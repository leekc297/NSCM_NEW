#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003(mkt-fcst) UI 공통 7항목(UC-01~07) — 정본(DMF0042 business-plan) 대비 정밀 대조.

hook #133 §5 — 단일 소스 = `asis_mapping_gate.py::UI_COMMON_ITEMS`.
정본 = DMF0042(business-plan) 279/279 PASS 화면.

⚠ grep 1패턴으로 판정하지 않는다(anti-simplification §1.1) — 항목마다 **복수 신호**를 본다.
   구현/미구현을 코드 근거(파일:라인)와 함께 낸다.
"""
import io, re, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

ROOT = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
TARGET = ROOT / "features/demand/src/pages/mkt-fcst"
REF = {
    "DMF0042(business-plan)": ROOT / "features/demand/src/pages/business-plan",
    "DMF0021(sales-plan)":    ROOT / "features/demand/src/pages/sales-plan",
}

# 항목별 **복수** 판정 신호 (하나라도 있으면 '있음'으로 세되, 전부 보고한다)
SIGNALS = {
    "UC-01 필터유지 Insert": [r"keepRowVisibleUnderFilter"],
    "UC-02 수정중 조회 confirm": [r"MSG00703", r"수정\s*중", r"isDirty.*confirm|confirm.*isDirty"],
    "UC-03 설정저장 그리드 비움": [r"setRows\(\s*\[\s*\]\s*\)", r"clearRows", r"onSave.*=>.*\[\]",
                                   r"MeasureSelectModal", r"ColumnLayoutModal"],
    "UC-04 저장성공 Toast": [r"setToast"],
    "UC-05 Excel Name(dataMap)": [r"excelDownload", r"dataMap", r"collectLiveColumnExportMeta"],
    "UC-06 콤마 다중 조회": [r"joinComma", r"split\(\s*','\s*\)", r"\.join\(\s*','\s*\)"],
    "UC-07 재조회 필터유지": [r"rebindFilterColumns", r"captureGridFilter", r"restoreGridFilter"],
}

def scan(folder: pathlib.Path):
    hits = {k: [] for k in SIGNALS}
    if not folder.exists():
        return hits, 0
    files = [f for f in folder.rglob("*") if f.suffix in (".ts", ".tsx")]
    for f in files:
        try:
            txt = f.read_text(encoding="utf-8")
        except Exception:
            continue
        for item, pats in SIGNALS.items():
            for pat in pats:
                for m in re.finditer(pat, txt):
                    ln = txt[:m.start()].count("\n") + 1
                    hits[item].append((f.relative_to(folder).as_posix(), ln, pat))
                    break          # 파일당 패턴별 1건만
    return hits, len(files)

print("=" * 92)
tgt_hits, n = scan(TARGET)
print(f"### 대상 DMF0003 (mkt-fcst) — {n} 파일")
for item, hs in tgt_hits.items():
    mark = "✅" if hs else "⛔"
    print(f"  {mark} {item:<28} {len(hs)}건")
    for f, ln, pat in hs[:3]:
        print(f"        {f}:{ln}  [{pat[:34]}]")

for name, folder in REF.items():
    print("\n" + "=" * 92)
    rh, rn = scan(folder)
    print(f"### 정본 {name} — {rn} 파일")
    for item, hs in rh.items():
        mark = "✅" if hs else "⛔"
        print(f"  {mark} {item:<28} {len(hs)}건", end="")
        if hs:
            print(f"   ← {hs[0][0]}:{hs[0][1]}")
        else:
            print()

print("\n" + "=" * 92)
print("### 이식 필요 판정 (대상 ⛔ & 정본 ✅)")
ref_hits, _ = scan(REF["DMF0042(business-plan)"])
ref2, _ = scan(REF["DMF0021(sales-plan)"])
for item in SIGNALS:
    if not tgt_hits[item] and (ref_hits[item] or ref2[item]):
        srcs = ref_hits[item] or ref2[item]
        which = "business-plan" if ref_hits[item] else "sales-plan"
        print(f"  ▶ {item:<28} 정본 {which}: {srcs[0][0]}:{srcs[0][1]}")
    elif not tgt_hits[item]:
        print(f"  ▶ {item:<28} 정본에도 없음 — 별도 설계 필요")
