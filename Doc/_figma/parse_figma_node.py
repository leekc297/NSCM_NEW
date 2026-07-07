#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Figma node JSON → UI 개발용 객체 분석 MD.
사용: python parse_figma_node.py <node_json> <node_id> <out_md> "<title>"
객체별: type/name/절대좌표(x,y,w,h)/fill(hex)/text/component/typography 추출."""
import json, sys, collections

node_json, node_id, out_md, title = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
data = json.load(open(node_json, encoding='utf-8'))
# /files?ids= 응답: top-level document + components + styles. 요청 노드를 id 로 탐색.
components = data.get('components', {}) or {}
styles_meta = data.get('styles', {}) or {}
def find_node(n, nid):
    if n.get('id') == nid: return n
    for c in (n.get('children') or []):
        r = find_node(c, nid)
        if r: return r
    return None
doc = find_node(data['document'], node_id)
if doc is None:
    print(f"ERR: node {node_id} not found"); sys.exit(1)
# 프레임 좌상단을 원점(0,0)으로 정규화 (Figma 캔버스 절대좌표 → 프레임 상대좌표)
_rb = doc.get('absoluteBoundingBox') or {}
OX, OY = _rb.get('x', 0) or 0, _rb.get('y', 0) or 0

def hexcolor(c, op=1.0):
    if c is None: return None
    a = c.get('a', 1.0) * op
    r, g, b = [int(round(c.get(k, 0) * 255)) for k in ('r', 'g', 'b')]
    h = f"#{r:02X}{g:02X}{b:02X}"
    return h if a >= 0.999 else f"{h}@{a:.2f}"

def fill_of(n):
    fills = n.get('fills') or []
    for f in fills:
        if f.get('visible', True) and f.get('type') == 'SOLID':
            return hexcolor(f.get('color'), f.get('opacity', 1.0))
    return None

def stroke_of(n):
    for s in (n.get('strokes') or []):
        if s.get('visible', True) and s.get('type') == 'SOLID':
            return hexcolor(s.get('color'), s.get('opacity', 1.0))
    return None

# 절대좌표 (absoluteBoundingBox)
rows = []          # 전체 객체 트리
texts = []         # TEXT only
fills_freq = collections.Counter()
inst_freq = collections.Counter()
inst_bbox = {}
text_styles = collections.Counter()

def walk(n, depth, parent_path):
    t = n.get('type'); name = n.get('name', '')
    bb = n.get('absoluteBoundingBox') or {}
    _x, _y = bb.get('x'), bb.get('y')
    x = None if _x is None else _x - OX
    y = None if _y is None else _y - OY
    w, h = bb.get('width'), bb.get('height')
    fill = fill_of(n); stroke = stroke_of(n)
    txt = n.get('characters')
    comp_name = ''
    if t == 'INSTANCE':
        cid = n.get('componentId')
        comp_name = components.get(cid, {}).get('name', cid or '')
        inst_freq[name] += 1
        if name not in inst_bbox and w: inst_bbox[name] = (round(w), round(h))
    if fill: fills_freq[fill] += 1
    rows.append(dict(depth=depth, type=t, name=name, x=x, y=y, w=w, h=h,
                     fill=fill, stroke=stroke, text=txt, comp=comp_name))
    if t == 'TEXT' and txt is not None:
        st = n.get('style', {}) or {}
        # bound text style name
        sid = (n.get('styles') or {}).get('text')
        sname = styles_meta.get(sid, {}).get('name', '') if sid else ''
        texts.append(dict(x=x, y=y, w=w, h=h, text=txt.replace('\n', ' '),
                          font=st.get('fontFamily', ''), size=st.get('fontSize', ''),
                          weight=st.get('fontWeight', ''), align=st.get('textAlignHorizontal', ''),
                          fill=fill, style=sname))
        if sname: text_styles[sname] += 1
    for c in (n.get('children') or []):
        walk(c, depth + 1, parent_path + '/' + name)

walk(doc, 0, '')

def num(v):
    return '' if v is None else (str(int(round(v))) if isinstance(v, (int, float)) else str(v))

L = []
L.append(f"# {title}")
L.append("")
L.append(f"> 원본 Figma node `{node_id}` — file `c9VYF8oleb9TczKeFWi4ka` (Next SCM Working File)")
L.append(f"> 생성: parse_figma_node.py · 방식: node JSON(absoluteBoundingBox 절대좌표 + characters 실라벨) · 좌표계 원점=프레임 좌상단 기준 절대값(px)")
rootbb = doc.get('absoluteBoundingBox') or {}
L.append(f"> 프레임: **{doc.get('name')}** — {num(rootbb.get('width'))} × {num(rootbb.get('height'))} px")
L.append(f"> 총 객체 {len(rows)} · TEXT 라벨 {len(texts)} · INSTANCE 종류 {len(inst_freq)}")
L.append("")

# §1 객체 트리 (전체)
L.append("## §1. 객체 트리 (전체) — type / name / x / y / w / h / fill / stroke / text")
L.append("")
L.append("| depth | type | name | x | y | w | h | fill | stroke | text/comp |")
L.append("|---|---|---|--:|--:|--:|--:|---|---|---|")
for r in rows:
    extra = ''
    if r['text']: extra = '“' + (r['text'][:40]) + '”'
    elif r['comp']: extra = '⟶ ' + r['comp']
    indent = '·' * r['depth']
    L.append(f"| {r['depth']} | {r['type']} | {indent}{r['name'][:40]} | {num(r['x'])} | {num(r['y'])} | {num(r['w'])} | {num(r['h'])} | {r['fill'] or ''} | {r['stroke'] or ''} | {extra} |")
L.append("")

# §2 TEXT 라벨 (UI 개발 핵심)
L.append("## §2. 텍스트 라벨 (실측, y→x 정렬) — UI 라벨/버튼/컬럼 헤더")
L.append("")
L.append("| text | x | y | w | h | font | size | weight | align | fill | style |")
L.append("|---|--:|--:|--:|--:|---|--:|--:|---|---|---|")
for tx in sorted(texts, key=lambda d: (d['y'] or 0, d['x'] or 0)):
    L.append(f"| {tx['text'][:50]} | {num(tx['x'])} | {num(tx['y'])} | {num(tx['w'])} | {num(tx['h'])} | {tx['font']} | {tx['size']} | {tx['weight']} | {tx['align']} | {tx['fill'] or ''} | {tx['style']} |")
L.append("")

# §3 색상 토큰
L.append("## §3. 색상 토큰 (fill 빈도)")
L.append("")
L.append("| HEX | 사용 수 |")
L.append("|---|--:|")
for hx, cnt in fills_freq.most_common():
    L.append(f"| `{hx}` | {cnt} |")
L.append("")

# §4 컴포넌트 인스턴스
L.append("## §4. 컴포넌트 인스턴스 (Figma 컴포넌트 → @shared/components 매핑 후보)")
L.append("")
L.append("| 인스턴스 name | 사용 수 | 대표 크기(w×h) |")
L.append("|---|--:|---|")
for nm, cnt in inst_freq.most_common():
    bb = inst_bbox.get(nm, ('', ''))
    L.append(f"| {nm} | {cnt} | {bb[0]}×{bb[1]} |")
L.append("")

# §5 타이포그래피
L.append("## §5. 타이포그래피 (Figma TEXT style 토큰)")
L.append("")
L.append("| TEXT style | 사용 수 |")
L.append("|---|--:|")
for nm, cnt in text_styles.most_common():
    L.append(f"| {nm} | {cnt} |")
L.append("")

open(out_md, 'w', encoding='utf-8').write("\n".join(L))
print(f"OK -> {out_md} | objects={len(rows)} texts={len(texts)} instances={len(inst_freq)} fills={len(fills_freq)}")
