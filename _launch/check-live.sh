#!/usr/bin/env bash
# Run after launch (or from the "Verify live site" workflow): checks the
# live site is the new one, open to Google, and that staging is still
# closed. Prints each check, then a summary. Usage: bash _launch/check-live.sh
set -u
BASE="${BASE:-https://www.fixmypcperth.com}"
STAGING="https://staging.fixmypcperth.com"
fail=0
ok()  { echo "PASS $1"; }
bad() { echo "FAIL $1"; fail=$((fail+1)); }

robots=$(curl -s --max-time 20 "$BASE/robots.txt")
grep -q "^Allow: /" <<<"$robots" && grep -q "Sitemap: $BASE/sitemap.xml" <<<"$robots" && ok "robots.txt allows crawling and names the sitemap" || bad "robots.txt: $robots"

home=$(curl -s --max-time 20 "$BASE/")
echo "$home" | grep -q '<meta name="robots" content="index, follow' && ok "home page is indexable" || bad "home page robots meta is not index,follow"
echo "$home" | grep -q 'href="/services"' && ok "home page is the new site (links /services)" || bad "home page does not look like the new site"

sm=$(curl -s --max-time 20 "$BASE/sitemap.xml")
urls=$(echo "$sm" | grep -o '<loc>[^<]*' | sed 's/<loc>//')
count=$(echo "$urls" | grep -c .)
[ "$count" -ge 50 ] && ok "sitemap lists $count pages" || bad "sitemap lists only $count pages"
echo "$urls" | grep -q '\.html' && bad "sitemap contains .html addresses" || ok "sitemap has clean addresses only"
nf=0
for u in $urls; do
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 20 "$u")
  if [ "$c" != "200" ]; then echo "  sitemap page $u returned $c"; nf=$((nf+1)); fi
done
[ "$nf" -eq 0 ] && ok "every sitemap page returns 200" || bad "$nf sitemap pages did not return 200"

c404=$(curl -s -o /tmp/nf.html -w "%{http_code}" --max-time 20 "$BASE/this-page-does-not-exist-check")
[ "$c404" = "404" ] && grep -q "That page has moved" /tmp/nf.html && ok "unknown address shows the branded 404" || bad "unknown address returned $c404 or the wrong page"

apex=$(curl -s -o /dev/null -w "%{http_code} %{redirect_url}" --max-time 20 "https://fixmypcperth.com/")
case "$apex" in 30[18]\ https://www.fixmypcperth.com/*) ok "fixmypcperth.com redirects to www";; *) bad "fixmypcperth.com gave: $apex";; esac

srob=$(curl -s --max-time 20 "$STAGING/robots.txt")
echo "$srob" | grep -q "^Disallow: /" && ok "staging is still blocked from Google" || echo "NOTE staging robots.txt: $srob"

echo "$fail problems"
[ "$fail" -eq 0 ]
