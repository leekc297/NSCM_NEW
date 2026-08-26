# -*- coding: utf-8 -*-
"""STEP B — [E20260820-VERPUSH2] 원장 _C 구동 5지점에 버전 술어 push (선행축소). 패치본 생성만.

등가성(5지점 모두 개별 확인 — 35_probe_stepB.py 실측):
  각 지점이 속한 블록에는 `JOIN SCM_MGR.GT_DM35_VERSION <al> ON A.VERSION_NO = <al>.VERSION_NO` **내부조인**이
  이미 존재한다. 따라서 `<원장별칭>.VERSION_NO IN (SELECT VERSION_NO FROM GT_DM35_VERSION)` 은
  그 조인이 이미 강제하는 조건의 **중복 술어** → 결과집합 불변(추가 술어가 행을 더 걸러낼 수 없음).
  효과는 옵티마이저가 (DIVISION_ID, VERSION_NO) 선두 인덱스를 access predicate 로 쓸 수 있게 되는 것뿐.
선례: 같은 SP L1550/1556/1594 [E20260820-VERPUSH] — 동일 문자열.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
src = open(BASE + r"\02_LIVE_AFTER_STEPA.sql", encoding="utf-8").read().split("\n")
if src and src[-1] == "":
    src.pop()
print(f"[원본] {len(src)} lines (STEP A 적용본)")

MARK = "E20260820-VERPUSH2"
PUSH = "VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)"
LED = r"(DM_PLN_MKT_FCST_C|DM_PLN_CFM_MKT_DEMAND_PLAN_C|DM_PLN_MKT_FCST_RESULT_C)"

# ---------- 대상 지점 수집 (라인 하드코딩 금지 — 패턴 + 기적용 여부로 판정) ----------
type1, type2 = [], []          # (idx0, alias) / (idx0_of_FROM, alias)
for i, t in enumerate(src):
    if t.strip().startswith("--"):
        continue
    m = re.search(rf"FROM\s+SCM_MGR\.{LED}\s+(\w+)\b", t)
    if not m:
        continue
    al = m.group(2)
    win = "\n".join(src[i:i + 40])
    if f"{al}.{PUSH}" in win:
        continue                                  # 기적용 (VERPUSH 1차)
    if re.search(r"WHERE \(CASE WHEN P_DIVISION_ID", t):
        type1.append((i, al, m.group(1)))
    else:
        type2.append((i, al, m.group(1)))

print(f"[대상] type1(UNION ALL 분기 · FROM 라인에 WHERE) {len(type1)}곳 / type2(별도 WHERE 블록) {len(type2)}곳")
assert len(type1) == 4, f"type1 {len(type1)}곳 (기대 4) — 중단"
assert len(type2) == 1, f"type2 {len(type2)}곳 (기대 1) — 중단"

# ---------- 등가성 전제: 각 지점 블록에 GT_DM35_VERSION 내부조인 존재 ----------
for i, al, tbl in type1 + type2:
    win = "\n".join(src[i:i + 45])
    jm = re.search(r"JOIN SCM_MGR\.GT_DM35_VERSION (\w+)\s*\n\s*ON A\.VERSION_NO = \1\.VERSION_NO", win)
    assert jm, f"L{i+1} {tbl} — GT_DM35_VERSION 내부조인 미확인, 등가성 근거 없음 → 중단"
    print(f"  L{i+1:>5} {tbl:<30} 별칭={al}  등가근거 JOIN GT_DM35_VERSION {jm.group(1)} ON A.VERSION_NO = {jm.group(1)}.VERSION_NO")

# type2 는 삽입 지점(WHERE 블록의 DIVISION_ID 라인) 확정
t2_ins = []
for i, al, tbl in type2:
    j = next((k for k in range(i, i + 40) if re.match(rf"\s*AND\s+{al}\.DIVISION_ID\s*=\s*P_DIVISION_ID\s*$", src[k])), None)
    assert j is not None, f"L{i+1} {tbl} — WHERE 블록의 DIVISION_ID 라인 미발견 → 중단"
    print(f"  ↳ type2 삽입 지점 L{j+1}: {src[j].strip()}")
    t2_ins.append((j, al, tbl))

# ---------- 조립 ----------
ins1 = {i: al for i, al, _ in type1}
ins2 = {j: al for j, al, _ in t2_ins}
out = []
for i, t in enumerate(src):
    out.append(t)
    if i in ins1:
        al = ins1[i]
        out.append(f"                --[{MARK}] 버전 술어를 UNION ALL 분기 안으로 push — 아래 JOIN GT_DM35_VERSION 이")
        out.append(f"                --  이미 강제하는 조건의 중복 술어이므로 결과 불변. 원장 선두 인덱스(DIVISION_ID, VERSION_NO)")
        out.append(f"                --  를 access predicate 로 쓰게 해 전면스캔을 없앤다 (hook #129 ②/④ · 1차 VERPUSH 패치와 동일 처방).")
        out.append(f"                AND {al}.{PUSH}")
    if i in ins2:
        al = ins2[i]
        out.append(f"        --[{MARK}] 동일 취지 — 위 JOIN SCM_MGR.GT_DM35_VERSION ON A.VERSION_NO = C.VERSION_NO 와 같은 집합")
        out.append(f"        AND   {al}.{PUSH}")

txt = "\n".join(out)

# ---------- 사후 assert ----------
assert txt.count(MARK) == 5, f"{MARK} {txt.count(MARK)}개 (기대 5)"
before_push = "\n".join(src).count(PUSH)
added = txt.count(PUSH) - before_push
print(f"[추가] 버전 술어 {before_push} → {txt.count(PUSH)} (+{added})")
assert added == 5, f"술어 추가 {added}건 (기대 5)"
for mk, k in (("E20260820-DS2", 1), ("E20260820-WFITEMPERF", 2), ("E20260820-VERPUSH]", 6),
              ("E20260820-RAWSCALAR", 2)):
    c = txt.count(mk)
    assert c == k, f"{mk} {c}개 (기대 {k}) — 기존 패치 훼손"
print("[assert] 기존 마커 DS2 1·WFITEMPERF 2·VERPUSH 6·RAWSCALAR 2 보존")
assert len(out) - len(src) == 4 * 4 + 1 * 2, f"라인 증분 {len(out)-len(src)} (기대 18)"

open(BASE + r"\03_PATCHED_STEPB_BODY.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] 03_PATCHED_STEPB_BODY.sql — {len(out)} lines (+{len(out)-len(src)})")
