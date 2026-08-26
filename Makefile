yarn:
	yarn

# Sync docs from the main trickster repo (override with TRICKSTER_REPO/TRICKSTER_REF)
sync-docs:
	./scripts/sync-docs.sh

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