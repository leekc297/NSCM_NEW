#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP5 — 붕괴가 실제로 일어났던 조건(PL/SQL 정적 SQL + 바인드)에서 OLD/NEW 플랜 비교.

왜 필요한가: STEP4 의 단독 실행(리터럴 치환)에서는 OLD 도 0.85초였다.
  즉 **단독 실행 성적은 이번 사고를 재현하지 못한다** — 52분 붕괴는 PL/SQL 안에서
  PL/SQL 변수를 바인드로 넘길 때 일어났다. 같은 조건에서 재검증한다.
  DML 은 하지 않는다 (INSERT 를 떼고 커서 OPEN/FETCH 만).
  OLD 는 붕괴 시 끝나지 않으므로 상한을 걸고, 미완주 자체를 증거로 기록한다.
"""
import sys, pathlib, re, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
OLD_F = OUT / "BACKUP_PKG_DMF0044_BODY_pre_transfertune_20260810.sql"
NEW_F = OUT / "PKG_DMF0044_BODY_TRANSFERTUNE_20260810.sql"
DIV, VER = '40', 'R_S_20260128_V002_C'
OLD_CAP = 150      # 초 — OLD 붕괴 시 상한


def mask(s):
    out = list(s); i = 0; n = len(s)
    while i < n:
        if s[i] == "'":
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, n)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):
            j = s.find('\n', i); j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i+2); j = n if j < 0 else j+2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)


def extract(text, proc, target):
    m = mask(text)
    start = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+' + proc + r'\b', m)][0]
    nxt = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+\w+', m) if mm.start() > start]
    end = nxt[0] if nxt else len(m)
    ins = start + m[start:end].index('INSERT INTO ' + target)
    i = m.index('(', ins); depth = 0
    while i < end:
        if m[i] == '(': depth += 1
        elif m[i] == ')':
            depth -= 1
            if depth == 0: break
        i += 1
    j = i + 1; depth = 0
    while j < end:
        if m[j] == '(': depth += 1
        elif m[j] == ')': depth -= 1
        elif m[j] == ';' and depth == 0: break
        j += 1
    return text[i+1:j].strip()


def block(sel, tag):
    """PL/SQL 정적 SQL + PL/SQL 변수(=바인드) 컨텍스트를 그대로 재현. INSERT 만 제거."""
    sel = sel.replace('SELECT', f'SELECT /*{tag}*/', 1)
    return f"""
DECLARE
    P_DIVISION_ID  VARCHAR2(32)  := '{DIV}';
    P_VERSION_NO   VARCHAR2(50)  := '{VER}';
    P_YYYY         VARCHAR2(4)   := :yyyy;
    v_user_id      VARCHAR2(10)  := 'mdf_batch';
    v_ori_version_no VARCHAR2(50) := :oriv;
    V_SP_BP        VARCHAR2(2)   := :spbp;
    c              SYS_REFCURSOR;
    n              PLS_INTEGER := 0;
BEGIN
    OPEN c FOR
{sel};
    LOOP
        FETCH c INTO {{into}};
        EXIT WHEN c%NOTFOUND;
        n := n + 1;
    END LOOP;
    CLOSE c;
    :cnt := n;
END;"""


u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
cur = con.cursor()
cur.execute("SELECT MAX(SUBSTR(YYYYMMDD,1,4)) FROM DM_MDF_VERSION WHERE VERSION_NO=:v", {"v": VER})
YYYY = cur.fetchone()[0]
cur.execute("SELECT MAX(ORI_VERSION_NO) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
ORIV = cur.fetchone()[0]
SPBP = 'SP'

# PRODUCT 문장의 결과 컬럼 타입에 맞춘 FETCH 변수 (26 컬럼)
INTO_PRODUCT = ("v1,v2,v3,v4,v5,v6,v7," + ",".join(f"m{i}" for i in range(1, 13))
                + ",v8,v9,v10,d1,v11,d2")
DECL_PRODUCT = """    v1 VARCHAR2(4000); v2 VARCHAR2(4000); v3 VARCHAR2(4000); v4 VARCHAR2(4000);
    v5 VARCHAR2(4000); v6 VARCHAR2(4000); v7 VARCHAR2(4000);
    m1 NUMBER; m2 NUMBER; m3 NUMBER; m4 NUMBER; m5 NUMBER; m6 NUMBER;
    m7 NUMBER; m8 NUMBER; m9 NUMBER; m10 NUMBER; m11 NUMBER; m12 NUMBER;
    v8 VARCHAR2(4000); v9 NUMBER; v10 VARCHAR2(4000); d1 DATE; v11 VARCHAR2(4000); d2 DATE;"""

results = {}
for lbl, f in (("OLD", OLD_F), ("NEW", NEW_F)):
    sel = extract(f.read_text(encoding='utf-8'),
                  'P_DMF0044_SALES_REPORT_PRODUCT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_PRODUCT')
    tag = f"T44P_{lbl}"
    blk = block(sel, tag).replace("    c              SYS_REFCURSOR;",
                                  DECL_PRODUCT + "\n    c              SYS_REFCURSOR;")
    blk = blk.replace("{into}", INTO_PRODUCT)
    con.call_timeout = (OLD_CAP if lbl == "OLD" else 900) * 1000
    cnt = cur.var(oracledb.NUMBER)
    print(f"\n{'='*112}\n### {lbl} — PL/SQL 정적 SQL + 바인드 컨텍스트 실행\n{'='*112}")
    t0 = time.time()
    try:
        cur.execute(blk, {"yyyy": YYYY, "oriv": ORIV, "spbp": SPBP, "cnt": cnt})
        el = time.time() - t0
        print(f"  완주 {el:.2f}초 / 행 {int(cnt.getvalue()):,}")
        results[lbl] = ("완주", el)
    except Exception as e:
        el = time.time() - t0
        print(f"  ⛔ 미완주 {el:.1f}초 — {str(e)[:120]}")
        results[lbl] = ("미완주", el)

    con.call_timeout = 60000
    try:
        cur.execute("""SELECT sql_id, child_number FROM v$sql
                        WHERE sql_text LIKE :t AND sql_text NOT LIKE '%v$sql%'
                        ORDER BY last_active_time DESC FETCH FIRST 1 ROWS ONLY""", {"t": f"%{tag}%"})
        r = cur.fetchone()
        if r:
            sid_, ch = r
            show(*fetch(cur, """SELECT id, LPAD(' ',depth)||operation||' '||NVL(options,'') op,
                                       object_name, cardinality est_rows, cost
                                  FROM v$sql_plan WHERE sql_id=:i AND child_number=:c ORDER BY id""",
                        {"i": sid_, "c": ch}))
            cur.execute("""SELECT COUNT(*) FROM v$sql_plan
                            WHERE sql_id=:i AND child_number=:c AND options='PUSHED PREDICATE'""",
                        {"i": sid_, "c": ch})
            npp = cur.fetchone()[0]
            print(f"  ★ VIEW PUSHED PREDICATE 노드 수 = {npp}  {'⛔ 붕괴 형태' if npp else '✅ 없음'}")
        else:
            print("  (플랜 미확보)")
    except Exception as e:
        print(f"  (플랜 조회 실패: {str(e)[:80]})")

print(f"\n{'#'*112}\n종합: OLD={results.get('OLD')} / NEW={results.get('NEW')}\n{'#'*112}")
con.close()
