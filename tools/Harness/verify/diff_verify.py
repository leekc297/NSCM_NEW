# -*- coding: utf-8 -*-
"""차등 검증(diff) — 화면이 실제로 보낸 call-proc 인자로 AS-IS SP(MSSQL) 와 TO-BE PROC(Oracle) 를 실행해 결과집합을 키 기반으로 비교한다(2026-11-06 플랜 2-4).
AS-IS 실행 결과가 1순위 정답(사용자 원칙 11-06): 공통행 값 불일치 = DIFF(FAIL) · 단독행(건수) 차이 = 판정필요 · 비교 불가 = SKIP(미검증, 사유 명시).

  python tools/Harness/verify/diff_verify.py <ID>          # → Doc/verify/<ID>/diff/<proc>__<n>.md|.csv · diff_summary.csv

입력
  Doc/verify/<ID>/calls/*.json   E2E 가 포착한 모든 non-SAVE call-proc [{menu,sheet,btn,url,postData,status,rows,dur,at,user,test}] (없으면 a1_live.json 의 calls[] 폴백)
  tools/Harness/rules/sp_pair.csv · param_map.csv (gen_param_map.py) · key_map.csv · norm_rules.csv · col_alias.csv
  Doc/tobefacts/db/proc_meta.csv (sheet,btn → proc) · tools/Harness/verify/cleanup_spec.json (키) · Doc/asisfacts/db/db_resultsets.csv (NOT NULL 키 후보)
  Doc/verify/<ID>/scenario_env.json .diff_replay {division, period_from, period_to, overrides{fe_key:value}} — 사용자 지정 조건(양쪽 같은 조건으로 치환)
판정(verdict): PASS(공통행≥1 · 불일치 셀 0) / DIFF(불일치 셀 ≥1) / ROWS_ONLY(공통행 0) / COLS(별칭 후 컬럼 집합 차이 — 값 비교는 공통 컬럼으로 계속, verdict 는 cols_* 열로 따로) /
              ERR(실행 오류) / SKIP(kind≠GET · 짝 없음 · UNRESOLVED 인자 — 사유에 인자명 전부)
안전: AS-IS 접속은 dbconn 'asis' readOnly(write 미지정) · kind=GET 만 실행 · TO-BE 는 매 호출 finally rollback · commit 호출 0건
"""
import csv, datetime, glob, hashlib, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, HERE); sys.path.insert(0, P('tools', 'DbConn'))
import dbconn, golden  # golden: run_asis/run_tobe/compare/KEYPROF/COLPROF/ORDERPROF (2026-11-06 main() 리팩터로 import 안전)
# ALL/'' 판독은 param_map.csv(gen_param_map.all_semantics) 값을 쓰고, 0행이면 'ALL'→'' · ''→'ALL' 순으로 재시도한다(a1_live.py:233 과 같은 방식)
RULES = P('tools', 'Harness', 'rules')
SUM_COLS = ['call_no', 'sheet', 'btn', 'asis_sp', 'tobe_proc', 'set', 'key_source', 'keys', 'asis_rows', 'tobe_rows', 'common', 'asis_only', 'tobe_only', 'cols_only_a', 'cols_only_t',
            'verdict', 'diff_cells', 'order', 'unresolved', 'params_asis', 'params_tobe', 'retry', 'note', 'md', 'measured_at']
csv.field_size_limit(10 ** 8)


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def nkey(c): return golden.nkey(c)


def load_calls(mid):
    """포착된 호출 → [{sheet, btn, body(dict), src}] · (sheet, btn, 정규화 body) 로 유일화 · SAVE 류 제외"""
    out, seen = [], set()
    files = sorted(glob.glob(P('Doc', 'verify', mid, 'calls', '*.json')))
    recs = []
    for f in files:
        try:
            with open(f, encoding='utf-8') as fh:
                j = json.load(fh)
            for x in (j if isinstance(j, list) else j.get('calls') or []):
                recs.append((x, os.path.relpath(f, ROOT)))
        except (OSError, ValueError):
            continue
    src_kind = 'calls'
    if not recs:
        a1 = P('Doc', 'verify', mid, 'a1_live.json')
        try:
            with open(a1, encoding='utf-8') as fh:
                for x in json.load(fh).get('calls') or []:
                    recs.append((x, os.path.relpath(a1, ROOT)))
            src_kind = 'a1_live(마지막 호출 1건 폴백 — calls/ 포착 전)'
        except (OSError, ValueError):
            pass
    for x, src in recs:
        sheet, btn = str(x.get('sheet') or ''), str(x.get('btn') or '')
        if re.search(r'SAVE|INS|UPD|DEL', btn, re.I):
            continue
        body = x.get('postData') if 'postData' in x else x.get('body')
        if isinstance(body, str):
            try:
                body = json.loads(body)
            except ValueError:
                body = None
        if not isinstance(body, dict):
            continue
        key = (sheet, btn, json.dumps(body, sort_keys=True, ensure_ascii=False))
        if key in seen:
            continue
        seen.add(key)
        out.append({'sheet': sheet, 'btn': btn, 'body': body, 'src': src, 'user': x.get('user', ''), 'rows_fe': x.get('rows', '')})
    return out, src_kind


def flat(v):
    """JSON 리스트/스칼라 → 문자열(리스트는 콤마 결합 · None → '')"""
    if v is None:
        return ''
    if isinstance(v, list):
        return ','.join(flat(x) for x in v)
    if isinstance(v, dict):
        return json.dumps(v, ensure_ascii=False)
    return str(v)


_BIND_CACHE = {}


def bind_map(cx, proc):
    """[(PROC_M COL_NM, PKG 인자명)] — BE 는 SCM_ADM_PROC_M 의 IN 행을 SORT_ORD 순서로 PKG 인자 위치에 묶는다. 수가 다르면 [](묶지 않음)"""
    k = proc.upper()
    if k not in _BIND_CACHE:
        cur = cx.cursor()
        cur.execute("SELECT COL_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE UPPER(PROC_NM) = :1 AND UPPER(COL_TP_CD) IN ('IN', 'I') ORDER BY SORT_ORD", [k])
        cols = [r[0] for r in cur.fetchall()]
        pkg, _, name = k.rpartition('.')
        cur.execute("""SELECT ARGUMENT_NAME FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = :n AND NVL(PACKAGE_NAME, '~') = NVL(:p, '~')
                         AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL AND IN_OUT = 'IN' ORDER BY POSITION""", n=name, p=(pkg or None))
        args = [r[0] for r in cur.fetchall()]
        _BIND_CACHE[k] = list(zip(cols, args)) if cols and len(cols) == len(args) else []
    return _BIND_CACHE[k]


def bind_like_be(cx, proc, body, md=None):
    """본문(FE 키 + 세션 키)을 PKG 인자명 키로도 채운 사본 — 인자명과 COL_NM 이 다른 자리(예 sesLangCd ↔ P_LANGUAGE)가 NULL 로 가지 않게"""
    out = dict(body)
    lk = {golden.nkey(k): k for k in body}
    renamed = []
    for col, arg in bind_map(cx, proc):
        a = re.sub(r'^P_', '', arg)
        src = lk.get(golden.nkey(col))
        if src is None or golden.nkey(a) in lk or golden.nkey(arg) in lk:
            continue
        out[a] = body[src]
        renamed.append(f'{col}→{arg}')
    if renamed and md is not None:
        md.append(f"- TO-BE 인자 묶음(PROC_M 순서 = BE 방식): {', '.join(renamed)}")
    return out


def load_sqllog(mid):
    try:
        with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'sqllog_calls.json'), encoding='utf-8') as f:
            return [c for c in json.load(f).get('calls', []) if c.get('params_parsed')]
    except (OSError, ValueError):
        return []


def session_of(calls, proc, body):
    """같은 PROC·같은 FE 본문의 로그 호출들에서 세션 값 — 가장 많이 나온 조합(동률이면 최근). 반환 (ses dict, 설명)"""
    want = {k: flat(v) for k, v in (body or {}).items()}
    seen = {}
    for c in calls:
        if (c.get('proc') or '').upper() != (proc or '').upper():
            continue
        got = {k: flat(v) for k, v in (c.get('fe') or {}).items()}
        if any(got.get(k, '') != v for k, v in want.items()):
            continue
        key = json.dumps(c.get('ses') or {}, ensure_ascii=False, sort_keys=True)
        seen[key] = (seen.get(key, (0, 0))[0] + 1, c.get('seq') or 0)
    if not seen:
        return {}, ''
    best = max(seen.items(), key=lambda kv: kv[1])
    note = '' if len(seen) == 1 else f" · 같은 본문의 세션 조합 {len(seen)}종 중 최다({best[1][0]}회) 사용 — 나머지 {[json.loads(k) for k in seen if k != best[0]][:3]}"
    return json.loads(best[0]), note


def translate(body, pmap_rows):
    """FE body(camelCase) → AS-IS {@p_x: 값} · (params, unresolved[], notes[])"""
    ps, unresolved, notes = {}, [], []
    bk = {nkey(k): v for k, v in body.items()}
    for m in pmap_rows:
        st = m.get('status') or ''
        an = (m.get('asis_param') or '').lstrip('@')
        if st.startswith('MANUAL'):
            st = 'OK'
        if st == 'OK':
            fk = m.get('fe_key') or ''
            raw = body.get(fk, bk.get(nkey(fk)))
            v = flat(raw)
            if (m.get('list_format') == 'csv') and isinstance(raw, list):
                v = ','.join(flat(x) for x in raw)
            sem = m.get('all_semantics') or ''
            # 2026-11-07 T136(SCP0037 diff 14건 AS-IS 0행): all_semantics '' 는 "빈 값 = 전체" 라는 값이다(NONE/AMBIG 는 note 로 구분) — 종전엔 '' 를 미판독으로 봐 'ALL' 을 그대로 보내 AS-IS `IN ('ALL')` 0행
            semnote = (m.get('note') or '')
            sem_known = not (semnote.startswith('NONE') or semnote.startswith('AMBIG'))
            if v in ('ALL', '') and sem != '' and v != sem:
                notes.append(f"{an}: '{v}'→'{sem}'(all_semantics)"); v = sem
            elif v == 'ALL' and sem == '' and sem_known:
                notes.append(f"{an}: 'ALL'→''(all_semantics: 빈 값 = 전체)"); v = ''
            elif v == 'ALL' and sem == '' and semnote.startswith('AMBIG'):
                notes.append(f"{an}: 'ALL' 유지(AMBIG)")
            if raw is None and fk and re.match(r'ses[A-Z]', fk) and (m.get('default') or '') != '':
                v = m.get('default')  # 호출 로그에 세션 값이 없을 때만 — 종전 동작(설정된 기본 계정) 유지 · 기본값이 없는 세션 인자(언어 등)는 아래에서 미해결
                notes.append(f"{an}: 세션 인자 {fk} 값 미포착 → default '{v}'(호출 로그 없음)")
            elif raw is None and fk and re.match(r'ses[A-Z]', fk):
                unresolved.append(f"{an}(세션 인자 {fk} 값 없음 — sqllog_calls.py 로 호출 로그 수집)")  # 세션 값은 기본값으로 채우지 않는다
            elif raw is None and fk:
                v = m.get('default') or ''
                notes.append(f"{an}: 본문에 {fk} 없음 → default '{v}'")
            ps[an] = v
        elif st == 'ASIS_ONLY':
            d = m.get('default') or ''
            if d == '':
                unresolved.append(an)
            ps[an] = d
        elif st == 'UNRESOLVED':
            if an:
                unresolved.append(an)
            else:
                unresolved.append(f"fe:{m.get('fe_key')}")
        # TOBE_ONLY: AS-IS 에 없음 — 전달 안 함
    return ps, unresolved, notes


def key_candidates(mid, sp, tobe_proc, a_sets, t_sets, cleanup):
    """키 우선순위 ① key_map.csv ② cleanup_spec keys ③ 결과 컬럼 PRE_KEY_VALUES|KEY_VALUES ④ db_resultsets is_nullable=0(감사 컬럼 제외) ⑤ None(자동)
    반환 ({set_no: [nkey…]}, source)"""
    km = [k for k in rd(os.path.join(RULES, 'key_map.csv')) if (k.get('proc') or '').upper() in (tobe_proc.upper(), sp.upper())]
    if km:
        return {int(k.get('set') or 1): [nkey(x) for x in (k.get('key_cols') or '').replace(';', ',').split(',') if x.strip()] for k in km}, 'key_map.csv'
    cols1 = [nkey(c) for c in (a_sets[0][0] if a_sets else [])]
    ks = (cleanup or {}).get('keys') or []
    if ks and all(nkey(k) in cols1 for k in ks):
        return {1: [nkey(k) for k in ks]}, 'cleanup_spec.json'
    for kc in ('PRE_KEY_VALUES', 'KEY_VALUES', 'KEY_IDX'):  # KEY_IDX: SCP0016 워터폴 AS-IS 결과 첫 컬럼(2026-11-06 실측)
        if nkey(kc) in cols1:
            return {1: [nkey(kc)]}, f'결과 컬럼 {kc}'
    nn = [r['name'] for r in rd(P('Doc', 'asisfacts', 'db', 'db_resultsets.csv')) if (r.get('module') or '').upper().endswith(sp.upper()) and r.get('is_nullable') == '0'
          and not re.search(r'CREAT|UPDATE|_BY$|_DATE$|DATE$', (r.get('name') or '').upper())]
    nn = [nkey(x) for x in nn if nkey(x) in cols1]
    if nn:
        return {1: nn}, 'db_resultsets.csv is_nullable=0'
    return None, 'auto(golden 복합 키)'


def load_norm():
    out = {}
    for r in rd(os.path.join(RULES, 'norm_rules.csv')):
        pat = r.get('col_pattern') or ''
        if pat:
            out[pat] = r
    return out


def load_alias():
    out = []
    for r in rd(os.path.join(RULES, 'col_alias.csv')):
        if (r.get('enabled') or 'Y').upper() == 'N' or '미확인' in (r.get('source') or ''):
            continue
        if r.get('pattern'):
            out.append((r['pattern'], (r.get('canon') or '').replace('\\1', r'\1').replace('\\2', r'\2')))
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__); return 2
    mid = args[0].upper()
    vd = P('Doc', 'verify', mid); od = os.path.join(vd, 'diff'); os.makedirs(od, exist_ok=True)
    for f in glob.glob(os.path.join(od, '*')):
        try: os.remove(f)
        except OSError: pass
    calls, src_kind = load_calls(mid)
    pm_rows = rd(P('Doc', 'tobefacts', 'db', 'proc_meta.csv'))
    proc_of = {}
    for r in pm_rows:
        if (r.get('menu_id') or '').upper() == mid and r.get('proc') and (r.get('use_yn') or 'Y') != 'N':
            proc_of[(r.get('sheet') or '', (r.get('btn') or '').upper())] = r['proc']
    pairs = {p['tobe_proc'].upper(): p for p in rd(os.path.join(RULES, 'sp_pair.csv')) if (p.get('menu_id') or '').upper() == mid and p.get('tobe_proc')}
    pmap = {}
    for m in rd(os.path.join(RULES, 'param_map.csv')):
        pmap.setdefault((m.get('tobe_proc') or '').upper(), []).append(m)
    try:
        cleanup = json.load(open(P('tools', 'Harness', 'verify', 'cleanup_spec.json'), encoding='utf-8')).get(mid) or {}
    except (OSError, ValueError):
        cleanup = {}
    replay = {}
    try:
        replay = json.load(open(os.path.join(vd, 'scenario_env.json'), encoding='utf-8')).get('diff_replay') or {}
    except (OSError, ValueError):
        replay = {}
    try:  # 사용자 지정 조건 정본 = Doc/verify/<ID>/diff_replay.json (scenario_env.json 은 체인이 매번 재생성하므로 분리 · 2026-11-06 SCP0016 버전 SP_W_20260615 = 양쪽 건수 동일)
        _rp = os.path.join(vd, 'diff_replay.json')
        if os.path.exists(_rp):
            replay = {**replay, **(json.load(open(_rp, encoding='utf-8')) or {})}
    except (OSError, ValueError):
        pass
    norm = load_norm(); alias = load_alias()
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    summary = []
    if not calls:
        summary.append({'call_no': 0, 'verdict': 'SKIP', 'note': f'포착된 call-proc 없음(Doc/verify/{mid}/calls/*.json · a1_live.json) — E2E 실행 뒤 다시', 'measured_at': now})
    ca = ct = None
    cfg = dbconn.load_cfg()
    if calls:
        ca = dbconn.connect('asis', cfg)  # readOnly(write 미지정) — 쓰기 시도 자체가 거부된다
        ct = dbconn.connect('tobe', cfg)
    sqllog = load_sqllog(mid)
    hdr = f"- 실행 {now} · AS-IS {dbconn.describe('asis', cfg)} (readOnly) · TO-BE {dbconn.describe('tobe', cfg)} (매 호출 rollback) · 호출 원천 {src_kind}"
    try:
        for n, c in enumerate(calls, 1):
            body = dict(c['body'])
            for k, v in (replay.get('overrides') or {}).items():
                body[k] = v
            if replay.get('division'):
                for k in list(body):
                    if nkey(k) in ('divisionid', 'division', 'div'):
                        body[k] = replay['division']
            if replay.get('period_from') or replay.get('period_to'):
                for k in list(body):
                    if replay.get('period_from') and re.search(r'(from|start)(yyyymmdd|date|ymd)?$', nkey(k)): body[k] = replay['period_from']
                    if replay.get('period_to') and re.search(r'(to|end)(yyyymmdd|date|ymd)?$', nkey(k)): body[k] = replay['period_to']
            # 시트→proc: PROC_M 에 있는 시트만. 'main' 폴백은 시트가 비었을 때만(공용 팝업 시트 projectByDivision/materialByDivision 호출을 메인 GET 으로 오매핑 → 0행↔0행 ROWS_ONLY 9행 · 2026-11-06 SCP0016 실측)
            proc = proc_of.get((c['sheet'], c['btn'].upper())) or (proc_of.get(('main', c['btn'].upper())) if c['sheet'] in ('', 'main') else '') or ''
            if not proc and c['sheet'] not in {s for s, _ in proc_of}:
                print(f"[SKIP-POPUP] #{n} {c['sheet']}/{c['btn']} — 이 화면 PROC_M 에 없는 시트(공용 팝업 호출 · M3 팝업 규칙 소관) → 차등 비교 대상 아님"); continue
            pair = pairs.get(proc.upper()) if proc else None
            sp = (pair or {}).get('asis_sp', '')
            short = re.sub(r'^PKG_\w+\.', '', proc) or f"{c['sheet']}_{c['btn']}"
            md = [f"# {mid} · {sp or '(AS-IS 짝 없음)'} ↔ {proc or '(PROC_M 배선 없음)'}", '', hdr, f"- 호출 #{n} sheet={c['sheet']} btn={c['btn']} user={c.get('user', '')} FE 응답 행 {c.get('rows_fe', '')} · 원천 {c['src']}",
                  f"- TO-BE 인자(FE 본문): `{json.dumps(body, ensure_ascii=False)[:1500]}`"]
            row = {'call_no': n, 'sheet': c['sheet'], 'btn': c['btn'], 'asis_sp': sp, 'tobe_proc': proc, 'set': 1, 'params_tobe': json.dumps(body, ensure_ascii=False)[:800], 'measured_at': now, 'md': ''}
            if not proc:
                row.update(verdict='SKIP', note=f"PROC_M 배선 없음(proc_meta sheet={c['sheet']} btn={c['btn']})"); md.append(f"- SKIP: {row['note']}")
            elif not pair:
                row.update(verdict='SKIP', note='sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가'); md.append(f"- SKIP: {row['note']}")
            elif (pair.get('kind') or '') != 'GET':
                row.update(verdict='SKIP', note=f"kind={pair.get('kind')} — GET 만 실행(쓰기 SP 실행 금지) · {pair.get('note', '')[:120]}"); md.append(f"- SKIP: {row['note']}")
            else:
                # 2026-11-11 T235: 세션 인자(sesLangCd 등)는 FE 본문에 없다(BE 가 붙임) → 사내 호출 로그의 같은 PROC·같은 본문 호출에서 읽어 양쪽에 같은 값을 준다
                #   실측(SSP0025 11-10 E2E 시간대): 같은 본문이 sesLangCd EN 9회·CN 6회 — 'KO' 로 가정했다면 틀렸다. 로그에 없으면 세션 인자는 미해결로 남긴다.
                ses, ses_note = session_of(sqllog, proc, body)
                if ses:
                    body = dict(body, **ses); md.append(f"- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{json.dumps(ses, ensure_ascii=False)}`{ses_note}")
                aps, unresolved, notes = translate(body, pmap.get(proc.upper(), []))
                bad_in = [k for k, v in body.items() if isinstance(v, str) and v in ('Invalid Date', 'NaN', 'undefined')]
                if bad_in:  # 2026-11-11 T239: E2E 가 잘못된 입력 상태에서 포착한 호출(FE 가 'Invalid Date' 전송) — 정상 조회가 아니라 대조 대상 아님(AS-IS 는 날짜 변환 오류)
                    unresolved = [f"{k}='{body[k]}'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님)" for k in bad_in]
                row['params_asis'] = json.dumps(aps, ensure_ascii=False)[:800]; row['unresolved'] = ','.join(unresolved)
                md.append(f"- AS-IS 인자(번역): `{json.dumps(aps, ensure_ascii=False)[:1500]}`" + (f" · 번역 메모: {' · '.join(notes)[:600]}" if notes else ''))
                if unresolved:
                    row.update(verdict='SKIP', note='인자 미해결(UNRESOLVED): ' + ','.join(unresolved) + ' — param_map.csv 에 값/대응 지정'); md.append(f"- SKIP: {row['note']}")
                else:
                    try:
                        a_sets = golden.run_asis(ca, sp, aps); retry = ''
                        # 2026-11-07 T136: 재시도 조건 = 첫 결과셋(본 조회) 0행 — 종전 '전체 결과셋 합 0' 은 보조 셋(SCP0037 RC2 3,016행 코드 목록)이 있으면 본 조회 0행을 재시도하지 않았다
                        if a_sets and len(a_sets[0][1]) == 0:  # a1_live.py:233 과 같은 재시도 — 'ALL'→'' 만, 그래도 0행이면 ''→'ALL' 만(동시에 바꾸면 빈 값 인자가 깨진다)
                            for label, alt in (("'ALL'→''", {k: ('' if v == 'ALL' else v) for k, v in aps.items()}), ("''→'ALL'", {k: ('ALL' if v == '' else v) for k, v in aps.items()})):
                                if alt == aps:
                                    continue
                                a2 = golden.run_asis(ca, sp, alt)
                                md.append(f"- 재시도 {label}: AS-IS {sum(len(s[1]) for s in a2)}행 ← `{json.dumps(alt, ensure_ascii=False)[:500]}`")
                                if a2 and len(a2[0][1]) > 0:
                                    a_sets, aps, retry = a2, alt, f"0행 → {label} 재실행"
                                    break
                        row['retry'] = retry
                        try:
                            t_sets, missing = golden.run_tobe(ct, proc, bind_like_be(ct, proc, body, md))
                            if missing: md.append(f"- TO-BE 인자 중 값 없음(NULL 전달): {', '.join(missing)}")
                        finally:
                            ct.rollback()
                        keys, ksrc = key_candidates(mid, sp, proc, a_sets, t_sets, cleanup)
                        rs_map = None
                        if (pair.get('rs_map') or 'ordinal') != 'ordinal':
                            rs_map = {int(x.split(':')[0]): x.split(':')[1] for x in pair['rs_map'].split(';') if ':' in x}
                        golden.COLPROF.clear(); golden.ORDERPROF.clear(); golden.KEYPROF.clear()
                        gv, lines = golden.compare(a_sets, t_sets, keys=keys, norm=norm, alias=alias, rs_map=rs_map)
                        md += lines
                        kp = golden.KEYPROF[0] if golden.KEYPROF else {}
                        op = golden.ORDERPROF[0] if golden.ORDERPROF else {}
                        t_data = [s for s in t_sets if not re.search(r'RESULT_CURSOR$', s[0])]
                        a1c = {nkey(x) for x in (a_sets[0][0] if a_sets else [])}; t1c = {nkey(x) for x in (t_data[0][1] if t_data else [])}
                        if alias:
                            a_n, t_n = golden._apply_norm(a_sets[0], t_data[0], alias, None) if a_sets and t_data else ((None,), (None,))
                            if a_n and a_n[0] is not None: a1c = {nkey(x) for x in a_n[0]}; t1c = {nkey(x) for x in t_n[1]}
                        row.update(key_source=ksrc if keys else kp.get('key_source', 'auto'), keys=kp.get('keys', ''), asis_rows=kp.get('asis_rows', ''), tobe_rows=kp.get('tobe_rows', ''),
                                   common=kp.get('key_rows', ''), asis_only=kp.get('asis_only_keys', ''), tobe_only=kp.get('tobe_only_keys', ''),
                                   cols_only_a=','.join(sorted(a1c - t1c))[:200], cols_only_t=','.join(sorted(t1c - a1c))[:200], diff_cells=kp.get('diff_cells', ''), order=op.get('order', ''))
                        kr = kp.get('key_rows') or 0
                        # 2026-11-11 T234: 키를 못 정해도 전 결과셋의 행 집합(중복 수 포함)이 완전히 같으면 대조는 이미 끝난 것 — SKIP 이 아니라 PASS
                        #   실측: SCP0108 P_SCP0108_GET_CAPA_LOB_CURRENT 378행 ↔ 378행 '공통 378 · 한쪽 전용 0' 인데 키 후보 없음으로 SKIP 19건
                        ops = list(golden.ORDERPROF)
                        set_equal = bool(ops) and all(o.get('asis_rows', 0) > 0 and o.get('asis_rows') == o.get('tobe_rows') == o.get('common_rows') and not o.get('capped') for o in ops)
                        if not kp.get('keys') and set_equal:
                            v = 'PASS'; row['note'] = '키 없이 판정 — 전 결과셋 행 집합 완전 일치(' + ' · '.join(f"셋{o.get('set')} {o.get('asis_rows')}행" for o in ops) + ' · 한쪽 전용 0)'
                            row.update(common=ops[0].get('common_rows', ''), asis_rows=ops[0].get('asis_rows', ''), tobe_rows=ops[0].get('tobe_rows', ''), asis_only=0, tobe_only=0, key_source='(행 집합)')
                        elif not kp.get('keys') and ops:
                            # 2026-11-11 CR-101: 양쪽 모두 조회는 됐다 — 키가 없어 셀 단위 대조는 못 하지만 행 집합 대조 수치는 실측값이다 → 미검증(SKIP)이 아니라 판정필요(ROWS_ONLY)
                            v = 'ROWS_ONLY'; row['note'] = ('키 없이 행 집합 대조 — ' + ' · '.join(f"셋{o.get('set')} AS-IS {o.get('asis_rows')}행/TO-BE {o.get('tobe_rows')}행(공통 {o.get('common_rows')} · AS-IS 전용 {o.get('asis_only')} · TO-BE 전용 {o.get('tobe_only')})" for o in ops[:4])
                                                            + ' · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요')
                            row.update(common=ops[0].get('common_rows', ''), asis_rows=ops[0].get('asis_rows', ''), tobe_rows=ops[0].get('tobe_rows', ''), asis_only=ops[0].get('asis_only', ''), tobe_only=ops[0].get('tobe_only', ''), key_source='(행 집합)')
                        elif not kp.get('keys'):
                            v = 'SKIP'; row['note'] = '행을 잇는 키를 정하지 못함(키 후보 없음) — key_map.csv 에 proc·key_cols 지정'
                        elif kr == 0:
                            v = 'ROWS_ONLY'; row['note'] = f"공통행 0(키 {kp.get('keys')}) — AS-IS {kp.get('asis_rows')}행 ↔ TO-BE {kp.get('tobe_rows')}행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요"
                        elif kp.get('diff_cells', 0) > 0:
                            v = 'DIFF'; row['note'] = f"공통 {kr}행 중 불일치 셀 {kp['diff_cells']} — diff/{short}__{n}.csv"
                        else:
                            v = 'PASS'; row['note'] = f"공통 {kr}행 전 컬럼 일치" + (f" · 단독행 AS-IS {kp.get('asis_only_keys')} / TO-BE {kp.get('tobe_only_keys')}" if (kp.get('asis_only_keys') or kp.get('tobe_only_keys')) else '')
                        if (a1c - t1c) or (t1c - a1c):
                            row['note'] += f" · 컬럼 집합 차이 AS-IS 전용 {sorted(a1c - t1c)[:5]} / TO-BE 전용 {sorted(t1c - a1c)[:5]}"
                        row['verdict'] = v
                        md.insert(3, f"- **판정 {v}** — {row['note']} · 키 원천 {row['key_source']} · 키 {row['keys']} · golden 집합 판정 {gv}")
                        if kp.get('examples'):
                            with open(os.path.join(od, f'{short}__{n}.csv'), 'w', encoding='utf-8-sig', newline='') as f:
                                w = csv.DictWriter(f, fieldnames=['key', 'column', 'asis', 'tobe']); w.writeheader(); w.writerows(kp['examples'])
                            md.append(f"\n## 불일치 셀(≤50) — diff/{short}__{n}.csv"); md.append('| 키 | 컬럼 | AS-IS | TO-BE |'); md.append('|---|---|---|---|')
                            for e in kp['examples'][:50]: md.append(f"| {e['key']} | {e['column']} | {e['asis']} | {e['tobe']} |")
                    except Exception as ex:
                        em = dbconn.mask(str(ex), cfg).splitlines()[0][:300]
                        # 2026-11-11 CR-101(사용자 결정): TO-BE 조회 자체가 실패한 것만 오류로 도출 — Oracle 오류(ORA-·PLS-)면 ERR_TOBE(FAIL), 그 밖(AS-IS·도구 쪽)은 ERR(미검증)
                        tb = bool(re.search(r'ORA-\d{5}|PLS-\d{5}|ALL_ARGUMENTS 에 ', em))
                        row.update(verdict='ERR_TOBE' if tb else 'ERR', note=('TO-BE 조회 실패 — ' if tb else '') + em); md.append(f"- {row['verdict']}: {row['note']}")
            mp = os.path.join(od, f'{short}__{n}.md')
            with open(mp, 'w', encoding='utf-8') as f: f.write('\n'.join(md) + '\n')
            row['md'] = os.path.relpath(mp, ROOT)
            summary.append(row)
            print(f"[{row['verdict']}] #{n} {c['sheet']}/{c['btn']} {sp or '-'} ↔ {proc or '-'} · {row.get('note', '')[:140]}")
    finally:
        for cx in (ca, ct):
            try:
                if cx is not None: cx.rollback(); cx.close()
            except Exception:
                pass
    sp_ = os.path.join(od, 'diff_summary.csv')
    with open(sp_, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=SUM_COLS); w.writeheader(); w.writerows([{k: r.get(k, '') for k in SUM_COLS} for r in summary])
    cnt = {}
    for r in summary: cnt[r['verdict']] = cnt.get(r['verdict'], 0) + 1
    print(f"[diff_verify] {mid}: 호출 {len(calls)}건({src_kind}) → " + ' · '.join(f'{k} {v}' for k, v in sorted(cnt.items())) + f" → {os.path.relpath(sp_, ROOT)}")
    # 골든 요약 반영(2026-11-07): mapping_trace 의 A1(TRACE SP 요소)은 Doc/golden/<ID>/_summary.csv 만 읽어 diff 가 PASS 여도 'golden SKIP' REVIEW 로 남았다(SCP0016 A1 판정필요 32행)
    #   → 같은 케이스 ID(screen:asis_sp) 로 화면 골든 요약을 갱신(only_case · 다른 케이스 행 보존 · 공용 색인은 golden.write_summary 의 잠금). SP 하나에 호출이 여럿이면 PASS > DIFF > ROWS_ONLY > COLS > ERR 순·공통행 많은 쪽
    try:
        rank = {'PASS': 0, 'DIFF': 1, 'ROWS_ONLY': 2, 'COLS': 3, 'ERR': 4, 'SKIP': 5}
        best = {}
        for r in summary:
            k = r.get('asis_sp') or ''
            if not k or not r.get('tobe_proc'): continue
            key = (rank.get(r.get('verdict'), 9), -int(r.get('common') or 0))
            if k not in best or key < best[k][0]: best[k] = (key, r)
        grows = []
        for k, (_, r) in best.items():
            gv = {'PASS': 'PASS', 'DIFF': 'DIFF', 'ROWS_ONLY': 'DIFF', 'COLS': 'COLS', 'ERR': 'ERR'}.get(r.get('verdict'), 'SKIP')
            grows.append({'screen': mid, 'case_id': f'{mid}:{k}', 'kind': 'GET', 'asis_sp': k, 'tobe_proc': r.get('tobe_proc', ''), 'verdict': gv, 'asis_rows': r.get('asis_rows', ''), 'tobe_rows': r.get('tobe_rows', ''),
                          'common_rows': r.get('common', ''), 'asis_only': r.get('asis_only', ''), 'tobe_only': r.get('tobe_only', ''), 'order': r.get('order', '')})
        if grows:
            golden.write_summary(grows, only_case=True)
            print(f"[diff_verify] 골든 요약 갱신 {len(grows)}건(case_id=screen:asis_sp · only_case) → Doc/golden/{mid}/_summary.csv")
    except Exception as ex:
        print(f'[diff_verify] 골든 요약 갱신 실패(무시 · TRACE A1 은 종전 골든 행 사용): {ex}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
