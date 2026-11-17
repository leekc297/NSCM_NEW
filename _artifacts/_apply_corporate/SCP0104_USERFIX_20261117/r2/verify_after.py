# -*- coding: utf-8 -*-
"""SCP0104 사용자의견 DB 보완 시험 (2026-11-17) — python verify_after.py <tag>   (tag = before | after)
1) ELTR 저장 ORA-01840 재현 호출(BE 로그 인자) → RESULT_CD · 같은 트랜잭션 안 변경 행 확인 후 ROLLBACK(이 경로에 COMMIT 없음 확인)
2) ELTR 조회 Material = 'apcan2364c'(소문자) → 행 수 · ITEM_ID 일치
3) SOP_ASSEMBLY · SOP_ELTR 조회 행 순서 = AS-IS ORDER BY 키 순서인지
4) Dummy 이름 대소문자 — after 에서만(이 프로시저는 COMMIT): 기존 이름을 소문자로 넣어 기존 코드 반환·행 수 불변 확인
"""
import sys, os, json, datetime
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn, oracledb
HERE = os.path.dirname(os.path.abspath(__file__))
SP = os.path.join(os.environ['LOCALAPPDATA'], r'Temp\claude\47795e279550c665\0af975be-1a48-4038-8fc6-fd8238bd28a7\scratchpad')
tag = sys.argv[1]
out = {}
con = dbconn.connect('tobe', write=True)
cur = con.cursor()
print('[%s] verify %s' % (datetime.datetime.now().strftime('%m-%d %H:%M:%S'), tag))


def args_of(pn):
    cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_SCP0104' AND OBJECT_NAME=:n AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION", n=pn)
    return cur.fetchall()


def call(pn, ins, cursor_name):
    a = args_of(pn)
    kw, outs = {}, {}
    n_in = sum(1 for _, io in a if io != 'OUT')
    if len(ins) == n_in - 1:   # BE 로그에 P_USER_ID 가 따옴표 없이 남아 추출에서 빠짐 → DEBUG 앞에 채움
        ins = list(ins[:-1]) + ['minyonglee1', ins[-1]]
    vi = iter(ins)
    for an, io in a:
        if io == 'OUT':
            outs[an] = cur.var(oracledb.DB_TYPE_CURSOR); kw[an] = outs[an]
        else:
            kw[an] = next(vi)
    cur.callproc('PKG_SCP0104.' + pn, keyword_parameters=kw)
    rc = outs[cursor_name].getvalue()
    cols = [d[0] for d in rc.description]
    return cols, [tuple(v.read() if hasattr(v, 'read') else v for v in r) for r in rc.fetchall()]


# 1) 저장 실패 재현
calls = json.load(open(os.path.join(SP, 'ora1840_calls.json'), encoding='utf-8'))
seen = set()
res1 = []
for c in calls:
    v = c['vals'][:26]
    k = (v[16], v[21][:30])
    if k in seen:
        continue
    seen.add(k)
    cur.execute("SELECT COUNT(*), SUM(LANE_QTY), SUM(ASSIGN_PRIORITY) FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN WHERE DIVISION_ID=:d AND LINE_ID=:l AND ITEM_ID=:i", d=v[3], l=v[8], i=v[18])
    b = cur.fetchone()
    cols, rows = call('P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR', v, 'O_RC1')
    cur.execute("SELECT COUNT(*), SUM(LANE_QTY), SUM(ASSIGN_PRIORITY) FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN WHERE DIVISION_ID=:d AND LINE_ID=:l AND ITEM_ID=:i", d=v[3], l=v[8], i=v[18])
    a = cur.fetchone()
    con.rollback()
    r = dict(at=c['at'], lane=v[16], vals_head=v[21][:12], result=rows[0][0] if rows else None, msg=(rows[0][2] or '')[:120] if rows else '', before=b, in_txn_after=a)
    res1.append(r)
    print(' 저장', r)
out['save'] = res1

# 2) ELTR Material
base = json.load(open(os.path.join(SP, 'get_calls.json'), encoding='utf-8'))['P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR(']
g = next(x for x in base if x[4] == 'MI02' and x[5] == 'ET')
names = [an for an, io in args_of('P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR') if io != 'OUT']
res2 = {}
for label, val in (('전체', g[names.index('P_ITEM_ID')]), ('소문자', 'apcan2364c'), ('대문자', 'APCAN2364C')):
    vv = list(g); vv[names.index('P_ITEM_ID')] = val
    cols, rows = call('P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR', vv, 'O_RC1')
    ii = cols.index('ITEM_ID') if 'ITEM_ID' in cols else None
    items = sorted({r[ii] for r in rows}) if ii is not None else []
    res2[label] = dict(n=len(rows), items=items[:5])
    print(' Material', label, repr(val[:20]), '→', len(rows), '행', items[:5])
    con.rollback()
out['material'] = res2

# 3) SOP 정렬
res3 = {}
gc = json.load(open(os.path.join(SP, 'get_calls.json'), encoding='utf-8'))
for pn, key in (('P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY', 'P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY('), ('P_SCP0104_GET_CAPA_LINE_SOP_ELTR', 'P_SCP0104_GET_CAPA_LINE_SOP_ELTR(')):
    uniq = []
    for x in gc[key]:
        if x not in uniq:
            uniq.append(x)
    for x in uniq:
        cols, rows = call(pn, x, 'O_RC1')
        kc = [c for c in ('DIVISION_ID', 'SITE_ID', 'COMPANY_ID', 'PLANT_ID', 'FACTORY_ID', 'LINE_ID', 'OPERATION_ID', 'ELTR_LN_TP_CD') if c in cols]
        keys = [tuple('' if r[cols.index(c)] is None else str(r[cols.index(c)]) for c in kc) for r in rows]
        bad = sum(1 for i in range(1, len(keys)) if keys[i] < keys[i - 1])
        res3['%s div=%s' % (pn[-12:], x[2])] = dict(n=len(rows), out_of_order=bad)
        print(' 정렬', pn[-12:], 'div', x[2], len(rows), '행 · 키 순서 어긋남', bad)
        con.rollback()
out['sop_order'] = res3

# 4) Dummy 대소문자(after 만)
cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0104' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%UPPER(A.NAME) = UPPER(V_NAME)%'")
patched = cur.fetchone()[0] > 0   # 09:44 사고 방지: 보완이 DB 에 없으면 이 시험(COMMIT 하는 채번)을 돌리지 않는다
if tag == 'after' and not patched:
    print(' Dummy 시험 건너뜀: DB 원문에 보완 구간 없음')
if tag == 'after' and patched:
    cur.execute("SELECT CODE_TP, CODE, NAME FROM SCP_MST_CAPA_DUMMY_CODE WHERE NAME <> LOWER(NAME) AND CODE_TP='M' AND ROWNUM = 1")
    row = cur.fetchone() or None
    if row is None:
        cur.execute("SELECT CODE_TP, CODE, NAME FROM SCP_MST_CAPA_DUMMY_CODE WHERE NAME <> LOWER(NAME) AND ROWNUM = 1"); row = cur.fetchone()
    cur.execute("SELECT COUNT(*) FROM SCP_MST_CAPA_DUMMY_CODE"); n0 = cur.fetchone()[0]
    cols, rows = call('P_SCP0104_CHECK_NAME_ON_DUMMY_CODE', [row[0], row[2].lower(), 'SCP0104', 'ASSEMBLY', 'minyonglee1', 'F'], 'O_RC1')
    cur.execute("SELECT COUNT(*) FROM SCP_MST_CAPA_DUMMY_CODE"); n1 = cur.fetchone()[0]
    ci = cols.index('CODE') if 'CODE' in cols else None
    got = [r[ci] for r in rows] if ci is not None else rows
    out['dummy'] = dict(existing=row, input=row[2].lower(), returned=got, rows_before=n0, rows_after=n1)
    print(' Dummy', out['dummy'])
con.rollback()
json.dump(out, open(os.path.join(HERE, 'logs', 'verify_%s.json' % tag), 'w', encoding='utf-8'), ensure_ascii=False, default=str, indent=1)
