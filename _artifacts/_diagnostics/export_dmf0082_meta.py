# -*- coding: utf-8 -*-
"""DMF0082 전체 이관 — 사내(OCGSCMD_P01) 메타 전수 export → 멱등 MERGE SQL + SP/PKG DDL.
   export_dmf0003_meta.py 를 DMF0082 로 적응. 출력: _deploy_packages/DMF0082_20260721_0738/{sql,sp}/*.sql
"""
import io, importlib.util, datetime, decimal

spec = importlib.util.spec_from_file_location("ora", r"C:\Projects\NSCM\_artifacts\_diagnostics\ora.py")
ora = importlib.util.module_from_spec(spec); spec.loader.exec_module(ora)
import oracledb
u, p, d = ora.conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()

OUT = r'C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_20260721_0738'
OWN = 'SCM_MGR'

def cols_of(table):
    cur.execute("""SELECT column_name, data_type FROM all_tab_columns
                   WHERE owner=:o AND table_name=:t ORDER BY column_id""", o=OWN, t=table)
    return cur.fetchall()

def lit(v):
    if v is None: return 'NULL'
    if isinstance(v, (int, float, decimal.Decimal)): return str(v)
    if isinstance(v, datetime.datetime): return "TO_DATE('%s','YYYY-MM-DD HH24:MI:SS')" % v.strftime('%Y-%m-%d %H:%M:%S')
    if isinstance(v, datetime.date): return "TO_DATE('%s','YYYY-MM-DD')" % v.strftime('%Y-%m-%d')
    return "'%s'" % str(v).replace("'", "''")

def export_merge(fh, table, where, pk, order=None, binds=None):
    colinfo = cols_of(table)
    names = [c[0] for c in colinfo]
    if not names:
        fh.write("-- WARN %s : 컬럼 0 (테이블 부재?)\n\n" % table); return 0
    sql = "SELECT %s FROM %s.%s WHERE %s" % (', '.join(names), OWN, table, where)
    if order: sql += " ORDER BY " + order
    cur.execute(sql, binds or {})
    rows = cur.fetchall()
    fh.write("-- ============================================================\n")
    fh.write("-- %s  (%d rows, PK=%s)\n" % (table, len(rows), '+'.join(pk)))
    fh.write("-- ============================================================\n")
    if not rows:
        fh.write("-- (대상 0행)\n\n"); return 0
    non_pk = [n for n in names if n not in pk]
    for r in rows:
        vals = dict(zip(names, r))
        using = ', '.join("%s AS %s" % (lit(vals[n]), n) for n in names)
        on = ' AND '.join("t.%s = s.%s" % (k, k) for k in pk)
        setc = ', '.join("t.%s = s.%s" % (n, n) for n in non_pk) or "t.%s = s.%s" % (pk[0], pk[0])
        fh.write("MERGE INTO %s.%s t USING (SELECT %s FROM DUAL) s\n" % (OWN, table, using))
        fh.write("ON (%s)\n" % on)
        fh.write("WHEN MATCHED THEN UPDATE SET %s\n" % setc)
        fh.write("WHEN NOT MATCHED THEN INSERT (%s) VALUES (%s);\n" % (', '.join(names), ', '.join("s.%s" % n for n in names)))
    fh.write("\n")
    return len(rows)

def header(fh, title):
    fh.write("-- =====================================================================\n")
    fh.write("-- DMF0082 (Fcst&Price MGMT) 전체 이관 — %s\n" % title)
    fh.write("-- 사내 OCGSCMD_P01 실측 export (2026-07-21). 멱등 MERGE. 스키마 SCM_MGR.\n")
    fh.write("-- =====================================================================\n\n")

stat = {}

# 01 — 메뉴/API/버튼
with io.open(OUT + r'\sql\01_DMF0082_menu_api_button.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '메뉴 · API · 버튼 배선')
    stat['MNU_M'] = export_merge(f, 'SCM_ADM_MNU_M', "MNU_ID='DMF0082'", ['MNU_ID'])
    stat['MNU_BTN_MPG'] = export_merge(f, 'SCM_ADM_MNU_BTN_MPG_M', "MNU_ID='DMF0082'",
        ['MNU_ID', 'SHT_NM', 'MNU_BTN_CD', 'API_ID'], "SHT_NM, MNU_BTN_CD, API_ID")
    stat['API_M'] = export_merge(f, 'SCM_ADM_API_M',
        "API_ID IN (SELECT DISTINCT API_ID FROM %s.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082')" % OWN,
        ['API_ID'], "API_ID")

# 02 — PROC_M
with io.open(OUT + r'\sql\02_DMF0082_proc_m.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, 'PROC_M — SP positional 시그니처 배선')
    stat['PROC_M'] = export_merge(f, 'SCM_ADM_PROC_M',
        "PROC_NM IN (SELECT DISTINCT a.API_URL FROM %s.SCM_ADM_API_M a JOIN %s.SCM_ADM_MNU_BTN_MPG_M b ON b.API_ID=a.API_ID WHERE b.MNU_ID='DMF0082')" % (OWN, OWN),
        ['PROC_NM', 'COL_NM'], "PROC_NM, SORT_ORD")

# 03 — SHEET_COLUMNS / SHEET_MEASURE
with io.open(OUT + r'\sql\03_DMF0082_sheet_columns_measure.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, 'UI Category Setup — SHEET_COLUMNS / SHEET_MEASURE')
    sc_pk = ['PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME', 'DIVISION_ID']
    stat['SHEET_COLUMNS'] = export_merge(f, 'SCM_MST_SHEET_COLUMNS', "PROGRAM_ID='DMF0082'",
        sc_pk, "SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")
    sm_cols = [c[0] for c in cols_of('SCM_MST_SHEET_MEASURE')]
    sm_pk = ['PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME'] + (['DIVISION_ID'] if 'DIVISION_ID' in sm_cols else [])
    stat['SHEET_MEASURE'] = export_merge(f, 'SCM_MST_SHEET_MEASURE', "PROGRAM_ID='DMF0082'",
        sm_pk, "SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")

# 04 — 권한
with io.open(OUT + r'\sql\04_DMF0082_authority.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '권한 — 메뉴/버튼 접근 (USER_GR)')
    ug_cols = [c[0] for c in cols_of('SCM_ADM_USER_GR_MNU_MPG_M')]
    ug_pk = [c for c in ('USER_GR_ID', 'MNU_ID') if c in ug_cols] or ['MNU_ID']
    stat['USER_GR_MNU'] = export_merge(f, 'SCM_ADM_USER_GR_MNU_MPG_M', "MNU_ID='DMF0082'", ug_pk)
    ugb_cols = [c[0] for c in cols_of('SCM_ADM_USER_GR_MNU_BTN_MPG_M')]
    ugb_pk = [c for c in ('USER_GR_ID', 'MNU_ID', 'SHT_NM', 'MNU_BTN_CD') if c in ugb_cols] or ['MNU_ID']
    stat['USER_GR_BTN'] = export_merge(f, 'SCM_ADM_USER_GR_MNU_BTN_MPG_M', "MNU_ID='DMF0082'", ugb_pk)

# 05 — 콤보 (그리드 CELL_COMBO_DATA_TYPE 실측 + 폼/편집 + 신규 2)
COMBOS = ['APPLICATION','BizTypeByDivision','CELL_PROD_SITE_ID','CUST_GROUP_DTL','CurrencyList','CustGroup',
          'DOM_EXP','DeptId','Division','EndCustomerByDivision40','EndCustomerByDivisionDept','FCST_TYPE_NOT_ETC',
          'FCST_TYPE_NOT_FREE','FromSiteByDivision','Incoterms','ItemType','Measure','ROUTE','SiteByEndCustomer',
          'SoldCustomer','YesOrNo','BucketType','IncotermsEdit','SalesBucket','FcstPriceEditMeasure']
inlist = ','.join("'%s'" % c for c in COMBOS)
with io.open(OUT + r'\sql\05_DMF0082_combo.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '콤보 (SCM_ADM_CMBO_SQL_M) — 그리드 실측 + 폼/편집 + 신규 2(SalesBucket/FcstPriceEditMeasure)')
    f.write("-- ⚠ 공유 콤보 다수 — 클라우드 존재 시 MERGE 가 값만 정합(무해). SalesBucket/FcstPriceEditMeasure = DMF0082 신규.\n\n")
    stat['CMBO'] = export_merge(f, 'SCM_ADM_CMBO_SQL_M', "SQL_ID IN (%s)" % inlist, ['SQL_ID', 'MDU_DIVS_CD'], "SQL_ID")

# 06 — 메시지 (FE constants MSG 사용분 + savePrice)
MSGS = ['MSG00001','MSG00002','MSG00004','MSG00043','MSG00108','MSG00113','MSG00137','MSG00164','MSG00227',
        'MSG00255','MSG00260','MSG00283','MSG00330','MSG00409','MSG00429','MSG00662','MSG00667','MSG00668',
        'MSG00669','MSG00670','MSG00671','MSG00672']
msgin = ','.join("'%s'" % m for m in MSGS)
with io.open(OUT + r'\sql\06_DMF0082_message.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '메시지 (SCM_ADM_MSG_M) — DMF0082 사용 MSG, KO/EN/CN')
    stat['MSG'] = export_merge(f, 'SCM_ADM_MSG_M', "MSG_ID IN (%s)" % msgin, ['MSG_ID', 'LANG_CD'], "MSG_ID, LANG_CD")

# 07 — LOOKUP (DMF0082 편집 measure — FcstPriceEditMeasure 의존)
LOOKS = ['DM_UI_EDITABLE_MEASURE']
lookin = ','.join("'%s'" % l for l in LOOKS)
with io.open(OUT + r'\sql\07_DMF0082_lookup.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, 'LOOKUP (MASTER + DETAIL) — DMF0082 편집 measure 참조')
    f.write("-- ⚠ 그리드 공유 콤보의 기타 lookup(INCOTERMS/DOM_EXP/FCST_TYPE 등)은 공유자산 — 클라우드 기존재 가정.\n")
    f.write("-- ⚠ SalesBucket 원천 DM_MST_BUCKET_CONVERSION(마스터 데이터)·FcstPriceEditMeasure 의 SCM_MST_SITE 는 마스터 — 클라우드 기존재 가정.\n\n")
    lm_cols = [c[0] for c in cols_of('SCM_ADM_LOOKUP_MASTER')]
    lm_pk = ['LOOKUP_TYPE'] if 'LOOKUP_TYPE' in lm_cols else [lm_cols[0]]
    stat['LOOKUP_M'] = export_merge(f, 'SCM_ADM_LOOKUP_MASTER', "LOOKUP_TYPE IN (%s)" % lookin, lm_pk, "LOOKUP_TYPE")
    ld_pk = ['LOOKUP_TYPE','SEGMENT1','SEGMENT2','SEGMENT3','SEGMENT4','SEGMENT5']
    stat['LOOKUP_D'] = export_merge(f, 'SCM_ADM_LOOKUP_MASTER_DETAIL',
        "LOOKUP_TYPE IN (%s) AND SEGMENT1='DMF0082'" % lookin, ld_pk, "LOOKUP_TYPE, DISPLAY_SEQ")

# ===== SP/PKG DDL =====
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE); DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'PRETTY',TRUE); END;")
def ddl(otype, name):
    cur.execute("SELECT DBMS_METADATA.GET_DDL(:t, :n, :o) FROM DUAL", t=otype, n=name, o=OWN)
    return cur.fetchone()[0].read() if hasattr(cur.fetchone_placeholder if False else object(),'x') else None

def get_ddl(otype, name):
    cur.execute("SELECT DBMS_METADATA.GET_DDL(:t, :n, :o) FROM DUAL", t=otype, n=name, o=OWN)
    lob = cur.fetchone()[0]
    return lob.read() if lob is not None else ''

SP_STANDALONE = ['DMF0082_GET_MAIN_DATA_CURRENT','DMF0082_GET_SPREAD_TITLE','DMF0082_SAVE_MAIN_DATA',
                 'DMF0082_POPUP_GET_FUTUREPRICE_INFO','DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP',
                 'DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE','DMF0082_EXCEL_UPLOAD','DMF0082_GET_EXCEL_UPLOAD_DATA']
spstat = {}
with io.open(OUT + r'\sp\PKG_DMF0082_SPEC.sql', 'w', encoding='utf-8', newline='\n') as f:
    f.write(get_ddl('PACKAGE_SPEC', 'PKG_DMF0082')); spstat['PKG_SPEC']=1
with io.open(OUT + r'\sp\PKG_DMF0082_BODY.sql', 'w', encoding='utf-8', newline='\n') as f:
    f.write(get_ddl('PACKAGE_BODY', 'PKG_DMF0082')); spstat['PKG_BODY']=1
for nm in SP_STANDALONE:
    try:
        body = get_ddl('PROCEDURE', nm)
        with io.open(OUT + r'\sp\%s.sql' % nm, 'w', encoding='utf-8', newline='\n') as f:
            f.write(body); spstat[nm]=1
    except Exception as e:
        print("  SP FAIL %s: %s" % (nm, e)); spstat[nm]=0

print("META EXPORT:")
for k, v in stat.items(): print("  %-16s %d" % (k, v))
print("SP EXPORT:")
for k, v in spstat.items(): print("  %-50s %d" % (k, v))
