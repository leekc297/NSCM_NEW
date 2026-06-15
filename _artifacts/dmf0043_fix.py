"""DMF0043_GET_CONTRIBUTION_SALES_LIST SP body 정밀 fix.

3 위치 변경:
1. line 332: ON TEAM.USER_ID IN (FN_SCM_STRING_SPLIT(I.OWNER,...)) → SUBSTR/INSTR
2. line 540: 동일 (A.OWNER)
3. 다른 위치 (sed 실패 fix) — 확실하게 매치

추가 fix:
- line 113~144 INSERT INTO SCM_MST_TITLESET_USER block → helper SP 호출 (helper SP 이미 적용된 상태이면 skip)
"""
import re
from pathlib import Path

src = Path(r"C:\Projects\NSCM\_artifacts\dmf0043_sp_body.txt").read_text(encoding='utf-8')

# Fix 1: line 332 + 540 — FN_SCM_STRING_SPLIT(I.OWNER) / FN_SCM_STRING_SPLIT(A.OWNER)
pattern1 = re.compile(
    r"ON\s+TEAM\.USER_ID\s+IN\s*\(\s*SELECT\s+COLUMN_VALUE\s+FROM\s+TABLE\(FN_SCM_STRING_SPLIT\(([IA])\.OWNER,\s*','\)\)\s+WHERE\s+ROWNUM\s*<=\s*1\s*\)",
    re.IGNORECASE
)
def replace1(m):
    alias = m.group(1)
    return (f"ON TEAM.USER_ID = CASE WHEN INSTR({alias}.OWNER, ',') > 0 "
            f"THEN SUBSTR({alias}.OWNER, 1, INSTR({alias}.OWNER, ',') - 1) "
            f"ELSE {alias}.OWNER END  -- [TUNING] FN_SCM_STRING_SPLIT lateral view 회피")
src_after, n1 = pattern1.subn(replace1, src)
print(f"[Fix 1] FN_SCM_STRING_SPLIT(OWNER) → SUBSTR/INSTR rewrite count: {n1}")

# Fix 2: TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') → SYSDATE (이미 적용 가능)
src_after, n2 = re.subn(
    r"TO_CHAR\(SYSDATE,\s*'YYYY-MM-DD HH24:MI:SS'\)",
    "SYSDATE",
    src_after
)
print(f"[Fix 2] TO_CHAR(SYSDATE,...) → SYSDATE rewrite count: {n2}")

# Fix 3: INSERT INTO SCM_MST_TITLESET_USER block → helper SP 호출
# Pattern: IF v_user_col_cnt = 0 THEN ... INSERT INTO SCM_MST_TITLESET_USER ... END IF;
# 다만 helper SP 이미 호출 중이면 skip
if "P_DMF0043_INIT_TITLESET_USER" in src_after:
    print("[Fix 3] helper SP 호출 이미 적용됨 — skip")
else:
    pattern3 = re.compile(
        r"IF\s+v_user_col_cnt\s*=\s*0\s+THEN(.*?)END\s+IF;",
        re.IGNORECASE | re.DOTALL
    )
    replace3 = (
        "IF v_user_col_cnt = 0 THEN\n"
        "        -- [TUNING] AUTONOMOUS_TRANSACTION helper (lock contention 회피)\n"
        "        P_DMF0043_INIT_TITLESET_USER(p_created_by, va_program_id, va_sheet_name);\n"
        "    END IF;"
    )
    src_after, n3 = pattern3.subn(replace3, src_after, count=1)
    print(f"[Fix 3] INSERT block → helper SP rewrite count: {n3}")

Path(r"C:\Projects\NSCM\_artifacts\dmf0043_sp_body_fixed.txt").write_text(src_after, encoding='utf-8')
print(f"\nOUTPUT: {len(src_after)} bytes")

# 잔존 grep
remaining = re.findall(r"FN_SCM_STRING_SPLIT\([IA]\.OWNER", src_after, re.IGNORECASE)
print(f"잔존 FN_SCM_STRING_SPLIT(OWNER) 호출 수: {len(remaining)}")
