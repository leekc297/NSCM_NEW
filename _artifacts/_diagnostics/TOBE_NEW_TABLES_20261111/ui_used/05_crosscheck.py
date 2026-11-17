"""05_crosscheck.py — 독립 2차 방법 대조: 사용 멤버 본문(주석 제거·문자열 마스킹)에 등장하는 '실존 TABLE/VIEW 이름' 식별자 전수
   vs 04 파서 추출 결과. 파서에 없는 등장 = (a) %TYPE 앵커 (b) 컬럼/별칭 동명 (c) 파서 누락 후보 → 원문 문맥과 함께 출력."""
import csv, re, collections
exec(open("04_closure.py", encoding="utf-8").read().split("# ───────────── 진입 시드 ─────────────")[0])
cm = list(csv.DictReader(open("closure_members.csv", encoding="utf-8-sig")))
mt = list(csv.DictReader(open("member_tables.csv", encoding="utf-8-sig")))
got = collections.defaultdict(set)
for r in mt: got[r["NODE"]].add(r["T_NAME"])
TV = {n for (o, n), t in OTYPE.items() if t & {"TABLE", "VIEW", "MATERIALIZED VIEW"}}
SYNS = {s for (o, s) in SYN if (o in ("PUBLIC", "SCM_MGR"))}
rows = []
for r in cm:
    own, nm, mb, k = r["OWNER"], r["OBJECT"], r["MEMBER"], r["KIND"]
    p = parsed(own, nm, "PACKAGE BODY" if k == "PACKAGE" else k)
    if not p: continue
    seg = mb if k == "PACKAGE" else "<OBJECT>"
    masked = seg_text(p, seg, 1).upper()
    for m in re.finditer(r"(?<![A-Z0-9_$#])([A-Z_][A-Z0-9_$#]*)(?![A-Z0-9_$#])", masked):
        w = m.group(1)
        if w not in TV and w not in SYNS: continue
        r2 = resolve_name([w], own)
        if not r2 or not (r2[2] & {"TABLE", "VIEW", "MATERIALIZED VIEW"}): continue
        if r2[1] in got[r["NODE"]]: continue
        ctx = masked[max(0, m.start() - 60):m.end() + 30].replace("\n", " ")
        after = masked[m.end():m.end() + 12]
        pre = masked[max(0, m.start() - 2):m.start()]
        kind = "ANCHOR(%TYPE)" if re.match(r"\s*\.\s*[A-Z_0-9$#]+\s*%|\s*%", after) else ("QUALIFIER(별칭.컬럼)" if pre.endswith(".") or after.lstrip().startswith(".") else "REVIEW")
        rows.append(dict(NODE=r["NODE"], NAME=r2[1], KIND=kind, CTX=re.sub(r"\s+", " ", ctx)))
with open("crosscheck_dictmatch.csv", "w", encoding="utf-8-sig", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["NODE", "NAME", "KIND", "CTX"]); w.writeheader()
    for x in rows: w.writerow(x)
c = collections.Counter(x["KIND"] for x in rows)
print("dict-match not in parser:", len(rows), c)
seen = set()
for x in rows:
    if x["KIND"] != "REVIEW": continue
    k = (x["NODE"], x["NAME"])
    if k in seen: continue
    seen.add(k); print(x["NODE"], x["NAME"], "|", x["CTX"][:150])
