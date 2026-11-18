# -*- coding: utf-8 -*-
"""수신 스냅샷(snap/received) ↔ AS-IS 유래 기대(snap/expected) 대조 — 골든 승인 전 기계 검증(2026-11-06 플랜 3-4)
  python tools/Harness/verify/snap_validate.py <ID>      # → Doc/verify/<ID>/snap/snap_validate.csv (key, kind, scope, status OK|MISMATCH|NA, missing, order, type_warn, extra, basis)
판정
  조회조건(aria.yml): 기대 라벨 전부 존재(MISSING) · 기대 순서대로 등장(ORDER · CR-071) · 라벨 뒤 3줄 안에 기대 컨트롤 역할(type_warn — 경고만)
  헤더(txt): 기대 컬럼 라벨 전부 헤더 셀에 존재(MISSING · 별칭·'*'·동적 토큰 정규화) · 수신에만 있는 셀 = extra(결함 아님 · 보고)
  버튼(aria.yml): 기대 버튼 코드마다 접두 일치하는 button 존재(MISSING)
  팝업·화면샷: 기대 없음 → NA(사람 확인)
승인 조건(snap_approve.py): MISSING·ORDER 0(type_warn·extra 는 허용) — 아니면 --force 와 사유 필요
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)


def nrm(s):
    s = re.sub(r'^\s*\*+\s*|\s*\*+\s*$', '', str(s or ''))
    s = re.sub(r'[^a-z0-9가-힣]', '', s.lower())
    return 'division' if s == 'div' else s  # 'Div.'↔'Division' 라벨 별칭(smoke findCond 와 동일 · 2026-11-06 헤더 'Division*' ↔ 'Div')


def aria_lines(text):
    out = []
    for ln in text.replace('\r', '').split('\n'):
        if not ln.strip():
            continue
        m = re.match(r'^(\s*)-\s*(\w+)(?:\s+"([^"]*)")?(?:\s*:\s*(.*))?$', ln)
        if m:
            role, name, rest = m.group(2), m.group(3) or '', m.group(4) or ''
            out.append({'raw': ln, 'role': role, 'name': name, 'text': (name or rest or '').strip()})
        else:
            out.append({'raw': ln, 'role': '', 'name': '', 'text': ln.strip()})
    return out


def validate_conds(exp, text):
    lines = aria_lines(text)
    idx, missing, type_warn = [], [], []
    for it in exp.get('items') or []:
        lab = nrm(it['label'])
        pos = next((i for i, l in enumerate(lines) if lab and nrm(l['text']) == lab), None)
        if pos is None:
            pos = next((i for i, l in enumerate(lines) if lab and lab in nrm(l['text']) and len(nrm(l['text'])) <= len(lab) + 12), None)
        if pos is None:
            missing.append(it['label']); continue
        idx.append((it['seq'], pos, it['label']))
        roles = it.get('roles') or []
        if roles and not any(l['role'] in roles for l in lines[pos:pos + 4]):
            type_warn.append(f"{it['label']}:{it.get('type1')}≠{','.join(sorted({l['role'] for l in lines[pos:pos + 4] if l['role']}))}")
    order = []
    seq = [x for x in sorted(idx)]
    dom_order = []
    for a, b in zip(seq, seq[1:]):
        if b[1] < a[1]:
            dom_order.append(f"{a[2]}→{b[2]}")
    # 순서 판정 = 시각 순서(# visual-order: 줄 · findCond bbox · SC1 과 같은 기준). aria 의 DOM 순서 차이는 경고만(CSS 배치가 DOM 과 다를 수 있음 · 2026-11-06 SCP0127)
    m = re.search(r'^#\s*visual-order:\s*(.*)$', text, re.M)
    if m:
        vis = [nrm(x) for x in m.group(1).split('>') if x.strip()]
        exp_seq = [nrm(it['label']) for it in sorted((exp.get('items') or []), key=lambda it: it['seq']) if nrm(it['label']) in vis]
        got_seq = [v for v in vis if v in exp_seq]
        if exp_seq != got_seq:
            order.append('시각 순서 ' + ' > '.join(got_seq) + ' ≠ 기준표 ' + ' > '.join(exp_seq))
        if dom_order:
            type_warn.append('DOM 순서≠기준표(경고): ' + ';'.join(dom_order))
    else:
        order = dom_order
        type_warn.append('visual-order 줄 없음 — DOM 순서로 판정(bbox 미측정)')
    return missing, order, type_warn, []


def validate_header(exp, text):
    cells = set()
    for ln in text.replace('\r', '').split('\n'):
        for c in ln.split(' | '):
            if c.strip():
                cells.add(nrm(c))
    hidden = {nrm(c) for c in (exp.get('meta_hidden') or [])}
    missing_all = [c for c in (exp.get('columns') or []) if nrm(c) and nrm(c) not in cells]
    missing = [c for c in missing_all if nrm(c) not in hidden]
    warn = [f"META 숨김(VISIBLE_FLAG=N · 설계 결정 확인): {c}" for c in missing_all if nrm(c) in hidden]
    expn = {nrm(c) for c in (exp.get('columns') or [])}
    extra = sorted(c for c in cells if c not in expn and not re.search(r'\{ym\}|\{ymd\}|\{w\}|\{date\}|\{n\}', c))
    return missing, [], warn, extra


def mapping_text(mid):
    """화면 대조표(__asis-mapping__.md) 원문 — Doc/tobefacts/screens/_index.csv 의 화면 → features/<feature>/src/pages/<page>"""
    try:
        with open(P('Doc', 'tobefacts', 'screens', '_index.csv'), encoding='utf-8-sig', newline='') as f:
            for r in csv.reader(f):
                if len(r) > 3 and r[1].upper() == mid.upper():
                    mp = P('nscm-fe', 'features', r[2], 'src', 'pages', r[3], '__asis-mapping__.md')
                    return open(mp, encoding='utf-8').read() if os.path.exists(mp) else ''
    except OSError:
        pass
    return ''


def validate_buttons(exp, text, mid=''):
    lines = aria_lines(text)
    btns = [l for l in lines if l['role'] == 'button']
    names = [nrm(l['name'] or l['text']) for l in btns]
    unnamed = sum(1 for nm in names if not nm)
    mtext = None
    missing, warn = [], []
    for code in exp.get('codes') or []:
        head = nrm(code.split('_')[0])
        if not any(nm.startswith(head) for nm in names):
            cu = code.upper()
            if cu == 'SEARCH':
                warn.append('SEARCH: Search(F5) 는 조회영역(SearchArea) 안의 버튼 — SubTitle 버튼 바 스냅샷 대상 아님(조회조건 스냅샷에서 확인)')  # 2026-11-06 실측
            # 2026-11-17 SCP0111 실측: 아래 3종은 버튼이 없어서가 아니라 대조 방식 때문에 누락으로 잡히던 것(검사기 결함)
            elif cu == 'EDIT':
                warn.append('EDIT: TO-BE 룰 CR-084·CR-093(편집 버튼 없음 · 조회 즉시 상시 편집) — 누락 아님')
            elif cu == 'EXCEL' and unnamed:
                warn.append(f'EXCEL: 공용 SubTitle Excel 은 툴팁만 있는 아이콘 버튼(접근성 이름 없음 · SubTitle.tsx Tooltip title=Excel) — 이름 없는 버튼 {unnamed}개로 확인')
            elif cu == 'SAVEDETAIL' and any(nm.startswith('save') for nm in names):
                if mtext is None: mtext = mapping_text(mid)
                if re.search(r'SAVE\s*/\s*SAVEDETAIL|SAVEDETAIL\s*/\s*SAVE', mtext or ''):
                    warn.append('SAVEDETAIL: 대조표가 Save 버튼 하나로 매핑(SAVE / SAVEDETAIL · 권한별 SP 분기) — Save 버튼 있음')
                else:
                    missing.append(code)
            else:
                missing.append(code)
    return missing, [], warn, []


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    mid = sys.argv[1].upper(); sd = P('Doc', 'verify', mid, 'snap')
    ed, rdir = os.path.join(sd, 'expected'), os.path.join(sd, 'received')
    try:
        res = json.load(open(os.path.join(sd, 'results.json'), encoding='utf-8'))
    except (OSError, ValueError):
        print(f'[snap_validate] {mid}: snap/results.json 없음 — _snap.spec 먼저 실행'); return 2
    rows = []
    for r in res:
        key, kind, scope = r['key'], r['kind'], r['scope']
        rp = r.get('received') or ''
        if kind == '화면샷' or not rp or not os.path.isfile(P(rp)):  # 화면샷은 AS-IS 유래 기대 없음(사람 확인) · DIFF 의 received 는 artifacts 폴더
            rows.append({'key': key, 'kind': kind, 'scope': scope, 'status': 'NA', 'missing': '', 'order': '', 'type_warn': '', 'extra': '', 'basis': ('화면샷 — 사람 확인(' + str(r.get('status')) + ')') if kind == '화면샷' else f"수신본 없음({r.get('status')})"}); continue
        text = open(P(rp), encoding='utf-8').read()
        ep = os.path.join(ed, key + '.json')
        if not os.path.exists(ep):
            rows.append({'key': key, 'kind': kind, 'scope': scope, 'status': 'NA', 'missing': '', 'order': '', 'type_warn': '', 'extra': '', 'basis': 'AS-IS 유래 기대 없음(팝업·화면샷) — 사람 확인'}); continue
        exp = json.load(open(ep, encoding='utf-8'))
        fn = {'조회조건': validate_conds, '헤더': validate_header, '버튼': validate_buttons}.get(kind)
        if not fn:
            rows.append({'key': key, 'kind': kind, 'scope': scope, 'status': 'NA', 'missing': '', 'order': '', 'type_warn': '', 'extra': '', 'basis': '검증기 없음'}); continue
        missing, order, tw, extra = fn(exp, text, mid) if kind == '버튼' else fn(exp, text)
        rows.append({'key': key, 'kind': kind, 'scope': scope, 'status': 'OK' if not missing and not order else 'MISMATCH', 'missing': ';'.join(missing), 'order': ';'.join(order), 'type_warn': ';'.join(tw)[:300], 'extra': ';'.join(extra)[:300], 'basis': exp.get('src', '')})
    out = os.path.join(sd, 'snap_validate.csv')
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['key', 'kind', 'scope', 'status', 'missing', 'order', 'type_warn', 'extra', 'basis']); w.writeheader(); w.writerows(rows)
    cnt = {}
    for r in rows: cnt[r['status']] = cnt.get(r['status'], 0) + 1
    print(f"[snap_validate] {mid}: {len(rows)}건 → " + ' · '.join(f'{k} {v}' for k, v in sorted(cnt.items())) + f" → Doc/verify/{mid}/snap/snap_validate.csv")
    for r in rows:
        if r['status'] == 'MISMATCH': print(f"   ✖ {r['key']}: 누락 [{r['missing']}] 순서 [{r['order']}]")
        elif r['type_warn'] or r['extra']: print(f"   ⚠ {r['key']}: 역할 {r['type_warn'][:120]} · 수신 추가 {r['extra'][:120]}")
    return 2 if cnt.get('MISMATCH') else 0


if __name__ == '__main__':
    sys.exit(main())
