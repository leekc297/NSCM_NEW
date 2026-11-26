"""화면 정합검증서 + 보완대상목록 xlsx 생성

  python tools/Harness/verify/make_verify_docs.py <MENU_ID> [--scope DB_ONLY|DB_FE]

입력  Doc/verify/<ID>/verify_ledger.csv (ledger.py → judge.py 판정 반영본)
산출  Doc/UI_CHECKLIST/<ID>_<화면명>_CheckList_v<N>.xlsx    (2026-10-28 정합검증서 → CheckList · 폴더 = harness.json paths.checklistDir, 기본 Doc/UI_CHECKLIST)
      Doc/UI_CHECKLIST/<ID>_<화면명>_ActionItemList_v<N>.xlsx ← 보완 적용(P6) 전에 사용자가 확인하는 목록
      Doc/verify/<ID>/fixlist.csv                         ← 보완 실행기(Vibe_Manager 🩹·🛠️·🧯)가 읽는 기계용 사본
버전 N 은 기존 파일 다음 번호(덮어쓰지 않음 · old/ 와 이전 위치 Doc/화면분석서 의 '정합검증서' 번호까지 이어서). 새 버전을 만들면 같은 화면의 이전 버전은
  Doc/UI_CHECKLIST/old/ 로 옮긴다(이전 위치 Doc/화면분석서 의 정합검증서·보완대상 포함 — tools/Docs/doc_archive.py). 보완 범위 = --scope 또는 tools/Harness/harness.json repairScope(기본 DB_ONLY).

보완 계층(fix_layer) 결정 — 원장 행에 값이 있으면 그대로, 없으면 아래 규칙(제안값, '근거' 열에 사유):
  DB_META   라벨·메시지 미등록(I1·I4), 컬럼 표시·편집 메타(A5, D1 에서 TO-BE INPUT_TP_CD 가 AS-IS 와 어긋날 때), 기준정보(B8·N1·H9), 콤보 원천 SQL(B4·B5·B7)
  DB_OBJECT 저장·조회 SP 결과(A1·A6·A7·E4·F1·F4·F6·F7·F8)
  FE        셀 편집·검증·연쇄·전제조건·팝업 인자(D1·D3·D4·D5·D6·E1·E2·E3·E5·C1~C5·G1·G2·G5·G6·G7·H2·H3·H8)
  COMMON    공통 컴포넌트(K1~K5·G3·B6·H6·H7·H10·L2·I2 의 공통 폴백) — 어느 범위에서도 직접 수정 금지, 가이드만
  HUMAN     판정필요·조건부 기대
"""
import argparse
try:  # 2026-11-13: 설명 열 새 형식 모듈(없거나 오류면 종전 한 줄 설명으로 동작)
    import sys as _s, os as _o; _s.path.insert(0, _o.path.dirname(_o.path.abspath(__file__))); import plain_detail
except Exception:
    plain_detail = None
import csv
import json
import os
import re
import sys
from collections import Counter

from openpyxl import Workbook
from openpyxl.cell.cell import ILLEGAL_CHARACTERS_RE
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
def _harness_paths():
    """개선안 20261124012047_SELF_2(R83): 산출물 폴더 = harness.json paths 1곳. 값이 없으면 checklistDir 기본값만 쓴다."""
    try:
        with open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig') as f:
            h = json.load(f) or {}
    except (OSError, ValueError):
        h = {}
    return h.get('paths') if isinstance(h.get('paths'), dict) else {}


def _abs(p):
    return os.path.normpath(p if os.path.isabs(p) else os.path.join(ROOT, p))


_HP = _harness_paths()
OUTDIR = _abs(_HP.get('checklistDir') or 'Doc/UI_CHECKLIST')  # 없으면 next_version 이 생성
OLD_CHECKLIST_DIRS = [_abs(d) for d in (_HP.get('legacyChecklistDirs') or []) if d]  # 옛 폴더 = 쓰지 않음. 사용자 의견 누적·번호 이어가기용으로만 읽는다
LEGACY_DIR = P('Doc', '화면분석서')            # 2026-10-28 이전 위치 — 사용자 의견 누적·번호 이어가기용으로만 읽는다
DOC_KIND = {'CheckList': ('CheckList', '정합검증서'), 'ActionItemList': ('ActionItemList', '보완대상')}  # 2026-10-28 보완대상 → ActionItemList  # 종류 → (새 이름, 이전 이름)
sys.path.insert(0, P('tools', 'Docs'))
import doc_archive  # noqa: E402

LAYER_BY_RULE = {}
for _r in ('I1', 'I4', 'A5', 'B8', 'N1', 'H9', 'B4', 'B5', 'B7', 'H5'):
    LAYER_BY_RULE[_r] = 'DB_META'
for _r in ('A1', 'A2', 'A3', 'A6', 'A7', 'A8', 'E4', 'F1', 'F4', 'F6', 'F7', 'F8', 'M1', 'M2', 'J1', 'J2', 'J3', 'J4'):
    LAYER_BY_RULE[_r] = 'DB_OBJECT'
for _r in ('K1', 'K2', 'K3', 'K4', 'K5', 'G3', 'B6', 'H6', 'H7', 'H10', 'L2', 'E6', 'H4'):
    LAYER_BY_RULE[_r] = 'COMMON'
LAYER_NAME = {'DB_META': 'DB 메타', 'DB_OBJECT': 'DB 객체(PKG/SP)', 'FE': '화면 FE', 'COMMON': '공통 컴포넌트', 'HUMAN': '사람판정'}
AXIS_NAME = {'1': '1.디자인·다국어', '2': '2.AS-IS 로직', '3': '3.SMOKE', '4': '4.CRUD', '5': '5.권한별 CRUD'}
RESULT_NAME = {'PASS': 'PASS', 'FAIL': 'FAIL', '판정필요': '판정필요', 'ERROR': '미검증(ERROR)', 'NOT_RUN': '미검증', 'WARN': 'WARN', 'NA': '해당없음'}

HFILL = PatternFill('solid', fgColor='F2E1D9')
FILLS = {'FAIL': 'F8CBAD', 'PASS': 'E2EFDA', '판정필요': 'FFF2CC', 'ERROR': 'D9D9D9', 'NOT_RUN': 'EDEDED'}
THIN = Side(style='thin', color='BFBFBF')
BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def screen_name(mid):
    for r in read_csv(P('Doc', 'tobefacts', 'db', 'menu.csv')):
        if r['mnu_id'].upper() == mid:
            return re.sub(r'[^\w가-힣]+', '', r['mnu_desc'].title()) or mid
    return mid


def next_path(mid, name, kind):
    new, old = DOC_KIND[kind]
    n = max(doc_archive.next_version(OUTDIR, f'{mid}_{name}_{new}', also=[LEGACY_DIR] + OLD_CHECKLIST_DIRS),
            doc_archive.next_version(OUTDIR, f'{mid}_{name}_{old}', also=[LEGACY_DIR] + OLD_CHECKLIST_DIRS))
    return os.path.join(OUTDIR, f'{mid}_{name}_{new}_v{n}.xlsx'), n


def archive_after_save(path, mid, name, kind):
    """새 버전 저장 뒤 — 같은 화면 이전 버전을 Doc/UI_CHECKLIST/old/ 로(이전 위치 Doc/화면분석서 의 옛 이름 파일 포함)"""
    doc_archive.archive_previous(path)
    _, old = DOC_KIND[kind]
    legacy = [f for f in doc_archive.all_versions([LEGACY_DIR], f'{mid}_{name}_{old}_v*.xlsx') if os.path.dirname(f) == LEGACY_DIR]
    if legacy:
        od = os.path.join(OUTDIR, doc_archive.OLD); os.makedirs(od, exist_ok=True)
        import shutil
        for f in legacy:
            dst = os.path.join(od, os.path.basename(f))
            if not os.path.exists(dst):
                try: shutil.move(f, dst)
                except OSError as ex: print(f'  [WARN] 이전 위치 문서 이동 실패(열려 있음?): {os.path.basename(f)} — {ex}')
        print(f'  이전 위치(Doc/화면분석서) {old} {len(legacy)}개 → {od}')


def prior_docs(mid):
    """사용자 의견·판정 누적용 — 이 화면 CheckList·옛 정합검증서 전 버전(새 폴더·old·이전 위치), 오래된 → 최신"""
    dirs = [OUTDIR] + OLD_CHECKLIST_DIRS + [LEGACY_DIR]
    fs = doc_archive.all_versions(dirs, f'{mid}_*_CheckList_v*.xlsx') + doc_archive.all_versions(dirs, f'{mid}_*_정합검증서_v*.xlsx')
    # '{mid}_*' 는 별개 화면(DMF0003 ↔ DMF0003_1_…)까지 잡는다 — ID 바로 뒤가 숫자 구간이면 다른 화면
    fs = [f for f in fs if not re.match(rf'^{re.escape(mid)}_\d+_', os.path.basename(f)) and not os.path.basename(f).startswith('~$')]
    return sorted(set(fs), key=os.path.getmtime)


def scope_setting(cli):
    if cli:
        return cli
    try:
        with open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig') as f:
            return json.load(f).get('repairScope', 'DB_ONLY')
    except (OSError, ValueError):
        return 'DB_ONLY'


def decide_layer(r):
    if r.get('fix_layer'):
        return r['fix_layer'], '원장 지정'
    if r['result'] == '판정필요':
        return 'HUMAN', '기대가 조건부·정답 확정 필요'
    rid = r['rule_id']
    if rid == 'D1' and 'INPUT_TP_CD' in r.get('asis_ref', ''):
        m = re.search(r"INPUT_TP_CD=(\w+)", r['asis_ref'])
        itp = m.group(1) if m else ''
        want_edit = r['expected'].startswith('편집 가능')
        meta_edit = itp in ('O', 'M') or (itp in ('IO', 'IM') and r['condition'] == '신규행')
        if itp and want_edit != meta_edit:
            return 'DB_META', f"TO-BE SHEET_COLUMNS.INPUT_TP_CD={itp} 가 AS-IS 기대와 반대 → 메타 수정 우선"
        return 'FE', f'메타(INPUT_TP_CD={itp or "-"})는 기대와 같음 → 화면 편집 제어(beginningEdit) 결함'
    if rid in LAYER_BY_RULE:
        return LAYER_BY_RULE[rid], f'규칙 {rid} 기본 계층'
    if rid == 'I2' and "'_'" in r.get('evidence', ''):
        return 'DB_META', '화면 폴백 노출 = 코드 미등록(I1 과 동일 조치)'
    return 'FE', f'규칙 {rid} 기본 계층(화면 동작)'


def apply_status(layer, scope):
    if layer in ('DB_META', 'DB_OBJECT'):
        return '적용 예정'
    if layer == 'FE':
        return '적용 예정' if scope == 'DB_FE' else '범위 밖(가이드만)'
    if layer == 'COMMON':
        return '범위 밖(가이드만 · 공통 컴포넌트)'
    return '사람판정 대기'


ANSI_RE = re.compile(r'\x1b\[[0-9;]*[A-Za-z]')


def xl_safe(v):
    """Excel 셀에 못 들어가는 제어문자 제거(2026-10-30 SCP0100: K1 증거에 Playwright 색상 코드 \x1b[2m 이 섞여 '검증 전체' 시트 쓰기에서
    IllegalCharacterError → CheckList 생성 중단 exit 8). 판정 문자열은 검사기가 아무 도구 오류 문구든 붙일 수 있으니 쓰는 쪽에서 정제한다(검사기 결함 T10)."""
    if isinstance(v, str):
        v = ANSI_RE.sub('', v)
        return ILLEGAL_CHARACTERS_RE.sub('', v)
    return v


def write_sheet(wb, title, header, rows, widths, result_col=None):
    ws = wb.create_sheet(title[:31])
    ws.append([xl_safe(h) for h in header])
    for c in ws[1]:
        c.fill, c.font, c.alignment, c.border = HFILL, Font(bold=True, size=11), Alignment(horizontal='center', vertical='center', wrap_text=True), BORDER
    for r in rows:
        ws.append([xl_safe(v) for v in r])
    for row in ws.iter_rows(min_row=2):
        for c in row:
            c.alignment, c.border, c.font = Alignment(vertical='top', wrap_text=True), BORDER, Font(size=10)
        if result_col is not None:
            v = str(row[result_col].value or '')
            key = next((k for k in FILLS if v.startswith(RESULT_NAME.get(k, k)) or v == k), None)
            if key:
                row[result_col].fill = PatternFill('solid', fgColor=FILLS[key])
    for i, w in enumerate(widths, 1):
        ws.column_dimensions[get_column_letter(i)].width = w
    ws.freeze_panes = 'A2'
    ws.auto_filter.ref = ws.dimensions
    ws.sheet_view.showGridLines = False
    return ws


# 2026-10-27 사용자 지시: 1~5 축 시트를 '검증 전체' 한 시트로 합치고 축은 '분류' 열(1.디자인·다국어 / 2.AS-IS 로직 / 3.SMOKE / 4.CRUD / 5.권한별 CRUD)로. '검증 ID' 는 2번째 열 고정(사용자판정 반입 키 rr[1])
# 2026-10-30 사용자 지시: 열 순서 = 영역 / 대상 / 결과 / 설명(구 '쉬운 설명' 명칭 변경) / 기대(AS-IS·규칙) / AS-IS 근거 / 조건 / 정답 / … — 결과·설명 두 열을 대상 바로 뒤로.
#   열 폭은 이름으로 묶어(LW_BY) 순서를 바꿔도 폭·값이 밀리지 않게 한다. lrow() 도 이름 → 값 사전으로 만들어 LH 순서로 뽑는다.
LH = ['No', '검증 ID', '분류', '출처', '유형', '규칙', '영역', '대상', '결과', '설명', '기대(AS-IS·규칙)', 'AS-IS 근거', '조건', '정답', '판정 방법', 'CheckList Remark', '사용자의견', '근거 등급', '증거(실측)', 'TO-BE 위치', '결함 원장', '사용자판정',
      '오라클', '기대 원천', '증거 경로', '전제']  # W8-A(플랜 G2): 3-증거 열 — 조치 필요 행마다 비공란이어야 한다
LW_BY = {'No': 5, '검증 ID': 12, '분류': 14, '출처': 11, '유형': 6, '규칙': 7, '영역': 10, '대상': 30, '조건': 22, '정답': 7, '기대(AS-IS·규칙)': 50, 'AS-IS 근거': 40, '판정 방법': 10, '결과': 11,
         'CheckList Remark': 50, '사용자의견': 30, '설명': 70, '근거 등급': 16, '증거(실측)': 60, 'TO-BE 위치': 22, '결함 원장': 14, '사용자판정': 30, '오라클': 9, '기대 원천': 28, '증거 경로': 34, '전제': 30}
LW = [LW_BY[h] for h in LH]
RESULT_COL = LH.index('결과')  # write_sheet 의 result_col 은 0-based(row[result_col]) — 2026-10-27 결과 배경색이 '근거 등급' 열에 칠해지던 결함 수정

# ── 근거 등급 (2026-10-26, Atlas Studio 규약 이식: 통과 근거 = 기계·사람(hard) vs AI 판단(soft), AI 판단만으로는 통과 금지) ──
#   판정 출처(tobe_ref)·증거 앞머리로 정한다. AI 판단만 있는 PASS·해당없음은 문서에서 '판정필요(AI 판단만)' 로 세고 PASS 로 세지 않는다.
GRADES = ['기계', '기계(상속·집계)', '사람', 'AI 작성·인용 확인', 'AI 판단만', '출처 미기록', '없음(미검증)', '없음(판정 대기)']
GRADE_HARD = {'기계', '기계(상속·집계)', '사람', 'AI 작성·인용 확인'}


def evidence_grade(r):
    res, t, ev = r.get('result') or '', (r.get('tobe_ref') or '').strip(), (r.get('evidence') or '').strip()
    if res in ('NOT_RUN', 'ERROR', ''):
        return '없음(미검증)'
    if res in ('판정필요', 'WARN'):
        return '없음(판정 대기)'
    if t.startswith('수동 사용자판정') or t.startswith('수동 결정(사람:'):
        return '사람'
    if t.startswith('수동 결정(AI·근거 확인)') or t.startswith('AI 검토(근거 확인)'):  # 2026-11-19 AI 판정 검토(llm_review.py) — 인용이 기계 확인된 것만 반영된다
        return 'AI 작성·인용 확인'
    if t.startswith('수동 결정'):  # AI·근거 없음, 또는 작성자 미기록(구 형식)
        return 'AI 판단만'
    if t.startswith('TO-BE 설계 결정('):  # 2026-10-30 GAP 분석 '제외' = 사람(원천 담당자)이 확정한 설계 결정 → 사람 근거
        return '사람'
    if re.match(r'^(상속|규칙 판정 상속|대조표 )', t) or re.match(r'^(행 집계|진입점 집계|대조표 상태 미구현|상속\(|검사 대상 아님 — 대조표 )', ev):
        return '기계(상속·집계)'
    if re.match(r'^(E2E|STATIC|META|W1 |수동 E2E|SYN|DB|sort)', t) or re.match(r'^(실측\[|시노님검사|검사 대상 아님)', ev):
        return '기계'
    if t:
        return '기계'
    return '출처 미기록'


def unverified_reason(r):
    """W8-A(플랜 1-5) 미검증 사유 4종 + 적용 불가(집계 제외). '' = 미검증 아님"""
    res = r.get('result') or ''; t = (r.get('tobe_ref') or '').strip(); ev = (r.get('evidence') or '').strip()
    if r.get('applicable') == 'N' or t.startswith('적용 불가(applicability)'): return '적용 불가(제외)'
    if ev.startswith('[재실측 스냅샷') and '골든 없음' in ev: return '승인대기(스냅샷)'  # W8-C: 수신본은 있으나 사용자 승인 골든이 아직 없음(snap/_review.md → snap_approve.py)
    if res in ('NOT_RUN', 'ERROR', ''): return '측정못함'
    if res == '판정필요' and (ev.startswith('[시험 검사') or ev.startswith('[보류 규칙')): return '시험검사'
    if res == 'NA' and (re.match(r'^(규칙 판정 상속 생략|직접 실측 없음|규칙 판정 상속\(대상 없음\)|W4 |W5 |W7 )', t) or re.match(r'^(자동 검사기 없음|자동 실측 없음|직접 실측 없음|규칙 \w+ 대상 일치 \d+행이 모두 NA)', ev)):
        return '대상불명' if r.get('applicable') == 'UNKNOWN' else '상속생략'
    return ''


def effective_result(r):
    # AI 판단만으로 PASS·해당없음이 된 행은 PASS 로 세지 않는다(판정필요). FAIL 은 보수적으로 유지.
    if r['_grade'] == 'AI 판단만' and r['result'] in ('PASS', 'NA'):
        return '판정필요'
    return r['result']


# 보완 종결 근거 — 보완 후 이 행을 '해결' 로 인정하는 조건(보완 실행기·사람이 같은 기준을 보게)
def close_evidence(r, layer):
    m = r.get('method') or ''
    if layer == 'HUMAN':
        return '사람 판정(결정표 by=이름) 또는 인용 확인된 근거(경로:줄+원문) — AI 설명만으로는 종결 불가'
    need = []
    if 'E2E' in m:
        need.append(f"run_verify.py 재실행에서 이 행({r['row_id']}) E2E 판정 PASS")
    if 'META' in m:
        need.append('사내 메타 재조회 판정 PASS')
    if 'DB' in m:
        need.append('DB 실측(ALL_SOURCE·결과 커서) PASS')
    if 'STATIC' in m or not need:
        need.append('judge·mapping_trace 정적 재판정 PASS')
    return ' · '.join(need) + ' — 보완 세션의 자기 보고(fixlist status)는 종결 근거가 아님'


USER_VERDICT = {}
REMARK = {}  # 2026-11-19 사용자 지시: 'CheckList Remark' 열 — 판정 검토(llm_review.csv)·사용자의견 처리 결과(opinion_intake.csv)를 행별로 적는다


def load_remarks(mid):
    """검증 ID → Remark 문구. 판정 검토: 분류·판정(반영 여부)·사유·근거 경로 / 사용자의견 처리: 처리 구분·답"""
    REMARK.clear()
    for x in read_csv(P('Doc', 'verify', mid, 'llm_review.csv')):
        rid = (x.get('row_id') or '').strip(); c = x.get('class') or ''
        if not rid or c in ('검토 제외', ''): continue
        if c == '미검토':
            REMARK[rid] = '[판정 검토] 검토하지 못함 — ' + (x.get('apply_why') or '')[:120]; continue
        ap = '반영' if x.get('apply') == 'Y' else ('미반영: ' + (x.get('apply_why') or '')[:60])
        L = [f"[판정 검토] 분류 {c} · 판정 {x.get('verdict', '')}({ap})", (x.get('reason') or '').strip()]
        if (x.get('evidence_ref') or '').strip(): L.append(('근거(확인됨): ' if x.get('verified') == 'Y' else '근거(미확인): ') + x['evidence_ref'].strip()[:300])
        if (x.get('rule_ref') or '').strip(): L.append('룰: ' + x['rule_ref'].strip() + ('' if x.get('rule_ok') == 'Y' else '(미등록)'))
        REMARK[rid] = chr(10).join(l for l in L if l)[:1500]
    for x in read_csv(P('Doc', 'verify', mid, 'opinion_intake.csv')):
        rid = (x.get('row_id') or '').strip()
        if not rid or not (x.get('class') or '').strip(): continue
        t = f"[의견 처리] {x.get('class', '')} — {(x.get('answer') or x.get('action') or '').strip()}"[:700]
        REMARK[rid] = (REMARK[rid] + chr(10) + t) if rid in REMARK else t


USER_OPINION = {}  # 정합검증서 '사용자의견' 열(2026-10-27 사용자가 조치 필요 시트에 추가) — 검증 ID 로 이어 넘긴다


def load_user_verdicts(mid):
    # 이전 정합검증서들의 '사용자판정' 열 — 새 버전으로 그대로 이어 넘긴다(사용자 기입 보존, 2026-10-26)
    import glob
    try:
        from openpyxl import load_workbook
    except Exception:
        return
    for f in prior_docs(mid):  # CheckList·옛 정합검증서 전 버전(checklistDir · legacyChecklistDirs · old · 이전 위치 Doc/화면분석서) 오래된 → 최신
        try: wb = load_workbook(f, read_only=True, data_only=True)
        except Exception: continue
        for ws in wb.worksheets:
            rws = list(ws.iter_rows(values_only=True))
            hi = next((i for i, rr in enumerate(rws[:5]) if any(c and ('사용자판정' in str(c) or '사용자의견' in str(c)) for c in rr)), None)
            if hi is None: continue
            for k, c in enumerate(rws[hi]):
                if not c: continue
                tgt = USER_VERDICT if '사용자판정' in str(c) else USER_OPINION if '사용자의견' in str(c) else None
                if tgt is None: continue
                for rr in rws[hi + 1:]:
                    if k < len(rr) and rr[k] and str(rr[k]).strip() and rr[1]: tgt[str(rr[1])] = str(rr[k]).strip()


# ── '쉬운 설명' 열(2026-10-27 사용자 요청: "AS-IS 규칙과 증거를 사용자가 쉽게 이해할 수 있게") ──
#   형식: [무엇을 보는 검사] 대조표 항목(있으면) · AS-IS 는 어떻게 동작 · TO-BE 실측은 어땠나 · 결론(같음/다름/대상 아님/사람 확인)
RULE_MEAN = {
    'A1': '같은 조건으로 조회한 결과 건수가 AS-IS 와 같은지', 'A2': '코드 값이 이름(명칭)으로 표시되는지', 'A3': '조회 결과가 없을 때의 안내', 'A4': '재조회 때 이전 결과가 남지 않는지',
    'A5': '그리드에 보이는 컬럼 구성이 AS-IS(메타·Division·개인화)와 같은지', 'A6': '조회 결과 행 순서(정렬)', 'K6': '상단 행 클릭/더블클릭으로 하단을 조회할 때 상단 그리드가 다시 조회·다시 그려짐(깜빡임) 없이 유지되는지', 'DB-SYN': 'DB 객체(PKG·테이블/뷰)·메타(MNU·PROC_M·SHEET_COLUMNS)·시노님·권한이 있고 유효한지 — 없거나 오류면 테스트가 돌 수 없어 차단(CR-076)', 'A8': '기간 동적 컬럼이 전 구간 만들어지는지', 'A10': '조회 전 빈 그리드 상태',
    'B1': '콤보 후보에 빈 항목이 없는지', 'B2': '콤보 후보에 중복이 없는지', 'B3': '콤보 후보 순서', 'B4': '콤보 후보 집합이 AS-IS 원천과 같은지', 'B8': '조회조건 콤보 종류·구성',
    'C1': '상위 조회조건을 바꾸면 하위 선택이 초기화되는지', 'C2': '상위 값에 따라 콤보 후보가 다시 만들어지는지', 'C3': '한 값을 고르면 연관 칸이 자동으로 채워지는지', 'C4': '상위 조건 변경 시 하위 후보가 다시 조회되는지',
    'C6': '값을 바꾸지 않고 셀을 닫았을 때 연관 칸이 그대로 남는지',
    'D1': '컬럼이 잠겨 있는지(편집 가능/불가)', 'D3': '행 조건(사이트 유형 등)에 따라 셀이 잠기는지', 'D4': 'Insert 한 새 행의 기본값', 'D5': '셀 입력 방식(텍스트·콤보·숫자·날짜)', 'D6': 'Insert 한 새 행이 생기는 위치',
    'E1': '숫자 셀 입력 범위(소수·최소·최대·문자 차단)', 'E2': '날짜 셀 입력 검증(존재하지 않는 날짜 차단)', 'E4': '업무 검증 메시지(저장 차단·안내)', 'E5': '입력 규칙(대문자·길이 등)',
    'F1': '저장이 DB 에 반영되는지', 'F2': '저장 결과 메시지', 'F3': '행의 CRUD 상태 표시(I/U/D)', 'F4': '저장 SP 호출·SQL 오류 없음', 'F5': 'Insert·수정 행의 CRUD 상태', 'F6': '저장 뒤 입력값이 그대로 남는지',
    'G1': '조회조건으로 조회 결과가 걸러지는지', 'G2': '멀티선택 조회조건(개별·전체 선택) 동작', 'G3': '조회조건 ↔ SP 인자 배선', 'G4': '조회조건 순서·구성이 기준표와 같은지', 'G5': '팝업으로 전달되는 조회조건·값', 'G6': '조회조건 초기값',
    'H2': '셀 색(편집 가능 노랑·글자색)', 'H3': '같은 값 인접 셀의 세로 병합(TO-BE 룰 CR-073: 키 컬럼만 병합)', 'H4': '컬럼 폭 비율·가로 스크롤', 'H5': '컬럼·조회조건 라벨(명칭)', 'H6': '팝업의 버튼 구성·그리드', 'H8': '숫자 천단위·소수·날짜 표시 포맷', 'H9': '컬럼 폭 메타', 'H10': '헤더 병합',
    'I1': '메타(SHEET_COLUMNS) 등록', 'I3': '명칭 컬럼 다국어', 'J1': '공통버튼(Insert/Delete/Save) 노출 = 기능 × 권한', 'J2': 'Division 권한에 따른 버튼 노출', 'J4': '권한 없는 기능 차단',
    'L1': '조회 응답 시간', 'L2': '입력 중 화면 재렌더', 'M1': 'Excel Upload 기능', 'M3': '팝업 내부 기능', 'M4': '팝업에서 고른 값이 행에 반영되는지', 'N1': '공란 컬럼',
    'X-NOTIMPL': 'GAP 에 미구현으로 적힌 동작을 화면에서 재현', 'X-ROW': 'AS-IS 메서드(진입점) 단위로 묶은 검사 결과', 'X-LOC': 'GAP 의 구현 위치 기록', 'X-REASON': 'GAP 제외·해당없음 사유 기록',
    'G8': '텍스트 조회조건을 대소문자 다르게 입력해도 같은 결과가 나오는지', 'G9': '텍스트 조회조건에 콤마로 값을 2개 이상 넣으면 전부 조회되는지', 'E7': '팝업으로 고르는 셀에 직접 입력한 잘못된 값이 차단되는지',
    'E6': '셀 키 입력(한글 IME·콤보 자동완성)', 'MS1': 'AS-IS 메시지와 같은 뜻의 TO-BE 메시지 ID 를 쓰는지(기준은 문구 의미, ID 일치 여부는 보지 않음)', 'DB-SYN': 'SP 가 쓰는 시노님·권한', 'SC1': '기준표 순서', 'SC2': '기준표 제외 조건 잔존', 'PCOL': '팝업 그리드 컬럼',
}
# FAIL 일 때 사용자가 화면에서 겪는 일(규칙별 한 문장)
FAIL_MEAN = {
    'C6': 'To Site(원천) 셀을 열었다가 값을 바꾸지 않고 닫기만 해도 연관 칸(Incoterms 등)이 지워집니다. AS-IS 는 값이 바뀔 때만 다시 계산합니다.',
    'E2': '존재하지 않는 날짜(예 10월 33일)를 입력해도 거부되지 않고 그대로 저장 대상이 됩니다. AS-IS 는 날짜 셀이 잘못된 날짜를 받지 않습니다.',
    'D6': 'Insert 를 누르면 새 행이 선택한 행 자리 대신 맨 위에 생깁니다. AS-IS 와 TO-BE 룰(hook #144) 둘 다 선택한 행 세트 바로 위입니다.',
    'G2': '멀티선택 조회조건에서 전체(ALL)를 고르고 조회하면 서버 오류가 나 결과가 0건입니다. 개별 선택은 정상입니다.',
    'C3': '팝업이나 상위 값 선택 뒤 자동으로 채워져야 하는 칸이 비어 있거나 다른 값입니다.',
    'H3': 'AS-IS 는 같은 값이 세로로 이어진 셀을 한 칸으로 합쳐 보여 주는데, TO-BE 는 이 컬럼을 합치지 않고 행마다 따로 보여 줍니다.',
    'H2': 'AS-IS 는 조건에 맞는 셀의 글자색·배경색을 바꿔 보여 주는데, TO-BE 그리드는 그 색 구분이 없습니다.',
    'M4': '팝업에서 고른 행의 값이 그리드 행에 옮겨지지 않았습니다.',
    'E1': '숫자 셀이 허용 범위 밖의 값(소수·범위 초과·문자)을 받습니다.',
    'B2': '콤보 후보 목록에 같은 값이 여러 번 나옵니다.',
    'D1': '컬럼의 잠금(편집 가능/불가) 상태가 AS-IS 와 다릅니다.',
    'A5': '그리드에 보이는 컬럼 구성이 AS-IS 와 다릅니다(빠졌거나 더 보임).',
    'H5': '컬럼 또는 조회조건의 라벨 문구가 AS-IS·기준표와 다릅니다.',
    'H8': '숫자 천단위·소수 자리·날짜 표시 포맷이 AS-IS 와 다릅니다.',
    'E4': 'AS-IS 가 띄우는 업무 검증 메시지(저장 차단·안내)가 TO-BE 에 없거나 다릅니다.',
    'G6': '조회조건의 초기값이 AS-IS 로드 시 값과 다릅니다.',
    'X-NOTIMPL': 'GAP 에 미구현으로 적힌 AS-IS 동작이 화면 재현에서도 없습니다. 구현이 필요합니다.',
}
RESULT_TAIL = {'PASS': '⇒ AS-IS 와 같게 동작합니다.', 'FAIL': '⇒ AS-IS 와 다릅니다(조치 필요).', 'NA': '⇒ 이 화면·데이터에서는 검사 대상이 아닙니다.', '판정필요': '⇒ 기계로 결론을 내지 못해 사람이 확인해야 합니다.', 'ERROR': '⇒ 검사 실행 오류.', 'NOT_RUN': '⇒ 아직 검사하지 않았습니다.'}
_PREFIXES = [re.compile(r'^\[사용자판정\].*?— 실측: ', re.S), re.compile(r'^\[사용자의견:[^\]]*\]\s*', re.S), re.compile(r'^실측\[T-[0-9a-f]+\]: '), re.compile(r'^\[대조표 [^\]]*실측으로 판정\] ')]
_TOK = [(re.compile(r'\bDIVISION_ID\b'), 'Division'), (re.compile(r'\bFROM_SITE_CODE\b'), 'From Site'), (re.compile(r'\bTO_SITE_CODE\b'), 'To Site'), (re.compile(r'\bTO_SITE\b'), 'To Site'), (re.compile(r'\bFROM_SITE\b'), 'From Site'),
        (re.compile(r'\bINCOTERMS_SSP\b'), 'SSP Incoterms'), (re.compile(r'\bINCOTERMS\b'), 'Incoterms'), (re.compile(r'\bTRANSPORT_MODE\b'), 'Trans Mode'), (re.compile(r'\bROUTE_ID\b'), 'Route Id'), (re.compile(r'\bPRIORITY\b'), 'Priority'),
        (re.compile(r'\bFROM_YYYYMMDD\b'), 'From 일자'), (re.compile(r'\bTO_YYYYMMDD\b'), 'To 일자'), (re.compile(r'\bVMI_YN\b'), 'To Site VMI'), (re.compile(r'\bBOD_VALID\b'), 'BOD Valid'), (re.compile(r'\bROUTE_VALID\b'), 'Route Valid'),
        (re.compile(r'\bLT_TYPE\b'), 'L/T Type'), (re.compile(r'\bROUTE_CNT\b'), 'Route Count'), (re.compile(r'\bLEAD_TIME\b'), 'Lead Time'), (re.compile(r'\bTO_CITY\b'), 'To City'), (re.compile(r'\bFROM_CITY\b'), 'From City'),
        (re.compile(r'\bDIS_TOTAL_LEAD_TIME\b'), 'Distribution Total L/T'), (re.compile(r'\bDAYS_(MON|TUE|WED|THU|FRI|SAT|SUN)\b'), lambda m: {'MON': '월', 'TUE': '화', 'WED': '수', 'THU': '목', 'FRI': '금', 'SAT': '토', 'SUN': '일'}[m.group(1)] + '요일'),
        (re.compile(r'\bREMARKS\b'), 'Remark'), (re.compile(r'\bCRUD_TYPE\b'), '행 상태')]


def _soften(t):
    for rx, k in _TOK: t = rx.sub(k, t)
    return t


def _strip(ev):
    ev = (ev or '').replace('\n', ' ').strip()
    changed = True
    while changed:
        changed = False
        for rx in _PREFIXES:
            ev2 = rx.sub('', ev, count=1)
            if ev2 != ev: ev, changed = ev2.strip(), True
    return ev



# 2026-11-06 사용자: 메시지 항목(MS1·E4)은 AS-IS MESSAGE_ID·DESC 와 TO-BE MESSAGE_ID·DESC 를 쉬운 설명에 나란히 — 한눈에 비교·검증
_MSG_TXT = None
def _msg_txt():
    global _MSG_TXT
    if _MSG_TXT is None:
        _MSG_TXT = {}
        try:
            for x in read_csv(P('Doc', 'tobefacts', 'db', 'msg_master.csv')):
                if (x.get('lang_cd') or '').upper() == 'KO' and x.get('msg_id'): _MSG_TXT[x['msg_id']] = (x.get('msg_nm') or '').replace(chr(10), ' ')
        except Exception:
            pass
    return _MSG_TXT
def _msg_cmp(ev):
    """증거 문장에서 AS-IS id·문구 / TO-BE 사용 id·문구(위치) / 같은 문구 TO-BE 코드 를 뽑아 비교 문장으로. 없으면 ''"""
    ev = (ev or '').replace(chr(10), ' ')
    m1 = re.search(r"\[AS-IS\] (MSG\d{5}) '([^']*)'", ev); m2 = re.search(r"\[TO-BE 사용\] (MSG\d{5}) '([^']*)' \(([^)]*)\)", ev); m3 = re.search(r"\[같은 문구 TO-BE 코드\] (MSG\d{5}) '([^']*)'", ev)
    if not m1:
        m1 = re.search(r"AS-IS (MSG\d{5}) '([^']*)'", ev); m3 = m3 or re.search(r"같은 문구의 TO-BE ID (MSG\d{5}) '([^']*)'", ev)
    if not m1: return ''
    T = _msg_txt(); aid, atx = m1.group(1), m1.group(2)
    out = [f'AS-IS {aid} "{_short(atx, 45)}"']
    if m2: out.append(f'TO-BE 사용 {m2.group(1)} "{_short(m2.group(2), 45)}" ({_short(m2.group(3), 30)})')
    else:
        same = T.get(aid)
        out.append(f'TO-BE {aid} "{_short(same, 45)}"' if same else f'TO-BE {aid} 미등록(SCM_ADM_MSG_M 행 없음)')
    tail = f' · 같은 문구 TO-BE 코드 {m3.group(1)} "{_short(m3.group(2), 45)}" → {m3.group(1)} 로 처리' if m3 else ''
    return ' ↔ '.join(out) + tail
def _msg_ids_txt(ev):
    """증거에 나온 MSG ID 들의 TO-BE 등록 문구(KO) — E4 등 메시지 검사 보조"""
    T = _msg_txt(); ids = []
    for mid_ in re.findall(r'MSG\d{5}', ev or ''):
        if mid_ not in ids: ids.append(mid_)
    return ' · '.join(f'{i} "{_short(T.get(i), 40)}"' if T.get(i) else f'{i} 미등록' for i in ids[:4])

def _fail_inputs(ev):
    bad = re.findall(r'([A-Z][A-Z0-9_]+)@\d+=(\S+) 입력 뒤 값이 다른 값으로 바뀜\(([^)]{0,50})', ev or '')
    al = re.search(r'알림=([^·|]{2,80})', ev or '')
    out = ''
    if bad: out += f" · 원인 후보: 앞 단계 입력 실패 {len(bad)}건 " + ', '.join(f"{c}='{v}'({_short(w, 30)})" for c, v, w in bad[:3])
    if al: out += f" · 알림 \"{al.group(1).strip()}\""
    return out
def _e7_plain(r, ev):
    m = re.search(r"입력 '([^']*)' → 값 '([^']*)' · 메시지 '([^']*)'(.*)$", ev or '')
    if not m: return f"{_target_label(r)}: 팝업 셀에 잘못된 값을 직접 입력했을 때 처리가 기대와 다름 — {_short(ev, 100)}"
    kept = m.group(1) == m.group(2); msg = m.group(3).strip()
    return (f"{_target_label(r)}: 팝업 셀에 잘못된 값 '{m.group(1)}' 을 직접 입력하면 {'값이 그대로 남고(되돌림 없음)' if kept else '값이 ' + repr(m.group(2)) + ' 로 바뀜'} · 메시지 {('없음' if not msg else repr(_short(msg, 40)))}"
            ' ' + f"{_short(m.group(4).strip(), 90)} → 기대: 되돌리거나 안내 메시지를 띄우고 저장 본문에 싣지 않음(SSP45REQ-23)")
def _target_label(r):
    """대조표 행이면 'D00-x-xxx · 요지' 를, 아니면 화면 용어 대상"""
    t = (r.get('target') or '').strip()
    return _soften(t)[:90]


# 쉬운 설명 — 한 문장. 사용자(2026-10-28 v75): "직관적으로 인지할 수 있게 간략히" · 사용자 제시 문구(E2·G2·C6) 그대로 채택
def _dbsyn_short(ev):
    """CR-076(2026-10-29): 객체명·원인·조치 SQL + 'CheckList 재작성 요청' 을 쉬운 설명에 그대로 — 사용자가 조치 필요 한 줄만 봐도 무엇을 어디에 실행하고 다음에 무엇을 해야 하는지 알게"""
    m = re.search(r'(?:접근할 수 없는 DB 객체|시노님 오류|콤보 SQL 객체) \d+건(?:\(([^)]*)\))?: ([^—]+)', ev or '')
    if (ev or '').startswith('[부분 차단]'):
        objs_ = (m.group(2).strip() if m else '콤보 SQL 객체')
        return f"⚠ 조회조건/셀 콤보가 쓰는 DB 객체 오류({objs_}) — 메인 조회는 정상이라 다른 검사는 판정했고 이 콤보에 의존하는 검사(B1~B4·G1·G2·C1·C4·D5)만 미검증 · 시노님/권한 조치 후 CheckList 재작성 요청"
    objs = (m.group(2).strip() + (f" [{m.group(1)}]" if m.group(1) else '')) if m else 'DB 객체·메타·시노님'
    g = re.search(r'남은 조치\(DBA\): ([^·]+)', ev or '')
    fix = f" · DBA 실행: {g.group(1).strip()[:150]}" if g else ' · 시노님은 syn_fix 가 자동 추가(이력 Doc/verify/_synonym_history.csv)'
    return f"⛔ DB 객체·메타·시노님 오류({objs}) — 테스트가 정상 실행되지 못해 이 CheckList 의 미검증 항목은 판정되지 않았음(비정상 결과를 결함으로 적지 않음){fix} · 대상을 등록·컴파일·GRANT 한 뒤 CheckList 재작성 요청(재실행해야 실제 검증 시작)"


def _a5_short(r, ev):
    m = re.search(r'(누락\([^)]*\) \d+개 = [^·]+)', ev or ''); n = re.search(r'(추가\([^)]*\) \d+개 = [^·]+)', ev or '')
    if m or n: return '그리드 컬럼 구성이 AS-IS 와 다름 — ' + ' · '.join(x.group(1).strip() for x in (m, n) if x)
    return f"{_target_label(r)}: 그리드 컬럼 표시 여부가 AS-IS 와 다름"


def _c6_src(ev):
    m = re.search(r'([A-Za-z_ ]+?) 셀을 열었다가', ev or '')
    return m.group(1).strip() if m else '원천'


def _l1_ms(ev):
    m = re.search(r'응답 (\d+)ms', ev or '')
    return f" — {m.group(1)}ms" if m else ''


def _a6_why(ev):
    w = []
    if 'NULL 정렬' in ev: w.append('빈 값 행 위치(Oracle NULL 정렬)')
    if '센티널' in ev or '첫 차이' in ev: w.append('기호/대소문자 정렬 차이')
    if '실측 순서대조' not in ev: w.append('정렬 키 다름')
    return (' — ' + ' · '.join(w)) if w else ''


def _g2_why(ev):
    return ' — SP 인자 자릿수 초과(32,767B)' if re.search(r'06502|32,?767|길이 초과', ev or '') else ''


# 쉬운 설명 — 한 문장. 2026-10-28 화면 독립화: 문구는 대상(_target_label)·증거에서 도출(특정 화면 컬럼명 금지)
FAIL_SHORT = {
    'G2': lambda r, ev: f"{_target_label(r)}: 전체(ALL) 선택 조회 시 서버 오류{_g2_why(ev)}",
    'E2': lambda r, ev: f"{_target_label(r)}: 일자 형식 오류(예 10월 33일)에도 입력 가능",
    'C6': lambda r, ev: f"{_target_label(r)}: {_c6_src(ev)} 셀을 변경 없이 편집 종료해도 종속 컬럼이 초기화됨 — CASCADE 미반영 처리 필요",
    'H2': lambda r, ev: (f"{_target_label(r)}: 조건부 글자색 규칙이 TO-BE 에 없음" if re.search(r'SetFGColor|Set_ValidTextColor|글자색', (r.get('target') or '') + ev) else f"{_target_label(r)}: 셀 색(편집 가능 노랑/글자색)이 AS-IS 와 다름"),
    'A6': lambda r, ev: f"조회 결과 행 순서가 AS-IS 와 다름{_a6_why(ev)}",
    'E6': lambda r, ev: f"{_target_label(r)}: 셀 키 입력 동작이 AS-IS 와 다름",
    'D6': lambda r, ev: 'Insert 새 행 위치가 AS-IS(선택 행 위)와 다름',
    'C3': lambda r, ev: f"{_target_label(r)}: 연관 값 자동 채움이 AS-IS 와 다름",
    'H3': lambda r, ev: f"{_target_label(r)}: 세로 병합이 AS-IS 와 다름",
    'M4': lambda r, ev: f"{_target_label(r)}: 팝업 선택값이 행에 반영되지 않음",
    'E1': lambda r, ev: f"{_target_label(r)}: 숫자 입력 범위(소수·범위·문자) 검증이 AS-IS 와 다름",
    'D1': lambda r, ev: f"{_target_label(r)}: 편집 가능/잠금이 AS-IS 와 다름",
    'D3': lambda r, ev: f"{_target_label(r)}: 행 조건부 잠금이 AS-IS 와 다름",
    'E4': lambda r, ev: f"{_target_label(r)}: AS-IS 업무 검증 메시지가 없거나 다름" + ((' — TO-BE 메시지: ' + _msg_ids_txt(ev)) if _msg_ids_txt(ev) else ''),
    'MS1': lambda r, ev: f"{_target_label(r)}: 같은 뜻의 TO-BE 메시지 ID 를 쓰지 않음" + ((' — ' + _msg_cmp(ev)) if _msg_cmp(ev) else ''),
    'G5': lambda r, ev: (f"{_target_label(r)}: 팝업 조건이 조회조건과 연동되지 않음 — " + ' · '.join(dict.fromkeys(re.findall(r'연동 누락: ([^—|]+?)\s*—', ev))) + ' 고정 전달'
                         if '연동 누락: ' in ev else f"{_target_label(r)}: 팝업에 넘기는 값이 AS-IS 와 다름"),
    'H6': lambda r, ev: f"{_target_label(r)}: 팝업 표준(버튼 순서·No. 컬럼)과 다름",
    # 2026-11-06(SCP0016 5번·SCP0037 4번): G4 규칙 안의 '돋보기 위치' 검사도 '순서·구성' 으로 적혀 사용자가 순서 오류로 읽었다 → 검사 대상별 문장
    'E7': lambda r, ev: _e7_plain(r, ev),
    'F1': lambda r, ev: f"{_target_label(r)}: 저장이 DB 에 반영되지 않음" + ((" — 저장 버튼 뒤 서버 저장 요청이 나가지 않음" + _fail_inputs(ev)) if '저장 요청 없음' in ev else ''),
    'F2': lambda r, ev: f"{_target_label(r)}: 저장 결과 메시지가 AS-IS 와 다름" + ((" — 저장 버튼 뒤 서버 저장 요청이 나가지 않음" + _fail_inputs(ev)) if '저장 요청 없음' in ev else ''),
    'G4': lambda r, ev: (f"{_target_label(r)}: 돋보기(검색 팝업) 버튼 위치가 입력칸과 맞지 않음" if '돋보기' in (r.get('target') or '')
                         else f"{_target_label(r)}: 조회조건 순서·구성이 기준표(Excel)와 다름"),
    'H5': lambda r, ev: f"{_target_label(r)}: 라벨이 기준표와 다름",
    'L1': lambda r, ev: f"{_target_label(r)}: 응답 시간 기준 초과{_l1_ms(ev)}",
    'F4': lambda r, ev: f"{_target_label(r)}: SP 호출 오류 또는 TO-BE 배선 없음",
    'A1': lambda r, ev: f"{_target_label(r)}: 같은 조건 조회 건수가 AS-IS 와 다름",
    'DB-SYN': lambda r, ev: _dbsyn_short(ev),
    'K6': lambda r, ev: '상단 행 클릭/더블클릭으로 하단 조회 시 상단 그리드가 다시 조회되거나 다시 그려짐(깜빡임)' + (' — 상단 재조회' if '다시 조회됨' in ev else '') + (' — 재렌더' if '다시 그려짐' in ev else ''),
    'A5': lambda r, ev: _a5_short(r, ev),
}


def _short(t, n=90):
    t = _soften(re.sub(r'\s+', ' ', t or '')).strip(' ·—')
    return t if len(t) <= n else t[:n - 1] + '…'


# 2026-11-06 사용자: 저장 결과 메시지·메시지·LABEL 오류는 쉬운 설명에 문구를 나열 — 규칙 집합(메시지·라벨 관련)과 증거에서 따옴표 문구를 뽑는다
MSG_LABEL_RULES = {'F2', 'E4', 'MS1', 'I2', 'I1', 'H5', 'E3', 'G4', 'E5', 'M2', 'H10', 'F1', 'K4', 'I3', 'D4'}
def _quoted(ev, n=6, w=60):
    out = []
    txt = (ev or '').replace(chr(10), ' ')
    for q in re.findall(r"'([^']{2,160})'", txt) + re.findall(r"(?:알림[=:]\s*|SAVE:\s*|메시지[=:]\s*)([^·|'\[\]]{2,120})", txt):  # 따옴표 문구 + '알림=…'·'SAVE: …' 형태
        q = q.strip()
        if q and q not in out and not re.fullmatch(r'[A-Z0-9_./:\\-]{1,20}', q): out.append(q)  # 코드·경로만인 토막은 제외
    return ' / '.join('"' + _short(q, w) + '"' for q in out[:n])
def _msg_texts_tail(rule, ev):
    if rule not in MSG_LABEL_RULES: return ''
    parts = []
    if rule in ('MS1', 'E4', 'F2', 'F1', 'M2', 'H10', 'E5'):
        t = _msg_ids_txt(ev)
        if t: parts.append('TO-BE 메시지 ' + t)
    q = _quoted(ev)
    if q: parts.append('실측 문구 ' + q)
    return (' — ' + ' · '.join(parts)) if parts else ''
def plain(r):
    out = _plain0(r)
    try:
        rule = r.get('rule_id') or ''; res = r.get('result') or ''
        if res in ('FAIL', '판정필요') and rule in MSG_LABEL_RULES and '실측 문구' not in out and '↔' not in out:  # MS1 비교 문장이 이미 있으면 중복 나열 안 함
            out += _msg_texts_tail(rule, r.get('evidence') or '')
    except Exception:
        pass
    return out
def _plain0(r):
    rule = r.get('rule_id') or ''; res = r.get('result') or ''; ev = _strip(r.get('evidence'))
    mean = RULE_MEAN.get(rule, rule); tgt = _target_label(r).rstrip('.')
    uv = re.match(r'^\[사용자판정\]\s*(.*?)\s*— 실측: ', (r.get('evidence') or '').replace(chr(10), ' '), re.S)
    note = f" (사용자 판정 '{_short(uv.group(1), 30)}')" if uv else ''
    # 집계 행
    m = re.match(r'^(행 집계|진입점 집계)\s*—\s*(?:대조표\s*)?(.+?)\s*의\s*(\S+)\s*(\d+)요소:\s*(.*?)(?: · FAIL 요소: (.*))?$', ev)
    if m:
        bad = _short((m.group(6) or '').split('; ')[0], 70)
        return f"세부 검사 {m.group(4)}건 합산({_short(m.group(5), 40)})" + (f" — FAIL 세부: {bad} · 조치는 세부 행에서" if bad else '')
    m = re.match(r'^진입점 집계\s*(\d+)검사\s*—\s*(.*)$', ev)
    if m:
        return f"AS-IS 메서드 안 세부 검사 {m.group(1)}건 합산({_short(m.group(2), 40)})" + (' — 조치는 세부 행에서' if res == 'FAIL' else '')
    if ev.startswith('선행 대조표') or ev.startswith('선행 미구현에 종속'):
        return f"선행 GAP 항목의 결과를 그대로 받음({ {'PASS': '같음', 'FAIL': '다름', 'NA': '대상 아님'}.get(res, res)}) — 별도 조치 없음"
    SHORT_RES = {'PASS': '같음', 'FAIL': '다름', 'NA': '대상 아님', '판정필요': '사람 확인', 'NOT_RUN': '미검사'}
    if r.get('source') in ('DEFECT', 'CONFIRMED', 'GENERAL'):
        return f"공통 점검 항목({mean}) — 이 화면의 같은 규칙 세부 결과: {SHORT_RES.get(res, res)}" + (' · 조치는 세부 행에서' if res == 'FAIL' else '')
    if rule in ('X-LOC', 'X-REASON'):
        return 'GAP 기록(구현 위치·사유) 확인됨' if res == 'PASS' else 'GAP 기록 보강(구현 위치·사유) — 화면 오류 아님'
    if rule == 'X-NOTIMPL':
        if res == 'PASS': return f"GAP 에는 미구현이지만 화면에선 이미 구현됨 — GAP 상태 수정 대상"
        if res == 'NA': return f"이번 데이터로 재현 불가 — {_short(ev.split(' — ')[0], 70)}"
        cur = re.search(r'커서\(선택 셀\) = r(\d+)/c(\d+) \(더블클릭한 셀 r\d+/c(\d+)\)', ev)
        if cur: return f"팝업 선택 후 커서가 더블클릭한 Route Id 셀({cur.group(3)}열)로 돌아오지 않고 {cur.group(2)}열로 이동 — AS-IS 는 그 셀로 복귀(GAP 사유: 저위험)"
        return f"GAP 미구현 항목이 화면에서도 미구현 — {_short(ev.split(' — ')[0], 80)}"
    if res == 'FAIL':
        f = FAIL_SHORT.get(rule)
        return (f(r, ev) if f else f"{mean}: AS-IS 와 다름 — {_short(ev.split(' — ')[0], 80)}") + note
    if res == 'PASS':
        return f"{mean}: AS-IS 와 같음" + note
    if res == 'NA':
        why = ev.split(' — ')[-1] if ' — ' in ev else ev
        return f"검사 대상 아님 — {_short(why, 80)}"
    if res == '판정필요':
        _mc = _msg_cmp(r.get('evidence')) if rule in ('MS1', 'E4') else ''
        return f"사람 확인 필요 — {_short(ev.split(' — ')[0], 80)}" + (f' · {_mc}' if _mc else '')
    return f"{mean}: {RESULT_TAIL.get(res, res)}"


# P6(2026-11-06 근본 보완): 기계 FAIL 의 재현 여부 — 이전 실행(e2e_results.json.prev)에서도 같은 행이 FAIL 이었으면 '재현 2회', 아니면 '1회 실측' 표식(조치 전 재현 확인 안내)
_PREV_E2E = {}
def _load_prev(mid):
    global _PREV_E2E
    try:
        import json as _j
        pp = P('Doc', 'verify', mid, 'e2e_results.json.prev')
        _PREV_E2E = {e.get('row_id'): e.get('result') for e in _j.load(open(pp, encoding='utf-8'))} if os.path.exists(pp) else {}
    except Exception:
        _PREV_E2E = {}
def _repro_tag(r):
    if r.get('result') != 'FAIL' or not str(r.get('tobe_ref') or '').startswith('E2E'): return ''
    pv = _PREV_E2E.get(r['row_id'])
    if pv == 'FAIL': return ' · 재현 2회(이전 실행도 FAIL)'
    if pv: return f' · 1회 실측(이전 실행 {pv}) — 재현 확인 필요'
    return ' · 1회 실측(이전 기록 없음) — 재현 확인 필요'
# P5: 다른 화면 사용자 판정과 같은 패턴 — 전 화면 제외 여부 결정 요청
def _similar_tag(r):
    n = str(r.get('note') or '')
    if '유사 사용자 판정:' not in n: return ''
    return ' ★ 다른 화면 사용자 판정 동일 패턴(' + n.split('유사 사용자 판정:')[-1].strip()[:90] + ') — 전 화면 제외 여부 결정 요청'
ACTION_SUMMARY = {}

# 2026-11-17 사용자 지시: 첫 줄 = '[위치 / 성격 / 수정 대상] 오류명'('○' 는 11-17 사용자 지시로 뺌). 정리 파일 tag 칸이 있으면 그 값, 없으면 규칙·대상·증거로 정한다.
#   위치 = 조회조건, 그리드 컬럼, 팝업, 버튼, 저장, 메뉴·권한, 화면 공통 · 성격 = 후보값, CASCADE, 기본값, 입력 제어, 로직, 순서, 표시, 성능, DB 객체
#   수정 대상 = FE, DB, FE+DB, 공통 FE, 확인 필요
_NATURE = {'B1': '후보값', 'B2': '후보값', 'B4': '후보값', 'B8': '후보값', 'B3': '순서', 'A6': '순서',
           'C1': 'CASCADE', 'C2': 'CASCADE', 'C3': 'CASCADE', 'C4': 'CASCADE', 'C6': 'CASCADE',
           'D1': '입력 제어', 'D3': '입력 제어', 'D5': '입력 제어', 'E1': '입력 제어', 'E2': '입력 제어', 'E4': '입력 제어', 'E5': '입력 제어', 'E7': '입력 제어',
           'D4': '기본값', 'D6': '기본값', 'G6': '기본값', 'L1': '성능', 'L2': '성능', 'DB-SYN': 'DB 객체'}
_PLACE = {'B': '조회조건', 'F': '저장', 'J': '메뉴·권한', 'M': '팝업'}


def _tag_auto(r):
    rule = r.get('rule_id') or ''; fam = rule[:1]
    nature = _NATURE.get(rule) or ('표시' if fam in ('A', 'H', 'I') else '로직')
    try: et = (json.loads(r.get('condition') or '{}') or {}).get('et', '')
    except Exception: et = ''
    tgt = (r.get('target') or '') + ' ' + (r.get('area') or '')
    if rule in ('G1', 'G2', 'G3', 'G4', 'G6', 'G8', 'G9') or '조회조건' in tgt or et == 'SEARCH': place = '조회조건'
    elif rule in ('G5', 'H6') or '팝업' in tgt or 'popup' in tgt.lower(): place = '팝업'
    elif fam in _PLACE: place = _PLACE[fam]
    elif rule == 'E4': place = '저장'
    elif et == 'COL' or re.search(r'헤더|컬럼|칸', tgt): place = '그리드 컬럼'
    elif et == 'SP': place = '저장'
    elif et in ('BTN', 'BUTTON') or '버튼' in tgt: place = '버튼'
    else: place = '화면 공통'
    ev = (r.get('evidence') or '') + ' ' + (r.get('tobe_ref') or '')
    fl = (r.get('fix_layer') or '').upper()
    fe = bool(re.search(r'\.tsx?\b|\.tsx?:', ev)) or 'FE' in fl
    db = bool(re.search(r'PKG_|ORA-\d|SHEET_COLUMNS|SCM_[A-Z_]+_M\b', ev)) or 'DB' in fl or rule == 'DB-SYN'
    layer = 'FE+DB' if fe and db else 'FE' if fe else 'DB' if db else '확인 필요'
    if 'COMMON:' in (r.get('target') or ''): layer = '공통 FE'
    return f'{place} / {nature} / {layer}'


def _tag(r, s=None):
    t = (s or {}).get('tag') if s else ''
    return (t or '').strip() or _tag_auto(r)



# 2026-11-17 사용자 지시: 조치 필요는 화면 배치 순서(위 → 아래, 왼쪽 → 오른쪽)로 나열한다.
#   구역 = 메뉴·권한 → 조회조건 → 버튼 → 그리드 컬럼(탭 순서 → 컬럼 순서) → 팝업 → 저장 → 화면 공통.
#   조회조건 순서 = combo_runtime.json search 실측 순서(화면 DOM 순) · 탭 순서 = sheet_nav.json · 컬럼 순서 = AS-IS 메타 SHEET_COLUMNS SORT_ORDER_NO.
_ZONE = {'메뉴·권한': 0, '조회조건': 1, '버튼': 2, '그리드 컬럼': 3, '팝업': 4, '저장': 5, '화면 공통': 6}


def _summ(r):
    """정리 파일 행 — 이 행에 제목이 없으면 같은 묶음(group)의 제목 있는 행(대표 행이 PASS 로 빠져도 남은 행이 같은 설명·위치·분류를 쓴다)"""
    s = ACTION_SUMMARY.get(r['row_id'])
    if s and not (s.get('title') or '').strip() and (s.get('group') or '').strip():
        s = next((x for x in ACTION_SUMMARY.values() if (x.get('group') or '').strip() == s['group'].strip() and (x.get('title') or '').strip()), s)
    return s or {}


def _layout(mid):
    lay = {'search': [], 'sheets': [], 'tabs': [], 'cols': {}}
    try: lay['search'] = list((json.load(open(P('Doc', 'verify', mid, 'combo_runtime.json'), encoding='utf-8')).get('search') or {}).keys())
    except Exception: pass
    try:
        sn = json.load(open(P('Doc', 'verify', mid, 'sheet_nav.json'), encoding='utf-8')).get('sheets') or {}
        lay['sheets'] = list(sn.keys())
        for v in sn.values():
            for t in (v.get('tabs') or [])[:1]:
                if t not in lay['tabs']: lay['tabs'].append(t)
    except Exception: pass
    for x in read_csv(P('Doc', 'asisfacts', 'screens', mid, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')):
        try: no = int(float(x.get('SORT_ORDER_NO') or 9999))
        except ValueError: no = 9999
        for k in (x.get('COLUMN_NAME') or '', (x.get('COLUMN_LABEL_NAME') or '').replace('*', '').strip()):
            if k and (k not in lay['cols'] or no < lay['cols'][k]): lay['cols'][k] = no
    return lay


def _screen_key(r, lay):
    s = _summ(r)
    tag = _tag(r, s); place = tag.split('/')[0].split(',')[0].strip()
    # 정리 파일이 있으면 '위치' 칸만 본다(증거 문장의 다른 탭·컬럼 이름이 순서를 흐리지 않게)
    txt = (s.get('where') or '') if (s.get('where') or '').strip() else ' '.join([r.get('target') or '', (r.get('evidence') or '')[:300]])
    if r.get('rule_id') == 'DB-SYN': return (-1, 0, 0, 0)   # 테스트 차단 원인 = 1번(2026-10-29 사용자)
    z = _ZONE.get(place, 6)
    if place == '조회조건':
        idx = [i for i, lb in enumerate(lay['search']) if re.search(r'(?<![A-Za-z])' + re.escape(lb) + r'(?![A-Za-z])', txt)]
        return (z, min(idx) if idx else 99, 0, 0)
    tab = [i for _, i in sorted((txt.find(t), i) for i, t in enumerate(lay['tabs']) if t and t in txt)][:1]   # 위치 칸에 먼저 나온 탭
    sh = [i for i, t in enumerate(lay['sheets']) if t and re.search(r'(?<![A-Z_])' + re.escape(t) + r'(?![A-Z_])', txt)]
    col = [n for k, n in lay['cols'].items() if len(k) > 2 and re.search(r'(?<![A-Za-z_])' + re.escape(k) + r'(?![A-Za-z_])', txt)]
    return (z, min(tab) if tab else 99, min(col) if col else 9999, min(sh) if sh else 99)   # 같은 탭 안에서는 왼쪽 컬럼부터


def _summary_text(r):
    """2026-11-17 사용자 지시(SCP0104): 설명 = ① 오류명(간결) ② 위치(조회조건 항목 / 탭·그리드·컬럼) ③ AS-IS 표기·동작 ④ TO-BE 표기·동작 ⑤ GAP.
    정리 파일(action_summary.csv)에 그 행이 있으면 그 내용, 없으면 원장 값으로 같은 틀을 채운다."""
    s = ACTION_SUMMARY.get(r['row_id'])
    if s and not (s.get('title') or '').strip() and (s.get('group') or '').strip():   # 묶음의 다른 행에 적은 설명을 쓴다
        s = next((x for x in ACTION_SUMMARY.values() if (x.get('group') or '').strip() == s['group'].strip() and (x.get('title') or '').strip()), s)
    same_n = len(r.get('_same') or [])
    tail = (chr(10) + f'같은 원인 {same_n + 1}건 묶음: ' + ', '.join([r['row_id']] + list(r.get('_same') or []))[:300]) if same_n else ''
    if s and (s.get('title') or '').strip():
        tg = _tag(r, s)
        if tg.startswith('저장'):  # 2026-11-18 사용자(SCP0111): 저장 항목 설명은 지금 형식 유지
            lines = ['● [' + tg + '] ' + s['title'].strip().lstrip('○● ').strip(), '위치 : ' + (s.get('where') or '').strip(), 'AS-IS : ' + (s.get('asis') or '').strip(), 'TO-BE : ' + (s.get('tobe') or '').strip(), 'GAP : ' + (s.get('gap') or '').strip()]
            if (s.get('action') or '').strip(): lines.append('조치 : ' + s['action'].strip())
        else:
            # 2026-11-18 사용자 지시(SCP0111 설명 형식): '[분류 / 유형 / 판정] 한 줄 요약' 아래 ' - AS-IS : ' · ' - TO-BE : ' · ' - GAP : '(계정 차이는 GAP 에) — 위치·조치 줄 없음
            # 2026-11-24 개선안(R84): 위치 줄은 두지 않고, 오류명에 위치(where)가 없으면 머리 줄 끝에 '(위치)' 로 붙인다
            ttl = s['title'].strip().lstrip('○● ').strip(); wh = (s.get('where') or '').strip()
            if wh and wh not in ttl: ttl += ' (' + wh + ')'
            lines = ['● [' + tg + '] ' + ttl, ' - AS-IS : ' + (s.get('asis') or '').strip(), ' - TO-BE : ' + (s.get('tobe') or '').strip(), ' - GAP : ' + (s.get('gap') or '').strip()]
        return chr(10).join(lines) + tail
    return ''


_NO_SUMMARY = set()


def _explain(r):
    """2026-11-13 사용자: 설명 = 맨 위에 무엇이 오류인지 정의, 그 아래 AS-IS 는 어떻게·TO-BE 는 어떻게. 조치 필요·판정 필요 행만 새 형식, 실패하면 종전 한 줄"""
    st = _summary_text(r)
    if st: return st
    short = plain(r); repro = _repro_tag(r); sim = _similar_tag(r)
    same = (f" (같은 내용 {len(r['_same']) + 1}건: {', '.join(sorted({(t.split('.')[0] if '.' in t else t) for t in r.get('_same_t', [])} | ({r['target'].split('.')[0]} if '.' in r['target'] else set()))[:6])})" if r.get('_same') else '')
    try:
        if r.get('result') in ('FAIL', '판정필요'):
            # 2026-11-18 사용자 지시(전 화면 · 이후 전체): 저장 항목은 지금 형식 유지, 그 밖은 ' - AS-IS : ' · ' - TO-BE : ' · ' - GAP : ' 틀(plain_detail.build_gap)
            tg = _tag(r)
            t = plain_detail.build(r, short, repro, same, RULE_MEAN.get(r.get('rule_id') or '', ''), keep_old=tg.startswith('저장')) + (chr(10) + '· ' + sim.strip() if sim else '')
            return '● [' + tg + '] ' + t.lstrip('○● ')
    except Exception:
        # 2026-11-25 개선안 20261124014507_SELF_2(R84): 예외 때도 AS-IS · TO-BE · GAP 4줄 틀을 채운다
        if r.get('result') in ('FAIL', '판정필요'):
            try: tg = _tag(r)
            except Exception: tg = ''
            head = ('● [' + tg + '] ') if tg else '● '
            try:
                t = plain_detail.build_gap(r, {}, short) + (chr(10) + '· ' + sim.strip() if sim else '')
                return head + t.lstrip('○● ')
            except Exception:
                _NO_SUMMARY.add(r['row_id'])
                return head + (short or '').lstrip('○● ') + repro + same + chr(10) + ' - AS-IS : 미확인' + chr(10) + ' - TO-BE : 미측정' + chr(10) + ' - GAP : 설명 생성 실패'
    return short + repro + sim + same
def lrow(i, r):
    shown = RESULT_NAME.get(r['result'], r['result']) + (' (AI 판단만)' if r.get('_raw_result') and r['_raw_result'] != r['result'] else '')
    explain = _explain(r)
    by = {'No': i, '검증 ID': r['row_id'], '분류': AXIS_NAME.get(r.get('axis', ''), r.get('axis', '')), '출처': r['source'], '유형': r['family'], '규칙': r['rule_id'], '영역': r['area'], '대상': r['target'],
          '조건': r['condition'], '정답': r['oracle'], '기대(AS-IS·규칙)': r['expected'], 'AS-IS 근거': r['asis_ref'], '판정 방법': r['method'], '결과': shown, 'CheckList Remark': REMARK.get(r['row_id'], ''), '사용자의견': USER_OPINION.get(r['row_id'], ''),
          '설명': explain, '근거 등급': r['_grade'], '증거(실측)': r['evidence'], 'TO-BE 위치': r['tobe_ref'], '결함 원장': r['defect_ref'], '사용자판정': USER_VERDICT.get(r['row_id'], ''),
          '오라클': r.get('oracle_class', ''), '기대 원천': r.get('expect_src', ''), '증거 경로': r.get('evidence_ref', ''), '전제': (r.get('precond') or '')[:300]}
    assert set(by) == set(LH), '열 정의(LH)와 행 값(lrow) 불일치'
    return [by[h] for h in LH]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--scope', choices=['DB_ONLY', 'DB_FE'])
    ap.add_argument('--plan-only', action='store_true', help='설명 정리 필요 목록(no_summary.json)까지만 · xlsx 쓰지 않음(2026-11-20 A6 · run_verify 가 설명 문장 작성 전에 부름)')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    _load_prev(mid)
    try: plain_detail.set_screen(mid)  # 2026-11-13: 설명 열 새 형식(오류 정의 → AS-IS/TO-BE 풀이)
    except Exception: pass
    rows = read_csv(P('Doc', 'verify', mid, 'verify_ledger.csv'))
    if not rows:
        print(f'[ERROR] 원장 없음 — ledger.py·judge.py 먼저 ({mid})')
        return 2
    scope = scope_setting(a.scope)
    name = screen_name(mid)
    load_user_verdicts(mid)
    load_remarks(mid)
    for r in rows:  # 근거 등급 → 문서상 결과(AI 판단만 PASS·NA = 판정필요). 원장 파일은 바꾸지 않는다.
        r['_grade'] = evidence_grade(r)
        eff = effective_result(r)
        if eff != r['result']:
            r['_raw_result'], r['result'] = r['result'], eff
    rules = {r['rule_id']: r for r in read_csv(P('tools', 'Harness', 'verify', 'detect_rules.csv'))}
    # 2026-11-20 사용자 지시 G2(중복 정리 · AI 판단 Doc/verify/<ID>/dedup_screen.csv): CheckList 는 대표 행만. 결과가 대표와 같은 구성원은 '중복 정리' 시트로 옮긴다.
    #   결과가 대표와 다른 구성원(직접 측정 결과 다름)은 본 목록에 그대로 둔다(묶음 판단 오류를 숨기지 않음)
    dup_rows = []
    try:
        import dedup_screen as _dd; _dmap = _dd.load_map(mid)
    except Exception:
        _dmap = {}
    try:   # 2026-11-25 측정 전 중복 정리(dedup_pre.py · dup_groups.csv): 같은 확인 구성원도 대표 1행으로(AI 판단 묶음이 우선)
        import dedup_pre as _dp
        for _k, _v in _dp.load(mid).items():
            _dmap.setdefault(_k, _v)
    except Exception:
        pass
    if _dmap:
        # 2026-11-26 개선안 20261126115652_SELF(R235): 해당없음·미검증(NA·ERROR·빈 값) 행과 사용자판정·사용자의견·Remark 있는 행은 묶지 않는다(dedup_same_measure 와 같은 기준)
        try:
            import dedup_same_measure as _sm0; _skip = set(_sm0.SKIP_RESULTS)
        except Exception:
            _skip = {'NA', '해당없음', 'ERROR', ''}
        _prot0 = set(USER_VERDICT) | set(USER_OPINION) | set(REMARK)
        _by = {r['row_id']: r for r in rows}; _keep = []
        for r in rows:
            _rep = _by.get(_dmap.get(r['row_id'], ''))
            if (_rep and _rep.get('result') == r.get('result') and (r.get('result') or '') not in _skip
                    and r['row_id'] not in _prot0 and _rep['row_id'] not in _prot0):
                dup_rows.append((r, _rep))
            else:
                _keep.append(r)
        rows = _keep
    # 2026-11-25 사용자 '대조표와 CHECKLIST 에 중복된 내용이 많고 같은 결과를 반복': 하위 행 판정을 다시 세는 집계 행(GENERAL '규칙 X 판정 N행 중 …')은 본 목록에서 빼고 '집계' 시트로
    agg_rows = [r for r in rows if r.get('source') == 'GENERAL' and re.match(r'^(\[[^\]]*\]\s*)*규칙 \S+ 판정 \d+행 중', r.get('evidence') or '')]
    if agg_rows:
        _aid = {r['row_id'] for r in agg_rows}; rows = [r for r in rows if r['row_id'] not in _aid]
    # 2026-11-26 사용자 'SCP0005 CheckList 2,000건 넘음, 중복 제거 보완': 같은 측정(규칙·결과·증거 전문·TO-BE 위치 같음)으로 판정된 행 중
    #   대상이 같은 행(팝업 호출 위치·저장 감사 표본 키만 다름)과 요구 행(GENERAL·CONFIRMED·DEFECT)을 대표 1행으로(dedup_same_measure.py) · 사용자판정·의견·Remark 있는 행은 남김
    same_n = 0
    try:
        import dedup_same_measure as _sm
        _prot = frozenset(set(USER_VERDICT) | set(USER_OPINION) | set(REMARK))
        _sg = _sm.groups(rows, _prot)
        if _sg:
            _sid = {a['row_id'] for a, _b in _sg}; dup_rows += _sg; same_n = len(_sg)
            rows = [r for r in rows if r['row_id'] not in _sid]
            print(f'  [중복 정리] 같은 측정 묶음 {same_n}행 → 대표 {len({b["row_id"] for _a, b in _sg})}행(dedup_same_measure)')
    except Exception as _e:
        print(f'  [WARN] 같은 측정 묶음 정리 생략({type(_e).__name__}: {str(_e)[:120]})')

    # 2026-11-20 수정분 재점검: 이번 실행이 부분 실행(run_mode only)이면 이번에 다시 재지 않은 E2E·검사기 행에 '이전 측정 유지(측정 시각)' 를 붙인다(원장은 그대로 · 문서 표시만).
    #   데이터에 기대는 규칙(LAYER_BY_RULE DB_OBJECT)은 '데이터 변경 미확인' 도 붙인다 — TO-BE DB 데이터 변경은 소스 지문에 넣을 수 없음
    keep_n = 0; delta_info = {}
    try:
        _rm = json.load(open(P('Doc', 'verify', mid, 'run_mode.json'), encoding='utf-8'))
        if _rm.get('mode') == 'only':
            _er = json.load(open(P('Doc', 'verify', mid, 'e2e_results.json'), encoding='utf-8'))
            _runs = [str(x.get('run') or '') for x in _er if x.get('run')]; _last = max(_runs) if _runs else ''
            _old = {x['row_id']: str(x.get('run') or '') for x in _er if str(x.get('run') or '') and str(x.get('run')) < _last}
            _st = set(_rm.get('stages') or [])
            def _kept(r):
                if r['row_id'] in _old: return _old[r['row_id']]
                if r['row_id'].startswith('EG-') and 'eg' not in _st: return '직전 팝업·권한 검사'
                if r['row_id'].startswith('ES-') and 'suite' not in _st: return '직전 E2E 4종'
                if r.get('source') == 'ASIS_DIFF' and 'diff' not in _st: return '직전 차등 검증'
                return ''
            _db = {k for k, v in LAYER_BY_RULE.items() if v == 'DB_OBJECT'} if isinstance(LAYER_BY_RULE, dict) else set()
            for r in rows:
                k = _kept(r)
                if not k: continue
                keep_n += 1
                when = (f'{k[:4]}-{k[4:6]}-{k[6:8]} {k[8:10]}:{k[10:12]}' if re.match(r'^\d{14}$', k) else k)
                r['evidence'] = f"[이전 측정 유지 {when}{' · 데이터 변경 미확인' if r.get('rule_id') in _db else ''}] " + (r.get('evidence') or '')
            try:
                _ds = json.load(open(P('Doc', 'verify', mid, 'delta_scope.json'), encoding='utf-8'))
            except (OSError, ValueError):
                _ds = {}
            delta_info = {'rules': len(_rm.get('rules') or []), 'stages': ','.join(sorted(_st)) or '없음', 'why': _ds.get('why', ''), 'last_full': _ds.get('last_full', '')}
    except (OSError, ValueError, KeyError):
        pass

    # ── 정합검증서 ──
    wb = Workbook()
    ws0 = wb.active
    ws0.title = '요약'
    cnt = Counter(r['result'] for r in rows)
    ws0.append([f'{mid} {name} — UI CheckList (AS-IS vs TO-BE)'])
    ws0['A1'].font = Font(bold=True, size=14)
    ws0.append(['정답 기준: O1 AS-IS 동작 · O2 확정 규칙(디자인·공통·고객 확정 요구) · O3 기능 무결성(오류·무반응·허위 성공)'])
    ws0.append(['미검증(NOT_RUN·ERROR)은 PASS 가 아니다 — 미검증 시트에 사유와 함께 남긴다.'])
    if delta_info:
        ws0.append([f"수정분 재점검: 재측정 규칙 {delta_info['rules']}개 · 추가 단계 {delta_info['stages']} · 이전 측정 유지 {keep_n}행 · 마지막 전체기능 재점검 {delta_info['last_full'] or '없음'} · 범위 근거: {delta_info['why'][:200]}"])
    fx = [r for r in rows if r['source'] == 'RULE_SCREEN' and r['rule_id'] == 'DB-SYN' and '시노님 자동 보완' in (r.get('evidence') or '')]
    if fx:
        ws0.append([f"🔧 시노님 자동 보완 — {(fx[0].get('evidence') or '').split('시노님 자동 보완 ', 1)[-1][:380]}"])
    blk = [r for r in rows if r['source'] == 'RULE_SCREEN' and r['rule_id'] == 'DB-SYN' and r['result'] == 'FAIL']
    if blk:
        ws0.append([f"⛔ 차단 1건: {(blk[0].get('evidence') or '')[:400]}"]); ws0.cell(row=ws0.max_row, column=1).font = Font(bold=True, color='C00000')
        ws0.append([f"   이 실행의 미검증 {sum(1 for r in rows if r['result'] in ('ERROR', 'NOT_RUN'))}행과 '[차단 영향]' 표시 행은 위 원인을 해소한 뒤 재실행하면 다시 판정됩니다. 조치 필요 1번이 차단 원인입니다."])
    ws0.append([])
    ws0.append(['축', '전체', 'PASS', 'FAIL', '판정필요', '미검증', '해당없음'])
    for ax in ('1', '2', '3', '4', '5'):
        sub = [r for r in rows if r['axis'] == ax]
        c = Counter(r['result'] for r in sub)
        ws0.append([AXIS_NAME[ax], len(sub), c['PASS'], c['FAIL'], c['판정필요'], c['NOT_RUN'] + c['ERROR'], c['NA']])
    ws0.append(['합계', len(rows), cnt['PASS'], cnt['FAIL'], cnt['판정필요'], cnt['NOT_RUN'] + cnt['ERROR'], cnt['NA']])
    # W8-A(플랜 1-5 · G3): 미검증 사유 4종 + 적용 불가(대상 없음 — 집계 제외) · 조치필요 정밀도(precision.py 직전 판)
    _ur = Counter(unverified_reason(r) for r in rows)
    ws0.append(['미검증 사유', '측정못함', _ur['측정못함'], '상속생략', _ur['상속생략'], '시험검사', _ur['시험검사'], '대상불명', _ur['대상불명'], '승인대기(스냅샷)', _ur['승인대기(스냅샷)'], '적용 불가(제외)', _ur['적용 불가(제외)']])
    try:
        _pr = read_csv(P('Doc', 'verify', mid, 'precision.csv'))
        if _pr:
            _l = _pr[-1]
            ws0.append([f"조치필요 정밀도(직전 판 v{_l.get('version')})", '조치필요', _l.get('action_needed'), '실결함', _l.get('confirmed_defect'), '허위', _l.get('false_positive'), '중복', _l.get('duplicate'), '미검토', _l.get('unreviewed'), '정밀도', _l.get('precision') or '미측정(검토 0)'])
        else:
            ws0.append(['조치필요 정밀도', '미측정(precision.py 이력 없음 — 사용자 판정 뒤 산출)'])
    except Exception:
        ws0.append(['조치필요 정밀도', '미측정'])
    ws0.append([])
    # 근거 등급 × 결과 — PASS 가 무엇으로 확인됐는지(기계·사람 = hard / AI 판단만 = soft, PASS 로 세지 않음)
    ws0.append(['근거 등급(판정 출처)', '전체', 'PASS', 'FAIL', '판정필요', '미검증', '해당없음', '통과 근거 인정'])
    grade_row = ws0.max_row
    for g in GRADES:
        sub = [r for r in rows if r['_grade'] == g]
        if not sub:
            continue
        c = Counter(r['result'] for r in sub)
        ws0.append([g, len(sub), c['PASS'], c['FAIL'], c['판정필요'], c['NOT_RUN'] + c['ERROR'], c['NA'], '인정' if g in GRADE_HARD else '불인정'])
    demoted = sum(1 for r in rows if r.get('_raw_result'))
    ws0.append([f'AI 판단만으로 PASS·해당없음이던 {demoted}건은 판정필요로 셈(원장 값은 보존 — 결정표 by·근거 인용으로 확정)' if demoted else 'AI 판단만으로 통과한 행 없음'])
    ws0.append(['근거 등급: 기계 = E2E·정적·메타·DB 실측 / 기계(상속·집계) = 다른 기계 판정의 상속·집계 / 사람 = CheckList 사용자판정·결정표 by=사람 / AI 작성·인용 확인 = AI 답이지만 인용 원문이 기계로 확인됨(행과 관련 있는지는 사람 확인 권장) / AI 판단만 = 인용 없는 AI 답'])
    for c in ws0[grade_row]:
        c.fill, c.font = HFILL, Font(bold=True)
    ws0.append([])
    ws0.append(['출처', '행 수'])
    for k, v in Counter(r['source'] for r in rows).items():
        ws0.append([k, v])
    ws0.append([])
    dref = sorted({r['defect_ref'] for r in rows if r['defect_ref']})
    dfail = sorted({r['defect_ref'] for r in rows if r['defect_ref'] and r['result'] == 'FAIL'})
    ws0.append(['결함 원장 대상', len(dref), '현재 FAIL(재현)', len(dfail)])
    for row in ws0.iter_rows(min_row=5, max_row=5):
        for c in row:
            c.fill, c.font = HFILL, Font(bold=True)
    for i, w in enumerate([22, 10, 14, 10, 10, 10, 10], 1):
        ws0.column_dimensions[get_column_letter(i)].width = w

    # 한 시트에 전 행(축 1→5 순서) — 축은 '분류' 열
    ordered = [r for ax in ('1', '2', '3', '4', '5') for r in rows if r['axis'] == ax] + [r for r in rows if r['axis'] not in ('1', '2', '3', '4', '5')]
    # 2026-11-26 사용자 '해당없음 849건도 줄일 수 있나요 → 옮겨줘': 해당없음(NA) 행은 '해당없음' 시트로(근거 문장 그대로, 원장은 그대로).
    #   '검증 전체' = 판정이 난 행(PASS·FAIL·판정필요·미검증) · 요약 건수는 종전처럼 해당없음 포함(tools/Docs/screen_status.py 도 두 시트를 합쳐 셈)
    na_rows = [r for r in ordered if r.get('result') == 'NA']
    ordered = [r for r in ordered if r.get('result') != 'NA']
    write_sheet(wb, '검증 전체', LH, [lrow(i, r) for i, r in enumerate(ordered, 1)], LW, result_col=RESULT_COL)
    if na_rows:
        write_sheet(wb, '해당없음', LH, [lrow(i, r) for i, r in enumerate(na_rows, 1)], LW, result_col=RESULT_COL)
        ws0.append([]); ws0.append([f"해당없음 {len(na_rows)}행은 '해당없음' 시트로 옮김(근거 = '증거(실측)' 열) · '검증 전체' {len(ordered)}행 = 판정이 난 행 · 위 집계는 해당없음 포함"])
    # 조치 필요(2026-10-28 사용자: 중복이라 빼는 것만 제외 — 실제 조치가 필요한 항목이면 상속 FAIL 도 조치 필요)
    #   포함: 직접 실측 FAIL · 결함원장(DEFECT)·확정규칙(CONFIRMED)·일반화(GENERAL) 행 중 '대상 직접 일치' 실측을 이어받은 상속 FAIL(그 결함 대상 자체가 조치 대상)
    #   제외(중복): '대상 직접 일치 없음 · 규칙 전반 상속' FAIL(다른 요소의 FAIL 을 빌린 것 — 조치는 원천 실측 행) · 대상·규칙·원천 검증 ID 가 같은 상속 FAIL 의 두 번째 이후(DEFECT·CONFIRMED 쌍 등)
    #              · 대조표 행/진입점 집계 · 선행 미구현 종속(요소 FAIL·미구현 행 1건의 합산 — 2026-10-27). 제외 행도 '검증 전체' 시트에는 남는다
    # 2026-10-28 사용자(v75 의견): 결함일반화·결함원장·확정규칙 행은 같은 규칙의 요소 실측을 빌린 것 — 실제 오류는 요소 행에 있으므로 조치 필요에는 올리지 않는다(검증 전체·결함 원장 대조 시트에는 남음)
    #   같은 규칙·같은 대상·같은 증거(예 C6 To Site→Incoterms 3행, A6 분기 2행)는 1건만 올리고 '동일 n건' 을 적는다
    fails, seen_same = [], {}
    # 2026-10-29 사용자(SCP0020 v5 '중복항목' 11건): 같은 컬럼 규칙이 시트(Plant·Packer·Tact Time·Tact Time Except)마다, 신규행/기존행마다 따로 올라옴
    #   → 중복 키 = (규칙, 시트 접두를 뗀 컬럼, 시트명·행번호·조건을 뗀 증거 핵심). 첫 행만 조치 필요에 올리고 '같은 내용 n건(시트 …)' 로 묶는다
    sheet_names = sorted({(r.get('target') or '').split('.')[0] for r in rows if r['source'] == 'COLUMN' and '.' in (r.get('target') or '')}, key=len, reverse=True)
    def _core_key(r):
        ev = re.sub(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*', '', r.get('evidence') or '')
        ev = re.sub(r'\br\d+\b|\d{4}-\d{2}-\d{2}[ T]?\d{0,2}:?\d{0,2}|신규행|기존행', '', ev)
        for sn in sheet_names:
            if sn: ev = ev.replace(sn + '.', '')
        tg = re.sub(r'\s*\(.*?\)\s*$', '', r['target']).strip()
        for sn in sheet_names:
            if sn and tg.startswith(sn + '.'): tg = tg[len(sn) + 1:]; break
        if r['rule_id'] in ('E1', 'E2', 'E5'):
            # 입력 검증은 @verify(COLUMN)·@trace(TRACE) 두 엔진이 같은 컬럼을 문장만 다르게 적는다('… 입력 'x' → 값 'y' NG' / '… 'x' → 'y' NG')
            #   → 증거 문장 대신 NG 난 시험 항목 집합으로 묶는다(2026-10-29 SCP0096 Working Time Default E1 이 V-/T- 2건으로 올라온 중복)
            ngs = sorted({re.sub(r'\s+', ' ', m.strip()) for m in re.findall(r"(?:^|·|:)\s*([^·:]+?)\s+(?:입력\s+)?'[^']*'\s*→\s*(?:값\s+)?'[^']*'\s+NG", ev)})
            if ngs: return (r['rule_id'], tg.upper(), 'NG:' + '|'.join(ngs))
        if r['rule_id'] == 'B7':
            # 후보 갱신(B7)의 (b-재진입) 캐시 판정은 화면 단위 현상(콤보 공통 캐시) — 조회조건마다 같은 문장이 반복되므로 대상 없이 묶는다(2026-10-29 SCP0020 Div·Plant Site·Operation group·Line 4건)
            core = ev.split('| FAIL:')[-1] if '| FAIL:' in ev else ev
            return (r['rule_id'], '', re.sub(r'\d+건|\s+', ' ', core)[:120])
        if r['rule_id'] == 'K3':
            # 2026-11-16 사용자 지적(SCP0104 v4 조치 필요에 'Hide Column → 컬럼 여전히 표시' 3건 — 화면 행 V-6af7fe19 · 결함 일반화 DM-P26 · DM-P28):
            #   그리드 조작(K3)은 한 번의 실측(copy·ctrl·hdr·hide·f5 …)을 화면 행과 결함 유형 행이 각자 자기 항목만 골라 적는다 → 대상도 증거 앞머리도 달라 위 키로는 안 묶였다.
            #   → 실패한 조작 항목('hide FAIL: …' 의 항목 이름과 증상 앞부분) 집합으로 묶는다(대상 무관 — 화면당 같은 조작 실패는 1건)
            subs = sorted({a.lower() + ':' + re.sub(r'\s+', ' ', b).strip()[:60] for a, b in re.findall(r'(?:^|\|)\s*([A-Za-z0-9]+) FAIL: ([^|]*)', ev)})
            if subs: return ('K3', '', 'SUB:' + '|'.join(subs))
        return (r['rule_id'], tg.upper(), re.sub(r'\s+', ' ', ev)[:120])
    elem_rules ={r['rule_id'] for r in rows if r['result'] == 'FAIL' and r['source'] in ('COLUMN', 'SEARCH', 'ASIS', 'TRACE', 'SP', 'MSG') and not re.match(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*(행 집계|진입점 집계|규칙 \w+ )', r.get('evidence') or '')}
    a5_screen = next((r for r in rows if r['source'] == 'RULE_SCREEN' and r['rule_id'] == 'A5' and r['result'] == 'FAIL' and re.search(r'누락\(|추가\(', r.get('evidence') or '')), None)
    for r in rows:
        ev = r.get('evidence') or ''
        if r['result'] != 'FAIL' or re.match(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*(행 집계|진입점 집계|선행 미구현에 종속|선행 대조표 )', ev):
            continue
        # 결함일반화·결함원장·확정규칙 행 중 '규칙 판정 상속' 행만 제외 — 그 행이 직접 실측(E2E/STATIC/DB)된 FAIL 이면 조치 필요에 올린다
        #   (2026-11-07 SCP0127 L1 64초·K3 F5 FAIL 이 DEFECT 행에만 있고 요소(RULE_SCREEN) 행은 ERROR(근거 불충분)라 조치 필요에서 사라지던 누락 — 사용자 문제 제기 ②)
        if r['source'] in ('DEFECT', 'CONFIRMED', 'GENERAL') and (re.match(r'^(규칙 판정 상속|상속|TO-BE|수동)', r.get('tobe_ref') or '') or re.match(r'^(\[[^\]]*\]\s*)*규칙 \w+ ', ev) or not (r.get('tobe_ref') or '').strip()):
            continue
        if r['source'] == 'RULE_SCREEN' and re.match(r'^(\[[^\]]*\]\s*)*규칙 \w+ 요소 \d+행 집계', ev) and r['rule_id'] in elem_rules:
            continue  # 요소 행이 조치 필요에 있으면 화면 집계 행은 같은 내용의 반복(2026-10-29 A5 '중복항목')
        # A5(그리드 컬럼 구성): 화면 행이 누락/추가 컬럼명을 적는 지금은 화면 행 1건이 정답 — 컬럼별 A5 요소 행은 그 안에 묶는다(2026-10-29 regress 위반 T-6b72d463 '중복항목')
        if r['rule_id'] == 'A5' and r['source'] != 'RULE_SCREEN' and a5_screen is not None:
            a5_screen.setdefault('_same', []).append(r['row_id']); a5_screen.setdefault('_same_t', []).append(r['target']); continue
        k = _core_key(r)
        if k in seen_same:
            seen_same[k].setdefault('_same', []).append(r['row_id']); seen_same[k].setdefault('_same_t', []).append(r['target']); continue
        seen_same[k] = r; fails.append(r)
    # 2026-11-06 T80 사용자 지시(SCP0037 '조치필요 중복제거'): 대상만 다르고 근거가 같은 행(대조표 행마다 같은 E4 근거 11건)과
    #   '… 최종 FAIL: <다른 행 근거>' 처럼 다른 조치 행의 실패를 옮겨 적은 행은 원천 1건으로 묶는다(검증 전체 시트에는 그대로 남음)
    _evn = lambda r: re.sub(r'\s+', ' ', re.sub(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*', '', r.get('evidence') or '')).strip()
    kept, by_ev = [], {}
    for r in fails:
        e = _evn(r); root = None
        m = re.search(r'최종 FAIL: (.{20,})$', e)
        if m:
            tail = m.group(1)[:60]
            root = next((k for k in kept if k is not r and _evn(k).startswith(tail[:40])), None)
        if root is None and len(e) >= 30:
            root = by_ev.get(e[:200])
        if root is not None:
            root.setdefault('_same', []).append(r['row_id']); root.setdefault('_same_t', []).append(r['target']); root['_same'] += r.get('_same', []); root['_same_t'] += r.get('_same_t', [])
            continue
        kept.append(r); by_ev.setdefault(e[:200], r)
    # 원천이 뒤에 나온 경우(옮겨 적은 행이 먼저) — 한 번 더 접는다
    final = []
    for r in kept:
        e = _evn(r); m = re.search(r'최종 FAIL: (.{20,})$', e)
        root = next((k for k in kept if k is not r and m and _evn(k).startswith(m.group(1)[:40])), None) if m else None
        if root is not None:
            root.setdefault('_same', []).append(r['row_id']); root.setdefault('_same_t', []).append(r['target']); root['_same'] += r.get('_same', []); root['_same_t'] += r.get('_same_t', [])
            continue
        final.append(r)
    # 2026-11-17 사용자 지시(SSP0020 v31 조치 필요 3번 = 2번과 동일 항목 '중복 제거'): 근거가 '같은 결함 <행 ID>' 로 다른 조치 행을 가리키면
    #   (V-db5fae91 A5 스냅샷 헤더 'Valid' 잔존 → V-d1f0e5dc H5 Valid→Active) 그 행으로 묶는다. 가리킨 행이 조치 필요에 없으면 그대로 둔다
    _fid = {r['row_id']: r for r in final}
    _folded = []
    for r in final:
        ref_ids = re.findall(r'같은 결함\s*([A-Z]{1,3}-[0-9a-f]{6,})', r.get('evidence') or '')
        root = next((_fid[i] for i in ref_ids if i in _fid and _fid[i] is not r and not re.search(r'같은 결함\s*' + re.escape(r['row_id']), _fid[i].get('evidence') or '')), None)
        if root is not None:
            root.setdefault('_same', []).append(r['row_id']); root.setdefault('_same_t', []).append(r['target']); root['_same'] += r.get('_same', []); root['_same_t'] += r.get('_same_t', [])
            continue
        _folded.append(r)
    final = _folded
    # 2026-11-06 사용자 지시(SCP0084 v3 조치 필요 14·15·16 '상단과 동일항목 중복'): 두 엔진(@verify COLUMN · @trace TRACE)이 같은 컬럼·같은 규칙을
    #   대상 이름만 달리('Long Term Stock.MEMO (Memo)' ↔ 'MEMO') 적은 행, 같은 저장 실측 1회('저장 요청이 서버로 나가지 않음')를 규칙(F1·F2·F4)·대상(화면·저장 SP)별로
    #   따로 적은 행을 원천 1건으로 묶는다(검증 전체 시트에는 그대로 남음).
    def _col_of(r):
        t = re.sub(r'\s*\(.*?\)\s*$', '', r.get('target') or '').strip()
        for sn in sheet_names:
            if sn and t.startswith(sn + '.'): t = t[len(sn) + 1:]; break
        return t.upper() if re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', t) else ''
    _SYMPTOM = [('SAVE_NOT_SENT', re.compile(r'저장 요청\(call-proc\)이 서버로 나가지 않음|저장 요청이 나가지 않아|main/SAVE 호출 0건|SAVE call-proc 없음')),
                ('COND_NOT_FILTERED', re.compile(r'조건 밖 \d+종'))]  # T115(2026-11-06 SCP0131 5·6번): 같은 조회조건의 G8(대소문자)·G9(콤마) '조건 밖' = 필터 미적용 1원인
    _SYM_BY_TARGET = {'COND_NOT_FILTERED'}  # 조건(대상)별로 접는 증상 — 저장 미전송은 화면 1건
    merged, by_col, by_sym = [], {}, {}
    for r in final:
        sym = next((k for k, rx in _SYMPTOM if rx.search(r.get('evidence') or '')), '')
        if sym in _SYM_BY_TARGET: sym = (sym, re.sub(r'\s*\[.*?\]\s*$', '', r.get('target') or '').strip())
        c = _col_of(r)
        root = by_sym.get(sym) if sym else (by_col.get((r['rule_id'], c)) if c else None)
        if root is not None:
            root.setdefault('_same', []).append(r['row_id']); root.setdefault('_same_t', []).append(r['target']); root['_same'] += r.get('_same', []); root['_same_t'] += r.get('_same_t', [])
            continue
        merged.append(r)
        if sym: by_sym[sym] = r
        elif c: by_col[(r['rule_id'], c)] = r
    fails = merged
    # 2026-11-17 사용자 지시(SCP0104 v22 '중복제거'·'설명 간결'): 화면별 정리 파일 Doc/verify/<ID>/action_summary.csv 의 group 이 같은 행은 원인 1건으로 묶는다
    #   (붙여넣기 핸들러 없음 10행 · 저장 ORA-01840 4행처럼 규칙·대상은 달라도 고칠 곳이 하나인 행). 검증 전체 시트에는 그대로 남는다
    global ACTION_SUMMARY
    ACTION_SUMMARY = {x['row_id']: x for x in read_csv(P('Doc', 'verify', mid, 'action_summary.csv')) if (x.get('row_id') or '').strip()}
    _grp, _kept2 = {}, []
    for r in fails:
        g = (ACTION_SUMMARY.get(r['row_id']) or {}).get('group', '').strip()
        root = _grp.get(g) if g else None
        if root is not None:
            root.setdefault('_same', []).append(r['row_id']); root.setdefault('_same_t', []).append(r['target']); root['_same'] += r.get('_same', []); root['_same_t'] += r.get('_same_t', [])
            continue
        if g: _grp[g] = r
        _kept2.append(r)
    fails = _kept2
    _lay = _layout(mid)
    fails.sort(key=lambda r: _screen_key(r, _lay))  # 차단 원인(DB-SYN)이 1번(2026-10-29) · 그 뒤 화면 배치 순서(2026-11-17)
    try:  # 회귀 게이트(regress.py)용 — 조치 필요 행과 묶인 행(folded_into)
        ai = [{'row_id': r['row_id'], 'rule_id': r['rule_id'], 'target': r['target'], 'same': r.get('_same') or []} for r in fails]
        for r in fails:
            for sid_ in (r.get('_same') or []): ai.append({'row_id': sid_, 'rule_id': r['rule_id'], 'target': '', 'folded_into': r['row_id']})
        json.dump(ai, open(P('Doc', 'verify', mid, 'action_items.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    except Exception as _ex:
        print(f'  [WARN] action_items.json 기록 실패: {_ex}')
    write_sheet(wb, '조치 필요', LH, [lrow(i, r) for i, r in enumerate(fails, 1)], LW, result_col=RESULT_COL)
    # 2026-11-18 사용자(중복 제거 · 전 화면): 판정 필요도 정리 파일 group 이 같은 행은 1행으로 묶는다(원본 행은 복사본으로 다뤄 다른 시트에 영향 없음)
    _rv, _rg = [], {}
    for r in [r for r in rows if r['result'] == '판정필요']:
        g = (ACTION_SUMMARY.get(r['row_id']) or {}).get('group', '').strip()
        if g and g in _rg:
            _rg[g].setdefault('_same', []).append(r['row_id']); _rg[g].setdefault('_same_t', []).append(r['target']); continue
        r2 = dict(r); r2['_same'] = list(r.get('_same') or []); r2['_same_t'] = list(r.get('_same_t') or [])
        if g: _rg[g] = r2
        _rv.append(r2)
    write_sheet(wb, '판정 필요', LH, [lrow(i, r) for i, r in enumerate(_rv, 1)], LW, result_col=RESULT_COL)
    # 2026-11-20 구간 B '기준' 시트: 기준 원장(Doc/verify/<ID>/criteria/criteria.csv) 중 사람이 볼 항목 = 판단 대기 · 대상 아님 · TO-BE 룰 결합 · AI 가 요소를 정한 항목.
    #   사용자의견 열에 '대상 아님' · 'TO-BE RULE' · '오류 아님' · '확정' 을 적으면 다음 기준 정리(criteria_build.py)가 그 항목에 고정한다(AI 보다 우선)
    try:
        _cr = [x for x in read_csv(P('Doc', 'verify', mid, 'criteria', 'criteria.csv')) if x.get('status') != '확정' or x.get('by') not in ('코드', '')]
        _ord = {'판단 대기': 0, '대상 아님': 1, '확정': 2}
        _cr.sort(key=lambda x: (_ord.get(x.get('status'), 3), x.get('elem_key', ''), x.get('rule_id', '')))
        CH = ['No', '기준 항목', '상태', '요소', '규칙', '확인', '기대', '근거', 'AS-IS 실측', 'TO-BE 룰', '정한 주체', '원장 행 수', '사용자의견']
        write_sheet(wb, '기준', CH, [[i, x['crit_id'], x.get('status', ''), x.get('elem_key', ''), x.get('rule_id', ''), x.get('check', ''), x.get('expected', ''), x.get('basis', ''),
                                     x.get('src_live', ''), x.get('src_rule', ''), x.get('by', ''), len([y for y in (x.get('rows') or '').split(';') if y]), ''] for i, x in enumerate(_cr, 1)],
                    [6, 16, 10, 22, 8, 40, 40, 50, 30, 14, 10, 8, 30])
    except Exception as _ex:
        print(f'  [WARN] 기준 시트 작성 실패: {_ex}')
    # 2026-11-18 전 화면: 두 시트에 보이는 행 중 정리 파일(action_summary.csv) 문장이 없는 행 = 설명 정리 필요(50_DOC_STYLE.md CheckList 설명 칸 틀)
    _NO_SUMMARY.update(r['row_id'] for r in list(fails) + _rv if not _summary_text(r))
    try:  # 2026-11-19 설명 문장 작성(llm_desc.py)용 — 정리 파일 문장이 없는 행과 그 행에 묶인 행
        json.dump([{'row_id': r['row_id'], 'sheet': ('조치 필요' if r in fails else '판정 필요'), 'same': list(r.get('_same') or [])} for r in list(fails) + _rv if not _summary_text(r)],
                  open(P('Doc', 'verify', mid, 'no_summary.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    except Exception as _ex:
        print(f'  [WARN] no_summary.json 기록 실패: {_ex}')
    if a.plan_only:
        print(f'[설명 정리 필요] {len(_NO_SUMMARY)}건(목록만 · --plan-only · 문서는 설명 문장 작성 뒤 1회 생성)')
        return 0
    base = {(d['src'] + '-' + d['no']): d for d in read_csv(P('Doc', 'verify', 'defects_baseline.csv'))}
    drows = []
    for i, ref in enumerate(dref, 1):
        rs = [r for r in rows if r['defect_ref'] == ref]
        d = base.get(ref, {})
        res = 'FAIL' if any(r['result'] == 'FAIL' for r in rs) else ('판정필요' if any(r['result'] == '판정필요' for r in rs) else ('PASS' if all(r['result'] == 'PASS' for r in rs) else '미검증'))
        # 2026-10-30 출처 열: DM/SCPSSP(단위테스트) · GAP/GAPPI/GAPSELF(갭 분석 종합 — 원장 상태 = 처리 상태) · SSP45(DMF0045 검증내역)
        state = ('미조치' if d.get('open') == 'Y' else '조치완료') if d.get('src') in ('DM', 'SCPSSP') else (d.get('zionex_status') or ('미조치' if d.get('open') == 'Y' else '조치완료'))
        drows.append([i, ref, d.get('src', ''), d.get('ui_name', ''), d.get('div', ''), d.get('test_content', ''), d.get('test_result', ''), state,
                      ';'.join(r['rule_id'] for r in rs), ', '.join(r['row_id'] for r in rs), res, ' | '.join(r['evidence'][:160] for r in rs if r['evidence'])[:900]])
    write_sheet(wb, '결함 원장 대조', ['No', '결함 원장', '출처', 'UI명', 'Div', '테스트 내용', '테스트 결과(사람)', '원장 조치상태', '검출 규칙', '검증 ID', '시스템 결과', '증거'],
                drows, [5, 12, 8, 18, 8, 30, 50, 10, 14, 24, 11, 60], result_col=10)
    # 2026-10-30 설계 결정(GAP) 시트 — 이 화면에 적용 가능한 설계 결정(design_decisions.csv)과 이번 판정에서 실제로 NA 로 바꾼 행 수(judge 가 기록한 design_decisions_applied.csv)
    try:
        dd_all = read_csv(P('tools', 'Harness', 'rules', 'design_decisions.csv'))
        dd_mine = [d for d in dd_all if (d.get('menu_id') or '') == mid or (d.get('scope') or '').upper() == 'ALL']
        applied = read_csv(P('Doc', 'verify', mid, 'design_decisions_applied.csv'))
        napp = Counter(x['dd_id'] for x in applied)
        ddrows = [[i, d['dd_id'], d.get('gap_item', ''), f"{d.get('src', '')}-{d.get('no', '')}", d.get('rule_ids', ''), d.get('target', ''), d.get('target_tokens', ''), d.get('asis', ''), d.get('tobe', ''), d.get('reason', ''),
                   d.get('human_check', ''), napp.get(d['dd_id'], 0), ', '.join(x['row_id'] for x in applied if x['dd_id'] == d['dd_id'])[:300]] for i, d in enumerate(dd_mine, 1)]
        write_sheet(wb, '설계 결정(GAP)', ['No', 'DD', 'GAP 항목', '원천', '검출 규칙', '대상', '대조 토큰', 'AS-IS', 'TO-BE 결정', '근거', '사람 확인', '적용 행 수', '적용 행 ID'],
                    ddrows, [5, 8, 8, 12, 12, 30, 20, 40, 40, 40, 12, 8, 40])
    except Exception as _ex:
        print(f'  [WARN] 설계 결정(GAP) 시트 생략: {_ex}')
    # W8-A(플랜 1-5 · G3): 미검증 = 측정못함(ERROR/NOT_RUN) + 상속생략 + 시험검사 + 대상불명 — 적용 불가(대상 없음) 행은 제외(요약에 건수만)
    unv = [r for r in rows if unverified_reason(r) in ('측정못함', '상속생략', '시험검사', '대상불명', '승인대기(스냅샷)')]
    # 2026-11-18 VM 완료 정의(현재 화면)가 '미검증' 시트 행 수를 사유별로 보여 주도록 기록(Excel 을 열지 않고 읽음 · 실패해도 문서 생성 계속)
    try:
        with open(P('Doc', 'verify', mid, 'checklist_counts.json'), 'w', encoding='utf-8') as f:
            json.dump({'menu_id': mid, 'unverified_sheet': len(unv), 'unverified_by_reason': dict(Counter(unverified_reason(r) for r in unv)),
                       'direct_unmeasured': sum(1 for r in unv if '직접 실측 없음' in ((r.get('tobe_ref') or '') + (r.get('evidence') or '')))},
                      f, ensure_ascii=False, indent=1)
    except Exception as _ex:
        print(f'  [WARN] checklist_counts.json 기록 생략: {_ex}')
    write_sheet(wb, '미검증', LH + ['사유'], [lrow(i, r) + [f"{unverified_reason(r)} · " + (r['evidence'] or ('E2E 미구현 규칙 — 판정기 확장 대상' if 'E2E' in r['method'] else '판정기 미구현'))] for i, r in enumerate(unv, 1)],
                LW + [40], result_col=RESULT_COL)
    if dup_rows:
        write_sheet(wb, '중복 정리', ['대표 행', '대표 대상', '결과', '중복 행', '출처', '규칙', '대상', '조건'],
                    [[rp['row_id'], (rp.get('target') or '')[:120], r.get('result', ''), r['row_id'], r.get('source', ''), r.get('rule_id', ''), (r.get('target') or '')[:160], (r.get('condition') or '')[:160]] for r, rp in sorted(dup_rows, key=lambda x: (x[1]['row_id'], x[0]['row_id']))],
                    [12, 40, 8, 12, 12, 7, 50, 40], result_col=3)
        ws0.append([]); ws0.append([f"중복 정리(측정 전 묶음 Doc/verify/{mid}/dup_groups.csv · AI 판단 dedup_screen.csv · 같은 측정 묶음 dedup_same_measure {same_n}행): 같은 확인으로 묶인 {len(dup_rows)}행은 대표 행 결과와 같아 '중복 정리' 시트로 옮김 · 위 집계는 대표 행 기준"])
    if agg_rows:
        write_sheet(wb, '집계', ['행', '규칙', '대상', '결과', '근거'], [[r['row_id'], r.get('rule_id', ''), (r.get('target') or '')[:120], r.get('result', ''), (r.get('evidence') or '')[:300]] for r in sorted(agg_rows, key=lambda x: (x.get('rule_id', ''), x['row_id']))],
                    [12, 7, 50, 8, 80], result_col=4)
        ws0.append([f"집계 행 {len(agg_rows)}행(규칙별 하위 행 판정을 다시 센 행)은 '집계' 시트로 옮김 · 위 집계에 넣지 않음 · 원장 전체 기준 = 위 집계 + 중복 정리 {len(dup_rows)}행 + 집계 {len(agg_rows)}행"])
    # 2026-11-20 사용자 지시 '사용자판정도 우선 권장안으로 진행, 차후 판정필요 항목으로 필요할 때만 코멘트': decide_apply.py 가 남긴 Doc/verify/<ID>/ai_recommend.csv
    _rec = read_csv(os.path.join(ROOT, 'Doc', 'verify', mid, 'ai_recommend.csv')) if os.path.exists(os.path.join(ROOT, 'Doc', 'verify', mid, 'ai_recommend.csv')) else []
    _rec_ap = [x for x in _rec if x.get('status') == 'applied']; _rec_kp = [x for x in _rec if x.get('status') == 'kept']
    if _rec_ap or _rec_kp:
        _st_ko = {'applied': '권장안 적용', 'kept': '권장안으로 풀 수 없음'}
        write_sheet(wb, '판정필요(권장안 적용)', ['행', '규칙', '대상', '상태', '권장 판정', '신뢰', '이유', '근거', '다른 선택지', '필요한 조치'],
                    [[x.get('row_id', ''), x.get('rule_id', ''), (x.get('target') or '')[:160], _st_ko.get(x.get('status'), ''), x.get('recommend', ''), x.get('confidence', ''), x.get('reason', ''), x.get('evidence_ref', ''), x.get('alternatives', ''), x.get('action', '')] for x in _rec_ap + _rec_kp],
                    [12, 7, 44, 14, 10, 7, 60, 40, 34, 44])
        ws0.append([]); ws0.append([f"권장안 적용(Doc/verify/{mid}/ai_recommend.csv): 사용자 판정 대상 {len(_rec_ap)}행은 AI 권장안으로 '판정필요' 처리 · 다르게 판정할 행만 사용자의견 칸에 적음 · 권장안으로 풀 수 없는 행 {len(_rec_kp)}(사유와 필요한 조치는 '판정필요(권장안 적용)' 시트)"])
    write_sheet(wb, '검출 규칙', ['규칙', '유형', '명칭', '정답', '방법', '기대 원천', '판정 방법'],
                [[k, v['family'], v['name'], v['oracle'], v['method'], v['expected_source'], v['how']] for k, v in rules.items()], [7, 6, 30, 8, 12, 40, 60])
    p1, n1 = next_path(mid, name, 'CheckList')
    try:  # 2026-11-13 문장 규칙 4·7 — 저장 직전 기호 정리(줄표·장식 기호·가운뎃점 나열) + '설명' 칸 개조식. 사용자 기입 칸은 그대로
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'tools', 'Docs')); import doc_style; doc_style.before_save(wb, gaejo=doc_style.CHECKLIST_GAEJO, free=True)
    except Exception as _e: print('[문장 규칙] ERROR 저장 전 정리 못함:', _e)
    wb.save(p1)
    try:  # 2026-11-13 문장 규칙(수식어·아는 주어·번역투) 검사 — 보고만 하고 문서 생성은 막지 않는다(tools/Docs/doc_style.py)
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'tools', 'Docs')); import doc_style; doc_style.after_save(p1)
    except Exception as _e: print('[문장 규칙] ERROR 검사 못함:', _e)
    archive_after_save(p1, mid, name, 'CheckList')
    # 2026-11-16 사용자: CheckList 생성 후 Doc/UI_TEST(SCP&SSP) 에 테스트 Excel 도 생성 — '조치 필요' 시트 기준(make_ui_test_sheet.py)
    #   사람이 쓰는 파일이라 덮어쓰지 않고 검증 ID 가 없는 행만 덧붙인다. 실패해도 CheckList 생성 결과(rc)는 바꾸지 않는다.
    ui_test_msg = ''
    try:
        import make_ui_test_sheet
        _rc_ut, ui_test_msg = make_ui_test_sheet.build(mid, p1)
    except Exception as _e:
        ui_test_msg = f'UI 테스트 Sheet: ERROR 생성 못함 — {_e}'

    # ── 보완대상목록 ──
    targets = [r for r in rows if r['result'] in ('FAIL', '판정필요')]
    fail_ids = {r['row_id'] for r in fails}
    # 2026-11-08 (c) 보정 레시피 — tools/Harness/rules/fix_recipes.csv(rule_id × layer): 변경 요지·대상 객체 패턴·검증 명령(부분 재판정 --only)을 규칙 단위로 채운다. 레시피 없는 규칙은 종전처럼 빈 칸(가이드)
    try:
        _rc = read_csv(P('tools', 'Harness', 'rules', 'fix_recipes.csv'))
    except Exception:
        _rc = []
    def recipe_of(rule_id, layer):
        for key in ((rule_id, layer), (rule_id, '*')):
            for x in _rc:
                if (x.get('rule_id'), x.get('layer') or '*') == key:
                    return x
        return None
    fx = []
    for i, r in enumerate(targets, 1):
        layer, why = decide_layer(r)
        rcp = recipe_of(r['rule_id'], layer)
        fmt = lambda s: (s or '').replace('{mid}', mid).replace('{row_id}', r['row_id']).replace('{target}', r['target'])
        fx.append({'fix_id': f'FX-{mid}-{i:03d}', 'row_id': r['row_id'], 'defect_ref': r['defect_ref'], 'family': r['family'], 'rule_id': r['rule_id'],
                   'axis': AXIS_NAME.get(r['axis'], r['axis']), 'target': r['target'], 'symptom': r['evidence'], 'expected': f"[{r['oracle']}] {r['expected']}",
                   'asis_ref': r['asis_ref'], 'layer': layer, 'layer_name': LAYER_NAME[layer], 'layer_reason': why,
                   'object': (r['tobe_ref'] + (f" · 레시피 대상: {fmt(rcp['object_pattern'])}" if rcp and rcp.get('object_pattern') else '')),
                   'change': (f"[레시피 {rcp['rule_id']}/{rcp['layer']} · 자동 {rcp.get('auto_apply') or 'N'} · 출처 {rcp.get('source') or ''}] {fmt(rcp['change_template'])}" if rcp else ''),
                   'verify': (fmt(rcp['verify_cmd']) if rcp and rcp.get('verify_cmd') else f"python tools/Harness/verify/run_verify.py {mid} --only {r['rule_id']}  (부분 재판정 · 해당 행 {r['row_id']})"),
                   'apply': apply_status(layer, scope),
                   'status': '대기', 'scope_at': scope, 'grade': r['_grade'], 'close_evidence': close_evidence(r, layer),
                   # 정합검증서 '조치 필요' 시트와 같은 행 = 보완 메뉴(🛠️·🧯·🚒·🩹·🔗) 일괄 보완 대상(2026-10-28 사용자)
                   'action_needed': 'Y' if r['row_id'] in fail_ids else 'N'})
    FH = ['No', '보완 ID', '검증 ID', '결함 원장', '유형', '규칙', '축', '대상', '현상(실측)', '기대(정답·근거)', 'AS-IS 근거', '보완 계층', '계층 판단 근거',
          '대상 객체(TO-BE)', '변경 요지(보완 시 기입)', '검증 방법', f'적용 여부(설정 {scope})', '상태', '현재 판정 근거 등급', '종결 근거(해결로 인정하는 조건)']
    FW = [5, 15, 12, 12, 6, 6, 12, 28, 50, 45, 38, 12, 30, 24, 30, 30, 16, 8, 14, 50]
    to_row = lambda i, f: [i, f['fix_id'], f['row_id'], f['defect_ref'], f['family'], f['rule_id'], f['axis'], f['target'], f['symptom'], f['expected'], f['asis_ref'],
                           f['layer_name'], f['layer_reason'], f['object'], f['change'], f['verify'], f['apply'], f['status'], f['grade'], f['close_evidence']]
    wb2 = Workbook()
    s0 = wb2.active
    s0.title = '요약'
    s0.append([f'{mid} {name} — ActionItemList (보완 적용 전 확인용)'])
    s0['A1'].font = Font(bold=True, size=14)
    # 2026-11-08: 실행 모드 — 부분 재판정(--only)·E2E 생략 판은 그 사실을 요약에 적는다(재실행 규칙 외 행은 직전 실행 결과 그대로)
    try:
        _rm = json.load(open(P('Doc', 'verify', mid, 'run_mode.json'), encoding='utf-8'))
        if _rm.get('mode') == 'only':
            s0.append([f"실행 모드: 부분 재판정 --only {','.join(_rm.get('rules') or [])} ({_rm.get('at')}) — 그 규칙의 E2E 테스트만 재실행 · 다른 행의 E2E 결과는 직전 실행 것"])
        elif _rm.get('mode') == 'skip-e2e':
            s0.append([f"실행 모드: E2E 생략 재판정 ({_rm.get('at')}) — E2E 행은 직전 실행 결과"])
    except (OSError, ValueError):
        pass
    s0.append([f'작업 모드 repairScope = {scope}  (tools/Harness/harness.json · Vibe_Manager 환경설정 🧭 작업 모드에서 변경)'])
    s0.append(['DB_ONLY(DB MODE): DB 객체·메타만 적용, 화면 FE 는 가이드 / DB_FE(UI/DB MODE): 화면 FE 까지 적용 / 공통 컴포넌트는 항상 가이드만 / 검사 항목·판정은 모드와 무관'])
    s0.append(['종결 근거: 보완 후 해결로 인정하는 조건은 각 행의 "종결 근거" 열 — 기계 재판정(E2E·정적·메타·DB) 또는 사람 판정만 인정, 보완 세션의 자기 보고는 인정하지 않음'])
    s0.append([])
    s0.append(['보완 계층', '건수', '적용 예정', '범위 밖(가이드)', '사람판정'])
    for lay in ('DB_META', 'DB_OBJECT', 'FE', 'COMMON', 'HUMAN'):
        sub = [f for f in fx if f['layer'] == lay]
        s0.append([LAYER_NAME[lay], len(sub), sum(f['apply'] == '적용 예정' for f in sub), sum(f['apply'].startswith('범위 밖') for f in sub), sum(f['apply'] == '사람판정 대기' for f in sub)])
    s0.append(['합계', len(fx)])
    s0.append([])
    s0.append(['유형', '건수'])
    for k, v in sorted(Counter(f['family'] for f in fx).items()):
        s0.append([k, v])
    for row in s0.iter_rows(min_row=5, max_row=5):
        for c in row:
            c.fill, c.font = HFILL, Font(bold=True)
    for i, w in enumerate([20, 8, 12, 16, 10], 1):
        s0.column_dimensions[get_column_letter(i)].width = w
    write_sheet(wb2, '보완 대상 전체', FH, [to_row(i, f) for i, f in enumerate(fx, 1)], FW)
    write_sheet(wb2, 'DB 적용분', FH, [to_row(i, f) for i, f in enumerate([f for f in fx if f['layer'] in ('DB_META', 'DB_OBJECT')], 1)], FW)
    write_sheet(wb2, 'FE 적용분', FH, [to_row(i, f) for i, f in enumerate([f for f in fx if f['layer'] == 'FE'], 1)], FW)
    write_sheet(wb2, '공통 컴포넌트 가이드', FH, [to_row(i, f) for i, f in enumerate([f for f in fx if f['layer'] == 'COMMON'], 1)], FW)
    write_sheet(wb2, '사람판정', FH, [to_row(i, f) for i, f in enumerate([f for f in fx if f['layer'] == 'HUMAN'], 1)], FW)
    p2, n2 = next_path(mid, name, 'ActionItemList')
    try:  # 2026-11-13 문장 규칙 4·7 — 저장 직전 기호 정리(줄표·장식 기호·가운뎃점 나열) + '설명' 칸 개조식. 사용자 기입 칸은 그대로
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'tools', 'Docs')); import doc_style; doc_style.before_save(wb2, gaejo=doc_style.CHECKLIST_GAEJO, free=True)
    except Exception as _e: print('[문장 규칙] ERROR 저장 전 정리 못함:', _e)
    wb2.save(p2)
    try:  # 2026-11-13 문장 규칙(수식어·아는 주어·번역투) 검사 — 보고만 하고 문서 생성은 막지 않는다(tools/Docs/doc_style.py)
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'tools', 'Docs')); import doc_style; doc_style.after_save(p2)
    except Exception as _e: print('[문장 규칙] ERROR 검사 못함:', _e)
    archive_after_save(p2, mid, name, 'ActionItemList')
    fl = P('Doc', 'verify', mid, 'fixlist.csv')
    with open(fl, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(fx[0].keys()) if fx else ['fix_id'])
        w.writeheader()
        w.writerows(fx)
    print(f'CheckList v{n1}: {p1}')
    print(f'  결과 ' + ' · '.join(f'{k} {v}' for k, v in sorted(cnt.items())) + f' · 결함 원장 {len(dref)}건 중 FAIL {len(dfail)}')
    print(f'ActionItemList v{n2}: {p2} (설정 {scope})')
    if ui_test_msg:
        print(ui_test_msg)
    print('  ' + ' · '.join(f"{LAYER_NAME[k]} {v}" for k, v in Counter(f['layer'] for f in fx).items()) + f' · 기계용 {fl}')
    # 2026-11-18 사용자 지시(전 화면): 조치 필요·판정 필요 설명은 세션이 Doc/verify/<ID>/action_summary.csv 에 쓴 문장으로 나와야 한다
    print(f'[설명 정리 필요] {len(_NO_SUMMARY)}건' + (f" — Doc/verify/{mid}/action_summary.csv 에 작성 후 run_verify.py {mid} --resume-docs (틀: tools/VibeManager/rules/50_DOC_STYLE.md 'CheckList 설명 칸 틀') · " + ', '.join(sorted(_NO_SUMMARY)[:40]) if _NO_SUMMARY else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
