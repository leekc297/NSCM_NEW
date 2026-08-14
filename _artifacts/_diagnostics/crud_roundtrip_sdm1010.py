# -*- coding: utf-8 -*-
"""SDM1010 저장 경로 전수 CRUD 왕복 — 수신 정본 PKG(2026-08-13 교체) 계약판.

경로: SAVE(I — 서버 채번·EVENT) → 필수누락 I=EVENT 0 → GET_TAB1(ATUH alias·색) → BTN_REQ(DRAFT→WAITING)
      → 편집가드(WAITING 행 M=EVENT 0) → BTN_CANCEL(WAITING→WRITING) → 권한 WRITE/READ replace-set
      (교차 보존 [E20260813-XTYPE]) → 요청 승인(목록 포함=CONFIRM)/REJECT(TYPE=요청권한) → SAVE(M/D)
      → GET_PERIOD → TAB2(본인 권한행·ALL 센티널)
전 경로 실데이터 왕복 후 정리(잔존 0) — 테스트 키 프리픽스 ZZ_CRUD_RT 격리. 내부 COMMIT SP —
집합 불변식 복원 검증 방식 (feedback_save_sp_direct_call_commits).
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout.reconfigure(encoding="utf-8", errors="replace")
from ora import conn_info  # noqa: E402

import oracledb  # noqa: E402

US = "minyonglee1"
PASS_CNT = 0
FAIL_CNT = 0


def check(name, cond, detail=""):
    global PASS_CNT, FAIL_CNT
    if cond:
        PASS_CNT += 1
        print(f"  [PASS] {name}")
    else:
        FAIL_CNT += 1
        print(f"  [FAIL] {name} — {detail}")


def rc(cur):
    rows = cur.fetchall()
    return dict(zip([x[0] for x in cur.description], rows[0])) if rows else {}


def main():
    u, pw, d = conn_info()
    con = oracledb.connect(user=u, password=pw, dsn=d)
    c = con.cursor()

    def save_tab1(flag, key, name, div="81", cust=None, sop="", code=""):
        # ⚠ M/D 가드 = dpjtKey+dpjtCode+dpjtSeq 실값 필수 (빈 값 = 조용히 0건 — 계약 §2)
        r = con.cursor()
        c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_SAVE_TAB1_PJT_REG",
                   [flag, key, code, "1", div, "DEV", cust or "", name, "POUCH", "ALS", "CELL",
                    sop, "EG00", US, r])
        return rc(r)

    def get_tab1():
        o1, o2 = con.cursor(), con.cursor()
        c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_GET_TAB1_PJT_REG", ["81", US, "SDM1010", "", o1, o2])
        cols = [x[0] for x in o1.description]
        return cols, [dict(zip(cols, r)) for r in o1.fetchall()]

    # 사전 정리 + 실존 고객 확보 (END_CUSTOMER = SCM_MST_SITE INNER)
    c.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY IN (SELECT DPJT_KEY FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_NAME LIKE 'ZZ_CRUD_RT%')")
    c.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_NAME LIKE 'ZZ_CRUD_RT%'")
    con.commit()
    c.execute("SELECT END_CUSTOMER FROM SCM_MGR.SCM_MST_SITE WHERE END_CUSTOMER IS NOT NULL AND END_CUSTOMER <> '-' AND ROWNUM=1")
    cust = c.fetchone()[0]

    # 1. SAVE I — 서버 채번(TEMP_)·EVENT 1
    r = save_tab1("I", "", "ZZ_CRUD_RT_A", cust=cust, sop="2026-09-01 00:00:00")
    check("1. SAVE(I) CODE=0/EVENT=1", r.get("CODE") == "0" and r.get("EVENT") == "1", r)
    c.execute("SELECT DPJT_KEY, DPJT_REG_STATUS, DPJT_CODE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_NAME='ZZ_CRUD_RT_A'")
    row = c.fetchone()
    check("1a. 원장 INSERT + DRAFT + TEMP 채번", row is not None and row[1] == "DRAFT" and row[2].startswith("TEMP_"), row)
    key = row[0]
    code = row[2]

    # 1g. 필수 누락 I = EVENT 0 (조용한 skip 계약 — [E20260813-EMPTYCHK] 가드 동작 확인)
    r = save_tab1("I", "", "")
    check("1g. 필수 누락 I = EVENT 0", r.get("CODE") == "0" and r.get("EVENT") == "0", r)

    # 2. GET_TAB1 — 본인 관리 필터·ATUH 오타 alias·상태명/색
    cols, rows = get_tab1()
    mine = [x for x in rows if x["DPJT_NAME"] == "ZZ_CRUD_RT_A"]
    check("2. GET_TAB1 행 조회(본인 관리)", len(mine) == 1, f"rows={len(rows)}")
    check("2a. ATUH alias 4종 + 상태명/색", "DPJT_ATUH_REG_STATUS_NAME" in cols
          and mine and mine[0]["DPJT_REG_STATUS_NAME"] == "작성중" and mine[0]["DPJT_REG_STATUS_COLOR_TYPE"] == "Gray",
          [x for x in cols if "ATUH" in x])

    # 3. BTN_REQ — DRAFT → WAITING ([E20260813-DRAFTGUARD])
    r3 = con.cursor()
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_BTN_REQ_PJT_REG", ["81", key, US, r3])
    c.execute("SELECT DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", k=key)
    check("3. 등록요청 DRAFT→WAITING", rc(r3).get("EVENT") == "1" and c.fetchone()[0] == "WAITING")

    # 3g. WAITING 행 M = EVENT 0 (관리자여도 상태 무관 MERGE — 변경내역 있으면 갱신됨. 가드는 D/REQ 축이므로
    #     여기서는 WAITING 행 D 시도 = EVENT 0 검증)
    r = save_tab1("D", key, "ZZ_CRUD_RT_A", code=code)
    check("3g. WAITING 행 D = EVENT 0 (가드)", r.get("EVENT") == "0", r)

    # 4. BTN_CANCEL — WAITING → WRITING
    r4 = con.cursor()
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_BTN_CANCEL_PJT_REG", ["81", key, US, r4])
    c.execute("SELECT DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", k=key)
    check("4. 요청취소 WAITING→WRITING", rc(r4).get("EVENT") == "1" and c.fetchone()[0] == "WRITING")

    # 5. 권한 WRITE replace-set (2명) + READ (1명) — 교차 보존 [E20260813-XTYPE]
    r5 = con.cursor()
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_WRITE", ["I", key, "ZZ_U1^ZZ_U2", "81", US, r5])
    r6 = con.cursor()
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_READ", ["I", key, "ZZ_U3", "81", US, r6])
    c.execute("""SELECT USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS FROM SCM_MGR.SPMS_PROJECT_USER_MAP
                 WHERE DPJT_KEY=:k ORDER BY USER_ID""", k=key)
    got = c.fetchall()
    check("5. WRITE 2 + READ 1 (READ 저장이 WRITE 미소거)",
          got == [("ZZ_U1", "WRITE", "CONFIRM"), ("ZZ_U2", "WRITE", "CONFIRM"), ("ZZ_U3", "READ", "CONFIRM")], got)

    # 6. 요청 시뮬 → 승인(목록 포함 재저장=CONFIRM) / 반려(BTN_REJECT — TYPE=요청권한)
    c.execute("""UPDATE SCM_MGR.SPMS_PROJECT_USER_MAP SET DPJT_AUTH_TYPE_REQ='WRITE', DPJT_AUTH_STATUS='REQUEST'
                 WHERE DPJT_KEY=:k AND USER_ID IN ('ZZ_U2','ZZ_U3')""", k=key)
    con.commit()
    r7 = con.cursor()  # 승인: ZZ_U2 를 WRITE 목록에 유지·포함 재저장
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_WRITE", ["I", key, "ZZ_U1^ZZ_U2", "81", US, r7])
    c.execute("SELECT DPJT_AUTH_STATUS FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY=:k AND USER_ID='ZZ_U2'", k=key)
    check("6. 요청 승인 = 목록 포함 저장 → CONFIRM", c.fetchone()[0] == "CONFIRM")
    r8 = con.cursor()  # 반려: ZZ_U3
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_SAVE_POP_BTN_REJECT", [key, "ZZ_U3", US, r8])
    c.execute("SELECT DPJT_AUTH_TYPE, DPJT_AUTH_STATUS FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY=:k AND USER_ID='ZZ_U3'", k=key)
    check("6b. 반려 = REJECT + TYPE=요청권한(WRITE)", c.fetchone() == ("WRITE", "REJECT"))

    # 6c. GET_POP 3본 — WRITE/READ/REQ 분리 조회 (SSO 실사용자 아님 → INNER 소실 특성 확인만: 커서 정상)
    for sp in ("WRITE", "READ", "REQ"):
        o1, o2 = con.cursor(), con.cursor()
        c.callproc(f"SCM_MGR.PKG_SDM1010.P_SDM1010_GET_POP_PJT_AUTH_{sp}", [key, "81", US, o1, o2])
        _ = o1.fetchall()
        check(f"6c. GET_POP_AUTH_{sp} 커서 정상", rc(o2).get("CODE") == "0")

    # 7. SAVE M (WRITING 상태·본인 관리) → 반영
    r = save_tab1("M", key, "ZZ_CRUD_RT_A2", cust=cust, sop="2026-10-01 00:00:00", code=code)
    c.execute("SELECT DPJT_NAME FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", k=key)
    check("7. SAVE(M) 반영", r.get("EVENT") == "1" and c.fetchone()[0] == "ZZ_CRUD_RT_A2", r)

    # 8. GET_PERIOD (M/-1/S ~ M/0/E)
    o1, o2 = con.cursor(), con.cursor()
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_GET_PERIOD", ["M", "-1", "S", "M", "0", "E", US, o1, o2])
    pr = o1.fetchall()
    check("8. GET_PERIOD YMD 4컬럼", len(pr) == 1 and len(pr[0]) == 4 and len(pr[0][1]) == 8, pr)

    # 9. TAB2 — 본인 권한행 (ALL 센티널·날짜 필수 쌍)
    c.execute("""UPDATE SCM_MGR.SPMS_PROJECT_USER_MAP SET USER_ID=:u WHERE DPJT_KEY=:k AND USER_ID='ZZ_U1'""", u=US, k=key)
    con.commit()
    o1, o2 = con.cursor(), con.cursor()
    c.callproc("SCM_MGR.PKG_SDM1010.P_SDM1010_GET_TAB2_PJT_LIST",
               ["ALL", "ALL", "ALL", "ALL", "", "", US, o1, o2])  # 기간 빈값=전체 (지정 시 REG_COMP_DATE NULL 행 제외 — 계약 §5)
    cols2 = [x[0] for x in o1.description]
    rows2 = [dict(zip(cols2, r)) for r in o1.fetchall()]
    check("9. TAB2 본인 권한행 조회 + MY_WORK 리터럴",
          any(x["DPJT_NAME"] == "ZZ_CRUD_RT_A2" and x["MY_WORK"] == "My Work" for x in rows2), f"rows={len(rows2)}")

    # 10. SAVE D (WRITING) → 삭제 + USER_MAP 정리 후 잔존 0
    c.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY=:k", k=key)
    con.commit()
    r = save_tab1("D", key, "ZZ_CRUD_RT_A2", code=code)
    c.execute("SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_NAME LIKE 'ZZ_CRUD_RT%'")
    check("10. SAVE(D) + 잔존 0", r.get("EVENT") == "1" and c.fetchone()[0] == 0, r)
    c.execute("SELECT COUNT(*) FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY=:k", k=key)
    check("10a. USER_MAP 잔존 0", c.fetchone()[0] == 0)

    print(f"\n== 총계: PASS {PASS_CNT} / FAIL {FAIL_CNT}")
    sys.exit(1 if FAIL_CNT else 0)


if __name__ == "__main__":
    main()
