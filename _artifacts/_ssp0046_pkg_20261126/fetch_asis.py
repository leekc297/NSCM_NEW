import pyodbc,sys,os,datetime
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
cs=f"DRIVER={{{env.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes"
c=pyodbc.connect(cs,timeout=20);cur=c.cursor()
out=sys.argv[1]
cur.execute("""select s.name, o.name, o.type_desc, o.modify_date, m.definition from sys.objects o join sys.schemas s on s.schema_id=o.schema_id
 join sys.sql_modules m on m.object_id=o.object_id where o.name like 'SSP0046%' or o.name like 'DMF0045%' or o.name in ('FN_GET_ANL_SHIP_FROZEN_DAY_CNT') order by o.name""")
for sch,n,t,md,d in cur.fetchall():
    open(os.path.join(out,f'{sch}.{n}.sql'),'w',encoding='utf-8',newline='').write(d)
    print(f'{sch}.{n}\t{t}\t{md}\t{len(d)}')
print('FETCHED',datetime.datetime.now())
