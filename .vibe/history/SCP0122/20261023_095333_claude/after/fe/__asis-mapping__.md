# SCP0122 PlanActivityMgmt — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs`
TO-BE: `nscm-fe/features/supply/src/pages/plan-activity-mgmt/`
설계 정본: `.atlas/gscm-design/SCP0122/design/{00_checklist,01_layout,02_search-combo,03_grid-columns}.md`

## 조회조건 콤보 (design 02)

| AS-IS | 라인 | TO-BE | 비고 |
|---|---|---|---|
| `BLUtils.GetDivision(false,"")` → `Division_SCP` | cs:40,126 | `PlanActivityMgmtForm` `COMBO.DIVISION` `useTabComboQueries({comboId:'Division_SCP',mnuId})` | EE 포함(WithoutEE 클라필터 금지). MyDivision 재사용 금지 |
| `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SCP_ALL` | cs:53,129,174 | `COMBO.PLAN_GROUP` 全件 + 클라 `DIVISION_ID` 필터 + `sortBy='label'` | 필터형 cascade, NAME 정렬(AS-IS 2025-10-20) |
| `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")` | cs:47,127 | `COMBO.PROCESS` `{comboId:'LookupCommon',lookupType:'OPMZ_PRS_CD'}` | 정적, cascade 없음 |
| `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivision`+`ClearDataSource` | cs:544,169-175,548 | `setSearchParams({divisionId, planGroupId:''})` → PlanGroup 재필터 + `filters` 비움(그리드 clear) | design 01 L3 |
| `CboPlanGroup_SelectedIndexChanged`→`ClearDataSource` | cs:551-554 | `setSearchParams({planGroupId})` → `filters` 비움 | design 01 L4 |
| `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0`, `usrLayoutControl2.Enabled=false`) | cs:123-124 | `noAuthDivision` → 콤보 disable + Search 무동작(`handleSearch` 게이트) + `MSG00667` alert | division 데이터 권한 게이트(L2). SearchArea(shared) 무수정 위해 조회 함수에서 차단 |
| `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후보 0 | cs:169-172 | Division 무선택 시 `planGroupOptions=[]`(전체노출 아님) | design 02 §4 초기 후보 0 등가 |

## 그리드 (design 03)

| AS-IS | 라인 | TO-BE | 비고 |
|---|---|---|---|
| `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_COLUMNS 구동) | cs:212 | `staticColumns`(admin fetch) → `DataGrid` | 컬럼 하드코딩 없음(hook #130) |
| `Query(ds)` GET SP 바인딩 | cs:341 | `useTabProcQuery` `o_rc1` | design 03 §4.2 |
| 셀콤보 `SetComBoParam("ActivityCode",dtActivityCdAll)` | cs:45 | 컬럼메타 `CELL_COMBO_DATA_TYPE='ActivityCode'` + `DataGrid` 자동 콤보 | SQL_ID 'ActivityCode' 05_register.sql 등록 |
| Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성 | cs:238-243 | `PlanActivityMgmtGrid` `cellEditEnded`→`applyActivitySync` | design 03 §3-R3, 콤보행 7컬럼 복사 |
| `filterCalls#2` `dtActivityCdAll CODE='<actv_cd>'` | cs:233 | `activityByCode` Map lookup | Auto-Sync 원천행 추출 |
| `LockColumn`/`LockRange` 편집범위 = OPMZ_ACTV_SEQ/OPMZ_ACTV_NAME | cs:277-279,381-383 | 컬럼메타 `INPUT_TP_CD='M'`(05_register.sql) → DataGrid 편집 게이트 | 상수이식 금지(hook #130), design 03 §3-R4/R7 |
| `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | cs:342 | 편집 = 메타 2컬럼만(모드 없음) | design 03 §3-R5, Edit 미이식 |
| `Insert_Row` 기본값 5컬럼 | cs:360-385 | `handleInsert` `GridAction.addRow` 검색조건 복사원본 | convert-core §2.4, design 03 §3-R6 |
| `DeleteButton`→`siMain.Delete` | cs:263-268 | `handleDelete` `GridAction.removeRow` | 활성그리드 라우팅, design 03 §3-R8 |
| `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세션) | cs:387-510 | `handleSave`→`buildSavePayload(rows, sessionUserId)`+`apiClient.post` | I/M/D, M/D WHERE=preActvCd, 물리삭제, design 03 §4.4. payload 키=PROC_M COL_NM camelCase(activeFlag/prsCd/planGrId/actvCd/actvSeq/preActvCd/userId). userId=`useSessionStore().session.userId`(call-proc 세션 자동주입 없음, 자매 SCP0006) |
| 필수검증(actv_cd/actv_seq 공백 MSG00001) | cs | `useSaveWithValidation`(INPUT_TP_CD=M) | 공통 훅, 커스텀만 두지 않음 |
| 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443 | cs:453 | `hasDuplicateNewRow` → `MSG00428` | 조회결과 없으면 생략(2025-07-02) |

## 미이식 (dead / 전 화면 공통 결정)

| AS-IS | 라인 | 사유 |
|---|---|---|
| `EditButton`(SwitchLock 편집모드 토글) | cs:271-281 | `asis_to_tobe §11` 전 화면 공통 미이식. hotkeyConfig edit 키 미배치(공용 기본핸들러 없어 부작용 없음) |
| gridSignal #21 `SetValue OPMZ_PLAN_GR_ID` | cs:576 | 주석처리된 `SpdMain_ClipboardPasted` 내부 = 미배선 dead code(design 03 §3-R9). 재현 대상 아님 |
| `prsCd`(GET) = `CString.GetCheckedListValue(dtPlanGroup, cboProcess.SelectedValue)` | cs:310 | AS-IS 오타 인자(dtPlanGroup 감쌈). TO-BE 는 선택 Process code 직접 전달로 재현(design 02 §2-4). GET filters 키=PROC_M COL_NM camelCase(divisionId/planGroupId/prsCd) |

## MSG 코드 (hook #114 — AS-IS 번호 그대로 쓰지 않음)

| AS-IS | 의미 | TO-BE | 사유 |
|---|---|---|---|
| MSG00097 | 권한 Division 없음 | **MSG00667** | TO-BE MSG00097="Please select Division."(의미 다름) → KO "권한을 가진 Division이 없습니다" 문구 역조회 |
| MSG00443 | 신규행 중복 | **MSG00428** | AS-IS MSG00443 TO-BE 미등록 → "신규 입력 데이터 중 중복" 등가 |
| MSG00004 | 저장건수 | **MSG00002**(성공) / **MSG00004**(변경없음) | TO-BE MSG00004="No changes to save." 라 성공은 MSG00002 사용 |
| MSG00001 | 필수 공백 | (공통 `useSaveWithValidation` 자동) | 메타 INPUT_TP_CD=M 기반 표준 메시지 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SCP0122 는 편집 단일그리드(편집 2컬럼 OPMZ_ACTV_SEQ/NAME, 셀콤보 ActivityCode, Insert/Delete/Save). 공용 DataGrid·gridAction·useMessageStore 위임 축 포함.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | - | 신규행 Insert 는 handleInsert(GridAction.addRow, searchParams 복사원본)로 재현. 필터-유지 정책(keepRowVisibleUnderFilter)은 공용 DataGrid/프레임워크 소관이며 현재 공용 DataGrid 미배선=전역 프레임워크 갭(이 화면 feature 폴더 밖). 런타임 육안 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | - | 편집 중 재조회 confirm 은 공용 편집가드 패턴 소관(화면 고유 배선 없음). EditTracker dirty 상태는 존재하나 재조회 confirm 은 프레임워크 축 — 화면 폴더 밖 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(SCP0122 Measure 0건, GridColumnSet 미배선). 사용자 컬럼 편집 UI 부재 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | PlanActivityMgmt.tsx:96,102,122 | 저장 성공/변경없음 시 `useMessageStore.setToast`(LGES 표준 하단중앙 자동소멸 Toast, MSG00002/MSG00004) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | PlanActivityMgmt.tsx:169 / packages/foundation/src/utils/gridAction.ts | 공용 DataGrid `excelFileName='PlanActivityMgmt'` export + gridAction dataMap(CODE→NAME 승계) — 셀콤보 OPMZ_ACTV_NAME(ActivityCode) Name 출력 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | - | 조회조건 3콤보(Division/PlanGroup/Process)만 — 자유 key-in 콤마 다중검색 텍스트 필드 없음. 콤마 다중 대상 필드 부재 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | packages/shared/src/components/organisms/data-grid/DataGrid.tsx:55 | 공용 DataGrid 가 `rebindFilterColumns` 사용 — 재조회 시 컬럼 필터 재적용 | 구현 |
