# -*- coding: utf-8 -*-
# 2-14 WH_STOCK(aj7nw6qjt4tjv) 사내 재현 : 세션 GTT 에 계획 40/20261121/SP/1 HQ00 측정값 적재 후 SELECT 부분을 원문, 변경안으로 실행
# 결과 = 행 다중집합 비교. SP 변수 = 바인드. 사용 : python w2.py <변경안 파일 ...>
import sys, io, re, time, collections
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

VARS = r'\bV_(DIVISION_ID|PLAN_START_YYYYMMDD|PLAN_TYPE|SEQ|COMPANY_ID|DATA_START_YYYYMMDD|DATA_END_YYYYMMDD)\b'
B = dict(V_DIVISION_ID='40', V_PLAN_START_YYYYMMDD='20261121', V_PLAN_TYPE='SP', V_SEQ=1, V_COMPANY_ID='HQ00',
         V_DATA_START_YYYYMMDD='20261120', V_DATA_END_YYYYMMDD='20270213')


def old_sel():
    src = io.open('PR_SSP_ANL_SHIP_PLAN_40.TOBE.sql', encoding='utf-8').read()
    i = src.index('/* 2-14. [I]WH_STOC'); j = src.index('WITH BOH AS', i); k = src.index('\n        ;', j)
    return src[j:k]


def prep(sel, tag):
    sel = re.sub(VARS, r':V_\1', sel)
    return '/* %s */\n' % tag + sel, {k: v for k, v in B.items() if ':' + k in sel}


def main():
    cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
    c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
    if 'cloudenv' in sys.argv: c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE"); sys.argv.remove('cloudenv'); print('adaptive_plans FALSE')
    c.execute("""SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_ID) FROM ALL_TAB_COLUMNS T WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'
      AND EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS S WHERE S.OWNER='SCM_MGR' AND S.TABLE_NAME='SSP_ANL_SHIP_PLAN_40' AND S.COLUMN_NAME=T.COLUMN_NAME)""")
    cols = c.fetchone()[0]
    c.execute("INSERT INTO GT_SSP_ANL_SHIP_PLAN_40 (" + cols + ") SELECT " + cols + """ FROM SSP_ANL_SHIP_PLAN_40 P
     WHERE P.DIVISION_ID='40' AND P.PLAN_START_YYYYMMDD='20261121' AND P.PLAN_TYPE='SP' AND P.SEQ=1
       AND P.MEASURE NOT IN ('WH_STOCK','BALANCE')
       AND EXISTS (SELECT 1 FROM SCM_MST_SITE E WHERE E.DIVISION_ID='40' AND NVL(E.COMPANY_ID,'-')='HQ00' AND E.SCM_SITE_ID=P.FROM_SITE)
     ORDER BY DECODE(P.MEASURE,'SHIP_REQ',1,'SHIP_CONFIRM',2,'POSTP_PLAN',3,'PROD_PLAN',4,'INCO_WIP',5,'MES_FCS_HOLD',6,'MES_FCS_RELEASE',7,'PROD_DATE',8,'LOT',9,'WH_IN',10,'INSP_WIP',11,12), P.ITEM_ID, P.FROM_SITE, P.YYYYMMDD""")
    print('GT 적재', c.rowcount, flush=True)
    tag = time.strftime('%H%M%S')
    cand = [('OLD', old_sel())] + [(f.split('.')[0].upper().replace('_', ''), io.open(f, encoding='utf-8').read()) for f in sys.argv[1:]]
    res = {}
    for rnd in (1, 2):
        for name, sel in cand:
            q, b = prep(sel, 'W14_%s_%s' % (name, tag))
            t = time.time(); c.execute(q, b); rows = c.fetchall(); el = time.time() - t
            res[name] = collections.Counter(rows)
            print(rnd, name, '%.2fs' % el, 'rows', len(rows), 'qty %.3f' % sum(r[10] or 0 for r in rows), flush=True)
    for name, _ in cand[1:]:
        print('  %s == OLD' % name, res[name] == res['OLD'])
    c.execute("SELECT REGEXP_SUBSTR(SQL_TEXT, 'W14_[A-Z0-9_]+'), CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS, ROUND(ELAPSED_TIME/1e6/EXECUTIONS, 2), ROUND(BUFFER_GETS/EXECUTIONS) "
              "FROM V$SQL WHERE SQL_TEXT LIKE '%W14_%" + tag + "%' AND SQL_TEXT NOT LIKE '%V$SQL%' ORDER BY 1")
    rs = c.fetchall()
    for x in rs: print('V$SQL', x)
    for x in rs:
        c.execute("SELECT SQL_ID FROM V$SQL WHERE SQL_TEXT LIKE :t AND CHILD_NUMBER = :c AND SQL_TEXT NOT LIKE '%V$SQL%'", t='%' + x[0] + '%', c=x[1]); sid = c.fetchone()[0]
        c.execute("select plan_table_output from table(dbms_xplan.display_cursor(:s, :c, 'TYPICAL'))", s=sid, c=x[1])
        io.open('w_plan_%s.txt' % x[0].split('_')[1], 'w', encoding='utf-8').write('\n'.join(r[0] for r in c.fetchall()))
    cx.rollback()


if __name__ == '__main__':
    main()
