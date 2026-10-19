# SCP0024 Production Plan Fix — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS: `GSCM.SCP.Forms.UIL/Analysis/SCP0024_ProductionPlanFix/SCP0024_ProductionPlanFix.cs`(=cs) + `.Designer.cs`(=dz).
> 근거 원천: Roslyn `screen-analysis.json`(1.2-syntax) + design 00~03(DB 실측) + **AS-IS `.cs` 본문 정독**
> (gap-resolve iter-2 — GSCM/ 소스 리포 반입으로 라인 정밀 read 완료. 종전 "소스 부재 확인필요" 항목 전건 재판정).
> 커버리지: validations 16(+프레임워크 2) · gridSignals 31 · comboCalls 8 · events 12 전건.

## 1. events (12) — 영역별 핸들러 매핑

| # | AS-IS control.event | cs:line | TO-BE | 상태 |
|--:|---|--:|---|:--:|
| 1 | btnItemId.Click | 648 | `ProductionPlanFix.tsx` onItemSearch → `MaterialByDivisionModal`(AS-IS cs:650 SCM0002_MaterialByDivisionPopup, preSearchParams division/operationGroup/itemId/scpModuleType='SCP0024') open | 구현 |
| 2 | btnUnfix.Click | 1199 | `ProductionPlanFix.tsx` handleUnfix (R2 권한 → R1 조회선행 → R3 셀선택 가드) → `buildUnfixPayload`(선택셀 기반 — AS-IS SaveData_FixInfo_U cs:1249-1544 재현: Prod Plan 행 × 수량 있는 D_(W_ 는 같은 월(YYYYMM)+ISO 주의 D_ 로 확장 — W_ 가 (BASIS_YYYYMM, ISO_WEEK) 단위라 AS-IS 인접 블록과 동일) → ACTIVE_FLAG='D', BUCKET_TYPE 빈값(AS-IS 미설정)). R3 판정은 `grid.selection` 유무가 아니라 payload 조립 결과(0건 → MSG00134, confirm 이전)로 한다 — Wijmo 는 itemsSource 바인딩 시 (0,0) 셀을 자동 선택해 selection 유무만으로는 "미선택"을 가리지 못한다(2026-10-12 실사용 리포트로 정정, V16 참고). R1 0행 안내는 AS-IS 무반응과 다른 사용자 결정 | 구현 |
| 3 | btnW26.Click | 1216 | 별도 버튼 삭제(사용자 지시 2026-10-06) — 공용 `PeriodRangePicker` 달력 팝업 내장 프리셋 W26 으로 대체. AS-IS `GetDayRange`(cs:1184-1197)는 `p_from_date=""`로 서버에 보내 항상 오늘 기준으로 계산한다(선택된 From 기준 아님) — 공용 컴포넌트 기본 동작(From 기준, 다른 화면 하위호환)과 달라 `quickWeeksFromToday` prop 으로 오늘 기준 override(2026-10-12 정정, 종전 "From 기준 26주" 기록은 오류) | 대체 |
| 4 | btnW52.Click | 1221 | 별도 버튼 삭제 — `PeriodRangePicker` 팝업 내장 프리셋 W52 로 대체(위 #3 과 동일하게 `quickWeeksFromToday` 로 오늘 기준). 진입 시 기본 기간은 `ProductionPlanFix.tsx` handlePreset(52) 가 유지(cs:430, 이미 오늘 기준) | 대체 |
| 5 | btnWLast.Click | 1226 | 버튼·`wLastPeriod`/`showWLast` 삭제(사용자 지시 2026-10-06) — 공용 `PeriodRangePicker` 는 WLast 프리셋이 없다 | 미구현(의도적 제외, §7-4) |
| 6 | cboBucketType.SelectedIndexChanged | 642 | Form bucket set → Grid buildPivotColumns 재구성(visible 토글) | 구현 |
| 7 | cboDivision.SelectedIndexChanged | 1109 | `useProductionPlanFixStore.setDivision`(하위 cascade+그리드 초기화) | 구현 |
| 8 | cboOperationGroup.SelectedIndexChanged | 1124 | Form 클라 필터 재계산(plantSite/line) | 구현 |
| 9 | chkSum.CheckedChanged | 704 | Form chkSum set → Grid isPivotVisible(W_/M_ SUM 토글) | 구현 |
| 10 | clbPlantSite.SelectedIndexChanged | 1119 | Form lineOptions 클라 필터(SITE_ID) 재계산 | 구현 |
| 11 | spdMain.CellDoubleClick | 1130 | `ProductionPlanFixGrid.tsx` dblClickHandler(hostElement dblclick + hitTest ColumnHeader) — AS-IS `SetDblClickColumnShowHide`(SpreadInfo.cs:10838-10885) 재현: M_ 헤더=같은 월 W_ 토글+D_ 숨김 / W_ 헤더=같은 주 D_ 토글 | 구현 |
| 12 | spdMain.TopChange | 594 | 스크롤/머지 재적용 — 공용 DataGrid + CustomMergeManager 내장 | 패턴(자동) |

## 2. comboCalls (8) — 조회조건 콤보 SQL_ID 매핑 (design 02 §2 실측)

| # | AS-IS code | cs:line | TO-BE SQL_ID(실측 USE_YN=Y) | 클라 필터 | 상태 |
|--:|---|--:|---|---|:--:|
| 1 | BLUtils.GetDivision | 281 | `Division_SCP`(EE 포함) | - | 구현 |
| 2 | Data_SCP.CommonAll PlantSiteProdPlan1 | 283 | `PlantSiteProdPlan1_SCP_ALL`(EE pool) | F1 DIVISION_ID+OPERATION_GROUP | 구현 |
| 3 | Data_SCP.CommonAll PlantByDivisionOperation1 | 284 | `PlantByDivisionOperation1_SCP_ALL`(비EE pool) | F2 동일 | 구현 |
| 4 | Data_SCP.CommonAll LineProdPlanLine1 | 286 | `LineProdPlanLine1_SCP_ALL`(EE pool) | F3 = DIVISION_ID+OPERATION_GROUP+SITE_ID(cs:807 원식 확정, Form 재현) | 구현 |
| 5 | Data_SCP.CommonAll LineByOperationAddOSP1 | 287 | `LineByOperationAddOSP1_SCP_ALL`(비EE pool) | F4 = DIVISION_ID+SITE_ID(cs:812 원식 확정 — OPERATION_GROUP 미포함, Form 재현) | 구현 |
| 6 | Data.Common LookupCommon(ElectrodeType) | 291 | lookup `ELECTRODE_TYPE`(ANODE/CATHODE/ONESIDE). 비EE 시 값 비움+비활성(SetChangedControl cs:833-841 → Form disabled={!isEe} + setDivision 리셋) | - | 구현 |
| 7 | Data_SCP.Common OperationGroupEE | 780 | `OperationGroupEE_SCP`(A,E) — EE 분기 | isEeDivision | 구현(분기식 확정 cs:779) |
| 8 | Data_SCP.Common OperationGroup | 782 | `OperationGroup_SCP`(P,A) — 비EE 분기 | isEeDivision | 구현(분기식 확정 cs:779) |

> EE/비EE pool 스왑 분기식 확정(gap-resolve iter-2): RefreshOperationGroup/PlantSite/Line 전건
> `_division.Substring(0,2).Equals("EE")`(cs:779/789/805) = `isEeDivision`(앞2자 EE)이 정확 재현.
> filterCalls F1~F4 전건 원식 확정: F1/F2(Plant)=DIVISION_ID+OPERATION_GROUP(cs:791/795),
> F3(EE Line)=DIVISION_ID+OPERATION_GROUP+SITE_ID(cs:807), F4(비EE Line)=DIVISION_ID+SITE_ID(cs:812).
> 주의: AS-IS `getLine()`(cs:125-138)은 clbPlantSite 를 읽는 복사-붙여넣기 결함(부분 선택 시 p_line_id 에
> plant 값 전송)이라 재현하지 않는다 — TO-BE 는 lineIds 를 올바르게 전송(의도적 차이, AS-IS 버그 미재현).

## 3. validations (16) — 메시지 흐름 매핑 (design 01 §2.6 M1~M14 + 영역3 2건)

> 양식: asis_mapping_gate 정본 4컬럼(요지|구현위치|사유|상태). msgId·cs:line·흐름은 요지 셀에 병기.
>   조합 ID(M2/M3 등)는 게이트가 개별 검증하도록 단일 ID 로 전개(조용한 누락 차단). gap-resolve iter-1 재구성.

| ID | 요지 (msgId·cs:line·흐름) | 구현 위치 (파일:라인) | 사유 (제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| M1 | MSG00109 cs:623 EditButton 편집가드 |  | AS-IS 본문 확정(iter-2): EditButton 은 MSG00109(TO-BE 실측 "Read-only mode.") 안내 후 return 뿐이고 SwitchLock 은 주석(cs:625-633) — 토글 어포던스 자체가 AS-IS 에서 이미 비활성. `asis_to_tobe.md §11`·§8 F2 (b) 결정과 합쳐 미이식 확정. Hotkeys enum 에 edit 슬롯 부재(팬텀 없음) | 제외 |
| M2 | MSG00004 cs:1043 SaveData(Fix) 변경없음 |  | 해당없음 — AS-IS SaveData(Fix)는 SaveButton 주석(cs:636-639)의 dead code. G20 사용자 결정(2026-09-26)으로 Fix 경로 미이식 | 해당없음 |
| M3 | MSG00006 cs:1052 SaveData(Fix) 성공 |  | 해당없음 — M2 와 동일(Fix 경로 미이식, G20) | 해당없음 |
| M4 | MSG00096 cs:1207 Unfix 권한 | ProductionPlanFix.tsx handleUnfix (R2 hasButton('SAVE') false → MSG.NO_PERMISSION) |  | 구현 |
| M5 | MSG00016 cs:1676 Fix confirm(`SaveData_FixInfo`, cs:1570) |  | 해당없음 — `SaveData_FixInfo` 는 호출부 없는 dead code(Fix 경로 미이식, G20). 활성 Unfix confirm 은 M10(cs:1319, `SaveData_FixInfo_U`) — 종전 본 표의 cs:1319/1676 Fix/Unfix 라벨이 뒤바뀌어 있었음(정정) | 해당없음 |
| M6 | MSG00004 cs:1502 Fix 결과(변경없음) |  | 해당없음 — Fix 경로 미이식(G20) | 해당없음 |
| M7 | MSG00003 cs:1511 Fix 실패 |  | 해당없음 — Fix 경로 미이식(G20). Unfix 실패는 M13(useProcMutation 공용 onError) | 해당없음 |
| M8 | (예외) cs:1521 Fix 예외 |  | 해당없음 — Fix 경로 미이식(G20) | 해당없음 |
| M9 | MSG00046 cs:1537 Unfix(활성 경로 SaveData_FixInfo_U) 수집 0건 "삭제할 데이터가 없습니다" | 별도 메시지로 구현하지 않음(2026-10-12 정정) — `buildUnfixPayload` 0건 판정을 V16(R3)의 confirm **이전** 셀선택 가드와 합쳐 MSG.SELECT_CELL 하나로 처리한다(아래 V16 참고). TO-BE 는 "선택은 했으나 수집 0건"과 "아예 미선택"을 구분하지 않는다 | 해당없음(V16 으로 흡수) |
| M10 | MSG00016 cs:1319 Unfix confirm(`SaveData_FixInfo_U`, 활성 경로) = "삭제하시겠습니까?"(cs:1318 주석 실문구) | ProductionPlanFix.tsx handleUnfix (setAlert confirm MSG.CONFIRM_UNFIX=MSG00683 "삭제 하시겠습니까?"/"Do you want to delete it?", ora.py SCM_ADM_MSG_M 실측 — 종전 MSG01438"Release 하시겠습니까?"는 unfix→release 의미 재해석이라 AS-IS 문구와 불일치, 자매 SCP0025 동일 결함 2026-10-02 정정 선례) |  | 구현 |
| M11 | MSG00004 cs:1708 Unfix 변경없음 |  | 해당없음 — cs:1570 구 경로(SaveData_FixInfo) dead code 내부. 활성 경로 수집 0건 안내는 M9(MSG01078) | 해당없음 |
| M12 | MSG00004 cs:1502 Unfix 성공 "{0}개의 데이터가 저장되었습니다"(인자 result_cnt) 후 재조회 FindData_Main(cs:1503). cs:1721 MSG00006 은 dead code(cs:1570 SaveData_FixInfo) 내부라 대상 아님 | ProductionPlanFix.tsx useProcMutation onSuccess (invalidateQueries 재조회 + Toast MSG.SAVED_COUNT=MSG00672 "{0} data saved.", {0}=전송 행 수 payload.length — 공용 onSuccess 가 응답 본문을 주지 않아 ref 로 전달. AS-IS result_cnt 도 SP 의 전송 데이터셋 행 수) |  | 구현 |
| M13 | (예외) cs:1515-1521 Unfix 예외·cs:1507-1512 result_code≠'S' MSG00003 | useProcMutation 기본 onError(error.message Alert). 주의: SAVE SP 가 실패해도 예외 없이 스칼라 OUT(O_RESULT_CODE='F')만 반환하고 BE 가 스칼라 OUT 을 응답에 싣지 않아 현재는 실패가 성공 Toast 로 보일 수 있다 — SP(O_RESULT_CURSOR 전환)·SCM_ADM_PROC_M 변경을 DB 담당자에게 요청함, 적용 후 Unfix 실패 케이스 확인 필요 |  | 구현 |
| M14 | MSG00046 cs:1740 Unfix(구 경로 SaveData_FixInfo) 수집 0건 안내 |  | 해당없음 — cs:1570 SaveData_FixInfo 는 호출부 없는 dead code(활성 경로는 cs:1249 SaveData_FixInfo_U = M9 로 구현) | 해당없음 |
| V15 | MSG00134 cs:1601 Fix(`SaveData_FixInfo`, cs:1570) selCells<1 |  | 해당없음 — `SaveData_FixInfo` 는 호출부 없는 dead code(Fix 경로 미이식, G20). 활성 Unfix selCells 가드는 V16(cs:1312, `SaveData_FixInfo_U`) — 종전 본 표의 cs:1312/1601 Unfix/Fix 라벨이 뒤바뀌어 있었음(정정) | 해당없음 |
| V16 | MSG00134 cs:1312 Unfix(`SaveData_FixInfo_U`, 활성 경로) selCells<1 | ProductionPlanFix.tsx handleUnfix (R3) → `buildUnfixPayload(gridRef.current).length === 0` → MSG.SELECT_CELL. 2026-10-12 재정정: Wijmo FlexGrid 는 itemsSource 바인딩 시 (0,0) 셀을 자동 선택하므로 `grid.selection` 존재(또는 `rows.length>0`) 만으로는 "미선택"을 가릴 수 없다(기본 선택 셀은 날짜 열이 아니라 셀 자체는 항상 "선택됨"으로 보임) — 아무 셀도 고르지 않고 Unfix 를 누르면 가드를 건너뛰고 바로 confirm 이 뜨는 실사용 리포트로 확인. `buildUnfixPayload` 가 Prod Plan 행 × D_/W_ 열만 유효로 치므로 기본 선택 셀은 항상 0건이 되어 confirm 이전에 올바르게 막힌다. 이전 기록(2026-10-07, `rows.length>0`만으로 판정하도록 "정정"했다는 메모)은 실제 코드에 반영된 적이 없는 문서 오기였다(git log 확인) — 삭제하고 이 항목으로 대체 | 구현 |
| V17 | (프레임워크) checkRequiredOfSearch cs:850 — Designer 라벨 '*' 필수(Division*=dz:723 / Operation Group*=dz:734 / Period*=dz:898) 빈값/'ALL' 시 MSG00002 차단 | hooks/useProductionPlanFixValidation.ts validateSearch (divisionId/operationGroupId/from·to 필수 → MSG00429 "{0} value is required." 실측 재매핑 — 구 MSG00002 는 TO-BE "Saved successfully." 오표시) |  | 구현 |
| V18 | (프레임워크) Check_PeriodDate_New(dCalendar,"1","7") cs:855 — 빈 날짜 MSG00049 / from>to MSG00108 (최대구간 검사는 AS-IS 주석 처리) | hooks/useProductionPlanFixValidation.ts validateSearch (빈값=V17 Period 필수로 흡수, from>to → MSG.PERIOD_RANGE=MSG00108) |  | 구현 |

> i18n: MSG 코드는 TO-BE `SCM_ADM_MSG_M` 문구 역매핑(Hook #114, constants.MSG 주석). AS-IS 번호 그대로 하드코딩 금지.
> CONFIRM_FIX=MSG01034 'Do you want to confirm?'(DB 실측, EN/KO 존재) — SCP0024 Fix 경로는 NO-OP 확정(G20)이라 미사용.
> CONFIRM_UNFIX=MSG00683(AS-IS MSG00016 "삭제하시겠습니까?" 문구 일치, 2026-10-07 정정) — 종전 MSG01438 "Release" 는 의미 재해석이라 불일치(자매 SCP0025 2026-10-02 선례와 동일 결함).

## 4. gridSignals (31) — 그리드 동작 파리티 (design 03 §3 R-A~R-I, grid-behavior-parity 게이트)

| 규칙 | signals# | AS-IS | TO-BE | 상태 |
|---|---|---|---|:--:|
| R-A 3-span 기간헤더 + 요일색 | #7~#17 (11) | ColumnHeaderSpan/ForeColor cs:528/535~564 | `buildPivotColumns`(월>주>일 3단) + Grid formatItem(토 Blue/일 Red) | 구현 |
| R-B spdInfo 초기화 | #1/#2 (2) | SmartColMerge/VisibleTab cs:470/471 | 공용 DataGrid 헤더 초기화 | 패턴 |
| R-C 조건부 컬럼 visible(EE) | #3~#6 (4) | ORIGIN_DIVISION_ID/ELECTRODE_TYPE cs:473~482 `!_division.Substring(0,2).Equals("EE")` | `isFixedColumnVisible`(EE_ONLY_COLUMNS × isEeDivision) — 분기식 정확 재현(iter-2 확정) | 구현 |
| R-D SUM 롤업 visible 토글 | #19~#25 (7) | SetSpreadColumn cs:709-757 — DAILY: D_=true·W_/M_=chkSum / WEEKLY: D_=false·W_=true·M_=chkSum / MONTHLY: M_=true·D_/W_=false | `isPivotVisible`(bucket×chkSum) — 본문 대조 결과 3분기 전건 일치(iter-2 확정, iCol 미시매핑 잔여 없음) | 구현 |
| R-E 데이터바인딩 + 전 컬럼 잠금 | #26/#27 (2) | Query/LockColumn cs:895/897 + ReadOnlySheetList cs:415 | `useTabProcQuery` + Grid beginningEdit·pastingCell 전 셀 cancel(G20 사용자 결정 2026-09-26: AS-IS 전 셀 읽기전용 재현 — 편집 band 해제 override 제거) | 구현 |
| R-F 인접 동일값 세로 병합 | #18/#28 (2) | SmartColMerge cs:597/925 | 공용 `allowMerging`+CustomMergeManager(정보/키 12열, pivot 제외) | 구현 |
| R-G 셀 타입 텍스트 | #29 (1) | SetCellTypeText cs:1085 — InitSpreadFixReason 내부인데 호출부(cs:922-923)가 주석 처리된 dead code(iter-2 확정) | Fix Reason 행 D_ 값은 GET SP 가 measure-행으로 직접 반환(구조 대체) | 구현(dead code) |
| R-H FIX_REASON 세팅 | #30 (1) | SetValue cs:1097 — 동일 dead code(호출부 주석) | GET SP MEASURE='Fix Reason' 행 D_ 셀에 반환 + 저장 payload FIX_REASON | 구현(dead code) |
| R-I 더블클릭 드릴다운 | #31 (1) | SetDblClickColumnShowHide(SpreadInfo.cs:10838-10885 본문 확정 — M_ SUM: 월 내 W_ 토글+D_ 숨김 / W_: 주 내 D_ 토글) | `ProductionPlanFixGrid.tsx` dblClickHandler(hitTest ColumnHeader → 월/주 멤버십 토글) | 구현(iter-2) |

## 5. 편집 band (design 03 §3-보강 — SAVE SP 실측) — **폐기(2026-09-26 G20 사용자 결정: AS-IS 전 셀 읽기전용 재현, 아래는 이력 보존)**

- 편집 가능 = D_(일자) × Prod Plan measure 행 QTY 셀만 (`isPivotCellEditable`). W_/M_(SUM 롤업)·Fix Reason 행 잠금.
  - iter-2 G1: iter-1 은 화면 beginningEdit 가 cancel=true 만 설정해 공용 setEditableColumns(SEARCH_ONLY→cancel) 의 잠금을 되살리지 못해 편집 band 도 편집 불가였다. cancel 을 양방향 확정(`e.cancel=!isPivotCellEditable`)해 해소.
  - iter-2 E1: iter-1 의 과거 구간(cutoff=이번주 월요일) 편집잠금·회색은 AS-IS 근거 부재(design 03 §6 #6)라 제거 — 과거구간 처리는 §7 확인필요.
  - iter-3 PASTE1: 화면이 beginningEdit 만 override 하면 공용 setEditableColumns 의 pastingCell 가드가 SEARCH_ONLY 셀을 cancel 해 Excel 붙여넣기가 전건 무동작이었다. 화면 `pastingCell` 를 beginningEdit 과 동일 판정(`e.cancel=!isPivotCellEditable`)으로 override 해 편집 band 붙여넣기 활성 — pastedCell 롤업이 뒤이어 발화(memory dmf0003-paste-qty-blocked-searchonly / datagrid-paste-editability-pastingcell-gap).
- D_ 편집 시 상위 W_/M_ SUM 롤업 재집계(`cellEditEnded`/`pastedCell` → sumValues). 저장 시 변경 D_ 셀만 일자별 unpivot(`buildFixSavePayload`).
- 저장 경로 A `P_SCP0024_SAVE_PLAN_FIX_DS`(JSON) 계약 — ACTIVE_FLAG/MEASURE/YYYYMMDD/QTY/FIX_REASON 등. FIX_MODE(F/U) 마킹.

## 6. toolbarOverride (design 01 §2.4)

| override | AS-IS 본문(iter-2 정독 확정) | TO-BE hotkeyConfig | 상태 |
|---|---|---|:--:|
| FindButton (Search) | 실동작 FindData_Main(cs:605-608) | `search: handleSearch`(항상) | 구현 |
| SaveButton | **NO-OP(본문 주석 `//SaveData()`, cs:636-639)** — AS-IS 는 시트 ReadOnly(cs:415)+SaveButton 무동작이라 화면 내 Fix 저장 경로가 없다 | `save: () => undefined` — G20 사용자 결정(2026-09-26): AS-IS 엄격 재현. 편집 band·Fix 저장 경로 제거, 전 셀 읽기전용. DB 메타(main/SAVE→_DS)는 유지하되 FE 미호출 | 구현(NO-OP 확정) |
| InsertButton | NO-OP(InsertRow 빈 본문, cs:610-613/1059-1061) | `insert: () => undefined`(NO-OP 노출) | 구현(NO-OP 확정) |
| DeleteButton | NO-OP(본문 주석 `//siMain.Delete()`, cs:615-618) | `delete: () => undefined`(NO-OP 노출) | 구현(NO-OP 확정) |
| EditButton | MSG00109 안내 후 return(SwitchLock 주석, cs:621-634) | (Hotkeys enum 에 edit 슬롯 부재 — 팬텀 없음. §3 M1 제외 근거 참조) | 제외(§11 + AS-IS 확정) |
| ExcelButton | 실동작 SimplexelService.ExportFpSpread(cs:665-698) | SubTitle 공통 excel export(excelFileName) | 구현(패턴) |

## 7. 확인 필요 / 한계 (gap-resolve iter-2 재판정 — `.cs` 정독으로 1·2·3·5·8 해소, 침묵 누락 없이 명시)

1. (해소, iter-2) toolbarOverride 본문 전건 확정 — §6 표 참조(Insert/Delete=NO-OP, Edit=MSG00109 안내, Save=NO-OP 주석, Excel=실동작).
2. (해소, iter-2) F3/F4 Line 술어 원식 확정 — EE=DIVISION_ID+OPERATION_GROUP+SITE_ID(cs:807) / 비EE=DIVISION_ID+SITE_ID(cs:812). Form 재현 완료.
3. (해소, iter-2) EE/비EE 분기식 확정 — `Substring(0,2)=="EE"`(cs:779/789/805) = isEeDivision 정확 재현.
4. btnWLast — 사용자 지시(2026-10-06)로 W26/W52/WLast 개별 버튼을 삭제하고 공용 `PeriodRangePicker` 를 사용한다. AS-IS GetLastRange 동작(cs:436-444 반환값이 '52'면 숨김, cs:1226-1246 라벨 숫자 파싱 → GetDayRange)은 재현하지 않으며, SP(`SCM0001_GET_SCP_DAILY_PLAN_PERIOD`)도 미배포(ora.py 2026-09-25, all_procedures 0건)라 배선 대상이 없다.
5. (해소, iter-2) R-D 3분기 본문 일치·R-G/R-H dead code·R-I 드릴다운 구현 — §4 표 참조.
6. 저장 경로↔버튼 배선·PROC_M 파라미터 메타 — convert-sp 후속(design 03 §6 #7). AS-IS 활성 Unfix 는 dataset SP(`SaveProductionPlanFix`/SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET, cs:1487-1494)를 타며 TO-BE _DS SP 가 그 대응(JSON). _DS 문서키(PLAN_START_YYYYMMDD/PLAN_TYPE/SEQ)는 AS-IS 도 컬럼만 정의하고 값 미설정(cs:1266-1268 vs 1392-1406) — 현행 FE 미전송이 정합(DAILY 매칭키 무영향, iter-1 G7).
7. CONFIRM_FIX(MSG) — iter-2 해소: MSG01034 'Do you want to confirm?'(DB 실측) 재매핑 완료.
8. (해소, gap-resolve iter-2) 과거 구간(cutoff) 편집잠금 — AS-IS 정독 결과 FindData_Main/InitSpread 어디에도 cutoff 잠금·회색 로직이 없다(전 컬럼 LockColumn 뿐, cs:897). E1 제거가 AS-IS 정합으로 확정.
9. 브라우저 시각·조작감(3-span 헤더 렌더·요일색·병합 시각·편집 band 잠금 UX·드릴다운 토글·toast) — 사용자 확인 축(미확인).
10. (해소, 2026-09-26) G20 — 사용자 결정: AS-IS 엄격 재현 채택. SAVE=NO-OP(노출 유지 무동작)·편집 band 제거·전 셀 읽기전용·Fix 저장 경로 제거(§5 폐기, Unfix 만 활성 쓰기). `buildFixSavePayload`/`validateSave`/`isPivotCellEditable` 은 미호출 상태로 보존(Fix 확정 화면 SCP0013 참조용 _DS 계약 문서).

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다(gap-resolve iter-1 에서 축 추가).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — 자유 Insert 기능 없음 (fix/unfix 모델, hotkeyConfig insert=()=>undefined NO-OP, ProductionPlanFix.tsx:186; 그리드 행은 GET SP 반환분만) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | 공용 위임 — SearchArea(ProductionPlanFixForm.tsx:173 onSearch)·SubTitle(ProductionPlanFix.tsx:208) 조회가 packages/shared SearchArea.tsx:115·SubTitle.tsx:198 confirmIfDirtyKey('search') 로 감싸지고, 공용 DataGrid(useDirtyRegistry)가 D_ 편집 dirty 를 자동 등록 — 화면 배선 불요 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 해당없음 — 이 화면은 Column/Measure 설정 모달 미사용(SubTitle customButtons=Unfix만, design §3). admin 메타(fetchStaticColumns/Measures)는 mount·Search 시 fetch 로 소비하며 사용자 설정 UI 없음 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ProductionPlanFix.tsx useProcMutation onSuccess (Unfix 저장 → 재조회 + 건수 Toast, 수동 apiClient.post 미사용) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ProductionPlanFix.tsx:213 (SubTitle excelFileName='ProductionPlanFix' — gridAction dataMap 승계). 고정 컬럼은 admin 메타로 코드(OPERATION_GROUP/SCM_SITE_ID) hidden + NAME 컬럼 표시(columns.ts buildFixedColumns) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useProductionPlanFixStore.ts:110~115 (plantSite/line/electrode 다중 → joinOrEmpty(arr)=arr.join(',') 로 GET SP STRING_SPLIT 전달; itemId txtItemId key-in) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ProductionPlanFixGrid.tsx:188~199 (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장, gridFilterRef 전달, 화면 배선 불요) |  | 구현 |
