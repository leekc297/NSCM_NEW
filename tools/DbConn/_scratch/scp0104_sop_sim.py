import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import oracledb
from dbconn import connect
c = connect('tobe'); cur = c.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
def q(sql, **b):
    cur.execute(sql, b); cols=[d[0] for d in cur.description]; return [dict(zip(cols,r)) for r in cur]
def call(sheet, p):
    rc1=cur.var(oracledb.DB_TYPE_CURSOR); rc2=cur.var(oracledb.DB_TYPE_CURSOR)
    args=[p.get(k,'') or None for k in ['ver','seq','div','site','plant','fac','line','op','eltr','valid']]+['SCP0104','SOP_'+sheet,'minyonglee1','F',rc1,rc2]
    cur.callproc('PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_SOP_'+sheet, args)
    return rc1.getvalue().fetchall()
op_sql="""SELECT DISTINCT B.SEGMENT1 DIVISION_ID, B.SEGMENT2 CODE, B.SEGMENT3 ELTR, B.SEGMENT4 SG FROM SCM_ADM_LOOKUP_MASTER A JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE=B.LOOKUP_TYPE
 WHERE A.LOOKUP_GROUP='SCP' AND A.LOOKUP_TYPE='OPERATION_ELECTRODE_TYPE' AND B.VALID_YN='Y'"""
ops=q(op_sql)
for sheet, mtab, sg in [('ASSEMBLY','SCP_MST_CAPA_LINE','A'),('ASSEMBLY','SCP_MST_CAPA_LINE','P'),('ELTR','SCP_MST_CAPA_ELTR_LINE','E')]:
  for div in ['81_HG','81_ST']:
    m=[r for r in q(f"select division_id,site_id,plant_id,factory_id,line_id from {mtab}") if r['DIVISION_ID']==div]
    site=sorted({r['SITE_ID'] for r in m if r['SITE_ID'] and r['SITE_ID']!='-'})
    plant=sorted({r['PLANT_ID'] for r in m if r['PLANT_ID'] and r['PLANT_ID']!='-'})
    fac=sorted({r['FACTORY_ID'] for r in m if r['FACTORY_ID'] and r['FACTORY_ID']!='-'})
    line=sorted({r['LINE_ID'] for r in m if r['LINE_ID'] and r['LINE_ID']!='-'})
    opc=[o for o in ops if o['DIVISION_ID']==div and o['SG']==sg]
    opids=sorted({o['CODE'] for o in opc if o['CODE']!='-' and not (sg=='E' and o['CODE']=='AFFFF')})
    if sg=='E': el=[o for o in ops if o['DIVISION_ID']==div and o['CODE']=='E2000']
    else: el=[o for o in ops if o['DIVISION_ID']==div and (o['CODE'] or '')[:1]==sg]
    elt=sorted({o['ELTR'] for o in el if o['CODE'] in opids and o['ELTR'] and o['ELTR']!='-'})
    base=dict(ver='X',seq='1',div=div)
    full=dict(base,site=','.join(site),plant=','.join(plant),fac=','.join(fac),line=','.join(line),op=','.join(opids),eltr=','.join(elt) if sg!='E' else '')
    print(f'### {sheet} SG={sg} DIV={div} master_lines={len(line)} ops={opids} eltr={elt}')
    print('  A) FE 기본값(전 축 ALL) rows =', len(call(sheet, full)))
    print('  B) 사업부만 rows =', len(call(sheet, base)))
    t=dict(full); t['eltr']=''; print('  C) 기본값 + LineType 빈값 rows =', len(call(sheet,t)))
    t=dict(full); t['line']=''; print('  D) 기본값 + Line 빈값 rows =', len(call(sheet,t)))
