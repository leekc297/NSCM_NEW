# -*- coding: utf-8 -*-
"""DMF0003 전체 이관 — 사내(OCGSCMD_P01) 메타 전수 export → 멱등 MERGE SQL.
   동적 컬럼 발견(ALL_TAB_COLUMNS) + PK 기준 MERGE. 값 타입별 리터럴화(NULL/숫자/날짜/문자).
   출력: _deploy_packages/DMF0003_20260720_1625/sql/*.sql , sp/*.sql
"""
import io, importlib.util, datetime, decimal

spec = importlib.util.spec_from_file_location("ora", r"C:\Projects\NSCM\_artifacts\_diagnostics\ora.py")
ora = importlib.util.module_from_spec(spec); spec.loader.exec_module(ora)
import oracledb
u, p, d = ora.conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()

OUT = r'C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0003_20260720_1625'
OWN = 'SCM_MGR'

def cols_of(table):
    cur.execute("""SELECT column_name, data_type FROM all_tab_columns
                   WHERE owner=:o AND table_name=:t ORDER BY column_id""", o=OWN, t=table)
    return cur.fetchall()

def lit(v):
    if v is None:
        return 'NULL'
    if isinstance(v, (int, float, decimal.Decimal)):
        return str(v)
    if isinstance(v, datetime.datetime):
        return "TO_DATE('%s','YYYY-MM-DD HH24:MI:SS')" % v.strftime('%Y-%m-%d %H:%M:%S')
    if isinstance(v, datetime.date):
        return "TO_DATE('%s','YYYY-MM-DD')" % v.strftime('%Y-%m-%d')
    s = str(v).replace("'", "''")
    return "'%s'" % s

def export_merge(fh, table, where, pk, order=None, binds=None):
    colinfo = cols_of(table)
    names = [c[0] for c in colinfo]
    if not names:
        fh.write("-- ⚠ %s : 컬럼 0 (테이블 부재?)\n\n" % table); return 0
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
        ins_cols = ', '.join(names)
        ins_vals = ', '.join("s.%s" % n for n in names)
        fh.write("MERGE INTO %s.%s t USING (SELECT %s FROM DUAL) s\n" % (OWN, table, using))
        fh.write("ON (%s)\n" % on)
        fh.write("WHEN MATCHED THEN UPDATE SET %s\n" % setc)
        fh.write("WHEN NOT MATCHED THEN INSERT (%s) VALUES (%s);\n" % (ins_cols, ins_vals))
    fh.write("\n")
    return len(rows)

def header(fh, title):
    fh.write("-- =====================================================================\n")
    fh.write("-- DMF0003 전체 이관 — %s\n" % title)
    fh.write("-- 사내 OCGSCMD_P01 실측 export (2026-07-20). 멱등 MERGE. 스키마 SCM_MGR.\n")
    fh.write("-- =====================================================================\n\n")

stat = {}

# 01 — 메뉴/API/버튼 배선
with io.open(OUT + r'\sql\01_DMF0003_menu_api_button.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '메뉴 · API · 버튼 배선')
    stat['MNU_M'] = export_merge(f, 'SCM_ADM_MNU_M', "MNU_ID='DMF0003'", ['MNU_ID'])
    stat['MNU_BTN_MPG'] = export_merge(f, 'SCM_ADM_MNU_BTN_MPG_M', "MNU_ID='DMF0003'",
                                       ['MNU_ID', 'SHT_NM', 'MNU_BTN_CD', 'API_ID'], "SHT_NM, MNU_BTN_CD, API_ID")
    stat['API_M'] = export_merge(f, 'SCM_ADM_API_M',
                                 "API_ID IN (SELECT DISTINCT API_ID FROM %s.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0003')" % OWN,
                                 ['API_ID'], "API_ID")

# 02 — PROC_M (DMF0003 SP 시그니처 배선)
with io.open(OUT + r'\sql\02_DMF0003_proc_m.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, 'PROC_M — SP positional 시그니처 배선')
    stat['PROC_M'] = export_merge(f, 'SCM_ADM_PROC_M',
                                  "UPPER(PROC_NM) LIKE '%DMF0003%'", ['PROC_NM', 'COL_NM'], "PROC_NM, SORT_ORD")

# 03 — 그리드 컬럼/메저 (UI Category)
with io.open(OUT + r'\sql\03_DMF0003_sheet_columns_measure.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, 'UI Category Setup — SHEET_COLUMNS / SHEET_MEASURE')
    sc_pk = ['PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME', 'DIVISION_ID']
    stat['SHEET_COLUMNS'] = export_merge(f, 'SCM_MST_SHEET_COLUMNS', "PROGRAM_ID='DMF0003'",
                                         sc_pk, "SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")
    sm_cols = [c[0] for c in cols_of('SCM_MST_SHEET_MEASURE')]
    sm_pk = ['PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME'] + (['DIVISION_ID'] if 'DIVISION_ID' in sm_cols else [])
    stat['SHEET_MEASURE'] = export_merge(f, 'SCM_MST_SHEET_MEASURE', "PROGRAM_ID='DMF0003'",
                                         sm_pk, "SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")

# 04 — 권한 (메뉴/버튼 접근)
with io.open(OUT + r'\sql\04_DMF0003_authority.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '권한 — 메뉴/버튼 접근 (USER_GR)')
    ug_cols = [c[0] for c in cols_of('SCM_ADM_USER_GR_MNU_MPG_M')]
    ug_pk = [c for c in ('USER_GR_ID', 'MNU_ID') if c in ug_cols] or ['MNU_ID']
    stat['USER_GR_MNU'] = export_merge(f, 'SCM_ADM_USER_GR_MNU_MPG_M', "MNU_ID='DMF0003'", ug_pk)
    ugb_cols = [c[0] for c in cols_of('SCM_ADM_USER_GR_MNU_BTN_MPG_M')]
    ugb_pk = [c for c in ('USER_GR_ID', 'MNU_ID', 'SHT_NM', 'MNU_BTN_CD') if c in ugb_cols] or ['MNU_ID']
    stat['USER_GR_BTN'] = export_merge(f, 'SCM_ADM_USER_GR_MNU_BTN_MPG_M', "MNU_ID='DMF0003'", ugb_pk)

# 05 — 콤보 (DMF0003 사용분: 전용 + 공유)
COMBOS = ['MyDivision','TeambyDivision','UserTeamByDivision','EndCustomer','EndCustomerByDivision',
          'EndCustomerByDivisionDept','ScmSitebyEndCustomer40','SalesSite','SenderCode','ItemType','BizType',
          'BucketType','Incoterms','IncotermsEdit','CustomsHandbook','FcstType','FcstTypeEditMode','FcstTypeWs',
          'Measure','MktFcstEditMeasure','MktFcstEditableDivision','MktFcstUserEditDivision','MktFcstWsPlannerYn',
          'MktFcstUserGroups','Dmf0003ScpPlannerEditFlag','Dmf0003DmPlannerEditFlag','AS_FROM_SITE',
          'PlantSitebyDivision','PlantSitebyEndCustomer','FromSiteByDivision']
inlist = ','.join("'%s'" % c for c in COMBOS)
with io.open(OUT + r'\sql\05_DMF0003_combo.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '콤보 (SCM_ADM_CMBO_SQL_M) — DMF0003 전용 + 공유 사용분')
    f.write("-- ⚠ 공유 콤보 다수 — 클라우드에 이미 존재하면 MERGE 가 값만 정합(무해).\n\n")
    stat['CMBO'] = export_merge(f, 'SCM_ADM_CMBO_SQL_M', "SQL_ID IN (%s)" % inlist, ['SQL_ID', 'MDU_DIVS_CD'], "SQL_ID")

# 06 — 메시지 (DMF0003 사용 MSG — 3언어)
MSGS = ['MSG00043','MSG00096','MSG00097','MSG00108','MSG00113','MSG00152','MSG00164','MSG00225','MSG00227',
        'MSG00260','MSG00429','MSG00448','MSG00476','MSG00477','MSG00478','MSG00606','MSG00617','MSG00618',
        'MSG00660','MSG00661','MSG00662','MSG00663','MSG00664','MSG00665','MSG00666']
msgin = ','.join("'%s'" % m for m in MSGS)
with io.open(OUT + r'\sql\06_DMF0003_message.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, '메시지 (SCM_ADM_MSG_M) — DMF0003 사용 MSG, KO/EN/CN')
    stat['MSG'] = export_merge(f, 'SCM_ADM_MSG_M', "MSG_ID IN (%s)" % msgin, ['MSG_ID', 'LANG_CD'], "MSG_ID, LANG_CD")

# 07 — LOOKUP (마스터+디테일)
LOOKS = ['MKT_FCST_MEASURE','SALES_TYPE_CODE','SALES_TYPE_CODE2','SALES_TYPE_CODE2_ADD','DM_UI_EDITABLE_DIVISION',
         'AS_SITE_PLANT','SCP_PLANNER_EDIT_FLAG','DM_PLANNER_EDIT_FLAG','GET_ADMIN_GROUP_MEASURE',
         'MKT_FCST_VALIDATION_PRICE','BUCKET_TYPE_CODE','EDI_SENDER_CODE','AS_INCOTERMS','DM_PR_SLOC','TMM_MEASURE_ADMIN']
lookin = ','.join("'%s'" % l for l in LOOKS)
with io.open(OUT + r'\sql\07_DMF0003_lookup.sql', 'w', encoding='utf-8', newline='\n') as f:
    header(f, 'LOOKUP (MASTER + DETAIL) — DMF0003 참조 타입')
    f.write("-- ⚠ 공유 lookup — 클라우드 존재 시 값 정합. SCP/DM_PLANNER_EDIT_FLAG 는 운영값 협의 대기(0행 가능).\n\n")
    lm_cols = [c[0] for c in cols_of('SCM_ADM_LOOKUP_MASTER')]
    lm_pk = ['LOOKUP_TYPE'] if 'LOOKUP_TYPE' in lm_cols else [lm_cols[0]]
    stat['LOOKUP_M'] = export_merge(f, 'SCM_ADM_LOOKUP_MASTER', "LOOKUP_TYPE IN (%s)" % lookin, lm_pk, "LOOKUP_TYPE")
    ld_pk = ['LOOKUP_TYPE','SEGMENT1','SEGMENT2','SEGMENT3','SEGMENT4','SEGMENT5']
    stat['LOOKUP_D'] = export_merge(f, 'SCM_ADM_LOOKUP_MASTER_DETAIL', "LOOKUP_TYPE IN (%s)" % lookin,
                                    ld_pk, "LOOKUP_TYPE, DISPLAY_SEQ")

print("META EXPORT:")
for k, v in stat.items():
    print("  %-16s %d" % (k, v))
