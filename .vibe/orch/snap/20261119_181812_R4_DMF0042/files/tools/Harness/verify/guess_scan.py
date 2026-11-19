# -*- coding: utf-8 -*-
"""추측 지점 원장(2026-11-11 · 플랜 §1) — 도구·체인이 '실행해서 재지 않고' 추정·근사·이름 규칙·LLM 서술로 결론을 내는 지점을 전수 목록으로 관리한다.

  python tools/Harness/verify/guess_scan.py --update     스캔 → Doc/verify/_guess_registry.csv 갱신(손으로 채운 열 보존) + _guess_registry.md 요약
  python tools/Harness/verify/guess_scan.py --report     현황만 출력(단계×상태 · 엔진별 · 분모·분자)
  python tools/Harness/verify/guess_scan.py --check      스캔에 있는데 원장에 없는 지점이 있으면 exit 2(경고 게이트)
  python tools/Harness/verify/guess_scan.py --selftest

검출 종류(kind):
  MARKER   주석·문구의 추정 표식(추정·근사·한계·폴백·겹침·fallback·guess …) — '추정 금지' 같은 부정 문맥은 뺀다
  FUNC     추정 함수·상수(guess*, match_tobe, isHist, SIMILAR_*, GENERIC_TOKENS, RX_TOOLFAIL, RX_ABSENT, BACKSTOP, feature_present)
  NAMERULE 이름 정규식으로 종류를 가르는 지점(SAVE|INS|UPD|DEL · _H$|_HIST · _GET_)
  LLM      LLM 이 산출물을 쓰는 지점(claude -p · VM claude 메뉴 · agent 프롬프트)
  RELAX    판정 완화 지점(판정필요→NA · trial 보류 · W7 수동 검수)
  MANUAL   조사로 확인해 손으로 올린 지점(스캔이 지우지 않는다)
열: guess_id(파일+정규화 문구 해시 — 줄이 밀려도 유지), stage, kind, file, line, text, what(무엇을 추측하는가), grade, impact, engine, status, note, first_seen, last_seen
  status: open(대체 엔진 없음) · engine-built(엔진 있음·미입증) · proven(실측으로 대체 입증) · accepted-limit(사용자 승인 한계) · user-confirm(사용자 확인 대기) · gone(코드에서 사라짐) · dismissed(검토 결과 추측 지점 아님 — 사유를 note 에)
한계: 표식도 이름도 없는 추정(예: 임계값 비교만 있는 코드)은 스캔으로 못 찾는다 — 발견되면 MANUAL 로 올린다. 그래서 '스캔 0 = 추측 0' 이 아니다.
"""
import csv
import glob
import hashlib
import json
import os
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
REG = os.path.join(ROOT, 'Doc', 'verify', '_guess_registry.csv')
MD = os.path.join(ROOT, 'Doc', 'verify', '_guess_registry.md')
COLS = ['guess_id', 'stage', 'kind', 'file', 'line', 'text', 'what', 'grade', 'impact', 'engine', 'status', 'note', 'first_seen', 'last_seen']
KEEP = ['what', 'grade', 'impact', 'engine', 'status', 'note', 'first_seen']  # 스캔이 덮어쓰지 않는 열

GLOBS = ['tools/Harness/*.js', 'tools/Harness/lib/*.js', 'tools/Harness/*.ps1', 'tools/Harness/prompts/*.md', 'tools/Harness/verify/*.py',
         'tools/E2E/*.js', 'tools/E2E/lib/*.ts', 'tools/E2E/fixtures/*.ts', 'tools/DbConn/*.py', 'tools/AsisFacts/src/*.cs', 'tools/AsisFacts/*.ps1',
         'tools/VibeManager/*.json', 'tools/VibeManager/*.js', 'Doc/e2e/specs/_*.spec.ts', 'Doc/e2e/specs/eg_*.spec.ts', 'Doc/_analysis/scripts/*.py']
SKIP_FILE = re.compile(r'\.bak|selftest|_debug|guess_scan\.py$|engine_selfcheck\.py$')

RX_MARK = re.compile(r'추정|추측|근사|한계\s*[:：(]|폴백|휴리스틱|heuristic|guess|이름 관례|명명 규칙|겹침|어림|fallback|approx|판단\s*불가|미대응|유사|similar', re.I)
RX_LIMIT = re.compile(r'한계\s*[:：(]|판단\s*불가|미대응|폴백|fallback', re.I)
RX_NEG = re.compile(r'금지|않는다|않음|하지 않|아님|폐기|제거|없이|말 것|대신')
RX_FUNC = re.compile(r'\b(guess\w*|match_tobe|isHist|SIMILAR_\w+|GENERIC_TOKENS|RX_TOOLFAIL|RX_ABSENT|BACKSTOP\w*|feature_present)\b\s*(?:=|\(|:)')
RX_FUNC_DEF = re.compile(r'(?:def|function|const|let|var)\s+(guess\w*|match_tobe|isHist|feature_present)\b|^\s*(SIMILAR_\w+|GENERIC_TOKENS|RX_TOOLFAIL|RX_ABSENT|BACKSTOP\w*)\s*=')
RX_NAMERULE = re.compile(r"""(?:re\.(?:search|match|compile)\(|new RegExp\(|/)[^\n]{0,40}(?:SAVE\|[^\n]{0,30}(?:INS|UPD)|_H\$\||_HIST|\(\?i\)_?GET_)""")
RX_LLM = re.compile(r"claude\s+-p|['\"]claude['\"]\s*,|spawn\w*\(\s*['\"]claude|_prompt\.txt")
RX_LLM_JSON = re.compile(r'"(?:prompt|claude)"\s*:\s*"')  # VM 메뉴 정의(json)의 claude 프롬프트 — 코드의 showInputBox({ prompt }) 는 LLM 호출이 아니다
RX_COMMENT_ONLY = re.compile(r'^\s*(#|//|\*|/\*|<!--)')
RX_RELAX = re.compile(r"판정필요[^\n]{0,30}(?:NA|해당없음)|수동 검수 대상\(작업 원장 W7\)|status\W{1,6}trial|FAIL 승격 전")


def stage_of(rel, text=''):
    r = rel.lower()
    if 'vibemanager' in r:
        return 'VM'
    if 'asisfacts' in r:
        return 'DOC' if re.search(r'agent', r) else 'PARSE'
    if '_analysis/scripts' in r:
        return 'DOC'
    if 'dbconn' in r:
        return 'META' if 'meta_apply' in r else 'SP_GEN'
    if '/verify/' in r:
        b = os.path.basename(r)
        if re.match(r'(facts_|asis_|crosscheck|gen_expect|ledger)', b):
            return 'PARSE'
        if re.match(r'repair', b):
            return 'REPAIR'
        return 'VERIFY'
    if 'tools/harness' in r:
        b = os.path.basename(r)
        if re.search(r'pkg', b):
            return 'SP_GEN'
        if re.search(r'register', b):
            return 'META'
        if re.search(r'repair', b):
            return 'REPAIR'
        return 'FE_GEN'
    return 'VERIFY'


# 파일 → 대체 엔진 기본 대응(플랜 §2 · 원장에서 손으로 바꾸면 그 값이 유지된다)
ENGINE_MAP = [
    (r'verify/(facts_|asis_)', 'EN-06'), (r'verify/crosscheck', 'EN-10'), (r'AsisFacts/src/Agent', 'EN-18'), (r'AsisFacts/', 'EN-06'), (r'_analysis/scripts', 'EN-09'),
    (r'Harness/gen-pkg', 'EN-08·EN-20'), (r'Harness/check-pkg', 'EN-05'), (r'DbConn/(golden|gen_golden)', 'EN-02'), (r'Harness/gen-register', 'EN-03·EN-17'),
    (r'Harness/(gen|templates|mine)', 'EN-20'), (r'Harness/check\.js', 'EN-04'), (r'Harness/(repair|lib/repair)', 'EN-01'), (r'verify/repair', 'EN-01·EN-19'),
    (r'verify/(a1_live|g2_asis|mapping_trace)', 'EN-14'), (r'verify/(sort_check|f10_check|sp_|facts_append)', 'EN-08'), (r'verify/align_check', 'EN-07·EN-13'),
    (r'verify/judge', 'EN-11·EN-12'), (r'lib/(sheetid|probe)', 'EN-13'), (r'lib/savecheck', 'EN-08'), (r'verify/(combo_|lookup_|display_sort)', 'EN-17'),
    (r'VibeManager/', 'EN-01·EN-05·EN-18'), (r'specs/_', 'EN-11·EN-13'),
    (r'popup', 'EN-14'), (r'verify/(make_verify_docs|timing_report|engine_gap_cluster|impl_engine|decisions|weaken_check)', 'EN-21'),
    (r'verify/i18n_', 'EN-17'), (r'verify/(measure_sweep|master_sweep|gen_param_map|gen_cleanup_spec|b7_check)', 'EN-08'),
    (r'verify/(ledger|applicability|coverage)', 'EN-06'), (r'verify/diff_verify', 'EN-14'), (r'verify/snap_', 'EN-07'), (r'verify/run_verify', 'EN-00'),
    (r'verify/eg_ingest', 'EN-11'), (r'E2E/(lib|fixtures)/', 'EN-11'), (r'Harness/(e2e-judge|gap)\.js', 'EN-11'),
]


def engine_of(rel):
    for rx, e in ENGINE_MAP:
        if re.search(rx, rel, re.I):
            return e
    return ''


def norm(text):
    return re.sub(r'\s+', ' ', re.sub(r'\d{2,}', '#', text)).strip()[:160]


def gid(rel, kind, text):
    return 'G-' + hashlib.sha1(f'{rel}|{kind}|{norm(text)}'.encode('utf-8')).hexdigest()[:8]


def classify(line, is_json=False):
    """한 줄 → [(kind, 일치 문구)] — 여러 종류가 겹치면 모두"""
    out = []
    code = not RX_COMMENT_ONLY.search(line)  # NAMERULE·RELAX 는 실행 코드 줄만 — 과거 결함을 설명하는 주석 줄은 뺀다
    m = RX_FUNC_DEF.search(line)
    if m:
        out.append(('FUNC', m.group(0).strip()))
    m = RX_NAMERULE.search(line) if code else None
    if m:
        out.append(('NAMERULE', m.group(0).strip()[:60]))
    m = (RX_LLM_JSON if is_json else RX_LLM).search(line)
    if m:
        out.append(('LLM', m.group(0).strip()))
    m = RX_RELAX.search(line) if code else None
    if m:
        out.append(('RELAX', m.group(0).strip()))
    if not out:
        # 한계 표식(한계·판단불가·미대응·폴백)은 '추측하지 않고 남긴 미측정 지점' 이라 부정 문맥이어도 올린다. 추정 표식만 '추정 금지/쓰지 않는다' 문맥을 뺀다
        m = RX_LIMIT.search(line)
        if m:
            out.append(('MARKER', m.group(0).strip()))
        else:
            m = RX_MARK.search(line)
            if m and not RX_NEG.search(line[max(0, m.start() - 25):m.end() + 25]):
                out.append(('MARKER', m.group(0).strip()))
    return out


def scan():
    rows = {}
    files = []
    for g in GLOBS:
        files += [p for p in glob.glob(os.path.join(ROOT, g)) if os.path.isfile(p) and not SKIP_FILE.search(os.path.basename(p))]
    for p in sorted(set(files)):
        rel = os.path.relpath(p, ROOT).replace(os.sep, '/')
        try:
            lines = open(p, encoding='utf-8-sig', errors='replace').read().split('\n')
        except OSError:
            continue
        for i, l in enumerate(lines, 1):
            if len(l) > 6000:
                l = l[:6000]
            for kind, hit in classify(l, rel.endswith('.json')):
                j = max(0, l.find(hit) - 60)
                text = re.sub(r'\s+', ' ', l[j:j + 220]).strip()
                k = gid(rel, kind, text)
                if k not in rows:
                    rows[k] = {'guess_id': k, 'stage': stage_of(rel, l), 'kind': kind, 'file': rel, 'line': str(i), 'text': text}
    return rows, len(set(files))


def load_seed():
    p = os.path.join(HERE, 'guess_seed.csv')
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return [r for r in csv.DictReader(f) if (r.get('what') or '').strip()]


def load():
    if not os.path.exists(REG):
        return {}
    with open(REG, encoding='utf-8-sig', newline='') as f:
        return {r['guess_id']: r for r in csv.DictReader(f)}


def save(reg):
    order = {'PARSE': 0, 'DOC': 1, 'FE_GEN': 2, 'SP_GEN': 3, 'META': 4, 'VERIFY': 5, 'REPAIR': 6, 'VM': 7, 'AI': 8}
    rows = sorted(reg.values(), key=lambda r: (order.get(r.get('stage', ''), 9), r.get('file', ''), int(r.get('line') or 0)))
    tmp = REG + '.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader()
        for r in rows:
            w.writerow({c: r.get(c, '') for c in COLS})
    os.replace(tmp, REG)


def counts(reg):
    live = [r for r in reg.values() if r.get('status') not in ('gone', 'dismissed')]
    by = {}
    for r in live:
        by.setdefault(r['stage'], {}).setdefault(r.get('status') or 'open', 0)
        by[r['stage']][r.get('status') or 'open'] += 1
    eng = {}
    for r in live:
        for e in re.split(r'[·,]\s*', r.get('engine') or '(대응 엔진 미정)'):
            eng.setdefault(e or '(대응 엔진 미정)', [0, 0])
            eng[e or '(대응 엔진 미정)'][0] += 1
            eng[e or '(대응 엔진 미정)'][1] += 1 if r.get('status') in ('proven', 'accepted-limit') else 0
    return live, by, eng


def report(reg, nfiles=None, new=0, gone=0):
    live, by, eng = counts(reg)
    done = sum(1 for r in live if r.get('status') in ('proven', 'accepted-limit'))
    lines = [f"# 추측 지점 원장 현황 — {time.strftime('%Y-%m-%d %H:%M:%S')}", '',
             f"- 살아 있는 지점 **{len(live)}** (스캔 대상 파일 {nfiles if nfiles is not None else '-'}) · 해소(proven+accepted-limit) **{done}/{len(live)}** · 이번 스캔 신규 {new} · 사라짐 {gone}",
             "- 출처: `tools/Harness/verify/guess_scan.py` 실측 · 원장 `Doc/verify/_guess_registry.csv`",
             "- 주의: 표식·이름이 없는 추정은 스캔으로 못 찾는다(발견 시 MANUAL 행으로 등록) — 이 수치는 '알려진 추측 지점' 수다.", '',
             '## 단계 × 상태', '', '| 단계 | open | engine-built | proven | accepted-limit | user-confirm | 합계 |', '|---|---|---|---|---|---|---|']
    for st in ['PARSE', 'DOC', 'FE_GEN', 'SP_GEN', 'META', 'VERIFY', 'REPAIR', 'VM', 'AI']:
        d = by.get(st)
        if not d:
            continue
        lines.append(f"| {st} | {d.get('open', 0)} | {d.get('engine-built', 0)} | {d.get('proven', 0)} | {d.get('accepted-limit', 0)} | {d.get('user-confirm', 0)} | {sum(d.values())} |")
    lines += ['', '## 종류', '', '| 종류 | 지점 수 |', '|---|---|']
    kd = {}
    for r in live:
        kd[r['kind']] = kd.get(r['kind'], 0) + 1
    lines += [f"| {k} | {v} |" for k, v in sorted(kd.items(), key=lambda x: -x[1])]
    lines += ['', '## 대체 엔진별(한 지점이 여러 엔진에 걸리면 각각 셈)', '', '| 엔진 | 걸린 지점 | 해소 |', '|---|---|---|']
    lines += [f"| {k} | {v[0]} | {v[1]} |" for k, v in sorted(eng.items(), key=lambda x: (-x[1][0], x[0]))]
    return '\n'.join(lines) + '\n'


def selftest():
    cases = [
        ('추정 표식', "    // tobe_pkg_candidate 는 명명 규칙 추정값", ['MARKER']),
        ('부정 문맥 제외', "    # 그 외는 판단불가로 남긴다 (추측하지 않음)", ['MARKER']),  # '판단불가' 는 표식 — 뒤의 '추측하지 않음' 과 별개
        ('순수 부정', "  // 컬럼 겹침 추정은 쓰지 않는다 — 추정 금지", []),
        ('추정 함수 정의', "function guessSheet(sp) {", ['FUNC']),
        ('이름 규칙 정규식', "const isHist = (t: string) => /_H$|_HIST|HISTORY/i.test(t);", ['FUNC', 'NAMERULE']),
        ('LLM 호출', "  const r = spawnSync('claude', ['-p', prompt]);", ['LLM']),
        ('판정 완화', "    r['evidence'] += ' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)'", ['RELAX']),
        ('해당 없음', "    const n = rows.length;", []),
    ]
    bad = 0
    for name, line, want in cases:
        got = [k for k, _ in classify(line)]
        ok = got == want
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {name} → {got}{'' if ok else ' (기대 ' + str(want) + ')'}")
    a = gid('x.py', 'MARKER', '   추정  12345 값'); b = gid('x.py', 'MARKER', '추정 99 값')
    ok = a == b
    bad += 0 if ok else 1
    print(f"{'OK ' if ok else 'NG '} 줄 이동·숫자 변화에도 같은 id")
    print(f"{len(cases) + 1 - bad}/{len(cases) + 1}")
    return 1 if bad else 0


def main():
    a = set(sys.argv[1:])
    if '--selftest' in a:
        return selftest()
    reg = load()
    if '--report' in a and '--update' not in a:
        print(report(reg)); return 0
    found, nfiles = scan()
    today = time.strftime('%Y-%m-%d')
    new = [k for k in found if k not in reg]
    if '--check' in a:
        print(f"[guess_scan] 스캔 {len(found)}지점(파일 {nfiles}) · 원장에 없는 지점 {len(new)}")
        for k in new[:15]:
            print(f"  {found[k]['file']}:{found[k]['line']} [{found[k]['kind']}] {found[k]['text'][:110]}")
        return 2 if new else 0
    gone = 0
    for k, r in found.items():
        if k in reg:
            old = reg[k]
            for c in ('stage', 'kind', 'file', 'line', 'text'):
                old[c] = r[c]
            old['last_seen'] = today
            if not old.get('engine'):
                old['engine'] = engine_of(r['file'])
            if old.get('status') == 'gone':
                old['status'] = 'open'
        else:
            reg[k] = {**r, 'what': '', 'grade': 'E0', 'impact': '', 'engine': engine_of(r['file']), 'status': 'open', 'note': '', 'first_seen': today, 'last_seen': today}
    for s in load_seed():  # 조사로 확인한 지점 — 스캔으로 못 찾는 추정(guess_seed.csv)
        k = 'M-' + hashlib.sha1(f"{s['file']}|{s['what']}".encode('utf-8')).hexdigest()[:8]
        if k in reg:
            for c in ('stage', 'file', 'line', 'what', 'impact'):
                reg[k][c] = s.get(c, '')
            reg[k]['last_seen'] = today
            if not reg[k].get('engine'):
                reg[k]['engine'] = s.get('engine', '')
        else:
            reg[k] = {'guess_id': k, 'kind': 'MANUAL', 'text': '', 'grade': s.get('grade') or 'E0', 'status': s.get('status') or 'open', 'note': s.get('note', ''),
                      'first_seen': today, 'last_seen': today, **{c: s.get(c, '') for c in ('stage', 'file', 'line', 'what', 'impact', 'engine')}}
            new.append(k)
    for k, r in reg.items():
        if k not in found and r.get('kind') != 'MANUAL' and r.get('status') not in ('gone', 'dismissed'):
            r['status'] = 'gone'; r['note'] = (r.get('note') or '') + f' | {today} 코드에서 사라짐(이전 상태 확인 필요)'; gone += 1
    save(reg)
    md = report(reg, nfiles, len(new), gone)
    open(MD, 'w', encoding='utf-8').write(md)
    print(md)
    return 0


if __name__ == '__main__':
    sys.exit(main())
