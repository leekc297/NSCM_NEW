"""분기 근거(A) 중 모집단 컬럼으로 이어지지 않은 것의 사유 분포 — 놓친 제외 가능성 점검"""
import os, re, json, collections
HERE = os.path.dirname(os.path.abspath(__file__))
R = json.load(open(os.path.join(HERE, "_cache", "result.json"), encoding="utf-8"))
cols, ev = R["cols"], R["ev"]
popset = {(c["table"], c["column"]) for c in cols}; popcols = {c["column"] for c in cols}
A = [e for e in ev if e["cls"] in ("A", "A_NULLCHK")]
linked = [e for e in A if [x for x in e["refs"] if (x[0], x[1]) in popset]]
un = [e for e in A if e not in linked]
print("분기 근거", len(A), "/ 모집단 연결", len(linked), "/ 미연결", len(un))
print("연결 tier:", collections.Counter(t for e in linked for _, _, t in {tuple(x) for x in e["refs"]}))


def why(e):
    n = e["notes"]
    m = re.search(r": ([^;(]+)", n)
    return (m.group(1).strip() if m else "(참조 없음)")[:28]


def colname(e):
    m = re.match(r"\s*(?:[\w#@]+\.)?([\w@]+):", e["notes"])
    return m.group(1).upper() if m else ""


cnt = collections.Counter(why(e) for e in un)
for k, v in cnt.most_common(20):
    print("  ", k, v)
# 미연결인데 피연산자 컬럼명이 모집단 컬럼명인 것
risky = [e for e in un if colname(e) in popcols]
print("미연결 중 피연산자가 모집단 컬럼명과 같은 것", len(risky))
c2 = collections.Counter((colname(e), why(e)) for e in risky)
for k, v in c2.most_common(40):
    print("  ", k, v)
for e in risky[:12]:
    print("   >", e["object"], e["line"], e["notes"][:90], "|", e["snip"][:200])
