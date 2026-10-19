"""[E20261013-DMF0003SYNCSYS] 바뀐 기록 식 검증 (읽기 전용 — 테이블을 건드리지 않는다)

적용본(01_PKG_DMF0003_BODY.sql)에서 바뀐 SELECT 목록 2줄을 그대로 잘라, 시험 행(메저 10종 × 원장 생성자 있음/없음)에 적용한다.
동기화 프로시저 자체는 실행하지 않는다 — 실행하면 82 Sales Plan 전 행이 다시 기록된다(사용자 지시: 데이터 일괄 수정 불필요).

기대
  수량 메저 5종 : 생성자 = 입력 그대로(비어 있으면 빈 채로) · 생성 시각 = 입력 그대로 · 수정자 = SYSTEM · 수정 시각 = 지금
  금액 메저 5종 : 생성자 = SYSTEM · 생성 시각 = 지금(입력이 비어 있으므로) · 수정자 = SYSTEM · 수정 시각 = 지금
"""
import sys, os, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
QTY = ["MKT_FCST", "CUST_FCST", "TMM_FCST", "RTF", "RTF_SYS_RP"]
AMT = ["SalesAmt_KRW", "SalesAmt_LOC", "SalesAmt_USD", "MKT_AMT_KRW", "MKT_AMT_LOC"]


def main():
    src = open(os.path.join(HERE, "01_PKG_DMF0003_BODY.sql"), encoding="utf-8").read()
    m = re.search(r"\n(\s*, CASE WHEN MEASURE IN \([^\n]*\n\s*, 'SYSTEM', SYSDATE AS LAST_UPDATE_DATE)\n", src)
    assert m, "바뀐 2줄을 찾지 못함"
    expr = m.group(1)
    assert src.count(expr) == 1
    print("검증 대상 식:\n" + expr)
    rows = []
    for meas in QTY:   # 수량 메저는 원장에서 생성자·생성 시각을 가져온다 (생성자가 빈 경우도 시험)
        rows.append((meas, "ledger_user", "DATE '2026-09-01'"))
        rows.append((meas, None, "DATE '2026-09-01'"))
    for meas in AMT:   # 금액 메저는 프로시저가 생성자·생성 시각을 비워서 넘긴다. 값이 들어온 경우도 시험
        rows.append((meas, None, "CAST(NULL AS DATE)"))
        rows.append((meas, "someone", "CAST(NULL AS DATE)"))
    union = " UNION ALL ".join(
        f"SELECT {i} AS RN, '{mm}' AS MEASURE, {('NULL' if cb is None else repr(cb))} AS CREATED_BY, {cd} AS CREATION_DATE FROM DUAL"
        for i, (mm, cb, cd) in enumerate(rows))
    sql = (f"SELECT RN, MEASURE, CREATED_BY AS IN_CREATED_BY, TO_CHAR(CREATION_DATE, 'YYYY-MM-DD') AS IN_CRE\n"
           f"{expr.replace('SYSDATE AS LAST_UPDATE_DATE', 'SYSDATE')}\n"
           f"     , TRUNC(SYSDATE) FROM ( {union} ) ORDER BY RN")
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute(sql)
    fail = 0
    for rn, meas, in_cb, in_cre, out_cb, out_cre, out_ub, out_upd, today in cur.fetchall():
        if meas in QTY:
            ok = out_cb == in_cb and out_cre.strftime("%Y-%m-%d") == in_cre and out_ub == "SYSTEM" and out_upd.date() == today.date()
        else:
            ok = out_cb == "SYSTEM" and out_cre.date() == today.date() and out_ub == "SYSTEM" and out_upd.date() == today.date()
        fail += (not ok)
        print("PASS" if ok else "FAIL", f"| {meas:13s} | 입력 생성자 {str(in_cb):12s} → 생성자 {str(out_cb):12s} | 생성일 {out_cre:%Y-%m-%d} | 수정자 {out_ub} | 수정일 {out_upd:%Y-%m-%d}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
