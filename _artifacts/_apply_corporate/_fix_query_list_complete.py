"""
SYS0013 통합 fix:
1) PKG_SYS0013 body — INNER JOIN row 곱셈 → EXISTS 패턴 + EDIT_YN scalar subquery
2) ORDER BY DQ_ID 추가 (default sort)
3) SHEET_COLUMNS — DATA_SORT_METHOD_CODE='ASC' 설정 (자매 SYS0010 패턴)
"""
import oracledb

conn = oracledb.connect(user='SCM_MGR', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur = conn.cursor()

# Step 1+2: PKG body 추출 + 패치
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_SYS0013' AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = ''.join(r[0] for r in cur.fetchall())

# (1) SELECT의 T2.EDIT_YN → scalar subquery
old_sel = ", NVL(T2.EDIT_YN,'N') AS EDIT_YN"
new_sel = """, NVL((SELECT MAX(T2A.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2A
                    WHERE T2A.USER_ID=P_USER_ID AND T2A.MNU_ID=P_MNU_ID AND T2A.UNIT_TP_CD='D'
                      AND (A.DIVISION_ID=T2A.UNIT_ID OR A.DIVISION_ID='-')), 'N') AS EDIT_YN"""

if old_sel in body:
    new_body = body.replace(old_sel, new_sel, 1)
    print(f'  ✅ EDIT_YN scalar subquery applied')
else:
    print(f'  ⚠ EDIT_YN pattern not found')
    new_body = body

# (2) INNER JOIN block → WHERE EXISTS
# 원본 (다중 공백 포함 가능)
import re
ij_pat = re.compile(
    r'FROM\s+SCM_ADM_DQ_LIST\s+A\s+'
    r'INNER\s+JOIN\s+\(SELECT\s+\*[^\n]*\n\s*'
    r'FROM\s+SCM_ADM_USER_MNU_EDIT_AUTH_V\s*\n\s*'
    r"WHERE\s+USER_ID\s*=\s*P_USER_ID\s*\n\s*"
    r"AND\s+MNU_ID\s*=\s*P_MNU_ID\s*\n\s*"
    r"AND\s+UNIT_TP_CD\s*=\s*'D'\)\s+T2\s*\n\s*"
    r"ON\s+\(A\.DIVISION_ID\s*=\s*T2\.UNIT_ID\s+OR\s+A\.DIVISION_ID\s*=\s*'-'\)",
    re.MULTILINE
)
m = ij_pat.search(new_body)
print(f'  INNER JOIN block found: {bool(m)}')

if m:
    rep = """FROM SCM_ADM_DQ_LIST A
        WHERE EXISTS (
            SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
            WHERE T2.USER_ID=P_USER_ID AND T2.MNU_ID=P_MNU_ID AND T2.UNIT_TP_CD='D'
              AND (A.DIVISION_ID=T2.UNIT_ID OR A.DIVISION_ID='-')
        )"""
    new_body = new_body[:m.start()] + rep + new_body[m.end():]
    # 다음에 오는 "WHERE 1 = 1" → "AND 1 = 1"
    new_body = new_body.replace(
        "        )\n\n        WHERE 1 = 1\n          AND (NVL(P_DQ_ID",
        "        )\n          AND 1 = 1\n          AND (NVL(P_DQ_ID", 1
    )
    print(f'  ✅ INNER JOIN → WHERE EXISTS applied')

# (3) 외부 SELECT 끝의 WHERE 1=1 AND EXISTS(...SPLIT_ROLE...) 직후 ORDER BY DQ_ID 추가
# 원본 끝부분:
#   AND EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%')
# 또는 fix 후:
#   AND (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'));
old_role = "AND (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'));"
new_role = "AND (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'))\n     ORDER BY TO_NUMBER(DQ_ID);"
if old_role in new_body:
    new_body = new_body.replace(old_role, new_role, 1)
    print(f'  ✅ ORDER BY DQ_ID added')
else:
    print(f'  ⚠ ORDER BY insertion point not found')

# 적용
try:
    cur.execute('CREATE OR REPLACE ' + new_body)
    print(f'\n✅ PKG_SYS0013 body CREATE OR REPLACE OK')
except Exception as e:
    print(f'\n❌ ERR: {e}')

# Step 3: SHEET_COLUMNS — DATA_SORT_METHOD_CODE='ASC'
cur.execute("UPDATE SCM_MST_SHEET_COLUMNS SET DATA_SORT_METHOD_CODE='ASC', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE PROGRAM_ID='SYS0013' AND DATA_SORT_METHOD_CODE IS NULL")
print(f'  ✅ SHEET_COLUMNS DATA_SORT_METHOD_CODE=ASC : {cur.rowcount} row')

conn.commit()

# Verify
print()
print('=== Verify — DQ_ID=3 row count + sort ===')
import oracledb as _ora
conn2 = _ora.connect(user='SCMD_APP', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur2 = conn2.cursor()
o1=cur2.var(_ora.CURSOR); o2=cur2.var(_ora.CURSOR)
cur2.callproc('PKG_SYS0013.P_SYS0013_GET_QUERY_LIST', ['','','','minyonglee1','SYS0013',o1,o2])
rows = o1.getvalue().fetchall()
print(f'  Total: {len(rows)}')
# DQ_ID=3 count
cnt3 = sum(1 for r in rows if str(r[0])=='3')
print(f'  DQ_ID=3 count: {cnt3}')
print(f'  First 5 DQ_IDs: {[r[0] for r in rows[:5]]}')
conn2.close()
conn.close()
