#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DMF0082 Division 81/40 분기 — 사전 진단 (읽기 전용, 단일 커넥션)
플랜: zany-wondering-sundae.md §전체 실행 순서 1
출력: stdout 요약 + SP 소스 추출본은 --outdir 하위 파일

진단 항목:
  D1. 81/40 6쌍 테이블 컬럼 인벤토리 (CELL_PROD_SITE_ID/END_CUSTOMER 부재 확인, ATTRIBUTE 길이)
  D2. DM_PLN_MKT_FCST / SCM_MST_FUTURE_PRICE DISTINCT DIVISION_ID (LIKE '81%' 커버리지)
  D3. 81 measure 인벤토리 (MKT_AMT/SCM_FCST 존재 여부 → MERGE 필터·skip 확정)
  D4. SEQ1_DM_PLN_MKT_FCST_H / SEQ1_SCM_MST_FUTURE_PRICE_H 존재
  D5. PR_DM_PLN_CFM_TO_MKT_FCST 소스 추출 (전파 범위 → 게이트 분류)
  D6. 라이브 SP 4종 소스 추출 (SAVE diff 0 확인용 + 적용 시 백업 원본)
  D7. _C 테이블 VERSION_NO 체계 (컬럼 존재 + DM_MST_VERSION 대비)
  D8. SP 4종 ALL_ARGUMENTS (시그니처 불변 사전 검증)
  D9. SHEET_COLUMNS / SHEET_MEASURE division별 메타 카운트
"""
import os, sys, io, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / "_diagnostics"))
from ora import conn_info  # noqa: E402

import oracledb  # noqa: E402

OUTDIR = pathlib.Path(sys.argv[sys.argv.index("--outdir") + 1]) if "--outdir" in sys.argv else pathlib.Path(".")
OUTDIR.mkdir(parents=True, exist_ok=True)

T81 = ["DM_PLN_MKT_FCST", "DM_PLN_MKT_FCST_H", "DM_PLN_MKT_FCST_C",
       "SCM_MST_FUTURE_PRICE", "SCM_MST_FUTURE_PRICE_H", "SCM_MST_FUTURE_PRICE_C"]
T40 = ["DM_PLN_CFM_MKT_DEMAND_PLAN", "DM_PLN_CFM_MKT_DEMAND_PLAN_H", "DM_PLN_CFM_MKT_DEMAND_PLAN_C",
       "DM_PLN_CFM_SELLING_PRICE", "DM_PLN_CFM_SELLING_PRICE_H", "DM_PLN_CFM_SELLING_PRICE_C"]
SPS = ["DMF0082_SAVE_MAIN_DATA", "DMF0082_GET_MAIN_DATA_CURRENT",
       "DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP"]


def rows(cur, sql, **binds):
    cur.execute(sql, binds)
    return cur.fetchall()


def section(title):
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


def extract_source(cur, name, obj_type_filter=None):
    """ALL_SOURCE 기반 추출 (GET_DDL 은 권한 이슈 시 실패하므로 SOURCE 우선)"""
    r = rows(cur, """
        SELECT TYPE, LINE, TEXT FROM ALL_SOURCE
        WHERE OWNER='SCM_MGR' AND NAME=:n
        ORDER BY TYPE, LINE""", n=name)
    if not r:
        return None
    by_type = {}
    for t, _line, text in r:
        by_type.setdefault(t, []).append(text if text is not None else "")
    return by_type


def main():
    u, p, d = conn_info()
    print(f"[conn] {u}@{d}")
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        section("D1. 컬럼 인벤토리 (81 6종 + 40 대조 2종)")
        for t in T81 + ["DM_PLN_CFM_MKT_DEMAND_PLAN", "DM_PLN_CFM_SELLING_PRICE"]:
            r = rows(cur, """
                SELECT COLUMN_ID, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, DATA_DEFAULT
                FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t
                ORDER BY COLUMN_ID""", t=t)
            print(f"\n--- {t} ({len(r)} cols) ---")
            if not r:
                print("  !! 테이블 없음")
                continue
            for cid, cn, dt, dl, nu, dflt in r:
                dflt_s = (str(dflt).strip()[:20] if dflt else "")
                print(f"  {cid:>3} {cn:<28} {dt}({dl}) {'NULL' if nu=='Y' else 'NOT NULL':<8} {dflt_s}")
            names = {x[1] for x in r}
            if t in T81:
                print(f"  >> CELL_PROD_SITE_ID={'존재!!' if 'CELL_PROD_SITE_ID' in names else '부재(예상대로)'}"
                      f" / END_CUSTOMER={'존재!!' if 'END_CUSTOMER' in names else '부재(예상대로)'}")

        section("D2. DISTINCT DIVISION_ID (81 커버리지)")
        for t in ["DM_PLN_MKT_FCST", "SCM_MST_FUTURE_PRICE"]:
            r = rows(cur, f"SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.{t} GROUP BY DIVISION_ID ORDER BY 1")
            print(f"\n--- {t} ---")
            for div, cnt in r:
                print(f"  {div:<12} {cnt:>10,}")

        section("D3. 81 measure 인벤토리")
        r = rows(cur, """
            SELECT MEASURE, COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST
            WHERE DIVISION_ID LIKE '81%' GROUP BY MEASURE ORDER BY 1""")
        for m, cnt in r:
            print(f"  {m:<20} {cnt:>10,}")
        r = rows(cur, """
            SELECT MEASURE, COUNT(*) FROM SCM_MGR.SCM_MST_FUTURE_PRICE
            WHERE DIVISION_ID LIKE '81%' GROUP BY MEASURE ORDER BY 1""")
        print("  -- SCM_MST_FUTURE_PRICE --")
        for m, cnt in r:
            print(f"  {m:<20} {cnt:>10,}")

        section("D4. 시퀀스 존재")
        r = rows(cur, """
            SELECT SEQUENCE_NAME, LAST_NUMBER FROM ALL_SEQUENCES
            WHERE SEQUENCE_OWNER='SCM_MGR' AND SEQUENCE_NAME IN
            ('SEQ1_DM_PLN_MKT_FCST_H','SEQ1_SCM_MST_FUTURE_PRICE_H',
             'SEQ1_DM_PLN_CFM_MKT_DEMAND_PLAN_H','SEQ1_DM_PLN_CFM_SELLING_PRICE_H')""")
        for n, last in r:
            print(f"  {n:<40} last={last}")
        if len(r) < 2:
            # _H INSERT 가 실제 어떤 SEQ 를 쓰는지 정본 SP에서 재확인 필요 신호
            r2 = rows(cur, """
                SELECT SEQUENCE_NAME FROM ALL_SEQUENCES
                WHERE SEQUENCE_OWNER='SCM_MGR' AND (SEQUENCE_NAME LIKE '%MKT_FCST%' OR SEQUENCE_NAME LIKE '%FUTURE_PRICE%')""")
            print("  >> 예상 SEQ 미발견 — 후보:", [x[0] for x in r2])

        section("D5. PR_DM_PLN_CFM_TO_MKT_FCST 소스 추출")
        src = extract_source(cur, "PR_DM_PLN_CFM_TO_MKT_FCST")
        if src:
            for typ, lines in src.items():
                f = OUTDIR / "PR_DM_PLN_CFM_TO_MKT_FCST.sql"
                f.write_text("".join(lines), encoding="utf-8")
                print(f"  {typ} {len(lines)}줄 → {f}")
                # 게이트 분류 핵심: DIVISION 필터 / DELETE 범위 즉석 스캔
                body = "".join(lines).upper()
                for kw in ["DIVISION_ID", "DELETE", "TRUNCATE", "MERGE", "DM_PLN_MKT_FCST", "SCM_MST_FUTURE_PRICE", "'40'", "'81"]:
                    cnt = body.count(kw)
                    print(f"    scan {kw:<22} {cnt}건")
        else:
            print("  !! ALL_SOURCE 에 없음 (권한/명칭 확인 필요)")

        section("D6. 라이브 SP 소스 추출 (diff/백업 원본)")
        for name in SPS + ["PKG_DMF0082"]:
            src = extract_source(cur, name)
            if not src:
                print(f"  !! {name} 소스 없음")
                continue
            for typ, lines in src.items():
                suffix = "_BODY" if typ == "PACKAGE BODY" else ("_SPEC" if typ == "PACKAGE" else "")
                f = OUTDIR / f"LIVE_{name}{suffix}.sql"
                f.write_text("".join(lines), encoding="utf-8")
                print(f"  {name} [{typ}] {len(lines)}줄 → {f.name}")

        section("D7. _C 테이블 VERSION 체계")
        for t in ["DM_PLN_MKT_FCST_C", "SCM_MST_FUTURE_PRICE_C",
                  "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "DM_PLN_CFM_SELLING_PRICE_C"]:
            r = rows(cur, """
                SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME LIKE '%VERSION%'""", t=t)
            print(f"  {t:<36} version cols: {[x[0] for x in r] or '없음'}")
        r = rows(cur, """
            SELECT VERSION_NO, DIVISION_ID, COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_C
            GROUP BY VERSION_NO, DIVISION_ID ORDER BY VERSION_NO DESC FETCH FIRST 12 ROWS ONLY""")
        print("  -- DM_PLN_MKT_FCST_C 최근 VERSION_NO×DIVISION --")
        for v, div, cnt in r:
            print(f"    {v:<20} {div:<10} {cnt:>10,}")

        section("D8. SP 시그니처 (ALL_ARGUMENTS)")
        for name in SPS:
            r = rows(cur, """
                SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS
                WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND PACKAGE_NAME IS NULL
                ORDER BY POSITION""", n=name)
            print(f"\n--- {name} ({len(r)} args) ---")
            for pos, an, io_, dt in r:
                print(f"  {pos:>2} {an or '(return)':<28} {io_:<6} {dt}")
        r = rows(cur, """
            SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS
            WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082' AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA'
            ORDER BY POSITION""")
        print(f"\n--- PKG_DMF0082.P_DMF0082_GET_MAIN_DATA ({len(r)} args) ---")
        for pos, an, io_, dt in r:
            print(f"  {pos:>2} {an or '(return)':<28} {io_:<6} {dt}")

        section("D9. SHEET_COLUMNS / SHEET_MEASURE division별 메타")
        for t, extra in [("SCM_MST_SHEET_COLUMNS", ""), ("SCM_MST_SHEET_MEASURE", "")]:
            try:
                r = rows(cur, f"""
                    SELECT DIVISION_ID, SHEET_NAME, COUNT(*) FROM SCM_MGR.{t}
                    WHERE PROGRAM_ID='DMF0082' GROUP BY DIVISION_ID, SHEET_NAME ORDER BY 1,2""")
                print(f"\n--- {t} ---")
                for div, sn, cnt in r:
                    print(f"  {str(div):<12} {sn:<20} {cnt:>5}")
            except oracledb.DatabaseError as e:
                print(f"  !! {t}: {e}")

        section("D3b. 40 measure 대조 (참고)")
        r = rows(cur, """
            SELECT MEASURE, COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
            GROUP BY MEASURE ORDER BY 1""")
        for m, cnt in r:
            print(f"  {m:<20} {cnt:>10,}")

    print("\n[done]")


if __name__ == "__main__":
    main()
