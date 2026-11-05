# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init · 대사: convert-gap-resolve iter-1 (2026-09-25)
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> TO-BE 경로 약칭: Page=`ShipmentWorkingDayOsp.tsx` · Form=`components/ShipmentWorkingDayOspForm.tsx` · Grid=`components/ShipmentWorkingDayOspGrid.tsx` · Store=`useShipmentWorkingDayOspStore.ts` · Dyn=`shipment-working-day-osp.dynamic-columns.ts` · Const=`shipment-working-day-osp.constants.ts`.
> AS-IS 정본: `SCP0096_Shipment_Working_Day_OSP.cs`(읽기전용, 852라인) — 라인은 00_checklist/03_grid-columns 실측.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 cboDivision / UsrCombo | Form:124-144 (Division CustomDropdown, Division_SCP_NoEE 서버 ATTRIBUTE3<>'EE' 필터 :60) |  | 구현 |
| D00-1-002 | §1 clbPlantSite / UsrCheckedList | Form:145-147 (multi() Plant Site 다중선택, PlantByDivisionOperOsp3_SCP cascade :48-51) |  | 구현 |
| D00-1-003 | §1 cboDayWeek / UsrCombo | Form:157-172 (Day of the week CustomDropdown, lookup WEEK_WORK_TIME :57,72-75) |  | 구현 |
| D00-1-004 | §1 cboInputValue / UsrCombo | Form:174-188 (Input Value CustomDropdown, YesOrNo :69, disabled={isDayWeekEmpty}) |  | 구현 |
| D00-1-005 | §1 chkSum / UsrCheckBox | Page:378-382 (Sum customButton 토글) + Grid showSum→visible :198 |  | 구현 |
| D00-1-006 | §1 dCalendar / UsrDateRangePicker3 | Form:148-155 (PeriodField start/end) |  | 구현 |
| D00-1-007 | §1 btnInput / UsrButton | Form:189-200 (Input Button, onClick=onInput, disabled={isDayWeekEmpty}) |  | 구현 |
| D00-1-008 | §1 spdMain / FpSpread | Grid:360-367 (공용 DataGrid — FlexGrid 직접 금지 hook#10) |  | 구현 |
| D00-1-009 | §1 spdMain_Sheet1 / SheetView | Grid:360-367 (DataGrid 단일 시트 itemsSource=data) |  | 구현 |
| D00-1-010 | §1 usrConditionPanel1 / UsrConditionPanel | Form:118-202 (SearchArea 조회조건 패널) |  | 구현 |
| D00-1-011 | §1 usrButton1 / UsrButton | Page:356-384 (SubTitle 공통버튼 컨테이너 — SEARCH/SAVE/EDIT/Sum) | AS-IS 컨테이너 버튼그룹 → SubTitle 로 흡수 | 구현 |
| D00-1-012 | §1 usrLayoutControl2 / UsrLayoutControl | Form:117-202 (SearchArea 레이아웃) | AS-IS DevExpress 레이아웃 컨테이너 = TO-BE SearchArea/Grid 로 대체(레이아웃 프리미티브는 화면 요소 아님) | 제외 |
| D00-1-013 | §1 layoutControlGroup2 / LayoutControlGroup | — | AS-IS DevExpress 레이아웃 그룹 컨테이너 — 표현 전용, TO-BE Grid size 로 흡수(비즈니스 신호 아님) | 제외 |
| D00-1-014 | §1 components / Container | — | WinForms 디자이너 IContainer(비가시 컴포넌트 컨테이너) — UI 신호 아님 | 제외 |
| D00-1-015 | §1 layoutControlItem1 / LayoutControlItem | — | DevExpress 레이아웃 아이템(래퍼) — 실제 컨트롤은 §1 개별 행에 대사됨, 래퍼는 표현 전용 | 제외 |
| D00-1-016 | §1 layoutControlItem2 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-017 | §1 layoutControlItem3 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-018 | §1 layoutControlItem4 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-019 | §1 layoutControlItem7 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-020 | §1 layoutControlItem10 / LayoutControlItem | — | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-021 | §1 layoutSum / LayoutControlItem | Page:378-382 (Sum 버튼 배치) | chkSum(D00-1-005) 배치 래퍼 — 실동작은 D00-1-005 대사 | 구현 |
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
| D00-2-004 | §2 chkSum / CheckedChanged (.cs:352) | Page:381 (Sum action → setShowSum) → Grid:198 SUM visible |  | 구현 |
| D00-2-005 | §2 btnInput / Click (.cs:698-707) | Page:255-341 (handleInputValue — 3분기 SetText + 6가드) |  | 구현 |
| D00-2-006 | §2 spdMain / CellDoubleClick (.cs:817-819) | — | SetDblClickColumnShowHide(컬럼 접기/펼치기) — D00-3-032 와 동일 신호, AS-IS 부가기능(핵심 CRUD 무관)으로 미이식. 향후 요구 시 재설계 | 제외 |
| D00-2-007 | §2 spdMain / TopChange (.cs) | Grid:69,286-333 (다단 헤더 총높이 rAF 상시 정규화 — 스크롤/레이아웃 변동 시 머지헤더 재적용) | AS-IS TopChange SmartColMerge 재적용 = TO-BE wijmo mergeManager 상시 유지(스크롤 sticky)로 대체 | 구현 |
| D00-3-001 | §3 SetReNumerCellType / 160 | Grid:122-125 (WORKING_TIME_DEFAULT inputTpCd OPTIONAL) + FPNumber 서식(03 §1 scale2) |  | 구현 |
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
| D00-3-016 | §3 LockColumn / 288 (키 3컬럼 잠금) | Grid:210-211,255-262 (isEditableBinding=false → beginningEdit e.cancel; DIVISION_ID~PLANT_SITE_NAME 비편집) |  | 구현 |
| D00-3-017 | §3 LockColumn / 289 (LAST_INPUT_DATE~MEASURE 잠금) | Grid:122-125 (SEARCH_ONLY) + isEditableBinding 제외 → 잠금 |  | 구현 |
| D00-3-018 | §3 Visible= / 347 (D_/W_ 항상표시) | Grid:156 (D_ leaf visible:true) |  | 구현 |
| D00-3-019 | §3 Visible= / 352 (chkSum SUM 토글) | Grid:198 (sumGroups visible:showSum) |  | 구현 |
| D00-3-020 | §3 LockColumn / 405 (spdInfo 제목시트 잠금) | — | 제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님) — 구조적으로 편집 불가 | 제외 |
| D00-3-021 | §3 Query / 470 (FindData_Main 조회) | Page:76-82,127-135 (useTabProcQuery GET SP + handleSearch invalidateQueries) |  | 구현 |
| D00-3-022 | §3 LockColumn / 472 (조회 직후 전열 잠금) |  | 미이식(2026-09-29, convert-core §2.4 규범 준수) — 조회 직후 개별 잠금 호출 없음. Grid 는 `editMode`(=`canEdit` 권한) off 일 때 전 셀 잠금(권한 없으면 읽기전용) 으로 동등 대체 | 제외 |
| D00-3-023 | §3 SmartColMerge / 477 (조회 후 재병합) | Grid:286-333 (조회 후 updatedLayout rAF 로 머지헤더 재적용) |  | 구현 |
| D00-3-024 | §3 Get / 683 (Columns.Get(0).Visible 조회 전 차단) | Page:257-260 (handleInputValue 가드 #1 !hasSearched → MSG.NOT_SEARCHED) |  | 구현 |
| D00-3-025 | §3 GetModelColumnFromViewColumn / 734 | Page:290-298 (writeCell — g.columns[col].binding 로 뷰열→모델 binding 변환) |  | 구현 |
| D00-3-026 | §3 GetModelColumnFromViewColumn / 735 | Page:290-298 (writeCell 좌표→binding 변환, dataItem 조회) |  | 구현 |
| D00-3-027 | §3 SetText / 744 (SelectDay 선택셀 기입) | Page:300-312 (isSelectDay 선택영역 D_ 셀 writeCell) |  | 구현 |
| D00-3-028 | §3 SetText / 758 (SelectDay 기입 지점2) | Page:308-312 (선택영역 중첩루프 writeCell) |  | 구현 |
| D00-3-029 | §3 SetText / 771 (SelectDay 기입 지점3) | Page:290-298 (writeCell setCellData + tracker.storeChange) |  | 구현 |
| D00-3-030 | §3 SetText / 789 (EveryDay 전행 D_) | Page:313-324 (isEveryDay → 전행×전 D_ 컬럼 writeCell) |  | 구현 |
| D00-3-031 | §3 SetText / 797 (요일별 매칭 D_) | Page:319-322 (dayCol.weekday===targetWeekday 매칭 셀만 writeCell) |  | 구현 |
| D00-3-032 | §3 SetDblClickColumnShowHide / 819 | — | 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식. 향후 요구 시 재설계 | 제외 |
| D00-4b-001 | §4b Data_SCP.Common / MyDivisionInEE / dtMyDivision | Form:54-55,60 (COMBO.DIVISION=Division_SCP_NoEE, 서버 ATTRIBUTE3<>'EE' 필터) |  | 구현 |
| D00-4b-002 | §4b Data.Common / LookupCommon / dtDayWeek | Form:57,72-75 (useTabLookupQueries DAY_WEEK_LOOKUP=WEEK_WORK_TIME) |  | 구현 |
| D00-4b-003 | §4b Data.Common / YesOrNo / dtValidYN | Form:54-55,69 (COMBO.INPUT_VALUE=YesOrNo) + Grid:161 D_ 셀 dataMap DAY_CELL_DATA_MAP(Y/N) |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / PlantByDivisionOperOsp3 / dtPlantSiteByDivision | Form:48-51,54-55,66 (COMBO.PLANT_SITE=PlantByDivisionOperOsp3_SCP, divisionId cascade 재조회) |  | 구현 |
| D00-4d-001 | §4d BtnInput_Click 가드 #1 조회 전(MSG00135) | Page:257-260 (!hasSearched → MSG.NOT_SEARCHED alert) |  | 구현 |
| D00-4d-002 | §4d BtnInput_Click 가드 편집모드 아님 | Page:262-265 (!editMode → 안내 후 무동작) |  | 구현 |
| D00-4d-003 | §4d BtnInput_Click 가드 DayWeek 미선택(무메시지) | Form:195 (btnInput disabled={isDayWeekEmpty} — 값 없으면 클릭 차단, AS-IS :710-713 return) |  | 구현 |
| D00-4d-004 | §4d BtnInput_Click 형식검증(Y/N, MSG00050) | Page:267-272 (INPUT_VALUE_SET.includes(raw) 아니면 MSG.INVALID_FORMAT) |  | 구현 |
| D00-4d-005 | §4d BtnInput_Click 가드 #4 SelectDay 선택셀0(MSG00134) | Page:303-307 (isSelectDay sel 없음 → MSG.NO_CELL_SELECTED) |  | 구현 |
| D00-4d-006 | §4d BtnInput_Click 권한(!CanModelChange, 무메시지) | Page:262-265 (편집모드 게이트로 흡수 — 편집모드 진입 자체가 EDIT 권한 hasButton('EDIT') 게이트, Page:368) | AS-IS CanModelChange 권한체크 = TO-BE editMode 진입(EDIT 버튼 권한)으로 흡수 | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:SEARCH | Main 조회(FindData_Main) | Page:127-135 (handleSearch — validateFind + setFilters + invalidateQueries) |  | 구현 |
| CRUD:SAVE | 저장(SaveData_Main, M-only 7 CLOB) | Page:161-235 (handleSave — EditTracker net 변경 '^' 직렬화 + apiClient.post SAVE) |  | 구현 |
| CRUD:EDIT | EditButton(SwitchLock) 편집모드 |  | 미이식(2026-09-29, convert-core §2.4 규범 준수) — Edit 버튼·handleEdit 토글 제거. `canEdit = hasButton('EDIT')`(mount 1회)로 대체, grid `editMode` prop 이 그 값을 받아 동등 게이트 | 제외 |
| CRUD:INSERT | Insert(toolbarOverride NO-OP) | Page:245 (hotkeyConfig.insert=()=>undefined — 버튼 노출·클릭 무동작) | AS-IS .cs:274-276 본문 공백 = NO-OP(설계 01_layout §2 #7). 노출 유지 무동작 — gap-resolve iter-1 정정 | 구현 |
| CRUD:DELETE | Delete(toolbarOverride NO-OP) | Page:246 (hotkeyConfig.delete=()=>undefined — 버튼 노출·클릭 무동작) | AS-IS .cs:278-280 본문 공백 = NO-OP(설계 01_layout §2 #8). 노출 유지 무동작 — gap-resolve iter-1 정정 | 구현 |
| MODAL:(none) | 팝업/모달 없음 | — | AS-IS SCP0096 은 팝업 없는 단일 화면(조회조건+pivot 편집 그리드) — 분석 md·FE 양쪽 모달 파일 0 | 해당없음 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지 (keepRowVisibleUnderFilter) | — | 이 화면은 신규행 Insert 없음(pivot 셀 편집 전용, Insert=NO-OP D00-4d/CRUD:INSERT). 신규행 개념 부재 → 해당없음 | 해당없음 |
| COMMON:UC-02 | 수정 중 재조회 시 confirm (MSG00703) | Page:137-145,353 (resetGrid — Division 변경 시 미저장 편집 폐기) + handleSearch 는 편집모드 해제(:130) | AS-IS 는 수정중 재조회 confirm 없이 SwitchLock 잠금복귀 — TO-BE 도 조회 시 editMode off + EditTracker clear(동일 동작). 별도 confirm 은 AS-IS 미존재 | 구현 |
| COMMON:UC-03 | 컬럼 설정 적용 시 Reset 후 재조회 | Page:104,134 (fetchStaticColumns mount+Search refetch) — admin 컬럼 메타 변경 반영 | 이 화면은 Column/Measure 설정 UI 진입점 없음(SHEET_MEASURE 0행). admin 메타 변경은 Search refetch 로 반영 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 Toast | Page:224 (저장 성공 setToast success) |  | 구현 |
| COMMON:UC-05 | Excel Download 콤보 컬럼 Name 출력 | Grid:161 (D_ 셀 dataMap DAY_CELL_DATA_MAP) + SubTitle 공용 Excel(gridAction dataMap 승계) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중 입력 전건 조회 | Form:145-147,104-109 (Plant Site 다중선택 → orAll 'ALL' 정규화, 콤마 다중) |  | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 (rebindFilterColumns) | Grid:336-357 (FlexGridFilter 피처 소유 + filterApplied 재적용, filterColumns 유지) |  | 구현 |
