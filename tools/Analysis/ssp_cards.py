# -*- coding: utf-8 -*-
"""
카드형 흐름(HTML) 조각 — 2026-11-11 사용자 지적「옆으로만 나열해 인식성이 떨어짐」 보완
슬라이드처럼 '색 띠 제목 + 본문' 카드를 줄 단위로 배치하고, 줄이 바뀌면 꺾인 화살표로 잇는다.
- 산출 문자열은 한 줄짜리 HTML(`<div class="spf …`) — ssp_flow.py md2html 이 그대로 통과시킨다. 모양(CSS)은 ssp_flow_view.css
- Markdown 뷰어에서는 CSS 없이 제목 + 목록으로 보인다(내용 누락 없음)
"""
import html

AR = 30  # 카드 사이 화살표 칸 폭(px) — ssp_flow_view.css 의 --ar 와 같아야 한다


def esc(s): return html.escape(str(s), quote=False)


def card(title, lines, color, key=None, cls='', bullets=True):
    """색 띠 제목 + 본문 목록. key = 클릭 시 열 상세(레지스트리 키)"""
    body = ('<ul>' + ''.join(f'<li>{esc(l)}</li>' for l in lines) + '</ul>') if (lines and bullets) else ''.join(f'<div class="spf-l">{esc(l)}</div>' for l in lines)
    k = f' data-k="{esc(key)}"' if key else ''
    return f'<div class="spf-card {cls}" style="--c:{color}"{k}><div class="spf-h">{esc(title)}</div>{body}</div>'


def sub(title, lines, key=None):
    """열 안의 작은 상자(굵은 이름 + 설명)"""
    k = f' data-k="{esc(key)}"' if key else ''
    return f'<div class="spf-sub"{k}><b>{esc(title)}</b>' + ''.join(f'<span>{esc(l)}</span>' for l in lines) + '</div>'


def column(title, inner, color):
    """제목 띠 + 작은 상자 묶음"""
    return f'<div class="spf-col" style="--c:{color}"><div class="spf-h">{esc(title)}</div>{inner}</div>'


def rows(cells, per_row, sym='▶', snake=True):
    """카드 목록을 per_row 개씩 줄로 나누고 화살표를 넣는다. 줄 끝 → 다음 줄 처음은 꺾인 화살표"""
    out = []
    for i in range(0, len(cells), per_row):
        chunk = cells[i:i + per_row]; parts = []
        for j in range(per_row):
            if j: parts.append(f'<div class="spf-ar">{sym if j < len(chunk) else ""}</div>')
            parts.append(chunk[j] if j < len(chunk) else '<div class="spf-card spf-empty"></div>')
        if i and snake: out.append(f'<div class="spf-snake" style="--n:{per_row}"><i></i><u></u></div>')
        out.append('<div class="spf-row">' + ''.join(parts) + '</div>')
    return ''.join(out)


def legend(items):
    """items = [(이름, 색)]"""
    return '<div class="spf-leg">' + ''.join(f'<span style="--c:{c}"><i></i>{esc(n)}</span>' for n, c in items) + '</div>'


def note(title, lines, color):
    return f'<div class="spf-note" style="--c:{color}"><b class="t">{esc(title)}</b>' + ''.join((f'<b>{esc(l)}</b>' if i == 0 else f'<span>{esc(l)}</span>') for i, l in enumerate(lines)) + '</div>'


def wrap(inner, cls=''):
    return f'<div class="spf {cls}">{inner}</div>'
