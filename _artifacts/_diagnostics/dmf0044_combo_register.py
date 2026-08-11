#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_combo_register.py — DMF0044 그리드 행별 콤보 2종 신규 등록 (2026-08-09, 사용자 승인)

배경: AS-IS DMF0044 는 `.cs` 가 런타임에 `SetCellTypeCombo` 로 DEPT_ID 콤보를 붙인다
      (InsertRow L990~991 / spdMain_Changed L1180·L1196). SHEET_COLUMNS 메타에는 AS-IS 도 없다.
      TO-BE 는 이 런타임 바인딩분이 미이관이라 **신규행에서 팀을 자유 텍스트로 입력**하고 있었다.
      TO-BE 등가 = 상위 콤보 superset 을 받아 `GRID_CASCADE_FILTERS` 로 **행 컨텍스트 클라 필터**
      (DMF0042 선례 hook #59 §5-G). 그 원천 콤보 2종이 미등록이라 여기서 등록한다.

등록 대상 (AS-IS `UP_FX_GetCommonDataList` 원문 1:1):
  · DMF0044_DEPARTMENT_TEAM          (AS-IS L5028~) — @Param1 = UPPER_DEPT_ID 로 팀 조회
      TO-BE 는 행별 서버호출 대신 superset + 클라 필터라 **부모키 컬럼(DEPARTMENT_ID)을 함께 반환**한다.
      (신규 콤보이므로 컬럼 추가 제약 없음 — 공유 콤보 SQL 변경 금지 룰의 대상이 아니다)
  · DMF0044_ETC_SALE_RESULT_TYPE_40  (AS-IS L5006~) — 파라미터 없음, lookup 그대로

⚠ INSERT-only. 기존재 시 건너뛴다(MERGE INTO/DELETE 금지 — memory corp-meta-integrity).
  감사컬럼은 'admin' 고정(memory meta-audit-column-admin-only).
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROWS = [
    {
        "SQL_ID": "DMF0044_DEPARTMENT_TEAM",
        "MDU_DIVS_CD": "DM",
        "SQL_NM": "[C] AS-IS UP_FX DMF0044_DEPARTMENT_TEAM — Dept→Team (superset+클라 cascade, 부모키 동반)",
        "SQL_DTL_CTN": (
            "SELECT D.DEPT_ID AS CODE\n"
            "     , D.DEPT_NAME_KO AS NAME\n"
            "     , D.UPPER_DEPT_ID AS DEPARTMENT_ID\n"
            "  FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO D\n"
            " WHERE D.VALID_YN = 'Y'\n"
            "   AND D.UPPER_DEPT_ID IS NOT NULL\n"
            " ORDER BY D.DEPT_NAME_KO"
        ),
    },
    {
        "SQL_ID": "DMF0044_ETC_SALE_RESULT_TYPE_40",
        "MDU_DIVS_CD": "DM",
        "SQL_NM": "[C] AS-IS UP_FX DMF0044_ETC_SALE_RESULT_TYPE_40 — DEPARTMENT_ID='기타' 시 DEPT_ID 후보",
        "SQL_DTL_CTN": (
            "SELECT L.SEGMENT1 AS CODE\n"
            "     , L.SEGMENT2 AS NAME\n"
            "  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L\n"
            " WHERE L.LOOKUP_TYPE = 'DMF0044_ETC_SALE_RESULT_TYPE_40'\n"
            "   AND L.VALID_YN = 'Y'"
        ),
    },
]

INS = """INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
 (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 VALUES (:sql_id, :divs, :nm, :ctn, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)"""


def run(apply_it):
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        # ⭐ DDL 길이 사전검증 — 추측 금지(memory ddl-grep-before-sql). 2026-08-09 실측:
        #   SQL_NM 이 VARCHAR2(100) 인데 164자를 넣어 ORA-12899 를 냈다. 넣기 전에 잰다.
        cur.execute("""SELECT COLUMN_NAME, DATA_LENGTH FROM ALL_TAB_COLUMNS
                        WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_CMBO_SQL_M'
                          AND COLUMN_NAME IN ('SQL_ID','MDU_DIVS_CD','SQL_NM','SQL_DTL_CTN')""")
        lim = dict(cur.fetchall())
        over = []
        for r in ROWS:
            for col in ("SQL_ID", "MDU_DIVS_CD", "SQL_NM", "SQL_DTL_CTN"):
                n = len(r[col].encode("utf-8"))
                if col in lim and n > lim[col]:
                    over.append("%s.%s = %d byte > %d" % (r["SQL_ID"], col, n, lim[col]))
        if over:
            for o in over:
                print("  ⛔ 길이 초과: %s" % o)
            return 1
        for r in ROWS:
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s",
                        {"s": r["SQL_ID"]})
            exists = cur.fetchone()[0]
            if exists:
                print("[skip] %s — 이미 등록됨(INSERT-only 규약)" % r["SQL_ID"])
                continue
            # 등록 전 **SQL 자체가 도는지** 실행해 본다. 0행/오류인 콤보를 등록하면 조용한 빈 콤보가 된다.
            try:
                cur.execute("SELECT COUNT(*) FROM (%s)" % r["SQL_DTL_CTN"])
                n = cur.fetchone()[0]
            except Exception as e:  # noqa: BLE001
                print("[FAIL] %s — SQL 실행 오류: %s" % (r["SQL_ID"], str(e)[:120]))
                return 1
            print("[ok] %s — 실행 검증 %d행" % (r["SQL_ID"], n))
            if n == 0:
                print("  ⛔ 0행 — 등록해도 빈 콤보다. 원천 확인 필요")
                return 1
            if apply_it:
                cur.execute(INS, {"sql_id": r["SQL_ID"], "divs": r["MDU_DIVS_CD"],
                                  "nm": r["SQL_NM"], "ctn": r["SQL_DTL_CTN"]})
                print("  → INSERT 완료")
        if apply_it:
            con.commit()
            cur.execute(
                "SELECT SQL_ID, USE_YN, CREATED_BY FROM SCM_MGR.SCM_ADM_CMBO_SQL_M "
                "WHERE SQL_ID IN ('DMF0044_DEPARTMENT_TEAM','DMF0044_ETC_SALE_RESULT_TYPE_40') ORDER BY 1")
            print("\n[검증] 등재 확인")
            for row in cur.fetchall():
                print("  %-34s USE_YN=%s CREATED_BY=%s" % row)
        else:
            print("\n(미적용 — --apply 로 실행)")
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()
    sys.exit(run(a.apply))


if __name__ == "__main__":
    main()
