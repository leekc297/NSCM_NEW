# -*- coding: utf-8 -*-
"""TO-BE 룰 원장(2026-11-11 · 플랜 §3) — 흩어진 TO-BE 룰을 1룰 1행으로 모으고, 각 룰이 어느 단계에서 무엇으로 강제되는지를 코드 실측으로 붙인다.

  python tools/Harness/verify/tobe_rule_registry.py --build   원천 CSV + 코드 스캔 → tools/Harness/rules/tobe_rule_registry.csv · Doc/verify/_tobe_rule_registry.md
  python tools/Harness/verify/tobe_rule_registry.py --check   무결성 위반(코드에 있는데 원장에 없는 룰 번호)이 있으면 exit 2
  python tools/Harness/verify/tobe_rule_registry.py --selftest

현재 단계(M0): **통합 뷰 + 무결성 게이트**. 판정·생성 도구는 아직 원천 CSV 를 그대로 읽는다(판정 불변) — 원장 구동 전환은 다음 단계(EN-11).
원천: confirmed_requirements.csv(CR) · design_decisions.csv(DD) · sp_replaced.csv(SPR) · allowed_gaps.csv(AG) · label_alias.csv(룰의 파라미터로 연결)
열: rule_id, kind, scope, detect_rules, title, requirement, phase, enforcers, declared_harness, origin, decided_at, status, source, integrity
  kind: TOBE_DIFF(AS-IS 와 달라도 오류 아님) · TOBE_DEV(TO-BE 개발 규칙) · FORBID · (미분류)
    — DD·SPR·AG 는 파일 정의상 TOBE_DIFF. CR 은 원천에 종류 열이 없어 **추측으로 나누지 않는다** → tobe_rule_kind.csv(rule_id,kind,by,at)에 지정된 것만 반영, 나머지는 (미분류)로 집계.
  phase: 그 룰 번호가 실제로 나오는 코드 위치에서 유도(FE_GEN·SP_GEN·META_GEN·FE_GATE·SP_GATE·LEDGER·JUDGE·E2E·DOC) — 선언이 아니라 실측.
  enforcers: 'file:line' 목록(최대 8개 + 총 개수). DD 는 judge 가 CSV 로 읽으므로 'judge.py(data)' 로 표기.
  integrity: NO_ENFORCER(강제 지점 없음 — 산문·사후 판정만) · GEN_UNLINKED(생성 단계 미연결) · OK
"""
import csv
import glob
import os
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
RULES = os.path.join(ROOT, 'tools', 'Harness', 'rules')
OUT = os.path.join(RULES, 'tobe_rule_registry.csv')
MD = os.path.join(ROOT, 'Doc', 'verify', '_tobe_rule_registry.md')
COLS = ['rule_id', 'kind', 'scope', 'detect_rules', 'title', 'requirement', 'phase', 'enforcers', 'declared_harness', 'origin', 'decided_at', 'status', 'source', 'integrity']
CODE_GLOBS = ['tools/Harness/*.js', 'tools/Harness/lib/*.js', 'tools/Harness/verify/*.py', 'tools/Harness/prompts/*.md', 'tools/E2E/*.js', 'tools/E2E/lib/*.ts',
              'tools/E2E/fixtures/*.ts', 'Doc/e2e/specs/_*.spec.ts', 'Doc/e2e/specs/eg_*.spec.ts', 'tools/DbConn/*.py', 'tools/VibeManager/*.json']
SKIP = re.compile(r'\.bak|selftest|_debug|tobe_rule_registry\.py$|cr_harness_gap\.py$')
RX_ID = re.compile(r'\b(CR-\d{3}|DD-\d{3})\b')
GEN_PHASES = {'FE_GEN', 'SP_GEN', 'META_GEN'}


def rd(name):
    p = os.path.join(RULES, name)
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def phase_of(rel):
    b = os.path.basename(rel).lower(); r = rel.lower()
    if 'prompts/' in r:
        return 'SP_GEN' if 'pkg' in b else 'FE_GEN'
    if 'tools/harness/verify/' in r:
        if b.startswith('judge') or b.startswith('eg_ingest') or b.startswith('mapping_trace'):
            return 'JUDGE'
        if b.startswith('ledger') or b.startswith('gen_expect') or b.startswith('oracle_class') or b.startswith('applicability'):
            return 'LEDGER'
        if b.startswith('make_verify_docs'):
            return 'DOC'
        return 'STATIC'
    if 'tools/harness/' in r:
        if b.startswith('gen-pkg'):
            return 'SP_GEN'
        if b.startswith('check-pkg'):
            return 'SP_GATE'
        if b.startswith('gen-register'):
            return 'META_GEN'
        if b.startswith('check'):
            return 'FE_GATE'
        if b.startswith('gen') or b.startswith('templates'):
            return 'FE_GEN'
        return 'FE_GATE'
    if 'tools/e2e/' in r or 'doc/e2e/specs' in r:
        return 'E2E'
    if 'vibemanager' in r:
        return 'VM'
    return 'OTHER'


def scan_code():
    """{rule_id: [(rel, line)]}"""
    hits = {}
    files = []
    for g in CODE_GLOBS:
        files += [p for p in glob.glob(os.path.join(ROOT, g)) if os.path.isfile(p) and not SKIP.search(os.path.basename(p))]
    for p in sorted(set(files)):
        rel = os.path.relpath(p, ROOT).replace(os.sep, '/')
        try:
            lines = open(p, encoding='utf-8-sig', errors='replace').read().split('\n')
        except OSError:
            continue
        for i, l in enumerate(lines, 1):
            for m in set(RX_ID.findall(l)):
                hits.setdefault(m, []).append((rel, i))
    return hits, len(set(files))


def build():
    hits, nfiles = scan_code()
    kinds = {r['rule_id']: r for r in rd('tobe_rule_kind.csv')}
    alias = {}
    for r in rd('label_alias.csv'):
        alias.setdefault(r.get('req_id', ''), []).append(f"{r.get('asis_label')}→{r.get('tobe_label')}({r.get('scope')})")
    rows = []

    def enf(rid, extra=None):
        hs = hits.get(rid, [])
        ph = sorted({phase_of(f) for f, _ in hs} | set(extra or []))
        txt = ';'.join(f'{os.path.basename(f)}:{ln}' for f, ln in hs[:8]) + (f' …(+{len(hs) - 8})' if len(hs) > 8 else '')
        return ph, txt, len(hs)

    for r in rd('confirmed_requirements.csv'):
        rid = r['req_id']; ph, txt, n = enf(rid)
        if n and 'LEDGER' not in ph:
            pass
        ph2 = sorted(set(ph) | {'LEDGER'})  # ledger.py 가 scope 에 맞는 CR 마다 CONFIRMED 검증 행을 만든다(데이터 구동)
        decl = (r.get('harness') or '').strip()
        gen_linked = bool(set(ph2) & GEN_PHASES) or bool(decl)
        integ = 'NO_ENFORCER' if not n and not decl else ('OK' if gen_linked else 'GEN_UNLINKED')
        k = kinds.get(rid, {}).get('kind') or '(미분류)'
        rows.append({'rule_id': rid, 'kind': k, 'scope': r.get('scope', ''), 'detect_rules': r.get('rule_ids') or r.get('rule_id', ''), 'title': r.get('target', ''),
                     'requirement': (r.get('requirement') or '')[:400] + (f" | 라벨 대응 {'; '.join(alias[rid])}" if rid in alias else ''), 'phase': ';'.join(ph2),
                     'enforcers': txt or '(코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만)', 'declared_harness': decl, 'origin': r.get('origin', ''), 'decided_at': '',
                     'status': r.get('status', ''), 'source': 'confirmed_requirements.csv', 'integrity': integ})
    for r in rd('design_decisions.csv'):
        rid = r['dd_id']; ph, txt, n = enf(rid, ['JUDGE'])
        ok = (r.get('human_check') or '').startswith('확인')
        rows.append({'rule_id': rid, 'kind': kinds.get(rid, {}).get('kind') or 'TOBE_DIFF', 'scope': r.get('scope') or r.get('menu_id', ''), 'detect_rules': r.get('rule_ids', ''), 'title': r.get('target', '')[:120],
                     'requirement': f"AS-IS: {(r.get('asis') or '')[:150]} → TO-BE: {(r.get('tobe') or '')[:150]} · 사유 {(r.get('reason') or '')[:120]}", 'phase': ';'.join(ph),
                     'enforcers': 'judge.py(data: design_decisions.csv)' + (f';{txt}' if txt else ''), 'declared_harness': '', 'origin': f"{r.get('src')}#{r.get('no')} {r.get('gap_item', '')}",
                     'decided_at': r.get('decided_at', ''), 'status': r.get('human_check', '') or r.get('status', ''), 'source': 'design_decisions.csv',
                     'integrity': 'GEN_UNLINKED' if ok else 'PENDING(확인 전 — 판정에 적용 안 됨)'})
    for i, r in enumerate(rd('sp_replaced.csv'), 1):
        rows.append({'rule_id': f'SPR-{i:03d}', 'kind': 'TOBE_DIFF', 'scope': r.get('menu_id', ''), 'detect_rules': 'F4', 'title': r.get('asis_sp', ''), 'requirement': f"AS-IS SP {r.get('asis_sp')} → TO-BE 호출 {r.get('tobe_calls')} · {(r.get('reason') or '')[:200]}",
                     'phase': 'JUDGE', 'enforcers': 'judge.py(data: sp_replaced.csv)', 'declared_harness': '', 'origin': r.get('decided_by', ''), 'decided_at': r.get('decided_at', ''), 'status': '확정', 'source': 'sp_replaced.csv', 'integrity': 'GEN_UNLINKED'})
    for i, r in enumerate(rd('allowed_gaps.csv'), 1):
        rows.append({'rule_id': f'AG-{i:03d}', 'kind': 'TOBE_DIFF', 'scope': 'ALL', 'detect_rules': '', 'title': f"{r.get('kind')}: {(r.get('pattern') or '')[:80]}", 'requirement': (r.get('reason') or '')[:200],
                     'phase': 'FE_GEN;FE_GATE', 'enforcers': 'gen.js·check.js·gap.js(data: allowed_gaps.csv)', 'declared_harness': '', 'origin': '', 'decided_at': '', 'status': '확정', 'source': 'allowed_gaps.csv', 'integrity': 'OK'})
    known = {r['rule_id'] for r in rows}
    orphan = {k: v for k, v in hits.items() if k not in known}
    return rows, orphan, hits, nfiles


def report(rows, orphan, nfiles):
    def cnt(key, src=None):
        d = {}
        for r in rows:
            if src and r['source'] != src:
                continue
            d[r[key]] = d.get(r[key], 0) + 1
        return d
    cr = [r for r in rows if r['source'] == 'confirmed_requirements.csv']
    L = [f"# TO-BE 룰 원장 현황 — {time.strftime('%Y-%m-%d %H:%M:%S')}", '',
         f"- 룰 **{len(rows)}**건 = CR {len(cr)} · DD {sum(1 for r in rows if r['source'] == 'design_decisions.csv')} · SPR {sum(1 for r in rows if r['source'] == 'sp_replaced.csv')} · AG {sum(1 for r in rows if r['source'] == 'allowed_gaps.csv')} (코드 스캔 파일 {nfiles})",
         "- 출처: `tools/Harness/verify/tobe_rule_registry.py --build` 실측 · 원장 `tools/Harness/rules/tobe_rule_registry.csv`",
         "- 현재 원장은 통합 뷰다 — 판정·생성 도구는 아직 원천 CSV 를 읽는다(전환은 EN-11).", '',
         '## 종류', '', '| 종류 | 건수 |', '|---|---|'] + [f'| {k} | {v} |' for k, v in sorted(cnt('kind').items(), key=lambda x: -x[1])]
    L += ['', '## CR 무결성(강제 지점 실측)', '', '| 상태 | 건수 | 뜻 |', '|---|---|---|']
    mean = {'OK': '생성 단계 또는 하네스에 연결됨', 'GEN_UNLINKED': '코드에 룰 번호는 있으나 생성 단계 미연결(사후 검출만)', 'NO_ENFORCER': '코드 어디에도 룰 번호 없음 — ledger 의 산문 기대 행으로만 존재'}
    L += [f"| {k} | {v} | {mean.get(k, '')} |" for k, v in sorted(cnt('integrity', 'confirmed_requirements.csv').items(), key=lambda x: -x[1])]
    ph = {}
    for r in cr:
        for p in (r['phase'] or '').split(';'):
            if p:
                ph[p] = ph.get(p, 0) + 1
    L += ['', '## CR 이 실제로 나타나는 단계(한 룰이 여러 단계에 걸리면 각각 셈)', '', '| 단계 | CR 수 |', '|---|---|'] + [f'| {k} | {v} |' for k, v in sorted(ph.items(), key=lambda x: -x[1])]
    L += ['', f"## 코드에 있는데 원장에 없는 룰 번호 — {len(orphan)}건", '']
    L += [f"- `{k}` : " + ', '.join(f'{os.path.basename(f)}:{ln}' for f, ln in v[:4]) + (f' …(+{len(v) - 4})' if len(v) > 4 else '') for k, v in sorted(orphan.items())] or ['- 없음']
    hard = sorted(((r['rule_id'], r['enforcers']) for r in cr if 'judge.py' in r['enforcers']), key=lambda x: x[0])
    L += ['', f"## judge.py 에 번호로 박힌 CR — {len(hard)}종 (EN-11 에서 원장 구동으로 전환할 대상)", ''] + [f'- `{k}` : {v[:160]}' for k, v in hard]
    return '\n'.join(L) + '\n'


# ── 종류 분류(tobe_rule_kind.csv) + 사람이 읽는 취합 문서 2종 (2026-11-11 사용자 요청) ─────────────────────────────
KIND_FILE = os.path.join(RULES, 'tobe_rule_kind.csv')
MD_DIFF = os.path.join(ROOT, 'Doc', '_rules_consolidation', 'TOBE_RULES_DIFF.md')
MD_DEV = os.path.join(ROOT, 'Doc', '_rules_consolidation', 'TOBE_RULES_DEV.md')
# CR 문구에 'AS-IS 와 달라도 오류가 아니다' 를 직접 말하는 표현 — 이 표현이 있을 때만 TOBE_DIFF 로 자동 분류하고 그 표현을 근거로 남긴다
#   (2026-11-11 1차 결과 대조: '허용'·'대상 아님/제외' 는 요건 문장에도 쓰여 CR-040·CR-075 를 잘못 잡았다 → 차이를 직접 인정하는 표현만 남김.
#    판정 코드에 분기가 있다는 사실도 근거에서 뺌 — 요건을 검사하는 분기일 수 있다)
RX_DIFF = re.compile(r'오류 아님|오류가 아니|결함 아님|결함이 아니|달라도|다르더라도|정상이다')


def classify_kinds(rows):
    """tobe_rule_kind.csv 에 없는 CR 만 자동 분류해 추가한다(있는 행 = 사람이 정한 값 — 건드리지 않는다). 반환 {rule_id: row}"""
    cur = {r['rule_id']: r for r in rd('tobe_rule_kind.csv')}
    today = time.strftime('%Y-%m-%d'); added = 0
    for r in rows:
        if r['source'] != 'confirmed_requirements.csv' or r['rule_id'] in cur:
            continue
        m = RX_DIFF.search(r['requirement'])
        if m:
            kind, basis = 'TOBE_DIFF', f"문구 '{m.group(0)}'"
        else:
            kind, basis = 'TOBE_DEV', "문구에 '오류 아님' 표현 없음 — TO-BE 가 지켜야 할 요건"
        cur[r['rule_id']] = {'rule_id': r['rule_id'], 'kind': kind, 'by': '자동(문구 기준)', 'at': today, 'basis': basis}; added += 1
    with open(KIND_FILE + '.tmp', 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['rule_id', 'kind', 'by', 'at', 'basis']); w.writeheader()
        w.writerows(sorted(cur.values(), key=lambda x: x['rule_id']))
    os.replace(KIND_FILE + '.tmp', KIND_FILE)
    return cur, added


def _cell(s, n=260):
    return re.sub(r'\s+', ' ', str(s or '')).replace('|', '¦')[:n]


def _doc_head(p):
    """문서 첫 제목과 첫 설명 줄(결정적 추출 — 요약을 지어내지 않는다)"""
    try:
        lines = open(p, encoding='utf-8-sig', errors='replace').read().split('\n')
    except OSError:
        return '', ''
    title = next((l.lstrip('# ').strip() for l in lines if l.startswith('#')), '')
    desc = next((l.strip().lstrip('> ').strip() for l in lines if l.strip() and not l.startswith('#') and not l.startswith('---') and len(l.strip()) > 12), '')
    return title, desc


def memory_only_decisions():
    """메모리 파일 중 TO-BE 결정을 말하지만 CR/DD 번호가 없는 것 — 원장 미등록 후보(사용자 확인 대상)"""
    d = os.path.join(os.path.expanduser('~'), '.claude', 'projects', 'c--Projects-NSCM', 'memory')
    out = []
    for p in sorted(glob.glob(os.path.join(d, '*.md'))):
        b = os.path.basename(p)
        if not b.startswith('feedback_'):  # 사용자 지시·판정 기록만(진행 기록 project_* 는 룰이 아니다)
            continue
        t = open(p, encoding='utf-8', errors='replace').read()
        m = re.search(r'^description:\s*(.+)$', t, re.M)
        desc = m.group(1) if m else ''
        # 설명 줄이 TO-BE 룰임을 직접 말하는데 본문 어디에도 CR/DD 번호가 없는 것
        if re.search(r'TO-BE 룰|TO-BE RULE', desc) and not RX_ID.search(t):
            out.append((b, desc[:200]))
    return out


def write_docs(rows, kinds):
    now = time.strftime('%Y-%m-%d %H:%M:%S')
    kind_of = lambda r: (kinds.get(r['rule_id'], {}).get('kind') or r['kind'])
    cr = [r for r in rows if r['source'] == 'confirmed_requirements.csv']
    head = ["> **자동 생성 문서 — 직접 고치지 않는다.** 원천을 고친 뒤 `python tools/Harness/verify/tobe_rule_registry.py --build` 로 다시 만든다.",
            "> 원천: `tools/Harness/rules/confirmed_requirements.csv`(CR) · `design_decisions.csv`(DD) · `sp_replaced.csv` · `allowed_gaps.csv` · `label_alias.csv` · 종류 지정 `tobe_rule_kind.csv`",
            f"> 생성 {now} · 통합 원장 `tools/Harness/rules/tobe_rule_registry.csv`", '']
    # ── 1) AS-IS 와 달라도 오류 아님 ─────────────────────────────────────────
    diff_cr = [r for r in cr if kind_of(r) == 'TOBE_DIFF']
    dd = [r for r in rows if r['source'] == 'design_decisions.csv']
    L = ['# TO-BE 룰 — AS-IS 와 달라도 오류가 아닌 항목 (정합검증 예외 기준)', ''] + head
    L += [f"- 전 화면·영역 룰(CR) **{len(diff_cr)}**건 · 화면별 설계 결정(DD) **{len(dd)}**건 · SP 통합 대체 {sum(1 for r in rows if r['source'] == 'sp_replaced.csv')}건 · 생성 단계 허용 차이 {sum(1 for r in rows if r['source'] == 'allowed_gaps.csv')}건",
          "- 쓰임: 정합검증(CheckList)에서 이 표의 항목과 맞는 AS-IS↔TO-BE 차이는 FAIL 로 올리지 않는다. 새 판정이 나오면 원천 CSV 에 행을 추가하고 다시 생성한다.",
          "- '강제 지점' 열은 그 룰 번호가 실제로 나오는 코드 위치(실측)다. 비어 있으면 판정 코드에 아직 연결되지 않은 것이다.", '',
          '## 1. 전 화면·영역 룰 (CR)', '', '| 룰 | 범위 | 대상 | 내용 | 분류 근거 | 강제 지점(실측) | 출처 |', '|---|---|---|---|---|---|---|']
    for r in sorted(diff_cr, key=lambda x: x['rule_id']):
        k = kinds.get(r['rule_id'], {})
        L.append(f"| {r['rule_id']} | {_cell(r['scope'], 30)} | {_cell(r['title'], 60)} | {_cell(r['requirement'], 400)} | {_cell(k.get('basis'), 80)} ({_cell(k.get('by'), 20)}) | {_cell(r['enforcers'], 160)} | {_cell(r['origin'], 80)} |")
    L += ['', '## 2. 화면별 설계 결정 (DD) — AS-IS 기능을 TO-BE 에서 제외·변경하기로 한 결정', '']
    by_scr = {}
    for r in dd:
        by_scr.setdefault(r['scope'] or '(공통)', []).append(r)
    for scr in sorted(by_scr):
        L += [f'### {scr} ({len(by_scr[scr])}건)', '', '| 결정 | 검사 규칙 | 대상 | AS-IS → TO-BE · 사유 | 확인 상태 | 출처 |', '|---|---|---|---|---|---|']
        for r in sorted(by_scr[scr], key=lambda x: x['rule_id']):
            L.append(f"| {r['rule_id']} | {_cell(r['detect_rules'], 30)} | {_cell(r['title'], 80)} | {_cell(r['requirement'], 420)} | {_cell(r['status'], 60)} | {_cell(r['origin'], 50)} |")
        L.append('')
    L += ['## 3. SP 통합·대체', '', '| 룰 | 화면 | 내용 |', '|---|---|---|'] + [f"| {r['rule_id']} | {r['scope']} | {_cell(r['requirement'], 400)} |" for r in rows if r['source'] == 'sp_replaced.csv']
    L += ['', '## 4. 라벨 대응 (AS-IS 문구 ↔ TO-BE 문구)', '', '| 룰 | 범위 | 영역 | AS-IS | TO-BE | 비고 |', '|---|---|---|---|---|---|']
    L += [f"| {r.get('req_id')} | {r.get('scope')} | {_cell(r.get('area'), 40)} | {r.get('asis_label')} | {r.get('tobe_label')} | {_cell(r.get('note'), 200)} |" for r in rd('label_alias.csv')]
    L += ['', '## 5. 생성 단계 허용 차이 (AS-IS 컨트롤·패턴 중 TO-BE 에 옮기지 않는 것)', '', '| 룰 | 종류: 패턴 | 사유 |', '|---|---|---|']
    L += [f"| {r['rule_id']} | {_cell(r['title'], 120)} | {_cell(r['requirement'], 200)} |" for r in rows if r['source'] == 'allowed_gaps.csv']
    mem = memory_only_decisions()
    L += ['', f'## 6. 원장 미등록 후보 — 메모리에만 있는 TO-BE 결정 ({len(mem)}건 · 사용자 확인 뒤 CR 로 등록)', '']
    L += [f'- `{b}` — {_cell(d, 220)}' for b, d in mem] or ['- 없음']
    os.makedirs(os.path.dirname(MD_DIFF), exist_ok=True)
    open(MD_DIFF, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    # ── 2) TO-BE 개발 규칙 ────────────────────────────────────────────────
    dev_cr = [r for r in cr if kind_of(r) == 'TOBE_DEV']
    L = ['# TO-BE 개발 규칙 — 설계부터 소스 개발까지 지켜야 할 것', ''] + head
    hooks = sorted(glob.glob(os.path.join(ROOT, 'Doc', '_rules_v2', 'hooks', '*.md')))
    tobe_docs = sorted(glob.glob(os.path.join(ROOT, 'Doc', '_rules_v2', '_tobe', '*.md')))
    path_rules = sorted(glob.glob(os.path.join(ROOT, '.claude', 'rules', '*.md')))
    L += [f"- 확정 요건(CR) **{len(dev_cr)}**건 · 정밀 룰 문서 {len(tobe_docs)}개 · 작업 hook 문서 {len(hooks)}개 · 경로별 규약 {len(path_rules)}개",
          "- 이 문서는 **목록과 위치**를 한곳에 모은 것이다. 룰 본문은 각 원천 문서에 있고, 기계 판정 위치는 '강제 지점' 열(실측)과 §2 표에 있다.",
          "- '생성 연결' 열: 화면·PKG·메타 **생성 단계**에서 강제되면 OK, 사후 검증에서만 잡히면 GEN_UNLINKED, 코드에 룰 번호가 없으면 NO_ENFORCER.", '',
          '## 1. 확정 요건 (CR) — TO-BE 가 지켜야 할 동작', '', '| 룰 | 범위 | 대상 | 요건 | 검사 규칙 | 생성 연결 | 강제 지점(실측) | 출처 |', '|---|---|---|---|---|---|---|---|']
    for r in sorted(dev_cr, key=lambda x: x['rule_id']):
        L.append(f"| {r['rule_id']} | {_cell(r['scope'], 30)} | {_cell(r['title'], 60)} | {_cell(r['requirement'], 400)} | {_cell(r['detect_rules'], 30)} | {r['integrity']} | {_cell(r['enforcers'], 140)} | {_cell(r['origin'], 80)} |")
    tr = os.path.join(RULES, 'tobe_rules.md')
    if os.path.exists(tr):
        body = [l for l in open(tr, encoding='utf-8-sig').read().split('\n') if l.startswith('|')]
        L += ['', '## 2. 영역별 문서 룰 ↔ 기계 판정 위치 (`tools/Harness/rules/tobe_rules.md` 취합)', ''] + body
    L += ['', f'## 3. TO-BE 정밀 룰 문서 ({len(tobe_docs)}개 · `Doc/_rules_v2/_tobe/`)', '', '| 문서 | 제목 | 첫 설명 줄 |', '|---|---|---|']
    for p in tobe_docs:
        t, d = _doc_head(p); L.append(f"| `{os.path.basename(p)}` | {_cell(t, 80)} | {_cell(d, 160)} |")
    L += ['', f'## 4. 경로별 규약 ({len(path_rules)}개 · `.claude/rules/` — 해당 경로 파일을 만질 때 자동 로드)', '', '| 문서 | 제목 | 첫 설명 줄 |', '|---|---|---|']
    for p in path_rules:
        t, d = _doc_head(p); L.append(f"| `{os.path.basename(p)}` | {_cell(t, 80)} | {_cell(d, 160)} |")
    L += ['', f'## 5. 작업 hook 문서 ({len(hooks)}개 · `Doc/_rules_v2/hooks/`)', '', '| 문서 | 제목 | 첫 설명 줄 |', '|---|---|---|']
    for p in hooks:
        t, d = _doc_head(p); L.append(f"| `{os.path.basename(p)}` | {_cell(t, 90)} | {_cell(d, 170)} |")
    L += ['', '## 6. 실행 hook (저장·명령 시 자동 차단 — `.claude/hooks/`)', '']
    L += [f'- `{os.path.basename(p)}`' for p in sorted(glob.glob(os.path.join(ROOT, '.claude', 'hooks', '*.ps1')))] or ['- 없음']
    open(MD_DEV, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    return len(diff_cr), len(dev_cr), len(dd), len(mem), len(hooks)


def selftest():
    cases = [('judge', 'tools/Harness/verify/judge.py', 'JUDGE'), ('ledger', 'tools/Harness/verify/ledger.py', 'LEDGER'), ('정적 검사기', 'tools/Harness/verify/sort_check.py', 'STATIC'),
             ('FE 생성기', 'tools/Harness/gen.js', 'FE_GEN'), ('FE 게이트', 'tools/Harness/check.js', 'FE_GATE'), ('PKG 게이트', 'tools/Harness/check-pkg.js', 'SP_GATE'),
             ('PKG 생성기', 'tools/Harness/gen-pkg.js', 'SP_GEN'), ('메타 생성기', 'tools/Harness/gen-register-sql.js', 'META_GEN'), ('E2E', 'Doc/e2e/specs/_verify.spec.ts', 'E2E'),
             ('프롬프트', 'tools/Harness/prompts/new_screen.md', 'FE_GEN')]
    bad = 0
    for n, f, w in cases:
        g = phase_of(f); ok = g == w; bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n} → {g}{'' if ok else ' (기대 ' + w + ')'}")
    ids = sorted(set(RX_ID.findall("if 'CR-098' in ev or dd == 'DD-012': # CR-0981 XCR-001 CR-07")))
    ok = ids == ['CR-098', 'DD-012']; bad += 0 if ok else 1
    print(f"{'OK ' if ok else 'NG '} 룰 번호 추출 → {ids}")
    print(f"{len(cases) + 1 - bad}/{len(cases) + 1}")
    return 1 if bad else 0


def main():
    a = set(sys.argv[1:])
    if '--selftest' in a:
        return selftest()
    rows, orphan, hits, nfiles = build()
    if '--check' in a:
        print(f"[tobe_rule_registry] 룰 {len(rows)} · 코드에 있는데 원장에 없는 번호 {len(orphan)}: {', '.join(sorted(orphan))[:300]}")
        return 2 if orphan else 0
    kinds, added = classify_kinds(rows)
    for r in rows:
        if r['rule_id'] in kinds:
            r['kind'] = kinds[r['rule_id']]['kind']
    tmp = OUT + '.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(rows)
    os.replace(tmp, OUT)
    md = report(rows, orphan, nfiles)
    open(MD, 'w', encoding='utf-8').write(md)
    n_diff, n_dev, n_dd, n_mem, n_hooks = write_docs(rows, kinds)
    print(md)
    print(f"[tobe_rule_registry] 종류 자동 분류 신규 {added}건 → {os.path.relpath(KIND_FILE, ROOT)}")
    print(f"[tobe_rule_registry] 취합 문서: {os.path.relpath(MD_DIFF, ROOT)} (CR {n_diff} · DD {n_dd} · 메모리 미등록 후보 {n_mem}) / {os.path.relpath(MD_DEV, ROOT)} (CR {n_dev} · hook 문서 {n_hooks})")
    return 0


if __name__ == '__main__':
    sys.exit(main())
