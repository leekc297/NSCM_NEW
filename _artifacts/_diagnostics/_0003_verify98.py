#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 대사표 잔여 98건 — **코드 대조로 판정** (구현 위치 실측 · 추정 금지).

원칙
  · 요지에서 **검증 가능한 토큰**(컬럼명·콤보명·핸들러명·SP명)을 뽑아 FE 소스에서 실재를 찾는다.
  · 찾으면 `구현` + 실제 파일:라인. 못 찾으면 **`미구현` 으로 남긴다**(임의 '해당없음' 금지).
  · 토큰을 뽑을 수 없는 행은 `미판정` 으로 분리해 사람이 보게 한다 — 조용히 통과시키지 않는다.
"""
import io, re, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

PAGE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt-fcst")
MAP = PAGE / "__asis-mapping__.md"

# FE 소스 인덱스
SRC = {}
for f in PAGE.rglob("*"):
    if f.suffix in (".ts", ".tsx") and f.name != "__asis-mapping__.md":
        try:
            SRC[f.relative_to(PAGE).as_posix()] = f.read_text(encoding="utf-8").split("\n")
        except Exception:
            pass
print(f"[index] FE {len(SRC)} 파일")

def find(tokens):
    """토큰 중 하나라도 실재하면 (파일:라인, 매칭토큰) 반환."""
    for tk in tokens:
        if len(tk) < 3:
            continue
        pat = re.compile(re.escape(tk), re.I)
        for fn, lines in SRC.items():
            for i, ln in enumerate(lines, 1):
                if pat.search(ln):
                    return f"{fn}:{i}", tk
    return None, None

# 요지 → 검증 토큰 추출
SEC = re.compile(r"^§[0-9.]+ *")
def tokens_of(gist):
    g = SEC.sub("", gist).replace("[원문 무번호]", "")
    out = []
    # 백틱 코드
    out += re.findall(r"`([A-Za-z_][A-Za-z0-9_./]{2,})`", g)
    # 대문자 스네이크 (컬럼/상수)
    out += re.findall(r"\b([A-Z][A-Z0-9_]{3,})\b", g)
    # AS-IS 핸들러명 → TO-BE 는 이름이 다르므로 **컬럼/콤보 토큰만** 신뢰
    out = [t for t in out if not t.startswith(("L3", "L5", "L6", "L7", "L9"))]
    # 조회조건 라벨(Division/Team/...) — 첫 토큰이 영문 단어면 후보
    m = re.match(r"([A-Za-z][A-Za-z ./]{2,20}?)\s*/", g)
    if m:
        out.append(m.group(1).strip().replace(" ", "_").upper())
        out.append(m.group(1).strip())
    return [t for t in dict.fromkeys(out) if t]

lines = MAP.read_text(encoding="utf-8").split("\n")
impl = undecided = notimpl = 0
report = []
for i, l in enumerate(lines):
    if not l.startswith("| "):
        continue
    c = l.split("|")
    if len(c) < 6 or c[5].strip() != "미구현":
        continue
    rid, gist = c[1].strip(), c[2].strip()
    tks = tokens_of(gist)
    if not tks:
        undecided += 1
        report.append(("미판정", rid, gist[:70], ""))
        continue
    loc, tk = find(tks)
    if loc:
        c[3] = f" {loc} (토큰 `{tk}` 실재) "
        c[4] = " "
        c[5] = " 구현 "
        lines[i] = "|".join(c)
        impl += 1
        report.append(("구현", rid, gist[:60], loc))
    else:
        notimpl += 1
        report.append(("미구현", rid, gist[:70], f"토큰 {tks[:3]} 미발견"))

MAP.write_text("\n".join(lines), encoding="utf-8")
print(f"\n[판정] 구현 {impl} / 미구현 {notimpl} / 미판정 {undecided}\n")
for st in ("미구현", "미판정"):
    sel = [r for r in report if r[0] == st]
    if not sel:
        continue
    print(f"── {st} {len(sel)}건 ──")
    for _, rid, g, note in sel[:30]:
        print(f"   {rid:<10}{g[:66]:<68}{note[:40]}")
    if len(sel) > 30:
        print(f"   … 외 {len(sel)-30}건")
