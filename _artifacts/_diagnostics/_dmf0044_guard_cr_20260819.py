#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0044_guard_cr_20260819.py — PKG_DMF0044 CR 경로 빈 버전 가드 추가 (사용자 요구 2026-08-19)

배경: DMF0044 Version Modal 에서 원장 0행 버전(예: 클라우드 SP_W_20260806_V001)으로 CR 실행 시
SQL 오류가 그대로 노출. CP 경로에는 NODATAGUARD(2026-08-10)가 있으나 CR 경로에는 부재.
조치: CR 의 실적 기준일 산출 직후, 원장(DM_PLN_SALES_PLAN_C) 0행이면 기존 e_validation +
'SOURCE_VERSION_EMPTY' 안내로 반환 (패키지 기존 관례 재사용 — 마커 [E20260819-NODATAGUARD-CR]).
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

OLD = """\t\t\tEXCEPTION WHEN NO_DATA_FOUND THEN d_Result_Date := NULL;
\t\t\tEND;
\t\tELSIF p_action_type = 'CP' THEN"""

NEW = """\t\t\tEXCEPTION WHEN NO_DATA_FOUND THEN d_Result_Date := NULL;
\t\t\tEND;

\t\t\t-- [E20260819-NODATAGUARD-CR] 빈 원본 버전 가드 (사용자 요구 2026-08-19):
\t\t\t--   원장(DM_PLN_SALES_PLAN_C) 0행 버전으로 CR 진행 시 SQL 오류가 그대로 노출되던 결함.
\t\t\t--   CP 경로의 NODATAGUARD(2026-08-10)와 대칭 — 기존 SOURCE_VERSION_EMPTY 안내 재사용.
\t\t\tBEGIN
\t\t\t\tSELECT 1 INTO n_log_count FROM DM_PLN_SALES_PLAN_C
\t\t\t\t WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no AND ROWNUM = 1;
\t\t\tEXCEPTION WHEN NO_DATA_FOUND THEN
\t\t\t\tv_log_type := 'SOURCE_VERSION_EMPTY'; RAISE e_validation;
\t\t\tEND;
\t\tELSIF p_action_type = 'CP' THEN"""

OUT = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0044_BODY_NLS1861_NODATAGUARDCR_20260819.sql"


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute(
        """SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
           AND TYPE='PACKAGE BODY' ORDER BY LINE"""
    )
    body = "CREATE OR REPLACE " + "".join(r[0] for r in cur.fetchall()).rstrip() + "\n/\n"
    cnt = body.count(OLD)
    assert cnt == 1, f"앵커 {cnt}건 (1 기대)"
    body = body.replace(OLD, NEW)
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        f.write(body)
    cur.execute(body.rstrip().rstrip("/").rstrip())
    cur.execute(
        "SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044'"
    )
    print("적용 후:", cur.fetchall())
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'")
    print("ALL_ERRORS:", cur.fetchone()[0])
    for mk in ("E20260819-NLS1861", "E20260819-NODATAGUARD-CR"):
        cur.execute(
            """SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
               AND TYPE='PACKAGE BODY' AND TEXT LIKE '%' || :m || '%'""",
            {"m": mk},
        )
        print(f"마커 {mk}:", cur.fetchone()[0])
    cur.close()
    con.close()
    print("클라우드 적용 파일:", OUT)


if __name__ == "__main__":
    main()
