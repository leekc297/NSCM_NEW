#!/usr/bin/env python3
"""make_docs — 화면 ID 하나로 사람이 보는 Excel 문서 4종을 팀 양식(hook #105 · TestCases4)으로 생성한다.

  python make_docs.py <ID> [<ID> ...] [--out-design Doc/화면설계서] [--out-analysis Doc/화면분석서] [--out-test Doc/단위테스트]

  산출 (기존 파일은 덮어쓰지 않고 버전 +1):
    Doc/화면설계서/{ID}_{Name}_화면설계서_v{N}.0.xlsx   8시트 (개요·전체흐름·LAYOUT·조회조건·버튼·GRID·EVENT·VALIDATION·API·SP)
    Doc/화면분석서/{ID}_{Name}_UI분석서_v{N}.0.xlsx     10시트 (개요·전체흐름·VALIDATION취합·MATRIX_Division·MATRIX_권한·MATRIX_Measure·MATRIX_Bucket·가시성·SP_LOOKUP_콤보·이전소스_차이점)
    Doc/화면분석서/{ID}_{Name}_GAP분석서_v{N}.0.xlsx    3시트 (요약·GAP 전체·조치 필요)
    Doc/단위테스트/{ID}_{Name}_TestCases4_v{N}.0.xlsx   Division 별 시트 (33열 TestCases4 양식) — unit_test.md 가 있을 때만

  원천: Doc/asisfacts/agent/<ID>/*.md (문서 생성 S3.agent) · Doc/asisfacts/screens/<ID>/*.csv (Fact Pack) · Doc/gap/<ID>_gap.csv
        Doc/tobefacts/db/{menu,proc_meta,proc_params,sheet_columns,sheet_measures,btn_auth,user_group}.csv · Doc/gen/<ID>/register.json
  원칙: 서식·용어는 팀이 쓰는 문서와 같게(머지 규칙 §1-E · 맑은 고딕 10 · 자연어 · 소스 라인번호 금지 · 도구 내부 용어 금지).
        MD/CSV 가 정본이고 Excel 은 읽는 사람용 사본이다. 원천이 없는 시트는 비우지 않고 "원천 없음" 을 적는다.
"""
import sys, os, re, csv, json, datetime, glob
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
try:
    import openpyxl
    from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
    from openpyxl.utils import get_column_letter
except ImportError:
    sys.exit('openpyxl 없음 — pip install openpyxl 후 재실행')

# ── 인자 ──────────────────────────────────────────────────────────────────────
argv = sys.argv[1:]
def opt(name, default):
    global argv
    if name in argv:
        i = argv.index(name); v = argv[i + 1]; argv = argv[:i] + argv[i + 2:]; return v
    return default
OUT_DESIGN = opt('--out-design', os.path.join(ROOT, 'Doc', '화면설계서'))
OUT_ANALYSIS = opt('--out-analysis', os.path.join(ROOT, 'Doc', '화면분석서'))
OUT_TEST = opt('--out-test', os.path.join(ROOT, 'Doc', '단위테스트'))
IDS = [a.upper() for a in argv if not a.startswith('--')]
if not IDS: sys.exit(__doc__)
TODAY = datetime.date.today().strftime('%Y-%m-%d')

# ── 서식 (팀 설계서 생성기 _gen_design_*.py 와 동일 계열) ────────────────────
FONT_NAME = '맑은 고딕'
BASE_F = Font(name=FONT_NAME, size=10)
TITLE_F = Font(name=FONT_NAME, size=14, bold=True, color='1F4E79')
SEC_FILL = PatternFill('solid', fgColor='1F4E79'); SEC_F = Font(name=FONT_NAME, bold=True, color='FFFFFF', size=11)
HDR_FILL = PatternFill('solid', fgColor='4472A8'); HDR_F = Font(name=FONT_NAME, bold=True, color='FFFFFF', size=10)
KEY_FILL = PatternFill('solid', fgColor='EEF3F9'); KEY_F = Font(name=FONT_NAME, bold=True, size=10)
WARN_FILL = PatternFill('solid', fgColor='FFF2CC'); BAD_FILL = PatternFill('solid', fgColor='F8D7DA'); OK_FILL = PatternFill('solid', fgColor='E2F0D9')
TC_HDR_FILL = PatternFill('solid', fgColor='1F4E78'); TC_BODY_FILL = PatternFill('solid', fgColor='FDE9D9')
WRAP = Alignment(wrap_text=True, vertical='top'); THIN = Border(*[Side(style='thin', color='B0B0B0')] * 4)

class SB:
    """시트 빌더 — title / sec(섹션 바) / hdr / row(머지 규칙) / kv / text"""
    def __init__(self, ws, widths):
        self.ws, self.r, self.n = ws, 0, len(widths)
        for i, w in enumerate(widths, 1): ws.column_dimensions[get_column_letter(i)].width = w
        ws.sheet_view.showGridLines = False
    def title(self, t, sub=None):
        self.r += 1; c = self.ws.cell(self.r, 1, t); c.font = TITLE_F
        if sub: self.r += 1; s = self.ws.cell(self.r, 1, sub); s.font = Font(name=FONT_NAME, size=9, color='7F7F7F'); self._merge_left(self.r, 1)
        self.r += 1
    def sec(self, t):
        self.r += 1
        for i in range(1, self.n + 1): self.ws.cell(self.r, i).fill = SEC_FILL
        c = self.ws.cell(self.r, 1, t); c.font = SEC_F
        self.ws.merge_cells(start_row=self.r, start_column=1, end_row=self.r, end_column=self.n)
        c.alignment = Alignment(horizontal='left', vertical='center'); self.ws.row_dimensions[self.r].height = 20
    def hdr(self, cols):
        self.r += 1
        for i, v in enumerate(cols, 1):
            c = self.ws.cell(self.r, i, v); c.fill = HDR_FILL; c.font = HDR_F; c.alignment = Alignment(vertical='center', horizontal='center', wrap_text=True); c.border = THIN
        for i in range(len(cols) + 1, self.n + 1): self.ws.cell(self.r, i).fill = HDR_FILL
    def row(self, cols, fill=None):
        """값이 있는 마지막 열 이후가 전부 비면 그 열부터 끝까지 가로 머지 + 좌측 정렬 (#105 §1-E)"""
        self.r += 1; vals = list(cols) + [None] * (self.n - len(cols))
        idx = [i for i, v in enumerate(vals) if v is not None and str(v).strip()]
        for i, v in enumerate(vals, 1):
            c = self.ws.cell(self.r, i, v if v is None else str(v)); c.alignment = WRAP; c.border = THIN; c.font = BASE_F
            if fill: c.fill = fill
        if idx and idx[-1] < self.n - 1: self._merge_left(self.r, idx[-1] + 1)
    def kv(self, k, v):
        self.r += 1
        a = self.ws.cell(self.r, 1, k); a.font = KEY_F; a.fill = KEY_FILL; a.alignment = WRAP; a.border = THIN
        b = self.ws.cell(self.r, 2, '' if v is None else str(v)); b.alignment = WRAP; b.border = THIN; b.font = BASE_F
        if self.n > 2: self._merge_left(self.r, 2)
    def text(self, t, fill=None):
        self.r += 1; c = self.ws.cell(self.r, 1, t); c.alignment = WRAP; c.font = BASE_F
        if fill: c.fill = fill
        self._merge_left(self.r, 1)
    def note(self, t): self.text(t, WARN_FILL)
    def _merge_left(self, r, start_col=1):
        if self.n < 2 or start_col >= self.n: return
        self.ws.merge_cells(start_row=r, start_column=start_col, end_row=r, end_column=self.n)
        self.ws.cell(r, start_col).alignment = Alignment(horizontal='left', vertical='top', wrap_text=True)
    def gap(self): self.r += 1

# ── 용어 (도구 내부 표기 → 읽는 사람 표기) ─────────────────────────────────────
STATUS_KO = {'COVERED': '반영 완료', 'INTENDED': '의도적 변경(반영 불필요)', 'MISSING': '미반영(조치 필요)', 'UNMAPPED': '대응 미확인', 'PARTIAL': '일부 반영'}
KIND_KO = {'control': '화면 요소', 'event': '사용자 동작', 'endpoint': '호출 SP', 'hard_column': '코드 지정 컬럼', 'sheet': '그리드 시트'}
EP_STATUS_KO = {'MATCH': '일치', 'BIZ_MATCH': '공통 데이터 일치', 'UNRESOLVED': '미확인', 'NOT_FOUND': '찾지 못함', 'COMMENTED': '주석 처리됨'}
EVENT_KO = {'Click': '클릭', 'CellDoubleClick': '셀 더블클릭', 'CellClick': '셀 클릭', 'SelectedIndexChanged': '선택 변경', 'Load': '화면 열림', 'CheckedChanged': '체크 변경',
            'TopChange': '스크롤', 'Change': '값 변경', 'ValueChanged': '값 변경', 'TextChanged': '입력 변경', 'KeyDown': '키 입력', 'ButtonClicked': '버튼 클릭',
            'ActiveSheetChanging': '시트 전환', 'EditModeOff': '편집 종료', 'ComboSelChange': '콤보 선택', 'Leave': '포커스 이동', 'FormClosing': '화면 닫기'}
CTRL_KO = [('DateRangePicker', '기간 선택'), ('DatePicker', '날짜 선택'), ('CheckedListBox', '다중 선택 목록'), ('CheckedList', '다중 선택 목록'), ('CheckedComboBox', '다중 선택 콤보'),
           ('MultiLineEditor', '여러 줄 입력'), ('MultiLineInput', '여러 줄 입력'), ('ComboBox', '콤보'), ('CheckBox', '체크박스'), ('RadioButton', '선택 버튼'),
           ('Button', '버튼'), ('TextBox', '입력칸'), ('TextEdit', '입력칸'), ('SheetView', '그리드 시트'), ('Spread', '그리드'), ('Grid', '그리드'), ('Label', '라벨'),
           ('ConditionPanel', '조회조건 영역'), ('LayoutControlGroup', '배치 그룹'), ('LayoutControlItem', '배치 항목'), ('LayoutControl', '배치 영역'), ('GroupBox', '그룹 영역'),
           ('Panel', '영역'), ('TabControl', '탭'), ('SplitContainer', '분할 영역'), ('Calendar', '달력'), ('NumericUpDown', '숫자 입력')]
GRID_MARK_KO = {'기본': '표시', '숨김': '숨김', '코드추가': '코드로 추가', '코드추가?': '코드로 추가(추정)', '-': '-'}
BIZ_KO = {'fox': 'SP 호출', 'biz': '공통 데이터 조회', 'sql': '직접 SQL', 'popup': '팝업', 'excel': 'Excel', 'unknown': '미확인'}

def ctrl_kind(tp):
    tp = str(tp or '')
    for k, v in CTRL_KO:
        if k.lower() in tp.lower(): return v
    return tp.split('.')[-1] or ''
def ev_ko(e): return EVENT_KO.get(e, e)
def status_ko(s): return STATUS_KO.get(str(s).upper(), s)

_LINE_REF = re.compile(r'\s*\((?:정본\s*)?L\d[\d,\s~\-–L]*\)'); _LINE_REF2 = re.compile(r'\s*[—-]\s*L\d[\d,\s~\-–L]*(?=[\s,)]|$)')
_LINE_TOKEN = re.compile(r'(?:정본\s*)?L\d+(?:\s*[~\-–]\s*L?\d+)?'); _BACKTICK = re.compile(r'`([^`]*)`'); _BOLD = re.compile(r'\*\*([^*]*)\*\*')
def clean(t):
    """MD 1행 → 읽는 문장: 백틱·굵게·라인번호 제거, 내용 보존"""
    t = _BACKTICK.sub(r'\1', str(t or '')); t = _BOLD.sub(r'\1', t); t = _LINE_REF.sub('', t); t = _LINE_REF2.sub('', t); t = _LINE_TOKEN.sub('', t)
    t = re.sub(r'[,\s]*\)', ')', t); t = re.sub(r'\(\s*[,;]\s*', '(', t); t = re.sub(r'\(\s*\)', '', t); t = re.sub(r'\s+([,.])', r'\1', t); t = re.sub(r'\s{2,}', ' ', t)
    t = t.replace('Fact Pack', '분석 자료').replace('엔드포인트', '호출 SP').replace('핸들러', '처리 함수').replace('cascade', '연동').replace('바인딩', '표시')
    return t.strip(' ,;—-')

# ── 원천 읽기 ───────────────────────────────────────────────────────────────────
def read_csv(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as fh:
        rows = list(csv.reader(fh))
    if not rows: return []
    h = rows[0]; return [dict(zip(h, r + [''] * (len(h) - len(r)))) for r in rows[1:] if any(x.strip() for x in r)]
def read_text(p): return open(p, encoding='utf-8-sig').read() if os.path.exists(p) else ''

def md_sections(text):
    """MD → {'1. 제목': [lines...]} (## 단위) + 하위 ### 는 본문에 포함"""
    out, cur = {}, None
    for ln in text.replace('\r\n', '\n').split('\n'):
        m = re.match(r'^##\s+(.*)', ln)
        if m: cur = clean(m.group(1)); out[cur] = []; continue
        if cur is not None: out[cur].append(ln)
    return out
def find_sec(secs, *keys):
    for k, v in secs.items():
        if any(key in k for key in keys): return v
    return []
def md_tables(lines):
    """본문 줄 → [table rows(list of list)] 여러 개"""
    tables, i = [], 0
    while i < len(lines):
        if re.match(r'^\s*\|.*\|\s*$', lines[i]) and i + 1 < len(lines) and re.match(r'^\s*\|[\s:|-]+\|\s*$', lines[i + 1]):
            rows = []
            while i < len(lines) and re.match(r'^\s*\|.*\|\s*$', lines[i]):
                if not re.match(r'^\s*\|[\s:|-]+\|\s*$', lines[i]): rows.append([clean(c) for c in lines[i].strip().strip('|').split('|')])
                i += 1
            tables.append(rows); continue
        i += 1
    return tables
def md_bullets(lines):
    out = []
    for ln in lines:
        s = ln.strip()
        if re.match(r'^[-*]\s+', s) or re.match(r'^\d+\.\s+', s): out.append(clean(re.sub(r'^([-*]|\d+\.)\s+', '', s)))
    return out
def md_prose(lines):
    out, in_code = [], False
    for ln in lines:
        s = ln.strip()
        if s.startswith('```'): in_code = not in_code; continue
        if in_code or not s or s.startswith('|') or s.startswith('#'): continue
        out.append(clean(re.sub(r'^([-*]|\d+\.)\s+', '', s)))
    return out
def md_codeblocks(lines):
    blocks, cur, in_code = [], [], False
    for ln in lines:
        if ln.strip().startswith('```'):
            if in_code: blocks.append(cur); cur = []
            in_code = not in_code; continue
        if in_code: cur.append(ln.rstrip())
    return blocks

class Src:
    def __init__(self, ID):
        self.ID = ID
        self.agent = os.path.join(ROOT, 'Doc', 'asisfacts', 'agent', ID); self.pack = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID)
        self.gen = os.path.join(ROOT, 'Doc', 'gen', ID); self.db = os.path.join(ROOT, 'Doc', 'tobefacts', 'db')
        self.md = {k: read_text(os.path.join(self.agent, k + '.md')) for k in ['analysis', 'screen_design', 'tobe_design', 'business_analysis', 'oracle_migration', 'unit_test', 'web_components', 'source_links']}
        self.sec = {k: md_sections(v) for k, v in self.md.items()}
        self.controls = read_csv(os.path.join(self.pack, 'controls.csv')); self.events = read_csv(os.path.join(self.pack, 'events.csv'))
        self.endpoints = read_csv(os.path.join(self.pack, 'endpoints.csv')); self.validations = read_csv(os.path.join(self.pack, 'validations.csv'))
        self.expressions = read_csv(os.path.join(self.pack, 'expressions.csv')); self.grid = read_csv(os.path.join(self.pack, 'grid_effective.csv'))
        self.popups = read_csv(os.path.join(self.pack, 'popups.csv')); self.files = read_csv(os.path.join(self.pack, 'files.csv')); self.flow = read_csv(os.path.join(self.pack, 'flow.csv'))
        self.gap = read_csv(os.path.join(ROOT, 'Doc', 'gap', f'{ID}_gap.csv'))
        self.menu = read_csv(os.path.join(self.db, 'menu.csv')); self.proc_meta = [r for r in read_csv(os.path.join(self.db, 'proc_meta.csv')) if r.get('menu_id', '').upper() == ID]
        self.sheet_cols = [r for r in read_csv(os.path.join(self.db, 'sheet_columns.csv')) if r.get('program_id', '').upper() == ID]
        self.sheet_meas = [r for r in read_csv(os.path.join(self.db, 'sheet_measures.csv')) if (r.get('program_id') or r.get('menu_id') or '').upper() == ID]
        self.btn_auth = [r for r in read_csv(os.path.join(self.db, 'btn_auth.csv')) if r.get('mnu_id', '').upper() == ID and r.get('use_yn', 'Y') != 'N']
        self.groups = {r.get('user_gr_id'): (r.get('user_gr_nm') or r.get('user_gr_id')) for r in read_csv(os.path.join(self.db, 'user_group.csv'))}
        self.reg = json.load(open(os.path.join(self.gen, 'register.json'), encoding='utf-8-sig')) if os.path.exists(os.path.join(self.gen, 'register.json')) else {}
        pm = {r.get('proc'): r for r in read_csv(os.path.join(self.db, 'proc_params.csv'))}
        self.proc_params = {}
        for r in read_csv(os.path.join(self.db, 'proc_params.csv')): self.proc_params.setdefault(r.get('proc'), []).append(r)
        # 화면명 · 메뉴 경로
        mrow = next((m for m in self.menu if m.get('mnu_id', '').upper() == ID), None)
        self.name = (mrow or {}).get('mnu_desc') or ''
        if not self.name:
            m = re.search(r'화면명\*{0,2}:\s*\*{0,2}\s*([^\n|]+)', self.md['analysis'])
            self.name = m.group(1).strip() if m else ''
        if not self.name:
            m = re.search(r'^#\s+' + ID + r'\s+(.*?)\s*(화면|분석|설계)', self.md['analysis'] or self.md['screen_design'], re.M); self.name = m.group(1).strip() if m else ID
        path, cur, seen = [], mrow, set()
        while cur and cur.get('mnu_id') not in seen:
            seen.add(cur.get('mnu_id')); path.insert(0, cur.get('mnu_desc') or cur.get('mnu_id')); up = cur.get('uppr_mnu_id'); cur = next((m for m in self.menu if m.get('mnu_id') == up), None)
        self.menu_path = ' > '.join(path)
        self.page_dir = f"nscm-fe/features/{self.reg['feature']}/src/pages/{self.reg['pageDir']}" if self.reg.get('feature') else ''
        self.cur_files = [f for f in self.files if f.get('variant') == 'current']
        self.divisions = [c for c in (self.grid[0].keys() if self.grid else []) if c not in ('sheet', 'sheet_rule', 'column', 'label', 'source')]
        self.has_agent = bool(self.md['analysis'] or self.md['screen_design'])
    def safe_name(self):
        n = re.sub(r'[\\/:*?"<>|]+', '', self.name).replace(' ', '').replace('(', '').replace(')', '').replace('.', '')
        return n[:40] or self.ID
    def label_of(self, ctrl):
        for t in md_tables(find_sec(self.sec['screen_design'], '컨트롤 명세')):
            for r in t[1:]:
                if r and r[0] == ctrl and len(r) > 2: return r[2]
        return ''
    def endpoints_unique(self):
        seen, out = set(), []
        for e in self.endpoints:
            k = e.get('candidate') or e.get('key')
            if not k or k in seen: continue
            seen.add(k); out.append(e)
        return out
    def tables_from_objects(self):
        """objects 컬럼 'SELECT:T1, INSERT:T2' → {테이블: {읽기,쓰기}}"""
        acc = {}
        for e in self.endpoints:
            for tok in re.split(r'[,\s]+', e.get('objects') or ''):
                if ':' not in tok: continue
                op, name = tok.split(':', 1); name = name.strip()
                if not name or name.startswith('#') or name.startswith('@'): continue
                acc.setdefault(name, set()).add('읽기' if op.upper() in ('SELECT', 'REF', 'FROM', 'JOIN') else '쓰기')
        return acc

# ── 공통 블록 ───────────────────────────────────────────────────────────────────
def next_version(folder, prefix):
    os.makedirs(folder, exist_ok=True)
    vers = [0]
    for f in glob.glob(os.path.join(folder, prefix + '_v*.xlsx')):
        m = re.search(r'_v(\d+)(?:\.\d+)?\.xlsx$', f)
        if m: vers.append(int(m.group(1)))
    return max(vers) + 1

def block_overview(sb, S, doc_kind):
    sb.title(f'{S.ID} ({S.name}) {doc_kind}', f'작성 {TODAY} · 원천: 현행 소스 분석 자료 + 운영 메타(메뉴·SP 배선·그리드 컬럼) · 이 문서는 사람이 읽는 사본이며 변경 시 분석 자료를 먼저 갱신합니다')
    sb.sec('1. 개요')
    sb.kv('화면 ID / 명', f'{S.ID} / {S.name}')
    sb.kv('메뉴 경로', S.menu_path or '(운영 메뉴에 미등록)')
    sb.kv('페이지 폴더', S.page_dir or '(TO-BE 페이지 미생성)')
    ov = md_prose(find_sec(S.sec['analysis'], '화면 개요'))
    purpose = next((x.split(':', 1)[1].strip() for x in ov if x.startswith('주요 기능') or '주요 기능' in x), '')
    domain = next((x.split(':', 1)[1].strip() for x in ov if x.startswith('도메인')), '')
    if domain: sb.kv('업무 영역', domain)
    sb.kv('화면 성격', purpose or next(iter(md_prose(find_sec(S.sec['business_analysis'], '목적'))), '') or '(문서 생성 전 — 분석 자료만 반영)')
    if S.cur_files: sb.kv('현행 소스', '\n'.join(f"{f.get('file')}" for f in S.cur_files if f.get('file', '').endswith('.cs')))
    sb.kv('TO-BE SP 배선', '\n'.join(f"{r.get('sheet')} / {r.get('btn')} → {r.get('pkg') + '.' if r.get('pkg') else ''}{r.get('proc') or '(미배선)'}" for r in S.proc_meta) or '(운영 배선 없음)')
    sb.gap(); sb.sec('개정 이력'); sb.hdr(['버전', '일자', '내용']); sb.row(['v1.0', TODAY, '최초 작성 (현행 소스 분석 기준)'])

def block_flow(sb, S):
    sb.title('2. 전체 흐름', '이 화면이 업무 흐름의 어느 단계에서 쓰이는지와, 화면이 부르는 SP · 주요 테이블 · 저장 대상')
    sb.sec('A. 업무 흐름 속 위치'); sb.hdr(['단계', '프로세스', '설명', '본 화면'])
    scen = find_sec(S.sec['business_analysis'], '사용자 시나리오'); flows = find_sec(S.sec['business_analysis'], '업무 흐름도')
    steps = []
    for blk in md_codeblocks(flows):
        cur = None
        for ln in blk:
            m = re.match(r'^\s*(\d+)\.\s*\[(.+?)\]\s*(.*)', ln)
            if m: cur = [m.group(1), m.group(2), clean(m.group(3)), '본 화면']; steps.append(cur); continue
            m2 = re.match(r'^\s*→\s*(.*)', ln)
            if m2 and cur: cur[2] = (cur[2] + '\n' if cur[2] else '') + '→ ' + clean(m2.group(1))
    if not steps:
        # 시나리오 제목으로 대체
        for k in S.sec['business_analysis']:
            pass
        titles = re.findall(r'^###\s+시나리오\s*(\d+)\s*[:：]\s*(.*)', S.md['business_analysis'], re.M)
        steps = [[n, clean(t), '', '본 화면'] for n, t in titles]
    if steps:
        for s in steps: sb.row(s)
    else: sb.note('업무 흐름 원천 없음 — 문서 생성(S3.agent) 후 다시 만들면 채워집니다.')
    sb.gap(); sb.sec('B. 화면이 부르는 SP'); sb.hdr(['구분', 'SP / 데이터', '무엇을 하나요', 'TO-BE 배선', '참조 테이블'])
    pm_by = {}
    for r in S.proc_meta: pm_by.setdefault((r.get('proc') or '').upper(), r)
    for e in S.endpoints_unique():
        cand = e.get('candidate') or ''; sp = re.sub(r'^SP\s+', '', e.get('sp_or_sql') or '')
        tobe = next((f"{r.get('sheet')}/{r.get('btn')} → {r.get('pkg')+'.' if r.get('pkg') else ''}{r.get('proc')}" for k, r in pm_by.items() if k and (k in cand.upper() or (sp and sp.upper() in k))), '')
        use = next((row[2] for t in md_tables(find_sec(S.sec['screen_design'], '액션 명세')) for row in t[1:] if len(row) > 3 and cand.split('.')[-1] in row[3]), '')
        objs = ', '.join(sorted({tok.split(':', 1)[1] for tok in re.split(r'[,\s]+', e.get('objects') or '') if ':' in tok and not tok.split(':', 1)[1].startswith('#')}))
        sb.row([BIZ_KO.get(e.get('kind'), e.get('kind')), cand, use or EP_STATUS_KO.get(e.get('status'), e.get('status') or ''), tobe, objs])
    if not S.endpoints: sb.note('호출 SP 원천 없음')
    sb.gap(); sb.sec('C. 주요 데이터 테이블'); sb.hdr(['테이블', '읽기 / 쓰기', '비고'])
    tabs = S.tables_from_objects()
    for t, ops in sorted(tabs.items()): sb.row([t, ' / '.join(sorted(ops)), '메타(관리 설정) 테이블' if re.match(r'^(SCM_ADM|TB_FX|SHEET_)', t.upper()) else ''])
    if not tabs: sb.note('테이블 참조 원천 없음(SP 본문 미분석)')
    sb.gap(); sb.sec('D. 저장 대상 (Measure)'); sb.hdr(['항목', '내용'])
    if S.sheet_meas:
        for r in S.sheet_meas[:60]: sb.row([r.get('measure') or r.get('measure_name') or r.get('column_name') or '', ', '.join(f'{k}={v}' for k, v in r.items() if v and k not in ('program_id', 'menu_id'))][:2])
    else: sb.row(['해당 축 없음', '이 화면은 저장 대상 Measure 가 없습니다(조회 또는 단순 입력 화면).'])

# ── 화면설계서 8시트 ────────────────────────────────────────────────────────────
def build_design(S):
    wb = openpyxl.Workbook(); wb.remove(wb.active)
    sb = SB(wb.create_sheet('1.개요'), [22, 70, 30]); block_overview(sb, S, '화면설계서')
    sb = SB(wb.create_sheet('2.전체흐름'), [8, 30, 62, 30, 36]); block_flow(sb, S)
    # 3.LAYOUT
    sb = SB(wb.create_sheet('3.LAYOUT'), [22, 80]); sb.title('3. 화면 구성'); sb.hdr(['영역', '구성'])
    lay = find_sec(S.sec['screen_design'], '화면 레이아웃'); areas = []
    for blk in md_codeblocks(lay):
        cur = None
        for ln in blk:
            m = re.search(r'\[(.+?)\]\s*([\w.]*)', ln)
            if m and ('영역' in m.group(1) or '팝업' in m.group(1) or '그리드' in m.group(1) or 'Grid' in m.group(1)): cur = [clean(m.group(1)), '']; areas.append(cur); continue
            m2 = re.search(r'-\s*(.+)', ln)
            if m2 and cur: cur[1] = (cur[1] + '\n' if cur[1] else '') + clean(m2.group(1).strip('│ '))
    if not areas and S.controls:
        kids = {}
        for c in S.controls:
            if c.get('variant') != 'current': continue
            kids.setdefault(c.get('parent') or '(최상위)', []).append(f"{S.label_of(c.get('name')) or c.get('name')}({ctrl_kind(c.get('type'))})")
        for p, ks in kids.items(): areas.append([p, ', '.join(ks)])
    for a in areas: sb.row(a)
    if not areas: sb.note('레이아웃 원천 없음')
    pops = md_prose(find_sec(S.sec['screen_design'], '팝업')) or [f"{p.get('name') or p.get('popup')}" for p in S.popups]
    if pops: sb.gap(); sb.sec('팝업'); [sb.text(p) for p in pops]
    # 4.조회조건·버튼
    sb = SB(wb.create_sheet('4.조회조건·버튼'), [20, 16, 30, 44, 30]); sb.title('4. 조회조건 · 버튼'); sb.sec('조회조건'); sb.hdr(['항목', '유형', '데이터 원천', '동작 · 연동', '비고'])
    tbls = md_tables(find_sec(S.sec['screen_design'], '컨트롤 명세')); n = 0
    acts = {row[1]: row for t in md_tables(find_sec(S.sec['screen_design'], '액션 명세')) for row in t[1:] if len(row) > 2}
    for t in tbls:
        for r in t[1:]:
            if len(r) < 3: continue
            kind = ctrl_kind(r[1])
            if kind in ('버튼', '그리드', '그리드 시트', '조회조건 영역', '배치 영역', '배치 그룹', '배치 항목', '영역', '그룹 영역', '라벨', '분할 영역', '탭'): continue
            ev = r[5] if len(r) > 5 and r[5] not in ('-', '') else ''
            act = acts.get(ev); do = (act[2] + (' → ' + act[3] if len(act) > 3 and act[3] not in ('-', '') else '')) if act else (f'{ev_ko(ev.split("_")[-1])} 시 연동' if ev else '')
            sb.row([r[2] or r[0], kind, (r[6] if len(r) > 6 else ''), do, ('필수' if len(r) > 4 and r[4] == '필수' else '') + (f' · 초기값 {r[3]}' if len(r) > 3 and r[3] not in ('-', '') else '')]); n += 1
    if not n:
        for c in S.controls:
            if c.get('variant') == 'current' and ctrl_kind(c.get('type')) in ('기간 선택', '날짜 선택', '다중 선택 목록', '콤보', '체크박스', '입력칸', '선택 버튼'):
                sb.row([S.label_of(c.get('name')) or c.get('name'), ctrl_kind(c.get('type')), '', '', '']); n += 1
    if not n: sb.note('조회조건 원천 없음')
    sb.gap(); sb.sec('버튼'); sb.hdr(['버튼', '처리', '호출 SP', '결과 반영', '비고'])
    nb = 0
    for t in md_tables(find_sec(S.sec['screen_design'], '액션 명세')):
        for r in t[1:]:
            if len(r) >= 5: sb.row([r[0], r[2], r[3], r[4], '']); nb += 1
    if not nb:
        for c in S.controls:
            if c.get('variant') == 'current' and ctrl_kind(c.get('type')) == '버튼': sb.row([c.get('name'), '', '', '', '']); nb += 1
    if not nb: sb.note('버튼 원천 없음')
    # 5.GRID
    sb = SB(wb.create_sheet('5.GRID'), [26, 24, 30, 12, 12, 12, 12, 30]); sb.title('5. 그리드')
    sheets = {}
    for g in S.grid: sheets.setdefault(g.get('sheet'), []).append(g)
    divs = [d for d in S.divisions if any((g.get(d) or '') not in ('', '-') for g in S.grid)]
    if sheets:
        for sh, rows in sheets.items():
            rule = rows[0].get('sheet_rule', ''); sb.sec(f"시트 '{sh}'" + (f" — 컬럼 구성: {'관리 설정 + 코드' if '코드' in rule else '관리 설정' if 'META' in rule else rule}" if rule else ''))
            sb.hdr(['컬럼(식별자)', '표시 이름', '원천'] + divs[:4] + ['비고'])
            for g in rows: sb.row([g.get('column'), g.get('label'), '관리 설정' if g.get('source') == 'META' else '코드 지정' if g.get('source') else ''] + [GRID_MARK_KO.get(g.get(d) or '', g.get(d) or '') for d in divs[:4]] + [''])
            sb.gap()
    for t in md_tables(find_sec(S.sec['screen_design'], '그리드 명세')):
        pass
    gm = md_prose(find_sec(S.sec['screen_design'], '그리드 명세'))
    if gm: sb.sec('그리드 동작 설명'); [sb.text(x) for x in gm[:40]]
    if not sheets and not gm: sb.note('그리드 원천 없음')
    # 6.EVENT
    sb = SB(wb.create_sheet('6.EVENT'), [8, 26, 18, 44, 36, 30]); sb.title('6. 사용자 동작과 처리'); sb.hdr(['번호', '대상', '동작', '처리 내용', '호출 SP', '결과 반영'])
    acts_by_handler = {row[1]: row for t in md_tables(find_sec(S.sec['screen_design'], '액션 명세')) for row in t[1:] if len(row) > 2}
    i = 0
    for e in S.events:
        if e.get('variant') not in ('current', '', None): continue
        i += 1; h = e.get('handler') or ''; a = acts_by_handler.get(h) or acts_by_handler.get(e.get('target'))
        tgt = e.get('target') or ''; tgt_l = S.label_of(tgt.replace('this.', '')) or tgt.replace('this.', '') or '화면'
        sb.row([f'E{i:02d}', tgt_l, ev_ko(e.get('event')), (a[2] if a else ''), (a[3] if a and len(a) > 3 else ''), (a[4] if a and len(a) > 4 else '')])
    if not i: sb.note('사용자 동작 원천 없음')
    detail = find_sec(S.sec['analysis'], '기능 흐름')
    tb = md_tables(detail)
    if tb:
        sb.gap(); sb.sec('상세 — 진입점별 처리 경로'); sb.hdr(['진입점', '경로', '호출 SP', '상태', 'SP / SQL', ''])
        for t in tb:
            for r in t[1:]:
                r = [x for k, x in enumerate(r) if not (k == 2 and re.fullmatch(r'\d+', x or ''))]  # 줄 번호 열 제거
                sb.row([r[0] if r else '', r[1] if len(r) > 1 else '', r[2] if len(r) > 2 else '', EP_STATUS_KO.get(r[3], r[3]) if len(r) > 3 else '', r[4] if len(r) > 4 else '', ''])
    # 7.VALIDATION
    sb = SB(wb.create_sheet('7.VALIDATION'), [10, 44, 14, 50]); sb.title('7. 입력 확인과 메시지'); sb.hdr(['ID', '조건', '메시지', '동작'])
    nv = 0
    for v in S.validations:
        nv += 1; sb.row([f'V{nv:02d}', clean(v.get('condition') or v.get('detail') or v.get('text') or ''), v.get('msg_id') or v.get('message') or '', clean(v.get('action') or v.get('kind') or '')])
    for x in md_prose(find_sec(S.sec['screen_design'], '검증')) + md_prose(find_sec(S.sec['business_analysis'], '검증 규칙')) + md_prose(find_sec(S.sec['business_analysis'], '필수값')):
        if x: nv += 1; sb.row([f'V{nv:02d}', x, '', ''])
    if not nv: sb.row(['-', '화면 자체의 입력 확인 없음 (조회조건은 모두 선택 사항)', '', ''])
    # 8.API·SP
    sb = SB(wb.create_sheet('8.API·SP'), [30, 34, 60]); sb.title('8. SP · API 배선'); sb.sec('TO-BE 배선 (운영 메타)'); sb.hdr(['시트 / 버튼', 'SP', '입력 파라미터'])
    for r in S.proc_meta:
        ps = S.proc_params.get(r.get('proc')) or []
        sb.row([f"{r.get('sheet')} / {r.get('btn')}", f"{r.get('pkg')+'.' if r.get('pkg') else ''}{r.get('proc') or '(미배선)'}", ', '.join(p.get('col_nm') for p in sorted(ps, key=lambda p: int(p.get('sort_ord') or 0)) if p.get('col_tp_cd', 'IN') != 'OUT')])
    if not S.proc_meta: sb.note('운영 배선 없음 — 등록 SQL 적용 전')
    sb.gap(); sb.sec('현행 SP 와 참조 테이블'); sb.hdr(['현행 호출', 'SP', '참조 테이블'])
    for e in S.endpoints_unique(): sb.row([e.get('candidate'), re.sub(r'^SP\s+', '', e.get('sp_or_sql') or ''), ', '.join(sorted({tok.split(':', 1)[1] for tok in re.split(r'[,\s]+', e.get('objects') or '') if ':' in tok}))])
    t2 = md_tables(find_sec(S.sec['tobe_design'], '호출 API'))
    if t2: sb.gap(); sb.sec('동작별 호출 SP 후보 (설계 가이드)'); sb.hdr(t2[0][0][:3]); [sb.row(r[:3]) for r in t2[0][1:]]
    return wb

# ── UI분석서 10시트 ─────────────────────────────────────────────────────────────
def build_analysis(S):
    wb = openpyxl.Workbook(); wb.remove(wb.active)
    sb = SB(wb.create_sheet('1.개요'), [22, 60, 40]); block_overview(sb, S, 'UI분석서')
    sb = SB(wb.create_sheet('2.전체흐름'), [8, 30, 60, 30, 36]); block_flow(sb, S)
    sb = SB(wb.create_sheet('3.VALIDATION취합'), [10, 14, 44, 14, 30, 22]); sb.title('3. 입력 확인 · 메시지 취합'); sb.hdr(['ID', '구분', '조건 · 동작', '메시지', 'TO-BE 반영', '비고'])
    n = 0
    for v in S.validations: n += 1; sb.row([f'A-{n:02d}', clean(v.get('kind') or '화면 확인'), clean(v.get('condition') or v.get('detail') or v.get('text') or ''), v.get('msg_id') or '', '', ''])
    for x in md_prose(find_sec(S.sec['screen_design'], '검증')): n += 1; sb.row([f'A-{n:02d}', '화면 확인', x, '', '', ''])
    for x in md_prose(find_sec(S.sec['business_analysis'], '검증 규칙')) + md_prose(find_sec(S.sec['business_analysis'], '필수값')): n += 1; sb.row([f'B-{n:02d}', '업무 규칙', x, '', '', ''])
    for e in S.expressions: n += 1; sb.row([f'C-{n:02d}', '계산 · 잠금 규칙', clean(e.get('detail') or e.get('expression') or e.get('text') or ''), '', '', ''])
    if not n: sb.row(['-', '', '입력 확인 없음(조회 조건은 모두 선택 사항) — SP 내부 확인은 PKG 본문에서 별도 확인', '', '', ''])
    # 4.MATRIX_Division
    sb = SB(wb.create_sheet('4.MATRIX_Division'), [26, 20, 20, 20, 20, 30]); sb.title('4. Division 별 차이')
    divs = [d for d in S.divisions if any((g.get(d) or '') not in ('', '-') for g in S.grid)][:4]
    sb.hdr(['축'] + divs + ['근거'][:1] + [''] * (4 - len(divs)))
    for sh, rows in {g.get('sheet'): None for g in S.grid}.items():
        rs = [g for g in S.grid if g.get('sheet') == sh]
        sb.row([f"그리드 '{sh}' 컬럼 수"] + [str(sum(1 for g in rs if (g.get(d) or '') not in ('', '-', '숨김'))) for d in divs] + ['관리 설정 컬럼 기준'])
    for x in md_prose(find_sec(S.sec['tobe_design'], 'Division')) + md_prose(find_sec(S.sec['web_components'], 'Division')) + md_prose(find_sec(S.sec['analysis'], 'Division')): sb.row([x])
    if not S.grid and not divs: sb.note('Division 축 없음 — 이 화면은 Division 에 따른 차이가 없습니다.')
    # 5.MATRIX_권한
    sb = SB(wb.create_sheet('5.MATRIX_권한'), [24, 14, 14, 14, 16, 46]); sb.title('5. 권한 그룹별 사용 기능')
    grs = sorted({r.get('user_gr_id') for r in S.btn_auth})[:4]
    sb.hdr(['기능(시트 / 버튼)'] + [S.groups.get(g, g) for g in grs] + [''] * (4 - len(grs)) + ['비고'])
    keys = sorted({(r.get('sht_nm'), r.get('mnu_btn_cd')) for r in S.btn_auth})
    for sh, btn in keys: sb.row([f'{sh} / {btn}'] + [('Y' if any(r.get('user_gr_id') == g and r.get('sht_nm') == sh and r.get('mnu_btn_cd') == btn for r in S.btn_auth) else '') for g in grs] + [''] * (4 - len(grs)) + [''])
    for x in md_prose(find_sec(S.sec['screen_design'], '권한')) + md_prose(find_sec(S.sec['tobe_design'], '권한')): sb.row([x])
    if not keys: sb.note('운영 버튼 권한 메타 없음 — 등록 전이거나 전 그룹 공통')
    # 6.MATRIX_Measure
    sb = SB(wb.create_sheet('6.MATRIX_Measure'), [26, 62, 36]); sb.title('6. Measure 축'); sb.hdr(['축', '실측', 'TO-BE 방침'])
    if S.sheet_meas:
        for r in S.sheet_meas[:80]: sb.row([r.get('measure') or r.get('measure_name') or '', ', '.join(f'{k}={v}' for k, v in r.items() if v and k not in ('program_id', 'menu_id')), ''])
    else: sb.row(['해당 축 없음', '이 화면은 Measure(측정치) 개념이 없습니다.', ''])
    # 7.MATRIX_Bucket
    sb = SB(wb.create_sheet('7.MATRIX_Bucket'), [22, 26, 22, 22, 42]); sb.title('7. 기간 · Bucket 규칙'); sb.hdr(['항목', '내용', '', '', '비고'])
    bk = md_prose(find_sec(S.sec['business_analysis'], '날짜')) + md_prose(find_sec(S.sec['business_analysis'], '버킷'))
    for x in bk: sb.row([x])
    if not bk: sb.row(['해당 축 없음', '이 화면은 Bucket(일/주/월) 전환 규칙이 없습니다.'])
    # 8.가시성_LAYER종속
    sb = SB(wb.create_sheet('8.가시성_LAYER종속'), [26, 52, 40]); sb.title('8. 화면 요소의 표시 · 숨김 규칙'); sb.hdr(['화면 요소', '표시 규칙', '근거'])
    n8 = 0
    for c in S.controls:
        if c.get('variant') != 'current': continue
        k = ctrl_kind(c.get('type'))
        if k in ('조회조건 영역', '영역', '그룹 영역', '탭', '분할 영역'): sb.row([S.label_of(c.get('name')) or c.get('name'), f'{k} — 하위 요소를 담는 컨테이너', '화면 구성']); n8 += 1
    for x in md_prose(find_sec(S.sec['web_components'], '표시 차이')) + md_prose(find_sec(S.sec['screen_design'], '미확정')): sb.row([x]); n8 += 1
    if not n8: sb.note('표시 · 숨김 규칙 원천 없음')
    # 9.SP_LOOKUP_콤보
    sb = SB(wb.create_sheet('9.SP_LOOKUP_콤보'), [36, 72, 42]); sb.title('9. SP · 공통 데이터 · 콤보'); sb.hdr(['현행 호출', '용도 · 파라미터', 'TO-BE 대응'])
    pm_by = {(r.get('proc') or '').upper(): r for r in S.proc_meta}
    for e in S.endpoints_unique():
        cand = e.get('candidate') or ''; sp = re.sub(r'^SP\s+', '', e.get('sp_or_sql') or '')
        tobe = next((f"{r.get('pkg')+'.' if r.get('pkg') else ''}{r.get('proc')} ({r.get('sheet')}/{r.get('btn')})" for k, r in pm_by.items() if k and (k in cand.upper() or (sp and sp.upper() in k))), '')
        sb.row([cand, f"{BIZ_KO.get(e.get('kind'), e.get('kind'))} · {clean(e.get('detail') or '')}".strip(' ·'), tobe])
    for t in md_tables(find_sec(S.sec['oracle_migration'], '공통코드')):
        for r in t[1:]: sb.row(r[:3])
    if not S.endpoints: sb.note('호출 원천 없음')
    # 10.이전소스_차이점
    sb = SB(wb.create_sheet('10.이전소스_차이점'), [22, 40, 40, 30]); sb.title('10. 이전 소스 대비 차이'); sb.hdr(['축', '현행', '구버전', '판정'])
    legacy = [f for f in S.files if f.get('variant') == 'legacy']
    if legacy:
        for f in S.cur_files:
            base = os.path.basename(f.get('file', '')); lg = next((l for l in legacy if os.path.basename(l.get('file', '')) == base), None)
            sb.row([base, f"{f.get('lines')}행", f"{lg.get('lines')}행" if lg else '없음', ('동일' if lg and lg.get('sha256') == f.get('sha256') else '차이 있음' if lg else '구버전 없음')])
    else: sb.row(['구버전 소스', '없음', '', '비교 대상 없음 — 현행 단일'])
    return wb

# ── GAP분석서 ───────────────────────────────────────────────────────────────────
def build_gap(S):
    wb = openpyxl.Workbook(); wb.remove(wb.active)
    sb = SB(wb.create_sheet('1.요약'), [26, 16, 16, 16, 16, 30]); sb.title(f'{S.ID} ({S.name}) GAP 분석서', f'작성 {TODAY} · 현행 화면의 요소·동작·호출 SP·그리드 컬럼이 TO-BE 화면에 반영됐는지 대조한 결과')
    sb.sec('판정 기준'); sb.hdr(['판정', '뜻'])
    for k, v in STATUS_KO.items(): sb.row([v, {'COVERED': 'TO-BE 화면에 같은 기능이 있습니다.', 'INTENDED': 'TO-BE 설계상 다르게 만들기로 한 항목입니다(공통 컴포넌트로 대체 등).', 'MISSING': 'TO-BE 화면에서 아직 찾지 못했습니다 — 확인 후 반영이 필요합니다.', 'UNMAPPED': '대응 여부를 자동으로 판단하지 못했습니다 — 사람이 확인해야 합니다.', 'PARTIAL': '일부만 반영됐습니다.'}[k]])
    sb.gap(); sb.sec('구분별 현황');
    statuses = ['COVERED', 'INTENDED', 'MISSING', 'UNMAPPED']; sb.hdr(['구분'] + [STATUS_KO[s] for s in statuses] + ['합계'])
    kinds = sorted({g.get('kind') for g in S.gap}, key=lambda k: list(KIND_KO).index(k) if k in KIND_KO else 99)
    tot = {s: 0 for s in statuses}
    for k in kinds:
        cnt = {s: sum(1 for g in S.gap if g.get('kind') == k and g.get('status') == s) for s in statuses}
        for s in statuses: tot[s] += cnt[s]
        sb.row([KIND_KO.get(k, k)] + [cnt[s] or '' for s in statuses] + [sum(cnt.values())])
    sb.row(['합계'] + [tot[s] or '' for s in statuses] + [sum(tot.values())], KEY_FILL)
    need = sum(1 for g in S.gap if g.get('status') in ('MISSING', 'UNMAPPED'))
    sb.gap(); sb.text(f"조치가 필요한 항목: {need}건 ('3.조치 필요' 시트) · 반영 완료 {tot['COVERED']}건 · 의도적 변경 {tot['INTENDED']}건", OK_FILL if need == 0 else WARN_FILL)
    sb = SB(wb.create_sheet('2.GAP 전체'), [12, 34, 44, 18, 36, 40]); sb.title('2. 전체 항목'); sb.hdr(['구분', '현행 항목', '상세', '판정', '근거', '사유 · 설명'])
    fills = {'MISSING': BAD_FILL, 'UNMAPPED': WARN_FILL}
    for g in S.gap: sb.row([KIND_KO.get(g.get('kind'), g.get('kind')), clean(g.get('asis_item')), clean(g.get('asis_detail')), status_ko(g.get('status')), clean(g.get('evidence')), clean(g.get('reason'))], fills.get(g.get('status')))
    sb.ws.freeze_panes = 'A3'; sb.ws.auto_filter.ref = f'A2:F{sb.r}'
    sb = SB(wb.create_sheet('3.조치 필요'), [12, 34, 44, 18, 40, 16, 16]); sb.title('3. 조치 필요 항목', '미반영 · 대응 미확인 항목만 모았습니다. 담당자가 확인 결과와 조치를 적어 주세요.'); sb.hdr(['구분', '현행 항목', '상세', '판정', '확인 결과 / 조치', '담당', '완료일'])
    for g in S.gap:
        if g.get('status') in ('MISSING', 'UNMAPPED'): sb.row([KIND_KO.get(g.get('kind'), g.get('kind')), clean(g.get('asis_item')), clean(g.get('asis_detail')), status_ko(g.get('status')), clean(g.get('reason')), '', ''])
    if need == 0: sb.text('조치 필요 항목 없음', OK_FILL)
    sb.ws.freeze_panes = 'A3'
    return wb

# ── 단위테스트 TestCases4 ───────────────────────────────────────────────────────
TC_HEADERS = ['No', '테스트ID', '시나리오 ID', '', '', '시나리오', '구분', '타임라인', '스케줄\n(주기)', '단계', '버전타입', '화면 ID', '테스트명', '점검\n구분', '테스트데이터', '예상결과', 'As-IS Image ', 'TGT 테이블', 'TGT Measure', 'SRC 테이블', 'SRC Measure/원천', '설명', '삭제/복사구간', '비고', '실행절차', 'JOB (Full Name)', '프로시저 (Full Name)', '건수\n(As-Is/MSSQL)', '검증방법\n(As-Is/MSSQL)', '건수\n(To-Be/Oracle)', '검증방법\n(To-Be/Oracle)', '결과\n(P/F)', '실행일', '수행자']
def build_testcases(S):
    tbls = md_tables(find_sec(S.sec['unit_test'], '테스트 케이스')) or md_tables(S.md['unit_test'].split('\n'))
    if not tbls: return None
    rows = tbls[0][1:]; hdr = [h.lower() for h in tbls[0][0]]
    def col(r, *names):
        for nme in names:
            if nme in hdr and hdr.index(nme) < len(r): return r[hdr.index(nme)]
        return ''
    wb = openpyxl.Workbook(); wb.remove(wb.active)
    divs = [d for d in S.divisions if any((g.get(d) or '') not in ('', '-') for g in S.grid) and re.fullmatch(r'\d+', d)] or ['40', '81', '82']
    tabs = S.tables_from_objects(); tgt = ', '.join(t for t, ops in tabs.items() if '쓰기' in ops) or '-'; src = ', '.join(t for t, ops in tabs.items() if '읽기' in ops and '쓰기' not in ops) or '-'
    procs = ', '.join(sorted({f"{r.get('pkg')+'.' if r.get('pkg') else ''}{r.get('proc')}" for r in S.proc_meta if r.get('proc')})) or ''
    for d in divs:
        ws = wb.create_sheet(d)
        for i, h in enumerate(TC_HEADERS, 1):
            c = ws.cell(1, i, h); c.fill = TC_HDR_FILL; c.font = Font(name=FONT_NAME, size=10, bold=True, color='FFFFFF'); c.alignment = Alignment(horizontal='center', vertical='center', wrap_text=True); c.border = THIN
        ws.row_dimensions[1].height = 32; ws.freeze_panes = 'A2'
        for n, r in enumerate(rows, 1):
            kind = col(r, '구분'); proc_txt = clean(col(r, '절차')); pre = clean(col(r, '사전조건')); exp = clean(col(r, '기대결과')); inp = col(r, '입력값'); basis = clean(col(r, '근거'))
            step = '수정' if re.search(r'저장|수정|삭제|입력|편집', kind + proc_txt) else '조회'
            parts = [s.strip() for s in re.split(r'\s*(?:→|->|;)\s*', proc_txt) if s.strip()]
            steps_txt = '\n'.join(f'{i}) {s}' for i, s in enumerate(parts, 1)) if len(parts) > 1 else proc_txt
            vals = {1: n, 2: col(r, 'tc-id', 'tc_id', '테스트id'), 6: f'UI 상세 ({S.name})', 7: 'UI', 8: '주중', 10: step, 12: S.ID,
                    13: f'{S.name} — {kind}\n( {proc_txt[:60]} )', 14: '(정상)', 15: f'Div: {d} / {pre}', 16: exp,
                    18: tgt, 20: src, 22: clean(inp) if inp not in ('-', '') else '', 24: f'근거: {basis}' if basis else '',
                    25: steps_txt, 26: f'{S.name} 화면({S.ID})', 27: procs}
            for i in range(1, len(TC_HEADERS) + 1):
                c = ws.cell(n + 1, i, vals.get(i, '')); c.fill = TC_BODY_FILL; c.font = BASE_F; c.alignment = WRAP; c.border = THIN
        for i, w in enumerate([5, 16, 10, 3, 3, 24, 6, 8, 8, 8, 8, 10, 36, 8, 30, 44, 8, 26, 14, 26, 14, 24, 10, 24, 44, 24, 30, 10, 16, 10, 16, 8, 10, 10], 1): ws.column_dimensions[get_column_letter(i)].width = w
    return wb

# ── 실행 ────────────────────────────────────────────────────────────────────────
def save(wb, folder, prefix):
    v = next_version(folder, prefix); out = os.path.join(folder, f'{prefix}_v{v}.0.xlsx'); wb.save(out); return out
for ID in IDS:
    S = Src(ID); nm = S.safe_name(); made = []
    if not S.has_agent: print(f'[{ID}] 문서 생성(S3.agent) 산출 MD 없음 — 분석 자료(Fact Pack)·운영 메타·GAP 만으로 작성합니다 (설계서·분석서 일부 시트는 "원천 없음" 표기)')
    made.append(save(build_design(S), OUT_DESIGN, f'{ID}_{nm}_화면설계서'))
    made.append(save(build_analysis(S), OUT_ANALYSIS, f'{ID}_{nm}_UI분석서'))
    if S.gap: made.append(save(build_gap(S), OUT_ANALYSIS, f'{ID}_{nm}_GAP분석서'))
    else: print(f'[{ID}] GAP 원천 없음(Doc/gap/{ID}_gap.csv) — GAP분석서 생략')
    tc = build_testcases(S)
    if tc: made.append(save(tc, OUT_TEST, f'{ID}_{nm}_TestCases4'))
    else: print(f'[{ID}] unit_test.md 없음 — 단위테스트(TestCases4) 생략')
    for m in made: print(f'{ID} → {os.path.relpath(m, ROOT)}')
