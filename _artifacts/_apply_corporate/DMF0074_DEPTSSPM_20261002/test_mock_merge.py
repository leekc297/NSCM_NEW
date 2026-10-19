"""[E20261002-DEPTSSPM] 실행 게이트 — 적용된 BODY 의 4) 원장 MERGE · 5) 이력 INSERT 문장을 그대로 실행 (ROLLBACK — 원장 무변경)

모의 GT_DM74_TMP_METAL_LINK_PRICE 6행 (키는 SSPM/원장 실데이터에서 선정):
  T1 신규(81)   SSPM DEPT 있음            → INSERT, DEPT_ID = SSPM
  T2 신규(40)   SSPM DEPT 있음 (END_CUSTOMER=SSPM.PROJECT_CODE, PROJECT_CODE 공란) → INSERT, DEPT_ID = SSPM, PROJECT_CODE '-'
  T3 신규       SSPM DEPT NULL            → INSERT, DEPT_ID = '-'
  T4 기존 '-'   SSPM DEPT 있음            → UPDATE, DEPT_ID '-' → SSPM
  T5 기존 값    SSPM DEPT 다름            → UPDATE, DEPT_ID → SSPM
  T6 기존 값    SSPM DEPT NULL            → UPDATE, DEPT_ID 유지
신규 키는 PLAN_YYYYMM='209912' (원장 부재 assert). 종료 시 ROLLBACK + 원장/이력 전후 지문 동일 assert.
"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

MARK = "[E20261002-DEPTSSPM]"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0074' AND type='PACKAGE BODY' ORDER BY line")
src = "".join(r[0] for r in cur)
assert src.count(MARK) == 5, f"마커 {src.count(MARK)}개 — 적용 판본 확인"

m = re.findall(r"(MERGE INTO SCM_MGR\.DM_BPS_METAL_LINK_PRICE A\b.*?);\n", src, re.S)
assert len(m) == 1, f"MERGE {len(m)}개"
merge_sql = m[0].replace("P_CREATED_BY", ":usr")
h = re.findall(r"(INSERT INTO SCM_MGR\.DM_BPS_METAL_LINK_PRICE_H\b.*?);\n", src, re.S)
assert len(h) == 1, f"_H INSERT {len(h)}개"
hist_sql = h[0].replace("P_CREATED_BY", ":usr")
assert merge_sql.count(MARK) == 3 and hist_sql.count(MARK) == 2

FP = ("SELECT COUNT(*), SUM(ORA_HASH(DIVISION_ID||'|'||PLAN_YYYYMM||'|'||DEPT_ID||'|'||SCM_SITE_ID||'|'||ITEM_ID||'|'||METAL_KIND_CODE||'|'||"
      "TO_CHAR(LAST_UPDATE_DATE,'YYYYMMDDHH24MISS')||'|'||LAST_UPDATED_BY)) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE")
cur.execute(FP); fp_before = cur.fetchone()
cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE_H"); h_before = cur.fetchone()[0]

SSPM = "SCM_MGR.SCM_MST_SITE_ITEM"
LEDJ = ("FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE A JOIN " + SSPM + " SI ON SI.DIVISION_ID=A.DIVISION_ID "
        "AND SI.PROJECT_CODE=CASE WHEN A.DIVISION_ID='40' THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END "
        "AND SI.SCM_SITE_ID=A.SCM_SITE_ID AND SI.ITEM_ID=A.ITEM_ID ")
LCOLS = ("A.DIVISION_ID,A.PLAN_YYYYMM,A.END_CUSTOMER,A.PROJECT_CODE,A.PLANT_SITE_ID,A.ITEM_ID,A.METAL_LINK_YN,A.SCM_SITE_ID,A.CURRENCY,A.FCST_TYPE,"
         "A.METAL_EXCEPTION_YN,A.ENERGY,A.METAL_KIND_CODE,A.APPLY_PRICE_TYPE_CODE,A.FROM_PERIOD_YYYYMM,A.TO_PERIOD_YYYYMM,"
         "A.CONTRACT_UNIT_PRICE,A.METAL_APPLY_UNIT_PRICE,A.METAL_REQR_QTY, A.DEPT_ID, SI.DEPT_ID")


def one(sql):
    cur.execute(sql + " FETCH FIRST 1 ROWS ONLY")
    r = cur.fetchone()
    assert r, "표본 없음: " + sql[:120]
    return r


def new_row(div, where):
    s = one(f"SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID FROM {SSPM} WHERE DIVISION_ID='{div}' AND VALID_YN='Y' AND {where} "
            f"AND RTRIM(PROJECT_CODE) IS NOT NULL ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID")
    ec, pj = (s[0], None) if div == "40" else ("MOCK_EC", s[0])
    #       DIV  YYYYMM   EC  PJ  PLANT    ITEM  ML   SITE  CUR    FCST   EX   ENERGY KIND  KEY   FR   TO   CU MA MR VER
    return (div, "209912", ec, pj, "MOCKPL", s[2], "Y", s[1], "USD", "MPS", "N", 0, "Ni", "K1", "1", "2", 1, 2, 3, "MOCKVER"), s[3]


def old_row(where):
    r = one(f"SELECT {LCOLS} {LEDJ} WHERE {where} ORDER BY A.DIVISION_ID, A.PLAN_YYYYMM, A.ITEM_ID, A.METAL_KIND_CODE")
    row = list(r[:19]) + ["MOCKVER"]
    if row[0] == "40":
        row[3] = None  # 40 은 GT PROJECT_CODE 공란 (원장 '-')
    return tuple(row), r[19], r[20]


cases = []
g, sd = new_row("81", "DEPT_ID IS NOT NULL");                      cases.append(("T1 신규 81 SSPM有", g, None, sd, sd))
g, sd = new_row("40", "DEPT_ID IS NOT NULL");                      cases.append(("T2 신규 40 SSPM有", g, None, sd, sd))
g, sd = new_row("82", "DEPT_ID IS NULL");                          cases.append(("T3 신규 82 SSPM無", g, None, sd, "-"))
g, od, sd = old_row("A.DEPT_ID = '-' AND SI.DEPT_ID IS NOT NULL"); cases.append(("T4 기존 '-' SSPM有", g, od, sd, sd))
g, od, sd = old_row("A.DEPT_ID <> '-' AND SI.DEPT_ID IS NOT NULL AND SI.DEPT_ID <> A.DEPT_ID"); cases.append(("T5 기존 값 SSPM異", g, od, sd, sd))
g, od, sd = old_row("A.DEPT_ID <> '-' AND SI.DEPT_ID IS NULL");    cases.append(("T6 기존 값 SSPM無", g, od, sd, od))

KEYQ = ("SELECT DEPT_ID, PROJECT_CODE, LAST_UPDATED_BY FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE WHERE DIVISION_ID=:1 AND PLAN_YYYYMM=:2 AND END_CUSTOMER=:3 "
        "AND PROJECT_CODE=NVL(:4,'-') AND PLANT_SITE_ID=:5 AND ITEM_ID=:6 AND SCM_SITE_ID=:7 AND CURRENCY=:8 AND FCST_TYPE=:9 AND METAL_KIND_CODE=:10")


def key(g):
    return (g[0], g[1], g[2], g[3], g[4], g[5], g[7], g[8], g[9], g[12])


ok = True
try:
    for name, g, od, sd, exp in cases:
        cur.execute(KEYQ, key(g)); pre = cur.fetchall()
        assert len(pre) == (0 if od is None else 1), f"{name}: 사전 원장 행수 {len(pre)}"
    cur.execute("DELETE FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE")
    cur.executemany("INSERT INTO SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE (DIVISION_ID,PLAN_YYYYMM,END_CUSTOMER,PROJECT_CODE,PLANT_SITE_ID,ITEM_ID,"
                    "METAL_LINK_YN,SCM_SITE_ID,CURRENCY,FCST_TYPE,METAL_EXCEPTION_YN,ENERGY,METAL_KIND_CODE,APPLY_PRICE_TYPE_CODE,FROM_PERIOD,"
                    "TO_PERIOD,CONTRACT_UNIT,METAL_APPLY,METAL_REQR,VERSION_NO) VALUES (" + ",".join(f":{i+1}" for i in range(20)) + ")",
                    [c[1] for c in cases])
    cur.execute(merge_sql, usr="MOCK_DEPTSSPM"); print("MERGE rows", cur.rowcount)
    ok &= cur.rowcount == 6
    cur.execute(hist_sql, usr="MOCK_DEPTSSPM"); print("_H INSERT rows", cur.rowcount)
    ok &= cur.rowcount == 6
    for name, g, od, sd, exp in cases:
        cur.execute(KEYQ, key(g)); post = cur.fetchall()
        cur.execute("SELECT DEPT_ID FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE_H WHERE CREATED_BY='MOCK_DEPTSSPM' AND DIVISION_ID=:1 AND PLAN_YYYYMM=:2 "
                    "AND ITEM_ID=:3 AND SCM_SITE_ID=:4 AND METAL_KIND_CODE=:5 AND END_CUSTOMER=:6", (g[0], g[1], g[5], g[7], g[12], g[2]))
        hd = [r[0] for r in cur.fetchall()]
        exp_h = sd if sd is not None else "-"
        res = len(post) == 1 and post[0][0] == exp and post[0][2] == "MOCK_DEPTSSPM" and hd == [exp_h]
        ok &= res
        print(f"{'PASS' if res else 'FAIL'} {name:18s} div={g[0]:5s} item={g[5]:22s} 원장前={od!s:9s} SSPM={sd!s:9s} → 원장後={post[0][0] if post else None!s:9s} "
              f"(기대 {exp}) PJ={post[0][1] if post else None} _H={hd}")
finally:
    con.rollback()
    cur.execute(FP); fp_after = cur.fetchone()
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE_H"); h_after = cur.fetchone()[0]
    same = fp_before == fp_after and h_before == h_after
    print("ROLLBACK 후 원장 지문", fp_before, "→", fp_after, "/ _H", h_before, "→", h_after, "동일" if same else "불일치!!")
    con.close()
print("RESULT", "PASS" if ok and same else "FAIL")
