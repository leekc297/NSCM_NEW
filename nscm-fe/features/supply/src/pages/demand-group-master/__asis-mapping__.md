# SCP0110 GroupModelMapping — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0110_GroupModelMapping/SCP0110_GroupModelMapping.cs`(+`.Designer.cs`).
TO-BE: `nscm-fe/features/supply/src/pages/demand-group-master/`. domain=SCP(supply). 전환 판정=신규(NEW).

## 1. 레이아웃 (01_layout.md §1)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| Form BaseForm + usrConditionPanel1 | `DemandGroupMaster.tsx` Page + `MainTitle`/`SubTitle`/`DemandGroupMasterForm` | Designer:210 |
| usrLayoutControl1 (1행 5필드) | `SearchArea` conditions 5필드(Division/OperationGroup/GroupName/Project+btn/Model+btn) | Designer:220 / DemandGroupMasterForm.tsx |
| splitContainer1 (Vertical splitter, 좌 566 / 우 622) | `PanelGroup orientation='horizontal'` 좌 GroupMaster / 우 ModelList | Designer:85-101 |
| spdMain (Group Name 시트) | `GroupMasterGrid` (SHEETS.GROUP_NAME='groupName') | Designer:94/243 |
| spdSub (Model List 시트) | `ModelListGrid` (SHEETS.MODEL_LIST='modelList') | Designer:98/247 |

## 2. 조회조건 콤보 (02_search-combo.md)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| cboDivision = GetDivisionWithoutEE + '81' 필터, CODE Asc, 다중체크 | `Division_SCP` 콤보 + `buildDivisionOptions`(ATTRIBUTE3<>'EE' && CODE⊇'81', CODE asc) **단일** CustomDropdown | cs:40/166-197 / combos.ts |
| cboOperationGroup = LookupCommon(OPERATION_GROUP) + RemoveAt(2) | `LookupCommon@lookupType='OPERATION_GROUP'` + `buildOperationGroupOptions`(CODE<>'E' 코드기준) 단일 | cs:201-204 / combos.ts |
| txtGroupName → p_group_name | InputField → searchParams.groupName → filters.groupName | cs:384 |
| btnProject → SCM0002_ProjectbyDivisionPopup(division 선필터) | `ProjectByDivisionModal` preSearchParams={divisionId:firstDivision}, 반환 빈값 미덮어쓰기 | cs:973-988 / DemandGroupMasterForm.tsx |
| btnItemId → SCM0002_ItembyDivisionPopup(division+project) | `ItemByDivisionModal` preSearchParams={divisionId,projectCode} | cs:992-1010 |
| 라벨 리터럴 | t('LBL00641'/'LBL00027'/'LBL00037'/'LBL00617'/'LBL00669') | design 02 §4.5 |
| SetDivisionAuthCheck(0건→조회영역 잠금) | `isAuthDenied`(divisionOptions.length===0) → 필드 disabled | cs:194-195 / DemandGroupMasterForm.tsx |
| cascade 없음 (SelectedIndexChanged 주석) | useCascadeFields 미사용, 독립 콤보 | cs:968-971 |

## 3. 그리드 컬럼·셀콤보·편집 (03_grid-columns.md)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| siMain 컬럼 (DB 메타 구동, 6컬럼) | `staticColumns[groupName]` fetch(SHEET_NAME='Group Name') | cs:274 / store |
| siSub 컬럼 (DB 메타 구동, 5컬럼) | `staticColumns[modelList]` fetch(SHEET_NAME='Model List') | cs:290 / store |
| SetComBoParam(LookupCommon, dtOperationGroup) siMain OPERATION_GROUP | `buildGridColumns` dataMap 주입(LookupCommon {P,A}) | cs:273 / columns.ts |
| ONLY_STOCK YesOrNo 셀콤보 | dataMap 주입(YesOrNo {Y,N}), 편집가능(INPUT_TP_CD='O' 재선언) | 메타 / columns.ts |
| SetComBoParam(GroupMaster→dtGruop) siSub GROUP_ID, DBUtils.Filter(div+opGrp) | `GroupMaster_SCP_ALL` 조회 + `filterGroupMasterByContext`(div+opGrp) dataMap, 편집가능 | cs:286-289 / combos.ts |
| LockColumn(0..max,true) 조회직후 전잠금 | 메타 전열 INPUT_TP_CD='S' + §11(편집모드 미이식) — 편집컬럼만 FE 에서 'O' | cs:413 등 / columns.ts |
| LockColumn DIVISION_ID..GROUP_ID (siMain 키 잠금) | 편집 화이트리스트 MAIN_EDITABLE_COLUMNS=[GROUP_NAME,ONLY_STOCK]만 'O' | cs:338 |
| LockColumn DIVISION_ID..ITEM_ID (siSub 키 잠금) | 편집 화이트리스트 SUB_EDITABLE_COLUMNS=[GROUP_ID]만 'O' | cs:354 |
| Insert(siMain, 편집모드) 기본값 div/opGroup, GROUP_ID='' | `handleInsert`(GridAction.addRow, DIVISION_ID/OPERATION_GROUP=searchParams, GROUP_ID='') — division·opGroup 둘 다 없으면 무시(iter-2 C-02) | cs:945-962 |
| Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | `handleDelete`(GridAction.removeRow) — active=main 게이트 | cs:311-325 |
| SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시 | `GroupMasterGrid.handleDblClick` → onRowDblClick(groupId), data.length===0 return | cs:1026-1037 |
| SmartColMerge(spdSub) 세로 병합 | `ModelListGrid` allowMerging=Cells + MERGE_COLUMNS(DIVISION_ID/PROJECT_CODE/PROJECT_NAME/ITEM_ID) | cs:1082 |
| 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | `validateGroupMaster`(dirty 간 + GroupMaster_SCP_ALL 대비) | cs:663/680/692 |
| 저장검증 복수 Project 동일그룹 금지(수정간/기존대비) | `validateModelList`(GROUP_ID→PROJECT_CODE 단일 매핑 검사) | cs:837/853 |
| 필수 OPERATION_GROUP*·GROUP_NAME* | `useSaveWithValidation`(라벨 '*') — 편집('O') 재선언 컬럼셋(`groupValidationColumns`) 전달, GROUP_NAME* 빈값 차단(iter-2 A-01). OPERATION_GROUP* 는 lock 이라 검증 대상 제외(defaulted) | cs:635 |
| SAVE_GROUP_MASTER(action I/M/D, valid_yn, only_stock) | `buildGroupMasterPayload` + `callSaveGroupMaster`('^' bulk, apiClient.post) | cs:4-3 / save.ts |
| SAVE_MODEL_LIST(action=M 만, GROUP_ID 재매핑) | `buildModelListPayload`(MODIFY 만) + `callSaveModelList` | cs:4-3 / save.ts |
| 저장 후 FindData_Main_Sub 재조회 | refetchGroup()+refetchModel() (filters 불변 예외 허용) | DemandGroupMaster.tsx |
| user_id = @LoginUser | sesUserId BE 자동 주입(PROC_M) — FE 하드코딩 없음 | save.ts |

주의(iter-2 B-03 메타 정정): siMain OPERATION_GROUP 셀콤보 메타 `ATTRIBUTE1`(lookupType) 공란 →
`'OPERATION_GROUP'` 정정, siSub GROUP_ID 셀콤보 메타 `CELL_COMBO_DATA_TYPE='GroupMaster'`(dangling) →
`'GroupMaster_SCP_ALL'` 정정(ora.py exec 적용). INPUT_TP_CD='S' 는 §11 정책상 미변경 — 런타임은
FE dataMap 주입 경로 유지(auto-combo 는 lock 이라 미렌더).

## 4. 미이식/제외 (근거 명시 — react-gap-audit 오탐 방지)

| AS-IS | 처리 | 근거 |
|---|---|---|
| EditButton()/SwitchLock() 편집모드 토글 (L3~L7, MSG00129/00130) | **제외** — §11 EditButton 토글 미이식(전 화면 공통, 2026-09-23). 편집=컬럼조건만 | asis_to_tobe §11 |
| LineByOperation/LineByOperation2 셀콤보 | **미배선** — AS-IS dtLineByOperationOfSpdAll 로드되나 SetComBoParam 안 됨(dead 잔재) | cs:43/152, design 03 §6 #6 |
| Dsdm_Changed / spdMainDsdm_Changed 파생 | 없음 — AS-IS 빈 본문 | cs:1014/1094 |
| cboDivision 다중 체크(콤마 결합값 전달) | **의도적 단일선택으로 조정(2026-09-29)** — `PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER`가 `WHERE DIVISION_ID = V_DIVISION_ID` 완전일치만 지원(자매 `P_SCP0110_GET_MODEL_LIST`와 달리 `STRING_SPLIT` IN절 없음, DB 실측: 콤마 다중값 입력 시 0건). AS-IS UI는 체크리스트형 다중선택이었으나 실제로 2개 이상 선택하면 SP 결과가 항상 0건이 되는 잠재 결함이 있었음. TO-BE는 SP 수정 대신 FE를 단일선택으로 좁혀 회귀를 차단(공용 `DivisionField`의 "자동 선택 금지" 정책도 함께 준수 — 빈 값이면 사용자가 직접 골라야 함, 자동 기본값 부여 없음) | ora.py 직접 호출 실측(2026-09-29), `DemandGroupMasterForm.tsx` |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목, gap-resolve iter-2 신설)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — `asis_mapping_gate.py --check` 가 부재 행을 FAIL 처리한다(2026-09-28 iter-2 실측 FAIL 7건 → 이번 회차 조사·기입).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | `packages/foundation/src/utils/gridAction.ts:836`(`addRowSet` 내부 `keepRowVisibleUnderFilter` 호출) — `handleInsert`(`DemandGroupMaster.tsx:112-121`)가 `GridAction.addRow`→`addRowSet` 경로를 그대로 씀 | | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '작업중인 데이터가 있습니다. 조회 하시겠습니까?' confirm (MSG00704 — 1st 행4) | 공용 위임 — `packages/shared/src/components/organisms/search-area/SearchArea.tsx:115`/`packages/shared/src/components/organisms/sub-title/SubTitle.tsx:198`의 confirmIfDirtyKey(dirtyKey, 'search')(`packages/shared/src/stores/useDirtyRegistry.ts:110` MSG00704). `DemandGroupMasterForm.tsx:69`가 handleSearch(`DemandGroupMaster.tsx:103`)를 SearchArea onSearch로 전달해 자동 게이트 통과. `GroupMasterGrid.tsx:85`/`ModelListGrid.tsx:86`이 editTrackerRef 를 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx`에 넘기고 excludeFromDirtyCheck 를 지정하지 않아 그 파일 564행 registerDirtyCheck 로 dirty 자동 등록 | 정정(2026-09-29 gap-resolve iter-4) — 이전 기입("리포 67화면 중 사용 0건")은 memory `asis-mapping-gate-contract-and-ui-common-axes`(2026-09-27)가 이미 반증한 오판정이었다. MSG00703은 화면 닫기 전용, 재조회 confirm은 MSG00704이며 배선은 화면이 아니라 공용 컴포넌트에 있어 화면 코드 grep 0건이 정상이다 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `useDemandGroupMasterStore.ts:107-122`(`fetchStaticColumns`, mount+Search 시 재호출) | 컬럼 메타 재조회 자체는 구현돼 있으나 "적용 시 기존 조회 데이터 Reset" 동작이 화면 코드에 명시적으로 없다 — 공통 admin 컬럼 설정 UI 표준 흐름(재조회 트리거)에 위임되는지 직접 확인 못함(자매 bod 동일 판정) | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `DemandGroupMaster.tsx:148`(무변경 `setToast`)·`DemandGroupMaster.tsx:183`(저장성공 `setToast`) | | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `utils/demand-group-master.columns.ts`(`buildGridColumns` dataMap 주입 — OPERATION_GROUP/ONLY_STOCK/GROUP_ID) | 공통 Excel 다운로드(Wijmo 표준 xlsx export)가 컬럼 `dataMap`(콤보 CODE→NAME)을 표준으로 승계하는 구조이나, 이 화면의 Excel 다운로드 버튼(`SubTitle excelFileName='Demand Group Master'`)이 실제로 Name 출력을 내는지 직접 실행 검증은 못함(공통 유틸 신뢰, 화면별 실측 아님 — 자매 bod 동일 판정) | 제외 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | `PKG_SCP0110.P_SCP0110_GET_MODEL_LIST`(ALL_SOURCE 실측 LINE 340-347, P_PROJECT_ID/P_ITEM_ID 를 STRING_SPLIT(P_..., ',') 로 분해해 IN 절 매칭) — `DemandGroupMasterForm.tsx`(`searchParams.projectId`/`searchParams.itemId` InputField) | P_GROUP_NAME(Group Name Key-in 필드, ALL_SOURCE LINE 356-357)는 STRING_SPLIT 없이 LIKE '%..%' 단일 부분일치 — 이름 검색이라 콤마 다중검색 대상 자체가 아님(ID 키인이 아니라 텍스트 검색) | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `packages/shared/src/components/organisms/data-grid`(`FlexGridFilter` ref) — `mainGridFilterRef`/`subGridFilterRef`(`DemandGroupMaster.tsx:41-42`)가 `SubTitle`(:224)에 표준 배선 | 공통 컴포넌트가 재조회 후 필터 상태를 실제로 유지하는지(rebindFilterColumns 적용 여부)는 화면 코드만으로 확정 불가(공통 컴포넌트 내부 동작, 자매 bod 동일 판정) | 제외 |
