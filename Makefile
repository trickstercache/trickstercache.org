yarn:
	yarn

# Sync docs from the trickster repo. Pass VERSION=vX.Y.Z to sync from that
# release tag and show the version in the site header; without it, docs are
# synced from main (override with TRICKSTER_REPO/TRICKSTER_REF) with no label.
sync-docs:
	./scripts/sync-docs.sh $(VERSION)

serve: yarn
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender

production-build:
	hugo \
		--minify

preview-build:
	hugo \
		--baseURL $(DEPLOY_PRIME_URL) \
		--buildDrafts \
		--buildFuture \
		--minify

open:
	open https://cncf-hugo-starter.netlify.com