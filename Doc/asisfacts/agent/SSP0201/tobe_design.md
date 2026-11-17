# SSP0201 TO-BE 설계 참고 (As-is 사실 기반)

> 이 문서는 TO-BE 결정이 아니라 As-is 사실을 TO-BE 관점에서 정리한 것입니다. 결정이 필요한 항목은 §5 미확정 사항에 모았습니다.

## 1. 조회조건 (컨트롤 기준)

| 순서(Designer 선언 순) | 컨트롤 | 라벨(원문) | 유형 | 초기/특이 사항 |
|---:|---|---|---|---|
| 1 | txtConfirmId | Confirm Id | 멀티라인 텍스트 | |
| 2 | clbDivision_ID | Div | 단일 콤보 | 값 40/EE 여부로 그리드 컬럼 표시가 바뀜. 변경 이벤트 `clbDivision_ID_SelectedIndexChanged` |
| 3 | clbFromSite | From Site | 다중 선택 | |
| 4 | txtSoNo | SO No | 멀티라인 텍스트 | Designer Visible=false. 표시 조건 **확인 필요** |
| 5 | drpPeriod | Shipment Date | 기간 | 초기값은 `SCP.SCM0001_GET_SCP_DAY_PERIOD`(GetDayRange) |
| 6 | cboStatus | Status | 콤보 | |
| 7 | txtRequest (+ btnItemId) | 라벨 미추출(항목명 Model) | 멀티라인 텍스트 + 팝업 버튼 | |
| 8 | cboChangeType | Change Type | 콤보 | "P" 여부로 그리드 헤더·컬럼이 바뀜. 변경 시 GetDayRange 재호출 |
| 9 | clbToSite | To Site | 다중 선택 | |
| — | btnNew | NEW | 버튼 | 신규 행 |
| — | btnChangeRe | Request Complete | 버튼 | |

- 위 순서는 Designer 선언 순서이며, 화면에서 보이는 배치 순서는 **확인 필요**입니다.
- `GetCheckedListValue` 호출 지점(FindData_Main:1303~1307, FindData_Main_Nonasync:1395, SaveButton:795, SetChangedControl:503)과 SP 파라미터의 대응은 **확인 필요**입니다.
- 저장된 조회조건: TB_FX_SearchCondition 5행.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 호출 순서 (엔드포인트) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` → InitControls | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값 조회 API |
| Change Type 변경 | `CboChangeType_SelectedIndexChanged` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 위와 같음 (+ 그리드 헤더 재구성은 FE) |
| 조회 | FindButton | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` → `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 상단 목록 조회 API, 하단 요청 상세 조회 API |
| 행 추가 | InsertButton → InsertRow | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] (+ 미추출 소스: UserPlantSiteByDivisionOspPack, Data_SCP.Common, GetSSPInnerTable("MyDivision")) | 셀 콤보용 공통코드 API |
| NEW | `BtnNew_Click` | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | 위와 같음 |
| 저장(툴바) | SaveButton | `SSP.SSP0201_GET_CHANGE_REQ_NO` → `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` → GetERPInterface(`SSP.SSP0201_GET_SHIPMENT_STATUS`, `SSP.SSP0201_GET_ERP_SO_NO_CNT`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`) / GetNewERPInterface(`SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`) → 재조회(`SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` 또는 `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING`) | 요청번호 채번 API, 신규 확정 저장 API, 상태·SO 건수 검증 API, 드래프트 저장 API |
| Save Draft | `BtnSave_Click` → SaveDataDrafting | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | 요청 완료 저장 API (이름과 호출 SP가 다르므로 §5 확인) |
| Request Complete (2개 버튼) | `BtnChangeRe_Click` → SaveDataDrafting | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | 위와 같음 (메일 발송 체인 포함) |
| Cancel | `BtnCancel_Click` → DeleteDataDrafting | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` → 재조회 | 요청 취소 API (ERP/SCS 인터페이스 INSERT 포함) |
| 셀 클릭 | `SpdMain_CellClick` | TRANSPORT_MODE: CommonDataList [TransMode] / TO_SITE_SHIPTO_CODE: CommonDataList [ShipToCodeByDivision] / 헤더 체크박스 전체 토글 | 셀 콤보 지연 로딩 API |
| 셀 콤보 변경 | `SpdMain_ComboSelChange` | CommonDataList [ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`(FindData_BOD) → ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL 세팅, CommonDataList [TransMode] | BOD 조회 API (SSP0026 공유) |
| 붙여넣기 | `SpdMain_ClipboardPasted` | CommonDataList [ShipToCodeByDivision] | 셀 콤보 API |
| 승인자 선택 | `BtnApprovalUser_Click` | 엔드포인트 미추출 | **확인 필요** |
| 품목 선택 | `btnItemId_Click` | 엔드포인트 미추출 | **확인 필요** |
| 기타 그리드 이벤트 | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_EditChange`, `SpdMain_CursorChanged`, `shtMain_Change` | 엔드포인트 미추출 | FE 로직, 내용 **확인 필요** |

### 2-1. 저장 전 검증 (SSP_Main_Validation)

| 블록 | 줄 | 검사 컬럼 |
|---|---|---|
| Validationdr | 3188~3195 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks, TO_SITE_SHIPTO_CODE |
| SONoValidationdr | 3238~3244 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE (INCOTERMS 없음) |
| SONoValidationdr | 3315~3321 | 위와 같음 |

- 각 검사의 조건과 메시지는 Fact Pack에 없어 **확인 필요**입니다(`validation.md` 작성 시 원문 대조 필수).
- ERP I/F 차단 검사: `chkERPIFBlockYn`(BLOCK_YN, PERIOD).

## 3. Division별 Grid 변형 요약

| 시트 | 40 · EE | 그 외(81 계열·82·EE_* 계열) | 근거 |
|---|---|---|---|
| Shipment Change Request | END_CUSTOMER 표시 / PROJECT_CODE·PROJECT_NAME 숨김 → 31컬럼 | END_CUSTOMER 숨김 / PROJECT_CODE·PROJECT_NAME 표시 → 32컬럼 | InitSpread 578~587 (조회조건 Div 기준), SpdMain_ComboSelChange 4870~4881 (행 DIVISION_ID 기준) |
| Change Request | 27컬럼 (?5) | 28컬럼 (?5) | grid_effective (적용 여부 확인 필요) |

- 조건 비교는 정확히 `"40"`과 `"EE"`이므로 EE_HD 등 EE_* 계열은 '그 외'에 속합니다(grid_effective 결과와 일치).
- Change Type 변형(division과 무관):
  - "P": Shipment Change Request의 ERP_SO_NO·CONFIRM_ID Width 0, Change Request의 ERP_SO_NO 숨김, 헤더 "Plan"/"Confirm"
  - 그 외: CONFIRM_ID Width 120, ERP_SO_NO 표시, 헤더 "Confirmed"/"Change"
- 행 DIVISION_ID 콤보는 EE를 제외합니다(`c["CODE"] != "EE"`).
- TO_SITE_SHIPTO_CODE 콤보 세팅(InsertRow:2457)은 `clbDivision_ID.ControlValues == "40"` 조건 안에 있습니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 근거 |
|---|---|
| 메뉴 그룹 권한 8행 존재 (내용 미첨부) | dbo.TB_FX_GroupMenuAuth |
| 프로그램/메뉴 등록 각 2행 | dbo.TB_FX_ProgramInfo, dbo.TB_FX_MenuItemInfo |
| 툴바 진입점: FindButton(R), InsertButton(C), SaveButton(C/U) | flow.csv entry_kind=button |
| 화면 버튼: Save Draft·Request Complete(U), Cancel(D 성격 — DELETE SP 호출), Delete(btnDel, 배선 미확인) | events.csv, props.csv |
| 시트 잠금 검사 `siMain.IsLock(siMain.SheetName) == false`에서만 셀 콤보·행 추가·헤더 체크 동작 | grid_code (InsertRow, BtnNew_Click, SpdMain_CellClick) |
| 사용자 그룹 기반 필터: `UserInfoContext.Current["NowGroupID"]` | SetChangeControl, SetChangedControl, SaveDataDrafting, InsertRow, BtnNew_Click, SpdMain_ComboSelChange |
| Filter GROUP_ID / USER_ID 지정 후 GetSSPInnerTable 호출 | SetChangeControl:312~349 |
| 요청자·승인자·부서 정보(REQUEST_USER, APPROVAL_USER, *_DEPT) 보유 | SetChangeRequestInfo |

- 그룹별 C/R/U/D 플래그 값은 TB_FX_GroupMenuAuth 행 내용이 없어 **확인 필요**입니다.
- 요청자와 승인자에 따라 버튼 활성/비활성이 갈리는지는 SetChangeControl/SetChangedControl 본문이 없어 **확인 필요**입니다.

## 5. 미확정 사항

| # | 항목 | 필요한 확인 |
|---:|---|---|
| 1 | btnSave("Save Draft")가 COMPLETE SP를 호출하는 것이 의도된 동작인지 (btnSave는 Visible=false) | 원문 SaveDataDrafting 2222줄 앞뒤 분기 |
| 2 | SaveButton 내 GetERPInterface / GetNewERPInterface, FindData_Main / FindData_Main_Nonasync가 갈리는 조건 | 원문 SaveButton |
| 3 | GetErpIFCheck(미연결) 포함 여부 | 원문 호출처 검색 |
| 4 | btnDel, btnAdd 동작 / txtItemId, dtDate 용도 | 원문 + 런타임 |
| 5 | Change Request REMARKS Width=0 처리 (메타 '기본'과 충돌) | 런타임 확인 |
| 6 | Change Request 2단 헤더 7열 병합의 7번째 컬럼 | 메타 정렬 + 런타임 |
| 7 | 미추출 데이터 소스(UserPlantSiteByDivisionOspPack, Data_SCP.Common 2종, GetSSPInnerTable, dtShipmentInputPeriod, dtERPBlockYnIF, dtEndCustomer)의 SP | 프레임워크·BIZ 소스 추적 |
| 8 | 조회조건 라벨 미추출 항목(txtRequest/Model)과 usrLayoutControl2·3 항목 라벨 | props.csv 전체본 |
| 9 | 메일 발송 체인(SP_SEND_DBMAIL)의 TO-BE 대체 방식 | 아키텍처 결정 |
| 10 | ERP/SCS 인터페이스 테이블(XIF_*) 연동의 TO-BE 대상 | 인터페이스 담당 확인 |
| 11 | 주석 처리된 호출 4건은 TO-BE 범위 제외 대상인지 (현행 기능 아님) | — |
| 12 | 판단불가 분기 140건(런타임) | 실행 확인 |
