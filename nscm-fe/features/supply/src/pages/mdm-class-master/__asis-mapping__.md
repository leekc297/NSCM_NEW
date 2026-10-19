# SCP0087 MDM Class Master — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `GSCM.SCP.Forms.UIL/Master/SCP0087_MDMClassMaster/SCP0087_MDMClassMaster.{cs,designer.cs}`
> 설계 근거: `.atlas/gscm-design/SCP0087/design/00_checklist.md ~ 03_grid-columns.md` + `07_human-doc-supplement.md`
> convert-core §2.1 #11 — validations/gridSignals/buttonGuards/entryPoints 100% 매핑.

## 1. entryPoints (toolbar override 5종 — design 00 §4g)

| # | AS-IS | action | cs 라인 | TO-BE |
|---|---|---|---|---|
| 1 | FindButton | Search | 143 | `handleSearch` → `setFilter()` → useTabProcQuery 자동발사 (MdmClassMaster.tsx) |
| 2 | SaveButton | Save | 181 | `handleSave` → R11 가드 + `saveWithValidation`/`useProcMutation` |
| 3 | DeleteButton | Delete | 177 | no-op — `hotkeyConfig.delete: false` (툴바 미노출, R14) |
| 4 | EditButton | Edit | 154 | **제거(사용자 지시)** — Edit 버튼/편집모드 없이 default 편집. 편집가능 컬럼은 admin 메타 INPUT_TP_CD='O' 3컬럼 + 공용 DataGrid isEditableCell 이 한정(AS-IS Edit→SwitchLock 대체) |
| 5 | InsertButton | Insert | 149 | 비활성 — `hotkeyConfig.insert: false` (툴바 미노출, R13) |

## 2. buttonGuards + 추가 가드 (design 00 §4d)

| AS-IS 가드 | cs 라인 | TO-BE |
|---|---|---|
| EditButton `fps==null` return | 156 | `handleEdit`: `if (!gridRef.current) return` (R3) |
| EditButton `RowCount==0` return | 158 | `handleEdit`: `if (rows.length===0) return` (R4) |
| SaveButton `fps==null` return | 183 | `handleSave`: grid 없으면 finishEditing/collectionView 접근 무해 (R9) |
| SaveData_Main `RowCount==0` return | 260 | `handleSave`: dirty 0건이면 NO_CHANGE 토스트 후 종료 (R10) |
| SaveData_Main `IsLock==false` 일 때만 저장 | 270 | **제거(사용자 지시)** — 편집모드 없이 default 편집이라 R11 view-상태 가드 불요. 저장대상 0건은 `handleSave` dirty 0 가드(NO_CHANGE)로 방어, false-success 는 useProcMutation 표준 판정 |
| InsertButton `return` (삽입 비활성) | 151 | `hotkeyConfig.insert: false` (R13) |
| DeleteButton 빈 본문 (삭제 no-op) | 177-179 | `hotkeyConfig.delete: false` (R14) |

## 3. gridSignals (7건 — design 00 §3 / 03 §3)

| # | AS-IS | cs 라인 | TO-BE |
|---|---|---|---|
| 1 | SmartColMerge (2단 헤더 병합) | 130 | DataGrid `allowMerging=ColumnHeaders`(MdmClassMasterGrid) — 같은 값 셀 병합 재현. `sClsLblNm`(Level 1~4) columnMapping TWO_DEPTH 로 Level 그룹 가로 병합 + 단일컬럼 세로 병합(rowspan 2). design 03 §2 |
| 2 | SwitchLock (편집모드 토글) | 160 | **제거(사용자 지시)** — 편집모드 없이 default 편집(AS-IS IsLock 토글 미재현) |
| 3 | LockRange 전체셀 잠금 | 169 | admin 메타 3컬럼('O')만 편집 — 나머지 20컬럼 'S'(공용 isEditableCell 이 상시 읽기전용) |
| 4 | LockRange ITEM_TYPE~PROCESS_DETAIL unlock | 172 | admin 메타 INPUT_TP_CD='O' 3컬럼(05_register.sql 정비) — default 편집(편집모드 게이트 없음) |
| 5 | Query(ds.Tables[0]) 바인딩 | 232 | useTabProcQuery `o_rc1` → DataGrid itemsSource |
| 6 | LockColumn 전열 잠금(조회직후) | 234 | 조회직후 `isEditing=false` → MdmClassMasterGrid beginningEdit `e.cancel=true` (R1) |
| 7 | GetValue2(i, CLASS_ID) 저장 셀읽기 | 298 | 저장 payload = dirty 행(CLASS_ID 포함) — `validateSaveRows` 키 존재 방어 |

## 4. validations (5건 — design 00 §4f, Top11 #11)

| # | AS-IS msgId | 조건 | cs 라인 | TO-BE (SCM_ADM_MSG_M 역조회 코드 — AS-IS 번호 직이식 금지, Hook #114) |
|---|---|---|---|---|
| 1 | GMessageBoxForException | 조회 예외 | 246 | useTabProcQuery 전역 에러 처리(공통 인터셉터) |
| 2 | MSG00004(저장건수, AS-IS) | result_code=='S' | 338 | 저장 성공 → `useProcMutation` 기본 onSuccess = **MSG00002**("Saved successfully.") + invalidate 재조회 |
| 3 | MSG00003(서버에러, AS-IS) | err_code!='S' | 347 | 저장 실패 → `useProcMutation` 기본 onError = **MSG00003**("Failed to save.") + err_message |
| 4 | GMessageBoxForException | iCount>0 저장 예외 | 358 | onError 경로(공통) |
| 5 | GMessageBoxForException | 저장 마무리 예외 | 378 | onError 경로(공통) |

주의: AS-IS MSG00004=저장성공은 TO-BE 에서 **MSG00002**(TO-BE MSG00004="No changes to save."로 의미 상이) — 역조회 재매핑. 저장대상 0건 가드에는 TO-BE MSG00004("No changes to save.")를 사용(`MSG.NO_CHANGE`).

## 5. 조회조건 / 콤보 (design 02)

| AS-IS | cs 라인 | TO-BE |
|---|---|---|
| txtClassId → p_class_id (LIKE) | 203 | searchCondition.classId → filters.classId |
| txtClassName → p_class_name (LIKE) | 204 | searchCondition.className → filters.className |
| cboUseFlag DataBind(YesOrNo, isAddALL) 기본 'Y' | 107,113 | `useTabComboQueries(['YesOrNo'])` + FE addAll('ALL'), default 'Y' |
| p_use_flag = ALL ? '' : value | 205 | `useFlag==='ALL' ? '' : useFlag` (store setFilter) |
| Form_Load 자동조회 없음 | 92-99 | mount `clearFilters()` 게이트 + `enabled=!!filters` (진입 자동조회 금지) |

## 6. 저장 계약 (design 03 §4.4)

- SAVE = UPDATE-only: ITEM_TYPE / PROCESS_GROUP / PROCESS_DETAIL 3컬럼만 반영. USE_FLAG/CLASS_NAME 편집불가·저장무반영(등가).
- USER_ID = @LoginUser 세션 주입(convert-core §3.5) — FE payload 미포함.
- 저장대상 = CRUD_TYPE 마킹 행(EditTracker). Insert/Delete 없어 실질 M 만.
- GET backfill side-effect(SCM_MST_ITEM_CLASS_SN→_M, 분류3칼럼 NULL) = convert-sp 소관(PKG_SCP0087 미배포).

## 7. 이식 제외 (design 03 §1 주의 / 07 §2)

- **BASIC_NICKNAME_PACK**: C# DefColumns 정의뿐, DB 메타/GET 반환에 없음 → 미이식.
- **VERSION**: 사람설계서 데이터항목 시트에만(유령 컬럼), DB 메타 23행·GET 23컬럼·Layout 헤더에 없음 → 미이식.
- 표시명 오기(Version↔Process Detail, 07 §2 G6) 따르지 않음 — PROCESS_DETAIL='Process Detail'(DB 메타 정본).

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — `asis_mapping_gate.py --check` 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | 해당없음 — 이 화면은 Insert 비노출 | AS-IS `InsertButton{ return; }` 삽입 완전 비활성(cs:149-151) → `MdmClassMaster.tsx:116` hotkeyConfig `insert:false`(신규행 추가 경로 자체 없음). 편집 = 기존행 3컬럼(ITEM_TYPE/PROCESS_GROUP/PROCESS_DETAIL)만. 신규행 Insert 요구 부재 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '작업중인 데이터가 있습니다. 조회 하시겠습니까?' confirm | `packages/shared/src/components/organisms/search-area/SearchArea.tsx:112,115`(`confirmIfDirtyKey(tabDirtyKey(tabId),'search')`) — `MdmClassMasterForm.tsx:43` `<SearchArea onSearch>` 로 배선 + `MdmClassMasterGrid.tsx:71` DataGrid `editTrackerRef`(EditTracker 가 편집 3컬럼 변경을 dirty 자동등록) | 공용 `SearchArea`(tabId 기반 dirty 레지스트리 확인) + `DataGrid`(EditTracker) 경유라 화면 코드 별도 배선 불필요 — 자매 outsourcing-capacity/project-route 와 동일 공통 구조 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx`(`handleColumnSettingsSave`) | 컬럼 설정 저장 시 rows Reset/재조회 유도 부재는 전 화면 공유 `packages/shared` 공통 동작 — Hard Boundary(convert-core §2.2)상 이 화면 gap-resolve 범위 밖(공통 컴포넌트 이슈로 별도 보고, 자매 동일 판정). 이 화면은 pivot 아님·Column/Measure 설정 모달 미노출(customButtons=Edit 단일, MdmClassMaster.tsx:123-125) | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준) | `MdmClassMaster.tsx:108`(`saveWithValidation(...,mutate)` → `useProcMutation` 표준 onSuccess=성공 Toast MSG00002 / onError=MSG00003) + `:103` 변경없음 `setToast({type:'error', message:MSG00004})` | 저장 성공·변경없음 모두 Toast. 저장 전 CLASS_ID 키 방어검증 실패(useMdmClassMasterValidation.ts:26 setAlert)는 CRUD 완료가 아니라 사전 차단이라 Alert 사용이 맞다(AS-IS MessageBox 동일 의미) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) | `MdmClassMaster.tsx:141` `SubTitle excelFileName='MdmClassMaster'`(공용 `GridAction.excelDownload` 경유) | 이 화면 그리드 셀 콤보 **0건**(`SCM_MST_SHEET_COLUMNS` CELL_COMBO_DATA_TYPE 23행 전건 공란·CELL_CONTROL_OBJECT_TYPE_CODE FPComboBox 0, ora.py 실측) → Code/Name 승계 이슈 자체 미해당. Excel export 경로는 공통 SubTitle 그대로 사용 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | 해당없음 — 조회조건 단일 LIKE 부분일치 | AS-IS GET SP(design 02 §2.4 asis.py 실측) = `CLASS_ID LIKE N'%'+@p_class_id+'%'` / `CLASS_NAME LIKE N'%'+@p_class_name+'%'` 단일 부분일치 — 콤마 분리(F_LIST_PARAM/STRING_SPLIT) 없음. FE(MdmClassMasterForm.tsx:56-82)도 원문 단일 전달. TO-BE GET SP 도 동일 계약(convert-sp). 콤마 다중검색 요구 미해당 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx`(`itemsSourceChanged` — 재조회로 데이터 재적재돼도 컬럼 필터 보존·재적용) | 공용 `DataGrid`(`MdmClassMasterGrid.tsx:68`, `gridFilterRef` 전달)가 `itemsSource` 참조 변경(재조회) 시 filterDefinition 보존·재적용 — 이 화면 그리드도 공용 래퍼 경유(자매 동일) | 구현 |
