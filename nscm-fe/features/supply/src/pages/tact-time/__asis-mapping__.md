# SCP0020 TactTime — AS-IS ↔ To-Be 매핑 매트릭스

> AS-IS `GSCM.SCP.Master.UIL/SCP0020_TactTime.cs` (+ Designer) → To-Be `features/supply/src/pages/tact-time`.
> 근거 백본: `.atlas/gscm-design/SCP0020/design/00_checklist.md`(Roslyn 카운트) + 01~03.
> gap 리포트(판정/self-check/정직보고): `.atlas/gscm-design/SCP0020/design/04_react-gap.md`.

## 1. 컨트롤 (Roslyn controls 26 — design 00 §1)

| 영역 | AS-IS | To-Be | 파일 |
|---|---|---|---|
| 1 Layout | usrConditionPanel1 / usrLayoutControl2 / layoutControlGroup2 / splitContainer2 | SearchArea + PanelGroup(수평 split) | `TactTime.tsx`, `TactTimeForm.tsx` |
| 1 Layout | usrLayoutControl1 / layoutControlGroup1 (orphan dead) | 미이식 (design 01 §1 dead) | — |
| 2 조회 | cboDivision | Division CustomDropdown (cascade L0) | `TactTimeForm.tsx` |
| 2 조회 | clbPlantSite (다중) | Plant Site multi CustomDropdown (cascade L1) | `TactTimeForm.tsx` |
| 2 조회 | clbLine (다중) | Line multi CustomDropdown (cascade L2) | `TactTimeForm.tsx` |
| 2 조회 | cboOperationGroup | Operation Group CustomDropdown (lookup) | `TactTimeForm.tsx` |
| 2 조회 | cboValid | design 01 D-2 정적 숨김 → 미렌더, 기본 'ALL' 파라미터 유지(D-2b) | `useTactTimeStore.ts` |
| 2 조회 | btnItemId / txtItemId | Item Search 버튼 + InputField(다건) + ItemSearchModal | `TactTimeForm.tsx`, `modals/ItemSearchModal.tsx` |
| 3 그리드 | spdMain (Plant/Packer 2탭) | TactTimeMainGrid (mode 전환, 단일 DataGrid 컬럼셋 교체) | `TactTimeMainGrid.tsx` |
| 3 그리드 | spdExcept | TactTimeExceptGrid | `TactTimeExceptGrid.tsx` |

## 2. 이벤트 (Roslyn events 5 + cascade 2 — design 00 §2)

| AS-IS event | line | To-Be |
|---|---|---|
| btnItemId_Click | 2541 | `TactTimeForm` onItemSearch → ItemSearchModal |
| SpdMain_EditChange / EditModeOff | 2806/2814 | `TactTimeMainGrid` cellEditEnded (파생 + clamp) |
| spdExcept_EditChange / EditModeOff | 2827/2835 | `TactTimeExceptGrid` cellEditEnded |
| ClbDivision_SelectedIndexChanged | 2516 | `TactTimeForm` division onChange → plantSite/line 초기화 |
| ClbPlantSite_SelectedIndexChanged | 2528 | `TactTimeForm` plantSite onChange → line 초기화 |

## 3. 검증 (Roslyn validations 47 — design 00 §2b, 영역3 39 이식 / static 8 = 예외처리 공통)

| MSG ID | 로직 | To-Be |
|---|---|---|
| MSG00193 | PRIORITY>0 / TACT_TIME>0 | `useTactTimeValidation.validateMainRows` |
| MSG00085 / MSG00072 | YIELD 1~100 | `validateMainRows` / `validateExceptRows` |
| MSG00002 | 전극(E) LANE_QTY 필수 / Except LINE_ID 필수 | `validateMainRows` / `validateExceptRows` |
| MSG00049 | Except 날짜형식 yyyyMMdd | `validateExceptRows` |
| MSG00048 | Except 날짜범위 >=17530101 | `validateExceptRows` |
| MSG00105 | 중첩기간(checkValidN5) | `validateExceptRows` |
| MSG00108 | 시작<=종료(checkValidN8) | `validateExceptRows` |
| MSG00203 | TACT_TIME clamp | `TactTimeMainGrid` / `TactTimeExceptGrid` cellEditEnded |
| MSG00109/00199/00161/00004/00006/00043 | 읽기전용/작업중/Insert/저장확인·결과 | SubTitle 표준 버튼 + useProcMutation onSuccess/onError |
| static 8 (GMessageBoxForException) | catch 예외처리 | 공통 apiClient 인터셉터/에러 토스트 |

## 4. gridSignals (Roslyn 77 — design 00 §3 / 03 §3)

| 유형 | 건수 | To-Be |
|---|---:|---|
| LockColumn/LockRange (편집잠금 white-list) | 32 | `utils/tactTimeEditLock.ts` isPlant/isPacker/isExceptCellEditable (+ test) |
| SetValue Insert 기본값 | 27 | `utils/tactTimeEditLock.ts` plant/packer/exceptInsertDefaults (+ test) |
| SetValue 파생 Auto-Sync | 9 | `utils/tactTimeDerive.ts` deriveJumboMin/deriveTactTimeFromDaily/clampTactTime (+ test) |
| SmartColMerge | 9 | DataGrid allowMerging (키 컬럼 연속 병합 — 대상 컬럼 리스트 확인 필요, design 03 §6-4) |

## 5. SP (Roslyn spCalls 8 — design 00 §4a / 03 §4)

| AS-IS SP | To-Be sheet / action |
|---|---|
| SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME | `plant` SEARCH / SAVE (useTabProcQuery / useProcMutation) |
| SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_TIME_OSP | `packer` SEARCH / SAVE |
| SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SAVE_TACT_TIME_EXCEPT(_OSP) | `except` SEARCH / SAVE |
| SCM0002 Item 팝업 | `itemSearch` SEARCH (확인 필요 — 별도 화면 SP) |

> 확인 필요(정직): SP 본문·배포(INVALID)·admin 메타(버튼/컬럼/콤보) 미등록 — design 03 §6 / 04_react-gap.md 참조.
> 이 매핑은 설계 문서 카운트를 To-Be 코드에 100% 대응시킨 커버리지 표이며, DB 실측 blocked 축은 04 에 ERROR 로 명시.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.
> 근거는 convert-gap-resolve iter-1 메인세션 재판정(2026-09-25) 시 tact-time 코드 실사(Explore) 결과다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | 공용 DataGrid `restoreGridFilter()` (packages 공용 DataGrid.tsx itemsSourceChanged) — 재바인딩 시 필터 재적용. tact-time 은 공용 그리드 소비(TactTimeMainGrid/ExceptGrid) | | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = confirm 프롬프트 | SubTitle 이 handleSearch(TactTime.tsx:214)를 confirmIfDirtyKey(...,'search')로 래핑 → MSG00704 dirty confirm (공용 useDirtyRegistry) | | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 | | 해당없음 — SCP0020 은 SHEET_COLUMNS 메타 구동 정적 컬럼 그리드(design 00 §화면형태 / 03 §319: 동적 pivot·measure 설정 무). 사용자 Column/Measure 설정 다이얼로그가 없어 트리거 자체가 부재 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | 공용 useSaveWithValidation → useMessageStore.setToast (TactTime.tsx:189-193/207-210 saveWithValidation 경유) | | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 | 공용 gridAction.excelDownload 가 liveDataMaps 승계(dataMap 보존) — 콤보 컬럼 Name 출력. tact-time DataGrid 소비 | | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | | 해당없음 — SCP0020 조회조건에 자유 텍스트 key-in 필드 없음. txtItemId 는 AS-IS UsrMultiLineEditor(SCM0002 팝업 다중행 반영, design 02 §6, resultProps=[ItemID])로 팝업 구동, plantSite/line 은 다중선택 드롭다운(배열). 콤마 key-in 대상 컨트롤 부재 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 | 공용 DataGrid itemsSourceChanged → restoreGridFilter() + rebindFilterColumns (재조회 시 필터 재적용). tact-time DataGrid 소비 | | 구현 |
