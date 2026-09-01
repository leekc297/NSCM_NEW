# -*- coding: utf-8 -*-
"""DMF0040 UI분석서 v1.0 (10시트 — hook #105 §1-C, 견본 DMF0003 v2.3 구조)"""
import io, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

OUT = r"C:\Projects\NSCM\Doc\화면분석서\DMF0040_MktFcstComparison_UI분석서_v1.0.xlsx"
H = Font(bold=True, size=12)
HD = Font(bold=True, color="FFFFFF")
FILL = PatternFill("solid", fgColor="4472C4")
THIN = Border(*[Side(style="thin")] * 4)
WRAP = Alignment(vertical="top", wrap_text=True)

wb = openpyxl.Workbook()
wb.remove(wb.active)


def sheet(title, widths):
    ws = wb.create_sheet(title)
    for i, w in enumerate(widths, 1):
        ws.column_dimensions[openpyxl.utils.get_column_letter(i)].width = w
    return ws


def put(ws, row, vals, header=False, title=False):
    for i, v in enumerate(vals, 1):
        c = ws.cell(row=row, column=i, value=v)
        c.alignment = WRAP
        c.border = THIN
        if header:
            c.font = HD
            c.fill = FILL
        if title:
            c.font = H
            c.border = Border()
    return row + 1


# 1.개요
ws = sheet("1.개요", [22, 60, 40])
r = put(ws, 1, ["DMF0040 (MKT FCST Comparison) — UI분석서 v1.0"], title=True)
for k, v in [
    ("작성", "2026-08-26 (hook #105 §1-C 10시트 신표준 — 선행 md 3종 + Figma 영역 매핑표 완비 후 작성)"),
    ("AS-IS 정본", r"GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.cs 1,875행 (+Designer 1,502행) — coverage DM.csv: Forms.UIL=todo / Plan.UIL=gone"),
    ("화면 성격", "읽기 전용 조회·비교 리포트 — MKT FCST 버전(최대 2) 간 Waterfall 비교. Insert/Delete/Save 빈 구현·EditButton=MSG00109·조회 후 전열 잠금"),
    ("메뉴", "Demand > Demand_Waterfall > DMF0040 (MNU00046 'MKT FCST Comparison', ROUTE_PATH demand/demand-waterfall/dmf0040)"),
    ("전용 SP", "PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON (18 IN + O_RC1/O_RESULT_CURSOR, VALID) / DMF0040_GET_SPREAD_TITLE (standalone 461행 — PKG 미편입)"),
    ("전용 팝업", "DMF0000_VersionByWaterfallPopup (368행 — 버전 다중선택 최대 2)"),
    ("분모", "이벤트 22 · validation 17 · expressions 5(SUM 스팬) · 직접 SP 13 · 팝업 6클래스 7개소"),
    ("선행 산출물", "주요이벤트_상세분석.md (E01~E22) / 제약매트릭스_상세.md (A/D/G/P 19행) / Cascade_Filter_전수.md / _figma/screens/DMF0040.md 영역 매핑표"),
    ("TO-BE 프로비저닝", "메뉴·그룹권한 4·SHEET_COLUMNS 48(Mkt Fcst Waterfall)·PKG VALID 준비 / SHEET_MEASURE·BTN·PROC_M·API_M·CMBO 0행 = 신규 시딩"),
    ("UI Category Setup 방침", "사용자 지시(2026-08-26): 지식사전(_rules_v2/_dictionary) 기반 + DIVISION 별 설정 — division 값 원천은 언제나 AS-IS (hook #142 §3.5)"),
]:
    r = put(ws, r, [k, v, ""])

# 2.전체흐름
ws = sheet("2.전체흐름", [8, 28, 60, 30])
r = put(ws, 1, ["2. 전체흐름 — DM 프로세스 내 위치"], title=True)
r = put(ws, r, ["단계", "프로세스", "설명", "본 화면 위치"], header=True)
flow = [
    ("1", "기준정보", "Division/Site/Item/Project 마스터 정비", ""),
    ("2", "수요예측 입력", "MKT FCST 입력 (DMF0003/DMF0082) — 버전 생성의 원천", ""),
    ("3", "판매계획", "Sales Plan 수립 (DMF0021)", ""),
    ("4", "Cutoff", "주기 Cutoff 로 버전(MF_D/MF_W/MF_M) 확정 — DM_MST_VERSION", "* 비교 대상 버전의 생성 지점"),
    ("5", "사업계획·I/F", "Biz Plan·Waterfall 리포트 (DMF0035/DMF0040/DMF0053)", "** 본 화면 — 확정 버전 최대 2개를 기간 축으로 비교(Difference 행), 실적 구간 회색"),
    ("6", "배치·정리", "이력·정리 배치", ""),
]
for row in flow:
    r = put(ws, r, list(row))
r = put(ws, r + 1, ["조회 흐름", "", "Division·기간·버전(기본=최근 MF_W 2개) 선택 → SPREAD_TITLE 로 월>주>일 3단 동적 헤더 구성 → 메인 SP 1회 조회 → 버전×Measure 행 비교 + SUM 집계 + 헤더 더블클릭 드릴다운(M_→W_→D_)", ""])

# 3.VALIDATION취합
ws = sheet("3.VALIDATION취합", [10, 14, 30, 44, 14, 30, 22])
r = put(ws, 1, ["VALIDATION 취합 — SOURCE = 제약매트릭스_상세.md (19행 = validation.md 17 + analysis.md §16 잔여 2)"], title=True)
r = put(ws, r, ["ID", "구분", "위치 (라인)", "조건·동작", "MSG", "TO-BE 매핑", "비고"], header=True)
vals = [
    ("A-01", "조회 사전검증", "FindData L671~677", "필수 3종(Division*/Period*/Version*) 후 division 빈값이면 차단", "MSG00097", "handleSubmit V1", ""),
    ("A-02", "조회 사전검증", "FindData L680~685", "기간 역전(from>to) 차단", "MSG00108", "V2", ""),
    ("A-03", "조회 사전검증", "FindData L687~695", "2년 초과 시 알림 + 종료일을 시작일+2년으로 자동 보정 후 차단", "MSG00164", "V3 (보정까지 파리티)", "문구는 3년 — 로직은 2년. 공용 MSG 정정은 별도 결정"),
    ("D-01", "Division 분기", "InitControls L293", "division 존재 시에만 하위 콤보 적재", "", "cascade 가드", ""),
    ("D-02", "Division 분기", "InitControls L295", "81 계열·82 vs 40 — EndCustomer 파라미터 축 상이", "", "CMBO 파라미터 분기", ""),
    ("D-03", "Division 분기", "FindData L671", "division 빈값 분기 (A-01 축)", "", "V1", ""),
    ("D-04", "Division 분기", "cboDivision L968", "40: Project·Plant Site 라벨/버튼 Disable (81·82: Enable)", "", "division 반응형 disabled", ""),
    ("D-05", "Division 분기", "clbTeam L1051", "division prefix 존재 가드", "", "cascade 가드", ""),
    ("D-06", "Division 분기", "clbTeam L1053", "81 계열·82 vs 40 — Customer/SalesSite 재적재 파라미터 상이", "", "CMBO 파라미터 분기", ""),
    ("D-07", "Division 분기", "clbCustomer L1090", "division 존재 가드", "", "cascade 가드", ""),
    ("D-08", "Division 분기", "clbCustomer L1092", "81 계열·82 vs 40 — SalesSite 파라미터 상이", "", "CMBO 파라미터 분기", ""),
    ("D-09", "Division 분기", "spdMain_ComboSelChange L1164", "그리드 Division 셀 변경 시 행 콤보 재적재", "", "제외 — Insert 전제 사문 (읽기 전용)", ""),
    ("D-10", "Division 분기", "fnValidation L1439", "Insert 행 9키 중복 검사", "", "제외 — Insert 전제 사문", ""),
    ("G-01", "입력검증", "txtVersion_KeyDown L1657", "Version 직접 타이핑 차단 — 키 입력 = 버전 팝업 오픈", "", "readOnly + 클릭/키 → 모달", "validation.md #14"),
    ("G-02", "사전분기", "GetThisWeekMonday L1671", "월요일 역산 (Current 실적 경계)", "", "회색 경계 util", ""),
    ("G-03", "사전분기", "GetLastWeekSunDayByDate L1694", "Cutoff 버전 전주 일요일 역산", "", "동일 util", ""),
    ("G-04", "사전분기", "SetAmountCalculating L1748", "QTY index 0 = 원본 복원 후 종료", "", "스케일 전환 가드", ""),
    ("P-01", "권한·모드", "EditButton L588~595", "편집 시도 = 읽기전용 통보", "MSG00109", "편집 진입점 미노출 — 제외(사유)", ""),
    ("P-02", "버전 제약", "btnVersion_Click L1652~1660", "선택 버전 3개 이상 차단", "MSG00255", "Version 모달 반환부 검사", ""),
    ("P-03", "버전 제약(모달)", "팝업 SetItem L318~324", "OK 시 선택 2개 초과 차단(선택 초기화)", "MSG00255", "모달 내부 차단", "MODAL 축 — 대사표 MODAL 행"),
]
for row in vals:
    r = put(ws, r, list(row))

# 4.MATRIX_Division
ws = sheet("4.MATRIX_Division", [26, 34, 34, 34, 30])
r = put(ws, 1, ["MATRIX — Division 별 제약·동작 (실측: 40 / 81 계열(81, 81_UC, 81_HD, 81_HG, 81_HM, 81_ST) / 82)"], title=True)
r = put(ws, r, ["축", "40", "81 계열", "82", "근거"], header=True)
mtx = [
    ("Project 조회조건", "Disable (라벨·버튼 비활성)", "Enable", "Enable", "cboDivision L968~ (D-04)"),
    ("Plant Site 조회조건", "Disable", "Enable", "Enable", "동일"),
    ("End Customer 콤보 파라미터", "division+team(콤보 원값)", "division+team(코드 변환값)", "81 과 동일", "InitControls L295·clbTeam L1053 (D-02/06)"),
    ("Sales Site 콤보 파라미터", "division+team+customer", "division+빈값+customer", "81 과 동일", "clbCustomer L1092 (D-08)"),
    ("Cell Qty 체크박스", "Enabled=true (layout 항상 숨김)", "동일 숨김", "동일", "layoutControlItem10 Never = 화면 미노출 → TO-BE 제외"),
    ("메인 SP division 파라미터", "단일 division 코드", "단일 (81 계열 개별)", "단일", "FindData p_division_id"),
    ("편집 가능 여부", "없음 (읽기 전용)", "없음", "없음", "전 division 조회 전용"),
]
for row in mtx:
    r = put(ws, r, list(row))

# 5.MATRIX_권한
ws = sheet("5.MATRIX_권한", [24, 14, 14, 14, 16, 46])
r = put(ws, 1, ["MATRIX — 권한 그룹 별 기능 (TO-BE SCM_ADM_USER_GR_MNU_MPG_M 실측 4그룹 — 2026-08-26)"], title=True)
r = put(ws, r, ["기능", "ADMIN", "DM ADMIN", "DM Viewer", "SCP Planner", "비고"], header=True)
auth = [
    ("메뉴 접근", "Y", "Y", "Y", "Y", "TO-BE 실측 4행 (SYSADMIN 2026-02-09 + SCP admin 2026-07-27)"),
    ("조회 (SEARCH)", "Y", "Y", "Y", "Y", "읽기 전용 화면 — 전 그룹 동일"),
    ("Excel Download", "Y", "Y", "Y", "Y", "FE 다운로드 (UC-05 콤보 Name)"),
    ("Column/Measure 개인화", "Y", "Y", "Y", "Y", "titleSet 축 (개인화 — 전 그룹)"),
    ("편집 (I/U/D/S)", "-", "-", "-", "-", "화면 자체 미보유 (AS-IS 빈 구현)"),
    ("TO-BE 버튼 배선(신규 시딩)", "", "", "", "", "시트 'Mkt Fcst Waterfall': SEARCH + spreadTitle:SEARCH + titleSet:SEARCH/SAVE + version:SEARCH — SAVE/INSERT 계열 없음"),
]
for row in auth:
    r = put(ws, r, list(row))

# 6.MATRIX_Measure
ws = sheet("6.MATRIX_Measure", [26, 62, 36])
r = put(ws, 1, ["MATRIX — Measure 축 (AS-IS 는 DMF0035 와 공유)"], title=True)
r = put(ws, r, ["축", "실측", "TO-BE 방침"], header=True)
meas = [
    ("Measure 개인화 원천", "btnMeasure L1350: DM0002_TitleSetForm_Popup(PROGRAM_ID='DMF0035', SHEET='Mkt Fcst Waterfall', 메저모드) — 컬럼(btnColumn)은 'DMF0040'", "MeasureSelectModal(master 정본) 파라미터 = 시딩 방침에 따름"),
    ("TO-BE SHEET_MEASURE 현황", "DMF0040 = 0행 / DMF0035 = 49행 (동일 SHEET_NAME 'Mkt Fcst Waterfall')", "DMF0040 축 신규 시딩 — DMF0035 49행을 원천 참조하되 division 값·목록은 AS-IS 실측(TITLESET_USER 141행 + SP 산출 Measure)으로 확정 (hook #142 §3.5 — TO-BE 끼리 무검증 복제 금지)"),
    ("Measure 표시 행", "메인 SP 가 버전×Measure 행 생성 (MEASURE_GROUP/MEASURE) + Difference 파생 행 (글자 Blue)", "SP 산출 그대로 표시 (읽기 전용)"),
    ("사전 대조", "지식사전 03_sheet_measures.md (494종) 에서 'Mkt Fcst Waterfall' 시트 축 대조", "confidence low/none 항목 채택 금지 — Phase 5 시딩 시 대조표 산출"),
]
for row in meas:
    r = put(ws, r, list(row))

# 7.MATRIX_Bucket_Version
ws = sheet("7.MATRIX_Bucket_Version", [22, 26, 22, 22, 42])
r = put(ws, 1, ["MATRIX — Bucket x 컬럼 가시성 / Version 제약 (읽기 전용 — FCST_TYPE 입력 제약 없음, 화면 실측 축으로 구성)"], title=True)
r = put(ws, r, ["Bucket", "D_ (일)", "W_ (주)", "M_ (월)", "비고"], header=True)
bkt = [
    ("DAILY", "표시", "Sum 체크 시", "Sum 체크 시", "SetSpreadColumn L1373~"),
    ("WEEKLY", "숨김", "표시", "Sum 체크 시", ""),
    ("MONTHLY (기본)", "숨김", "숨김", "표시", "DefineProperty L370 기본값"),
    ("ONLY_WEEKLY", "-", "표시 (단순 3단)", "-", "chkSum 비활성·SetSpreadHeader 경로 (L391~396)"),
]
for row in bkt:
    r = put(ws, r, list(row))
r = put(ws, r + 1, ["Version 축", "", "", "", ""], header=True)
for row in [
    ("기본값", "최근 MF_W 2개 (Current 제외)", "", "", "GetDefaultVersion L1832~1875 — division 변경 시 재세팅"),
    ("선택 상한", "최대 2개 (초과 MSG00255)", "", "", "모달 내부(P-03) + 반환부(P-02) 이중"),
    ("버전 타입", "MF_D / MF_W / MF_M (모달 체크박스 조합)", "", "", "부모 code=MF 고정"),
    ("실적 회색 경계", "Current/빈값 = min(전주 일요일, 조회말일) / Cutoff = 버전명 내 날짜의 전주 일요일", "", "", "FindData L774~886 — ONLY_WEEKLY 는 W_ 키, 그 외 D_ 키·해당 M_ 은 White 예외"),
]:
    r = put(ws, r, list(row))

# 8.가시성_LAYER종속
ws = sheet("8.가시성_LAYER종속", [26, 52, 40])
r = put(ws, 1, ["객체 가시성 · 컨테이너 LAYER 종속"], title=True)
r = put(ws, r, ["객체", "가시성 규칙", "근거"], header=True)
vis = [
    ("cboCellQty (Cell Qty)", "항상 숨김 — layoutControlItem10 Visibility=Never", "InitControls L322 → TO-BE 제외"),
    ("chkSum", "ONLY_WEEKLY 에서 비활성+해제 / 그 외 활성", "InitSpread L391~397"),
    ("B_ 접두 동적 컬럼", "항상 숨김 (SPREAD_TITLE 산출 중 B_ 토큰)", "SetSpreadHeaderSpan L507"),
    ("D_/W_/M_ 동적 컬럼", "Bucket x Sum 매트릭스 (7시트) + 헤더 더블클릭 드릴다운 토글", "SetSpreadColumn·CellDoubleClick"),
    ("DAY_CODE SAT/SUN 헤더", "글자색 Blue/Red", "SetSpreadHeaderSpan L517"),
    ("실적 구간 셀", "배경 Gainsboro (행별 Version 경계까지) — 해당 월 SUM 은 White 예외", "FindData L774~886"),
    ("Measure=Difference 행", "데이터 영역 글자 Blue", "FindData L889~893"),
    ("좌측 차원 컬럼", "Freeze(Measure 컬럼까지) + 세로 SmartColMerge", "SetSpreadHeader(Span)·TopChange"),
    ("Footer Sum", "ColumnFooter Sum — D_/W_/M_ SumIgnoreHidden 집계 (LightGray)", "InitSpreadFooterSum L406~424"),
]
for row in vis:
    r = put(ws, r, list(row))

# 9.SP_LOOKUP_콤보
ws = sheet("9.SP_LOOKUP_콤보", [36, 72, 42])
r = put(ws, 1, ["SP 매핑 · LOOKUP · 콤보 (직접 호출 13 전수 — source_links.md v3 = .cs 실측 일치)"], title=True)
r = put(ws, r, ["AS-IS Endpoint", "용도·파라미터", "TO-BE 매핑"], header=True)
sps = [
    ("DM.DMF0040_GET_MKT_FCST_COMPARISON", "메인 조회 16p (division/site/plant/team/customer/bizType/project/item/from/to/createdBy/version(콤마 최대2)/itemType/owner/diffOnly(bool)/bucket) — Timeout 30분", "PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON (18 IN — +p_user_id/p_menu_id, VALID 기변환) — PROC_M/API_M 신규 배선"),
    ("DM.DMF0040_GET_SPREAD_TITLE", "동적 헤더 5p (start/end/createdBy/division/bucket)", "standalone 461행 — PKG 편입 여부 Phase 5 결정 (UI별 PKG 원칙) 후 spreadTitle:SEARCH 배선"),
    ("SCM.SCM0001_GET_DIVISION (실사용 MyDivision InnerTable)", "Division 콤보 (그룹·사용자 필터)", "기존 공용 CMBO Division 계열 실측 재사용 (미등록 시 신규)"),
    ("(InnerTable) UserTeamByDivision", "Team 콤보", "기존 CMBO 실측 재사용 (forecast-price 계열 공유)"),
    ("(InnerTable) EndCustomerByDivision", "End Customer (division+team, D-02 분기)", "동일"),
    ("(InnerTable) BizType", "Biz Type", "동일"),
    ("(InnerTable) UserSiteByEndCustomer", "Sales Site (D-06/08 분기)", "동일"),
    ("(InnerTable) UserPlantSiteByDivision", "Plant Site", "동일"),
    ("DM.PR_GET_DAY_RANGE (p_month=6)", "기본 조회구간 (당월 1일~6개월 말일) — 2번째 커서", "공용 SP 재사용 (기존 TO-BE 이관분 실측)"),
    ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE", "Bucket 콤보 (DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY)", "DMF0003 공유 콤보 실측 재사용"),
    ("DM.DMF0003_GET_QTY_TYPE_CODE", "QTY 스케일 콤보", "동일"),
    ("SCM.SCM0001_GET_LOOKUP_VALUES(ITEM_TYPE_CODE)", "Item Type 콤보", "공용 룩업 콤보 재사용"),
    ("DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP", "버전 목록 6p — 기본버전 세팅(E22-b)+버전 모달", "TO-BE SP 실측 후 배선 (DMF0035 TO-BE 기이관 여부 확인) — version:SEARCH"),
    ("팝업 내부 SP (공용 모달 담당)", "TitleSet GET/SET·Owner·Project/Item by Division 등 8계열 (매트릭스 21건 중 직접 13 제외분)", "master 공용 모달이 자체 배선 — 본 화면 배선 대상 아님"),
]
for row in sps:
    r = put(ws, r, list(row))

# 10.이전소스_차이점
ws = sheet("10.이전소스_차이점", [24, 46, 44, 30])
r = put(ws, 1, ["이전 소스 대비 차이점 — AS-IS 실측 (Forms.UIL 정본 vs Plan.UIL 레거시 + 판정 근거)"], title=True)
r = put(ws, r, ["축", "Forms.UIL (정본 1,875행)", "Plan.UIL (레거시 1,824행)", "판정"], header=True)
for row in [
    ("coverage 판정", "todo (전환 대상)", "gone (AS-IS 원본에서 소멸 2026-08-20)", "Forms.UIL = 정본"),
    ("차이 내용", "헤더 변경이력 주석 + ExcelButton 속도개선([E20241004-000997] SimpleExcelExport)", "ExcelButton 없음 (base 기본)", "로직 동일·라인 -51 offset"),
    ("Designer", "1,502행", "동일 (해시 일치)", "차이 없음"),
    ("TO-BE 적용", "Excel 다운로드 = 공용 DataGrid Excel (HideZero·소수3자리 옵션 참고)", "", ""),
    ("orphan SP", "JJG_ORI_DMF0040_GET_MKT_FCST_COMPARISON (1,197줄·38p) = 구버전 백업 — 전환 대상 아님", "", "02_orphan_sps.md L55"),
    ("TO-BE PKG vs standalone", "PKG_DMF0040 (2026-04-06 변환, GT_DM40_* GTT) 정본 / 구 standalone 2본 병존 (GT_GMFC_* 계보)", "", "배선 = PKG 정본"),
]:
    r = put(ws, r, list(row))

wb.save(OUT)
print("저장:", OUT)

wb2 = openpyxl.load_workbook(OUT, read_only=True)
names = wb2.sheetnames
assert len(names) == 10, names
counts = {}
for wsx in wb2.worksheets:
    n = sum(1 for row in wsx.iter_rows(values_only=True) if any(c not in (None, "") for c in row))
    counts[wsx.title] = n
wb2.close()
print("시트 10 OK:", names)
print("행 카운트:", counts)
print("VALIDATION 데이터 행(제목·헤더 제외):", counts["3.VALIDATION취합"] - 2, "(기대 20 = A3+D10+G4+P3)")
