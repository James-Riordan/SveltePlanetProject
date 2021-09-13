#!/bin/bash

yarn build
cd dist

git init
git remote add origin "https://github.com/James-Riordan/SveltePlanetProject"

git checkout -b github-pages
git add .
git commit -m "Updated Build"
git push --set-upstream origin github-pages --force