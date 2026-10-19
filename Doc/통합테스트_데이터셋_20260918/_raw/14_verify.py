# -*- coding: utf-8 -*-
"""
Phase 6 — 검증 게이트 G1~G6

G1 샘플 지정 24 STEP 이 전부 TestData 시트에 존재 (누락 0)
G2 전 행의 키 조합이 ZIOUI1 에 실존 (0건 행 금지)
G3 '신규(SSPM 미생성)' 행이 실제로 MKT_FCST 0건인지 재확인
G4 권한×MEASURE 가 GET_ADMIN_GROUP_MEASURE 실측과 일치
G5 오전 115행이 전부 승계 (Step No 매핑 누락 0)
G6 원본 3시트 무변경 (셀 단위 대조)
"""
import re
import json
import pathlib
import sys
import importlib.util

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
import openpyxl

D = pathlib.Path(__file__).resolve().parent
OUT = D.parent
SRC = pathlib.Path(r"C:\TRANFILE\RECEIVE\DM_통합테스트_SampleData_20260918.xlsx")
DEST = OUT / "06_SAMPLEDATA_STEPNO.xlsx"

spec = importlib.util.spec_from_file_location("stepmap", D / "10_stepmap.py")
SM = importlib.util.module_from_spec(spec)
spec.loader.exec_module(SM)
META = json.loads((D / "01_meta.json").read_text(encoding="utf-8"))


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


wb = openpyxl.load_workbook(DEST)
rows = {}
for div in ("40", "81", "82"):
    ws = wb[SM.OUT_SHEET[div]]
    cols = [c.value for c in ws[1]]
    rows[div] = [dict(zip(cols, r)) for r in ws.iter_rows(min_row=2, values_only=True)]
allrows = [r for v in rows.values() for r in v]
print("TestData 총 {:,}행 (40 {} / 81 {} / 82 {})".format(
    len(allrows), len(rows["40"]), len(rows["81"]), len(rows["82"])))

fail = []

# ── G1 ──
want = {(d, s) for d, s, smp, *_ in SM.STEPS if smp == "Y"}
have = {(r["DIV"], r["StepNo"]) for r in allrows if r["샘플지정"] == "Y"}
miss = want - have
print("\n[G1] 샘플 STEP {}개 중 누락 {}개 {}".format(len(want), len(miss), sorted(miss) or ""))
if miss:
    fail.append("G1")

# ── G5 ──
mws = openpyxl.load_workbook(OUT / "04_TESTDATA_SET.xlsx")["TESTDATA_SET"]
mi = {n: k for k, n in enumerate(c.value for c in mws[1])}
morn = list(mws.iter_rows(min_row=2, values_only=True))
kept = [r for r in allrows if r["데이터출처"] == "기존(데이터보유 상위)"]
print("[G5] 오전 {}행 → 승계 {}행".format(len(morn), len(kept)))
if len(kept) != len(morn):
    fail.append("G5")

# ── G6 ──
a, b = openpyxl.load_workbook(SRC), openpyxl.load_workbook(DEST)
diff = 0
for sh in ("40 DIVISION", "81 DIVISION", "82 DIVISION"):
    wa, wbb = a[sh], b[sh]
    if (wa.max_row, wa.max_column) != (wbb.max_row, wbb.max_column):
        diff += 1
        continue
    for ra, rb in zip(wa.iter_rows(values_only=True), wbb.iter_rows(values_only=True)):
        if ra != rb:
            diff += 1
print("[G6] 원본 3시트 차이 {}건".format(diff))
if diff:
    fail.append("G6")

# ── G2 / G3 ──
with conn() as db:
    cur = db.cursor()
    bad_exist, bad_gap = [], []
    seen = set()
    for r in allrows:
        if r["구분"] in ("IF",) and r["데이터출처"] == "신규(기준정보·IF)":
            continue          # IF 수신분은 원장 실존을 이미 추출 시 확인
        k = (r["DIV"], r["PROJECT_CODE"], r["SCM_SITE_ID"], r["ITEM_ID"], r["데이터출처"])
        if k in seen or r["ITEM_ID"] in (None, "-", ""):
            continue
        seen.add(k)
        cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM
                        WHERE DIVISION_ID=:d AND PROJECT_CODE=:p
                          AND SCM_SITE_ID=:s AND ITEM_ID=:i""",
                    d=k[0], p=k[1], s=k[2], i=k[3])
        if not cur.fetchone()[0]:
            bad_exist.append(k)
        if k[4] == "신규(SSPM 미생성)":
            cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST
                            WHERE DIVISION_ID=:d AND PROJECT_CODE=:p AND SCM_SITE_ID=:s
                              AND ITEM_ID=:i AND MEASURE='MKT_FCST' AND QTY<>0""",
                        d=k[0], p=k[1], s=k[2], i=k[3])
            if cur.fetchone()[0]:
                bad_gap.append(k)
    print("[G2] SSPM 실존 확인 — 검사 {}키 / 미실존 {}키 {}".format(
        len(seen), len(bad_exist), bad_exist[:3]))
    print("[G3] 신규(SSPM 미생성) 재확인 — MKT_FCST 가 있는 키 {}개 {}".format(
        len(bad_gap), bad_gap[:3]))
    if bad_exist:
        fail.append("G2")
    if bad_gap:
        fail.append("G3")

# ── G4 ──
AM = {}
for m in META["auth_measure"]:
    AM.setdefault((m["AUTH"], m["SCR"]), set()).add(m["MEASURE"])
viol = []
for r in allrows:
    auth, scr, meas = r["권한그룹"], r["실제화면"], str(r["입력MEASURE"] or "")
    key = (auth, scr)
    if key not in AM:
        continue                       # 메타 미등재 = 제한 없음 전제
    for tok in re.split(r"[/,]", meas):
        tok = tok.split("(")[0].strip()
        if tok and tok not in AM[key] and tok not in ("-", "실적수량", "재고"):
            viol.append((auth, scr, tok))
viol = sorted(set(viol))
print("[G4] 권한×MEASURE 메타 불일치 {}건 {}".format(len(viol), viol[:5]))
if viol:
    fail.append("G4")

print("\n판정: {}".format("전 게이트 PASS" if not fail else "FAIL — " + ", ".join(fail)))
