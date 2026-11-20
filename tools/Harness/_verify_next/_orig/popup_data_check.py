"""M3 팝업 데이터 조회 정적+DB 검사 — AS-IS 개인화(TitleSet) 팝업 목록 ↔ TO-BE 메타 조회를 '화면이 보낼 수 있는 Division 값'마다 실행 (2026-10-30)

사용자 지적(10-30, SCP0100): Measure 팝업에 데이터가 조회되지 않는데 CheckList 에 목록이 도출되지 않았다.
  원인(검사기): ① M3(팝업 내부 조회)는 _trace.spec W4b 가 '그리드 셀 더블클릭으로 여는 팝업'(PCOL trigger)만 열었다 —
  SubTitle 버튼(btnMeasure·btnColumn)으로 여는 팝업은 어떤 검사도 열지 않았다(T8 측정 경로 편중).
  ② AS-IS POPUP 문장에는 G5(인자)·H6(표준)만 원장 행이 생기고 M3 행이 없었다 → 조회 0건이 들어갈 자리가 없었다.
  ③ G5 popup_args_check 는 AS-IS 인자가 전부 리터럴("SCP0100", "Global PSI New", false)이면 짝을 못 지어 NA(W7)로 지나갔다.
  원인(화면): TO-BE 는 AS-IS 팝업에 없던 Division 을 메타 조회 인자로 보내고, 단일 Division 이면 PKG 가 DIVISION_ID NULL 공통
  measure 를 걸러 0건 → AS-IS 는 Division 과 무관하게 같은 목록.

판정 단위 = TO-BE 화면 코드의 개인화 메타 조회 호출(`/admin/menu/${..}/(measure|column)`) × 시트
  AS-IS 짝 = 같은 화면의 개인화 팝업 호출 중 같은 종류(isColumn true=column · false=measure) — 시트 리터럴이 같으면 그 호출, 아니면 같은 종류 전부
  DB 실행 = BE 가 실제로 부르는 PROC(Controller 경로 → ServiceImpl selectList id → MyBatis CALL 원문, 화면 고유값 없음)을
            divisionId '' (FE 의 ALL·다중 선택 정규화 값) + 화면 Division 콤보 후보 각각으로 실행 → 행수. 실행 후 ROLLBACK
            (PROC 가 개인화 기본행을 INSERT 할 수 있어 커밋 금지 · PROC 원문에 COMMIT 이 있으면 실행하지 않고 ERROR)
  FAIL   : '' 에서 N>0 인데 단일 Division d 에서 0건이고 AS-IS 팝업이 Division 인자를 받지 않음(= AS-IS 는 Division 과 무관한 같은 목록)
           · '' 에서도 0건인데 AS-IS 메타(dbmeta 덤프)에 그 시트 행이 있음
  PASS   : 모든 Division 값에서 N>0 (AS-IS 가 Division 인자를 받는 팝업은 '' 기준 N>0 이면 PASS, 0건 Division 은 증거에만)
  ERROR  : BE PROC 해석 불가 · DB 실행 실패 · Division 후보를 못 구함 · 0건인데 AS-IS 근거 없음([근거 불충분]) — FAIL 로 적지 않는다
  NA     : AS-IS 에 같은 종류의 개인화 팝업이 없음(팝업 목록 원천이 아닌 메타 조회)

추출 한계(명시)
  - TO-BE 호출 = 화면 페이지 폴더 .ts/.tsx 의 apiClient 호출 문자열 경로만. 공용 모달(ColumnLayoutModal) 내부의 titleSet
    엔드포인트 조회는 보지 않는다(그 경로의 0건은 E2E 몫). divisionId 가 변수면 '단일 Division 을 보낼 수 있음'으로 본다.
  - 시트 = 문자열 리터럴 · 같은 폴더의 `export const X = '…'` · `X[key]` 레코드 상수의 값 전부.
  - Division 후보 = Doc/verify/<ID>/combo_runtime.json(E2E 실측 콤보 응답 comboId~Division) → 없으면 e2e.config defaultDivision.
  - 계정 = e2e.config forceAccount/defaultAccount (개인화 분기는 계정의 TitleSet 보유 여부에 따라 다르다 — 그 계정 기준).

  python popup_data_check.py <MENU_ID> [--asis <AS-IS ID>]   → Doc/verify/<ID>/popup_data.csv
"""
import csv, json, os, re, sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, HERE)
sys.path.insert(0, P('tools', 'DbConn'))
from popup_args_check import asis_popups, page_dir, fe_sources, balanced, split_top, classify, concept, read_csv, popup_params, _POP_IDX  # noqa: E402

FIELDS = ['menu_id', 'kind', 'asis_ref', 'asis_popup', 'asis_sheet', 'asis_div_param', 'tobe_ref', 'endpoint', 'proc', 'sheet',
          'division_expr', 'base_rows', 'div_rows', 'zero_divisions', 'verdict', 'note']
E2E_CFG = P('tools', 'E2E', 'e2e.config.json')


def titleset_popup(pcls):
    """AS-IS 팝업 원문이 개인화(TITLESET) 목록을 조회하는 팝업인가 — 원문의 FoxDataRequest 이름으로 판별(화면 무관)"""
    popup_params(pcls, '(생성자)', 0)  # _POP_IDX 구축
    fp = _POP_IDX.get(pcls)
    if not fp:
        return False
    try:
        src = open(fp, encoding='utf-8-sig', errors='replace').read()
    except OSError:
        return False
    return bool(re.search(r'FoxDataRequest\(\s*"[^"]*GET_TITLESET', src, re.I))


def asis_titleset_calls(aid):
    out = []
    for pc in asis_popups(aid):
        if pc['how'] != '(생성자)' or not titleset_popup(pc['popup']):
            continue
        it = {i['param']: i for i in pc['items']}
        col = next((i for i in pc['items'] if concept(i['param']) == 'iscolumn'), None)
        if not col or col['kind'] != 'LITERAL' or col['arg'] not in ('true', 'false'):
            kind = ''  # 종류 미확정 — 양쪽 모두와 짝
        else:
            kind = 'column' if col['arg'] == 'true' else 'measure'
        sh = next((i for i in pc['items'] if concept(i['param']) == 'sheetname'), None)
        sheet = sh['source'].strip().strip('"') if sh and sh['kind'] == 'LITERAL' and sh['source'].strip().startswith('"') else ''
        out.append({'ref': f"{pc['file']}:{pc['line']} {pc['cls']}.{pc['method']}", 'popup': pc['popup'], 'kind': kind, 'sheet': sheet,
                    'div_param': any(concept(p) == 'division' for p in it)})
    return out


def const_values(srcs, name):
    """`export const NAME = '…'` → [값] · `export const NAME: Record<…> = { k: '…', … }` → [값…]"""
    for src in srcs.values():
        m = re.search(r'\bconst\s+' + re.escape(name) + r'\b[^=]*=\s*', src)
        if not m:
            continue
        rest = src[m.end():]
        sm = re.match(r"\s*(['\"`])([^'\"`]*)\1", rest)
        if sm:
            return [sm.group(2)]
        if rest.lstrip().startswith('{'):
            st = m.end() + (len(rest) - len(rest.lstrip()))
            en = balanced(src, st)
            body = src[st + 1:en - 1] if en > 0 else ''
            return [v for v in re.findall(r":\s*(['\"`])([^'\"`]*)\1", body) for v in [v[1]]]
    return []


def tobe_meta_calls(srcs, rel):
    out = []
    rx = re.compile(r"\.(?:post|get)\s*(?:<[^>]*>)?\s*\(\s*`/admin/menu/\$\{[^}]+\}/(measure|column)`\s*,\s*")
    for f, src in srcs.items():
        for m in rx.finditer(src):
            st = m.end()
            if src[st:st + 1] != '{':
                out.append({'file': f, 'rel': rel(f), 'line': src.count('\n', 0, m.start()) + 1, 'kind': m.group(1), 'sheets': [], 'div': '', 'error': '요청 본문이 객체 리터럴이 아님'}); continue
            en = balanced(src, st)
            body = src[st + 1:en - 1] if en > 0 else ''
            kv = {}
            for ent in split_top(body):
                km = re.match(r"['\"]?([A-Za-z_]\w*)['\"]?\s*:\s*(.*)$", ent, re.S)
                if km:
                    kv[km.group(1)] = km.group(2).strip()
                elif re.fullmatch(r'[A-Za-z_]\w*', ent):
                    kv[ent] = ent
            sx = kv.get('sheetNm') or kv.get('sheetName') or ''
            sheets, err = [], ''
            lm = re.fullmatch(r"(['\"`])([^'\"`]*)\1", sx)
            if lm:
                sheets = [lm.group(2)]
            elif re.fullmatch(r'[A-Z][A-Z0-9_]*', sx):
                sheets = const_values(srcs, sx)
            elif re.fullmatch(r'([A-Z][A-Z0-9_]*)\[[^\]]+\]', sx):
                sheets = const_values(srcs, sx.split('[')[0])
            if not sheets:
                err = f"시트 식 해석 불가({sx[:40]})"
            dx = kv.get('divisionId', '')
            out.append({'file': f, 'rel': rel(f), 'line': src.count('\n', 0, m.start()) + 1, 'kind': m.group(1), 'sheets': sheets,
                        'div': dx, 'error': err})
    return out


def be_proc(kind):
    """/admin/menu/{mnuId}/<kind> → Controller 메서드 → ServiceImpl selectList id → MyBatis CALL 원문(PROC·인자 순서)"""
    be = P('nscm-be', 'src', 'main')
    ctl_m = svc = None
    for dp, _, fs in os.walk(os.path.join(be, 'java')):
        for fn in fs:
            if not fn.endswith('Controller.java'):
                continue
            s = open(os.path.join(dp, fn), encoding='utf-8', errors='replace').read()
            m = re.search(r'Mapping\(\s*value\s*=\s*"/admin/menu/\{mnuId\}/' + kind + r'"[^\n]*\n(?:[^\n]*\n){0,3}?[^\n]*?\b\w+Service\.(\w+)\(', s)
            if m:
                ctl_m = m.group(1); break
        if ctl_m:
            break
    if not ctl_m:
        return None, f"BE 경로 /admin/menu/{{mnuId}}/{kind} 의 Controller 메서드 해석 불가"
    sel = None
    for dp, _, fs in os.walk(os.path.join(be, 'java')):
        for fn in fs:
            if fn.endswith('ServiceImpl.java'):
                s = open(os.path.join(dp, fn), encoding='utf-8', errors='replace').read()
                mm = re.search(r'\b' + re.escape(ctl_m) + r'\s*\([^)]*\)[^{]*\{', s)
                if mm:
                    en = balanced(s, mm.end() - 1)
                    im = re.search(r'select\w*\(\s*nameSpace\s*\+\s*"(\w+)"', s[mm.end():en])
                    if im:
                        sel = im.group(1); break
        if sel:
            break
    if not sel:
        return None, f"ServiceImpl {ctl_m} 의 MyBatis id 해석 불가"
    for dp, _, fs in os.walk(os.path.join(be, 'resources')):
        for fn in fs:
            if fn.endswith('.xml'):
                s = open(os.path.join(dp, fn), encoding='utf-8', errors='replace').read()
                xm = re.search(r'<select\s+id="' + re.escape(sel) + r'"[^>]*>\s*\{\s*CALL\s+([\w.]+)\s*\((.*?)\)\s*\}', s, re.S)
                if xm:
                    return {'proc': xm.group(1), 'args': re.findall(r'#\{\s*(\w+)', xm.group(2)), 'xml': f"{fn}#{sel}"}, ''
    return None, f"MyBatis select id={sel} 의 CALL 원문 해석 불가"


def division_candidates(mid):
    rt_p = P('Doc', 'verify', mid, 'combo_runtime.json')
    codes = []
    if os.path.exists(rt_p):
        rt = json.load(open(rt_p, encoding='utf-8'))
        for c in rt.get('combos', []):
            if re.search(r'"comboId"\s*:\s*"(My)?Division(_\w+)?"', c.get('body', '')):  # Division 콤보 자체만(…ByDivision 은 Division 종속 다른 콤보)
                codes += [r['c'] for r in c.get('rows', []) if r.get('c') and r['c'] not in codes]
    src = 'combo_runtime.json(E2E 실측 Division 콤보)'
    if not codes:
        cfg = json.load(open(E2E_CFG, encoding='utf-8-sig'))
        if cfg.get('defaultDivision'):
            codes, src = [cfg['defaultDivision']], 'e2e.config defaultDivision'
    return codes, src


def asis_meta_rows(aid, kind, sheet):
    fn = 'dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv' if kind == 'measure' else 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv'
    rows = read_csv(P('Doc', 'asisfacts', 'screens', aid, fn))
    if not rows:
        return None
    k = next((c for c in rows[0] if c.lower() == 'sheet_name'), None)
    return sum(1 for r in rows if not k or (r.get(k) or '') == sheet)


def main():
    mid = sys.argv[1].upper()
    aid = sys.argv[sys.argv.index('--asis') + 1].upper() if '--asis' in sys.argv else next(
        (m['asis_id'].upper() for m in read_csv(P('tools', 'Harness', 'rules', 'map_screen.csv')) if (m.get('tobe_id') or '').upper() == mid), mid)
    out_p = P('Doc', 'verify', mid, 'popup_data.csv')
    os.makedirs(os.path.dirname(out_p), exist_ok=True)
    rel = lambda f: os.path.relpath(f, ROOT).replace('\\', '/')
    pdir = page_dir(mid)
    srcs = fe_sources(pdir) if pdir and os.path.isdir(pdir) else {}
    acalls = asis_titleset_calls(aid)
    tcalls = tobe_meta_calls(srcs, rel)
    rows = []

    def base(**kw):
        r = {k: '' for k in FIELDS}; r['menu_id'] = mid; r.update(kw); return r

    if not acalls:
        with open(out_p, 'w', encoding='utf-8-sig', newline='') as f:
            csv.DictWriter(f, fieldnames=FIELDS).writeheader()
        print(f"{mid}: M3 팝업 데이터 — AS-IS 개인화 팝업 없음 → 대상 0 → {out_p}")
        return 0
    if not tcalls:
        for a in acalls:
            rows.append(base(kind=a['kind'], asis_ref=a['ref'], asis_popup=a['popup'], asis_sheet=a['sheet'], asis_div_param='Y' if a['div_param'] else 'N',
                             verdict='ERROR', note='검사기 한계 — TO-BE 화면 코드에서 개인화 메타 조회 호출(/admin/menu/../measure|column)을 찾지 못함(공용 모달 내부 조회 경로는 E2E 몫)'))
    divs, dsrc = division_candidates(mid)
    cfg = json.load(open(E2E_CFG, encoding='utf-8-sig'))
    user = cfg.get('forceAccount') or cfg.get('defaultAccount')
    procs = {}
    cx = None
    try:
        from dbconn import connect
        import oracledb
        cx = connect('tobe')
    except Exception as e:  # noqa: BLE001
        cx_err = f"DB 접속 실패 {type(e).__name__}: {str(e)[:120]}"
    else:
        cx_err = ''

    def proc_has_commit(proc):
        owner, pkg, name = (proc.split('.') + ['', ''])[:3] if proc.count('.') == 2 else ('SCM_MGR', *proc.split('.'))
        cur = cx.cursor()
        cur.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=owner.upper(), n=pkg.upper())
        src = ''.join(t for _, t in cur.fetchall())
        m = re.search(r'\bPROCEDURE\s+' + re.escape(name) + r'\b', src, re.I)
        if not m:
            return None
        nxt = re.search(r'\n\s*(PROCEDURE|FUNCTION)\s+\w+', src[m.end():], re.I)
        body = re.sub(r'--[^\n]*|/\*.*?\*/', ' ', src[m.start(): m.end() + (nxt.start() if nxt else len(src))], flags=re.S)
        return bool(re.search(r'\bCOMMIT\b', body, re.I))

    def run_count(pinfo, sheet, div):
        cur = cx.cursor()
        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        val = {'userId': user, 'mnuId': mid, 'sheetNm': sheet, 'divisionId': div}
        args = [rc if a == 'DATARESULT' else val.get(a) for a in pinfo['args']]
        try:
            cur.callproc(pinfo['proc'], args)
            n = len(rc.getvalue().fetchall())
        finally:
            cx.rollback()  # 개인화 기본행 INSERT 분기 — 측정만 하고 되돌린다
        return n

    for t in tcalls:
        tref = f"{t['rel']}:{t['line']}"
        pair = [a for a in acalls if a['kind'] in (t['kind'], '')]
        if not pair:
            rows.append(base(kind=t['kind'], tobe_ref=tref, endpoint=f"/admin/menu/{{mnuId}}/{t['kind']}", division_expr=t['div'][:80], verdict='NA',
                             note=f"AS-IS 에 {t['kind']} 개인화 팝업 호출 없음 — 팝업 목록 원천이 아닌 메타 조회"))
            continue
        if t['error']:
            for a in pair:
                rows.append(base(kind=t['kind'], asis_ref=a['ref'], asis_popup=a['popup'], tobe_ref=tref, verdict='ERROR', note=f"검사기 한계 — {t['error']}"))
            continue
        if t['kind'] not in procs:
            procs[t['kind']] = be_proc(t['kind'])
        pinfo, perr = procs[t['kind']]
        for sheet in t['sheets']:
            exact = [a for a in pair if a['sheet'] and a['sheet'] == sheet]
            for a in (exact or [a for a in pair if not a['sheet']] or pair[:1]):
                common = dict(kind=t['kind'], asis_ref=a['ref'], asis_popup=a['popup'], asis_sheet=a['sheet'] or '(식)', asis_div_param='Y' if a['div_param'] else 'N',
                              tobe_ref=tref, endpoint=f"/admin/menu/{{mnuId}}/{t['kind']}", proc=(pinfo or {}).get('proc', ''), sheet=sheet, division_expr=t['div'][:80])
                if not pinfo or cx is None:
                    rows.append(base(**common, verdict='ERROR', note=f"검사기 한계 — {perr or cx_err}")); continue
                c_flag = proc_has_commit(pinfo['proc'])
                if c_flag is None or c_flag:
                    rows.append(base(**common, verdict='ERROR', note=f"검사기 한계 — PROC 원문 {'COMMIT 포함(실행하면 개인화 행이 남음 — 측정 생략)' if c_flag else '조회 불가'}")); continue
                cls_, _ = classify(t['div']) if t['div'] else ('EMPTY', '')
                probe = [''] + (divs if cls_ == 'BOUND' else [])
                try:
                    cnt = {d: run_count(pinfo, sheet, d) for d in probe}
                except Exception as e:  # noqa: BLE001
                    rows.append(base(**common, verdict='ERROR', note=f"검사기 한계 — DB 실행 실패 {type(e).__name__}: {str(e)[:160]}")); continue
                b = cnt['']
                zero = [d for d in probe if d and cnt[d] == 0]
                dtxt = ', '.join(f"{d}={cnt[d]}" for d in probe if d)
                common.update(base_rows=str(b), div_rows=dtxt[:600], zero_divisions=','.join(zero))
                who = f"계정 {user} · PROC {pinfo['proc']}({pinfo['xml']}) · 시트 '{sheet}'"
                if cls_ == 'BOUND' and not divs:
                    rows.append(base(**common, verdict='ERROR', note=f"검사기 한계 — Division 후보를 구하지 못함(combo_runtime.json·defaultDivision 없음) · '' {b}건 · {who}")); continue
                if b == 0:
                    am = asis_meta_rows(aid, t['kind'], a['sheet'] or sheet)
                    if am:
                        rows.append(base(**common, verdict='FAIL', note=f"팝업 목록 0건 — TO-BE 메타 조회가 Division 무관('')으로도 0건 · AS-IS 메타 {am}행(팝업에 표시) · {who}"))
                    else:
                        rows.append(base(**common, verdict='ERROR', note=f"[근거 불충분] TO-BE '' 0건 · AS-IS 메타 덤프에 같은 시트 행 없음/덤프 없음 — 팝업이 원래 빈 목록인지 미확정 · {who}"))
                    continue
                if zero and not a['div_param']:
                    rows.append(base(**common, verdict='FAIL', note=(
                        f"팝업 목록 0건 — Division 단일 선택({', '.join(zero[:8])}{' 외' if len(zero) > 8 else ''}) 후 열면 0건, ALL/다중('') 은 {b}건. "
                        f"AS-IS {a['popup']} 는 Division 인자를 받지 않아(생성자 인자 {a['ref']}) Division 과 무관하게 같은 목록 → TO-BE 가 AS-IS 에 없는 Division 조건({t['div'][:60]})을 "
                        f"팝업 목록 조회에 추가해 공통(DIVISION_ID 없음) 메타가 걸러짐 · Division 별 {dtxt[:300]} · {who} (원천 {dsrc}) · "
                        f"보완 방향(보완실행 단계): ① PROC 의 Division 필터가 DIVISION_ID 없는 공통 메타를 포함(DB 객체) 또는 ② AS-IS 처럼 팝업 목록 조회에 Division 미전달('')")))
                elif zero:
                    rows.append(base(**common, verdict='PASS', note=f"'' {b}건 · AS-IS 팝업도 Division 인자를 받음(Division 별 목록 차이는 AS-IS 동작) · 0건 Division {','.join(zero[:8])} · {who}"))
                else:
                    rows.append(base(**common, verdict='PASS', note=f"'' {b}건 · Division 별 {dtxt[:200] or '(고정 조건 — Division 미전달)'} · 전부 1건 이상 · {who}"))
    if cx is not None:
        cx.close()
    with open(out_p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=FIELDS)
        w.writeheader()
        w.writerows(rows)
    print(f"{mid}: M3 팝업 데이터 — AS-IS 개인화 팝업 {len(acalls)} · TO-BE 메타 조회 {len(tcalls)} · Division 후보 {len(divs)}({dsrc}) → "
          f"{dict(Counter(r['verdict'] for r in rows))} → {out_p}")
    for r in rows:
        if r['verdict'] in ('FAIL', 'ERROR'):
            print(f"  [{r['verdict']}] {r['tobe_ref'] or r['asis_ref']} {r['sheet']}: {r['note'][:200]}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
