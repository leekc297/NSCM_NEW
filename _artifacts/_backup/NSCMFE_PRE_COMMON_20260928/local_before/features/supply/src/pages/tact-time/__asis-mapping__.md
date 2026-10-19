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
