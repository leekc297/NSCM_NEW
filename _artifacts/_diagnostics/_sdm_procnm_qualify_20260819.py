#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_sdm_procnm_qualify_20260819.py — SDM PROC_M 스키마 접두 부여 (PLS-00201 해소)

원인(실측): BE 로컬 계정 SCMP_APP 에 PKG_SDM1010/PKG_SDM1020 개인 시노님 부재
(타 PKG 63본은 시노님 보유 — 관례). SCM_MGR 은 CREATE ANY SYNONYM 권한 없음(ORA-01031, DBA 영역).
즉시 해결: PROC_M.PROC_NM 에 'SCM_MGR.' 접두 부여 — generic call-proc 은 PROC_NM 그대로
'{call ...}' 를 만들므로 스키마 한정명이면 시노님 없이 EXECUTE 권한만으로 해석된다.
(정석 = DBA/SCMP_APP 계정으로 시노님 생성 — 생성 후 원복 여부는 사용자 선택)
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
              SET PROC_NM = 'SCM_MGR.' || PROC_NM, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
            WHERE PROC_NM LIKE 'PKG_SDM10%'"""
    )
    print("PROC_NM 접두 부여:", cur.rowcount, "행")
    con.commit()
    cur.execute("SELECT DISTINCT PROC_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%SDM10%' ORDER BY 1")
    for r in cur.fetchall():
        print("  ", r[0])
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
