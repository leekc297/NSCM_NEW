# -*- coding: utf-8 -*-
"""
P_SSP0046_SAVE_SHIPMENT_REQUEST 저장 시험 (같은 세션 안에서 확인 후 ROLLBACK, COMMIT 없음)
- PKG_SSP0046 GET 결과의 SHIP_REQ 1행을 골라 수량 +1 로 'M' 저장
- 저장 전/후 DM_PLN_SHIPMENT_REQ 대상 행(BOD 제외 키) 수량·BOD_ID 비교, 이력 행 수 비교
- 저장 프로시저 본문에 COMMIT 없음(예외 경로 제외), 로그는 PR_SCM_SYS_LOG_BATCH 자율 트랜잭션
"""
import oracledb, sys, json
div, sheet, frm, to = sys.argv[1:5]
env = dict(l.strip().split('=', 1) for l in open(r'c:\Projects\NSCM\.env.asis', encoding='utf-8')
           if '=' in l and not l.startswith('#'))
c = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                     dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
c.autocommit = False
cur = c.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")

rc1, rc2 = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
cur.callproc('PKG_SSP0046.P_SSP0046_GET_SHIPMENT_REQUEST', [sheet, div, '', '', '', '', '', '', frm, to, 'admin', rc1, rc2])
r = rc1.getvalue()
cols = [d[0].upper() for d in r.description]
rows = [dict(zip(cols, x)) for x in r.fetchall()]
pick = None
for x in rows:
    if x['MEASURE'] != 'SHIP_REQ' or not x.get('BOD_ID') or x['BOD_ID'] in ('-', '/'):
        continue
    for k in cols:
        if k.startswith('D_') and x[k] not in (None, 0) and k[2:] >= frm:
            pick = (x, k[2:], float(x[k]))
            break
    if pick:
        break
assert pick, 'SHIP_REQ 수량 있는 행 없음'
x, ymd, qty = pick
key = dict(d=x['DIVISION_ID'], i=x['ITEM_ID'], f=x['FROM_SITE'], t=x['TO_SITE'], p=x['PROJECT_CODE'],
           n=x['INCOTERMS'], c=x['FCST_TYPE'], m=x['TR_MODE'], y=ymd)
Q = ("SELECT BOD_ID, QTY, LAST_UPDATED_BY FROM DM_PLN_SHIPMENT_REQ WHERE DIVISION_ID=:d AND ITEM_ID=:i AND PLANT_SITE_ID=:f "
     "AND SCM_SITE_ID=:t AND PROJECT_CODE=:p AND INCOTERMS=:n AND FCST_TYPE=:c AND TRANSPORT_MODE=:m AND MEASURE='SHIP_REQ' AND YYYYMMDD=:y")
cur.execute(Q, key); before = cur.fetchall()
cur.execute("SELECT COUNT(*) FROM DM_PLN_SHIPMENT_REQ_H WHERE DIVISION_ID=:d AND ITEM_ID=:i AND YYYYMMDD=:y", d=key['d'], i=key['i'], y=ymd)
h0 = cur.fetchone()[0]

o = cur.var(oracledb.CURSOR)
args = ['M', x['DIVISION_ID'], x['ITEM_ID'], x['FROM_SITE'], x['TO_SITE'], x['PROJECT_CODE'], x['INCOTERMS'], x['FCST_TYPE'],
        x['TR_MODE'], x['BOD_ID'], 'SHIP_REQ', ymd, str(qty + 1), 'SMOKE_SSP0046', o]
cur.callproc('PKG_SSP0046.P_SSP0046_SAVE_SHIPMENT_REQUEST', args)
res = o.getvalue().fetchall()
cur.execute(Q, key); after = cur.fetchall()
cur.execute("SELECT COUNT(*) FROM DM_PLN_SHIPMENT_REQ_H WHERE DIVISION_ID=:d AND ITEM_ID=:i AND YYYYMMDD=:y", d=key['d'], i=key['i'], y=ymd)
h1 = cur.fetchone()[0]
cur.execute("SELECT BOD_ID FROM GT_SSP0046_SAVE"); gt_bod = cur.fetchall()
c.rollback()
cur.execute(Q, key); rolled = cur.fetchall()
print(json.dumps({'key': key, 'screen_bod': x['BOD_ID'], 'gt_bod_after_update': gt_bod, 'result': res,
                  'before': before, 'after': after, 'hist_before': h0, 'hist_after': h1, 'after_rollback': rolled},
                 ensure_ascii=False, default=str, indent=1))
