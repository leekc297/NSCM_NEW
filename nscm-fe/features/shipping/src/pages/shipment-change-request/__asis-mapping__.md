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
| spdMain (FpSpread "Shipment Change Request" 65열) | 3 | `DataGrid` (isReadOnly=!canEdit — 편집 기본 ON, §B P-1) | ShipmentChangeRequestMainGrid.tsx |
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
| SaveButton !IsLock (편집모드) | `hotkeyConfig.save = hasButton('SAVE') ? handleSave : false` — 편집모드 조건 제거(§B P-1, 편집 기본 ON) | 배선 |
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
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | - | 편집 중 재조회 confirm 은 공용 편집가드 패턴 소관(화면 고유 배선 없음). 편집모드 state 는 §B P-1 로 제거됐고(편집 기본 ON) 재조회 confirm 은 공용 DataGrid/SearchArea 축이다 — 화면 폴더 밖 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(SSP0201 Measure 0건, GridColumnSet 미배선). 사용자 컬럼 편집 UI 부재로 미해당 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | ShipmentChangeRequest.tsx:236,286 | 저장/완료 성공 시 `setToast`(useMessageStore, LGES 표준 하단중앙 자동소멸 Toast) 호출 | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | ShipmentChangeRequest.tsx:344 / packages/foundation/src/utils/gridAction.ts | 공용 DataGrid `excelFileName` export + gridAction dataMap(CODE→NAME 승계, 2026-08-11 전화면 공통) — MAIN 셀콤보(TransMode 등) Name 출력 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | - | 조회조건에 자유 key-in 콤마 다중검색 필드 없음 — Division/Site/Plan Type/Status=콤보, Model=팝업/단일 텍스트, ERP SO No/Confirm ID=단일 텍스트. 콤마 다중 대상 필드 부재 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | packages/shared/src/components/organisms/data-grid/DataGrid.tsx:55 | 공용 DataGrid 가 `rebindFilterColumns` 사용 — 재조회 시 컬럼 필터 재적용(화면 2 DataGrid 모두 공용) | 구현 |

## 2026-10-07 UI 패리티 이식 (기준 = 자매 SSP0200 의 사용자 피드백 교정분)

> 사용자 지시: "SSP0200 에 대한 내용들이 결국 SSP0201 이니 UI 에 대해서 맞춰라".
> 종전 SSP0200 매핑의 "자매 수정 금지" 는 이 지시로 **해제**됐다(복사 금지는 유지 — 항목별 AS-IS 대조 이식).
> 이식 판정의 입력: SSP0200 교정 커밋 5건(8c440da7 · cf323c0a · ddd3710d · de3de5ad · 64f500eb) +
> AS-IS `SSP0201_ShipmentChangeRequest.cs`(5,838행)·Designer(1,729행) 실측 + DB 실측(ora.py 2026-10-07).

### A. DB 실측으로 교정한 전제 (종전 주석이 stale 이었다)

| 항목 | 종전 주석 | 2026-10-07 실측 |
|---|---|---|
| `PKG_SSP0201` | "미배포(convert-sp 후속)" | **PACKAGE / PACKAGE BODY 모두 VALID**. SP 10종 전건 배포(`_GET_SHIPMENT_CHANGE_REQUEST` · `_GET_SHIPMENT_CHANGE_REQUEST_N` · `_GET_SHIPMENT_REQUEST_DRAFTING` · `_GET_CHANGE_REQ_NO` · `_GET_ERP_SO_NO_CNT` · `_GET_SHIPMENT_STATUS` · `_SAVE_SHIPMENT_CONFIRM_NEW` · `_SAVE_SHIPMENT_REQUEST_DRAFTING` · `_SAVE_SHIPMENT_REQUEST_COMPLETE` · `_DELETE_SHIPMENT_REQUEST_DRAFTING`) |
| 실행체인 차단 사유 | "SP 미이관" | **"버튼메타 미등록"** 이 실제 병목. `SCM_ADM_MNU_BTN_MPG_M`(SSP0201) = SEARCH/SAVE/EDIT/INSERT + sub SEARCH **5행만**. 자매 SSP0200 은 18행. 미등록 = DELETE · EXCEL · GET_CHANGE_REQ_NO · GET_SCP_DAY_PERIOD · GET_SHIPMENT_STATUS · GET_ERP_SO_NO_CNT · SEARCH_NEW · SAVE_DRAFTING · SAVE_COMPLETE · USER_CHECK |

### B. 이식한 것 (UI)

| ID | 교정 내용 | 근거 | 착지점 |
|---|---|---|---|
| P-1 | **편집모드 모드토글 제거 → 편집 기본 ON** | convert-core §2.4 + 사용자 지시(2026-09-25/10-07). 종전 Edit 핸들러는 가드 `subRows.length > 0` 에 걸리면 **알림도 없이 무동작** = 서브에 행이 있는 순간 편집 도달불가(SSP0200 의 "변경사유 입력 도달불가" 와 같은 결함 유형) | 페이지 `canEdit = hasButton('EDIT')` 1회. store `isGridEditable`/`setGridEditable` 제거. `isCellEditable(row, binding, canEdit)` |
| P-2 | **Delete = 저장 전 신규행 전용** | AS-IS `DeleteButton()`(cs:688~691) 본문 공백 NO-OP 는 SSP0200(cs:706~709)과 동일. SSP0200 이 사용자 지시로 실동작을 부여한 것과 같은 근거(넣은 신규행 되돌림 수단 부재) | `handleDelete` — `GridUtils.getSelectedRows` + `isInsertedRow` 가드 + `GridAction.removeRow(g, true, true)`. 신규행 0건이면 `SCREEN_TEXT.DELETE_INSERT_ONLY` 안내(조용한 무동작 금지) |
| P-3 | **승인부서(Approval Dept Name) 바인딩** | AS-IS 팝업은 **4값** 반환(UserID/UserName·_E/**Dept_Name**/**Dept_ID**, cs:2757~2765). 종전 TO-BE 는 3값만 받아 `appDeptName` 이 **항상 공백**이었다. 공용 `SsoUserModal` 은 cf323c0a 이후 `deptNm`/`deptId` 를 준다 | `handleApprovalSelected` 5-인자. `RequestInfo.appDeptId` 신설(저장 시 `APPROVAL_DEPT` → 자매 SSP0202 디테일 승인부서명 조인 원천) |
| P-4 | **Model 셀 팝업 사전조회값** | SSP0200 8c440da7 과 동일 — 셀에서 열면 **그 행의 기존 Model 값**으로 필터해야 한다. 종전엔 조회조건 `itemId` 를 넘겨 엉뚱한 후보가 떴다 | `ItemByDivisionModal preSearchParams.itemId` = 셀 경로면 `row[ITEM_POPUP_COLUMN]`, 조회조건 경로면 `sc.itemId` |
| P-5 | **버튼 재배치 + 리사이즈 레이아웃** | 종전 TO-BE 는 고정 %(45/30) div 3개라 리사이즈 불가 + 4버튼 전부 SubTitle | `PanelGroup` 3분할 + `splitBar` 2개. SubTitle = `New` 1개(INSERT 권한). `RequestActionBar` 신설 = Request Complete(SAVE) + Cancel |
| **P-6** | **패널 배열을 자매 SSP0200 과 일치화** — `Grid1(main)` / `요청정보 폼 + 액션바(196px 고정)` / `Grid2(sub)` | **사용자 지시 2026-10-07**. AS-IS Designer 실측은 `splitContainer` Horizontal/SplitterDistance=253, Panel1=spdMain / Panel2=spdSub(상) + panel3(하: 요청정보 좌 X=0 / 버튼 우 X=760) = **Grid1/Grid2/폼** 순서다. 두 화면을 같은 조작감으로 쓰는 사용자 요구가 Designer 좌표보다 우선 → **의도적 드리프트**(처음엔 Designer 순서로 이식했다가 지시에 따라 교체) | `ShipmentChangeRequest.tsx` PanelGroup 자식 순서 + `.module.scss` 의 `.mainPane`(height:100%) / `.subPane`(flex:1 1 0) 규칙을 SSP0200 과 동일하게 맞췄다 |

### C. 이식하지 않은 것 (AS-IS 실측으로 "초과구현" 판정)

| 항목 | SSP0200 | SSP0201 AS-IS | 판정 |
|---|---|---|---|
| **Insert Multiple 팝업** | 있음(btnInsertMultiple cs:2924 + `InsertMultipleModal`) | **NOT FOUND** — `btnInsertMultiple`/`InsertPopup` grep 0건 | **미이식**(구현하면 AS-IS 초과) |
| **SO 주문상세 드릴다운** | 있음(ERP_SO_NO 더블클릭 → `SSP0300_OrderDetailPopup`, cs:4858~4878) | **NOT FOUND** — `SpdMain_CellDoubleClick`(cs:4283)은 ITEM_ID/PROJECT_CODE 만 처리, ERP_SO_NO/SSP0300 참조 0건 | **미이식**(동일) |
| **조회조건 콤보 `'ALL'` 전송** | 8c440da7 에서 `''` → `'ALL'` 로 교정 | — | **미이식(이식하면 결함)**. `PKG_SSP0201` body 는 `V_x_YN := CASE WHEN V_x IS NULL OR UPPER(TRIM(V_x))='ALL' THEN 'N' ELSE 'Y' END`(line 264~287) — Oracle 에서 빈 문자열 = NULL 이라 **현 `''` 전송이 이미 등가**다. 바꿔야 할 이유가 없다 |
| 레이아웃 순서 | Grid1 / 폼 / Grid2 | Grid1 / Grid2 / 폼 | **SSP0200 과 맞추지 않는다** — Designer 가 다르다(위 P-5) |

### D. 잔여 미배선 (버튼메타 등록이 선행조건 — 다음 회차)

1. **저장 실행체인** — 수정저장(`SAVE_DRAFTING`, AS-IS `GetERPInterface` 2번 루프 축) · 신규 2단계(`SEARCH_NEW`→`SAVE_DRAFTING`) · 요청완료(`SAVE_COMPLETE`). 현재 `handleSave` 는 단일 `useProcMutation`, `handleChangeRequest` 는 **toast 만** 띄우는 stub 이다(실제 저장 없음 — 사용자에게 성공으로 보인다. 메타 등록과 함께 최우선 해소 대상).
2. **SP 반환코드 이름기반 읽기**(`readResultCode`/`resultCodeOf`) — ①의 실행체인과 세트.
3. **승인자 권한 제한 팝업** — `ApprovalUserModal`(`PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST` 직호출). `USER_CHECK` 메타 필요. 현재는 공용 `SsoUserModal`(SCM_ADM_USER_M 전건, 권한필터 없음).
4. **Period 기본값 SP** — AS-IS 는 `GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD`(p_offset_day=30, cs:2712~2727). 현재 TO-BE 는 **dayjs 근사**(`periodByPlanType`). `GET_SCP_DAY_PERIOD` 메타 필요. SSP0200 은 실 SP 를 쓴다.
5. **Excel 버튼** — `EXCEL` 메타 미등록이라 현재 `excel: false` 로 명시 차단(기본 핸들러 부활 방지). 등록 시 키를 빼면 자동 노출.
6. **Cancel 버튼 권한축** — SSP0200 은 `hasButton('DELETE')`. SSP0201 은 DELETE 미등록이라 `canEdit`(EDIT)로 잠정 게이트했다. DELETE 등록 회차에 SSP0200 과 맞춘다.

### E. 그리드 기능 전수 점검 (2026-10-07, 사용자 신고 "아래 그리드 헤더 정리 안 됨")

> 정본 입력: AS-IS `InitSpread()` cs:543~653 + `SCM_MST_SHEET_COLUMNS` 실측(ora.py).
> 메타 실측: main "Shipment Change Request" 65행(VIS 24) / sub "Change Request" 58행(VIS 27,
> SMALL_CLASS_LABEL_NAME 53행 = Confirmed 7 · Change 7 · 기타, DATA_SCALE_NUMBER **전건 NULL**).

#### 해소한 것 (spdSub)

| ID | AS-IS 신호 | 종전 TO-BE | 조치 |
|---|---|---|---|
| **G-1** | — (TO-BE 고유) | 메타 폭(25~150) 그대로 → **58열 2단 헤더가 그대로 잘림** | `autoSizeColumn(i, false, 8)` 전 표시컬럼 적용 + `loadedRows` 핸들러 + 컬럼/행 변경 시 rAF 재적용. 폭 0(REMARKS)·`visible:false`(ERP_SO_NO)는 건너뛴다. **사용자 신고의 직접 원인** |
| **G-2** | CHK 헤더 `CheckBoxCellType` + `Value=false` + bevel Border (cs:606~613) | 헤더에 라벨 `ALL` 텍스트만 | `formatItem` 의 `CellType.ColumnHeader` 분기에서 disabled 체크박스 렌더(읽기전용 그리드라 선택 불가) |
| **G-3** | CHK `col.MergePolicy = MergePolicy.None` (cs:615~617) | **CHK 가 다른 열과 함께 세로 병합됨** | **G-7 로 대체됨** — 병합 모드를 `ColumnHeaders` 로 내리면 데이터 셀 병합 자체가 사라져 자동 충족된다. 종전 조치(rAF 에서 `col.allowMerging=false` 재적용)는 제거했다 |
| **G-4** | REMARKS `Width = 0` — 주석 "화면에서만 제거함" (cs:622) | 메타 그대로 폭 150 **노출** | `buildSubColumns` 가 `colWth:0`. `visible:false` 로 숨기지 않는다 — 메타 축(admin 관리)을 FE 가 뒤집지 않고(CLAUDE.md §2 체크4), autoFit 이 폭 0 을 건너뛰게 한다 |
| **G-5** | changeType='P' → ERP_SO_NO 숨김(cs:627) + 그룹라벨 `Plan`/`Confirm`(cs:629~630), 그 외 `Confirmed`/`Change`(cs:651~652) | **분기 전무** — SubGrid 가 `changeType` 을 받지도 않았다 | SubGrid `changeType` prop 신설 + `buildSubColumns(adminCols, changeType, planLabels)`. 메타 SCLS 기본값이 else 분기와 일치하므로 'P' 일 때만 교체. 라벨은 화면이 i18n 으로 공급(영문 하드코딩 금지) |

#### 해소한 것 (spdMain)

| ID | AS-IS 신호 | 종전 TO-BE | 조치 |
|---|---|---|---|
| **G-6** | `MessageHelper.GetTerm("Shipment Plan Qty" / "Shipment Confirm Qty")` (cs:562/574) | **영문 리터럴 하드코딩**(`c.header = isPlan ? 'Shipment Plan Qty*' : …`) | `SCREEN_TEXT.QTY_HEADER_PLAN/CONFIRM`(`_ssp0201.*` 미등록 키 + defaultValue). 두 문구는 TO-BE `SCM_ADM_MSG_M` 0행이라 MSG/LBL 번호를 빌리지 않는다(hook #114). 자매 SSP0200 은 같은 이유로 **미구현**으로 남겼으나, 이 화면은 이미 문구가 떠 있으므로 키로 승격해 원천을 하나로 모았다 |

#### 점검 결과 "현 상태가 정답" (변경하지 않음)

| 축 | 판정 근거 |
|---|---|
| sub 전량 읽기전용 | `siSub.LockColumn(0, GetMaxColumnIndex(), true)` cs:1824 **live** → `isReadOnly={true}` 유지 |
| sub 데이터셀 병합 | `siSub.SmartColMerge()` cs:1831 **live** → `AllowMerging.Cells` 유지. **자매 SSP0200 은 sub 병합이 없다**(그쪽 AS-IS 는 해당 호출이 주석) — AS-IS 가 다르므로 맞추지 않는다 |
| main 데이터셀 병합 | `siMain.SmartColMerge()` cs:1446·2732 **live** → `AllowMerging.Cells` 유지 |
| sub 2단 헤더 | `SetSheetHeaderColumn(spreadInfo, 2)` cs:602 + 메타 SCLS 53행 → 메타 구동 유지(하드코딩 금지, hook #87§D) |
| **수량 소수자리** | **자매 SSP0200 의 `scale:3` 강제를 베끼지 않았다.** AS-IS SSP0201 은 `SetReNumerCellType(…, NEW_SHIPMENT_CONFIRM_QTY, 0)` cs:603 = **0 자리**이고, 메타 셀유형도 FPNumberText(공용 매핑이 'd0' 정수)라 현 동작이 이미 AS-IS 와 같다. 3 을 이식하면 결함이 된다 |
| main 단일 헤더 | main 메타 SCLS **0행**(실측) → `sClsLblNm/lClsLblNm` 제거 유지 |
| main formatItem | 편집/잠금 3색만 토글하고 `textContent` 를 쓰지 않는다 → 자매 SSP0200 의 **QTY 편집기 진입 막힘 버그(editRange 가드)가 구조적으로 없다**. 이식 불요 |
| main autoFit | 자매 SSP0200 도 main 에는 autoFit 이 없다(sub 전용) → 추가하지 않는다 |

#### 미해소 (메타 정정이 선결 — 확인필요)

1. **sub `ERP_SO_NO`** — AS-IS else 분기(cs:649)는 `Visible = true` 인데 메타가 `VISIBLE_FLAG='N'`/`COLUMN_WIDTH=0` 이다. FE 로 되살리면 메타 축을 뒤집는 것이라(CLAUDE.md §2 체크4) 손대지 않았다. **메타 UPDATE 가 맞는 해법**이고, 그때까지 else 분기에서도 SO No 열이 보이지 않는다.
2. **sub `NEW_SHIPMENT_CONFIRM_QTY` 셀유형** — 메타 FPNumberText. 편집 대상 수량열이면 FPNumber 가 맞다(자매 SSP0200 도 같은 지적을 남겼다). 단 이 그리드는 전량 읽기전용이라 현재 영향 없음.

#### G-7 정정 — 2단 헤더 그룹라벨 병합 (사용자 재신고 2026-10-07 "아직 헤더가 SSP0200/SSP0003 과 다르다")

**종전 판정이 틀렸다.** §E 에서 "sub 데이터셀 병합 = `AllowMerging.Cells` 유지가 정답"으로 적은 것은
AS-IS `siSub.SmartColMerge()`(cs:1831 live)만 보고 **Wijmo 병합 모드의 의미를 확인하지 않은** 결론이다.

`AllowMerging` 은 누적 플래그가 아니라 **대상 영역 선택**이다 — 공용 `CustomMergeManager` 실측:

| 경로 | 허용 모드 | 근거 |
|---|---|---|
| 컬럼 헤더 병합 `_getColumnHeaderMergedRange` | `All` · `AllHeaders` · **`ColumnHeaders`** | `mergeManager.ts:167~172` |
| 데이터 셀 병합 `_getCellMergedRange` | `All` · **`Cells`** | `mergeManager.ts:209~210` |

즉 `Cells` 는 **헤더 병합을 명시적으로 거부**한다(즉시 `null` 반환). 그 결과 2단 헤더의
`Confirmed`(7열) / `Change`(7열) 그룹라벨이 **가로로 합쳐지지 않고 열마다 반복 출력**됐다 —
이것이 사용자가 두 번 신고한 "헤더가 정리되지 않았다 / 자매 화면과 다르다" 의 실제 원인이다.
§E 의 G-1(autoFit)은 폭 문제만 고쳤고 병합 축은 손대지 않아 증상이 남아 있었다.

**조치** — sub 그리드 병합 모드를 자매 2화면과 동일하게 맞춘다:

| 화면 | 종전 | 변경 후 | 자매 기준 |
|---|---|---|---|
| SSP0201 sub | `Cells` | **`ColumnHeaders`** | SSP0200 sub = **미지정 → 기본 `ColumnHeaders`**(DataGrid.tsx:553) |
| SSP0202 sub | `Cells` | **`ColumnHeaders`** | SSP0003 sub = `ColumnHeaders`(명시) |

부수효과(의도): 데이터 셀 병합이 없어져 AS-IS CHK `MergePolicy.None`(cs:615~617)이 자동 충족된다 →
G-3 의 런타임 `col.allowMerging=false` 재적용을 제거했다. 자매 SSP0200 `buildSubColumns` 주석(98~100행)이
"그리드 기본 allowMerging=ColumnHeaders 라 데이터 셀 병합 자체가 없어 D9(MergePolicy=None)는 충족된다" 로
**이미 같은 근거를 남겨 두었다** — 처음부터 그 주석을 따랐어야 했다.

**명시적 트레이드오프(미이식)**: AS-IS `siSub.SmartColMerge()` 의 **데이터 셀 세로병합은 포기**했다.
자매 2화면과의 헤더 일치를 우선한 **사용자 결정(2026-10-07)** 이다. 둘 다 원하면 `AllowMerging.All`
(헤더+셀)로 올리면 된다 — 그때 CHK 제외(G-3)를 다시 살려야 한다.

**함께 해소(SSP0202)**: sub 그리드에 autoFit 이 없어 헤더가 잘렸다(자매 SSP0003 에는 있다) →
`autoSizeColumn` + `loadedRows` + rAF 를 SSP0201 과 동일하게 넣었다.

#### 남은 불일치 — 메인 그리드 병합 (사용자 확인 대기)

사용자 신고는 "아래(sub) 그리드" 였으므로 메인은 **건드리지 않았다.** 현황만 남긴다:

| 화면 | main `allowMerging` | 자매 기준 | AS-IS |
|---|---|---|---|
| SSP0201 main | `Cells` | SSP0200 main = 미지정 → `ColumnHeaders` | `siMain.SmartColMerge()` cs:1446·2732 **live** |
| SSP0202 main | `Cells` | SSP0003 main = `None` | `siMain.SmartColMerge()` cs:640·1276 **live** |

메인은 둘 다 **단일 헤더**(main 메타 `SMALL_CLASS_LABEL_NAME` 0행 실측)라 헤더 병합 대상이 없다 →
`Cells`/`ColumnHeaders`/`None` 사이에 **헤더 외관 차이는 없고 데이터 셀 세로병합 유무만 갈린다**.
현재 SSP0201/0202 메인은 AS-IS SmartColMerge 를 재현하고 있고, 자매 2화면은 재현하지 않는다.
**자매와 맞출지(=데이터 병합 해제) AS-IS 를 지킬지는 사용자 결정 사항**이다.

#### G-8 컬럼 폭/표시 메타를 SSP0200 과 동일화 (사용자 지시 2026-10-07 "Width 를 동일하게 줘서 맞춰라")

autoFit(G-1)·헤더병합(G-7) 이후에도 헤더가 잘려 보인 잔여 원인은 **메타 폭 자체가 자매와 달랐기** 때문이다.
`SCM_MST_SHEET_COLUMNS` FULL OUTER JOIN 실측(ora.py 2026-10-07) 후 **SSP0200 값으로 정렬**했다
(적용 스크립트 `.atlas/gscm-design/SSP0201/design/07_register_column-width-parity.sql` + 롤백 동반).

| 시트 | 컬럼 | 변경 | 비고 |
|---|---|---|---|
| main | `CHANGE_REASON_CODE` · `CHANGE_REASON_DETAIL` | `VISIBLE_FLAG` **N → Y** | **도달불가 결함 해소.** 두 열은 편집 화이트리스트에 있고 MSG00287 선행가드까지 구현돼 있는데 `VISIBLE_FLAG='N'` 이라 그리드에 렌더조차 안 됐다 — 자매 SSP0200 이 `19f25cf1` 로 고친 "변경사유 입력 도달불가" 와 **동일 결함**. 폭은 SSP0200 과 똑같이 0 으로 두고 FE `MIN_WIDTH_OVERRIDE`(110/150)로 보정한다 |
| main | `REMARKS` · `REMARKS2` | W `0 → 100`, VIS **N → Y** | SSP0200 실측값 |
| main | `ERP_SO_NO` | W `0 → 80`, VIS **N → Y** | SSP0200 실측값 |
| main | `SHIPMENT_DATE` | W **80 → 110** | 헤더 `Shipment Date*` 잘림. 자매 `7798c4da`("헤더/값 잘림 해소")가 먼저 고친 그 폭이다 |
| main | `ATTRIBUTE10` · `EDIT_MAIN` · `FROM_SITE` · `TO_SITE` | VIS **N → Y**(W 는 양쪽 0) | 폭이 양쪽 0 이라 **시각 차이는 없다**. 다만 컬럼셋 포함 여부가 갈려 Excel export 대상·컬럼 필터 후보·dataMap 부착 범위가 달라진다 → "기능 동일" 요구에 따라 정렬 |
| sub | `ERP_SO_NO` | W `0 → 80`, VIS **N → Y** | AS-IS else 분기 cs:649 가 `Visible = true` 다 — 메타가 'N' 이라 AS-IS 가 보여주는 열이 TO-BE 에서만 사라져 있었다. FE 는 changeType='P' 일 때만 숨긴다(cs:627 등가) |
| sub | `SHIPMENT_CONFIRM_QTY` | W **60 → 80** | SSP0200 실측값 |

**FE 동반 변경**: `buildColumns` 단일헤더 경로에 `MIN_WIDTH_OVERRIDE` 보정 추가(자매 `buildMainColumns` 와 동일).
메타 폭이 이미 있으면 건드리지 않는다 — admin 관리 축 보존(CLAUDE.md §2 체크4).

**검증**: 적용 후 재조회로 **SSP0200 ↔ SSP0201 공통컬럼의 폭/표시 상이 0행** 확인.
SSP0201 고유 2열(`SHIPTO_CODE`·`NEW_SHIPTO_CODE` @70)은 Packer 판 정상 컬럼이라 유지한다.

§E 의 "미해소 1. sub ERP_SO_NO — 메타 정정이 선결(확인필요)" 는 이로써 **해소**됐다.

#### P-7 조회조건(SearchArea)을 SSP0200 과 동일 구성으로 (사용자 지시 2026-10-08)

> "Searchbox 가 SSP0200 와 다르다. **SO No 와 Single Process 두 개를 제외하고는 동일하게** 표현되어야 한다."
> 지시의 예외 2건이 AS-IS Designer 실측과 정확히 일치했다 — 아래 근거로 확정했다.

**AS-IS Designer 실측(`SSP0201_ShipmentChangeRequest.Designer.cs`)**

| 컨트롤 | 실측 | 판정 |
|---|---|---|
| `PlanType1`(Change Type 콤보) | `Visibility = Never` (810행) | **렌더 금지** — 자매 SSP0200 과 동일 근거(Δ1/L-050) |
| `lblSONo`(SO No) | `Visibility = Never` (824행) + **`lblSONo.Control = this.txtSoNo`** (814행) | **렌더 금지** — 레이아웃 항목이 입력칸까지 감싸므로 라벨·입력 전체가 비노출이다. SSP0200 은 노출하므로 이것이 자매 간 실차이다 |
| `chkSingleProcess` | Designer·cs 양쪽 **grep 0건** | **미존재** — 만들면 초과구현. SSP0200 전용 컨트롤이다 |

**변경 결과 — 메인 7필드(전부 `Grid size=3`), `extraConditions` 없음**

| # | 필드 | 종전 SSP0201 | 변경 후 |
|---|---|---|---|
| 1 | Div (40 고정 disabled) | 메인 1 | 그대로 |
| 2 | From Site (다중+ALL) | 메인 2 | 그대로 |
| 3 | To Site (다중+ALL) | 메인 3 | 그대로 |
| — | ~~Plan Type~~ | **메인 4 노출** | **제거**(AS-IS `Never`) |
| 4 | Status (ALL 선두, P 제외) | 메인 5 | 메인 4 |
| 5 | **Shipment Date**(기간) | **extraConditions, 라벨 없음** | **메인 5 + `LBL01115` 라벨**(SSP0200 동일 코드·동일 자리) |
| 6 | Model/Nickname | 메인 6 | 메인 6 |
| — | ~~SO No~~ | **extraConditions 노출** | **제거**(AS-IS `Never`) |
| 7 | **Confirm ID** | **extraConditions** | **메인 7** |

필드 순서를 SSP0200 과 1:1 대조해 확인했다 — `Div / From Site / To Site / Status / Shipment Date / Model/Nickname / (SO No) / Confirm ID` 중 SO No 만 빠진 형태로 완전 일치한다.

**부수 정리**
- `extraConditions` prop 자체를 제거했다(남는 필드가 없다). 조회조건이 7건이라 hook #52 의 "6건 초과 시 접기" 기준에 걸리지만, 자매 SSP0200 도 메인 8건을 접지 않고 한 영역에 둔다 — **동일 표현 우선**(사용자 지시).
- Plan Type 제거로 Form 에서 `changePlanType`·`changeTypeOptions`·`CHANGE_REQ_TYPE` lookup 호출이 사라졌다.
  store 의 `changePlanType`(기간 재산출 cascade)은 **보존**하되 호출부가 없어 도달 불가다 — SSP0200 이
  `changeType='C'` 고정으로 'P' 분기를 코드에만 남긴 것과 같은 상태(Δ2)다.
- `LBL.PLAN_TYPE`·`LBL.SO_NO` 상수는 **삭제하지 않고** 근거 주석과 함께 남겼다(사용처 0건).
  AS-IS 에 실재하는 컨트롤이고, 메타·설계 추적 시 번호가 사라지면 "누락"으로 오판된다.
- store `erpSoNo` 는 payload 계약상 유지되며 항상 `''`(전체 조회)로 나간다 — SP 의 `IS NULL` 분기가 받는다.

**검증**: type-check · build(tsc) · vitest 35건 통과, 변경 파일 eslint 0건.
