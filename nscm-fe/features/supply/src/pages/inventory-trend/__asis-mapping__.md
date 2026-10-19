# SCP0101 Inventory Trend — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0101_InventoryTrend/SCP0101_InventoryTrend.cs`(+`.designer.cs`)
TO-BE: `nscm-fe/features/supply/src/pages/inventory-trend/`
설계 근거: `.atlas/gscm-design/SCP0101/design/00~03`. 화면 성격 = 조회 전용 Report(Find/Excel 실동작, Save NO-OP, 전 컬럼 Lock).

## 1. 컨트롤/컨테이너 (design 01 §1 — 13건)

| AS-IS 컨트롤 | 근거 | TO-BE |
|---|---|---|
| usrConditionPanel1 (HidePanel) | designer:77~83 | `SearchArea`(InventoryTrendForm) — MainTitle openSearchArea 토글 |
| layoutControlGroup2 / usrLayoutControl2 | designer:87~102,368~385 | SearchArea 내부 `FormItem` grid(`@foundation` common-styles) |
| monthPicker (UsrMonthPicker) | designer:402~413 | `DatePickerCalendar` usecase='month' |
| cboDivision (UsrCheckedList2) | designer:387~400 | `CustomDropdown` multiple allOption (Division_SCP) |
| clbPlant (UsrCheckedList2) | designer:415~428 | `CustomDropdown` multiple allOption (PlantByGroup_SCP cascade) |
| txtItem_Id (UsrMultiLineEditor) | designer:451~464 | `InputField`(Material) + 팝업버튼 |
| btnItem_Id (UsrButton) | cs:970~989 | `FunctionSearchIcon` → ItemByDivisionModal |
| btnColumn (Column 설정) | designer:430~441 | DataGrid 컨텍스트 메뉴(공용) |
| chkDetail (상세토글) | designer:487~498, Visible=false(366) | 미노출 재현(항상 hidden 22컬럼) — 아래 R8 |
| spdMain (FpSpread) | designer:500~514 | `DataGrid`(InventoryTrendGrid) 단일 sheet 'main' |
| emptySpaceItem1/2 | designer:443~449,479~485 | flex 여백(별도 노드 불요) |
| emptySpaceItem6 | designer:54,551~557 | orphan(미사용, 재현 불요) |

## 2. 이벤트 (design 00 events 5)

| AS-IS 이벤트 | 근거 | TO-BE |
|---|---|---|
| CboDivision_SelectedIndexChanged → SetChangedControl | cs:204,161~166 | Division 값 파라미터 → PlantByGroup_SCP react-query 자동 재조회(cascade). setSearchParams 가 plant ALL 리셋 |
| MonthPicker_ValueChanged → SetSpreadHeader | cs:1010~1013 | month 변경 → 6개월 헤더 relabel(재조회 없음). InventoryTrendGrid `leafHeaderByBinding` useMemo(dep month) |
| ChkDetail_CheckedChanged → SetLayout | cs:1015~1018 | 미재현(chkDetail Visible=false → 트리거 불가, R8 패리티=숨김 유지). 확인필요(04) |
| BtnItem_Id_Click → ItembyDivisionPopup | cs:970~989 | onItemSearch → ItemByDivisionModal, 반환 itemId 채움(빈값 무시) |
| BtnColumn_Click → InitSpread(TitleSet) | cs:960~967 | DataGrid 컨텍스트 메뉴 컬럼설정(공용) |

## 3. Validation (design 02 §4 — 실질 1건 + 참고)

| AS-IS validation | 근거 | TO-BE |
|---|---|---|
| checkRequiredOfSearch — 권한 Division 0건 → 권한없음 조회차단 | cs:278; DataUtil.cs:390~416 | Form: Division_SCP+EE필터 0건 → noDivisionAuth → SearchArea disable + MSG00667 alert('No authority assigned.', AS-IS MSG00097 의도 매칭 TO-BE 코드, Hook #114). page: hotkeyConfig.search=false(조회 미발사) |
| `*` 접미 필수필드(MSG00002) | DataUtil.cs:427~444 | 비적용 — SCP0101 라벨(Month/Division/Plant/Material) 중 `*` 없음(design 02 §4) |
| ExcelButton 조회 0건 확인(MSG00100) | cs:251~267 | handleExcel: rows 0건이면 MSG00719(등가 문구) alert 후 미다운로드 |

## 4. spCalls (design 00 spCalls 3)

| AS-IS SP 호출 | 근거 | TO-BE |
|---|---|---|
| SCP0101_GET_INVENTORY_TREND(Find) | cs:301~307 | useTabProcQuery(main). PKG_SCP0101 미배포 → 런타임 실행체인 미완(convert-sp 후속) |
| SCP0084_GET_MONTH_RANGE(월범위 초기화) | cs:630~648 | month 기본=현재월 폴백(SCP0084 미배포). 배포 후 min/max·MAX 기본 배선 |
| (조회 로그성 호출) | cs | 미해당(TO-BE 서버 표준 로깅) |

## 5. entryPoints / 툴바 버튼 (design 00 entryPoints 9 → override 4)

| AS-IS override | 근거 | TO-BE hotkeyConfig |
|---|---|---|
| FindButton → Find_Data | cs:217~220 | `search` = handleSearch(hasButton('SEARCH') + !noDivisionAuth) |
| ExcelButton → ExportExcelData | cs:251~267 | `excel` = handleExcel(0건 가드) |
| SaveButton (빈 본문 NO-OP) | cs:248~249 | `save` = `() => undefined`(false·키 생략 금지 — 공용 addRow/removeRow 회귀 방지) |
| EditButton (SwitchLock→전체잠금→MEMO unlock) | cs:222~246 | 대응 없음 — NSCM 공용 툴바에 Edit 키 부재(HotkeyConfig) + MEMO 컬럼 부재로 실효 편집대상 0. 파리티=read-only. 확인필요(04) |
| insert/delete/manual/upload | — | 미사용(리포트) — false |

## 6. gridSignals / 동적 규칙 (design 03 §2·§3)

| AS-IS | 근거 | TO-BE |
|---|---|---|
| SetSpreadHeader — QTY_MONTH1..5 = -5..-1개월 yy.MM | cs:347~398 | `leafHeaderByBinding` col.header relabel(updatedLayout 재적용) |
| SetSpreadHeader — QTY_MONTH_FOCUS = 선택월 yy.MM + Red/Bold | cs:381~382 | col.header + formatItem(ColumnHeader) color/bold |
| SetSpreadHeader — LONG_TERM_STOCK_AMOUNT row1=focus월 | cs:384~388 | col.header relabel(그룹 row0='Amount(KRW)' 유지) |
| SetSpreadHeader — INV_STATUS row0="{focus월} Inventory Status" | cs:834~843 | formatItem(ColumnHeader row0) textContent relabel |
| SetBackColor — LongTerm 행 음영(R1) | cs:454~482 | formatItem(Cell) 행 배경(REPORT_TYPE≠'Ending'). 색상 확인필요(AS-IS 오버로드 버그) |
| SetCellColor — CHK_QTY 40/30/20/10 → INV_STATUS 색(R2) | cs:498~546 | formatItem(Cell) 글자 Red(+40 배경 LightGreen). SetCellColorOLD(547~629)=dead, 미이관 |
| SmartColMerge — 반복 셀 세로 병합(R4) | cs:325 | allowMerging=Cells + MERGE_COLUMNS(선두 식별 그룹, updatedLayout 재적용) |
| LockColumn 조회후 전 컬럼 잠금(R7) | cs:320 | staticColumns INPUT_TP_CD 전건 'S'(read-only) + 편집셀 미배선 |
| 셀 콤보 0 / measure 0 / lookup 바인딩 0 | design 03 §1 | 코드셀 콤보화 없음(원코드 표시 유지) |

## 7. 미이관/확인 필요

- MEMO 편집 저장: AS-IS EditButton MEMO unlock 시도이나 MEMO 컬럼 메타/SP 반환 부재 + SaveButton NO-OP → 비영속. TO-BE 패리티=편집 불가(확인필요 04).
- chkDetail 상세토글 22컬럼: AS-IS Visible=false 로 미노출 → 항상 hidden 재현(확인필요 04).
- R1 LongTerm 행 음영 색상: AS-IS SetBackColor 오버로드 버그(의도 Silver 미적용) → TO-BE 는 연한 회색(#f2f2f2)으로 의도 재현, 정확 색상 사용자 확인 축.
- _XLS 4컬럼(hidden): AS-IS Excel swap 주석처리(미채움 vestigial) → TO-BE 도 미채움 유지.
