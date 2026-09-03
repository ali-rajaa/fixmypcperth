#!/usr/bin/env bash
# Deploy FixMyPC Perth. Run from the repo root.
set -e
echo "1/4 building locally to catch errors before they reach production"
bundle install --quiet && bundle exec jekyll build
echo "2/4 build OK — committing"
git add -A
git commit -m "Jekyll conversion, price normalisation, local SEO, 11 new suburb pages"
echo "3/4 pushing"
git push origin main
echo "4/4 done. Now purge the Cloudflare cache, then add the redirect rules in CLOUDFLARE.md"
