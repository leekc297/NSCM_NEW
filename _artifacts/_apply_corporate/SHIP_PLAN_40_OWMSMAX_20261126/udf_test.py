# PRAGMA UDF 효과 시험 : 두 함수를 시험용 사본(ZT_ 접두, PRAGMA UDF 추가)으로 만들어 같은 문장 비교 후 사본 삭제
import sys, time, re
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 180000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
def src(n):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='FUNCTION' ORDER BY LINE", n=n)
    return ''.join(r[0] for r in c.fetchall())
made = []
try:
    for n in ['FN_GET_ITEM_OPERATION_GROUP', 'FN_GET_SCM_SITE_ID_PLANT']:
        s = src(n)
        s = s.replace('"%s"' % n, 'ZT_' + n[3:], 1)
        s, k = re.subn(r'\bAS\b', 'AS\n    PRAGMA UDF;', s, count=1)
        # RESULT_CACHE 키워드 뒤 첫 AS 앞에 주석 블록이 있음 : 첫 AS 는 주석 뒤의 AS 여야 함
        assert k == 1
        c.execute('CREATE OR REPLACE ' + s); made.append('ZT_' + n[3:])
        c.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n", n='ZT_' + n[3:]); print('ZT_' + n[3:], c.fetchone())
    c.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='ZT_GET_ITEM_OPERATION_GROUP' AND TEXT LIKE '%PRAGMA%'"); print(c.fetchall())
    BASE = """SELECT MAX(O.CUTOFF_DATE) /* UDFT_%(k)s */
  FROM SSP_DNM_OWMS_STOCK O JOIN SCM_MST_SITE B
    ON B.DIVISION_ID = :d AND NVL(B.COMPANY_ID, '-') = NVL(:c, '-') AND B.DIVISION_ID = O.DIVISION_ID AND B.PLANT_ID = O.PLANT_ID
 WHERE O.PROD_GROUP = :d AND %(p)s"""
    P = {'FUNC': "FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL",
         'UDF': "ZT_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, ZT_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL",
         'UDF_SCALAR': "(SELECT ZT_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, ZT_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL"}
    for rnd in (1, 2, 3):
        for co in ('HQ00', 'NJ00', 'AZ00'):
            r = {}
            for k, p in P.items():
                t = time.time(); c.execute(BASE % dict(k=k, p=p), d='40', c=co); r[k] = (c.fetchone()[0], round(time.time() - t, 2))
            print(rnd, co, r, 'SAME' if len(set(v[0] for v in r.values())) == 1 else 'DIFF', flush=True)
finally:
    for m in made:
        c.execute('DROP FUNCTION SCM_MGR.' + m); print('DROP', m)
