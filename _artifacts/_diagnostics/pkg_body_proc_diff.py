# -*- coding: utf-8 -*-
"""PKG BODY 두 본을 프로시저/함수 단위로 분해해 정규화 diff — python pkg_body_proc_diff.py <cloud.sql> <ours.sql> [out.md]"""
import io, re, sys, difflib, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

def read(p):
    b = pathlib.Path(p).read_bytes()
    for enc in ("utf-8-sig", "cp949", "euc-kr", "latin-1"):
        try: return b.decode(enc)
        except UnicodeDecodeError: continue
    return b.decode("utf-8", "replace")

def strip_comments(t):
    t = re.sub(r"/\*.*?\*/", " ", t, flags=re.S)
    t = re.sub(r"--[^\n]*", " ", t)
    return t

def split_units(t):
    """PROCEDURE/FUNCTION name ... END name; 단위로 분해 (주석 제거본 기준)."""
    units = {}
    for m in re.finditer(r"\b(PROCEDURE|FUNCTION)\s+(\w+)\b", t, flags=re.I):
        name = m.group(2).upper(); start = m.start()
        e = re.search(r"\bEND\s+" + re.escape(name) + r"\s*;", t[start:], flags=re.I)
        if not e: continue
        units[name] = t[start:start + e.end()]
    return units

def norm(s):
    s = re.sub(r"\s+", " ", s).strip().upper()
    s = re.sub(r"\s*([(),;=<>|+\-*/])\s*", r"\1", s)
    return s

cloud, ours = read(sys.argv[1]), read(sys.argv[2])
cu, ou = split_units(strip_comments(cloud)), split_units(strip_comments(ours))
names = sorted(set(cu) | set(ou))
rows = []; details = []
for n in names:
    a, b = cu.get(n), ou.get(n)
    if a is None: rows.append((n, "사내에만 있음 (클라우드 부재) → 클라우드 SPEC 에 선언 없으면 BODY 컴파일 실패")); continue
    if b is None: rows.append((n, "⚠ 클라우드에만 있음 → 이관본 적용 시 유실")); continue
    if norm(a) == norm(b): rows.append((n, "동일(공백·주석 무시)")); continue
    rows.append((n, "차이 있음"))
    al = [norm(x) for x in re.split(r"(?<=;)", a) if x.strip()]
    bl = [norm(x) for x in re.split(r"(?<=;)", b) if x.strip()]
    d = [l for l in difflib.unified_diff(al, bl, "cloud", "corp", lineterm="", n=0) if not l.startswith(("---", "+++", "@@"))]
    details.append((n, d[:40], len(d)))
print(f"cloud units {len(cu)} / corp units {len(ou)}")
for n, v in rows: print(f"  {n:48} {v}")
for n, d, tot in details:
    print(f"\n=== {n} (statement diff {tot}줄, 앞 40) ===")
    for l in d: print("   ", l[:220])
if len(sys.argv) > 3:
    out = ["# PKG BODY 프로시저 단위 diff", f"- cloud: `{sys.argv[1]}`", f"- corp : `{sys.argv[2]}`", "", "| 프로시저 | 판정 |", "|---|---|"]
    out += [f"| {n} | {v} |" for n, v in rows]
    for n, d, tot in details:
        out += ["", f"## {n} (statement diff {tot}줄)", "```diff"] + [l[:400] for l in d] + ["```"]
    pathlib.Path(sys.argv[3]).write_text("\n".join(out) + "\n", encoding="utf-8"); print("\nreport:", sys.argv[3])
