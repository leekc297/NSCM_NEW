# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 clbDivision / UsrCheckedList | components/ScpIfBlockingForm.tsx:56 (CustomDropdown multiple, Division 다중체크·EE 포함) |  | 구현 |
| D00-1-002 | §1 drpPeriod / UsrDateRangePicker | components/ScpIfBlockingForm.tsx:91,105 (DatePickerCalendar From~To, 필수) |  | 구현 |
| D00-1-003 | §1 usrConditionPanel1 / UsrConditionPanel | components/ScpIfBlockingForm.tsx:42 (공용 SearchArea = 조회조건 컨테이너 등가) |  | 구현 |
| D00-1-004 | §1 spdMain / FpSpread | components/ScpIfBlockingGrid.tsx:26 (공용 DataGrid, 메타 구동 5컬럼) |  | 구현 |
| D00-1-005 | §1 spdMain_Sheet1 / SheetView | scp-if-blocking.constants.ts:17 ADMIN_SHEET_NAME main:'Main' — 단일 시트 "Main" |  | 구현 |
| D00-1-006 | §1 usrLayoutControl1 / UsrLayoutControl | — | DevExpress 레이아웃 컨테이너(시각 전용) — TO-BE 는 React 셸(MainTitle/SubTitle/SearchArea)로 대체, 대응 컨트롤 없음 | 해당없음 |
| D00-1-007 | §1 usrLayoutControl2 / UsrLayoutControl | ScpIfBlocking.tsx:65,140 (SetDivisionAuthCheck 대상 컨테이너 = R1 noAuth → Form disabled 등가) |  | 구현 |
| D00-1-008 | §1 layoutControlGroup1 / LayoutControlGroup | — | DevExpress 레이아웃 그룹(시각 전용) — React 레이아웃 셸 대체, 대응 컨트롤 없음 | 해당없음 |
| D00-1-009 | §1 layoutControlGroup2 / LayoutControlGroup | — | DevExpress 레이아웃 그룹(시각 전용) — React 레이아웃 셸 대체, 대응 컨트롤 없음 | 해당없음 |
| D00-1-010 | §1 layoutControlItem4 / LayoutControlItem | components/ScpIfBlockingForm.tsx:53 (FormItem label LBL00641 Division) |  | 구현 |
| D00-1-011 | §1 layoutControlItem6 / LayoutControlItem | components/ScpIfBlockingForm.tsx:86,88 (FormItem label LBL00013 Period* required) |  | 구현 |
| D00-1-012 | §1 emptySpaceItem1 / EmptySpaceItem | — | DevExpress 여백 필러(시각 전용) — 대응 컨트롤 없음 | 해당없음 |
| D00-1-013 | §1 imageList1 / ImageList | — | WinForms 아이콘 리소스 인프라 — TO-BE 아이콘은 공용 컴포넌트 소관, 화면 대응물 없음 | 해당없음 |
| D00-1-014 | §1 components / Container | — | WinForms 디자이너 인프라(비 UI) — 대응물 없음 | 해당없음 |
| D00-3-001 | §3 SwitchLock / `()` | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23). 잠금 범위 재현 = 키컬럼 상시 S 잠금(D00-3-002)이 전부 — 편집모드 조건부 잠금 없음(이 화면) | 제외 |
| D00-3-002 | §3 LockColumn / DIVISION_ID·PLAN_START_YYYYMMDD 잠금(true) | 메타 SCM_MST_SHEET_COLUMNS INPUT_TP_CD='S'(DB 실측 2026-10-13) → components/ScpIfBlockingGrid.tsx:31 staticColumns 구동 |  | 구현 |
| D00-3-003 | §3 Query / `(ds)` 조회결과 바인딩 | ScpIfBlocking.tsx:67 useTabProcQuery → components/ScpIfBlockingGrid.tsx:30 itemsSource |  | 구현 |
| D00-3-004 | §3 LockColumn / 전열(0~max) 잠금(true) — 조회직후 | — | 조회직후 전열잠금 = EditButton 편집모드 OFF 상태(토글로 해제) — ANL-06 토글 어포던스 미이식, TO-BE 편집 기본 ON·키컬럼만 정적 S 잠금(D00-3-002) | 제외 |
| D00-4b-001 | §4b Data_SCP.Common / MyDivisionInEE / dtMyDivision | scp-if-blocking.constants.ts:25 COMBO.DIVISION='MyDivisionInEE_SCP' → ScpIfBlocking.tsx:54 useTabComboQueryResults(USE_YN=Y 실측) |  | 구현 |
| D00-4b-002 | §4b Data.Common / YesOrNo / dtYesOrNo | 셀콤보 메타 CELL_COMBO_DATA_TYPE='YesOrNo'(DB 실측) → components/ScpIfBlockingGrid.tsx:31 공용 DataGrid 자동배선 |  | 구현 |
| D00-4b-003 | §4b Data.CallBizCommonData / `"PERIOD_"+value` / dt | scp-if-blocking.constants.ts:26 COMBO.PERIOD_DEFAULT → ScpIfBlocking.tsx:89-94 applyPeriodDefault(periodApplied 가드) |  | 구현 |
| D00-4d-001 | §4d FindButton / Search | ScpIfBlocking.tsx:105,124 handleSearch(Period 필수 MSG00013 가드 후 setFilters) |  | 구현 |
| D00-4d-002 | §4d SaveButton / Save | ScpIfBlocking.tsx:116,125 onSave(dirty M행 → saveWithValidation+useProcMutation) |  | 구현 |
| D00-4d-003 | §4d InsertButton / Insert | ScpIfBlocking.tsx:126 `insert: () => undefined`(AS-IS 빈 override NO-OP 정확 재현, 공용 addRow 차단) |  | 구현 |
| D00-4d-004 | §4d DeleteButton / Delete | ScpIfBlocking.tsx:127 `delete: () => undefined`(AS-IS 빈 override NO-OP, 공용 removeRow 차단) |  | 구현 |
| D00-4d-005 | §4d EditButton / Edit | — | EditButton 토글 어포던스 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23). canEdit=hasButton('EDIT') 1회 치환(ScpIfBlocking.tsx:49). 조건부 잠금 없음(키컬럼 정적 S 뿐) | 제외 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | Insert = AS-IS 빈 override NO-OP(ScpIfBlocking.tsx:126) — 신규행 추가 자체가 없음(키컬럼 잠금, CRUD=U만). 신규행 필터 유지 대상 0 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ScpIfBlocking.tsx:141 (SubTitle) + components/ScpIfBlockingForm.tsx:42 (SearchArea) — 공용 nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx:201 · nscm-fe/packages/shared/src/components/organisms/search-area/SearchArea.tsx:118 confirmIfDirtyKey 가드(편집 그리드 YN 'O'라 자동 적용) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | — | Measure 0·정적 5컬럼(DB 실측) — 사용자 Column/Measure 개인화로 SP 쿼리가 바뀌는 축이 없음. Reset-재조회 대상 0 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ScpIfBlocking.tsx:89-95 useProcMutation onSuccess → setToast(success, MSG00672 "{0} data saved" + {0}=저장 행수) + invalidateQueries 재조회. 실패는 onError setAlert(MSG00006) | gap-resolve iter-1: convert-react 미배선(공용 MSG00002) 결함 교정(G9) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ScpIfBlocking.tsx:146 SubTitle excelFileName — 공용 DataGrid excel export 가 셀콤보 Name 출력. YesOrNo 는 CODE=NAME='Y'/'N'(DB 실측)이라 출력 동일 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | — | 조회조건에 key-in 텍스트 입력 없음(Division=체크리스트 콤보, Period=날짜 picker). 콤마 다중검색 대상 입력 0 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ScpIfBlockingGrid.tsx:26 (DataGrid, gridFilterRef 주입 ScpIfBlocking.tsx:150) — 공용 nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1695 rebindFilterColumns 로 재조회 시 필터-컬럼 자동 복구 |  | 구현 |

## 구성
- 조회조건(영역2): Division(다중 체크, 비필수, **EE 포함**) + Period*(필수, From~To).
- 단일 그리드(영역3) "Main" 5컬럼: DIVISION_ID / PLAN_START_YYYYMMDD(키·잠금) + FP/MRP/DM_RTF_YN(YesOrNo 셀콤보, 편집).
- 툴바: Find/Save(실동작) + Insert/Delete(**NO-OP 노출**) + Edit(권한축, 미노출).

## 콤보 (02 §2 / 03 §1.1)
| 용도 | SQL_ID | 파라미터 | 비고 |
|---|---|---|---|
| Division(조회) | `MyDivisionInEE_SCP` | @sesUserId/@mnuId | 권한필터 + EE 포함(공통 MyDivision 과 달리 EE 미제외 — 클라 필터 없음). 재사용 금지 대조 완료 |
| Period 기본값 | `PERIOD_DEFAULT` | @TimeZone | 진입 1회 FROM_VALUE:TO_VALUE 적용(periodApplied 가드). 이후 사용자 입력 보존 |
| YN 셀콤보 | `YesOrNo` | - | 상수 2값(Y/N). 메타(CELL_COMBO_DATA_TYPE) 구동 — 공용 DataGrid 자동 배선, 커스텀 콤보 로직 없음 |

## 버튼 override (01 §2 / 00 §4d)
| AS-IS | 본문 | TO-BE hotkeyConfig |
|---|---|---|
| FindButton | FindData() | `search: hasButton('SEARCH') ? handleSearch : false` (필수 Period 검증 후 setFilters) |
| SaveButton | SaveData() | `save: hasButton('SAVE') && canEdit ? onSave : false` (dirty M행 → useProcMutation + useSaveWithValidation) |
| InsertButton | 빈 본문(NO-OP) | `insert: () => undefined` (false/생략 금지 — 공용 addRow 차단, AUTH-04) |
| DeleteButton | 빈 본문(NO-OP) | `delete: () => undefined` (공용 removeRow 차단) |
| EditButton | SwitchLock 모드토글 | **미이식**(convert-core §2.4): `canEdit = hasButton('EDIT')` 1회 치환. 편집모드 상태 신설 안 함 |

## 편집·저장 (03 §3·§4)
- 키컬럼(DIVISION_ID/PLAN_START) 잠금 = 메타 `INPUT_TP_CD='S'`(상시 읽기전용, canEdit 무관).
- YN 3컬럼 편집 = 메타 `INPUT_TP_CD='O'`(05_register.sql 에서 S→O 정정, FAIL-risk 해소).
- 저장 = `CRUD_TYPE='M'` dirty 행만, FP/MRP/DM YN UPDATE(키 매칭). INSERT/DELETE 없음.
- GET WHERE 하한 `PLAN_START_YYYYMMDD >= FN_GET_BUCKET_YYYYMMDD(0)`(과거 Plan 숨김) = convert-sp 이식 계약.

## 런타임
- **PKG_SCM0019 MISSING** → GET/SAVE end-to-end 는 convert-sp 배포 후. FE·권한 메타는 선배선 완료.
- i18n: 저장 성공 MSG00672("{0} data saved") / 실패 MSG00006 / Period 필수 MSG00013 / 무권한 MSG00097
  (AS-IS MSG00004/00006 번호 직사용 금지 — TO-BE 문구 역조회, Hook#114).
