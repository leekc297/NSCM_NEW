# -*- coding: utf-8 -*-
"""테스트결과서 — UI CheckList(run_verify) 결과를 사용자가 읽는 '테스트 내역 · 결과' Excel 로 (2026-10-30 사용자 요청)

  python tools/Harness/verify/make_test_report.py <MENU_ID>

입력(모두 직전 UI CheckList 실행 산출물 — 이 스크립트는 아무것도 다시 측정하지 않는다):
  Doc/verify/<ID>/verify_ledger.csv            판정 원장(judge 완료본)
  Doc/verify/<ID>/e2e_results.json             E2E 행별 실측
  Doc/verify/<ID>/e2e/results.json             Playwright 실행 테스트 목록(통과/실패/소요)
  Doc/verify/<ID>/e2e/shots/index_*.json       FAIL 행 캡처(테스트 종료 시점 화면 · _verify/_trace afterEach)
  Doc/verify/<ID>/run_verify.result.json       실행 시각·봉투
  Doc/e2e/results/<ID>/shots/<ID>_*.png        스모크 캡처(2026-11-06 화면 폴더 · 없으면 공용 Doc/e2e/results/shots)(화면 진입·조회조건·조회 결과·공통 기능·권한별)
  tools/E2E/e2e.config.json                    테스트 환경(FE/BE URL·계정·Division)

출력: Doc/테스트결과서/<ID>_<화면명>_테스트결과서_v<n>.xlsx (이전 판은 Doc/테스트결과서/old/)
  시트: 요약 · 테스트결과(그룹 → 검사 규칙 → 항목, Excel 개요(outline)로 접기/펼치기) · 실패 상세(캡처 포함) · 실행 테스트 · 화면 캡처 · 용어 설명

CheckList 와의 차이: CheckList 는 판정 원장 그대로(검증 ID·근거 등급·사용자판정 열), 테스트결과서는 같은 행을 **그룹으로 묶고 결과를 사람 말로 상세하게**(테스트 내역·기대·실제·겪는 일·캡처).
행 수·결과 분포는 같은 실행의 CheckList 와 반드시 일치해야 한다(요약 시트에 대조 표시).
"""
import argparse
import datetime
import json
import os
import re
import sys
from collections import Counter, OrderedDict

from openpyxl import Workbook
from openpyxl.drawing.image import Image as XLImage
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, HERE)
sys.path.insert(0, P('tools', 'Docs'))
import doc_archive  # noqa: E402
import make_verify_docs as mvd  # noqa: E402  — 설명 문장(plain)·근거 등급·결과 강등·FAIL 의미·규칙 뜻을 CheckList 와 같은 코드로

OUTDIR = P('Doc', '테스트결과서')
KIND = '테스트결과서'

# ── 사용자 언어 ──
RES_KO = {'PASS': '통과', 'FAIL': '실패', '판정필요': '확인 필요', 'ERROR': '미검증(오류)', 'NOT_RUN': '미검증', 'WARN': '주의', 'NA': '해당 없음', '': '미검증'}
RES_ORDER = {'FAIL': 0, '판정필요': 1, 'WARN': 2, 'ERROR': 3, 'NOT_RUN': 4, '': 4, 'PASS': 5, 'NA': 6}
RES_FILL = {'FAIL': 'F8CBAD', 'PASS': 'E2EFDA', '판정필요': 'FFF2CC', 'WARN': 'FFF2CC', 'ERROR': 'D9D9D9', 'NOT_RUN': 'EDEDED', '': 'EDEDED', 'NA': 'F2F2F2'}
METHOD_KO = {'E2E': '화면 자동 조작(E2E)', 'STATIC': '소스·SP 정적 분석', 'META': '화면 메타(DB) 조회', 'DB': 'DB 실측 비교', 'W1': '콤보 원천 실행 비교', 'SYN': '시노님·권한 조회'}
ORACLE_KO = {'O1': 'AS-IS 실제 동작과 같아야 함', 'O2': 'TO-BE 확정 규칙(CR)을 지켜야 함', 'O3': '기능이 깨지지 않아야 함(무결성)'}
SOURCE_KO = {'SEARCH': '조회조건', 'COLUMN': '그리드 컬럼', 'SP': '조회 SP', 'ASIS': 'AS-IS 화면 동작', 'RULE_SCREEN': '화면 공통 규칙', 'TRACE': '대조표 항목', 'DEFECT': '이 화면 과거 결함', 'GENERAL': '다른 화면 결함 유형', 'CONFIRMED': 'TO-BE 확정 규칙'}
# 영역(원장 area) → 그룹 제목·순서. 원장에 없는 영역은 '기타' 로(새 영역이 생기면 여기에 추가 — 누락 없이 뒤에 붙는다)
GROUPS = OrderedDict([
    ('화면', '화면 공통 — 진입·버튼·다국어·레이아웃'),
    ('조회조건', '조회조건 — 콤보 후보·입력·연동·초기값'),
    ('조회', '조회 결과 — 건수·정렬·값'),
    ('그리드', '그리드 컬럼 — 표시·편집 잠금·입력 검증·CRUD 상태'),
    ('팝업', '팝업 — 열기·선택값 반영·내부 기능'),
    ('메시지', '메시지 — 업무 검증·안내 문구'),
    ('검증', '저장 검증'),
    ('대조표', 'AS-IS 동작 대조 — 대조표 항목별 화면 재현'),
    ('확정규칙', 'TO-BE 확정 규칙(CR) 준수'),
    ('결함원장', '이 화면의 과거 결함 재발 확인'),
    ('결함일반화', '다른 화면 결함 유형 재발 확인(공통 점검)'),
])
HFILL = PatternFill('solid', fgColor='F2E1D9')
GFILL = PatternFill('solid', fgColor='DDEBF7')   # 그룹 행
SFILL = PatternFill('solid', fgColor='F2F2F2')   # 세부 그룹 행
THIN = Side(style='thin', color='BFBFBF')
BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)
WRAP_TOP = Alignment(vertical='top', wrap_text=True)


def read_json(p, default):
    try:
        with open(p, encoding='utf-8-sig') as f:
            return json.load(f)
    except (OSError, ValueError):
        return default


def ko_result(res):
    return RES_KO.get(res, res)


def method_ko(m):
    toks = [t for t in re.split(r'[+;]', m or '') if t]
    return ' + '.join(METHOD_KO.get(t, t) for t in toks) or '(기록 없음)'


def oracle_ko(o):
    toks = [t for t in re.split(r'[+;]', o or '') if t]
    return ' / '.join(ORACLE_KO.get(t, t) for t in toks) or '(기록 없음)'


def cond_ko(c):
    """조건 — TRACE 행은 JSON(검사 설정)이라 키: 값 으로 펼친다. 그 외는 원문."""
    c = (c or '').strip()
    if c.startswith('{'):
        try:
            d = json.loads(c)
            parts = []
            for k, v in d.items():
                if v in (None, '', [], {}):
                    continue
                parts.append(f'{k}: {json.dumps(v, ensure_ascii=False) if isinstance(v, (list, dict)) else v}')
            return ' · '.join(parts) if parts else '(조건 없음)'
        except ValueError:
            return c
    return c or '(조건 없음)'


def split_user_verdict(ev):
    """'[사용자판정] X — 실측: Y' → (X, Y). 아니면 ('', ev)."""
    m = re.match(r'^\[사용자판정\]\s*(.*?)\s*— 실측: (.*)$', (ev or '').replace('\r', ''), re.S)
    return (m.group(1), m.group(2)) if m else ('', ev or '')


def actual_detail(r):
    """실제 결과(상세) — 실측 증거 전문(자르지 않음) + 사용자 판정이 있으면 분리 표기 + 결론 한 줄."""
    uv, ev = split_user_verdict(r.get('evidence') or '')
    ev = mvd.xl_safe(ev).strip()
    lines = []
    if uv:
        lines.append(f'■ 사용자 판정: {uv}')
    lines.append(f'■ 실측: {ev}' if ev else '■ 실측: (기록 없음)')
    note = (r.get('note') or '').strip()
    m = re.search(r'원판정:\s*([A-Z가-힣]+)', note)
    if m and m.group(1) != r.get('result'):
        lines.append(f"■ 기계 원판정 {ko_result(m.group(1))} → 최종 {ko_result(r['result'])}(설계 결정·사용자 판정 반영)")
    lines.append(mvd.RESULT_TAIL.get(r.get('result') or '', ''))
    return '\n'.join(x for x in lines if x)


def test_detail(r):
    return '\n'.join([
        f"■ 방법: {method_ko(r.get('method'))}",
        f"■ 조건: {cond_ko(r.get('condition'))}",
        f"■ 기준: {oracle_ko(r.get('oracle'))}",
        f"■ AS-IS 근거: {(r.get('asis_ref') or '').strip() or '(없음)'}",
        f"■ 판정 출처: {(r.get('tobe_ref') or '').strip() or '(없음)'}",
    ])


def item_title(r):
    rule = r.get('rule_id') or ''
    tgt = mvd._target_label(r).rstrip('.') if hasattr(mvd, '_target_label') else (r.get('target') or '')
    mean = mvd.RULE_MEAN.get(rule, rule)
    return f'{tgt} — {mean}' if tgt else mean


def experience(r):
    """사용자가 겪는 일(FAIL) — 규칙별 문장이 있으면 그것, 없으면 설명(한 줄)."""
    if r.get('result') != 'FAIL':
        return ''
    return mvd.FAIL_MEAN.get(r.get('rule_id') or '') or mvd.plain(r)


def load_shots(mid):
    """FAIL 캡처 색인 — Doc/verify/<ID>/e2e/shots/index_*.json {row_id: {file,test,at,note}}"""
    d = P('Doc', 'verify', mid, 'e2e', 'shots')
    idx = {}
    if os.path.isdir(d):
        for f in sorted(os.listdir(d)):
            if f.startswith('index_') and f.endswith('.json'):
                for k, v in (read_json(os.path.join(d, f), {}) or {}).items():
                    if os.path.exists(os.path.join(d, v.get('file', ''))):
                        idx[k] = dict(v, path=os.path.join(d, v['file']))
    return idx


SMOKE_CAP = [('open', '화면 진입 직후'), ('cond', '조회조건 입력 후'), ('searched', '조회 결과'), ('common', '공통 기능(Sort·Filter·Condition 등) 조작 후')]


def smoke_shots(mid):
    # 2026-11-06: 화면 하나 smoke 의 캡처는 Doc/e2e/results/<ID>/shots — 화면 폴더 먼저, 같은 파일명이 공용 shots 에도 있으면 화면 폴더 것을 쓴다
    import e2e_paths
    out = []
    seen = set()
    for d, f in [(d, f) for d in e2e_paths.shots_dirs(mid) for f in sorted(os.listdir(d))]:
        if not (f.startswith(mid + '_') and f.endswith('.png')) or f in seen:
            continue
        seen.add(f)
        key = f[len(mid) + 1:-4]
        cap = dict(SMOKE_CAP).get(key)
        if not cap:
            m = re.match(r'^authcrud_(.+)$', key)
            cap = f'권한별 CRUD — 계정 {m.group(1)}' if m else key
        p = os.path.join(d, f)
        out.append({'file': f, 'path': p, 'caption': cap, 'at': datetime.datetime.fromtimestamp(os.path.getmtime(p)).strftime('%Y-%m-%d %H:%M:%S')})
    order = {k: i for i, (k, _) in enumerate(SMOKE_CAP)}
    out.sort(key=lambda s: (order.get(s['file'][len(mid) + 1:-4], 99), s['file']))
    return out


def pw_tests(mid):
    """Playwright 실행 테스트 목록 — Doc/verify/<ID>/e2e/results.json"""
    d = read_json(P('Doc', 'verify', mid, 'e2e', 'results.json'), None)
    out = []
    if not d:
        return out

    def walk(s, file_):
        for sp in s.get('specs', []):
            for t in sp.get('tests', []):
                for x in t.get('results', []):
                    err = ((x.get('error') or {}).get('message') or '')
                    out.append({'file': s.get('file') or file_, 'title': sp.get('title') or '', 'status': x.get('status') or '', 'ms': x.get('duration') or 0, 'err': mvd.xl_safe(re.sub(r'\s+', ' ', err))[:300]})
        for c in s.get('suites', []):
            walk(c, s.get('file') or file_)
    for s in d.get('suites', []):
        walk(s, s.get('file') or '')
    return out


def style_header(ws, ncol):
    for c in ws[ws.max_row][:ncol]:
        c.fill, c.font, c.alignment, c.border = HFILL, Font(bold=True, size=11), Alignment(horizontal='center', vertical='center', wrap_text=True), BORDER


def set_widths(ws, widths):
    for i, w in enumerate(widths, 1):
        ws.column_dimensions[get_column_letter(i)].width = w


def add_image(ws, path, anchor, max_w=640):
    """캡처 삽입 — 폭 max_w 로 축소(비율 유지). 행 높이는 호출자가 맞춘다. 반환 = (w, h) px"""
    img = XLImage(path)
    w, h = img.width, img.height
    if w > max_w:
        h = int(h * max_w / w); w = max_w
    img.width, img.height = w, h
    img.anchor = anchor
    ws.add_image(img)
    return w, h


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    vdir = P('Doc', 'verify', mid)
    ledger = os.path.join(vdir, 'verify_ledger.csv')
    rows = mvd.read_csv(ledger)
    if not rows:
        print(f'[ERROR] {mid}: 판정 원장 없음({os.path.relpath(ledger, ROOT)}) — 먼저 🔎 UI CheckList 를 실행한다(테스트결과서는 그 결과를 읽기만 한다)')
        return 2
    env = read_json(os.path.join(vdir, 'run_verify.result.json'), {}) or {}
    if env.get('state') not in ('completed',):
        print(f"[WARN] {mid}: 직전 UI CheckList 봉투 상태 {env.get('state')!r}({env.get('why') or ''}) — 완료된 실행이 아니면 결과가 불완전할 수 있다")
    if not os.path.exists(os.path.join(vdir, 'e2e_results.json')):
        print(f'[WARN] {mid}: E2E 실측(e2e_results.json) 없음 — E2E 행은 미검증으로 표기된다')
    cfg = read_json(P('tools', 'E2E', 'e2e.config.json'), {}) or {}
    name = mvd.screen_name(mid)
    mvd.load_user_verdicts(mid)
    for r in rows:  # CheckList 와 같은 등급·강등 규칙
        r['_grade'] = mvd.evidence_grade(r)
        r['_eff'] = mvd.effective_result(r)
    shots = load_shots(mid)
    smokes = smoke_shots(mid)
    tests = pw_tests(mid)

    # ── 그룹 구성: 영역 → 규칙 → 행(결과 심각도 → 대상) ──
    areas = list(GROUPS.keys()) + sorted({r.get('area') or '' for r in rows} - set(GROUPS.keys()))
    by_area = OrderedDict((k, []) for k in areas)
    for r in rows:
        by_area[r.get('area') or ''].append(r)
    by_area = OrderedDict((k, v) for k, v in by_area.items() if v)

    def stat(rs):
        c = Counter(r['_eff'] for r in rs)
        return {'전체': len(rs), '통과': c.get('PASS', 0), '실패': c.get('FAIL', 0), '확인 필요': c.get('판정필요', 0) + c.get('WARN', 0),
                '미검증': c.get('ERROR', 0) + c.get('NOT_RUN', 0) + c.get('', 0), '해당 없음': c.get('NA', 0)}

    def stat_line(s):
        return f"항목 {s['전체']} · 통과 {s['통과']} · 실패 {s['실패']} · 확인 필요 {s['확인 필요']} · 미검증 {s['미검증']} · 해당 없음 {s['해당 없음']}"

    wb = Workbook()
    # ════ 1. 요약 ════
    ws0 = wb.active; ws0.title = '요약'
    total = stat(rows)
    started, ended = env.get('started') or '', (env.get('ts') or '')[:19].replace('T', ' ')
    ws0.append([f'{mid} {name} — 테스트결과서']); ws0['A1'].font = Font(bold=True, size=16)
    ws0.append(['생성 시각', datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), '', '이 문서는 직전 UI CheckList 실행 결과를 읽어 만든 것으로, 새로 측정하지 않았다.'])
    ws0.append(['테스트 실행', f'{started} ~ {ended}'.strip(' ~') or '(봉투 없음)', '', f"run_verify 봉투 상태 {env.get('state') or '-'} · 판정 {env.get('verdict') or '-'}"])
    ws0.append(['테스트 환경', f"FE {cfg.get('feUrl', '-')} · BE {cfg.get('beUrl', '-')}", '', f"계정 {cfg.get('forceAccount') or cfg.get('defaultAccount') or '-'} · 기본 Division {cfg.get('defaultDivision', '-')} · 사내오라클(ZIOUI1) 기준"])
    pw_ok = sum(1 for t in tests if t['status'] == 'passed'); pw_bad = [t for t in tests if t['status'] not in ('passed', 'skipped')]
    ws0.append(['자동 테스트 실행', f'Playwright 테스트 {len(tests)}개 — 통과 {pw_ok} · 실패/중단 {len(pw_bad)} · 건너뜀 {sum(1 for t in tests if t["status"] == "skipped")}', '', '테스트가 측정 전에 죽으면 담당 항목은 미검증(오류)로 남는다(검증엔진 미기동)' if pw_bad else '모든 자동 테스트가 끝까지 실행됨'])
    ws0.append(['CheckList 대조', f"검증 행 {total['전체']} = CheckList '검증 전체' 행 수", '', '테스트결과서의 항목 = CheckList 검증 행 1:1(검증 ID 열로 대조) — 결과 분포가 다르면 서로 다른 실행이다'])
    ws0.append([])
    ws0.append(['전체 결과', '항목', '통과', '실패', '확인 필요', '미검증', '해당 없음', '통과율(해당 없음 제외)'])
    style_header(ws0, 8)

    def rate(s):
        d = s['전체'] - s['해당 없음']
        return f"{s['통과'] / d * 100:.1f}%" if d else '-'
    ws0.append(['전체', total['전체'], total['통과'], total['실패'], total['확인 필요'], total['미검증'], total['해당 없음'], rate(total)])
    ws0.append([])
    ws0.append(['그룹별 결과', '항목', '통과', '실패', '확인 필요', '미검증', '해당 없음', '통과율(해당 없음 제외)'])
    style_header(ws0, 8)
    for gi, (ak, rs) in enumerate(by_area.items(), 1):
        s = stat(rs)
        ws0.append([f'{gi}. {GROUPS.get(ak, ak or "기타")}', s['전체'], s['통과'], s['실패'], s['확인 필요'], s['미검증'], s['해당 없음'], rate(s)])
    ws0.append([])
    ws0.append(['결과 용어', '뜻'])
    style_header(ws0, 2)
    for k, v in [('통과', 'AS-IS(또는 TO-BE 확정 규칙)와 같게 동작함 — 기계 실측 또는 사람 판정 근거 있음'), ('실패', 'AS-IS 와 다르게 동작함 — 조치 필요(실패 상세 시트)'),
                 ('확인 필요', '기계로 결론을 내지 못해 사람이 확인해야 함(AI 판단만 있는 통과·해당 없음도 여기로 셈)'), ('미검증', '검사가 실행되지 않았거나 도구 오류로 측정 못 함'),
                 ('해당 없음', '이 화면·데이터에서는 검사 대상이 아님(TO-BE 에 없는 항목 · 설계 결정으로 의도된 차이 · 재현 데이터 없음)')]:
        ws0.append([k, v])
    ws0.append([])
    ws0.append(['시트 안내', '테스트결과 = 전체 항목(그룹 → 검사 규칙 → 항목, 왼쪽 개요(+/−)로 접기) · 실패 상세 = 실패 항목만 캡처 포함 · 실행 테스트 = Playwright 테스트 목록 · 화면 캡처 = 스모크·실패 캡처 · 용어 설명 = 검사 규칙 뜻'])
    set_widths(ws0, [26, 48, 10, 70, 12, 12, 12, 22])
    for row in ws0.iter_rows(min_row=2):
        for c in row:
            c.alignment = WRAP_TOP

    # ════ 2. 테스트결과(그룹) ════
    ws = wb.create_sheet('테스트결과')
    H = ['No', '그룹', '검사 규칙', '테스트 항목', '테스트 내역', '기대 결과', '실제 결과(상세)', '결과', '설명(한 줄)', '겪는 일(실패 시)', '캡처', '비고', '검증 ID']
    W = [6, 30, 34, 40, 60, 50, 80, 10, 60, 50, 22, 40, 12]
    ws.append(H); style_header(ws, len(H))
    n = 0
    for gi, (ak, rs) in enumerate(by_area.items(), 1):
        gtitle = f'{gi}. {GROUPS.get(ak, ak or "기타")}'
        s = stat(rs)
        ws.append([f'■ {gtitle} — {stat_line(s)}'])
        gr = ws.max_row
        ws.merge_cells(start_row=gr, start_column=1, end_row=gr, end_column=len(H))
        ws.cell(gr, 1).fill = GFILL; ws.cell(gr, 1).font = Font(bold=True, size=12); ws.cell(gr, 1).alignment = Alignment(vertical='center')
        ws.row_dimensions[gr].height = 22
        by_rule = OrderedDict()
        for r in sorted(rs, key=lambda r: (r.get('rule_id') or '', RES_ORDER.get(r['_eff'], 9), r.get('target') or '')):
            by_rule.setdefault(r.get('rule_id') or '', []).append(r)
        # 규칙은 실패가 있는 것부터
        for rule, rr in sorted(by_rule.items(), key=lambda kv: (-sum(1 for x in kv[1] if x['_eff'] == 'FAIL'), -sum(1 for x in kv[1] if x['_eff'] == '판정필요'), kv[0])):
            s2 = stat(rr)
            mean = mvd.RULE_MEAN.get(rule, rule)
            ws.append(['', f'▸ {rule}', f'{mean} — {stat_line(s2)}'])
            sr = ws.max_row
            ws.merge_cells(start_row=sr, start_column=3, end_row=sr, end_column=len(H))
            for c in range(1, len(H) + 1):
                ws.cell(sr, c).fill = SFILL
            ws.cell(sr, 2).font = Font(bold=True); ws.cell(sr, 3).font = Font(bold=True)
            ws.row_dimensions[sr].outline_level = 1
            first = ws.max_row + 1
            for r in rr:
                n += 1
                sh = shots.get(r['row_id'])
                remark = [x for x in [
                    f"결함 원장 {r['defect_ref']}" if r.get('defect_ref') else '',
                    f"사용자판정: {mvd.USER_VERDICT.get(r['row_id'])}" if mvd.USER_VERDICT.get(r['row_id']) else '',
                    f"사용자의견: {mvd.USER_OPINION.get(r['row_id'])}" if mvd.USER_OPINION.get(r['row_id']) else '',
                    f"근거 등급 {r['_grade']}",
                    f"출처 {SOURCE_KO.get(r.get('source') or '', r.get('source') or '')}",
                    ('문서 결과는 확인 필요(AI 판단만 있는 통과·해당 없음)' if r['_eff'] != r['result'] else ''),
                ] if x]
                ws.append([n, gtitle, f'{rule} {mean}', item_title(r), test_detail(r), (r.get('expected') or '').strip() or '(기대 기록 없음)', actual_detail(r), ko_result(r['_eff']),
                           mvd.plain(r), experience(r), (f"{sh['file']} ({sh.get('note', '')})" if sh else ''), ' · '.join(remark), r['row_id']])
                rr_i = ws.max_row
                ws.row_dimensions[rr_i].outline_level = 2
                for c in ws[rr_i]:
                    c.alignment, c.border, c.font = WRAP_TOP, BORDER, Font(size=10)
                ws.cell(rr_i, 8).fill = PatternFill('solid', fgColor=RES_FILL.get(r['_eff'], 'FFFFFF'))
            last = ws.max_row
            if last >= first:
                pass  # outline_level 로 묶임(행별 지정) — group() 는 level 재지정으로 겹침을 깨뜨려 쓰지 않는다
    set_widths(ws, W)
    ws.freeze_panes = 'E2'
    ws.sheet_properties.outlinePr.summaryBelow = False
    ws.sheet_view.showGridLines = False
    ws.auto_filter.ref = ws.dimensions

    # ════ 3. 실패 상세(캡처 포함) ════
    wf = wb.create_sheet('실패 상세')
    fails = sorted([r for r in rows if r['_eff'] == 'FAIL'], key=lambda r: (areas.index(r.get('area') or '') if (r.get('area') or '') in areas else 99, r.get('rule_id') or '', r.get('target') or ''))
    wf.append([f'{mid} {name} — 실패 항목 {len(fails)}건 (조치 필요). 각 항목: 무엇을 어떻게 테스트했고, 기대와 실제가 어떻게 달랐고, 사용자가 무엇을 겪는지 · 캡처는 해당 테스트 종료 시점 화면'])
    wf['A1'].font = Font(bold=True, size=12)
    wf.merge_cells(start_row=1, start_column=1, end_row=1, end_column=4)
    set_widths(wf, [6, 22, 100, 40])
    fi = 0
    for r in fails:
        fi += 1
        sh = shots.get(r['row_id'])
        wf.append([])
        wf.append([fi, '그룹', f"{GROUPS.get(r.get('area') or '', r.get('area') or '기타')} › {r.get('rule_id')} {mvd.RULE_MEAN.get(r.get('rule_id') or '', '')}", f"검증 ID {r['row_id']}"])
        hr = wf.max_row
        for c in range(1, 5):
            wf.cell(hr, c).fill = PatternFill('solid', fgColor='F8CBAD'); wf.cell(hr, c).font = Font(bold=True); wf.cell(hr, c).border = BORDER
        layer, why = mvd.decide_layer(r)  # (계층, 사유) — CheckList ActionItemList 와 같은 판단
        scope = mvd.scope_setting(None)
        body = [('테스트 항목', item_title(r)), ('테스트 내역', test_detail(r)), ('기대 결과', (r.get('expected') or '').strip() or '(기대 기록 없음)'),
                ('실제 결과', actual_detail(r)), ('사용자가 겪는 일', experience(r)),
                ('조치 계층', f"{mvd.LAYER_NAME.get(layer, layer)} — {why} · 보완 범위 설정({scope}) 기준 {mvd.apply_status(layer, scope)}"),
                ('종결 근거', mvd.close_evidence(r, layer)),
                ('관련 결함 원장', r.get('defect_ref') or '(없음)'),
                ('사용자 판정·의견', ' · '.join(x for x in [mvd.USER_VERDICT.get(r['row_id'], ''), mvd.USER_OPINION.get(r['row_id'], '')] if x) or '(없음)')]
        for k, v in body:
            wf.append(['', k, v, ''])
            rr_i = wf.max_row
            wf.cell(rr_i, 2).font = Font(bold=True)
            for c in range(1, 5):
                wf.cell(rr_i, c).alignment, wf.cell(rr_i, c).border = WRAP_TOP, BORDER
        if sh:
            wf.append(['', '화면 캡처', f"{sh['file']} — {sh.get('note', '')} · 테스트 '{sh.get('test', '')}' · {sh.get('at', '')}", ''])
            cap_r = wf.max_row
            wf.cell(cap_r, 2).font = Font(bold=True)
            wf.append(['', '', '', ''])
            img_r = wf.max_row
            try:
                w, h = add_image(wf, sh['path'], f'C{img_r}', max_w=700)
                wf.row_dimensions[img_r].height = max(20, h * 0.75 + 6)
            except Exception as ex:  # 캡처 파일 손상 등 — 문서는 계속 만든다
                wf.cell(img_r, 3).value = f'(캡처 삽입 실패: {ex})'
        else:
            wf.append(['', '화면 캡처', '(이 항목의 캡처 없음 — 다음 UI CheckList 실행부터 실패 항목은 테스트 종료 시점 화면이 저장된다)', ''])
            wf.cell(wf.max_row, 2).font = Font(bold=True)
    if not fails:
        wf.append(['실패 항목이 없습니다.'])
    wf.sheet_view.showGridLines = False

    # ════ 4. 실행 테스트 ════
    wt = wb.create_sheet('실행 테스트')
    wt.append(['No', '스펙', '테스트', '상태', '소요(초)', '오류(있을 때)'])
    style_header(wt, 6)
    ST_KO = {'passed': '통과', 'failed': '실패', 'timedOut': '시간 초과', 'skipped': '건너뜀', 'interrupted': '중단'}
    for i, t in enumerate(tests, 1):
        wt.append([i, t['file'], t['title'], ST_KO.get(t['status'], t['status']), round(t['ms'] / 1000, 1), t['err']])
        for c in wt[wt.max_row]:
            c.alignment, c.border = WRAP_TOP, BORDER
        if t['status'] != 'passed':
            wt.cell(wt.max_row, 4).fill = PatternFill('solid', fgColor='F8CBAD')
    if not tests:
        wt.append(['(Playwright 실행 기록 없음 — E2E 미실행 또는 결과 파일 없음)'])
    set_widths(wt, [6, 18, 90, 10, 10, 80])
    wt.freeze_panes = 'A2'

    # ════ 5. 화면 캡처 ════
    wc = wb.create_sheet('화면 캡처')
    wc.append(['No', '구분', '설명', '파일 · 시각'])
    style_header(wc, 4)
    set_widths(wc, [6, 16, 100, 60])
    ci = 0
    for s in smokes:
        ci += 1
        wc.append([ci, '스모크', s['caption'], f"{s['file']} · {s['at']}"])
        wc.append([])
        img_r = wc.max_row
        try:
            w, h = add_image(wc, s['path'], f'C{img_r}', max_w=700)
            wc.row_dimensions[img_r].height = max(20, h * 0.75 + 6)
        except Exception as ex:
            wc.cell(img_r, 3).value = f'(캡처 삽입 실패: {ex})'
    seen = set()
    for rid, sh in shots.items():
        if sh['file'] in seen:
            continue
        seen.add(sh['file'])
        ci += 1
        ids = [k for k, v in shots.items() if v['file'] == sh['file']]
        wc.append([ci, '실패', f"테스트 '{sh.get('test', '')}' 종료 시점 — 실패 항목 {len(ids)}건: {', '.join(ids[:8])}{' …' if len(ids) > 8 else ''}", f"{sh['file']} · {sh.get('at', '')}"])
        wc.append([])
        img_r = wc.max_row
        try:
            w, h = add_image(wc, sh['path'], f'C{img_r}', max_w=700)
            wc.row_dimensions[img_r].height = max(20, h * 0.75 + 6)
        except Exception as ex:
            wc.cell(img_r, 3).value = f'(캡처 삽입 실패: {ex})'
    if ci == 0:
        wc.append(['(캡처 없음 — 스모크 E2E 미실행이거나 Doc/e2e/results/<ID>/shots·Doc/e2e/results/shots 에 이 화면 파일 없음)'])

    # ════ 6. 용어 설명 ════
    wg = wb.create_sheet('용어 설명')
    wg.append(['구분', '코드', '뜻', '이 화면 항목 수'])
    style_header(wg, 4)
    rc = Counter(r.get('rule_id') or '' for r in rows)
    for rule, cnt in sorted(rc.items(), key=lambda kv: (-kv[1], kv[0])):
        wg.append(['검사 규칙', rule, mvd.RULE_MEAN.get(rule, '(카탈로그 뜻 없음 — detect_rules.csv 확인)'), cnt])
    for k, v in METHOD_KO.items():
        wg.append(['판정 방법', k, v, ''])
    for k, v in ORACLE_KO.items():
        wg.append(['정답 기준', k, v, ''])
    for k, v in SOURCE_KO.items():
        wg.append(['항목 출처', k, v, sum(1 for r in rows if r.get('source') == k)])
    for g in mvd.GRADES:
        wg.append(['근거 등급', g, {'기계': 'E2E·정적·메타·DB 실측', '기계(상속·집계)': '다른 기계 판정의 상속·집계', '사람': 'CheckList 사용자판정·결정표·설계 결정(GAP 담당자 확정)', 'AI 작성·인용 확인': 'AI 답이지만 인용 원문이 기계로 확인됨',
                                     'AI 판단만': '인용 없는 AI 답 — 통과로 세지 않음(확인 필요)', '출처 미기록': '판정 출처 기록 없음', '없음(미검증)': '검사 미실행', '없음(판정 대기)': '사람 확인 대기'}.get(g, ''), sum(1 for r in rows if r['_grade'] == g)])
    set_widths(wg, [12, 14, 90, 14])
    for row in wg.iter_rows(min_row=2):
        for c in row:
            c.alignment, c.border = WRAP_TOP, BORDER

    # 모든 셀 제어문자 정제(검사기 문구 방어 — T10)
    for sh_ in wb.worksheets:
        for row in sh_.iter_rows():
            for c in row:
                if isinstance(c.value, str):
                    c.value = mvd.xl_safe(c.value)

    os.makedirs(OUTDIR, exist_ok=True)
    ver = doc_archive.next_version(OUTDIR, f'{mid}_{name}_{KIND}')
    out = os.path.join(OUTDIR, f'{mid}_{name}_{KIND}_v{ver}.xlsx')
    wb.save(out)
    doc_archive.archive_previous(out)
    print(f'테스트결과서 v{ver}: {out}')
    print(f"  항목 {total['전체']} — 통과 {total['통과']} · 실패 {total['실패']} · 확인 필요 {total['확인 필요']} · 미검증 {total['미검증']} · 해당 없음 {total['해당 없음']} · 그룹 {len(by_area)} · 실패 캡처 {len(set(s['file'] for s in shots.values()))} · 스모크 캡처 {len(smokes)} · 실행 테스트 {len(tests)}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
