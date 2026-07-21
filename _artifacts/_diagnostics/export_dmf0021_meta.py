# -*- coding: utf-8 -*-
"""DMF0021 전체 이관 — 사내(OCGSCMD_P01) 메타 전수 export → 멱등 MERGE SQL + SP/PKG DDL.
   export_dmf0082_meta.py 를 DMF0021 로 적응. 출력: _deploy_packages/DMF0021_20260721_0903/{sql,sp}/*.sql
"""
import io, importlib.util, datetime, decimal
spec = importlib.util.spec_from_file_location("ora", r"C:\Projects\NSCM\_artifacts\_diagnostics\ora.py")
ora = importlib.util.module_from_spec(spec); spec.loader.exec_module(ora)
import oracledb
u, p, d = ora.conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
OUT = r'C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0021_20260721_0903'
OWN = 'SCM_MGR'

def cols_of(t):
    cur.execute("SELECT column_name FROM all_tab_columns WHERE owner=:o AND table_name=:t ORDER BY column_id", o=OWN, t=t)
    return [r[0] for r in cur.fetchall()]
def lit(v):
    if v is None: return 'NULL'
    if isinstance(v,(int,float,decimal.Decimal)): return str(v)
    if isinstance(v,datetime.datetime): return "TO_DATE('%s','YYYY-MM-DD HH24:MI:SS')"%v.strftime('%Y-%m-%d %H:%M:%S')
    if isinstance(v,datetime.date): return "TO_DATE('%s','YYYY-MM-DD')"%v.strftime('%Y-%m-%d')
    return "'%s'"%str(v).replace("'","''")
def export_merge(fh, table, where, pk, order=None):
    names = cols_of(table)
    if not names: fh.write("-- WARN %s : 컬럼 0\n\n"%table); return 0
    sql = "SELECT %s FROM %s.%s WHERE %s"%(', '.join(names), OWN, table, where)
    if order: sql += " ORDER BY "+order
    cur.execute(sql); rows = cur.fetchall()
    fh.write("-- ============================================================\n")
    fh.write("-- %s  (%d rows, PK=%s)\n"%(table, len(rows), '+'.join(pk)))
    fh.write("-- ============================================================\n")
    if not rows: fh.write("-- (대상 0행)\n\n"); return 0
    non_pk = [n for n in names if n not in pk]
    for r in rows:
        vals = dict(zip(names, r))
        using = ', '.join("%s AS %s"%(lit(vals[n]), n) for n in names)
        on = ' AND '.join("t.%s = s.%s"%(k,k) for k in pk)
        setc = ', '.join("t.%s = s.%s"%(n,n) for n in non_pk) or "t.%s = s.%s"%(pk[0],pk[0])
        fh.write("MERGE INTO %s.%s t USING (SELECT %s FROM DUAL) s\n"%(OWN,table,using))
        fh.write("ON (%s)\n"%on)
        fh.write("WHEN MATCHED THEN UPDATE SET %s\n"%setc)
        fh.write("WHEN NOT MATCHED THEN INSERT (%s) VALUES (%s);\n"%(', '.join(names), ', '.join("s.%s"%n for n in names)))
    fh.write("\n"); return len(rows)
def header(fh, title):
    fh.write("-- =====================================================================\n")
    fh.write("-- DMF0021 (Sales Plan) 전체 이관 — %s\n"%title)
    fh.write("-- 사내 OCGSCMD_P01 실측 export (2026-07-21). 멱등 MERGE. 스키마 SCM_MGR.\n")
    fh.write("-- =====================================================================\n\n")

stat = {}
with io.open(OUT+r'\sql\01_DMF0021_menu_api_button.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'메뉴 · API · 버튼 배선')
    stat['MNU_M']=export_merge(f,'SCM_ADM_MNU_M',"MNU_ID='DMF0021'",['MNU_ID'])
    stat['MNU_BTN_MPG']=export_merge(f,'SCM_ADM_MNU_BTN_MPG_M',"MNU_ID='DMF0021'",['MNU_ID','SHT_NM','MNU_BTN_CD','API_ID'],"SHT_NM, MNU_BTN_CD, API_ID")
    stat['API_M']=export_merge(f,'SCM_ADM_API_M',"API_ID IN (SELECT DISTINCT API_ID FROM %s.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0021')"%OWN,['API_ID'],"API_ID")
with io.open(OUT+r'\sql\02_DMF0021_proc_m.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'PROC_M — SP positional 시그니처 배선')
    stat['PROC_M']=export_merge(f,'SCM_ADM_PROC_M',
        "PROC_NM IN (SELECT DISTINCT a.API_URL FROM %s.SCM_ADM_API_M a JOIN %s.SCM_ADM_MNU_BTN_MPG_M b ON b.API_ID=a.API_ID WHERE b.MNU_ID='DMF0021')"%(OWN,OWN),
        ['PROC_NM','COL_NM'],"PROC_NM, SORT_ORD")
with io.open(OUT+r'\sql\03_DMF0021_sheet_columns_measure.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'UI Category Setup — SHEET_COLUMNS / SHEET_MEASURE (⭐ FROM_SITE_ID 81행 포함)')
    stat['SHEET_COLUMNS']=export_merge(f,'SCM_MST_SHEET_COLUMNS',"PROGRAM_ID='DMF0021'",['PROGRAM_ID','SHEET_NAME','COLUMN_NAME','DIVISION_ID'],"SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")
    sm=cols_of('SCM_MST_SHEET_MEASURE'); sm_pk=['PROGRAM_ID','SHEET_NAME','COLUMN_NAME']+(['DIVISION_ID'] if 'DIVISION_ID' in sm else [])
    stat['SHEET_MEASURE']=export_merge(f,'SCM_MST_SHEET_MEASURE',"PROGRAM_ID='DMF0021'",sm_pk,"SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")
with io.open(OUT+r'\sql\04_DMF0021_authority.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'권한 — 메뉴/버튼 접근 (USER_GR)')
    ug=cols_of('SCM_ADM_USER_GR_MNU_MPG_M'); ug_pk=[c for c in ('USER_GR_ID','MNU_ID') if c in ug] or ['MNU_ID']
    stat['USER_GR_MNU']=export_merge(f,'SCM_ADM_USER_GR_MNU_MPG_M',"MNU_ID='DMF0021'",ug_pk)
    ub=cols_of('SCM_ADM_USER_GR_MNU_BTN_MPG_M'); ub_pk=[c for c in ('USER_GR_ID','MNU_ID','SHT_NM','MNU_BTN_CD') if c in ub] or ['MNU_ID']
    stat['USER_GR_BTN']=export_merge(f,'SCM_ADM_USER_GR_MNU_BTN_MPG_M',"MNU_ID='DMF0021'",ub_pk)
COMBOS=['BizTypeByDivision','CELL_PROD_SITE_ID','DM_COMPANY','DOM_EXP','DeptId','Division','DmBizType',
        'EndCustomerByDivision40','EndCustomerByDivisionDept','FcstType','FromSiteByDivision','Incoterms',
        'ItemType','Measure','SiteByEndCustomer_InnerCode','YesOrNo','BucketType','SalesPlanUserAuthGroup',
        'CurrencyList','PlantSitebyEndCustomer','EndCustomer','SoldCustomer']
inlist=','.join("'%s'"%c for c in COMBOS)
with io.open(OUT+r'\sql\05_DMF0021_combo.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'콤보 (SCM_ADM_CMBO_SQL_M) — 그리드 실측 + 폼/편집 + DMF0021 전용(CELL_PROD_SITE_ID/SalesPlanUserAuthGroup)')
    f.write("-- ⚠ 공유 콤보 다수 — 클라우드 존재 시 값만 정합(무해). CELL_PROD_SITE_ID(P3)/SalesPlanUserAuthGroup(P6) = DMF0021 신규.\n\n")
    stat['CMBO']=export_merge(f,'SCM_ADM_CMBO_SQL_M',"SQL_ID IN (%s)"%inlist,['SQL_ID','MDU_DIVS_CD'],"SQL_ID")
MSGS=['MSG00002','MSG00004','MSG00085','MSG00097','MSG00108','MSG00113','MSG00146','MSG00164','MSG00227','MSG00361','MSG00429']
msgin=','.join("'%s'"%m for m in MSGS)
with io.open(OUT+r'\sql\06_DMF0021_message.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'메시지 (SCM_ADM_MSG_M) — DMF0021 사용 MSG, KO/EN/CN')
    stat['MSG']=export_merge(f,'SCM_ADM_MSG_M',"MSG_ID IN (%s)"%msgin,['MSG_ID','LANG_CD'],"MSG_ID, LANG_CD")
LOOKS=['GET_ADMIN_GROUP_MEASURE','SP_CELL_PROD_SITE']
lookin=','.join("'%s'"%l for l in LOOKS)
with io.open(OUT+r'\sql\07_DMF0021_lookup.sql','w',encoding='utf-8',newline='\n') as f:
    header(f,'LOOKUP (MASTER + DETAIL) — 편집권한(GET_ADMIN_GROUP_MEASURE)·CellProdSite')
    f.write("-- ⚠ GET_ADMIN_GROUP_MEASURE = 편집권한/authGroup 핵심(SEGMENT2='DMF0021' 등재그룹). 그리드 기타 lookup 은 공유자산 클라우드 기존재 가정.\n\n")
    lm=cols_of('SCM_ADM_LOOKUP_MASTER'); lm_pk=['LOOKUP_TYPE'] if 'LOOKUP_TYPE' in lm else [lm[0]]
    stat['LOOKUP_M']=export_merge(f,'SCM_ADM_LOOKUP_MASTER',"LOOKUP_TYPE IN (%s)"%lookin,lm_pk,"LOOKUP_TYPE")
    stat['LOOKUP_D']=export_merge(f,'SCM_ADM_LOOKUP_MASTER_DETAIL',"LOOKUP_TYPE IN (%s)"%lookin,['LOOKUP_TYPE','SEGMENT1','SEGMENT2','SEGMENT3','SEGMENT4','SEGMENT5'],"LOOKUP_TYPE, DISPLAY_SEQ")

# SP/PKG DDL
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE); DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'PRETTY',TRUE); END;")
def get_ddl(ot,nm):
    cur.execute("SELECT DBMS_METADATA.GET_DDL(:t,:n,:o) FROM DUAL", t=ot, n=nm, o=OWN)
    lob=cur.fetchone()[0]; return lob.read() if lob is not None else ''
SPS=['DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX','DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL','DMF0021_GET_SALES_PLAN_MEASUREINFO','DMF0021_GET_SPREAD_TITLE']
spstat={}
with io.open(OUT+r'\sp\PKG_DMF0021_SPEC.sql','w',encoding='utf-8',newline='\n') as f: f.write(get_ddl('PACKAGE_SPEC','PKG_DMF0021')); spstat['PKG_SPEC']=1
with io.open(OUT+r'\sp\PKG_DMF0021_BODY.sql','w',encoding='utf-8',newline='\n') as f: f.write(get_ddl('PACKAGE_BODY','PKG_DMF0021')); spstat['PKG_BODY']=1
for nm in SPS:
    try:
        with io.open(OUT+r'\sp\%s.sql'%nm,'w',encoding='utf-8',newline='\n') as f: f.write(get_ddl('PROCEDURE',nm)); spstat[nm]=1
    except Exception as e: print("  SP FAIL %s: %s"%(nm,e)); spstat[nm]=0
print("META:"); [print("  %-16s %d"%(k,v)) for k,v in stat.items()]
print("SP:"); [print("  %-40s %d"%(k,v)) for k,v in spstat.items()]
