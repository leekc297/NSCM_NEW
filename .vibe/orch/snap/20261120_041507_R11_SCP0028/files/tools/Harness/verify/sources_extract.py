# -*- coding: utf-8 -*-
"""검증 지식 원천 xlsx 3개 → MD + 기계판독 CSV + 이미지 (누락 0 증명 포함) — Doc/verify/sources/

  python tools/Harness/verify/sources_extract.py [--only dm|gap|ssp45] [--dm <xlsx>] [--gap <xlsx>] [--ssp45 <xlsx>]

원천(2026-10-30 사용자 지시 — CheckList 가 이 3개 파일의 내역을 누락 없이 품게 하기 위한 1단계):
  dm     최종 단위테스트 결과 점검 (zio 관리) _ 202600826.xlsx   — 시트 '수정사항' 285행 × 23열 + 증빙 시트(결함 No. 이름) + 이미지
  gap    (20260928) 화면 기능 갭 분석 종합 (1).xlsx                — '갭분석' 506 · 'PI확인요청' 66 · '자체결함확인' 42 · 'Sheet1' 집계 · '조회영역이상'(빈 시트)
  ssp45  ☆NSCME_SCP&SSP 테스트_DMF0045(Shipment Request).xlsx     — '공통요건' 25 · '검증내역' 12

원칙(anti-simplification):
  · 모든 시트의 비어있지 않은 셀을 전부 기록한다 — 표 시트는 열 이름 그대로 표(MD)+CSV, 그 밖(증빙·집계·표 바깥 셀)은 `시트!R행C열 = 값` 목록.
  · 이미지는 drawing XML 앵커(시트·행·열)로 위치를 잡아 _img/<key>/ 에 저장하고 MD 에 링크. 앵커가 없는 media 도 _unanchored 로 저장.
  · 자르지 않는다(최대 셀 2,412자). 날짜는 YYYY-MM-DD(시각 있으면 포함).
  · 시트별 xlsx 셀 수 = 기록 셀 수, 이미지 참조 수 = 저장 수 를 _extract_report.md 로 증명. 하나라도 다르면 exit 1 (PASS 자가선언 금지).
  · 손편집 금지 — 원천 xlsx 를 고친 뒤 재실행.
"""
import argparse
import collections
import csv
import datetime
import os
import re
import sys
import zipfile

import openpyxl

try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
OUT_DIR = os.path.join(ROOT, 'Doc', 'verify', 'sources')
RECV = r'C:\TRANFILE\RECEIVE'

# key → 원천 정의. tables: 시트명 → {header: 헤더 행 번호 목록(2단 헤더는 2개 · 아래 행 우선), id_col: 행 ID 로 쓸 열 이름, id_prefix}
SOURCES = {
    'dm': {
        'path': os.path.join(RECV, '최종 단위테스트 결과 점검 (zio 관리) _ 202600826.xlsx'),
        'title': 'DM 단위테스트 결과 점검 (zio 관리) 2026-08-26 — 결함 원장 원문(수정사항 285건 · 증빙 시트 · 이미지)',
        'stem': 'dm_unit_test_20260826',
        'tables': {'수정사항': {'header': [2], 'id_col': 'No.', 'id_prefix': 'DM'}},
    },
    'gap': {
        'path': os.path.join(RECV, '(20260928) 화면 기능 갭 분석 종합 (1).xlsx'),
        'title': 'AS-IS vs TO-BE 화면 기능 갭 분석 종합 (2026-09-28) — 갭분석 506 · PI확인요청 66 · 자체결함확인 42 원문',
        'stem': 'gap_analysis_20260928',
        'tables': {
            '갭분석': {'header': [4], 'id_col': '번호', 'id_prefix': 'GAP'},
            'PI확인요청': {'header': [3, 4], 'id_col': '번호', 'id_prefix': 'GAPPI'},
            '자체결함확인': {'header': [3, 4], 'id_col': '번호', 'id_prefix': 'GAPSELF'},
        },
    },
    'ssp45': {
        'path': os.path.join(RECV, '☆NSCME_SCP&SSP 테스트_DMF0045(Shipment Request).xlsx'),
        'title': 'SCP&SSP 단위테스트 — DMF0045 Shipment Request (공통요건 25 · 검증내역 12) 원문',
        'stem': 'scpssp_test_dmf0045',
        'tables': {
            '공통요건': {'header': [2], 'id_col': 'No', 'id_prefix': 'SSP45REQ'},
            '검증내역': {'header': [2], 'id_col': 'No.', 'id_prefix': 'SSP45'},
        },
    },
}


def col_letter(c):
    s = ''
    while c:
        c, r = divmod(c - 1, 26)
        s = chr(65 + r) + s
    return s


def fmt(v):
    """셀 값 → 문자열(원문 보존). 날짜 = YYYY-MM-DD(+ HH:MM 시각이 있을 때) · 정수형 float 는 정수."""
    if v is None:
        return ''
    if isinstance(v, datetime.datetime):
        return v.strftime('%Y-%m-%d') if (v.hour, v.minute, v.second) == (0, 0, 0) else v.strftime('%Y-%m-%d %H:%M')
    if isinstance(v, datetime.date):
        return v.isoformat()
    if isinstance(v, float) and v.is_integer():
        return str(int(v))
    return str(v).replace('\x0b', '\n').replace('_x000B_', '\n').replace('_x000D_', '')


def md_cell(s):
    return (s or '').replace('\\', '\\\\').replace('|', '\\|').replace('\r\n', '⏎').replace('\n', '⏎').replace('\r', '⏎')


def safe_name(s):
    return re.sub(r'[^0-9A-Za-z가-힣_.-]+', '_', s).strip('_') or 'sheet'


def nonempty(v):
    return v is not None and v != ''


def read_workbook(path):
    """모든 시트의 비어있지 않은 셀 → {sheet: {'cells': [(r,c,val)], 'max_row', 'max_col', 'order': n}}"""
    wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    out = collections.OrderedDict()
    for i, ws in enumerate(wb.worksheets):
        cells = []
        r = 0
        for row in ws.iter_rows(values_only=True):
            r += 1
            for c, v in enumerate(row, 1):
                if nonempty(v):
                    cells.append((r, c, v))
        out[ws.title] = {'cells': cells, 'max_row': ws.max_row, 'max_col': ws.max_column, 'order': i}
    wb.close()
    return out


def read_drawings(path):
    """drawing XML → {sheet: {'images': [(row, col, png_media, svg_media, name)], 'charts': [(row, col, name)]}} + 전체 media 목록"""
    z = zipfile.ZipFile(path)
    names = set(z.namelist())
    wbx = z.read('xl/workbook.xml').decode('utf-8')
    rels = z.read('xl/_rels/workbook.xml.rels').decode('utf-8')
    rid2t = {}
    for m in re.finditer(r'<Relationship\b([^>]*)/?>', rels):
        a = m.group(1)
        i = re.search(r'\bId="([^"]+)"', a); t = re.search(r'\bTarget="([^"]+)"', a)
        if i and t:
            rid2t[i.group(1)] = t.group(1)
    sheets = re.findall(r'<sheet\b[^>]*?\bname="([^"]+)"[^>]*?\br:id="([^"]+)"', wbx)
    out = {}
    used_media = set()
    for name, rid in sheets:
        name = name.replace('&amp;', '&').replace('&lt;', '<').replace('&gt;', '>').replace('&quot;', '"').replace('&apos;', "'")
        t = rid2t.get(rid, '')
        sp = ('xl/' + t.lstrip('/')) if not t.startswith('/xl/') else t.lstrip('/')
        relp = sp.replace('worksheets/', 'worksheets/_rels/') + '.rels'
        imgs, charts = [], []
        if relp in names:
            srel = z.read(relp).decode('utf-8')
            for d in re.findall(r'Target="(?:\.\./|/xl/)?drawings/(drawing\d+\.xml)"', srel):
                dx = z.read(f'xl/drawings/{d}').decode('utf-8')
                drel_p = f'xl/drawings/_rels/{d}.rels'
                rmap = {}
                if drel_p in names:
                    drel = z.read(drel_p).decode('utf-8')
                    for m in re.finditer(r'<Relationship\b([^>]*)/?>', drel):
                        a = m.group(1)
                        i = re.search(r'\bId="([^"]+)"', a); tg = re.search(r'\bTarget="([^"]+)"', a)
                        if i and tg:
                            rmap[i.group(1)] = tg.group(1).split('/')[-1]
                for anc in re.findall(r'<xdr:(?:twoCellAnchor|oneCellAnchor|absoluteAnchor)\b[^>]*>(.*?)</xdr:(?:twoCellAnchor|oneCellAnchor|absoluteAnchor)>', dx, re.S):
                    fr = re.search(r'<xdr:from><xdr:col>(\d+)</xdr:col>.*?<xdr:row>(\d+)</xdr:row>', anc, re.S)
                    row, col = (int(fr.group(2)) + 1, int(fr.group(1)) + 1) if fr else (0, 0)
                    nm = re.search(r'<xdr:cNvPr\b[^>]*\bname="([^"]*)"', anc)
                    nm = nm.group(1) if nm else ''
                    if '<xdr:graphicFrame' in anc and 'drawingml/2006/chart' in anc:
                        charts.append((row, col, nm))
                        continue
                    blip = re.search(r'<a:blip\b[^>]*\br:embed="([^"]+)"', anc)
                    svg = re.search(r'<asvg:svgBlip\b[^>]*\br:embed="([^"]+)"', anc)
                    png = rmap.get(blip.group(1)) if blip else None
                    svgm = rmap.get(svg.group(1)) if svg else None
                    if png or svgm:
                        imgs.append((row, col, png, svgm, nm))
                        for mm in (png, svgm):
                            if mm:
                                used_media.add(mm)
        out[name] = {'images': imgs, 'charts': charts}
    media = sorted(n.split('/')[-1] for n in names if n.startswith('xl/media/'))
    return z, out, media, used_media


def build_table(cells, header_rows):
    """표 시트: 헤더 행(들) → 열 이름(아래 행 우선 · 빈 이름=열문자 · 중복=이름(열문자)), 데이터 = 헤더 아래 모든 행. 헤더 위 셀은 '표 바깥 셀'."""
    by_row = collections.defaultdict(dict)
    for r, c, v in cells:
        by_row[r][c] = v
    hmax = max(header_rows)
    max_col = max((c for r, c, _ in cells), default=0)
    names, seen = [], collections.Counter()
    for c in range(1, max_col + 1):
        nm = ''
        for hr in sorted(header_rows, reverse=True):
            v = by_row.get(hr, {}).get(c)
            if nonempty(v):
                nm = re.sub(r'\s*\n\s*', ' ', fmt(v)).strip()
                break
        if not nm:
            nm = f'열{col_letter(c)}'
        seen[nm] += 1
        names.append(nm)
    dup = {n for n, k in seen.items() if k > 1}
    cols = [f'{n}({col_letter(i + 1)})' if n in dup else n for i, n in enumerate(names)]
    above = [(r, c, v) for r, c, v in cells if r < min(header_rows)]
    header_cells = [(r, c, v) for r, c, v in cells if r in header_rows]
    rows = []
    for r in sorted(k for k in by_row if k > hmax):
        rows.append((r, {cols[c - 1]: fmt(by_row[r][c]) for c in by_row[r] if c <= max_col}))
    return cols, rows, above, header_cells


def row_ids(rows, idc, prefix):
    """행 ID — 번호가 시트 안에서 유일하면 PREFIX-<번호>, 중복(PI확인요청은 날짜 그룹마다 1부터 다시 시작)이면 PREFIX-<번호>_r<원행> 으로 전 행 고유화."""
    nos = [d.get(idc, '').strip() for _, d in rows]
    dup = {n for n, k in collections.Counter(n for n in nos if n).items() if k > 1}
    out = {}
    for (r, d), n in zip(rows, nos):
        out[r] = f'{prefix}-{n}_r{r}' if (n and n in dup) else (f'{prefix}-{n}' if n else f'{prefix}-r{r}')
    return out, dup


LABEL_RX = re.compile(r'^[PCpc]?\d{1,3}$')


def evidence_index(sheets, tables, per_sheet_imgs):
    """비정형 시트 → 결함 No. 연결: 시트명이 No. 면 시트 전체 · 시트 안 라벨 셀(P1·p24·23 …)이 있으면 라벨 좌상단 기준으로 이미지·셀을 그 No. 에 귀속.
    반환 {No.(대문자): [(sheet, label or '', n_cells, n_imgs)]}"""
    idx = collections.defaultdict(list)
    for sname, info in sheets.items():
        if sname in tables:
            continue
        cells = info['cells']
        imgs = per_sheet_imgs.get(sname, [])
        if LABEL_RX.match(sname.strip()):
            idx[sname.strip().upper()].append((sname, '', len(cells), len(imgs)))
            continue
        if not ('~' in sname or sname == '안진선'):
            continue  # 라벨 분할은 P-범위 시트(P1~P15 …)·안진선 시트만 — 집계 시트의 숫자 셀(건수)은 라벨이 아니다
        labels = [(r, c, fmt(v).strip()) for r, c, v in cells if LABEL_RX.match(fmt(v).strip())]
        if not labels:
            continue
        cnt = collections.defaultdict(lambda: [0, 0])
        for r, c, v in cells:
            if (r, c, fmt(v).strip()) in labels:
                continue
            lab = label_for((r, c), labels)
            if lab:
                cnt[lab][0] += 1
        for row, col, rel, kind, nm, mm in imgs:
            lab = label_for((row, col), labels)
            if lab:
                cnt[lab][1] += 1
        for lr, lc, lv in labels:
            n_c, n_i = cnt.get(lv, [0, 0])
            idx[lv.upper()].append((sname, lv, n_c, n_i))
    return idx


def label_for(pos, labels):
    """P-범위 시트: 이미지/셀 앵커의 좌상단에 있는 가장 가까운 라벨(P1, P21 …) — 행이 같거나 위, 열이 같거나 왼쪽."""
    r, c = pos
    cand = [(lr, lc, lv) for lr, lc, lv in labels if lr <= r and lc <= c]
    if not cand:
        return ''
    lr, lc, lv = max(cand, key=lambda x: (x[0], x[1]))
    return lv


def extract(key, cfg, baseline_dm_nos):
    path = cfg['path']
    if not os.path.exists(path):
        print(f'[ERROR] 원천 없음: {path}')
        return None
    st = os.stat(path)
    print(f'== {key}: {os.path.basename(path)} ({st.st_size // 1024:,} KB · 수정 {datetime.datetime.fromtimestamp(st.st_mtime):%Y-%m-%d %H:%M})', flush=True)
    sheets = read_workbook(path)
    z, draw, media, used_media = read_drawings(path)
    img_dir = os.path.join(OUT_DIR, '_img', key)
    os.makedirs(img_dir, exist_ok=True)
    stem = cfg['stem']
    today = datetime.date.today().isoformat()

    # ── 이미지 저장(앵커 기준 파일명) + 미앵커 media
    img_records = []  # (sheet, row, col, relpath, kind, name)
    saved = set()
    per_sheet_imgs = collections.defaultdict(list)
    for sname, d in draw.items():
        n_by_pos = collections.Counter()
        for row, col, png, svgm, nm in d['images']:
            n_by_pos[(row, col)] += 1
            n = n_by_pos[(row, col)]
            for mm, kind in ((png, 'png'), (svgm, 'svg')):
                if not mm:
                    continue
                ext = mm.rsplit('.', 1)[-1].lower()
                fn = f"{safe_name(sname)}_r{row}c{col}_{n}.{ext}"
                fp = os.path.join(img_dir, fn)
                if not os.path.exists(fp) or os.path.getsize(fp) != z.getinfo('xl/media/' + mm).file_size:
                    with z.open('xl/media/' + mm) as src, open(fp, 'wb') as dst:
                        dst.write(src.read())
                saved.add(fn)
                rel = f'_img/{key}/{fn}'
                img_records.append((sname, row, col, rel, kind, nm, mm))
                per_sheet_imgs[sname].append((row, col, rel, kind, nm, mm))
    unanchored = [m for m in media if m not in used_media]
    if unanchored:
        os.makedirs(os.path.join(img_dir, '_unanchored'), exist_ok=True)
        for m in unanchored:
            with z.open('xl/media/' + m) as src, open(os.path.join(img_dir, '_unanchored', m), 'wb') as dst:
                dst.write(src.read())
    n_anchor_refs = sum(sum(1 for x in (png, svgm) if x) for d in draw.values() for _, _, png, svgm, _ in d['images'])

    # ── 표 시트 / 비정형 시트 분리 + 기록 셀 수 집계
    report = []  # per sheet: (sheet, kind, xlsx_cells, recorded_cells, rows, imgs, charts)
    recorded_total = 0
    tables = {}
    csv_rows_all = []
    cells_csv = []  # 비정형·표 바깥 셀
    for sname, info in sheets.items():
        cells = info['cells']
        n_x = len(cells)
        tcfg = cfg['tables'].get(sname)
        if tcfg:
            cols, rows, above, header_cells = build_table(cells, tcfg['header'])
            rec = len(above) + len(header_cells) + sum(len(d) for _, d in rows)
            rids, dup = row_ids(rows, tcfg['id_col'], tcfg['id_prefix'])
            tables[sname] = {'cols': cols, 'rows': rows, 'above': above, 'cfg': tcfg, 'rids': rids, 'dup': dup}
            for r, c, v in above:
                cells_csv.append((sname, r, c, fmt(v)))
            report.append((sname, '표', n_x, rec, len(rows), len(per_sheet_imgs.get(sname, [])), len(draw.get(sname, {}).get('charts', []))))
        else:
            rec = n_x
            for r, c, v in cells:
                cells_csv.append((sname, r, c, fmt(v)))
            report.append((sname, '비정형' if n_x else '빈 시트', n_x, rec, 0, len(per_sheet_imgs.get(sname, [])), len(draw.get(sname, {}).get('charts', []))))
        recorded_total += rec

    # ── 증빙 시트/라벨 → 결함 No. 연결(DM) · 미연결 증빙 집계
    evid_idx = evidence_index(sheets, tables, per_sheet_imgs) if key == 'dm' else {}
    table_nos = {d.get(t['cfg']['id_col'], '').strip().upper() for t in tables.values() for _, d in t['rows']}
    evid_unlinked = sorted(k for k in evid_idx if k not in table_nos)
    evid_linked = sorted(k for k in evid_idx if k in table_nos)

    def evid_str(no):
        return ' ; '.join(f"§ `{s}`" + (f"(라벨 {lab} · 셀 {nc} · 이미지 {ni})" if lab else f"(셀 {nc} · 이미지 {ni})") for s, lab, nc, ni in evid_idx.get((no or '').upper(), []))

    # ── CSV (표) · cells CSV (비정형)
    os.makedirs(OUT_DIR, exist_ok=True)
    csv_p = os.path.join(OUT_DIR, stem + '.csv')
    with open(csv_p, 'w', encoding='utf-8-sig', newline='') as f:
        allcols = ['row_id', 'src_file', 'src_sheet', 'src_row']
        extra = []
        for sname, t in tables.items():
            for c in t['cols']:
                if c not in extra:
                    extra.append(c)
        w = csv.DictWriter(f, fieldnames=allcols + extra + ['증빙_이미지', '증빙_시트'])
        w.writeheader()
        for sname, t in tables.items():
            idc = t['cfg']['id_col']
            rids = t['rids']
            for r, d in t['rows']:
                rid = rids[r]
                imgs = [rel for (ir, ic, rel, kind, nm, mm) in per_sheet_imgs.get(sname, []) if ir == r]
                evid_sheet = evid_str(d.get(idc, '').strip()) if key == 'dm' else ''
                row = {'row_id': rid, 'src_file': os.path.basename(path), 'src_sheet': sname, 'src_row': r, '증빙_이미지': ';'.join(imgs), '증빙_시트': evid_sheet}
                row.update(d)
                w.writerow(row)
                csv_rows_all.append(row)
    cells_p = os.path.join(OUT_DIR, stem + '_cells.csv')
    with open(cells_p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['src_sheet', 'row', 'col', 'cell', 'value'])
        for sname, r, c, v in cells_csv:
            w.writerow([sname, r, c, f'{col_letter(c)}{r}', v])
    img_p = os.path.join(OUT_DIR, stem + '_images.csv')
    with open(img_p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['src_sheet', 'row', 'col', 'cell', 'file', 'kind', 'drawing_name', 'media'])
        for sname, row, col, rel, kind, nm, mm in img_records:
            w.writerow([sname, row, col, f'{col_letter(col)}{row}' if row else '', rel, kind, nm, mm])

    # ── MD
    L = []
    P = L.append
    P(f"# {cfg['title']}")
    P('')
    P(f"> 생성: {today} · `python tools/Harness/verify/sources_extract.py --only {key}` 로 재생성(손편집 금지 — 원천 xlsx 를 고친 뒤 재실행).")
    P(f"> 원천: `{os.path.basename(path)}` ({st.st_size:,} B · 수정 {datetime.datetime.fromtimestamp(st.st_mtime):%Y-%m-%d %H:%M}) · 시트 {len(sheets)}개 · 비어있지 않은 셀 {sum(len(i['cells']) for i in sheets.values()):,} · 이미지 참조 {n_anchor_refs}(media 파일 {len(media)}).")
    P(f"> 기계판독본: `Doc/verify/sources/{stem}.csv`(표 시트 행 · row_id 열이 2단계 분류 키) · `{stem}_cells.csv`(표 바깥·비정형 시트 셀) · `{stem}_images.csv`(이미지 위치) · 이미지 `Doc/verify/sources/_img/{key}/`.")
    P(f"> 행 ID 규칙: " + ' · '.join(f"시트 `{s}` → `{t['id_prefix']}-<{t['id_col']}>`" for s, t in cfg['tables'].items()) + ". 셀 줄바꿈은 `⏎` 로 표기. 값은 자르지 않음.")
    P('> 목적: CheckList(정합검증)가 이 파일의 내역을 누락 없이 품도록 하는 1단계 원문 — 2단계에서 결함 재발 규칙·설계 결정·공통 요건으로 분류해 검증엔진에 반영한다.')
    P('')
    P('## 1. 시트 목록 (xlsx ↔ 기록 대조)')
    P('')
    P('| # | 시트 | 유형 | xlsx 비어있지 않은 셀 | 기록 셀 | 표 행 | 이미지 | 차트 | 일치 |')
    P('|---|---|---|---|---|---|---|---|---|')
    for i, (sname, kind, nx, rec, nrows, nimg, nch) in enumerate(report, 1):
        P(f"| {i} | {md_cell(sname)} | {kind} | {nx} | {rec} | {nrows or ''} | {nimg or ''} | {nch or ''} | {'OK' if nx == rec else 'ERROR'} |")
    P('')
    sec = 2
    for sname, t in tables.items():
        cols, rows, above, tcfg = t['cols'], t['rows'], t['above'], t['cfg']
        P(f"## {sec}. 표 시트 `{sname}` — {len(rows)}행 × {len(cols)}열 (헤더 행 {', '.join(map(str, tcfg['header']))})")
        P('')
        if above:
            P('표 바깥 셀(헤더 위):')
            for r, c, v in above:
                P(f"- `{sname}!{col_letter(c)}{r}` = {md_cell(fmt(v))}")
            P('')
        hdr = ['행 ID', '원행'] + cols + (['증빙 이미지', '증빙 시트'] if key == 'dm' else ['증빙 이미지'])
        P('| ' + ' | '.join(md_cell(h) for h in hdr) + ' |')
        P('|' + '---|' * len(hdr))
        idc = tcfg['id_col']
        if t['dup']:
            P(f"> 번호 중복 {len(t['dup'])}건({', '.join(sorted(t['dup'])[:10])}) — 이 시트의 행 ID 는 `{tcfg['id_prefix']}-<번호>_r<원행>` 로 고유화.")
            P('')
        for r, d in rows:
            rid = t['rids'][r]
            imgs = [rel for (ir, ic, rel, kind, nm, mm) in per_sheet_imgs.get(sname, []) if ir == r]
            imgmd = ' '.join(f'[{os.path.basename(x)}]({x})' for x in imgs)
            vals = [md_cell(d.get(c, '')) for c in cols]
            tail = [imgmd] + ([md_cell(evid_str(d.get(idc, '').strip()))] if key == 'dm' else [])
            P('| ' + ' | '.join([rid, str(r)] + vals + tail) + ' |')
        P('')
        sec += 1
    # 비정형 시트
    others = [(s, i) for s, i in sheets.items() if s not in tables]
    P(f"## {sec}. 비정형 시트 {len(others)}개 — 셀 원문 + 이미지 위치 (증빙 시트 = 결함 No. 와 같은 이름)")
    P('')
    for sname, info in others:
        cells = info['cells']
        imgs = per_sheet_imgs.get(sname, [])
        charts = draw.get(sname, {}).get('charts', [])
        P(f"### `{sname}` — 셀 {len(cells)} · 이미지 {len(imgs)} · 차트 {len(charts)}" + (' · (빈 시트)' if not cells and not imgs and not charts else ''))
        P('')
        labels = [(r, c, fmt(v)) for r, c, v in cells if re.fullmatch(r'[PCp]?\d{1,3}', fmt(v).strip())] if re.search(r'~', sname) or sname == '안진선' else []
        for r, c, v in cells:
            P(f"- `{sname}!{col_letter(c)}{r}` = {md_cell(fmt(v))}")
        for row, col, rel, kind, nm, mm in sorted(imgs):
            lab = label_for((row, col), labels) if labels else ''
            P(f"- 이미지 `{sname}!{col_letter(col)}{row}`" + (f" (라벨 {lab})" if lab else '') + f" {kind}: [{os.path.basename(rel)}]({rel})" + (f" · 이름 {md_cell(nm)}" if nm else ''))
        for row, col, nm in charts:
            P(f"- 차트 `{sname}!{col_letter(col)}{row}`: {md_cell(nm)} (차트 객체 — 이미지 아님 · 원본 xlsx 에서 확인)")
        P('')
    sec += 1
    if unanchored:
        P(f"## {sec}. 앵커 없는 media {len(unanchored)}개 — `_img/{key}/_unanchored/`")
        P('')
        for m in unanchored:
            P(f"- [{m}](_img/{key}/_unanchored/{m})")
        P('')
        sec += 1
    md_p = os.path.join(OUT_DIR, stem + '.md')
    with open(md_p, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(L) + '\n')

    # ── 대조 결과
    mismatch = [(s, nx, rec) for s, k, nx, rec, *_ in report if nx != rec]
    img_ok = n_anchor_refs == len(img_records) and len(saved) == len({os.path.basename(x[3]) for x in img_records})
    base_note = ''
    if key == 'dm':
        base_note = f"증빙 연결: 결함 No. {len(evid_linked)}건에 증빙 시트/라벨 연결 · 결함 No. 와 안 맞는 증빙 라벨 {len(evid_unlinked)}건({', '.join(evid_unlinked[:12])}) | "
        nos = {d.get('No.', '').strip() for _, d in tables['수정사항']['rows'] if d.get('No.', '').strip()}
        base_note += f"수정사항 No. {len(nos)} vs defects_baseline DM {len(baseline_dm_nos)} — 일치 {len(nos & baseline_dm_nos)} · xlsx 만 {sorted(nos - baseline_dm_nos)[:10]} · baseline 만 {sorted(baseline_dm_nos - nos)[:10]}"
        if nos != baseline_dm_nos:
            mismatch.append(('수정사항 No. ↔ defects_baseline.csv', len(nos), len(baseline_dm_nos)))
    xlsx_total = sum(len(i['cells']) for i in sheets.values())
    print(f"   시트 {len(sheets)} · 셀 {xlsx_total:,} → 기록 {recorded_total:,} · 이미지 참조 {n_anchor_refs} → 저장 {len(saved)}(media {len(media)} · 미앵커 {len(unanchored)}) · 표 행 {sum(len(t['rows']) for t in tables.values())}")
    if base_note:
        print('   ' + base_note)
    for m in mismatch:
        print(f'   [ERROR] 불일치: {m}')
    return {'key': key, 'file': os.path.basename(path), 'md': os.path.relpath(md_p, ROOT), 'csv': os.path.relpath(csv_p, ROOT), 'sheets': len(sheets), 'cells': xlsx_total,
            'recorded': recorded_total, 'imgs': n_anchor_refs, 'saved': len(saved), 'media': len(media), 'unanchored': len(unanchored),
            'rows': {s: len(t['rows']) for s, t in tables.items()}, 'report': report, 'mismatch': mismatch, 'img_ok': img_ok, 'base_note': base_note}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--only', choices=list(SOURCES))
    for k in SOURCES:
        ap.add_argument(f'--{k}', help=f'{k} 원천 xlsx 경로(기본 {SOURCES[k]["path"]})')
    a = ap.parse_args()
    baseline_dm = set()
    bp = os.path.join(ROOT, 'Doc', 'verify', 'defects_baseline.csv')
    if os.path.exists(bp):
        with open(bp, encoding='utf-8-sig') as f:
            baseline_dm = {r['no'].strip() for r in csv.DictReader(f) if r.get('src') == 'DM'}
    results = []
    for k, cfg in SOURCES.items():
        if a.only and k != a.only:
            continue
        if getattr(a, k):
            cfg = dict(cfg, path=getattr(a, k))
        r = extract(k, cfg, baseline_dm)
        if r:
            results.append(r)
    # 보고서
    os.makedirs(OUT_DIR, exist_ok=True)
    L = ['# 원천 xlsx → MD/CSV 추출 대조 보고 (누락 0 증명)', '',
         f"> 생성 {datetime.datetime.now():%Y-%m-%d %H:%M:%S} · `python tools/Harness/verify/sources_extract.py` · 판정 = 시트별 xlsx 비어있지 않은 셀 수 = 기록 셀 수 · 이미지 참조 수 = 저장 수 · (DM) 수정사항 No. 집합 = defects_baseline DM. 하나라도 다르면 ERROR(exit 1).", '',
         '| 원천 | 파일 | 시트 | xlsx 셀 | 기록 셀 | 이미지 참조 | 저장 | media | 미앵커 | 표 행 | 판정 |', '|---|---|---|---|---|---|---|---|---|---|---|']
    bad = False
    for r in results:
        ok = not r['mismatch'] and r['img_ok']
        bad |= not ok
        L.append(f"| {r['key']} | {md_cell(r['file'])} | {r['sheets']} | {r['cells']:,} | {r['recorded']:,} | {r['imgs']} | {r['saved']} | {r['media']} | {r['unanchored']} | {' · '.join(f'{s} {n}' for s, n in r['rows'].items())} | {'OK' if ok else 'ERROR'} |")
    L.append('')
    for r in results:
        L += [f"## {r['key']} — `{r['md']}`", '', '| 시트 | 유형 | xlsx 셀 | 기록 셀 | 표 행 | 이미지 | 차트 | 일치 |', '|---|---|---|---|---|---|---|---|']
        for sname, kind, nx, rec, nrows, nimg, nch in r['report']:
            L.append(f"| {md_cell(sname)} | {kind} | {nx} | {rec} | {nrows or ''} | {nimg or ''} | {nch or ''} | {'OK' if nx == rec else 'ERROR'} |")
        if r['base_note']:
            L += ['', f"- {r['base_note']}"]
        for m in r['mismatch']:
            L.append(f"- **ERROR 불일치**: {m}")
        L.append('')
    with open(os.path.join(OUT_DIR, '_extract_report.md'), 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(L) + '\n')
    print(f"보고서: {os.path.relpath(os.path.join(OUT_DIR, '_extract_report.md'), ROOT)} — " + ('ERROR(불일치 있음)' if bad else '전부 OK'))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
