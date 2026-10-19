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
| cboDivision = GetDivisionWithoutEE + '81' 필터, CODE Asc, 다중체크 | `Division_SCP` 콤보 + `buildDivisionOptions`(ATTRIBUTE3<>'EE' && CODE⊇'81', CODE asc) 다중 CustomDropdown | cs:40/166-197 / combos.ts |
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
