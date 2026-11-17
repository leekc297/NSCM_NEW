# SSP0200 Shipment Change Request — 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 씁니다.
> 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> Fact Pack에 기대값 근거가 없는 항목은 기대결과에 **확인 필요**를 함께 적었습니다.
> 주석 처리된 호출은 테스트 대상에서 뺐습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0200-001 | 초기화 | SSP0200 권한이 있는 사용자 | 화면을 엽니다 | — | drpPeriod에 기간 초기값이 설정됩니다(기간 길이 확인 필요) | `Form_Load` > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SCM0001_GET_SCP_DAY_PERIOD |
| TC-SSP0200-002 | 초기화 | 같음 | 화면을 열고 clbDivision_ID 목록을 확인합니다 | — | 사용자 그룹 권한(TB_FX_USERGROUPAUTHEXTENTION) 범위의 Div 목록이 표시됩니다 | `Form_Load` > GetDivision, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, SSP0200_GET_SHIPMENT_DIVISION |
| TC-SSP0200-003 | 초기화 | 같음 | 화면을 열고 clbFromSite 목록을 확인합니다 | — | 선택된 Div의 From Site 목록이 표시됩니다 | `Form_Load` > SetChangedControl > GetShipmentPlanPlantSite, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0200-004 | 이벤트 | 화면이 열려 있음 | clbDivision_ID 값을 다른 Div로 바꿉니다 | Div=40 → 81 | clbFromSite 목록이 다시 조회됩니다 | `clbDivision_ID_SelectedIndexChanged`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0200-005 | 이벤트 | 화면이 열려 있음 | cboChangeType 값을 바꿉니다 | ChangeType="P" | drpPeriod 기간이 다시 계산됩니다(값 확인 필요) | `CboChangeType_SelectedIndexChanged` > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0200-006 | 그리드 | cboChangeType="P" | 조회 버튼을 누르고 spdMain 컬럼을 확인합니다 | ChangeType="P" | 시트 `Shipment Change Request`의 ERP_SO_NO, CONFIRM_ID가 Width=0입니다. 시트 `Change Request`의 ERP_SO_NO가 숨겨지고 2단 헤더가 "Plan"/"Confirm"입니다 | InitSpread:607/608/701, `Shipment Change Request`, `Change Request` |
| TC-SSP0200-007 | 그리드 | cboChangeType이 "P"가 아님 | 조회 후 컬럼을 확인합니다 | ChangeType≠"P" | `Shipment Change Request`의 ERP_SO_NO Width=100, CONFIRM_ID Width=120입니다. `Change Request`의 ERP_SO_NO가 표시되고 헤더가 "Confirmed"/"Change"입니다 | InitSpread:618/619/723, `Shipment Change Request`, `Change Request` |
| TC-SSP0200-008 | 조회 | 조회 대상 데이터가 있음 | 조건(clbDivision_ID, clbFromSite, drpPeriod, cboChangeType)을 입력하고 조회합니다 | Div=40, 기간=초기값 | 상단 spdMain에 결과가 표시됩니다 | FindButton > FindData_Main, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, SSP0200_GET_SHIPMENT_CHANGE_REQUEST, `Shipment Change Request` |
| TC-SSP0200-009 | 조회 | 같음 | 같은 조회에서 하단을 확인합니다 | 같음 | 하단 spdSub에 Draft가 표시됩니다. txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, cboChangeReason, txtReasonDetail 값이 채워집니다(SetChangeRequestInfo) | FindButton > FindData_Sub_Draft, `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING`, SSP0200_GET_SHIPMENT_REQUEST_DRAFTING, `Change Request` |
| TC-SSP0200-010 | 조회 | 조건에 맞는 데이터가 없음 | 존재하지 않는 txtSoNo로 조회합니다 | SO No=존재하지 않는 값 | spdMain, spdSub가 0행이고 오류가 없습니다. 메시지 문구는 확인 필요 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-011 | 조회 | 다건 조건 | txtSoNo와 txtConfirmId에 여러 줄을 붙여넣고 clbFromSite를 여러 개 선택한 뒤 조회합니다 | SO 2건, Site 2개 | 입력한 값 전부에 해당하는 결과가 나옵니다(GetCheckedListValue 다건 전달) | FindData_Main:1466~1473, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` |
| TC-SSP0200-012 | 그리드 | 조회 결과가 있음 | spdMain 컬럼 헤더를 확인합니다 | Div=81 | `Shipment Change Request`에 메타 헤더(Div, Confirm/Plan ID, SO No, Status, Model*, … Trans Mode*)가 표시되고 표시 컬럼은 32개입니다(판단불가 ?4 별도 확인) | SetSheetHeaderColumn@InitSpread:598, `Shipment Change Request` |
| TC-SSP0200-013 | 그리드 | 조회 결과가 있음 | spdSub 헤더를 확인합니다 | Div=81 | `Change Request`가 2단 헤더(기존 6열/변경 6열 Span)로 표시되고, CHK가 CheckBox(기본 false), REMARKS가 Width=0입니다. 표시 컬럼은 26개입니다(?5) | SetSheetHeaderColumn@InitSpread:659, InitSpread:672~696, `Change Request` |
| TC-SSP0200-014 | division | Div=40 선택 | 조회 후 spdMain을 확인합니다 | Div=40 | END_CUSTOMER, ERP_ATTR1(Consignee Name), ERP_ATTR2(Contact Point), ERP_ATTR3(Lot)이 표시되고 PROJECT_CODE, PROJECT_NAME이 숨겨집니다. 34열입니다 | InitSpread:630~637, `Shipment Change Request` |
| TC-SSP0200-015 | division | Div=EE 선택 | 조회 후 spdMain을 확인합니다 | Div=EE | TC-014와 같습니다(34열) | InitSpread:630~637, `Shipment Change Request` |
| TC-SSP0200-016 | division | Div=81 계열/82/EE_* 선택 | 조회 후 spdMain을 확인합니다 | Div=82 | END_CUSTOMER, ERP_ATTR1~3이 숨겨지고 PROJECT_CODE, PROJECT_NAME이 표시됩니다. 32열입니다 | InitSpread:641~648, `Shipment Change Request` |
| TC-SSP0200-017 | division | Div=40 / 그 외 | 조회 후 spdSub 표시 컬럼 수를 비교합니다 | Div=40, 81 | 40은 25열, 81은 26열입니다. 귀속 추정 컬럼은 확인 필요 | grid_effective, `Change Request` |
| TC-SSP0200-018 | 이벤트 | 그리드가 잠기지 않음 | 프레임워크 행추가(InsertButton)를 누릅니다 | — | spdMain에 신규 행이 추가되고 FROM_SITE_DESCRIPTION 콤보 목록이 설정됩니다 | InsertButton > InsertRow, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` |
| TC-SSP0200-019 | 이벤트 | 그리드가 잠기지 않음 | btnNew를 클릭합니다 | — | 신규 행이 추가됩니다. DIVISION_ID 콤보에 "EE"가 없습니다 | `BtnNew_Click`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` |
| TC-SSP0200-020 | 이벤트 | 그리드가 잠기지 않음 | btnInsertMultiple을 클릭하고 팝업의 txtCurrentInsert_Qty에 3을 입력한 뒤 btnButtonList 확인을 누릅니다 | 수량=3 | spdMain에 3행이 추가되고 Item/From Site가 설정됩니다(값 확인 필요) | `btnInsertMultiple_Click` > InsertRowMultiple, `SSP.SSP0200_GET_ITEM_FROM_BOD`, SSP0200_GET_ITEM_FROM_BOD, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` |
| TC-SSP0200-021 | 이벤트 | btnInsertMultiple 클릭 | 팝업이 열릴 때 초기 상태를 확인합니다 | — | usrLabel1, txtCurrentInsert_Qty, btnButtonList가 표시됩니다. 초기값은 확인 필요 | `Form_Load` (InsertPopup .ctor:49) |
| TC-SSP0200-022 | 이벤트 | 팝업이 열려 있음 | btnButtonList 취소 버튼을 누릅니다 | — | 팝업이 닫히고 행이 추가되지 않습니다(동작 확인 필요) | `btnButtonList_UsrButtonList_Click_Detected` |
| TC-SSP0200-023 | 이벤트 | spdMain에 행이 있음 | 행의 Item 관련 셀을 바꿉니다 | ITEM_ID 변경 | Item/BOD 기반 값이 보정됩니다(대상 컬럼 확인 필요) | `shtMain_Change`(dsdm.Changed) > GetItemFromBOD, `SSP.SSP0200_GET_ITEM_FROM_BOD` |
| TC-SSP0200-024 | 이벤트 | spdMain에 행이 있음 | TRANSPORT_MODE 셀을 클릭합니다 | — | Trans Mode 콤보 목록이 표시됩니다 | `SpdMain_CellClick`, `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0200-025 | 그리드 | 잠기지 않았고 1행 이상 있음 | 체크박스 컬럼 헤더를 클릭합니다(2회) | — | 1회 클릭에 전체 체크, 2회 클릭에 전체 해제됩니다 | `SpdMain_CellClick`:5505~5544 |
| TC-SSP0200-026 | 이벤트 | spdMain에 행이 있음 | 콤보 셀(BOD/Route 관련)을 선택합니다 | 콤보 값 선택 | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL이 설정됩니다 | `SpdMain_ComboSelChange` > FindData_BOD, `SSP.SSP0026_GET_BOD_ITEM`, SSP0026_GET_BOD_ITEM, `biz:CommonData.CommonDataList` |
| TC-SSP0200-027 | division | spdMain에 행이 있음 | 행의 DIVISION_ID 콤보를 40으로 바꿉니다 | DIVISION_ID=40 | END_CUSTOMER가 표시되고 PROJECT_CODE, PROJECT_NAME이 숨겨집니다. From Site 콤보가 다시 조회됩니다 | `SpdMain_ComboSelChange`:5668~5670, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`, `Shipment Change Request` |
| TC-SSP0200-028 | division | 같음 | 행의 DIVISION_ID 콤보를 81로 바꿉니다 | DIVISION_ID=81 | END_CUSTOMER가 숨겨지고 PROJECT_CODE, PROJECT_NAME이 표시됩니다 | `SpdMain_ComboSelChange`:5677~5679, `Shipment Change Request` |
| TC-SSP0200-029 | 저장 | 편집한 행이 있음 | 프레임워크 저장을 누릅니다 | 정상 값 | 변경요청번호가 채번됩니다 | SaveButton:862, `SSP.SSP0200_GET_CHANGE_REQ_NO`, SSP0200_GET_CHANGE_REQ_NO |
| TC-SSP0200-030 | 저장 | 같음 | 저장 후 DB를 확인합니다 | 정상 값 | SSP_ANL_SHIP_CONFIRM에 신규 행이 생기고 DM_PLN_MKT_FCST가 MERGE됩니다 | SaveButton:1056, `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, SSP0200_SAVE_SHIPMENT_CONFIRM_NEW |
| TC-SSP0200-031 | 저장 | 같음 | 저장 직후 상단 갱신을 확인합니다 | — | 상단이 다시 조회됩니다 | SaveButton > FindData_Main_Nonasync, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N`, SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N |
| TC-SSP0200-032 | 저장 | ERP I/F 대상 건 | 저장 후 오류 확정 테이블을 확인합니다 | ERP 오류 건 | SSP_ANL_SHIP_ERP_ERROR_CONFIRM에 INSERT되고 _CHG_REQ, _CHG_REQ_DE가 UPDATE됩니다(진입 조건 확인 필요) | GetERPInterface:3950, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0200-033 | 저장 | ERP I/F 대상 건 | 저장 중 Draft 삭제 경로를 확인합니다 | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE와 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT가 일어납니다(조건 확인 필요) | GetERPInterface:3989, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0200-034 | 저장 | ERP I/F 대상 건 | 저장 시 출하 상태 확인을 봅니다 | CONFIRM_ID 다건 | 결과 Tables[0~2]의 CONFIRM_ID로 상태를 판정합니다(메시지 확인 필요) | GetShipmentStatusChk:4096, `SSP.SSP0200_GET_SHIPMENT_STATUS`, SSP0200_GET_SHIPMENT_STATUS |
| TC-SSP0200-035 | 저장 | ERP I/F 대상 건 | 저장 시 SO 건수 확인을 봅니다 | — | CNT 결과에 따라 분기합니다(조건 확인 필요) | GetErpSoNoCnt:4161, `SSP.SSP0200_GET_ERP_SO_NO_CNT`, SSP0200_GET_ERP_SO_NO_CNT |
| TC-SSP0200-036 | 저장 | SO가 있는 건 | 저장합니다 | ERP_SO_NO 있음 | SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE와 _CHG_REQ_DE INSERT가 일어납니다 | SoNo:4771, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`, SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0200-037 | 저장 | SO가 없는 건 | 저장합니다 | ERP_SO_NO 없음 | TC-036과 같은 테이블에 반영됩니다(NonSoNo 경로) | NonSoNo:4491, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-038 | 저장 | 신규 경로 건 | 저장합니다 | 신규 행 | GetNewERPInterface > NewNonSoNo 경로로 저장됩니다(진입 조건 확인 필요) | NewNonSoNo:4297, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-039 | 저장 | SO가 있는 건 | 저장 후 I/F 테이블을 확인합니다 | ERP_SO_NO 있음 | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN에 INSERT되고 SSP_ANL_SHIP_CONFIRM이 갱신됩니다 | GetErpIFCheckNew:5009, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0200-040 | 저장 | SO가 있는 건 | 저장 후 IFSEQ를 확인합니다 | — | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN이 UPDATE됩니다(IFSEQ 병합) | GetErpIFSeqMerge:5067, `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE`, PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE |
| TC-SSP0200-041 | 저장 | 편집한 행이 있음 | Shipment Qty를 비운 채 저장합니다 | SHIPMENT_CONFIRM_QTY=빈값 | 검증 메시지가 나오고 저장이 중단됩니다(문구 확인 필요) | SaveButton > SSP_Main_Validation (shipment_confirm_qty) |
| TC-SSP0200-042 | 저장 | SO가 없는 일반 건 | INCOTERMS를 비운 채 저장합니다 | INCOTERMS=빈값 | 일반 건이면 검증에 걸립니다. SO 건이면 INCOTERMS를 검증하지 않습니다(확인 필요) | SSP_Main_Validation (Validationdr / SONoValidationdr) |
| TC-SSP0200-043 | 저장 | ERP Block 상태(BLOCK_YN) | 저장합니다 | BLOCK_YN=Y(가정 데이터) | 저장이 차단되거나 안내 메시지가 나옵니다(판정식 확인 필요) | SaveButton > chkERPIFBlockYn |
| TC-SSP0200-044 | 저장 | 저장 중 SP 오류 | DB 오류를 유도한 뒤 저장합니다 | 무효 CONFIRM_ID | 오류 메시지가 나오고 재조회되지 않습니다. 롤백 범위는 확인 필요 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-045 | 저장 | 하단 Draft가 있음 | spdSub CHK를 선택하고 btnChangeRe2를 클릭합니다 | CHK=true 1건 | 완료 처리(SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE)와 메일 발송 체인이 실행되고 재조회됩니다 | `BtnChangeRe_Click` > SaveDataDrafting, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE`, SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE, `Change Request` |
| TC-SSP0200-046 | 저장 | btnSave가 표시된 상태(기본 Visible=false) | btnSave를 클릭합니다 | CHK=true 1건 | SaveDataDrafting이 실행되고 재조회됩니다. Request Complete와의 차이는 확인 필요 | `BtnSave_Click`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0200-047 | 저장 | 하단 Draft가 있음 | spdSub CHK를 선택하고 btnCancel을 클릭합니다 | CHK=true 1건 | Draft가 삭제되거나 상태가 바뀌고, ERP I/F 체크(GetErpIFCheck) 후 재조회됩니다 | `BtnCancel_Click` > DeleteDataDrafting / GetErpIFCheck, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, `Change Request` |
| TC-SSP0200-048 | 저장 | 하단에 선택된 행이 없음 | btnCancel을 클릭합니다 | CHK 없음 | 처리되지 않거나 안내 메시지가 나옵니다(확인 필요) | `BtnCancel_Click`, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-049 | 이벤트 | 변경요청 정보 영역 | btnApprovalUser를 클릭합니다 | — | 승인자 선택 동작이 실행되고 txtApproval, txtAppDeptName에 반영됩니다(확인 필요) | `BtnApprovalUser_Click` |
| TC-SSP0200-050 | 이벤트 | 조회조건 영역 | btnItemId를 클릭합니다 | — | Item 선택 동작이 실행되고 txtRequest에 반영됩니다(확인 필요) | `btnItemId_Click` |
| TC-SSP0200-051 | 이벤트 | spdMain에 여러 행이 있음 | spdMain을 세로로 스크롤합니다 | — | TopChange 처리가 실행됩니다(내부 동작 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0200-052 | 이벤트 | spdMain에 행이 있음 | 셀을 더블클릭합니다 | — | 내부 동작 확인 필요 | `SpdMain_CellDoubleClick` |
| TC-SSP0200-053 | 이벤트 | spdMain에 행이 있음 | 편집 셀에 값을 입력합니다 | 임의 값 | EditChange 처리가 실행됩니다(확인 필요) | `SpdMain_EditChange` |
| TC-SSP0200-054 | 이벤트 | spdMain에 행이 있음 | 여러 셀을 Ctrl+V로 붙여넣습니다 | 2행×2열 | 붙여넣기 후처리가 실행됩니다(확인 필요) | `SpdMain_ClipboardPasted` |
| TC-SSP0200-055 | 이벤트 | spdMain에 2행 이상 있음 | 다른 행으로 커서를 옮깁니다 | — | CursorChanged 처리가 실행됩니다. 하단 연동 여부는 확인 필요 | `SpdMain_CursorChanged` |
| TC-SSP0200-056 | 권한 | 그리드가 잠긴 상태(IsLock=true) | btnNew 클릭, 헤더 체크 클릭 | — | 행이 추가되지 않고 헤더 전체 체크가 동작하지 않습니다 | `BtnNew_Click`, `SpdMain_CellClick`(IsLock 조건) |
| TC-SSP0200-057 | 권한 | 사용자 그룹이 다른 계정 2개 | 각 계정으로 화면을 열고 clbDivision_ID, clbFromSite를 비교합니다 | 그룹 A / B | 그룹 권한(TB_FX_USERGROUPAUTHEXTENTION)에 따라 목록이 다릅니다 | `SSP.SSP0200_GET_SHIPMENT_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0200-058 | 권한 | 권한 메타 | 메뉴 권한별로 조회·저장 버튼 활성을 확인합니다 | C/R/U/D 조합 | TB_FX_GroupMenuAuth 값대로 동작합니다(값 확인 필요) | FindButton, SaveButton, TB_FX_GroupMenuAuth |
| TC-SSP0200-059 | 초기화 | FoxQuery 미등록 SP | 화면을 열 때 Site 조회 오류가 나는지 확인합니다 | — | 오류 없이 목록이 로드됩니다. 오류가 나면 직접 호출 경로를 확인합니다 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` (NOT_IN_FOXQUERY) |
| TC-SSP0200-060 | 그리드 | 조회 후 SetChangeRequestSOGrid | sSearchType="Exist"이고 Ship Status가 "R"이 아닌 데이터로 조회합니다 | — | 시트 `Change Request`의 CHK가 숨겨집니다 | SetChangeRequestSOGrid:2294, `Change Request` |

### 커버리지 점검
- **이벤트 핸들러 19개**: btnInsertMultiple_Click(020), Form_Load(001·021), clbDivision_ID_SelectedIndexChanged(004), SpdMain_TopChange(051), BtnApprovalUser_Click(049), shtMain_Change(023), BtnSave_Click(046), BtnChangeRe_Click(045), BtnCancel_Click(047), BtnNew_Click(019), SpdMain_CellClick(024), SpdMain_CellDoubleClick(052), SpdMain_EditChange(053), SpdMain_ClipboardPasted(054), SpdMain_ComboSelChange(026), btnItemId_Click(050), CboChangeType_SelectedIndexChanged(005), SpdMain_CursorChanged(055), btnButtonList_UsrButtonList_Click_Detected(022)
- **엔드포인트 20개**: 001~003, 008~009, 018, 020, 024, 026, 029~040, 045, 047 등. 위 근거 열에 모두 원문으로 나옵니다.
- **시트 2개**: `Shipment Change Request`(006·012·014~016), `Change Request`(006·013·017·060)
- **division**: 40(014), EE(015), 그 외(016), 행 단위(027·028)
- **빈 결과·오류**: 010, 044, 048, 059
