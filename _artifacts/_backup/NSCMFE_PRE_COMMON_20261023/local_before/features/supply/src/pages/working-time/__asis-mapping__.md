# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init · 대사: convert-gap-resolve (2026-09-25)
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> TO-BE 경로 약칭: Page=`WorkingTime.tsx` · Form=`components/WorkingTimeForm.tsx` · Grid=`components/WorkingTimeGrid.tsx` · Store=`useWorkingTimeStore.ts` · Dyn=`working-time.dynamic-columns.ts` · Const=`working-time.constants.ts`.
> AS-IS 정본: `SCP0019_WorkingTime.cs`(읽기전용) — 라인은 00_checklist / 01_layout / 03_grid-columns 실측.
> 화면 노출 실태(01_layout §3): Building/Bucket/Sum 3종은 AS-IS 도 `Visibility=Never`(정적 hidden) — TO-BE 는 hidden 상태 그대로 이식(렌더 안 함). 관련 컨트롤/이벤트/SUM 토글 신호는 이 실태 근거로 제외.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 btnInput / UsrButton | Form:211-221 (Input Button, onClick=onInput, disabled={dayWeekCode===SelectDay}) |  | 구현 |
| D00-1-002 | §1 cboBucketType / UsrCombo | — | AS-IS `Visibility=Never` 정적 hidden(01_layout §3 lblBucket/cboBucketType, Designer 695) — 버킷 콤보 화면 비노출. TO-BE 는 hidden 실태 그대로 이식(렌더 안 함, Form:34 주석) — UI 신호 아님 | 제외 |
| D00-1-003 | §1 cboDayWeek / UsrCombo | Form:164-180 (Day of the week CustomDropdown, lookup WEEK_WORK_TIME :48,75-78) |  | 구현 |
| D00-1-004 | §1 cboDivision / UsrCombo | Form:126-153 (Division CustomDropdown, MyDivision :45-46,50 + cascade 초기화) |  | 구현 |
| D00-1-005 | §1 chkSum / UsrCheckBox | — | AS-IS `Visible=false`+`Visibility=Never` 정적 hidden(01_layout §3, Designer 434/668) — SUM 토글 컨트롤 화면 비노출, 실 SUM 표시는 기본값 고정. TO-BE hidden 그대로 이식(Form:34 미렌더) — UI 신호 아님 | 제외 |
| D00-1-006 | §1 clbBuilding / UsrCheckedList | Form:45-46,60-71,81 (COMBO.BUILDING 데이터소스 로드 — Line 다중키 필터축(FACTORY_ID)으로만 사용, UI 는 hidden 미렌더) | AS-IS `Visibility=Never` 정적 hidden(01_layout §3, Designer 398/658) — 컨트롤 자체는 미렌더, 데이터소스만 Line cascade 필터용으로 보존 | 구현 |
| D00-1-007 | §1 clbLine / UsrCheckedList | Form:161-163 (multi() Line 다중선택, division+plantSite+building+operation 다중키 client 필터 :60-71) |  | 구현 |
| D00-1-008 | §1 clbOperation / UsrCheckedList | Form:158-160 (multi() Operation 다중선택, LocationGroupByCapaWT_SCP :44-46,57) |  | 구현 |
| D00-1-009 | §1 clbPlantSite / UsrCheckedList | Form:154-157 (multi() Plant Site 다중선택, PlantByDivisionOperOsp4_SCP_ALL divisionId client 필터 :52-55) |  | 구현 |
| D00-1-010 | §1 components / Container | — | WinForms 디자이너 IContainer(비가시 컴포넌트 컨테이너) — UI 신호 아님 | 제외 |
| D00-1-011 | §1 dCalendar / UsrDateRangePicker3 | Form:181-190 (PeriodField start/end — 공용 features/master PeriodField) |  | 구현 |
| D00-1-012 | §1 emptySpaceItem1 / EmptySpaceItem | — | DevExpress 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-013 | §1 emptySpaceItem10 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-014 | §1 emptySpaceItem2 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-015 | §1 emptySpaceItem3 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-016 | §1 emptySpaceItem4 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-017 | §1 emptySpaceItem5 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-018 | §1 emptySpaceItem6 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-019 | §1 emptySpaceItem9 / EmptySpaceItem | — | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-020 | §1 layoutControlGroup2 / LayoutControlGroup | — | DevExpress 레이아웃 그룹 컨테이너 — 표현 전용, TO-BE SearchArea/Grid 로 흡수(비즈니스 신호 아님) | 제외 |
| D00-1-021 | §1 layoutControlItem1 / LayoutControlItem | — | DevExpress 레이아웃 아이템(래퍼) — 실제 컨트롤은 §1 개별 행에 대사됨, 래퍼는 표현 전용 | 제외 |
| D00-1-022 | §1 layoutControlItem10 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-023 | §1 layoutControlItem11 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-024 | §1 layoutControlItem2 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-025 | §1 layoutControlItem3 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼(Building 라벨, 정적 hidden) — 표현 전용 | 제외 |
| D00-1-026 | §1 layoutControlItem4 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-027 | §1 layoutControlItem5 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-028 | §1 layoutControlItem7 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-029 | §1 layoutControlItem8 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼(chkSum 배치, 정적 hidden) — 표현 전용 | 제외 |
| D00-1-030 | §1 layoutControlItem9 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-031 | §1 lblBucket / LayoutControlItem | — | DevExpress 레이아웃 라벨 래퍼(Bucket, 정적 hidden) — 표현 전용 | 제외 |
| D00-1-032 | §1 spdMain / FpSpread | Grid:305-314 (공용 DataGrid — FlexGrid 직접 금지 hook#10) |  | 구현 |
| D00-1-033 | §1 spdMain_Sheet1 / SheetView | Grid:305-314 (DataGrid 단일 시트 itemsSource=data) |  | 구현 |
| D00-1-034 | §1 txtInpuValue / TextBox | Form:192-210 (Input Value InputField, maxLength 4, 숫자만 수용 → searchParams.inputValue) |  | 구현 |
| D00-1-035 | §1 usrButton1 / UsrButton | — | Designer 좌표 0/0·tab0·배선/표시 흔적 없는 미사용 버튼 — AS-IS 도 유령 노드(01_layout §4 #201: TO-BE 미이관, 이식 시 유령 버튼 발생) | 제외 |
| D00-1-036 | §1 usrConditionPanel1 / UsrConditionPanel | Form:119-224 (SearchArea 조회조건 패널, isHidden 토글 :122) |  | 구현 |
| D00-1-037 | §1 usrLayoutControl2 / UsrLayoutControl | — | DevExpress 레이아웃 컨트롤 루트 컨테이너 = TO-BE SearchArea/Grid 로 대체(레이아웃 프리미티브는 화면 요소 아님) | 제외 |
| D00-2-001 | §2 btnInput / Click | Page:233-290 (handleInputValue — 4가드 + 선택 D_ 셀 setCellData + tracker.storeChange) |  | 구현 |
| D00-2-002 | §2 cboBucketType / SelectedIndexChanged | — | cboBucketType 정적 hidden(D00-1-002) — 화면 비노출이라 사용자 변경 이벤트 도달 불가. 버킷은 Daily 고정(01_layout §3), TO-BE 미이식 | 제외 |
| D00-2-003 | §2 cboDayWeek / SelectedIndexChanged | Form:174-176 (onChange → dayWeekCode) → Form:216 btnInput disabled 토글 + Page:240 값입력 가드 |  | 구현 |
| D00-2-004 | §2 cboDivision / SelectedIndexChanged | Form:137-149 (onChange → setSearchParams{divisionId, 하위 cascade 초기화} + onDivisionChange resetGrid) |  | 구현 |
| D00-2-005 | §2 chkSum / CheckedChanged | — | chkSum 정적 hidden(D00-1-005) — 화면 비노출이라 토글 이벤트 도달 불가. SUM 표시는 기본값 고정(01_layout §3), TO-BE 미이식 | 제외 |
| D00-2-006 | §2 clbBuilding / SelectedIndexChanged | — | clbBuilding 정적 hidden(D00-1-006) — 화면 비노출이라 사용자 변경 이벤트 없음. Building 은 Line 필터축 데이터소스로만 존재(Form:60-71 client 필터로 대체) | 제외 |
| D00-2-007 | §2 clbOperation / SelectedIndexChanged | Form:158-160 (multi onPick → setSearchParams{operationIds, lineIds:[]}) → Line cascade 재필터(:60-71) |  | 구현 |
| D00-2-008 | §2 clbPlantSite / SelectedIndexChanged | Form:154-157 (multi onPick → setSearchParams{plantSiteIds, lineIds:[]}) → Line cascade 재필터(:60-71) |  | 구현 |
| D00-2-009 | §2 spdMain / CellDoubleClick | — | SetDblClickColumnShowHide(컬럼 접기/펼치기) — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식(D00-3-037 동일 신호). 향후 요구 시 재설계 | 제외 |
| D00-2-010 | §2 spdMain / TopChange | Grid:230-278 (다단 헤더 총높이 48px rAF 상시 정규화 — 스크롤/레이아웃 변동 시 머지헤더 재적용) | AS-IS TopChange SmartColMerge 재적용 = TO-BE wijmo updatedLayout 상시 유지로 대체 | 구현 |
| D00-3-001 | §3 SetReNumerCellType / (WORKING_TIME_DEFAULT, 0, 2, 7) 숫자셀타입(0~7) | Grid:106 (inputTpCd 메타 위임 — WORKING_TIME_DEFAULT 는 SHEET_COLUMNS INPUT_TP_CD='O' 로 편집형) + staticEditableByMeta(Grid:37-38) + Const:61-66 WORKING_TIME_RANGE DEFAULT 0~7 |  | 구현 |
| D00-3-002 | §3 SmartColMerge / () 헤더 병합 | Grid:120-152 (동적 D_ 2단 머지헤더 group 구성 — 요일 run span → wijmo columnGroups) |  | 구현 |
| D00-3-003 | §3 SetReNumerCellType / (sColumnName, 0, 0) 동적컬럼 숫자셀타입 | Grid:131-141 (동적 D_ leaf format 'n0' 정수 + _ctrlType NUMBER + _inputEditType OPTIONAL) |  | 구현 |
| D00-3-004 | §3 ForeColor= / 토=Blue/일=Red 요일 헤더색 (sDayCode) | Grid:177-181 (formatItem ColumnHeader SAT=#1e56c8/SUN=#c0392b) + Dyn:16,35 weekday 라벨 파생 |  | 구현 |
| D00-3-005 | §3 ColumnHeaderSpan / (0, iLargeStartCol, ..., sLargeSpanName) 대분류 span | Grid:143-151 (요일 연속 run 을 상단 그룹 span 으로 병합 — group.leafs) |  | 구현 |
| D00-3-006 | §3 ColumnHeaderSpan / (1, iSmallStartCol, ..., sSmallSpanName) 소분류 span | Grid:127-142 (D_ leaf 일(DD) 하단 헤더) |  | 구현 |
| D00-3-007 | §3 ColumnHeaderSpan / (1, iSmallStartCol, ..., sSmallSpanName) 소분류 span | Grid:127-142 (D_ leaf 일(DD) 하단 헤더) |  | 구현 |
| D00-3-008 | §3 ColumnHeaderSpan / (1, iSmallStartCol, ..., sSmallSpanName) 소분류 span | Grid:127-142 (D_ leaf 일(DD) 하단 헤더) |  | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / (0, iLargeStartCol, ..., sLargeSpanName) 대분류 span | Grid:143-151 (요일 run 상단 그룹 span) |  | 구현 |
| D00-3-010 | §3 SmartColMerge / () | Grid:118-152 (동적 D_ 헤더 span 재구성 + Grid:230-278 총높이 정규화) |  | 구현 |
| D00-3-011 | §3 SwitchLock / () 편집모드 잠금 토글 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-012 | §3 LockColumn / (DIVISION_ID~LINE_NAME, true) 키컬럼 잠금 | Grid:169-172,213-225 (editableStaticBindings 메타 O/M 미포함 → isEditableBinding=false → beginningEdit e.cancel; 키/식별 컬럼 메타 INPUT_TP_CD='S') |  | 구현 |
| D00-3-013 | §3 LockColumn / (LAST_INPUT_DATE~OSP_YN, true) 메타컬럼 잠금 | Grid:106,164-172 (메타 INPUT_TP_CD='S' 컬럼은 editableStaticBindings 제외 → 잠금) |  | 구현 |
| D00-3-014 | §3 Locked= / Rows[iRow].Locked = true 행 잠금 | Grid:54-55,210-212 (isRowEditable — OSP_YN!=='Y' 행은 beginningEdit e.cancel 로 전 편집셀 잠금) |  | 구현 |
| D00-3-015 | §3 BackColor= / Rows[iRow].BackColor = LockColor 잠금행 색 | Grid:186-196 (formatItem OSP_YN!=='Y' 편집형 셀 wj-cell-non-editable 회색 — UnLockOnlyOSP 재현) |  | 구현 |
| D00-3-016 | §3 Visible= / Columns[iCol].Visible = true | Grid:137 (동적 D_ leaf visible:true) |  | 구현 |
| D00-3-017 | §3 Visible= / Columns[iCol].Visible = chkSum.Checked (SUM 토글) | — | SUM 열은 chkSum 정적 hidden(D00-1-005)에 종속 — 컨트롤 비노출이라 토글 불가, SUM 표시는 기본값 고정(01_layout §3). TO-BE 미이식 | 제외 |
| D00-3-018 | §3 Visible= / Columns[iCol].Visible = false | Grid:89-92 (visibleColumns — display&&visible admin 메타로 컬럼 노출 제어) |  | 구현 |
| D00-3-019 | §3 Visible= / Columns[iCol].Visible = true | Grid:89-92 (visibleColumns — admin SHEET_COLUMNS 메타 위임 노출) |  | 구현 |
| D00-3-020 | §3 Visible= / Columns[iCol].Visible = chkSum.Checked (SUM 토글) | — | SUM 열은 chkSum 정적 hidden(D00-1-005)에 종속 — 컨트롤 비노출이라 토글 불가, SUM 표시 기본값 고정(01_layout §3). TO-BE 미이식 | 제외 |
| D00-3-021 | §3 Visible= / Columns[iCol].Visible = false | Grid:89-92 (visibleColumns — admin 메타 display=false 컬럼 미노출) |  | 구현 |
| D00-3-022 | §3 Visible= / Columns[iCol].Visible = true | Grid:89-92 (visibleColumns — admin 메타 노출 제어) |  | 구현 |
| D00-3-023 | §3 LockColumn / (iCol, true) 정보시트 컬럼 잠금 | — | AS-IS spreadInfo(제목/헤더 시트) 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님, Grid:147-151) — 구조적으로 편집 불가 | 제외 |
| D00-3-024 | §3 Query / (dsBinding) 데이터 바인딩 | Page:63-69,114-121 (useTabProcQuery GET SP + handleSearch invalidateQueries) → Grid:312 itemsSource |  | 구현 |
| D00-3-025 | §3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 잠금 | Grid:200-212 (조회 직후 편집모드 아님 — 전 편집형 셀 beginningEdit e.cancel) + Page:129 resetGrid hasSearched=false |  | 구현 |
| D00-3-026 | §3 SmartColMerge / () | Grid:230-278 (조회 후 updatedLayout rAF 로 머지헤더 재적용) |  | 구현 |
| D00-3-027 | §3 SetBGColor / (i,j,i,j, InvalidColor) 검증 실패 셀 색(0~7) | — | AS-IS 셀 검증실패 배경색 표기 — TO-BE 는 범위 검증을 값입력 시점 alert(MSG00203 OUT_OF_RANGE, Page:260-263)로 선차단해 잘못된 값이 셀에 기입되지 않음. 사후 셀-색 검증 경로 불필요(무해 미이식) | 제외 |
| D00-3-028 | §3 SetBGColor / (i,j,i,j, InvalidColor) 검증 실패 셀 색(0~1440) | — | AS-IS 셀 검증실패 배경색 표기(분 단위 0~1440) — TO-BE 는 값입력 시점 범위 alert(Page:260-263 DAY_MIN~DAY_MAX)로 선차단. 사후 셀-색 검증 경로 불필요(무해 미이식) | 제외 |
| D00-3-029 | §3 Get / (0) Columns.Get(0) — btnInput 가드용 컬럼 참조 | Page:235-238 (handleInputValue 가드 #1 !hasSearched → MSG.NOT_SEARCHED — 조회 전 컬럼0 숨김 등가 판정) |  | 구현 |
| D00-3-030 | §3 GetModelColumnFromViewColumn / (row) 값입력 시 뷰→모델 행 인덱스 변환 | Page:272-274 (g.rows[row].dataItem 로 뷰행→모델 데이터아이템 변환) |  | 구현 |
| D00-3-031 | §3 GetModelColumnFromViewColumn / (col) 값입력 시 뷰→모델 열 인덱스 변환 | Page:275-277 (g.columns[col].binding 로 뷰열→모델 binding 변환) |  | 구현 |
| D00-3-032 | §3 SetText / (i,j,strValue) 선택셀 값 입력 | Page:278-281 (setCellData + tracker.storeChange — 선택 D_ 셀 write) |  | 구현 |
| D00-3-033 | §3 SetText / (i,j,strValue) 선택셀 값 입력 | Page:270-284 (selectedRanges 중첩루프 셀별 writeCell) |  | 구현 |
| D00-3-034 | §3 SetText / (i,j,strValue) 선택셀 값 입력 | Page:270-284 (선택영역 반복 셀 write) |  | 구현 |
| D00-3-035 | §3 SetText / (i,j,strValue) 선택셀 값 입력 | Page:270-284 (선택영역 반복 셀 write) |  | 구현 |
| D00-3-036 | §3 SetText / (i,j,strValue) 선택셀 값 입력 | Page:270-284 (선택영역 반복 셀 write) |  | 구현 |
| D00-3-037 | §3 SetDblClickColumnShowHide / (sender, e) 더블클릭 컬럼 토글 | — | 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식(D00-2-009 동일 신호). 향후 요구 시 재설계 | 제외 |
| D00-4b-001 | §4b Data.Common / MyDivision / dtMyDivision | Form:45-46,50 (COMBO.DIVISION=MyDivision, 권한 @sesUserId+@mnuId 내장) → divisionOptions |  | 구현 |
| D00-4b-002 | §4b Data.Common / LookupCommon / dtDayWeek | Form:48,75-78 (useTabLookupQueries DAY_WEEK_LOOKUP=WEEK_WORK_TIME, SEGMENT1/2 정규화) |  | 구현 |
| D00-4b-003 | §4b Data_SCP.Common / PlantByDivisionOperOsp3 / dtPlantSiteByDivision | Form:45-46,52-55 (COMBO.PLANT_SITE=PlantByDivisionOperOsp4_SCP_ALL 전량로드 + divisionId client 필터) | AS-IS Osp3 재조회 = TO-BE Osp4_ALL 전량로드 + DBUtils.Filter 클라 필터(§4c 필터형 확정, Const:39-41) | 구현 |
| D00-4b-004 | §4b Data.Common / BuildingByDivision / dtBuilding | Form:45-46,60-71,81 (COMBO.BUILDING=BuildingByDivision1_SCP_ALL — Line 필터축 FACTORY_ID 데이터소스, hidden 미렌더) | AS-IS Building 콤보 정적 hidden(01_layout §3) — 데이터소스만 Line client 필터용 보존, 컨트롤 미노출 | 구현 |
| D00-4b-005 | §4b Data_SCP.Common / LocationGroupByCapaWT / dtOperation | Form:45-46,57 (COMBO.OPERATION=LocationGroupByCapaWT_SCP, 필터 없이 전체 유지 §3) |  | 구현 |
| D00-4b-006 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | Form:45-46,60-71 (COMBO.LINE=LineByOperationAddOSP2_SCP_ALL 전량로드 + division/plant/building/operation 다중키 client 필터) |  | 구현 |
| D00-4b-007 | §4b Data.Common / BuildingByDivision / dtBuilding | Form:45-46,60-71,81 (Building 데이터소스 — clbPlantSite cascade 경로에서도 동일 소스 재사용, hidden) | AS-IS cascade 재조회 = TO-BE 단일 전량로드 후 client 필터(§4c 필터형) — 콤보 로드 1회로 통합. Building 은 hidden(01_layout §3) | 구현 |
| D00-4b-008 | §4b Data_SCP.Common / LocationGroupByCapaWT / dtOperation | Form:45-46,57 (Operation 데이터소스 — clbPlantSite cascade 경로에서도 동일 소스 재사용, 필터 없이 전체) | AS-IS cascade 재조회 = TO-BE 전량로드 후 필터 없이 전체 유지(§4c) | 구현 |
| D00-4b-009 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | Form:45-46,60-71 (Line 데이터소스 — clbPlantSite cascade 경로 재필터, plantSiteIds client 필터 :62-63) | AS-IS cascade 재조회(param 세트) = TO-BE 전량로드 후 다중키 client 필터로 통합(§4c 필터형) | 구현 |
| D00-4b-010 | §4b Data_SCP.Common / LocationGroupByCapaWT / dtOperation | Form:45-46,57 (Operation 데이터소스 — clbBuilding cascade 경로에서도 동일 소스, 필터 없이 전체) | AS-IS cascade 재조회 = TO-BE 전량로드 후 전체 유지(§4c). Building 은 hidden 이라 사용자 cascade 트리거 없음 | 구현 |
| D00-4b-011 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | Form:45-46,60-71 (Line 데이터소스 — clbBuilding cascade 경로 재필터, buildingIds client 필터 :65-66) | AS-IS cascade 재조회 = TO-BE 다중키 client 필터로 통합(§4c). Building hidden 이나 필터축은 보존 | 구현 |
| D00-4b-012 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | Form:45-46,60-71 (Line 데이터소스 — clbOperation cascade 경로 재필터, operationIds client 필터 :67-68) | AS-IS cascade 재조회(pFactoryID 포함 param) = TO-BE 다중키 client 필터로 통합(§4c 필터형) | 구현 |
| D00-4b-013 | §4b Data.CallBizCommonData / ("PERIOD_"+value) / dt | Store:38-41 (dCalendar 기본기간 클라 프리셋 — 당월1일~익월말일) | AS-IS PERIOD_* BIZ 콤보 = TO-BE 클라 기본값으로 개통(PERIOD_* SP 연동은 04_react-gap 확인필요 이월, Store:36-37) — 기본 기간 산출 대체 | 구현 |
| D00-4c-001 | §4c RefreshPlantSiteByDivision / dtPlantSiteByDivisionAll (PlantByDivisionOperOsp4) | Form:52-55 (PlantByDivisionOperOsp4_SCP_ALL 전량로드 + DIVISION_ID client 필터 재현) |  | 구현 |
| D00-4c-002 | §4c RefreshBuilding / dtBuildingAll (BuildingByDivision1) | Form:60-71,81 (BuildingByDivision1_SCP_ALL 전량로드 — Line FACTORY_ID 필터축, Building UI hidden) | AS-IS RefreshBuilding 클라필터 = TO-BE Line 다중키 client 필터의 FACTORY_ID 축으로 흡수(Building 컨트롤 hidden 01_layout §3) | 구현 |
| D00-4c-003 | §4c RefreshLine / dtLineAll (LineByOperationAddOSP2) | Form:60-71 (LineByOperationAddOSP2_SCP_ALL 전량로드 + division/plant/building/operation 다중키 client 필터 — RefreshLine 조건식 1:1) |  | 구현 |
| D00-4d-001 | §4d BtnInput_Click / Input (조회 전 컬럼0 숨김, MSG00135) | Page:235-238 (!hasSearched → MSG.NOT_SEARCHED alert) |  | 구현 |
| D00-4d-002 | §4d BtnInput_Click / Input (!CanModelChange 권한, 무메시지) | Form:216 (btnInput disabled 게이트) + Page:274 (OSP_YN!=='Y' 행 skip — 편집 대상 아닌 행 write 차단) | AS-IS CanModelChange 권한체크 = TO-BE 편집 대상 행(OSP_YN='Y') 판정 + 저장 EDIT 권한 게이트로 흡수 | 구현 |
| D00-4d-003 | §4d BtnInput_Click / Input (pDayWeekCode=SelectDay 차단) | Form:216 (btnInput disabled={dayWeekCode===SelectDay}) + Page:240 (재확인 SelectDay 이면 무동작) |  | 구현 |
| D00-4d-004 | §4d BtnInput_Click / Input (selCells<1 셀 미선택, MSG00134) | Page:243-248 (selectedRanges 없음 → MSG.NO_CELL_SELECTED) + Page:285-288 (편집셀 0건 → 재알림) |  | 구현 |
| D00-4d-005 | §4d BtnInput_Click / Input (pDayWeekCode 공백, 무메시지) | Page:240 (dayWeekCode===SelectDay(기본 미선택) 면 return — 공백/미선택 게이트) | AS-IS pDayWeekCode 공백 순수가드 = TO-BE 기본값 SelectDay 미선택 게이트로 흡수(빈값도 SelectDay 등가) | 구현 |
| D00-4d-006 | §4d BtnInput_Click / Input (!CanModelChange 재확인, 무메시지) | Page:274 (write 루프 OSP_YN!=='Y' 행 skip — #2 와 동일 권한/편집대상 게이트, 다른 지점) | AS-IS CanModelChange 재확인 = TO-BE write 시점 편집 대상 행 판정으로 흡수(D00-4d-002 동일 게이트) | 구현 |
| D00-4d-007 | §4d BtnInput_Click / Input (ds==null 데이터셋 null 차단, 무메시지) | Page:235-238 (!hasSearched → 조회 전 데이터 없음 차단, MSG.NOT_SEARCHED) | AS-IS ds==null 순수가드 = TO-BE 미조회 게이트로 흡수(조회 전엔 rows 없음, hasSearched=false) | 구현 |
| D00-4e-001 | §4e (예외) / GMessageBoxForException | Page:209-211 (handleSave catch → setAlert 예외 메시지) |  | 구현 |
| D00-4e-002 | §4e MSG00203 / GMessageBox | Page:260-263 (값입력 범위검증 num 이 DAY_MIN~DAY_MAX 벗어나면 → MSG.OUT_OF_RANGE) + Const:80-81 |  | 구현 |
| D00-4e-003 | §4e MSG00203 / GMessageBox | Page:257-263 (D_ 셀 0~1440 범위검증 → MSG.OUT_OF_RANGE, Const:61-66 DAY_MIN/DAY_MAX) |  | 구현 |
| D00-4e-004 | §4e MSG00004 / GMessageBox | Page:178-180 (저장 대상 없음 → MSG.NO_SAVE_DATA "No data to save") | AS-IS MSG00004 저장건수/무변경 안내 = TO-BE NO_SAVE_DATA(변경 0건) alert 로 대응(Const:88-89) | 구현 |
| D00-4e-005 | §4e (예외) / GMessageBoxForException | Page:197-202 (저장 응답 오류코드 → message 추출 후 setAlert SAVE_ERROR) |  | 구현 |
| D00-4e-006 | §4e (예외) / GMessageBoxForException | Page:209-211 (handleSave catch(e) → 예외 메시지 setAlert) |  | 구현 |
| D00-4e-007 | §4e MSG00135 / GMessageBox | Page:235-238 (btnInput 조회 전 차단 → MSG.NOT_SEARCHED=MSG00135, Const:72-73) |  | 구현 |
| D00-4e-008 | §4e MSG00134 / GMessageBox | Page:245-247 (셀 미선택 → MSG.NO_CELL_SELECTED=MSG00134, Const:76-77) |  | 구현 |
| D00-4e-009 | §4e MSG00050 / GMessageBox | Page:251-254 (입력값 형식검증 빈값/비숫자 → MSG.INVALID_FORMAT=MSG00050, Const:78-79) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 이 화면은 신규행 Insert 없음(Insert=NO-OP, Page:222; pivot 셀 편집 전용). 신규행 개념 부재 → 해당없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | Page:114-121,127-131 (handleSearch/resetGrid — 조회 시 editTracker.clearChanges + hasSearched 재게이트) | AS-IS 는 수정중 재조회 confirm 없이 SwitchLock 잠금복귀 — TO-BE 도 조회/Division 변경 시 편집 폐기(동일 동작). 별도 confirm 은 AS-IS 미존재 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | Page:92,120 (fetchStaticColumns mount+Search refetch) — admin SHEET_COLUMNS 메타 변경 반영 | 이 화면은 Column/Measure 설정 UI 진입점 없음(SHEET_MEASURE 0행). admin 메타 변경은 Search refetch 로 반영 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | Page:204 (저장 성공 setToast success) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | Grid:71-83 (cellCboDataTp→COMBO dataMap) + SubTitle 공용 Excel(Page:305-314 gridAction dataMap 승계) | 이 화면 정적 컬럼엔 셀 콤보 없음(Const:97-98) — DIVISION_ID 는 코드표시(CODE_DISPLAY). dataMap 승계 경로는 공용 SubTitle 로 보장 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | Form:154-163,104-111 (Plant Site/Operation/Line 다중선택 → orAll 'ALL' 정규화, 콤마 다중) + Store:87 orAll |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | Grid:281-302 (FlexGridFilter 피처 소유 + filterApplied 재적용, filterColumns 유지) |  | 구현 |
