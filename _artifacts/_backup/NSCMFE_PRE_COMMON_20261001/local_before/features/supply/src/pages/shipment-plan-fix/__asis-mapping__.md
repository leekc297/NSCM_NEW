# SCP0025 Shipment Plan Fix — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS: `GSCM.SCP.Forms.UIL/Analysis/SCP0025_ShipmentPlanFix/SCP0025_ShipmentPlanFix.cs`(=cs) + `.Designer.cs`(=dz).
> 근거 원천: Roslyn `screen-analysis.json`(1.2-syntax, 파일:라인 앵커) + design 00~03(DB·SP 실측). GSCM `.cs` 본문은
> 작업 디렉터리 밖(부재)이라 라인 정밀 read 불가 — 라인번호는 Roslyn 기록 기준. 소스 부재 잔여는 "확인필요"로 명시.
> 커버리지: validations 10 · gridSignals 53 · comboCalls 7 · events 10 · buttonGuards 3 전건.
> 핵심 차이(자매 SCP0024): SCP0025 는 전 컬럼 read-only(INPUT_TP_CD='S' 20건) → 편집 그리드 아님. Unfix = 셀선택 역산 키에
> ACTIVE_FLAG='D'(design 03 §3-보강/§4.3). SAVE SP 는 실측상 Unfix 전용(확정 테이블 write = 'D' DELETE 뿐, Fix-insert 없음).

## 1. events (10) — 영역별 핸들러 매핑

| # | AS-IS control.event | cs:line | TO-BE | 상태 |
|--:|---|--:|---|:--:|
| 1 | btnItem_Id.Click | 1248 | `ShipmentPlanFix.tsx` onItemSearch → `ItemByDivisionModal` open | 구현 |
| 2 | btnUnfix.Click | 752 | `ShipmentPlanFix.tsx` handleUnfix (R1~R4 가드 → buildUnfixPayload → mutate) | 구현 |
| 3 | btnW26.Click | 779 | `ShipmentPlanFixForm` W26 → onPreset(26) | 구현 |
| 4 | btnW52.Click | 784 | W52 → onPreset(52) | 구현 |
| 5 | btnWLast.Click | 789 | WLast → onPreset(Number(wLastPeriod)||26) + showWLast/동적 라벨(자매 SCP0024 선례). GetLastRange SP 미배선이라 wLastPeriod='' → W26 fallback | 확인필요(§7-1, SP 미배선) |
| 6 | cboBucketType.SelectedIndexChanged | 1190 | Form bucket set → Grid buildPivotColumns 재구성(visible 토글, 재조회 없음) | 구현 |
| 7 | cboDivision.SelectedIndexChanged | 436 | `useShipmentPlanFixStore.setDivision`(하위 cascade+기간 초기화+그리드 초기화) + Page effect 가 기본기간(GetLastRange 근사 W26) 재시드 — iter-2 GAP-02 | 구현 |
| 8 | chkSum.CheckedChanged | 1195 | Form chkSum set → Grid isPivotVisible(W_/M_ SUM 토글) | 구현 |
| 9 | spdMain.CellDoubleClick | 446 | SetDblClickColumnShowHide(드릴다운) | 미구현(확인필요 §7-2) |
| 10 | spdMain.TopChange | 450 | 스크롤/머지 재적용 — 공용 DataGrid + CustomMergeManager 내장 | 패턴(자동) |

## 2. comboCalls (7) — 콤보/데이터소스 SQL_ID 매핑 (design 02 §2 실측)

| # | AS-IS code | cs:line | 영역 | TO-BE SQL_ID(실측 USE_YN=Y) | 상태 |
|--:|---|--:|:--:|---|:--:|
| 1 | BLUtils.GetDivision | 53 | 2 | `Division_SCP`(EE 포함·권한필터). MyDivision(EE 제외) 재사용 금지 | 구현 |
| 2 | Data.Common LookupCommon(OPERATION_GROUP) | 192 | 2 | lookup `OPERATION_GROUP`(P/A/E) — 초기값. division 확정 시 S4/S5 로 대체 | 구현(스왑으로 대체) |
| 3 | Data.Common LookupCommon(ELECTRODE_TYPE) | 195 | 2 | lookup `ELECTRODE_TYPE`(ANODE/CATHODE/ONESIDE) | 구현 |
| 4 | Data.Common SpreadTitle(SCM0014) | 280 | 3 | 그리드 컬럼메타 → `staticColumns` fetch(SCM_MST_SHEET_COLUMNS 'Shipment Plan Fix' 20행) | 구현 |
| 5 | Data_SCP.Common PlanExecYn | 765 | 1 | `PlanExecYn_SCP`(@divisionId → PLAN_STATUS) — R3 게이트 데이터. Page useTabComboQueries + handleUnfix 판정 | 구현 |
| 6 | Data_SCP.Common OperationGroup | 870 | 2 | `OperationGroup_SCP`(P,A) — 비EE 분기 | 구현(분기식 근사 §7-3) |
| 7 | Data_SCP.Common OperationGroupEE | 873 | 2 | `OperationGroupEE_SCP`(A,E) — EE 분기 | 구현(분기식 근사 §7-3) |

> EE/비EE 스왑은 `isEeDivision(division)` = division ∈ FN_GET_DIVISION_DIV('EE') 목록(EE/EE_HD/EE_HG/EE_HM/EE_ST/EE_UC,
> design 03 §2.7 실측) 판정. cboBucketType 은 comboCall 아님 — SP직접(DM0003_GET_BUCKET_TYPE_CODE) → TO-BE `BucketType` CMBO.
> filterCalls 0(§4c) — 클라 후처리 필터 없음(Division_SCP/OperationGroup(EE)_SCP 모두 WHERE 에 후보 내장).

## 3. buttonGuards (3) + validations (10) — 메시지·가드 흐름 매핑 (design 01 §2.6 M1~M9 + 영역3 1건)

> 양식: asis_mapping_gate 정본 4컬럼(요지|구현위치|사유|상태). msgId·cs:line·흐름은 요지 셀에 병기.
>   조합 ID(G1/M3 등)는 게이트가 개별 검증하도록 단일 ID 로 전개(조용한 누락 차단). gap-resolve iter-1 재구성.

| ID | 요지 (msgId·cs:line·흐름) | 구현 위치 (파일:라인) | 사유 (제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| G1 | MSG00096 cs:757 Unfix R2 권한(CanUpdate) | ShipmentPlanFix.tsx:133-136 (handleUnfix R2 hasButton('SAVE') false → MSG.NO_PERMISSION) |  | 구현 |
| G2 | MSG00304 cs:766 Unfix R3 PLAN_STATUS='0' | ShipmentPlanFix.tsx:119-122,138-141 (isPlanNotExecuted PlanExecYn_SCP 행1 & PLAN_STATUS='0' → MSG.PLAN_NOT_EXEC). MSG00304 미등록→영문 fallback(§7-4) |  | 구현 |
| G3 | (ViewModel null cs:755) Unfix R1 조회선행 | ShipmentPlanFix.tsx:128-131 (rows.length===0 → MSG.SEARCH_FIRST) |  | 구현 |
| M1 | MSG00109 cs:464 EditButton 편집가드 |  | EditButton/SwitchLock '수정 모드' 토글 어포던스는 `asis_to_tobe.md §11`·§8 F2 로 (b) 결정 — SCP0025 는 전 컬럼 read-only(INPUT_TP_CD='S' 20건) 구조라 편집모드 자체 부재. Hotkeys enum edit 슬롯 부재(팬텀 없음) | 제외 |
| M2 | (예외) cs:581 FindData_Main 조회 예외 | ShipmentPlanFix.tsx (전역 axios interceptor + useTabProcQuery 공용) |  | 구현 |
| M5 | MSG00016 cs:953 Unfix confirm | ShipmentPlanFix.tsx:153 (setAlert confirm MSG.CONFIRM_UNFIX=MSG01438) |  | 구현 |
| M6 | MSG00004 cs:1105 Unfix 성공(result_cnt) | ShipmentPlanFix.tsx (useProcMutation 공용 onSuccess 토스트) |  | 구현 |
| M7 | MSG00003 cs:1114 Unfix 실패(ReErrorMsg) | ShipmentPlanFix.tsx (useProcMutation 공용 onError) |  | 구현 |
| M8 | (예외) cs:1124 Unfix 예외 | ShipmentPlanFix.tsx (useProcMutation onError) |  | 구현 |
| M9 | MSG00046 cs:1140 삭제/확정해제 액션 안내 |  | 해당없음 — 별도 삭제 액션 미사용(Unfix=ACTIVE_FLAG='D' DELETE 로 흡수, insert/delete=()=>undefined) | 해당없음 |
| V1 | MSG00134 cs:948 selCells<1 (Unfix 전제) | ShipmentPlanFix.tsx:143-146 (handleUnfix R4 hasSelectedCell() false → MSG.SELECT_CELL=MSG00014) |  | 구현 |

> i18n: 공용 MSG 코드는 자매 SCP0024 가 TO-BE `SCM_ADM_MSG_M` 문구 역매핑(Hook #114)한 값 재사용 —
> NO_PERMISSION=MSG00096 / SELECT_CELL=MSG00014(AS-IS MSG00134) / CONFIRM_UNFIX=MSG01438(AS-IS MSG00016) /
> PERIOD_RANGE=MSG00108 / SEARCH_FIRST=MSG00662. MSG00304(PLAN_NOT_EXEC)는 SCP0025 고유 — 이 세션 DB 재검증
> 미완(ora.py query 승인 게이트)이라 AS-IS 번호 유지 + 영문 fallback, §7-4 확인필요.

## 4. gridSignals (53) — 그리드 동작 파리티 (design 03 §3 R-A~R-J, grid-behavior-parity 게이트)

| 규칙 | signals# | AS-IS | TO-BE | 상태 |
|---|---|---|---|:--:|
| R-A 3-span 기간헤더 + 요일색 | #29~#39 (11) | ColumnHeaderSpan/ForeColor cs:382~416 | `buildPivotColumns`(월>주>일 3단) + Grid formatItem(토 Blue/일 Red) | 구현 |
| R-B 동적 기간 숫자 celltype | #27/#28 (2) | SetReNumerCellType cs:375/379 | pivot 컬럼 format 'n0'(소수0, 음수허용). Fix Reason 행 셀 텍스트 표시 | 구현 |
| R-C 정보컬럼 3행 헤더 span(rowSpan=3) | #9~#24 (16) | ColumnHeaderSpan siMain cs:313~331 | staticColumns 정보/키 컬럼 + 다단헤더(공용 DataGrid) | 구현(iCol 세부 근사 §7-3) |
| R-D 조건부 컬럼 visible(EE) | #2~#7 (6) | ELECTRODE_TYPE/ORIGIN_TO/FROM_DIVISION_ID cs:264~272 | `isFixedColumnVisible`(EE_ONLY_COLUMNS × isEeDivision, FN_GET_DIVISION_DIV('EE') 실측) | 구현 |
| R-E spdInfo 초기화(merge + 액션박스) | #1/#8 (2) | SmartColMerge/AddActionTextBox cs:258/291 | 공용 DataGrid 헤더 초기화 | 패턴 |
| R-F MEASURE 고정(Freeze) + 병합 | #25/#26 (2) | Freeze/SmartColMerge cs:339/340 | measure(FIXED_FLAG=Y)까지 좌측 frozen(fixed 컬럼) + allowMerging | 구현 |
| R-G 데이터바인딩 + 전 컬럼 잠금 | #42/#43/#44 (3) | Query/LockColumn(0,max,true)/SmartColMerge cs:563/571/572 | `useTabProcQuery` + 전 컬럼 INPUT_TP_CD='S'(read-only, 편집 없음) | 구현 |
| R-H 셀타입 텍스트 + FIX_REASON 세팅 | #45/#46 (2) | SetCellTypeText/SetValue(dr["FIX_REASON"]) cs:644/698 | `mergeFixReason`(O_RC2 를 키+YYYYMMDD 로 Fix Reason 행 D_ 셀에 매핑) | 구현(O_RC2 컬럼 케이스 근사 §7-5) |
| R-I 더블클릭 컬럼 토글 + TopChange 재병합 | #40/#41 (2) | SetDblClickColumnShowHide/SmartColMerge cs:447/452 | TopChange 재병합=CustomMergeManager 내장. 더블클릭 드릴다운 미구현(§7-2) | 부분구현 |
| R-J SUM 컬럼 visible 토글(chkSum×bucket) | #47~#53 (7) | siObj chkSum.Checked cs:1206~1230 | `isPivotVisible`(bucket×chkSum, W_/M_ 토글) | 구현(iCol 미시매핑 §7-3) |

합계: 11+2+16+6+2+2+3+2+2+7 = 53 ✓

## 5. 편집/선택 band (design 03 §3-보강 — SAVE SP 실측)

- **편집 없음**: SHEET_COLUMNS 20컬럼 전건 INPUT_TP_CD='S' + AS-IS LockColumn(0,max,true) → 전 컬럼 read-only.
  EditTracker 편집·beginningEdit unlock·cellEditEnded 롤업·pastingCell 없음(자매 SCP0024 의 편집 band 미이식 — 의도적).
- **Unfix = 셀 선택 역산**: `buildUnfixPayload(grid)` 가 grid.selectedRanges 를 순회해 Ship Plan 행 × D_(일자) 셀만 골라
  14컬럼 JSON(ACTIVE_FLAG='D') 으로 조립(design 03 §4.3). 키 = DIVISION_ID/BIZ_TYPE/ITEM_ID/TO_SITE/FROM_SITE/BOD_ID/YYYYMMDD.
- **SAVE SP 실측(PKG_SCP0025 body)**: 확정 테이블 write = `DELETE FROM SCP_ANL_SHIPMENT_PLAN_FIX ... AND UPPER(P_ACTIVE_FLAG)='D'`(L749)
  + history INSERT(_H, L686) 뿐. Fix-insert 경로 없음 → SAVE 버튼·btnUnfix 둘 다 Unfix(ACTIVE_FLAG='D')로 배선(design 03 §0).

## 6. toolbarOverride (design 01 §2.4)

| override | line | TO-BE hotkeyConfig | 상태 |
|---|--:|---|:--:|
| FindButton (Search) | 459 | `search: handleSearch`(항상) | 구현 |
| SaveButton (Save) | 468 | `save: hasButton('SAVE') ? handleUnfix : false` — design 03 §0: SAVE SP 는 Unfix 전용이라 SAVE=Unfix 로 배선 | 구현(AS-IS Save=Fix vs Unfix 최종판정 §7-6) |
| EditButton (Edit) | 463 | (Hotkeys enum 에 edit 슬롯 없음 — search/save/insert/delete/manual/upload. 공용 기본 edit 핸들러 부재 → 슬롯 생략해도 팬텀 동작 없음. AS-IS MSG00109 가드 본문 확정 대기) | 확인필요 §7-2 |
| ExcelButton (Excel) | 471 | SubTitle 공통 excel export(excelFileName='ShipmentPlanFix') | 패턴 |
| (Insert/Delete override 없음) | - | `insert/delete: () => undefined`(공용 기본 addRow/removeRow 부활 방지, skill §3) | 구현 |

## 7. 확인 필요 / 한계 (소스 부재·세션 제약 — 침묵 누락 없이 명시, convert-core §4.3)

1. btnWLast periodType 값 — GetDayRange offset 미확정(design 02 §7-8). 자매 SCP0024 선례대로 wLastPeriod prop + showWLast +
   동적 라벨 구조로 정비. GetLastRange SP(SCM0001_GET_SCP_DAILY_PLAN_PERIOD) 미배선(convert-sp 후속) → wLastPeriod='' → W26 fallback.
2. spdMain.CellDoubleClick(SetDblClickColumnShowHide, R-I 드릴다운) / EditButton 본문 — GSCM `.cs` 부재(design 01 §5, 03 §6 #2). 미구현.
   iter-2 판단: `SetDblClickColumnShowHide` 는 AS-IS Spread 프레임워크 내장 메서드로 본문(어느 헤더 더블클릭 시 어느 하위
   컬럼그룹을 expand/collapse 하는지)이 소스에 없어 정확한 대응 대상을 확정할 수 없다. 추측 구현은 anti-simplification 위반이라
   자매 SCP0024(동일 미구현·확인필요 백로그)와 동일하게 백로그로 남긴다. `.cs` 확보 세션에서 본문 확인 후 구현.
3. EE/비EE 분기 predicate — 데이터 경계(EE 목록 FN_GET_DIVISION_DIV('EE'))·후보집합(P,A / A,E) 실측, C# `SetOperationGroupByDivision`
   판정식은 소스 부재로 미확정(design 02 §7-3). division 목록 멤버십으로 근사. R-C rowSpan iCol 세부·R-J SUM iCol 매핑 저위험 근사(design 03 §6 #2).
4. MSG00304(PLAN_NOT_EXEC) TO-BE 문구 재검증 — 이 세션 ora.py query 승인 게이트로 SCM_ADM_MSG_M 재조회 미완. AS-IS 번호 유지 +
   영문 fallback. DB 접속 가능 세션에서 문구 역조회 후 TO-BE 코드 확정(Hook #114). (공용 MSG 는 자매 SCP0024 검증본 재사용.)
5. O_RC2 Fix Reason 컬럼 케이스 — design 03 §4.2 문서값(키 + YYYYMMDD + FIX_REASON) 기준. `mergeFixReason` 는 케이스 무시 접근(getCI)으로
   흡수하나, 실제 반환 컬럼명·매칭 키 정합은 런타임 파리티에서 최종 대사(design 03 §6 #1 to_yyyymmdd/BOD_* 불일치 포함).
6. AS-IS Save(Fix) vs Unfix 최종 구분 — GSCM `.cs`(SaveData_FixInfo_U strAction) 부재. TO-BE SAVE SP 는 실측상 Unfix 전용
   (Fix-insert 없음)이라 SAVE=Unfix 로 배선(design 03 §0). AS-IS 에 별도 Fix 저장이 있었는지는 소스 확보 후 확정(사용자 축).
7. 브라우저 시각·조작감(3-span 헤더 렌더·요일색·병합 시각·read-only 셀 선택 UX·toast·선택 셀 물리 판정 design 03 §6 #3) — 사용자 확인 축(미확인).

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다(gap-resolve iter-1 에서 축 추가).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — 자유 Insert 기능 없음 (read-only 조회 + 셀선택 Unfix 모델, hotkeyConfig insert=()=>undefined ShipmentPlanFix.tsx:177) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음 (전 컬럼 INPUT_TP_CD='S' read-only, 수정 중 상태 미존재; Unfix 는 편집 아닌 셀선택 역산) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 해당없음 — Column/Measure 설정 모달 미사용(SubTitle customButtons=Unfix만, Measure 레지스트리 0행). admin 컬럼메타는 mount·Search fetch 로 소비(사용자 설정 UI 없음) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentPlanFix.tsx:59-63,155 (Unfix 저장 useProcMutation → 공용 onSuccess Toast, 수동 apiClient.post 미사용) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ShipmentPlanFix.tsx:204 (SubTitle excelFileName='ShipmentPlanFix'). lookup(division/biz_type/site/nickname)은 서버 FN 이 표시명 컬럼으로 반환(design 03 §4.2) → 코드 아닌 Name 출력 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useShipmentPlanFixStore.ts setFilter (electype 다중 → join(',') 로 GET SP STRING_SPLIT 전달; itemId txtItemId key-in) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ShipmentPlanFixGrid.tsx (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장, gridFilterRef 전달, 화면 배선 불요) |  | 구현 |
