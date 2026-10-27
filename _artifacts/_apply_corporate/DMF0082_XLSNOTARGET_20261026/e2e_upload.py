"""DMF0082 Excel Upload E2E — [E20261026-DMF0082XLSNOTARGET] (사내 ZIOUI1) — BE FileServiceImpl 와 같은 호출 체인을 직접 실행한다.

  PR_SAVE_EXCEL_UPLOAD(JSON, 19, 'DMF0082', 'FcstNPrice', user) → P_DMF0082_EXCEL_UPLOAD(0, ...) → PR_GET_EXCEL_UPLOAD_RESULT
  → (S1 만) P_DMF0082_EXCEL_UPLOAD(1, ...) 저장 → SCM_MST_FUTURE_PRICE 확인 → 테스트 행 정리
  → (G1) 대상 없는 행으로 저장 시도 → CODE -1 (저장 차단) 확인

원장 보호: 테스트 ID XLSNT_T1 · 저장 케이스(S1) 대상 프로젝트 FUTURE_PRICE/_H 0건 assert · 정리는 테스트 ID 가 만든 행만.
조회 전용 케이스는 스테이징(SCM_ADM_EXCEL_UPLOAD)만 쓴다 — 매 케이스 전 테스트 ID 스테이징 삭제, 종료 시 삭제.
"""
import json
import sys

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402

USER = "XLSNT_T1"
HDR = ["Div", "Team", "End Customer", "Project Code", "Currency", "Model"] + [f"M{i}" for i in range(13)]
# 정상 — LOC 대상 있음 (사내 실측: 같은 조합 품목 3 · FP LOC KRW 단일)
LOC_OK = {"Div": "81", "Team": "Sales T.Porsche/BMW P", "End Customer": "BMW", "Project Code": "A15BW7003",
          "Currency": "KRW", "Model": "", "M2": "10"}
# 정상 — LOC 없음, RTF_SYS_RP 만 있음 (사내 실측: 프로젝트 FP 0건) → 저장 케이스
RTF_OK = {"Div": "81", "Team": "ESG팀", "End Customer": "Lion Bus", "Project Code": "A17LS4001",
          "Currency": "USD", "Model": "", "M2": "10"}
SAVE_PRJ = RTF_OK["Project Code"]

M_EC = "No MODEL for END CUSTOMER / PROJECT CODE."
M_TEAM = "No MODEL for TEAM / PROJECT CODE."
M_TGT = "No Upload Target MODEL (LOC / RTF_SYS_RP)."

CASES = [
    ("C01 정상 Model 빈칸 · LOC 대상", LOC_OK, "SUCCESS", None),
    ("C02 정상 Model 빈칸 · RTF_SYS_RP 대상만", RTF_OK, "SUCCESS", None),
    ("C03 10-26 신고 조합 (Alte · A21BW2003 · AI/빅데이터1.빅데이터분석팀)",
     {**LOC_OK, "Team": "AI/빅데이터1.빅데이터분석팀", "End Customer": "Alte", "Project Code": "A21BW2003", "Currency": "USD"},
     "ERROR", None),   # 기대 메시지는 신규 3종 중 하나 — 아래에서 판정
    ("C04 End Customer 와 Project 불일치", {**LOC_OK, "End Customer": "Lion Bus"}, "ERROR", M_EC),
    ("C05 Team 이 Project 품목 부서 아님", {**LOC_OK, "Team": "ESG팀"}, "ERROR", M_TEAM),
    ("C06 품목·부서 일치 · LOC/RTF 대상 없음",
     {**LOC_OK, "Team": "자동차.마케팅.마케팅3.독일마케팅1팀", "Project Code": "A21BW2005"}, "ERROR", M_TGT),
    ("C07 없는 Team", {**LOC_OK, "Team": "ZZ없는팀"}, "ERROR", "Invalid TEAM."),
    ("C08 없는 End Customer", {**LOC_OK, "End Customer": "ZZNOCUST"}, "ERROR", "Invalid END CUSTOMER."),
    ("C09 없는 Project", {**LOC_OK, "Project Code": "ZZNOPRJ"}, "ERROR", "Invalid PROJECT CODE."),
    ("C10 없는 Currency", {**LOC_OK, "Currency": "ZZZ"}, "ERROR", "Invalid CURRENCY."),
    ("C11 Division 82", {**LOC_OK, "Div": "82"}, "ERROR", "Invalid Division."),
    ("C12 Division 빈칸", {**LOC_OK, "Div": "", "Team": "x"}, None, None),   # Div 빈칸 = AS-IS 동일 SKIP (빈 줄 취급)
    ("C13 Model 입력 정상 (회귀)", {**LOC_OK, "Model": "APBMW12VA-A2-090"}, "SUCCESS", None),
    ("C14 Model 입력 · 없는 Model (회귀)", {**LOC_OK, "Model": "ZZZ-NOT-EXIST"}, "ERROR", "Invalid MODEL."),
]


def payload(rows):
    title = {"UPLOAD_STAT": "@TITLE", **{f"_COL{i + 1}": h for i, h in enumerate(HDR)}}
    data = [{"UPLOAD_STAT": "UPLOAD", **{f"_COL{i + 1}": r.get(h, "") for i, h in enumerate(HDR)}} for r in rows]
    return json.dumps([title, *data], ensure_ascii=False)


def fetch(rc):
    cols = [d[0] for d in rc.description]
    return [dict(zip(cols, r)) for r in rc.fetchall()]


def clear_staging(cur):
    cur.execute("DELETE FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:u", u=USER)
    cur.connection.commit()


def upload(cur, row, mode_save=False):
    # 화면 업로드 1회 = 스테이징 1묶음. 연속 호출이 같은 초(CREATION_DATE)에 묶이지 않게 테스트 ID 스테이징을 비운다.
    clear_staging(cur)
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("PKG_NSCM_UI_EXCEL.PR_SAVE_EXCEL_UPLOAD", [payload([row]), len(HDR), "DMF0082", "FcstNPrice", USER, rc])
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD", [0, USER, "DMF0082", "FcstNPrice", rc])
    valid = fetch(rc.getvalue())
    cur.connection.commit()   # BE 트랜잭션 커밋과 동일 시점
    c1, c2, c3 = (cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(3))
    cur.callproc("PKG_NSCM_UI_EXCEL.PR_GET_EXCEL_UPLOAD_RESULT", [len(HDR), "DMF0082", "FcstNPrice", USER, c1, c2, c3])
    cnt = fetch(c1.getvalue())
    cur.execute("""SELECT UPLOAD_STATUS_CODE, MESSAGE_TEXT FROM SCM_ADM_EXCEL_UPLOAD
                    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:u
                      AND UPLOAD_STATUS_CODE NOT IN ('@TITLE')""", u=USER)
    stg = cur.fetchall()
    saved = None
    if mode_save:
        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc("PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD", [1, USER, "DMF0082", "FcstNPrice", rc])
        saved = fetch(rc.getvalue())
        cur.connection.commit()
    return valid, cnt, stg, saved


def ledger(cur):
    cur.execute("SELECT COUNT(*) FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p", p=SAVE_PRJ)
    fp = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM SCM_MST_FUTURE_PRICE_H WHERE DIVISION_ID='81' AND PROJECT_CODE=:p", p=SAVE_PRJ)
    return fp, cur.fetchone()[0]


def main():
    u, p, d = conn_info()
    results = []
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
        print("DB", cur.fetchone())
        cur.execute("SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%XLSNOTARGET%'")
        print("PATCH TAG", cur.fetchone()[0])
        before = ledger(cur)
        assert before == (0, 0), f"원장 보호: 저장 케이스 프로젝트 FP/FP_H 가 이미 {before} — 중단"
        try:
            for name, row, exp_stat, exp_msg in CASES:
                valid, cnt, stg, _ = upload(cur, row)
                stat = stg[0][0] if stg else None
                msg = stg[0][1] if stg else None
                if exp_stat is None:      # C12 — 판정용 관찰
                    ok = stat == "SKIP"
                elif exp_msg is None and exp_stat == "ERROR":
                    ok = stat == "ERROR" and msg in (M_EC, M_TEAM, M_TGT)
                else:
                    ok = stat == exp_stat and (exp_msg is None or msg == exp_msg)
                results.append(ok)
                print(f"{'PASS' if ok else 'FAIL'}  {name}: 검증={valid[0]['CODE'] if valid else None} 결과={stat} / {msg} / CNT={cnt}")
            # G1 — 대상 없는 행(C05)으로 저장 시도 → 차단
            valid, cnt, stg, saved = upload(cur, CASES[4][1], mode_save=True)
            ok = saved and saved[0]["CODE"] == "-1" and ledger(cur) == (0, 0)
            results.append(ok)
            print(f"{'PASS' if ok else 'FAIL'}  G1 대상 없는 행 저장 시도: {stg} → {saved}")
            # S1 — RTF_SYS_RP 대상 정상 행 저장
            valid, cnt, stg, saved = upload(cur, RTF_OK, mode_save=True)
            fp, fph = ledger(cur)
            cur.execute("""SELECT ITEM_ID, MEASURE, CURRENCY, MIN(YYYYMMDD), MAX(YYYYMMDD), COUNT(*), MIN(PRICE), MAX(PRICE)
                             FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p AND CREATED_BY=:u
                            GROUP BY ITEM_ID, MEASURE, CURRENCY ORDER BY 1, 2""", p=SAVE_PRJ, u=USER)
            rows = cur.fetchall()
            loc = [r for r in rows if r[1] == "LOC"]
            ok = saved and saved[0]["CODE"] == "0" and fp > 0 and fp == fph and loc and all(r[6] == 10 and r[7] == 10 for r in loc)
            results.append(ok)
            print(f"{'PASS' if ok else 'FAIL'}  S1 RTF 대상 저장: 검증={stg} 저장={saved} FP={fp} FP_H={fph}")
            for r in rows:
                print("      ", r)
        finally:
            cur.execute("DELETE FROM SCM_MST_FUTURE_PRICE WHERE DIVISION_ID='81' AND PROJECT_CODE=:p AND CREATED_BY=:u AND ATTRIBUTE8='EXCEL UPLOAD'", p=SAVE_PRJ, u=USER)
            n1 = cur.rowcount
            cur.execute("DELETE FROM SCM_MST_FUTURE_PRICE_H WHERE DIVISION_ID='81' AND PROJECT_CODE=:p AND CREATED_BY=:u AND ATTRIBUTE8='EXCEL UPLOAD'", p=SAVE_PRJ, u=USER)
            n2 = cur.rowcount
            con.commit()
            clear_staging(cur)
            print(f"CLEANUP FP {n1} · FP_H {n2} · 스테이징 삭제 → 원장 {ledger(cur)} (전 {before})")
    print(f"\nRESULT {sum(1 for r in results if r)}/{len(results)} PASS")


if __name__ == "__main__":
    main()
