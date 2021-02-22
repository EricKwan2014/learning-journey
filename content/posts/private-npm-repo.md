---
author: "Eric Cheung"
title: "Publish a private npm repo using Lerna"
date: "2021-02-18"
description: "A sample article showcasing how to publish a private npm repo using Lerna"
tags: ["npm", "learn"]
showtoc: true
---

## Introducing Lerna

Lerna is a tool that optimizes the workflow around managing multi-package repositories with Git and npm.

### Blockquote

> Don't communicate by sharing memory, share memory by communicating.
>
> — Rob Pike [^1]

[^1]: The above quote is excerpted from Rob Pike's [talk](https://www.youtube.com/watch?v=PAAkCSZUG1c) during Gopherfest, November 18, 2015.

## Getting started

```sh
npm i -g lerna # or
yarn global add lerna

# To install dependencies for all packages
lerna bootstrap

# Remove the node_modules directory from all packages. https://github.com/lerna/lerna/#clean#
lerna clean

# Import the package in the local path <pathToRepo> into packages/<directory-name> with commit history
lerna import <pathToRepo>

# To run all the tests (if the corresponding script, "test" exists)
lerna run test
```

## Step to npm publish

- Update the `packages/working-lib` and commit your works
- Make sure your lib is working properly (consider using jest/other testing tools in your lib)
- Bump-up the version in `packages/working-lib/package.json` (I suggested using Semver for versioning) [Semver](https://semver.org/)
- Merge the latest changes into a release branch
- A working CI/CD workflow to trigger the following npm publish action
  - or you can simply `lerna changed && lerna version --yes && npm publish`

I suggest doing more with npm publish

```sh
#!/bin/bash -ex

for f in packages/*; do
  pushd $f;
    name=$(echo $f | awk -F'/' '{print $2}')
    packageName=$(cat package.json \
      | grep name \
      | head -1 \
      | awk -F: '{ print $2 }' \
      | sed 's/[",]//g' \
      | tr -d '[[:space:]]') || true
    sourceVersion=$(cat package.json \
      | grep version \
      | head -1 \
      | awk -F: '{ print $2 }' \
      | sed 's/[",]//g' \
      | tr -d '[[:space:]]') || true
    publishedVersion=$(npm view $packageName version) || true;

    # do a validation before publishing a package
    if [ "${publishedVersion}" != "${sourceVersion}" ]; then
      npm publish;
      # optional section and suggested to implement a notification
      # curl -X POST --data-urlencode "payload={\"text\": \"${packageName} \`${sourceVersion}\` published\"}" $SLACK_WEBHOOK_URL
    fi
  popd;
done
```
