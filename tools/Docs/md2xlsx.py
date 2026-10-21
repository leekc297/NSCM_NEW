#!/usr/bin/env python3
"""md2xlsx — 화면 문서(MD) + Fact Pack CSV + GAP CSV 를 사용자가 보는 Excel 1권으로 묶는다.
  python md2xlsx.py <ID> [<ID> ...] [--out Doc\\documents]
  입력: Doc/asisfacts/agent/<ID>/*.md (analysis=화면분석서, screen_design=화면설계서, tobe_design, business_analysis,
        oracle_migration, unit_test, web_components, source_links) · Doc/gap/<ID>_gap.csv · Doc/asisfacts/screens/<ID>/*.csv ·
        Doc/gen/<ID>/{DOD,CHECK,PIPELINE}.md · 페이지 __asis-mapping__.md
  출력: Doc/documents/<ID>/<ID>_화면문서_YYYYMMDD.xlsx  (시트: 표지, 화면분석서, 화면설계서, To-Be설계, 업무분석, Oracle이관, 단위테스트,
        GAP, 대조표(매핑), 컨트롤, 이벤트, 엔드포인트, 검증, 표현식, 그리드, DoD)
  MD 는 그대로 두고(기본 산출물), Excel 은 사람이 보는 사본이다. openpyxl 사용(노트북 설치됨).
"""
import sys, os, re, csv, json, datetime
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
try:
    import openpyxl
    from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
    from openpyxl.utils import get_column_letter
except ImportError:
    sys.exit('openpyxl 없음 — 클라우드 또는 ALLOW 된 환경에서 pip install openpyxl 후 재실행')

out_base = os.path.join(ROOT, 'Doc', 'documents')
argv = sys.argv[1:]
if '--out' in argv: i = argv.index('--out'); out_base = argv[i + 1]; argv = argv[:i] + argv[i + 2:]
args = [a for a in argv if not a.startswith('--')]
if not args: sys.exit(__doc__)
HFILL = PatternFill('solid', fgColor='1F4E78'); HFONT = Font(bold=True, color='FFFFFF'); TFONT = Font(bold=True, size=12)
THIN = Side(style='thin', color='BBBBBB'); BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)
SHEETS_MD = [('analysis.md', '화면분석서'), ('screen_design.md', '화면설계서'), ('tobe_design.md', 'To-Be설계'), ('business_analysis.md', '업무분석'),
             ('oracle_migration.md', 'Oracle이관'), ('unit_test.md', '단위테스트'), ('web_components.md', '컴포넌트'), ('source_links.md', '소스링크')]
PACK_CSV = [('controls.csv', '컨트롤'), ('events.csv', '이벤트'), ('endpoints.csv', '엔드포인트'), ('validations.csv', '검증'), ('expressions.csv', '표현식'), ('grid_effective.csv', '그리드'), ('popups.csv', '팝업')]

def md_blocks(text):
    """MD → [('h', level, text) | ('p', text) | ('table', [[...]])]"""
    out, lines, i = [], text.replace('\r\n', '\n').split('\n'), 0
    while i < len(lines):
        ln = lines[i]
        if re.match(r'^\s*\|.*\|\s*$', ln) and i + 1 < len(lines) and re.match(r'^\s*\|[\s:|-]+\|\s*$', lines[i + 1]):
            rows = []
            while i < len(lines) and re.match(r'^\s*\|.*\|\s*$', lines[i]):
                if not re.match(r'^\s*\|[\s:|-]+\|\s*$', lines[i]): rows.append([c.strip() for c in lines[i].strip().strip('|').split('|')])
                i += 1
            out.append(('table', rows)); continue
        m = re.match(r'^(#{1,6})\s+(.*)', ln)
        if m: out.append(('h', len(m.group(1)), m.group(2).strip()))
        elif ln.strip(): out.append(('p', re.sub(r'^\s*[-*]\s+', '• ', ln.rstrip())))
        i += 1
    return out

def put_md(ws, text):
    r = 1
    for b in md_blocks(text):
        if b[0] == 'h':
            c = ws.cell(row=r, column=1, value=b[2]); c.font = Font(bold=True, size=14 - min(b[1], 4)); r += 1
        elif b[0] == 'p':
            ws.cell(row=r, column=1, value=b[1]).alignment = Alignment(wrap_text=True, vertical='top'); r += 1
        else:
            rows = b[1]
            for j, row in enumerate(rows):
                for k, v in enumerate(row):
                    c = ws.cell(row=r, column=1 + k, value=v); c.border = BORDER; c.alignment = Alignment(wrap_text=True, vertical='top')
                    if j == 0: c.fill = HFILL; c.font = HFONT
                r += 1
            r += 1
    ws.column_dimensions['A'].width = 48
    for col in range(2, 12): ws.column_dimensions[get_column_letter(col)].width = 28

def put_csv(ws, rows):
    for j, row in enumerate(rows):
        for k, v in enumerate(row):
            c = ws.cell(row=1 + j, column=1 + k, value=v); c.border = BORDER
            if j == 0: c.fill = HFILL; c.font = HFONT
    if rows:
        ws.freeze_panes = 'A2'; ws.auto_filter.ref = f"A1:{get_column_letter(len(rows[0]))}{len(rows)}"
        for k in range(len(rows[0])): ws.column_dimensions[get_column_letter(k + 1)].width = min(60, max(10, max(len(str(r[k])) if k < len(r) else 0 for r in rows[:200]) + 2))

def read_csv(p):
    with open(p, encoding='utf-8-sig', newline='') as fh: return [r for r in csv.reader(fh)]

def build(ID):
    ID = ID.upper(); agent = os.path.join(ROOT, 'Doc', 'asisfacts', 'agent', ID); pack = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID)
    gen = os.path.join(ROOT, 'Doc', 'gen', ID); gap = os.path.join(ROOT, 'Doc', 'gap', f'{ID}_gap.csv')
    wb = openpyxl.Workbook(); cover = wb.active; cover.title = '표지'
    today = datetime.date.today().strftime('%Y-%m-%d'); info = [['화면 ID', ID], ['생성일', today], ['원천', 'Doc/asisfacts/agent, screens · Doc/gap · Doc/gen (MD/CSV 가 정본, 이 파일은 열람용 사본)']]
    try:
        summ = os.path.join(pack, f'{ID}_summary.md')
        if os.path.exists(summ):
            t = open(summ, encoding='utf-8-sig').read(); m = re.search(r'화면명[^|\n]*\|\s*([^|\n]+)', t); info.insert(1, ['화면명', m.group(1).strip() if m else ''])
    except Exception: pass
    for i, (k, v) in enumerate(info): cover.cell(row=1 + i, column=1, value=k).font = TFONT; cover.cell(row=1 + i, column=2, value=v)
    cover.column_dimensions['A'].width = 14; cover.column_dimensions['B'].width = 90
    n = 0
    for f, title in SHEETS_MD:
        p = os.path.join(agent, f)
        if os.path.exists(p): put_md(wb.create_sheet(title), open(p, encoding='utf-8-sig').read()); n += 1
    if os.path.exists(gap): put_csv(wb.create_sheet('GAP'), read_csv(gap)); n += 1
    # 대조표(__asis-mapping__.md): register.json 으로 페이지 위치
    reg = os.path.join(gen, 'register.json')
    if os.path.exists(reg):
        try:
            r = json.load(open(reg, encoding='utf-8-sig')); mp = os.path.join(ROOT, 'nscm-fe', 'features', r['feature'], 'src', 'pages', r['pageDir'], '__asis-mapping__.md')
            if os.path.exists(mp): put_md(wb.create_sheet('대조표(매핑)'), open(mp, encoding='utf-8-sig').read()); n += 1
        except Exception as e: print('매핑표 생략:', e)
    for f, title in PACK_CSV:
        p = os.path.join(pack, f)
        if os.path.exists(p): put_csv(wb.create_sheet(title), read_csv(p)); n += 1
    for f, title in [('DOD.md', 'DoD'), ('CHECK.md', '게이트'), ('PIPELINE.md', '파이프라인')]:
        p = os.path.join(gen, f)
        if os.path.exists(p): put_md(wb.create_sheet(title), open(p, encoding='utf-8-sig').read()); n += 1
    cover.cell(row=len(info) + 2, column=1, value='시트 수').font = TFONT; cover.cell(row=len(info) + 2, column=2, value=n)
    od = os.path.join(out_base, ID); os.makedirs(od, exist_ok=True)
    out = os.path.join(od, f"{ID}_화면문서_{datetime.date.today().strftime('%Y%m%d')}.xlsx"); wb.save(out)
    print(f'{ID} → {out}  (시트 {n + 1})'); return out

for ID in args: build(ID)
