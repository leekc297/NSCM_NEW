# -*- coding: utf-8 -*-
"""SQL_FULLTEXT ↔ BODY INSERT 16곳 정밀 대조 (바인드 무관 세그먼트 매칭).

PL/SQL 정적 SQL 은 로컬 변수가 :B1..:Bn 으로 치환되어 V$SQL 에 저장된다.
따라서 FULLTEXT 를 :Bn 기준으로 쪼갠 **리터럴 세그먼트 전부**가 BODY 문장에 **순서대로** 나타나는지로 판정한다.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
full = open(BASE + r"\10_SQLID_g0w0gvnn7rkb2_FULLTEXT.sql", encoding="utf-8").read()

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
con.close()


def norm(s):
    s = re.sub(r"/\*.*?\*/", " ", s, flags=re.S)
    s = re.sub(r"--[^\n]*", " ", s)
    s = re.sub(r"\s+", " ", s)
    # 연산자 주변 공백 통일
    s = re.sub(r"\s*([(),=<>|+*/-])\s*", r"\1", s)
    return s.strip().upper()


nfull = norm(full).rstrip(";")
segs = [x for x in re.split(r":B\d+", nfull) if x.strip()]
nbind = len(re.findall(r":B\d+", nfull))
print(f"FULLTEXT: {len(nfull)}자 / 바인드 {nbind}개 / 리터럴 세그먼트 {len(segs)}개")

text_by_line = {ln: t for ln, t in src}
maxln = src[-1][0]
starts = [ln for ln, t in src if re.search(r"INSERT\s+INTO\s+SCM_MGR\.GT_DM35_RAW_DATA\b", t, re.I)]

results = []
for s in starts:
    buf, ln = [], s
    while ln <= maxln:
        t = text_by_line.get(ln, "")
        buf.append(t)
        if ";" in re.sub(r"--[^\n]*", "", t):
            break
        ln += 1
    nst = norm("\n".join(buf)).rstrip(";")
    pos, ok, miss = 0, True, None
    for i, sg in enumerate(segs):
        j = nst.find(sg, pos)
        if j < 0:
            ok = False
            miss = i
            break
        pos = j + len(sg)
    results.append((s, ln, ok, miss, len(nst)))
    print(f"  L{s:>5}-{ln:<5} 세그먼트 {'전부일치' if ok else f'{miss}/{len(segs)} 에서 실패'}  (문장 {len(nst)}자)")

win = [r for r in results if r[2]]
print(f"\n[특정] 세그먼트 전부 일치: {[r[0] for r in win]}")
if len(win) != 1:
    print("[STOP] 유일 특정 실패 — 추가 판별 필요")
    # 실패 세그먼트 인덱스 분포로 근접 후보 확인
    for s, e, ok, miss, L in results:
        if not ok and miss is not None and miss >= 1:
            print(f"   L{s}: 세그먼트 {miss} 미발견 → {segs[miss][:120]!r}")
    sys.exit(3)

s, e, _, _, _ = win[0]
print(f"\n[확정] SQL_ID g0w0gvnn7rkb2 = BODY L{s} ~ L{e}")
print("\n=== 해당 문장 원문 ===")
for ln in range(s, e + 1):
    print(f"{ln:>5}| {text_by_line[ln]}")
