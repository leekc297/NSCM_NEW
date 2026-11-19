# -*- coding: utf-8 -*-
"""사용자 칸·Measure 설정(SCM_MST_TITLESET_USER) 정합(2026-11-02 엔진 갭 EG025·EG399)

  python tools/Harness/verify/titleset_check.py <MENU_ID>   → Doc/verify/<ID>/titleset.csv (eg_ingest 가 반입)
  python tools/Harness/verify/titleset_check.py --selftest   판정 변이 입증

  EG399: AS-IS 설정 중 이관 대상(사용자 원장·칸 메타에 있는 행) ↔ TO-BE 존재 — 빠진 행 있으면 ERROR(확인 대상)
         .env.asis 가 개발 DB 라 이관 원천과 같은지 미확인 → FAIL 로 올리지 않는다
  EG025: 칸 설정 보유 사용자 중 필수 컬럼(USER_SELECTABLE_FLAG=N · VISIBLE_FLAG=Y) 미보유 — 실행 시 자동 포함될 수 있어 ERROR(확인 대상) · 화면 표시는 컬럼 설정 시험(K2)이 잰다
  읽기 전용 · 새로 조회(hook #152)
"""
import re, csv, os, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
COLS = ['kind', 'target', 'result', 'why']


def judge_migration(asis_rows, tobe_rows, users, meta_cols):
    """행 = (user, type, column). users·meta_cols 는 소문자·대문자 정규화 집합 · C 만 칸 메타 대조"""
    if not asis_rows:
        return 'NA', 'AS-IS 설정 0행 — 이관 대상 없음'
    tobe = {(u.lower(), t, c.upper()) for u, t, c in tobe_rows}
    elig = [(u.lower(), t, c.upper()) for u, t, c in asis_rows if u.lower() in users and (t != 'C' or c.upper() in meta_cols)]
    miss = [x for x in elig if x not in tobe]
    if not elig:
        return 'NA', f'AS-IS {len(asis_rows)}행 중 이관 대상 0 — 사용자 원장·칸 메타 밖'
    if miss:
        return 'ERROR', f'[확인 대상] 이관 대상 {len(elig)}행 중 TO-BE 없음 {len(miss)}행(예 {miss[:3]}) · AS-IS 전체 {len(asis_rows)}행 — AS-IS 접속이 개발 DB 라 이관 원천 일치 미확인'
    return 'PASS', f'이관 대상 {len(elig)}행 전부 TO-BE 존재 · AS-IS 전체 {len(asis_rows)}행'


def judge_required(user_cols, required):
    """user_cols: {user: {columns}} · required: {columns}"""
    if not user_cols:
        return 'NA', '칸 설정 보유 사용자 0'
    if not required:
        return 'NA', '전 Division 공통 필수 컬럼 없음(USER_SELECTABLE_FLAG=N)'
    bad = {u: sorted(required - cs) for u, cs in user_cols.items() if required - cs}
    if bad:
        ex = next(iter(sorted(bad)))
        return 'ERROR', f"[확인 대상] 칸 설정 보유 {len(user_cols)}명 중 필수 컬럼 미보유 {len(bad)}명(예 {ex}: {bad[ex][:4]}) — 실행 시 자동 포함 여부는 컬럼 설정 시험에서 확인"
    return 'PASS', f'칸 설정 보유 {len(user_cols)}명 모두 필수 컬럼 {len(required)}개 보유'


def judge_measure_order(rows, order, mcol='MEASURE'):
    """조회 결과 행 순서 ↔ 셋팅 순서(EG393) — 같은 키의 연속 행에서 Measure 순서가 셋팅과 거꾸로면 위반. rows = 화면 표본(행 순서 유지) · order = {Measure: 순번}"""
    if not rows or mcol not in rows[0]:
        return 'NA', 'Measure 칸이 없는 화면'
    if not order:
        return 'NA', '이 사용자 Measure 셋팅 없음'
    keys = [k for k in rows[0] if k != mcol and re.search(r'(?i)ITEM|SITE|CUSTOMER|PROJECT|INCOTERM|FCST_TYPE|DOM_EXP|^S$', k) and not re.search(r'(?i)NAME|_DATE$|_BY$', k)]  # 행을 나누는 키만 — Measure 마다 값이 다른 칸은 키가 아니다
    pairs = bad = 0; ex = ''
    up = {str(k).upper(): v for k, v in order.items()}
    for a, b in zip(rows, rows[1:]):
        if any(a.get(k) != b.get(k) for k in keys):
            continue
        x, y = up.get(str(a.get(mcol)).upper()), up.get(str(b.get(mcol)).upper())
        if x is None or y is None:
            continue
        pairs += 1
        if x > y:
            bad += 1; ex = ex or f'{a.get(mcol)}→{b.get(mcol)}'
    if not pairs:
        return 'NA', '같은 키의 연속 행 중 셋팅에 있는 Measure 짝 없음 — 표본 없음'
    return ('FAIL', f'Measure 순서 위반 {bad}/{pairs}쌍 — 예 {ex}(셋팅 순서와 반대)') if bad else ('PASS', f'같은 키 연속 {pairs}쌍 전부 셋팅 순서')


def selftest():
    A = [('u1', 'C', 'a'), ('u1', 'M', 'm'), ('x', 'C', 'a'), ('u1', 'C', 'gone')]
    U, M = {'u1'}, {'A'}
    cases = [('이관 전부 있음', judge_migration(A, [('U1', 'C', 'A'), ('u1', 'M', 'M')], U, M)[0], 'PASS'),
             ('이관 빠짐', judge_migration(A, [('u1', 'C', 'A')], U, M)[0], 'ERROR'),
             ('AS-IS 없음', judge_migration([], [], U, M)[0], 'NA'),
             ('대상 밖만', judge_migration([('x', 'C', 'a')], [], U, M)[0], 'NA'),
             ('필수 보유', judge_required({'u': {'A', 'B'}}, {'A'})[0], 'PASS'),
             ('필수 미보유', judge_required({'u': {'B'}}, {'A'})[0], 'ERROR'),
             ('설정 없음', judge_required({}, {'A'})[0], 'NA'),
             ('필수 메타 없음', judge_required({'u': {'B'}}, set())[0], 'NA'),
             ('순서 일치', judge_measure_order([{'S': 'a', 'MEASURE': 'X'}, {'S': 'a', 'MEASURE': 'Y'}], {'X': 1, 'Y': 2})[0], 'PASS'),
             ('순서 거꾸로', judge_measure_order([{'S': 'a', 'MEASURE': 'Y'}, {'S': 'a', 'MEASURE': 'X'}], {'X': 1, 'Y': 2})[0], 'FAIL'),
             ('키가 바뀌면 비교 안 함', judge_measure_order([{'S': 'a', 'MEASURE': 'Y'}, {'S': 'b', 'MEASURE': 'X'}], {'X': 1, 'Y': 2})[0], 'NA'),
             ('Measure 칸 없음', judge_measure_order([{'S': 'a'}], {'X': 1})[0], 'NA'),
             ('셋팅 없음', judge_measure_order([{'S': 'a', 'MEASURE': 'X'}], {})[0], 'NA'),
             ('대소문자 무시', judge_measure_order([{'S': 'a', 'MEASURE': 'x'}, {'S': 'a', 'MEASURE': 'y'}], {'X': 1, 'Y': 2})[0], 'PASS')]
    bad = 0
    for n, got, want in cases:
        k = got == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main(mid):
    from dbconn import connect
    res = []
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("SELECT USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SHEET_NAME FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID=:p", p=mid)
        tobe = [(str(a), str(b), str(c), str(d or '')) for a, b, c, d in cur.fetchall()]
        cur.execute("SELECT COLUMN_NAME, SHEET_NAME, USER_SELECTABLE_FLAG, VISIBLE_FLAG, DIVISION_ID FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:p AND NVL(VALID_YN,'Y')='Y'", p=mid)
        meta = [(str(a).upper(), str(b or ''), c, d, e) for a, b, c, d, e in cur.fetchall()]
        cur.execute('SELECT LOWER(USER_ID) FROM SCM_ADM_USER_M')
        users = {x[0] for x in cur.fetchall()}
    meta_cols = {m[0] for m in meta}
    try:
        with connect('asis') as cx:
            cur = cx.cursor()
            cur.execute('SELECT USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME FROM dbo.SCM_MST_TITLESET_USER WITH (NOLOCK) WHERE PROGRAM_ID=?', mid)
            asis = [(str(a), str(b), str(c)) for a, b, c in cur.fetchall()]
        r, why = judge_migration(asis, [t[:3] for t in tobe], users, meta_cols)
    except Exception as e:
        r, why = 'ERROR', f'[측정 경로 없음] AS-IS 조회 실패: {str(e)[:160]}'
    res.append({'kind': 'TITLESET_MIG', 'target': mid, 'result': r, 'why': why})
    # 시트별 — 사용자별 Division 을 알 수 없어(사용자 원장에 없음) 전 Division 공통 필수만 판정하고 Division 별 미보유 수는 근거로 붙인다
    sheets = sorted({t[3] for t in tobe if t[1] == 'C'})
    for sh in sheets or ['']:
        uc = {}
        for u, t, c, s in tobe:
            if t == 'C' and s == sh:
                uc.setdefault(u, set()).add(c.upper())
        by_div = {}
        for m in meta:
            if m[1].lower() == sh.lower() and m[2] == 'N' and m[3] == 'Y':
                for d in str(m[4] or '').split(','):
                    if d.strip():
                        by_div.setdefault(d.strip(), set()).add(m[0])
        req = set.intersection(*by_div.values()) if by_div else set()
        r, why = judge_required(uc, req)
        per = {d: sum(1 for cs in uc.values() if v - cs) for d, v in sorted(by_div.items())}
        if per:
            why += f' · Division 별 필수 미보유 사용자 수(사용자 Division 미확인 — 참고) {per}'
        res.append({'kind': 'TITLESET_REQ', 'target': f'{mid}.{sh}', 'result': r, 'why': why})
    # EG393 — 실전송 표본(a1_live.json)이 있으면 그 사용자의 Measure 셋팅 순서와 대조
    _a1 = os.path.join(ROOT, 'Doc', 'verify', mid, 'a1_live.json')
    if os.path.exists(_a1):
        import json
        d = json.load(open(_a1, encoding='utf-8')); rows = d.get('sample') or []
        call = (d.get('calls') or [{}])[0]; b = {}
        try: b = json.loads(call.get('body') or '{}')
        except ValueError: pass
        uid = b.get('sesUserId') or b.get('createdBy') or b.get('userId') or ''
        with connect('tobe') as cx:
            cur = cx.cursor()
            cur.execute("SELECT COLUMN_NAME, SORT_ORDER_NO FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID=:p AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='M' AND LOWER(SHEET_NAME)=LOWER(:s)", p=mid, u=uid, s=str(call.get('sheet') or ''))
            order = {str(a): (c or 0) for a, c in cur.fetchall()}
        r, why = judge_measure_order(rows, order)
        res.append({'kind': 'MEASURE_ORDER', 'target': f"{mid}.{call.get('sheet', '')}", 'result': r, 'why': f'{why} · 사용자 {uid}'})
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'titleset.csv')
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(res)
    for x in res:
        print(f"[titleset] {x['kind']} {x['target']}: {x['result']} {x['why']}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
