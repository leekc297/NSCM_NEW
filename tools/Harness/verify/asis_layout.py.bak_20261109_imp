"""AS-IS 조회조건 패널 배치 순서 — 디자이너 LayoutControl 좌표(그룹 오프셋 누적) 기준 위→아래 줄, 줄 안 왼→오른 (2026-10-30 SCP0100 조치 필요 6번 계기 · 검사기 결함 T11)

  python tools/Harness/verify/asis_layout.py <MENU_ID> [<AS-IS ID>]      # 배치 순서·이름 후보 출력(파일 쓰기 없음)

사례: SC1(E2E smoke '기준표 순서')이 search_cond.csv 의 tobe_order 번호를 '화면 배치 순서' 로 보고 FAIL 을 냈다.
  그 번호는 기준표 xlsx 의 정리 순서이지 화면 좌표 순서가 아니다. SCP0100 TO-BE 화면 1행
  Div → From Site → Cell Group → Search Mode → PJT → Bucket → Period 은 AS-IS 디자이너 배치와 같았다(사용자 판정 '판정 오류').
  → 순서 FAIL 은 '기준표 순서와도, AS-IS 화면 배치와도 다를 때' 만 낸다.

이름 맞추기: 컨트롤마다 이름 후보 = plan.json fields(asis 컨트롤 → TO-BE 라벨 목록) ∪ 디자이너 LayoutControlItem.Text('*' 제외)
  ∪ 기준표(search_cond.csv) asis_name → tobe_name. 화면 토큰과 후보가 같으면 그 컨트롤이다.
한계(보수): 좌표가 없는 컨트롤(코드에서 추가)·코드로 바꾼 Visibility 는 반영하지 못한다. 이름을 못 맞춘 화면 토큰은
  비교에서 빠지고 그 수를 돌려준다 — 호출 쪽은 맞춘 토큰이 2개 미만이면 판정하지 않는다(ERROR/원판정 유지).
"""
import csv
import json
import os
import re
import sys
from asis_variant import is_main  # 2026-11-09 T172: variant 'only' 화면(SSP 등 180) = 현행 — 판정 단일 원천

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
ROW_TOL = 12  # 같은 줄로 보는 y 차이(px) — smoke-extra.ts 화면 배치 순서와 같은 값


def norm(s):
    return re.sub(r'[^a-z0-9가-힣]', '', (s or '').lower())


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def designer_path(asis_id):
    for r in read_csv(P('Doc', 'asisfacts', 'screens', asis_id, 'controls.csv')):
        f = (r.get('file') or '').replace('\\', '/')
        if is_main(r, P('Doc', 'asisfacts', 'screens', asis_id)) and f.lower().endswith('.designer.cs'):
            for base in (P('GSCM'), ROOT):
                fp = os.path.join(base, f)
                if os.path.exists(fp):
                    return fp
    return ''


def layout_items(menu_id, asis_id=''):
    """[{ctl, item, x, y, aliases}] — 좌표순(줄 → x). 디자이너를 못 찾으면 []"""
    menu_id = menu_id.upper(); asis_id = (asis_id or menu_id).upper()
    fp = designer_path(asis_id)
    if not fp:
        return []
    s = open(fp, encoding='utf-8-sig', errors='replace').read()
    ctl = dict(re.findall(r'this\.(\w+)\.Control = this\.(\w+);', s))
    loc = {k: (int(x), int(y)) for k, x, y in re.findall(r'this\.(\w+)\.Location = new System\.Drawing\.Point\((-?\d+), (-?\d+)\);', s)}
    txt = dict(re.findall(r'this\.(\w+)\.Text = "([^"]*)";', s))
    parent = {}
    for g, body in re.findall(r'this\.(\w+)\.Items\.AddRange\(new [^{]*\{([^}]*)\}', s):
        for c in re.findall(r'this\.(\w+)', body):
            parent[c] = g

    def absolute(k):
        x, y = loc.get(k, (0, 0)); g = parent.get(k); seen = set()
        while g and g not in seen:  # 중첩 그룹은 그룹 좌표를 더한다(순환 방어)
            seen.add(g); gx, gy = loc.get(g, (0, 0)); x += gx; y += gy; g = parent.get(g)
        return x, y

    # 이름 후보: plan.json fields(asis 컨트롤 → TO-BE 라벨들) · 기준표 asis_name → tobe_name
    by_ctl = {}
    pf = P('Doc', 'e2e', 'specs', f'{menu_id}.plan.json')
    if os.path.exists(pf):
        try:
            for f in json.load(open(pf, encoding='utf-8')).get('fields') or []:
                if f.get('asis'):
                    by_ctl.setdefault(f['asis'], set()).update(norm(x) for x in [f.get('label'), f.get('tobeLabel')] + list(f.get('labels') or []) if x)
        except Exception:
            pass
    sc = [r for r in read_csv(P('tools', 'Harness', 'rules', 'search_cond.csv')) if (r.get('menu_id') or '').upper() == menu_id]
    a2t = {}
    for r in sc:
        if (r.get('asis_name') or '').strip():
            a2t.setdefault(norm(r['asis_name']), set()).update({norm(r.get('tobe_name') or ''), norm(r['asis_name'])} - {''})

    out = []
    for item, c in ctl.items():
        if item not in loc:
            continue
        t = (txt.get(item) or '').replace('*', '').strip()
        al = set(by_ctl.get(c, set()))
        if t and not re.match(r'^(layoutControlItem|emptySpaceItem|simpleLabelItem)\d*$', t, re.I):
            al.add(norm(t)); al |= a2t.get(norm(t), set())
        for a in list(al):
            al |= a2t.get(a, set())
        al.discard('')
        if not al:
            continue
        x, y = absolute(item)
        out.append({'ctl': c, 'item': item, 'x': x, 'y': y, 'text': t, 'aliases': al})
    out.sort(key=lambda d: (d['y'], d['x']))
    rows_, cur, y0 = [], [], None  # 줄 묶기: 줄 첫 항목 y 와 ROW_TOL 이내면 같은 줄
    for d in out:
        if y0 is None or d['y'] - y0 > ROW_TOL:
            if cur: rows_.append(cur)
            cur, y0 = [], d['y']
        cur.append(d)
    if cur: rows_.append(cur)
    return [d for r in rows_ for d in sorted(r, key=lambda d: d['x'])]


def compare(menu_id, screen_tokens, asis_id=''):
    """화면 순서 토큰(정규화) ↔ AS-IS 배치 순서.
    반환 {ok, matched, asis_seq, screen_seq, unmatched, reason} — matched < 2 면 ok=None(판정 불가)"""
    items = layout_items(menu_id, asis_id)
    if not items:
        return {'ok': None, 'matched': 0, 'asis_seq': [], 'screen_seq': [], 'unmatched': list(screen_tokens), 'reason': 'AS-IS 디자이너 배치 없음'}
    # 같은 라벨이 두 컨트롤의 후보일 수 있다(SCP0100 'Search Level' = 라디오 rgrpSearchLevel 의 TO-BE 라벨 목록 · 콤보 cboSearchLevel 의 Text)
    #   → 후보가 적은 토큰부터 배정하고, 디자이너 Text 가 그 토큰과 같은 컨트롤을 먼저 고른다
    cand = {t: [i for i, d in enumerate(items) if norm(t) in d['aliases']] for t in screen_tokens}
    pos, unmatched = {}, []
    for t in sorted(dict.fromkeys(screen_tokens), key=lambda t: (len(cand[t]) or 99, screen_tokens.index(t))):
        free = [i for i in cand[t] if i not in pos.values()]
        k = next((i for i in free if norm(items[i]['text']) == norm(t)), free[0] if free else None)
        if k is None:
            unmatched.append(t); continue
        pos[t] = k
    screen_seq = [t for t in screen_tokens if t in pos]
    asis_seq = sorted(screen_seq, key=lambda t: pos[t])
    if len(screen_seq) < 2:
        return {'ok': None, 'matched': len(screen_seq), 'asis_seq': asis_seq, 'screen_seq': screen_seq, 'unmatched': unmatched, 'reason': '맞춘 조건 2개 미만'}
    return {'ok': screen_seq == asis_seq, 'matched': len(screen_seq), 'asis_seq': asis_seq, 'screen_seq': screen_seq, 'unmatched': unmatched, 'reason': ''}


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    mid = sys.argv[1].upper(); aid = sys.argv[2].upper() if len(sys.argv) > 2 else ''
    for d in layout_items(mid, aid):
        print(f"({d['x']:>5},{d['y']:>4}) {d['ctl']:<18} {d['text']:<20} {sorted(d['aliases'])}")
