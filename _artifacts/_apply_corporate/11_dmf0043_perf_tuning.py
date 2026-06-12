#!/usr/bin/env python3
"""
DMF0043 / DMF0043_01 성능 튜닝.

진단:
  - DM_MST_CONTRIBUTE_RATIO_DTL (1.5M rows) 에 인덱스 0건 — 모든 JOIN full scan
  - DMF0043_GET_CONTRIBUTE_MAIN_DATA + DMF0043_GET_CONTRIBUTION_SALES_LIST 둘 다 영향

Fix:
  1) CREATE INDEX (VER_SEQ + 6 join keys + YYYYMM) — ONLINE / NOLOGGING / COMPRESS
  2) GATHER STATS (인덱스 + 테이블)
  3) (optional) MST 측 통계도 새로고침

ROW count 1.5M / 컬럼 8 / 추정 인덱스 size ~150MB. USERS tablespace 여유 35GB.
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

INDEX_NAME = "IDX01_DM_MST_CONTRIBUTE_RATIO_DTL"
INDEX_DDL = f"""
CREATE INDEX {INDEX_NAME}
ON DM_MST_CONTRIBUTE_RATIO_DTL
  (VER_SEQ, DEPARTMENT_ID, DEPT_ID,
   END_CUST_REPORT, SOLDTO_CUST_REPORT,
   PRODUCT_GROUP, DM_BIZ_TYPE, YYYYMM)
NOLOGGING
COMPRESS 4
ONLINE
""".strip()


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_PERF_TUNING.log"
    log_lines = [
        f"=== PERF TUNING: DMF0043 GET SPs (DTL index + stats) ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        cur = conn.cursor()

        # 0. PRE-CHECK: 이미 index 있나
        cur.execute(
            "SELECT COUNT(*) FROM USER_INDEXES WHERE INDEX_NAME=:n", n=INDEX_NAME
        )
        if cur.fetchone()[0] > 0:
            log_lines.append(f"  [SKIP] {INDEX_NAME} 이미 존재")
        else:
            t0 = datetime.datetime.now()
            log_lines.append(f"  [STEP 1] CREATE INDEX {INDEX_NAME} (8 col COMPRESS 4 ONLINE)")
            try:
                cur.execute(INDEX_DDL)
                conn.commit()
                dt = (datetime.datetime.now() - t0).total_seconds()
                log_lines.append(f"           [OK] {dt:.1f}s")
            except oracledb.DatabaseError as e:
                log_lines.append(f"           [ERR] {e}")
                log_file.write_text("\n".join(log_lines), encoding="utf-8")
                print(f"[ERR] CREATE INDEX 실패 — see {log_file}")
                return 2

        # STEP 2: GATHER STATS on index + table
        t0 = datetime.datetime.now()
        log_lines.append(f"  [STEP 2] GATHER STATS (table + index)")
        try:
            cur.execute("""
                BEGIN
                  DBMS_STATS.GATHER_TABLE_STATS(
                    ownname     => USER,
                    tabname     => 'DM_MST_CONTRIBUTE_RATIO_DTL',
                    cascade     => TRUE,
                    method_opt  => 'FOR ALL INDEXED COLUMNS SIZE AUTO',
                    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
                    degree      => 4
                  );
                END;
            """)
            dt = (datetime.datetime.now() - t0).total_seconds()
            log_lines.append(f"           [OK] {dt:.1f}s")
        except oracledb.DatabaseError as e:
            log_lines.append(f"           [WARN] stats 실패 (인덱스는 살림): {e}")

        # STEP 3: 검증 — index 가 cardinality 식별하는지
        cur.execute("""
            SELECT INDEX_NAME, NUM_ROWS, DISTINCT_KEYS, LEAF_BLOCKS, STATUS
              FROM USER_INDEXES WHERE INDEX_NAME=:n
        """, n=INDEX_NAME)
        row = cur.fetchone()
        if row:
            log_lines.append(
                f"  [STEP 3] {row[0]} stats: rows={row[1]} distinct_keys={row[2]} leafBlocks={row[3]} status={row[4]}"
            )

        # STEP 4: VER_SEQ=12 sample lookup explain
        cur.execute("""
            EXPLAIN PLAN FOR
            SELECT COUNT(*) FROM DM_MST_CONTRIBUTE_RATIO_DTL
             WHERE VER_SEQ=12 AND DEPARTMENT_ID='58691249' AND DEPT_ID='70000479'
               AND END_CUST_REPORT='IM' AND SOLDTO_CUST_REPORT='IM'
               AND PRODUCT_GROUP='N' AND DM_BIZ_TYPE='CELL' AND YYYYMM='202401'
        """)
        log_lines.append(f"  [STEP 4] EXPLAIN PLAN (sample point lookup):")
        cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,NULL,'BASIC'))")
        for r in cur.fetchall():
            log_lines.append(f"     {r[0]}")

        cur.close()

        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        print(f"[OK] 튜닝 완료 — see {log_file}")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
