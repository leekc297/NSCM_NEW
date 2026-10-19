# SSP0201 AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs`(5838L) + `.Designer.cs`(1729L).
> 백본: `.atlas/gscm-design/SSP0201/roslyn/screen-analysis.json`. 설계: `design/00~03`.
> 4축 카운트(00_checklist §6): controls 81 / events 17 / validations 68 / gridSignals 257 / comboCalls 13 / buttonGuards 63 / spCalls 15(고유12) / popups 8.
> 주의: PKG_SSP0201 미배포(convert-sp 후속) — 실행체인(조회/저장) 런타임 검증은 SP 배포 후. 이 매핑은 FE 정적 배선 기준.

## 1. controls (81) → TO-BE

| AS-IS 컨트롤 | 영역 | TO-BE | 파일 |
|---|---|---|---|
| clbDivision_ID (Division, "40"고정 disabled R3) | 2 | `CustomDropdown disabled` value=FIXED_DIVISION | ShipmentChangeRequestForm.tsx |
| clbFromSite / clbToSite (다중+ALL) | 2 | `CustomDropdown multiple allOption` | ShipmentChangeRequestForm.tsx |
| cboChangeType (Plan Type, 기본 C) | 2 | `CustomDropdown` + useTabLookupQueries('CHANGE_REQ_TYPE') | 〃 |
| cboStatus (Status, P제외+ALL선두) | 2 | `CustomDropdown allOption` + lookup filter code!='P' | 〃 |
| txtRequest (Model, 다건) + btnItemId | 2 | `InputField` + FunctionSearchIcon → ItemByDivisionModal | 〃 |
| drpPeriod (기간, 30일 기본) | 2 | `PeriodField` + SCM0001_GET_SCP_DAY_PERIOD | 〃 |
| txtSoNo (ERP SO No, 다건) / txtConfirmId (Confirm ID) | 2 | `InputField multiline` (extraConditions) | 〃 |
| spdMain (FpSpread "Shipment Change Request" 65열) | 3 | `DataGrid` (isReadOnly=!isGridEditable) | ShipmentChangeRequestMainGrid.tsx |
| spdSub (FpSpread "Change Request" 58열, 읽기전용) | 3 | `DataGrid isReadOnly` 2단헤더 | ShipmentChangeRequestSubGrid.tsx |
| txtTitle/txtApproval/txtAppDeptName/cboChangeReason/txtReasonDetail/txtRequestor/txtRequestDeptName | 1 | RequestInfoPanel 필드 | RequestInfoPanel.tsx |
| txtRequestNo (hidden R5) | 1 | requestInfo.requestNo (state, 비노출) | types + store |
| btnApprovalUser (승인자검색 R7) | 1 | RequestInfoPanel Approval endAdornment → SsoUserModal | RequestInfoPanel + page |
| btnNew(R10)/btnCancel(R9)/btnChangeRe2(R14) | 1 | customButtons (New/Cancel/Request Complete) | ShipmentChangeRequest.tsx |
| btnAdd/btnDel/btnSave/dtDate/btnChangeRe(상단) — dead UI (R4) | 1 | **미노출**(CN-4 확인대기) | — |
| usrConditionPanel1 (접기/펼침) | 2 | SearchArea + MainTitle openSearchArea | page |

## 2. events (17) → TO-BE

| AS-IS 이벤트 | TO-BE 핸들러 | 근거 |
|---|---|---|
| EditButton (toolbarOverride, R1 SwitchLock) | `handleEdit` → setGridEditable(true), 가드 subRows.length===0 | R1 |
| FindButton (R13) | `handleSearch` → setFilter + 뷰복귀 | R13/R2 |
| InsertButton (R11) / BtnNew_Click (R10) | `handleInsert` → GridAction.addRow (division 40 고정) | R10/R11 |
| DeleteButton (R12 NO-OP) | hotkeyConfig.delete = `() => undefined` | R12 |
| SaveButton/BtnSave_Click (R8/R14) | `handleSave` → ERP게이트+필수검증+mutate+뷰복귀 | R8/R14 |
| BtnChangeRe_Click (R14 checkRequired) | `handleChangeRequest` → 필수4항목+ERP게이트 | R14 |
| BtnCancel_Click (R9) | `handleCancel` → subRows 가드+confirm+clearRequestInfo | R9 |
| BtnApprovalUser_Click (R7) | `handleApprovalSelected` (KO/EN 분기) | R7 |
| clbDivision_ID_SelectedIndexChanged | Division 40 고정이라 실효 없음(R3) — 콤보 payload divisionId 재조회형 배선 | R3, 02 §3 |
| CboChangeType_SelectedIndexChanged | Period 재계산 파생(P=오늘+9D) — setPeriod(페이지/Form) | 02 §3 cascade#2 |
| 그리드 셀 편집(cellEditEnded/beginningEdit) | MainGrid beginningEdit(화이트리스트)/cellEditEnded(EDIT_MAIN+SO전파) | 03 §3.1/§3.2 |

## 3. validations (68) → TO-BE (buttonGuards 63 + checkRequired 등)

| AS-IS guard | TO-BE | 상태 |
|---|---|---|
| SaveButton !IsLock (편집모드) | hotkeyConfig.save = ... && isGridEditable | 배선 |
| chkERPIFBlockYn (R8, SSPBlockCheckIF_SCP BLOCK_YN='Y') | `checkErpBlock` (getCombo) → MSG_ERP_BLOCK 차단 | 배선 |
| checkRequiredOfSpread(siMain) 메타 필수 | `saveWithValidation(dirty, staticColumns)` | 배선(INPUT_TP_CD 전건 'S' → 라벨* 매핑) |
| bolChang_Flag==false (MSG00133 수정없음) | dirty.length===0 → MSG_NO_CHANGES | 배선 |
| SHIPMENT_STATUS=='R' (MSG00174 요청완료) | dirty.some(status==='R') 차단 | 배선 |
| checkRequired 4항목(승인자/제목/변경사유/사유상세) | `checkChangeRequestRequired` → MSG_REQUIRED_FIELD | 배선 |
| 수량합계==0 (MSG00202) | **SP 분기(수량합계) — convert-sp 후속** | 미완(SP) |
| 출하일 하한/상한(MSG00201/00194, dBaseDate) | **부분 — 상수(D=CHANGE_REQ_DAY) 미배선, SP/후속** | 부분(CN) |
| erp_status=='C' (MSG00189) | beginningEdit e.cancel + isErpLocked | 배선 |
| REASON_CODE 없이 DETAIL (MSG00287) | cellEditEnded isReasonCodeMissing → 값 리셋+alert | 배선 |
| From/To Site 선행필수(MSG00098) | **셀콤보 cascade 선행검증 — CN-3(per-row) 부분** | 부분(CN) |
| Validation_Check() 본문(Qty/Date/Mode→ChangeReason) | **미정독(00_checklist §5-5 인계) — 후속 정독 필요** | 미완(정독) |

> validations 68건: 위 핵심 guard 는 R14/R8 표(01_layout §2)에서 소진, 나머지는 셀 파생/SP 검증(convert-sp)으로 인계. 전건 소비 대사는 04_react-gap.md §CommonCheckList/구조룰 표 참조.

## 4. gridSignals (257) → TO-BE (category별)

| category(건수) | TO-BE | 파일 |
|---|---|---|
| lock (39) | `isCellEditable`(화이트리스트: 기존 status='C'&erp!='C' / 신규 'I' / 40·EE 배타) + 서브 전량 읽기전용 | shipmentChangeRequestEditLock.ts |
| value (108) | `setEditMain`/`soGroupRows`/`applyChangeReasonCode`(EDIT_MAIN+SO전파+Reason 가드). **NEW_* route/BOD/LT 파생은 AS-IS도 주석→SP 이관(convert-sp)** | shipmentChangeRequestDerive.ts + MainGrid cellEditEnded |
| color (30) | formatItem wj-cell-editable / wj-cell-locked (hook #95 3색) | MainGrid formatItem |
| cellType (19) | 셀콤보 A(메타 자동) + B(6종 재조회, admin 메타 구동 useRowParamCombos). **PARAM2/9/10 미이관 → CN-3** | comboParams + 05_register(확인필요) |
| span (28) | 서브 2단헤더 Confirmed/Change(SMALL_CLASS_LABEL_NAME, hook #93 48px) | SubGrid buildColumns(twoTier) |
| visible (18) | 동적 컬럼 토글: changeType='P'(ERP_SO_NO/CONFIRM_ID) + Division 40/EE(END_CUSTOMER↔PROJECT_CODE) | MainGrid useEffect + editLock |
| merge (5) | DataGrid allowMerging(공용, SmartColMerge 등가) — **본 화면 기본값, 병합정책 대조 CN** | DataGrid |
| dataSource (3) | useTabProcQuery(MAIN/SUB) o_rc1 | page |
| other (7) | 커서복원/클립보드 — 공용 DataGrid 처리 | DataGrid |

## 5. 인계(확인필요) 요약 — goal ⑤ CN-1~6

- CN-1 From Site 콤보(OSP팩 의미) / CN-2 TransMode 동명이의 / CN-3 셀콤보 B PARAM2/9/10 미이관 / CN-4 dead UI 5버튼·R6 read-only / CN-5 InsertButton vs BtnNew 통합·Validation_Check 정독 / CN-6 PKG_SSP0201 미배포.
- 상세·상태는 `.atlas/gscm-design/SSP0201/design/04_react-gap.md` 정직보고 표.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SSP0201 은 편집 CRUD 화면(MAIN 편집/SUB read-only). 공용 DataGrid·gridAction·useMessageStore 위임 축 포함.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | - | 신규행 Insert 는 편집모드 게이트(handleInsert)로 재현. 필터-유지 정책(keepRowVisibleUnderFilter)은 공용 DataGrid/프레임워크 소관이며 현재 공용 DataGrid 미배선(grep 0)=전역 프레임워크 갭(이 화면 feature 폴더 밖). 런타임 육안 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | - | 편집 중 재조회 confirm 은 공용 편집가드 패턴 소관(화면 고유 배선 없음). 편집상태(isGridEditable)는 존재하나 재조회 confirm 은 프레임워크 축 — 화면 폴더 밖 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(SSP0201 Measure 0건, GridColumnSet 미배선). 사용자 컬럼 편집 UI 부재로 미해당 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | ShipmentChangeRequest.tsx:236,286 | 저장/완료 성공 시 `setToast`(useMessageStore, LGES 표준 하단중앙 자동소멸 Toast) 호출 | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | ShipmentChangeRequest.tsx:344 / packages/foundation/src/utils/gridAction.ts | 공용 DataGrid `excelFileName` export + gridAction dataMap(CODE→NAME 승계, 2026-08-11 전화면 공통) — MAIN 셀콤보(TransMode 등) Name 출력 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | - | 조회조건에 자유 key-in 콤마 다중검색 필드 없음 — Division/Site/Plan Type/Status=콤보, Model=팝업/단일 텍스트, ERP SO No/Confirm ID=단일 텍스트. 콤마 다중 대상 필드 부재 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | packages/shared/src/components/organisms/data-grid/DataGrid.tsx:55 | 공용 DataGrid 가 `rebindFilterColumns` 사용 — 재조회 시 컬럼 필터 재적용(화면 2 DataGrid 모두 공용) | 구현 |
