#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""02_dump_tobe.py — TO-BE(Oracle SCM_MGR) 메타 + 값도메인 전수 덤프.

출력: tobe_columns.json / tobe_measures.json / cmbo_meta.json / lookup_domain_tobe.json

값 도메인(셀컨트롤·정렬·정렬방식)의 **정본은 TO-BE** 다. AS-IS 판(lookup_domain_asis.json)은 교차검증용.
⚠ 원천이 0행이면 중단한다 — 적재 중 스냅샷으로 "허용값 없음" 사전을 만들면 전 컬럼이 위반이 된다
   (2026-08-21 15:57 적재 창에서 실제로 0행을 관측했다).
"""
import re
import sys

NL_ = chr(10)

import cfg

OWNER = "SCM_MGR"
COL_TABLE = "SCM_MST_SHEET_COLUMNS"
MEA_TABLE = "SCM_MST_SHEET_MEASURE"


def fetch_all(cur, table):
    cur.execute(
        """SELECT column_name FROM all_tab_columns
            WHERE owner=:o AND table_name=:t ORDER BY column_id""",
        o=OWNER, t=table,
    )
    cols = [r[0] for r in cur.fetchall()]
    if not cols:
        raise SystemExit(f"{OWNER}.{table} 컬럼 조회 실패")
    sel = ", ".join(f'"{c}"' for c in cols)
    cur.execute(f"SELECT {sel} FROM {OWNER}.{table}")
    rows = []
    for r in cur.fetchall():
        d = {}
        for c, v in zip(cols, r):
            if hasattr(v, "isoformat"):
                v = v.isoformat(sep=" ")
            elif hasattr(v, "read"):          # CLOB
                v = v.read()
            d[c] = v
        rows.append(d)
    return cols, rows


def main():
    con = cfg.tobe_connect()
    cur = con.cursor()
    print(f"[TO-BE] {con.dsn if hasattr(con, 'dsn') else 'oracle'}")

    bl = cfg.load_baseline()

    col_cols, col_rows = fetch_all(cur, COL_TABLE)
    print(f"  {COL_TABLE}: {len(col_rows)}행 / {len(col_cols)}열")
    cfg.report_drift(bl, "tobe_columns", len(col_rows))

    mea_cols, mea_rows = fetch_all(cur, MEA_TABLE)
    print(f"  {MEA_TABLE}: {len(mea_rows)}행 / {len(mea_cols)}열")
    cfg.report_drift(bl, "tobe_measures", len(mea_rows))

    # 콤보 레지스트리 — @토큰은 BE makeComboQuery 와 동일 정규식으로 파싱
    cur.execute(
        """SELECT SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN
             FROM SCM_MGR.SCM_ADM_CMBO_SQL_M ORDER BY SQL_ID, MDU_DIVS_CD"""
    )
    cmbo = []
    for sql_id, mdu, nm, ctn, use_yn in cur.fetchall():
        body = ctn.read() if hasattr(ctn, "read") else (ctn or "")
        cmbo.append({
            "SQL_ID": sql_id, "MDU_DIVS_CD": mdu, "SQL_NM": nm, "USE_YN": use_yn,
            "TOKENS": sorted(set(re.findall(r"@\w+", body))),
            "SQL_DTL_CTN": body,
        })
    print(f"  SCM_ADM_CMBO_SQL_M: {len(cmbo)}건")
    cfg.report_drift(bl, "cmbo", len(cmbo))

    # 값 도메인 — admin 이 관리하는 허용값 (FE enum 과 교차 기준)
    lk_state = {}
    for t in ("SCM_ADM_LOOKUP_MASTER_DETAIL", "SCM_ADM_LOOKUP_MASTER",
              "SCM_ADM_LOOKUP_MASTER_DETAIL_H", "SCM_CODE_LOOKUP_VALUE"):
        cur.execute(f"SELECT COUNT(*) FROM {OWNER}.{t}")
        lk_state[t] = cur.fetchone()[0]
    print("  TO-BE lookup 실태: " + ", ".join(f"{k}={v}행" for k, v in lk_state.items()))
    if lk_state["SCM_ADM_LOOKUP_MASTER_DETAIL"] == 0:
        raise SystemExit(
            "[LOOKUP EMPTY] SCM_ADM_LOOKUP_MASTER_DETAIL 0행 — 적재 중 스냅샷으로 판단됩니다." + NL_
            + "  이 상태로 사전을 만들면 허용값이 비어 전 컬럼이 위반으로 뒤집힙니다. 적재 완료 후 재실행하십시오.")

    cur.execute(
        """SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, DISPLAY_SEQ, VALID_YN
             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE IN ('CELL_CONTROL_OBJECT_TYPE_CODE','HORIZONTAL_ALIGN_CODE',
                                  'DATA_SORT_METHOD','SHEET_PRSL_YN')
            ORDER BY LOOKUP_TYPE, DISPLAY_SEQ, SEGMENT1"""
    )
    lk_cols = [d[0] for d in cur.description]
    lookup = [dict(zip(lk_cols, r)) for r in cur.fetchall()]
    by_type = {}
    for r in lookup:
        if r["VALID_YN"] == "Y":
            by_type.setdefault(r["LOOKUP_TYPE"], []).append(r["SEGMENT1"])
    print("  LOOKUP 값도메인(TO-BE 정본): "
          + ", ".join(f"{k}={len(v)}" for k, v in sorted(by_type.items())))

    cur.close()
    con.close()

    meta = {"owner": OWNER, "snapshot": cfg.SNAPSHOT_DATE}
    for obj, name in (
        ({"meta": meta, "columns": col_cols, "rows": col_rows}, "tobe_columns.json"),
        ({"meta": meta, "columns": mea_cols, "rows": mea_rows}, "tobe_measures.json"),
        (cmbo, "cmbo_meta.json"),
        ({"meta": meta, "rows": lookup, "by_type": by_type,
          "row_counts": lk_state}, "lookup_domain_tobe.json"),
    ):
        print(f"  → {cfg.jdump(obj, name)}")
    cfg.save_baseline(bl)


if __name__ == "__main__":
    sys.exit(main())
