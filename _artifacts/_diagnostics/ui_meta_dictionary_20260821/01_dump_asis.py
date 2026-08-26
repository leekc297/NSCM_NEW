#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""01_dump_asis.py — AS-IS(MSSQL) UI Category Setup 메타 전수 덤프.

출력: asis_columns.json (SCM_MST_SHEET_COLUMNS 36열 전건)
      asis_measures.json (SCM_MST_SHEET_MEASURE 26열 전건)
      lookup_domain_asis.json (셀컨트롤/정렬/정렬방식 허용값 — 교차검증용)

값 도메인의 정본은 **TO-BE**(02_dump_tobe.py)다. 여기서 뜨는 AS-IS 판은 **교차검증용**이다.
⚠ 2026-08-21 적재 중에는 TO-BE 가 일시적으로 0행이었다(15:57 LAST_DDL). 적재 완료 후 64,500행으로
   AS-IS 와 동일한 도메인(컨트롤 13종·align C/L/R)을 갖는다. 0행 관측은 그 적재 창의 산물이다.

원칙 (플랜 Phase 0-3): TOP/LIMIT 없이 전건. 부분/찢어진 스냅샷으로 사전을 만들지 않는다.

건수 검증은 고정 기대치가 아니라 **스냅샷 정합성**으로 한다 (00_config 참조):
  clean COUNT == NOLOCK COUNT == sys.partitions rows  이고  두 번 샘플이 동일할 때만 진행.
  AS-IS DEV 는 실제로 적재 중 committed 0 을 반환하는 창이 관측됐다 (2026-08-21).
"""
import sys

import cfg

COL_TABLE = "dbo.SCM_MST_SHEET_COLUMNS"
MEA_TABLE = "dbo.SCM_MST_SHEET_MEASURE"
LOOKUP_TABLE = "dbo.SCM_ADM_LOOKUP_MASTER_DETAIL"
LOOKUP_TYPES = ("CELL_CONTROL_OBJECT_TYPE_CODE", "HORIZONTAL_ALIGN_CODE",
                "DATA_SORT_METHOD", "SHEET_PRSL_YN")


def sample_counts(cur, table):
    """(clean, dirty, partition) 3중 카운트 — 재적재 창 판별용."""
    cur.execute(
        f"""SELECT (SELECT COUNT(*) FROM {table}),
                   (SELECT COUNT(*) FROM {table} WITH (NOLOCK)),
                   (SELECT SUM(p.rows) FROM sys.partitions p
                     WHERE p.object_id=OBJECT_ID(?) AND p.index_id IN (0,1))""",
        table,
    )
    clean, dirty, part = cur.fetchone()
    return int(clean), int(dirty), (int(part) if part is not None else None)


def fetch_all(cur, table):
    """테이블 전건 + 실제 컬럼 순서를 DB 에서 읽어온다 (컬럼목록 추측 금지)."""
    cur.execute(
        "SELECT c.name FROM sys.columns c WHERE c.object_id=OBJECT_ID(?) ORDER BY c.column_id",
        table,
    )
    cols = [r[0] for r in cur.fetchall()]
    if not cols:
        raise SystemExit(f"{table} 컬럼 조회 실패 — 테이블명/권한 확인")
    sel = ", ".join(f"[{c}]" for c in cols)
    cur.execute(f"SELECT {sel} FROM {table}")
    rows = []
    for r in cur.fetchall():
        d = {}
        for c, v in zip(cols, r):
            if hasattr(v, "isoformat"):
                v = v.isoformat(sep=" ")
            d[c] = v
        rows.append(d)
    return cols, rows


def main():
    e = cfg.asis_env()
    print(f"[AS-IS] {e['user']}@{e['host']}:{e['port']}/{e['db']}")
    con = cfg.asis_connect()
    cur = con.cursor()

    bl = cfg.load_baseline()

    # ① 안정 상태 확인 → ② 전건 추출 → ③ 추출 결과가 확정 건수와 같은지 재확인
    n_col = cfg.stable_count(lambda: sample_counts(cur, COL_TABLE), COL_TABLE)
    col_cols, col_rows = fetch_all(cur, COL_TABLE)
    print(f"  {COL_TABLE}: {len(col_rows)}행 / {len(col_cols)}열")
    if len(col_rows) != n_col:
        raise SystemExit(f"[TORN] {COL_TABLE}: 확정 {n_col} vs 추출 {len(col_rows)} — 추출 중 변동. 재실행 필요")
    cfg.report_drift(bl, "asis_columns", len(col_rows))

    n_mea = cfg.stable_count(lambda: sample_counts(cur, MEA_TABLE), MEA_TABLE)
    mea_cols, mea_rows = fetch_all(cur, MEA_TABLE)
    print(f"  {MEA_TABLE}: {len(mea_rows)}행 / {len(mea_cols)}열")
    if len(mea_rows) != n_mea:
        raise SystemExit(f"[TORN] {MEA_TABLE}: 확정 {n_mea} vs 추출 {len(mea_rows)} — 추출 중 변동. 재실행 필요")
    cfg.report_drift(bl, "asis_measures", len(mea_rows))

    # 값 도메인 (셀컨트롤/정렬/정렬방식) — admin 이 관리하는 허용값
    ph = ",".join("?" * len(LOOKUP_TYPES))
    cur.execute(
        f"""SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, DISPLAY_SEQ, VALID_YN
              FROM {LOOKUP_TABLE} WHERE LOOKUP_TYPE IN ({ph})
             ORDER BY LOOKUP_TYPE, DISPLAY_SEQ, SEGMENT1""",
        *LOOKUP_TYPES,
    )
    lk_cols = [d[0] for d in cur.description]
    lookup = [dict(zip(lk_cols, r)) for r in cur.fetchall()]
    by_type = {}
    for r in lookup:
        if r["VALID_YN"] == "Y":
            by_type.setdefault(r["LOOKUP_TYPE"], []).append(r["SEGMENT1"])
    print("  LOOKUP 값도메인: " + ", ".join(f"{k}={len(v)}" for k, v in sorted(by_type.items())))

    cur.close()
    con.close()

    meta = {"source": e["db"], "host": e["host"], "port": e["port"],
            "label": cfg.ASIS_SOURCE_LABEL, "snapshot": cfg.SNAPSHOT_DATE}
    p1 = cfg.jdump({"meta": meta, "columns": col_cols, "rows": col_rows}, "asis_columns.json")
    p2 = cfg.jdump({"meta": meta, "columns": mea_cols, "rows": mea_rows}, "asis_measures.json")
    p3 = cfg.jdump({"meta": meta, "rows": lookup, "by_type": by_type}, "lookup_domain_asis.json")
    cfg.save_baseline(bl)
    for x in (p1, p2, p3):
        print("  -> " + x)


if __name__ == "__main__":
    sys.exit(main())
