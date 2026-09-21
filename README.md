# <img src="./static/branding/logos/trickster-logo.svg" width=54 />  trickstercache.org

This repository contains the documentation site for Trickster, available at <https://trickstercache.org>.

## Making a contribution

To make a contribution to the documentation, [file an issue](https://github.com/trickstercache/trickstercache.org/issues/new/choose) or fork the project and submit a [Pull Request](https://github.com/trickstercache/trickstercache.org/pulls). For specific instructions see [About Forks](https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/about-forks) and [Creating a Pull Request](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) in the GitHub documentation.

Note that the actual documentation content is [synced](scripts/sync-docs.sh) from the [main Trickster repo's 'docs' directory](https://github.com/trickstercache/trickster/tree/main/docs). So if you want to fix something in the actual documentation, contribute that to the main repo. Contributions to this repo should be about the actual Docs site (CSS/styling/layout, deployment automation, etc.) rather than its content.

## Releases and deployment

The site is published to Netlify by the
[Deploy to Netlify](.github/workflows/deploy.yml) GitHub Actions workflow whenever a
semantic version tag (`vX.Y.Z`, optionally with a pre-release suffix such as
`v2.1.0-beta1`) is pushed to this repository. Tag this repo with the same version as
the Trickster release being documented:

```
git tag v2.1.0
git push origin v2.1.0
```

The workflow then:

1. checks out that tag of this repository;
2. runs `scripts/sync-docs.sh v2.1.0`, which syncs the docs from the **same tag** of the
   [trickster repo](https://github.com/trickstercache/trickster), so the published site
   always matches that release's documentation, and records the version in
   `data/trickster.toml`;
3. builds the site with Hugo, rendering the version next to the logo in the site header
   so readers can tell which documentation version they are looking at; and
4. publishes the result to Netlify's production site.

An already-tagged version can be re-deployed with the workflow's **Run workflow**
button in the GitHub Actions tab.

### One-time setup

- Add two repository secrets under GitHub **Settings → Secrets and variables → Actions**:
  - `NETLIFY_AUTH_TOKEN`: a Netlify personal access token, created from your avatar menu
    under **User settings → Applications → Personal access tokens → New access token**.
    The token is shown only once and must have an expiration, so rotate this secret
    before it expires.
  - `NETLIFY_SITE_ID`: the **Project ID** from the Netlify project's
    **Project configuration → General → Project details → Project information**.
    Netlify renamed sites to projects, but this is the same value the CLI and API call
    the site ID.
- `netlify.toml` tells Netlify to skip its own git-triggered production builds (its
  `ignore` command exits 0 when Netlify's `CONTEXT` is `production`), so pushes to
  `main` no longer publish anything while deploy previews for pull requests keep
  working. After the first tag deploy, confirm in the Netlify deploy log that a push
  to `main` shows as skipped rather than published. If the repository is
  ever unlinked from Netlify entirely, pull request previews stop but the tag workflow
  still deploys.

### Previewing a specific version locally

```
make sync-docs VERSION=v2.1.0
make serve
```

`make sync-docs` without `VERSION` syncs from `main` and the site shows no version
label.

## Finding files to edit

The Trickster documentation site uses Hugo with the Docsy theme. For more detailed information on the site infrastructure, see the [Hugo](https://gohugo.io/documentation/) and [Docsy](https://www.docsy.dev/docs/) documentation.

### Editing styles

To override styles, edit the SCSS files in the [assets/scss](https://github.com/trickstercache/trickstercache.org/tree/main/assets/scss) directory. Use these two files as follows:

- `_styles_project.scss`: edit this file to override Docsy styles or change the current styles.
- `_variables_project.scss`: declare SCSS variables in this file that you can use elsewhere.

## Using the documentation site locally 

### Prerequisite

To build and run the site locally, you must have a recent `extended` version of [Hugo](https://gohugo.io).
For more information on configuring your environment, see the Docsy
[Getting started](https://www.docsy.dev/docs/getting-started/#prerequisites-and-installation) guide. If you don't want to run the site locally, you can check the preview when you submit your PR.

### Running the website locally

1. At the command line, within the Trickster documentation root directory, run the following command:

   ```
   hugo serve
   ```

1. Open your web browser and type `http://localhost:1313` in your navigation bar,
   This opens a local instance of the docsy-example homepage. You can now make
   changes to the docsy example and those changes will immediately show up in your
   browser after you save.


#### Troubleshooting

In you experience the following error, you need the extended version of Hugo:

```
➜ hugo server

INFO 2021/01/21 21:07:55 Using config file: 
Building sites … INFO 2021/01/21 21:07:55 syncing static files to /
Built in 288 ms
Error: Error building site: TOCSS: failed to transform "scss/main.scss" (text/x-scss): resource "scss/scss/main.scss_9fadf33d895a46083cdd64396b57ef68" not found in file cache
```

See the Docsy [user guide](https://www.docsy.dev/docs/getting-started/) for details on how to install Hugo.

## License

© Trickster Authors 2021 | Documentation Distributed under CC-BY-4.0

© 2021 The Linux Foundation. All rights reserved. The Linux Foundation has registered trademarks and uses trademarks. For a list of trademarks of The Linux Foundation, please see our [Trademark Usage page](https://www.linuxfoundation.org/trademark-usage).
