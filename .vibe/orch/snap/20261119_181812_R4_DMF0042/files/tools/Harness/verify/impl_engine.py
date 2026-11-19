# -*- coding: utf-8 -*-
"""구현 엔진 v2 — 작업 원장(work ledger) 단일화 (2026-10-26)

  python tools/Harness/verify/impl_engine.py <MENU_ID>

  사용자 지시: "아직 검증되지 않은 673건은 구현되고 검증되어야 한다" · "대조표 미구현이면 FAIL 인데 구현 대기열로 따로 분류한 이유?"
  → 판정(mapping_trace)과 별개의 '대기열' 을 두지 않는다. **PASS·NA 가 아닌 검사 인스턴스 전부 = 할 일** 하나의 원장에 담는다.
     원장이 0건이 될 때까지 화면은 완료가 아니다(check.js VC1 · G11).

  입력: Doc/verify/<ID>/mapping_trace_instances.csv · mapping_trace.csv · mapping_trace_checks.csv (mapping_trace.py v2)
        fixlist.csv(보완대상목록 — 원장 FAIL 의 계층 분류·FX 번호 연결) · tools/Harness/harness.json repairScope
  출력: Doc/verify/<ID>/work_ledger.csv · work_ledger.md · work_ledger_summary.json
  작업 유형(결과 → 해야 할 일)
    W1 기능 구현        FAIL X-NOTIMPL(대조표 미구현) · AS-IS 엔드포인트의 TO-BE 프로시저 대응 없음
    W2 구현 위치 확인   FAIL X-LOC — 대조표의 구현 위치가 소스에 없음(구현 누락 또는 대조표 오기)
    W3 동작 수정        그 외 FAIL — 보완대상목록 FX 번호·계층 연결
    W4 검사기 구현      TODO — 검증 엔진에 검사기를 만든다 + 그 전에 구현 여부부터 확인(TO-BE 흔적 없으면 '구현 의심')
    W5 검사기 연결      NOPATH — 검사기는 있으나 이 대상을 실행하는 경로가 없다(ledger.py 원장 항목 생성 또는 @trace 확장)
    W6 검증 실행        NOT_RUN — 검사기·경로 있음, 실행만 남음(smoke·auth·crud 스펙 생성/실행 또는 @verify/@trace 재실행)
    W7 기대값 확정      REVIEW(판정필요)·WARN — AS-IS 원문·사람 확인으로 기대 확정 후 재판정(X-REASON = 대조표 사유 보강)
    W8 구현 후 검증     BLOCKED — 선행 W1(같은 대조표 행) 완료 후 검증
    W9 도구 오류        ERROR — 판정 불가(도구·환경) 원인 해소 후 재판정
  담당 층: DB(PKG·SP·메타 — 🛠️/🧯 적용 가능) · FE(repairScope=DB_ONLY 면 가이드만) · 대조표(문서 보강) · 하네스(검증 엔진) · E2E(실행) · 사람(판정)
  이 스크립트는 코드를 고치지 않는다.
"""
import csv, json, os, re, sys, collections, datetime
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.join(ROOT, 'Doc')
csv.field_size_limit(10 ** 8)
rdcsv = lambda p: list(csv.DictReader(open(p, encoding='utf-8-sig'))) if os.path.exists(p) else []
RX_DB = re.compile(r'SHEET_COLUMNS|INPUT_TP_CD|CMBO|콤보 ?SQL|PROC_M|API_M|\bPKG_|\bP_[A-Z0-9_]{4,}|SCM_ADM_|SCM_MST_|TO-BE 프로시저|AS-IS 엔드포인트', re.I)  # 수정 위치가 DB 객체·메타로 서술된 행만 DB
WNAME = {'W1': '기능 구현', 'W2': '구현 위치 확인', 'W3': '동작 수정', 'W4': '검사기 구현', 'W5': '검사기 연결', 'W6': '검증 실행', 'W7': '기대값 확정', 'W8': '구현 후 검증', 'W9': '도구 오류'}
RUNNER_HOW = {'smoke': 'smoke 스펙 생성·실행(🧪 E2E smoke)', 'auth': 'auth/authcrud 스펙 생성·실행', 'crud': 'crud 스펙 생성·실행', 'trace': '검증 엔진 @trace 재실행(run_verify)',
              'verify': '@verify 재실행(run_verify)', 'meta': 'judge.py META 판정(DB 접속)', 'static': 'mapping_trace.py 재실행'}


def msg_mapper():
    """AS-IS 메시지 ID → TO-BE ID (문구 일치 — tools/Harness/lib/msgmap.js 와 같은 규칙: KO → EN, 자리표시자 {n}). AS-IS ID 를 그대로 쓰면 다른 문구가 된다"""
    nm = lambda t: re.sub(r"""[\s.,!?。！？:;'"`·~\-_()\[\]]""", '', re.sub(r'\{\s*\d+\s*\}', '{n}', str(t or '')).lower())
    unq = lambda t: str(t or '').strip('"')
    asis = {unq(r.get('MessageID')).upper(): (unq(r.get('Ko')), unq(r.get('En'))) for r in rdcsv(os.path.join(DOC, 'asisfacts', 'db', 'meta', 'dbo.TB_FX_MessageInfo.csv'))}
    by = collections.defaultdict(list)
    for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'msg_master.csv')):
        if r.get('msg_id', '').startswith('MSG') and r.get('use_yn', 'Y') == 'Y' and r.get('msg_nm'): by[(r['lang_cd'].upper(), nm(r['msg_nm']))].append(r['msg_id'])
    def f(mid):
        ko, en = asis.get(mid.upper(), ('', ''))
        c = by.get(('KO', nm(ko)), []) if ko else []
        c = c or (by.get(('EN', nm(en)), []) if en else [])
        return (sorted(set(c))[0] if c else ''), ko or en
    return f


def main():
    mid = (sys.argv[1] if len(sys.argv) > 1 else '').upper()
    if not mid: print(__doc__); return 2
    od = os.path.join(DOC, 'verify', mid)
    inst = rdcsv(os.path.join(od, 'mapping_trace_instances.csv'))
    if not inst: print(f'[ERROR] {od}/mapping_trace_instances.csv 없음 — mapping_trace.py {mid} 먼저'); return 2
    trows = {r['row_id']: r for r in rdcsv(os.path.join(od, 'mapping_trace.csv'))}
    rows_of = collections.defaultdict(list)
    for r in rdcsv(os.path.join(od, 'mapping_trace_checks.csv')): rows_of[r['instance']].append(r['row_id'])
    summ = json.load(open(os.path.join(od, 'mapping_trace_summary.json'), encoding='utf-8'))
    defs = {r['check']: r for r in rdcsv(os.path.join(HERE, 'mapping_checkdefs.csv'))}
    scope = 'DB_ONLY'
    try: scope = json.load(open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('repairScope', 'DB_ONLY')
    except Exception: pass
    fe_guide = scope == 'DB_ONLY'
    fixl = rdcsv(os.path.join(od, 'fixlist.csv')); fix_by_row = {r['row_id']: r for r in fixl}
    # TO-BE 흔적(W4 구현 의심 판정) — 화면 FE 소스 · SHEET_COLUMNS · 문구로 환산한 TO-BE MSG ID
    page = os.path.join(ROOT, summ.get('fe_page') or '__none__'); fe_txt = ''
    for dp, _, fs in os.walk(page) if os.path.isdir(page) else []:
        for f in fs:
            if f.endswith(('.ts', '.tsx')):
                try: fe_txt += open(os.path.join(dp, f), encoding='utf-8').read() + '\n'
                except Exception: pass
    meta_cols = {r['column_name'] for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'sheet_columns.csv')) if r.get('column_name')}
    procs = {re.sub(r'^(P_|UP_|SP_)', '', r['proc'].split('.')[-1].upper()) for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if r.get('proc')}
    mmap = msg_mapper()

    def trace_of(d):
        """TO-BE 구현 흔적 — 있음/없음/판단불가"""
        if d['et'] == 'COL': return '있음(SHEET_COLUMNS)' if d['name'] in meta_cols else ('있음(FE 소스)' if re.search(r'\b' + re.escape(d['name']) + r'\b', fe_txt) else '없음')
        if d['et'] == 'MSG':
            t, txt = mmap(d['name'])
            if not t: return f"없음(TO-BE 에 '{txt[:30]}' 문구 메시지 미등록)"
            return f'있음({t})' if t in fe_txt else f'없음(TO-BE {t} 발생 지점이 화면 소스에 없음)'
        if d['et'] in ('COND', 'BTN'):
            als = [x for x in d['display'].split(' / ') if len(x) >= 3] + [d['name']]
            return '있음(FE 소스)' if any(re.search(r'(?<![A-Za-z0-9_])' + re.escape(a) + r'(?![A-Za-z0-9_])', fe_txt) for a in als) else '없음'
        if d['et'] == 'SP':
            return '있음(PROC_M)' if re.sub(r'^(P_|UP_|SP_)', '', d['name'].split('.')[-1].upper()) in procs else '없음(PROC_M 대응 없음)'
        return '판단불가(대상 단위 ' + d['et'] + ')'

    def owner(d, text):
        if fe_guide: fe = 'FE(repairScope=DB_ONLY — 이번 범위 밖)'
        else: fe = 'FE(적용 대상 — 공통 컴포넌트는 변경 전 확인)'
        return 'DB(🛠️/🧯 적용 가능)' if RX_DB.search(text) else fe

    out = []
    for d in inst:
        res = d['result']
        if res in ('PASS', 'NA'): continue
        df = defs.get(d['check'], {}); rids = list(dict.fromkeys(rows_of.get(d['key'], [])))
        rtxt = ' '.join(trows.get(r, {}).get('summary', '') for r in rids[:5])
        runners = [x for x in (df.get('runner') or 'verify').split('|') if x]
        tr = ''
        if res == 'FAIL' and d['check'] == 'X-NOTIMPL':
            w = 'W1'; what = f"대조표 미구현 행 구현 — {trows.get(d['name'], {}).get('summary', '')[:200]}"; who = owner(d, rtxt)
            done = f"대조표 상태 '구현' + 구현 위치 기입 → 같은 행의 BLOCKED 검사 실행(W8)"
        elif res == 'FAIL' and d['check'] == 'X-LOC':
            w = 'W2'; what = f"구현 위치 확인·대조표 보강 — {d['why'][:160]}"; who = '대조표(FE __asis-mapping__.md)'
            done = 'X-LOC PASS(구현 위치 파일:라인 실존)'
        elif res == 'FAIL':
            fx = next((fix_by_row[x] for x in re.findall(r'(V-[0-9a-f]{8}|T-[0-9a-f]{8})', d['why'] + ' ' + d.get('trace_row', '')) if x in fix_by_row), None)
            w = 'W3'; what = f"{d['check']} FAIL 수정 — {d['display'][:60]}: {d['why'][:140]}" + (f" ({fx['fix_id']})" if fx else '')
            who = (f"{fx['layer_name']}({fx['apply']})" if fx else owner(d, rtxt + ' ' + d['why'])); done = f"{d['check']} 재판정 PASS(judge + @verify/@trace)"
        elif res == 'TODO':
            tr = trace_of(d)
            w = 'W4'; what = f"검사기 구현 {d['check']} — {df.get('how', '')[:120]} · 대상 {d['display'][:50]}"
            who = '하네스(검증 엔진 _trace.spec.ts)' + (' + 구현 확인(TO-BE 흔적 없음 → 구현 의심)' if tr.startswith('없음') else '')
            done = f"{d['check']} 판정 PASS — 검사기 구현 → 원장 TRACE 행 실행"
        elif res == 'NOPATH':
            tr = trace_of(d)
            w = 'W5'; what = f"검사기 연결 {d['check']}({df.get('checker', '')[:40]}) → 대상 {d['et']} {d['display'][:50]}"
            who = '하네스(ledger.py 원장 항목 생성 또는 @trace 확장)' + (' + 구현 확인(TO-BE 흔적 없음)' if tr.startswith('없음') else '')
            done = f"{d['check']} 판정 PASS"
        elif res == 'NOT_RUN':
            w = 'W6'; what = f"{d['check']} 실행 — {d['display'][:50]} · {d['why'][:100]}"; who = 'E2E(' + ' / '.join(RUNNER_HOW.get(x, x) for x in runners) + ')'
            done = f"{d['check']} 판정 PASS"
        elif res in ('REVIEW', 'WARN'):
            w = 'W7'
            if d['check'] == 'X-REASON': what = f"제외·해당없음 사유 근거 보강 — {trows.get(d['name'], {}).get('summary', '')[:150]}"; who = '대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치)'
            else: what = f"{d['check']} 기대값 확정 — {d['display'][:50]}: {d['why'][:150]}"; who = '사람 판정 / AS-IS 원문 확인 → 재판정'
            done = f"{d['check']} PASS 또는 FAIL 로 확정(판정필요 0)"
        elif res == 'BLOCKED':
            pre = [r for r in rids if trows.get(r, {}).get('verdict') == '미구현']
            w = 'W8'; what = f"{d['check']} — 대조표 미구현 행 {', '.join(pre[:4])} 구현 후 검증 · 대상 {d['display'][:50]}"; who = '선행 W1 완료 후 ' + ('E2E' if 'E2E' in df.get('method', '') else '검증')
            done = f"선행 W1 완료 → {d['check']} PASS"
        else:
            w = 'W9'; what = f"{d['check']} 도구 오류 — {d['why'][:150]}"; who = '하네스·환경'; done = '재판정'
        out.append({'work_id': '', 'type': w, 'type_name': WNAME[w], 'check': d['check'], 'layer': d['layer'], 'result': res, 'target_unit': d['et'], 'target': d['display'][:80],
                    'owner': who, 'what': what[:400], 'tobe_trace': tr, 'asis_ref': d.get('cs', '')[:200], 'rows': len(rids), 'row_ids': ' '.join(rids[:12])[:300],
                    'done_when': done, 'instance': d['key'], 'trace_row': d.get('trace_row', '')})
    order = {k: i for i, k in enumerate(WNAME)}
    out.sort(key=lambda x: (order[x['type']], x['layer'], x['check'], x['target']))
    for i, x in enumerate(out, 1): x['work_id'] = f'WK-{mid}-{i:04d}'
    cols = list(out[0].keys()) if out else ['work_id']
    with open(os.path.join(od, 'work_ledger.csv'), 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.DictWriter(fp, fieldnames=cols); w.writeheader(); [w.writerow(x) for x in out]
    for old in ('impl_queue.csv', 'impl_queue.md', 'impl_queue_summary.json', 'engine_backlog.md'):  # v1 산출물(대기열 분리) 폐기 — 작업 원장 하나로 통합
        p = os.path.join(od, old)
        if os.path.exists(p): os.remove(p)
    ct = collections.Counter(x['type'] for x in out)
    total = len(inst); done_n = sum(1 for d in inst if d['result'] in ('PASS', 'NA'))
    susp = [x for x in out if x['tobe_trace'].startswith('없음')]
    by_check = collections.defaultdict(collections.Counter)
    for x in out: by_check[x['check']][x['type']] += 1
    by_owner = collections.Counter(re.sub(r'\(.*', '', x['owner']).strip() for x in out)
    json.dump({'menu_id': mid, 'generated': datetime.datetime.now().isoformat(timespec='seconds'), 'instances': total, 'done': done_n, 'open': len(out), 'by_type': dict(ct),
               'by_owner': dict(by_owner), 'suspect_not_implemented': len(susp), 'by_check': {k: dict(v) for k, v in by_check.items()}},
              open(os.path.join(od, 'work_ledger_summary.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    L = [f'# 작업 원장 — {mid} · {datetime.datetime.now():%Y-%m-%d %H:%M}', '',
         f'> 검사 인스턴스 {total}건 중 PASS·NA {done_n}건 외 **{len(out)}건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).',
         f'> 보완 범위 repairScope = **{scope}** — FE 항목은 {"이번 범위 밖(DB_ONLY)" if fe_guide else "적용 대상"}. 이 원장은 코드를 고치지 않는다.', '',
         '| 유형 | 할 일 | 건수 | 완료 조건 |', '|---|---|---|---|']
    DONE = {'W1': '대조표 구현 + 위치 기입 → W8 실행', 'W2': '구현 위치 실존', 'W3': '재판정 PASS', 'W4': '검사기 구현 → 실행 PASS', 'W5': '원장 항목/엔진 연결 → 실행 PASS',
            'W6': '실행 → PASS', 'W7': '기대 확정 → PASS/FAIL', 'W8': '선행 W1 → PASS', 'W9': '원인 해소 → 재판정'}
    for k in WNAME:
        if ct.get(k): L.append(f'| {k} | {WNAME[k]} | {ct[k]} | {DONE[k]} |')
    L += ['', f'- 담당: ' + ' · '.join(f'{k} {v}' for k, v in by_owner.most_common()),
          f'- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): {len(susp)}건 — 검증 전에 구현 여부부터 확인', '',
          '## 검사별 할 일 분포', '', '| 검사 | 층 | ' + ' | '.join(WNAME) + ' | 검사 방법 |', '|---' * (len(WNAME) + 3) + '|']
    for k, c in sorted(by_check.items(), key=lambda kv: -sum(kv[1].values())):
        L.append(f"| {k} | {defs.get(k, {}).get('layer', '')} | " + ' | '.join(str(c.get(t, 0) or '') for t in WNAME) + f" | {defs.get(k, {}).get('how', '')[:70]} |")
    for k in WNAME:
        sub = [x for x in out if x['type'] == k]
        if not sub: continue
        L += ['', f'## {k} {WNAME[k]} ({len(sub)})', '', '| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |', '|---|---|---|---|---|---|---|']
        L += [f"| {x['work_id']} | {x['check']} | {x['target'][:40].replace('|', '/')} | {x['owner'][:40]} | {x['what'][:130].replace('|', '/')} | {x['tobe_trace'][:30]} | {x['rows']} ({x['row_ids'][:40]}) |" for x in sub]
    open(os.path.join(od, 'work_ledger.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print(f"{mid}: 작업 원장 {len(out)}건(인스턴스 {total} 중 PASS·NA {done_n}) — " + ' · '.join(f'{k} {WNAME[k]} {v}' for k, v in sorted(ct.items())) + f" · 구현 의심 {len(susp)} → Doc/verify/{mid}/work_ledger.md")
    return 0


if __name__ == '__main__':
    sys.exit(main())
