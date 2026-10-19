# -*- coding: utf-8 -*-
"""v3 검증 게이트 — 08_SAMPLEDATA_STEPNO_v3.xlsx

G1  DIVISION 3시트 = 07 원본과 셀 단위 동일 (무변경)
G2  TestData 3시트의 앞 36컬럼 = 06(이전 양식) 헤더와 순서까지 동일
G3  06 의 299행이 1행도 빠짐없이 v3 에 승계 (36컬럼 값 동일)
G4  `항목` 컬럼 오염 0 — 전부 DIVISION 시트의 항목 문자열 (07 의 ITEM_ID 혼입 결함 정정 확인)
G5  DIVISION 시트에서 `샘플 Link`='샘플' 인 STEP 전수가 TestData 행 + STEP 시트 보유
G6  STEP 시트 데이터 행수 = 07 대응 시트 행수 (누락 0)
G7  v2 유래 행의 INCOTERMS 에 EDIT_FLAG='N' 값 0건
G8  필수 컬럼 공백 0건
G9  '기존' 분류 행은 전부 선별근거(분류기준) 보유
G10 `기간(실측)`/`현재값(실측)` 의 미측정 표기는 v2 단독 행에만 존재
"""
import pathlib
import sys
import importlib.util

import openpyxl

HERE = pathlib.Path(__file__).resolve().parent
D = HERE.parent
V1 = D / "06_SAMPLEDATA_STEPNO.xlsx"
V2 = D / "07_SAMPLEDATA_STEPNO_v2.xlsx"
V3 = D / "08_SAMPLEDATA_STEPNO_v3.xlsx"

_spec = importlib.util.spec_from_file_location("stepdef", HERE / "40_stepdef_v3.py")
SD = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(SD)

DIVS = ("40", "81", "82")
INCO_N = {"A01", "DAT", "DDU", "Z01", "Z02", "Z04"}
NOT_MEASURED = "미측정(재조회 필요)"

ok = True


def gate(n, cond, msg):
    global ok
    ok = ok and cond
    print("{} {:4s} {}".format("PASS" if cond else "FAIL", n, msg))


def rows(ws, first=2):
    hdr = [c.value for c in next(ws.iter_rows(max_row=1))]
    out = []
    for r in ws.iter_rows(min_row=first, values_only=True):
        if not any(x not in (None, "") for x in r):
            continue
        out.append({h: r[i] if i < len(r) else None
                    for i, h in enumerate(hdr) if h is not None})
    return hdr, out


w1 = openpyxl.load_workbook(V1, data_only=True)
w2 = openpyxl.load_workbook(V2, data_only=True)
w3 = openpyxl.load_workbook(V3, data_only=True)

# ── G1 ───────────────────────────────────────────────────────────────────
diff = []
for d in DIVS:
    a, b = w2[SD.SHEET_OF[d]], w3[SD.SHEET_OF[d]]
    if (a.max_row, a.max_column) != (b.max_row, b.max_column):
        diff.append("{} 크기 {}x{} != {}x{}".format(
            d, a.max_row, a.max_column, b.max_row, b.max_column))
        continue
    for r in range(1, a.max_row + 1):
        for c in range(1, a.max_column + 1):
            if a.cell(r, c).value != b.cell(r, c).value:
                diff.append("{} {}행{}열".format(d, r, c))
gate("G1", not diff, "DIVISION 3시트 무변경 ({})".format(
    "동일" if not diff else "차이 " + ", ".join(diff[:5])))

# ── G2 ───────────────────────────────────────────────────────────────────
h1, _ = rows(w1[SD.OUT_SHEET["40"]])
bad = []
for d in DIVS:
    h3, _ = rows(w3[SD.OUT_SHEET[d]])
    if h3[:len(h1)] != h1:
        bad.append(d)
gate("G2", not bad, "앞 36컬럼 = 06 양식 동일 (확장 {}컬럼 뒤에 추가)".format(
    len(rows(w3[SD.OUT_SHEET['40']])[0]) - len(h1)))

# ── G3 ───────────────────────────────────────────────────────────────────
# `항목` = 07 결함 정정 대상, ENRICH 3종 = v2 실측 메타로 보강하는 문서화된 컬럼.
# 그 외 33컬럼은 06 원문과 **완전 동일**해야 한다.
ENRICH = {"항목", "엑셀항목", "편집요일", "권한메타근거", "등록값명세",
          "데이터보유(실측)", "기간(실측)", "현재값(실측)", "분류기준",
          "ITEM_ID", "SCM_SITE_ID", "PROJECT_CODE", "FCST_TYPE", "INCOTERMS",
          "DOM_EXP", "PLANT_SITE_ID"}   # 42 재측정 · 45 재선별 대상
CMP = [c for c in h1 if c not in ENRICH]
miss, n1, enrich_n = [], 0, 0
for d in DIVS:
    _, a = rows(w1[SD.OUT_SHEET[d]])
    _, b = rows(w3[SD.OUT_SHEET[d]])
    n1 += len(a)
    have = {}
    for r in b:
        if str(r.get("행출처", "")).startswith("v1"):
            have.setdefault(tuple(str(r.get(c, "")) for c in CMP), []).append(r)
    for r in a:
        k = tuple(str(r.get(c, "")) for c in CMP)
        pool = have.get(k)
        if not pool:
            miss.append((d, r.get("StepNo"), r.get("데이터출처"), r.get("ITEM_ID")))
            continue
        v3r = pool.pop(0)
        for c in ("편집요일", "권한메타근거", "등록값명세",
                  "데이터보유(실측)", "기간(실측)", "현재값(실측)"):
            if str(r.get(c, "")) != str(v3r.get(c, "")):
                enrich_n += 1
gate("G3", not miss, "06 {}행 전수 승계 — 비교 {}컬럼 완전일치 (미승계 {}건{})".format(
    n1, len(CMP), len(miss), " " + str(miss[:3]) if miss else ""))
print("     └ 보강 셀 {}개 (편집요일/권한메타근거/등록값명세 — v2 실측 메타로 '-' 채움)"
      .format(enrich_n))

# ── G4 ───────────────────────────────────────────────────────────────────
allowed = set()
for d in DIVS:
    for row in w3[SD.SHEET_OF[d]].iter_rows(min_row=2, values_only=True):
        v = row[2] if len(row) > 2 else None
        if v:
            allowed.add(str(v).strip())
bad4 = []
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    for r in b:
        if str(r.get("항목", "")).strip() not in allowed:
            bad4.append((d, r.get("StepNo"), r.get("항목")))
gate("G4", not bad4, "항목 컬럼 오염 0건 (위반 {}{})".format(
    len(bad4), " " + str(bad4[:3]) if bad4 else ""))

# ── G5 ───────────────────────────────────────────────────────────────────
need = {}
sys.path.insert(0, str(HERE))
bld = importlib.util.spec_from_file_location("bld", HERE / "41_build_v3.py")
BM = importlib.util.module_from_spec(bld)
bld.loader.exec_module(BM)
for d in DIVS:
    for k, info in BM.parse_division(w3[SD.SHEET_OF[d]], d).items():
        if info["샘플Link"] == "샘플":
            need.setdefault(d, set()).add(k)
miss5 = []
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    have = {str(r["StepNo"]) for r in b}
    for k in sorted(need.get(d, ())):
        if k not in have:
            miss5.append((d, k, "TestData 행 없음"))
        if "{}_{}".format(d, k) not in w3.sheetnames:
            miss5.append((d, k, "STEP 시트 없음"))
gate("G5", not miss5, "샘플 STEP {}개 전수 커버 (누락 {}{})".format(
    sum(len(v) for v in need.values()), len(miss5), " " + str(miss5[:4]) if miss5 else ""))

# ── G6 ───────────────────────────────────────────────────────────────────
bad6 = []
for n in w3.sheetnames:
    if "_" not in n or n.split("_")[0] not in DIVS:
        continue
    a = sum(1 for r in w2[n].iter_rows(min_row=3, values_only=True)
            if any(x not in (None, "") for x in r))
    b = sum(1 for r in w3[n].iter_rows(min_row=3, values_only=True)
            if any(x not in (None, "") for x in r))
    if a != b:
        bad6.append((n, a, b))
gate("G6", not bad6, "STEP 시트 {}개 행수 일치 (불일치 {}{})".format(
    sum(1 for n in w3.sheetnames if "_" in n and n.split("_")[0] in DIVS),
    len(bad6), " " + str(bad6[:3]) if bad6 else ""))

# ── G7 ───────────────────────────────────────────────────────────────────
bad7 = []
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    for r in b:
        if "v2" in str(r.get("행출처", "")) and str(r.get("INCOTERMS", "")).strip() in INCO_N:
            bad7.append((d, r.get("StepNo"), r.get("INCOTERMS")))
gate("G7", not bad7, "v2 행 INCOTERMS 입력불가값 0건 (위반 {}{})".format(
    len(bad7), " " + str(bad7[:3]) if bad7 else ""))

# ── G8 ───────────────────────────────────────────────────────────────────
REQ = ["StepNo", "Step", "항목", "DIV", "구분", "데이터출처", "분류기준",
       "권한그룹", "테스트계정", "대상원장", "행출처"]
bad8 = []
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    for r in b:
        for c in REQ:
            if str(r.get(c, "")).strip() in ("", "None"):
                bad8.append((d, r.get("StepNo"), c))
gate("G8", not bad8, "필수 컬럼 공백 0건 (위반 {}{})".format(
    len(bad8), " " + str(bad8[:5]) if bad8 else ""))

# ── G9 ───────────────────────────────────────────────────────────────────
bad9 = []
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    for r in b:
        if str(r.get("데이터출처", "")).startswith("기존") and \
           str(r.get("분류기준", "")).strip() in ("", "-", "None"):
            bad9.append((d, r.get("StepNo")))
gate("G9", not bad9, "'기존' 행 선별근거 보유 (누락 {})".format(len(bad9)))

# ── G10 ──────────────────────────────────────────────────────────────────
bad10, n_nm = [], 0
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    for r in b:
        nm = NOT_MEASURED in (str(r.get("기간(실측)")) + str(r.get("현재값(실측)")))
        if nm:
            n_nm += 1
            if str(r.get("행출처")) != "v2(07)":
                bad10.append((d, r.get("StepNo"), r.get("행출처")))
gate("G10", n_nm == 0, "미측정 표기 잔존 {}행 (2026-09-21 재측정 완료 → 0 이어야 함)".format(n_nm))

# ── G11  '기존' 행 키 실존 100% (42_refill_measure 결과 반영본) ─────────────
bad11 = n_exist = 0
detail = []
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    for r in b:
        if not str(r.get("데이터출처", "")).startswith("기존"):
            continue
        if str(r.get("대상원장", "")).strip() in ("-", ""):
            continue          # 조회 전용 화면 — 저장 원장 없음
        n_exist += 1
        v = str(r.get("데이터보유(실측)", ""))
        if v.startswith("⚠") or v in ("", "None"):
            bad11 += 1
            detail.append((d, r.get("StepNo"), v[:30]))
gate("G11", bad11 == 0, "'기존' {}행 전수 원장 실존 (위반 {}{})".format(
    n_exist, bad11, " " + str(detail[:3]) if detail else ""))

# ── G12  STEP 시트 LAYOUT 중복 컬럼명 0 ────────────────────────────────────
dup = []
for n in w3.sheetnames:
    if "_" not in n or n.split("_")[0] not in DIVS:
        continue
    names = [c.value for c in w3[n][1]][17:]
    names = [x for x in names if x]
    if len(names) != len(set(names)):
        dup.append((n, len(names) - len(set(names))))
gate("G12", not dup, "STEP 시트 LAYOUT 중복 컬럼명 0 (위반 {}{})".format(
    len(dup), " " + str(dup[:3]) if dup else ""))

# ── G13  LAYOUT 잔여 공백은 전부 `_LAYOUT_GAP` 에 사유 등재 ─────────────────
gapped = set()
if "_LAYOUT_GAP" in w3.sheetnames:
    for r in w3["_LAYOUT_GAP"].iter_rows(min_row=2, values_only=True):
        if r[0]:
            gapped.add((str(r[0]), str(r[3])))
missing13 = []
for n in w3.sheetnames:
    if "_" not in n or n.split("_")[0] not in DIVS:
        continue
    ws = w3[n]
    hdr = [c.value for c in ws[1]]
    data = [r for r in ws.iter_rows(min_row=3)
            if any(c.value not in (None, "") for c in r)]
    for i in range(17, len(hdr)):
        if not hdr[i]:
            continue
        if any(i >= len(r) or r[i].value in (None, "") for r in data):
            if (n, str(hdr[i])) not in gapped:
                missing13.append((n, hdr[i]))
gate("G13", not missing13, "공백 LAYOUT 컬럼 {}건 전수 사유 등재 (미등재 {}{})".format(
    len(gapped), len(missing13), " " + str(missing13[:3]) if missing13 else ""))

# ── 요약 ─────────────────────────────────────────────────────────────────
print()
tot = 0
for d in DIVS:
    _, b = rows(w3[SD.OUT_SHEET[d]])
    tot += len(b)
    src, org = {}, {}
    for r in b:
        src[str(r["데이터출처"])] = src.get(str(r["데이터출처"]), 0) + 1
        org[str(r["행출처"])] = org.get(str(r["행출처"]), 0) + 1
    print("{} {:3d}행  출처 {}  회차 {}".format(SD.OUT_SHEET[d], len(b), src, org))
print("합계 {}행 / 시트 {}개".format(tot, len(w3.sheetnames)))
print("\n{}".format("전체 PASS" if ok else "FAIL 있음"))
sys.exit(0 if ok else 1)
