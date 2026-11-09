# SCP0037 Operation LT — AS-IS ↔ TO-BE 매핑 매트릭스

> convert-core §2.1 Top11 #11: validations / gridSignals / buttonGuards / events 전건 1:1 매핑.
> AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0037_OperationLT/SCP0037_OperationLT.cs`(+`.Designer.cs`).
> 백본: `.atlas/gscm-design/SCP0037/design/00_checklist.md` §2b/§3/§4d, roslyn/screen-analysis.json.
> TO-BE: `features/supply/src/pages/operation-lt/`. NSCM 표준 — 그리드 상시 편집 + 셀 white-list(editLock),
>   AS-IS "조회직후 전체 lock -> Edit unlock" 모드전이는 셀별 white-list 상시 적용으로 대체(formation/tact-time 선례).

## validations (n=7, design 00 §2b)

| # | msgId | AS-IS 조건(cs) | TO-BE 구현 |
|--:|---|---|---|
| 1 | MSG00004 | 저장결과 `Rows[0][0]=="S"` -> "{n}개 저장" + 재조회 (L506) | `useProcMutation` onSuccess 표준 toast(MSG.SAVE_SUCCESS=MSG00672 "{0} data saved.") + invalidate 재조회 (OperationLT.handleSave) |
| 2 | (무msgId) | 저장결과 `Rows[0][0]=="N"` -> 서버 errorMsg (L518) | 저장 실패시 서버 메시지 표준 경로(useProcMutation 실패 핸들) |
| 3 | MSG00006 | 저장결과 그 외 -> 일반 실패 (L522) | MSG.SAVE_FAIL=MSG00006 "Failed to save." (표준 실패 toast) |
| 4 | MSG00093 | SCM_SITE_ID 셀 클릭 시 `IsNullOrEmpty(divisionId)` (L551) | OperationLTGrid dblclick guard — division 공백 시 MSG.REQUIRED_SELECT(MSG01122 "Select {0}", {0}=Division) |
| 5 | MSG00093 | ITEM_ID 셀 클릭 시 `IsNullOrEmpty(divisionId)` (L664) | 위와 통합(design §2b 비고) — dblclick guard division |
| 6 | MSG00093 | ITEM_ID 셀 클릭 시 `IsNullOrEmpty(sScmSite)` (L671) | OperationLTGrid dblclick guard — SCM_SITE_ID 공백 시 MSG01122 {0}=Plant Site |
| 7 | MSG00060 | 저장 전 4키 중복 `!isPass` (L970 checkValidN1) | useOperationLTValidation.validateSaveRows — 4키(DUP_KEY_COLUMNS) 중복 시 MSG.DUPLICATE(MSG01092 "The same {0} exists.", {0}=Operation LT) |

## buttonGuards (n=13, design 00 §4d)

| # | method | AS-IS 조건 | TO-BE 구현 |
|--:|---|---|---|
| 1 | DeleteButton | `fps != null` (L286) | OperationLT.handleDelete — `if(!grid) return` |
| 2 | DeleteButton | `fps.Name=="spdMain"` (L288) | 단일 그리드라 활성그리드 = gridRef 고정 |
| 3 | DeleteButton | `ActiveRow == null -> return` (L291) | handleDelete — `if(!selected) return` (선택행 없음) |
| 4 | SpdMain_CellClick | `Rows.Count<=0` (L538) | dblclick — `row` 없으면 return |
| 5 | SpdMain_CellClick | `IsLock==false && action==FlagI` 신규행만 (L541) | isItemPopupCell = isNewRow && ITEM_ID (신규행만 팝업/편집) |
| 6 | SpdMain_CellClick | `e.Column==ITEM_ID` (L656) | dblclick — binding==='ITEM_ID' 분기 |
| 7 | SpdMain_CellClick | `IsNullOrEmpty(divisionId)` (L661) | dblclick guard division (validations #4/#5) |
| 8 | SpdMain_CellClick | `IsNullOrEmpty(sScmSite)` (L668) | dblclick guard SCM_SITE_ID (validations #6) |
| 9 | SpdMain_ComboSelChange | `Rows.Count<=0` (L698) | 콤보변경 = SCM_SITE_ID cellEditEnded, row 없으면 no-op |
| 10 | SpdMain_KeyPress | `!ActiveCell.Locked` (L728) | ITEM_ID 인라인 편집 차단 = isCellEditable('ITEM_ID')=false (beginningEdit 취소) |
| 11 | SpdMain_KeyPress | `ActiveColumn==ITEM_ID` (L730) | 위와 동일 — ITEM_ID 키입력 차단(팝업 전용) |
| 12 | SpdMain_ClipboardPasted | `Rows.Count<=0` (L742) | pastedCell handler, row 없으면 no-op |
| 13 | SpdMain_ClipboardPasted | `IsLock==true` (L745) | 셀 편집가부 editLock 상시 적용(잠긴 셀 붙여넣기는 wijmo 가 차단) |

## events (n=7, design 00 §2)

| # | control.event | AS-IS handler(cs) | TO-BE 구현 |
|--:|---|---|---|
| 1 | btnItemId.Click | btnItemId_Click (L825) | OperationLTForm onItemSearch -> MaterialByDivisionModal(COM0013) open |
| 2 | cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged (L847) | OperationLTForm Division onChange -> plantSiteIds cascade 초기화 + Plant Site 옵션 재계산 |
| 3 | cboLTOperation.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | OperationLTForm LT Operation onChange -> plantSiteIds 초기화 + showInvFlag 재평가(isPreInspSelected) |
| 4 | spdMain.CellClick | SpdMain_CellClick (L536) | OperationLTGrid dblclick — ITEM_ID 팝업 오픈 + 셀 편집 진입(beginningEdit) |
| 5 | spdMain.ClipboardPasted | SpdMain_ClipboardPasted (L740) | OperationLTGrid pastedCell -> applyScmSiteChange 파생 |
| 6 | spdMain.ComboSelChange | SpdMain_ComboSelChange (L696) | OperationLTGrid cellEditEnded(SCM_SITE_ID) -> PLANT_SITE_ID 미러 + ITEM/NICK clear |
| 7 | spdMain.KeyPress | SpdMain_KeyPress (L726) | ITEM_ID 인라인 편집 차단(isCellEditable) |

## gridSignals (n=45, design 00 §3 / 03 §3) — 규칙 그룹 매핑

| gridSignals # | 카테고리 | AS-IS | TO-BE |
|---|---|---|---|
| 2,7,41,42 | visible | INV_FLAG 컬럼 Visible 토글(초기 false / PRE_INSP true) (L246/357/856/860) | applyInvFlagVisible(cols, showInvFlag) — isPreInspSelected 파생 |
| 1 | cellType | LT_DAY 숫자셀(1,0,100) (L242) | 컬럼 메타 FPNumber (admin CTRL 'FPNumber') |
| 3,9 | lock | SwitchLock / 조회직후 전체 lock(0,MaxCol) (L278,361) | 셀 white-list 상시(editLock) — 조회 결과는 white-list 외 전 컬럼 잠금 |
| 4,5 | lock | Edit 진입 부분 lock: DIVISION_ID~LT_OPERATION / SITE_ITEM_VALID_YN~audit (L280,281) | isCellEditable — 기존행 편집 = LT_DAY·INV_FLAG(PRE_INSP)만 (EXISTING_ROW_EDITABLE) |
| 12,13,14,15 | lock | 신규행 LockRange 4구간 (L403~406) | isCellEditable — 신규행 편집 = SCM_SITE_ID·ITEM_ID·LT_DAY·INV_FLAG만 (NEW_ROW_EDITABLE) |
| 10,6 | other | Insert / Delete (L388,296) | GridAction.addRow(insertDefaults) / handleDelete(신규행만) |
| 11,21 | value | 신규행 기본값 DIVISION_ID/VALID_YN='Y'/LT_OPERATION (L402,654) | insertDefaults(division, ltOperation) |
| 16,17,18,19,43,44,45,35 | cellType | 신규행 SCM_SITE_ID 셀콤보 dtPlantSiteByDivisionForIns (행 종속 좁힘) (L586~931) | beginningEdit -> buildCellPlantSiteCandidates(행 DIVISION_ID+LT_OPERATION) -> DataMap 스왑 |
| 20 | cellType | 신규행 DIVISION_ID 셀콤보 dtMyDivisionIns (L653) | DIVISION_ID 신규행 잠금(조회 division 고정) — 셀콤보 미노출(design 03 §6#3) |
| 22,23 | value | ITEM 팝업 선택 -> ITEM_ID/NICK_NAME (L689,690) | applyItemSelect(row, itemId, nickName) |
| 24,25,26,27 | value | DIVISION 변경 -> 하위 4셀 clear (L705~708) | (신규행 DIVISION_ID 잠금이라 in-grid division 변경 없음 — design 03 §6#3) |
| 28,29,30 | value | SCM_SITE_ID 변경 -> ITEM/NICK clear + PLANT_SITE_ID 미러 (L718~721) | applyScmSiteChange(row, scmSiteId) |
| 31~40 | value | 붙여넣기 파생(SCM_SITE_ID/PLANT_SITE_ID/NICK) (L763~817) | pastedCell -> applyScmSiteChange(붙여넣기 동일 파생) |
| 8 | dataSource | 조회 결과 바인딩 (L360) | useTabProcQuery data.o_rc1 -> DataGrid itemsSource |

카운트 대사: visible 4 + cellType 10 + lock 8 + value 20 + dataSource 1 + other 2 = 45. 전건 반영.

## 미이관/대체 정직 표기 (convert-core §4.3)

- 신규행 DIVISION_ID 셀콤보(#20) 및 division 변경 파생(#24~27): AS-IS 는 신규행 DIVISION_ID 를 LockRange 로 잠그면서도 dtMyDivisionIns 콤보를 세팅(상충). 실질 조회 division 고정으로 구현(design 03 §6#3) — in-grid division 변경 경로 없음.
- 셀콤보 SCM_SITE_ID PARAM2/9/10 미이관(admin 메타 공란)은 FE 셀콤보 빌더(buildCellPlantSiteCandidates)로 재현(design 03 §6#1).
- filterCalls #5(OSP_LT) AS-IS AND 누락 결함 -> 의도된 IN('P','E')로 구현(design 02 §7#2).
- TO-BE PKG_SCP0037 미배포 -> 조회/저장 런타임 미검증(convert-sp 후속). GET/SAVE 계약은 design 03 §4.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

> 원천: 통합테스트 사전점검 Common 축(asis_mapping_gate `UI_COMMON_ITEMS`). NSCM 전 화면 공통 UX 요구.
> 이 화면은 전 항목을 공용 인프라(shared DataGrid / GridAction / useDirtyRegistry / SubTitle excel / useProcMutation)로 위임 소비하며 자기 override·opt-out 이 없다(convert-gap-resolve iter-1, DB 접속 PASS 세션에서 소스 실측). 실제 화면 육안 동작은 사용자 축(브라우저 확인).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowVisibleUnderFilter, 필터 clear 금지) | OperationLTGrid.tsx:177 공용 DataGrid(keepRowVisibleUnderFilter, gridAction.ts) + OperationLT.tsx:120 GridAction.addRow(화면 자체 필터 clear 없음) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703) | OperationLTGrid.tsx:177 공용 DataGrid 가 registerDirtyCheck/Reset 자동 등록(DataGrid.tsx:564-567, useDirtyRegistry) + editTrackerRef 배선(:181) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset 후 재조회 유도 | useOperationLTStore.ts:97 fetchStaticColumns + OperationLT.tsx:85,101 mount+Search refetch(admin 동적 컬럼). Measure 없음(pivot X, design 03 §2) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 자동소멸 | OperationLT.tsx:138 setToast + :76,144 useProcMutation/saveWithValidation 표준 성공 toast(#132) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계) | OperationLT.tsx:167 SubTitle excelFileName='OperationLT'(공용 DataGrid dataMap→Name 승계, dataGridUtils) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중 입력 시 전건 조회 | useOperationLTStore.ts:73-85 setFilter joinOrAll(division/plantSite/ltOperation 콤마) + itemId passthrough → GET SP String_Split(design 03 §4-2). 런타임은 PKG 배포 후 실검증 |  | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회+필터 유지(rebindFilterColumns) | OperationLTGrid.tsx:179 gridFilterRef + :177 공용 DataGrid(rebindFilterColumns, gridAction.ts) |  | 구현 |
