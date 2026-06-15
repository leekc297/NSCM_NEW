"""
P_SYS0013_GET_QUERY_LIST 의 row 곱셈 사고 fix:
- INNER JOIN (... OR DIV='-') → EXISTS + scalar subquery for EDIT_YN
"""
import oracledb, re

conn = oracledb.connect(user='SCM_MGR', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur = conn.cursor()

cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_SYS0013' AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = ''.join(r[0] for r in cur.fetchall())

# INNER JOIN block 검색
# 원본:
#   FROM SCM_ADM_DQ_LIST A
#       INNER JOIN (SELECT * -- EDIT_YN
#           FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
#           WHERE USER_ID = P_USER_ID
#           AND MNU_ID = P_MNU_ID
#           AND UNIT_TP_CD = 'D') T2
#           ON (A.DIVISION_ID = T2.UNIT_ID OR A.DIVISION_ID = '-')
#
# 변경 후:
#   FROM SCM_ADM_DQ_LIST A
#   WHERE EXISTS (
#       SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
#       WHERE T2.USER_ID = P_USER_ID AND T2.MNU_ID = P_MNU_ID AND T2.UNIT_TP_CD = 'D'
#         AND (A.DIVISION_ID = T2.UNIT_ID OR A.DIVISION_ID = '-')
#   )
#
# 그리고 SELECT 절의 T2.EDIT_YN 참조 → scalar subquery 로 변경

# Step 1: SELECT 절의 T2.EDIT_YN → scalar subquery
old_sel = ", NVL(T2.EDIT_YN,'N') AS EDIT_YN"
new_sel = """, NVL((SELECT MAX(T2.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                    WHERE T2.USER_ID = P_USER_ID AND T2.MNU_ID = P_MNU_ID AND T2.UNIT_TP_CD = 'D'
                      AND (A.DIVISION_ID = T2.UNIT_ID OR A.DIVISION_ID = '-')), 'N') AS EDIT_YN"""
n1 = body.count(old_sel)
print(f'  SELECT T2.EDIT_YN matches: {n1}')
new_body = body.replace(old_sel, new_sel, 1)

# Step 2: INNER JOIN 블록 → WHERE EXISTS (line by line)
inner_join_block = """        FROM SCM_ADM_DQ_LIST A
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON (A.DIVISION_ID = T2.UNIT_ID OR A.DIVISION_ID = '-')"""

exists_block = """        FROM SCM_ADM_DQ_LIST A
        WHERE EXISTS (
            SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2_AUTH
            WHERE T2_AUTH.USER_ID = P_USER_ID
              AND T2_AUTH.MNU_ID = P_MNU_ID
              AND T2_AUTH.UNIT_TP_CD = 'D'
              AND (A.DIVISION_ID = T2_AUTH.UNIT_ID OR A.DIVISION_ID = '-')
        )
          AND 1 = 1 -- placeholder"""

# 정확 매칭 시도 — 공백 정규화
def norm(s): return re.sub(r'\\s+', ' ', s).strip()

# 검색: A INNER JOIN ... ON ... ) 까지의 multi-line 블록
pat = re.compile(r'FROM SCM_ADM_DQ_LIST A\\s+INNER JOIN \\(SELECT \\* -- EDIT_YN\\s+FROM SCM_ADM_USER_MNU_EDIT_AUTH_V\\s+WHERE USER_ID = P_USER_ID\\s+AND MNU_ID = P_MNU_ID\\s+AND UNIT_TP_CD = \\'D\\'\\) T2\\s+ON \\(A\\.DIVISION_ID = T2\\.UNIT_ID OR A\\.DIVISION_ID = \\'-\\'\\)', re.MULTILINE | re.IGNORECASE)
m = pat.search(new_body)
print(f'  INNER JOIN block found: {bool(m)}')
if m:
    rep = """FROM SCM_ADM_DQ_LIST A
        WHERE EXISTS (
            SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2_AUTH
            WHERE T2_AUTH.USER_ID = P_USER_ID
              AND T2_AUTH.MNU_ID = P_MNU_ID
              AND T2_AUTH.UNIT_TP_CD = 'D'
              AND (A.DIVISION_ID = T2_AUTH.UNIT_ID OR A.DIVISION_ID = '-')
        )"""
    new_body = new_body[:m.start()] + rep + new_body[m.end():]

# Step 3: TMPDQ CTE 의 끝 WHERE 1=1 ... (P_DQ_ID/P_DQ_NAME 처리) 는 그대로 (이전 fix 유지)
# 다만 'WHERE 1 = 1 / AND (NVL(P_DQ_ID,...))' 가 EXISTS 다음에 와야 함
# 위 rep 가 EXISTS 만 추가 → 기존 WHERE 1=1 절은 그 뒤에. 다만 EXISTS 결과로 인해 'WHERE 1=1' 가 'AND 1=1' 으로 바뀌어야 syntax 정상

# 검사: 변경된 body 안에 'EXISTS' 다음 'WHERE 1 = 1' 가 있는지
if 'EXISTS (' in new_body:
    # EXISTS 뒤에 오는 'WHERE 1 = 1' → 'AND 1 = 1'
    new_body = new_body.replace('        WHERE 1 = 1\n          AND (NVL(P_DQ_ID', '          AND 1 = 1\n          AND (NVL(P_DQ_ID', 1)

# Step 4: 적용
try:
    cur.execute('CREATE OR REPLACE ' + new_body)
    print('✅ PKG_SYS0013 body fix applied')
except Exception as e:
    print(f'❌ ERR: {e}')
    # debug — 변경된 부분 출력
    idx = new_body.find('FROM SCM_ADM_DQ_LIST A')
    if idx >= 0: print(f'--- around FROM ---\\n{new_body[idx:idx+800]}\\n---')

conn.commit()
conn.close()
