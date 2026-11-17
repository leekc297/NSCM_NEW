# SSP0021 Shipment Plan — 단위테스트 케이스

> **근거**: 업무분석서 §4 규칙·§5 데이터 흐름, 화면설계서 §3 컨트롤·§5 액션 명세. 절차 열의 컨트롤명은 화면설계서 §3과 같은 이름을 쓴다.
> **기대결과 원칙**: Fact Pack에서 확인되는 동작만 적었다. 메시지 문구나 판정 기준처럼 확인되지 않은 부분은 "AS-IS 실행 결과와 동일(확인 필요)"로 적었다.
> **제외**: 주석 처리된 호출 1건(320줄)은 테스트 케이스로 만들지 않았다.
> **공통 사전조건**: 시험 계정은 SSP0021 메뉴 권한 보유, 시험 Division 데이터 존재.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0021-001 | 초기화 | 로그인 완료 | 화면을 연다 | — | clbDivision_ID 목록이 구성된다(사용자 그룹 기준) | `Form_Load`, `SSP.SSP0021_GET_SHIPMENT_DIVISION`, `SSP0021_GET_SHIPMENT_DIVISION` |
| TC-SSP0021-002 | 초기화 | 로그인 완료 | 화면을 열고 cboBucketType 목록을 확인한다 | — | Bucket 목록이 구성되고 DAILY/WEEKLY/MONTHLY 값이 있다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0021-003 | 초기화 | 로그인 완료 | 화면을 열고 spdMain 헤더를 확인한다 | — | Shipment Plan 시트 헤더 3행(LARGE/SMALL CLASS Span + SUM)과 날짜 열이 생성된다 | `Form_Load`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, Shipment Plan |
| TC-SSP0021-004 | 초기화 | 로그인 완료 | 화면을 열고 spdDetail 활성 시트를 확인한다 | — | 활성 시트가 Shipment Plan Detail이다(CreateSpread 594줄) | `Form_Load`, Shipment Plan Detail |
| TC-SSP0021-005 | 초기화 | 화면 진입 | drpPeriod에 직접 입력을 시도한다 | 임의 날짜 | drpPeriod가 비활성(Enabled=false)이라 입력할 수 없다 | `Form_Load`, `cboPlanDate_SelectedIndexChanged` |
| TC-SSP0021-006 | 이벤트 | 화면 진입 | clbDivision_ID에서 다른 Division을 고른다 | Division=81 | DIVISION_ID 기준으로 Company 관련 값이 반영된다(반영 대상 확인 필요) | `clbDivision_ID_SelectedIndexChanged` |
| TC-SSP0021-007 | 이벤트 | Division 선택 | clbCompany_ID를 바꾼다 | Company=시험 회사 | clbPlantSite 목록이 갱신되고 spdMain 헤더가 재구성된다. 처리 중 cboPlanDate 변경 이벤트가 연쇄 실행되지 않는다(-= 5933 / += 5937) | `clbCompanyID_SelectedIndexChanged`, `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-008 | 조회(오류) | To-Be From Site API 미등록 또는 SP 오류 상황 | clbCompany_ID를 바꾼다 | Company=시험 회사 | 오류 메시지가 표시되고 화면이 멈추지 않는다. AS-IS FoxQuery 미등록 상태의 동작은 확인 필요 | `clbCompanyID_SelectedIndexChanged`, `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` |
| TC-SSP0021-009 | 이벤트 | Company 선택 | cboPlanDate를 바꾼다 | Plan-date=목록 두 번째 값 | drpPeriod에 FROM_DATE~TO_DATE가 반영되고 spdMain 날짜 열이 다시 생성된다 | `cboPlanDate_SelectedIndexChanged`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-010 | 그리드 | 조회 완료 | cboBucketType을 DAILY로 고른다 | Bucket=DAILY, chkSum 해제 | D_ 열 표시. M_ 열은 chkSum.Checked(false)에 따라 숨김. W_ 열 최종 표시값은 AS-IS 실행 결과와 동일(확인 필요) | `cboBucketType_SelectedIndexChanged`, Shipment Plan |
| TC-SSP0021-011 | 그리드 | 조회 완료 | cboBucketType을 WEEKLY로 고른다 | Bucket=WEEKLY, chkSum 해제 | D_ 숨김, W_ 표시, M_ 숨김 | `cboBucketType_SelectedIndexChanged`, Shipment Plan |
| TC-SSP0021-012 | 그리드 | 조회 완료 | cboBucketType을 MONTHLY로 고른다 | Bucket=MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged`, Shipment Plan |
| TC-SSP0021-013 | 그리드 | 조회 완료, Bucket=WEEKLY | chkSum을 체크한다 | chkSum=체크 | M_ 열이 표시된다(체크 해제 시 숨김) | `chkSum_CheckedChanged`, Shipment Plan |
| TC-SSP0021-014 | 조회 | Division·Company·Plan-date 선택 | 툴바 Find를 누른다 | Division=81, Company=시험 회사, From Site 전체, txtItemId 빈값 | spdMain(Shipment Plan)에 Measure 행·날짜 열 데이터가 표시된다. 표시 컬럼은 Div·From Site·Model·Nick Name·PSI·BOH_TYPE·BOH_QTY·Measure 8개 | FindButton, `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SSP0021_GET_SHIPMENT_PLAN`, Shipment Plan |
| TC-SSP0021-015 | 조회(빈 결과) | 조회조건 선택 | txtItemId에 없는 모델을 넣고 Find를 누른다 | txtItemId=NOTEXIST | spdMain에 데이터 행이 없다. 오류 없이 헤더는 유지된다 | FindButton, `SSP.SSP0021_GET_SHIPMENT_PLAN` |
| TC-SSP0021-016 | 조회(검증) | 화면 진입 | clbCompany_ID 또는 cboPlanDate를 비우고 Find를 누른다 | Company=빈값 | 필수(`*`) 항목 누락 메시지가 표시되고 조회되지 않는다. 메시지 문구는 확인 필요 | FindButton, `SSP.SSP0021_GET_SHIPMENT_PLAN` |
| TC-SSP0021-017 | 그리드 | 조회 완료 | spdMain 날짜 열을 확인한다 | — | 컬럼명에 `B_`가 있는 열은 숨김(너비 0). 그 외는 너비 70 숫자 열. 토요일 헤더 글자 파랑, 일요일 빨강 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, Shipment Plan |
| TC-SSP0021-018 | 그리드 | 조회 완료 | spdMain 셀 병합을 확인한다 | — | MergePolicy=Always에 따라 같은 값 셀이 병합된다 | FindButton, Shipment Plan |
| TC-SSP0021-019 | 그리드 | 조회 완료 | spdMain에서 MEASURE=SHIP_PLAN 행의 날짜 셀을 더블클릭한다 | 날짜 열 셀 | spdDetail이 Shipment Plan Detail로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP0021_GET_SHIPMENT_PLAN_DETAIL`, Shipment Plan Detail |
| TC-SSP0021-020 | 그리드 | 조회 완료 | BOH_TYPE=ERP 행의 BOH_QTY 셀을 더블클릭한다 | — | Stock Location Detail로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP0021_GET_STOCK_LOCATION_DETAIL`, Stock Location Detail |
| TC-SSP0021-021 | 그리드 | 조회 완료 | BOH_TYPE=oWMS 행의 BOH_QTY 셀을 더블클릭한다 | — | oWMS Detail로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_OWMS_DETAIL`, `SSP0021_GET_OWMS_DETAIL`, oWMS Detail |
| TC-SSP0021-022 | 그리드 | 조회 완료 | BOH_TYPE=HOLD 행의 BOH_QTY 셀을 더블클릭한다 | — | Hold stock 시트로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_HOLD_STOCK`, `SSP0021_GET_HOLD_STOCK`, Hold stock |
| TC-SSP0021-023 | 그리드 | 조회 완료 | BOH_TYPE=MES 행의 BOH_QTY 셀을 더블클릭한다 | — | MES Stock Detail(2088~2089줄)과 MES Stock(2093~2094줄)이 조회된다. 최종 활성 시트는 AS-IS 실행 결과와 동일(확인 필요) | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, `SSP0021_GET_MES_STOCK_DETAIL`, `SSP.SSP0021_GET_MES_STOCK`, `SSP0021_GET_MES_STOCK`, MES Stock, MES Stock Detail |
| TC-SSP0021-024 | 그리드(빈 결과) | 조회 완료 | BOH_QTY가 아니고 MEASURE+1 미만인 열(예: Model)을 더블클릭한다 | ITEM_ID 셀 | 상세 조회가 일어나지 않는다(분기 조건 불충족) | `SpdMain_CellDoubleClick` |
| TC-SSP0021-025 | 조회 | spdDetail 활성 시트=Shipment Plan Detail | drpPeriod2·txtModel2를 입력하고 btnSearch를 누른다 | Shipment Date=시험 기간, Model=시험 모델 | Shipment Plan Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, Shipment Plan Detail |
| TC-SSP0021-026 | 조회 | 활성 시트=Stock Location Detail | btnSearch를 누른다 | txtModel2=시험 모델 | Stock Location Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, Stock Location Detail |
| TC-SSP0021-027 | 조회 | 활성 시트=oWMS Detail | btnSearch를 누른다 | txtModel2=시험 모델 | oWMS Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_OWMS_DETAIL`, oWMS Detail |
| TC-SSP0021-028 | 조회 | 활성 시트=Shipment Result | drpPeriod3·clbResultType을 입력하고 btnSearch를 누른다 | 시험 기간, Result Type 전체 | Shipment Result가 조회되고 InitSpread로 헤더가 재구성된다(입력 컨트롤과 시트의 대응은 확인 필요) | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, `SSP0021_GET_SHIPMENT_RESULT`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, Shipment Result |
| TC-SSP0021-029 | 조회 | 활성 시트=MES Stock / MES Stock Detail | txtBoxID를 입력하고 btnSearch를 누른다 | Box ID=시험 값 | MES Stock / MES Stock Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_MES_STOCK`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, MES Stock, MES Stock Detail |
| TC-SSP0021-030 | 조회(빈 결과) | 활성 상세 시트 임의 | 결과가 없는 조건으로 btnSearch를 누른다 | txtModel2=NOTEXIST | 상세 시트에 행이 없다. 오류는 발생하지 않는다 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` |
| TC-SSP0021-031 | 이벤트 | 화면 진입 | btnMeasure를 누른다 | Measure 선택(팝업 확인 필요) | spdMain이 재구성된다 | `BtnMeasure_Click`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-032 | 이벤트 | 화면 진입 | btnItemId를 누르고 팝업에서 모델을 고른다 | 모델 1건 | txtItemId에 선택 값이 들어간다(팝업 대상 확인 필요) | `btnItemId_Click` |
| TC-SSP0021-033 | 이벤트 | 화면 진입 | btnItemID2를 누르고 모델을 고른다 | 모델 1건 | txtModel2에 선택 값이 들어간다 | `BtnItemID2_Click` |
| TC-SSP0021-034 | 이벤트 | 화면 진입 | btnRequestor를 누르고 요청자를 고른다 | 요청자 1명 | txtRequestor에 선택 값이 들어간다 | `BtnRequestor_Click` |
| TC-SSP0021-035 | 이벤트 | 조회 완료 | btnSimulation을 누른다 | — | AS-IS 실행 결과와 동일(Simulation 로직 확인 필요). 엔드포인트 호출 없음 | `BtnSimulation_Click` |
| TC-SSP0021-036 | 그리드 | 조회 완료 | spdDetail 탭 0·1·2·5를 차례로 클릭한다 | — | Shipment Plan Detail / Stock Location Detail / oWMS Detail / Shipment Result로 전환된다 | `SpdDetail_SheetTabClick`, Shipment Plan Detail, Stock Location Detail, oWMS Detail, Shipment Result |
| TC-SSP0021-037 | 그리드 | 조회 완료 | spdDetail 시트를 바꾼다 | — | 활성 시트 변경 처리(세부 확인 필요). 오류 없음 | `SpdDetail_ActiveSheetChanged` |
| TC-SSP0021-038 | 그리드 | 잠기지 않은 상세 시트, 행 ≥ 1 | 체크박스 헤더 셀을 클릭한다 | — | 헤더 체크 값이 토글되고(true↔false) 열 전체 선택/해제가 반영된다 | `SpdDetail_CellClick`, Shipment Plan Detail |
| TC-SSP0021-039 | 권한 | 잠긴 시트(IsLock=true) | 체크박스 헤더 셀을 클릭한다 | — | AS-IS 1837·1841줄 분기와 동일하게 동작한다(잠금 시 동작 확인 필요) | `SpdDetail_CellClick` |
| TC-SSP0021-040 | 그리드 | Shipment Plan Detail 편집 모드 | 콤보 셀(예: Change Reason) 값을 고른다 | 콤보 값 1개 | 선택 값이 반영된다(세부 로직 확인 필요) | `SpdDetail_ComboSelChange`, Shipment Plan Detail |
| TC-SSP0021-041 | 그리드 | 상세 조회 완료 | spdDetail 셀을 더블클릭한다 | — | AS-IS와 동일(세부 로직 확인 필요). 오류 없음 | `SpdDetail_CellDoubleClick` |
| TC-SSP0021-042 | 그리드 | Shipment Plan Detail 편집 모드 | Shipment Qty* 셀을 편집한다 | 100 | 편집 상태가 반영된다(세부 로직 확인 필요) | `SpdDetail_EditChange`, Shipment Plan Detail |
| TC-SSP0021-043 | 그리드 | Shipment Plan Detail 편집 모드 | 여러 셀을 붙여넣는다 | 코드 값 포함 클립보드 | 붙여넣은 값이 CODE 기준으로 매칭된다(1509줄. 매칭 실패 시 동작 확인 필요) | `SpdDetail_ClipboardPasted`, Shipment Plan Detail |
| TC-SSP0021-044 | 그리드 | 조회 완료(행 다수) | spdMain을 세로 스크롤한다 | — | AS-IS와 동일(동기화 여부 확인 필요). 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0021-045 | 그리드 | 상세 조회 완료(행 다수) | spdDetail을 세로 스크롤한다 | — | AS-IS와 동일. 오류 없음 | `SpdDetail_TopChange` |
| TC-SSP0021-046 | 그리드 | 조회 완료 | spdMain 날짜 셀 값을 바꾼다 | 10 | 변경 처리(세부 확인 필요) | `SpdMain_Change`, Shipment Plan |
| TC-SSP0021-047 | 그리드 | 조회 완료 | spdMain에 붙여넣는다 | 숫자 여러 셀 | 붙여넣기 처리(세부 확인 필요) | `SpdMain_ClipboardPasted`, Shipment Plan |
| TC-SSP0021-048 | 이벤트 | 화면 진입 | drpPeriod2 기간을 바꾼다 | 시작일·종료일 변경 | 값 변경 처리(세부 확인 필요) | `DrpPeriod2_ValueChanged` |
| TC-SSP0021-049 | 이벤트 | 상세 데이터 바인딩 | dsdm 데이터 변경을 일으킨다(상세 셀 수정) | — | 변경 처리(dsdm 정체 확인 필요) | `shtDetail_Change` |
| TC-SSP0021-050 | 권한 | 조회 완료, 권한 사용자 | 툴바 Edit를 누른다 | 로그인 사용자 | 사용자 정보 확인 후 편집 가능 상태가 된다 | EditButton, `SSP.SSP0002_GET_USER_INFO_LIST`, `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0021-051 | 권한 | 조회 완료, 비대상 사용자 | 툴바 Edit를 누른다 | 권한 없는 사용자 | 편집이 허용되지 않는다(판정 기준·메시지 확인 필요) | EditButton, `SSP.SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0021-052 | 저장(검증) | Shipment Plan Detail 편집, SO No 없는 행 | Shipment Qty*를 비우고 Save를 누른다 | shipment_confirm_qty=빈값 | Validation_Check에서 저장이 중단되고 메시지가 표시된다(문구 확인 필요) | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, Shipment Plan Detail |
| TC-SSP0021-053 | 저장(검증) | SO No 있는 행 | Trans Mode*를 비우고 Save를 누른다 | TRANSPORT_MODE=빈값 | SONoValidationdr 검증으로 저장이 중단된다 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, Shipment Plan Detail |
| TC-SSP0021-054 | 저장 | Shipment Plan Detail 편집, 필수값 정상 | Save를 누른다 | Shipment Qty=100, Shipment Date=유효일, Trans Mode=유효값 | SSP_ANL_SHIP_CONFIRM 등에 저장되고 SSP_ANL_SHIP_CONFIRM_H 이력이 남는다. 호출 조건은 확인 필요 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0021-055 | 저장 | 저장 대상 행 존재 | Save → GetERPInterface 단계 확인 | — | 확정 변경 시각 확인 SP가 호출된다 | SaveButton, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SCM_SSP_CHECK_CONFIRM_CHANGETIME` |
| TC-SSP0021-056 | 저장 | SO No 있는 행 | Save → GetErpSoNoCnt 단계 확인 | — | 결과 CNT를 확인한다(판정 기준 확인 필요) | SaveButton, `SSP.SSP0021_GET_ERP_SO_NO_CNT`, `SSP0021_GET_ERP_SO_NO_CNT` |
| TC-SSP0021-057 | 저장 | 저장 대상 행 존재 | Save → GetShipmentStatusChk 단계 확인 | — | 결과 Tables[0]·[1]·[2]의 CONFIRM_ID를 확인한다 | SaveButton, `SSP.SSP0021_GET_SHIPMENT_STATUS`, `SSP0021_GET_SHIPMENT_STATUS` |
| TC-SSP0021-058 | 저장 | ERP 오류 확인 대상 행(조건 확인 필요) | Save | — | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ/CHG_REQ_DE UPDATE | SaveButton, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| TC-SSP0021-059 | 저장 | 확정 삭제 대상 행(조건 확인 필요) | Save | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | SaveButton, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0021-060 | 저장 | SO No 없는 변경 행 | Save → NonSoNo | — | SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE에 변경요청이 INSERT되고 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN에 기록된다 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0021-061 | 저장 | SO No 있는 변경 행 | Save → SoNo → GetErpIFCheckNew | — | DRAFTING 저장 뒤 DELETE_BY_CONFIRM과 CHG_BATCH(2회: 4045·4075줄)가 호출된다. 호출 조건은 확인 필요 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| TC-SSP0021-062 | 저장 | 저장 성공 | 저장 후 화면 상태를 확인한다 | — | spdMain, Shipment Plan Detail, Hold stock이 다시 조회된다 | SaveButton, `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0021_GET_HOLD_STOCK`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-063 | 저장(오류) | Hold stock 시트 편집 | Amend Qty*·End Date*를 입력하고 Save를 누른다 | Amend Qty=10, End Date=유효일 | ⚠ DB에 SP가 없어 판정 보류. To-Be는 원본 SP 확보 전 오류 메시지 표시 + 데이터 무변경을 확인한다 | SaveButton, `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`, `SSP0021_SAVE_HOLD_STOCK_DATA`, Hold stock |
| TC-SSP0021-064 | 저장(오류) | 저장 SP에서 DB 오류가 나도록 설정(시험 DB) | Save를 누른다 | 제약 위반 값 | 오류 메시지가 표시되고 부분 저장이 남지 않는다(트랜잭션 처리 확인 필요) | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0021-065 | 저장(검증) | ERP I/F 차단(BLOCK_YN=Y) 설정 | Save를 누른다 | — | chkERPIFBlockYn의 BLOCK_YN·PERIOD에 따라 처리된다(차단 동작 확인 필요) | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0021-066 | 저장(정적 확인) | 소스 정적 분석 | 화면의 모든 진입점(이벤트·툴바)에서 호출 경로를 추적한다 | — | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`은 진입점 미연결 메서드(GetErpIFCheck, GetErpIFCheckNew_)에서만 호출된다. 화면 조작으로는 호출되지 않는다 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0021-067 | 그리드 | 조회 완료 | spdMain 컬럼 표시를 확인한다 | Division=40 | 표시 8: Div, From Site, Model, Nick Name, PSI, BOH_TYPE, BOH_QTY, Measure(MEASURE_NAME). 숨김: Back Color, Confrim Day, Site, Lot_YN, MEASURE | Shipment Plan |
| TC-SSP0021-068 | 그리드 | Shipment Plan Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 42 / 메타 69. 필수 표기 Shipment Qty*, Shipment Date*, Trans Mode* | Shipment Plan Detail, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` |
| TC-SSP0021-069 | 그리드 | Stock Location Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 20 (Available Date ~ Wiphold Yn) | Stock Location Detail, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` |
| TC-SSP0021-070 | 그리드 | oWMS Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 25 (Allocation Qty ~ Undecided Qty) | oWMS Detail, `SSP.SSP0021_GET_OWMS_DETAIL` |
| TC-SSP0021-071 | 그리드 | Hold stock 조회 | 컬럼 표시를 확인한다 | — | 표시 10. 숨김 Site(FROM_SITE)·HOLD_ID. 필수 표기 Amend Qty*, End Date* | Hold stock, `SSP.SSP0021_GET_HOLD_STOCK` |
| TC-SSP0021-072 | 그리드 | Hold stock Detail 진입(진입 경로 확인 필요) | 컬럼 표시를 확인한다 | — | 표시 10. `*` 표기 없음(Amend Qty, End Date) | Hold stock Detail |
| TC-SSP0021-073 | 그리드 | MES Stock 조회 | 컬럼 표시를 확인한다 | — | 표시 9 (Available Stock ~ Total) | MES Stock, `SSP.SSP0021_GET_MES_STOCK` |
| TC-SSP0021-074 | 그리드 | MES Stock Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 13 (Available stock YN ~ QMS Unhold Sched Date) | MES Stock Detail, `SSP.SSP0021_GET_MES_STOCK_DETAIL` |
| TC-SSP0021-075 | 그리드 | Shipment Result 조회 | 컬럼 표시를 확인한다 | — | 표시 18 (Shipment Pack Qty ~ Shipment Date) | Shipment Result, `SSP.SSP0021_GET_SHIPMENT_RESULT` |
| TC-SSP0021-076 | division | Division=82 | Shipment Result를 조회하고 CHILD_QTY 너비를 확인한다 | Division=82 | CHILD_QTY(Shipment Pack Qty) Width=75 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, Shipment Result |
| TC-SSP0021-077 | division | Division=81 | Shipment Result를 조회하고 CHILD_QTY 너비를 확인한다 | Division=81 | Width=75 코드가 적용되지 않고 메타 COLUMN_WIDTH를 따른다 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, Shipment Result |
| TC-SSP0021-078 | division | Division=40 / EE 각각 | 9개 시트 표시 컬럼 수를 확인한다 | Division=40, Division=EE | 두 division 모두 Hold stock 10, Hold stock Detail 10, MES Stock 9, MES Stock Detail 13, oWMS Detail 25, Shipment Plan 8, Shipment Plan Detail 42, Shipment Result 18, Stock Location Detail 20 (14 division 동일) | Hold stock, Hold stock Detail, MES Stock, MES Stock Detail, oWMS Detail, Shipment Plan, Shipment Plan Detail, Shipment Result, Stock Location Detail |

## 2. 커버리지 대조

### 2.1 이벤트 핸들러 (26/26)
| 핸들러 | TC |
|---|---|
| `Form_Load` | 001~005 |
| `SpdMain_TopChange` | 044 |
| `SpdDetail_TopChange` | 045 |
| `cboBucketType_SelectedIndexChanged` | 010~012 |
| `chkSum_CheckedChanged` | 013 |
| `BtnMeasure_Click` | 031 |
| `btnItemId_Click` | 032 |
| `BtnItemID2_Click` | 033 |
| `BtnSearch_Click` | 025~030, 076, 077 |
| `BtnRequestor_Click` | 034 |
| `BtnSimulation_Click` | 035 |
| `SpdDetail_SheetTabClick` | 036 |
| `SpdDetail_ActiveSheetChanged` | 037 |
| `SpdDetail_CellClick` | 038, 039 |
| `SpdDetail_ComboSelChange` | 040 |
| `SpdDetail_CellDoubleClick` | 041 |
| `SpdDetail_EditChange` | 042 |
| `SpdDetail_ClipboardPasted` | 043 |
| `SpdMain_CellDoubleClick` | 019~024 |
| `SpdMain_Change` | 046 |
| `DrpPeriod2_ValueChanged` | 048 |
| `SpdMain_ClipboardPasted` | 047 |
| `clbDivision_ID_SelectedIndexChanged` | 006 |
| `clbCompanyID_SelectedIndexChanged` | 007, 008 |
| `cboPlanDate_SelectedIndexChanged` | 005, 009 |
| `shtDetail_Change` | 049 |

### 2.2 엔드포인트 (23/23)
| 엔드포인트 | TC |
|---|---|
| `SSP.SSP0021_GET_SHIPMENT_DIVISION` | 001 |
| `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | 052, 054, 064 |
| `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | 063 |
| `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 058 |
| `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 059, 061 |
| `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | 053, 060, 061, 065 |
| `SSP.SSP0021_GET_ERP_SO_NO_CNT` | 056 |
| `SSP.SSP0021_GET_SHIPMENT_STATUS` | 057 |
| `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | 066 |
| `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | 061 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | 002 |
| `SSP.SSP0021_GET_SHIPMENT_PLAN` | 014, 015, 016, 062 |
| `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | 019, 025, 030, 062, 068 |
| `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` | 020, 026, 069 |
| `SSP.SSP0021_GET_OWMS_DETAIL` | 021, 027, 070 |
| `SSP.SSP0021_GET_SHIPMENT_RESULT` | 028, 075, 076, 077 |
| `SSP.SSP0021_GET_HOLD_STOCK` | 022, 062, 071 |
| `SSP.SSP0021_GET_MES_STOCK` | 023, 029, 073 |
| `SSP.SSP0021_GET_MES_STOCK_DETAIL` | 023, 029, 074 |
| `SSP.SSP0002_GET_USER_INFO_LIST` | 050, 051 |
| `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | 007, 008 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 003, 007, 009, 017, 028, 031, 062 |
| `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | 055 |

### 2.3 시트 (9/9)
| 시트 | TC |
|---|---|
| Shipment Plan | 003, 010~014, 017, 018, 046, 047, 067 |
| Shipment Plan Detail | 004, 019, 025, 036, 038, 040, 042, 043, 052, 053, 068 |
| Stock Location Detail | 020, 026, 036, 069 |
| oWMS Detail | 021, 027, 036, 070 |
| Hold stock | 022, 063, 071 |
| Hold stock Detail | 072 |
| MES Stock | 023, 029, 073 |
| MES Stock Detail | 023, 029, 074 |
| Shipment Result | 028, 036, 075, 076, 077 |

### 2.4 Division 변형
- 코드 분기 1건(82 CHILD_QTY Width=75): TC-076(82), TC-077(비 82).
- 메타 표시 수는 14개 division이 같다: TC-078(40, EE 표본). 나머지 12개 division도 같은 절차로 확인한다.

## 3. 판정 보류 항목 (확인 필요 의존)
| TC | 보류 사유 |
|---|---|
| 010 | DAILY일 때 W_ 열 최종 표시값(4469·4474줄 실행 순서) |
| 035 | Simulation 로직과 핸들러 연결 |
| 039, 041, 044~049 | 핸들러 세부 로직 Fact Pack 미포함 |
| 054~061, 065 | 저장 체인 분기 조건과 메시지 |
| 063 | `SSP0021_SAVE_HOLD_STOCK_DATA` DB 미존재 |
| 072 | Hold stock Detail 진입 경로 |
