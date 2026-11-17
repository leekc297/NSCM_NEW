# SSP0201 Shipment Change Request — 단위테스트

> **근거 범위**: Fact Pack(SSP0201)과 업무분석서·화면설계서. 절차 열의 컨트롤명은 화면설계서 §3 이름을, 근거 열의 엔드포인트·SP·핸들러·시트 이름은 원문 그대로 씁니다.
> 기대결과 중 Fact Pack에 근거가 없는 부분(메시지 문구, 코드 목록 등)은 **확인 필요**로 적었습니다. 이 부분은 AS-IS 실행 결과로 기대값을 확정해야 합니다.
> 주석 처리된 호출 4건(1179, 1561, 1937, 2720줄)과 진입점이 없는 `GetErpIFCheck`는 테스트 케이스로 만들지 않았습니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0201-001 | 초기화 | SSP0201 메뉴 접근 권한이 있는 사용자 로그인 | 화면을 연다 | — | GetDayRange가 서버를 호출하고, drpPeriod에 기간 기본값이 세팅됨 | `Form_Load` > InitControls > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD` / SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0201-002 | 초기화 | TC-001 | 화면을 연 뒤 spdMain, spdSub 헤더를 확인한다 | — | spdMain = 시트 `Shipment Change Request`(헤더 1행), spdSub = 시트 `Change Request`(헤더 2행, ColumnHeaderSpan) | `Form_Load`, CreateSpread:523/527/537, InitSpread:546/599, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-003 | 초기화 | TC-001 | 숨김 컨트롤을 확인한다 | — | txtSoNo, btnSave, btnAdd, dtDate가 보이지 않음(Designer Visible=false). btnChangeRe2, btnCancel, btnDel, btnNew, btnChangeRe는 보임 | props.csv Visible=false (txtSoNo 420, dtDate 993, btnSave 1022, btnAdd 1033), `Form_Load` |
| TC-SSP0201-004 | 초기화(오류) | `SCP.SCM0001_GET_SCP_DAY_PERIOD`가 빈 결과 또는 오류를 반환하도록 설정 | 화면을 연다 | — | 화면이 비정상 종료되지 않음. drpPeriod 값과 오류 메시지는 **확인 필요**(AS-IS 실행으로 기대값 확정) | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0201-005 | 이벤트 | TC-001 | cboChangeType 값을 바꾼다 | 바꾸기 전과 다른 Change Type 값 | GetDayRange가 다시 호출되어 drpPeriod가 재계산됨 | `CboChangeType_SelectedIndexChanged` > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0201-006 | 그리드 | cboChangeType = "P" | 그리드를 구성(조회)한 뒤 헤더·컬럼을 확인한다 | cboChangeType="P" | `Shipment Change Request`: ERP_SO_NO, CONFIRM_ID Width=0 / `Change Request`: ERP_SO_NO 숨김, 0행 헤더 "Plan"(LT_DAY~7열), "Confirm"(NEW_LT_DAY~7열) | InitSpread 554, 555, 624, 626~641, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-007 | 그리드 | cboChangeType ≠ "P" | 그리드를 구성(조회)한 뒤 헤더·컬럼을 확인한다 | cboChangeType="P"가 아닌 값(목록 확인 필요) | `Shipment Change Request`: CONFIRM_ID Width=120 / `Change Request`: ERP_SO_NO 표시, 0행 헤더 "Confirmed", "Change" | InitSpread 567, 646, 648~663, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-008 | 이벤트 | TC-001 | clbDivision_ID를 다른 Div로 바꾼다 | Div=40 → 81 | 정적 추출상 서버 호출 없음. 화면 반영 내용(그리드 컬럼 재구성, 조회조건 재세팅 등)은 **확인 필요** | `clbDivision_ID_SelectedIndexChanged` (InitEvent:360) |
| TC-SSP0201-009 | 조회 | 조회 대상 출하 확정 데이터가 있음 | clbDivision_ID, clbFromSite, clbToSite, drpPeriod, cboStatus, cboChangeType을 지정하고 툴바 조회를 누른다 | Div=81, 기간=기본값 | spdMain(`Shipment Change Request`)에 목록 표시 | FindButton > FindData_Main, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` / SP `SSP0201_GET_SHIPMENT_CHANGE_REQUEST` |
| TC-SSP0201-010 | 조회 | 변경 요청(드래프트) 데이터가 있음 | 툴바 조회를 누른다 | TC-009와 같음 | spdSub(`Change Request`)에 상세 표시. ds.Tables[1]의 USER_NAME, DEPT_NAME_KO 등 요청자 정보가 txtRequestor/txtRequestDeptName에 반영(대상 컨트롤 확인 필요) | FindButton > FindData_Sub_Draft, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` / SP `SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-011 | 조회(빈 결과) | 조건에 맞는 데이터가 없음 | txtConfirmId에 없는 ID를 넣고 조회한다 | Confirm Id = 존재하지 않는 값 | spdMain, spdSub가 0행. 안내 메시지는 **확인 필요** | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING`, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-012 | 조회(오류) | 조회 SP가 오류를 반환하도록 설정 | 조회한다 | — | 오류 메시지가 표시되고 그리드가 깨지지 않음(문구 **확인 필요**) | FindButton, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` |
| TC-SSP0201-013 | 그리드 | 조회 결과에 SHIPMENT_STATUS가 "R"이 아닌 행이 있고 sSearchType = "Exist" | 조회 후 spdSub CHK 컬럼을 확인한다 | — | 해당 조건에서 CHK 컬럼 숨김(2061). "R"인 경우는 표시 유지 | SetChangeRequestSOGrid 2061, 시트 `Change Request` |
| TC-SSP0201-014 | 저장(행 추가) | spdMain 시트 잠금 해제(IsLock=false) | 툴바 행 추가를 누른다 | clbDivision_ID=40 | spdMain에 신규 행 추가, TO_SITE_SHIPTO_CODE 콤보 세팅 | InsertButton > InsertRow(2455), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-015 | 권한 | spdMain 시트 잠금(IsLock=true) | 툴바 행 추가와 btnNew를 누른다 | — | 행 추가와 콤보 세팅이 동작하지 않음 | InsertRow, `BtnNew_Click`, `siMain.IsLock(siMain.SheetName) == false` 조건 |
| TC-SSP0201-016 | 이벤트 | IsLock=false | btnNew("NEW")를 누른다 | — | spdMain에 신규 행 추가, Ship to 콤보 세팅 | `BtnNew_Click`(2996), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-017 | 저장 | spdMain에 필수 컬럼을 모두 입력한 신규 행이 있음 | 툴바 저장을 누른다 | 필수 컬럼(§업무분석서 4-1) 입력 | 변경 요청 번호가 채번됨 | SaveButton(780), `SSP.SSP0201_GET_CHANGE_REQ_NO` / SP `SSP0201_GET_CHANGE_REQ_NO` |
| TC-SSP0201-018 | 저장 | TC-017 | 저장 후 DB를 확인한다 | — | SSP_ANL_SHIP_CONFIRM에 행 INSERT, SCM_SYS_LOG_BATCH 로그 INSERT | SaveButton(936), `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` / SP `SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` |
| TC-SSP0201-019 | 저장(검증) | spdMain 행의 shipment_confirm_qty 또는 TRANSPORT_MODE 비움 | 툴바 저장을 누른다 | Shipment Qty = 빈값 | 저장이 중단되고 검증 메시지가 표시됨(문구·대상 행 표시 방식 **확인 필요**). SP 호출 없음 | SaveButton > SSP_Main_Validation 3188~3195 / 3238~3244, 시트 `Shipment Change Request` |
| TC-SSP0201-020 | 저장(검증) | Validationdr 경로의 행에서 INCOTERMS 비움 | 저장을 누른다 | INCOTERMS = 빈값 | Validationdr 경로는 INCOTERMS 검사 대상, SONoValidationdr 경로는 아님. 경로 분기 조건 **확인 필요** | SSP_Main_Validation 3188~3195 vs 3238~3244 |
| TC-SSP0201-021 | 저장 | ERP 연계 대상 행이 있음 | 툴바 저장을 누른다 | — | 출하 상태 검사 SP가 호출되고, ds.Tables[0~2]의 CONFIRM_ID로 검사함 | SaveButton > GetERPInterface > GetShipmentStatusChk(3571), `SSP.SSP0201_GET_SHIPMENT_STATUS` / SP `SSP0201_GET_SHIPMENT_STATUS` |
| TC-SSP0201-022 | 저장 | TC-021 | 저장한다 | — | SO 건수 SP가 호출되고 CNT 값을 읽음. CNT에 따른 분기(SoNo/NonSoNo)는 **확인 필요** | SaveButton > GetERPInterface > GetErpSoNoCnt(3636), `SSP.SSP0201_GET_ERP_SO_NO_CNT` / SP `SSP0201_GET_ERP_SO_NO_CNT` |
| TC-SSP0201-023 | 저장 | SO 번호가 있는 행(SoNo 경로) | 저장한다 | ERP_SO_NO 있음 | SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE INSERT, SSP_ANL_SHIP_CONFIRM UPDATE | SaveButton > GetERPInterface > SoNo(4163), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` / SP `SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-024 | 저장 | SO 번호가 없는 행(NonSoNo / NewNonSoNo 경로) | 저장한다 | ERP_SO_NO 없음 | TC-023과 같은 테이블 반영. GetERPInterface/GetNewERPInterface 분기 조건 **확인 필요** | NonSoNo(3939), GetNewERPInterface > NewNonSoNo(3768), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-025 | 저장 | 저장 완료 | 저장 후 재조회를 확인한다 | — | spdMain이 재조회됨(FindData_Main_Nonasync 경로) | SaveButton > FindData_Main_Nonasync(1417), `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` / SP `SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` |
| TC-SSP0201-026 | 저장 | 저장 완료 | FindButton 재조회 경로를 확인한다 | — | spdMain, spdSub 재조회. TC-025와 갈리는 조건은 **확인 필요** | SaveButton > FindButton > FindData_Main / FindData_Sub_Draft, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-027 | 저장(검증) | dtERPBlockYnIF BLOCK_YN이 차단 값 | 저장한다 | BLOCK_YN = 차단 값(값 **확인 필요**) | 저장이 차단되거나 경고가 표시됨(동작·문구 **확인 필요**) | chkERPIFBlockYn (BLOCK_YN, PERIOD) |
| TC-SSP0201-028 | 저장(오류) | 저장 SP가 오류를 반환하도록 설정 | 저장한다 | — | 오류 메시지가 표시되고 재조회 전 상태가 유지됨. 롤백 범위는 **확인 필요** | SaveButton, `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` |
| TC-SSP0201-029 | 이벤트 | spdSub에 드래프트 요청이 있고 usrLayoutControl3 요청 정보(txtTitle, txtApproval, cboChangeReason, txtReasonDetail)가 입력됨 | btnChangeRe("Request Complete", 조회조건 영역)를 누른다 | — | SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE, SSP_ANL_SHIP_CONFIRM UPDATE, 메일 발송 로그(SCM_ADM_SMS_MAIL_SEND_LOG) INSERT 후 재조회 | `BtnChangeRe_Click` > SaveDataDrafting(2222), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` / SP `SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-030 | 이벤트 | TC-029와 같음 | btnChangeRe2("Request Complete", 버튼 영역)를 누른다 | — | TC-029와 같은 결과 | `BtnChangeRe_Click`(btnChangeRe2.Click, InitEvent:372), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-031 | 이벤트 | TC-029 완료 | 완료 후 그리드를 확인한다 | — | spdMain, spdSub 재조회 | `BtnChangeRe_Click` > SaveDataDrafting > FindButton, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-032 | 이벤트 | btnSave가 보이는 상태(Designer Visible=false, 표시 조건 **확인 필요**) | btnSave("Save Draft")를 누른다 | — | COMPLETE SP 호출 후 재조회(TC-029와 같은 SP) | `BtnSave_Click` > SaveDataDrafting(2222), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-033 | 이벤트(오류) | COMPLETE SP가 오류를 반환하도록 설정 | btnChangeRe를 누른다 | — | 오류 메시지가 표시되고 메일이 발송되지 않음(문구 **확인 필요**) | `BtnChangeRe_Click`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-034 | 이벤트 | spdSub에 드래프트 요청이 있고 CHK로 선택함 | btnCancel("Cancel")을 누른다 | CHK 선택 1건 | SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE UPDATE, SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_PACK_SHIP_PLAN_S_SN·XIF_SCS_PACK_SHIP_PLAN_S_SN INSERT 후 재조회 | `BtnCancel_Click` > DeleteDataDrafting(2379), `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` / SP `SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-035 | 이벤트(빈 선택) | spdSub에서 아무 행도 선택하지 않음 | btnCancel을 누른다 | CHK 선택 0건 | 처리 여부와 안내 메시지는 **확인 필요** | `BtnCancel_Click`, `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`, 시트 `Change Request` |
| TC-SSP0201-036 | 이벤트 | TC-001 | btnApprovalUser를 누른다 | — | 정적 추출상 서버 호출 없음. txtApproval/txtAppDeptName 반영 여부는 **확인 필요** | `BtnApprovalUser_Click` (InitEvent:362) |
| TC-SSP0201-037 | 이벤트 | TC-001 | btnItemId를 누른다 | — | 정적 추출상 서버 호출 없음. txtRequest/txtItemId 반영 여부는 **확인 필요** | `btnItemId_Click` (InitEvent:383) |
| TC-SSP0201-038 | 이벤트 | dsdm 데이터 소스 변경 발생(dsdm 정체 **확인 필요**) | dsdm Changed가 일어나게 한다 | — | 핸들러가 오류 없이 실행됨. 처리 내용은 **확인 필요** | `shtMain_Change` (dsdm.Changed, InitEvent:365) |
| TC-SSP0201-039 | 이벤트 | 조회 결과가 화면보다 많음 | spdMain을 세로로 스크롤한다 | — | 핸들러가 오류 없이 실행됨. 처리 내용은 **확인 필요** | `SpdMain_TopChange` (InitEvent:361), 시트 `Shipment Change Request` |
| TC-SSP0201-040 | 그리드 | IsLock=false, spdMain에 행 존재 | spdMain의 TRANSPORT_MODE 셀을 클릭한다 | — | Trans Mode 콤보 목록 로딩 | `SpdMain_CellClick`(4677), `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0201-041 | 그리드 | IsLock=false | spdMain의 TO_SITE_SHIPTO_CODE 셀을 클릭한다 | — | Ship to 콤보 목록 로딩 | `SpdMain_CellClick`(4691), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-042 | 그리드 | spdMain 행 1건 이상, 헤더에 체크박스 셀 존재 | 헤더 체크박스를 두 번 클릭한다 | — | 1회: 현재 값 반전(true↔false), 2회: 원복 | `SpdMain_CellClick` 4705/4740/4744 |
| TC-SSP0201-043 | 그리드 | spdMain에 행 존재 | spdMain 셀을 더블클릭한다 | — | 핸들러가 오류 없이 실행됨. 처리 내용은 **확인 필요** | `SpdMain_CellDoubleClick` (InitEvent:379) |
| TC-SSP0201-044 | 그리드 | spdMain에 편집 가능한 행 존재 | spdMain 셀 값을 편집한다 | 임의 값 | 핸들러가 오류 없이 실행됨. 행 변경 표시 등 처리 내용은 **확인 필요** | `SpdMain_EditChange` (InitEvent:380) |
| TC-SSP0201-045 | 그리드 | IsLock=false | 엑셀에서 복사한 여러 행을 spdMain에 붙여넣는다 | 2행 | 붙여넣은 행의 Ship to 콤보가 세팅됨 | `SpdMain_ClipboardPasted`(5143), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-046 | 그리드 | spdMain에 행 존재 | 콤보 컬럼 값을 바꾼다 | To Site 변경 | Ship to 콤보 재세팅 | `SpdMain_ComboSelChange`(4815), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-047 | 그리드 | BOD 마스터에 해당 경로 존재 | spdMain에서 BOD 조회를 일으키는 콤보(트리거 컬럼 **확인 필요**)를 바꾼다 | — | 행의 ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL이 채워지고 Trans Mode 콤보가 세팅됨 | `SpdMain_ComboSelChange` > FindData_BOD(5840/5860), `SSP.SSP0026_GET_BOD_ITEM` / SP `SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0201-048 | 그리드(빈 결과) | BOD 마스터에 해당 경로 없음 | TC-047과 같은 조작을 한다 | — | 행 값 세팅 없음. 오류 처리·안내는 **확인 필요** | FindData_BOD, `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0201-049 | 그리드 | spdMain에 행 존재 | spdMain 행의 DIVISION_ID 콤보를 40으로, 다시 81로 바꾼다 | 40 → 81 | 40: END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김 / 81: 반대 | `SpdMain_ComboSelChange` 4870~4872, 4879~4881, 시트 `Shipment Change Request` |
| TC-SSP0201-050 | 그리드 | spdMain에 행 2건 이상 | spdMain에서 다른 행으로 커서를 옮긴다 | — | 핸들러가 오류 없이 실행됨. 하단 spdSub 연동 여부는 **확인 필요** | `SpdMain_CursorChanged` (InitEvent:387) |
| TC-SSP0201-051 | 그리드 | 조회 완료(Div=81, cboChangeType≠"P") | spdMain 표시 컬럼을 메타와 대조한다 | — | 메타 기본 33컬럼 중 END_CUSTOMER 숨김 → 32컬럼. 헤더 라벨은 화면설계서 §4-1과 같음. 메타 숨김 32컬럼은 보이지 않음 | 시트 `Shipment Change Request`, SCM_MST_SHEET_COLUMNS(65행), grid_effective |
| TC-SSP0201-052 | 그리드 | 조회 완료(Div=81, cboChangeType≠"P") | spdSub 표시 컬럼과 2단 헤더를 대조한다 | — | 메타 기본 28컬럼, 0행 "Confirmed"/"Change" 7열 병합, 1행 라벨은 화면설계서 §4-2와 같음. REMARKS는 Width=0이라 보이지 않음 | 시트 `Change Request`, SCM_MST_SHEET_COLUMNS(58행), InitSpread 619 |
| TC-SSP0201-053 | division | clbDivision_ID=40 | 조회 후 두 그리드의 표시 컬럼 수를 센다 | Div=40 | `Shipment Change Request` 31컬럼(END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김), `Change Request` 27컬럼(판단불가 ?4/?5는 실행 확인) | InitSpread 578~580, grid_effective, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-054 | division | clbDivision_ID=EE | TC-053과 같음 | Div=EE | `Shipment Change Request` 31, `Change Request` 27 | InitSpread 578~580, grid_effective |
| TC-SSP0201-055 | division | clbDivision_ID=81 | TC-053과 같음 | Div=81 | `Shipment Change Request` 32(END_CUSTOMER 숨김, PROJECT_* 표시), `Change Request` 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-056 | division | clbDivision_ID=81_HD | TC-053과 같음 | Div=81_HD | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-057 | division | clbDivision_ID=81_HG | TC-053과 같음 | Div=81_HG | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-058 | division | clbDivision_ID=81_HM | TC-053과 같음 | Div=81_HM | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-059 | division | clbDivision_ID=81_ST | TC-053과 같음 | Div=81_ST | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-060 | division | clbDivision_ID=81_UC | TC-053과 같음 | Div=81_UC | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-061 | division | clbDivision_ID=82 | TC-053과 같음 | Div=82 | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-062 | division | clbDivision_ID=EE_HD | TC-053과 같음 | Div=EE_HD | 32 / 28 (EE_* 계열은 "EE"와 정확히 같지 않으므로 '그 외'에 속함) | InitSpread 585~587, grid_effective |
| TC-SSP0201-063 | division | clbDivision_ID=EE_HG | TC-053과 같음 | Div=EE_HG | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-064 | division | clbDivision_ID=EE_HM | TC-053과 같음 | Div=EE_HM | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-065 | division | clbDivision_ID=EE_ST | TC-053과 같음 | Div=EE_ST | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-066 | division | clbDivision_ID=EE_UC | TC-053과 같음 | Div=EE_UC | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-067 | 권한 | TB_FX_GroupMenuAuth에 등록된 그룹별 계정(8행, 값 **확인 필요**) | 그룹별로 로그인해 조회·행 추가·저장·Request Complete·Cancel을 시도한다 | 그룹별 계정 | 그룹 권한 플래그대로 툴바·버튼이 동작/차단됨(기대값은 행 내용 확인 후 확정) | TB_FX_GroupMenuAuth, FindButton, InsertButton, SaveButton, `BtnChangeRe_Click`, `BtnCancel_Click` |
| TC-SSP0201-068 | 권한 | 서로 다른 NowGroupID를 가진 두 사용자 | 각각 화면을 열어 조회조건 콤보 목록을 비교한다 | — | GetSSPInnerTable(GROUP_ID, USER_ID 필터) 결과에 따라 목록이 다를 수 있음(기대값 **확인 필요**) | SetChangeControl 312~349, `Form_Load` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러(17) | `Form_Load` | 001~004 |
| | `clbDivision_ID_SelectedIndexChanged` | 008 |
| | `SpdMain_TopChange` | 039 |
| | `BtnApprovalUser_Click` | 036 |
| | `shtMain_Change` | 038 |
| | `BtnSave_Click` | 032 |
| | `BtnChangeRe_Click` | 029~031, 033 |
| | `BtnCancel_Click` | 034, 035 |
| | `BtnNew_Click` | 015, 016 |
| | `SpdMain_CellClick` | 040~042 |
| | `SpdMain_CellDoubleClick` | 043 |
| | `SpdMain_EditChange` | 044 |
| | `SpdMain_ClipboardPasted` | 045 |
| | `SpdMain_ComboSelChange` | 046~049 |
| | `btnItemId_Click` | 037 |
| | `CboChangeType_SelectedIndexChanged` | 005 |
| | `SpdMain_CursorChanged` | 050 |
| 엔드포인트(13) | `SSP.SSP0201_GET_CHANGE_REQ_NO` | 017 |
| | `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | 018, 028 |
| | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | 009, 011, 012, 026, 031 |
| | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | 025 |
| | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 010, 011, 026, 031 |
| | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | 029, 030, 032, 033 |
| | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | 034, 035 |
| | `biz:CommonData.CommonDataList` | 014, 016, 040, 041, 045, 046, 047 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 001, 004, 005 |
| | `SSP.SSP0201_GET_SHIPMENT_STATUS` | 021 |
| | `SSP.SSP0201_GET_ERP_SO_NO_CNT` | 022 |
| | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | 023, 024 |
| | `SSP.SSP0026_GET_BOD_ITEM` | 047, 048 |
| 시트(2) | `Shipment Change Request` | 002, 006, 007, 049, 051, 053~066 |
| | `Change Request` | 002, 006, 007, 013, 052, 053~066 |
| division(14) | 40, EE, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | 053~066 |
| 빈 결과 / 오류 | 조회·BOD·취소 빈 결과 / 초기화·조회·저장·완료 오류 | 004, 011, 012, 028, 033, 035, 048 |

- 제외: 주석 처리된 호출 4건(1179 SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW 주석본, 1561, 1937, 2720), 진입점이 없는 `GetErpIFCheck`(4276), 배선이 없는 btnDel·btnAdd.
