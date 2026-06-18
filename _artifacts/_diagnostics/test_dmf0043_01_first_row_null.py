#!/usr/bin/env python3
"""DMF0043_01 첫 row dynamic 컬럼 NULL 카운트 — PIVOT NVL 적용 검증.

사용법:
  python _artifacts/_diagnostics/test_dmf0043_01_first_row_null.py

환경 변수:
  NSCM_ORA_USER / NSCM_ORA_PASS / NSCM_ORA_DSN (사내 Oracle 연결)

검증 SP: DMF0043_GET_CONTRIBUTION_SALES_LIST
기대값: First row dynamic col NULL count = 0 (모든 dynamic 컬럼이 첫 row 에 값 보유).

NULL > 0 시 적용 hook:
  - _rules_v2/hooks/pivot-dynamic-column-nvl.md §3 (SELECT list NVL wrap 의무)
  - _rules_v2/hooks/sp-patch-file-deploy.md (END;/ + 의존순서 + fallback ALTER COMPILE)
"""
import os
import sys

import oracledb

u, p, d = os.getenv("NSCM_ORA_USER"), os.getenv("NSCM_ORA_PASS"), os.getenv("NSCM_ORA_DSN")
if not (u and p and d):
    sys.exit("ERROR: NSCM_ORA_USER/PASS/DSN env vars required")

# DMF0043_GET_CONTRIBUTION_SALES_LIST 의 IN 파라미터 — analysis 시 정확 시그니처 확인 의무.
# 가정: divisionId / verSeq / versionNo / endCustReport / productGroup / bizType /
#       millionYn / compatibilityYn / sesUserId / mnuId + cursor OUT
# 실제 시그니처는 SCM_ADM_PROC_M PROC_NM='DMF0043_GET_CONTRIBUTION_SALES_LIST' 로 확인.
PROC_NAME = "DMF0043_GET_CONTRIBUTION_SALES_LIST"

# minyonglee1 권한 + DMF0043 의 최근 verSeq 사용 (사내 DB 에 따라 조정 필요)
TEST_PARAMS = {
    "divisionId": "40",
    "verSeq": "",          # 사용자가 실제 verSeq 로 채워야 함 (또는 SP 가 default 처리)
    "versionNo": "",
    "endCustReport": "",
    "productGroup": "ALL",
    "bizType": "ALL",
    "millionYn": "N",
    "compatibilityYn": "N",
    "sesUserId": "minyonglee1",
    "mnuId": "DMF0043_01",
}


def run() -> int:
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        rc = con.cursor()

        # PROC_M 시그니처 확인 — IN 파라미터 순서 (COL_TP_CD='IN', SORT_ORD 순)
        cur.execute(
            """
            SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD
              FROM SCM_MGR.SCM_ADM_PROC_M
             WHERE PROC_NM = :p
             ORDER BY SORT_ORD
            """,
            p=PROC_NAME,
        )
        params_meta = cur.fetchall()
        in_params = [m for m in params_meta if m[1] == "IN"]
        print(f"PROC_M 시그니처 ({PROC_NAME}):")
        for col_nm, col_tp, data_tp, sort in params_meta:
            print(f"  {sort:3d}  {col_tp:10s} {data_tp:12s} {col_nm}")
        print()

        # callproc — IN 파라미터를 TEST_PARAMS 에서 순서대로 채움 + 마지막에 cursor 추가
        try:
            in_values = [TEST_PARAMS.get(m[0], "") for m in in_params]
            cur.callproc(PROC_NAME, [*in_values, rc])
        except oracledb.DatabaseError as e:
            print(f"ERROR: callproc 실패 — {e}")
            print("→ TEST_PARAMS 의 verSeq / versionNo 등 채워야 정상 호출 가능.")
            return 1

        cols = [c[0] for c in rc.description]
        # PIVOT dynamic 컬럼 후보: Y#YYYY#CODE, M#YYYYMM#CODE
        dyn = [
            (i, c)
            for i, c in enumerate(cols)
            if c.startswith("Y#") or c.startswith("M#") or "#" in c
        ]
        rows = rc.fetchmany(1)
        if not rows:
            print("(no rows returned — verSeq 가 빈 값이거나 조건 불일치)")
            return 0

        first = rows[0]
        null_cnt = sum(1 for i, _ in dyn if first[i] is None)
        print(
            f"First row dynamic col NULL count: {null_cnt} / {len(dyn)}"
        )
        if null_cnt > 0:
            print()
            print("[NULL 발견 — pivot-dynamic-column-nvl.md §3 fix 적용 의무]")
            print("Sample NULL 컬럼 (first 10):")
            shown = 0
            for i, c in dyn:
                if first[i] is None:
                    print(f"  {c}")
                    shown += 1
                    if shown >= 10:
                        break
        else:
            print("[PASS — 모든 dynamic 컬럼이 첫 row 에 값 보유]")

        rc.close()
        return 0 if null_cnt == 0 else 2


if __name__ == "__main__":
    sys.exit(run())
