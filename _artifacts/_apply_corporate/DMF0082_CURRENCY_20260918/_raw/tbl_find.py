# -*- coding: utf-8 -*-
"""DMF0072/0007/0006 의 저장 대상 테이블을 PKG 원문에서 추출"""
import re, pathlib, sys, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

for pkg in ("PKG_DMF0072", "PKG_DMF0007", "PKG_DMF0006", "PKG_DMF0005"):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:p
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""", p=pkg)
    body = "".join(r[0] for r in cur)
    if not body:
        print("{:14s} — 패키지 없음".format(pkg)); continue
    tabs = collections.Counter()
    for kw in ("INSERT INTO", "MERGE INTO", "UPDATE", "DELETE FROM"):
        for t in re.findall(kw + r"\s+(?:SCM_MGR\.)?([A-Z][A-Z0-9_]{6,})", body):
            if not t.startswith("GT_"):
                tabs[t] += 1
    print("{:14s} {:6,}줄  저장대상: {}".format(
        pkg, body.count(chr(10)) + 1, [t for t, _ in tabs.most_common(6)]))
