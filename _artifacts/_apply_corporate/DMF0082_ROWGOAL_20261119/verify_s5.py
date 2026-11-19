"""S5: #18_40 위반 0건 대량 삭제(원본이 끝까지 탐색하는 경로) 전후 시간 — 품목코드 앞에 'ZZ' 를 붙여 원장과 짝이 없게 함"""
import sys, re, time, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
D = os.path.dirname(os.path.abspath(__file__))
_prev = open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), encoding='utf-8').read()
exec(open(os.path.join(D, 'verify_equiv.py'), encoding='utf-8').read().split("c = dbconn.connect")[0])
out.close(); open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), 'w', encoding='utf-8').write(_prev)
c = dbconn.connect('tobe'); k = c.cursor(); k.callTimeout = 900000
k.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR"); k.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
k.execute("DELETE FROM GT_PRDM1_T_MAIN")
k.execute("""INSERT INTO GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
              INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
    SELECT 'D', DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, 'ZZ' || ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'LOC',
           PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, 'pt_test'
      FROM DM_PLN_CFM_SELLING_PRICE P
     WHERE DIVISION_ID='40' AND MEASURE='LOC' AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD')
     ORDER BY YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID FETCH FIRST 45495 ROWS ONLY""")
k.execute("BEGIN DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_PRDM1_T_MAIN'); END;")
o, f = Q['#18_40']
res = []
for tag, q in (('수정본', f), ('원본', o)):
    t = time.time()
    try: k.execute(q); r = k.fetchall(); v = r[0][0] if r else None
    except Exception as e: v = 'ERR ' + str(e)[:60]
    res.append(f"{tag}={v!r} ({round(time.time()-t,1)}s)")
line = 'S5 #18_40 위반0 대량삭제 45,495행: ' + ' / '.join(res)
print(line); open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), 'a', encoding='utf-8').write(line + '\n')
k.execute("DELETE FROM GT_PRDM1_T_MAIN"); c.commit()
