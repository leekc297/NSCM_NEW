"""S4 보완: #18_81 수정본 값이 실제 위반 행인지 키로 좁혀 확인 (위반 전체 집합 조회는 행마다 반복 계획이라 10분 초과)"""
import sys, re, time, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
D = os.path.dirname(os.path.abspath(__file__))
_prev = open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), encoding='utf-8').read()   # 아래 exec 가 결과 파일을 새로 여므로 보존
exec(open(os.path.join(D, 'verify_equiv.py'), encoding='utf-8').read().split("c = dbconn.connect")[0])   # stmt(), Q, ALL 재사용
out.close(); open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), 'w', encoding='utf-8').write(_prev)
c = dbconn.connect('tobe'); k = c.cursor(); k.callTimeout = 600000
k.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR"); k.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
k.execute("DELETE FROM GT_PRDM1_T_MAIN")
k.execute("""INSERT INTO GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
              INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
    SELECT 'D', DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'LOC',
           PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, 'pt_test'
      FROM DM_PLN_CFM_SELLING_PRICE P
     WHERE DIVISION_ID='40' AND MEASURE='LOC' AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD')
       AND EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM I, SCM_MST_ITEM_SN SN
                    WHERE I.DIVISION_ID=P.DIVISION_ID AND I.SCM_SITE_ID=P.SCM_SITE_ID AND I.ITEM_ID=P.ITEM_ID
                      AND I.VALID_YN='Y' AND SN.DIVISION_ID=I.DIVISION_ID AND SN.ITEM_ID=I.ITEM_ID AND SN.ACTIVE_FLAG='Y')
     ORDER BY YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID FETCH FIRST 45495 ROWS ONLY""")
k.execute("BEGIN DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_PRDM1_T_MAIN'); END;")
o, f = Q['#18_81']
t = time.time(); k.execute(o); ro = k.fetchall(); to = round(time.time()-t, 2)
t = time.time(); k.execute(f); rf = k.fetchall(); tf = round(time.time()-t, 2)
vo = ro[0][0] if ro else None; vf = rf[0][0] if rf else None
def member(v):
    m = re.match(r'● Sales Site : (.*) / ● Model : (.*)$', v)
    q = ALL['#18_81'].replace('WHERE EXISTS', f"WHERE F.SCM_SITE_ID = '{m.group(1)}' AND F.ITEM_ID = '{m.group(2)}' AND EXISTS", 1)
    k.execute(q); return len(k.fetchall()) > 0
ok = (vo is None) == (vf is None) and (vf is None or (member(vf) and member(vo)))
line = f"S4 #18_81 전행D: 원본={vo!r} ({to}s) 수정본={vf!r} ({tf}s) | 판정같음={(vo is None) == (vf is None)} 원본값·수정본값 실제 위반행={ok}"
print(line); open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), 'a', encoding='utf-8').write(line + '\nRESULT ' + ('PASS' if ok else 'FAIL') + ' (S1~S3 verify_equiv.py, S4 verify_s4.py)\n')
k.execute("DELETE FROM GT_PRDM1_T_MAIN"); c.commit()
