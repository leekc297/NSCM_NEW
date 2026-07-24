# -*- coding: utf-8 -*-
"""PKG_DMF0021 spec/body 생성 — 멤버 4(DATAEX/SPREAD_TITLE/MEASUREINFO/SAVE).
body=백업 원본 헤더/END만 치환(본문 무수정), spec=ALL_ARGUMENTS 재구성. MEASUREINFO2 제외."""
import os, io, re, oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
BK = os.path.join(BASE, "_backup")
SP = os.path.join(BASE, "sp"); os.makedirs(SP, exist_ok=True)

MEMBERS = [
    ("DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX", "END DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx;"),
    ("DMF0021_GET_SPREAD_TITLE",             "END DMF0021_GET_SPREAD_TITLE;"),
    ("DMF0021_GET_SALES_PLAN_MEASUREINFO",   "END DMF0021_GET_SALES_PLAN_MEASUREINFO;"),
    ("DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL",   "END DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL;"),
]

def transform_body(sa, endlabel):
    with io.open(os.path.join(BK, f"{sa}_orig.sql"), "r", encoding="utf-8") as f:
        t = f.read()
    # 1) 헤더: CREATE OR REPLACE [EDITIONABLE] PROCEDURE "SCM_MGR"."sa"  ->  PROCEDURE P_sa
    hdr = re.compile(r'CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+)?PROCEDURE\s+"SCM_MGR"\."' + re.escape(sa) + r'"')
    n = len(hdr.findall(t)); assert n == 1, f"{sa}: header count={n}"
    t = hdr.sub(f"PROCEDURE P_{sa}", t)
    # 2) END 라벨: exact-match 1회
    assert t.count(endlabel) == 1, f"{sa}: endlabel count={t.count(endlabel)}"
    t = t.replace(endlabel, f"END P_{sa};")
    # 3) 트레일링 '/' 제거 + 선두 공백 정리
    t = re.sub(r'\n/\s*$', '\n', t).strip("\n")
    return t

conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
def sig(sa):
    cur.execute("""SELECT argument_name, in_out, data_type FROM all_arguments
      WHERE owner='SCM_MGR' AND object_name=:n AND package_name IS NULL ORDER BY position""", n=sa)
    parts=[]
    for nm, io_, dt in cur.fetchall():
        oradt = "SYS_REFCURSOR" if dt=="REF CURSOR" else dt
        parts.append(f"        {nm:22} {io_:3} {oradt}")
    return "\n      , ".join(p.strip() for p in parts)  # placeholder; rebuild below

# spec 선언 재구성
def spec_decl(sa):
    cur.execute("""SELECT argument_name, in_out, data_type FROM all_arguments
      WHERE owner='SCM_MGR' AND object_name=:n AND package_name IS NULL ORDER BY position""", n=sa)
    lines=[]
    for nm, io_, dt in cur.fetchall():
        oradt = "SYS_REFCURSOR" if dt=="REF CURSOR" else dt
        lines.append(f"{nm} {io_} {oradt}")
    body = "\n      , ".join(lines)
    return f"    PROCEDURE P_{sa}\n    (\n        {body}\n    );"

specs = "\n\n".join(spec_decl(sa) for sa,_ in MEMBERS)
spec = (f'CREATE OR REPLACE PACKAGE "SCM_MGR"."PKG_DMF0021" AS\n'
        f'/* [PKG CONSOLIDATION 20260723] UI별 PKG 취합 — 멤버 4(DATAEX/SPREAD_TITLE/MEASUREINFO/SAVE).\n'
        f'   MEASUREINFO2(미사용 변형본) 제거. 본문 무수정 이관(standalone 라이브 기준). */\n'
        f'{specs}\n\nEND PKG_DMF0021;\n/\n')
with io.open(os.path.join(SP,"PKG_DMF0021_SPEC.sql"),"w",encoding="utf-8",newline="") as f: f.write(spec)
print("SPEC written")

bodies = "\n\n\n".join(transform_body(sa,end) for sa,end in MEMBERS)
body = (f'CREATE OR REPLACE PACKAGE BODY "SCM_MGR"."PKG_DMF0021" AS\n\n'
        f'{bodies}\n\nEND PKG_DMF0021;\n/\n')
with io.open(os.path.join(SP,"PKG_DMF0021_BODY.sql"),"w",encoding="utf-8",newline="") as f: f.write(body)
print("BODY written, members:", body.count("PROCEDURE P_DMF0021"))
