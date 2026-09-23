# Hugo finds Dart Sass (the sass-embedded npm package) via PATH.
export PATH := $(CURDIR)/node_modules/.bin:$(PATH)

node_modules: package.json package-lock.json
	npm ci
	@touch node_modules

deps: node_modules

# Sync docs from the trickster repo. Pass VERSION=vX.Y.Z to sync from that
# release tag and show the version in the site header; without it, docs are
# synced from main (override with TRICKSTER_REPO/TRICKSTER_REF) with no label.
sync-docs:
	./scripts/sync-docs.sh $(VERSION)

serve: deps
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender

production-build: deps
	hugo \
		--minify

preview-build: deps
	hugo \
		--baseURL $(DEPLOY_PRIME_URL) \
		--buildDrafts \
		--buildFuture \
		--minify

open:
	open https://trickstercache.org

.PHONY: deps sync-docs serve production-build preview-build open
