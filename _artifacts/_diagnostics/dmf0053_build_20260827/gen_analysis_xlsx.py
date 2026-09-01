# -*- coding: utf-8 -*-
"""DMF0053 UI분석서 v1.0 (10시트 — hook #105 §1-C, DMF0040 생성기 계보)"""
import io, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

OUT = r"C:\Projects\NSCM\Doc\화면분석서\DMF0053_CustFcstWaterfall_UI분석서_v1.0.xlsx"
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
r = put(ws, 1, ["DMF0053 (Customer FCST Waterfall) — UI분석서 v1.0"], title=True)
for k, v in [
    ("작성", "2026-08-27 (hook #105 §1-C 10시트 — 선행 md 3종 + Figma 영역 매핑표 완비 후 작성)"),
    ("AS-IS 정본", r"GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.cs 1,822행 (+Designer 1,611행) — Forms.UIL 판 정본(ExcelButton E20241004-000997 포함). Plan.UIL 1,790행=구판(source_links.md 가 구판 경로 지시 — 정정)"),
    ("화면 성격", "읽기 전용 조회 리포트 — Customer FCST(EDI 포함) Waterfall. Insert/Delete/Save 주석 처리·EditButton=MSG00109·조회 후 전열 잠금·Excel 은 다운로드만"),
    ("메뉴", "Demand > Demand_Waterfall > DMF0053 (MNU00048 'Customer FCST Waterfall', ROUTE_PATH demand/demand-waterfall/dmf0053 — 라이브 DB 실측. Figma 브레드크럼 Report 는 디자인 참조 only)"),
    ("전용 SP", "PKG_DMF0053 (VALID, BODY 1,151행 — 2026-08-24 정비판): P_DMF0053_GET_CUST_FCST_WATERFALL (21 IN + O_RC1~3) / P_DMF0053_GET_SPREAD_TITLE (7 IN + O_RC1). GTT 9본"),
    ("팝업", "검색 3(ProjectEx/ItemEx/Owner → master 공용 모달) + TitleSet 2(공용 Column/Measure 모달) + 제외 3(Version 'CF' 숨김 / 셀 더블클릭 Project·Item = dead path)"),
    ("분모", "이벤트 핸들러 23 (사문 5 포함) · validation 18 · expressions 5(SUM 스팬) · 직접 Endpoint 12 + InnerTable 6 · 팝업 7클래스 8개소"),
    ("선행 산출물", "주요이벤트_상세분석.md (E01~E23) / 제약매트릭스_상세.md (A6+B10+C2+D1) / Cascade_Filter_전수.md (17행 조회조건+모달 4영역) / _figma/screens/DMF0053.md 영역 매핑표"),
    ("TO-BE 프로비저닝", "메뉴·그룹권한 4(ADMIN/DM ADMIN/DM Planner/DM Viewer — ⚠ DMF0040 과 달리 DM Planner 포함)·SHEET_COLUMNS 66(CUST Fcst Waterfall)·SHEET_MEASURE 2(CUST_FCST/CUST_FCST_EDI)·PKG VALID / API_M·PROC_M·BTN·그룹버튼권한 0행 = 신규 시딩"),
    ("조회조건 방침", "#112 카탈로그 'Customer FCST Waterfall' 17행 전 행 대조 (Div./Biz. Type/PJT/Model/Nickname 명칭 변경·QTY/Sum=Figma 실존이라 구현·Version 칸=카탈로그·Figma 부재+AS-IS 숨김 → 미구현)"),
]:
    r = put(ws, r, [k, v, ""])

# 2.전체흐름
ws = sheet("2.전체흐름", [8, 28, 60, 30])
r = put(ws, 1, ["2. 전체흐름 — DM 프로세스 내 위치"], title=True)
r = put(ws, r, ["단계", "프로세스", "설명", "본 화면 위치"], header=True)
for row in [
    ("1", "기준정보", "Division/Site/Item/Project 마스터 정비", ""),
    ("2", "EDI 수신", "고객 EDI CALLOFF 수신 (DM_DNM_EDI_CALLOFF_ITEM) — Customer FCST 원천", "* 원천 데이터 생성 지점"),
    ("3", "Customer FCST 적재", "Customer FCST 원장 (DM_PLN_CUST_FCST_H) + Upload (DMF0014)", "* 비교 원장"),
    ("4", "수요계획", "MKT FCST/Sales Plan (DMF0003/0021/0082)", ""),
    ("5", "Waterfall 리포트", "Waterfall 계열 (DMF0035/DMF0040/DMF0053)", "** 본 화면 — Customer FCST vs EDI 를 기간 축(M>W>D 3단)으로 표시, Input Date(적재일) 축 필터 보유"),
    ("6", "배치·정리", "이력·정리 배치", ""),
]:
    r = put(ws, r, list(row))
r = put(ws, r + 1, ["조회 흐름", "", "Division·기간(Period 6개월/Input Date 1개월 기본)·Bucket 선택 → SPREAD_TITLE 로 월>주>일 3단 동적 헤더 → 메인 SP 21p 1회 조회 → Measure(Cust. FCST/EDI) 행 표시 + SUM 집계 + 헤더 더블클릭 드릴다운 + O_RC3 DATA_ORDER 로 클라 정렬", ""])

# 3.VALIDATION취합
ws = sheet("3.VALIDATION취합", [10, 14, 30, 44, 14, 30, 22])
r = put(ws, 1, ["VALIDATION 취합 — SOURCE = 제약매트릭스_상세.md (A6+B10+C2+D1 = 분모 18 + EditButton)"], title=True)
r = put(ws, r, ["ID", "구분", "위치 (라인)", "조건·동작", "MSG", "TO-BE 매핑", "비고"], header=True)
for row in [
    ("A-01", "조회 사전검증", "FindData L677~682", "Division 미선택 차단", "MSG00097", "handleSubmit V1", "실문구 'Division 을 선택하세요.' (DB=locales 일치)"),
    ("A-02", "조회 사전검증", "FindData L686~690", "Period 역전(from>to) 차단", "MSG00108", "V2", "'조회 기간이 잘못되었습니다 (시작일 > 종료일).'"),
    ("A-03", "조회 사전검증", "FindData L692~699", "Period 3년 초과 — 알림+to=from+3년 보정 후 중단", "MSG00164", "V3", "'조회 기간은 3년 이내로…' — 문구·로직 3년 정합"),
    ("A-04", "조회 사전검증", "FindData L701~707", "Input Date 역전 차단", "MSG00108", "V4", ""),
    ("A-05", "조회 사전검증", "FindData L709~716", "Input Date 3년 초과 — 보정 후 중단", "MSG00164", "V5", ""),
    ("A-06", "권한·모드", "EditButton L587~594", "편집 시도 = 읽기전용 통보", "MSG00109", "제외 — 편집 진입점 미노출 (hotkeyConfig false)", ""),
    ("B-01", "Division 분기", "InitControls L286", "81*(접두)/82 초기 Customer 적재 경로", "", "초기 cascade", ""),
    ("B-02", "Division 분기", "FindData L677", "division 빈값 분기 (A-01 전제)", "", "V1", ""),
    ("B-03", "Division 분기", "cboDivision L949", "division null 가드", "", "cascade 가드", ""),
    ("B-04", "Division 분기", "cboDivision L951~983", "81*/82: PJT·Plant Site·검색버튼 활성 / 40: 비활성", "", "isProjectEnabled — ⚠ DMF0040 과 반대", ""),
    ("B-05", "Division 분기", "clbTeam L1035", "division 가드", "", "cascade 가드", ""),
    ("B-06", "Division 분기", "clbTeam L1037~1060", "81*/82: SalesSite team 미전달 / 40: 전달", "", "CMBO 파라미터 분기", ""),
    ("B-07", "Division 분기", "clbCustomer L1072", "division 가드", "", "cascade 가드", ""),
    ("B-08", "Division 분기", "clbCustomer L1074~1087", "81*/82 vs 40 SalesSite 파라미터 분기", "", "CMBO 파라미터 분기", ""),
    ("B-09", "Division 분기", "spdMain_ComboSelChange L1150", "그리드 Division 셀 콤보 재설정", "", "제외 — dead path (전열 잠금·Insert 미노출)", ""),
    ("B-10", "Division 분기", "fnValidation L1462", "Insert 행 9키 중복 검사", "", "제외 — dead code (저장 경로 없음)", ""),
    ("C-01", "사전분기", "GetLastWeekSunDayByDate L1691", "전주 일요일 역산", "", "제외 — 소비처(실적 회색) 전부 주석", ""),
    ("C-02", "사전분기", "SetAmountCalculating L1744", "QTY index 0 = 원본 복원", "", "QTY 스케일 가드", ""),
    ("D-01", "입력검증", "txtVersion_KeyDown L1676", "키 입력 = Version 팝업", "", "제외 — Version 조회조건 미구현 (Figma·카탈로그 부재+AS-IS 숨김)", ""),
]:
    r = put(ws, r, list(row))

# 4.MATRIX_Division
ws = sheet("4.MATRIX_Division", [26, 34, 34, 34, 30])
r = put(ws, 1, ["MATRIX — Division 별 제약·동작 (40 / 81 계열(81, 81_UC, 81_HM, 81_ST, 81_HD, 81_HG) / 82 — SHEET_COLUMNS DIVISION_ID 토큰 실측 정합)"], title=True)
r = put(ws, r, ["축", "40", "81 계열", "82", "근거"], header=True)
for row in [
    ("PJT 조회조건", "Disable", "Enable", "Enable", "cboDivision L951~983 (B-04) — ⚠ DMF0040 과 반대"),
    ("Plant Site 조회조건", "Disable", "Enable", "Enable", "동일"),
    ("End Customer 콤보", "division+team(콤보 원값)", "division+team(코드 변환값)", "81 동일", "InitControls L286~305 (B-01)"),
    ("Sales Site 콤보", "division+team+customer", "division+''+customer", "81 동일", "clbTeam/clbCustomer (B-06/B-08)"),
    ("81 판정 방식", "-", "Substring(0,2)=='81' 접두 — 81_UC/81_HM/81_ST/81_HD/81_HG 포함", "=='82' 등호", "L951 등"),
    ("전용 컬럼 (SHEET_COLUMNS 실측)", "CUST_GROUP(_DTL)/APPLICATION/ROUTE/MDM_PROJECT_NAME/MIN_CAPACITY/FORECAST_INFO_* 등 40 전용 다수", "CUSTOMER_PLANT/PLANT_SITE_ID/CELL_PER_*/KWH_*/SALES_COMPANY", "ENERGE/CELL_QUANTITY", "PROGRAM_ID='DMF0053' 66행 DIVISION_ID 토큰"),
    ("편집 가능 여부", "없음 (읽기 전용)", "없음", "없음", "전 division 조회 전용"),
]:
    r = put(ws, r, list(row))

# 5.MATRIX_권한
ws = sheet("5.MATRIX_권한", [24, 14, 14, 14, 16, 46])
r = put(ws, 1, ["MATRIX — 권한 그룹 (TO-BE SCM_ADM_USER_GR_MNU_MPG_M 실측 4그룹 — 2026-08-27)"], title=True)
r = put(ws, r, ["기능", "ADMIN", "DM ADMIN", "DM Planner", "DM Viewer", "비고"], header=True)
for row in [
    ("메뉴 접근", "Y", "Y", "Y", "Y", "실측 4행 — ⚠ DMF0040(SCP Planner 포함) 과 로스터 상이"),
    ("조회 (SEARCH)", "Y", "Y", "Y", "Y", "읽기 전용 — 전 그룹 동일"),
    ("Excel Download", "Y", "Y", "Y", "Y", "FE 다운로드 (UC-05)"),
    ("Column/Measure 개인화", "Y", "Y", "Y", "Y", "titleSet 축 (개인화)"),
    ("편집 (I/U/D/S)", "-", "-", "-", "-", "화면 미보유 (AS-IS 주석 처리)"),
    ("TO-BE 버튼 배선(신규 시딩)", "", "", "", "", "custFcstWaterfall:SEARCH + spreadTitle:SEARCH + titleSet:SEARCH/SAVE — 4그룹×4=16 + BTN 4 (Version 배선 없음)"),
]:
    r = put(ws, r, list(row))

# 6.MATRIX_Measure
ws = sheet("6.MATRIX_Measure", [26, 62, 36])
r = put(ws, 1, ["MATRIX — Measure 축"], title=True)
r = put(ws, r, ["축", "실측", "TO-BE 방침"], header=True)
for row in [
    ("TO-BE SHEET_MEASURE", "기시딩 2행: CUST_FCST('Cust. FCST' sort10)/CUST_FCST_EDI('EDI' sort20) — DEFAULT_FLAG=Y·USER_SELECTABLE=Y·DIVISION_ID 전 계열", "재시딩 불요 — AS-IS titleset 'M' 실사용과 대조만 (Phase 5)"),
    ("SP 산출 Measure", "GT_DMF0053_SELECT_MEASURE 적재 (BODY L384~) — 'Immidiate' 등 표시 변환 CASE (L431·L926 'Customer FCST') 는 R 스모크에서 실측 확정", "SP 산출 그대로 표시 (읽기 전용) — 스모크 결과를 대사표에 기록"),
    ("Measure 개인화", "btnMeasure = DM0002_TitleSetForm_Popup('DMF0053', 'CUST Fcst Waterfall', false, division)", "master MeasureSelectModal + titleSet 'M' SAVE (SCM0002_SET_TITLESET_POPUP)"),
    ("MEASURE/MEASURE_GROUP 컬럼", "SHEET_COLUMNS sort 220/230 — VISIBLE_FLAG='N' (표시 축 아님·행 축)", "그리드 좌측 고정 차원으로 SP 커서가 반환"),
]:
    r = put(ws, r, list(row))

# 7.MATRIX_Bucket
ws = sheet("7.MATRIX_Bucket", [22, 26, 22, 22, 42])
r = put(ws, 1, ["MATRIX — Bucket x 컬럼 가시성 (Version 축 없음 — DMF0040 과의 차이)"], title=True)
r = put(ws, r, ["Bucket", "D_ (일)", "W_ (주)", "M_ (월)", "비고"], header=True)
for row in [
    ("DAILY", "표시", "Sum 체크 시", "Sum 체크 시", "SetSpreadColumn L1375~"),
    ("WEEKLY", "숨김", "표시", "Sum 체크 시", ""),
    ("MONTHLY (기본)", "숨김", "숨김", "표시", "DefineProperty L374 기본값"),
    ("ONLY_WEEKLY", "-", "표시 (단순 3단)", "-", "chkSum 비활성+해제·SetSpreadHeader 경로 (L394~398)"),
]:
    r = put(ws, r, list(row))
r = put(ws, r + 1, ["기간 축", "", "", "", ""], header=True)
for row in [
    ("Period 기본값", "당월 1일~6개월 말일", "", "", "PR_GET_DAY_RANGE p_month=6 (L1544)"),
    ("Input Date 기본값", "당월 1일~1개월 말일", "", "", "동일 SP p_month=1 (L1548)"),
    ("기간 상한", "각각 3년 (초과 시 보정)", "", "", "A-03/A-05"),
    ("Version 축", "미구현 — versionNo='' 고정", "", "", "btnVersion 숨김+카탈로그·Figma 부재 (E21/E22)"),
]:
    r = put(ws, r, list(row))

# 8.가시성_LAYER종속
ws = sheet("8.가시성_LAYER종속", [26, 52, 40])
r = put(ws, 1, ["객체 가시성 · 컨테이너 LAYER 종속"], title=True)
r = put(ws, r, ["객체", "가시성 규칙", "근거"], header=True)
for row in [
    ("btnVersion + txtVersion(Date*)", "AS-IS: 버튼 숨김(Visible=false)+텍스트 노출 / TO-BE: 칸 자체 미구현", "Designer L348 + Figma·카탈로그 부재"),
    ("PJT·Plant Site (+검색버튼)", "40 = Disable / 81*·82 = Enable", "B-04"),
    ("chkSum", "ONLY_WEEKLY 에서 비활성+해제 / 그 외 활성", "InitSpread L394~398"),
    ("B_ 접두 동적 컬럼", "항상 숨김 (SPREAD_TITLE 산출 중 B_ 토큰)", "SetSpreadHeaderSpan L499~502"),
    ("D_/W_/M_ 동적 컬럼", "Bucket x Sum 매트릭스 (7시트) + 헤더 더블클릭 드릴다운", "SetSpreadColumn·CellDoubleClick"),
    ("DAY_CODE SAT/SUN 헤더", "글자색 Blue/Red (Daily 3단 헤더 row2)", "SetSpreadHeaderSpan L512~516"),
    ("실적 회색", "없음 — AS-IS 로직 전부 주석 (chkColor 도 미배선 사문)", "L811~903 주석 — ⚠ DMF0040 과 차이"),
    ("좌측 차원 컬럼", "Freeze(Measure 까지) + 세로 SmartColMerge", "SetSpreadHeaderSpan L553~554"),
    ("Footer Sum", "ColumnFooter 'Sum' — D_/W_/M_ SumIgnoreHidden (LightGray)", "InitSpreadFooterSum L414~431"),
    ("MEASURE 그룹/행", "MEASURE_GROUP+MEASURE 좌측 축 — 세로 머지", "DefColumns L105~106"),
]:
    r = put(ws, r, list(row))

# 9.SP_LOOKUP_콤보
ws = sheet("9.SP_LOOKUP_콤보", [36, 72, 42])
r = put(ws, 1, ["SP 매핑 · LOOKUP · 콤보 (직접 Endpoint 12 + InnerTable 6 전수)"], title=True)
r = put(ws, r, ["AS-IS Endpoint", "용도·파라미터", "TO-BE 매핑"], header=True)
for row in [
    ("DM.DMF0053_GET_CUST_FCST_WATERFALL", "메인 조회 19p (division/dept/endCustomer/scmSite/project/item/itemType/from/to/createdBy/plantSite/bizType/owner/version/bucket/userDeptId/groupId/fromCreate/toCreate) — Timeout 10분", "PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL (21 IN — +p_user_id/p_menu_id) — API_M/PROC_M 신규 배선"),
    ("DM.DMF0053_GET_SPREAD_TITLE", "동적 헤더 5p (start/end/createdBy/division/bucket)", "PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE (7 IN — PKG 기편입, DMF0040 의 standalone 결정과 달리 PKG 정본) — spreadTitle:SEARCH"),
    ("(InnerTable) MyDivision", "Division 콤보 (그룹·사용자)", "master DivisionField 기존 CMBO 재사용"),
    ("(InnerTable) UserTeamByDivision", "Team", "TeamField 재사용"),
    ("(InnerTable) EndCustomerByDivision", "End Customer (division+team)", "EndCustomerField 재사용"),
    ("(InnerTable) BizType", "Biz Type", "BizTypeField 재사용"),
    ("(InnerTable) UserSiteByEndCustomer", "Sales Site (B-06/08 분기)", "SalesSiteField 재사용"),
    ("(InnerTable) UserPlantSiteByDivision", "Plant Site", "PlantSiteField 재사용"),
    ("DM.PR_GET_DAY_RANGE (p_month=6/1)", "Period·Input Date 기본값 — 2번째 커서", "공용 SP 재사용 (DMF0040 배선 실측 계보)"),
    ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE", "Bucket 콤보 (DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY)", "DMF0003 공유 콤보 재사용"),
    ("DM.DMF0003_GET_QTY_TYPE_CODE", "QTY 스케일 콤보 (1/1,000/1,000,000/100,000,000)", "동일"),
    ("SCM.SCM0001_GET_LOOKUP_VALUES(ITEM_TYPE_CODE)", "Item Type 콤보", "공용 룩업 재사용"),
    ("SCM.SCM0001_GET_DIVISION 외 미사용 헬퍼 4종", "GetDivision/GetTeambyDivision/GetCustomerbyDivision/GetBizTypebyDivision — 정의만 있고 InnerTable 로 대체된 잔재 (GetScmSitebyDivision/GetPlantSitebyEndCustomer 는 dead path E10 전용)", "제외 — 사문"),
    ("팝업 내부 SP", "TitleSet GET/SET·Owner/Project/Item by Division — 공용 모달 담당", "master 공용 모달 자체 배선 (본 화면 배선 대상 아님)"),
]:
    r = put(ws, r, list(row))

# 10.이전소스_차이점
ws = sheet("10.이전소스_차이점", [24, 46, 44, 30])
r = put(ws, 1, ["이전 소스 대비 차이점 + DMF0040 대비 차이 (동계열 Waterfall)"], title=True)
r = put(ws, r, ["축", "Forms.UIL (정본 1,822행)", "Plan.UIL (구판 1,790행)", "판정"], header=True)
for row in [
    ("차이 내용", "헤더 이력 주석 + ExcelButton 속도개선([E20241004-000997] SimplexelService.ExportFpSpread)", "ExcelButton 없음", "Forms.UIL = 정본 (+32행)"),
    ("Designer", "1,611행", "바이트 동일 (105,086B)", "차이 없음"),
    ("TO-BE Excel", "공용 DataGrid Excel Download (UC-05)", "", ""),
]:
    r = put(ws, r, list(row))
r = put(ws, r + 1, ["DMF0040 대비 차이", "", "", ""], header=True)
for row in [
    ("버전 축", "미구현 (btnVersion 숨김·타입 'CF')", "DMF0040: 최대 2 비교·기본 MF_W 2 자동", "단일 원장 waterfall"),
    ("기간 상한", "3년 (문구·로직 정합)", "DMF0040: 2년 (문구 3년 — 불일치 특례)", ""),
    ("Input Date 축", "있음 (CreateDate from/to — 검증 2건 추가)", "없음", ""),
    ("실적 회색", "없음 (AS-IS 주석)", "있음 (boundaryRef 구현)", ""),
    ("Difference 행", "없음", "있음 (Blue)", ""),
    ("PJT/Plant Site 활성", "81*/82 활성·40 비활성", "40 비활성 (동일 방향, 파라미터 상이)", ""),
    ("권한 로스터", "DM Planner 포함 4그룹", "SCP Planner 포함 4그룹", "E2E 로스터 상이"),
    ("검색 팝업", "PJT/Model/Owner 3종 (master 공용 모달)", "동일 계보", ""),
]:
    r = put(ws, r, list(row))

wb.save(OUT)
print("저장:", OUT)
wb2 = openpyxl.load_workbook(OUT, read_only=True)
names = wb2.sheetnames
assert len(names) == 10, names
counts = {w.title: sum(1 for row in w.iter_rows(values_only=True) if any(c not in (None, "") for c in row)) for w in wb2.worksheets}
wb2.close()
print("시트 10 OK:", names)
print("행:", counts)
print("VALIDATION 데이터 행:", counts["3.VALIDATION취합"] - 2, "(기대 19 = A6+B10+C2+D1)")
