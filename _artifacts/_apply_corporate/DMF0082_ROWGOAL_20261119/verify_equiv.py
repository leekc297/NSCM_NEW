"""[E20261119-DMF0082ROWGOAL] 원본 vs 수정본 판정 동등성 시험 (사내 ZIOUI1, 세션 전용 GTT, 조회만)
문장 원문은 _base_body.txt / _fixed_body.txt 에서 라인으로 잘라 INTO 만 떼고 그대로 실행한다.
시나리오
  S1 #5  위반 0건(마스터 유효 45,495행)            → 원본 행 없음 / 수정본 NULL      = 둘 다 통과
  S2 #5  위반 3건 추가(마스터 없는 품목)            → 둘 다 값 있음, 둘 다 위반 집합 안
  S3 #18 40 전 행 ACTION='D'                       → 원본·수정본 위반 유무 같음, 값이 위반 집합 안
  S4 #18 81 (DM_PLN_MKT_FCST) 같은 데이터, 문장만   → 위와 같음
"""
import sys, re, time, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
D = os.path.dirname(os.path.abspath(__file__))
B = open(os.path.join(D, '_base_body.txt'), encoding='utf-8').read().split('\n')
F = open(os.path.join(D, '_fixed_body.txt'), encoding='utf-8').read().split('\n')
out = open(os.path.join(D, 'VERIFY_EQUIV_RESULT.txt'), 'w', encoding='utf-8')
def p(*a): print(*a); print(*a, file=out, flush=True)

def stmt(L, s, e):
    t = '\n'.join(L[s-1:e]); t = re.sub(r'--[^\n]*', '', t)
    t = re.sub(r'\bINTO\s+\w+', '', t, count=1); return t.strip().rstrip(';').strip()
Q = {
 '#5':     (stmt(B, 24890, 24904), stmt(F, 24891, 24905)),
 '#18_40': (stmt(B, 25706, 25757), stmt(F, 25707, 25758)),
 '#18_81': (stmt(B, 25778, 25824), stmt(F, 25779, 25825)),
}
for k_, (o, f) in Q.items():
    assert 'FETCH FIRST 1 ROWS ONLY' in o and 'FETCH FIRST' not in f and 'MIN(' in f, k_
# 위반 전체 집합 = 원본에서 FETCH FIRST 만 뗀 문장
ALL = {k_: re.sub(r'FETCH\s+FIRST\s+1\s+ROWS\s+ONLY', '', o) for k_, (o, f) in Q.items()}

c = dbconn.connect("tobe"); k = c.cursor(); k.callTimeout = 600000
k.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
k.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")   # 저장 SP 와 같은 세션 설정
k.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); p('start', k.fetchone()[0])

def load(action):
    k.execute("DELETE FROM GT_PRDM1_T_MAIN")
    k.execute(f"""INSERT INTO GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                  INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
        SELECT '{action}', DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'LOC',
               PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, 'pt_test'
          FROM DM_PLN_CFM_SELLING_PRICE P
         WHERE DIVISION_ID='40' AND MEASURE='LOC' AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD')
           AND EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM I, SCM_MST_ITEM_SN SN
                        WHERE I.DIVISION_ID=P.DIVISION_ID AND I.SCM_SITE_ID=P.SCM_SITE_ID AND I.ITEM_ID=P.ITEM_ID
                          AND I.VALID_YN='Y' AND SN.DIVISION_ID=I.DIVISION_ID AND SN.ITEM_ID=I.ITEM_ID AND SN.ACTIVE_FLAG='Y')
         ORDER BY YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID FETCH FIRST 45495 ROWS ONLY""")
    n = k.rowcount
    k.execute("BEGIN DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_PRDM1_T_MAIN'); END;")  # SP 24453 과 같음(GTT 세션 통계)
    return n

def run(sql):
    t = time.time(); k.execute(sql); r = k.fetchall(); return r, round(time.time() - t, 2)

def case(name, key):
    o, f = Q[key]
    ro, to = run(o); rf, tf = run(f); ra, ta = run(ALL[key])
    allset = {x[0] for x in ra}
    vo = ro[0][0] if ro else None; vf = rf[0][0] if rf else None
    same_verdict = (vo is None) == (vf is None)
    in_set = (vf is None and not allset) or (vf in allset)
    p(f'{name}: 원본={vo!r} ({to}s) 수정본={vf!r} ({tf}s) 위반집합={len(allset)}건 | 판정같음={same_verdict} 수정본값∈집합={in_set} 수정본=MIN(집합)={vf == (min(allset) if allset else None)}')
    return same_verdict and in_set

ok = True
p('S1 load', load('M')); ok &= case('S1 #5 위반0', '#5')
k.execute("""INSERT INTO GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
              INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
             SELECT 'M', DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, 'ZZROWGOAL_T' || LEVEL, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE,
                    PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
               FROM (SELECT * FROM GT_PRDM1_T_MAIN WHERE ROWNUM = 1) CONNECT BY LEVEL <= 3""")
ok &= case('S2 #5 위반3', '#5')
p('S3 load D', load('D'))
ok &= case('S3 #18_40 전행D', '#18_40')
ok &= case('S4 #18_81 전행D', '#18_81')
k.execute("DELETE FROM GT_PRDM1_T_MAIN"); c.commit()
p('RESULT', 'PASS' if ok else 'FAIL')
