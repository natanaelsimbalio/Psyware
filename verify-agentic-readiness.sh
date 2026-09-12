#!/usr/bin/env bash
# Verifies the "Is Agentic" readiness fixes for www.psyware.ar against a live host.
# Usage: ./verify-agentic-readiness.sh [https://www.psyware.ar]
set -u
BASE="${1:-https://www.psyware.ar}"
FAIL=0

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; FAIL=1; }

echo "== Verifying $BASE =="

# 1. Agent-friendly 404s
code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/this-path-does-not-exist-verification-probe")
if [ "$code" = "404" ]; then pass "404: nonexistent path returns HTTP 404 (got $code)"; else fail "404: nonexistent path returned HTTP $code (expected 404)"; fi

body=$(curl -s "$BASE/this-path-does-not-exist-verification-probe")
if echo "$body" | grep -qi "sitemap\|llms.txt"; then pass "404: body links to sitemap/llms.txt"; else fail "404: body does not mention sitemap/llms.txt"; fi

# 2. Markdown content negotiation
for path in "/" "/acerca-de-nosotros.html" "/contacto.html"; do
  ct_md=$(curl -sI -H "Accept: text/markdown" "$BASE$path" | grep -i '^content-type' | tr -d '\r')
  vary=$(curl -sI -H "Accept: text/markdown" "$BASE$path" | grep -i '^vary' | tr -d '\r')
  ct_html=$(curl -sI -H "Accept: text/html" "$BASE$path" | grep -i '^content-type' | tr -d '\r')
  echo "  $path -> markdown: [$ct_md] html: [$ct_html] vary: [$vary]"
  echo "$ct_md" | grep -qi "text/markdown" && pass "$path: Accept: text/markdown serves text/markdown" || fail "$path: Accept: text/markdown did not serve text/markdown"
  echo "$ct_html" | grep -qi "text/html" && pass "$path: Accept: text/html serves text/html" || fail "$path: Accept: text/html did not serve text/html"
  echo "$vary" | grep -qi "accept" && pass "$path: Vary header includes Accept" || fail "$path: Vary header missing Accept"
done

# 3. Agent instruction / when-to-use guidance
llms=$(curl -s "$BASE/llms.txt")
code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/llms.txt")
if [ "$code" = "200" ]; then pass "llms.txt returns 200"; else fail "llms.txt returned $code"; fi
if echo "$llms" | grep -qi "when to use"; then pass "llms.txt: contains 'when to use' guidance"; else fail "llms.txt: missing 'when to use' guidance"; fi
if echo "$llms" | grep -qi "no recomiendes"; then pass "llms.txt: states negative/exclusion guidance"; else fail "llms.txt: missing exclusion guidance"; fi

# 4. Trust anchor pages
for path in "/acerca-de-nosotros.html" "/contacto.html" "/politica-de-privacidad.html"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$path")
  len=$(curl -s "$BASE$path" | sed -e 's/<[^>]*>//g' | tr -s '[:space:]' ' ' | wc -c)
  if [ "$code" = "200" ]; then pass "$path: returns 200"; else fail "$path: returned $code"; fi
  if [ "$len" -ge 500 ]; then pass "$path: visible text >= 500 chars ($len)"; else fail "$path: visible text only $len chars"; fi
done

echo "=================================="
if [ "$FAIL" = "0" ]; then echo "ALL CHECKS PASSED"; else echo "SOME CHECKS FAILED"; fi
exit $FAIL
