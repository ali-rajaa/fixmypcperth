#!/usr/bin/env bash
# Run after launch: checks every old address redirects (301) to the right
# page, and that every target page itself loads (200). Prints only problems,
# then a summary. Usage: bash _launch/test-redirects.sh
# Fragments (#battery) are not sent to the server, so targets are compared
# without them; the fragment is checked in the Location header instead.
set -u
BASE="${BASE:-https://www.fixmypcperth.com}"   # override to test elsewhere
fail=0; n=0
check() {
  local src="$1" want="$2"; n=$((n+1))
  local out code loc
  out=$(curl -s -o /dev/null -w "%{http_code} %{redirect_url}" --max-time 20 "$BASE$src")
  code=${out%% *}; loc=${out#* }
  if [ "$code" != "301" ] || [ "$loc" != "$BASE$want" ]; then
    echo "FAIL $src -> got $code $loc (want 301 $BASE$want)"; fail=$((fail+1)); return
  fi
  local tcode; tcode=$(curl -s -o /dev/null -w "%{http_code}" --max-time 20 "$BASE${want%%#*}")
  if [ "$tcode" != "200" ]; then echo "FAIL target $want returned $tcode"; fail=$((fail+1)); fi
}
check "/blog" "/tech-tips"
check "/blog.html" "/tech-tips"
check "/blog/data-recovery-perth-guide" "/data-recovery-perth"
check "/blog/data-recovery-perth-guide.html" "/data-recovery-perth"
check "/blog/how-much-does-pc-repair-cost-perth" "/tech-tips/how-much-does-pc-repair-cost-perth"
check "/blog/how-much-does-pc-repair-cost-perth.html" "/tech-tips/how-much-does-pc-repair-cost-perth"
check "/blog/how-to-fix-a-slow-computer" "/tech-tips/why-is-my-pc-so-slow"
check "/blog/how-to-fix-a-slow-computer.html" "/tech-tips/why-is-my-pc-so-slow"
check "/blog/how-to-tell-if-pc-has-virus" "/tech-tips/how-to-tell-if-pc-has-virus"
check "/blog/how-to-tell-if-pc-has-virus.html" "/tech-tips/how-to-tell-if-pc-has-virus"
check "/blog/laptop-screen-replacement-physical-repairs" "/tech-tips/laptop-screen-replacement-physical-repairs"
check "/blog/laptop-screen-replacement-physical-repairs.html" "/tech-tips/laptop-screen-replacement-physical-repairs"
check "/blog/signs-hard-drive-failing" "/tech-tips/signs-hard-drive-failing"
check "/blog/signs-hard-drive-failing.html" "/tech-tips/signs-hard-drive-failing"
check "/blog/ssd-upgrade-perth-guide" "/tech-tips/ssd-upgrade-perth-guide"
check "/blog/ssd-upgrade-perth-guide.html" "/tech-tips/ssd-upgrade-perth-guide"
check "/blog/why-is-my-pc-so-slow" "/tech-tips/why-is-my-pc-so-slow"
check "/blog/why-is-my-pc-so-slow.html" "/tech-tips/why-is-my-pc-so-slow"
check "/business-it-support.html" "/business-it-support"
check "/computer-backup-setup-perth" "/data-recovery-perth#backup"
check "/computer-backup-setup-perth.html" "/data-recovery-perth#backup"
check "/computer-repair-armadale" "/suburbs/armadale"
check "/computer-repair-atwell" "/suburbs/cockburn"
check "/computer-repair-canning-vale" "/suburbs/canning-vale"
check "/computer-repair-cockburn" "/suburbs/cockburn"
check "/computer-repair-gosnells" "/suburbs/gosnells"
check "/computer-repair-harrisdale" "/suburbs/harrisdale"
check "/computer-repair-jandakot" "/suburbs/jandakot"
check "/computer-repair-thornlie" "/suburbs/thornlie"
check "/computer-repair-willetton" "/suburbs/willetton"
check "/computer-wont-turn-on-perth.html" "/computer-wont-turn-on-perth"
check "/data-recovery-perth.html" "/data-recovery-perth"
check "/gaming-pc-build-perth.html" "/gaming-pc-build-perth"
check "/index.html" "/"
check "/industries/it-support-accountants-perth" "/it-support-accountants-perth"
check "/industries/it-support-allied-health-perth" "/it-support-allied-health-perth"
check "/industries/it-support-childcare-perth" "/it-support-childcare-perth"
check "/industries/it-support-legal-perth" "/it-support-legal-perth"
check "/industries/it-support-retail-perth" "/it-support-retail-perth"
check "/industries/it-support-trades-perth" "/it-support-trades-perth"
check "/it-support-accountants-perth.html" "/it-support-accountants-perth"
check "/it-support-allied-health-perth.html" "/it-support-allied-health-perth"
check "/it-support-childcare-perth.html" "/it-support-childcare-perth"
check "/it-support-hospitality-perth.html" "/it-support-hospitality-perth"
check "/it-support-legal-perth.html" "/it-support-legal-perth"
check "/it-support-real-estate-perth.html" "/it-support-real-estate-perth"
check "/it-support-retail-perth.html" "/it-support-retail-perth"
check "/it-support-trades-perth.html" "/it-support-trades-perth"
check "/laptop-battery-replacement-perth" "/laptop-repair-perth#battery"
check "/laptop-battery-replacement-perth.html" "/laptop-repair-perth#battery"
check "/laptop-repair-perth.html" "/laptop-repair-perth"
check "/pricing.html" "/pricing"
check "/quiz" "/pc-health-check-perth"
check "/quiz.html" "/pc-health-check-perth"
check "/quote-request.html" "/quote-request"
check "/reviews.html" "/reviews"
check "/slow-computer-repair-perth.html" "/slow-computer-repair-perth"
check "/ssd-upgrade-perth" "/computer-upgrades-perth"
check "/ssd-upgrade-perth.html" "/computer-upgrades-perth"
check "/suburbs/canning-vale.html" "/suburbs/canning-vale"
check "/suburbs/cannington.html" "/suburbs/cannington"
check "/suburbs/cockburn.html" "/suburbs/cockburn"
check "/suburbs/harrisdale.html" "/suburbs/harrisdale"
check "/suburbs/huntingdale.html" "/suburbs/huntingdale"
check "/suburbs/jandakot.html" "/suburbs/jandakot"
check "/suburbs/thornlie.html" "/suburbs/thornlie"
check "/suburbs/willetton.html" "/suburbs/willetton"
check "/terms.html" "/terms"
check "/virus-removal-perth.html" "/virus-removal-perth"
check "/windows-11-upgrade-perth" "/windows-reinstall-perth"
check "/windows-11-upgrade-perth.html" "/windows-reinstall-perth"
check "/windows-reinstall-perth.html" "/windows-reinstall-perth"
echo "$n redirects checked, $fail problems"
[ "$fail" -eq 0 ]
