# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init · 대사: convert-gap-resolve iter-1 (2026-09-25)
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> TO-BE 경로 약칭: Page=`ShipmentWorkingDayOsp.tsx` · Form=`components/ShipmentWorkingDayOspForm.tsx` · Grid=`components/ShipmentWorkingDayOspGrid.tsx` · Store=`useShipmentWorkingDayOspStore.ts` · Dyn=`shipment-working-day-osp.dynamic-columns.ts` · Const=`shipment-working-day-osp.constants.ts` · Hook=`hooks/useShipmentWorkingDayOspInputValue.ts`(2026-10-20 분리 — AS-IS BtnInput_Click 본문 1:1).
> AS-IS 정본: `SCP0096_Shipment_Working_Day_OSP.cs`(읽기전용, 852라인) — 라인은 00_checklist/03_grid-columns 실측.
> 2026-10-20 2차 보완(원장 `REQ:CHAT-20261020-S96-8~16`): PKG.sql 사내 미러 복원·GTT DDL · 메시지 코드 TO-BE 실측 재배선 · Period 필수 · WORKING_TIME_DEFAULT 0~7 정수 · 저장 커서 키 소문자+MSG00672 · Sum 비노출 · INPUT_TP_CD 메타 위임 · __tests__ · e2e_plan 갱신. 행은 추가·갱신만(M06).
> 2026-10-20 보완(원장 `REQ:CHAT-20261020-S96-1~7`): 초기기간 서버 dayRange 소비(D00-2-008·D00-4-006) · Insert/Delete false(CRUD) · §4 엔드포인트 행 추가(D00-4-004~007) · btnInput 행 Hook 경로 갱신. 커밋본 97행 위에 추가만(M06).

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 cboDivision / UsrCombo | Form:124-144 (Division CustomDropdown, Division_SCP_NoEE 서버 ATTRIBUTE3<>'EE' 필터 :60) |  | 구현 |
| D00-1-002 | §1 clbPlantSite / UsrCheckedList | Form:145-147 (multi() Plant Site 다중선택, PlantByDivisionOperOsp3_SCP cascade :48-51) |  | 구현 |
| D00-1-003 | §1 cboDayWeek / UsrCombo | Form:157-172 (Day of the week CustomDropdown, lookup WEEK_WORK_TIME :57,72-75) |  | 구현 |
| D00-1-004 | §1 cboInputValue / UsrCombo | Form:174-188 (Input Value CustomDropdown, YesOrNo :69, disabled={isDayWeekEmpty}) |  | 구현 |
| D00-1-005 | §1 chkSum / UsrCheckBox | Page:79-80(주석)·377 showSum={false} / Grid:200-217(SUM 열 코드 비활성 보존) | AS-IS Designer `this.chkSum.Visible = false`(:346) — 사용자에게 보이지 않는 컨트롤 + AS-IS MSSQL SP·사내 Oracle GET SP 모두 D_ 일자열만 PIVOT(W_/M_ SUM 열 미생성) = 살아있는 동작 없음(#138, feedback_asis_delta_apply_criteria). 2026-10-20 2차 보완(원장 S96-13): Sum 커스텀 버튼 제거, Grid SUM 처리 코드는 showSum=false 로 비활성 보존 | 제외 |
| D00-1-006 | §1 dCalendar / UsrDateRangePicker3 | Form:148-155 (PeriodField start/end) |  | 구현 |
| D00-1-007 | §1 btnInput / UsrButton | Form:189-200 (Input Button, onClick=onInput, disabled={isDayWeekEmpty}) |  | 구현 |
| D00-1-008 | §1 spdMain / FpSpread | Grid:360-367 (공용 DataGrid — FlexGrid 직접 금지 hook#10) |  | 구현 |
| D00-1-009 | §1 spdMain_Sheet1 / SheetView | Grid:360-367 (DataGrid 단일 시트 itemsSource=data) |  | 구현 |
| D00-1-010 | §1 usrConditionPanel1 / UsrConditionPanel | Form:118-202 (SearchArea 조회조건 패널) |  | 구현 |
| D00-1-011 | §1 usrButton1 / UsrButton | Page:324-331,358-367 (hotkeyConfig + SubTitle 공통버튼 컨테이너 — SEARCH/SAVE · Insert/Delete false · customButtons 없음) | AS-IS 컨테이너 버튼그룹 → SubTitle 로 흡수 | 구현 |
| D00-1-012 | §1 usrLayoutControl2 / UsrLayoutControl | Form:117-202 (SearchArea 레이아웃) | AS-IS DevExpress 레이아웃 컨테이너 = TO-BE SearchArea/Grid 로 대체(레이아웃 프리미티브는 화면 요소 아님) | 제외 |
| D00-1-013 | §1 layoutControlGroup2 / LayoutControlGroup | — | AS-IS DevExpress 레이아웃 그룹 컨테이너 — 표현 전용, TO-BE Grid size 로 흡수(비즈니스 신호 아님) | 제외 |
| D00-1-014 | §1 components / Container | — | WinForms 디자이너 IContainer(비가시 컴포넌트 컨테이너) — UI 신호 아님 | 제외 |
| D00-1-015 | §1 layoutControlItem1 / LayoutControlItem | — | DevExpress 레이아웃 아이템(래퍼) — 실제 컨트롤은 §1 개별 행에 대사됨, 래퍼는 표현 전용 | 제외 |
| D00-1-016 | §1 layoutControlItem2 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-017 | §1 layoutControlItem3 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-018 | §1 layoutControlItem4 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-019 | §1 layoutControlItem7 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-020 | §1 layoutControlItem10 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-021 | §1 layoutSum / LayoutControlItem | — | chkSum(D00-1-005) 배치 래퍼 — chkSum 자체가 Designer Visible=false(:346) 비노출이라 래퍼도 화면 요소 아님(2026-10-20 정정) | 제외 |
| D00-1-022 | §1 emptySpaceItem1 / EmptySpaceItem | — | DevExpress 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-023 | §1 emptySpaceItem2 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-024 | §1 emptySpaceItem3 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-025 | §1 emptySpaceItem4 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-026 | §1 emptySpaceItem5 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-027 | §1 emptySpaceItem6 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-028 | §1 emptySpaceItem9 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-029 | §1 emptySpaceItem10 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-2-001 | §2 cboDivision / SelectedIndexChanged (.cs) | Form:135-140 (onChange → setSearchParams{divisionId,plantSiteIds:[]} + onDivisionChange resetGrid) |  | 구현 |
| D00-2-002 | §2 clbPlantSite / SelectedIndexChanged | Form:145-147 (multi onPick → setSearchParams{plantSiteIds}) |  | 구현 |
| D00-2-003 | §2 cboDayWeek / SelectedIndexChanged (.cs:669-681) | Form:166-168 (onChange → dayWeekCode) → isDayWeekEmpty(:80) enable 토글 InputValue/Input |  | 구현 |
| D00-2-004 | §2 chkSum / CheckedChanged (.cs:324-337) | Grid:210 (visible: showSum — 부모 Page:377 가 항상 false) | AS-IS Designer `this.chkSum.Visible = false`(:346) — 사용자에게 보이지 않는 컨트롤 + AS-IS MSSQL SP·사내 Oracle GET SP 모두 D_ 일자열만 PIVOT(W_/M_ SUM 열 미생성) = 살아있는 동작 없음(#138, feedback_asis_delta_apply_criteria). 2026-10-20 2차 보완(원장 S96-13): Sum 커스텀 버튼 제거, Grid SUM 처리 코드는 showSum=false 로 비활성 보존 | 제외 |
| D00-2-005 | §2 btnInput / Click (.cs:684-809) | Hook:46-128 (useShipmentWorkingDayOspInputValue — 가드 5 + 3분기 SetText, 메시지 코드 TO-BE 실측으로 2026-10-20 정정) ← Page:335-343 배선 |  | 구현 |
| D00-2-006 | §2 spdMain / CellDoubleClick (.cs:817-819) | — | SetDblClickColumnShowHide(컬럼 접기/펼치기) — D00-3-032 와 동일 신호, AS-IS 부가기능(핵심 CRUD 무관)으로 미이식. 향후 요구 시 재설계 | 제외 |
| D00-2-007 | §2 spdMain / TopChange (.cs) | Grid:69,286-333 (다단 헤더 총높이 rAF 상시 정규화 — 스크롤/레이아웃 변동 시 머지헤더 재적용) | AS-IS TopChange SmartColMerge 재적용 = TO-BE wijmo mergeManager 상시 유지(스크롤 sticky)로 대체 | 구현 |
| D00-2-008 | §2 this / Load → Form_Load (.cs:103,107-114: InitForm·InitControls·DefineProperty·CreateSpread·InitEvent) | Page:143-150 (mount useEffect — clearFilters·fetchStaticColumns·restoreSearchConditions = InitForm/컬럼 메타) + Page:91-113 (dayRange 쿼리·1회 적용 effect = InitControls `dCalendar.InitValue = GetDayRange()` .cs:137) + Store:56-80 (초기값: divisionId 세션 · dayWeek SelectDay · initPeriod placeholder) + Page:79-80(DefineProperty chkSum.Checked=false .cs:121 = SUM 항상 숨김) + Form 콤보 로드(= setListBox .cs:130-132) + Grid 핸들러 등록(= InitEvent/CreateSpread) | 2026-10-20 추가(G03). GetBucketType(.cs:136) 은 D00-4-007 제외 | 구현 |
| D00-3-001 | §3 SetReNumerCellType / 163 (WORKING_TIME_DEFAULT 소수 0 · 최소 0 · 최대 7) | Grid:106,131 (편집형 = admin INPUT_TP_CD 'O' 위임) + Page:245-265 (저장 직전 정수·0~7 범위 판정 MSG00460/MSG01037, Const:153 WTD_RANGE) | 2026-10-20 2차 보완(원장 S96-8): 이전엔 편집형 선언만 있고 0~7 정수 제약이 없었다. 사내 SAVE SP F_TO_NUM 은 범위 미검사 | 구현 |
| D00-3-002 | §3 SmartColMerge / 162 (spdInfo 제목시트) | Grid:138-185 (3단 머지헤더 group 구성 — 제목/헤더 시트 병합을 wijmo columnGroups 로 재현) |  | 구현 |
| D00-3-003 | §3 ForeColor= / 205 (요일 헤더색) | Grid:234-237 (formatItem ColumnHeader 토=#1e56c8/일=#c0392b, weekdayByBinding) |  | 구현 |
| D00-3-004 | §3 ColumnHeaderSpan / 212 | Grid:177-185 (dayGroups 월→주차→일 3단 span) |  | 구현 |
| D00-3-005 | §3 ColumnHeaderSpan / 213 | Grid:177-185 (월 대헤더 span) |  | 구현 |
| D00-3-006 | §3 ColumnHeaderSpan / 218 | Grid:180-184 (주차 소헤더 span) |  | 구현 |
| D00-3-007 | §3 ColumnHeaderSpan / 219 | Grid:180-184 (주차 소헤더 span) |  | 구현 |
| D00-3-008 | §3 ColumnHeaderSpan / 227 | Grid:188-202 (SUM 열 헤더 — W_/M_ sumGroups) |  | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / 228 | Grid:188-202 (SUM 열 헤더 span) |  | 구현 |
| D00-3-010 | §3 ColumnHeaderSpan / 238 | Grid:138-185 (일 pivot 헤더 span 분기) |  | 구현 |
| D00-3-011 | §3 ColumnHeaderSpan / 239 | Grid:138-185 (주 pivot 헤더 span 분기) |  | 구현 |
| D00-3-012 | §3 ColumnHeaderSpan / 240 | Grid:138-185 (월 pivot 헤더 span 분기) |  | 구현 |
| D00-3-013 | §3 ColumnHeaderSpan / 241 | Grid:286-333 (3단 헤더 총높이 60px 불변식 정규화) |  | 구현 |
| D00-3-014 | §3 SmartColMerge / 258 (좌측키 세로병합) | Grid:119 (fixed=c.fixed admin 위임) + DataGrid 좌측 키 컬럼 병합(WorkingTimeGrid 1:1) |  | 구현 |
| D00-3-015 | §3 SwitchLock / 286 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-016 | §3 LockColumn / 288 (키 3컬럼 잠금) | Grid:51-56,139-142,222-223,268-275 (INPUT_TP_CD 'S' → editableStaticBindings 제외 → beginningEdit e.cancel; 사내 메타 DIVISION_ID~PLANT_SITE_NAME 'S') | 2026-10-20 2차 보완(원장 S96-14): 리터럴 EDITABLE_STATIC_BINDING → admin INPUT_TP_CD 단일 원천 | 구현 |
| D00-3-017 | §3 LockColumn / 289 (LAST_INPUT_DATE~MEASURE 잠금) | Grid:106,131 (admin INPUT_TP_CD 'S' 그대로 SEARCH_ONLY) + isEditableBinding 제외 → 잠금 |  | 구현 |
| D00-3-018 | §3 Visible= / 347 (D_/W_ 항상표시) | Grid:168 (D_ leaf visible:true) | W_ 열은 GET SP 가 만들지 않음(AS-IS·Oracle 동일) — D_ 만 해당 | 구현 |
| D00-3-019 | §3 Visible= / 352 (chkSum SUM 토글) | Grid:210 (sumGroups visible: showSum — 항상 false) | AS-IS Designer `this.chkSum.Visible = false`(:346) — 사용자에게 보이지 않는 컨트롤 + AS-IS MSSQL SP·사내 Oracle GET SP 모두 D_ 일자열만 PIVOT(W_/M_ SUM 열 미생성) = 살아있는 동작 없음(#138, feedback_asis_delta_apply_criteria). 2026-10-20 2차 보완(원장 S96-13): Sum 커스텀 버튼 제거, Grid SUM 처리 코드는 showSum=false 로 비활성 보존 | 제외 |
| D00-3-020 | §3 LockColumn / 405 (spdInfo 제목시트 잠금) | — | 제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님) — 구조적으로 편집 불가 | 제외 |
| D00-3-021 | §3 Query / 470 (FindData_Main 조회) | Page:117-123,181-188 (useTabProcQuery GET SP + handleSearch invalidateQueries) |  | 구현 |
| D00-3-022 | §3 LockColumn / 472 (조회 직후 전열 잠금) |  | 미이식(2026-09-29, convert-core §2.4 규범 준수) — 조회 직후 개별 잠금 호출 없음. Grid 는 `editMode`(=`canEdit` 권한) off 일 때 전 셀 잠금(권한 없으면 읽기전용) 으로 동등 대체 | 제외 |
| D00-3-023 | §3 SmartColMerge / 477 (조회 후 재병합) | Grid:297-345 (조회 후 updatedLayout rAF 로 머지헤더 재적용) |  | 구현 |
| D00-3-024 | §3 Get / 683 (Columns.Get(0).Visible 조회 전 차단) | Hook:47-50 (가드 #1 !hasSearched → MSG00662 "조회 후 수정모드로 가능합니다") | AS-IS MSG00135 원문("수정모드가 아니므로 입력할 수 없습니다")은 TO-BE 에서 다른 본문이라 의미 동일 코드로 치환(2026-10-20, 원장 S96-10) | 구현 |
| D00-3-025 | §3 GetModelColumnFromViewColumn / 734 | Hook:86-94 (writeCell — g.columns[col].binding 로 뷰열→모델 binding 변환) |  | 구현 |
| D00-3-026 | §3 GetModelColumnFromViewColumn / 735 | Hook:86-94 (writeCell 좌표→binding 변환, dataItem 조회) |  | 구현 |
| D00-3-027 | §3 SetText / 744 (SelectDay 선택셀 기입) | Hook:96-109 (isSelectDay 선택영역 D_ 셀 writeCell) |  | 구현 |
| D00-3-028 | §3 SetText / 758 (SelectDay 기입 지점2) | Hook:104-109 (선택영역 중첩루프 writeCell) |  | 구현 |
| D00-3-029 | §3 SetText / 771 (SelectDay 기입 지점3) | Hook:86-94 (writeCell setCellData + tracker.storeChange) |  | 구현 |
| D00-3-030 | §3 SetText / 789 (EveryDay 전행 D_) | Hook:109-120 (isEveryDay → 전행×전 D_ 컬럼 writeCell) |  | 구현 |
| D00-3-031 | §3 SetText / 797 (요일별 매칭 D_) | Hook:116-117 (dayCol.weekday===targetWeekday 매칭 셀만 writeCell) |  | 구현 |
| D00-3-032 | §3 SetDblClickColumnShowHide / 819 | — | 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식. 향후 요구 시 재설계 | 제외 |
| D00-4b-001 | §4b Data_SCP.Common / MyDivisionInEE / dtMyDivision | Form:54-55,60 (COMBO.DIVISION=Division_SCP_NoEE, 서버 ATTRIBUTE3<>'EE' 필터) |  | 구현 |
| D00-4b-002 | §4b Data.Common / LookupCommon / dtDayWeek | Form:57,72-75 (useTabLookupQueries DAY_WEEK_LOOKUP=WEEK_WORK_TIME) |  | 구현 |
| D00-4b-003 | §4b Data.Common / YesOrNo / dtValidYN | Form:54-55,69 (COMBO.INPUT_VALUE=YesOrNo) + Grid:161 D_ 셀 dataMap DAY_CELL_DATA_MAP(Y/N) |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / PlantByDivisionOperOsp3 / dtPlantSiteByDivision | Form:48-51,54-55,66 (COMBO.PLANT_SITE=PlantByDivisionOperOsp3_SCP, divisionId cascade 재조회) |  | 구현 |
| D00-4-004 | §4 SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP / SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (FindData_Main .cs:457-467, IN 4 + debug_mode) | Store:118-134 setFilters(divisionId/plantSiteId/fromYyyymmdd/toYyyymmdd = 사내 PROC_M COL_NM) + Page:117-123 useTabProcQuery MAIN → 사내 배선 SEARCH→P_SCP0096_GET→PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP(6인자) | debug_mode 는 As-is PRINT 전용 — 사내 PROC_M 미등록(2026-10-19 결정) | 구현 |
| D00-4-005 | §4 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN / SCP0009_GET_SHEET_CALENDAR_3SPAN (GetSpdTitle .cs:825-838 — 3단 헤더 타이틀) | Dyn:23-59 buildDynDayColumns/buildDynSumColumns + Grid:138-205 (월/주/일 3단 머지헤더·요일색을 GET O_RC1 alias D_yyyymmdd/W_/M_ 에서 FE 파생) | 사내 배선(calendar/SEARCH → PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)은 존재하나 FE 미호출 — 동일 조회구간의 헤더를 데이터 커서 alias 로 1회 호출에 흡수(SCP0019 동형) | 구현 |
| D00-4-006 | §4 SCP.SCM0001_GET_SCP_MONTH_PERIOD (InitControls GetDayRange .cs:137,840-846 → DateUtil.GetDayRange(cboDivision,'DAILY') DateUtil.cs:330 — flow.csv 미수록 프레임워크 유틸) | Const:22 SHEETS.DAY_RANGE + Page:91-113 (dayRangeFilters IN 5 = PROC_M COL_NM · useTabProcQuery · o_rc1[0].PERIOD 1회 적용) + Store:25,56-68,184,193-201 (dayRangeApplied·placeholder·applyDayRange) → 사내 배선 dayRange/SEARCH → SCM0001_SCP_MONTH_PERIOD_GET → PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD | 2026-10-20 추가(원장 S96-1). 사내 실측 '20261020:20271017' | 구현 |
| D00-4-007 | §4 DM.DM0003_GET_BUCKET_TYPE_CODE / DM0003_GET_BUCKET_TYPE_CODE (GetBucketType .cs:136,388-399) | — | dtBucketType 은 InitControls 에서 적재만 되고 소비 코드(cboBucketType_SelectedIndexChanged .cs:304-318 미배선 · SetSpreadColumn 분기 .cs:346-384 주석)가 전부 죽어 있음 — 살아있는 동작 없음(#138). PKG_SCP0096.P_DM0003_GET_BUCKET_TYPE_CODE 는 2026-10-19 이식분 보존(미호출) | 제외 |
| D00-4d-001 | §4d BtnInput_Click 가드 #1 조회 전(AS-IS MSG00135) | Hook:47-50 (!hasSearched → MSG.NOT_SEARCHED=MSG00662, Const:89) | TO-BE MSG00135 본문은 "편집 모드에서는 이 기능을 사용할 수 없습니다"(다른 메시지)·MSG00134/MSG00050 미등록 — SCM_ADM_MSG_M 실측으로 재배선(2026-10-20, 원장 S96-10) | 구현 |
| D00-4d-002 | §4d BtnInput_Click 가드 편집모드 아님(AS-IS MSG00135) | Hook:52-57 (!canEdit → MSG.NOT_EDIT_MODE=MSG01154 "수정모드가 아니므로 입력할 수 없습니다" alert, Const:91) | 2026-10-20 정정(원장 S96-11): 이전 무메시지 return 은 AS-IS(메시지 표시)와 달랐다. TO-BE 원문 동일 코드 사용 | 구현 |
| D00-4d-003 | §4d BtnInput_Click 가드 DayWeek 미선택(무메시지) | Form:195 (btnInput disabled={isDayWeekEmpty} — 값 없으면 클릭 차단, AS-IS :710-713 return) |  | 구현 |
| D00-4d-004 | §4d BtnInput_Click Input Value 값 검증(Y/N) | Hook:61-69 (INPUT_VALUE_SET 밖(미선택 ''·오염) → MSG.REQUIRED_VALUE=MSG00429 "{0} 값은 필수 입력 항목입니다" {0}=Input Value) | AS-IS 는 콤보라 형식검증 없이 빈값도 SetText(.cs:696) — TO-BE 는 빈 Y/N 셀 적재 방지로 선택 요구. 이전 MSG00050 은 TO-BE 미등록 코드(2026-10-20 정정) | 구현 |
| D00-4d-005 | §4d BtnInput_Click 가드 #4 SelectDay 선택셀0(AS-IS MSG00134 "날짜 선택 후 입력하세요") | Hook:99-103 (isSelectDay sel 없음 → MSG.NO_CELL_SELECTED=MSG01153 원문 동일, Const:93) + Hook:122-126 (선택영역에 D_ 셀 0 — 동일 안내) | 2026-10-20 정정(원장 S96-10) | 구현 |
| D00-4d-006 | §4d BtnInput_Click 권한(!CanModelChange, 무메시지) | Hook:52-57 (canEdit 게이트로 흡수 — canEdit = hasButton('EDIT') Page:78, 사내 MNU_BTN_MPG_M EDIT 정의) | AS-IS CanModelChange 권한체크 = TO-BE EDIT 버튼 권한으로 흡수(메시지는 D00-4d-002 의 MSG01154 로 통합) | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:SEARCH | Main 조회(FindData_Main — checkRequiredOfSearch Division*/Period* .cs:432 + GET) | Page:154-176,181-188 (validateFind — Division 필수 MSG00097 :158 · Period 필수 MSG00429 :166 · 역전 MSG00108 :172 + handleSearch — setFilters + invalidateQueries) | 2026-10-20 2차 보완(원장 S96-9): Period 필수 검증 추가(Designer "Period*" :532), 메시지 코드 TO-BE 실측으로 교정 | 구현 |
| CRUD:SAVE | 저장(SaveData_Main, M-only 7 CLOB · MSG00004 iCount 건 저장 · 빈 WORKING_TIME_DEFAULT→"0" .cs:567) | Page:202-316 (handleSave — EditTracker net 변경 '^' 직렬화 + WORKING_TIME_DEFAULT 정수·0~7 판정 :245-265 + apiClient.post SAVE → 사내 배선 SAVE→P_SCP0096_SAVE→PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 9인자 + 결과 커서 o_result_cursor(RESPONSE_SET.STATUS) RESULT_CODE 'F' 분기 :289-300 + 성공 토스트 MSG00672 {0}=RESULT_CNT :301-305) | 2026-10-20 2차 보완(원장 S96-8·S96-12): 결과 커서 키 대문자 O_RESULT_CURSOR → 소문자(BE PROC_M COL_NM) · 성공 토스트 MSG00004(TO-BE 본문 "수정한 내용이 없습니다") → MSG00672. 빈 WORKING_TIME_DEFAULT→"0" 은 사내 SP F_TO_NUM(NULL)=0 이 흡수(FE 는 '' 전송) | 구현 |
| CRUD:EDIT | EditButton(SwitchLock) 편집모드 |  | 미이식(2026-09-29, convert-core §2.4 규범 준수) — Edit 버튼·handleEdit 토글 제거. `canEdit = hasButton('EDIT')`(mount 1회)로 대체, grid `editMode` prop 이 그 값을 받아 동등 게이트 | 제외 |
| CRUD:INSERT | Insert(InsertButton override 본문 공백) | Page:289 (hotkeyConfig.insert=false — 버튼 비노출) | AS-IS .cs:274-276 본문 공백 = 기능 비활성(10_RULES_KEEP F1 · gate G2 "빈 핸들러 0건") + 사내 SCM_ADM_MNU_BTN_MPG_M(SCP0096) 에 INSERT 정의 없음(2026-10-20 실측: EDIT/SAVE/SEARCH) = Visible ❌(menu-button-dynamic-fetch §1.1). 2026-10-20 정정(이전 '() => undefined 노출 무동작' 은 두 룰·admin 메타와 상충, 원장 S96-2) | 제외 |
| CRUD:DELETE | Delete(DeleteButton override 본문 공백) | Page:290 (hotkeyConfig.delete=false — 버튼 비노출) | AS-IS .cs:278-280 본문 공백 = 기능 비활성(F1·G2) + 사내 MNU_BTN_MPG_M DELETE 정의 없음(2026-10-20 실측) = Visible ❌. 2026-10-20 정정(원장 S96-2) | 제외 |
| MODAL:(none) | 팝업/모달 없음 | — | AS-IS SCP0096 은 팝업 없는 단일 화면(조회조건+pivot 편집 그리드) — 분석 md·FE 양쪽 모달 파일 0 | 해당없음 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지 (keepRowVisibleUnderFilter) | — | 이 화면은 신규행 Insert 없음(pivot 셀 편집 전용, Insert=NO-OP D00-4d/CRUD:INSERT). 신규행 개념 부재 → 해당없음 | 해당없음 |
| COMMON:UC-02 | 수정 중 재조회 시 confirm (MSG00703) | Page:193-197,181-188 (resetGrid — Division 변경 시 미저장 편집 폐기 + handleSearch 는 편집 폐기) | AS-IS 는 수정중 재조회 confirm 없이 SwitchLock 잠금복귀 — TO-BE 도 조회 시 EditTracker clear(동일 동작). 별도 confirm 은 AS-IS 미존재 | 구현 |
| COMMON:UC-03 | 컬럼 설정 적용 시 Reset 후 재조회 | Page:143-150,181-188 (fetchStaticColumns mount+Search refetch) — admin 컬럼 메타(INPUT_TP_CD 포함) 변경 반영 | 이 화면은 Column/Measure 설정 UI 진입점 없음(SHEET_MEASURE 0행). admin 메타 변경은 Search refetch 로 반영 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 Toast | Page:301-305 (handleSave 성공 setToast success — MSG00672 {0}개 저장) |  | 구현 |
| COMMON:UC-05 | Excel Download 콤보 컬럼 Name 출력 | Grid:161 (D_ 셀 dataMap DAY_CELL_DATA_MAP) + SubTitle 공용 Excel(gridAction dataMap 승계) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중 입력 전건 조회 | Form:145-147,104-109 (Plant Site 다중선택 → orAll 'ALL' 정규화, 콤마 다중) |  | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 (rebindFilterColumns) | Grid:347-369 (FlexGridFilter 피처 소유 + filterApplied 재적용, filterColumns 유지) |  | 구현 |

## 보완요청 원장 축 (REQ — 2026-10-20 2차, `Doc/단위테스트_보완대상/보완요청_원장.md` S96-8~16)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| REQ:CHAT-20261020-S96-8 | WORKING_TIME_DEFAULT 0~7 정수 제약(AS-IS SetReNumerCellType .cs:163) | Page:245-265 + Const:153,102,104 |  | 구현 |
| REQ:CHAT-20261020-S96-9 | 조회 Period 필수(Designer "Period*" :532 + checkRequiredOfSearch .cs:432) | Page:161-169 (MSG00429 {0}=Period) |  | 구현 |
| REQ:CHAT-20261020-S96-10 | 메시지 코드 TO-BE SCM_ADM_MSG_M 실측 재배선(MSG00135→MSG00662 · MSG00134→MSG01153 · MSG00050 폐기 · Division 필수 MSG00097 · 역전 MSG00108) | Const:86-107 + Hook:49,101,124 + Page:158,172 |  | 구현 |
| REQ:CHAT-20261020-S96-11 | btnInput 편집권한 없음 = AS-IS MSG00135 알림(무메시지 return 아님) → MSG01154 | Hook:52-57 |  | 구현 |
| REQ:CHAT-20261020-S96-12 | 저장 결과 커서 키 o_result_cursor(소문자) + 성공 토스트 MSG00672 {0}=RESULT_CNT | Page:289-305 |  | 구현 |
| REQ:CHAT-20261020-S96-13 | Sum 커스텀 버튼 비노출(AS-IS chkSum Visible=false :346 · SP W_/M_ 없음) | Page:79-80,377 / Grid:210 |  | 구현 |
| REQ:CHAT-20261020-S96-14 | 정적 컬럼 편집 판정 = admin INPUT_TP_CD 단일 원천(리터럴 EDITABLE_STATIC_BINDING 제거) + registration.sql BLOCK 3-b 정합 UPDATE | Grid:51-56,106,131,139-142,222-223 + Doc/gen/SCP0096/SCP0096_registration.sql BLOCK 3-b |  | 구현 |
| REQ:CHAT-20261020-S96-15 | Doc/gen/SCP0096/SCP0096_PKG.sql = 사내 현행 미러 복원(check-pkg BLOCK 7→0) + SCP0096_GTT.sql | Doc/gen/SCP0096/SCP0096_PKG.sql · SCP0096_GTT.sql · _artifacts/_diagnostics/SCP0096_SUPP2_20261020/ | DB 객체 무변경(사내 현행 그대로) | 구현 |
| REQ:CHAT-20261020-S96-16 | DoD B20 __tests__ + e2e_plan.json 실제 페이지 정합 + TobeFacts 재추출(gap this.Load MISSING→COVERED) | __tests__/ShipmentWorkingDayOsp.spec.ts(TC-SCP0096-001~009) · Doc/gen/SCP0096/e2e_plan.json · Doc/e2e/specs/SCP0096.*.spec.ts | E2E 실행은 dev-login 401(BE)로 미검증 | 구현 |
