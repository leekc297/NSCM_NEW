# SCP0122 PlanActivityMgmt — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs`
TO-BE: `nscm-fe/features/supply/src/pages/plan-activity-mgmt/`
설계 정본: `.atlas/gscm-design/SCP0122/design/{00_checklist,01_layout,02_search-combo,03_grid-columns}.md`

## 조회조건 콤보 (design 02)

| AS-IS | 라인 | TO-BE | 비고 |
|---|---|---|---|
| `BLUtils.GetDivision(false,"")` → `Division_SCP` | cs:40,126 | `PlanActivityMgmtForm` `COMBO.DIVISION` `useTabComboQueries({comboId:'Division_SCP',mnuId})` | EE 포함(WithoutEE 클라필터 금지). MyDivision 재사용 금지 |
| `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SCP_ALL` | cs:53,129,174 | `COMBO.PLAN_GROUP` 全件 + 클라 `DIVISION_ID` 필터 + `sortByNameCi`(components/PlanActivityMgmtForm.tsx:53-63 · utils/plan-activity-mgmt.util.ts:89) | 필터형 cascade. NAME 정렬 = AS-IS `dbo.SCP0121_GET_SEARCH_INFO.sql:200` `ORDER BY OPMZ_PLAN_GR_NAME`(2025-10-20, CI 콜레이션) — 2026-10-22 보완: 공용 `sortBy='label'`(숫자·영문·한글 그룹+numeric 비교)은 AS-IS 순서와 달라 대문자 비교 정렬로 교체(콤보 SQL 은 공유라 무수정) |
| `setListBox`(DropDownList DataSource 바인딩 → 첫 행 자동선택) Division/PlanGroup/Process | cs:126-127,174 · `CControl.cs:344-375` | components/PlanActivityMgmtForm.tsx:72-87 (빈값·후보 밖이면 첫 후보 선택, `isPicked` utils/plan-activity-mgmt.util.ts:20) | 2026-10-22 보완(E9 초기값) — 종전 빈값이라 조회 시 빈 파라미터 0건·Insert 기본값 공란. 형제 SCP0123 PlanControlForm 동일 패턴. F6 복원값이 후보 안이면 유지 |
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
| `Save_Data` 결과 판정 `Tables[0].Rows[0][0]=="S"` → MSG00004({0}=건수) + 재조회 / 아니면 `"Error!\nMsg : "+오류문` | cs:503-519 | PlanActivityMgmt.tsx:121-138 (`parseSaveResult` utils/plan-activity-mgmt.util.ts:74 → 실패 alert / 성공 MSG00672 건수 toast) | 2026-10-22 보완 — 사내 현행 SAVE SP(ALL_SOURCE 10-09) 는 실패도 EXCEPTION 에서 ROLLBACK 후 `o_result_cursor` RESULT_CODE='F'·RESULT_CNT=오류문으로 HTTP 200 반환(BE GeneralServiceImpl.execBtn 커서 그대로 전달) → 종전 envelope code 만 보던 FE 는 실패를 '저장 성공' 으로 표시했음 |
| `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세션) | cs:387-510 | `handleSave`→`buildSavePayload(rows, sessionUserId)`+`apiClient.post` | I/M/D, M/D WHERE=preActvCd, 물리삭제, design 03 §4.4. payload 키=PROC_M COL_NM camelCase(activeFlag/prsCd/planGrId/actvCd/actvSeq/preActvCd/userId). userId=`useSessionStore().session.userId`(call-proc 세션 자동주입 없음, 자매 SCP0006) |
| `Save_Data` 실데이터 변경 없는 행 skip (`action != D && actv_cd == pre_actv_cd && actv_seq == pre_actv_seq` → continue) | cs:428-430 | `handleSave` dirtyRows 필터 `!isUnchangedRow(row)` (PlanActivityMgmt.tsx:137 / utils/plan-activity-mgmt.util.ts `isUnchangedRow`) | 2026-10-22 보완 — 커밋본 누락 1줄 이식. 편집 후 원값 복귀 M 행·코드/순번 공란 I 행은 AS-IS 와 같이 MSG00001 이전에 건너뜀 |
| 필수검증(actv_cd/actv_seq 공백 MSG00001) | cs | `useSaveWithValidation`(INPUT_TP_CD=M) | 공통 훅, 커스텀만 두지 않음 |
| 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443 | cs:338,442-460 | PlanActivityMgmt.tsx:168-181 `hasDuplicateNewRow`(utils/plan-activity-mgmt.util.ts:52) → `MSG00428` | 조회결과 없으면 생략(2025-07-02). 2026-10-22 보완: 비교 대상 = 조회 스냅샷 `dtPlanActivityAll` 등가(CRUD_TYPE≠I 전 행, 키 = `PRE_OPMZ_ACTV_CD` 조회 당시 코드) — 종전은 CRUD_TYPE 없는 행·현재 코드만 봐서 수정(M)/삭제(D) 표시 행의 원래 코드와 겹치는 신규행을 놓침 |

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
| MSG00004 | 저장건수 "{0}개의 데이터가 저장되었습니다" | **MSG00672**(성공, {0}=SP RESULT_CNT) / **MSG00004**(변경없음) | TO-BE MSG00004="No changes to save." 라 번호 그대로 쓰지 않음. 2026-10-22 보완: 종전 MSG00002(건수 없음) → 문구 일치 MSG00672("{0} data saved.", shipping 화면들 동일 재매핑) |
| (TO-BE 저장 실패 fallback) | 저장 실패 | **MSG00003** "Failed to save." | 2026-10-22 보완: 종전 MSG00043 = "Duplicate error on save. {0}" 로 의미 불일치. SP 오류문이 있으면 AS-IS 와 같이 `Error!\nMsg : <오류문>` 을 표시 |
| MSG00001 | 필수 공백 | (공통 `useSaveWithValidation` 자동) | 메타 INPUT_TP_CD=M 기반 표준 메시지 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SCP0122 는 편집 단일그리드(편집 2컬럼 OPMZ_ACTV_SEQ/NAME, 셀콤보 ActivityCode, Insert/Delete/Save). 공용 DataGrid·gridAction·useMessageStore 위임 축 포함.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | - | 신규행 Insert 는 handleInsert(GridAction.addRow, searchParams 복사원본)로 재현. 필터-유지 정책(keepRowVisibleUnderFilter)은 공용 DataGrid/프레임워크 소관이며 현재 공용 DataGrid 미배선=전역 프레임워크 갭(이 화면 feature 폴더 밖). 런타임 육안 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | components/PlanActivityMgmtGrid.tsx:76 (editTrackerRef → 공용 DataGrid.tsx:649-654 registerDirtyCheck) · SearchArea.tsx:118 / SubTitle.tsx:207 `confirmIfDirtyKey(…,'search')` · Division 변경 components/PlanActivityMgmtForm.tsx:128-130 | 2026-10-22 정정: 종전 '해당없음(프레임워크 축)' 은 사실과 다름 — 공용 위임으로 구현돼 있음(형제 scp-bom·plan-control 동일 판정). 런타임 미검증 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(SCP0122 Measure 0건, GridColumnSet 미배선). 사용자 컬럼 편집 UI 부재 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | PlanActivityMgmt.tsx:133,160 | 저장 성공/변경없음 시 `useMessageStore.setToast`(LGES 표준 하단중앙 자동소멸 Toast, MSG00672/MSG00004) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | PlanActivityMgmt.tsx:213 / packages/foundation/src/utils/gridAction.ts | 공용 DataGrid `excelFileName='PlanActivityMgmt'` export + gridAction dataMap(CODE→NAME 승계) — 셀콤보 OPMZ_ACTV_NAME(ActivityCode) Name 출력 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | - | 조회조건 3콤보(Division/PlanGroup/Process)만 — 자유 key-in 콤마 다중검색 텍스트 필드 없음. 콤마 다중 대상 필드 부재 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | packages/shared/src/components/organisms/data-grid/DataGrid.tsx:55 | 공용 DataGrid 가 `rebindFilterColumns` 사용 — 재조회 시 컬럼 필터 재적용 | 구현 |

---

# 하네스 Fact Pack 대조표 (TobeGen 2026-10-22 — 커밋본 위에 행 추가)

> 원천: Doc/asisfacts/screens/SCP0122 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.
> 2026-10-22: 골격 재생성본이 커밋본을 덮어써 types/util 2파일 삭제·대조표 축소가 있었음 → 커밋본 복원 후 아래 행만 병합(SCP0096 사고 동형, M06/M07).

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrLayoutControl1 / UsrLayoutControl | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-002 | §1 layoutControlGroup1 / LayoutControlGroup | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 usrLayoutControl2 / UsrLayoutControl | - | WinForms/DevExpress 레이아웃 컨테이너 — 단 cs:124 `SetDivisionAuthCheck(usrLayoutControl2)` 의 비활성화는 Form `noAuthDivision`(components/PlanActivityMgmtForm.tsx:91) 로 이식 | 해당없음 |
| D00-1-004 | §1 cboPlanGroup / UsrComboBox | components/PlanActivityMgmtForm.tsx:138-159 (CustomDropdown · PlanGroup_SCP_ALL Division 필터 cascade · 이름 정렬·첫 후보 선택 :53-63,77-81) |  | 구현 |
| D00-1-005 | §1 cboProcess / UsrComboBox | components/PlanActivityMgmtForm.tsx:162-182 (CustomDropdown · LookupCommon OPMZ_PRS_CD · 첫 후보 선택 :83-87) |  | 구현 |
| D00-1-006 | §1 cboDivision / UsrCombo | components/PlanActivityMgmtForm.tsx:113-135 (CustomDropdown · Division_SCP 권한 콤보 · 첫 후보 선택 :72-75) | 골격의 DivisionField(MyDivision) 미사용 — AS-IS dtMyDivision = BLUtils.GetDivision(false) 권한 Division(EE 포함) = Division_SCP(design 02 §2, MyDivision 재사용 금지) | 구현 |
| D00-1-007 | §1 layoutControlGroup2 / LayoutControlGroup | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-008 | §1 emptySpaceItem1 / EmptySpaceItem | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-009 | §1 layoutControlItem2 / LayoutControlItem | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-010 | §1 layoutControlItem9 / LayoutControlItem | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-011 | §1 Division / LayoutControlItem | - | WinForms/DevExpress 레이아웃 라벨 — FormItem label LBL00001 로 흡수 | 해당없음 |
| D00-1-012 | §1 spdMain / FpSpread | components/PlanActivityMgmtGrid.tsx:73 (DataGrid ← 'Plan Activity Mgmt' 컬럼 메타) |  | 구현 |
| D00-1-013 | §1 spdMain_Sheet1 / SheetView | - | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS.MAIN='main' 으로 흡수 | 해당없음 |
| D00-1-014 | §1 imageList1 / ImageList | - | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load | PlanActivityMgmt.tsx:67-71 (useEffect — clearFilters·fetchStaticColumns·restoreSearchConditions) | AS-IS Form_Load cs:101-108 — 진입 자동조회 없음(AS-IS 도 FindButton 시 조회) · 기간 조회조건 없음(B24 해당없음) | 구현 |
| D00-2-002 | §2 cboDivision / SelectedIndexChanged | components/PlanActivityMgmtForm.tsx:123-130 → usePlanActivityMgmtStore.ts:74-78 (setDivision) → 첫 후보 재선택 Form:77-87 | AS-IS ClbDivision_SelectedIndexChanged cs:544-549 = SetChangedControl(PlanGroup 재필터 cs:169-175) + ClearDataSource. PlanGroup 재필터 = planGroupOptions 파생(Form:53) + 첫 후보 선택(Form:77-81, AS-IS 재바인딩 첫 행), 그리드 clear = filters 비움. TO-BE 공통 요건(10-02)으로 Process 도 초기화 + 편집중 MSG00704 confirm | 구현 |
| D00-2-003 | §2 cboPlanGroup / SelectedIndexChanged | components/PlanActivityMgmtForm.tsx:148-155 → usePlanActivityMgmtStore.ts:59-66 (setSearchParams planGroupId → filters 비움) | AS-IS CboPlanGroup_SelectedIndexChanged cs:551-554 = ClearDataSource(그리드 clear) | 구현 |
| D00-2-004 | §2 spdMain / ComboSelChange | components/PlanActivityMgmtGrid.tsx:50-62 (cellEditEnded → applyActivitySync) | AS-IS SpdMain_ComboSelChange cs:225-247 — OPMZ_ACTV_NAME 선택 시 ActivityCode 행에서 OPMZ_ACTV_CD+LINK_UI_TYPE/PROGRAM_NAME/CONFIRM_YN/AUTO_YN/OPTION_YN 복사 | 구현 |
| D00-2-005 | §2 spdMain / CellClick | components/PlanActivityMgmtGrid.tsx:55 (cellEditEnded e.row) | AS-IS spdMain_CellClick cs:556-559 = `_currRowIdx = e.Row` 저장만(ComboSelChange 대상 행). TO-BE 는 편집 이벤트 e.row 로 같은 행을 직접 잡아 흡수 — 별도 click 핸들러 불요 | 구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 biz:CommonData.CommonDataList /  | components/PlanActivityMgmtForm.tsx:39-45 (useTabComboQueries LookupCommon lookupType='OPMZ_PRS_CD') | AS-IS dtProcessCdAll = Data.Common(LookupCommon,"OPMZ_PRS_CD") cs:47 → cboProcess. 콤보 SQL 이라 PROC 등록 대상 아님 — register.json/registration.sql 의 ACTION 'PKG_SCP0122.P_' 행은 오추정이라 제거(2026-10-22) | 구현 |
| D00-4-002 | §4 SCP.SCP0121_GET_SEARCH_INFO / SCP0121_GET_SEARCH_INFO | components/PlanActivityMgmtForm.tsx:39-63 (PlanGroup_SCP_ALL 콤보 + Division 필터 + OPMZ_PLAN_GR_NAME 정렬) | AS-IS dsSearchInfo.Tables[3](cs:129, GetPlanGroupByUserID cs:139-166 · Owner 권한 미적용 p_user_id='') = Plan Group 全件 → 의미 등가 콤보 PlanGroup_SCP_ALL 로 대체(design 02 §2). 별도 PROC 배선 없음(allowed_gap) | 구현 |
| D00-4-003 | §4 SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT / SCP0122_GET_PLAN_ACTIVITY_MGMT | PlanActivityMgmt.tsx:50-56 (useTabProcQuery main) · usePlanActivityMgmtStore.ts:80-95 (filters divisionId/planGroupId/prsCd) | 사내 ZIOUI1 2026-10-22 실측: MNU_BTN main/SEARCH → API P_SCP0122_GET(PROC_SELECT) → PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT · PROC_M IN 3 + o_rc1 + o_result_cursor = filter 키 일치(B22) | 구현 |
| D00-4-004 | §4 SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT / SCP0122_SAVE_PLAN_ACTIVITY_MGMT | PlanActivityMgmt.tsx:102-147 (apiClient.post main/SAVE/call-proc · o_result_cursor RESULT_CODE 판정 parseSaveResult) · utils/plan-activity-mgmt.util.ts buildSavePayload | 사내 ZIOUI1 2026-10-22 실측: MNU_BTN main/SAVE → API P_SCP0122_SAVE(PROC_SAVE) → PKG_SCP0122.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT · PROC_M IN 7(activeFlag/prsCd/planGrId/actvCd/actvSeq/preActvCd/userId) = payload 키 일치 · OUT o_result_cursor(PROC_RESULT) RESULT_CODE 'S'/'F' + RESULT_CNT 판정 | 구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'Plan Activity Mgmt' / META+코드연결 (15컬럼) | components/PlanActivityMgmtGrid.tsx:73-81 (DataGrid sheetName=ADMIN_SHEET_NAME[SHEETS.MAIN]) | 컬럼 메타 SHEET_NAME 'Plan Activity Mgmt'(15행, 사내 실측) ≠ 호출 시트 SHT_NM 'main' — constants ADMIN_SHEET_NAME 로 분리 | 구현 |

## §6 동적 컬럼

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-6-001 | §6 타이틀 SP / DB루프 컬럼 생성 — 없음 | - | 2026-10-22 진단: As-is 에 GetSpdTitle·*_GET_SHEET_CALENDAR_3SPAN·*_SPREAD_TITLE·InitSpreadDateColumn·Add*Column DB루프 없음(Fact Pack summary §2·§4-2·§11 = 메타형 `SetSheetHeaderColumnSCP@SetSpreadInit:212` 와 Designer 속성 4행뿐). 컬럼 = SCM_MST_SHEET_COLUMNS 'Plan Activity Mgmt' 15행(admin 컬럼 메타, D00-5-001). 헤더 1행(`AddSheet(spdMain,…,1,1,30)` cs:185) — ColumnHeaderSpan/리터럴 leaf 없음(H01·H05 대상 아님). RESPONSE_SET `o_rc1` = proc_params OUT COL_NM 일치(B26) | 해당없음 |
