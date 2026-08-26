#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_sdm_procnm_revert_20260819.py — SDM PROC_NM 접두 원복

PLS-00306 원인: BE 파라미터 목록은 PKG_NSCM_UI_COMM.PR_GET_API_INFO_LIST 가 무접두 PROC_NM
조인으로 생성 — 접두 부여가 조인을 깨 0-인자 호출이 됨. DBA 시노님 생성 완료(사용자 확인)
→ 무접두 관례로 원복이 정석.
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute(
        """UPDATE SCM_MGR.SCM_ADM_PROC_M
              SET PROC_NM = REPLACE(PROC_NM, 'SCM_MGR.PKG_SDM10', 'PKG_SDM10'),
                  LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
            WHERE PROC_NM LIKE 'SCM_MGR.PKG_SDM10%'"""
    )
    print("원복:", cur.rowcount, "행")
    con.commit()
    cur.execute(
        "SELECT DISTINCT PROC_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%SDM1020%'"
    )
    print("확인:", cur.fetchall())
    # 시노님 실존 재확인 (DBA 생성분)
    cur.execute(
        """SELECT OWNER, SYNONYM_NAME FROM DBA_SYNONYMS
           WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME IN ('PKG_SDM1010','PKG_SDM1020')"""
    )
    print("시노님:", cur.fetchall())
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
