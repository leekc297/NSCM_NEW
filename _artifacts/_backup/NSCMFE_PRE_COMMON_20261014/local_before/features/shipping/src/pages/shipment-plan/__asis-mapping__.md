# SSP0060 Shipment Plan — AS-IS ↔ TO-BE 매핑 매트릭스

- 원천: `.atlas/gscm-design/SSP0060/design/00_checklist.md` (Roslyn 백본, analyzerVersion 1.2-syntax)
- AS-IS 정본: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs` (8,036줄)
- 작성: convert-react iter-1 (2026-09-25). ID 채번 = `D00-{섹션}-{행번호}` (asis_mapping_gate 규약).
- 상태 허용값: 구현 / 제외(사유 필수) / 해당없음(사유 필수)
- 주의: `asis_mapping_gate.py --check` 는 이 세션에서 실행 권한 차단(비대화형 승인 필요) — 수기 작성,
  게이트 기계검증은 ERROR(미실행) 상태로 04_react-gap.md 에 보고.

공통 사유 약어:
- **[SP-CHAIN]** ERP Drafting IF 체인(NonSoNo/SoNo/NewNonSoNo — PR_SSP_ANL_*, SCM_SSP_*, SSP0202_*,
  GetERPInterface 하위 SP 12종 + C# ERP WebService `service.RtFlag`) — TO-BE 미배포/미존재.
  FE 는 Confirm 저장(SAVE_SHIPMENT_REQUEST_CONFIRM)까지 배선, Drafting 3경로는 convert-sp 후속.
- **[PKG-SSP0002]** PKG_SSP0002 (GET_NERP_CODE / GET_USER_INFO_LIST) TO-BE 미배포(all_objects 0건 실측).
- **[META-GAP]** 03 §0 갭#1~5 — 콤보/컬럼 메타 미정비. 빈 리스트 렌더가 AS-IS 갭의 정확한 재현(임의 채움 금지).
- **[WINFORMS]** WinForms 전용 배관(FarPoint/DevExpress 레이아웃·ProgressForm·InputMap 등) — React/공용
  컴포넌트가 등가 제공(플랫폼 차이, 이식 대상 아님).

## §1 controls (66)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-1-001 | PlanDate 라벨 | components/ShipmentPlanForm.tsx (Plan Date FormItem) | | 구현 |
| D00-1-002 | Requestor 라벨 | components/ShipmentPlanDetailBar.tsx (Requestor FormItem) | | 구현 |
| D00-1-003 | btnItemID2 (2차 Model 팝업) | ShipmentPlan.tsx openItemDetailBar + DetailBar onModelSearch | | 구현 |
| D00-1-004 | btnItemId (1차 Model 팝업) | ShipmentPlan.tsx openItemMain + Form onItemSearch | | 구현 |
| D00-1-005 | btnMeasure | ShipmentPlan.tsx customButtons Measure(handleMeasure) | | 구현 |
| D00-1-006 | btnNew | DetailBar NEW 버튼 + ShipmentPlan.tsx handleNew | | 구현 |
| D00-1-007 | btnRequestor | DetailBar onRequestorSearch → RequestorModal | | 구현 |
| D00-1-008 | btnSearch (Detail 재조회) | DetailBar Search 버튼 + handleDetailSearch | | 구현 |
| D00-1-009 | btnSimulation | ShipmentPlan.tsx customButtons Simulation(handleSimulation) | 재계산 본체는 D00-3-033 참조(부분) | 구현 |
| D00-1-010 | cboBucketType | Form Bucket CustomDropdown('BucketType' 콤보) | | 구현 |
| D00-1-011 | cboPlanDate | Form Plan Date CustomDropdown(Plan_Infor_SCP) | | 구현 |
| D00-1-012 | chkSum | Form extraConditions Sum Checkbox | | 구현 |
| D00-1-013 | chkTotPSI | Form extraConditions Tot PSI Checkbox | | 구현 |
| D00-1-014 | clbCompany_ID | Form Company CustomDropdown(division o_rc2 클라 필터) | | 구현 |
| D00-1-015 | clbDivision_ID | Form Division CustomDropdown(division o_rc1) | | 구현 |
| D00-1-016 | clbPlantSite | Form From Site CustomDropdown multiple(Com_FromSite_SCP) | | 구현 |
| D00-1-017 | clbProductLevel11 | Form Product Level1 CustomDropdown multiple(CellGroup_SCP) | | 구현 |
| D00-1-018 | clbProductLevel12 | DetailBar Product Level1(동일 CellGroup_SCP 결과 재사용) | | 구현 |
| D00-1-019 | clbResultType | DetailBar Result Type(useTabLookupQueries SSP_SHIPMENT_RESULT_TYPE) | | 구현 |
| D00-1-020 | components (Container) | | [WINFORMS] 디자이너 컨테이너 | 해당없음 |
| D00-1-021 | drpPeriod (표시전용) | Form Period disabled InputField(periodFrom~periodTo) | | 구현 |
| D00-1-022 | drpPeriod2 | DetailBar PeriodField(period2, clamp=setPeriod2) | | 구현 |
| D00-1-023 | drpPeriod3 | DetailBar PeriodField(period3, 기본 오늘-9~-1) | | 구현 |
| D00-1-024~028 | emptySpaceItem1~5 | | [WINFORMS] 레이아웃 여백 | 해당없음 |
| D00-1-029 | imageList1 | | [WINFORMS] 아이콘 리소스 | 해당없음 |
| D00-1-030~031 | layoutControlGroup2/3 | ShipmentPlanForm(1차) / ShipmentPlanDetailBar(2차) 컨테이너 | | 구현 |
| D00-1-032~046 | layoutControlItem1~17 (라벨 컨테이너 15) | Form/DetailBar 의 각 FormItem label + fieldSet 가시성 | R1 가시성은 detailFieldSet | 구현 |
| D00-1-047 | lblBucket | Form Bucket 라벨(LBL00710) | | 구현 |
| D00-1-048 | lblCombo1 (Division 라벨) | Form Division 라벨(LBL00641) | | 구현 |
| D00-1-049 | lblItemId | Form Model 라벨(LBL00669) | | 구현 |
| D00-1-050~051 | lcProductLevel11/12 | Form/DetailBar Product Level1 라벨(LBL01144 신규 등록) | | 구현 |
| D00-1-052 | lcbtnNew | DetailBar NEW(fieldSet.newButton 가시성) | | 구현 |
| D00-1-053 | lcbtnSimulation | customButtons Simulation | R7 노출게이트는 D00-2b-059 참조 | 구현 |
| D00-1-054 | spdDetail | components/ShipmentPlanDetailGrid.tsx (DataGrid×7 탭) | | 구현 |
| D00-1-055 | spdDetail_Sheet1 | DetailGrid TabWrapper(DETAIL_SHEETS) | | 구현 |
| D00-1-056 | spdMain | components/ShipmentPlanMainGrid.tsx | | 구현 |
| D00-1-057 | spdMain_Sheet1 | MainGrid DataGrid | | 구현 |
| D00-1-058 | splitContainer1 | ShipmentPlan.module.scss gridArea/mainGrid/detailArea | 리사이즈 핸들 미구현(고정 flex 분할) — 04 확인필요 | 구현 |
| D00-1-059 | txtBoxID | DetailBar Box ID InputField | | 구현 |
| D00-1-060 | txtItemId | Form Model InputField(itemId) | | 구현 |
| D00-1-061 | txtModel2 | DetailBar Model InputField(model) | | 구현 |
| D00-1-062 | txtRequestor | DetailBar Requestor InputField | | 구현 |
| D00-1-063 | usrButton1 | | Designer 선언만, 이벤트/속성 배선 0건(01 §5-5 실측 — dead 컨트롤) | 제외 |
| D00-1-064 | usrConditionPanel1 | SearchArea(openSearchArea 토글 — MainTitle) | | 구현 |
| D00-1-065~066 | usrLayoutControl2/3 | ShipmentPlanForm / ShipmentPlanDetailBar | | 구현 |

## §2 events (29)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | BtnItemID2_Click | ShipmentPlan.tsx openItemDetailBar → ItemByDivisionModal | | 구현 |
| D00-2-002 | btnItemId_Click | ShipmentPlan.tsx openItemMain → ItemByDivisionModal | | 구현 |
| D00-2-003 | BtnMeasure_Click | handleMeasure → ColumnSettingModal(TITLESET 'M') | | 구현 |
| D00-2-004 | BtnNew_Click | handleNew 전용 본문(gap-audit J1 — InsertRow 와 별개): PlanDetail+IsLock+RowCount>0 가드, 원본행=활성행 다음(마지막이면 자기 — L7347~7352 클램프), DIVISION_ID·MKT_OWNER 2필드만 복사, markBtnNewRow → 편집 스팬 = LockRange 등가(DIVISION_ID..PRODUCT_LEVEL1 + MKT_OWNER..ORIGIN_TO_DIVISION_ID 잠금 밖 전 컬럼) | 신규행 FROM/TO_SITE·DIVISION_ID 셀콤보·route 재조회(L7421~7434)는 설계 01~03 부재+셀콤보 메타 갭으로 보류(셀콤보 축) — 04 확인필요 | 구현 |
| D00-2-005 | BtnRequestor_Click | openRequestor → RequestorModal | 목록 콤보 미등록 [META-GAP 유사 — AS-IS 원문 접근불가] | 구현 |
| D00-2-006 | BtnSearch_Click | handleDetailSearch(활성 sheet 분기 setDetailFilter) | | 구현 |
| D00-2-007 | BtnSimulation_Click | handleSimulation | 재계산 본체 부분(§3-G) — 04 확인필요 | 구현 |
| D00-2-008 | cboBucketType_SelectedIndexChanged | MainGrid isDynVisible(bucketType 의존 dynamicColumns) | | 구현 |
| D00-2-009 | cboPlanDate_SelectedIndexChanged | Form handlePlanDateChange → setPlanDate(파생/realFlag) | | 구현 |
| D00-2-010 | chkSum_CheckedChanged | MainGrid isDynVisible(chkSum 의존) | | 구현 |
| D00-2-011 | chkTotPSI_CheckedChanged | ShipmentPlan.tsx mainRows(SEQ<12/21 클라 필터) | AS-IS 는 재조회 — 서버 전량 반환 실측이라 클라 필터 등가 | 구현 |
| D00-2-012 | clbCompanyID_SelectedIndexChanged | store setCompany + 재조회 콤보 payload 의존 재발사 | | 구현 |
| D00-2-013 | clbDivision_ID_SelectedIndexChanged | store setDivision | GetNERPCode 재필터는 [PKG-SSP0002] — 제외 축 별도(D00-4-027) | 구현 |
| D00-2-014 | DrpPeriod2_ValueChanged | store setPeriod2 → clampPeriod2(무메시지) | | 구현 |
| D00-2-015 | shtDetail_Change | DetailGrid cellEditEndedHandler(SO전파/EDIT_MAIN/사유연동) | | 구현 |
| D00-2-016 | SpdDetail_ActiveSheetChanged | store setActiveDetailSheet → fieldSetOf(R1/R1a~f) | | 구현 |
| D00-2-017 | SpdDetail_CellClick | DetailGrid clickHandler(CHANGE_REQ_NO → ConfirmDetailModal) + gotFocus(activeGrid) | | 구현 |
| D00-2-018 | SpdDetail_CellDoubleClick | DetailGrid dblClickHandler(ITEM_ID/PROJECT_CODE 신규행) | ERP_SO_NO(OrderDetail·SSP0300)는 TO-BE 팝업 부재 — 제외(D00-4e-004) | 구현 |
| D00-2-019 | SpdDetail_ClipboardPasted | | 공용 DataGrid 붙여넣기 + beginningEdit 잠금이 등가. 행별 가드 세부(빈셀 차단 #16)는 04 확인필요 | 해당없음 |
| D00-2-020 | SpdDetail_ComboSelChange | DetailGrid cellEditEndedHandler(콤보 포함 편집 종료 공통) | TransMode 재조회형 콤보는 [META-GAP] | 구현 |
| D00-2-021 | SpdDetail_EditChange | DetailGrid cellEditEndedHandler(CHANGE_REASON_DETAIL 가드) | | 구현 |
| D00-2-022 | SpdDetail_SheetTabClick | DetailGrid TabWrapper setActiveTabIndex | | 구현 |
| D00-2-023 | SpdDetail_TopChange | | [WINFORMS] 스크롤 병합 재적용 — 공용 CustomMergeManager 자동 | 해당없음 |
| D00-2-024 | SpdMain_CellDoubleClick | MainGrid dblClickHandler → handleMainDrilldown | | 구현 |
| D00-2-025 | SpdMain_Change | MainGrid cellEditEndedHandler → calcPlanQty | | 구현 |
| D00-2-026 | SpdMain_ClipboardPasted | | 공용 DataGrid 붙여넣기 + beginningEdit 잠금 판정 공통 적용 | 해당없음 |
| D00-2-027 | spdMain_KeyDown | | [WINFORMS] FarPoint InputMap 커스텀 — Wijmo 기본 키맵 등가 | 해당없음 |
| D00-2-028 | spdMain_KeyUp | | [WINFORMS] 동상 | 해당없음 |
| D00-2-029 | SpdMain_TopChange | | [WINFORMS] SmartColMerge 재적용 — 공용 병합 매니저 자동 | 해당없음 |

## §2b validations (59)

| ID | msgId(AS-IS) | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-2b-001 | (예외 표시) | | 공통 axios 인터셉터/useProcMutation onError 가 등가 | 해당없음 |
| D00-2b-002 | MSG00189 ERP C 편집차단 | DetailGrid beginningEditHandler → MSG01401 | | 구현 |
| D00-2b-003 | MSG00278 운송수단 필수(저장) | ShipmentPlan.tsx handleSave planDetail → MSG00429 | | 구현 |
| D00-2b-004 | MSG00287 변경사유 필수 | DetailGrid cellEditEnded(CHANGE_REASON_DETAIL) → MSG01291 | | 구현 |
| D00-2b-005 | MSG00047 dr null 가드 | | React Query 미도착 = 빈 그리드, null 역참조 경로 없음 | 해당없음 |
| D00-2b-006~008 | MSG00098 Item 팝업 필수 3종 | ShipmentPlan.tsx openCellPopup('item') → MSG00013 | | 구현 |
| D00-2b-009~012 | MSG00098 Project 팝업 필수 4종 | ShipmentPlan.tsx openCellPopup('project') → MSG00013 | | 구현 |
| D00-2b-013 | MSG00278 (ComboSelChange 경로) | | TRANSPORT_MODE 셀콤보 [META-GAP] 갭#2 — 메타 정비 후 자동 배선 | 제외 |
| D00-2b-014 | MSG00425 하한 위반 경고 | | dNoEditQty 산정식이 03 미규정 — AS-IS 재확인 필요(04 확인필요) | 제외 |
| D00-2b-015~016 | MSG00007 Measure sheet 제한 | handleMeasure(detail 이면 조용히 no-op / 기본 main 고정) | null 그리드 상황은 TO-BE 미발생 | 구현 |
| D00-2b-017 | MSG00251 SSP 사용자 체크 | | [PKG-SSP0002] GET_USER_INFO_LIST 미배포 — fail-open, 배포 후 배선(04) | 제외 |
| D00-2b-018 | MSG00170 이전 Plan 편집차단 | handleEdit 가드② → MSG01185 | | 구현 |
| D00-2b-019 | MSG00424 편집 Sheet 상이 | handleEdit 가드③ → MSG01274 | | 구현 |
| D00-2b-020 | MSG00312 Real 아님(Detail) | handleEdit 가드②(동일 realFlag 축) → MSG01185 | | 구현 |
| D00-2b-021 | MSG00084 음수 검증 | handleSave main(negatives) → MSG00225 | | 구현 |
| D00-2b-022 | MSG00004 Main 저장 반환 | handleSave main 성공 토스트(MSG00002) | | 구현 |
| D00-2b-023 | MSG00284 Main 저장 부가 | handleSave main false-success alert(MSG00003) | | 구현 |
| D00-2b-024 | 예외 카운트 가드 | | 공통 에러 처리 등가 | 해당없음 |
| D00-2b-025 | MSG00133 변경 없음 | handleSave planDetail → MSG00133 | | 구현 |
| D00-2b-026 | MSG00004 Confirm 반환 | mutateConfirm onSuccess 토스트(MSG00002) | | 구현 |
| D00-2b-027 | MSG00324 저장 확인창 | handleSave confirm(MSG01201) | | 구현 |
| D00-2b-028 | MSG00284 Confirm 실패 | useProcMutation 기본 onError(MSG00003) | | 구현 |
| D00-2b-029~030 | HoldStock 저장 반환 2종 | handleSave holdStock 안내 alert | HoldStock 저장 SP 미존재(TO-BE/AS-IS 실측) — convert-sp 후속 | 제외 |
| D00-2b-031~033 | MSG00219/267/194 ERP 차단·정합 | | [SP-CHAIN] | 제외 |
| D00-2b-034~035 | MSG00285/286 행별 변경사유 | handleSave planDetail 행별 reason 가드 → MSG01289 | | 구현 |
| D00-2b-036~057 | ERP Drafting 체인 메시지 22종(MSG00247/049/404/197/204/324/284/248/249/189/306 등) | | [SP-CHAIN] NonSoNo/SoNo/NewNonSoNo + GetERPInterface — convert-sp 후속 | 제외 |
| D00-2b-058 | MSG00313 PlanDate 최신 불일치 | | 콤보 캐시(staleTime 0)와 서버 재대조 배선 보류 — 04 확인필요(MSG01315 예약) | 제외 |
| D00-2b-059 | MSG00292 Simulation Real 아님 | handleSimulation 경고 토스트(MSG01295) 후 계속 | | 구현 |

## §3 gridSignals (252 — §3.1 대표 35행 + §3-A~H 그룹 귀속, 00 §3.2 커버리지 구간 기준)

| ID | 요지(카테고리) | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-3-001 | SmartColMerge 헤더 병합 초기화 | 공용 CustomMergeManager + MainGrid applyMerge | | 구현 |
| D00-3-002 | Freeze(FCST_TYPE 열까지 고정) | 공용 DataGrid staticColumns(FIXED_FLAG 소비) — ShipmentPlanMainGrid | admin 메타 FIXED_FLAG=MEASURE 1건 실측(gap-resolve) — 코드 오버라이드 0 | 구현 |
| D00-3-003 | VisibleTab 6건 | DetailGrid TabWrapper(DETAIL_SHEETS 7탭) | | 구현 |
| D00-3-004 | MergePolicy Always 5~6컬럼 | MainGrid applyMerge(MAIN_MERGE_COLUMNS 한정) | | 구현 |
| D00-3-005~007 | Footer Sum/포맷/배경색 | | Footer 합계는 AS-IS Detail 전용 표시 — 공용 DataGrid 미배선, 04 확인필요 | 제외 |
| D00-3-008 | ColumnHeaderSpan 8건(3단 헤더) | MainGrid dynamicColumns(월>주>일 nested) | | 구현 |
| D00-3-009 | SetValue EDIT_MAIN='Y' | DetailGrid cellEditEnded(row.EDIT_MAIN='Y') | | 구현 |
| D00-3-010 | Action 열 강조색(FGAction/BGModified) | ShipmentPlanMainGrid formatItem(EditTracker 'M' 마킹 스타일) | AS-IS 색상값 1:1 은 04 확인필요(시각 축) | 구현 |
| D00-3-011 | CHANGE_REASON 코드/상세 연동 | DetailGrid cellEditEnded | | 구현 |
| D00-3-012 | ERP_SO_NO 액티브셀 이동·리셋 | | AS-IS 편집취소 UX 배관 — beginningEdit cancel 로 등가 | 해당없음 |
| D00-3-013 | SHIPMENT_DATE 파생 세팅 | DetailGrid cellEditEnded(SO그룹 전파) | ETD/ETA 재계산은 AS-IS 주석처리(서버 이관) — 미계산 재현 | 구현 |
| D00-3-014 | 저장 후 강조색 리셋 | mutateConfirm onSuccess clearChanges + 재조회 | | 구현 |
| D00-3-015 | Item 팝업 결과 반영(ITEM_ID/NICK_NAME) | ShipmentPlan.tsx ItemByDivisionModal(cell) setSelectedValue | | 구현 |
| D00-3-016 | Project 팝업 결과 반영 | ProjectByDivisionModal(cell) setSelectedValue | | 구현 |
| D00-3-017 | TRANSPORT_MODE 콤보 세팅 | | [META-GAP] 갭#2 — 셀콤보 메타 미배선(빈 리스트 재현) | 제외 |
| D00-3-018 | 헤더 체크박스 전체선택 토글 | | 대상 컬럼(CHECK_NEED_YN 추정) 메타 미배선 — 04 확인필요 | 제외 |
| D00-3-019 | Main 수량 편집 반영+초과 Red | MainGrid cellEditEnded → calcPlanQty (Red 시각은 EditTracker) | | 구현 |
| D00-3-020 | ChangeActiveSheet 8-sheet 전환 | DetailGrid TabWrapper + handleMainDrilldown | | 구현 |
| D00-3-021 | SmartColMerge 재적용 | 공용 병합 매니저 자동 | 공용 DataGrid 병합 매니저가 자동 재적용 — 화면 코드 불요 | 해당없음 |
| D00-3-022 | Insert 신규행 삽입·파생·잠금 | handleInsert(HoldStock/PlanDetail 2원천) + editLock | | 구현 |
| D00-3-023 | SwitchLock/LockRange 편집 잠금 28건 | utils/shipment-plan.editLock.ts(beginningEdit+formatItem) | LockRange 상수 이식 금지(hook #130) — 화이트리스트 판정 함수로 재현 | 구현 |
| D00-3-024 | 저장 실패 셀 InvalidColor | | Main 저장 음수는 저장 전 차단(MSG00225)이라 실패색 경로 미발생 — 셀 단위 표기는 04 확인필요 | 제외 |
| D00-3-025 | GetViewRowFromModelRow | | Wijmo collectionView 인덱스 공용 처리 | 해당없음 |
| D00-3-026 | Sum 체크 연동 Visible 7건 | MainGrid isDynVisible(bucket×chkSum 표) | | 구현 |
| D00-3-027 | spreadInfo 헤더 시트 잠금 | | 헤더 정보 시트는 TO-BE 미존재(dynamicColumns 로 대체) | 해당없음 |
| D00-3-028 | Query/LockColumn 조회 바인딩 9건 | 각 sheet useTabProcQuery + isReadOnly/편집잠금 | | 구현 |
| D00-3-029 | 조회 후 재병합·주석리셋·0치환 | DataGrid wrapper(병합)/서버 wide 결과 그대로 | ResetNote(셀 메모)는 D00-3-032 | 구현 |
| D00-3-030 | 조회 후 액티브셀 지정 | | UX 배관 — Wijmo 기본 포커스 | 해당없음 |
| D00-3-031 | PSI 파생값 대량 반영(§3-A) | utils/shipment-plan.calc.ts(calcPlanQty 5산식+TOT 5종) + 단위테스트 | TOT dead 4종 미계산 재현 | 구현 |
| D00-3-032 | StickyNote 셀 메모 유지 | | AS-IS EDIT_YN 노트 표시 — TO-BE wide 커서에 EDIT_YN 부재(실측), 04 확인필요 | 제외 |
| D00-3-033 | Simulation 신규행·콤보·잠금 | | §3-G SUM 캐스케이드 03 §6-9 미확정 — 경고(MSG01295)만 구현, 재계산 본체 보류(04) | 제외 |
| D00-3-034 | Sum 집계 반영(TOT 5종) | utils/shipment-plan.calc.ts recalcTotals | | 구현 |
| D00-3-035 | END_CUSTOMER 콤보·자동채움 | | [META-GAP] 갭#3(SQL+컬럼 미등록) — SetEndCustomer 는 메타 정비 후 | 제외 |

## §4 spCalls (30)

| ID | SP | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | SSP0060_GET_SHIPMENT_DIVISION | SHEETS.DIVISION(useTabProcQuery, Form) | | 구현 |
| D00-4-002 | SSP0060_SAVE_SHIPMENT_PLAN | handleSave main(apiClient.post call-proc) | PROC_M 등재는 convert-sp | 구현 |
| D00-4-003 | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | mutateConfirm(SHEETS.PLAN_DETAIL SAVE) | | 구현 |
| D00-4-004 | SSP0060_SAVE_HOLD_STOCK_DATA | handleSave holdStock 안내 | SP 미존재(TO-BE/AS-IS 실측) — convert-sp 후속. API/BTN 메타는 선등록 | 제외 |
| D00-4-005~016 | ERP Drafting 하위 SP 12종(§4 #5~16) | | [SP-CHAIN] | 제외 |
| D00-4-017 | DM0003_GET_BUCKET_TYPE_CODE | 'BucketType' 콤보 재사용(동일 원천 — core §2.6 대조) | | 구현 |
| D00-4-018 | SSP0060_GET_SHIPMENT_PLAN | SHEETS.MAIN(useTabProcQuery) — 서버 wide pivot 실측 | | 구현 |
| D00-4-019 | SSP0060_GET_SHIPMENT_PLAN_DETAIL | SHEETS.PLAN_DETAIL | | 구현 |
| D00-4-020 | SSP0060_GET_STOCK_LOCATION_DETAIL | SHEETS.STOCK_DETAIL | | 구현 |
| D00-4-021 | SSP0060_GET_OWMS_DETAIL | SHEETS.OWMS_DETAIL | | 구현 |
| D00-4-022~023 | SSP0060_GET_SHIPMENT_RESULT(2분기) | SHEETS.SHIPMENT_RESULT(단일 배선 — 분기 파라미터 P_TYPE) | | 구현 |
| D00-4-024 | SSP0060_GET_HOLD_STOCK | SHEETS.HOLD_STOCK(드릴다운 dblFlag='Y') | | 구현 |
| D00-4-025 | SSP0060_GET_MES_STOCK | SHEETS.MES_STOCK | | 구현 |
| D00-4-026 | SSP0060_GET_MES_STOCK_DETAIL | SHEETS.MES_STOCK_DETAIL | | 구현 |
| D00-4-027 | SSP0002_GET_NERP_CODE | | [PKG-SSP0002] — Company ERP 재필터 보류(goal 백로그, Form 주석) | 제외 |
| D00-4-028 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SHEETS.CALENDAR(PKG_COM0000 공용 — API P_SSP0060_GET_CALENDAR) | | 구현 |
| D00-4-029 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | | [SP-CHAIN] 동시편집 검증 — Confirm 저장 SP 내부 처리 여부 convert-sp 확인 | 제외 |
| D00-4-030 | SSP0002_GET_USER_INFO_LIST | | [PKG-SSP0002] Edit 가드① fail-open(04) | 제외 |

## §4a entryPoints (34 고유)

| ID | 진입점 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4a-001 | EditButton(toolbarOverride) | customButtons Edit → handleEdit(가드 4종) | 가드① [PKG-SSP0002] 제외 | 구현 |
| D00-4a-002 | FindButton | hotkeyConfig.search → handleSearch | | 구현 |
| D00-4a-003 | SaveButton | hotkeyConfig.save → handleSave(활성그리드 분기) | | 구현 |
| D00-4a-004 | DeleteButton (NO-OP 확정) | hotkeyConfig.delete = `() => undefined` (노출 유지) | 00 §4d 재판단 금지 | 구현 |
| D00-4a-005 | InsertButton | hotkeyConfig.insert → handleInsert(2원천+가드) | | 구현 |
| D00-4a-006~036 | event 29종 | §2 표와 동일 귀속 | | 구현(§2 참조) |

## §4b comboCalls (12)

| ID | code | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4b-001 | Incoterms(셀콤보) | admin 메타 FPComboBox 'Incoterms'(정상 배선 실측) | 라우트 종속 여부 03 §6-11 확인필요 | 구현 |
| D00-4b-002~004 | TransMode ×3(셀콤보 재조회) | | [META-GAP] 갭#2 — 컬럼 미배선(빈 리스트 재현) | 제외 |
| D00-4b-005 | SSPBlockCheckIF | | [SP-CHAIN] ERP 차단 플래그 — Drafting 경로 전용 | 제외 |
| D00-4b-006 | Plan_Infor(검증용 Tmp) | | MSG00313 대조 경로 보류(D00-2b-058) | 제외 |
| D00-4b-007 | Com_FromSite | Form From Site(Com_FromSite_SCP) | | 구현 |
| D00-4b-008 | ShipmentPlanToSite | | Detail TO_SITE 셀콤보용 — 컬럼 메타 배선 축(PARAM 등재)은 [META-GAP] 계열, 04 확인필요 | 제외 |
| D00-4b-009 | Plan_Infor(콤보) | Form Plan Date(Plan_Infor_SCP) | | 구현 |
| D00-4b-010 | CellGroup | Form/DetailBar Product Level1(CellGroup_SCP) | | 구현 |
| D00-4b-011 | Container_Size | | Simulation 재계산 본체 보류(D00-3-033)와 동일 축 | 제외 |
| D00-4b-012 | EndCustomerByItemForSSP | | [META-GAP] 갭#3(SQL 미등록) | 제외 |

## §4d buttonGuards (43)

| ID | 가드 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4d-001~002 | shtDetail_Change 진입가드(Row/Col -1, RowCount 0) | DetailGrid cellEditEnded(row null 가드) | | 구현 |
| D00-4d-003 | IsLock==false | DetailGrid editModeRef(editingGrid==='detail') | | 구현 |
| D00-4d-004 | sErpStatus=='C' | DetailGrid beginningEdit(MSG01401) | | 구현 |
| D00-4d-005~006 | TRANSPORT_MODE 컬럼/공백 | handleSave planDetail 필수 가드 | 셀 즉시 가드는 [META-GAP] 콤보 미배선 | 구현 |
| D00-4d-007~009 | CHANGE_REASON_CODE 분기(sSoNo 포함) | DetailGrid cellEditEnded | | 구현 |
| D00-4d-010~013 | SpdDetail_EditChange 가드 4종 | DetailGrid(editLock + CHANGE_REASON_DETAIL 가드) | | 구현 |
| D00-4d-014~018 | ClipboardPasted 가드 5종 | | 공용 붙여넣기 + beginningEdit 잠금 공통. 빈셀 한정(#16)·사유 매핑(#17,18)은 04 확인필요 | 해당없음 |
| D00-4d-019~030 | CellDoubleClick 가드 12종(sheet/컬럼/action='I'/필수값) | DetailGrid dblClickHandler + openCellPopup(MSG00013) | | 구현 |
| D00-4d-031~032 | ComboSelChange TRANSPORT_MODE | | [META-GAP] 갭#2 | 제외 |
| D00-4d-033~034 | CellClick CHANGE_REQ_NO/공백 | DetailGrid clickHandler(#34 공백 가드 포함) | | 구현 |
| D00-4d-035~036 | BtnMeasure fps 가드 | handleMeasure | | 구현 |
| D00-4d-037 | DrpPeriod2 범위(intDiff) | clampPeriod2(무메시지) | | 구현 |
| D00-4d-038 | EditButton isOK(사용자 체크) | | [PKG-SSP0002] fail-open | 제외 |
| D00-4d-039~040 | EditButton PlanDate/EditSpread | handleEdit 가드②③ | | 구현 |
| D00-4d-041~042 | EditButton Detail 분기/RealFlag | handleEdit 가드②(realFlag 동일 축) | | 구현 |
| D00-4d-043 | BtnNew ActiveSheetIndex!=0 | handleNew(PlanDetail 아니면 무동작) | | 구현 |

## §4e popups (21)

| ID | 팝업 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4e-001 | ItembyDivision(조회조건 2차) | ItemByDivisionModal(openItemDetailBar) | plantSite 사전필터는 공용 모달 계약(COM0008) 밖 — 04 확인필요 | 구현 |
| D00-4e-002 | ItembyDivision(Detail 셀) | ItemByDivisionModal(cellPopupKind='item') | | 구현 |
| D00-4e-003 | ProjectbyDivision(Detail 셀) | ProjectByDivisionModal(cellPopupKind='project') | | 구현 |
| D00-4e-004 | SSP0300_OrderDetailPopup | | PKG_SSP0300 미배포 + TO-BE 팝업 부재 — ERP_SO_NO dblClick 미배선(04 확인필요, 사용자 축) | 제외 |
| D00-4e-005 | ShipmentPlanConfirmDetailPopup | components/modals/ConfirmDetailModal.tsx(GET_CFM_DRAFTING) | | 구현 |
| D00-4e-006 | TitleSetForm(Measure) | ColumnSettingModal(TITLESET_MEASURE_TYPE='M') | | 구현 |
| D00-4e-007 | UserInfoPopup(Requestor) | components/modals/RequestorModal.tsx(SSP0060 전용 신규 — 사용자 확정) | 목록 콤보 SQL 등록 보류(AS-IS SystemManager 접근 불가) | 구현 |
| D00-4e-008 | ItembyDivision(조회조건 1차) | ItemByDivisionModal(openItemMain) | | 구현 |
| D00-4e-009~021 | ProgressForm ×12 + Request | Request=components/modals/ShipmentRequestModal.tsx(R8) / ProgressForm=[WINFORMS] 로딩 표시(react-query isFetching 등가) | | 구현/해당없음 |

## CRUD·모달 매트릭스

| ID | 축 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| CRUD:SEARCH | FindData_Main + Detail 8-sheet 조회 | handleSearch/handleDetailSearch/handleMainDrilldown | | 구현 |
| CRUD:SAVE | Main flat/Confirm/HoldStock/Drafting | handleSave + ShipmentRequestModal | HoldStock·Drafting 미배선은 [SP-CHAIN] 후속(convert-sp) | 구현 |
| CRUD:INSERT | HoldStock/PlanDetail 2원천 | handleInsert | | 구현 |
| CRUD:DELETE | NO-OP(00 §4d) | hotkeyConfig.delete `() => undefined` | | 구현 |
| CRUD:EDIT | 4가드 + 화이트리스트 잠금해제 | handleEdit + editLock | 가드①(GetSSPUserCheck)은 PKG_SSP0002 미배포로 fail-open — [PKG-SSP0002] 후속 | 구현 |
| MODAL:ItemByDivisionModal | 공용 재사용 ×3 | ShipmentPlan.tsx | | 구현 |
| MODAL:ProjectByDivisionModal | 공용 재사용 | ShipmentPlan.tsx | | 구현 |
| MODAL:RequestorModal | 화면 전용 신규 | components/modals/RequestorModal.tsx | 목록 콤보(SSP0060_UserInfoList) 미등록 — 직접입력 동작, 목록은 R3(사용자/SP 축) | 구현 |
| MODAL:ConfirmDetailModal | 화면 전용 신규 | components/modals/ConfirmDetailModal.tsx | | 구현 |
| MODAL:ShipmentRequestModal | 화면 전용 신규(R8) | components/modals/ShipmentRequestModal.tsx | | 구현 |
| MODAL:ColumnSettingModal | 공용(Measure) | ShipmentPlan.tsx | | 구현 |
| MODAL:OrderDetailPopup | ERP_SO_NO dblClick(SSP0300) | (TO-BE 부재) | PKG_SSP0300·TO-BE 팝업 부재 — 미배선(SP/화면 후속) | 제외 |

## 잔여(제외/확인필요) 총괄 — 완료 조건 아님, 04_react-gap.md "확인 필요/SP 후속" 과 1:1

1. [SP-CHAIN] ERP Drafting IF 체인(validations 22종 + SP 12종 + Container_Size/SSPBlockCheckIF) — convert-sp 후속.
2. [PKG-SSP0002] GetSSPUserCheck(Edit 가드① fail-open)·GetNERPCode(Company ERP 재필터).
3. [META-GAP] 셀콤보/컬럼 메타 5건(TRANSPORT_MODE/END_CUSTOMER/CHANGE_REASON_CODE/STOCK_STATUS/INPUT_TP_CD) — 빈 리스트 재현이 정답, admin 정비 대기.
4. HoldStock 저장 SP 미존재(AS-IS DB 에도 없음 — 실측).
5. Simulation 재계산 본체(03 §6-9 미확정)·MSG00425 하한식·MSG00313 재대조·Footer 합계·StickyNote·헤더 체크박스·splitter 리사이즈·OrderDetail 팝업·R5 IsLock 부가조건 — 04 확인필요(사용자 축).

---

## iter-2 보완 매핑 (2026-09-25 — react-gap-audit iter-1 issues I1~I22 해소분)

> 형식: `ID | AS-IS 근거(gist) | To-Be 구현(impl) | 사유(reason) | 상태(status)` — asis_mapping_gate 5열 규약.
> gap-resolve iter-1(2026-09-26) 에 I5/I11/I15 를 DB 실측으로 해소(구현), I7/I13/I20/I17~21 은 블로커 사유 명시 제외로 정정.

| ID | AS-IS 근거 | To-Be 구현 | 사유 | 상태 |
|---|---|---|---|---|
| I1-paste | SpdMain_ClipboardPasted(.cs L994~1029 — SHIP_PLAN_DETAIL&&TO_SITE 행만 EditByChange) + FarPoint Lock | MainGrid pastingCell(동적 D_/W_/M_ 에 isMainCellEditable 전체대입) + pastedCell→calcPlanQty | | 구현 |
| I1-delete | spdMain_KeyUp(.cs L2462~2521 — 선택범위 D_ 셀 "0"+EditByChange) | MainGrid keydown 캡처(Delete): 편집가능 D_ 셀만 0 세팅 + EditTracker.storeChange + 셀 단위 calcPlanQty | 편집가능 셀 한정 — AS-IS 는 전 D_ 셀(04 확인필요 병기, 사용자 축) | 구현 |
| I2 | SaveData_Main IsLock(shtMain)==false 가드(.cs L2935~2940 — 조용히 무시) | handleSave main: `!mainEditable`(canEdit·최신Plan) 이면 silent return (gap-resolve A00: editMode 제거) | | 구현 |
| I3 | InsertRow 두 분기 IsLock==false 가드(.cs L2539/L2558) | handleInsert/handleNew: `!detailEditable` 이면 silent return (gap-resolve A00: editMode 제거) | | 구현 |
| I4 | 메타 구동 전 컬럼 FPMerge.Restricted(framework SpreadInfo.cs:1295) + Always 6컬럼(L651~656). 동적 D_/W_/M_ 는 FPMerge.None | MainGrid applyMerge: base 전 컬럼 allowMerging=true / 동적만 false(CustomMergeManager 누적 키 병합) | | 구현 |
| I5 | spdInfo.Freeze(0, FCST_TYPE+1)(.cs L648) — 코드가 메타(FIXED_FLAG=MEASURE 1건)를 오버라이드 | staticColumns 소비(FIXED_FLAG 메타 구동), 코드 fixed 리터럴 오버라이드 0건(grep) | gap-resolve DB 실측: Main FIXED_FLAG='Y'=MEASURE 1건(freeze 경계) 확인 — 규칙 준수 해소 | 구현 |
| I6 | InsertRow defaultData 명시 45항목(.cs L2644~2692) + 공백 STATUS='C' 간주(L2568~2571) | PLAN_DETAIL_INSERT_COPY_COLUMNS 상수(43 복사 + QTY 0/ERP_STATUS '' 강제) + status 공백='C' 허용 | | 구현 |
| I7 | Form_Load FindString(sUserCompany_NM)(.cs L329~334) — 원천 SSP InnerTable MyCompanyID | 첫 행 선택만 재현 | TO-BE 세션(UserSession)에 company 필드 부재 실측 — 매칭 수단(세션 확장/콤보 등록)은 사용자 축 | 제외 |
| I8 | SpdDetail_SheetTabClick index5: SetItemChecked(0/1,true)(.cs L2434~2441) | DetailBar effect: ShipmentResult 활성 시 lookup 앞 2코드 merge 체크 | | 구현 |
| I9 | Division/Company 변경 시 그리드 초기화(hook #5, np §5-5) | store setDivision/setCompany: filters={} / 페이지 effect: EditTracker 3종 clearChanges (gap-resolve A00: editMode 해제 제거 — 편집 기본 ON) | | 구현 |
| I10 | SpdMain_CellDoubleClick(.cs L2320~2381): MES=Detail+Stock 2연속 조회(활성=MES Stock) / 말미 bEdit_Mode=false | handleMainDrilldown MES 특수분기 + setEditMode(false,'') + MainGrid dblClick 대상 kindOf(D_/W_/M_) 확대 | | 구현 |
| I11 | Simulation()(.cs L7463~7886): 1단계 Red SHIP_PLAN WH/BALANCE/CONTAINER(CEIL) + 2단계 전행 SUM 캐스케이드 | utils/shipment-plan.calc.ts `simulate()`+`buildCalendarGroups()`(vitest 12/12 PASS) | gap-resolve DB 실측: Container_Size_SCP 등록 확인 — Container qty 산출 경로 해소 | 구현 |
| I13 | TRANSPORT_MODE 콤보 강제(SetCellTypeCombo 재조회 L1973~1997) — 메타 CELL_CONTROL_OBJECT_TYPE_CODE 공백 | 화이트리스트 편집(텍스트) — 콤보 미배선 | gap-resolve DB 실측: TransportMode 콤보는 레지스트리 존재하나 컬럼메타(CELL_COMBO_DATA_TYPE) 미참조. AS-IS 는 C# 런타임 배선 → 메타 정비는 admin 결정(§2.3 임의배선 금지, 사용자 축) | 제외 |
| I14 | 정정: BaseForm.FpSpread_CellClick(BaseForm.cs L2303~2305)이 모든 셀 클릭에서 fps 무조건 전환 | activeGrid = 마지막 클릭 그리드(양방향): MainGrid click→'main', DetailGrid gotFocus→'detail' | 프레임워크(BaseForm) 근거 — audit expect 와 상이(04 명시) | 구현 |
| I15 | HeaderSpan "BOH"(.cs L634) | staticColumns 승계(base 컬럼 헤더 = admin 메타 s/lClsLblNm) | gap-resolve DB 실측: SMALL/LARGE_CLASS_LABEL_NAME='BOH'(BOH_TYPE·BOH_QTY) 메타 존재 확인 — 해소 | 구현 |
| I16 | InitSpreadFooterSum(.cs L764~853 — 시트별 수치구간 Sum + 'Sum' 라벨) | DetailGrid effect: FOOTER_SUM_RANGE(7시트 anchor 실측) + wijmo columnFooters Aggregate.Sum | 'Sum' 라벨·배경색은 공용 footer 렌더 시각 축 — 사용자 확인 | 구현 |
| I17 | EDIT_YN 셀 노트(StickyNote) | 미배선 — wide 커서에 EDIT_YN 부재(실측) | SP 확장(convert-sp) 또는 미이관 확정 — SP/사용자 축 | 제외 |
| I18 | HoldStock 탭 상시 노출 정책 | 상시 노출 재현 | AS-IS 런타임 거동 확인 필요 — 사용자 축 | 제외 |
| I19 | 토/일 DAY_CODE 실값 | 변경 없음 | PROC_M 등재(convert-sp) 후 call-proc 실행값 확인 — SP 축 | 제외 |
| I20 | BtnItemID2_Click plantSite 전달(.cs L1031~1045) | 공용 ItemByDivisionModal 계약(preSearchParams 에 plantSite 없음 — COM0008 파라미터 밖) | 의도적 차이 — 공용 모달 개조는 Hard Boundary 금지 | 제외 |
| I21 | Confirm payload 키 ↔ PROC_M COL_NM 정합 | 변경 없음 | convert-sp PROC_M 등재 시 확정 — SP 축 | 제외 |
| I22 | SpdDetail_ClipboardPasted 가드 5종(L1395~) — 잠금해제 셀 붙여넣기 허용 | DetailGrid(PlanDetail/HoldStock) pastingCell 에 isDetailCellEditable 전체대입 + pastedCell 에 SO전파 핸들러 연결 | | 구현 |
| NEW-1 | 공용 wrapper beginningEdit/pastingCell 이 메타 'S' 전건을 취소 — cancel-only 배선으론 Detail 편집 실동작 불가 | Detail 판정 핸들러를 e.cancel 전체대입으로 교체(화이트리스트만 해제) | | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate.py --check 가 부재 행을 FAIL 처리한다.
> gap-resolve iter-1(2026-09-26)에 전 행 코드 대사로 판정 기입. UC-01/05/07 은 공용 DataGrid(@shared) 승계.

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFilter) | 공용 DataGrid(@shared/components organisms/data-grid/DataGrid.tsx) keepRowVisibleUnderFilter — 화면이 DataGrid 사용으로 승계 | | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 confirm(MSG00703) | ShipmentPlan.tsx handleSearch — EditTracker.hasChanges() 3종 판정 후 setAlert(confirm, MSG00703)→onConfirm=runMainSearch | | 구현 |
| COMMON:UC-03 | 컬럼/Measure 설정 적용 시 기존 데이터 Reset 후 재조회 | ShipmentPlan.tsx ColumnSettingModal onSave → activeGrid==='main' 시 refetchMain (L816~818) | | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 Toast | ShipmentPlan.tsx:223 setToast(success, MSG.SAVED) / ShipmentRequestModal.tsx:71 setToast — 저장성공 toast, setAlert 는 검증차단 전용 | | 구현 |
| COMMON:UC-05 | Excel Download 콤보 컬럼 Code 아닌 Name 출력 | 공용 DataGrid excel 출력이 staticColumns 콤보 dataMap 승계(Name) — 화면은 excelFileName='ShipmentPlan'(L683) + staticColumns 전달 | | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중 입력 전건 조회 | useShipmentPlanStore.ts:110 multiLine() split(/[\n,]/) — Model/Item/BoxID 콤마·개행 다중 | | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns) | 공용 DataGrid(@shared) rebindFilterColumns — 화면이 DataGrid 사용으로 승계 | | 구현 |

## gap-resolve iter-1 정정 (2026-09-26 — DB 실측 반영, 상단 잔여 총괄 중 해소분)

- **[META-GAP] 정정**: iter-1~3 이 도구 차단으로 미확정했던 셀콤보/컬럼 메타를 `ora.py` 실측 확정.
  - CHANGE_REASON_CODE: SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE='CHANGE_REASON_CODE_ALL' 배선 확인 → 콤보 존재+staticColumns 승계 = **구현**(갭 아님).
  - Container_Size_SCP(I11): SCM_ADM_CMBO_SQL_M 등록 확인 → Simulation Container qty 정상 산출 경로 = **해소**.
  - I5 FIXED_FLAG: Main 시트 FIXED_FLAG='Y' = MEASURE 1건(freeze 경계). 코드 fixed 리터럴 오버라이드 0건(grep) → staticColumns 소비 = 규칙 준수 **해소**.
  - I15 BOH 헤더: SMALL/LARGE_CLASS_LABEL_NAME='BOH'(BOH_TYPE·BOH_QTY) 메타 존재 → staticColumns 승계 = **해소**.
  - J2 기본 2코드: SSP_SHIPMENT_RESULT_TYPE DISPLAY_SEQ 1=P(Plan)/2=O(oWMS) 실측 → 코드 기본체크 일치 **해소**.
  - TRANSPORT_MODE·END_CUSTOMER: 컬럼 메타에 콤보 미배선(TransportMode 콤보는 레지스트리 존재하나 컬럼 메타 미참조). AS-IS 는 C# SetCellTypeCombo 런타임 배선 → 메타 정비는 admin 결정(§2.3 임의 배선 금지) = **R3(사용자/admin 축)**.
- **[META-GAP] INPUT_TP_CD**: 196/196 전건 'S' 실측 확정 — AS-IS 갭 정확 재현(코드 화이트리스트 편집), 임의 채움 금지.
- **[Requestor] 정정**: UP_FX_GetUserInfoList 는 AS-IS LGCE_SCMDEV 에 실존(접근 가능 — iter-1 "SystemManager DB 접근 불가" 는 오판). 다만 TO-BE 유저검색 콤보 미등록·자매 미러 부재로 SSP0060_UserInfoList 신규 등록은 SP 변환/패턴 결정 필요 = **R3**.
- **[A00 editMode 토글 제거 — R1 해소]**: 독립 감사(react-gap-audit iter-4)가 지목. iter-1~3 이 이식한 AS-IS EditButton/SwitchLock '수정 모드' 토글(`editMode`/`setEditMode`/`editingGrid`)을 제거하고 `const canEdit = hasButton('EDIT')`(마운트 1회) + `mainEditable`/`detailEditable`(=canEdit·realFlag) 로 전환. 근거: convert-core §2.4 · memory [[editbutton-toggle-not-ported]] · 자매 [[ssp0025-no-edit-toggle-always-editable]](전 화면 공통 결정 2026-09-23/25). 잠금 범위(editLock 화이트리스트 10컬럼·BtnNew 스팬·STATUS 게이트)·realFlag(최신 Plan) 데이터 조건은 보존. Edit customButton 미노출. self-check grep `editMode|setEditMode` 0 hit / type-check·lint·vitest(12/12) PASS. 변경 5파일: ShipmentPlan.tsx·useShipmentPlanStore.ts·components/ShipmentPlan{Main,Detail}Grid.tsx·utils/shipment-plan.editLock.ts.
