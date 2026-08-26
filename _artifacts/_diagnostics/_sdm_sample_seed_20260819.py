#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_sdm_sample_seed_20260819.py — SDM1010/1020 샘플 프로젝트 5건 시드 (사용자 요청 2026-08-19)

설계서 GRID 목업(자동차 사업부) 계열 명칭 + lookup 실값 조합. GET INNER JOIN 8축 전부 통과하도록
lookup 에서 유효 (CELL_TYPE, STACK_METHOD) 쌍·BIZ_TYPE·DPJT_CLASS 를 실측 선정.
나의 권한 다양화: ADMIN 2 / WRITE 1 / READ 1 / 권한없음 1 (minyonglee1 기준).
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

USER = "minyonglee1"


def pick(cur, sql, n):
    cur.execute(sql)
    rows = cur.fetchall()
    assert rows, f"lookup 0행: {sql[:80]}"
    return [rows[i % len(rows)] for i in range(n)]


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()

    # 유효 lookup 실값 선정 (division 40)
    # 오늘 CRUD 왕복에서 GET 8축 INNER JOIN 통과가 실증된 조합으로 고정
    pairs = [("PRISM", "AZS")] * 5
    bizs = pick(cur, """SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='DM_BIZ_TYPE' AND VALID_YN='Y' ORDER BY DISPLAY_SEQ""", 5)
    clss = pick(cur, """SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='SPMS_DPJT_CLASS' AND VALID_YN='Y' ORDER BY DISPLAY_SEQ""", 5)
    cur.execute("""SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND VALID_YN='Y'""")
    valid_status = {r[0] for r in cur.fetchall()}
    print("유효 상태코드:", sorted(valid_status))

    def status(want, fb="COMPLETE"):
        return want if want in valid_status else fb

    samples = [
        ("26VW01", "MC25",          status("COMPLETE"), "ADMIN"),
        ("26VW02", "MC26",          status("COMPLETE"), "ADMIN"),
        ("26GM01", "Prismatic PJT", status("WAITING"),  "WRITE"),
        ("26TY01", "Toyota 60PL",   status("COMPLETE"), "READ"),
        ("26HK01", "Affordable EV", status("REJECT"),   None),  # 권한없음
    ]
    n_mst = n_map = 0
    for i, (code, name, st, auth) in enumerate(samples):
        key = f"{code}_000001"
        ct, sm = pairs[i]
        cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_USER_MAP WHERE DPJT_KEY=:k", {"k": key})
        cur.execute("DELETE FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_KEY=:k", {"k": key})
        cur.execute(
            """INSERT INTO SCM_MGR.SPMS_PROJECT_MST
                 (DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_NAME, DIVISION_ID, DPJT_CLASS, END_CUSTOMER,
                  CELL_TYPE, BIZ_TYPE, STACK_METHOD, SOP_DATE, SOP_PLANT_ID,
                  MGMT_USER_ID, CNFM_USER_ID, DPJT_REG_STATUS,
                  REG_REQ_DATE, REG_MOD_DATE, REG_COMP_DATE, DPJT_REG_CAT, DPJT_MGMT_STATUS,
                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
               VALUES
                 (:k, :c, 1, :n, '40', :cl, '-',
                  :ct, :bz, :sm, ADD_MONTHS(TRUNC(SYSDATE), 5), '-',
                  :mu, :mu, :st,
                  TRUNC(SYSDATE)-10, NULL, TRUNC(SYSDATE)-:off, 'NEW', 'TEMP',
                  'admin', SYSDATE, 'admin', SYSDATE)""",
            {"k": key, "c": code, "n": name, "cl": clss[i][0], "ct": ct, "bz": bizs[i][0],
             "sm": sm, "mu": USER, "st": st, "off": i + 1},
        )
        n_mst += 1
        if auth:
            cur.execute(
                """INSERT INTO SCM_MGR.SPMS_PROJECT_USER_MAP
                     (DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_CODE, DPJT_SEQ,
                      DPJT_NAME, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:k, :u, :a, 'CONFIRM', :c, 1, :n,
                           'admin', SYSDATE, 'admin', SYSDATE)""",
                {"k": key, "u": USER, "a": auth, "c": code, "n": name},
            )
            n_map += 1
        print(f"  {key} {name}: 상태={st} 권한={auth or '없음'} CT={ct}/SM={sm}/BIZ={bizs[i][0]}/CLS={clss[i][0]}")
    con.commit()
    print(f"시드 완료: MST {n_mst} / USER_MAP {n_map}")

    # GET 실측 (minyonglee1, 기간 최근 40일)
    rc1 = cur.var(oracledb.DB_TYPE_CURSOR)
    rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.execute(
        """BEGIN SCM_MGR.PKG_SDM1020.P_SDM1020_GET_PJT_LIST(
             '40','ALL','ALL','ALL',
             TO_CHAR(TRUNC(SYSDATE)-40,'YYYY-MM-DD'), TO_CHAR(TRUNC(SYSDATE),'YYYY-MM-DD'),
             :usr, :c1, :c2); END;""",
        {"usr": USER, "c1": rc1, "c2": rc2},
    )
    rows = rc1.getvalue().fetchall()
    print(f"GET 실측: {len(rows)}행 (기대 5)")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
