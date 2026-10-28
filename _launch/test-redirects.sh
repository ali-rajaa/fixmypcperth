#!/usr/bin/env bash
# Run after launch: checks every old address redirects (301) to the right
# page, and that every target page itself loads (200). Prints only problems,
# then a summary. Usage: bash _launch/test-redirects.sh
# Fragments (#battery) are not sent to the server, so targets are compared
# without them; the fragment is checked in the Location header instead.
set -u
BASE="${BASE:-https://www.fixmypcperth.com}"   # override to test elsewhere
fail=0; n=0
# One request, answer left in $fetched. No response at all (000: the host
# did not answer) is asked twice more, 5s then 10s apart, so a short host
# blip is not reported as a broken redirect. Any real answer (a wrong
# redirect, a 404) is final. A host that is really down is caught below:
# three addresses in a row with no answer stops the run.
fetched=""; down=0
fetch() {
  local try
  for try in 1 2 3; do
    fetched=$(curl -s -o /dev/null -w "%{http_code} %{redirect_url}" --max-time 20 "$1")
    [ "${fetched%% *}" != "000" ] && return
    [ "$try" -lt 3 ] || return
    echo "  note: $1 gave no response, trying again"; sleep $((try*5))
  done
}
check() {
  # Follows the whole chain (up to 4 hops). Passes when the first response
  # is a permanent redirect (301/308), the chain ends on the expected page
  # with a 200, and a #section target keeps its #section somewhere in the
  # chain. Two hops are fine: Cloudflare's existing ".html" rule strips the
  # extension first, then the bulk list sends it on.
  local src="$1" want="$2"; n=$((n+1))
  local url="$BASE$src" code loc hops=0 first="" frag_ok=1
  [ "${want#*#}" != "$want" ] && frag_ok=0
  while :; do
    local out; fetch "$url"; out=$fetched
    code=${out%% *}; loc=${out#* }
    [ -z "$first" ] && first=$code
    case "$code" in 301|302|307|308) ;; *) break;; esac
    hops=$((hops+1)); [ "$frag_ok" -eq 0 ] && [ "$loc" = "$BASE$want" ] && frag_ok=1
    url=${loc%%#*}; [ "$hops" -ge 4 ] && break
  done
  if [ "$first" = "000" ]; then
    echo "FAIL $src -> the host did not respond"; fail=$((fail+1)); down=$((down+1))
    # Three addresses in a row with no answer: the host is down, not a
    # redirect. Stop rather than wait out every address.
    if [ "$down" -ge 3 ]; then echo "The host stopped responding (3 addresses in a row). Stopped early: re-run once it is back."; exit 1; fi
    return; fi
  down=0
  if [ "$first" != "301" ] && [ "$first" != "308" ]; then
    echo "FAIL $src -> first response $first, not a permanent redirect"; fail=$((fail+1)); return; fi
  if [ "$url" != "$BASE${want%%#*}" ] || [ "$code" != "200" ]; then
    local note=""; [ "$code" = "000" ] && note=", the host did not respond"
    echo "FAIL $src -> ended at $url ($code$note), want $BASE$want"; fail=$((fail+1)); return; fi
  if [ "$frag_ok" -ne 1 ]; then echo "FAIL $src -> lost the #${want#*#} on the way"; fail=$((fail+1)); return; fi
  [ "$hops" -gt 1 ] && echo "note $src -> $want in $hops hops"
  return 0
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
check "/index" "/"
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
