# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Period / LayoutControlItem | components/ShipmentRequestForm.tsx:280 (PeriodField) | AS-IS drpPeriod readOnly 는 shared PeriodField 개변 필요(Hard Boundary)로 미이식, 편집가능 대체(DMF0040 표준). 컨트롤 자체는 구현 | 구현 |
| D00-1-002 | §1 btnColumn / UsrButton | ShipmentRequest.tsx:367-378 (customButtons COLUMN_SETUP) |  | 구현 |
| D00-1-003 | §1 btnItemId / UsrButton | components/ShipmentRequestForm.tsx:251 (ItemField 팝업 진입) |  | 구현 |
| D00-1-004 | §1 btnMeasure / UsrButton | ShipmentRequest.tsx:379-389 (customButtons MEASURE_SELECT) |  | 구현 |
| D00-1-005 | §1 btnProject / UsrButton | components/ShipmentRequestForm.tsx:239 (ProjectField 팝업 진입) |  | 구현 |
| D00-1-006 | §1 cboBucketType / UsrCombo | components/ShipmentRequestForm.tsx:263-277 (Bucket CustomDropdown) |  | 구현 |
| D00-1-007 | §1 cboDivision / UsrCombo | components/ShipmentRequestForm.tsx:184-212 (Division CustomDropdown) |  | 구현 |
| D00-1-008 | §1 chkSum / UsrCheckBox | components/ShipmentRequestGrid.tsx:704-748 (sumYn 상위버킷 표시 토글) |  | 구현 |
| D00-1-009 | §1 clbCustomer / UsrCheckedList | components/ShipmentRequestForm.tsx:220-226 (End Customer multiField) |  | 구현 |
| D00-1-010 | §1 clbDivision / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트(clbDivision 는 Division 라벨/그룹 컨테이너) — TO-BE 무관 | 해당없음 |
| D00-1-011 | §1 clbPlantSite / UsrCheckedList | components/ShipmentRequestForm.tsx:231-238 (Plant Site multiField, 40 비활성) |  | 구현 |
| D00-1-012 | §1 clbSalesSite / UsrCheckedList | components/ShipmentRequestForm.tsx:227-229 (Sales Site multiField) |  | 구현 |
| D00-1-013 | §1 clbTeam / UsrCheckedList | components/ShipmentRequestForm.tsx:213-219 (Team multiField) |  | 구현 |
| D00-1-014 | §1 components / System.ComponentModel.Container |  | WinForms designer 아티팩트(IContainer) — TO-BE 무관 | 해당없음 |
| D00-1-015 | §1 drpPeriod / UsrDateRangePicker | components/ShipmentRequestForm.tsx:280 (PeriodField) | 컨트롤은 구현(편집가능 대체). AS-IS readOnly 속성만 미이식(D00-1-001·헤더 주석 27-33) | 구현 |
| D00-1-016 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem12 / EmptySpaceItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem2 / EmptySpaceItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-019 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-020 | §1 emptySpaceItem6 / EmptySpaceItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-021 | §1 emptySpaceItem8 / EmptySpaceItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-022 | §1 imageList1 / System.Windows.Forms.ImageList |  | WinForms designer 아티팩트(아이콘 리소스 컨테이너) — TO-BE 무관 | 해당없음 |
| D00-1-023 | §1 layoutControlGroup1 / LayoutControlGroup |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-024 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-025 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-026 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-027 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-028 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-029 | §1 layoutControlItem5 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-030 | §1 layoutControlItem6 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-031 | §1 layoutControlItem7 / LayoutControlItem |  | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-032 | §1 lblBucket / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label(Form.tsx:265)로 흡수 | 해당없음 |
| D00-1-033 | §1 lblCustomer / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-034 | §1 lblItemType / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-035 | §1 lblModel / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-036 | §1 lblPlantSite / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-037 | §1 lblProject / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-038 | §1 lblSalesSite / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-039 | §1 lblTeam / LayoutControlItem |  | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-040 | §1 spdMain / FpSpread | components/ShipmentRequestGrid.tsx:796-814 (DataGrid=Wijmo FlexGrid) |  | 구현 |
| D00-1-041 | §1 spdMain_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView 아티팩트 — TO-BE 는 단일 FlexGrid(spdMain=D00-1-040)로 흡수, 시트 2종은 activeSheet 상태(store) | 해당없음 |
| D00-1-042 | §1 txtItemId / UsrMultiLineEditor | components/ShipmentRequestForm.tsx:251 (ItemField multiCheckbox) | AS-IS 콤마 다중 텍스트 입력 → TO-BE 다중선택 필드로 재현 | 구현 |
| D00-1-043 | §1 txtProject / UsrMultiLineEditor | components/ShipmentRequestForm.tsx:239 (ProjectField multiCheckbox) | AS-IS 콤마 다중 텍스트 입력 → TO-BE 다중선택 필드로 재현 | 구현 |
| D00-1-044 | §1 usrConditionPanel1 / UsrConditionPanel | components/ShipmentRequestForm.tsx:174-288 (SearchArea) |  | 구현 |
| D00-1-045 | §1 usrLayoutControl1 / UsrLayoutControl |  | WinForms 레이아웃 컨테이너 아티팩트 — TO-BE 는 SearchArea/Grid layout(D00-1-044)으로 흡수 | 해당없음 |
| D00-1-046 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms 레이아웃 컨테이너 아티팩트 — TO-BE 는 SearchArea/Grid layout 으로 흡수 | 해당없음 |
| D00-2-001 | §2 btnColumn / Click | ShipmentRequest.tsx:373 (setOpenColumnSetting) → components/ShipmentRequestModals.tsx:177 (ColumnLayoutModal) |  | 구현 |
| D00-2-002 | §2 btnItemId / Click | components/ShipmentRequestForm.tsx:251 (ItemField 팝업) → components/ShipmentRequestModals.tsx:129 (ItemByDivisionModal) |  | 구현 |
| D00-2-003 | §2 btnMeasure / Click | ShipmentRequest.tsx:382 (setOpenMeasureSelect) → components/ShipmentRequestModals.tsx:239 (MeasureSelectModal) |  | 구현 |
| D00-2-004 | §2 btnProject / Click | components/ShipmentRequestForm.tsx:239 (ProjectField 팝업) → components/ShipmentRequestModals.tsx:99 (ProjectByDivisionModal) |  | 구현 |
| D00-2-005 | §2 cboBucketType / SelectedIndexChanged | ShipmentRequest.tsx:216 (handleBucketChange, validateBucketChange MSG00227 가드) |  | 구현 |
| D00-2-006 | §2 cboDivision / SelectedIndexChanged | ShipmentRequest.tsx:203 (handleDivisionChange, cascade 초기화) |  | 구현 |
| D00-2-007 | §2 chkSum / CheckedChanged | components/ShipmentRequestGrid.tsx:704 (applyDynVisibility sumYn 분기) |  | 구현 |
| D00-2-008 | §2 clbCustomer / SelectedIndexChanged | utils/dmf0045.searchCombos.ts:28 (salesSite cascade — UserSiteByEndCustomer) | useCascadeFields 파라미터 자동 refetch(SalesSite 재조회) | 구현 |
| D00-2-009 | §2 clbTeam / SelectedIndexChanged | utils/dmf0045.searchCombos.ts:53 (resolveSalesSiteDeptIds, div40 Team 변경 시 DEPT_ID cascade) |  | 구현 |
| D00-2-010 | §2 spdMain / CellDoubleClick | components/ShipmentRequestGrid.tsx:576 (dblclickHandler — 헤더 드릴다운 579-604 + 셀 모달 606-616) |  | 구현 |
| D00-2-011 | §2 spdMain / ComboSelChange | components/ShipmentRequestGrid.tsx:504 (cellEditEndedHandler — 셀 편집 종료/재계산) | AS-IS 인셀 콤보 선택변경 = TO-BE cellEditEnded(편집확정)로 흡수 | 구현 |
| D00-2-012 | §2 spdMain / TopChange | utils/dmf0045.merge.ts:98 (HierarchicalMergeManager = SmartColMerge + TopChange), Grid.tsx:627 (인스턴스화) |  | 구현 |
| D00-2-013 | §2 spdMain / KeyUp | components/ShipmentRequestGrid.tsx:501 (pastingCell) / 567·573 (pastedCell — Ctrl+C/V) | AS-IS KeyUp Ctrl+C/V = TO-BE Wijmo autoClipboard + pastingCell/pastedCell 훅으로 흡수 | 구현 |
| D00-3-001 | §3 SmartColMerge / 미산출(1.0) | utils/dmf0045.merge.ts:98 (HierarchicalMergeManager) |  | 구현 |
| D00-3-002 | §3 LockColumn / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler — LockColumn 강제) + utils/dmf0045.editLock.ts:59 (evalShipmentDynCell R1) |  | 구현 |
| D00-3-003 | §3 LockRange / 미산출 | utils/dmf0045.editLock.ts:59 (evalShipmentDynCell R2 MEASURE whitelist) |  | 구현 |
| D00-3-004 | §3 LockRange / 미산출 | utils/dmf0045.editLock.ts:59 (evalShipmentDynCell R3 row-action I/M/D) |  | 구현 |
| D00-3-005 | §3 LockRange / 미산출 | utils/dmf0045.editLock.ts:45 (isFrozenLeadingDay R4 SHIP_FROZEN 선행 D_ 잠금) |  | 구현 |
| D00-3-006 | §3 LockRange / 미산출 | utils/dmf0045.editLock.ts:91 (insertStaticEditable R5 신규행 정적셀 화이트리스트) |  | 구현 |
| D00-3-007 | §3 LockRange / 미산출 | utils/dmf0045.editLock.ts:116 (isInsertModalCell 신규행 모달셀 잠금) |  | 구현 |
| D00-3-008 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange 종합 enforcement) |  | 구현 |
| D00-3-009 | §3 SmartColMerge / 미산출 | utils/dmf0045.merge.ts:117 (getMergedRange Data Cell 좌측 키컬럼 세로 머지) |  | 구현 |
| D00-3-010 | §3 SetValue / 미산출 | utils/dmf0045.bohFrontFill.ts:33 (applyBohFrontFill = Set_SumValues BOH 첫 D_ 전방채움) |  | 구현 |
| D00-3-011 | §3 SetValue / 미산출 | utils/dmf0045.recalc.ts:80 (expandBucketToDays — W_/M_ 입력 → 하위 D_ 전개) |  | 구현 |
| D00-3-012 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-013 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-014 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-015 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-016 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-017 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-018 | §3 LockRange / 미산출 | components/ShipmentRequestGrid.tsx:466 (beginningEditHandler LockRange) |  | 구현 |
| D00-3-019 | §3 SetValue / 미산출 | components/ShipmentRequestGrid.tsx:504 (cellEditEndedHandler — 정수 절삭 + D_ 전개 반영) |  | 구현 |
| D00-3-020 | §3 SetValue / 미산출 | utils/dmf0045.save.ts:76 (buildUnfoldRows — 값 '0' → 'D' 셀 삭제 전환) |  | 구현 |
| D00-3-021 | §3 SmartColMerge / 미산출 | utils/dmf0045.merge.ts:152 (getMergedRange ColumnHeader 2단 년월/주차 가로 머지) |  | 구현 |
| D00-4d-001 | §4d MSG00097 / sDivision == "" | utils/dmf0045.validate.ts:42 (validateFind REQUIRE_DIVISION MSG00097) + ShipmentRequest.tsx:190 (handleSearch 가드) |  | 구현 |
| D00-4d-002 | §4d (예외) / — (GMessageBoxForException) | ShipmentRequest.tsx:281 (handleSave 예외 → SAVE_ERROR toast) | AS-IS 조회 예외 메시지박스 = TO-BE useTabProcQuery 공통 에러핸들러/toast 로 흡수 | 구현 |
| D00-4d-003 | §4d MSG00043 / !fnValidation() | utils/dmf0045.save.ts:6-9 (중복검사 SP 내장 — SAVE SP fnValidation 재구현 금지) | AS-IS fnValidation 중복체크는 SAVE SP(P_DMF0045_SAVE_SHIPMENT_REQUEST) 서버 검증에 위임 — 클라 재구현 금지 규약 | 해당없음 |
| D00-4d-004 | §4d MSG00084 / nDayQty < 0 | utils/dmf0045.validate.ts:102 (validateSaveRows 음수 qty → MSG00085) | AS-IS MSG00084 미매핑 → 배포 MSG00085 재매핑(constants.ts:NEGATIVE_QTY) | 구현 |
| D00-4d-005 | §4d MSG00004 / 결과[0][0]=="S" (iCount) | ShipmentRequest.tsx:281 (handleSave 성공 → MSG.SAVED toast MSG00004) |  | 구현 |
| D00-4d-006 | §4d (무msgId) / 결과[0][0]=="N" | ShipmentRequest.tsx:281 (handleSave 결과 파싱 → 실패 toast) | AS-IS msgId 없는 N 분기 = TO-BE parseSaveOutcome/SAVE_ERROR 공통 실패경로로 흡수 | 구현 |
| D00-4d-007 | §4d MSG00042 / 결과[0][0]=="N" | ShipmentRequest.tsx:281 (handleSave 실패 → SAVE_ERROR toast MSG00618) | AS-IS MSG00042(저장실패) → TO-BE SAVE_ERROR(MSG00618) 재매핑(constants.ts) | 구현 |
| D00-4d-008 | §4d MSG00005 / iCount > 0 | ShipmentRequest.tsx:242 (handleSave — 변경 0건 시 저장 스킵, validate.ts:79 NO_CHANGES MSG00004) | AS-IS iCount>0 저장대상 존재 판정 = TO-BE buildUnfoldRows 수집 결과(0건 → NO_CHANGES)로 흡수 | 구현 |
| D00-4d-009 | §4d (예외) / — (GMessageBoxForException) | ShipmentRequest.tsx:281 (handleSave 저장 예외 → SAVE_ERROR toast) | AS-IS 저장 예외 메시지박스 = TO-BE 공통 에러핸들러/toast 로 흡수 | 구현 |
| D00-4d-010 | §4d MSG00098 / p_item_id == "" (Model) | utils/dmf0045.editLock.ts:132 (canOpenBodPopup ITEM_ID 선행조건) + ShipmentRequest.tsx:156 (handlePopupCellDblClick MSG.ITEM_REQUIRED_FOR_BOD 가드) | AS-IS MSG00098 미매핑 → 임시 MSG00002(constants.ts:ITEM_REQUIRED_FOR_BOD) | 구현 |
| D00-4d-011 | §4d MSG00002 / sDivision == "" (Division ID) | utils/dmf0045.validate.ts:88-100 (validateSaveRows REQUIRED_FIELDS 루프, DIVISION_ID) |  | 구현 |
| D00-4d-012 | §4d MSG00002 / sProjectCode == "" (Project Code) | utils/dmf0045.validate.ts:88-100 (REQUIRED_FIELDS PROJECT_CODE) |  | 구현 |
| D00-4d-013 | §4d MSG00002 / sSiteId == "" (Sales Site ID) | utils/dmf0045.validate.ts:88-100 (REQUIRED_FIELDS FROM_SITE) |  | 구현 |
| D00-4d-014 | §4d MSG00002 / sItemId == "" (Item ID) | utils/dmf0045.validate.ts:88-100 (REQUIRED_FIELDS ITEM_ID) |  | 구현 |
| D00-4d-015 | §4d MSG00002 / sFcstType == "" (FCST Type) | utils/dmf0045.validate.ts:88-100 (REQUIRED_FIELDS FCST_TYPE) |  | 구현 |
| D00-4d-016 | §4d MSG00002 / sIncoterms == "" (Incoterms) | utils/dmf0045.validate.ts:88-100 (REQUIRED_FIELDS INCOTERMS) |  | 구현 |
| D00-4d-017 | §4d MSG00002 / sMeasure == "" (Measure) | utils/dmf0045.validate.ts:88-100 (REQUIRED_FIELDS MEASURE) |  | 구현 |
| D00-4d-018 | §4d MSG00002 / sDivision=="81" && sPlantSiteId=="" (Plant Site ID) | utils/dmf0045.validate.ts:85 (validateSaveRows Div81 TO_SITE 필수 분기) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:BodItemRouteModal | FE 실존 모달 (components/modals/BodItemRouteModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/ShipmentRequestModals.tsx:155 (BodItemRouteModal, DMF0046 BOD 경로) | AS-IS spdMain_CellDoubleClick TR_MODE→DMF0046 BOD 팝업(cs 1312-1393) 근거 | 구현 |
| MODAL:ShipmentRequestModals | FE 실존 모달 (components/ShipmentRequestModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/ShipmentRequestModals.tsx:99·129·177·239 (Project/Item/Column/Measure 모달 집합) | AS-IS btnProject/btnItemId/btnColumn/btnMeasure Click + CellDoubleClick 팝업 집합의 TO-BE 컨테이너 | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/ShipmentRequestModals.tsx:99 (SCM0002 Project), :129 (DMF0047 Item), :155 (DMF0046 BOD) | AS-IS 범용 ShowDialog(cs 1250-1432 PROJECT_CODE/TR_MODE/ITEM_ID 셀더블클릭) = TO-BE 3종 셀모달 집합으로 재현 | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | components/ShipmentRequestGrid.tsx:751 (reapplyInsertRowVisibility + keepRowVisibleUnderFilter) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ShipmentRequest.tsx:208 (handleSearch — hasPendingChanges() 시 MSG.CONFIRM_RESEARCH_UNSAVED confirm, onConfirm=runSearch) / constants.ts:107 (CONFIRM_RESEARCH_UNSAVED='MSG00703' — SCM_ADM_MSG_M 실측) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | store/useShipmentRequestStore.ts:294 (fetchStaticColumns) / :327 (fetchStaticMeasures) / :413 (applyColumnLayout — 적용 후 재조회) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentRequest.tsx:281 (handleSave 성공 → MSG.SAVED toast) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | components/ShipmentRequestGrid.tsx:797-814 (DataGrid comboParams 806 dataMap → Excel Name 출력, SubTitle excelFileName) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | store/useShipmentRequestStore.ts:237 (setFilter — j()/raw() 콤마구분 payload, 208·210) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ShipmentRequestGrid.tsx:761 (FlexGridFilter rebindFilterColumns 재적용) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | components/ShipmentRequestGrid.tsx:751 (reapplyInsertRowVisibility + keepRowVisibleUnderFilter) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ShipmentRequest.tsx:208 (handleSearch — hasPendingChanges() 시 MSG.CONFIRM_RESEARCH_UNSAVED confirm, onConfirm=runSearch) / constants.ts:107 (CONFIRM_RESEARCH_UNSAVED='MSG00703' — SCM_ADM_MSG_M 실측) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | store/useShipmentRequestStore.ts:294 (fetchStaticColumns) / :327 (fetchStaticMeasures) / :413 (applyColumnLayout — 적용 후 재조회) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentRequest.tsx:281 (handleSave 성공 → MSG.SAVED toast) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | components/ShipmentRequestGrid.tsx:797-814 (DataGrid comboParams 806 dataMap → Excel Name 출력, SubTitle excelFileName) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | store/useShipmentRequestStore.ts:237 (setFilter — j()/raw() 콤마구분 payload, 208·210) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ShipmentRequestGrid.tsx:761 (FlexGridFilter rebindFilterColumns 재적용) |  | 구현 |
