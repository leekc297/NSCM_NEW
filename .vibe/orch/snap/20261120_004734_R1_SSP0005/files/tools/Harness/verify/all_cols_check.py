# -*- coding: utf-8 -*-
"""전 컬럼 선택 조회 SQL 오류(2026-11-03 엔진 갭 EG213 · GAP-340 Forecast Info All ORA-01722 유형)

  python tools/Harness/verify/all_cols_check.py <MENU_ID>   → Doc/verify/<ID>/all_cols.csv (eg_ingest 가 F4 행으로 반입)
  python tools/Harness/verify/all_cols_check.py --selftest   판정 변이 입증

  사용자 칸 설정(SCM_MST_TITLESET_USER)을 읽어 SELECT 를 만드는 조회 PROC 이 대상. 실제 사용자 설정은 건드리지 않는다:
  없는 사용자 E2E_TMP_ALLCOL 로 그 시트의 선택 가능 칸 전부를 넣고 → PROC 직접 실행(_GET_ 만) → 끝에 그 사용자 행만 지운다(ROLLBACK + DELETE · 전후 행 수 대조)
  판정: 실행 오류·결과 커서 오류 코드 = FAIL · 정상 = PASS · 칸 설정을 안 읽는 PROC·인자 값 없음 = NA
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)
COLS = ['proc', 'sheet', 'cols', 'result', 'why']
TMP = 'E2E_TMP_ALLCOL'
LAST_ROWS = -1


def judge(proc, sheet, n, err, code, base=''):
    """err = 실행 예외 문구 · code = 결과 커서의 오류 코드·문구(없으면 빈 값) · base = 칸 설정 없이 같은 인자로 돌린 대조군 오류 — 대조군도 실패면 인자 문제라 판정 불가"""
    if base:
        return 'ERROR', f"[측정 경로 없음] {proc}({sheet}) 칸 설정 없이도 실패 — 인자 확인 필요: {base[:160]}"
    if err:
        return 'FAIL', f"{proc}({sheet}) 칸 {n}개 전부 선택 조회 오류: {err[:200]}"
    if code:
        return 'FAIL', f"{proc}({sheet}) 칸 {n}개 전부 선택 결과 커서 오류: {code[:200]}"
    return 'PASS', f"{proc}({sheet}) 칸 {n}개 전부 선택 조회 오류 0"


def judge_split(sheet, base, added, cols):
    """Last Update 칸 추가 전후 행 수(EG398 GAPPI-43) — 값이 다른 행이 갈라지면 키당 Measure 1행이 깨진다"""
    if base < 0 or added < 0:
        return 'ERROR', f'[측정 경로 없음] {sheet} 행 수를 못 읽음(전 {base} · 후 {added})'
    if base == 0:
        return 'NA', f'{sheet} 칸 추가 전 0행 — 표본 없음'
    if added > base:
        return 'FAIL', f'{sheet} {cols} 추가로 행이 갈라짐 {base}→{added}행'
    return 'PASS', f'{sheet} {cols} 추가 전후 {base}행 = {added}행'


def selftest():
    cases = [('정상', judge('P', 'S', 3, '', '')[0], 'PASS'), ('ORA 오류', judge('P', 'S', 3, 'ORA-01722', '')[0], 'FAIL'), ('결과 커서 오류', judge('P', 'S', 3, '', '-9994 오류')[0], 'FAIL'), ('대조군도 실패', judge('P', 'S', 3, 'ORA-01840', '', 'ORA-01840')[0], 'ERROR'), ('행 분리', judge_split('S', 5, 7, ['L'])[0], 'FAIL'), ('행 수 같음', judge_split('S', 5, 5, ['L'])[0], 'PASS'), ('0행', judge_split('S', 0, 0, ['L'])[0], 'NA'), ('못 읽음', judge_split('S', -1, 5, ['L'])[0], 'ERROR')]
    bad = 0
    for n, got, want in cases:
        k = got == want; bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def nk(s): return re.sub(r'[^a-z0-9]', '', str(s).lower())


def call(tcx, proc, params):
    import oracledb
    cur = tcx.cursor(); pkg, _, name = proc.rpartition('.')
    cur.execute("""SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND NVL(PACKAGE_NAME,'~')=NVL(:p,'~')
                   AND DATA_LEVEL=0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION""", n=name.upper(), p=(pkg.upper() or None))
    lp = {nk(k): v for k, v in params.items()}; args, outs = [], []
    ses = lp.get('sesuserid') or lp.get('pcreatedby') or lp.get('createdby') or ''  # BE 가 세션 사용자로 채우는 인자(@sesUserId)
    for argn, inout, dt in cur.fetchall():
        if 'OUT' in inout and dt == 'REF CURSOR':
            v = cur.var(oracledb.DB_TYPE_CURSOR); outs.append((argn, v)); args.append(v)
        else:
            val = lp.get(nk(argn), lp.get(nk(re.sub(r'(?i)^p_', '', argn))))
            if val is None and re.search('(?i)created_?by|user_?id$', argn):
                val = ses
            args.append(val)
    cur.callproc(proc, args)
    code = ''
    global LAST_ROWS
    LAST_ROWS = -1
    for argn, v in outs:
        rc = v.getvalue()
        if rc is None:
            continue
        cols = [d[0] for d in rc.description]
        rows = rc.fetchmany(5)
        if LAST_ROWS < 0 and not re.search('RESULT', argn, re.I) and len(cols) > 1:  # 본 결과 커서 행 수(EG398)
            LAST_ROWS = len(rows)
            while True:
                more = rc.fetchmany(5000)
                if not more:
                    break
                LAST_ROWS += len(more)
        if re.search('RESULT', argn, re.I) and rows and 'CODE' in cols:
            c = rows[0][cols.index('CODE')]
            if str(c) not in ('0', '1', 'S', 'SUCCESS', 'None'):
                code = f"{c} {rows[0][cols.index('MESSAGE')] if 'MESSAGE' in cols else ''}"
    return code


def main(mid):
    from dbconn import connect
    gc = [r for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'golden', 'golden_cases.csv'), encoding='utf-8-sig', newline='')) if r.get('screen') == mid and r.get('kind') == 'GET' and re.search('_GET_', r.get('tobe_proc') or '')]
    pm = [r for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv'), encoding='utf-8-sig', newline='')) if (r.get('menu_id') or '').upper() == mid]
    res = []
    # 화면 실전송 본문이 있으면 그 인자를 쓴다(골든 케이스 없는 화면 · 날짜 빈 값 방지)
    sent = {}
    _a1 = os.path.join(ROOT, 'Doc', 'verify', mid, 'a1_live.json')
    if os.path.exists(_a1):
        for c0 in json.load(open(_a1, encoding='utf-8')).get('calls') or []:
            p0 = next((r.get('proc') for r in pm if (r.get('sheet') or '').lower() == str(c0.get('sheet')).lower() and (r.get('btn') or '').upper() == str(c0.get('btn')).upper()), '')
            try:
                sent[str(p0).upper()] = json.loads(c0.get('body') or '{}')
            except ValueError:
                pass
    known = {g['tobe_proc'].upper() for g in gc}
    gc = gc + [{'tobe_proc': k, 'params': '{}'} for k in sent if k and re.search('_GET_', k) and k not in known]
    with connect('tobe', write=True) as cx:
        cur = cx.cursor()
        cur.execute('SELECT COUNT(*) FROM SCM_MST_TITLESET_USER WHERE USER_ID=:u', u=TMP); assert cur.fetchone()[0] == 0, f'{TMP} 행이 이미 있음 — 수동 확인'
        cur.execute("SELECT COUNT(*) FROM SCM_MST_TITLESET_USER"); n0 = cur.fetchone()[0]
        try:
            for g in gc:
                proc = g['tobe_proc']; pkg, _, nm = proc.rpartition('.')
                cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE NAME=:n AND TYPE='PACKAGE BODY' AND UPPER(TEXT) LIKE '%TITLESET_USER%' AND ROWNUM=1", n=pkg.upper())
                if not cur.fetchone():
                    continue
                sheets = sorted({r.get('sheet').lower(): r.get('sheet') for r in pm if (r.get('proc') or '').upper() == proc.upper() and r.get('sheet')}.values())
                try:
                    params = sent.get(proc.upper()) or json.loads(g.get('params') or '{}')
                except ValueError:
                    params = {}
                if not params:
                    res.append({'proc': proc, 'sheet': '', 'cols': 0, 'result': 'NA', 'why': '인자 값 없음(골든 케이스)'}); continue
                up = {k: (TMP if re.search('(?i)created_?by|user_?id|sesuser', k) else v) for k, v in params.items()}
                for sh in sheets or ['']:
                    cur.execute("SELECT COLUMN_NAME FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:p AND LOWER(SHEET_NAME)=LOWER(:s) AND NVL(VALID_YN,'Y')='Y' AND USER_SELECTABLE_FLAG='Y'", p=mid, s=sh)
                    cols = sorted({r[0] for r in cur.fetchall()})
                    if not cols:
                        continue
                    base = ''
                    try:
                        base = call(cx, proc, params)
                    except Exception as e:  # noqa: BLE001 — 대조군: 칸 설정 없이 같은 인자
                        base = str(e).split('\n')[0]
                    cx.rollback()
                    cur.execute('DELETE FROM SCM_MST_TITLESET_USER WHERE USER_ID=:u', u=TMP)
                    for i, c in enumerate(cols):
                        cur.execute("""INSERT INTO SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                                       VALUES (:u, :p, :s, 'C', :c, :o, 'admin', SYSDATE, 'admin', SYSDATE)""", u=TMP, p=mid, s=sh, c=c, o=i + 1)
                    err, code = '', ''
                    try:
                        code = call(cx, proc, up)
                    except Exception as e:  # noqa: BLE001 — ORA 오류가 판정 재료
                        err = str(e).split('\n')[0]
                    r, why = judge(proc, sh, len(cols), err, code, base)
                    res.append({'proc': proc, 'sheet': sh, 'cols': len(cols), 'result': r, 'why': why})
                    cx.rollback()
                    # EG398 — Last Update 칸을 더해도 행이 갈라지지 않아야 한다(필수 칸만 ↔ 필수 칸 + Last Update)
                    lu = [c for c in cols if re.search('(?i)LAST_UPDATE', c)]
                    if lu and not base:
                        cur.execute("SELECT COLUMN_NAME FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:p AND LOWER(SHEET_NAME)=LOWER(:s) AND NVL(VALID_YN,'Y')='Y' AND USER_SELECTABLE_FLAG='N'", p=mid, s=sh)
                        req = sorted({x[0] for x in cur.fetchall()})
                        counts = []
                        for cset in (req, req + lu):
                            cur.execute('DELETE FROM SCM_MST_TITLESET_USER WHERE USER_ID=:u', u=TMP)
                            for i, c in enumerate(cset):
                                cur.execute("""INSERT INTO SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                                               VALUES (:u, :p, :s, 'C', :c, :o, 'admin', SYSDATE, 'admin', SYSDATE)""", u=TMP, p=mid, s=sh, c=c, o=i + 1)
                            try:
                                call(cx, proc, up); counts.append(LAST_ROWS)
                            except Exception:  # noqa: BLE001 — 행 수를 못 읽음
                                counts.append(-1)
                            cx.rollback()
                        r2, why2 = judge_split(sh, counts[0], counts[1], lu)
                        res.append({'proc': proc, 'sheet': f'{sh}|행분리', 'cols': len(req) + len(lu), 'result': r2, 'why': why2})
        finally:
            cx.rollback()
            cur.execute('DELETE FROM SCM_MST_TITLESET_USER WHERE USER_ID=:u', u=TMP); cx.commit()
            cur.execute("SELECT COUNT(*) FROM SCM_MST_TITLESET_USER"); n1 = cur.fetchone()[0]
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'all_cols.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, COLS); w.writeheader(); w.writerows(res)
    c = {}
    for x in res: c[x['result']] = c.get(x['result'], 0) + 1
    print(f'[all_cols] {mid} {c} · 설정 표 행 수 전 {n0} 후 {n1}')
    return 0 if n0 == n1 else 1


if __name__ == '__main__':
    if len(sys.argv) < 2: sys.exit(__doc__)
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
