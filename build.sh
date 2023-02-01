#!/usr/bin/env bash

curl -o npm.json "https://replicate.npmjs.com/_all_docs?include_docs=true"
du . -h