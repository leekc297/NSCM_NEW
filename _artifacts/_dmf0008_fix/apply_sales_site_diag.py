"""
DMF0008_GET_SALES_SITE — patch EXCEPTION to expose real SQLERRM (diagnostic mode).
"""
from pathlib import Path
import re

ROOT = Path(__file__).parent
ORIG = ROOT / "_original_sales_site.sql"
DIAG = ROOT / "_diag_sales_site.sql"

body = ORIG.read_text(encoding="utf-8")

# Replace the generic '오류가 발생했습니다.' RAISE_APPLICATION_ERROR with detailed one
# Pattern: RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
# Replace with: RAISE_APPLICATION_ERROR(-20001, 'SQLCODE=' || V_SQL_CODE || ' SQLERRM=' || V_SQL_ERRMSG || ' BT=' || SUBSTR(V_BACKTRACE, 1, 800));
new_body, n = re.subn(
    r"RAISE_APPLICATION_ERROR\s*\(\s*-20001\s*,\s*'오류가 발생했습니다\.'\s*\)\s*;",
    "RAISE_APPLICATION_ERROR(-20001, 'SQLCODE=' || V_SQL_CODE || ' SQLERRM=' || V_SQL_ERRMSG || ' BACKTRACE=' || SUBSTR(V_BACKTRACE, 1, 800));",
    body
)
print(f"RAISE patches: {n}")

# Also disable PR_SCM_SYS_LOG_BATCH (might be source of additional failure)
# Comment out the call
new_body, n2 = re.subn(
    r"^(\s*)PR_SCM_SYS_LOG_BATCH\(",
    r"\1NULL; -- DIAG: PR_SCM_SYS_LOG_BATCH(",
    new_body,
    flags=re.MULTILINE
)
print(f"LOG_BATCH disabled: {n2}")

# Need to comment out the rest of the call (multi-line args + closing paren)
# Original: PR_SCM_SYS_LOG_BATCH(v_program_name, ... lines ... );
# After our subst: NULL; -- DIAG: PR_SCM_SYS_LOG_BATCH( ... but the closing ); still needs to be commented
# Simpler: find from "NULL; -- DIAG:" line until first matching `);` and comment each line
lines = new_body.split('\n')
out = []
in_log_block = False
for line in lines:
    if 'NULL; -- DIAG: PR_SCM_SYS_LOG_BATCH' in line:
        in_log_block = True
        out.append(line)
        continue
    if in_log_block:
        out.append('        -- DIAG: ' + line.lstrip())
        if ');' in line:
            in_log_block = False
        continue
    out.append(line)

new_body = '\n'.join(out)

if not new_body.rstrip().endswith('/'):
    new_body = new_body.rstrip() + "\n/\n"
DIAG.write_text(new_body, encoding="utf-8")
print(f"Wrote: {DIAG}")
