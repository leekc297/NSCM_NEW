# -*- coding: utf-8 -*-
"""룰·hook·하네스 등록 정합 점검 (2026-11-13 전수 점검에서 상시 도구로 — 읽기 전용)

  python scripts/rules/inventory_check.py                 전체 점검 · 어긋남이 1건이라도 있으면 exit 1
  python scripts/rules/inventory_check.py --registry      도구 등록부 표(Markdown)를 표준 출력으로
  python scripts/rules/inventory_check.py --write-registry  tools/Harness/README.md 의 등록부 구간(TOOL-REGISTRY 표식 사이)을 다시 쓴다
  python scripts/rules/inventory_check.py --memory        메모리 색인 점검 포함(이 PC 의 ~/.claude/projects/C--Projects-NSCM/memory)

왜: 2026-10-12 재편 뒤 한 달 동안 도구·작업·hook 이 늘면서 문서 수치·카탈로그·감시 범위가 실제와 어긋났다
    (Doc/_rules_consolidation/2026-11-13_INVENTORY_정리안.md). 새 도구·hook 을 넣고 등록을 빠뜨리면 여기서 드러나게 한다.
점검(이름 = 출력의 항목 코드):
  HOOK_WIRING   .claude/settings.json 이 부르는 스크립트가 실재하는가
  HOOK_COUNT    문서 hook 디스크 수 = RULESET_MASTER 상단 = §4 헤더 = §4 표 행 수 = CLAUDE.md·hooks README 표기
  HOOK_CATALOG  hook 파일마다 RULESET_MASTER §4 표 · 00_INDEX · 00_CATEGORY_MAP · 30_HOOK_DISPOSITION 에 있는가
  ROUTER_REFS   TRIGGER_ROUTER 핵심 Hook 열의 이름이 파일로 있는가 · 추출본이 MASTER 와 같은가(build_router.py --check)
  VM_JSON       steps.json·quick.json 파싱 · 가리키는 script/path/prompt · 작업 id · 라벨이 실재하는가
  CHAIN_FILES   run_verify.py·eg_chain.py·prereq.py 가 부르는 도구 파일이 실재하는가
  GATE_SCOPE    run_verify.py 가 직접 부르는 Python 도구의 폴더가 engine_selfcheck PY_GLOBS 에 들어 있는가
  STAGE_WARN    run_verify.py 를 마지막으로 고친 뒤의 실행 로그에 '진행 표시' 경고(단계 예정 수 ≠ 실제)가 있는가
  REGISTRY      검증·실측 도구 파일이 전부 tools/Harness/README.md 도구 등록부에 올라 있는가(새 도구 등록 누락 방지)
  MEMORY        (--memory) 색인 깨진 링크 · 색인에 없는 메모리 파일
한계(추측으로 메우지 않음): 문서 본문끼리의 모순, 규칙의 검사 구현 여부(engine_audit.py), VM 메뉴의 실제 클릭 동작은 보지 않는다.
"""
import ast
import csv
import glob
import json
import os
import re
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BS = chr(92)
README = os.path.join(ROOT, 'tools', 'Harness', 'README.md')
BEGIN, END = '<!-- TOOL-REGISTRY:BEGIN -->', '<!-- TOOL-REGISTRY:END -->'
REG_GLOBS = ['tools/Harness/verify/*.py', 'tools/AsisLive/*.py', 'tools/AsisLive/*.ps1', 'tools/AsisLocal/*.py', 'tools/AsisLocal/*.cmd', 'tools/Docs/*.py', 'tools/DbConn/*.py',
             'tools/E2E/*.py', 'tools/E2E/*.js', 'tools/E2E/*.cmd', 'tools/Harness/*.js', 'scripts/rules/*.py', 'scripts/rules/*.ps1']
KNOWN_ROUTER_NONFILE = {'figma-mapping-check', 'call-proc', 'case-sensitive', 'wj-cell-editable', 'wj-cell-non-editable'}  # v1 hook 이름 1 + 코드 용어 4(hook 아님)
FAILS = []


def P(*a):
    return os.path.join(ROOT, *a)


def rd(p):
    try:
        with open(p, encoding='utf-8-sig', errors='replace') as f:
            return f.read()
    except OSError:
        return ''


def live(globs):
    out = []
    for g in globs:
        out += [os.path.relpath(p, ROOT).replace(BS, '/') for p in glob.glob(P(g)) if os.path.isfile(p) and '.bak' not in os.path.basename(p)]
    return sorted(set(out))


def report(code, ok, msg, items=()):
    print(f"[{'OK' if ok else '✗ '}] {code}: {msg}")
    for x in list(items)[:40]:
        print(f'       - {x}')
    if not ok:
        FAILS.append(code)


# ── hook ────────────────────────────────────────────────────────────────
def chk_hooks():
    st = rd(P('.claude', 'settings.json'))
    cmds = re.findall(r'-File\s+([^"\s]+\.ps1)', st)
    miss = [c for c in cmds if not os.path.exists(c)]
    report('HOOK_WIRING', not miss and bool(cmds), f'settings.json 연결 {len(cmds)} · 없는 스크립트 {len(miss)}', miss)

    H = sorted(os.path.splitext(os.path.basename(p))[0] for p in glob.glob(P('Doc', '_rules_v2', 'hooks', '*.md')))
    master = rd(P('Doc', '_rules_consolidation', 'RULESET_MASTER.md'))
    m1 = re.search(r'hook 총수 = \*\*(\d+)\*\*', master)
    m2 = re.search(r'## §4\. Hook 카탈로그 \(전체 (\d+)', master)
    s4 = master[master.find('## §4.'):]
    s4 = s4[:s4.find('\n## §5')] if '\n## §5' in s4 else s4
    rows = [l for l in s4.splitlines() if re.match(r'^\|\s*\d+\s*\|', l)]
    row_names = {re.sub(r'[`*⭐ ]', '', l.split('|')[2]).split('(')[0].strip() for l in rows}
    nums = [int(re.match(r'^\|\s*(\d+)\s*\|', l).group(1)) for l in rows]
    claude = re.search(r'hook 한 줄 요약 (\d+)종', rd(P('CLAUDE.md')))
    readme = re.search(r'문서 hook \*\*(\d+)종\*\*', rd(P('.claude', 'hooks', 'README.md')))
    vals = {'디스크': len(H), 'MASTER 상단': int(m1.group(1)) if m1 else -1, 'MASTER §4 헤더': int(m2.group(1)) if m2 else -1, 'MASTER §4 표 행': len(rows),
            'CLAUDE.md §3': int(claude.group(1)) if claude else -1, 'hooks README': int(readme.group(1)) if readme else -1}
    dup = sorted({n for n in nums if nums.count(n) > 1})
    report('HOOK_COUNT', len(set(vals.values())) == 1 and not dup, ' · '.join(f'{k} {v}' for k, v in vals.items()) + (f' · 중복 번호 {dup}' if dup else ''))

    def has(text, h):
        return re.search(r'(?<![A-Za-z0-9_\-])' + re.escape(h) + r'(?![A-Za-z0-9_\-])', text) is not None
    idx = rd(P('Doc', '_rules_v2', '00_INDEX.md'))
    cat = rd(P('Doc', '_rules_v2', '_categories', '00_CATEGORY_MAP.md'))
    disp = set()
    try:
        with open(P('tools', 'VibeManager', 'rules', '30_HOOK_DISPOSITION.csv'), encoding='utf-8-sig') as f:
            disp = {r[1] for r in csv.reader(f) if len(r) > 1}
    except OSError:
        pass
    miss = [f'{h} — ' + ' · '.join(w for w, ok in (('§4 표', h in row_names), ('00_INDEX', has(idx, h)), ('CATEGORY_MAP', has(cat, h)), ('DISPOSITION', h in disp)) if not ok)
            for h in H if not (h in row_names and has(idx, h) and has(cat, h) and h in disp)]
    extra = sorted(row_names - set(H))
    report('HOOK_CATALOG', not miss and not extra, f'hook {len(H)} · 어느 한 곳이라도 미등재 {len(miss)} · 표에만 있고 파일 없는 이름 {len(extra)}', miss + [f'(파일 없음) {x}' for x in extra])

    rt = rd(P('Doc', '_rules_consolidation', 'TRIGGER_ROUTER.md'))
    toks = set()
    for l in rt.splitlines():
        if l.startswith('| **T') and len(l.split('|')) > 4:
            toks |= set(re.findall(r'(?<![A-Za-z0-9_/\.\-])[a-z][a-z0-9]+(?:-[a-z0-9]+)+(?![A-Za-z0-9_\-])', l.split('|')[4]))
    bad = sorted(t for t in toks if t not in H and t not in KNOWN_ROUTER_NONFILE)
    r = subprocess.run([sys.executable, P('scripts', 'rules', 'build_router.py'), '--check'], capture_output=True, text=True, encoding='utf-8', errors='replace', cwd=ROOT)
    report('ROUTER_REFS', not bad and r.returncode == 0, f'핵심 Hook 열 이름 {len(toks)} · 파일 없는 것 {len(bad)} · build_router --check rc {r.returncode}', bad + ([(r.stdout or r.stderr).strip()[-200:]] if r.returncode else []))


# ── VM ──────────────────────────────────────────────────────────────────
def vm_vars():
    return {'root': ROOT, 'toolsDir': P('tools', 'AsisFacts'), 'harnessDir': P('tools', 'Harness'), 'outDir': P('Doc', 'asisfacts'), 'tobeDir': P('nscm-fe'), 'tobeOutDir': P('Doc', 'tobefacts'),
            'rulesDir': P('tools', 'Harness', 'rules'), 'gapDir': P('Doc', 'gap'), 'genDir': P('Doc', 'gen'), 'vibeDir': P('.vibe'), 'promptsDir': P('tools', 'Harness', 'prompts'),
            'dbconnDir': P('tools', 'DbConn'), 'reconDir': P('tools', 'Recon'), 'e2eDir': P('tools', 'E2E'), 'dbOutDir': P('Doc', 'db'), 'reconOutDir': P('Doc', 'recon'),
            'e2eOutDir': P('Doc', 'e2e'), 'goldenDir': P('Doc', 'golden'), 'extDir': P('tools', 'VibeManager')}


def load_vm():
    S = json.load(open(P('tools', 'VibeManager', 'steps.json'), encoding='utf-8-sig'))
    Q = json.load(open(P('tools', 'VibeManager', 'quick.json'), encoding='utf-8-sig'))
    return S, Q


def chk_vm():
    try:
        S, Q = load_vm()
    except (OSError, ValueError) as e:
        report('VM_JSON', False, f'steps.json/quick.json 읽기·파싱 실패 — {str(e)[:150]}')
        return
    V = vm_vars()

    def sub(s):
        return re.sub(r'\$\{([^}]+)\}', lambda m: V.get(m.group(1), m.group(0)), s).replace(BS, '/')
    tasks, bad = {}, []
    for s in S['steps']:
        for t in s['tasks']:
            if t['id'] in tasks:
                bad.append(f"중복 작업 id {t['id']}")
            tasks[t['id']] = t
    for tid, t in tasks.items():
        for key in ('script', 'path'):
            if key in t:
                p = sub(t[key])
                p = p.split('${')[0].rstrip('/') if '${' in p else p
                if not os.path.exists(p):
                    bad.append(f'{tid} {key} 없음: {t[key]}')
        if t.get('kind') == 'claude' and not os.path.exists(os.path.join(V['promptsDir'], t.get('prompt', ''))):
            bad.append(f"{tid} prompt 없음: {t.get('prompt')}")
    items = [it for g in Q['groups'] for it in g['items']]
    labels = [it['label'] for it in items]
    nchain = 0
    for it in items:
        k = it.get('kind')
        if k == 'task' and it.get('task') not in tasks:
            bad.append(f"메뉴 '{it['label'][:30]}' 작업 없음: {it.get('task')}")
        if k == 'chain':
            nchain += 1
            for st in it.get('steps', []):
                if 'task' in st and st['task'] not in tasks:
                    bad.append(f"체인 {it.get('chainId')} 작업 없음: {st['task']}")
                for co in (st.get('claudeOf'), (st.get('repair') or {}).get('claudeOf')):
                    if co and not any(l.startswith(co) for l in labels):
                        bad.append(f"체인 {it.get('chainId')} claudeOf 라벨 없음: {co}")
        if k == 'multi':
            bad += [f"묶음 '{it['label'][:30]}' 항목 없음: {l}" for l in it.get('items', []) if not any(x.startswith(l) for x in labels)]
        if k in ('open', 'browser') and it.get('path'):
            p = sub(it['path'])
            if '${' not in p and not os.path.exists(p):
                bad.append(f"메뉴 '{it['label'][:30]}' 경로 없음: {it['path']}")
    report('VM_JSON', not bad, f"단계 {len(S['steps'])} · 작업 {len(tasks)} · 메뉴 항목 {len(items)} · 체인 {nchain} · 깨진 참조 {len(bad)}", bad)


# ── 체인 ────────────────────────────────────────────────────────────────
def chain_stages():
    """run_verify.py 를 줄 단위로 읽어 도구 파일명 → 단계 목록."""
    out = {}
    cur = ''
    for l in rd(P('tools', 'Harness', 'verify', 'run_verify.py')).splitlines():
        if l.lstrip().startswith('#'):
            continue
        m = re.search(r"\bstage\('(\w+)'", l)
        if m:
            cur = m.group(1)
        if cur and re.search(r'\brun\(|\bsub\(|for s in \(', l):
            for b in re.findall(r"'([A-Za-z0-9_\-]+\.(?:py|js|cmd))'", l.split('  # ')[0]):
                out.setdefault(b, [])
                if cur not in out[b]:
                    out[b].append(cur)
    return out


def chk_chain():
    V = P('tools', 'Harness', 'verify')
    names = {}
    for base in ('tools', 'scripts', os.path.join('Doc', 'e2e', 'specs')):
        for dp, dn, fn in os.walk(P(base)):
            if 'node_modules' in dp or '__pycache__' in dp:
                dn[:] = []
                continue
            for f in fn:
                names.setdefault(f, dp)
    bad, n = [], 0
    for src in ('run_verify.py', 'eg_chain.py', 'prereq.py'):
        for i, l in enumerate(rd(os.path.join(V, src)).splitlines(), 1):
            if l.lstrip().startswith('#'):
                continue
            for b in re.findall(r"'([A-Za-z0-9_\-]+\.(?:py|js|cmd|ps1))'", l.split('  # ')[0]):
                if b == 'cli.js':
                    continue
                n += 1
                if b not in names:
                    bad.append(f'{src}:{i} {b}')
    report('CHAIN_FILES', not bad, f'체인 3개 파일의 도구 참조 {n} · 없는 파일 {len(bad)}', bad)

    rv = rd(os.path.join(V, 'run_verify.py'))
    dirs = {'tools/Harness/verify'}
    for m in re.finditer(r"os\.path\.join\(ROOT, ((?:'[^']+', )+)'([A-Za-z0-9_\-]+\.py)'\)", rv):
        dirs.add('/'.join(re.findall(r"'([^']+)'", m.group(1))))
    sc = rd(os.path.join(V, 'engine_selfcheck.py'))
    mg = re.search(r'PY_GLOBS = \[([\s\S]*?)\]', sc)
    globs = re.findall(r"'([^']+)/\*\.py'", mg.group(1)) if mg else []
    out = sorted(d for d in dirs if d not in globs)
    report('GATE_SCOPE', not out, f"run_verify 가 직접 부르는 Python 폴더 {sorted(dirs)} · 변경 게이트 감시 밖 {len(out)}", out)

    mt = os.path.getmtime(os.path.join(V, 'run_verify.py'))
    warn, nlog = {}, 0
    for p in glob.glob(P('.vibe', 'logs', '*CheckList*.log')):  # CheckList 실행 로그만 — 서버 기동 로그는 수 GB 라 통째로 읽으면 메모리 오류
        if os.path.getmtime(p) < mt:
            continue
        nlog += 1
        try:
            with open(p, encoding='utf-8', errors='replace') as f:
                for l in f:
                    if '진행 표시 — 단계' in l:
                        k = l.strip()[:90]
                        warn[k] = warn.get(k, 0) + 1
        except OSError:
            continue
    report('STAGE_WARN', not warn, f"run_verify.py 수정({time.strftime('%m-%d %H:%M', time.localtime(mt))}) 뒤 로그 {nlog}개 · 단계 예정 수 경고 {sum(warn.values())}줄"
           + ('' if nlog else ' (그 뒤 실행 로그 없음 = 미측정)'), [f'{v}회 {k}' for k, v in warn.items()])


# ── 도구 등록부 ─────────────────────────────────────────────────────────
def docline(p):
    src = rd(P(p))
    d = ''
    if p.endswith('.py'):
        try:
            d = ast.get_docstring(ast.parse(src)) or ''
        except SyntaxError:
            d = ''
    if not d:
        for l in src.splitlines()[:12]:
            s = l.strip().lstrip('#/*@remREM: ').strip()
            if len(s) > 12 and not s.lower().startswith(('!', 'coding', '-*-', 'echo', 'import', 'const', "'use", 'for ', 'chcp', 'set ', 'setlocal', 'param', '$', 'cd ')):
                d = s
                break
    d = next((x.strip() for x in d.splitlines() if x.strip()), '')
    return d.replace('|', '/')[:150]


def registry_rows():
    stages = chain_stages()
    V = P('tools', 'Harness', 'verify')
    egc, pre = rd(os.path.join(V, 'eg_chain.py')), rd(os.path.join(V, 'prereq.py'))
    try:
        S, Q = load_vm()
    except (OSError, ValueError):
        S, Q = {'steps': []}, {'groups': []}
    by_script = {}
    for s in S['steps']:
        for t in s['tasks']:
            if t.get('script'):
                by_script.setdefault(os.path.basename(t['script'].replace(BS, '/')), []).append(t['id'])
    files = live(REG_GLOBS)
    code = {p: rd(P(p)) for p in live(REG_GLOBS + ['tools/E2E/lib/*', 'tools/E2E/fixtures/*', 'Doc/e2e/specs/_*.spec.ts', 'Doc/e2e/specs/eg_*.spec.ts', '.claude/hooks/*.ps1',
                                                    'tools/VibeManager/*.js', 'tools/Harness/hooks/*.ps1', 'tools/CloudPkg/*.py', 'tools/Analysis/*.py', 'tools/AsisFacts/*.ps1', 'tools/Harness/*.ps1'])}
    # 코드 파일마다 import 한 모듈 이름을 한 번만 뽑아 둔다(도구 수 × 코드 수만큼 정규식을 돌리면 2분을 넘긴다)
    imports = {q: set(re.findall(r'^\s*(?:import|from)\s+([A-Za-z_][A-Za-z0-9_]*)', c, flags=re.M)) if q.endswith('.py') else set() for q, c in code.items()}
    rows = []
    for p in files:
        b = os.path.basename(p)
        stem = os.path.splitext(b)[0]
        ent = []
        if b in stages and p.startswith(('tools/Harness/verify/', 'tools/AsisLive/', 'tools/DbConn/', 'tools/E2E/')):
            ent.append('체인 ' + '·'.join(stages[b]))
        if b == 'run_verify.py':
            ent.append('체인 진입점')
        if p.startswith('tools/Harness/verify/') and f"'{b}'" in egc and b != 'eg_chain.py':
            ent.append('체인 eg(eg_chain 안)')
        if f"'{b}'" in pre and b != 'prereq.py':
            ent.append('체인 pre(prereq 안)')
        if b in by_script:
            ent.append('VM ' + '·'.join(by_script[b][:4]) + (f' 외 {len(by_script[b]) - 4}' if len(by_script[b]) > 4 else ''))
        if not ent:
            refs = []
            for q, c in code.items():
                if q == p:
                    continue
                if b in c or (p.endswith('.py') and stem in imports[q]):
                    refs.append(os.path.basename(q))
            ent.append('다른 도구가 사용: ' + ', '.join(sorted(set(refs))[:3]) + (f' 외 {len(set(refs)) - 3}' if len(set(refs)) > 3 else '') if refs else '손 실행(진입점 연결 없음)')
        rows.append((p, ' / '.join(ent), docline(p)))
    return rows


def registry_md():
    rows = registry_rows()
    out = [BEGIN, f"> 자동 생성 — `python scripts/rules/inventory_check.py --write-registry` ({time.strftime('%Y-%m-%d %H:%M')} · 도구 {len(rows)}개 · 손 실행 {sum(1 for r in rows if r[1].startswith('손 실행'))}개). 직접 고치지 말고 다시 생성한다.",
           '> 진입 열: `체인 <단계>` = `run_verify.py`(CheckList) 가 그 단계에서 실행 · `VM <작업 id>` = `tools/VibeManager/steps.json` 작업 · `다른 도구가 사용` = import·호출만 · `손 실행` = 어떤 진입점에도 연결 없음(명령줄에서 직접).', '']
    cur = None
    for p, ent, d in rows:
        folder = os.path.dirname(p)
        if folder != cur:
            cur = folder
            out += ['', f'### `{folder}/`', '', '| 도구 | 진입 | 머리말 첫 줄 |', '|---|---|---|']
        out.append(f'| `{os.path.basename(p)}` | {ent} | {d} |')
    out += ['', END]
    return '\n'.join(out)


def chk_registry():
    t = rd(README)
    if BEGIN not in t or END not in t:
        report('REGISTRY', False, 'tools/Harness/README.md 에 도구 등록부 구간이 없음 — --write-registry 로 만든다')
        return
    seg = t[t.index(BEGIN):t.index(END)]
    listed, cur = set(), ''
    for l in seg.splitlines():
        m = re.match(r'^### `([^`]+)/`', l)
        if m:
            cur = m.group(1)
        m = re.match(r'^\| `([^`]+)` \|', l)
        if m and cur:
            listed.add(cur + '/' + m.group(1))
    files = set(live(REG_GLOBS))
    miss, gone = sorted(files - listed), sorted(listed - files)
    report('REGISTRY', not miss and not gone, f'도구 {len(files)} · 등록부에 없는 도구 {len(miss)} · 등록부에만 있고 파일 없는 것 {len(gone)}'
           + (' → --write-registry 로 갱신' if miss or gone else ''), [f'(미등록) {x}' for x in miss] + [f'(파일 없음) {x}' for x in gone])


def write_registry():
    md = registry_md()
    raw = open(README, 'rb').read()
    bom = raw.startswith(b'\xef\xbb\xbf')
    t = raw.decode('utf-8-sig')
    crlf = '\r\n' in t
    t = t.replace('\r\n', '\n')
    if BEGIN in t and END in t:
        t = t[:t.index(BEGIN)] + md + t[t.index(END) + len(END):]
    else:
        print('[중단] README 에 등록부 표식이 없다 — 표식 2줄을 먼저 넣는다:', BEGIN, END)
        return 1
    if crlf:
        t = t.replace('\n', '\r\n')
    # 임시 파일에 다 쓴 뒤 바꿔치기 — 제자리 덮어쓰기는 잘림(truncate)이 거부되면 끝에 옛 내용이 남는다(2026-11-13 15:18 실제 발생)
    tmp = README + '.tmp_inv'
    with open(tmp, 'wb') as f:
        f.write((b'\xef\xbb\xbf' if bom else b'') + t.encode('utf-8'))
    for _i in range(5):
        try:
            os.replace(tmp, README)
            break
        except PermissionError:
            time.sleep(1)
    else:
        print('[오류] README 를 바꿔 쓰지 못함(다른 프로그램이 잡고 있음) — 새 내용은', os.path.relpath(tmp, ROOT), '에 있다')
        return 1
    print(f'등록부 갱신 → {os.path.relpath(README, ROOT)}')
    return 0


# ── 메모리 ──────────────────────────────────────────────────────────────
def chk_memory():
    M = os.path.join(os.path.expanduser('~'), '.claude', 'projects', 'C--Projects-NSCM', 'memory')
    if not os.path.isdir(M):
        report('MEMORY', False, f'메모리 폴더 없음(미측정): {M}')
        return
    files = {os.path.basename(p) for p in glob.glob(os.path.join(M, '*.md'))}
    links = {}
    for idx in ('MEMORY.md', '_index_bundles.md'):
        links[idx] = re.findall(r'\]\(([^)]+\.md)\)', rd(os.path.join(M, idx)))
    allidx = set(links['MEMORY.md']) | set(links['_index_bundles.md']) | {'MEMORY.md', '_index_bundles.md'}
    broken = sorted(x for x in allidx if not os.path.exists(os.path.join(M, x)))
    orphan = sorted(files - allidx)
    report('MEMORY', not broken and not orphan, f"메모리 파일 {len(files)} · MEMORY.md 링크 {len(set(links['MEMORY.md']))} · 묶음 색인 링크 {len(set(links['_index_bundles.md']))} · 깨진 링크 {len(broken)} · 색인에 없는 파일 {len(orphan)}",
           [f'(깨짐) {x}' for x in broken] + [f'(미색인) {x}' for x in orphan])


def main():
    a = sys.argv[1:]
    if '--registry' in a:
        sys.stdout.buffer.write((registry_md() + '\n').encode('utf-8'))
        return 0
    if '--write-registry' in a:
        return write_registry()
    print(f"== 룰·hook·하네스 등록 정합 점검 · {time.strftime('%Y-%m-%d %H:%M:%S')} ==")
    chk_hooks()
    chk_vm()
    chk_chain()
    chk_registry()
    if '--memory' in a:
        chk_memory()
    print(f"== {'FAIL — ' + ' · '.join(FAILS) if FAILS else 'PASS'} ==")
    return 1 if FAILS else 0


if __name__ == '__main__':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass
    sys.exit(main())
