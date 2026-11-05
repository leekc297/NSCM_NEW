# -*- coding: utf-8 -*-
"""콤보 응답 ↔ DB 최신 후보 대조(B7 · EG075 · DM-P1/DM-216) — Doc/verify/<ID>/combo_live.csv (2026-11-03)

  python -I tools/Harness/verify/combo_live_check.py <ID> [결과 폴더(combo_runtime.json 있는 곳)] [--user 계정]

  입력 : combo_runtime.json 의 combos[] — E2E 가 수집한 /admin/combo 요청 본문(body)과 응답 code/name(rows)
  방법 : SCM_MGR.SCM_ADM_CMBO_SQL_M 에서 SQL 을 새로 읽고(최신 원문 · BE 와 같이 DBMS_LOB.SUBSTR 4000자) BE(BaseService.makeComboQuery)
         와 같은 규칙으로 @키 를 본문 값(FE 가 이미 홑따옴표로 감쌈)·세션 값(sesUserId/userId/sesLangCd/langCd)·mnuId(따옴표 추가)로 치환, 없는 키는 '' —
         그 SQL 을 DB 에서 실행해 CODE 집합을 응답과 비교한다. 외부(LOOKUP·SSPM)에서 바뀐 값이 응답에 없으면(캐시·낡은 조회) 여기서 드러난다.
  판정 : 응답 = DB → PASS · DB 에만 있는 코드(응답 누락) → FAIL · 응답에만 있는 코드 → FAIL · SQL 없음/실행 오류/치환 불가 → ERROR(확인 대상)
         응답 rows 가 수집 상한(6000)으로 잘린 경우는 건수만 비교한다.
  변이 : CL_MUTATE=1 → 응답 첫 코드를 지워 FAIL 경로 확인(자기검증용 · 공식 결과 아님)
  세션 : 수집 레코드의 user(nscm.curUser · 2026-11-03 부터 기록)를 쓰고, 없으면 --user(기본 e2e.config.json defaultAccount)로 가정 — 시나리오에서 계정을 바꿔 수집한 콤보는 다른 결과가 날 수 있어 ERROR 가 아니라
         FAIL 로 나오면 사유에 '세션 사용자 가정' 을 적어 둔다(사용자 축 콤보 SQL 은 @sesUserId 포함 여부로 표시).
"""
import csv, json, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
COLS = ['combo_id', 'body', 'resp_n', 'db_n', 'missing', 'extra', 'result', 'why']


def default_user():
    try:
        return json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json'), encoding='utf-8-sig')).get('defaultAccount', '')
    except Exception:
        return ''


def subst(sql, params, user, lang='KO'):
    """BaseService.makeComboQuery 와 같은 치환. (치환된 SQL, 치환 못 한 키 목록)"""
    p = {k: v for k, v in params.items() if k != 'comboId'}
    p['sesUserId'] = f"'{user}'"; p['userId'] = f"'{user}'"; p['sesLangCd'] = f"'{lang}'"; p['langCd'] = f"'{lang}'"
    if p.get('mnuId') not in (None, '') and not str(p['mnuId']).startswith("'"):
        p['mnuId'] = f"'{p['mnuId']}'"
    missing = []
    def rep(m):
        k = m.group(1)
        if k in p:
            v = p[k]
            return str(v) if v is not None else "''"
        missing.append(k); return "''"
    return re.sub(r'@(\w+)', rep, sql), missing


def judge(resp_codes, db_codes, resp_n, truncated):
    """순수 판정 — 응답 코드 집합 ↔ DB 코드 집합"""
    if truncated:
        return ('PASS' if resp_n == len(db_codes) else 'FAIL', f"응답 {resp_n}건(수집 상한으로 코드 비교 생략) ↔ DB {len(db_codes)}건", [], [])
    miss = sorted(db_codes - resp_codes); extra = sorted(resp_codes - db_codes)
    if not miss and not extra:
        return 'PASS', f"응답 {len(resp_codes)}건 = DB {len(db_codes)}건", [], []
    why = f"응답 {len(resp_codes)}건 ↔ DB {len(db_codes)}건"
    if miss: why += f" · DB 에만(응답 누락) {len(miss)}: {', '.join(miss[:6])}"
    if extra: why += f" · 응답에만 {len(extra)}: {', '.join(extra[:6])}"
    return 'FAIL', why, miss, extra


def selftest():
    assert judge({'A', 'B'}, {'A', 'B'}, 2, False)[0] == 'PASS'
    assert judge({'A'}, {'A', 'B'}, 1, False)[0] == 'FAIL' and 'B' in judge({'A'}, {'A', 'B'}, 1, False)[1]
    assert judge({'A', 'C'}, {'A'}, 2, False)[0] == 'FAIL'
    assert judge(set(), {'A'} , 6000, True)[0] == 'FAIL'
    s, m = subst("SELECT 1 FROM T WHERE U=@sesUserId AND D=@divisionId AND M=@mnuId AND X=@nope", {'divisionId': "'81'", 'mnuId': 'DMF0082'}, 'u1')
    assert s == "SELECT 1 FROM T WHERE U='u1' AND D='81' AND M='DMF0082' AND X=''" and m == ['nope'], (s, m)
    print('selftest ok')


def main(mid, res_dir=None, user=None):
    user = user or default_user()
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    rt_p = os.path.join(res_dir or vd, 'combo_runtime.json')
    if not os.path.exists(rt_p):
        print(f'[combo_live] {mid}: combo_runtime.json 없음({rt_p}) — 건너뜀'); return 0
    combos = json.load(open(rt_p, encoding='utf-8-sig')).get('combos') or []
    seen = set(); items = []
    for c in combos:
        b = c.get('body') or ''
        if not b or b in seen or c.get('n') is None: continue
        seen.add(b)
        try:
            params = json.loads(b)
        except Exception:
            continue
        if isinstance(params, dict) and params.get('comboId'):
            items.append((params, c))
    if not items:
        print(f'[combo_live] {mid}: 수집된 콤보 요청 0건'); return 0
    from dbconn import connect
    res = []
    mutate = os.environ.get('CL_MUTATE') == '1'
    with connect('tobe') as cx:
        cur = cx.cursor()
        for params, c in items:
            cid = params['comboId']; body = c.get('body', '')
            try:
                cur.execute("SELECT DBMS_LOB.SUBSTR(SQL_DTL_CTN, 4000, 1), DBMS_LOB.GETLENGTH(SQL_DTL_CTN) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :1", [cid])
                row = cur.fetchone()
            except Exception as e:
                res.append({'combo_id': cid, 'body': body[:300], 'resp_n': c.get('n'), 'db_n': '', 'missing': '', 'extra': '', 'result': 'ERROR', 'why': f'[확인 대상] SQL 조회 실패 {str(e)[:120]}'}); continue
            if not row:
                res.append({'combo_id': cid, 'body': body[:300], 'resp_n': c.get('n'), 'db_n': '', 'missing': '', 'extra': '', 'result': 'ERROR', 'why': '[확인 대상] SCM_ADM_CMBO_SQL_M 에 SQL_ID 없음'}); continue
            u_rec = (c.get('user') or '').strip() or user
            sql, miss_keys = subst(str(row[0]), params, u_rec)
            note = f" · SQL {row[1]}자(BE 4000자 절단)" if row[1] and int(row[1]) > 4000 else ''
            try:
                cur.execute(sql); rows = cur.fetchall()
            except Exception as e:
                res.append({'combo_id': cid, 'body': body[:300], 'resp_n': c.get('n'), 'db_n': '', 'missing': '', 'extra': '', 'result': 'ERROR', 'why': f'[확인 대상] 치환 SQL 실행 오류 {str(e)[:120]}{note} · 미치환 키 {miss_keys}'}); continue
            cols = [d[0].upper() for d in cur.description]
            ci = cols.index('CODE') if 'CODE' in cols else 0
            db_codes = {str(r[ci]) if r[ci] is not None else '' for r in rows}
            resp_rows = c.get('rows') or []
            if mutate and resp_rows: resp_rows = resp_rows[1:]
            resp_codes = {str(r.get('c', '')) for r in resp_rows}
            resp_n = int(c.get('n') or 0) - (1 if mutate else 0)
            truncated = resp_n > len(resp_rows) + (1 if mutate else 0) and resp_n >= 6000
            r, why, miss, extra = judge(resp_codes, db_codes, resp_n, truncated)
            if r == 'FAIL' and '@sesUserId' in str(row[0]) or r == 'FAIL' and '@userId' in str(row[0]):
                why += f" · 세션 사용자 {'수집값 ' if c.get('user') else '가정 '}{u_rec}(사용자 축 SQL)"
            res.append({'combo_id': cid, 'body': body[:300], 'resp_n': resp_n, 'db_n': len(db_codes), 'missing': ';'.join(miss[:30]), 'extra': ';'.join(extra[:30]), 'result': r, 'why': why + note + (' · [변이 CL_MUTATE]' if mutate else '')})
    out = os.path.join(vd, 'combo_live.csv')
    os.makedirs(vd, exist_ok=True)
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, COLS); w.writeheader(); w.writerows(res)
    for x in res:
        print(f"[combo_live] {mid} {x['combo_id']}: {x['result']} {x['why']}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        selftest(); sys.exit(0)
    if len(sys.argv) < 2: sys.exit(__doc__)
    a = [x for x in sys.argv[1:] if not x.startswith('--')]
    u = None
    if '--user' in sys.argv: u = sys.argv[sys.argv.index('--user') + 1]; a = [x for x in a if x != u]
    sys.exit(main(a[0], a[1] if len(a) > 1 else None, u))
