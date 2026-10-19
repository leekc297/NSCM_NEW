# SCP0085 Ending Inventory — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0085_EndingInventory/SCP0085_EndingInventory.cs`(+`.designer.cs`)
TO-BE: `nscm-fe/features/supply/src/pages/ending-inventory/`
화면 성격: 조회 전용 Report — Find + Excel 실동작 / Edit·Save NO-OP / 전 컬럼 Lock. 판정=신규.

## 조회조건 (영역2)

| AS-IS (cs/designer) | TO-BE | 근거 |
|---|---|---|
| RdoMonth/RdoDate (라디오, 기본 MONTH) | 단일선택 드롭다운 mode(Monthly/Daily) — NSCM RadioGroup 부재(capa-line-master 선례) | designer:341 / cs:518 rdButton_Changed |
| monthPicker (MonthMin '2021-12', InitValue=MAX_YYYYMM) | `DatePickerCalendar usecase='month' minYear=2021` (MONTH 모드) | cs:399~407 SetMonthRange |
| datePicker (기본 오늘) | `DatePickerCalendar usecase='date'` (DAILY 모드) | cs:200 |
| cboDivision (다중, MyDivision) | CustomDropdown multiple `MyDivision`(EE제외+권한필터 SQL 내장) | cs:43/191 |
| clbPlant (다중, PlantByGroup, division cascade) | CustomDropdown multiple `PlantByGroup_SCP`(@divisionId 재조회형) | cs:207 SetChangedControl |
| txtItem_Id + btnItem_Id (SCM0002 팝업) | InputField + `ItemByDivisionModal`(preSearchParams divisionId, 빈 반환 시 기존값 유지) | cs:429~448 |
| MonthPicker_ValueChanged (cs:499~503) | month 변경 → `date = month + "01"` 동기화(Form onChange) | iter-2 I2 |
| DatePicker_ValueChanged (cs:511~515) | date 변경 → `month = date.slice(0,4)` 동기화(Form onChange). 주의: AS-IS 는 연(YYYY)만 동기화하는 원본 동작을 그대로 재현 — 이후 MONTH 모드 재진입 시 monthPicker 는 연만 채워진 상태(육안 확인 축) | iter-2 I2 |
| Find_Data 파라미터 5종 | setFilters → useTabProcQuery(mode 별 SHEETS) 키 yyyymm/yyyymmdd·divisionId·plantId·itemId·debugMode='F' | cs:298~344 |

## 버튼 (영역1 R4~R7)

| AS-IS override | 본문 | TO-BE hotkeyConfig | 근거 |
|---|---|---|---|
| FindButton | Find_Data() 실동작 | `search: hasButton('SEARCH') ? handleSearch : false` | cs:281~298 |
| EditButton | NO-OP `{}` | NSCM 공용 툴바에 Edit 버튼 없음 → 대응 버튼 없음(편집 불가 파리티 동일) | cs:286~288 |
| SaveButton | NO-OP `{}` | `save: () => undefined`(노출 + 명시적 무동작, false·키 생략 금지) | cs:290~293 |
| ExcelButton | ExportExcelData 실동작 | `excel: handleExcel`(0건 시 MSG00719 안내 후 GridAction.excelDownload) | cs:666~683 |
| (report — Insert/Delete 없음) | — | `insert: false / delete: false`(기본 addRow/removeRow 핸들러 차단) | — |
| chkDetail("Devaluation Age") | Visible=false 정적 숨김 | UI 미노출(월령 39컬럼 항상 숨김으로 재현) | designer:652 / cs:201 (R8) |
| Division 권한 0건 | usrLayoutControl.Enabled=false + MSG00097 | Form noDivisionAuth → 입력 disable + setAlert(MSG00097) + store 승계 → page hotkeyConfig.search 차단(조회 액션까지 비활성) | cs:188 (R1), iter-2 I3 |

## 그리드 (영역3)

| AS-IS 동작 | TO-BE | 근거 |
|---|---|---|
| siMain.Query + LockColumn(0,max,true) | DataGrid staticColumns(SCM_MST_SHEET_COLUMNS 99행) 전 컬럼 읽기전용(INPUT_TP_CD 전건 S) | cs:355~356 |
| siMain.SmartColMerge() | `allowMerging=Cells` + MERGE_COLUMNS(YYYYMM/YYYYMMDD/DIVISION_ID/PLANT_NAME/PLANT_ID) 만 병합 | cs:362 |
| SetHeaderViewDetail (QUANTITY 헤더 더블클릭) | dblClick(ColumnHeader==QUANTITY) → toggleHeaderViewDetail → UNRESTRICTED_QTY/BLOCKED_STOCK/IN_TRANSIT show/hide(초기 숨김) | cs:456~497 |
| SetHeaderDaily (YYYYMMDD) | 가시성 effect: YYYYMMDD = (mode==DAILY) | cs:563~576 |
| SetHeaderDivision (CELL_TYPE_GR) | 가시성 effect: CELL_TYPE_GR = div∋'40'\|\|ALL | cs:578~596 |
| SetLayout 월령 39컬럼(chkDetail) | AGING_COLUMNS 항상 숨김(chkDetail 정적숨김 R8, 메타 M*_QUANTITY V=Y 이나 코드로 hide — goal C5) | cs:602~648 |
| BackColor USE_CELL_CF_BOM='Y' → CELL_CONVER_FACTOR/QUANTITY Yellow | formatItem effect 셀 배경 #ffff00(미해당 시 '' 해제) | cs:256/257 |
| 모드 전환 시 ClearDataSource | setSearchParams(mode 변경) → filters={} + page rows 를 filters[mode] 유무로 게이트 → 재전환 시 stale 캐시 미노출(재조회 전 빈 그리드) | cs:519~522, iter-2 I4 |

## SmartColMerge 병합 컬럼 제약 (grid-behavior-parity §1.3)

AS-IS `siMain.SmartColMerge()`(cs:362)는 인자 없이 호출되고 per-column 병합 정책은 FarPoint 스프레드
템플릿에 있어 `.cs`/`.designer.cs`/`SCM_MST_SHEET_COLUMNS`(merge 플래그 없음, FIXED_FLAG 만) 어디서도
정확한 병합 대상 목록을 추출할 수 없다. 설계(03_grid §3 #8)가 명시한 선두 그룹(DIVISION_ID/PLANT_NAME/
PLANT_ID …)에 선두 기간 컬럼(YYYYMM/YYYYMMDD)을 더해 적용했다. 공용 CustomMergeManager 는 좌측 누적
키 방식이라 선두 연속 컬럼에만 유효하다(비선두 컬럼 사이에 병합 대상이 끼면 사이 값도 같아야 병합).

## Excel 이원 컬럼(_XLS) 정책 (design 03 §3 #38~41,58~59) — 보류(Hard Boundary 밖·별도 PR)

AS-IS `SetSheetVisible`/`ExportExcelData`(cs:684~813)는 다운로드 시 표시 2자리 컬럼(CELL_CONVER_FACTOR/
QUANTITY)을 숨기고 `_XLS`(CELL_CONVER_FACTOR_XLS/QUANTITY_XLS, 5/7자리)를 보이게 스왑 + 내부 CF 컬럼
(CELL_CF/CELL_CF_BOM/USE_CELL_CF_BOM) 노출 + USE_CELL_CF_BOM='Y' 행 `_XLS` 셀 Yellow 로 내보낸다.

TO-BE 공용 `GridAction.excelDownload`(packages/foundation)로는 이를 이식할 수 없다:
1. export 는 columnGroups(admin 메타) 기준으로 컬럼을 재구성하며 `visible`을 메타값으로 되돌린다 —
   런타임 숨김은 `visibleBindings`로 제외되지만(HIDE 방향만 동작), 메타 V=N 인 `_XLS` 를 런타임에 보이게
   해도 재구성 시 다시 invisible 로 렌더돼 export 되지 않는다(SHOW 방향 미지원). 표시 컬럼만 숨기면
   컬럼이 통째로 빠져 오히려 회귀 → 반쪽 스왑 금지.
2. 공용 export 는 셀 배경색을 의도적으로 제거한다(gridAction.ts:1233, 전 화면 공통) → `_XLS` Yellow 불가.

두 제약 모두 `packages/foundation/gridAction.ts`(공용) 수정이 필요하다. convert-core §2.2 Hard Boundary 상
공용 유틸 변경은 이 화면 폴더 밖 — **분리 PR + default 무변화 + 4도메인 regression 0** 절차로만 가능
(iter-1 gap-audit §8 도 별도 PR 로 분류). 게다가 조회 SP(PKG_SCP0085) 미배포로 export 대상 데이터가 없어
런타임 검증도 불가하다. 따라서 iter-2 에서는 미이식(보류) — 04_react-gap "확인필요/보류" 참조.
