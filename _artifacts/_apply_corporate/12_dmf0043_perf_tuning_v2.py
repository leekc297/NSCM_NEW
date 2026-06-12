#!/usr/bin/env python3
"""
DMF0043 / DMF0043_01 성능 튜닝 v2 (추가 옵션).

이전 (script 11): DTL 8-key 인덱스 + stats — 메인 grid 측 효과 큼.
DMF0043_01 (DMF0043_GET_CONTRIBUTION_SALES_LIST) 여전히 느림 — 추가 옵션 순차 적용.

옵션:
  A) SCM_MST_SITE_ITEM (REGEXP_SUBSTR(OWNER, '[^,]+', 1, 1)) 함수 기반 인덱스
     - TEAM 서브쿼리 JOIN 의 핵심 매칭 키. 일반 인덱스 못 씀.
  B) DM_PLN_SALES_PLAN_REPORT_C (VERSION_NO, MEASURE, DIVISION_ID, YYYYMMDD) 인덱스
     - PK 가 16-col wide 라 MEASURE/YYYYMMDD filter 가 늦게 적용. 좁은 인덱스 추가.
  C) Stats 새로고침 (PLAN_REPORT_C / SITE_ITEM / SSO 3종)

모두 ONLINE / NOLOGGING / COMPRESS 로 lock 최소화.
"""
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

STEPS = [
    (
        "FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1",
        """
        CREATE INDEX FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1
        ON SCM_MST_SITE_ITEM (REGEXP_SUBSTR(OWNER, '[^,]+', 1, 1))
        NOLOGGING ONLINE
        """,
        "A. 함수 기반 인덱스 (REGEXP_SUBSTR OWNER 첫 token)",
    ),
    (
        "IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD",
        """
        CREATE INDEX IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD
        ON DM_PLN_SALES_PLAN_REPORT_C
          (VERSION_NO, MEASURE, DIVISION_ID, YYYYMMDD)
        NOLOGGING COMPRESS 3 ONLINE
        """,
        "B. PLAN_REPORT_C 좁은 4-key 인덱스 (PK 16-col 우회)",
    ),
]


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_PERF_TUNING_V2.log"
    log_lines = [
        f"=== PERF TUNING v2: DMF0043_01 (FBI + PLAN_REPORT_C index) ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        cur = conn.cursor()

        # Apply each index step
        for idx_name, ddl, label in STEPS:
            log_lines.append(f"\n--- {label} ---")
            cur.execute(
                "SELECT COUNT(*) FROM USER_INDEXES WHERE INDEX_NAME=:n", n=idx_name
            )
            if cur.fetchone()[0] > 0:
                log_lines.append(f"  [SKIP] {idx_name} 이미 존재")
                continue
            t0 = datetime.datetime.now()
            try:
                cur.execute(ddl.strip())
                conn.commit()
                dt = (datetime.datetime.now() - t0).total_seconds()
                log_lines.append(f"  [OK] CREATE INDEX {idx_name} ({dt:.1f}s)")
            except oracledb.DatabaseError as e:
                log_lines.append(f"  [ERR] {idx_name}: {e}")

        # C. Stats refresh (3 tables, parallel)
        log_lines.append(f"\n--- C. Stats 새로고침 (3 tables, AUTO_SAMPLE_SIZE) ---")
        for tbl in ["DM_PLN_SALES_PLAN_REPORT_C", "SCM_MST_SITE_ITEM",
                    "SCM_MST_SSO_USER_INFO", "SCM_MST_SSO_DEPT_INFO"]:
            t0 = datetime.datetime.now()
            try:
                cur.execute(f"""
                    BEGIN
                      DBMS_STATS.GATHER_TABLE_STATS(
                        ownname     => USER,
                        tabname     => '{tbl}',
                        cascade     => TRUE,
                        method_opt  => 'FOR ALL INDEXED COLUMNS SIZE AUTO',
                        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
                        degree      => 4
                      );
                    END;
                """)
                dt = (datetime.datetime.now() - t0).total_seconds()
                log_lines.append(f"  [OK] {tbl} ({dt:.1f}s)")
            except oracledb.DatabaseError as e:
                log_lines.append(f"  [WARN] {tbl}: {e}")

        # EXPLAIN PLAN — verify new FBI / index pickup
        log_lines.append(f"\n--- EXPLAIN PLAN: 핵심 JOIN simulation ---")
        try:
            cur.execute("""
                EXPLAIN PLAN FOR
                SELECT /*+ */ COUNT(*)
                  FROM DM_PLN_SALES_PLAN_REPORT_C P
                       INNER JOIN SCM_MST_SITE_ITEM I
                              ON P.DIVISION_ID=I.DIVISION_ID AND P.PROJECT_CODE=I.PROJECT_CODE
                             AND P.SCM_SITE_ID=I.SCM_SITE_ID AND P.ITEM_ID=I.ITEM_ID
                       LEFT JOIN SCM_MST_SSO_USER_INFO U
                              ON U.USER_ID = REGEXP_SUBSTR(I.OWNER, '[^,]+', 1, 1)
                 WHERE P.DIVISION_ID='40'
                   AND P.VERSION_NO='R_S_20251126_V002_C'
                   AND P.MEASURE='SalesAmt_USD'
            """)
            cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,NULL,'BASIC +PARTITION'))")
            for r in cur.fetchall():
                log_lines.append(f"  {r[0]}")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [WARN] EXPLAIN: {e}")

        cur.close()
        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        print(f"[OK] 튜닝 v2 완료 — see {log_file}")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
