# -*- coding: utf-8 -*-
"""PKG_DMF0003 재구성: 14 standalone(8 refresh + 6 new) 헤더치환 + 9 기존PKG멤버 원문유지 = 23멤버."""
import os, io, re, oracledb
BASE=os.path.dirname(os.path.abspath(__file__)); BK=os.path.join(BASE,"_backup"); SP=os.path.join(BASE,"sp"); os.makedirs(SP,exist_ok=True)
UI="DMF0003"
FROM_STD=[  # 8 refresh
 "DMF0003_GET_DM_ANL_CAR_PROPERTY","DMF0003_GET_DM_ANL_CAR_REF","DMF0003_GET_DM_ANL_MKT_PSI_DPINIT",
 "DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT","DMF0003_GET_MKT_FCST_COMPARE_POPUP","DMF0003_GET_SPREAD_TITLE",
 "DMF0003_GET_SPREAD_TITLE_CAR","DMF0003_GET_SPREAD_TITLE_PSI",
 # 6 new (twin無)
 "DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC","DMF0003_GET_DM_ANL_MKT_PSI_DATA","DMF0003_GET_PRPOPUP",
 "DMF0003_GET_PR_HISTORY_POPUP","DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL","DMF0003_SAVE_PRPOPUP"]
KEEP=[  # 9 기존 PKG 멤버 (authoritative/미사용twin)
 "P_DMF0003_GET_MKT_FCST_DATA","P_DMF0003_SAVE_MKT_FCST","P_DMF0003_CAR_FCST_EXCEL_UPLOAD",
 "P_DMF0003_GET_BUCKET_TYPE_CODE","P_DMF0003_GET_QTY_TYPE_CODE","P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE",
 "P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP","P_DMF0003_MKT_FCST_SALES_PLAN_SYNC","P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE"]

def transform_std(sa):
    t=io.open(os.path.join(BK,f"{sa}_orig.sql"),encoding="utf-8").read()
    hdr=re.compile(r'CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+)?PROCEDURE\s+"SCM_MGR"\."'+re.escape(sa)+r'"')
    assert len(hdr.findall(t))==1, f"{sa} hdr"
    t=hdr.sub(f"PROCEDURE P_{sa}", t)
    t=re.sub(r'\n/\s*$','\n',t).rstrip()
    m=list(re.finditer(r'(?im)^[ \t]*END\b[ \t]*[A-Za-z0-9_]*[ \t]*;[ \t]*$', t))
    assert m, f"{sa} END"
    last=m[-1]; t=t[:last.start()]+f"END P_{sa};"+t[last.end():]
    return t.strip("\n")

pkgbody=io.open(os.path.join(BK,f"PKG_{UI}_BODY_orig.sql"),encoding="utf-8").read()
# 본문 여는 줄 (IS/AS) 보존
mopen=re.search(r'(CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+)?PACKAGE\s+BODY\s+"SCM_MGR"\."'+UI.join(["PKG_",""])+r'"\s+(?:IS|AS))', pkgbody, re.I)
open_line='CREATE OR REPLACE PACKAGE BODY "SCM_MGR"."PKG_'+UI+'" IS'
def extract_member(mem):
    m=re.search(r'(?is)(\n[ \t]*PROCEDURE\s+'+mem+r'\b.*?\bEND\s+'+mem+r'\s*;)', pkgbody)
    assert m, f"{mem} 추출실패"
    return m.group(1).strip("\n")

def decl_from_membertext(memtext, memname):
    # 주석 제거 후 PROCEDURE memname 의 balanced (...) 추출 → spec 선언(DEFAULT 포함)
    h=re.sub(r'/\*.*?\*/',' ',memtext,flags=re.S); h=re.sub(r'--[^\n]*',' ',h)
    m=re.search(r'PROCEDURE\s+'+re.escape(memname)+r'\b', h); j=m.end()
    while j<len(h) and h[j] in ' \t\r\n': j+=1
    if j<len(h) and h[j]=='(':
        depth=0; k=j
        while k<len(h):
            if h[k]=='(': depth+=1
            elif h[k]==')':
                depth-=1
                if depth==0: break
            k+=1
        params=re.sub(r'\s+',' ',h[j:k+1]).strip()
        return f"    PROCEDURE {memname}\n    {params};"
    return f"    PROCEDURE {memname};"
mem_std=[(f"P_{sa}", transform_std(sa)) for sa in FROM_STD]
mem_keep=[(m, extract_member(m)) for m in KEEP]
allmems=mem_std+mem_keep
decls=[decl_from_membertext(txt,name) for name,txt in allmems]
spec=('CREATE OR REPLACE PACKAGE "SCM_MGR"."PKG_'+UI+'" AS\n'
      '/* [PKG CONSOLIDATION 20260723] UI별 PKG 취합 — 멤버 23. standalone live 14 최신화/신규 + 기존 9 유지. 본문 무수정. */\n'
      +"\n\n".join(decls)+"\n\nEND PKG_"+UI+";\n/\n")
io.open(os.path.join(SP,f"PKG_{UI}_SPEC.sql"),"w",encoding="utf-8",newline="").write(spec)
body=open_line+"\n\n"+"\n\n\n".join(txt for _,txt in allmems)+"\n\nEND PKG_"+UI+";\n/\n"
io.open(os.path.join(SP,f"PKG_{UI}_BODY.sql"),"w",encoding="utf-8",newline="").write(body)
print("members:", len(allmems), "| body PROCEDURE:", len(re.findall(r'\bPROCEDURE\s+P_DMF0003',body)))
