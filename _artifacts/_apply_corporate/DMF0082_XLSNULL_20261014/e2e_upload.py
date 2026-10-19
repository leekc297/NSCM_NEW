"""DMF0082 Excel Upload E2E (사내 ZIOUI1) — BE FileServiceImpl 와 같은 호출 체인을 직접 실행한다.

  PR_SAVE_EXCEL_UPLOAD(JSON, 19, 'DMF0082', 'FcstNPrice', user) → P_DMF0082_EXCEL_UPLOAD(0, ...) → PR_GET_EXCEL_UPLOAD_RESULT
  (C1 만) → P_DMF0082_EXCEL_UPLOAD(1, ...) 저장 → SCM_MST_FUTURE_PRICE 확인 → 테스트 행 정리

원장 보호: 테스트 ID XLSNULL_T1 · 저장 전 대상 프로젝트 FUTURE_PRICE 0건 assert · 정리는 테스트 ID 가 만든 행만.
"""
import json
import sys

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402

USER = "XLSNULL_T1"
HDR = ["Div", "Team", "End Customer", "Project Code", "Currency", "Model"] + [f"M{i}" for i in range(13)]
BASE = {"Div": "81", "Team": "ESS.SCM.SCM2팀", "End Customer": "ESS", "Project Code": "A25PS1001-M02",
        "Currency": "USD", "Model": "", "M2": "10"}
PRJ = BASE["Project Code"]

CASES = [
    ("C1 원본 파일 행(Model 빈칸, M2=10)", {}, "SUCCESS", None),
    ("C2 Team 빈칸", {"Team": ""}, "ERROR", "NULL TEAM."),
    ("C3 존재하지 않는 Model", {"Model": "ZZZ-NOT-EXIST"}, "ERROR", "Invalid MODEL."),
    ("C4 M2 = 0", {"M2": "0"}, "ERROR", "Zero Number."),
    ("C5 M2 = -5", {"M2": "-5"}, "ERROR", "Negative Number."),
    ("C6 유효 Model 입력(ECE1592F1-01-E00, M3=20)", {"Model": "ECE1592F1-01-E00", "M2": "", "M3": "20"}, "SUCCESS", None),
]


def payload(row):
    title = {"UPLOAD_STAT": "@TITLE", **{f"_COL{i + 1}": h for i, h in enumerate(HDR)}}
    data = {"UPLOAD_STAT": "UPLOAD", **{f"_COL{i + 1}": row.get(h, "") for i, h in enumerate(HDR)}}
    return json.dumps([title, data], ensure_ascii=False)


def fetch(rc):
    cols = [d[0] for d in rc.description]
    return [dict(zip(cols, r)) for r in rc.fetchall()]


def upload(cur, row, mode_save=False):
    # 화면 업로드 1회 = 스테이징 1묶음. 연속 호출이 같은 초(CREATION_DATE)에 묶이지 않게 테스트 ID 스테이징을 비운다.
    cur.execute("DELETE FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:u", u=USER)
    cur.connection.commit()
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("PKG_NSCM_UI_EXCEL.PR_SAVE_EXCEL_UPLOAD", [payload(row), len(HDR), "DMF0082", "FcstNPrice", USER, rc])
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD", [0, USER, "DMF0082", "FcstNPrice", rc])
    valid = fetch(rc.getvalue())
    c1, c2, c3 = (cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(3))
    cur.callproc("PKG_NSCM_UI_EXCEL.PR_GET_EXCEL_UPLOAD_RESULT", [len(HDR), "DMF0082", "FcstNPrice", USER, c1, c2, c3])
    cnt, lst = fetch(c1.getvalue()), fetch(c2.getvalue())
    cur.execute("""SELECT UPLOAD_STATUS_CODE, MESSAGE_TEXT, ATTRIBUTE6 FROM SCM_ADM_EXCEL_UPLOAD
                    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:u
                      AND CREATION_DATE = (SELECT MAX(CREATION_DATE) FROM SCM_ADM_EXCEL_UPLOAD
                                            WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:u)
                      AND UPLOAD_STATUS_CODE NOT IN ('@TITLE','SKIP')""", u=USER)
    stg = cur.fetchall()
    saved = None
    if mode_save:
        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc("PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD", [1, USER, "DMF0082", "FcstNPrice", rc])
        saved = fetch(rc.getvalue())
    return valid, cnt, lst, stg, saved


def fp_rows(cur):
    cur.execute("""SELECT ITEM_ID, MEASURE, CURRENCY, SCM_SITE_ID, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
                          MIN(YYYYMMDD), MAX(YYYYMMDD), COUNT(*), MIN(PRICE), MAX(PRICE)
                     FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p
                    GROUP BY ITEM_ID, MEASURE, CURRENCY, SCM_SITE_ID, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
                    ORDER BY 1, 2""", p=PRJ)
    return cur.fetchall()


def main():
    u, p, d = conn_info()
    results = []
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
        print("DB", cur.fetchone())
        cur.execute("SELECT COUNT(*) FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p", p=PRJ)
        before = cur.fetchone()[0]
        assert before == 0, f"원장 보호: 대상 프로젝트 FUTURE_PRICE 가 이미 {before}건 — 중단"
        cur.execute("SELECT COUNT(*) FROM SCM_MST_FUTURE_PRICE_H WHERE DIVISION_ID='81' AND PROJECT_CODE=:p", p=PRJ)
        before_h = cur.fetchone()[0]
        print("BEFORE FP", before, "FP_H", before_h)
        try:
            for name, delta, exp_stat, exp_msg in CASES:
                row = {**BASE, **delta}
                valid, cnt, lst, stg, _ = upload(cur, row)
                stat = stg[0][0] if stg else None
                msg = stg[0][1] if stg else None
                ok = stat == exp_stat and (exp_msg is None or msg == exp_msg)
                results.append((name, exp_stat, exp_msg, stat, msg, ok))
                print(f"{'PASS' if ok else 'FAIL'}  {name}: 검증={valid} 결과={stat} / {msg} / CNT={cnt}")
            # 저장 — C1 원본 행
            valid, cnt, lst, stg, saved = upload(cur, BASE, mode_save=True)
            print("SAVE C1 검증", stg, "저장 결과", saved)
            rows = fp_rows(cur)
            print("AFTER FP (ITEM, MEASURE, CUR, SITE, PLANT, INCO, DOM, FCST, MIN, MAX, CNT, MINP, MAXP)")
            for r in rows:
                print("  ", r)
            items = sorted({r[0] for r in rows})
            meas = sorted({r[1] for r in rows})
            ok_items = items == ["ECE1592F1-01-E00", "ECE1592F1-01-E05"]
            loc = [r for r in rows if r[1] == "LOC"]
            ok_loc = all(r[11] == 10 and r[12] == 10 and r[8][:6] == "202612" and r[9][:6] == "202612" for r in loc)
            print(f"{'PASS' if ok_items else 'FAIL'}  저장 대상 Model = {items} (기대 E00·E05)")
            print(f"{'PASS' if ok_loc and loc else 'FAIL'}  LOC = 10 · 2026-12 주차만 (M2 = 당월+2)")
            print("      MEASURES", meas)
        finally:
            # 정리 — 테스트 ID 가 만든 행만
            cur.execute("DELETE FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p AND CREATED_BY=:u AND ATTRIBUTE8='EXCEL UPLOAD'", p=PRJ, u=USER)
            n1 = cur.rowcount
            cur.execute("DELETE FROM SCM_MST_FUTURE_PRICE_H WHERE DIVISION_ID='81' AND PROJECT_CODE=:p AND CREATED_BY=:u AND ATTRIBUTE8='EXCEL UPLOAD'", p=PRJ, u=USER)
            n2 = cur.rowcount
            cur.execute("DELETE FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:u", u=USER)
            n3 = cur.rowcount
            con.commit()
            cur.execute("SELECT COUNT(*) FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p", p=PRJ)
            a = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM SCM_MST_FUTURE_PRICE_H WHERE DIVISION_ID='81' AND PROJECT_CODE=:p", p=PRJ)
            ah = cur.fetchone()[0]
            print(f"CLEANUP FP {n1} · FP_H {n2} · STAGING {n3} → FP {a} (전 {before}) · FP_H {ah} (전 {before_h})")
    print("\nSUMMARY", sum(r[5] for r in results), "/", len(results), "validation cases PASS")


if __name__ == "__main__":
    main()
