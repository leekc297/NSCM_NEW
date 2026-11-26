# -*- coding: utf-8 -*-
# 3단계 최종 INSERT(cy0a8kvgd0cw7) SELECT 사내 재현 : 세션 GTT 에 계획 40/20261121/SP/1 HQ00 전 측정값(13종) 적재
# 변형 : OLD(원문), E3OLD(클라우드 1행 추정 재현 CARDINALITY(T 1)), E3HASH(재현 + 해시 조인 지정), HASH(실제 추정 + 해시 조인 지정)
# 결과 = 행 수 + 전 컬럼 ORA_HASH 합(SYSDATE 는 고정값으로 바꿔 비교). DB 안에서 집계해 전송 시간 제외
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

raw = io.open('s3_old_raw.sql', encoding='utf-8').read().rstrip().rstrip(';').rstrip()
raw = raw.replace('SYSDATE      AS LAST_UPDATED_BY', 'SYSDATE      AS LAST_UPDATE_DATE')
raw = raw.replace('SYSDATE', "TO_DATE('2026-11-26', 'YYYY-MM-DD')")
assert raw.count(',T.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */') == 1 and raw.count(',T.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */') == 1
raw = raw.replace(',T.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */', ',T.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID').replace(',T.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */', ',T.DIVISION_ID AS ORIGIN_TO_DIVISION_ID')
raw = re.sub(r'\bV_(DIVISION_ID|COMPANY_ID|BATCH_USER)\b', r':V_\1', raw)
cols = re.findall(r'(?:AS\s+(\w+)\s*(?:/\*.*?\*/)?\s*$)|(?:,?\s*T\.(\w+)\s*(?:/\*.*?\*/)?\s*$)', raw, re.M)
names = []
for a, b in cols:
    names.append(a or b)
seen, uniq = set(), []
for n in names:
    k = n
    while k in seen:
        k += '_2'
    seen.add(k); uniq.append(k)
uniq = uniq[:36]
assert uniq[35] == 'ATTRIBUTE10' and uniq[24] == 'CREATION_DATE'
HINT_POS = 'SELECT DISTINCT'
V = {
    'OLD': raw,
    'E3OLD': raw.replace(HINT_POS, 'SELECT /*+ CARDINALITY(T 1) */ DISTINCT', 1),
    'E3HASH': raw.replace(HINT_POS, 'SELECT /*+ CARDINALITY(T 1) LEADING(T V E) USE_HASH(V E) */ DISTINCT', 1),
    'HASH': raw.replace(HINT_POS, 'SELECT /*+ LEADING(T V E) USE_HASH(V E) */ DISTINCT', 1),
}
B = dict(V_DIVISION_ID='40', V_COMPANY_ID='HQ00', V_BATCH_USER='ssp_batch')


def wrap(q, tag):
    hcols = " || '|' || ".join('X.' + n for n in uniq)
    return "/* %s */ SELECT COUNT(*), SUM(ORA_HASH(%s)) FROM (%s) X" % (tag, hcols, q)


def main():
    cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
    c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
    c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
    c.execute("""SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_ID) FROM ALL_TAB_COLUMNS T WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'
      AND EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS S WHERE S.OWNER='SCM_MGR' AND S.TABLE_NAME='SSP_ANL_SHIP_PLAN_40' AND S.COLUMN_NAME=T.COLUMN_NAME)""")
    gc = c.fetchone()[0]
    c.execute("INSERT INTO GT_SSP_ANL_SHIP_PLAN_40 (" + gc + ") SELECT " + gc + """ FROM SSP_ANL_SHIP_PLAN_40 P
     WHERE P.DIVISION_ID='40' AND P.PLAN_START_YYYYMMDD='20261121' AND P.PLAN_TYPE='SP' AND P.SEQ=1
       AND EXISTS (SELECT 1 FROM SCM_MST_SITE E WHERE E.DIVISION_ID='40' AND NVL(E.COMPANY_ID,'-')='HQ00' AND E.SCM_SITE_ID=P.FROM_SITE)""")
    print('GT 적재', c.rowcount, '컬럼', len(uniq), flush=True)
    tag = time.strftime('%H%M%S')
    res = {}
    for rnd in (1, 2):
        for k, q in V.items():
            t = time.time(); c.execute(wrap(q, 'S3_%s_%s' % (k, tag)), B); r = c.fetchone(); el = time.time() - t
            res[k] = r
            print(rnd, k, '%.2fs' % el, r, flush=True)
    for k in V:
        print('  %s == OLD' % k, res[k] == res['OLD'])
    c.execute("SELECT REGEXP_SUBSTR(SQL_TEXT, 'S3_[A-Z0-9]+'), PLAN_HASH_VALUE, EXECUTIONS, ROUND(ELAPSED_TIME/1e6/EXECUTIONS, 2), ROUND(BUFFER_GETS/EXECUTIONS) "
              "FROM V$SQL WHERE SQL_TEXT LIKE '%S3_%" + tag + "%' AND SQL_TEXT NOT LIKE '%V$SQL%' ORDER BY 1")
    for x in c.fetchall(): print('V$SQL', x)
    cx.rollback()


if __name__ == '__main__':
    main()
