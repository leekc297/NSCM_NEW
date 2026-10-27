# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-3-001 | §3 164 / siMain | ScpBomGrid allowMerging=Cells + updatedLayout MERGE_COLUMNS (SmartColMerge TopChange → CustomMergeManager 자동) |  | 구현 |
| D00-3-002 | §3 205 / siMain |  | ChangeActiveSheet — 단일 그리드(Except 미부착, design 01 R6) 활성시트 전환 없음 | 해당없음 |
| D00-3-003 | §3 215 / siMain | ScpBomGrid allowMerging=Cells + updatedLayout(초기 병합) |  | 구현 |
| D00-3-004 | §3 216 / siMain |  | VisibleTab 단일시트 탭 — 단일 DataGrid 탭 UI 없음(design 01 R6) | 해당없음 |
| D00-3-005 | §3 345 / siMain |  | SwitchLock EDIT 모드 토글 미이식(asis_to_tobe.md §11 전 화면 공통). INPUT_TP_CD 메타 상시 재현 | 제외 |
| D00-3-006 | §3 349 / siMain | ScpBomGrid staticColumns (INPUT_TP_CD S15 메타 소비 — LockColumn 상수 이식 0, hook #130) |  | 구현 |
| D00-3-007 | §3 359 / siMain | utils/scp-bom.editLock.ts isRowLocked(SCP_PLAN_YN 비 Y/N) + ScpBomGrid beginningEdit cancel |  | 구현 |
| D00-3-008 | §3 360 / siMain | ScpBomGrid formatItem — isRowLocked 행 ROW_LOCK_BG Gray(hook #95) |  | 구현 |
| D00-3-009 | §3 471 / siMain | ScpBom.tsx useTabProcQuery data.o_rc → DataGrid itemsSource |  | 구현 |
| D00-3-010 | §3 472 / siMain | ScpBomGrid staticColumns (조회직후 전잠금 = 기본 read-only + M3 편집 메타) |  | 구현 |
| D00-3-011 | §3 474 / siMain | ScpBomGrid allowMerging=Cells(조회후 병합, #3 동일 기제) |  | 구현 |
| D00-3-012 | §3 667 / siMain |  | IsLockCell CellClick — AS-IS 바디 빈 블록(design 03 §3.2) no-op | 해당없음 |
| D00-3-013 | §3 707 / siMain |  | ChangeActiveSheet ActiveSheetChanged — 단일 시트 재동기화 원천 제거 | 해당없음 |
| D00-4b-001 | §4b Data.Common / MyDivision / dtMyDivision | components/ScpBomForm.tsx Division CustomDropdown COMBO.DIVISION(MyDivision — 81 고정+disabled) |  | 구현 |
| D00-4b-002 | §4b Data_SCP.Common / PlantByDivisionAll / dtPlantSiteByDivision | components/ScpBomForm.tsx Plant Site CustomDropdown COMBO.PLANT(PlantByDivisionAll_SCP, multiple+allOption) |  | 구현 |
| D00-4d-001 | §4d SpdMain_CellDoubleClick / - |  | SpdMain_CellDoubleClick — 선택 좌표 저장뿐(후속 없음) 미배선 | 해당없음 |
| D00-4d-002 | §4d SaveButton / Save | ScpBom.tsx handleSave (finishEditing + dirty CRUD_TYPE + saveWithValidation) |  | 구현 |
| D00-4d-003 | §4d DeleteButton / Delete | ScpBom.tsx hotkeyConfig.delete=()=>undefined (AS-IS DeleteButton 빈 본문 NO-OP 파리티 R5, hasButton 곱) |  | 구현 |
| D00-4d-004 | §4d InsertButton / Insert | ScpBom.tsx hotkeyConfig.insert=()=>undefined (AS-IS InsertButton 빈 본문 NO-OP 파리티 R4) |  | 구현 |
| D00-4d-005 | §4d SpdMain_Changed / - | ScpBom.tsx editTrackerRef + ScpBomGrid — 공용 EditTracker CRUD_TYPE 자동 마킹 |  | 구현 |
| D00-4d-006 | §4d SpdMain_Changed / - | ScpBomGrid beginningEdit (S/M 메타 차단 + isRowLocked 행잠금) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:AlertModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | ScpBom.tsx setAlert (useMessageStore 공용 AlertModal — 저장 실패 ERR_MESSAGE·필수 안내) |  | 구현 |
| MODAL:MaterialByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/ScpBomForm.tsx onModelSearch → MaterialByDivisionModal(COM0013, features/master 공용) 반환 modelId |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | MaterialByDivisionModal open(CustomDialog) — AS-IS SCM0002_ItembyDivisionPopup.ShowDialog 등가 |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터 상태 Insert 시 필터 유지 |  | INSERT NO-OP(R4) — 신규행 추가 경로 없어 필터유지 대상 없음 | 해당없음 |
| COMMON:UC-02 | 수정 중 조회 시 confirm | ScpBomGrid editTrackerRef → 공용 DataGrid registerDirtyCheck + SubTitle/SearchArea confirmIfDirtyKey(MSG00704) |  | 구현 |
| COMMON:UC-03 | 컬럼설정 적용 시 재조회 | useScpBomStore.fetchStaticColumns + ScpBom mount/Search refetch (Measure 없음 pivot X) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 Toast | ScpBom.doSave setToast(성공)/setAlert(실패) |  | 구현 |
| COMMON:UC-05 | Excel Code 아닌 Name | SubTitle excelFileName=ScpBom — 공용 DataGrid dataMap CODE→NAME |  | 구현 |
| COMMON:UC-06 | Key-in 콤마 다중 조회 | plantSiteId 콤마 결합(setFilter). Model/Parent/Child 는 SP 계약상 단일값(AS-IS 등가, 02 §7#3 갭 기록) |  | 구현 |
| COMMON:UC-07 | 필터 상태 재조회 시 유지 | ScpBomGrid gridFilterRef → 공용 DataGrid rebindFilterColumns |  | 구현 |

## validations (n=8, design 00 §2b + 신규 V9)

| # | msgId(AS-IS) | AS-IS 조건(cs) | TO-BE 구현 |
|--:|---|---|---|
| 1 | MSG00333 | Alt BOM 미체크 시 Model/Parent/Child 3텍스트 전부 공백(cs:253~261) | useScpBomValidation.validateSearch — `!alterBom && 3텍스트 공백` → MSG.REQUIRE_ONE_ITEM(MSG01329) alert·차단. Alt BOM 체크 시 통과 |
| 2 | MSG00334 | Model=Pack 인라인 SQL 0건(cs:264~277) | MSG.MODEL_NOT_PACK(MSG01330) 상수 배선. **실행수단(체크 프로시저) 미배포(goal.md ④) → 이번 회차 미배선**(명세 이탈 기록 §미이관) |
| 3 | MSG00335 | Parent=Pack 인라인 SQL 0건(cs:280~293) | MSG.PARENT_NOT_PACK(MSG01331) 상수 배선. 동상 — 수단 미배포 미배선 |
| 4 | MSG00336 | Child=Cell 인라인 SQL(cs:296~321, AS-IS SQL 결함) | MSG.CHILD_NOT_CELL(MSG01332) 상수 배선. 동상 — 수단 미배포 미배선(AS-IS 결함 미재현) |
| 5 | (예외) | FindData_Main GMessageBoxForException(cs:485) | 공통 예외 처리(axios interceptor + AlertModal) 흡수 |
| 6 | MSG00004 | 저장 성공 `rows[0][0]=='S'` → "{n}개 저장" + 재조회(cs:585) | doSave 성공분기 → setToast MSG.SAVE_SUCCESS(MSG00672 "{0}개…") + refetch. 동번호 재사용 금지(#114) |
| 7 | MSG00006 | 저장 실패 → 일반 실패(ERR_MESSAGE 미표시, cs:596) | doSave 실패분기 → o_rc 에러행 ERR_MESSAGE AlertModal(AS-IS 미표시분 표준 노출, design 03 §3.1) / 폴백 MSG.SAVE_FAIL(MSG00006) |
| 8 | (예외) | 저장 try GMessageBoxForException, iCount>0(cs:602) | callSaveScpBom false-success 차단(`res.status>=400 || Number(res.data.code)`) + 공통 예외 |
| 9(신규) | MSG00097 | InitControls dtMyDivision 0건 → SetDivisionAuthCheck(cs:121~122, bf:5269) | handleSearch — divisionAuth===false 면 MSG.REQUIRE_DIVISION(MSG00097 "Please select Division.") alert·조회 차단(R8). ScpBomForm.onDivisionAuth 판정 |

## buttonGuards (n=6, design 00 §4d — 전건 hasMessage=false 순수 가드)

| # | method | AS-IS 조건(cs) | TO-BE 구현 |
|--:|---|---|---|
| 1 | SpdMain_CellDoubleClick | `Rows.Count<=0`(cs:151) | 더블클릭 전용 동작 없음(design 03 §3.2 — 좌표 저장뿐) → 가드 자체 불요 |
| 2 | SaveButton | `fps==null`(cs:330) | handleSave — `grid?.finishEditing()` 후 `if(!grid)`/dirty 0건 시 중단(단일 그리드 = gridRef 고정) |
| 3 | DeleteButton | `fps==null`(cs:369) | DELETE NO-OP(`() => undefined`) — 본문 전체 주석(R5). 삭제 로직 없음 |
| 4 | InsertButton | `fps==null`(cs:392) | INSERT NO-OP(`() => undefined`) — 본문 전체 주석(R4). 추가 로직 없음 |
| 5 | SpdMain_Changed | `!CanModelChange \|\| e.Row==-1 \|\| e.Column==-1`(cs:675) | 조회 중 편집 억제 = useTabProcQuery isFetching(공용 DataGrid) + 헤더영역 편집 불가(wijmo 기본) |
| 6 | SpdMain_Changed | `siMain==null \|\| IsLock(SheetName)`(cs:676) | S/M 메타 차단(공용 DataGrid setEditableColumns) + 행 잠금(isRowLocked, beginningEdit cancel) |

## events (n=12, design 00 §2)

| # | control.event | AS-IS handler(cs) | TO-BE 구현 |
|--:|---|---|---|
| 1 | btnItemId.Click | btnItemId_Click(cs:643) | ScpBomForm onModelSearch → MaterialByDivisionModal(COM0013) open, 반환 → modelId |
| 2 | cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged(cs:625) | Division '81' 고정+disabled(R7) → 사용자 변경 트리거 없음. PlantSite 콤보 @divisionId='81' 1회 로드 |
| 3 | clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged(cs:633) | 실질 no-op(design 02 §3 — 로컬 계산만) → TO-BE 배선 불요 |
| 4 | dsdmMain.Changed | SpdMain_Changed(cs:672) | 좌표 저장뿐(후속 없음) → 공용 EditTracker 가 CRUD_TYPE 자동 마킹. 별도 불요 |
| 5 | spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged(cs:702) | 단일 시트(Except 미부착, design 01 R6) → 원천 제거 |
| 6 | spdMain.CellClick | SpdMain_CellClick(cs:665) | 바디 빈 블록(design 03 §3.2) → 불요 |
| 7 | spdMain.CellDoubleClick | SpdMain_CellDoubleClick(cs:149) | 선택 좌표 저장뿐 → 불요 |
| 8 | spdMain.ClipboardPasted | SpdMain_ClipboardPasted(cs:691) | 바디 빈 블록 → 공용 DataGrid 표준 paste + EditTracker + 콤보 후보 검증(Y/N·1..20 외 차단)로 등가 |
| 9 | spdMain.EditChange | SpdMain_EditChange(cs:713) | 좌표 계산 후 미사용 → 편집 파이프라인(cellEditEnded) 흡수, 파생 없음 |
| 10 | spdMain.EditModeOff | SpdMain_EditModeOff(cs:722) | 빈 본문 → 불요 |
| 11 | spdMain.TextChanged | spdMain_TextChanged(cs:727) | 빈 본문 → 불요 |
| 12 | spdMain.TopChange | SpdMain_TopChange(cs:161) | SmartColMerge 재수행 → Wijmo CustomMergeManager 뷰포트 자동 유지(재수행 불요, hook #69) |

## gridSignals (n=13, design 00 §3 / 03 §3) — 규칙 그룹 매핑

| # | 카테고리 | AS-IS(cs) | TO-BE |
|---|---|---|---|
| 1 | merge | SmartColMerge TopChange(cs:164) | CustomMergeManager 자동 유지(재수행 불요) |
| 2 | other | ChangeActiveSheet(cs:205) | 단일 그리드 → 불요 |
| 3 | merge | SmartColMerge 초기화(cs:215) | ScpBomGrid allowMerging=Cells + updatedLayout(MERGE_COLUMNS 제한) |
| 4 | visible | VisibleTab(true) 단일 시트 탭(cs:216) | 단일 DataGrid·탭 없음(design 01 R6) → 미구현 확정 |
| 5 | lock | SwitchLock EDIT 토글(cs:345) | 미이식(asis_to_tobe §11) — INPUT_TP_CD 메타 상시 재현 |
| 6 | lock | LockColumn DIVISION_ID~ECO_CODE(cs:349) | INPUT_TP_CD='S' 메타 소비(SORT1~15) — 상수 이식 0(hook #130) |
| 7 | lock | Rows[i].Locked 조건부 행잠금(cs:359) | isRowLocked(SCP_PLAN_YN 비 Y/N) → beginningEdit cancel(EDITABLE_COLUMNS 포함 전 셀) |
| 8 | color | 잠금행 BackColor=LockColor(cs:360) | ScpBomGrid formatItem — isRowLocked 행 배경 ROW_LOCK_BG(Gray, hook #95) |
| 9 | dataSource | Query(ds) 조회 바인딩(cs:471) | useTabProcQuery data.o_rc(RESPONSE_KEY) → DataGrid itemsSource |
| 10 | lock | LockColumn(0,Max) 조회직후 전잠금(cs:472) | TO-BE 기본 읽기전용 + M 3종만 편집(메타) 동일 → 별도 불요 |
| 11 | merge | SmartColMerge 조회후(cs:474) | allowMerging=Cells(#3 과 동일 기제) |
| 12 | lock | IsLockCell CellClick(cs:667) | CellClick 바디 빈 블록 → 불요 |
| 13 | other | ChangeActiveSheet(cs:707) | 단일 시트 재동기화 → 원천 제거 |

카운트 대사: merge 3 + lock 5 + color 1 + visible 1 + dataSource 1 + other 2 = 13. 전건 반영.

## controls / popups (design 00 §1 / §5-E)

| AS-IS 컨트롤 | TO-BE |
|---|---|
| cboDivision(UsrCombo) | ScpBomForm Division CustomDropdown('81' 고정+disabled, MyDivision) |
| clbPlantSite(UsrCheckedList) | ScpBomForm Plant Site CustomDropdown multiple+allOption(PlantByDivisionAll_SCP) |
| txtModelID/txtParentID/txtChildID(UsrMultiLineEditor) | ScpBomForm InputField 3종(단일값 실효, design 02 §2.3) |
| btnItemId(UsrButton) | ScpBomForm 돋보기 → MaterialByDivisionModal(COM0013), 반환 → modelId |
| ucbAltBOM(UsrCheckBox) | ScpBomForm Checkbox(alterBom → 'ALTER'/'ALL') |
| spdMain(FpSpread) 단일 시트 | ScpBomGrid 공용 DataGrid(staticColumns 메타 구동) |
| ProgressForm | useTabProcQuery isFetching(공용 로딩) |
| SCM0002_ItembyDivisionPopup | MaterialByDivisionModal(COM0013) — cs 실측 반환처=txtModelID |

## 미이관/대체 정직 표기 (convert-core §4.3)

- **타입 사전검증 V2~V4(MSG01330/1331/1332)**: AS-IS 인라인 SQL 이나 TO-BE 체크 프로시저 미배포(goal.md ④·02 §7#4). FE 는 SQL 직접실행 금지 → 이번 회차 **미배선**(메시지 상수만 배선). 명세 이탈 — convert-sp 에서 체크 프로시저 신설 또는 검증 생략+0행 안내로 후속 결정.
- **멀티라인 3종 다중값 갭**: v0.5 명세=다중 / SP·AS-IS 런타임=단일값. **권고(b) AS-IS 등가 단일값**으로 구현(02 §7#3). 사용자 합의 시 SP STRING_SPLIT 보완은 convert-sp 후속.
- **Division '81' 고정+disabled**(R7): AS-IS OnShown 강제. '81' 후보 부재 시 AS-IS 폴백(마지막 행 선택)은 결함이라 미재현 — 빈 선택+조회 차단(R8)으로 처리.
- **EDIT 모드 토글 미이식**(R3): editMode/setEditMode store 미신설(convert-core §2.4). 조회 직후부터 M 3종 상시 편집(행 잠금 규칙 우선).
- **다단 헤더**: AS-IS 는 1행 헤더였으나(design 03 §1.1.1) TO-BE 는 메타 LARGE/SMALL_CLASS_LABEL('Simulator' 그룹·PLANT_ID 상단 'Plant ID') 자동 소비 — 메타 정본 소비 결과(코드로 무력화 금지).
- **전 플랜트 일괄 반영 사양**: SAVE UPDATE WHERE=(division,parent,child) 3키 → 같은 조합 타 플랜트 행 동반 갱신(AS-IS 사양, design 03 §4.2). 결함 아님.
- **런타임 검증(브라우저 육안·SP 실행)**: 사용자 확인 축 = 미완. type-check/lint/grep 정적검증만 이번 회차 수행.