#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   MYSQL_USER=root MYSQL_PWD=yourpass MYSQL_HOST=localhost ./check_task_4.sh alx_book_store
#   # If MYSQL_PWD not set, you'll be prompted.

DB_NAME="${1:-alx_book_store}"
SQL_FILE="task_4.sql"

info()  { printf "• %s\n" "$*"; }
pass()  { printf "✅ %s\n" "$*"; }
fail()  { printf "❌ %s\n" "$*"; exit 1; }

# 1) FILE EXISTS
info "Checking if ${SQL_FILE} exists…"
[[ -f "$SQL_FILE" ]] || fail "${SQL_FILE} not found."
pass "File exists."

# 2) FILE NOT EMPTY
info "Checking if ${SQL_FILE} is not empty…"
[[ -s "$SQL_FILE" ]] || fail "${SQL_FILE} is empty."
pass "File is not empty."

# 3) NO ANALYZE KEYWORD
info "Checking script does not use ANALYZE…"
if grep -Eiq '\bANALYZE\b' "$SQL_FILE"; then
  fail "Found forbidden keyword: ANALYZE"
fi
pass "No ANALYZE found."

# Build mysql command (batch/TSV, no headers)
MYSQL_ARGS=()
[[ -n "${MYSQL_HOST:-}" ]] && MYSQL_ARGS+=(-h "${MYSQL_HOST}")
[[ -n "${MYSQL_USER:-}" ]] && MYSQL_ARGS+=(-u "${MYSQL_USER}")
if [[ -n "${MYSQL_PWD:-}" ]]; then
  MYSQL_ARGS+=(-p"${MYSQL_PWD}")
else
  # Prompt if password not given via env var
  MYSQL_ARGS+=(-p)
fi

MYSQL_CMD=(mysql "${MYSQL_ARGS[@]}" --batch --raw --skip-column-names "${DB_NAME}")

OUT_ACTUAL="$(mktemp)"
OUT_EXPECTED="$(mktemp)"

cleanup() { rm -f "$OUT_ACTUAL" "$OUT_EXPECTED"; }
trap cleanup EXIT

# 4) RUN STUDENT SCRIPT AND CAPTURE OUTPUT
info "Running ${SQL_FILE} against database '${DB_NAME}'…"
# Using batch+no headers ensures tab-separated rows for comparison.
"${MYSQL_CMD[@]}" < "$SQL_FILE" > "$OUT_ACTUAL" || fail "Failed to execute ${SQL_FILE}"

# Ensure output present
if ! [[ -s "$OUT_ACTUAL" ]]; then
  fail "No output produced by ${SQL_FILE} (does the table 'books' exist and are you selecting its columns?)."
fi

# Basic shape check: each row should have 6 tab-separated fields (Field, Type, Null, Key, Default, Extra)
info "Verifying output has 6 columns per row…"
awk -F'\t' 'NF!=6 { bad=1 } END { exit bad }' "$OUT_ACTUAL" || fail "Output rows are not 6-column descriptions."
pass "Output shape is correct (6 columns)."

# 5) REFERENCE DESCRIPTION FROM INFORMATION_SCHEMA (EXPECTED)
info "Building expected description from INFORMATION_SCHEMA…"
"${MYSQL_CMD[@]}" -e "
SELECT
  COLUMN_NAME,
  COLUMN_TYPE,
  CASE WHEN IS_NULLABLE='YES' THEN 'YES' ELSE 'NO' END,
  COLUMN_KEY,
  COLUMN_DEFAULT,
  EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'books'
ORDER BY ORDINAL_POSITION;
" > "$OUT_EXPECTED" || fail "Failed to read INFORMATION_SCHEMA for 'books'."

# Ensure table exists in DB for a fair comparison
if ! [[ -s "$OUT_EXPECTED" ]]; then
  fail "No columns found for 'books' in ${DB_NAME}. (Is the table created?)"
fi

# 6) COMPARE ACTUAL VS EXPECTED
info "Comparing your output to expected description…"
if ! diff -u "$OUT_EXPECTED" "$OUT_ACTUAL" >/dev/null; then
  echo "---- diff (expected vs your output) ----"
  diff -u "$OUT_EXPECTED" "$OUT_ACTUAL" || true
  fail "Description does not match expected schema."
fi

pass "Description matches INFORMATION_SCHEMA for 'books'. All checks passed! 🎉"
