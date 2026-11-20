# -*- coding: utf-8 -*-
"""선행 칸(먼저 채워야 하는 칸) AS-IS 사실 — 2026-11-09 T176(SSP0025 신규행 Division 오탐 10건)

배경: AS-IS SSP0025 InsertRow(cs:308-330)는 신규행 Division 을 비워 두고, SpdMain_CellClick(cs:628-632)이
  'Division 이 비었는데 Division 이 아닌 칸을 누르면 MSG00093(Division 을 선택하십시오) 후 return' 한다.
  TO-BE 가 같은 동작으로 바뀌자(13:22 FE) 검사기가 Division 을 고르지 않은 채 신규행 칸을 측정해
  '편집 불가 · 자동완성 안 됨 · 저장 행 수 다름' 등 허위 FAIL 10건을 냈다. 사용자는 Division 을 먼저 고른다 →
  검사기도 같은 순서로 측정해야 한다. 이 사실이 그 순서(선행 칸)를 화면 독립으로 제공한다.

입력: Doc/asisfacts/screens/<ID>/actions.csv · files.csv · AS-IS 소스(변수 → 컬럼 상수 해석)
출력: Doc/asisfacts/screens/<ID>/cell_prereq.csv
  target   = 선행 칸을 요구하는 칸(*: except 칸을 뺀 전부)
  except   = '*' 일 때 제외 칸(보통 선행 칸 자신)
  prereq   = 먼저 채워야 하는 칸(AS-IS 상수 → 컬럼 값)
  scope    = NEW(신규행 분기 '== FlagI/StringI' 안) | ALL
  msg      = 막을 때 메시지(코드·인자 원문)
  ref      = 파일:줄 클래스.메서드

인정 조건(모두): ① 그리드 편집 진입 이벤트 처리기(CellClick·CellDoubleClick·EditModeOn·ButtonClicked·EnterCell·LeaveCell)
  ② 가장 안쪽 guard = IsNullOrEmpty(v) [&& e.Column != GetColumnIndex(X)] 또는 v(.Trim()) == "" ③ 같은 guard 에 MESSAGE 와 RETURN 이 함께 있음
  ④ v 가 같은 메서드에서 Get(Value|Text)(e.Row, GetColumnIndex(상수)) 로 읽힌 값. 해석 못 하면 행을 남기되 prereq 빈칸(검사기는 쓰지 않음).
추출 한계: 같은 메서드 안 지역 변수 대입만 해석(필드·다른 메서드 경유 값은 미해석으로 남김).
"""
import csv, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from asis_variant import is_cur  # variant 'only' = 현행(T172)
from facts_cellclear import const_map, rd

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
csv.field_size_limit(10 ** 8)
HANDLER = re.compile(r'CellClick|CellDoubleClick|EditModeOn|ButtonClicked|EnterCell|LeaveCell')
EMPTY_IF = re.compile(r'^if \(\s*(?:!\s*)?(?:string|String)\.IsNullOrEmpty\(\s*(\w+)(?:\.Trim\(\))?\s*\)'
                      r'(?:\s*&&\s*e\.Column\s*!=\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\))?\s*\)$')
EMPTY_EQ = re.compile(r'^if \(\s*(\w+)(?:\.Trim\(\))?\s*==\s*(?:""|string\.Empty|String\.Empty)'
                      r'(?:\s*&&\s*e\.Column\s*!=\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\))?\s*\)$')
TGT = re.compile(r'e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\)')
NEWROW = re.compile(r'==\s*(?:CAppSetting\.(?:FlagI|StringI)\b|"I")')  # SSP0060 'action == "I"' 형태 포함
MODE_SEG = re.compile(r'IsLock\(|SheetName|ActiveSheet|GetColumnIndex\([^)]*\)\s*(?:>|>=|!=)')  # 화면 모드·시트 판별(행 값 조건 아님)
ASSIGN = re.compile(r'\b(\w+)\s*=\s*\w+\.Get(?:Value|Text)\(\s*e\.Row\s*,\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\)\s*\)(?:\.ToString\(\))?')
COLS = ['target', 'except', 'prereq', 'scope', 'cond_kind', 'msg', 'cond', 'ref']  # cond_kind = NONE|MODE|ROW(행 값 조건 — 검사기 자동 채움 대상 아님)


def src_lines(file_rel):
    q = next((x for x in (os.path.join(ROOT, 'GSCM', file_rel), os.path.join(ROOT, 'GSCM_20260512', file_rel)) if os.path.exists(x)), '')
    return open(q, encoding='utf-8-sig', errors='replace').read().splitlines() if q else []


def main(sid):
    d = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    if not os.path.isdir(d) or not os.path.exists(os.path.join(d, 'actions.csv')):
        print(f"{sid}: actions.csv 없음 — 건너뜀"); return
    files ={f['file'] for f in rd(os.path.join(d, 'files.csv')) if is_cur(f)}
    from asis_live import dead_methods
    dead = dead_methods(sid)
    acts = [a for a in rd(os.path.join(d, 'actions.csv')) if a['file'] in files and (a['class'], a['method']) not in dead]
    cmaps, lines, out, seen = {}, {}, [], set()
    for a in acts:
        if a['kind'] != 'MESSAGE' or not HANDLER.search(a['method']):
            continue
        segs = [s.strip() for s in (a['guard'] or '').split('▸') if s.strip()]
        if not segs:
            continue
        m = EMPTY_IF.match(segs[-1]) or EMPTY_EQ.match(segs[-1])
        if not m or segs[-1].startswith('if (!'):
            continue
        if not any(b['kind'] == 'RETURN' and b['method'] == a['method'] and b['file'] == a['file'] and (b['guard'] or '').strip() == (a['guard'] or '').strip() for b in acts):
            continue  # 메시지만 띄우고 진행하면 선행 조건이 아니다
        var, exc = m.group(1), m.group(2) or ''
        f = a['file']
        if f not in cmaps:
            cmaps[f] = const_map(f.replace('\\', '/'))
            lines[f] = src_lines(f.replace('\\', '/'))
        cm, ls = cmaps[f], lines[f]
        # 같은 메서드 actions 행의 원문 줄에서 변수 대입 해석
        col_const = ''
        for b in acts:
            if b['method'] != a['method'] or b['file'] != f:
                continue
            try:
                ln = ls[int(b['line']) - 1]
            except (ValueError, IndexError):
                continue
            for v, c in ASSIGN.findall(ln):
                if v == var:
                    col_const = c
        tgts = [TGT.findall(s)[-1] for s in segs[:-1] if TGT.search(s) and not s.startswith('else of')]
        tgt_const = tgts[-1] if tgts else ''
        scope = 'NEW' if any(NEWROW.search(s) and not s.startswith('else of') for s in segs) else 'ALL'
        other = [s for s in segs[:-1] if not TGT.search(s) and not (NEWROW.search(s) and not s.startswith('else of'))]
        cond_kind = 'ROW' if any(not MODE_SEG.search(s) for s in other) else ('MODE' if other else 'NONE')
        row = {'target': cm.get(tgt_const, tgt_const) if tgt_const else '*',
               'except': (cm.get(exc, exc) if exc else '') if not tgt_const else '',
               'prereq': cm.get(col_const, '') if col_const else '',
               'scope': scope, 'cond_kind': cond_kind,
               'msg': f"{a['target']}{a['value']}"[:160],
               'cond': ' ▸ '.join(s for s in segs[:-1] if not TGT.search(s))[:300],
               'ref': f"{os.path.basename(f)}:{a['line']} {a['class']}.{a['method']}"}
        key = (row['target'], row['prereq'], row['scope'])
        if key in seen:
            continue
        seen.add(key)
        out.append(row)
    p = os.path.join(d, 'cell_prereq.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as fo:
        w = csv.DictWriter(fo, fieldnames=COLS)
        w.writeheader()
        w.writerows(out)
    print(f"{sid}: 선행 칸 {len(out)}건(행 전체 {sum(1 for x in out if x['target'] == '*')}·칸 지정 {sum(1 for x in out if x['target'] != '*')}·미해석 {sum(1 for x in out if not x['prereq'])}) → {p}")


if __name__ == '__main__':
    for s in sys.argv[1:]:
        main(s.upper())
