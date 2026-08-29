#!/usr/bin/env bash
#
# sync-docs.sh
#
# Syncs the Trickster documentation from the main trickster repo into this
# Hugo/Docsy site. It shallow-clones the trickster repo into a temp directory,
# transforms docs/*.md into Docsy-ready pages (front matter, section layout,
# rewritten links), copies doc images into static/, and removes the temp
# checkout when finished.
#
# The entire content/en/docs tree is owned by this script and is regenerated
# on every run, EXCEPT for the site-authored files listed in KEEP_FILES.
#
# Usage:
#   ./scripts/sync-docs.sh
#
# Environment overrides:
#   TRICKSTER_REPO  git URL of the trickster repo (default: upstream GitHub)
#   TRICKSTER_REF   branch or tag to sync from (default: main)

set -euo pipefail

REPO_URL="${TRICKSTER_REPO:-https://github.com/trickstercache/trickster.git}"
REF="${TRICKSTER_REF:-main}"
GH_BLOB="https://github.com/trickstercache/trickster/blob/${REF}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS_DST="${ROOT}/content/en/docs"
IMG_DST="${ROOT}/static/images/docs"

# Site-authored pages under content/en/docs that are not sourced from the
# trickster repo and must survive a sync.
KEEP_FILES="quickstart.md"

# Source files/dirs to skip entirely (shell glob patterns, matched against
# the path relative to the trickster repo's docs/ directory). Skipped files
# are not synced and do not trigger 'Other' section warnings.
SKIP_PATTERNS="
roadmap.md
developer/*
"

is_skipped() {
  local p
  for p in ${SKIP_PATTERNS}; do
    # shellcheck disable=SC2254
    case "$1" in ${p}) return 0 ;; esac
  done
  return 1
}

# ---------------------------------------------------------------------------
# Section definitions: slug|Title|weight|description
# ---------------------------------------------------------------------------
SECTIONS="
getting-started|Getting Started|10|How to get up and running with Trickster.
backends|Backends|20|Configuring the upstream origins that Trickster accelerates.
caching|Caching|30|Cache data stores and behaviors common to all of Trickster's caching modes.
object-caching|Object Caching|40|Accelerating generic HTTP objects with Trickster's Reverse Proxy Cache.
time-series-caching|Time Series Caching|50|Accelerating time series databases with Trickster's Delta Proxy Cache.
time-series-caching/providers|Providers|100|Guides for each supported time series provider.
routing|Routing & Load Balancing|60|Directing requests across multiple backends with the ALB, autodiscovery and Rule engine.
request-handling|Request Handling|70|Customizing how Trickster processes HTTP requests and responses.
observability|Observability|80|Metrics, logs, distributed tracing, and debugging Trickster's behavior.
"

# ---------------------------------------------------------------------------
# Page manifest: source-file|section|optional short linkTitle
# Order within a section determines sidebar order.
# Files present in the source repo but missing from this manifest are synced
# into an "Other" section and a warning is printed, so nothing silently drops.
# ---------------------------------------------------------------------------
MANIFEST="
placement.md|getting-started|
configuring.md|getting-started|
new-changed-2.0.md|getting-started|What's New in 2.0
multi-origin.md|backends|Multiple Backends
authenticator.md|backends|
tls.md|backends|
health.md|backends|
caches.md|caching|
retention.md|caching|Retention Policies
chunked_caching.md|caching|
negative-caching.md|caching|
range_request.md|object-caching|Byte Range Requests
collapsed-forwarding.md|object-caching|
supported-backend-providers.md|time-series-caching|Supported Providers
per-query-instructions.md|time-series-caching|
query-range-limits.md|time-series-caching|
timeseries_sharding.md|time-series-caching|Request Sharding
flight-sql.md|time-series-caching|Flight SQL Listeners
prometheus.md|time-series-caching/providers|Prometheus
influxdb.md|time-series-caching/providers|InfluxDB
clickhouse.md|time-series-caching/providers|ClickHouse
graphite.md|time-series-caching/providers|Graphite
mysql.md|time-series-caching/providers|MySQL
alb.md|routing|Application Load Balancer
alb-autodiscovery.md|routing|ALB Autodiscovery
rule.md|routing|Rule Backend
paths.md|request-handling|Paths
request_rewriters.md|request-handling|
body.md|request-handling|Request Body Handling
cors.md|request-handling|CORS
simulated-latency.md|request-handling|
metrics.md|observability|Metrics
tracing.md|observability|Tracing
access-logs.md|observability|Access & Error Logs
trickster-result.md|observability|X-Trickster-Result Header
"

# Renamed/removed source files still referenced by links: old-name|new-name
LINK_ALIASES="
supported-origin-types.md|supported-backend-providers.md
"

# ---------------------------------------------------------------------------

manifest_lines() { echo "$MANIFEST" | grep -v '^[[:space:]]*$'; }
section_lines() { echo "$SECTIONS" | grep -v '^[[:space:]]*$'; }

# section_for <file> -> section slug (empty if unmapped)
section_for() {
  manifest_lines | awk -F'|' -v f="$1" '$1==f{print $2; exit}'
}

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

echo ">> Cloning ${REPO_URL} (${REF}) ..."
git clone --quiet --depth 1 --branch "${REF}" "${REPO_URL}" "${TMP}/trickster"
SRC="${TMP}/trickster/docs"

if [ ! -d "${SRC}" ]; then
  echo "ERROR: ${SRC} not found in cloned repo" >&2
  exit 1
fi

STAGE="${TMP}/stage"
mkdir -p "${STAGE}"

# ---------------------------------------------------------------------------
# Detect source files missing from the manifest and append them to "Other"
# ---------------------------------------------------------------------------
UNMAPPED=""
while IFS= read -r f; do
  rel="${f#"${SRC}"/}"
  is_skipped "${rel}" && continue
  if [ -z "$(section_for "${rel}")" ]; then
    UNMAPPED="${UNMAPPED}${rel}
"
    echo "WARNING: ${rel} is not in the sync manifest; placing it in the 'Other' section." >&2
  fi
done < <(find "${SRC}" -maxdepth 2 -name '*.md' -not -path '*/images/*' | sort)

if [ -n "${UNMAPPED}" ]; then
  SECTIONS="${SECTIONS}other|Other|999|Uncategorized documentation. Add these pages to scripts/sync-docs.sh's manifest.
"
  while IFS= read -r f; do
    [ -n "${f}" ] && MANIFEST="${MANIFEST}${f}|other|
"
  done <<< "${UNMAPPED}"
fi

# ---------------------------------------------------------------------------
# Build the sed script that rewrites intra-doc links.
# Every known doc file gets its final absolute URL, so links work regardless
# of which section the linking and linked pages land in.
# ---------------------------------------------------------------------------
SEDF="${TMP}/links.sed"
: > "${SEDF}"

emit_link_rules() {
  local file="$1" target="$2" section base esc
  section="$(section_for "${target}")"
  base="$(basename "${target}" .md)"
  esc="$(printf '%s' "${file%.md}" | sed 's/[].[^$*\/&]/\\&/g')"
  # ](./file.md#anchor) | ](file.md#anchor) | ](/docs/file.md#anchor)
  printf 's|](\\(\\./\\)\\{0,1\\}\\(/docs/\\)\\{0,1\\}%s\\.md\\(#[^)]*\\)\\{0,1\\})|](/docs/%s/%s/\\3)|g\n' \
    "${esc}" "${section}" "${base}" >> "${SEDF}"
  # ](./file#anchor)  (extension-less variant seen in the wild)
  printf 's|](\\./%s\\(#[^)]*\\))|](/docs/%s/%s/\\1)|g\n' \
    "${esc}" "${section}" "${base}" >> "${SEDF}"
}

while IFS='|' read -r file section short; do
  [ -z "${file}" ] && continue
  emit_link_rules "${file}" "${file}"
  # pages in subdirectories may also be linked by bare filename from siblings
  if [ "${file}" != "$(basename "${file}")" ]; then
    emit_link_rules "$(basename "${file}")" "${file}"
  fi
done < <(manifest_lines)

while IFS='|' read -r old new; do
  [ -z "${old}" ] && continue
  emit_link_rules "${old}" "${new}"
done < <(echo "$LINK_ALIASES" | grep -v '^[[:space:]]*$')

# Image references -> /images/docs/ (copied into static/)
cat >> "${SEDF}" <<'EOF'
s|src="\./images/|src="/images/docs/|g
s|src="images/|src="/images/docs/|g
s|](\./images/|](/images/docs/|g
s|](images/|](/images/docs/|g
EOF

# Any remaining relative links point at files in the trickster repo itself
# (../examples/..., ./developer/..., etc.) -> GitHub URLs. The bare
# developer/ form covers links to that skipped subdirectory.
cat >> "${SEDF}" <<EOF
s|](\\.\\./|](${GH_BLOB}/|g
s|](\\./|](${GH_BLOB}/docs/|g
s|](developer/|](${GH_BLOB}/docs/developer/|g
EOF

# ---------------------------------------------------------------------------
# Generate section _index.md files
# ---------------------------------------------------------------------------
while IFS='|' read -r slug title weight desc; do
  [ -z "${slug}" ] && continue
  mkdir -p "${STAGE}/${slug}"
  cat > "${STAGE}/${slug}/_index.md" <<EOF
---
title: "${title}"
linkTitle: "${title}"
weight: ${weight}
description: >
  ${desc}
---
EOF
done < <(section_lines)

# Top-level docs landing page
cat > "${STAGE}/_index.md" <<'EOF'
---
title: "Documentation"
linkTitle: "Documentation"
weight: 20
menu:
  main:
    weight: 20
---

Explore how to use Trickster to accelerate your projects. If you're new to
Trickster, check out [Where to Place Trickster](/docs/getting-started/placement/)
and the [Quickstart](/docs/quickstart/).
EOF

# ---------------------------------------------------------------------------
# Transform each page: front matter from the H1, then link rewrites
# ---------------------------------------------------------------------------
declare -i count=0
weight=0
prev_section=""

while IFS='|' read -r file section short; do
  [ -z "${file}" ] && continue
  src_file="${SRC}/${file}"
  if [ ! -f "${src_file}" ]; then
    echo "WARNING: ${file} is in the manifest but not in the source repo; skipping." >&2
    continue
  fi

  if [ "${section}" != "${prev_section}" ]; then
    weight=0
    prev_section="${section}"
  fi
  weight=$((weight + 10))

  title="$(awk '/^# /{sub(/^# /,""); print; exit}' "${src_file}")"
  if [ -z "${title}" ]; then
    title="$(basename "${file}" .md)"
  fi
  link_title="${short:-${title}}"

  out="${STAGE}/${section}/$(basename "${file}")"
  {
    printf -- '---\ntitle: "%s"\nlinkTitle: "%s"\nweight: %d\n---\n\n' \
      "${title//\"/\\\"}" "${link_title//\"/\\\"}" "${weight}"
    # drop the H1 (Docsy renders the title) and any blank lines right after it
    awk 'BEGIN{skip=1} skip&&/^# /{skip=2;next} skip==2&&/^[[:space:]]*$/{next} {skip=0;print}' \
      "${src_file}" | sed -f "${SEDF}"
  } > "${out}"
  count+=1
done < <(manifest_lines)

# ---------------------------------------------------------------------------
# Stage images, then rsync everything into place
# ---------------------------------------------------------------------------
mkdir -p "${IMG_DST}"
rsync -a --delete "${SRC}/images/" "${IMG_DST}/"

RSYNC_EXCLUDES=()
for k in ${KEEP_FILES}; do
  RSYNC_EXCLUDES+=(--exclude "${k}")
done
mkdir -p "${DOCS_DST}"
rsync -a --delete "${RSYNC_EXCLUDES[@]}" "${STAGE}/" "${DOCS_DST}/"

echo ">> Synced ${count} pages from ${REPO_URL}@${REF}"
echo ">>   docs   -> ${DOCS_DST#"${ROOT}"/}"
echo ">>   images -> ${IMG_DST#"${ROOT}"/}"
