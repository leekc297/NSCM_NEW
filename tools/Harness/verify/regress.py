# -*- coding: utf-8 -*-
"""검사기 회귀 게이트(2026-10-29 사용자: "검사기 오류로 인한 조치 필요 항목 — 재발하지 않도록") — 사용자 판정을 회귀 오라클로 쓴다.

사용: python tools/Harness/verify/regress.py [<MENU_ID> ...] [--harvest]   (인자 없으면 원장이 있는 모든 화면)

하는 일
  1 --harvest(또는 오라클 파일이 없을 때): 모든 CheckList 판(harness.json paths.checklistDir·legacyChecklistDirs 와 그 old, 옛 Doc/화면분석서)의 '사용자의견/사용자판정' 열을 모아
    Doc/verify/_user_verdicts.csv (menu_id,row_id,class,opinion,rule_id,target,explain,source_file) 로 쓴다. class = 판정오류 | 중복 | 대상아님 | 실제오류확인 | 설명요구 | 기타
  2 화면별 검사:
    (a) class=판정오류 행 — judge 가 사용자판정으로 덮기 전 '원판정'(note 의 원판정:) 이 FAIL 이면 위반 → 검사기가 여전히 같은 허위 FAIL 을 낸다
    (b) class=중복 행 — 그 행이 조치 필요(Doc/verify/<ID>/action_items.json)에 별도 항목으로 올라 있으면 위반(묶이지 않음)
    (c) class=대상아님 행 — 원판정이 FAIL 이면 위반
  3 결과: Doc/verify/_regress_report.md (화면별 위반 목록) · 위반 0 이면 exit 0, 아니면 exit 2
원칙: 사용자 판정은 행 덮어쓰기(마스킹)로 끝내지 않는다 — 같은 검사기 결함이 다시 나오면 여기서 걸린다.
"""
import argparse, csv, glob, json, os, re, sys, datetime

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
VERD = os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts.csv')
REPORT = os.path.join(ROOT, 'Doc', 'verify', '_regress_report.md')
# (2026-10-30) 놓친 결함 오라클 — 사용자가 실제로 확인한 결함(expected=FAIL: 검사기가 **측정 FAIL** 로 잡아야 함) · 사용자가 판정오류라 한 행(NOT_FAIL) ·
#   대상 아님(NA 유지). SCP0111 8건 중 7건 미검출 계기 — "오류는 못 거르고 정상만 오류로 거른다" 를 매 실행 숫자로 드러낸다. 위반이면 exit 2 → run_verify rc 10
ORACLE = os.path.join(ROOT, 'Doc', 'verify', '_missed_oracle.csv')
RX_MEASURED = re.compile(r'^(E2E|STATIC|META|SYN|DB|W1 |sort)')  # 측정 근거(make_verify_docs.evidence_grade '기계' 와 같은 접두)
RX_INHERITED = re.compile(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*(행 집계|진입점 집계|선행 미구현에 종속|선행 대조표 |규칙 \w+ )')


def cls(o):
    o2 = str(o or '').lower()
    if re.search(r'중복', o2): return '중복'
    if re.search(r'판정\s*오류|판단\s*오류|오류\s*아님|오판|^정상|정상\s*확인|이상\s*없음|재현\s*안', o2): return '판정오류'
    if re.search(r'^fail|구현\s*필요|오류\s*맞|실제\s*오류', o2): return '실제오류확인'
    if re.search(r'대상\s*아님|해당\s*없음|^na\b', o2): return '대상아님'
    if re.search(r'설명|이해|어디|명기|상세', o2): return '설명요구'
    return '기타'


def _checklist_dirs():
    """CheckList 폴더 목록 = harness.json paths.checklistDir(없으면 Doc/UI_CHECKLIST) + paths.legacyChecklistDirs."""
    try:
        with open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig') as f:
            hp = (json.load(f) or {}).get('paths') or {}
    except (OSError, ValueError):
        hp = {}
    hp = hp if isinstance(hp, dict) else {}
    ds = [hp.get('checklistDir') or 'Doc/UI_CHECKLIST'] + list(hp.get('legacyChecklistDirs') or [])
    return [os.path.normpath(d if os.path.isabs(d) else os.path.join(ROOT, d)) for d in ds if d]


def harvest():
    import openpyxl
    # 개선안 20261124012047_SELF_4(R83): CheckList 폴더 = harness.json paths.checklistDir + legacyChecklistDirs(make_verify_docs·judge 와 같은 값)
    pats = []
    for d in _checklist_dirs():
        pats += [os.path.join(d, '*_CheckList_v*.xlsx'), os.path.join(d, 'old', '*_CheckList_v*.xlsx')]
    pats += [os.path.join(ROOT, 'Doc', '화면분석서', '**', '*_정합검증서_v*.xlsx'), os.path.join(ROOT, 'Doc', '화면분석서', '**', '*_CheckList_v*.xlsx')]
    files = sorted({f for p in pats for f in glob.glob(p, recursive=True) if not os.path.basename(f).startswith('~$')}, key=os.path.getmtime)
    # 2026-11-08 속도: 판 xlsx 262개를 매 실행 전부 여는 데 264s(SCP0122 --only K3 실측 · docs 단계의 95%) → 파일별 (mtime, size) 캐시 — 바뀐/새 판만 다시 읽는다(결과 동일 · 순서 = mtime)
    CACHE = os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts_cache.json')
    try:
        cache = json.load(open(CACHE, encoding='utf-8')) if os.path.exists(CACHE) else {}
    except (OSError, ValueError):
        cache = {}
    ops = {}; hit = miss = 0
    for f in files:
        sid = os.path.basename(f).split('_')[0]
        rel = os.path.relpath(f, ROOT).replace('\\', '/'); st = os.stat(f); key = f'{st.st_mtime_ns}:{st.st_size}'
        c = cache.get(rel)
        if c and c.get('key') == key:
            for sid_, rid, *v in c.get('ops', []): ops[(sid_, rid)] = tuple(v)
            hit += 1; continue
        miss += 1; got = []
        try: wb = openpyxl.load_workbook(f, read_only=True, data_only=True)
        except Exception:
            cache[rel] = {'key': key, 'ops': []}; continue
        for ws in wb.worksheets:
            rows = list(ws.iter_rows(values_only=True))
            if not rows: continue
            hi = next((i for i, rr in enumerate(rows[:5]) if rr and any(c and ('사용자의견' in str(c) or '사용자판정' in str(c)) for c in rr)), None)
            if hi is None: continue
            hdr = [str(c) if c else '' for c in rows[hi]]
            ci = [k for k, h in enumerate(hdr) if '사용자의견' in h or '사용자판정' in h]
            ri = hdr.index('규칙') if '규칙' in hdr else 5; ti = hdr.index('대상') if '대상' in hdr else 7
            ei = next((k for k, h in enumerate(hdr) if h.startswith('쉬운 설명') or h == '설명'), None)  # 2026-10-30 열 이름 '설명'(옛 판 '쉬운 설명') — 위치 추측 금지
            for rr in rows[hi + 1:]:
                if not rr or len(rr) < 2 or not rr[1] or not re.match(r'^[VT]-[0-9a-f]{8}$', str(rr[1])): continue
                for c in ci:
                    if c < len(rr) and rr[c] and str(rr[c]).strip():
                        o = str(rr[c]).strip()
                        v_ = (o, str(rr[ri] if ri < len(rr) and rr[ri] else ''), str(rr[ti] if ti < len(rr) and rr[ti] else '')[:60], str(rr[ei] if ei is not None and ei < len(rr) and rr[ei] else '')[:160], os.path.relpath(f, ROOT))
                        ops[(sid, str(rr[1]))] = v_; got.append([sid, str(rr[1]), *v_])
        cache[rel] = {'key': key, 'ops': got}
    # 2026-11-06(동시 실행 영향 차단): 여러 화면 CheckList 가 동시에 --harvest 하면 반쯤 쓰인 공용 파일을 다른 화면이 읽을 수 있었다 → 임시 파일 → 원자 교체
    tmp = f'{VERD}.{os.getpid()}.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.writer(fp); w.writerow(['menu_id', 'row_id', 'class', 'opinion', 'rule_id', 'target', 'explain', 'source_file'])
        for (s, rid), v in sorted(ops.items()): w.writerow([s, rid, cls(v[0]), v[0], v[1], v[2], v[3], v[4]])
    _replace(tmp, VERD)
    try:  # 캐시도 원자 교체(동시 실행 보호) · 사라진 판 항목은 정리
        live = {os.path.relpath(f, ROOT).replace('\\', '/') for f in files}
        ctmp = f'{CACHE}.{os.getpid()}.tmp'
        with open(ctmp, 'w', encoding='utf-8') as cf:
            json.dump({k: v for k, v in cache.items() if k in live}, cf, ensure_ascii=False)
        _replace(ctmp, CACHE)
    except OSError as _ex:
        print(f'[WARN] 판정 캐시 저장 실패(동작 영향 없음): {_ex}')
    print(f'사용자 판정 수집 {len(ops)}건 → {os.path.relpath(VERD, ROOT)} · 판 {len(files)}개(캐시 적중 {hit} · 재파싱 {miss})')
    return ops


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig') as f: return list(csv.DictReader(f))


def check_oracle(mid):
    """_missed_oracle.csv 의 이 화면 행마다 원장 일치 행(rule_id 일치 · target_re · condition_re)을 찾아 기대와 대조.
    FAIL: 일치 행 중 측정 FAIL(tobe_ref 측정 접두 · 증거가 상속/집계 아님) ≥1 — 0 이면 '놓친 결함'(일치 행 자체가 없으면 '대상 미생성')
    NOT_FAIL: 일치 행의 최근 원판정 또는 현재 결과가 FAIL 이면 위반 · NA: 일치 행 결과가 NA 가 아니면 위반
    FAIL_OR_BLOCKED: 측정 FAIL ≥1, 또는 일치 행 전부가 측정 FAIL 이거나 '[편집 불가로 미측정] … D1 FAIL V-xxxxxxxx 참조' ERROR(참조 행이 실제 FAIL)"""
    led = rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv'))
    if not led: return None
    out = []
    orig = lambda r: ((re.findall(r'원판정:(\w+)', r.get('note') or '') or [''])[-1])
    for o in [x for x in rd(ORACLE) if (x.get('menu_id') or '').upper() == mid]:
        rx_t = re.compile(o['target_re'], re.I) if o.get('target_re') else None
        rx_c = re.compile(o['condition_re'], re.I) if o.get('condition_re') else None
        hits = [r for r in led if r['rule_id'] == o['rule_id'] and (not rx_t or rx_t.search(r.get('target') or '')) and (not rx_c or rx_c.search(r.get('condition') or ''))]
        exp = (o.get('expected') or '').upper()
        if exp == 'FAIL':
            meas = [r for r in hits if r['result'] == 'FAIL' and RX_MEASURED.match(r.get('tobe_ref') or '') and not RX_INHERITED.match(r.get('evidence') or '')]
            ok = bool(meas)
            why = '' if ok else ('대상 미생성 — 원장에 일치 행 없음(검사 우주 밖)' if not hits else f"놓친 결함 — 일치 {len(hits)}행 결과 {', '.join(sorted({r['result'] for r in hits}))} · {(hits[0].get('evidence') or '')[:120]}")
        elif exp == 'FAIL_OR_BLOCKED':  # 2026-10-30 SCP0111 E1: TO-BE 가 컬럼을 잠가(D1 FAIL) 입력 규칙을 못 재는 상태 — 측정 FAIL 또는 'D1 FAIL 참조' 로 명시 연결된 ERROR 만 인정(NA·무근거 ERROR 는 위반)
            meas = [r for r in hits if r['result'] == 'FAIL' and RX_MEASURED.match(r.get('tobe_ref') or '') and not RX_INHERITED.match(r.get('evidence') or '')]
            by_id = {r['row_id']: r for r in led}
            blocked = [r for r in hits if r['result'] == 'ERROR' and (r.get('evidence') or '').startswith('[편집 불가로 미측정]')
                       and any(by_id.get(m) and by_id[m]['result'] == 'FAIL' for m in re.findall(r'\b(V-[0-9a-f]{8}|T-[0-9a-f]{8})\b', r.get('evidence') or ''))]
            ok = bool(meas) or (bool(hits) and all(r in meas or r in blocked for r in hits))
            why = '' if ok else ('대상 미생성 — 원장에 일치 행 없음(검사 우주 밖)' if not hits else f"놓친 결함 — 일치 {len(hits)}행 중 측정 FAIL 0 · 차단(D1 FAIL 연결) {len(blocked)} · 그 외 {', '.join(sorted({r['result'] for r in hits if r not in blocked}))}")
        elif exp == 'NOT_FAIL':
            bad = [r for r in hits if orig(r) == 'FAIL' or (not orig(r) and r['result'] == 'FAIL')]
            ok = not bad
            why = '' if ok else '허위 FAIL 재발 — ' + ', '.join(f"{r['row_id']}({r['result']}/원판정 {orig(r) or '-'})" for r in bad[:4])
        else:  # NA
            bad = [r for r in hits if r['result'] != 'NA']
            ok = not bad
            why = '' if ok else '대상 아님 행이 판정됨 — ' + ', '.join(f"{r['row_id']}({r['result']})" for r in bad[:4])
        out.append({'rule_id': o['rule_id'], 'target_re': o['target_re'], 'expected': exp, 'ok': ok, 'why': why, 'note': o.get('note') or '', 'hits': len(hits)})
    return out


def check(mid, verd):
    led = {r['row_id']: r for r in rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv'))}
    if not led: return None
    ai_p = os.path.join(ROOT, 'Doc', 'verify', mid, 'action_items.json')
    actions = {}
    try:
        for a in json.load(open(ai_p, encoding='utf-8')): actions[a['row_id']] = a
    except Exception: actions = None
    viol = []
    for v in verd:
        r = led.get(v['row_id'])
        if not r: continue
        note = r.get('note') or ''; ms = re.findall(r'원판정:(\w+)', note); orig = ms[-1] if ms else ''  # 최근 실행 값(옛 note 에 누적된 앞쪽 값은 낡음 · 2026-10-30)
        if v['class'] in ('판정오류', '대상아님'):
            if orig == 'FAIL' or (not orig and r['result'] == 'FAIL'):
                viol.append((v['row_id'], v['class'], v['rule_id'], v['target'], f"검사기 원판정 FAIL 유지 — 사용자: '{v['opinion'][:60]}' · 현재 증거: {(r.get('evidence') or '')[:140]}"))
        elif v['class'] == '중복':
            if actions is not None and v['row_id'] in actions and not actions[v['row_id']].get('folded_into'):
                viol.append((v['row_id'], v['class'], v['rule_id'], v['target'], f"조치 필요에 별도 항목으로 남음(묶이지 않음) — 사용자: '{v['opinion'][:60]}'"))
    return {'menu_id': mid, 'checked': len([v for v in verd if v['row_id'] in led]), 'violations': viol, 'actions': None if actions is None else sum(1 for a in actions.values() if not a.get('folded_into'))}


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menus', nargs='*'); ap.add_argument('--harvest', action='store_true'); a = ap.parse_args()
    if a.harvest or not os.path.exists(VERD): harvest()
    verd = rd(VERD)
    # 2026-11-17(SCP0104 T-25489c40): 대화로 받은 최신 판정(_user_verdicts_direct.csv)이 CheckList 옛 판의 의견보다 우선.
    #   사용자가 '오류 아님' 을 뒤집어 FAIL 로 확정하면 그 행은 판정오류 오라클이 아니다(검사기 FAIL 이 정답) → 실제오류확인으로 바꾼다
    try:
        _dv = {(d.get('menu_id') or '').upper() + '|' + (d.get('row_id') or '').strip(): (d.get('verdict') or '').strip().upper() for d in rd(os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts_direct.csv'))}
        for v_ in verd:
            k_ = (v_.get('menu_id') or '').upper() + '|' + (v_.get('row_id') or '').strip()
            if _dv.get(k_) == 'FAIL' and v_.get('class') in ('판정오류', '대상아님'): v_['class'] = '실제오류확인'; v_['opinion'] = (v_.get('opinion') or '') + ' → 사용자 직접 판정 FAIL 로 대체'
            elif _dv.get(k_) == 'PASS' and v_.get('class') == '실제오류확인': v_['class'] = '판정오류'; v_['opinion'] = (v_.get('opinion') or '') + ' → 사용자 직접 판정 PASS 로 대체'
    except Exception as _ex:
        print(f'[WARN] 직접 판정 반영 실패(무시): {_ex}')
    # 2026-11-06 W8(플랜 1-6·3-4): 대화·스냅샷 승인으로 받은 직접 판정(_user_verdicts_direct.csv)도 회귀 오라클 — PASS → 판정오류(다시 FAIL 이면 위반) · NA/SKIP → 대상아님 · FAIL → 실제오류확인
    have = {(v['menu_id'], v['row_id']) for v in verd}
    for d in rd(os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts_direct.csv')):
        v = (d.get('verdict') or '').strip().upper(); c = {'PASS': '판정오류', 'NA': '대상아님', 'SKIP': '대상아님', 'FAIL': '실제오류확인'}.get(v)
        key = ((d.get('menu_id') or '').upper(), (d.get('row_id') or '').strip())
        if c and key[1] and key not in have:
            verd.append({'menu_id': key[0], 'row_id': key[1], 'class': c, 'opinion': d.get('opinion') or '', 'rule_id': '', 'target': '', 'explain': '', 'source_file': '_user_verdicts_direct.csv'}); have.add(key)
    menus = [m.upper() for m in a.menus] or sorted({v['menu_id'] for v in verd} | {os.path.basename(d) for d in glob.glob(os.path.join(ROOT, 'Doc', 'verify', '*')) if os.path.isdir(d) and os.path.exists(os.path.join(d, 'verify_ledger.csv'))})
    out = []; total = 0
    for mid in menus:
        vs = [v for v in verd if v['menu_id'] == mid and v['class'] in ('판정오류', '중복', '대상아님')]
        res = check(mid, vs)
        if res is None: continue
        res['oracle'] = check_oracle(mid) or []
        omiss = [o for o in res['oracle'] if not o['ok']]
        out.append(res); total += len(res['violations']) + len(omiss)
        print(f"{mid}: 사용자 판정 {res['checked']}건 대조 · 위반 {len(res['violations'])}" + (f" · 조치 필요 {res['actions']}건" if res['actions'] is not None else ' · action_items.json 없음(문서 미생성)')
              + (f" · 놓친결함 오라클 {len(res['oracle'])}건 중 위반 {len(omiss)}" if res['oracle'] else ''))
        for v in res['violations'][:12]: print(f"   ✖ {v[0]} {v[1]} {v[2]} {v[3][:30]} — {v[4][:150]}")
        for o in omiss[:20]: print(f"   ✖ 오라클 {o['rule_id']} /{o['target_re']}/ 기대 {o['expected']} — {o['why'][:160]}")
    lines = [f"# 검사기 회귀 보고 — {datetime.datetime.now():%Y-%m-%d %H:%M}", '', f"오라클: {os.path.relpath(VERD, ROOT)} ({len(verd)}건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 {os.path.relpath(ORACLE, ROOT)}", f"위반 합계: {total}", '']
    for res in out:
        omiss = [o for o in res['oracle'] if not o['ok']]
        lines.append(f"## {res['menu_id']} — 대조 {res['checked']}건 · 위반 {len(res['violations'])} · 놓친결함 오라클 {len(res['oracle'])}건 중 위반 {len(omiss)}")
        for v in res['violations']: lines.append(f"- {v[0]} [{v[1]}] {v[2]} {v[3]} — {v[4]}")
        for o in res['oracle']: lines.append(f"- {'✔' if o['ok'] else '✖'} 오라클 {o['rule_id']} /{o['target_re']}/ 기대 {o['expected']} · 일치 {o['hits']}행{(' — ' + o['why']) if o['why'] else ''} · {o['note'][:80]}")
        lines.append('')
    # 2026-11-06(사용자 지시 · 화면 ID 중간 폴더): 화면별 보고 Doc/verify/<ID>/_regress_report.md(그 화면 절만) — 동시에 도는 다른 화면이 공용 보고를 덮어써도
    #   이 화면 CheckList 가 가리키는 보고는 남는다. 공용 Doc/verify/_regress_report.md 는 마지막 실행 전체(종전과 같음 · 원자 교체)
    head = lines[:2]
    for res in out:
        sec, on = [], False
        for ln in lines:
            if ln.startswith('## '): on = ln.startswith(f"## {res['menu_id']} —")
            if on: sec.append(ln)
        omiss = [o for o in res['oracle'] if not o['ok']]
        pd = os.path.join(ROOT, 'Doc', 'verify', res['menu_id'])
        if os.path.isdir(pd):
            _write_text(os.path.join(pd, '_regress_report.md'), '\n'.join(head + [lines[2], f"위반 합계: {len(res['violations']) + len(omiss)}", ''] + sec))
    _write_text(REPORT, '\n'.join(lines))
    print(f"→ {os.path.relpath(REPORT, ROOT)}{' · 화면별 Doc/verify/<ID>/_regress_report.md' if out else ''} · 위반 {total}")
    return 2 if total else 0


def _replace(tmp, dst):
    """원자 교체 — Windows 에서 다른 프로세스가 잠깐 열고 있으면(PermissionError) 0.25초 간격 최대 10초 재시도"""
    import time
    for i in range(41):
        try:
            os.replace(tmp, dst); return
        except PermissionError:
            if i == 40: raise
            time.sleep(0.25)


def _write_text(dst, text):
    tmp = f'{dst}.{os.getpid()}.tmp'
    with open(tmp, 'w', encoding='utf-8') as f: f.write(text)
    _replace(tmp, dst)


if __name__ == '__main__':
    sys.exit(main())
