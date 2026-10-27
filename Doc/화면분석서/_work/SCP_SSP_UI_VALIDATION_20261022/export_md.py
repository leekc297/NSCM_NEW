# -*- coding: utf-8 -*-
"""화면 VALIDATION 취합 xlsx → md (시스템·AI 가 읽을 수 있는 텍스트본, 2026-10-23 사용자 지시)
- 원천 = 완성된 xlsx 그대로(빌더 재실행 없이 엑셀 셀 값만 옮김 → 엑셀과 1:1)
- {DOM}_화면_VALIDATION_취합_20261022.md : 전 시트 전 행
- {DOM}_화면_VALIDATION_취합_20261022/<화면ID>.md : 화면별 분할(차단·보정_필터·제외 행) + _INDEX.md"""
import os, re, sys
import openpyxl

OUT = r'C:/Projects/NSCM/Doc/화면분석서'
STAMP = '20261022'


def cell(v):
    if v is None:
        return ''
    s = str(v).replace('\r\n', '\n').replace('\r', '\n')
    return s.replace('|', '\\|').replace('\n', '<br>')


def table(hdr, rows):
    out = ['| ' + ' | '.join(cell(h) for h in hdr) + ' |', '|' + '---|' * len(hdr)]
    out += ['| ' + ' | '.join(cell(v) for v in r) + ' |' for r in rows]
    return '\n'.join(out)


def sid_of(v):
    m = re.match(r'(SCP|SSP)\d{4}', str(v or ''))
    return m.group(0) if m else None


def export(dom):
    src = f'{OUT}/{dom}_화면_VALIDATION_취합_{STAMP}.xlsx'
    wb = openpyxl.load_workbook(src, read_only=True)
    sheets = {n: [list(r) for r in wb[n].iter_rows(values_only=True)] for n in wb.sheetnames}
    head = [f'# {dom} 화면 VALIDATION 취합 ({STAMP})', '',
            f'> 원본 엑셀: `Doc/화면분석서/{dom}_화면_VALIDATION_취합_{STAMP}.xlsx` 의 전 시트·전 행을 그대로 옮긴 텍스트본(셀 줄바꿈 = `<br>`, `|` = `\\|`).',
            f'> 화면별 분할본: `Doc/화면분석서/{dom}_화면_VALIDATION_취합_{STAMP}/<화면ID>.md` · 생성 스크립트 `Doc/화면분석서/_work/SCP_SSP_UI_VALIDATION_20261022/export_md.py`.',
            '> 판정 기준·용어(TO-BE 적용여부 / TO-BE 적용 TAG / 메시지 의미 대조)는 아래 "작성기준" 시트가 정본.', '',
            '## 시트 목록', '']
    head += [f'- [{n}](#{n.lower().replace(" ", "-")}) — {max(len(sheets[n]) - 1, 0)}행' for n in sheets]
    body = []
    for n, rows in sheets.items():
        body += ['', f'## {n}', '']
        body.append(table(rows[0], rows[1:]) if rows else '(빈 시트)')
    path = f'{OUT}/{dom}_화면_VALIDATION_취합_{STAMP}.md'
    open(path, 'w', encoding='utf-8').write('\n'.join(head + body) + '\n')

    # 화면별 분할
    d = f'{OUT}/{dom}_화면_VALIDATION_취합_{STAMP}'
    os.makedirs(d, exist_ok=True)
    per = {}
    for n in ('UI별VALIDATION_차단', 'UI별VALIDATION_보정_필터', '제외_미실행'):
        rows = sheets.get(n) or []
        for r in rows[1:]:
            s = sid_of(r[0])
            if s:
                per.setdefault(s, {}).setdefault(n, [rows[0]]).append(r)
    stat = {r[0]: r for r in (sheets.get('판독현황') or [])[1:]}
    idx = [f'# {dom} 화면 VALIDATION 취합 — 화면별 인덱스 ({STAMP})', '',
           f'> 원본: `Doc/화면분석서/{dom}_화면_VALIDATION_취합_{STAMP}.xlsx` · 전체 텍스트본 `../{dom}_화면_VALIDATION_취합_{STAMP}.md` · 판정 기준 = 전체본 "작성기준" 시트.', '',
           '| 화면 | 차단 행 | 보정_필터 행 | 제외 행 | 파일 |', '|---|---|---|---|---|']
    names = {}
    for r in (sheets.get('판독현황') or [])[1:]:
        s = sid_of(r[0])
        if s:
            names[s] = r[0]
    for s in sorted(set(per) | set(names)):
        p = per.get(s, {})
        cnt = {k: len(v) - 1 for k, v in p.items()}
        title = names.get(s, s)
        lines = [f'# {title} — VALIDATION 취합 ({STAMP})', '',
                 f'> 원본: `Doc/화면분석서/{dom}_화면_VALIDATION_취합_{STAMP}.xlsx` 에서 이 화면 행만 추출. 판정 기준·용어 = 전체본 `../{dom}_화면_VALIDATION_취합_{STAMP}.md` "작성기준".', '']
        st = stat.get(title)
        if st:
            lines += ['## 판독현황', '', table(sheets['판독현황'][0], [st]), '']
        for n in ('UI별VALIDATION_차단', 'UI별VALIDATION_보정_필터', '제외_미실행'):
            lines += [f'## {n}', '']
            lines.append(table(p[n][0], p[n][1:]) if n in p else '(해당 행 없음)')
            lines.append('')
        open(f'{d}/{s}.md', 'w', encoding='utf-8').write('\n'.join(lines))
        idx.append(f"| {cell(title)} | {cnt.get('UI별VALIDATION_차단', 0)} | {cnt.get('UI별VALIDATION_보정_필터', 0)} | {cnt.get('제외_미실행', 0)} | [{s}.md]({s}.md) |")
    open(f'{d}/_INDEX.md', 'w', encoding='utf-8').write('\n'.join(idx) + '\n')

    # 검증: xlsx 행 수 = md 표 행 수(시트별), 화면별 분할 합계 = 원 시트 화면행 수
    md = open(path, encoding='utf-8').read()
    for n, rows in sheets.items():
        sec = md.split(f'\n## {n}\n', 1)[1].split('\n## ', 1)[0]
        got = sum(1 for ln in sec.split('\n') if ln.startswith('| ')) - 1 if rows else 0
        assert got == max(len(rows) - 1, 0), (dom, n, got, len(rows) - 1)
    for n in ('UI별VALIDATION_차단', 'UI별VALIDATION_보정_필터', '제외_미실행'):
        a = sum(1 for r in (sheets.get(n) or [])[1:] if sid_of(r[0]))
        b = sum(len(p[n]) - 1 for p in per.values() if n in p)
        assert a == b, (dom, n, a, b)
    print(dom, {n: len(r) - 1 for n, r in sheets.items()}, 'screens', len(set(per) | set(names)), os.path.getsize(path))


for dom in (sys.argv[1:] or ['SCP', 'SSP']):
    export(dom)
