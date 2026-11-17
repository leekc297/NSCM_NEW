# SSP0060 단위테스트 — Shipment Plan

> **근거**: Fact Pack(SSP0060)과 업무분석서·화면설계서입니다. '근거' 열의 엔드포인트, SP, 핸들러, 시트 이름은 원문 그대로입니다.
> 절차 열의 컨트롤명은 화면설계서 §3과 같습니다. 주석 처리된 호출은 테스트 대상에서 제외했습니다.
> 기대결과의 구체 값이나 메시지가 Fact Pack에 없으면 "확인 필요"로 적었습니다. 이런 케이스는 AS-IS 실행 결과를 기준값으로 삼아 판정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0060-001 | 초기화 | 권한 있는 계정으로 로그인 | 메뉴에서 SSP0060을 엶 | – | clbDivision_ID에 권한 Division 목록이 채워짐(TB_FX_USERGROUPAUTHEXTENTION 필터) | `Form_Load` > SetChangedControl · `SSP.SSP0060_GET_SHIPMENT_DIVISION` · SP SSP0060_GET_SHIPMENT_DIVISION |
| TC-SSP0060-002 | 초기화 | 001과 같음 | 화면을 연 직후 cboBucketType 목록 확인 | – | Bucket Type 코드 목록 표시(SCM_ADM_LOOKUP_MASTER_DETAIL) | `Form_Load` > GetBucketType · `DM.DM0003_GET_BUCKET_TYPE_CODE` · SP DM0003_GET_BUCKET_TYPE_CODE |
| TC-SSP0060-003 | 초기화 | 001과 같음 | 화면을 연 직후 spdMain 헤더 확인 | – | 날짜 컬럼 헤더가 달력(SCM_SYS_CALENDAR_M) 기준으로 생성됨 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-004 | 초기화 | 001과 같음 | 화면을 연 직후 drpPeriod 값 확인 | – | dtShipmentInputPeriod 0·1행 VALUE/Diff_VALUE와의 연관 여부 확인(값은 확인 필요). FP_Log2 로그 기록 | `Form_Load` > InitControls |
| TC-SSP0060-005 | 초기화 | 001과 같음 | 화면 표시 완료 시점 확인 | – | Shown 처리 수행(내용 확인 필요) | `SSP0060_ShipmentPlan_Shown` |
| TC-SSP0060-006 | 조회 | 001 완료, clbCompany_ID·clbDivision_ID·cboPlanDate·cboBucketType 선택 | FindButton 클릭 | Division=권한 Division, Plan Date=현재 | spdMain에 Shipment Plan 13개 표시 컬럼(Div, From Site, To Site, Product Level1, Model, Nick Name, FCST Type, Incoterms, Transmode, BOH_TYPE, BOH_QTY, PSI, Measure)과 날짜 컬럼 표시. 숨김 5(FROM_SITE, MEASURE, BACK_COLOR, CONFIRM_DAY, LOT_YN) 비표시 | FindButton > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_PLAN` · SP SSP0060_GET_SHIPMENT_PLAN · 시트 Shipment Plan |
| TC-SSP0060-007 | 조회 | 006과 같음 | 데이터가 없는 조건으로 FindButton 클릭 | 존재하지 않는 txtItemId | 0행 표시, 오류 없음(빈 결과 메시지는 확인 필요) | `SSP.SSP0060_GET_SHIPMENT_PLAN` · 시트 Shipment Plan |
| TC-SSP0060-008 | 조회 | SP 오류를 유도할 수 있는 환경 | FindButton 클릭 | SP 예외 발생 | 오류 메시지 표시, 그리드 기존 데이터 처리 확인 필요 | `SSP.SSP0060_GET_SHIPMENT_PLAN` (오류 응답) |
| TC-SSP0060-009 | 조회 | 006 조회 완료 | btnSearch 클릭 (txtRequestor, txtModel2, drpPeriod2, drpPeriod3, clbResultType, txtBoxID, clbProductLevel12 입력) | 조회 조건 | spdDetail Shipment Plan Detail 44개 표시 / 27개 숨김 컬럼 | `BtnSearch_Click` > FindData_Detail · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` · SP SSP0060_GET_SHIPMENT_PLAN_DETAIL · 시트 Shipment Plan Detail |
| TC-SSP0060-010 | 조회 | 009와 같음 | btnSearch 후 Stock Location Detail 탭 확인 | – | 20개 컬럼(Company, Deffect Qty, Div, Model, Plant, Storage …) 표시 | `BtnSearch_Click` > FindData_Stock_Detail · `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` · SP SSP0060_GET_STOCK_LOCATION_DETAIL · 시트 Stock Location Detail |
| TC-SSP0060-011 | 조회 | 009와 같음 | btnSearch 후 oWMS Detail 탭 확인 | – | 25개 컬럼(Capa. Grade, Long-term Qty, Reciving Qty, Inventory Status …) 표시 | `BtnSearch_Click` > FindData_oWMS_Detail · `SSP.SSP0060_GET_OWMS_DETAIL` · SP SSP0060_GET_OWMS_DETAIL · 시트 oWMS Detail |
| TC-SSP0060-012 | 조회 | 009와 같음 | btnSearch 후 Shipment Result 탭 확인 | – | 16개 컬럼(Confirm/Plan ID, SO No, ETA, ETD, Shipment Qty, Status, Shipment Date …) 표시. 헤더 재구성 | `BtnSearch_Click` > FindData_Shipment_Result(5977, 6117) · `SSP.SSP0060_GET_SHIPMENT_RESULT` · SP SSP0060_GET_SHIPMENT_RESULT · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Result |
| TC-SSP0060-013 | 조회 | 009와 같음 | btnSearch 후 MES Stock 탭 확인 | – | 9개 컬럼(Model, Nick Name, TOTAL, AVAILABLE_STOCK, BEFORE_OQC, OQC_INSP_REQUEST, OQC_COMPLETE, OQC_NG, QMS/MES Hold) 표시 | `BtnSearch_Click` > FindData_MES_stock · `SSP.SSP0060_GET_MES_STOCK` · SP SSP0060_GET_MES_STOCK · 시트 MES Stock |
| TC-SSP0060-014 | 조회 | 009와 같음 | btnSearch 후 MES Stock Detail 탭 확인 | txtBoxID 입력 | 13개 컬럼(Model, Nick Name, Lot ID, Box ID, Available stock YN, Exp Insp Vaild Date …) 표시 | `BtnSearch_Click` > FindData_MES_stock_Detail · `SSP.SSP0060_GET_MES_STOCK_DETAIL` · SP SSP0060_GET_MES_STOCK_DETAIL · 시트 MES Stock Detail |
| TC-SSP0060-015 | 조회 | 006 조회 완료 | spdMain 데이터 셀 더블클릭 | 임의 행 | spdDetail 각 시트 조회. Hold stock 10개 표시 컬럼(Div, From Site, Model, NICK_NAME, Amend Qty*, Start Date, End Date*, REMARKS, LAST_UPDATED_BY, LAST_UPDATE_DATE). 더블클릭 셀별 분기는 확인 필요 | `SpdMain_CellDoubleClick` > FindData_hold_stock · `SSP.SSP0060_GET_HOLD_STOCK` · SP SSP0060_GET_HOLD_STOCK · 시트 Hold stock |
| TC-SSP0060-016 | 조회 | 015와 같음 | spdMain 더블클릭 후 Detail 조회 7종 호출 확인 | – | PLAN_DETAIL, STOCK_LOCATION_DETAIL, OWMS_DETAIL, SHIPMENT_RESULT, HOLD_STOCK, MES_STOCK, MES_STOCK_DETAIL 호출 | `SpdMain_CellDoubleClick` · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` · `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` · `SSP.SSP0060_GET_OWMS_DETAIL` · `SSP.SSP0060_GET_SHIPMENT_RESULT` · `SSP.SSP0060_GET_MES_STOCK` · `SSP.SSP0060_GET_MES_STOCK_DETAIL` |
| TC-SSP0060-017 | 그리드 | 015 완료 | Hold stock Detail 시트 표시 확인 | – | 10개 표시 컬럼(라벨에 `*` 없음: Amend Qty, End Date). 숨김 FROM_SITE, HOLD_ID. 생성 코드와 데이터 소스는 확인 필요 | 시트 Hold stock Detail (SCM_MST_SHEET_COLUMNS) |
| TC-SSP0060-018 | 조회 | 009와 같음 | 데이터가 없는 조건으로 btnSearch 클릭 | 존재하지 않는 txtModel2 | 모든 Detail 시트 0행, 오류 없음 | `BtnSearch_Click` · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` (빈 결과) |
| TC-SSP0060-019 | 저장 | 006 조회 완료, spdMain 수량 셀 수정 | SaveButton 클릭 | 날짜 셀 수량 변경 | SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE에 INSERT | SaveButton > SaveData_Main · `SSP.SSP0060_SAVE_SHIPMENT_PLAN` · SP SSP0060_SAVE_SHIPMENT_PLAN |
| TC-SSP0060-020 | 저장 | 009 조회 완료, Shipment Plan Detail 행 수정 | SaveButton 클릭 | Shipment Qty*, Shipment Date*, Trans Mode* 변경 | SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | SaveButton > SaveData_Detail · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` · SP SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM · 시트 Shipment Plan Detail |
| TC-SSP0060-021 | 저장 | 020과 같음 | 필수(*) 값을 비우고 SaveButton 클릭 | Shipment Qty* 빈값 | 저장 차단 여부와 메시지는 확인 필요(Validation_Check) | SaveData_Detail > Validation_Check · 시트 Shipment Plan Detail |
| TC-SSP0060-022 | 저장 | ERP IF Block 상태(BLOCK_YN) | SaveButton 클릭 | – | chkERPIFBlockYn 판정에 따라 저장 차단 여부 확인(메시지 확인 필요) | SaveData_Detail > chkERPIFBlockYn |
| TC-SSP0060-023 | 저장 | 020과 같음 | SaveButton 후 ERP 오류 확인 처리 검증 | – | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ(_DE) UPDATE | GetERPInterface(3990) · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0060-024 | 저장 | 020과 같음 | SaveButton 후 확정 기준 Drafting 삭제 처리 검증 | – | SSP_ANL_SHIP_CONFIRM DELETE/UPDATE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | GetERPInterface(4031) · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` · SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0060-025 | 저장 | SO 번호가 있는 확정 건 | SaveButton 클릭 | ERP_SO_NO 존재 행 | CNT 판정 후 SoNo 분기에서 Drafting 저장 | GetErpSoNoCnt · `SSP.SSP0060_GET_ERP_SO_NO_CNT` · SP SSP0060_GET_ERP_SO_NO_CNT · SoNo(4380) · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` · SP SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0060-026 | 저장 | SO 번호가 없는 확정 건 | SaveButton 클릭 | ERP_SO_NO 없음 | NonSoNo 분기에서 Drafting 저장(CNT 임계값은 확인 필요) | NonSoNo(4159) · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0060-027 | 저장 | 020과 같음 | SaveButton 후 출하 상태 확인 | – | Tables[0..2] CONFIRM_ID 확인. 해당 시 처리는 확인 필요 | GetShipmentStatusChk · `SSP.SSP0060_GET_SHIPMENT_STATUS` · SP SSP0060_GET_SHIPMENT_STATUS |
| TC-SSP0060-028 | 저장 | 025와 같음 | SoNo 분기 IF 체크 | – | DELETE_BY_CONFIRM(4657), CHG_BATCH(4683, 4713) 호출. XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | GetErpIFCheckNew · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` · SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| TC-SSP0060-029 | 저장 | 020과 같음 | 다른 사용자가 같은 건을 먼저 변경한 뒤 SaveButton 클릭 | 변경 시각 불일치 | 변경 시각 확인 결과에 따른 차단 여부 확인 필요 | ChkConfirmChangeTime(7962) · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` · SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| TC-SSP0060-030 | 저장 | 015 완료, Hold stock 행 수정 | SaveButton 클릭 | Amend Qty*, End Date* 변경 | 엔드포인트가 FoxQuery·DB에 없음(NOT_IN_FOXQUERY). AS-IS 실행 시 오류 여부 기록. TO-BE 처리 결정 필요 | SaveData_Detail(3460) · `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` · 시트 Hold stock |
| TC-SSP0060-031 | 저장 | 020 저장 성공 | 저장 후 화면 확인 | – | 메인, Detail, Hold stock 재조회 | SaveData_Detail > FindData_Main / FindData_Detail / FindData_hold_stock · `SSP.SSP0060_GET_SHIPMENT_PLAN` · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` · `SSP.SSP0060_GET_HOLD_STOCK` |
| TC-SSP0060-032 | 저장 | 확정 SP 오류를 유도할 수 있는 환경 | SaveButton 클릭 | SP 예외 | 오류 메시지. 이후 ERP IF 단계 미진행 여부와 롤백 범위는 확인 필요 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` (오류 응답) |
| TC-SSP0060-033 | 초기화 | RequestPopup 호출(호출 지점 확인 필요) | 팝업을 엶 | 변경요청 대상 | spdMain에 Request Info 49개 컬럼(NEW_YN 포함) 구성 및 조회 | RequestPopup `Form_Load` > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` · SP SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING · 시트 Request Info |
| TC-SSP0060-034 | 초기화 | 033과 같음 | 팝업 표시 완료 시점 확인 | – | Shown 처리 수행(내용 확인 필요) | `SSP0060_ShipmentPlanRequestPopup_Shown` |
| TC-SSP0060-035 | 조회 | 033과 같음 | 대상이 없는 상태에서 FindButton 클릭 | 존재하지 않는 요청 | 0행, 오류 없음 | FindButton > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` (빈 결과) |
| TC-SSP0060-036 | 저장 | 033 조회 완료 | cboChangeReason, txtReasonDetail 입력 후 usrButtonList1 저장 클릭 | Change Reason*, Reason Detail* | 계획 처리 중 확인 후 확정 저장 | `usrButtonList1_UsrButtonList_Click_Detected` > SaveData > ChkEngProcessing · `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` · SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| TC-SSP0060-037 | 저장 | 036과 같음 | SaveButton 클릭 | – | 확정 저장(SSP_ANL_SHIP_CONFIRM, _H, XIF INSERT) | SaveButton > SaveData(584) · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` · 시트 Request Info |
| TC-SSP0060-038 | 저장 | 계획 처리 중 상태 | usrButtonList1 저장 클릭 | – | 저장 차단 여부와 메시지는 확인 필요 | ChkEngProcessing · `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| TC-SSP0060-039 | 저장 | 033과 같음 | cboChangeReason 미선택 상태로 저장 | Change Reason* 빈값 | 차단 여부와 메시지는 확인 필요 | RequestPopup SaveData · 시트 Request Info |
| TC-SSP0060-040 | 저장 | 037과 같음 | 저장 후 ERP 오류 확인과 삭제 처리 검증 | – | ERROR_CONFIRM(1044), DELETE_BY_CONFIRM(1072) 호출 | 팝업 GetERPInterface · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0060-041 | 저장 | SO 번호가 있는 건 | 팝업 저장 | ERP_SO_NO 존재 | SoNo 분기: DRAFTING_MAIN(1181) 후 CHG_BATCH(1253) | 팝업 SoNo · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` · SP SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| TC-SSP0060-042 | 저장 | SO 번호가 없는 건 | 팝업 저장 | ERP_SO_NO 없음 | NonSoNo 분기: DRAFTING_MAIN(1385) 후 CHG_BATCH_NEW_C(1408) | 팝업 NonSoNo · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` · SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C |
| TC-SSP0060-043 | 저장 | 041과 같음 | SoNo 분기 IF 체크 | – | DELETE_BY_CONFIRM(1525/1642), NEW_C(1551/1582), CHG_BATCH(1668/1699) 호출. 분기 조건은 확인 필요 | 팝업 GetErpIFCheckNew · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| TC-SSP0060-044 | 저장 | 037과 같음 | 다른 사용자가 먼저 변경한 뒤 팝업 저장 | 변경 시각 불일치 | 차단 여부 확인 필요 | 팝업 ChkConfirmChangeTime · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` · SP SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE |
| TC-SSP0060-045 | 저장 | 037과 같음 | 팝업 저장 시 SO 건수와 상태 확인 | – | GET_ERP_SO_NO_CNT(1759), GET_SHIPMENT_STATUS(1784) 호출 | 팝업 GetErpSoNoCnt / GetShipmentStatusChk · `SSP.SSP0060_GET_ERP_SO_NO_CNT` · `SSP.SSP0060_GET_SHIPMENT_STATUS` |
| TC-SSP0060-046 | 저장 | unreached 이관이 결정된 경우에만 수행 | 정적 확인: 진입점 미연결 여부 | – | 현행 화면에서는 호출되지 않음(정적 분석). TO-BE 이관 시 별도 TC 작성 | RequestPopup GetErpIFCheck(842) · `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` · SP SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| TC-SSP0060-047 | 저장 | 046과 같음 | 정적 확인: 진입점 미연결 여부 | – | 현행 화면에서는 호출되지 않음. TO-BE 이관 여부 결정 필요 | GetErpIFCheck(4579), GetErpIFCheckNew_(5042) · `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` · SP SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0060-048 | 이벤트 | 033 조회 완료 | btnAutoSet 클릭 | – | 클라이언트 자동 설정(대상 컬럼은 확인 필요), 엔드포인트 호출 없음 | `btnAutoSet_Click` |
| TC-SSP0060-049 | 이벤트 | 033 조회 완료 | 팝업 spdMain에 클립보드 붙여넣기 | 복수 셀 | 붙여넣기 처리(내용 확인 필요) | `spdMain_ClipboardPasted` (RequestPopup) |
| TC-SSP0060-050 | 이벤트 | 033 조회 완료 | 팝업 spdMain 셀 값 변경 | NEW_SHIPMENT_CONFIRM_QTY 변경 | 변경 처리(DIFF_QTY 연동 여부 확인 필요) | `spdMain_Change` (RequestPopup) · 시트 Request Info |
| TC-SSP0060-051 | 이벤트 | 033 / 006 완료 | 팝업 spdMain과 메인 spdMain에서 키 입력 | Ctrl/Delete 등 | KeyDown 처리(내용 확인 필요) | `spdMain_KeyDown` (RequestPopup Designer:280, 메인 Designer:910) |
| TC-SSP0060-052 | 이벤트 | 033과 같음 | 팝업 닫기 | – | FormClosing 처리(변경 확인 여부 확인 필요) | `SSP0060_ShipmentPlanRequestPopup_FormClosing` |
| TC-SSP0060-053 | 이벤트 | 006 완료 | 메인 spdMain에서 키를 눌렀다 뗌 | 임의 키 | KeyUp 처리(내용 확인 필요) | `spdMain_KeyUp` |
| TC-SSP0060-054 | 이벤트 | 006, 009 완료 | spdMain 세로 스크롤 | – | TopChange 처리(동기화 대상 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0060-055 | 이벤트 | 009 완료 | spdDetail 세로 스크롤 | – | TopChange 처리 | `SpdDetail_TopChange` |
| TC-SSP0060-056 | 이벤트 | 001 완료 | cboBucketType 변경 | 다른 Bucket | 처리 결과 확인 필요(헤더 재구성 여부) | `cboBucketType_SelectedIndexChanged` · `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0060-057 | 이벤트 | 006 완료 | chkSum 체크/해제 | ON/OFF | 합계 표시 변화(CalculateSum/Set_SumValues 연관 확인 필요) | `chkSum_CheckedChanged` · 시트 Shipment Plan |
| TC-SSP0060-058 | 이벤트 | 006 완료 | chkTotPSI 체크/해제 | ON/OFF | 메인 즉시 재조회 | `chkTotPSI_CheckedChanged` > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_PLAN` · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0060-059 | 이벤트 | 001 완료 | btnMeasure 클릭 후 Measure 선택 | 선택 Measure 6종 중 1 | Shipment Plan 시트 재구성(MEASURE 필수+기본 14 / 선택 6) | `BtnMeasure_Click` > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-060 | 이벤트 | 001 완료 | btnItemId 클릭 | – | 품목 선택 후 txtItemId 반영(팝업 종류 확인 필요) | `btnItemId_Click` |
| TC-SSP0060-061 | 이벤트 | 001 완료 | btnItemID2 클릭 | – | 품목 선택 후 txtModel2 반영 | `BtnItemID2_Click` |
| TC-SSP0060-062 | 이벤트 | 001 완료 | btnNew 클릭 | – | 처리 결과 확인 필요 | `BtnNew_Click` |
| TC-SSP0060-063 | 이벤트 | 001 완료 | btnRequestor 클릭 | – | 사용자 선택 후 txtRequestor 반영(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0060-064 | 이벤트 | 006 완료 | btnSimulation 클릭 | – | Container_Qty 기반 Simulation 결과 반영. 엔드포인트 없음 | `BtnSimulation_Click` · 시트 Shipment Plan |
| TC-SSP0060-065 | 이벤트 | 009 완료 | spdDetail 시트 탭 클릭 | Stock Location Detail 탭 | 탭 클릭 처리(재조회 여부 확인 필요) | `SpdDetail_SheetTabClick` · 시트 Stock Location Detail |
| TC-SSP0060-066 | 이벤트 | 009 완료 | 활성 시트를 oWMS Detail로 전환 | – | ActiveSheetChanged 처리 | `SpdDetail_ActiveSheetChanged` · 시트 oWMS Detail |
| TC-SSP0060-067 | 이벤트 | 009 완료 | Shipment Plan Detail에서 TRANSPORT_MODE 셀 클릭 | – | Trans Mode 콤보 목록 재조회(SCP_MST_BOD_V) | `SpdDetail_CellClick`(1987) · `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0060-068 | 이벤트 | 067과 같음 | 콤보에서 값 선택 | 다른 Trans Mode | ComboSelChange 처리(연동 컬럼 확인 필요) | `SpdDetail_ComboSelChange` · 시트 Shipment Plan Detail |
| TC-SSP0060-069 | 이벤트 | 009 완료 | spdDetail 셀 더블클릭 | 임의 셀 | 처리 결과 확인 필요(팝업 호출 여부) | `SpdDetail_CellDoubleClick` |
| TC-SSP0060-070 | 이벤트 | 009 완료 | Shipment Plan Detail 셀 편집 | From/To Site 등 | Trans Mode 목록 재조회(1380/1389) | `SpdDetail_EditChange` · `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0060-071 | 이벤트 | 009 완료 | spdDetail에 클립보드 붙여넣기 | 복수 행 | 붙여넣기 처리(c.CODE 사용) | `SpdDetail_ClipboardPasted` |
| TC-SSP0060-072 | 이벤트 | 006 완료 | spdMain 날짜 셀 값 변경 | 수량 변경 | 변경 처리(EditByChange QTY/NOEDIT_QTY 연관 확인 필요) | `SpdMain_Change` · 시트 Shipment Plan |
| TC-SSP0060-073 | 이벤트 | 006 완료 | spdMain에 클립보드 붙여넣기 | 복수 셀 | 붙여넣기 처리 | `SpdMain_ClipboardPasted` |
| TC-SSP0060-074 | 이벤트 | 001 완료 | drpPeriod2 값 변경 | 기간 변경 | ValueChanged 처리(drpPeriod3 연동 여부 확인 필요) | `DrpPeriod2_ValueChanged` |
| TC-SSP0060-075 | 이벤트 | 001 완료 | clbDivision_ID 변경 | 다른 Division | NERP 코드(SEGMENT2) 조회 | `clbDivision_ID_SelectedIndexChanged` > GetNERPCode · `SSP.SSP0002_GET_NERP_CODE` · SP SSP0002_GET_NERP_CODE |
| TC-SSP0060-076 | 이벤트 | 001 완료 | clbCompany_ID 변경 | 다른 Company | cboPlanDate 이벤트 해제 → 헤더 재구성 → 재연결. cboPlanDate 핸들러 중복 실행 없음 | `clbCompanyID_SelectedIndexChanged` > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0060-077 | 이벤트 | 001 완료 | cboPlanDate 변경 | 다른 Plan Date | FROM_DATE~TO_DATE1 기준으로 날짜 컬럼 재생성. EDIT_YN_* 컬럼 생성 | `cboPlanDate_SelectedIndexChanged` > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-078 | 이벤트 | 009 완료 | Detail 데이터셋(dsdm) 값 변경 | 셀 편집 | Changed 처리(내용 확인 필요) | `shtDetail_Change` |
| TC-SSP0060-079 | 권한 | 수정 권한이 있는 계정 / 없는 계정 | EditButton 클릭 | 계정 2종 | 사용자·그룹 권한 조회. 권한 없는 계정의 처리는 확인 필요 | EditButton > GetSSPUserCheck · `SSP.SSP0002_GET_USER_INFO_LIST` · SP SSP0002_GET_USER_INFO_LIST |
| TC-SSP0060-080 | 권한 | Division 권한이 다른 계정 2개 | 각 계정으로 화면을 엶 | 계정 A/B | clbDivision_ID 목록이 TB_FX_USERGROUPAUTHEXTENTION에 따라 다름 | `Form_Load` · `SSP.SSP0060_GET_SHIPMENT_DIVISION` |
| TC-SSP0060-081 | 권한 | TB_FX_GroupMenuAuth 13행 그룹별 계정 | FindButton / SaveButton / EditButton 노출 확인 | 그룹별 계정 | 그룹 권한값에 따라 버튼 노출(값 확인 필요) | FindButton · SaveButton · EditButton (TB_FX_GroupMenuAuth) |
| TC-SSP0060-082 | 그리드 | 033 조회 완료 | RequestPopup Request Info 헤더 확인 | – | 2단 헤더 `Confirmed`(LT_DAY~SHIPMENT_CONFIRM_QTY 6칸) / `Change`(NEW_LT_DAY~ 6칸), FCST Type 콤보(SALES_TYPE_CODE) | 시트 Request Info · `biz:CommonData.CommonDataList` [LookupCommon] (`<field:dtFcstType>`) |
| TC-SSP0060-083 | 초기화 | ConfirmDetailPopup 호출(지점 확인 필요) | 팝업을 엶 | 요청 번호 | txtRequestNo, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName(ReadOnly)과 usrLabel2 "Request Confirm Detail" 표시. spdMain Request Info 48컬럼(표시: Confirm/Plan ID, SO No, Project Name, FCST Type, Model, From/To Site, Incoterms, Confirmed 6, Change 6, Diff Qty, Change Reason, Reason Detail) | ConfirmDetailPopup `Form_Load` > FindDataMain(312) · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` · 시트 Request Info |
| TC-SSP0060-084 | 그리드 | 083과 같음 | 숨김 컬럼 ELECTRODE_YN과 NEW_TO_CITY 바인딩 확인 | – | 헤더 `NEW_TO_CITY`=필드 ELECTRODE_YN, 헤더 `ELECTRODE_YN`=필드 NEW_TO_CITY(원문 교차). TO-BE 처리 결정 필요 | 시트 Request Info (ConfirmDetailPopup 215/216, RequestPopup 240/241) |
| TC-SSP0060-085 | 이벤트 | 083과 같음 | btnButtonList 버튼 클릭 | 조회/닫기 등 | 처리 결과 확인 필요 | `btnButtonList_UsrButtonList_Click_Detected` |
| TC-SSP0060-086 | 조회 | 083과 같음 | 대상이 없는 요청 번호로 FindButton 클릭 | 없는 번호 | 텍스트박스 공백, 그리드 0행 | ConfirmDetailPopup FindButton > FindDataMain · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` (빈 결과) |
| TC-SSP0060-087 | division | Div=40 계정 | FindButton → btnSearch → 각 Detail 탭 확인 | Div 40 | 시트별 표시 컬럼 수: Shipment Plan 13, Shipment Plan Detail 44, Stock Location Detail 20, oWMS Detail 25, Shipment Result 16, MES Stock 9, MES Stock Detail 13, Hold stock 10, Hold stock Detail 10 | `SSP.SSP0060_GET_SHIPMENT_PLAN` · 시트 Shipment Plan / Shipment Plan Detail (grid_rule 40) |
| TC-SSP0060-088 | division | Div=81 계정 | 087과 같음 | Div 81 | 087과 같은 컬럼 수(메타 차이 없음) | grid_rule 81 · `SSP.SSP0002_GET_NERP_CODE` |
| TC-SSP0060-089 | division | Div=81_HD 계정 | 087과 같음 | Div 81_HD | 087과 같음 | grid_rule 81_HD |
| TC-SSP0060-090 | division | Div=81_HG 계정 | 087과 같음 | Div 81_HG | 087과 같음 | grid_rule 81_HG |
| TC-SSP0060-091 | division | Div=81_HM 계정 | 087과 같음 | Div 81_HM | 087과 같음 | grid_rule 81_HM |
| TC-SSP0060-092 | division | Div=81_ST 계정 | 087과 같음 | Div 81_ST | 087과 같음 | grid_rule 81_ST |
| TC-SSP0060-093 | division | Div=81_UC 계정 | 087과 같음 | Div 81_UC | 087과 같음 | grid_rule 81_UC |
| TC-SSP0060-094 | division | Div=82 계정 | 087과 같음 | Div 82 | 087과 같음 | grid_rule 82 |
| TC-SSP0060-095 | division | Div=EE 계정 | 087과 같음 | Div EE | 087과 같음 | grid_rule EE |
| TC-SSP0060-096 | division | Div=EE_HD 계정 | 087과 같음 | Div EE_HD | 087과 같음 | grid_rule EE_HD |
| TC-SSP0060-097 | division | Div=EE_HG 계정 | 087과 같음 | Div EE_HG | 087과 같음 | grid_rule EE_HG |
| TC-SSP0060-098 | division | Div=EE_HM 계정 | 087과 같음 | Div EE_HM | 087과 같음 | grid_rule EE_HM |
| TC-SSP0060-099 | division | Div=EE_ST 계정 | 087과 같음 | Div EE_ST | 087과 같음 | grid_rule EE_ST |
| TC-SSP0060-100 | division | Div=EE_UC 계정 | 087과 같음 | Div EE_UC | 087과 같음 | grid_rule EE_UC |
| TC-SSP0060-101 | 그리드 | 006 완료 | Shipment Plan 날짜 컬럼과 EDIT_YN_* 컬럼 확인 | – | 날짜별 `EDIT_YN_{날짜}`(헤더 `E{라벨}`) 생성. 표시 여부 확인 필요 | SetSpreadColumn / InitSpreadDateColumn · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-102 | 조회 | Detail SP 오류를 유도할 수 있는 환경 | btnSearch 클릭 | SP 예외 | 오류 메시지, 다른 시트 조회 계속 여부 확인 필요 | `BtnSearch_Click` · `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` (오류 응답) |

### 커버리지 점검
| 대상 | 총수 | 근거 열 등장 |
|---|---:|---|
| 이벤트 핸들러 | 38 | 38 (Form_Load 001/033/083, btnButtonList_UsrButtonList_Click_Detected 085, usrButtonList1_UsrButtonList_Click_Detected 036, btnAutoSet_Click 048, spdMain_ClipboardPasted 049, spdMain_Change 050, spdMain_KeyDown 051, SSP0060_ShipmentPlanRequestPopup_FormClosing 052, SSP0060_ShipmentPlanRequestPopup_Shown 034, spdMain_KeyUp 053, SSP0060_ShipmentPlan_Shown 005, SpdMain_TopChange 054, SpdDetail_TopChange 055, cboBucketType_SelectedIndexChanged 056, chkSum_CheckedChanged 057, chkTotPSI_CheckedChanged 058, BtnMeasure_Click 059, btnItemId_Click 060, BtnItemID2_Click 061, BtnSearch_Click 009, BtnNew_Click 062, BtnRequestor_Click 063, BtnSimulation_Click 064, SpdDetail_SheetTabClick 065, SpdDetail_ActiveSheetChanged 066, SpdDetail_CellClick 067, SpdDetail_ComboSelChange 068, SpdDetail_CellDoubleClick 069, SpdDetail_EditChange 070, SpdDetail_ClipboardPasted 071, SpdMain_CellDoubleClick 015, SpdMain_Change 072, DrpPeriod2_ValueChanged 074, SpdMain_ClipboardPasted 073, clbDivision_ID_SelectedIndexChanged 075, clbCompanyID_SelectedIndexChanged 076, cboPlanDate_SelectedIndexChanged 077, shtDetail_Change 078) |
| 엔드포인트 | 31 | 31 (`biz:CommonData.CommonDataList` 067/070/082, `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` 030, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` 046, `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` 047 등) |
| 시트 | 10 | 10 (Shipment Plan 006, Shipment Plan Detail 009, Stock Location Detail 010, oWMS Detail 011, Shipment Result 012, MES Stock 013, MES Stock Detail 014, Hold stock 015, Hold stock Detail 017, Request Info 033) |
| division | 14 | 14 (087~100) |
| 빈 결과 / 오류 응답 | – | 빈 결과 007, 018, 035, 086 / 오류 응답 008, 032, 102 |
