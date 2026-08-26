#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0044_CLOUD_20260820 — B_FE 산출물 생성기 (로컬 워킹트리 복사, READ-ONLY 원본).

  ① 페이지 폴더 전체 (index.ts 포함 — viewRegistry 등록 키. 부분 이관 = "Page Not Found" 계보)
  ② 페이지 밖 import 폐포 — grep 전수 추적으로 확정한 out-of-page 파일
  ③ configs/types/procedures.d.ts
  ④ locales KO/EN/CN 중 본 화면 코드 발췌 (실측)

⛔ 원본 수정 없음. B_FE 아래에 **원래 상대경로 그대로** 복사한다(붙여넣기 목적지 무오해).
"""
import io
import re
import sys
import json
import shutil
import pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
PKG_DIR = pathlib.Path(__file__).resolve().parent
OUT = PKG_DIR / "B_FE"
PAGE = "features/demand/src/pages/sales-reports"

# ── ② out-of-page 폐포 — 페이지가 직접 import 하는 배럴/모듈 중
#    2026-08-20 세션에서 내용이 바뀐 파일만 동봉 대상이다.
#    (배럴 전체를 동봉하면 무관한 화면까지 끌고 들어가므로, 변경분 ∩ 폐포 로 좁힌다.)
OUT_OF_PAGE = [
    ("features/master/src/components/searchFields/SearchFields.tsx",
     "DivisionField / VersionField 원천 — SalesReportsForm·ExchangeRateModal 이 직접 import"),
    ("features/master/src/components/columnLayoutModal/ColumnLayoutModal.tsx",
     "features/master/src/components 배럴 폐포 (index.ts 가 re-export)"),
    ("features/master/src/components/columnLayoutModal/columnLayoutModal.utils.ts",
     "동 배럴 폐포"),
    ("packages/foundation/src/utils/mergeManager.ts",
     "@foundation/utils 배럴 폐포 — allowEmptyCellMerge 확장점 추가(기본값 false = 기존 동작 보존)"),
    ("packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx",
     "@shared/components 폐포 — SalesReportsForm·ExchangeRateModal 의 CustomDropdown"),
    ("packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx",
     "@shared/components 폐포 — SalesReportsModals 의 ColumnLayoutModal 실체"),
    ("packages/shared/src/components/organisms/index.ts",
     "@shared/components 배럴 (organisms) — 폐포 경유"),
    ("packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx",
     "위 배럴이 re-export — 본 화면 미사용이나 배럴 타입 해석에 필요"),
    ("configs/types/procedures.d.ts",
     "③ useTabProcQuery / useProcMutation 의 MENU_ID→프로시저 타입 원천"),
]

# ── ④ locales 발췌 축 = A_DB/23 과 동일한 34코드 (LIVE 30 + 공통 1 + MNU 3)
CODES = ['LBL00086', 'LBL00112', 'LBL00121', 'LBL00626', 'LBL00627', 'LBL00661',
         'LBL00664', 'LBL00667', 'LBL00670', 'LBL00712', 'LBL00795', 'LBL00796',
         'LBL00797', 'LBL00798', 'MSG00002', 'MSG00004', 'MSG00096', 'MSG00283',
         'MSG00429', 'MSG00618', 'MSG00676', 'MSG00680', 'MSG00681', 'MSG00682',
         'MSG00683', 'MSG00684', 'MSG00685', 'MSG00686', 'MSG00687', 'MSG00688',
         'MSG00703', 'MNU00038', 'MNU00011', 'MNU00002']

if OUT.exists():
    shutil.rmtree(OUT)
OUT.mkdir(parents=True)

manifest = []


def copy(rel, note=""):
    src = FE / rel
    assert src.is_file(), f"원본 없음: {src}"
    dst = OUT / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    n = len(src.read_text(encoding="utf-8", errors="ignore").splitlines())
    manifest.append((rel, n, note))
    return n


# ── ① 페이지 폴더 전체 ────────────────────────────────────────────────────────
print("[1] 페이지 폴더 전체")
page_files = sorted(p for p in (FE / PAGE).rglob("*") if p.is_file())
for p in page_files:
    rel = p.relative_to(FE).as_posix()
    copy(rel, "페이지 폴더")
print(f"    {len(page_files)} files")
assert (OUT / PAGE / "index.ts").is_file(), "[ASSERT FAIL] index.ts 누락 — viewRegistry 등록 키"

# ── ② + ③ out-of-page 폐포 ──────────────────────────────────────────────────
print("[2] out-of-page 폐포 + procedures.d.ts")
for rel, note in OUT_OF_PAGE:
    n = copy(rel, note)
    print(f"    {rel}  ({n} lines)")

# ── ④ locales 발췌 ──────────────────────────────────────────────────────────
print("[3] locales 발췌")
loc_out = OUT / "public/locales"
loc_out.mkdir(parents=True, exist_ok=True)
loc_report = {}
for lang in ("KO", "EN", "CN"):
    src = FE / "public/locales" / f"{lang}.json"
    data = json.loads(src.read_text(encoding="utf-8"))
    sub = {c: data[c] for c in CODES if c in data}
    missing = [c for c in CODES if c not in data]
    loc_report[lang] = (len(sub), missing, len(data))
    (loc_out / f"{lang}.json").write_text(
        json.dumps(sub, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    manifest.append((f"public/locales/{lang}.json", len(sub) + 2,
                     f"발췌 {len(sub)}/{len(CODES)}코드 (원본 전체 {len(data)}키)"))
    print(f"    {lang}: {len(sub)}/{len(CODES)} 코드 발췌 (원본 {len(data)}키)"
          + (f"  ⚠ 결손 {missing}" if missing else ""))

# ── 폐포 자기검증: 페이지 폴더의 out-of-page import 가 전부 설명됐는가 ────────
print("[4] 폐포 자기검증")
ext = set()
for p in page_files:
    if p.suffix not in (".ts", ".tsx"):
        continue
    for m in re.findall(r"from\s+['\"]([^'\"]+)['\"]", p.read_text(encoding="utf-8", errors="ignore")):
        if not m.startswith("."):
            ext.add(m)
known_pkgs = {"react", "@mescius/wijmo.grid", "@mescius/wijmo.grid.filter"}
alias_covered = {"@foundation/", "@shared/", "features/master/"}
unexplained = [m for m in sorted(ext)
               if m not in known_pkgs and not any(m.startswith(a) for a in alias_covered)]
print(f"    out-of-page import 스펙 {len(ext)}종")
print(f"      외부 npm(이관 대상 아님)     : {sorted(known_pkgs & ext)}")
print(f"      alias/모노레포 내부(폐포 대상): {sorted(m for m in ext if any(m.startswith(a) for a in alias_covered))}")
assert not unexplained, f"[ASSERT FAIL] 분류되지 않은 import: {unexplained}"

(PKG_DIR / "_fe_manifest.json").write_text(
    json.dumps({"files": [{"path": r, "lines": n, "note": t} for r, n, t in manifest],
                "locales": {k: {"picked": v[0], "missing": v[1], "src_keys": v[2]}
                            for k, v in loc_report.items()}},
               ensure_ascii=False, indent=2), encoding="utf-8")

print(f"\nB_FE 총 {len(manifest)} 파일 / {sum(n for _, n, _ in manifest)} 행")
print("generate DONE (원본 무수정 — 복사만)")
