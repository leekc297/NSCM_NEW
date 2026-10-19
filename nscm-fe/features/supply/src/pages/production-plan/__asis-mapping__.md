# SCP0011 Production Plan — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0011_ProductionPlan/SCP0011_ProductionPlan.cs(+Designer)`
namespace `GSCM.SCP.Analysis.UIL`. 설계 정본: `.atlas/gscm-design/SCP0011/design/00~03`. 자매 선례: SCP0013.

## 전환 판정
- **신규(NEW)** — nscmPath `features/supply/src/pages/production-plan/`. MNU 미등록이라 ROUTE_PATH 폴백 불가,
  트리 탐색 결과 페이지 소스 부재(goal.md ①). ROUTE_PATH=`supply/production-plan` 로 05_register.sql 에서 확정.
- 화면 유형: master-detail 2 pivot 그리드 + 동적 기간열(D_/W_/M_) + cascade 콤보 + Amend. 자매 SCP0013
  (단일 pivot)의 pivot/편집잠금/derive 유틸을 이식하고 master-detail·Amend·EE 콤보만 추가 구현.

## 영역1 (01_layout) 동적 규칙
| AS-IS | TO-BE | 비고 |
|---|---|---|
| btnCal "Calculate"(btnRun) Amend | SubTitle customButtons 'Calculate' → `handleAmend` | R1 가드: 권한(대리 SAVE) → 조회조건 필수 → MSG00206 confirm → AMEND proc → 재조회 |
| EditButton 편집모드 토글(SwitchLock/LockRange) | **미이식**(convert-core §2.4) | editMode/setEditMode state 금지. `canEdit=hasButton('SAVE')` 1회(iter-2 H1 — EDIT 버튼코드 미등록·AS-IS CanUpdate↔SAVE 패리티, 자매 SCP0013 선례). 셀단위 편집은 productionPlanEditLock |
| InsertButton override `//InsertRow();` | `insert: () => undefined` | NO-OP, 버튼 노출(false·키생략 금지, R-A3) |
| DeleteButton override `//siMain.Delete();` | `delete: () => undefined` | NO-OP (R-A4) |
| FindButton | `handleSearch`(setFilter) | 실동작 |
| SaveButton→SaveData_Line | `handleSave`→`mutateLine`(LINE/SAVE) | 변경 D_ 셀 음수검증 후 저장, 성공 시 재조회 |
| btnMeasure(SCM0002_TitleSetForm_Popup) | SubTitle `IcMeasureSelect` → `MeasureSelectModal` | visibleMeasures 로 LINE 행 필터(TitleSet 표시 토글) |
| usrButton1 | **미이식(dead)** | Designer 미배치·Click 미배선 orphan (01_layout R6) |

## 영역2 (02_search-combo) 콤보 — 서버-파라미터 cascade(재조회)
| 조건 | TO-BE comboId | 파라미터 | 비고 |
|---|---|---|---|
| Division | MyDivisionInEE_SCP | @mnuId(withMenuId 자동)·@sesUserId(BE) | 권한 division |
| Operation Group | EE? OperationGroupEE_SCP : OperationGroup_SCP | 없음 | EE 여부로 comboId 스왑(convert-core §2.6) |
| Plant Site(다중) | EE? PlantSiteProdPlan_SCP : PlantByDivisionOperation | EE=@segment2=운영그룹/@attribute2=사업부 · 비EE=@divisionId/@operationGroup | iter-2 M1 — DB 실측(EE_PRODUCTION_PLAN lookup)로 토큰 확정, 스왑 정정 |
| Model(Item) 팝업 division | ItemByDivisionModal preSearchParams.divisionId | `divisionForItemPopup` (EE→UC/EE 제외 실사업부 CODE 결합) | iter-2 M5 — AS-IS UIUtils.GetAllDivisionCheckedElectrode 재현 |
| Electrode(다중) | LookupCommon | @lookupType=ELECTRODE_TYPE | EE 사업부만 enable |
| Plan Date | DATE_WEEKLY | @divisionId | 최신(idx0) 자동선택 |
| Plan Type | PlanType | @divisionId/@planStartYyyymmdd | 마지막 자동선택 |
| Seq | PlanSeq | @divisionId/@planStartYyyymmdd/@planType | 첫 항목 자동선택 |
| Model(Item) | txtItemId + `ItemByDivisionModal` | preSearchParams: division+plantSite | 팝업 결과 → itemId |
| Nick Name | txtNickName | — | p_nick_name 단순 텍스트 |
| Period | PeriodRangePicker | GetDayRange(W52) from=planDate | design 02 §2.8 |
| PERIOD 동적콤보(#10/#11) | **미이식(dead code)** | — | SetChangedPeriod 호출부 전부 주석(02 §2.9) |

## 영역3 (03_grid-columns) 그리드 — gridSignals 67 → 유틸 이식
| R | AS-IS | TO-BE | 파일 |
|---|---|---|---|
| R1 SmartColMerge | 고정컬럼 세로병합 | CustomMergeManager (pivot 제외 allowMerging) | ProductionPlanGrid |
| R2 EE 컬럼 visible | ORIGIN_DIVISION_ID/ELECTRODE_TYPE | eeOnly → isFixedColumnVisible | editLock/columns |
| R5 수치셀 | SetReNumerCellType 0~99999999 | pivot 컬럼 format 'n0' + 음수검증 | columns/page |
| R6 토/일 색 | 2단 헤더 토=Blue/일=Red | formatItem DAYOFWEEK | ProductionPlanGrid |
| R7 3단 헤더 span+SUM | ColumnHeaderSpan | buildPivotColumns(월>주>leaf) | columns |
| R8 SUM 열 잠금 | W_/M_ 비편집(D_ 전용) | editablePivotKindForBucket→상시 'D'(iter-2 M3 — §2.5/R8) | editLock |
| R9/R10 조회후 전열잠금→편집구간 unlock | LockColumn→LockRange | beginningEdit cancel=!isPivotCellEditable | ProductionPlanGrid |
| R12 Bucket/Sum 가시성 | SetSpreadColumn | isPivotVisible(bucket×chkSum) | editLock |
| R13 소수2 | SetDecimal | 비율 measure formatItem toFixed(2) | ProductionPlanGrid |
| R15 음수차단 | MSG00084 | handleSave D_ 음수 검사 | ProductionPlan |
| R16 LINE_TOTAL<100 적색 | MarkedForeColor | formatItem < 100 → red | ProductionPlanGrid |
| R17 과거/실적 회색 | SetBGColor2 | isPastPivot → PAST_GRAY | ProductionPlanGrid |
| R18/R19 헤더 더블클릭 접기 + chkAll 게이트 | SetDblClickColumnShowHide (cs L3042-3053 !chkAll 가드) | toggleDrilldown(..., chkAll) — chkAll 체크박스(iter-2 M4) | drilldown/Form |
| R19 편집모드 lock 토글 | SwitchLock/전체잠금 | **미이식**(§2.4 — 셀단위 판정으로 치환) | editLock |
| §2.4 W_/M_ SUM 파생 | CalculateSum | distributeWeeklyToDaily/sumValues, 비율=applyRatio(O_RC3/O_RC4) | derive |
| §2.5 편집가능 4조건 | EditButton+GET_PLAN_EDIT_INFO | isPivotCellEditable(measure+kind+과거+is_editable) | editLock |
| §4.2 master drill | SpdMain_CellDoubleClick | onRowDoubleClick → setLineFilter(LINE GET) | ProductionPlanGrid/page |

## 미이식 근거(필수 기록)
- **EditButton 편집모드**: convert-core §2.4 — editMode state 금지. 편집가부는 서버 GET_PLAN_EDIT_INFO +
  PlanType 규칙(마지막 아님/FN/TE)으로 셀단위 판정(productionPlanEditLock.isRowEditable).
  - **편집 권한축 = SAVE(iter-2 H1)**: AS-IS 편집가부는 CanUpdate 단일권한이고 EDIT 버튼코드는 이 화면
    버튼셋에 미등록(ora.py 실측 SEARCH/SAVE 뿐). `canEdit=hasButton('EDIT')`는 전 사용자 상시 false(편집 死).
    EDIT 임의등록 대신 SAVE 게이트로 전환(자매 SCP0013 동일 선례, AS-IS CanUpdate↔TO-BE SAVE).
- **usrButton1 / PERIOD 동적콤보 / B_ 텍스트열**: dead code (01 R6 / 02 §2.9 / 03 §2.1 — TO-BE 캘린더 SP 미반환).
- **스크롤 동기(TopChange)·bucket 변경 그리드 clear(iter-2 L4)**: 구조적 대체로 수용 — bucket 변경 시 서버
  재조회 없이 클라 pivot 가시성 재계산(동일 결과), 스크롤 동기는 UX 저위험 미이식.
- **MSG 매핑(iter-2 M2/L1)**: 저장 성공은 useProcMutation 기본(MSG00002), 무변경은 NO_CHANGES(MSG00004).
  Amend 확인은 MSG00206(TO-BE 미등록)→MSG01217(동일 의미 TO-BE 실측)로 remap.

## 메타 (05_register.sql)
- 2.7 메뉴: MNU_SCP0011(KO/EN/CN) + SCM_ADM_MNU_M(ROUTE_PATH=supply/production-plan) + GR_MNU(ADMIN/SCP Planner) — 등록·적용·확인 완료.
- 2.8 버튼/권한: MNU_BTN 8행 + GR_MNU_BTN 16행 — 등록·적용·확인 완료. API_M 7행 = 기등록 확인만.
- 2.75 컬럼/Measure, 2.76 콤보 = 전건 기등록 확인만(INSERT 없음).
- **PROC_M(파라미터 바인딩)**: 7 proc 전건 등록됨(DB 실측). 과거 비관습 등록(GET OUT 커서 COL_NM=model/line/editInfo, SAVE cell-level CLOB, AMEND)이 런타임 데이터패스 결함(04 H1~H3)이었으나 **2026-10-12 재실측상 해소** — GET OUT 커서 전부 o_rc1·AMEND 6 IN JVARCHAR 재등록 + SAVE(17 CLOB)는 FE submitLineSave 로 정합. 상세: `04_impl-gap-audit.md` ⓪.
