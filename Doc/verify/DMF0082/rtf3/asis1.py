import sys,time,re
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('asis') as cx:
    cur=cx.cursor()
    t=time.time()
    cur.execute("SELECT m.definition, o.modify_date FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id WHERE o.name='DMF0082_GET_MAIN_DATA'")
    d,md=cur.fetchone()
    print('modify',md,'len',len(d),round(time.time()-t,1),'s')
    open('Doc/verify/DMF0082/rtf3/ASIS_LIVE_DMF0082_GET_MAIN_DATA.sql','w',encoding='utf-8').write(d)
    L=d.split('\n')
    for i,l in enumerate(L):
        if 'DM_PLN_SALES_PLAN_RESULT_C' in l and not l.strip().startswith('--'):
            ctx=L[max(0,i-120):i+40]
            ms=[x.strip() for x in ctx if re.search(r'AS MEASURE\s*(--.*)?$|B\.RESULT_MEASURE|= *B\.MEASURE|VERSION_NO +LIKE|SP_VERSION_NO',x) and not x.strip().startswith('--')]
            print(i+1, ms)
