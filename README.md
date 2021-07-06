# Trickster documentation

This repository contains the [documentation site](https://trickstercache.org/) for Trickster.

## Making a contribution

To make a contribution to the documentation, [file an issue](https://github.com/trickstercache/trickstercache.org/issues/new/choose) or fork the project and submit a [Pull Request](https://github.com/trickstercache/trickstercache.org/pulls). For specific instructions see (About Forks)[https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/about-forks] and [Creating a Pull Request](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) in the GitHub documentation.

## Finding files to edit

The Trickster documentation site uses Hugo with the Docsy theme. The following instructions specify where to find frequently edited files. 

For more detailed information on the site infrastructure, see the [Hugo](https://gohugo.io/documentation/) and [Docsy](https://www.docsy.dev/docs/) documentation.

### Editing styles

To override styles, edit the SCSS files in the [assets/scss](https://github.com/trickstercache/trickstercache.org/tree/main/assets/scss) directory. Use these two files as follows:

- `_styles_project.scss`: edit this file to override Docsy styles or change the current styles.
- `_variables_project.scss`: declare SCSS variables in this file that you can use elsewhere.

### Editing documentation content

To edit Trickster documentation content, edit the markdown files in [content/en/docs](https://github.com/trickstercache/trickstercache.org/tree/main/content/en/docs). For guidance on how to write in markdown, see GitHub Guides [Mastering Markdown](https://guides.github.com/features/mastering-markdown/).

### Editing other parts of the site

To edit other areas of the Trickster website, see the following directories:

About: [https://github.com/trickstercache/trickstercache.org/tree/main/content/en/about](https://github.com/trickstercache/trickstercache.org/tree/main/content/en/about)
Blog: [https://github.com/trickstercache/trickstercache.org/tree/main/content/en/blog](https://github.com/trickstercache/trickstercache.org/tree/main/content/en/blog)
Community: [https://github.com/trickstercache/trickstercache.org/tree/main/content/en/community](https://github.com/trickstercache/trickstercache.org/tree/main/content/en/community)


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