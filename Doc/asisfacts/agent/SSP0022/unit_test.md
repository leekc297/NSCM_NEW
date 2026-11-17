# SSP0022 Shipment Request(Electrode) — 단위테스트

> **작성 근거**: 업무분석서 §5 데이터 흐름, 화면설계서 §3 컨트롤 명세와 §5 액션 명세.
> 절차 열의 컨트롤명은 화면설계서 §3과 같다. 근거 열의 엔드포인트·SP·핸들러·시트 이름은 원문 그대로다.
> 기대결과에 Fact Pack으로 확정되지 않은 부분이 있으면 '(확인 필요)'를 붙였다. 실행할 때 As-is 동작과 대조해 값을 확정한다.
> 주석 처리된 호출은 테스트 케이스에 넣지 않았다.

공통 사전조건(별도 표기가 없을 때): ADMIN/PLANNER 계정 1개로 로그인하고 SSP0022 메뉴에 진입한다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0022-001 | 초기화 | 공통 | 화면을 연다 | — | cboBucketType 목록이 채워진다(DAILY/WEEKLY/MONTHLY 포함 여부 확인 필요) | `Form_Load`, GetBucketType, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0022-002 | 초기화 | 공통 | 화면을 연다 → spdMain 헤더를 확인한다 | — | 날짜 컬럼이 3단 헤더(LARGE/SMALL/SUM)로 생긴다. `B_` 컬럼은 숨김. SAT=Blue, SUN=Red | `Form_Load`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, SP `SSP0022_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-003 | 초기화 | 공통 | 화면을 연다 → 컨트롤 상태를 확인한다 | — | rdButton1 선택됨. drpPeriod 비활성. chkPastPeriod·chkMyModel·btnModelId 숨김 | `Form_Load` (props: rdButton1 Checked=true, drpPeriod Enabled=false) |
| TC-SSP0022-004 | 조회 | Company·Division·Plan-date 선택 | clbCompany_ID, clbDivision_ID, cboPlanDate 선택 → FindButton | 데이터가 있는 조건 | spdMain에 PSI 행이 표시된다 | FindButton, `SSP.SSP0022_GET_SHIPMENT_PSI`, SP `SSP0022_GET_SHIPMENT_PSI`, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-005 | 조회 | 〃 | FindButton | 데이터가 없는 Plant(clbPlantSite)·Material(txtItemId) | 0행. 오류 없이 헤더만 남는다(빈 결과 메시지 여부 확인 필요) | `SSP.SSP0022_GET_SHIPMENT_PSI` (빈 결과) |
| TC-SSP0022-006 | 조회 | SP 오류를 유발하는 조건(예: 권한 없는 계정·DB 객체 비활성) | FindButton | — | 오류 메시지가 표시되고 그리드는 이전 상태를 유지한다(확인 필요) | `SSP.SSP0022_GET_SHIPMENT_PSI` (오류 응답) |
| TC-SSP0022-007 | 이벤트 | 화면 진입 | clbCompany_ID 값을 바꾼다 | 다른 Company | PlantEE 목록 재조회. 그리드 재구성. 변경 중 cboPlanDate 이벤트가 연쇄 실행되지 않는다(3669 해제 / 3673 재연결) | `clbCompanyID_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [code=PlantEE], `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-008 | 이벤트 | 화면 진입 | cboPlanDate 값을 바꾼다 | 다른 Plan-date | drpPeriod에 FROM_DATE~TO_DATE가 반영되고(확인 필요) 날짜 컬럼이 다시 만들어진다 | `cboPlanDate_SelectedIndexChanged`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-009 | 이벤트 | 화면 진입 | clbDivision_ID 값을 바꾼다 | 다른 Division | DIVISION_ID를 읽는다. 화면 반영 내용은 확인 필요 | `clbDivision_ID_SelectedIndexChanged` |
| TC-SSP0022-010 | 그리드 | TC-004 조회 완료, rdButton1 | cboBucketType=DAILY 선택 | DAILY | X_D_ 표시. X_M_은 chkSum 상태를 따른다. X_W_ 최종값 기록(확인 필요) | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:1917·1922, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-011 | 그리드 | 〃 | cboBucketType=WEEKLY 선택 | WEEKLY | X_D_ 숨김, X_W_ 표시, X_M_ = chkSum | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:1930~1938 |
| TC-SSP0022-012 | 그리드 | 〃 | cboBucketType=MONTHLY 선택 | MONTHLY | X_D_·X_W_ 숨김, X_M_ 표시 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:1946·1950 |
| TC-SSP0022-013 | 그리드 | TC-004 조회 완료 | rdButton2 선택 | Cell | TOT/JR/PC_BOH_QTY_CELL 표시, 나머지 BOH 숨김. Y_ 날짜 컬럼 표시. 재조회 없음 | `rdButton_Changed`:1837~1845, SetSpreadColumn:1961·1965 |
| TC-SSP0022-014 | 그리드 | 〃 | rdButton3 선택 | Pancake m | _PCM 3컬럼 표시. Z_ 표시 | `rdButton_Changed`:1850~1858, SetSpreadColumn:2017·2021 |
| TC-SSP0022-015 | 그리드 | rdButton3 상태 | rdButton1 선택 | UOM | TOT/JR/PC_BOH_QTY 표시. X_ 표시 | `rdButton_Changed`:1823~1831 |
| TC-SSP0022-016 | 그리드 | TC-004 조회 완료, WEEKLY | chkSum 체크 → 해제 | 체크/해제 | ?_M_ 컬럼이 체크 상태를 따라 표시/숨김 | `chkSum_CheckedChanged`, SetSpreadColumn:1938 |
| TC-SSP0022-017 | 그리드 | chkPastPeriod는 Visible=false — 코드로 Checked를 바꿔 검증(TO-BE 이관 시 노출 여부 확인 필요) | chkPastPeriod 미체크 → 체크 | — | 미체크: 헤더 2행이 "SUM"이 아닌 과거 날짜 컬럼 숨김. 체크: 표시. 핸들러 2개가 모두 실행된다 | `chkPastPeriod_CheckedChanged`, `chkPastPeriod_CheckedChanged_1`, SetSpreadColumn:2081 |
| TC-SSP0022-018 | 이벤트 | 화면 진입 | btnMeasure 클릭 | — | 그리드 재구성(Measure 선택 UI 동작 확인 필요) | `BtnMeasure_Click`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-019 | 이벤트 | 화면 진입 | btnItemId 클릭 | — | 품목 선택 UI가 열리고 선택값이 txtItemId에 들어간다(대상 팝업 확인 필요) | `btnItemId_Click` |
| TC-SSP0022-020 | 이벤트 | 화면 진입 | btnItemID2 클릭 | — | 선택값이 txtItemld2에 들어간다(확인 필요) | `BtnItemID2_Click` |
| TC-SSP0022-021 | 이벤트 | 화면 진입 | btnRequestor 클릭 | — | 요청자 선택값이 txtRequestor에 들어간다(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0022-022 | 이벤트 | TC-004 조회 완료 | spdMain 셀 더블클릭 | 임의 데이터 셀 | 메인 재조회. 더블클릭한 셀 값이 조건에 반영되는지 기록 | `SpdMain_CellDoubleClick`, `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-023 | 이벤트 | TC-004 조회 완료 | spdMain 셀 클릭 | 임의 셀 | 핸들러 2개가 모두 실행된다. 화면 반영 확인 필요 | `SpdMain_CellClick`, `spdMain_CellClick_1` |
| TC-SSP0022-024 | 이벤트 | TC-004 조회 완료 | spdMain 셀 값을 바꾼다 | 수치 변경 | 변경 행 표시(확인 필요) | `SpdMain_Change` |
| TC-SSP0022-025 | 이벤트 | TC-004 조회 완료, 행 다수 | spdMain을 세로 스크롤한다 | — | 동작 기록(spdDetail 동기화 여부 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0022-026 | 이벤트 | TC-027 조회 완료 | spdDetail을 세로 스크롤한다 | — | 동작 기록(확인 필요) | `SpdDetail_TopChange` |
| TC-SSP0022-027 | 조회 | 상단 조건 선택 | drpPeriod2, txtModelId2, txtRequestor, textNickName2, txtItemld2, txtLotID 입력 → btnSearch | 데이터가 있는 조건 | `Shipment Request Detail` 시트에 요청 상세가 표시된다 | `BtnSearch_Click`, `SSP.SSP0022_GET_REQUEST_DETAIL`, SP `SSP0022_GET_REQUEST_DETAIL`, 시트 `Shipment Request Detail` |
| TC-SSP0022-028 | 조회 | 〃 | btnSearch | 〃 | `Stock Detail` 시트에 재고 상세가 표시된다 | `BtnSearch_Click`, `SSP.SSP0022_GET_STOCK_DETAIL`, SP `SSP0022_GET_STOCK_DETAIL`, 시트 `Stock Detail` |
| TC-SSP0022-029 | 조회 | 〃 | btnSearch | 존재하지 않는 txtLotID | 두 시트 모두 0행. 오류 없음 | `SSP.SSP0022_GET_REQUEST_DETAIL`, `SSP.SSP0022_GET_STOCK_DETAIL` (빈 결과) |
| TC-SSP0022-030 | 이벤트 | spdDetail 표시 | Stock Detail ↔ Shipment Request Detail 탭 전환 | — | 활성 시트가 바뀐다. 핸들러 등록 2회(831·834)에 따른 중복 실행 여부를 기록 | `SpdDetail_ActiveSheetChanged` |
| TC-SSP0022-031 | 이벤트 | spdDetail 표시 | 시트 탭 클릭(TabIndex 2 포함) | — | TabIndex 2 → `Shipment Request Detail Excel` 처리(실제 탭 구성 확인 필요) | `SpdDetail_SheetTabClick`, 시트 `Shipment Request Detail Excel` |
| TC-SSP0022-032 | 이벤트 | TC-027 완료 | spdDetail 셀 클릭 | — | 동작 기록(확인 필요) | `SpdDetail_CellClick` |
| TC-SSP0022-033 | 이벤트 | Shipment Request Detail 행 존재 | spdDetail 셀 편집 | Qty 변경 | 편집 상태 반영(EDIT_FLAG 변경 여부 확인 필요) | `SpdDetail_EditChange`, 시트 `Shipment Request Detail` |
| TC-SSP0022-034 | 이벤트 | 신규 행 | FROM_SITE / TO_SITE 콤보 선택 | 유효 Site | BOD 정보를 조회한다 | `SpdDetail_ComboSelChange`, FindData_BOD, `SSP.SSP0022_GET_ITEM_POPUP`, SP `SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-035 | 이벤트 | 신규 행 | spdDetail 셀 더블클릭 | — | BOD 정보를 조회한다(팝업 여부 확인 필요) | `SpdDetail_CellDoubleClick`, `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-036 | 이벤트 | Shipment Request Detail 활성 | Excel에서 복사한 행을 spdDetail에 붙여넣는다 | Site·Material 포함 행 | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY가 자동으로 채워진다 | `SpdDetail_ClipboardPasted`, `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-037 | 이벤트 | 〃 | 붙여넣기 | BOD가 없는 Site·Material 조합 | 자동 채움 없음(오류 처리 확인 필요) | `SpdDetail_ClipboardPasted`, `SSP.SSP0022_GET_ITEM_POPUP` (빈 결과) |
| TC-SSP0022-038 | 저장 | Shipment Request Detail 활성, IsLock=false | InsertButton | — | 새 행 추가. FROM_SITE·TO_SITE 셀 콤보 설정 | InsertButton, InsertRow, `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite / PlantByElectordeShipToSite], 시트 `Shipment Request Detail` |
| TC-SSP0022-039 | 저장 | Stock Detail 활성 | InsertButton | — | 콤보 설정이 실행되지 않는다(InsertRow:1481 조건 불충족) | InsertRow:1481, 시트 `Stock Detail` |
| TC-SSP0022-040 | 권한 | SSP 사용자로 등록된 계정 | EditButton | — | 편집 가능 상태로 전환(확인 필요) | EditButton, GetSSPUserCheck, `SSP.SSP0002_GET_USER_INFO_LIST`, SP `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0022-041 | 권한 | SSP 사용자 미등록 계정 | EditButton | — | 편집 차단 또는 메시지(확인 필요) | `SSP.SSP0002_GET_USER_INFO_LIST` (빈 결과) |
| TC-SSP0022-042 | 저장 | TC-038에서 필수값 입력 | SaveButton | From Site*, To Site*, Model*, Material*, Shipment ETA*, Qty*, Incoterms*, Trans Mode* | SSP_ANL_SHIP_REQ_EE INSERT, _H 이력 INSERT, SCM_SYS_LOG_BATCH INSERT → 상세 재조회. 시험 후 대상 행 복원 | SaveButton, SaveData_Detail, `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`, SP `SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0022_GET_REQUEST_DETAIL` |
| TC-SSP0022-043 | 저장 | 기존 요청 행 Qty 수정 | SaveButton | Qty 변경 | SSP_ANL_SHIP_REQ_EE UPDATE + 이력 INSERT. 시험 후 원복 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` (UPDATE 경로) |
| TC-SSP0022-044 | 저장 | 메인 저장 경로(SaveData 실행 조건 확인 필요) | SaveButton | — | 저장 후 메인 재조회 | SaveData:2863, `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0022_GET_SHIPMENT_PSI` |
| TC-SSP0022-045 | 저장 | 필수값 누락 행 | SaveButton | Qty 공란 | 저장 차단 또는 SP 오류 메시지(확인 필요). DB 변경 없음 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` (오류 응답) |
| TC-SSP0022-046 | 이벤트 | 상단 조건 선택 | formDown 클릭 | — | Excel 양식 데이터 생성(9컬럼 Company*~Trans Mode*) | `btnExcelFormDownload_Click`, `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN`, SP `SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN`, 시트 `Shipment Request Detail Excel` |
| TC-SSP0022-047 | 이벤트 | 요청 데이터가 없는 조건 | formDown 클릭 | — | 빈 양식(헤더만). 오류 없음 | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` (빈 결과) |
| TC-SSP0022-048 | 이벤트 | TC-046 양식 작성 | btnExcelUpload 클릭 → 파일 선택 | 정상 양식 | 업로드 후 메인·상세 재조회(업로드 내용 저장 경로 확인 필요) | `btnExcelUpload_Click`, `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0022_GET_REQUEST_DETAIL` |
| TC-SSP0022-049 | 이벤트 | — | btnExcelUpload 클릭 → 양식이 아닌 파일 | 컬럼 불일치 파일 | 오류 메시지(확인 필요). 데이터 변경 없음 | `btnExcelUpload_Click` (오류) |
| TC-SSP0022-050 | 초기화 | BodItemPopup 호출 | 팝업을 연다 | — | clbDivision·Site 목록 채움. 품목 그리드 조회 | `Form_Load`(BodItemPopup), `SCM.SCM0001_GET_DIVISION`, SP `SCM0001_GET_DIVISION`, `SCM.SCM0001_GET_SITE_BY_DIVISION`, SP `SCM0001_GET_SITE_BY_DIVISION`, `biz:CommonData.CommonDataList` [PlantByElectordeShipFromSite/ToSite], `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-051 | 그리드 | BodItemPopup 열림 | 그리드 컬럼 확인 | — | Division, Division, Model, Material, Incoterms, Transport Mode, BOD ID, Confirm Day 8컬럼 | 시트 `Project` (InitSpread:208~215, 소속 팝업 확인 필요) |
| TC-SSP0022-052 | 조회 | BodItemPopup 열림 | clbDivision, clbFromSite, clbToSite, txtItemID 입력 → btnButtonList 조회 | 데이터가 있는 조건 | 품목/BOD 목록 표시 | `btnButtonList_UsrButtonList_Click_Detected`, `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-053 | 조회 | BodItemPopup 열림 | FindButton | 없는 Material | 0행 | FindButton > FindData:258, `SSP.SSP0022_GET_ITEM_POPUP` (빈 결과) |
| TC-SSP0022-054 | 이벤트 | BodItemPopup 열림 | clbDivision 변경 | 다른 Division | 동작 기록(Site 재조회 여부 확인 필요) | `clbDivision_SelectedIndexChanged` (BodItemPopup Designer:189) |
| TC-SSP0022-055 | 이벤트 | TC-052 결과 존재 | 팝업 spdMain 행 더블클릭 | 임의 행 | 선택값 반환 후 팝업 닫힘(확인 필요) | `spdMain_CellDoubleClick` (BodItemPopup Designer:416) |
| TC-SSP0022-056 | 초기화 | ShipmentRequestPopup 호출 | 팝업을 연다 | — | 기간이 1개월 범위로 설정된다(SQL 원문 확인 필요) | `Form_Load`(ShipmentRequestPopup), GetDayRange, `SCP.GET_DATE_RANGE_1MONTH` |
| TC-SSP0022-057 | 이벤트 | ShipmentRequestPopup 열림 | clbDivision 변경 | 다른 Division | From/To Site·Incoterms·TransportMode 콤보 재설정. 품목 재조회 | `clbDivision_SelectedIndexChanged` (ShipmentRequestPopup Designer:144), `biz:CommonData.CommonDataList` [PlantByElectordeShipFromSite·PlantByElectordeShipToSite·Incoterms·TransportMode], `SSP.SSP0022_GET_ITEM_POPUP` |
| TC-SSP0022-058 | 그리드 | ShipmentRequestPopup 열림 | 그리드 컬럼 확인 | — | 26컬럼(Div*, SCM Site*, Plant, From Site*, To Site*, Model*, Material*, Nick Name, Shipment Date*, "Qty* ", Incoterms*, "Trans Mode* ", L/T(Day), ETD, ETA, ROUTE_ID~ORIGIN_FROM_DIVISION_ID). 타입 Combo/Text/Date/Num 일치 | 시트 `Shipment Reqeust(Electrode)` (InitSpread:257~285) |
| TC-SSP0022-059 | 이벤트 | ShipmentRequestPopup 행 존재 | 팝업 spdMain 콤보 셀 선택 | From/To Site | 셀 콤보 재설정 + 품목 조회 | `SpdMain_ComboSelChange`, `biz:CommonData.CommonDataList` [PlantByElectordeShipFromSite/ToSite], `SSP.SSP0022_GET_ITEM_POPUP`, 시트 `Shipment Reqeust(Electrode)` |
| TC-SSP0022-060 | 이벤트 | 〃 | 팝업 spdMain 셀 편집 | Model 입력 | 동작 기록(확인 필요) | `SpdMain_EditChange` |
| TC-SSP0022-061 | 이벤트 | 〃 | 팝업 spdMain 텍스트 변경 | Material 입력 | 동작 기록(확인 필요) | `SpdMain_TextChanged` |
| TC-SSP0022-062 | 이벤트 | 〃 | 팝업 spdMain 셀 클릭 | — | 동작 기록(확인 필요) | `SpdMain_CellClick` (ShipmentRequestPopup Form_Load:160) |
| TC-SSP0022-063 | 저장 | ShipmentRequestPopup 필수값 입력 | btnButtonList 저장 / SaveButton | 필수 컬럼 전부 | SSP_ANL_SHIP_REQ_EE 저장 + 이력. 시험 후 복원 | `btnButtonList_UsrButtonList_Click_Detected` (ShipmentRequestPopup Designer:192), SaveData:539, `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0022-064 | 저장 | 진입점 미연결 — 실행 경로가 확인된 뒤에만 수행 | BOD 품목 유효성 검사 경로 실행(경로 확인 필요) | 유효/무효 BOD | 무효 BOD 차단 여부 기록. 경로가 없으면 '미연결'로 판정 기록 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK`, SP `SSP0022_GET_BOD_ITEM_VALID_CHECK` (BodItemValidChk_main:4094, BodItemValidChk:4143, 팝업 BodItemValidChk:770) |
| TC-SSP0022-065 | 저장 | 진입점 미연결 — 팝업 BodValidChk:663 경로 확인 후 | BOD 유효성 검사 경로 실행 | 유효/무효 BOD | 결과 기록. 경로가 없으면 '미연결' 판정 | `SSP.SSP0002_GET_BOD_VALID_CHECK`, SP `SSP0002_GET_BOD_VALID_CHECK` (ShipmentRequestPopup BodValidChk:663) |
| TC-SSP0022-066 | 그리드 | TC-004 조회 완료 | spdMain 컬럼 확인 | — | 메타 28/0 + MEASURE 10/0 + 날짜 DB루프. 표시 22컬럼(?9 런타임) | 시트 `Shipment Request(Electrode)`, SCM_MST_SHEET_COLUMNS, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0022-067 | 그리드 | TC-028 조회 완료 | Stock Detail 컬럼 확인 | — | Div~Package Type (oWMS) 표시. FROM_SITE("Site") 숨김. 표시 31(?9) | 시트 `Stock Detail` |
| TC-SSP0022-068 | 그리드 | TC-027 조회 완료 | Shipment Request Detail 컬럼 확인 | — | 표시 19(?9). ROUTE_ID~TO_CITY 등 15컬럼 숨김. 헤더 '*' 원문 일치 | 시트 `Shipment Request Detail` |
| TC-SSP0022-069 | 그리드 | TC-046 완료 | Shipment Request Detail Excel 컬럼 확인 | — | Company*, Div*, FromSite*, ToSite*, Material*, yyyyMMdd*, Qty*, Incoterms*, Trans Mode* | 시트 `Shipment Request Detail Excel` |
| TC-SSP0022-070 | division | Division 40 계정 | clbDivision_ID=40 → FindButton → btnSearch | 40 | 시트별 컬럼 수: Shipment Request(Electrode) 22, Stock Detail 31, Shipment Request Detail 19, Excel 12 | grid_effective(40), `SSP.SSP0022_GET_SHIPMENT_PSI`, 시트 `Shipment Request(Electrode)` |
| TC-SSP0022-071 | division | Division 81 계정 | clbDivision_ID=81 → 같은 절차 | 81 | TC-070과 같은 컬럼 수 | grid_effective(81) |
| TC-SSP0022-072 | division | Division EE 계정 | clbDivision_ID=EE → 같은 절차 | EE | TC-070과 같은 컬럼 수(14종 동일 규칙 대표 검증). 81_* / EE_* 하위 코드는 같은 결과를 표본으로 확인한다 | grid_effective(EE) |
| TC-SSP0022-073 | 권한 | NowGroupID가 다른 계정 2개 | 화면 진입 → 조회조건 목록 비교 | 그룹 A / B | SetChangeControl 필터(GROUP_ID, USER_ID)에 따라 목록이 달라진다(차이 내용 확인 필요) | SetChangeControl:379~421, `Form_Load` |

## 커버리지 점검표

### 이벤트 핸들러 35종 → TC
| 핸들러 | TC |
|---|---|
| btnExcelFormDownload_Click | 046, 047 |
| btnExcelUpload_Click | 048, 049 |
| chkPastPeriod_CheckedChanged_1 | 017 |
| spdMain_CellClick_1 | 023 |
| Form_Load | 001~003, 050, 056 |
| SpdMain_TopChange | 025 |
| SpdDetail_TopChange | 026 |
| cboBucketType_SelectedIndexChanged | 010~012 |
| rdButton_Changed | 013~015 |
| chkSum_CheckedChanged | 016 |
| chkPastPeriod_CheckedChanged | 017 |
| BtnMeasure_Click | 018 |
| btnItemId_Click | 019 |
| BtnItemID2_Click | 020 |
| BtnSearch_Click | 027, 028 |
| BtnRequestor_Click | 021 |
| SpdMain_CellClick | 023, 062 |
| SpdDetail_ActiveSheetChanged | 030 |
| SpdDetail_SheetTabClick | 031 |
| SpdDetail_CellClick | 032 |
| SpdDetail_ComboSelChange | 034 |
| SpdDetail_CellDoubleClick | 035 |
| SpdDetail_ClipboardPasted | 036, 037 |
| SpdDetail_EditChange | 033 |
| SpdMain_CellDoubleClick | 022 |
| SpdMain_Change | 024 |
| clbDivision_ID_SelectedIndexChanged | 009 |
| clbCompanyID_SelectedIndexChanged | 007 |
| cboPlanDate_SelectedIndexChanged | 008 |
| clbDivision_SelectedIndexChanged | 054, 057 |
| btnButtonList_UsrButtonList_Click_Detected | 052, 063 |
| spdMain_CellDoubleClick | 055 |
| SpdMain_EditChange | 060 |
| SpdMain_ComboSelChange | 059 |
| SpdMain_TextChanged | 061 |

### 엔드포인트 15종 → TC
| 엔드포인트 | TC |
|---|---|
| biz:CommonData.CommonDataList | 007, 038, 050, 057, 059 |
| DM.DM0003_GET_BUCKET_TYPE_CODE | 001 |
| SSP.SSP0022_GET_SHIPMENT_PSI | 004~006, 022, 044, 048, 070 |
| SSP.SSP0022_GET_REQUEST_DETAIL | 027, 029, 042, 048 |
| SSP.SSP0022_GET_STOCK_DETAIL | 028, 029 |
| SSP.SSP0022_SAVE_SHIPMENT_REQUEST | 042~045, 063 |
| SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | 046, 047 |
| SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | 002, 007, 008, 018, 022, 048, 066 |
| SSP.SSP0022_GET_ITEM_POPUP | 034~037, 050, 052, 053, 057, 059 |
| SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | 064 |
| SSP.SSP0002_GET_USER_INFO_LIST | 040, 041 |
| SCM.SCM0001_GET_DIVISION | 050 |
| SCM.SCM0001_GET_SITE_BY_DIVISION | 050 |
| SSP.SSP0002_GET_BOD_VALID_CHECK | 065 |
| SCP.GET_DATE_RANGE_1MONTH | 056 |

### 시트 6종 → TC
| 시트 | TC |
|---|---|
| Project | 051 |
| Shipment Reqeust(Electrode) | 058, 059 |
| Shipment Request Detail | 027, 033, 038, 068 |
| Shipment Request Detail Excel | 031, 046, 069 |
| Shipment Request(Electrode) | 002, 004, 010, 066, 070 |
| Stock Detail | 028, 039, 067 |

### 기타
- 빈 결과 케이스: 005, 029, 037, 041, 047, 053.
- 오류 응답 케이스: 006, 045, 049.
- 실저장 TC(042·043·063)는 저장 직전 대상 행을 기록하고, 시험이 끝나면 DB를 복원한다.
