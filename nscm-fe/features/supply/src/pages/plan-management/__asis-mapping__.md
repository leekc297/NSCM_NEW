# SCP0015 Plan Management — AS-IS ↔ TO-BE 매핑 매트릭스

- AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0015_PlanManagement/SCP0015_PlanManagement.cs` (1655줄) + `.Designer.cs`
- 설계 근거: `.atlas/gscm-design/SCP0015/design/00_checklist.md`(Roslyn 백본) · `01_layout.md` · `02_search-combo.md` · `03_grid-columns.md`
- 전환 회차: convert-react iter-1 (2026-09-24, 신규 생성) / iter-2 (2026-09-25, gap-audit G1~G3 보완 —
  저장 payload 평면화 + O_RESULT_CURSOR 판정, DIVISION_NAME 전용 MergeManager, RUN 성공 후 새 REVISION 컨텍스트 전환)

## 1. events (7건 전건)

| # | AS-IS | cs 라인 | TO-BE |
|---|---|---:|---|
| 1 | BtnStop_Click (MSG00185 confirm → SaveData_PlanStop) | 438 | `PlanManagement.tsx` `handleStop`/`execStop` — confirm(MSG01458) → `planMgmt/STOP/call-proc` |
| 2 | CboDivision_SelectedIndexChanged → SetChangedControl (PlanYear+PlanWeek 동시 재조회) | 1318 | `usePlanManagementStore.setSearchParams(divisionId)` 단일 커밋 — 하위 2콤보 쿼리 파라미터가 함께 갈려 한 액션으로 재조회(design 02 §3) |
| 3 | CboPlanYear_SelectedIndexChanged → PlanWeek 재조회 | 1325 | 동일 — `setSearchParams(planYear)` 가 planWeek 초기화, PlanWeek 쿼리 `calendarYyyy` 갱신으로 재조회 |
| 4 | SpdPlan_Changed (dsdm.Changed — REVISION_NO 한정) | 1418 | `PlanManagementGrid` `cellEditEnded`(REVISION_NO 한정) → `handleRevisionChanged` 연쇄 4단계(design 03 §4.3) |
| 5 | SpdPlan_CellClick (RUN/CONFIRM 버튼컬럼) | 1336 | `PlanManagementGrid.handleClick`(hitTest + `data-plan-action`) → `handleRun`/`handleConfirmAction` |
| 6 | SpdPlan_CellDoubleClick → FindData_Engin | 1362 | `PlanManagementGrid.handleDoubleClick` → `handleRowDoubleClick`(engine filter + selected) |
| 7 | timerStatus.Tick(2000ms) → CheckEngineStatus | 1586 | engineRun `useTabProcQuery` `queryOptions.refetchInterval = pollingActive ? 2000 : false` (신규 패턴 — 저장소 선례 0건) |

## 2. gridSignals (84건 — design 03 §3 합성 규칙 R1~R25 단위)

| 규칙 | AS-IS (#원본 gridSignals) | TO-BE |
|---|---|---|
| R1/R2 헤더 span (#1-27) | 컬럼 라벨·그룹 헤더 | `05_register.sql` SCM_MST_SHEET_COLUMNS COLUMN_LABEL_NAME + STEP_PROCESS1~4 SMALL_CLASS_LABEL_NAME='Step'(2단 헤더) |
| R3/R5 SmartColMerge 재실행 (#28-30,#32) | FarPoint 특유 재병합 | 미해당 — React 는 데이터 변경 시 자동 리렌더(design 03 §3 R3/R5 판정 그대로) |
| R4 DIVISION_NAME 병합 (#31) | SetColumnMerge(Always) | `PlanManagementGrid` allowMerging effect(DIVISION_NAME 만 true) + **화면 전용 `DivisionNameMergeManager`**(utils/planManagementMerge.ts — DataGrid mergeManager prop). 공용 CustomMergeManager 는 col0=MODELING_ID(행 유일키)부터 누적 머지키라 병합 실효 0 이었다(iter-1 gap-audit G2) — 값 단독 키 + 신규행 제외 가드로 대체 |
| R6 VisibleTab (#33,#34) | 시트 탭 표시 | 미해당 — 단일 화면 내 2그리드 구조(탭 아님) |
| R7~R10 RUN/CONFIRM lock (#35-46) | SetGridButtonEnabled L531-640 | `utils/planManagementLock.ts` isRunLocked/isConfirmLocked (+ vitest) — formatItem 이 행별 disabled 렌더 |
| R11~R13 전체잠금/REVISION unlock (#47-49) | LockColumn | admin 메타 INPUT_TP_CD — 전 컬럼 'S', REVISION_NO 만 'O'(05_register.sql) |
| R14 REVISION_NO 행별 콤보 (#50-56) | SetCellTypeCombo(dtRevisionXX 7종) | `PlanManagementGrid.beginningEdit` — 행 PLAN_TYPE 후보로 DataMap 스왑(후보 0건이면 빈 DataMap = 자유입력 차단). 후보 원천 = planMgmt 응답 o_rc2~o_rc8 동봉분(design 03 §1.4) |
| R15 Query 바인딩 (#57,#58) | ds → siPlan/siEngin | useTabProcQuery o_rc → DataGrid itemsSource |
| R16 dead code (#59,#60) | 주석 블록 내 SetText | 미이관(AS-IS 미실행 코드 — design 03 R16 판정 그대로) |
| R17 Confirm 정보 반영 (#61-63) | FindData_Confirm → SetText 3컬럼 | planConfirm 채널 effect — CONFIRM_YN/USER/TIME 행 갱신 + refresh(false) |
| R18 Confirm 저장 반영 (#64-66) | SaveData_PlanConfirm 성공 후 SetText | `execConfirm` 성공 시 `setConfirmFilters(key)` 재조회로 동일 3컬럼 갱신(SP 재반환값 대신 planConfirm SEARCH 재사용 — 동일 원천 테이블) |
| R19 REVISION 변경 파생 (#67-69) | SetText(PLAN_STATUS_NAME/PLAN_STATUS/MODELING_ID) | `handleRevisionChanged` (1)단계 — 후보 행 매칭 로컬 파생 |
| R20~R22 진행색상 (#70-77) | SetBGColor(ProcessColor) | `utils/planManagementEngine.ts` nextProgress/advanceProgress (+ vitest) + `EngineRunGrid` formatItem `.processFilled` 클래스. 정확한 원색(ProcessColor)은 미확인 — 시각 파리티는 사용자 확인 축 |
| R23 AddActionTextBox (#78,#79) | 버튼컬럼 사전 등록 | formatItem 버튼 직접 렌더(mail-setup MailCategoryGrid 선례 — 공통 그리드 FPButton 렌더링 부재) |
| R24 셀 포커스 복원 (#80-83) | SetActiveCell/ShowCell | 부분 재현 — React 리렌더는 선택 상태(wijmo selection)를 유지하므로 별도 복원 코드 없음. RUN 후 재조회(refetch)는 rows 교체라 선택이 풀릴 수 있음 — 확인 필요(사용자 축) |
| R25 GetViewRowFromModelRow (#84) | 모델/뷰 인덱스 변환 | 미해당 — dataItem 참조 기반 갱신(정렬/필터 상태 무관) |

## 3. validations (11건 전건) — Hook #114 MSG 역조회 반영

| # | AS-IS MSG | cs 라인 | TO-BE MSG(실측 2026-09-24) | 위치 |
|---|---|---:|---|---|
| 1 | MSG00185 Stop confirm | 440 | **MSG01458** "The Plan will be terminated of the Error Status. Do you want to run?" | `handleStop` |
| 2 | MSG00205 Modeling/PlanType 공백 | 477 | **MSG01460** "There is no Modeling ID or Plan Type. Please re-search and try again." | `handleRun` 가드(guardsReturn=true) |
| 3 | (예외처리) FindData_Plan catch | 772 | useTabProcQuery 내장 실패 alert(code!=0) + 전역 인터셉터 | 공통 |
| 4 | (예외처리) FindData_Engin catch | 998 | 동일 | 공통 |
| 5 | MSG00004 Confirm 저장 성공(건수) | 1136 | **MSG01461** "{0} data saved." (TO-BE MSG00004 는 "No changes to save." — 재사용 금지 확인) | `notifySaveResult` |
| 6 | MSG00006 Confirm 저장 실패 | 1157 | MSG00006 "Failed to save."(동일 ID·동일 의미 확인) | `notifySaveResult` |
| 7 | MSG00004 Stop 저장 성공(건수) | 1203 | MSG01461 | `execStop` → `notifySaveResult` |
| 8 | MSG00006 Stop 저장 실패 | 1224 | MSG00006 | 동일 |
| 9 | MSG00006 Run 실행 실패 | 1291 | 서버 예외 메시지 우선 표시(P_RAISE_NOT_MIGRATED 미구현 안내 — 0단계 확정), 공백이면 MSG00006 | `execRun` |
| 10 | MSG00183 Run confirm | 1345 | **MSG01456** "Do you want to run?" | `handleRun` |
| 11 | MSG00184 Confirm confirm | 1354 | **MSG01457** "Do you want to confirm?" | `handleConfirmAction` |

추가(영역2): MSG00097(권한 Division 0건) — 동일 ID 존재 확인("Please select Division."), `divisionAuthEmpty` alert 1회 + 조회 필수값 가드.

## 4. buttonGuards (4건) + override NO-OP (4건) + 추가 발견

| 항목 | AS-IS | TO-BE |
|---|---|---|
| guard #1 빈 그리드 더블클릭 no-op (L1364) | Rows.Count<=0 | hitTest dataItem 부재 시 return(`handleDoubleClick`) |
| guard #2 CanModelChange 재진입 가드 (L1420) | 비동기 조회 중 Changed 무시 | 미해당에 가까움 — TO-BE 는 이벤트 재진입이 아니라 상태 기반. cellEditEnded 는 편집 커밋 시 1회만 발화하고, 같은 값 재선택은 editStartValueRef 비교로 무시 |
| guard #3 REVISION_NO 컬럼 한정 (L1421) | e.Column 비교 | cellEditEnded 에서 binding !== 'REVISION_NO' return |
| guard #4 ds null 가드 (L1433) | 데이터소스 null | dataItem undefined 가드 |
| InsertButton NO-OP (L376) | `//InsertRow();` 주석 | **hotkeyConfig.insert = false(비노출)** — skill 3 grep 게이트의 "NO-OP 은 `() => undefined` 노출" 원칙의 예외 경로: DB `SCM_ADM_MNU_BTN_MPG_M` 에 INSERT/DELETE/SAVE 미등록 + **사용자 확정(2026-09-24, plan.md 0단계) "비노출(hasButton DB 게이트 그대로)"** — 근거를 이 표에 남긴다 |
| DeleteButton NO-OP (L381) | `//siMain.Delete();` | hotkeyConfig.delete = false — 동일 근거 |
| EditButton NO-OP (L387-414 전체 주석) | SwitchLock 로직 주석만 | 비노출(hotkeyConfig 에 edit 키 자체 없음 — 공용 SubTitle 표준에서 Edit 는 hotkeyConfig 대상 아님). 주석 로직(잠금 토글)은 재현 안 함(향후 재활성화 참고 기록만 — design 01 §2 행9) |
| SaveButton NO-OP (L432, SaveData() 빈 몸체) | `//SaveData();` | hotkeyConfig.save = false — 동일 근거 |
| FindButton 필수값 가드 (L670, Roslyn 미포착) | DataUtil.checkRequired(usrConditionPanel1) — PlanWeek 는 ConditionNotUseList(L221) 제외 | `handleSearch` — Division 공백 시 MSG00097 alert(TO-BE 표준 필수 alert), PlanYear 공백 시 AS-IS 그대로 조회 무시(early-return), PlanWeek 검사 제외 |
| Closed override (L416-428 전체 주석 — 00_checklist 추가 발견) | isUserRunPlan 종료 확인(MSG00180) 전체 비활성 | 미재현 — AS-IS 현재 동작(무조건 닫힘)과 동일. TO-BE 등가 MSG01455("There's the Plan you excute. Do you want to exit?") 가 등록돼 있음을 확인만 기록(재활성화 결정 시 사용) |

## 5. comboCalls (4건 전건 — design 02 실측 SQL_ID)

| # | AS-IS | TO-BE comboId·파라미터 |
|---|---|---|
| 1 | Data_SCP.Common(MyDivisionInEE, groupId, userId) L43 | `MyDivisionInEE_SCP` + `{ mnuId: MENU_ID }` (@sesUserId BE 주입. 표준 MyDivision 과 별개 콤보 — EE 포함/제외 정반대, 재사용 금지) |
| 2 | Data.Common(PlanYear, division) L652 | `PlanYear` + `{ param1: division }` |
| 3/4 | Data.Common(PlanWeek, division, planYear) L657/L1330 | `PlanWeek` + `{ param1: division, calendarYyyy: planYear }` — **연도 토큰명 calendarYyyy(param2 아님)** |

## 6. spCalls (6건) — FE 배선

| AS-IS SP | TO-BE 호출 |
|---|---|
| SCP.SCP0015_GET_PLAN_MST | `planMgmt` SEARCH (useTabProcQuery) — `sesUserGrId` FE 필수 전송(AS-IS p_group_id 누락 결함 미반복, design 03 §4.2) |
| SCP.SCP0015_GET_PLAN_ENGINE_RUN | `engineRun` SEARCH + refetchInterval 폴링 |
| SCP.SCP0015_GET_PLAN_MST_COMFIRM | `planConfirm` SEARCH (비가시 데이터 채널) |
| SCP.SCP0015_SAVE_PLAN_MST_COMFIRM | `planMgmt/CONFIRM/call-proc` (수동 경로 — BUTTON_TYPE 에 CONFIRM 없음) |
| SCP.SCP0015_SAVE_PLAN_MST_STOP | `planMgmt/STOP/call-proc` (수동 경로) |
| SCP.SCP0015_SAVE_PLAN_MST_RUN | `planMgmt/EXECUTE/call-proc` — SP 본문 P_RAISE_NOT_MIGRATED(convert-sp 백로그), 실패 메시지 그대로 안내. 성공 시 새 REVISION 감지 즉시 선택/Engine 컨텍스트를 새 revision 으로 전환(AS-IS CallEnginRun L494-519 등가 — iter-1 gap-audit G3 보완) |

저장 3종 공통(iter-2, gap-audit G1 보완): payload 는 PROC_M COL_NM **평면 최상위 키** 그대로 전송 —
`{ data: [payload] }` 래핑 금지(BaseService.makeProcedure 는 최상위 키만 name-lookup → 전 파라미터
NULL 바인딩 + 0행 UPDATE + 성공 alert). 성공/실패·건수는 `O_RESULT_CURSOR`(RESULT_CODE 'S'/'F',
RESULT_CNT / 실패 시 MSG — PKG_SCP0015 본문 실측) 판정 = AS-IS `Tables[0].Rows[0][0]=="S"` 등가.

CANCEL(P_SCP0015_SAVE_PLAN_MST_CANCEL) — AS-IS 소스에 없음. 사용자 확정(2026-09-24): 추가 안 함(DB 등록은 과거 잔재로 간주).

## 7. 알려진 잔여 / 확인 필요(사용자 축)

- Engine 진행바 원색(AS-IS ProcessColor)·병합 시각·버튼 셀 룩앤필 — 브라우저 육안 확인 필요.
- R24 셀 포커스 복원(RUN 후 재조회 시) — 육안 확인 필요.
- 분할 비율 초기값 45:55 는 334px 근사치(픽셀 고정이 아닌 % 분할) — 육안 확인 필요.
- `SCM_ADM_MNU_M.ROUTE_PATH` — 2단('supply/plan-management') 정정 + `USE_YN='Y'` 활성화 **적용 완료**
  (ora.py 실측 2026-09-25, iter-1 gap-audit ① 확인 — 05_register.sql [APPLIED] 블록).

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate.py --check 가 부재 행을 FAIL 처리한다.
> gap-resolve iter-1(2026-09-26) 전 행 코드 대사. Plan Management 는 엔진 제어 화면(Insert/Delete/Save NO-OP·조회조건 3콤보)이라 UC-01/02/03/06 해당없음.

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지 | — | Insert NO-OP(비노출, §4 근거) — 신규행 삽입 경로 없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 재조회 confirm(MSG00703) | — | 저장 버튼 NO-OP·배치 미저장 편집 개념 없음. REVISION_NO 변경은 즉시 파생(handleRevisionChanged), 엔진 액션(RUN/CONFIRM/STOP)은 개별 confirm 후 즉시 저장 | 해당없음 |
| COMMON:UC-03 | 컬럼/Measure 설정 적용 시 Reset·재조회 | — | Column/Measure 설정 모달 없음(customButtons 0, pivot 아님) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 Toast | PlanManagement.tsx notifySaveResult — 성공 setToast(success, MSG01461), 실패는 alert 유지(gap-resolve UC-04 정정) | | 구현 |
| COMMON:UC-05 | Excel 콤보 컬럼 Name 출력 | REVISION_NO formatItem CODE→NAME(행별 후보) + SubTitle excelFileName + 공용 DataGrid export dataMap 승계 | | 구현 |
| COMMON:UC-06 | Key-in 콤마 다중 조회 | — | 조회조건이 콤보 3종(Division/PlanYear/PlanWeek)뿐 — 텍스트 key-in 조회조건 없음(§5 "대소문자 무관" 미해당과 동일 축) | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 | 공용 DataGrid(@shared/components organisms/data-grid/DataGrid.tsx) rebindFilterColumns — 화면이 DataGrid 사용으로 승계 | | 구현 |

## gap-resolve iter-1 정정 (2026-09-26 — DB 실측·게이트 실행)

- **DB 재조회(rule #4 준수)**: PKG_SCP0015 PACKAGE+BODY VALID·7 proc / PROC_M 7행(SAVE 4종 OUT = O_RESULT_CURSOR 대문자 + o_rc 소문자 혼재, G5 근거 재확인) / MNU 1 / SHEET_COLUMNS 30 / CMBO 3(MyDivisionInEE_SCP·PlanYear·PlanWeek) — iter-3 기존확인과 일치.
- **RUN SP 미이관 재확인**: `all_source` PKG_SCP0015 에 RAISE_NOT_MIGRATED 4건 잔존 → RUN 은 여전히 'F' 커서(convert-sp 후속). FE 는 G5 정정으로 실패 alert 안내 — R3(convert-sp).
- **vitest 실행(G4 해소)**: `pnpm --dir nscm-fe/features/supply test` → plan-management(planManagementLock 12·planManagementEngine 7) 포함 supply 도메인 180/180 PASS. iter-1~3 "승인 차단 ERROR" 해소.
- **UC-04 정정**: notifySaveResult 성공 경로 setAlert→setToast(하단 Toast 표준).
