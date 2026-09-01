# -*- coding: utf-8 -*-
"""DMF0035 이관 보강 — 통합 3UI 의 종속 PROGRAM_ID(DMF0022/DMF0051) 메타(SHEET_COLUMNS/MEASURE·EXCEL_COLUMNS·MSG) 동봉.
   원인: PKG_DMF0022/0051 은 V_PROGRAM_ID:='DMF0022'/'DMF0051' 로 자기 시트 메타를 읽는데 초판 22_SHEET_META 는 DMF0035 행만 담음 (2026-08-27 사용자 지적)."""
import io, sys, re, pathlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb; from ora import conn_info
src = pathlib.Path(r"_artifacts/_diagnostics/_ui_cloud_pkg_build_20260827.py").read_text(encoding="utf-8")
helpers = src[src.index("u, p, d = conn_info()"):src.index("def src_of")]
exec(helpers)  # q/cols_of/pk_of/lit/merge_sql/insert_sql
STAMP = "2026-08-27 DEP-PROGRAM"
A = pathlib.Path(r"_artifacts/_deploy_packages/DMF0035_CLOUD_20260827/A_DB")
deps = ["DMF0022", "DMF0051"]
sl = [f"-- 22A_SHEET_META_DEP_PROGRAMS.sql — DMF0035 통합 3UI 종속 PROGRAM_ID {deps} SHEET_COLUMNS/MEASURE (PROGRAM_ID+SHEET_NAME 단위 DELETE 후 전체 재적재 — hook #98 §9) [{STAMP}]",
      "-- PKG_DMF0022/PKG_DMF0051 이 V_PROGRAM_ID 로 자기 메타를 읽음 → 이 파일 없으면 Sales Plan / Biz Plan 조회가 컬럼 0 으로 빈다. 22_SHEET_META 직후 실행."]
verify = []
for m in deps:
    for t in ("SCM_MST_SHEET_COLUMNS", "SCM_MST_SHEET_MEASURE"):
        cols = cols_of(t)
        for (sh,) in q(f"SELECT DISTINCT SHEET_NAME FROM SCM_MGR.{t} WHERE PROGRAM_ID=:m", m=m):
            rows = q(f"SELECT {', '.join(cols)} FROM SCM_MGR.{t} WHERE PROGRAM_ID=:m AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO, COLUMN_NAME", m=m, s=sh)
            sl.append(f"\n-- {t} {m}/{sh} {len(rows)}행"); sl.append(f"DELETE FROM SCM_MGR.{t} WHERE PROGRAM_ID='{m}' AND SHEET_NAME={lit(sh)};"); sl.append(insert_sql(t, rows, cols))
            verify.append(f"SELECT '{t}/{m}/{sh}' T, COUNT(*) CNT FROM SCM_MGR.{t} WHERE PROGRAM_ID='{m}' AND SHEET_NAME={lit(sh)};  -- 기대 {len(rows)}")
            print(t, m, sh, len(rows))
sl.append("COMMIT;")
(A/"22A_SHEET_META_DEP_PROGRAMS.sql").write_bytes(("\n".join(sl)+"\n").encode("utf-8"))
# EXCEL_COLUMNS + MSG(LBL) 종속분
ec = cols_of("SCM_ADM_EXCEL_COLUMNS"); pk = pk_of("SCM_ADM_EXCEL_COLUMNS")
rows = q(f"SELECT {', '.join(ec)} FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN ('DMF0022','DMF0051')")
(A/"25A_EXCEL_COLUMNS_DEP_PROGRAMS.sql").write_bytes((f"-- 25A EXCEL_COLUMNS DMF0022/DMF0051 {len(rows)}행 [{STAMP}]\n" + merge_sql("SCM_ADM_EXCEL_COLUMNS", rows, ec, pk, "PROGRAM_ID IN") + "COMMIT;\n").encode("utf-8"))
print("EXCEL_COLUMNS", len(rows))
verify.append("SELECT PROGRAM_ID, COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN ('DMF0022','DMF0051') GROUP BY PROGRAM_ID;  -- 기대 " + str(len(rows)) + " 합")
(A/"90_VERIFY.sql").open("a", encoding="utf-8").write("\n-- ── 22A/25A 종속 PROGRAM_ID(DMF0022/DMF0051) 메타 검증 [" + STAMP + "] ──\n" + "\n".join(verify) + "\n")
p = A.parent
(p/"README.md").open("a", encoding="utf-8").write(f"""
## 22A / 25A — 종속 PROGRAM_ID(DMF0022·DMF0051) 메타 동봉 (2026-08-27 사용자 지적)
- DMF0035 는 AS-IS 3UI 통합: MKT=PKG_DMF0035(PROGRAM_ID DMF0035) / Sales=PKG_DMF0022(**DMF0022**) / Biz=PKG_DMF0051(**DMF0051**). 각 PKG 는 `V_PROGRAM_ID` 로 자기 SHEET_COLUMNS/MEASURE 를 읽으므로 3 PROGRAM_ID 메타가 모두 있어야 한다.
- 초판 22_SHEET_META 는 DMF0035 만 → Sales/Biz 조회 컬럼 0 위험. `22A_SHEET_META_DEP_PROGRAMS.sql`(SHEET 단위 DELETE+INSERT) + `25A_EXCEL_COLUMNS_DEP_PROGRAMS.sql`(MERGE) 추가, 90_VERIFY 에 기대 건수 등재.
- 적용 순서: 22 → **22A** → 21 → 23 → 25 → **25A** → 26.
- FE 계약(procedures.d.ts): DMF0022 블록은 독립 키로 존재(사내 L56~L155) → FE_MERGE 에 `procedures.d.ts.DMF0022_BLOCK.txt` 추가. DMF0051 은 사내에 독립 키가 없고 DMF0035 블록의 `bizPlanWaterfall`/`bizPlanSpreadTitle` 시트가 그 계약이다.
""")
# DMF0022 procedures.d.ts 블록
lines = pathlib.Path("nscm-fe/configs/types/procedures.d.ts").read_text(encoding="utf-8").splitlines()
tops = [(i+1, re.match(r"^  ([A-Za-z0-9_]+): \{", l).group(1)) for i, l in enumerate(lines) if re.match(r"^  ([A-Za-z0-9_]+): \{", l)]
idx = [k for k,(ln,n) in enumerate(tops) if n=="DMF0022"][0]; s = tops[idx][0]; e = tops[idx+1][0]-1
while s-2 >= 0 and lines[s-2].strip().startswith(("*","/**")): s -= 1
while lines[e-1].strip().startswith(("*","/**")) or lines[e-1].strip()=="": e -= 1
blk = lines[s-1:e]; keys = [re.match(r"^    ([A-Za-z0-9_]+): \{", l).group(1) for l in blk if re.match(r"^    ([A-Za-z0-9_]+): \{", l)]
fm = p/"FE_MERGE"; (fm/"procedures.d.ts.DMF0022_BLOCK.txt").write_text("\n".join([f"// procedures.d.ts 의 DMF0022 계약 블록 — 사내 L{s}~L{e} ({e-s+1}줄, 시트 키 {keys}) — DMF0035 Sales Plan 축 종속 [{STAMP}]", "// 병합법: 클라우드 `  DMF0022: { ... },` 블록 교체(없으면 삽입). 파일 전체 덮어쓰기 ⛔", "// ----- BEGIN BLOCK -----"] + blk + ["// ----- END BLOCK -----"]) + "\n", encoding="utf-8")
print("DMF0022 block", f"L{s}~L{e}", keys)
(p/"_FILELIST.md").write_text("\n".join(sorted(f.relative_to(p).as_posix() for f in p.rglob("*") if f.is_file()))+"\n", encoding="utf-8")
