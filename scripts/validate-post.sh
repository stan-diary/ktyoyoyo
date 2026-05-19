#!/usr/bin/env bash
# validate-post.sh — Validates a blog post against 6 correctness properties
# Usage: ./scripts/validate-post.sh [path-to-post]
# Defaults to content/posts/elephant-gym-band-introduction.md

set -euo pipefail

FILE="${1:-content/posts/elephant-gym-band-introduction.md}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE"
  exit 1
fi

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  echo "PASS: $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  echo "FAIL: $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

# ---------------------------------------------------------------------------
# Property 1: Kebab-case identifier format
# Filename and slug contain only lowercase letters, digits, hyphens;
# no leading/trailing/consecutive hyphens.
# ---------------------------------------------------------------------------
check_kebab_case() {
  local value="$1"
  local label="$2"

  # Must contain only lowercase letters, digits, hyphens
  if [[ ! "$value" =~ ^[a-z0-9-]+$ ]]; then
    fail "Property 1 — $label '$value' contains invalid characters (must be lowercase letters, digits, hyphens only)"
    return 1
  fi
  # No leading hyphen
  if [[ "$value" == -* ]]; then
    fail "Property 1 — $label '$value' has a leading hyphen"
    return 1
  fi
  # No trailing hyphen
  if [[ "$value" == *- ]]; then
    fail "Property 1 — $label '$value' has a trailing hyphen"
    return 1
  fi
  # No consecutive hyphens
  if [[ "$value" == *--* ]]; then
    fail "Property 1 — $label '$value' has consecutive hyphens"
    return 1
  fi
  return 0
}

# Extract filename without extension
BASENAME=$(basename "$FILE" .md)

# Extract slug from front matter
SLUG=$(grep -m1 '^slug:' "$FILE" | sed 's/^slug:[[:space:]]*//' | tr -d '"' | tr -d "'")

P1_OK=true
check_kebab_case "$BASENAME" "filename" || P1_OK=false
check_kebab_case "$SLUG" "slug" || P1_OK=false

if [[ "$P1_OK" == "true" ]]; then
  pass "Property 1 — Kebab-case identifier format (filename='$BASENAME', slug='$SLUG')"
fi

# ---------------------------------------------------------------------------
# Property 2: Front matter delimiter structure
# File starts with `---` on line 1 and has a closing `---` before body.
# ---------------------------------------------------------------------------
FIRST_LINE=$(head -n1 "$FILE")

if [[ "$FIRST_LINE" != "---" ]]; then
  fail "Property 2 — File does not start with '---' on line 1 (got: '$FIRST_LINE')"
else
  # Find the closing delimiter (second occurrence of --- starting from line 2)
  CLOSING_LINE=$(tail -n +2 "$FILE" | awk '/^---$/{print NR; exit}')
  if [[ -z "$CLOSING_LINE" ]]; then
    fail "Property 2 — No closing '---' delimiter found for front matter"
  else
    pass "Property 2 — Front matter delimiter structure (opens line 1, closes line $((CLOSING_LINE + 1)))"
  fi
fi

# ---------------------------------------------------------------------------
# Property 3: Date field ISO 8601 compliance
# date matches YYYY-MM-DDTHH:MM:SS+08:00 with valid values.
# ---------------------------------------------------------------------------
DATE_VALUE=$(grep -m1 '^date:' "$FILE" | sed 's/^date:[[:space:]]*//' | tr -d '"' | tr -d "'")

if [[ "$DATE_VALUE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\+08:00$ ]]; then
  # Extract components for validity check
  YEAR=$(echo "$DATE_VALUE" | cut -c1-4)
  MONTH=$(echo "$DATE_VALUE" | cut -c6-7)
  DAY=$(echo "$DATE_VALUE" | cut -c9-10)
  HOUR=$(echo "$DATE_VALUE" | cut -c12-13)
  MINUTE=$(echo "$DATE_VALUE" | cut -c15-16)
  SECOND=$(echo "$DATE_VALUE" | cut -c18-19)

  VALID=true
  # Month 01-12
  if [[ "$MONTH" -lt 1 || "$MONTH" -gt 12 ]]; then
    VALID=false
  fi
  # Day 01-31
  if [[ "$DAY" -lt 1 || "$DAY" -gt 31 ]]; then
    VALID=false
  fi
  # Hour 00-23
  if [[ "$HOUR" -gt 23 ]]; then
    VALID=false
  fi
  # Minute 00-59
  if [[ "$MINUTE" -gt 59 ]]; then
    VALID=false
  fi
  # Second 00-59
  if [[ "$SECOND" -gt 59 ]]; then
    VALID=false
  fi

  if [[ "$VALID" == "true" ]]; then
    pass "Property 3 — ISO 8601 date compliance (date='$DATE_VALUE')"
  else
    fail "Property 3 — Date '$DATE_VALUE' has invalid component values"
  fi
else
  fail "Property 3 — Date '$DATE_VALUE' does not match YYYY-MM-DDTHH:MM:SS+08:00 pattern"
fi

# ---------------------------------------------------------------------------
# Property 4: Content section heading structure
# Body contains only ## headings (no #, ###, etc.) and at least 2 of them.
# ---------------------------------------------------------------------------

# Extract body content (everything after the closing front matter delimiter)
FRONT_MATTER_END=$((CLOSING_LINE + 1))
BODY=$(tail -n +"$((FRONT_MATTER_END + 1))" "$FILE")

# Check for any headings that are NOT level-2
BAD_HEADINGS=$(echo "$BODY" | grep -nE '^#{1,6} ' | grep -v '^[0-9]*:## ' || true)

if [[ -n "$BAD_HEADINGS" ]]; then
  fail "Property 4 — Body contains non-level-2 headings: $BAD_HEADINGS"
else
  # Count level-2 headings
  H2_COUNT=$(echo "$BODY" | grep -cE '^## ' || true)
  if [[ "$H2_COUNT" -lt 2 ]]; then
    fail "Property 4 — Body has fewer than 2 level-2 headings (found: $H2_COUNT)"
  else
    pass "Property 4 — Content heading structure ($H2_COUNT level-2 headings, no other heading levels)"
  fi
fi

# ---------------------------------------------------------------------------
# Property 5: Traditional Chinese as primary language
# CJK characters exceed 50% of non-whitespace characters in body paragraphs.
# ---------------------------------------------------------------------------

# Count CJK characters (Unicode range \u4e00-\u9fff, \u3400-\u4dbf, \uf900-\ufaff)
# We use perl for reliable Unicode handling
CJK_COUNT=$(echo "$BODY" | perl -CSD -ne '
  while (/[\x{4e00}-\x{9fff}\x{3400}-\x{4dbf}\x{f900}-\x{faff}]/g) { $count++ }
  END { print $count // 0 }
')

# Count total non-whitespace characters in body
TOTAL_NON_WS=$(echo "$BODY" | perl -CSD -ne '
  while (/\S/g) { $count++ }
  END { print $count // 0 }
')

if [[ "$TOTAL_NON_WS" -eq 0 ]]; then
  fail "Property 5 — Body has no non-whitespace characters"
else
  RATIO=$(echo "scale=4; $CJK_COUNT / $TOTAL_NON_WS * 100" | bc)
  RATIO_INT=$(echo "$RATIO" | cut -d. -f1)
  if [[ "$RATIO_INT" -gt 50 ]]; then
    pass "Property 5 — Traditional Chinese language ratio (CJK: $CJK_COUNT / $TOTAL_NON_WS non-ws chars = ${RATIO}%)"
  else
    fail "Property 5 — CJK ratio is ${RATIO}% (need >50%). CJK: $CJK_COUNT, total non-ws: $TOTAL_NON_WS"
  fi
fi

# ---------------------------------------------------------------------------
# Property 6: Word count within bounds
# CJK character count in body is between 300 and 600 inclusive.
# ---------------------------------------------------------------------------
if [[ "$CJK_COUNT" -ge 300 && "$CJK_COUNT" -le 600 ]]; then
  pass "Property 6 — Word count within bounds (CJK characters: $CJK_COUNT, range: 300–600)"
else
  fail "Property 6 — CJK character count is $CJK_COUNT (must be 300–600 inclusive)"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "========================================="
echo "Results: $PASS_COUNT passed, $FAIL_COUNT failed"
echo "========================================="

if [[ "$FAIL_COUNT" -gt 0 ]]; then
  exit 1
fi
