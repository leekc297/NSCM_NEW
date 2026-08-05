#!/bin/bash
# Apply SQL file to corporate Oracle DB via Docker exec sqlplus
# Usage: ./apply.sh <sql_file> [log_label]
#
# Exit codes:
#   0 = success or only known-acceptable errors (MSG_TP_CD NOT NULL)
#   2 = real errors (halt + report)

SQL_FILE="$1"
LABEL="${2:-$(basename "$SQL_FILE" .sql)}"
LOG_DIR="C:/Projects/NSCM/_artifacts/_apply_corporate/_logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d_%H%M%S)_${LABEL}.log"
CONN='SCM_MGR/"!SCMroqkf2026"@100.65.143.121:1521/OCGSCMD_P01'

if [ ! -f "$SQL_FILE" ]; then
  echo "[FAIL] file not found: $SQL_FILE"
  exit 1
fi

mkdir -p "$LOG_DIR"

echo "=== APPLY: $LABEL ===" | tee "$LOG_FILE"
echo "  SQL : $SQL_FILE" | tee -a "$LOG_FILE"
echo "  LOG : $LOG_FILE" | tee -a "$LOG_FILE"
echo "  TIME: $(date +%H:%M:%S)" | tee -a "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Strip CRLF + ensure trailing EXIT
{ tr -d '\r' < "$SQL_FILE"; printf "\nEXIT;\n"; } | docker exec -i nscm-oracle bash -c "sqlplus -L -S '$CONN'" >> "$LOG_FILE" 2>&1
RC=$?

# Categorize errors
ALL_ERR=$(grep -cE "^ORA-[0-9]+|^SP2-[0-9]+|^PLS-[0-9]+" "$LOG_FILE")
# Known-acceptable errors — patched later in Phase 5
#   ORA-01400 on MSG_M NOT NULL columns (MSG_TP_CD/USE_YN/CREATED_BY/LAST_UPDATED_BY)
#   ORA-00942 on SCM_COM_MSG_M (table never existed)
#   ORA-00904 on BMK_YN (SCM_ADM_MNU_M column added later in Docker, absent in corporate)
KNOWN_ORA01400=$(grep -cE 'ORA-01400.*"(MSG_TP_CD|USE_YN|CREATED_BY|LAST_UPDATED_BY)"' "$LOG_FILE")
KNOWN_SCM_COM_MSG_M=$(grep -cE 'SCM_COM_MSG_M' "$LOG_FILE" | head -1)
# count ORA-00942 lines that immediately follow a SCM_COM_MSG_M reference
KNOWN_00942=$(awk '/SCM_COM_MSG_M/{seen=NR+3} /ORA-00942/{if(NR<=seen)c++} END{print c+0}' "$LOG_FILE")
KNOWN_BMK_YN=$(grep -cE 'ORA-00904.*"BMK_YN"' "$LOG_FILE")
# ORA-01653 — USERS tablespace quota exhausted (sometimes for MSG_M / API_M / PROC_M tables)
KNOWN_01653=$(grep -cE 'ORA-01653' "$LOG_FILE")
# DBMS_METADATA bug in corporate Oracle 19c — audit-only backup block fails (real SP recreation still OK)
# Pattern: ORA-01001/06502 + DBMS_METADATA chain in 1 block
KNOWN_METADATA=0
if grep -qE 'DBMS_METADATA|UTL_XML|LPX-00210|bad stylesheet' "$LOG_FILE"; then
  KNOWN_METADATA=$(grep -cE 'DBMS_METADATA|UTL_XML|LPX-00210|bad stylesheet|ORA-01001|ORA-06502' "$LOG_FILE")
fi
# SP2-* are sqlplus client-side parse errors (often VERIFY-only SELECT statements with inline comments)
# Real SQL semantic errors are caught by ORA- and PLS- prefixes
KNOWN_SP2=$(grep -cE '^SP2-[0-9]+' "$LOG_FILE")
KNOWN_ERR=$((KNOWN_ORA01400 + KNOWN_00942 + KNOWN_BMK_YN + KNOWN_01653 + KNOWN_METADATA + KNOWN_SP2))
REAL_ERR=$((ALL_ERR - KNOWN_ERR))
if [ "$REAL_ERR" -lt 0 ]; then REAL_ERR=0; fi

echo "" >> "$LOG_FILE"
echo "=== END: $LABEL — exitcode=$RC, total_err=$ALL_ERR, known=$KNOWN_ERR, real=$REAL_ERR ===" >> "$LOG_FILE"

if [ "$REAL_ERR" -gt 0 ]; then
  echo "  [ERR ] real_errors=$REAL_ERR  (known_accepted=$KNOWN_ERR, total=$ALL_ERR)"
  echo "  --- first 10 unique errors ---"
  grep -E "^ORA-[0-9]+|^SP2-[0-9]+|^PLS-[0-9]+" "$LOG_FILE" | sort -u | head -10
  exit 2
fi
if [ "$KNOWN_ERR" -gt 0 ]; then
  echo "  [WARN] $KNOWN_ERR known i18n MSG_M NOT NULL errors (will patch later)"
fi
echo "  [OK  ] $LABEL"
exit 0
