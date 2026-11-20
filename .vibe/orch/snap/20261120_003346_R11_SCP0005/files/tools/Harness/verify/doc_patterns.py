#!/usr/bin/env python3
"""doc_patterns.py — 문서 행 → 결함 패턴 연결표(W8-3, 2026-11-05)

  대상 = defects_classified.csv 중 doc_proof.py 와 같은 대상(status DEFECT·빈값·REQ·OPEN) — 진행율과 같은 분모.
  문서 행 하나마다 '새 화면에서 이 유형의 결함이 어떤 경로로 검사되는가'를 적는다.

  검사 경로(path, ';' 로 여러 개):
    AUTO  = 이 문서 행을 출처로 적은 손 기대 행의 패턴 키를 그 화면 자동 행(gen_expect P##)이 재현 → 사실 조건만 맞으면 새 화면에도 생성
    HAND  = 손 기대 행은 있으나 자동 행이 재현하지 않음 → 그 화면 전용(새 화면 일반화 안 됨)
    RULE  = 문서 rule_ids 에 공통 검사기(mapping_checkdefs.csv)가 있음 → 모든 화면 원장에 규칙 행 · 규칙 단위(그 결함 자체 재현 아님)
    NONE  = 위 셋 다 없음 / 기계검출불가 = 문서 분류 detectable=N
  new_screen(새 화면 검출 등급 — 2026-11-05 정의: 규칙 검사기 존재만으로 '검출'로 세지 않는다):
    기계검출불가 = detectable=N
    AUTO        = 자동 패턴이 사실 조건 맞는 새 화면마다 구체 시험을 다시 생성(문서 행의 손 행 키 재현)
    RULE        = 문서가 UI 공통 현상(general_rule=Y) + 그 규칙 공통 검사기 실측 이력(등급 D·E·F·F* — C 는 측정 0 이라 제외) · 규칙 단위(개별 결함 재현 입증 아님)
    공통·미측정  = general_rule=Y 인데 공통 검사기 없음 또는 실측 0(등급 A·B·C) → W8-4 검출 입증 대상
    화면고유     = general_rule=N(업무·화면 고유) → 새 화면 일반화 대상 아님 · 그 화면 손 행(HAND)으로만

  연결 근거:
    손 기대 행 source 열의 문서 번호 토큰(<src>-<no>, 예 DM-84 · GAP-12 · GAPPI-3)이 문서 행 (src, no) 와 정확히 같을 때만.
    재현 판정 = gen_expect_recall.py 와 같은 함수(expect_rows.keys_of · auto_rows(full=True)) — 손 행 키 ∩ 그 화면 자동 행 키.
    규칙 등급 = doc_proof.py 출력 _doc_proof.csv(먼저 doc_proof.py 를 실행해야 최신).

  출력: Doc/verify/doc_patterns.csv + 콘솔 요약(숫자는 이 출력만 인용 — 감·예측 금지)
"""
import collections
import csv
import datetime
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import expect_rows as ER  # noqa: E402
import gen_expect as GEN  # noqa: E402

V = ER.V
TARGET = {'DEFECT', '', 'REQ', 'OPEN'}  # doc_proof.py TARGET 과 같아야 한다
TOKEN = re.compile(r'\b([A-Z][A-Z0-9]*)-([A-Z]?\d+)\b')  # DM-84 · DM-P60 · DM-C3(문서 번호 글자 접두)
OUT_COLS = ['src', 'no', 'menu_id', 'status', 'rule_ids', 'detectable', 'path', 'new_screen', 'pattern_id', 'applies_when',
            'hand_rows', 'auto_reproduced', 'rule_grades', 'reason', 'target']


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def split_rules(s):
    return [x for x in re.split(r'[;,\s]+', (s or '').strip()) if x]


def hand_index():
    """(src, no) → [(파일, 손 행)] — source 열 토큰 정확 일치"""
    idx = collections.defaultdict(list)
    for name in ER.EXPECT_FILES:
        rows, _ = ER.read_csv(os.path.join(V, name))
        for r in rows:
            for m in TOKEN.finditer(r.get('source') or ''):
                idx[(m.group(1), m.group(2))].append((name, r))
    return idx


_AUTO = {}


def auto_keymap(name, mid):
    """그 화면 자동 행(_all · 손 행 중복 제거 전) 키 → {pattern_id}"""
    k = (name, mid)
    if k not in _AUTO:
        km = collections.defaultdict(set)
        for x in ER.auto_rows(name, mid, full=True):
            for key in ER.keys_of(name, x):
                km[key].add(x.get('pattern_id', ''))
        _AUTO[k] = km
    return _AUTO[k]


def row_label(name, r):
    return f"{name.replace('_expect.csv', '').replace('.csv', '')}:{r.get('menu_id', '')}:{(r.get('name') or r.get('label') or r.get('column_re') or r.get('button') or '')[:40]}"


def main():
    D = rd(os.path.join(V, 'defects_classified.csv'))
    T = [r for r in D if r['status'] in TARGET]
    defs = {d['check']: d for d in rd(os.path.join(HERE, 'mapping_checkdefs.csv'))}
    grades = {r['rule_id']: r['grade'] for r in rd(os.path.join(V, '_doc_proof.csv'))}
    gp = os.path.join(V, '_doc_proof.csv')
    gtime = datetime.datetime.fromtimestamp(os.path.getmtime(gp)).strftime('%m-%d %H:%M') if os.path.exists(gp) else '없음'
    hidx = hand_index()
    out = []
    for r in T:
        key = (r['src'], r['no'])
        hands = hidx.get(key, [])
        pats, reproduced, hand_lbl, hand_keys = set(), [], [], set()
        for name, h in hands:
            # 같은 화면 손 행만 — source 는 문서 번호지만 손 행 menu_id 가 문서 행 화면과 다를 수 있어(공통 문서 → 다른 화면 적용) 둘 다 기록
            hand_lbl.append(row_label(name, h))
            hk = ER.keys_of(name, h)
            hand_keys |= hk
            km = auto_keymap(name, h.get('menu_id', ''))
            hit = {p for k in hk for p in km.get(k, set())}
            if hit:
                pats |= hit
                reproduced.append(f"{row_label(name, h)}←{'/'.join(sorted(hit))}")
        rules = split_rules(r['rule_ids'])
        rg = {x: (grades.get(x) or ('A' if x not in defs else '?')) for x in rules}
        rule_ok = [x for x in rules if x in defs]
        path = []
        if pats:
            path.append('AUTO')
        if hands and not pats:
            path.append('HAND')
        if rule_ok:
            path.append('RULE')
        reason = []
        if r['detectable'] == 'N':
            path = ['기계검출불가'] + path
            reason.append(f"문서 분류 detectable=N {(r.get('undetectable_reason') or '')[:60]}")
        if not path:
            path = ['NONE']
        if hands and not pats:
            reason.append('손 행 패턴 키 없음(유형화 안 됨)' if not hand_keys else f"손 행 키 {' + '.join(sorted(hand_keys))[:80]} 를 자동 행이 재현 안 함")
        if not hands:
            reason.append('이 문서 번호를 출처로 적은 손 기대 행 없음')
        miss_rule = [x for x in rules if x not in defs]
        if miss_rule:
            reason.append(f"공통 검사기 없는 규칙 {'·'.join(miss_rule)}")
        measured_rule = any(rg[x] in ('D', 'E', 'F', 'F*') for x in rule_ok)
        if r['detectable'] == 'N':
            new_screen = '기계검출불가'
        elif pats:
            new_screen = 'AUTO'
        elif r.get('general_rule') == 'Y':
            new_screen = 'RULE' if measured_rule else '공통·미측정'
        else:
            new_screen = '화면고유'
        if pats:
            pid = ';'.join(sorted(pats))
            applies = ' | '.join(f"{p}: {GEN.PATTERN_INFO[p][3]}" for p in sorted(pats) if p in GEN.PATTERN_INFO)
        elif rule_ok:
            pid = 'RULE:' + ';'.join(rule_ok)
            applies = ' | '.join(f"{x}: {(defs[x].get('subject') or '')} {(defs[x].get('how') or '')[:70]}" for x in rule_ok)
        elif hands:
            pid = 'HAND'
            applies = f"화면 {';'.join(sorted({h.get('menu_id', '') for _, h in hands}))} 전용 손 행"
        else:
            pid, applies = '-', ''
        out.append({'src': r['src'], 'no': r['no'], 'menu_id': r['menu_id'], 'status': r['status'] or '(빈값)', 'rule_ids': r['rule_ids'],
                    'detectable': r['detectable'], 'path': ';'.join(path), 'new_screen': new_screen, 'pattern_id': pid, 'applies_when': applies[:400],
                    'hand_rows': ' / '.join(hand_lbl)[:300], 'auto_reproduced': ' / '.join(reproduced)[:300],
                    'rule_grades': ';'.join(f'{x}={g}' for x, g in rg.items()), 'reason': ' · '.join(reason)[:300], 'target': r['target'][:120]})
    p = os.path.join(V, 'doc_patterns.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=OUT_COLS)
        w.writeheader()
        w.writerows(out)
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    n = len(out)
    print(f'[실측 {now}] 문서 {len(D)}행 중 대상 {n}행(status DEFECT·빈값·REQ·OPEN) · 규칙 등급 출처 _doc_proof.csv({gtime})')
    pc = collections.Counter()
    for x in out:
        for t in x['path'].split(';'):
            pc[t] += 1
    print('  경로별(행이 여러 경로면 중복 집계): ' + ' · '.join(f'{k} {v}' for k, v in pc.most_common()))
    prim = collections.Counter(x['path'].split(';')[0] for x in out)
    print('  대표 경로(첫 경로): ' + ' · '.join(f'{k} {v}' for k, v in prim.most_common()))
    nc = collections.Counter(x['new_screen'] for x in out)
    print('  새 화면 검출 등급: ' + ' · '.join(f'{k} {nc[k]}({100.0 * nc[k] / n:.1f}%)' for k in ('AUTO', 'RULE', '공통·미측정', '화면고유', '기계검출불가') if nc[k]))
    print('    ※ RULE = 규칙 단위(공통 검사기 실측 이력) — 개별 결함 재현 입증 아님 · 화면고유 = 문서 general_rule=N(새 화면 일반화 대상 아님)')
    hs = collections.Counter(x['new_screen'] for x in out if 'HAND' in x['path'] or 'AUTO' in x['path'])
    print('  손 기대 행 있는 문서 행: ' + ' · '.join(f'{k} {v}' for k, v in hs.most_common()))
    gap = collections.Counter(r for x in out if x['new_screen'] == '공통·미측정' for r in x['rule_grades'].split(';') if r)
    print('  공통·미측정 행의 규칙=등급: ' + ' '.join(f'{k}({v})' for k, v in gap.most_common(25)))
    ap = collections.Counter(p for x in out if 'AUTO' in x['path'] for p in x['pattern_id'].split(';'))
    print('  AUTO 패턴별 문서 행: ' + ' '.join(f'{k}({v})' for k, v in sorted(ap.items())))
    print('  →', os.path.relpath(p, ER.ROOT))


if __name__ == '__main__':
    main()
