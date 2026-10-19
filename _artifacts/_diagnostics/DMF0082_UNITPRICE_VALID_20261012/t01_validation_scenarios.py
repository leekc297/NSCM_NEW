# -*- coding: utf-8 -*-
"""DMF0082 저장 검증 10 (Unit Price Not Found) 시나리오 재현 — 사내 ZIOUI1, 영구 테이블 무변경.
SAVE_MAIN_DATA 의 ① 판가 수집 INSERT(GT_PRDM1_T_PRICE, 40 분기) ② 검증 10 SELECT 를 **USER_SOURCE 원문에서 그대로 추출**해
세션 GTT(GT_PRDM1_T_MAIN 등)에 가상 입력행만 넣고 실행한다. 끝에 ROLLBACK + GTT DELETE."""
import io, sys, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cn.call_timeout=600000; cur = cn.cursor()
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'"); print("BODY LAST_DDL", cur.fetchone()[0])
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = "".join(t or "" for (t,) in cur)
sv = src[src.index("PROCEDURE P_DMF0082_SAVE_MAIN_DATA"):]
# ① 판가 수집 (40 분기)
a = sv.index("    INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE"); b = sv.index("    ) AA;", a) + len("    ) AA")
ins_price = sv[a:b].replace("V_MIN_DATE", ":mn").replace("V_MAX_DATE", ":mx")
# ② 검증 10
a = sv.index("        SELECT 'End Customer : '"); b = sv.index("FETCH FIRST 1 ROWS ONLY;", a) + len("FETCH FIRST 1 ROWS ONLY")
val = re.sub(r"\n\s*INTO s_unit_price_valid", "", sv[a:b])
def reset():
    for t in ("GT_PRDM1_T_MAIN","GT_PRDM1_T_PRICE","GT_PRDM1_MSHYCHU1","GT_PRDM1_MSHYCHU2"): cur.execute(f"DELETE FROM SCM_MGR.{t}")
    cur.execute("INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2) SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='MEASURE' AND VALID_YN='Y'")
    cur.execute("INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2) SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='FCST_TYPE' AND VALID_YN='Y'")
def run(name, rows):
    reset()
    for r in rows:
        cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
                       VALUES ('I','40',:pj,:ec,:st,:it,:de,:ft,:ic,:ms,:pl,:cp,:ymd,:cur,:q,'TEST')""", r)
    cur.execute("SELECT MIN(C.BASIS_START_DATE), MAX(C.BASIS_END_DATE) FROM SCM_MGR.GT_PRDM1_T_MAIN A JOIN SCM_MGR.SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD=A.YYYYMMDD")
    mn, mx = cur.fetchone()
    cur.execute(ins_price, mn=mn, mx=mx)
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_PRDM1_T_PRICE"); np = cur.fetchone()[0]
    cur.execute(val); r = cur.fetchone()
    res = "PASS(저장 진행)" if r is None else "BLOCK(Unit Price Not Found) " + r[0].replace("\n"," | ")[:230]
    print(f"[{name}] T_PRICE={np}행 → {res}")
# 기준 키: 금주(20261012 주) LOC 판가가 있고 같은 주에 수요(MKT_FCST)가 있는 실제 키 1건
cur.execute("""SELECT P.PROJECT_CODE,P.END_CUSTOMER,P.SCM_SITE_ID,P.ITEM_ID,P.DOM_EXP,P.FCST_TYPE,P.INCOTERMS,P.PLANT_SITE_ID,P.CELL_PROD_SITE_ID,P.CURRENCY,
                      (SELECT COUNT(*) FROM DM_PLN_CFM_SELLING_PRICE X WHERE X.DIVISION_ID='40' AND X.MEASURE='LOC' AND X.PRICE>0 AND X.YYYYMMDD='20261019' AND X.PROJECT_CODE=P.PROJECT_CODE AND X.END_CUSTOMER=P.END_CUSTOMER AND X.SCM_SITE_ID=P.SCM_SITE_ID AND X.ITEM_ID=P.ITEM_ID AND X.DOM_EXP=P.DOM_EXP AND X.FCST_TYPE=P.FCST_TYPE AND X.INCOTERMS=P.INCOTERMS AND X.PLANT_SITE_ID=P.PLANT_SITE_ID AND X.CELL_PROD_SITE_ID=P.CELL_PROD_SITE_ID) NEXTWK
                 FROM DM_PLN_CFM_SELLING_PRICE P
                WHERE P.DIVISION_ID='40' AND P.MEASURE='LOC' AND P.PRICE>0 AND P.YYYYMMDD='20261012' AND P.CELL_PROD_SITE_ID NOT IN ('-','/')
                  AND P.FCST_TYPE NOT IN ('ASF','SDF','SMF','SPF','TST','WSF')
                  AND NOT EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM Z WHERE Z.DIVISION_ID='40' AND Z.PROJECT_CODE=P.PROJECT_CODE AND Z.SCM_SITE_ID=P.SCM_SITE_ID AND Z.ITEM_ID=P.ITEM_ID AND Z.VALID_YN='Y' AND Z.SALES_PLAN_ADJUST_YN='N')
                ORDER BY NEXTWK FETCH FIRST 1 ROWS ONLY""")
k = cur.fetchone(); print("기준 키(금주 LOC 실존):", k)
base = dict(pj=k[0], ec=k[1], st=k[2], it=k[3], de=k[4], ft=k[5], ic=k[6], pl=k[7], cp=k[8], cur='', ms='MKT_FCST', q=100, ymd='20261012')
R = lambda **o: {**base, **o}
print("\n--- A. 금주 LOC 가 원장에 있는 키에 수량 신규 입력")
run("A1 금주 월요일 1일, 키 전부 일치", [R()])
run("A2 금주 수(10-14)·금(10-16) 입력, 키 일치", [R(ymd='20261014'), R(ymd='20261016')])
run("A3 금주 + 다음주(10-19 주, 원장 LOC " + ("있음" if k[10] else "없음") + ")", [R(), R(ymd='20261019')])
run("A4 Cell Prod Site 만 다름('-' Common 선택)", [R(cp='-')])
run("A5 Cell Prod Site 가 '/' (센티널 전환 표기)", [R(cp='/')])
run("A6 Plant Site 공란(''→NULL)", [R(pl=None)])
run("A7 Plant Site '/' (원장은 '" + str(k[7]) + "')", [R(pl='/')])
run("A8 End Customer 다름", [R(ec='ZZ_TEST')])
run("A9 Incoterms 다름", [R(ic='ZZZ')])
run("A10 Customs Handbook(DOM_EXP) 다름", [R(de='Z')])
run("A11 Fcst Type 을 명칭으로 전송", [R(ft='Mass')])
print("\n--- B. 원장에 판가가 없는 새 키(End Customer 를 가상값으로) — 같은 저장에 LOC 를 함께 입력")
N = lambda **o: R(ec='ZZ_NEWKEY', **o)
run("B1 수량 월 + LOC 월(주 시작일)", [N(), N(ms='LOC', q=1.5, cur='USD')])
run("B2 수량 월 + LOC 수(10-14, 주 중간일)", [N(), N(ms='LOC', q=1.5, cur='USD', ymd='20261014')])
run("B3 수량 수(10-14) + LOC 수(10-14)", [N(ymd='20261014'), N(ms='LOC', q=1.5, cur='USD', ymd='20261014')])
run("B4 수량 월 + LOC 월, LOC 행만 Plant 공란", [N(), N(ms='LOC', q=1.5, cur='USD', pl=None)])
run("B5 수량 금주·다음주 + LOC 금주 월만", [N(), N(ymd='20261019'), N(ms='LOC', q=1.5, cur='USD')])
print("\n--- C. 월경계 분할주 (2026-12-28 월 ~ 2027-01-03 일: 12-28~31 / 01-01~03 두 구간)")
cur.execute("SELECT BASIS_YYYYMMDD, BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD IN ('20261228','20261231','20270101','20270103') ORDER BY 1"); print("   캘린더:", cur.fetchall())
run("C1 수량 01-01(금) + LOC 12-28(월, ISO 주 시작)", [N(ymd='20270101'), N(ms='LOC', q=1.5, cur='USD', ymd='20261228')])
run("C2 수량 01-01(금) + LOC 01-01(구간 시작)", [N(ymd='20270101'), N(ms='LOC', q=1.5, cur='USD', ymd='20270101')])
run("C3 수량 12-30(수) + LOC 12-28(월)", [N(ymd='20261230'), N(ms='LOC', q=1.5, cur='USD', ymd='20261228')])
reset(); cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1"); cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2"); cn.rollback(); cn.close(); print("\n정리 완료 (GTT 비움 · ROLLBACK · 영구 테이블 변경 없음)")
