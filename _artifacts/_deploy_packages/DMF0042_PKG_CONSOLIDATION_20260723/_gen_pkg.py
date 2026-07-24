# -*- coding: utf-8 -*-
"""PKG_DMF0042 재구성: standalone 10 헤더치환 + 기존 PKG 멤버 2(SAVE,PRICE_CONV) 원문추출. 멤버 12."""
import os, io, re, oracledb
BASE=os.path.dirname(os.path.abspath(__file__)); BK=os.path.join(BASE,"_backup"); SP=os.path.join(BASE,"sp"); os.makedirs(SP,exist_ok=True)
UI="DMF0042"
# standalone에서 멤버화할 것 (live-wired)
FROM_STD=["DMF0042_GET_DM_MDF_VERSION","DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION","DMF0042_GET_EXCHANGE_PRICE",
"DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP","DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA","DMF0042_GET_SPREAD_TITLE",
"DMF0042_SAVE_DM_BP_EXCHANGE_RATE","DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF",
"DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA","DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF",
"DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV"]  # SET_PRICE용 AS-IS 4인자 (오버로드)
# 기존 PKG에서 유지할 멤버 (SAVE + 내부용 5인자 PRICE_CONV 오버로드)
KEEP=["P_DMF0042_SAVE_DM_PLN_BP_FCST","P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV"]

def transform_std(sa):
    t=io.open(os.path.join(BK,f"{sa}_orig.sql"),encoding="utf-8").read()
    hdr=re.compile(r'CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+)?PROCEDURE\s+"SCM_MGR"\."'+re.escape(sa)+r'"')
    assert len(hdr.findall(t))==1, f"{sa} hdr"
    t=hdr.sub(f"PROCEDURE P_{sa}", t)
    # 마지막 END(라벨 유무 무관); 를 END P_sa; 로 (트레일링 / 앞)
    t=re.sub(r'\n/\s*$','\n',t).rstrip()
    m=list(re.finditer(r'(?im)^[ \t]*END\b[ \t]*[A-Za-z0-9_]*[ \t]*;[ \t]*$', t))
    assert m, f"{sa} END 없음"
    last=m[-1]
    t=t[:last.start()]+f"END P_{sa};"+t[last.end():]
    return t.strip("\n")

# 기존 PKG body에서 KEEP 멤버 원문 추출
pkgbody=io.open(os.path.join(BK,f"PKG_{UI}_BODY_orig.sql"),encoding="utf-8").read()
def extract_member(mem):
    m=re.search(r'(?is)(\n[ \t]*PROCEDURE\s+'+mem+r'\b.*?\bEND\s+'+mem+r'\s*;)', pkgbody)
    assert m, f"{mem} 추출 실패"
    return m.group(1).strip("\n")

conn=oracledb.connect(user=os.environ["NSCM_ORA_USER"],password=os.environ["NSCM_ORA_PASS"],dsn=os.environ["NSCM_ORA_DSN"]); cur=conn.cursor()
def decl_from_args(obj, pkg):
    cur.execute("""SELECT argument_name,in_out,data_type FROM all_arguments
      WHERE owner='SCM_MGR' AND object_name=:o AND NVL(package_name,'-')=:p ORDER BY position""", o=obj, p=pkg or '-')
    lines=[f"{nm} {io_} {'SYS_REFCURSOR' if dt=='REF CURSOR' else dt}" for nm,io_,dt in cur.fetchall()]
    name = obj if pkg else "P_"+obj
    return f"    PROCEDURE {name}\n    (\n        " + "\n      , ".join(lines) + "\n    );"

# SPEC
decls=[decl_from_args(sa,None) for sa in FROM_STD] + [decl_from_args(m,"PKG_DMF0042") for m in KEEP]
spec=('CREATE OR REPLACE PACKAGE "SCM_MGR"."PKG_DMF0042" AS\n'
      '/* [PKG CONSOLIDATION 20260723] UI별 PKG 취합 — 멤버 12. standalone live-wired 10 최신화/신규 + 기존 SAVE/PRICE_CONV 2 유지. 본문 무수정. */\n'
      + "\n\n".join(decls) + "\n\nEND PKG_DMF0042;\n/\n")
io.open(os.path.join(SP,"PKG_DMF0042_SPEC.sql"),"w",encoding="utf-8",newline="").write(spec)
# BODY
mems=[transform_std(sa) for sa in FROM_STD] + [extract_member(m) for m in KEEP]
body='CREATE OR REPLACE PACKAGE BODY "SCM_MGR"."PKG_DMF0042" IS\n\n'+"\n\n\n".join(mems)+"\n\nEND PKG_DMF0042;\n/\n"
io.open(os.path.join(SP,"PKG_DMF0042_BODY.sql"),"w",encoding="utf-8",newline="").write(body)
print("SPEC/BODY written. members:", len(FROM_STD)+len(KEEP))
print("body PROCEDURE 수:", len(re.findall(r'\bPROCEDURE\s+P_DMF0042', body)))
