"""CELL_PROD_SITE_ID 주변 '-' 리터럴 문맥 덤프 — 같은 줄 또는 ±2줄 안에 CELL_PROD 가 있는 코드 줄(주석 제외). 원문 ALL_SOURCE 새로 조회 → sources/ 저장"""
import sys, os, re, json; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
HERE = os.path.dirname(os.path.abspath(__file__)); os.makedirs(os.path.join(HERE, "sources"), exist_ok=True)
u,p,d = conn_info(); cur = oracledb.connect(user=u,password=p,dsn=d).cursor()
cur.execute("""SELECT DISTINCT NAME, TYPE FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%CELL_PROD%' AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION','PACKAGE','VIEW','TRIGGER') ORDER BY 1,2""")
objs = cur.fetchall()
def code(t):  # 줄 주석·문자열 밖 '--' 제거 (단순: 첫 '--' 이전)
    out, q = [], False
    i = 0
    while i < len(t):
        ch = t[i]
        if ch == "'": q = not q
        if not q and t[i:i+2] == "--": break
        out.append(ch); i += 1
    return "".join(out)
rep, meta = [], {}
for n, ty in objs:
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=n, t=ty)
    r = cur.fetchone(); 
    cur.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=n, t=ty)
    lines = [x[1].rstrip("\n") for x in cur]
    src = "\n".join(lines)
    open(os.path.join(HERE, "sources", f"{n}.{ty.replace(' ','_')}.sql"), "w", encoding="utf-8", newline="\n").write(src)
    # 블록 주석 위치 마스킹
    blk = [False]*len(lines); inb = False
    for i, l in enumerate(lines):
        c = code(l)
        if inb: blk[i] = True
        if "/*" in c and "*/" not in c[c.find("/*"):]: inb = True; blk[i] = blk[i] or c.strip().startswith("/*")
        if inb and "*/" in c: inb = False
    hits = []
    for i, l in enumerate(lines):
        c = code(l)
        if blk[i] or "'-'" not in c: continue
        win = " ".join(code(lines[j]).upper() for j in range(max(0,i-2), min(len(lines), i+3)))
        if "CELL_PROD" in win: hits.append(i)
    if hits:
        meta[f"{n}|{ty}"] = {"last_ddl": r[0], "status": r[1], "hits": [h+1 for h in hits], "same_line": sum(1 for h in hits if "CELL_PROD" in code(lines[h]).upper())}
        for h in hits:
            rep.append(f"### {n} [{ty}] L{h+1}  (LAST_DDL {r[0]})")
            for j in range(max(0,h-3), min(len(lines), h+3)):
                rep.append((">>" if j == h else "  ") + f"{j+1:6d}| {lines[j]}")
open(os.path.join(HERE, "context_dump.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(rep))
json.dump(meta, open(os.path.join(HERE, "context_meta.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("objects with CELL_PROD:", len(objs), "| with '-' near CELL_PROD:", len(meta), "| hit lines:", sum(len(v["hits"]) for v in meta.values()))
for k, v in meta.items(): print(f"  {k:70s} hits {len(v['hits']):3d} (same-line {v['same_line']}) LAST_DDL {v['last_ddl']} {v['status']}")
