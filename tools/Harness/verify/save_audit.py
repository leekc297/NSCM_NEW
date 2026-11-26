"""F8 감사 필드 · F7 저장 연계 테이블 정적 판정 — CRUD 실제 저장(E2E) 이 남긴 행의 정리 백업으로 판정 (2026-10-27)

사용자 요청(10-27): 단위테스트 두 시트 오류(예: SYS0012 Reject Reason·Request Date 파생 필드 · 저장 연계)가 다른 화면에 같은 형태로 있으면 찾아야 한다.
  F7·F8 은 검사기가 없어 모든 화면에서 '검사기 없음'으로 지나갔다.

원천
  TO-BE : cleanup_marker.py 가 E2E 마커 행을 지우기 전에 남긴 백업 Doc/verify/<ID>/cleanup/<시각>_<테이블>.csv + cleanup_<시각>.sql(계정·생성 시각 기준)
          = 화면 저장 1회가 실제로 기록한 테이블·행(루트 + 연쇄)
  AS-IS : 저장 SP 원문 Doc/asisfacts/db/modules/dbo.<SAVE SP>.sql 의 DML 대상 테이블(MERGE/INSERT = 신규행 저장 경로 · UPDATE/DELETE 만 = 기존행 경로)
          저장 SP = Doc/golden/golden_cases.csv kind=SAVE 의 asis_sp
판정
  F8  루트 행 CREATED_BY · LAST_UPDATED_BY = 저장 계정 · CREATION_DATE · LAST_UPDATE_DATE = 저장 시각(정리 SQL 기준 시각 ±10분) — 감사 컬럼 없으면 NA
  F7  AS-IS 저장 SP 가 신규행 경로(MERGE/INSERT)로 쓰는 업무 테이블마다 TO-BE 저장이 행을 남겼는지 — 없으면 FAIL
      로그 테이블(이름에 LOG)·임시(#·@) 제외 · UPDATE 만 하는 테이블은 신규행 1건 시험의 대상 아님(NA 메모) · TO-BE 에만 기록한 테이블은 참고(판정 영향 없음)

  python save_audit.py <MENU_ID>   → Doc/verify/<ID>/save_audit.json
"""
import csv, datetime, glob, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
AUDIT = ('CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE')


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def strip_tsql_comments(src):
    """T-SQL 주석 제거 — 문자열('…') 안은 그대로 · '--' 줄 주석 · '/* */' 블록 주석(중첩 허용)을 앞에서부터 하나씩 읽어 지운다.
    2026-11-18: 줄 단위 '--' 자르기를 먼저 하면 '/*-- … --*/' 의 닫는 표시가 사라져 뒤 본문 전체가 주석이 된다(DMF0003 SCM_MST_SITE_ITEM 누락 실측)"""
    out = []; i = 0; n = len(src); depth = 0
    while i < n:
        c2 = src[i:i + 2]
        if depth:
            if c2 == '/*': depth += 1; i += 2
            elif c2 == '*/': depth -= 1; i += 2; out.append(' ') if not depth else None
            else: out.append('\n') if src[i] == '\n' else None; i += 1
            continue
        if c2 == '/*': depth = 1; i += 2; continue
        if c2 == '--':
            j = src.find('\n', i); i = n if j < 0 else j; continue
        if src[i] == "'":
            j = i + 1
            while j < n:
                if src[j] == "'":
                    if src[j + 1:j + 2] == "'": j += 2; continue
                    break
                j += 1
            out.append(src[i:j + 1]); i = j + 1; continue
        out.append(src[i]); i += 1
    return ''.join(out)


def asis_targets(sp):
    p = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules', f'dbo.{sp}.sql')
    if not os.path.exists(p):
        return None
    ins, upd = set(), set()
    code = strip_tsql_comments(open(p, encoding='utf-8', errors='ignore').read())
    for m in re.finditer(r'(?i)\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+(?:\[?dbo\]?\.)?\[?([A-Za-z_][\w]*)\]?', code):
        kind, t = m.group(1), m.group(2).upper()
        if t in ('SET', 'TOP'):
            continue
        # 2026-11-18 SCP0111 F7: T-SQL 'UPDATE X SET … FROM 표 X' 의 별칭 X 를 표로 읽었다 → 같은 문장(다음 DML 앞까지)의 FROM/JOIN 에서 별칭이 가리키는 표로 바꾼다
        if not re.match(r'(?i)(MERGE|INSERT)', kind):
            seg = code[m.end():m.end() + 4000]
            nx = re.search(r'(?i)\b(UPDATE|INSERT|MERGE|DELETE)\b', seg)
            seg = seg[:nx.start()] if nx else seg
            al = re.search(r'(?i)\b(?:FROM|JOIN)\s+(?:\[?dbo\]?\.)?\[?([A-Za-z_#@][\w]*)\]?\s+(?:AS\s+)?' + re.escape(m.group(2)) + r'\b', seg)
            if al:
                t = al.group(1).upper()
        if t.startswith(('#', '@')) or 'LOG' in t:
            continue
        (ins if re.match(r'(?i)(MERGE|INSERT)', kind) else upd).add(t)
    return ins, upd - ins


def row_account(row, key_acc, default, default_t0=None):
    """T640: 백업 행의 키 값이 정리 SQL 키별 계정 줄과 같으면 그 계정(저장 시각이 있으면 시각도) · 없으면 기본(머리글·삭제 조건·설정) 계정
    key_acc = [(키 dict, 계정[, 저장 시각 datetime|None])] · default_t0 를 주면 (계정, 시각) 반환"""
    for keys, acc, *rest in key_acc:
        if keys and all(str(row.get(k, '')).strip() == str(v).strip() for k, v in keys.items()):
            return (acc, (rest[0] if rest and rest[0] else default_t0)) if default_t0 is not None else acc
    return (default, default_t0) if default_t0 is not None else default


def judge_trace(trace, save_sps, targets_of):
    """2026-11-18(SCP0111 F7·F8 미검증): 기존 행 수정형 저장 — restore_touched 키 없는 복원이 되돌리기 전에 남긴 save_trace.json 으로 판정
    F8 = 변경 행 감사 칸 판정(judge_audit: 생성 칸 불변 · 값이 바뀌면 수정 칸 갱신) — FAIL 1건이라도 있으면 FAIL · PASS 만이면 PASS
    F7 = AS-IS 저장 SP(전부) DML 대상 업무 표 중 이번에 확인한 표(tables_scanned)를 저장이 썼는지 — 확인 못 한 표가 있으면 NOT_RUN(추정 금지)"""
    au = [a for a in trace.get('audit') or [] if a.get('result') != 'NA']
    fails = [a for a in au if a.get('result') == 'FAIL']
    who = f"계정 {trace.get('account', '')} · 기준 시각 {trace.get('at', '')}"
    if not au:
        f8 = {'verdict': 'NOT_RUN', 'note': f"변경 행 감사 판정 없음(감사 칸 없음 또는 변경 0) · {who}"}
    else:
        f8 = {'verdict': 'FAIL' if fails else 'PASS',
              'note': ('; '.join(dict.fromkeys(a['why'] for a in fails))[:600] if fails else f"변경 행 {len(au)}건 감사 칸 정상(생성 칸 불변 · 수정 칸 갱신 · LAST_UPDATED_BY = 저장 계정)") + f" · {who}"}
    wrote = {t.upper() for t, n in {**(trace.get('created') or {}), **(trace.get('changed') or {})}.items() if n}
    scanned = {t.upper() for t in trace.get('tables_scanned') or []}
    sps = [sp for sp in save_sps if sp]
    if not sps:
        return f8, {'verdict': 'NA', 'note': '저장 SP 없음'}
    tg = {sp: targets_of(sp) for sp in sps}
    if any(v is None for v in tg.values()):
        return f8, {'verdict': 'NOT_RUN', 'note': f"AS-IS 저장 SP 원문 없음({', '.join(sp for sp, v in tg.items() if v is None)})"}
    need = set().union(*[v[0] | v[1] for v in tg.values()])
    unk = sorted(t for t in need if t not in scanned)
    miss = sorted(t for t in need if t in scanned and t not in wrote)
    base = f"AS-IS {', '.join(sps)} 대상 표 {', '.join(sorted(need)) or '없음'} · TO-BE 저장이 쓴 표 {', '.join(sorted(wrote))}"
    if miss:
        return f8, {'verdict': 'FAIL', 'note': f"{base} · 저장이 행을 남기지 않은 표 {', '.join(miss)}"}
    if unk:
        return f8, {'verdict': 'NOT_RUN', 'note': f"{base} · 이번 복원이 확인하지 않은 표 {', '.join(unk)}(cleanup_spec tables 밖) — 미측정"}
    return f8, {'verdict': 'PASS', 'note': f"{base} · 대상 표 전부 기록"}


def from_trace(mid, res):
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'save_trace.json')
    if not os.path.exists(p):
        return False
    trace = json.load(open(p, encoding='utf-8'))
    sys.path.insert(0, HERE); from asis_live import live_golden, asis_of
    asis = asis_of(mid, sys.argv[sys.argv.index('--asis') + 1] if '--asis' in sys.argv else '')
    sps = list(dict.fromkeys(g['asis_sp'] for g in live_golden(mid, asis, 'SAVE')))
    res['F8'], res['F7'] = judge_trace(trace, sps, asis_targets)
    res['run'] = {'cleanup_sql': 'save_trace.json(restore_touched 키 없는 복원)', 'account': trace.get('account', ''), 'saved_at': trace.get('at', ''),
                  'tables': {**(trace.get('created') or {}), **(trace.get('changed') or {})}}
    return True


def selftest():
    tg = {'SP1': ({'T1'}, set()), 'SP2': ({'T1'}, {'T2'})}.get
    base = {'account': 'u', 'at': '2026-11-18 16:59:21', 'tables_scanned': ['T1', 'T2'], 'changed': {'T1': 2, 'T2': 1}, 'created': {}, 'audit': [{'result': 'PASS', 'why': 'ok'}]}
    cases = [('정상', judge_trace(base, ['SP1', 'SP2'], tg), ('PASS', 'PASS')),
             ('감사 FAIL', judge_trace({**base, 'audit': [{'result': 'FAIL', 'why': 'x'}]}, ['SP1'], tg), ('FAIL', 'PASS')),
             ('표 누락', judge_trace({**base, 'changed': {'T1': 1}}, ['SP2'], tg), ('PASS', 'FAIL')),
             ('미확인 표', judge_trace({**base, 'tables_scanned': ['T1']}, ['SP2'], tg), ('PASS', 'NOT_RUN')),
             ('감사 없음', judge_trace({**base, 'audit': []}, ['SP1'], tg), ('NOT_RUN', 'PASS')),
             ('SP 원문 없음', judge_trace(base, ['SPX'], tg), ('PASS', 'NOT_RUN'))]
    bad = 0
    for n, (f8, f7), want in cases:
        got = (f8['verdict'], f7['verdict']); ok = got == want; bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n} → {got}(기대 {want})")
    ka = [({'ROUTE_ID': '11172'}, 'jooyong026')]
    for n, got, want in [('키별 계정', row_account({'ROUTE_ID': '11172'}, ka, 'minyonglee1'), 'jooyong026'),
                         ('키 다름 → 기본', row_account({'ROUTE_ID': '9'}, ka, 'minyonglee1'), 'minyonglee1'),
                         ('키 줄 없음 → 기본', row_account({'ROUTE_ID': '11172'}, [], 'u'), 'u')]:
        ok = got == want; bad += 0 if ok else 1; cases.append(n)
        print(f"{'OK ' if ok else 'NG '} {n} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main():
    mid = sys.argv[1].upper()
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'save_audit.json')
    sqls = sorted(glob.glob(os.path.join(ROOT, 'Doc', 'verify', mid, 'cleanup', 'cleanup_*.sql')))
    res = {'menu_id': mid, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'F8': None, 'F7': None}
    if not sqls and from_trace(mid, res):
        json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(f"{mid}: (기존 행 수정 저장) F8 {res['F8']['verdict']} · F7 {res['F7']['verdict']} — {res['F8']['note'][:120]} | {res['F7']['note'][:200]} → {out}")
        return
    if not sqls:
        res['F8'] = res['F7'] = {'verdict': 'NOT_RUN', 'note': 'CRUD 실제 저장 정리 기록 없음(E2E 저장 미실행)'}
        json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(f"{mid}: 저장 정리 기록 없음 — F7/F8 NOT_RUN")
        return
    # 가장 최근 '백업 1건 이상' 정리 실행
    for sp in reversed(sqls):
        # 2026-11-25 T640: dry-run·ROLLBACK 정리 기록(COMMIT 줄 없음)도 백업 CSV 를 남긴다 — 실제로 지우지 않은 기록이라 판정 원천에서 뺀다
        if not re.search(r'(?im)^\s*commit\s*;', open(sp, encoding='utf-8', errors='ignore').read()):
            continue
        ts = os.path.basename(sp)[8:-4]
        backs = {os.path.basename(b)[len(ts) + 1:-4]: read_csv(b) for b in glob.glob(os.path.join(os.path.dirname(sp), f'{ts}_*.csv'))}
        if any(backs.values()):
            break
    # 2026-11-09 T176(SSP0025 F7 허위 FAIL): 백업 행이 있는 정리 기록이 하나도 없으면(수동 정리 파일·이름 규약 불일치·0행) 저장이 무엇을 기록했는지 모른다 —
    #   빈 백업을 '기록 테이블 없음' 으로 읽어 F7 FAIL 을 내던 것을 측정 없음(NOT_RUN)으로 돌린다
    if not any(backs.values()):
        res['F8'] = res['F7'] = {'verdict': 'NOT_RUN', 'note': f"정리 기록 {len(sqls)}건에 짝이 맞는 백업 행 없음(<시각>_<테이블>.csv) — 저장이 기록한 테이블 미확인"}
        json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(f"{mid}: 정리 백업 행 없음 — F7/F8 NOT_RUN")
        return
    head = open(sp, encoding='utf-8', errors='ignore').read()
    user = (re.search(r'계정 (\S+)', head) or [None, ''])[1]
    # 2026-11-25 T640(SCP0005 F8 9행 'jooyong026 ≠ 저장 계정 minyonglee1'): 권한 계정 시험(authcrud)이 저장한 행을 기본 계정으로 비교했다.
    #   ① 키별 계정 줄(cleanup_marker keyset '-- 저장 키 {…} · 계정 X') ② 손 정리 SQL 은 삭제 조건 CREATED_BY = 'X'(정리한 사람이 저장 계정으로 묶은 값) ③ 머리글 계정 ④ e2e.config 기본 계정 순
    key_acc = [(json.loads(k), a, datetime.datetime.strptime(ts, '%Y-%m-%d %H:%M:%S') if ts else None)
               for k, a, ts in re.findall(r'-- 저장 키 (\{[^\n]*?\}) · 계정 (\S+?)(?: · 저장 시각 (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d))?$', head, re.M)]
    acc_src = '정리 SQL 머리글' if user else ''
    if not user:
        cb = sorted(set(re.findall(r"(?i)\bCREATED_BY\s*=\s*'([^']+)'", head)))
        if len(cb) == 1:
            user, acc_src = cb[0], '정리 SQL 삭제 조건 CREATED_BY'
    if not user:  # 정리 SQL 머리글에 계정이 없으면 E2E 기본 계정 — 빈 값과 비교하면 정상 계정이 '불일치' 로 나온다(2026-11-02 SCP0028 허위 F8)
        try:
            user = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json'), encoding='utf-8-sig')).get('defaultAccount', '')
        except (OSError, ValueError):
            user = ''
        acc_src = 'e2e.config 기본 계정' if user else ''
    t0 = re.search(r"TO_DATE\('(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)'", head)
    t0 = datetime.datetime.strptime(t0.group(1), '%Y-%m-%d %H:%M:%S') if t0 else None
    spec = json.load(open(os.path.join(HERE, 'cleanup_spec.json'), encoding='utf-8')).get(mid, {})
    # T640: keyset 정의는 root 가 없다 — 첫 대상 표(대표 표)에 백업 행이 있으면 그 표를 루트로(연쇄 이력 표가 먼저 잡히지 않게)
    _t1 = (spec.get('tables') or [''])[0]
    root_t = (spec.get('root') or {}).get('table') or (_t1 if backs.get(_t1) else '') or next((t for t, v in backs.items() if v), '')
    root = backs.get(root_t) or []
    res['run'] = {'cleanup_sql': os.path.relpath(sp, ROOT), 'account': user, 'saved_at': t0.strftime('%Y-%m-%d %H:%M:%S') if t0 else '',
                  'tables': {t: len(v) for t, v in backs.items()}}
    # F8
    if not user:
        res['F8'] = {'verdict': 'NOT_RUN', 'note': '저장 계정을 알 수 없음(정리 SQL 머리글·e2e.config 모두 없음)'}
    elif not root:
        res['F8'] = {'verdict': 'NOT_RUN', 'note': f'루트 테이블 {root_t} 백업 행 없음'}
    elif not any(c in root[0] for c in AUDIT):
        res['F8'] = {'verdict': 'NA', 'note': f'{root_t} 에 감사 컬럼 없음'}
    else:
        bad = []
        for r in root:
            exp, rt0 = row_account(r, key_acc, user, t0 or False)
            rt0 = rt0 or None
            for c in ('CREATED_BY', 'LAST_UPDATED_BY'):
                if c in r and (r[c] or '').lower() != exp.lower():
                    bad.append(f"{c}='{r[c]}' ≠ 저장 계정 '{exp}'")
            for c in ('CREATION_DATE', 'LAST_UPDATE_DATE'):
                if c in r:
                    try:
                        v = datetime.datetime.strptime(r[c][:19], '%Y-%m-%d %H:%M:%S')
                        if rt0 and abs((v - rt0).total_seconds()) > 600:
                            bad.append(f"{c}={r[c]} ≠ 저장 시각 {rt0:%Y-%m-%d %H:%M}")
                    except ValueError:
                        bad.append(f"{c}='{r[c]}' 날짜 아님/공란")
        vals = ' · '.join(f"{c}={root[0].get(c, '')}" for c in AUDIT if c in root[0])
        res['F8'] = {'verdict': 'FAIL' if bad else 'PASS', 'note': ('; '.join(dict.fromkeys(bad)) if bad else f"감사 컬럼 = 저장 계정·저장 시각 ({vals})") + f" · {root_t} {len(root)}행"
                     + f" · 저장 계정 출처 {'키별 계정 줄 ' + str(len(key_acc)) + '건 · ' if key_acc else ''}{acc_src}"}
    # F7
    sys.path.insert(0, HERE); from asis_live import live_golden, asis_of
    asis = asis_of(mid, sys.argv[sys.argv.index('--asis') + 1] if '--asis' in sys.argv else '')
    save_sp = next((g['asis_sp'] for g in live_golden(mid, asis, 'SAVE')), '')  # 실행되지 않는 AS-IS 메서드의 저장 SP 제외(2026-10-30 SCP0041)
    tg = asis_targets(save_sp) if save_sp else None
    if not tg:
        res['F7'] = {'verdict': 'NA' if not save_sp else 'NOT_RUN', 'note': '저장 SP 없음' if not save_sp else f'AS-IS 저장 SP 원문 없음({save_sp})'}
    else:
        ins, upd_only = tg
        wrote = {t for t, v in backs.items() if v}
        miss = sorted(t for t in ins if t not in wrote)
        extra = sorted(t for t in wrote if t not in ins | upd_only)
        res['F7'] = {'verdict': 'FAIL' if miss else 'PASS', 'asis_sp': save_sp, 'asis_insert_tables': sorted(ins), 'asis_update_only': sorted(upd_only),
                     'tobe_written': sorted(wrote), 'tobe_extra': extra,
                     'note': (f"AS-IS {save_sp} 신규행 경로 기록 테이블 {', '.join(miss)} 에 TO-BE 저장이 행을 남기지 않음" if miss else
                              f"AS-IS 신규행 경로 테이블 {', '.join(sorted(ins))} 모두 기록")
                             + (f" · UPDATE 만(신규 1건 시험 대상 아님): {', '.join(sorted(upd_only))}" if upd_only else '')
                             + (f" · TO-BE 에만 기록(참고 — AS-IS 트리거·다른 경로 여부 확인): {', '.join(extra)}" if extra else '')}
    json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"{mid}: F8 {res['F8']['verdict']} · F7 {res['F7']['verdict']} — {res['F8']['note'][:120]} | {res['F7']['note'][:200]} → {out}")


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    main()
