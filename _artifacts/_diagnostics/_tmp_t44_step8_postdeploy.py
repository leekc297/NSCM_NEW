#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP8 — 배포 후 검증
  (1) 라이브 소스 == 배포본 (바이트 일치)
  (2) 사고 커서(plan_hash 237589406) 무효화 확인
  (3) ★ 실제 병목 문장을 **운영과 동일한 형태**(INSERT + PL/SQL 바인드)로 실행해 실측
      → 반드시 ROLLBACK (커밋 없음). 프로시저를 부르지 않으므로 내부 COMMIT 도 없다.
"""
import sys, pathlib, re, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
PATCHED = OUT / "PKG_DMF0044_BODY_TRANSFERTUNE_20260810.sql"
DIV, VER = '40', 'R_S_20260128_V002_C'

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

def sec(t):
    print("\n" + "=" * 116); print(t); print("=" * 116)

# ---------- (1) 라이브 소스 == 배포본 ----------
sec("[1] 라이브 소스 == 배포본 대조")
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "CREATE OR REPLACE " + "".join(r[0] for r in cur.fetchall()).lstrip()
want = PATCHED.read_text(encoding="utf-8")
norm = lambda s: s.replace("\r\n", "\n").rstrip().rstrip("/").rstrip()
same = norm(live) == norm(want)
print(f"  라이브 {len(live.splitlines()):,}행 / 배포본 {len(want.splitlines()):,}행 → 일치: {'PASS ✅' if same else 'FAIL ⛔'}")
for m in ("TUNE-V 2026-08-10", "TUNE-J 2026-08-10", "DM_MST_ITEM_SINGLE_V", "SCM_MST_ITEM_SN"):
    print(f"    라이브 마커 '{m}' = {live.count(m)}")

# ---------- (2) 사고 커서 무효화 ----------
sec("[2] 사고 커서(SQL_ID 5dchxk6z8k7hg / plan_hash 237589406) 상태")
show(*fetch(cur, """SELECT sql_id, child_number, plan_hash_value, is_shareable, object_status,
                           executions, ROUND(elapsed_time/1e6,1) elapsed_s
                      FROM v$sql WHERE sql_id='5dchxk6z8k7hg'"""))
cur.execute("SELECT COUNT(*) FROM v$sql WHERE sql_id='5dchxk6z8k7hg' AND is_shareable='Y'")
n = cur.fetchone()[0]
print(f"  → 재사용 가능(is_shareable=Y) 커서 = {n}  {'✅ 무효화됨' if n == 0 else '⚠ 아직 재사용 가능'}")

# ---------- (3) 실제 병목 문장 실측 (INSERT 형태 · ROLLBACK) ----------
def mask(s):
    out = list(s); i = 0; nn = len(s)
    while i < nn:
        if s[i] == "'":
            j = i + 1
            while j < nn:
                if s[j] == "'":
                    if j + 1 < nn and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, nn)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):
            j = s.find('\n', i); j = nn if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i+2); j = nn if j < 0 else j+2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)

def extract_insert(text, proc, target):
    m = mask(text)
    start = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+' + proc + r'\b', m)][0]
    nxt = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+\w+', m) if mm.start() > start]
    end = nxt[0] if nxt else len(m)
    ins = start + m[start:end].index('INSERT INTO ' + target)
    j = ins; depth = 0
    while j < end:
        if m[j] == '(': depth += 1
        elif m[j] == ')': depth -= 1
        elif m[j] == ';' and depth == 0: break
        j += 1
    return text[ins:j].strip()

cur.execute("SELECT MAX(SUBSTR(YYYYMMDD,1,4)) FROM DM_MDF_VERSION WHERE VERSION_NO=:v", {"v": VER})
YYYY = cur.fetchone()[0]

sec("[3] ★ 병목 문장 실측 — 운영과 동일 형태(INSERT + PL/SQL 변수 바인드), 실행 후 ROLLBACK")
stmt = extract_insert(live, 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_PRODUCT')
blk = f"""
DECLARE
    P_DIVISION_ID VARCHAR2(32) := '{DIV}';
    P_VERSION_NO  VARCHAR2(50) := '{VER}';
    P_YYYY        VARCHAR2(4)  := '{YYYY}';
    v_user_id     VARCHAR2(10) := 'mdf_batch';
BEGIN
    -- 프로시저 원본과 동일 순서: 같은 division/version 선삭제 후 적재 (전체 ROLLBACK 예정)
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT
     WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO;
{stmt};
    :rc := SQL%ROWCOUNT;
END;"""
rc = cur.var(oracledb.NUMBER)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
before = cur.fetchone()[0]
print(f"  사전 상태: DM_MOBILE_REPORT_PRODUCT 해당 division/version 행 = {before:,}")
t0 = time.time()
cur.execute(blk, {"rc": rc})
el = time.time() - t0
print(f"  ★ 실행 완료 {el:.2f}초 / INSERT {int(rc.getvalue()):,} 행   (사고 시: 미완주 4,909초, 처리행 0)")

cur.execute("""SELECT sql_id, child_number, plan_hash_value, ROUND(elapsed_time/1e6,2) el,
                      buffer_gets, rows_processed
                 FROM v$sql WHERE sql_text LIKE 'INSERT INTO SCM_MGR.DM_MOBILE_REPORT_PRODUCT%'
                 ORDER BY last_active_time DESC FETCH FIRST 2 ROWS ONLY""")
rows = cur.fetchall()
for r in rows:
    print(f"    sql_id={r[0]} plan_hash={r[2]} elapsed={r[3]}s buffer_gets={r[4]:,} rows={r[5]:,}")
if rows:
    show(*fetch(cur, """SELECT id, LPAD(' ',depth)||operation||' '||NVL(options,'') op,
                               object_name, cardinality est_rows, cost
                          FROM v$sql_plan WHERE sql_id=:i AND child_number=:c ORDER BY id""",
                {"i": rows[0][0], "c": rows[0][1]}))
    cur.execute("""SELECT COUNT(*) FROM v$sql_plan WHERE sql_id=:i AND child_number=:c
                    AND operation='VIEW PUSHED PREDICATE'""", {"i": rows[0][0], "c": rows[0][1]})
    print(f"  ★ VIEW PUSHED PREDICATE 노드 = {cur.fetchone()[0]}  (0 이어야 정상)")

con.rollback()
cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
after = cur.fetchone()[0]
print(f"\n  [정리] ROLLBACK 완료 — 행 {before:,} → {after:,}  {'✅ 원상복구' if before == after else '⛔ 불일치'}")
con.close()
