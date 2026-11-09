# -*- coding: utf-8 -*-
"""조치필요 정밀도(2026-11-06 플랜 G1) — 판(version)마다 '조치 필요' 시트 행 수 ÷ 사용자 확인 실결함 수를 기록한다.

  python tools/Harness/verify/precision.py <ID>        # Doc/verify/<ID>/precision.csv + 전역 Doc/verify/_precision.csv(그 화면 행만 교체 · 원자 쓰기)

판별 = CheckList 각 판(Doc/CheckList · old · 옛 Doc/화면분석서, make_verify_docs.prior_docs 와 같은 탐색)의 '조치 필요' 시트.
  조치필요(action_needed) = 그 시트의 검증 ID 행 수
  실결함(confirmed_defect) = 사용자의견 class ∈ {실제오류확인}(regress.cls) ∪ 그 행이 _user_verdicts_direct.csv 에 verdict=FAIL 로 있음
  허위(false_positive)     = class ∈ {판정오류, 대상아님, 중복} ∪ direct verdict ∈ {PASS, NA, SKIP}
  미검토(unreviewed)       = 나머지(의견·판정 없음)
  정밀도(precision)        = confirmed_defect ÷ (confirmed_defect + false_positive) — 검토된 행만 분모(미검토가 많으면 '검토율' 을 같이 본다)
regress.py 에 넣지 않는 이유: harvest 는 (화면,row_id) 최신 1건만 남겨 판별 분모를 복원할 수 없다.
"""
import csv, datetime, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
from regress import cls, rd, _replace  # 분류 규칙·원자 교체 재사용
import make_verify_docs as MVD  # prior_docs(판 탐색)

GLOBAL = os.path.join(ROOT, 'Doc', 'verify', '_precision.csv')
COLS = ['menu_id', 'version', 'file', 'action_needed', 'confirmed_defect', 'false_positive', 'duplicate', 'unreviewed', 'reviewed_ratio', 'precision', 'measured_at']


def direct_verdicts(mid):
    out = {}
    for d in rd(os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts_direct.csv')):
        if (d.get('menu_id') or '').upper() == mid:
            out[(d.get('row_id') or '').strip()] = (d.get('verdict') or '').strip().upper()
    return out


def read_action_sheet(path):
    """'조치 필요' 시트 → [(row_id, 사용자의견, 사용자판정)] · 시트 없으면 None"""
    import openpyxl
    try:
        wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    except Exception:
        return None
    ws = next((w for w in wb.worksheets if w.title.replace(' ', '') in ('조치필요', '조치필요항목')), None)
    if ws is None:
        return None
    rows = list(ws.iter_rows(values_only=True))
    if not rows:
        return []
    hi = next((i for i, rr in enumerate(rows[:5]) if rr and any(c and '검증 ID' in str(c) for c in rr)), 0)
    hdr = [str(c) if c else '' for c in rows[hi]]
    oi = next((k for k, h in enumerate(hdr) if '사용자의견' in h), None)
    vi = next((k for k, h in enumerate(hdr) if '사용자판정' in h), None)
    out = []
    for rr in rows[hi + 1:]:
        if not rr or len(rr) < 2 or not rr[1] or not re.match(r'^(V|T|EG|AD)-[0-9a-f]{8}$', str(rr[1])):  # EG-(팝업·권한 검사기 행)도 조치 필요 행(2026-11-06 SCP0127 E7 누락 실측)
            continue
        o = str(rr[oi]).strip() if oi is not None and oi < len(rr) and rr[oi] else ''
        v = str(rr[vi]).strip() if vi is not None and vi < len(rr) and rr[vi] else ''
        out.append((str(rr[1]), o, v))
    return out


def measure(mid):
    dv = direct_verdicts(mid)
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    out = []
    for f in MVD.prior_docs(mid):
        if '_CheckList_v' not in os.path.basename(f):
            continue
        m = re.search(r'_v(\d+)\.xlsx$', os.path.basename(f))
        ver = int(m.group(1)) if m else 0
        rows = read_action_sheet(f)
        if rows is None:
            continue
        conf = fp = dup = unr = 0
        for rid, op, uv in rows:
            c = cls(op) if op else ''
            d = dv.get(rid, '')
            uvc = cls(uv) if uv else ''
            if c == '실제오류확인' or d == 'FAIL' or uvc == '실제오류확인' or re.match(r'^(FAIL|오류)', uv, re.I):
                conf += 1
            elif c == '중복' or uvc == '중복':
                dup += 1
            elif c in ('판정오류', '대상아님') or d in ('PASS', 'NA', 'SKIP') or uvc in ('판정오류', '대상아님') or re.match(r'^(PASS|NA|정상)', uv, re.I):
                fp += 1
            else:
                unr += 1
        n = len(rows); reviewed = conf + fp + dup
        out.append({'menu_id': mid, 'version': ver, 'file': os.path.relpath(f, ROOT), 'action_needed': n, 'confirmed_defect': conf, 'false_positive': fp, 'duplicate': dup,
                    'unreviewed': unr, 'reviewed_ratio': f'{reviewed / n:.3f}' if n else '', 'precision': f'{conf / (conf + fp):.3f}' if (conf + fp) else '', 'measured_at': now})
    return out


def write_csv(path, rows):
    tmp = f'{path}.{os.getpid()}.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows([{k: r.get(k, '') for k in COLS} for r in rows])
    _replace(tmp, path)


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    mid = sys.argv[1].upper()
    rows = measure(mid)
    pd = os.path.join(ROOT, 'Doc', 'verify', mid)
    if not os.path.isdir(pd):
        print(f'[precision] {mid}: Doc/verify/{mid} 없음'); return 2
    write_csv(os.path.join(pd, 'precision.csv'), rows)
    keep = [r for r in rd(GLOBAL) if (r.get('menu_id') or '').upper() != mid]
    write_csv(GLOBAL, keep + rows)
    if not rows:
        print(f'[precision] {mid}: CheckList 판 없음(조치 필요 시트 0) → precision.csv 빈 파일')
        return 0
    last = rows[-1]
    print(f"[precision] {mid}: 판 {len(rows)}개 → Doc/verify/{mid}/precision.csv · 최신 v{last['version']} 조치필요 {last['action_needed']} · 실결함 {last['confirmed_defect']} · 허위 {last['false_positive']} · 중복 {last['duplicate']} · 미검토 {last['unreviewed']} · 정밀도 {last['precision'] or '미측정(검토 0)'}")
    for r in rows:
        print(f"   v{r['version']:>2} 조치 {r['action_needed']:>3} 실결함 {r['confirmed_defect']:>3} 허위 {r['false_positive']:>3} 중복 {r['duplicate']:>3} 미검토 {r['unreviewed']:>3} 정밀도 {r['precision'] or '-':>5} 검토율 {r['reviewed_ratio'] or '-'}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
