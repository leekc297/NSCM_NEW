"""
DMF0008_GET_SALES_SITE — final fix:
- Line 53: UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL → UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1
  (메모리 feedback_isnull_to_nvl_null_handling.md 같은 변환 사고 패턴)
- EXCEPTION: keep diag-mode-like detail (SQLCODE/SQLERRM 노출) instead of generic
- PR_SCM_SYS_LOG_BATCH: keep disabled (SCM_SYS_LOG table 미존재)
"""
from pathlib import Path
import re

ROOT = Path(__file__).parent
ORIG = ROOT / "_original_sales_site.sql"
FIXED = ROOT / "_fixed_sales_site.sql"

body = ORIG.read_text(encoding="utf-8")

# Fix 1: UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL → COUNT > 1
new_body, n1 = re.subn(
    r"UTL_CALL_STACK\.SUBPROGRAM\(1\)\(1\)\s+IS\s+NOT\s+NULL",
    "UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1",
    body
)
print(f"UTL_CALL_STACK fixes: {n1}")

# Fix 2: RAISE_APPLICATION_ERROR with detailed info
new_body, n2 = re.subn(
    r"RAISE_APPLICATION_ERROR\s*\(\s*-20001\s*,\s*'오류가 발생했습니다\.'\s*\)\s*;",
    "RAISE_APPLICATION_ERROR(-20001, 'SQLCODE=' || V_SQL_CODE || ' SQLERRM=' || V_SQL_ERRMSG || ' BACKTRACE=' || SUBSTR(V_BACKTRACE, 1, 800));",
    new_body
)
print(f"RAISE_APPLICATION_ERROR detail: {n2}")

# Fix 3: PR_SCM_SYS_LOG_BATCH 비활성화 (SCM_SYS_LOG 미존재)
new_body, n3 = re.subn(
    r"^(\s*)PR_SCM_SYS_LOG_BATCH\(",
    r"\1NULL; -- [2026-06-10 FIX] PR_SCM_SYS_LOG_BATCH(",
    new_body,
    flags=re.MULTILINE
)
print(f"LOG_BATCH disabled: {n3}")

# Comment out the multi-line args of PR_SCM_SYS_LOG_BATCH
lines = new_body.split('\n')
out = []
in_log_block = False
for line in lines:
    if 'NULL; -- [2026-06-10 FIX] PR_SCM_SYS_LOG_BATCH' in line:
        in_log_block = True
        out.append(line)
        continue
    if in_log_block:
        out.append('        -- ' + line.lstrip())
        if ');' in line:
            in_log_block = False
        continue
    out.append(line)
new_body = '\n'.join(out)

if not new_body.rstrip().endswith('/'):
    new_body = new_body.rstrip() + "\n/\n"
FIXED.write_text(new_body, encoding="utf-8")
print(f"Wrote: {FIXED}")
