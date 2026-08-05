# -*- coding: utf-8 -*-
"""DMF0068 Demand Manager — UI분석서 10시트(hook #105 §1-C) + 화면설계서 8시트(§1-A) 생성
   원천: AS-IS 정본 전수 Read(2026-07-29) + 사내 Oracle 실측 + AS-IS MSSQL SP 대조
   서식: §1-E 가로 머지 / EVENT §1-D 선행 MD 전문 승계"""
import re as _re
import pathlib
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from openpyxl.drawing.image import Image as XImage

ROOT = pathlib.Path(r"C:\Projects\NSCM")
ANA = ROOT / "Doc" / "화면분석서"
DES = ROOT / "Doc" / "화면설계서"
CAP = ROOT / "Doc" / "_figma" / "CAP_SVG" / "DMF0068.png"
MD_EVENT = ANA / "DMF0068_DemandManager_주요이벤트_상세분석.md"
MD_MATRIX = ANA / "DMF0068_DemandManager_제약매트릭스_상세.md"

TITLE_F = Font(size=14, bold=True, color="1F4E79")
SEC_FILL = PatternFill("solid", fgColor="1F4E79")
SEC_F = Font(bold=True, color="FFFFFF", size=11)
HDR_FILL = PatternFill("solid", fgColor="4472A8")
HDR_F = Font(bold=True, color="FFFFFF")
WRAP = Alignment(wrap_text=True, vertical="top")
THIN = Border(*[Side(style="thin", color="B0B0B0")] * 4)


class SB:
    def __init__(self, ws, widths):
        self.ws, self.r, self.n = ws, 0, len(widths)
        for i, w in enumerate(widths, 1):
            ws.column_dimensions[get_column_letter(i)].width = w

    def title(self, t):
        self.r += 1
        self.ws.cell(self.r, 1, t).font = TITLE_F
        self.r += 1

    def sec(self, t):
        self.r += 1
        for i in range(1, self.n + 1):
            self.ws.cell(self.r, i).fill = SEC_FILL
        c = self.ws.cell(self.r, 1, t)
        c.font = SEC_F
        self.ws.merge_cells(start_row=self.r, start_column=1, end_row=self.r, end_column=self.n)
        c.alignment = Alignment(horizontal="left", vertical="center")

    def hdr(self, cols):
        self.r += 1
        for i, v in enumerate(cols, 1):
            c = self.ws.cell(self.r, i, v)
            c.fill, c.font = HDR_FILL, HDR_F
            c.alignment = Alignment(vertical="center", wrap_text=True)
            c.border = THIN

    def row(self, cols):
        """값이 있는 마지막 열 이후가 전부 비면 그 열부터 끝까지 가로 머지 + 좌측 정렬(§1-E)."""
        self.r += 1
        vals = list(cols) + [None] * (self.n - len(cols))
        idx = [i for i, v in enumerate(vals) if v is not None and str(v).strip()]
        for i, v in enumerate(vals, 1):
            c = self.ws.cell(self.r, i, v)
            c.alignment = WRAP
            c.border = THIN
        if idx and idx[-1] < self.n - 1:
            self._merge_left(self.r, idx[-1] + 1)

    def text(self, t):
        self.r += 1
        self.ws.cell(self.r, 1, t).alignment = WRAP
        self._merge_left(self.r, 1)

    def _merge_left(self, r, start_col=1):
        if self.n < 2 or start_col >= self.n:
            return
        self.ws.merge_cells(start_row=r, start_column=start_col, end_row=r, end_column=self.n)
        self.ws.cell(r, start_col).alignment = Alignment(horizontal="left", vertical="top", wrap_text=True)

    def gap(self):
        self.r += 1


# ── 선행 MD → 문서 서술체 (라인번호·백틱·굵게 표기만 제거, 내용 보존) ──
_LINE_REF = _re.compile(r"\s*\((?:정본\s*)?L\d[\d,\s~\-–L]*\)")
_LINE_REF2 = _re.compile(r"\s*[—-]\s*L\d[\d,\s~\-–L]*(?=[\s,)]|$)")
_BACKTICK = _re.compile(r"`([^`]*)`")
_BOLD = _re.compile(r"\*\*([^*]*)\*\*")
_LINE_TOKEN = _re.compile(r"(?:정본\s*)?L\d+(?:\s*[~\-–]\s*L?\d+)?")


def clean(text: str) -> str:
    t = _BACKTICK.sub(r"\1", text)
    t = _BOLD.sub(r"\1", t)
    t = _LINE_REF.sub("", t)
    t = _LINE_REF2.sub("", t)
    t = _LINE_TOKEN.sub("", t)
    t = _re.sub(r"[,\s]*\)", ")", t)
    t = _re.sub(r"\(\s*[,;]\s*", "(", t)
    t = _re.sub(r"\(\s*\)", "", t)
    t = _re.sub(r"\s+([,.])", r"\1", t)
    t = _re.sub(r"\s{2,}", " ", t)
    return t.strip(" ,;—-")


def md_detail_rows(md_path):
    """MD 전문을 (구분, 항목, 내용) 행으로 변환 — 무축약 승계(§1-D)."""
    rows, cur_h2, cur_h3, in_code = [], "", "", False
    for raw in md_path.read_text(encoding="utf-8").splitlines():
        s = raw.rstrip().strip()
        if s.startswith("```"):
            in_code = not in_code
            continue
        if not s or s.startswith("---") or s.startswith("# "):
            continue
        if s.startswith("## "):
            cur_h2, cur_h3 = clean(s[3:]), ""
            rows.append(["■ 이벤트", cur_h2, ""])
            continue
        if s.startswith("### "):
            cur_h3 = clean(s[4:])
            rows.append(["· 단계", cur_h3, ""])
            continue
        if s.startswith("#### "):
            cur_h3 = clean(s[5:])
            rows.append(["· 단계", cur_h3, ""])
            continue
        if s.startswith("|") and s.endswith("|"):
            cells = [clean(c) for c in s.strip("|").split("|")]
            if all(_re.fullmatch(r":?-{2,}:?", c or "") for c in cells if c is not None):
                continue
            rows.append(["  표", cells[0] if cells else "", " · ".join(cells[1:])])
            continue
        body = clean(s.lstrip("-*>").strip() if s.startswith(("- ", "* ", "> ")) else s)
        if not body:
            continue
        rows.append(["  코드/식별자" if in_code else "  내용", cur_h3 or cur_h2, body])
    return rows


# ══════════════════════════ 공통 데이터 (실측) ══════════════════════════
FLOW = [
    ("①", "기준정보 등록", "수요예측 입력에 앞서 필요한 마스터(고객/모델/판가/프로젝트)를 준비하는 단계입니다.",
     "Sales Price: DMF0020 / DMF0082 · PROJECT 등록: PR_SCM_MST_PROJECT", "", ""),
    ("②", "수요예측 입력", "사업부별 시장예측 수량을 입력·저장하는 단계입니다.",
     "MKT FCST: DMF0003 · FcstPrice: DMF0082", "", ""),
    ("③", "판매계획", "판매계획을 만들고 리포트로 확인하는 단계입니다. 리포트는 버전 선택 조회입니다.",
     "Sales Plan: DMF0021 · Sales Report: DMF0044 · ETC: DMF0049", "", ""),
    ("④", "Cutoff (버전 확정)", "계획 버전을 확정하는 단계입니다. 본 화면은 확정된 버전(ORI_CUTOFF_VERSION_NO)을 원천으로 삼습니다.",
     "PR_DM_PLN_*_CUTOFF 계열 · 버전 팝업 DMF0068_VersionPopup", "본 화면은 버전을 만들지 않고 선택만 합니다.", ""),
    ("⑤", "사업계획 / 수주관리", "확정된 계획을 사업계획으로 옮기고, 소형(40) 사업부의 수주 품의/현재 수량을 프로젝트·기간 단위로 관리하는 단계입니다.",
     "★ Demand Manager: DMF0068 (본 화면) · Biz Plan: DMF0042", "수주 기간(YYYYMM_FROM~TO)별 품의/현재 수량을 등록하고, 그 기간에 해당하는 계획·실적을 월별로 대사합니다.", "★ 본 화면"),
    ("⑥", "배치 / 정리", "주간 롤링·데이터 정리 배치 단계입니다.",
     "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 계열", "", ""),
]

FLOW_POS = ("본 화면은 ⑤단계에서 사용됩니다. 앞 단계(④ Cutoff)에서 확정된 버전을 선택해 그 버전이 가리키는 원본 컷오프 버전"
            "(ORI_CUTOFF_VERSION_NO)의 계획·실적을 읽어오고, 사용자가 입력한 수주 기간·수주(품의)·수주(현재) 를 "
            "DM_PLN_ORDER_MGT 원장에 저장합니다. 저장된 수주 정보는 소형(40) 사업부의 수주 대비 계획/실적 잔고 판단 근거가 됩니다.")

PKG_SP = [
    ("메인 조회", "PKG_DMF0068.P_DMF0068_GET_ORDERLIST",
     "선택한 버전과 조회 기간으로 프로젝트별 수주 정보와 월별 계획·실적을 동적 PIVOT 으로 돌려줍니다. 버전 접두사가 R_S 이면 Sales Plan 계열, 그 외에는 Biz Plan 계열 원천을 사용합니다.",
     "미등록 (API_M 0행)", "PKG 멤버", "커서 3개(O_RC1=데이터 / O_RC2=조립된 SQL 텍스트(진단용) / O_RESULT_CURSOR=결과코드)"),
    ("프로젝트 콤보", "PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT",
     "행 추가 시 Project 셀에 넣을 프로젝트 목록을 돌려줍니다. 룩업 유형 PROJECT_MODEL_MAPPING 의 SEGMENT1 을 코드·명칭으로 함께 반환합니다.",
     "미등록", "PKG 멤버", "AS-IS 는 버전이 바뀐 경우에만 재호출합니다"),
    ("버전 팝업", "PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP",
     "사업부·기간·유형·설명 조건으로 버전 목록을 돌려줍니다. 삭제(SEND_YN='D')와 이동(ATTRIBUTE1='MOVE') 버전은 제외합니다.",
     "미등록", "PKG 멤버", "편집권한 뷰와 INNER JOIN"),
    ("저장", "PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST",
     "화면에서 수집한 행들을 기간 중첩 검사 후 원장에 MERGE 합니다. 기간이 겹치면 저장하지 않고 중복 코드를 돌려줍니다. 짝이 되는 Measure 행의 기간도 함께 맞춰줍니다.",
     "미등록", "PKG 멤버", "⛔ 입력이 컬렉션 타입이라 현재 배선 불가 — CLOB(JSON) 래퍼 신설 필요"),
    ("삭제", "PKG_DMF0068.P_DMF0068_DEL_ORDERLIST",
     "선택한 행이 속한 Measure 그룹(ATTRIBUTE2) 전체를 원장에서 지웁니다. 즉 1행을 지우면 짝 행도 함께 지워집니다.",
     "미등록", "PKG 멤버", "⛔ 동일 — 래퍼 필요"),
    ("예외 로그", "F_COLLECTION_TO_JSON / PR_SCM_SYS_LOG_BATCH",
     "예외 발생 시 입력 컬렉션을 JSON 문자열로 바꿔 표준 로그에 남깁니다.", "(내부)", "함수 / 프로시저", ""),
    ("공통 룩업", "SCM0001_GET_LOOKUP_VALUES", "버전 팝업의 Type 콤보(MDF_TYPE)를 채웁니다.", "(공용)", "공용", ""),
]

TABLES = [
    ("원장(저장 대상)", "DM_PLN_ORDER_MGT",
     "소형 수주관리 원장입니다. 프로젝트·수주기간·Measure 단위로 수주(품의)/수주(현재) 수량을 보관하며 조회·저장·삭제의 단일 대상입니다. ATTRIBUTE1 은 행 자신의 키, ATTRIBUTE2 는 Measure 짝을 묶는 그룹 키, ATTRIBUTE3/4 는 기간 변경 전 값을 잠시 보관하는 자리입니다.",
     "읽기 + 쓰기"),
    ("버전", "DM_MDF_VERSION",
     "버전 목록과 원본 컷오프 버전(ORI_CUTOFF_VERSION_NO)의 원천입니다. 조회 시작 시 선택 버전으로부터 원본 버전을 찾아 계획·실적 조회에 사용합니다.", "읽기"),
    ("계획 — Sales Plan 계열", "DM_PLN_SALES_PLAN_C",
     "버전 접두사가 R_S 인 경우의 계획 수량 원천입니다.", "읽기"),
    ("계획 — Biz Plan 계열", "DM_PLN_BP_FCST_C",
     "버전 접두사가 R_S 가 아닌 경우의 계획 수량 원천입니다.", "읽기"),
    ("실적", "DM_PLN_SALES_PLAN_RESULT", "두 계열 공통 실적 수량 원천입니다.", "읽기"),
    ("마스터", "DM_MST_ITEM_SINGLE_V · SCM_MST_SITE_ITEM",
     "아이템 정보와 프로젝트 정보(PROJECT_INFO)·Cell/Pack Count 의 원천입니다. 수량에 Cell 수를 곱해 QTY(Cell) 을 만듭니다.", "읽기"),
    ("달력", "SCM_SYS_CALENDAR_M", "조회 기간의 월 목록을 뽑아 월별 PIVOT 컬럼을 만듭니다.", "읽기"),
    ("메타 — UI Category Setup", "SCM_MST_SHEET_COLUMNS (159행) · SCM_MST_SHEET_MEASURE (0행)",
     "시트 ContributeSalesList 의 컬럼 메타입니다. 고정 16개(가시 15 + 숨김 Project 1) 와 월 컬럼 M1~M143 로 구성됩니다. Measure 메타는 아직 0행입니다.", "읽기 (런타임 동적)"),
    ("메타 — Message", "SCM_ADM_MSG_M",
     "화면 메시지 원장입니다. AS-IS 13종 중 6종은 그대로 재사용 가능하고 5종은 신규 채번, 3종은 같은 번호가 다른 문구로 이미 쓰이고 있어 대체가 필요합니다.", "읽기"),
    ("메타 — 메뉴/버튼/배선", "SCM_ADM_MNU_M · SCM_ADM_MNU_BTN_MPG_M(0행) · SCM_ADM_API_M(0행) · SCM_ADM_PROC_M(0행)",
     "메뉴는 등록돼 있으나 주소가 임시(dmf0068)이며, 버튼·API·프로시저 배선은 전부 0행입니다. 구현 시 등록해야 합니다.", "읽기 (런타임 동적)"),
    ("메타 — 콤보/룩업", "SCM_ADM_LOOKUP_MASTER_DETAIL",
     "프로젝트 콤보(PROJECT_MODEL_MAPPING)와 버전 팝업 Type 콤보(MDF_TYPE)의 원천입니다.", "읽기"),
    ("메타 — 권한", "SCM_ADM_USER_GR_MNU_MPG_M (3그룹) · SCM_ADM_USER_GR_MNU_BTN_MPG_M (0행) · SCM_ADM_USER_MNU_EDIT_AUTH_V",
     "메뉴 권한은 ADMIN / DM ADMIN / DM Viewer 3그룹이 등록돼 있고 버튼 권한은 0행입니다. 편집 가능 여부는 편집권한 뷰로 판정하며, 조회 SQL 이 이 뷰와 INNER JOIN 하므로 뷰에 행이 없으면 조회 결과가 비게 됩니다.", "읽기 (런타임 동적)"),
    ("작업(GTT)", "GT_DM68_ORD_ITEM_SINGLE_V · GT_DM68_ORD_CELL_PACK_COUNT · GT_DM68_ORD_PJTIFO · GT_DM68_ORD_SRESULT_SPLAN · GT_DM68_ORD_BRESULT_BPLAN",
     "조회 파이프라인이 쓰는 세션 임시 테이블 5종입니다. 조회 시작 시 비우고 단계별로 채운 뒤 마지막에 PIVOT 원천으로 사용합니다.", "세션 임시"),
]

MEASURES = [
    ("MEA_1 (표시명 QTY(Cell))", "40", "세트의 첫째 행. 저장 시에는 항상 MEA_1 로 기록되며, 조회 시 계열에 따라 RTF_SYS_RP(Sales Plan) 또는 Business_Plan(Biz Plan) 으로 해석됩니다."),
    ("SalesAmt_KRW (표시명 Sales Amt.(KRW))", "40", "세트의 둘째 행. 금액 축입니다."),
    ("저장 테이블", "-", "DM_PLN_ORDER_MGT — 두 Measure 가 같은 그룹 키(ATTRIBUTE2)로 묶여 항상 쌍으로 저장·삭제됩니다."),
    ("SHEET_MEASURE", "-", "현재 0행입니다. AS-IS 는 Measure 2종을 소스에 직접 넣어 쓰므로, 메타 등록 여부는 구현 시 결정 대상입니다."),
]

SEARCH = [
    ("Version", "필수", "조회할 버전입니다. 직접 입력하지 않고 옆의 버전 찾기 버튼으로 팝업에서 고릅니다. 비어 있으면 조회를 막습니다.",
     "버전 팝업(DMF0068_VersionPopup)", "편집 모드에서는 잠깁니다."),
    ("버전 찾기 버튼", "-", "버전 팝업을 엽니다. 사업부는 40 으로 고정하고 기간은 오늘 기준 앞뒤 3개월로 열립니다.",
     "P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP", "편집 모드에서는 잠깁니다."),
    ("Period", "필수", "조회할 월 구간입니다. 기본값은 전년 1월부터 익년 12월까지(36개월)이며, 이 구간이 그리드의 월 컬럼 개수와 헤더를 결정합니다.",
     "-", "시작월이 종료월보다 뒤면 조회를 막습니다. 편집 모드에서는 잠깁니다."),
]

BUTTONS = [
    ("SEARCH (F5)", "공통", "조회합니다. 조회 전에 사업부·권한·버전·기간을 차례로 검사하고, 통과하면 시트를 다시 만들고 월 컬럼을 기간에 맞춰 표시합니다. 조회 결과는 전부 읽기 전용입니다."),
    ("INSERT (F8)", "공통", "행을 추가합니다. 언제나 두 행이 한 세트로 들어가며, 둘째 행의 프로젝트·수주기간은 첫째 행을 따라가고 잠깁니다. Measure 는 첫째 행 QTY(Cell), 둘째 행 Sales Amt.(KRW) 로 고정되고 바꿀 수 없습니다."),
    ("DELETE (F9)", "공통", "선택한 행을 삭제 표시합니다. 화면에서는 한 행만 표시되지만 저장 시 같은 그룹의 짝 행까지 함께 지워집니다."),
    ("EDIT", "공통", "편집 모드로 전환합니다. 사업부와 권한을 다시 검사하며, 편집 중에는 조회조건을 바꿀 수 없습니다. 짝수 행의 수주기간은 잠기고 윗행 값을 따라갑니다."),
    ("SAVE (F7)", "공통", "변경·추가된 행을 저장하고 삭제 표시된 행을 지웁니다. 저장과 삭제는 별개 호출이며, 하나라도 성공하면 저장 후 자동으로 다시 조회합니다."),
    ("EXCEL", "공통", "화면 그대로 엑셀로 내려받습니다. 병합은 풀고 테두리는 전체, 숫자는 천단위 구분 정수 형식으로 내보냅니다."),
    ("SORT / FILTER / CONDITION / RESET CONDITION", "공통", "표준 공통 버튼입니다. AS-IS 에는 별도 구현이 없으므로 TO-BE 공통 동작을 따릅니다."),
]

GRID = [
    ("고정 영역 (좌측)", "Project · 수주 기간(시작/종료) · Measure · 수주(품의) · 수주(현재) · 실적 · 계획 · 잔고(실적 기준) · 잔고(실적+계획 기준)",
     "관리자 컬럼 메타 기준 15개가 보이고 Project 1개는 숨김입니다. 헤더는 2단이며 시작·종료는 상위 헤더 '수주 기간' 으로 묶입니다."),
    ("월 영역 (우측)", "M1 ~ M143",
     "조회 기간의 월 수만큼만 보이고 나머지는 감춥니다. 헤더 2단째에는 실제 연월(예: 2026.01)이 찍히고 상위 헤더는 '수주 기간 매출 상세' 로 묶입니다. n번째로 보이는 월이 곧 Mn 입니다."),
    ("행 구조", "2행 1세트",
     "한 프로젝트·수주기간 조합은 QTY(Cell) 과 Sales Amt.(KRW) 두 행으로만 존재합니다. Project 와 수주 기간, 행 번호는 두 행에 걸쳐 세로로 병합해 보여줍니다."),
    ("편집 가능 셀", "Project · 수주 기간 · 수주(품의) · 수주(현재) (세트의 첫째 행만)",
     "조회 직후에는 모든 셀이 잠겨 있고 편집 모드에서만 열립니다. 실적·계획·잔고·월 수량은 계산 결과라 언제나 잠깁니다."),
    ("셀 색상", "편집 가능 = 노랑 / 잠금 = 회색 / 기본 = 흰색+얼룩무늬", "표준 3색 규칙을 따릅니다."),
    ("내부 키 컬럼", "KEYVALUE · KEYVALUE2 · MEASURE2", "화면에는 보이지 않지만 저장·삭제에 쓰는 키입니다. KEYVALUE2 가 Measure 짝을 묶습니다."),
    ("범위 밖 월 처리", "수주 기간을 벗어난 월은 0", "행의 수주 시작월보다 이르거나 종료월보다 늦은 월 칸은 0 으로 표시합니다."),
]

VALID_FE = [
    ("1", "화면 진입", "내 사업부 목록에 40 이 없음", "MSG00415", "40번 사업부 전용 화면임을 알리고 더 진행하지 않습니다. AS-IS 는 화면을 닫지는 않아 빈 그리드가 남습니다."),
    ("2", "편집 진입", "내 사업부 목록에 40 이 없음", "MSG00415", "편집 모드로 들어가지 못합니다."),
    ("3", "편집 진입", "로그인 그룹이 DM ADMIN 또는 ADMIN 이 아님", "MSG00096", "권한이 없어 편집할 수 없습니다."),
    ("4", "조회", "내 사업부 목록에 40 이 없음", "MSG00415", "조회하지 않습니다."),
    ("5", "조회", "로그인 그룹이 DM ADMIN 또는 ADMIN 이 아님", "MSG00096", "AS-IS 는 조회에도 편집권한을 요구했습니다. TO-BE 는 조회를 메뉴 권한으로 열고 이 게이트는 편집 계열에만 적용합니다(확정)."),
    ("6", "조회", "Version 이 비어 있음", "MSG00283", "버전을 먼저 고르라고 알립니다."),
    ("7", "조회", "Period 시작 또는 종료가 비어 있음", "MSG00002 (파라미터 Period)", "기간은 필수입니다."),
    ("8", "조회", "Period 를 날짜로 해석할 수 없음", "MSG00049", "날짜 형식 오류를 알립니다."),
    ("9", "조회", "시작월이 종료월보다 뒤", "MSG00108", "기간 대소가 맞지 않습니다."),
    ("10", "조회", "(도달 불가) 건수 변수 분기", "MSG00307", "⛔ 변수가 항상 0 이라 실행되지 않는 죽은 코드입니다. TO-BE 이관 대상이 아닙니다."),
    ("11", "저장", "행의 수주 기간이 비어 있음", "MSG00002 (파라미터 Period)", "저장 전체를 중단합니다."),
    ("12", "저장", "행의 Project 가 비어 있음", "MSG00002 (파라미터 Project)", "저장 전체를 중단합니다."),
    ("13", "저장", "행의 Measure 가 비어 있음", "MSG00002 (파라미터 Measure)", "저장 전체를 중단합니다."),
    ("14", "저장", "수주(품의) 또는 수주(현재)가 비어 있음", "MSG00084", "0보다 큰 정수를 넣어야 합니다."),
    ("15", "저장", "수주(품의) 또는 수주(현재)의 정수부가 0 이하", "MSG00084", "0보다 큰 정수를 넣어야 합니다."),
    ("16", "저장", "행의 시작월이 종료월보다 뒤", "MSG00108", "저장 전체를 중단합니다."),
    ("17", "저장", "행의 기간을 날짜로 해석할 수 없음", "MSG00049", "저장 전체를 중단합니다."),
    ("18", "저장", "새로 넣은 행이 짝을 이루지 못함", "MSG00113", "그룹 키가 비어 있는 행들을 프로젝트·기간으로 묶었을 때 2행이 안 되면 막습니다. 신규는 반드시 두 행이 한 쌍이어야 합니다."),
    ("19", "저장 결과", "저장 성공", "MSG00004 (ADD / MODIFY : 건수)", "성공 건수를 알리고 자동으로 다시 조회합니다."),
    ("20", "저장 결과", "기간 중첩", "MSG00105", "이미 겹치는 기간이 있어 저장하지 않았음을 알립니다."),
    ("21", "저장 결과", "그 밖의 실패", "MSG00260", "신규 입력 데이터에 중복이 있음을 알립니다."),
    ("22", "삭제 결과", "삭제 성공", "MSG00004 (DELETE : 건수)", "삭제 건수를 알리고 자동으로 다시 조회합니다."),
    ("23", "삭제 결과", "삭제 실패", "MSG00284", "실행 중 오류가 발생했음을 알립니다."),
    ("P1", "버전 팝업 선택", "두 행 이상 선택", "MSG00279", "버전은 하나만 고를 수 있습니다."),
    ("P2", "버전 팝업 선택", "선택한 행이 없음", "MSG00279", "버전을 골라야 합니다."),
]

VALID_SP = [
    ("SAVE", "기간 중첩 (원장 기준)", "같은 사업부·프로젝트·Measure 에서 자기 자신을 제외하고 기간이 겹치는 행이 이미 있으면 저장을 취소하고 중복 코드를 돌려줍니다."),
    ("SAVE", "기간 중첩 (입력 자체 기준)", "저장하려는 입력 안에서도 같은 조합끼리 기간이 겹치는지 확인합니다."),
    ("SAVE", "짝 기간 동기화", "기간이 바뀐 행이 있으면 같은 그룹 키를 가진 짝 행의 기간도 같은 값으로 맞춥니다."),
    ("SAVE", "그룹 키 보정", "그룹 키가 비어 있는 행은 같은 프로젝트·기간의 기존 행에서 그룹 키를 물려받고, 없으면 새로 만듭니다."),
    ("SAVE", "버전 저장 안 함", "원장에 VERSION_NO 컬럼이 있지만 저장하지 않습니다. 버전과 무관하게 등록·수정·조회한다는 원설계 방침입니다."),
    ("DEL", "짝 동시 삭제", "선택한 행의 그룹 키에 속한 모든 행을 지웁니다."),
    ("GET", "편집권한 조인", "조회 SQL 이 편집권한 뷰와 INNER JOIN 합니다. 뷰에 해당 사용자·메뉴·사업부 행이 없으면 결과가 0행이 됩니다."),
    ("GET", "명시적 RAISE", "위 검증 외의 명시적 RAISE 는 없습니다. 예외는 표준 블록에서 로그를 남기고 -20001 로 전파합니다."),
]

DEFECTS = [
    ("D1", "GET_ORDERLIST — 프로젝트 정보 추출 조건",
     "프로젝트 정보를 가진 아이템을 고르는 조건이 Oracle 에서 언제나 거짓이 되어 작업 테이블이 비고, 그 결과 월별 수량·실적·계획·잔고가 전부 0 으로 나옵니다.",
     "MSSQL 의 빈 문자열 비교를 Oracle 로 그대로 옮겼기 때문입니다. Oracle 은 빈 문자열을 NULL 로 다루므로 비교 결과가 참이 될 수 없습니다.",
     "조건을 'PROJECT_INFO 가 NULL 이 아님' 으로 바꿉니다.",
     "사내 실측 — 현재 조건 0행 / 정정 조건 14,981행"),
    ("D2", "GET_ORDERLIST — 월별 PIVOT 컬럼 참조",
     "월 컬럼 M1, M2 … 가 수량 대신 해당 월의 연월 숫자(202501, 202502 …)를 그대로 돌려줍니다.",
     "MSSQL 의 대괄호 식별자를 옮기면서 따옴표를 붙이지 않아 컬럼 참조가 아니라 숫자 상수가 되었습니다.",
     "PIVOT 목록과 참조를 모두 큰따옴표 식별자로 만들도록 동적 SQL 생성부를 정정합니다.",
     "사내 실행으로 현상·정정 양쪽 확인"),
    ("D3", "SAVE_ORDERLIST — 후처리 커서의 범위",
     "그룹 키 보정과 짝 기간 동기화, 임시 컬럼 초기화가 이번 저장분이 아니라 원장 전체를 훑습니다.",
     "AS-IS MSSQL 원본도 동일합니다. 변환 결함이 아니라 원설계 특성입니다.",
     "변경하지 않고 리스크로만 관리합니다. 원장이 66행 규모라 현재 영향은 없습니다.",
     "AS-IS SP 원문 대조 완료"),
    ("D4", "화면 — 범위 밖 월 0 처리 시작 위치",
     "수주 기간을 벗어난 월을 0 으로 바꾸는 처리가 두 번째 표시 월부터 시작해, 첫 번째 표시 월은 범위 밖이어도 0 처리되지 않습니다.",
     "AS-IS 소스의 반복 시작 인덱스가 컬럼 시작 위치와 한 칸 어긋나 있습니다.",
     "TO-BE 는 첫 월부터 동일하게 적용합니다.", "AS-IS 소스 실측"),
    ("D5", "화면 — 사업부 판정 방식",
     "사업부 판정이 '포함' 비교라서 140, 401 같은 코드도 통과합니다.",
     "AS-IS 잔존 결함입니다.", "TO-BE 는 정확히 40 인지로 판정합니다.", "AS-IS 소스 실측"),
    ("D7", "GET_ORDERLIST / 버전 팝업 — 편집권한 뷰 조인 방식",
     "편집 권한이 없는 사용자는 조회 결과와 버전 목록이 통째로 비어 보입니다.",
     "편집권한 뷰를 INNER JOIN 으로 붙여 편집 권한이 곧 조회 조건이 되어 있습니다.",
     "확정된 권한 정책(조회는 메뉴 권한, 편집 계열만 EDIT_YN)에 맞춰 LEFT JOIN 으로 바꾸고 권한이 없으면 EDIT_YN 을 N 으로 내려줍니다.",
     "PKG 본문 실측"),
    ("D6", "메타 — 실적/계획 컬럼 중복 등록",
     "컬럼 메타에 Result·Plan 과 SResult·SPlan 이 같은 정렬 순서로 중복 등록돼 있는데, 조회 프로시저는 SResult·SPlan 만 돌려줍니다.",
     "이관 과정의 중복입니다.", "Result·Plan 을 보이지 않도록 바꾸는 것을 권합니다. 삭제는 실사용 대조 후에 판단합니다.",
     "사내 메타 실측 159행"),
]

MATRIX_DIV = [
    ("1", "화면 진입", "내 사업부 목록에 40 이 포함되는지 확인", "없으면 안내 후 진행 중단"),
    ("2", "편집 진입", "동일 확인", "없으면 편집 불가"),
    ("3", "조회", "동일 확인", "없으면 조회 불가"),
    ("4", "모든 프로시저 호출", "사업부 값을 40 으로 고정해 보냅니다", "사업부 선택 UI 자체가 없습니다"),
    ("5", "버전 팝업", "사업부를 40 으로 고정해 엽니다", "팝업 안의 사업부 체크리스트는 40 이 선택된 상태로 열립니다"),
]

MATRIX_AUTH = [
    ("1", "조회", "AS-IS 는 DM ADMIN / ADMIN 만 허용", "TO-BE 는 메뉴 권한이 있으면 조회 가능", "정책 완화 (확정)"),
    ("2", "편집 진입", "DM ADMIN / ADMIN", "아니면 편집 차단 (MSG00096)", "AS-IS 정책 유지"),
    ("3", "조회 결과", "편집권한 뷰에 사용자·메뉴·사업부 행이 있어야 함", "⚠ 조회 SQL 이 INNER JOIN 이라 뷰에 없으면 0행", "조회를 열려면 이 조인을 LEFT 로 바꾸고 EDIT_YN 만 내려받도록 정정 필요"),
    ("4", "버전 팝업", "동일 편집권한 뷰 조인", "없으면 버전 목록 0행", "동일 정정 대상"),
    ("5", "메뉴 권한", "ADMIN / DM ADMIN / DM Viewer 3그룹 등록", "DM Viewer 는 조회 전용으로 운영", "정책 확정에 따라 유지"),
    ("6", "버튼 권한", "미등록 (0행)", "구현 시 메뉴 권한 그룹 × 버튼으로 등록", "편집 계열 버튼은 DM ADMIN / ADMIN 에만 부여"),
]

MATRIX_MEASURE = [
    ("1", "행 추가", "언제나 두 행을 한 번에 넣습니다", "첫째 행 QTY(Cell), 둘째 행 Sales Amt.(KRW)"),
    ("2", "행 추가", "두 행에 같은 그룹 키를 부여합니다", "이후 저장·삭제가 이 키로 짝을 찾습니다"),
    ("3", "행 추가", "Measure 셀을 잠급니다", "사용자가 Measure 를 바꿀 수 없습니다"),
    ("4", "행 추가", "둘째 행의 프로젝트·수주기간을 첫째 행에 연결하고 잠급니다", "첫째 행을 고치면 둘째 행이 따라 바뀝니다"),
    ("5", "편집 진입", "짝수 행의 수주기간을 잠그고 윗행 값을 복사합니다", "편집 중에도 짝의 기간은 항상 같습니다"),
    ("6", "저장", "수정 행은 Measure 를 코드로 치환해 기록합니다", "금액 축이 아니면 MEA_1 으로 저장합니다"),
    ("7", "저장", "새 행이 짝을 못 이루면 막습니다", "그룹 키가 빈 행을 프로젝트·기간으로 묶어 2행 미만이면 차단"),
    ("8", "저장(SP)", "그룹 키가 빈 행에 기존 그룹 키를 물려주거나 새로 만듭니다", ""),
    ("9", "저장(SP)", "기간이 바뀌면 짝 행 기간도 함께 바꿉니다", ""),
    ("10", "삭제(SP)", "그룹 키 기준으로 짝까지 함께 지웁니다", "화면은 한 행만 선택해도 됩니다"),
    ("11", "버전 계열 분기", "버전이 R_S 로 시작하면 Sales Plan 계열, 아니면 Biz Plan 계열", "⚠ 화면의 Measure 콤보 두 벌은 내용이 같아 현재 분기가 실질적으로 같습니다"),
    ("12", "조회 표시명", "계열에 따라 내부 코드를 QTY(Cell) / Sales Amt.(KRW) 로 바꿔 보여줍니다", ""),
]

MATRIX_PERIOD = [
    ("1", "기본값", "전년 1월 ~ 익년 12월 (36개월)", "화면이 열릴 때 자동 설정됩니다"),
    ("2", "컬럼 개수", "조회 기간의 월 수만큼 보입니다", "메타에는 M1~M143 이 준비돼 있고 나머지는 감춥니다"),
    ("3", "컬럼 헤더", "2단째에 실제 연월을 찍습니다", "상위 헤더는 '수주 기간 매출 상세' 로 묶입니다"),
    ("4", "데이터 대응", "n번째로 보이는 월 = Mn", "프로시저가 순번 별칭으로 돌려줍니다"),
    ("5", "실적/계획 경계", "전월까지 실적, 당월부터 계획", "조회 시점의 시스템 날짜 기준입니다"),
    ("6", "범위 밖 월", "행의 수주 기간을 벗어난 월은 0", "⚠ AS-IS 는 첫 표시 월을 건너뜁니다(D4)"),
    ("7", "조회 검증", "기간 필수 · 형식 검사 · 시작≤종료", "각각 별도 메시지로 안내합니다"),
    ("8", "저장 검증", "행 단위로 동일한 형식·대소 검사", "하나라도 어긋나면 저장 전체를 중단합니다"),
    ("9", "확장 한계", "AS-IS 는 월 컬럼을 144개로 가정해 코드에 박아 두었습니다", "TO-BE 는 기간에서 계산해 동적으로 만듭니다"),
]

VISIBILITY = [
    ("고정 컬럼", "Project", "숨김", "메타에서 보이지 않도록 설정돼 있습니다. 실제 표시는 Project_Name 이 담당합니다."),
    ("고정 컬럼", "Project_Name / OrderStart / OrderEnd / Measure / OrderApproval / OrderNow / SResult / SPlan / Stock / Stock2", "표시", "총 15개가 보이도록 등록돼 있습니다."),
    ("고정 컬럼", "Result / Plan", "표시(등록상)", "⚠ SResult·SPlan 과 중복이며 조회 프로시저가 값을 주지 않아 빈 열이 됩니다. 숨김 권장(D6)."),
    ("고정 컬럼", "MEASURE2 / KEYVALUE / KEYVALUE2", "표시(등록상), 폭 0", "내부 키라 화면에서는 사실상 보이지 않습니다."),
    ("월 컬럼", "M1 ~ M143", "표시(등록상)", "실제 표시 개수는 조회 기간이 결정합니다. 나머지는 화면에서 감춥니다."),
    ("프로시저 반환", "EDIT_YN", "메타 없음", "⚠ 조회 프로시저는 돌려주지만 컬럼 메타에 없습니다. 편집 가능 판정에 쓰려면 메타 등록 또는 화면 내부 처리로 정해야 합니다."),
    ("부모 종속", "-", "해당 없음", "이 화면은 LAYER 계층 은폐 구조를 쓰지 않습니다."),
]

LEGACY_DIFF = [
    ("보안 패치", "저장·삭제 호출 방식", "구본은 프로시저 이름과 파라미터를 코드에 그대로 노출했습니다.",
     "정본은 별칭(SaveDemandManager / DelDemandManager)으로 부르고 실제 이름은 별도 정의 파일이 갖습니다.",
     "TO-BE 는 API 배선으로 대체되므로 별칭 개념이 불필요합니다."),
    ("이력 주석", "헤더", "구본에는 2026-03-18 이력이 없습니다.", "정본에 보안성 취약점 보완 이력이 추가됐습니다.", "-"),
    ("코드 정리", "GetLookupData 메서드", "구본에는 공통 룩업 조회 메서드가 있었습니다.", "정본에서 제거됐습니다(호출부 없음).", "TO-BE 이관 대상 아님"),
    ("규모", "행수", "1,328행(구본)", "1,337행(정본)", "-"),
    ("영향", "분석 자료", "기존 분석 MD·엑셀은 전부 구본 기준이며 메시지 문구가 다른 사전에서 잘못 매핑돼 있습니다.",
     "본 문서는 정본과 사내 실측만 사용했습니다.", "기존 자료 재사용 금지"),
]

MSG_MAP = [
    ("MSG00002", "{0} 값은 필수 입력입니다", "MSG00614 = {0} 값은 필수 입력입니다. (문구 일치)", "MSG00614 재사용", "AS-IS 번호는 다른 문구로 점유됨"),
    ("MSG00004", "저장 결과 {0} 건", "MSG00672 = {0}개의 데이터가 저장되었습니다. (의미 일치)", "MSG00672 재사용", "저장·삭제 결과 공용. AS-IS 번호는 다른 문구로 점유됨"),
    ("MSG00049", "유효한 날짜 형식이 아닙니다. {0}", "MSG00611 = 유효한 날짜 형식이 아닙니다. (YYYYMMDD)", "MSG00611 재사용", "파라미터가 형식 안내로 고정"),
    ("MSG00084", "0보다 큰 정수를 입력하십시오", "동일·유사 문구 없음 (MSG00679 는 Business Plan 전용)", "신규 MSG00699", "3언어 등록"),
    ("MSG00096", "권한이 없습니다", "MSG00096 = 권한이 없습니다. (문구 일치)", "그대로 재사용", "✔"),
    ("MSG00105", "중첩된 기간이 있습니다", "동일·유사 문구 없음", "신규 MSG00700", "3언어 등록"),
    ("MSG00108", "시작일자가 종료일자보다 늦을 수 없습니다", "MSG00108 = 조회 기간이 잘못되었습니다 (시작일 > 종료일). (의미 일치)", "그대로 재사용", "✔"),
    ("MSG00113", "필수 입력 컬럼이 없습니다", "MSG00113 = 필수 입력 컬럼이 없습니다. (문구 일치)", "그대로 재사용", "✔"),
    ("MSG00260", "신규 입력 데이터 중 중복된 데이터가 있습니다", "MSG00260 = 중복된 조합이 존재합니다. (의미 일치)", "그대로 재사용", "✔"),
    ("MSG00279", "버전은 1개만 선택해 주세요", "동일·유사 문구 없음 (MSG00255 는 최대 2개)", "신규 MSG00701", "3언어 등록"),
    ("MSG00283", "버전을 선택하세요", "MSG00283 = 버전을 선택하세요. (문구 일치)", "그대로 재사용", "✔"),
    ("MSG00284", "실행중 에러가 발생했습니다", "MSG00618 = 저장 중 오류가 발생했습니다. (의미 일치)", "MSG00618 재사용", "저장 흐름 내 삭제 실패 안내. AS-IS 번호는 다른 문구로 점유됨"),
    ("MSG00307", "(도달 불가)", "-", "이관 제외", "죽은 코드"),
    ("MSG00415", "40번 사업부 전용 화면입니다", "동일·유사 문구 없음 (MSG00667 은 다른 의미)", "신규 MSG00702", "3언어 등록"),
]

OVERVIEW = [
    ("화면 ID", "DMF0068"),
    ("화면명", "Demand Manager (AS-IS 명칭: 소형 수주관리)"),
    ("도메인", "DM (Demand)"),
    ("메뉴 경로", "Demand > Demand Waterfall > Demand Manager (메뉴 트리 실측 — 상위 Demand, 중간 Demand Waterfall, 본 화면 레벨 3)"),
    ("업무 목적", "소형(40) 사업부의 수주 정보를 프로젝트·수주기간 단위로 등록·수정하고, 그 기간에 해당하는 계획·실적 수량을 월별로 함께 보며 잔고를 확인하는 화면입니다."),
    ("AS-IS 폼", "DMF0068_DemandManager40 (GSCM.DM.Forms.UIL / Plan) — 1,337행. 호출 팝업 DMF0068_VersionPopup 1종."),
    ("TO-BE 경로", "features/demand/src/pages/demand-manager (현재 미구현). 메뉴 주소는 dmf0068 로 임시 등록돼 있어 demand-manager 로 정정 예정."),
    ("대상 Division", "40 전용. 사업부 선택 UI 가 없고 모든 프로시저 호출에 40 을 고정으로 보냅니다."),
    ("화면 성격", "조회 + 편집(행 추가·수정·삭제·저장). 그리드는 한 개이며 헤더가 2단이고, 한 건이 Measure 2행으로 표현됩니다."),
    ("주요 SP", "PKG_DMF0068 의 조회·프로젝트콤보·버전팝업·저장·삭제 5개 멤버. 사내에서 패키지는 유효 상태입니다."),
    ("제외 범위", "AS-IS 의 죽은 코드(3단 헤더 동적 구성, 건수 안내 메시지, 화면단 실적·계획 재계산, 팝업 공통 타이틀 조회)는 이관하지 않습니다."),
    ("⚠ 선행 조치", "조회 프로시저에 차단성 결함 2건이 실측 확인됐습니다(월 수량이 상수로 반환 / 프로젝트 정보 추출 조건이 항상 거짓). 정정 없이는 화면이 의미 있는 값을 표시하지 못합니다."),
    ("권한 정책", "조회는 메뉴 권한(ADMIN / DM ADMIN / DM Viewer)으로 열고, 편집·저장·삭제·행추가는 편집권한(EDIT_YN) 기준으로 통제합니다. AS-IS 는 조회에도 편집권한을 요구했으나 TO-BE 는 완화합니다."),
    ("메시지 정책", "AS-IS 13종을 사내 메시지 원장과 명칭(문구) 기준으로 대사해 9종은 기존 코드를 재사용하고 4종만 신규 채번(MSG00699~MSG00702)합니다. 1종은 죽은 코드라 이관하지 않습니다."),
]


def write_common_flow(sb, wide=6):
    sb.sec("A. DM 전체 프로세스 흐름 (6단계) — 원천: DM 분석 마인드맵 + 도메인 분석 자료")
    sb.hdr(["단계", "단계명", "무엇을 하는 단계인가요", "관련 화면 · 배치(SP)", "비고", "본 화면"])
    for r in FLOW:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. 본 화면 위치")
    sb.text(FLOW_POS)
    sb.gap()
    sb.sec("C-1. 이 화면이 사용하는 PKG · SP (실사용 전수 — 사내 실측)")
    sb.hdr(["구분", "오브젝트", "무엇을 하나요", "API 배선", "구조", "비고"])
    for r in PKG_SP:
        sb.row(list(r))
    sb.gap()
    sb.sec("C-2. 주요 데이터 Table — SP·메타 실측")
    sb.hdr(["구분", "테이블", "역할", "읽기/쓰기"])
    for r in TABLES:
        sb.row(list(r))
    sb.gap()
    sb.sec("C-3. Measure 저장대상")
    sb.hdr(["Measure", "Division", "규칙"])
    for r in MEASURES:
        sb.row(list(r))


# ══════════════════════════ UI분석서 (10시트) ══════════════════════════
def build_analysis():
    wb = openpyxl.Workbook()
    wb.remove(wb.active)

    ws = wb.create_sheet("1.개요")
    sb = SB(ws, [24, 120])
    sb.title("DMF0068 Demand Manager — UI분석서")
    sb.hdr(["항목", "내용"])
    for k, v in OVERVIEW:
        sb.row([k, v])

    ws = wb.create_sheet("2.전체흐름")
    sb = SB(ws, [8, 24, 58, 50, 46, 12])
    sb.title("2. 전체흐름 — DM 프로세스 내 위치 · 사용 PKG/SP · 주요 테이블 · Measure 저장대상")
    write_common_flow(sb)

    ws = wb.create_sheet("3.VALIDATION취합")
    sb = SB(ws, [8, 18, 40, 24, 60])
    sb.title("3. VALIDATION 취합 — 화면(FE) 검증 + 프로시저(DB) 검증 + 원본 결함")
    sb.sec("A. 화면 검증 (AS-IS 활성 23건 + 팝업 2건 — 전수)")
    sb.hdr(["#", "시점", "조건", "메시지", "무엇을 하나요"])
    for r in VALID_FE:
        sb.row(list(r))
    sb.gap()
    sb.sec("A-2. 메시지 ID 대사 (AS-IS ↔ 사내 TO-BE 실문구 비교)")
    sb.hdr(["AS-IS ID", "AS-IS 문구", "사내 TO-BE 현황", "조치", "비고"])
    for r in MSG_MAP:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. 프로시저 검증 (PKG_DMF0068 본문 전수 Read)")
    sb.hdr(["멤버", "검증/규칙", "무엇을 하나요"])
    for r in VALID_SP:
        sb.row(list(r))
    sb.gap()
    sb.sec("C. 원본 결함 (실측) — 은폐 없이 기재")
    sb.hdr(["#", "위치", "증상", "원인", "조치", "검증 근거"])
    for r in DEFECTS:
        sb.row(list(r))

    ws = wb.create_sheet("4.MATRIX_Division")
    sb = SB(ws, [8, 22, 55, 60])
    sb.title("4. MATRIX — Division 축")
    sb.text("이 화면은 사업부 40 전용입니다. 사업부를 고르는 조회조건이 없고, 진입·편집·조회 세 곳에서 내 사업부 목록에 40 이 있는지만 확인합니다.")
    sb.hdr(["#", "시점", "확인 내용", "효과"])
    for r in MATRIX_DIV:
        sb.row(list(r))

    ws = wb.create_sheet("5.MATRIX_권한")
    sb = SB(ws, [8, 20, 45, 45, 40])
    sb.title("5. MATRIX — 권한 축")
    sb.hdr(["#", "시점", "조건", "효과", "비고"])
    for r in MATRIX_AUTH:
        sb.row(list(r))

    ws = wb.create_sheet("6.MATRIX_Measure")
    sb = SB(ws, [8, 20, 60, 60])
    sb.title("6. MATRIX — Measure(2행 1세트) 축")
    sb.text("이 화면의 가장 큰 특징입니다. 한 건은 반드시 QTY(Cell) 과 Sales Amt.(KRW) 두 행으로 이루어지며, 추가·수정·삭제가 모두 이 짝 단위로 움직입니다.")
    sb.hdr(["#", "시점", "규칙", "효과"])
    for r in MATRIX_MEASURE:
        sb.row(list(r))

    ws = wb.create_sheet("7.MATRIX_월·기간")
    sb = SB(ws, [8, 20, 55, 60])
    sb.title("7. MATRIX — 월(PIVOT)·기간 축")
    sb.text("다른 DM 화면의 FCST_TYPE 축은 이 화면에 없습니다(예측 유형으로 갈라지지 않음). 대신 조회 기간이 그리드 월 컬럼을 결정하는 축이 핵심이라 이를 매트릭스로 정리합니다.")
    sb.hdr(["#", "구분", "규칙", "효과"])
    for r in MATRIX_PERIOD:
        sb.row(list(r))

    ws = wb.create_sheet("8.가시성_LAYER종속")
    sb = SB(ws, [20, 45, 18, 65])
    sb.title("8. 가시성 — 컬럼 메타 실측 159행")
    sb.hdr(["구분", "컬럼", "표시 여부", "설명"])
    for r in VISIBILITY:
        sb.row(list(r))

    ws = wb.create_sheet("9.SP_LOOKUP_콤보")
    sb = SB(ws, [16, 46, 58, 22, 16, 40])
    sb.title("9. SP · LOOKUP · 콤보 — 배선 실측")
    sb.sec("A. 사용 PKG · SP")
    sb.hdr(["구분", "오브젝트", "무엇을 하나요", "API 배선", "구조", "비고"])
    for r in PKG_SP:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. 배선 메타 실측 (사내 2026-07-29)")
    sb.hdr(["메타", "실측", "판정"])
    for r in [
        ("SCM_ADM_API_M", "0행", "⚠ 구현 시 등록 필요"),
        ("SCM_ADM_PROC_M", "0행", "⚠ 구현 시 등록 필요 — 인자 순서는 프로시저 정의와 정확히 일치시켜야 합니다"),
        ("SCM_ADM_MNU_BTN_MPG_M", "0행", "⚠ 화면이 쓰는 모든 시트에 대해 등록 필요"),
        ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", "0행", "⚠ 메뉴 권한 3그룹 × 버튼으로 등록 필요"),
        ("SCM_ADM_USER_GR_MNU_MPG_M", "3행 (ADMIN / DM ADMIN / DM Viewer)", "등록 완료 — 다만 DM Viewer 는 AS-IS 정책과 충돌"),
        ("SCM_MST_SHEET_COLUMNS", "159행 (고정 16 + 월 143)", "등록 완료 — Result·Plan 중복 정리 필요"),
        ("SCM_MST_SHEET_MEASURE", "0행", "등록 필요 여부는 구현 시 판단"),
        ("SCM_ADM_MNU_M", "1행 (주소 dmf0068)", "⚠ demand-manager 로 정정 필요"),
        ("PKG_DMF0068", "SPEC / BODY 모두 유효", "정상 (단, 본문 결함 2건 정정 필요)"),
        ("T_DMF0068_ROW / T_DMF0068_TAB", "유효", "정상"),
        ("standalone SP 4종", "유효하지 않음", "패키지로 대체된 잔재 — 배선은 패키지로만 합니다"),
        ("GT_DM68_ORD_* 5종", "존재", "조회 파이프라인 작업 테이블"),
    ]:
        sb.row(list(r))
    sb.gap()
    sb.sec("C. 콤보 · 룩업")
    sb.hdr(["대상", "원천", "설명"])
    for r in [
        ("Project (그리드 셀 콤보)", "SCM_ADM_LOOKUP_MASTER_DETAIL (PROJECT_MODEL_MAPPING)", "행 추가 시 프로젝트 목록을 채웁니다. AS-IS 는 버전이 바뀔 때만 다시 읽습니다."),
        ("Measure (그리드 셀 콤보)", "화면 내부 고정 2건", "메타가 아니라 소스에 직접 들어 있습니다. 값은 잠겨 있어 사용자가 바꿀 수 없습니다."),
        ("Type (버전 팝업)", "MDF_TYPE 룩업", "버전 유형 선택 콤보입니다."),
        ("Division (버전 팝업)", "내 사업부 목록", "호출 시 40 으로 고정 선택됩니다."),
    ]:
        sb.row(list(r))

    ws = wb.create_sheet("10.이전소스_차이점")
    sb = SB(ws, [16, 24, 46, 46, 40])
    sb.title("10. 이전 소스(GSCM_20260512) ↔ 정본(GSCM) 차이 — 실측")
    sb.text("두 파일을 직접 비교한 결과 변경은 56줄 추가 / 47줄 삭제 한 덩어리이며, 내용은 2026-03-18 보안 패치와 사용하지 않는 메서드 제거입니다.")
    sb.hdr(["구분", "대상", "이전(구본)", "정본", "TO-BE 영향"])
    for r in LEGACY_DIFF:
        sb.row(list(r))

    out = ANA / "DMF0068_DemandManager_UI분석서_v1.0.xlsx"
    wb.save(out)
    return out, wb


# ══════════════════════════ 화면설계서 (8시트) ══════════════════════════
def build_design():
    wb = openpyxl.Workbook()
    wb.remove(wb.active)

    ws = wb.create_sheet("1.개요")
    sb = SB(ws, [24, 120])
    sb.title("DMF0068 Demand Manager — 화면설계서")
    sb.hdr(["항목", "내용"])
    for k, v in OVERVIEW:
        sb.row([k, v])
    sb.gap()
    sb.sec("개정 이력")
    sb.hdr(["버전", "일자", "내용"])
    sb.row(["v1.0", "2026-07-29", "최초 작성. AS-IS 정본 1,337행 전수 Read + 사내 PKG 본문 전수 Read + AS-IS MSSQL 원본 SP 대조 실측 기반."])

    ws = wb.create_sheet("2.전체흐름")
    sb = SB(ws, [8, 24, 58, 50, 46, 12])
    sb.title("2. 전체흐름 — DM 프로세스 내 위치 · 사용 PKG/SP · 주요 테이블 · Measure 저장대상")
    write_common_flow(sb)

    ws = wb.create_sheet("3.LAYOUT")
    sb = SB(ws, [22, 60, 60])
    sb.title("3. LAYOUT — 화면 구성")
    sb.sec("A. 진입 경로")
    sb.text("Demand > Demand Waterfall > Demand Manager 로 들어갑니다. 메뉴 주소는 현재 임시값(dmf0068)이며 구현 시 demand-manager 로 정정합니다.")
    sb.gap()
    sb.sec("B. 화면 구역")
    sb.hdr(["구역", "구성", "설명"])
    for r in [
        ("상단 조회영역", "Version(읽기 전용 입력 + 찾기 버튼) · Period(월 구간)",
         "두 조건만 있습니다. 사업부는 40 으로 고정이라 화면에 나오지 않습니다. 편집 중에는 두 조건 모두 잠깁니다."),
        ("우측 상단", "Search 버튼", "조회를 실행합니다."),
        ("버튼 영역", "Insert · Delete · Save · Sort · Filter · Condition · Reset Condition · Excel",
         "표준 공통 버튼 묶음입니다. 행 추가는 언제나 두 행 세트로 들어갑니다."),
        ("그리드", "단일 그리드, 헤더 2단",
         "왼쪽 고정 영역(프로젝트·수주기간·Measure·수량·실적·계획·잔고)과 오른쪽 월 영역으로 나뉩니다. 한 건이 두 행으로 보이고 프로젝트·수주기간·행번호는 세로 병합됩니다."),
        ("건수 표시", "총 N 건", "조회 결과 건수를 그리드 위에 보여줍니다."),
        ("팝업", "버전 선택 팝업 1종",
         "사업부·기간·유형·설명으로 버전을 찾아 한 건만 고릅니다. 두 건 이상 고르면 안내 후 막습니다."),
    ]:
        sb.row(list(r))
    sb.gap()
    sb.sec("C. 화면 이미지 (TO-BE 디자인 시안)")
    sb.text("아래 이미지는 디자인 참조입니다. 배치·버튼 구성·셀 색상 참고용이며 권한·편집·필수값 같은 정책 판단의 근거로 쓰지 않습니다.")
    if CAP.exists():
        img = XImage(str(CAP))
        img.width, img.height = int(img.width * 0.62), int(img.height * 0.62)
        ws.add_image(img, f"A{sb.r + 2}")
        sb.r += 46
    else:
        sb.text("(이미지 파일 없음)")

    ws = wb.create_sheet("4.조회조건·버튼")
    sb = SB(ws, [22, 12, 66, 34, 44])
    sb.title("4. 조회조건 · 버튼")
    sb.sec("A. 조회조건 (전수 3)")
    sb.hdr(["조건", "필수", "역할", "연결 SP", "비고"])
    for r in SEARCH:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. 버튼 (공통 override 6 + 커스텀 1)")
    sb.hdr(["버튼", "구분", "연결 동작"])
    for r in BUTTONS:
        sb.row(list(r))
    sb.row(["버전 찾기", "특화", "조회조건 옆의 작은 버튼입니다. 버전 선택 팝업을 열고, 고른 버전을 Version 칸에 채웁니다."])

    ws = wb.create_sheet("5.GRID")
    sb = SB(ws, [22, 46, 76])
    sb.title("5. GRID — 구조 · 동적 컬럼 · 편집 규칙")
    sb.hdr(["구분", "대상", "설명"])
    for r in GRID:
        sb.row(list(r))
    sb.gap()
    sb.sec("컬럼 메타 실측 (SCM_MST_SHEET_COLUMNS 159행)")
    sb.hdr(["구분", "컬럼", "설명"])
    for r in VISIBILITY:
        sb.row([r[0], r[1], r[3]])

    ws = wb.create_sheet("6.EVENT")
    sb = SB(ws, [18, 40, 90])
    sb.title("6. EVENT — 목차 + 상세")
    sb.sec("A. 목차")
    sb.hdr(["번호", "언제", "무엇이 어떻게 동작하나요"])
    for r in [
        ("E01", "화면을 열 때", "기간을 전년 1월~익년 12월로 채우고, 내 사업부에 40 이 있는지 확인한 뒤 그리드를 만들고 월 컬럼 표시 범위를 계산합니다."),
        ("E02", "버전 찾기 버튼을 누를 때", "사업부 40, 오늘 기준 앞뒤 3개월로 버전 팝업을 엽니다. 한 건을 고르면 Version 칸에 채워집니다."),
        ("E03", "Search 를 누를 때", "사업부·권한·버전·기간을 차례로 검사하고, 시트를 다시 만든 뒤 조회 프로시저를 부릅니다. 결과는 전부 잠긴 상태로 표시되고, 수주 기간을 벗어난 월 칸은 0 으로 바뀝니다."),
        ("E04", "Edit 를 누를 때", "사업부·권한을 다시 검사하고 편집 모드로 바꿉니다. 조회조건이 잠기고, 짝수 행의 수주기간은 윗행 값을 따라가며 잠깁니다."),
        ("E05", "Insert 를 누를 때", "두 행을 한 번에 넣습니다. 프로젝트 콤보를 채우고 Measure 를 고정 배정한 뒤 두 행에 같은 그룹 키를 부여합니다."),
        ("E06", "Delete 를 누를 때", "선택한 행을 삭제 표시합니다. 실제로는 저장 시 같은 그룹의 짝 행까지 함께 지워집니다."),
        ("E07", "Save 를 누를 때", "행마다 필수값·숫자·기간을 검사하고, 새로 넣은 행이 짝을 이루는지 확인한 뒤 저장과 삭제를 차례로 호출합니다. 성공하면 자동으로 다시 조회합니다."),
        ("E08", "Excel 을 누를 때", "화면 그대로 엑셀로 내보냅니다. 병합은 풀고 숫자는 천단위 구분 정수 형식입니다."),
    ]:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. 상세 (선행 산출물 주요이벤트 상세분석 전문 승계)")
    sb.hdr(["구분", "항목", "내용"])
    ev_rows = md_detail_rows(MD_EVENT)
    for r in ev_rows:
        sb.row(list(r))

    ws = wb.create_sheet("7.VALIDATION")
    sb = SB(ws, [8, 18, 40, 24, 60])
    sb.title("7. VALIDATION — 화면 검증 + 프로시저 검증 + 원본 결함")
    sb.sec("A. 화면 검증 (활성 23건 + 팝업 2건)")
    sb.hdr(["#", "시점", "조건", "메시지", "무엇을 하나요"])
    for r in VALID_FE:
        sb.row(list(r))
    sb.gap()
    sb.sec("A-2. 메시지 ID 대사")
    sb.hdr(["AS-IS ID", "AS-IS 문구", "사내 TO-BE 현황", "조치", "비고"])
    for r in MSG_MAP:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. 프로시저 검증")
    sb.hdr(["멤버", "검증/규칙", "무엇을 하나요"])
    for r in VALID_SP:
        sb.row(list(r))
    sb.gap()
    sb.sec("C. 축별 정리")
    sb.hdr(["축", "갈라지나요", "내용"])
    for r in [
        ("Division", "갈라지지 않음", "40 전용입니다. 다른 사업부 값으로 분기하는 로직이 없습니다."),
        ("권한", "갈라짐", "조회·편집 모두 DM ADMIN / ADMIN 만 허용하며, 조회 SQL 은 편집권한 뷰와 조인합니다."),
        ("Measure", "갈라짐", "QTY(Cell) 과 Sales Amt.(KRW) 두 행이 항상 한 세트로 움직입니다."),
        ("버전 계열", "형식상 갈라짐", "R_S 여부로 원천 테이블이 갈리지만, 화면의 Measure 목록은 두 계열이 같습니다."),
        ("기간", "갈라짐", "조회 기간이 월 컬럼 개수와 헤더를 결정하고, 전월/당월 경계로 실적과 계획이 나뉩니다."),
        ("FCST_TYPE", "갈라지지 않음", "이 화면에는 예측 유형 축이 없습니다."),
    ]:
        sb.row(list(r))
    sb.gap()
    sb.sec("D. 원본 결함 (실측)")
    sb.hdr(["#", "위치", "증상", "원인", "조치", "검증 근거"])
    for r in DEFECTS:
        sb.row(list(r))
    sb.gap()
    sb.sec("E. 제약매트릭스 상세 (선행 산출물 전문 승계)")
    sb.hdr(["구분", "항목", "내용"])
    mx_rows = md_detail_rows(MD_MATRIX)
    for r in mx_rows:
        sb.row(list(r))

    ws = wb.create_sheet("8.API·SP")
    sb = SB(ws, [16, 46, 58, 22, 16, 40])
    sb.title("8. API · SP")
    sb.sec("A. 화면이 부르는 프로시저 전수")
    sb.hdr(["구분", "오브젝트", "무엇을 하나요", "API 배선", "구조", "비고"])
    for r in PKG_SP:
        sb.row(list(r))
    sb.gap()
    sb.sec("B. AS-IS ↔ TO-BE 파라미터 변형")
    sb.hdr(["프로시저", "AS-IS 입력", "TO-BE 입력", "차이"])
    for r in [
        ("조회", "사업부 · 버전 · 시작월 · 종료월", "사업부 · 버전 · 시작월 · 종료월 · 사용자 · 메뉴",
         "사용자·메뉴가 추가됐습니다. 편집권한 뷰 조인에 쓰입니다. 반환 커서도 1개에서 3개로 늘었는데, 두 번째는 조립된 SQL 문장이라 화면에서 쓰지 않습니다."),
        ("프로젝트 콤보", "사업부 · 버전", "사업부 · 버전 · 사용자 · 메뉴", "동일하게 사용자·메뉴가 추가됐습니다."),
        ("버전 팝업", "시작일 · 종료일 · 사업부 · 유형 · 설명", "동일 + 사용자 · 메뉴", "동일하게 추가됐습니다."),
        ("저장", "테이블 값 파라미터 · 사용자 · 사업부 · 버전", "컬렉션 타입 · 사용자 · 사업부 · 버전",
         "⛔ 컬렉션 타입은 표준 호출 방식으로 넘길 수 없습니다. 문자열(JSON)을 받아 컬렉션으로 바꿔 기존 멤버를 그대로 부르는 래퍼가 필요합니다."),
        ("삭제", "테이블 값 파라미터", "컬렉션 타입", "⛔ 동일 — 래퍼가 필요합니다."),
    ]:
        sb.row(list(r))
    sb.gap()
    sb.sec("C. 다루는 테이블")
    sb.hdr(["구분", "테이블", "역할", "읽기/쓰기"])
    for r in TABLES:
        sb.row(list(r))
    sb.gap()
    sb.sec("D. 결과코드 규약")
    sb.hdr(["프로시저", "상황", "AS-IS 반환", "TO-BE 반환", "화면 처리"])
    for r in [
        ("저장", "성공", "결과코드 S + 건수", "코드 0 · SUCCESS · 건수", "성공 안내 후 재조회"),
        ("저장", "기간 중첩", "결과코드 DUPLICATE", "코드 DUPLICATE · DATE DUPLICATE", "중첩 안내 후 중단"),
        ("저장", "그 밖의 실패", "결과코드 F", "예외로 전파(-20001)", "오류 안내 — 백엔드 오류 응답 매핑이 필요합니다"),
        ("삭제", "성공", "결과코드 S + 건수", "코드 0 · SUCCESS · 건수", "성공 안내 후 재조회"),
        ("삭제", "실패", "결과코드 F", "예외로 전파", "오류 안내"),
    ]:
        sb.row(list(r))

    out = DES / "DMF0068_DemandManager_화면설계서_v1.0.xlsx"
    wb.save(out)
    return out, wb, len(ev_rows), len(mx_rows)


if __name__ == "__main__":
    a_out, a_wb = build_analysis()
    d_out, d_wb, ev_n, mx_n = build_design()
    print(f"UI분석서   : {a_out.name}  시트 {len(a_wb.sheetnames)} — {a_wb.sheetnames}")
    print(f"화면설계서 : {d_out.name}  시트 {len(d_wb.sheetnames)} — {d_wb.sheetnames}")
    print(f"EVENT 승계 행 {ev_n} / VALIDATION 제약매트릭스 승계 행 {mx_n}")
