# -*- coding: utf-8 -*-
"""DEPT_ID 룰 변경 전/후 건수 대사 하네스 — 동일 파라미터로 대상 GET SP 호출, 커서별 행수 + DEPT_ID 분포 기록"""
import sys, json, time, hashlib, oracledb, collections, pathlib
TAG=sys.argv[1]  # before | after
OUT=pathlib.Path(__file__).parent/f"baseline_{TAG}.json"
USER="minyonglee1"; FR,TO,NOW="20260801","20270228","20260824"
DIVS=["40","81","82"]
BASE={"P_DEPT_ID":"ALL","P_END_CUSTOMER":"ALL","P_SCM_SITE_ID":"ALL","P_PLANT_SITE_ID":"ALL","P_PROJECT_CODE":"","P_ITEM_ID":"",
 "P_CUSTOMER_PROJECT_CODE":"","P_CUSTOMER_MODEL":"","P_FROM_YYYYMMDD":FR,"P_TO_YYYYMMDD":TO,"P_NOW_YYYYMMDD":NOW,"P_BIZTYPE":"ALL","P_BIZ_TYPE":"ALL",
 "P_CREATED_BY":USER,"P_USER_ID":USER,"P_USERINFO":USER,"P_OWNER":"","P_OWNER_ID":"ALL","P_OVER_RANGE":"N","P_INVALID_EXEC":"N","P_VERSION_TYPE":"CURRENT",
 "P_VERSION_NO":"Current","P_ITEM_TYPE":"ALL","P_BUCKET":"MONTHLY","P_INTERNAL_YN":"N","P_CELL_YN":"N","P_QTY_YN":"N","P_USER_DEPT_ID":"","P_GROUP_ID":"",
 "P_TEAM_ID":"ALL","P_CUSTOMER":"ALL","P_USER_GROUP":"DM ADMIN","P_SENDER_CODE":"ALL","P_DIFF_ONLY":"False"}
PROCS=[ # (package, proc, menu, overrides)
 (None,"DMF0020_GET_SCM_MST_FUTURE_PRICE","DMF0020",{"P_PROJECT_CODE":"ALL","P_ITEM_ID":"ALL","P_OWNER":"ALL"}),
 (None,"DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP","DMF0020",{"P_PROJECT_CODE":"ALL","P_ITEM_ID":"ALL","P_OWNER":"ALL"}),
 ("PKG_DMF0020","P_DMF0020_GET_SALES_PRICE_TEMPLATE","DMF0020",{}),
 ("PKG_DMF0020","P_DMF0020_GET_OWNER_DATA","DMF0020",{"P_PROJECT_CODE":"ALL"}),
 ("PKG_DMF0020","P_DMF0020_GET_SCM_MST_FUTURE_PRICE","DMF0020",{"P_PROJECT_CODE":"ALL","P_ITEM_ID":"ALL","P_OWNER":"ALL"}),
 ("PKG_DMF0020","P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP","DMF0020",{"P_PROJECT_CODE":"ALL","P_ITEM_ID":"ALL","P_OWNER":"ALL"}),
 ("PKG_DMF0022","P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL","DMF0035",{"P_VERSION_TYPE":"CURRENT"}),
 ("PKG_DMF0035","P_DMF0035_GET_MKT_FCST_WATERFALL","DMF0035",{"P_VERSION_NO":"CURRENT"}),
 ("PKG_DMF0040","P_DMF0040_GET_MKT_FCST_COMPARISON","DMF0040",{}),
 ("PKG_DMF0051","P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL","DMF0035",{"P_VERSION_TYPE":"CURRENT"}),
 ("PKG_DMF0074","P_DMF0074_GET_METAL_LINK_PRICE","DMF0074",{"P_FROM_YYYYMMDD":"202401","P_TO_YYYYMMDD":"202712"}),
 ("PKG_DMF0074","P_DMF0074_GET_METAL_LINK_TEMPLATE","DMF0074",{}),
 ("PKG_DMF0082","P_DMF0082_GET_MAIN_DATA","DMF0082",{"P_PROJECT_CODE":"ALL","P_OWNER":"ALL","P_VERSION_TYPE":"Current"}),
 ("PKG_DMF0082","P_DMF0082_GET_MAIN_DATA_CURRENT","DMF0082",{"P_PROJECT_CODE":"ALL","P_OWNER":"ALL","P_VERSION_TYPE":"Current"}),
 ("PKG_DMF0082","P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP","DMF0082",{"P_PROJECT_CODE":"ALL","P_ITEM_ID":"ALL","P_OWNER":"ALL"}),
]
cn=oracledb.connect(user="SCM_MGR",password="zionex1!",dsn="175.211.29.206:2521/AJS"); cn.call_timeout=300000; cur=cn.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
res={}
for pkg,proc,menu,ov in PROCS:
    if pkg: cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME=:k AND OBJECT_NAME=:o AND DATA_LEVEL=0 ORDER BY POSITION",k=pkg,o=proc)
    else: cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME IS NULL AND OBJECT_NAME=:o AND DATA_LEVEL=0 ORDER BY POSITION",o=proc)
    args=cur.fetchall(); full=(pkg+"." if pkg else "")+proc
    for div in DIVS:
        if proc=="DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP" and div=="40": print("SKIP standalone POPUP|40 (GT_DMF0020_PJT 적재 >10min)",flush=True); continue
        vals={**BASE,**ov,"P_DIVISION_ID":div,"P_MENU_ID":menu,"P_MNU_ID":menu}
        ins=[]; outs=[]
        for a,io in args:
            if io=="IN": ins.append(vals.get(a,""))
            else: outs.append(cn.cursor())
        key=f"{full}|{div}"; t0=time.time()
        try:
            cur.callproc(full, ins+outs)
            el=round(time.time()-t0,1); curs=[]
            for i,oc in enumerate(outs):
                try:
                    cols=[c[0] for c in oc.description]; rows=oc.fetchall()
                    di=cols.index("DEPT_ID") if "DEPT_ID" in cols else None
                    dep=collections.Counter(str(r[di]) for r in rows) if di is not None else None
                    h=hashlib.md5("\n".join(sorted("|".join("" if v is None else str(v) for v in r) for r in rows)).encode("utf-8","ignore")).hexdigest() if len(rows)<=200000 else None
                    curs.append({"cursor":i+1,"rows":len(rows),"cols":len(cols),"dept_distinct":(len(dep) if dep else None),"dept_null":(dep.get("None",0) if dep else None),"hash":h})
                except Exception as e:
                    curs.append({"cursor":i+1,"error":str(e)[:120]})
            res[key]={"elapsed":el,"cursors":curs}
            print(f"OK   {key:80s} {el:6.1f}s  "+" ".join(f"c{c['cursor']}={c.get('rows','ERR')}" for c in curs)+"  "+" ".join(f"[dept {c['dept_distinct']}/{c['dept_null']}null]" for c in curs if c.get('dept_distinct') is not None), flush=True)
        except Exception as e:
            res[key]={"error":str(e).splitlines()[0][:200]}
            print(f"FAIL {key:80s} {str(e).splitlines()[0][:150]}", flush=True)
        cn.rollback()
OUT.write_text(json.dumps(res,indent=1,ensure_ascii=False),encoding="utf-8")
print("saved",OUT)
