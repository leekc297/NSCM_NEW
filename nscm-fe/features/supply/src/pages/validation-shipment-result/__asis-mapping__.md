# SCM0014 ValidationShipmentResult — AS-IS ↔ TO-BE 매핑

- AS-IS: `GSCM/06.UIL/GSCM.SCM.Validation.UIL/SCM0014_ValidationShipmentResult.cs` (+`.Designer.cs`)
- TO-BE: `nscm-fe/features/supply/src/pages/validation-shipment-result/`
- 화면 성격: 읽기전용 조회(Intransit Inventory). 단일 그리드 + 2단 헤더. 조회조건 7종. 저장/삽입/삭제 없음.
- 설계 근거: `.atlas/gscm-design/SCM0014/design/00_checklist.md ~ 03_grid-columns.md`

## 1. 진입점(entryPoints) / 툴바 버튼

| AS-IS | cs 라인 | 판정 | TO-BE |
|---|---|---|---|
| FindButton → Find_Data() | cs:277~279 | 실동작(조회) | `hotkeyConfig.search = handleSearch`(hasButton('SEARCH') + R1 무권한 차단), `setFilters()`→useTabProcQuery |
| EditButton → GMessageBox('MSG00109'); return | cs:281~285 | 읽기전용 안내(편집상태 전환 없음) | **미노출(R2 옵션 b 채택)** — hotkeyConfig 에서 edit 키 생략. 근거: 읽기전용 화면·asis_to_tobe §11 모드토글 미이식. 편집 파리티: TO-BE 도 편집 불가(동일). option a(노출+MSG00109) 미채택 |
| (Excel — BaseForm 표준 export) | — | 표준 export | `hotkeyConfig.excel = handleExcel`(0건 가드, 권한 무관 클라 다운로드 — 자매 SCP0085 파리티) |
| (Save/Insert/Delete override 없음) | — | AS-IS 미존재 | `insert/delete/save = false`(미노출, 기본 addRow/removeRow 핸들러 차단) |

## 2. 동적 규칙(R1~R7, design 01 §2)

| # | AS-IS | cs 라인 | TO-BE |
|---|---|---|---|
| R1 | dtDivision.Rows.Count==0 → SetDivisionAuthCheck(조회영역 잠금) + MSG00097 | cs:142~143 | Form: MyDivision 콤보 0건 → 전 필드 disable + setAlert(MSG00097) + store.noDivisionAuth → page 가 search hotkey 차단 |
| R2 | EditButton 읽기전용 안내 | cs:281~285 | edit 키 생략(§1) |
| R3/S1 | Find 전 checkRequiredOfSearch | cs:292 | 필수 조회조건 0건(Designer 실측) — 강제 없음, 빈 조건 조회 허용(방어적 배선 불요) |
| R4/R5 | 조회결과 LockColumn 전열 + ReadOnlySheetList | cs:340~342·146 | 전 컬럼 읽기전용(INPUT_TP_CD 'S' 메타 + EditTracker 미배선). DataGrid staticColumns 만 |
| R6 | cboDivision 변경 → SetChangedControl(no-op, site 콤보 주석) | cs:413~415·172~180 | store.setSearchParams: division 변경 시 filters={} (그리드 비움, 표준 #5). 재조회는 Search 로만 |
| R7 | usrConditionPanel Height=75 고정(2단) | cs:193~196 | SearchArea 표준(고정 px 이식 불요) |

## 3. 조회조건(comboCalls / 팝업, design 02)

| AS-IS | cs 라인 | TO-BE |
|---|---|---|
| cboDivision = Data.Common(Type.MyDivision) | cs:37·150·300 | `useTabComboQueries({ comboId:'MyDivision', mnuId:MENU_ID })` 단일. EE제외+권한 CMBO SQL 내장 |
| cboResultType = Data.Common(Type.LookupCommon,'SHIPMENT_RESULT_TYPE') | cs:154·307 | `useTabComboQueries({ comboId:'LookupCommon', lookupType:'SHIPMENT_RESULT_TYPE', mnuId })` 단일, I/C/B, ALL 없음 |
| txtPlantSite (TextBox, 콤보 주석) | cs:301·323 | InputField 텍스트(콤보 부활 금지) → searchParams.plantSiteId |
| txtSaleSite (TextBox, 콤보 주석) | cs:302·324 | InputField 텍스트 → searchParams.salesSiteId |
| btnProjectID → SCM0002_ProjectbyDivisionPopup | cs:396~409 | `ProjectByDivisionModal`(preSearchParams: divisionId), 콤마 다중 → searchParams.projectCode |
| btnItemId → SCM0002_ItembyDivisionPopup | cs:378~393 | `ItemByDivisionModal`(preSearchParams: divisionId), 콤마 다중 → searchParams.itemId. **한계: AS-IS scmSite(txtPlantSite) 컨텍스트는 공용 COM0008 팝업 요청 계약에 없음 → division 만 전달(자매 동일)** |
| drpPeriod = GetDayRange() | cs:157·160~170·305~306 | `PeriodRangePicker`(store initState) → from/toYyyymmdd. **SP GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH 명은 1MONTH 이나 실제 SQL(SCM.foxml) 은 From/To 둘 다 DATEADD(DAY,-1)=어제 → From=To=어제** |

## 4. 그리드(gridSignals, design 03)

| AS-IS | cs 라인 | 판정 | TO-BE |
|---|---|---|---|
| Query(ds) 시트 바인딩 | cs:338 | 실행 | useTabProcQuery → DataGrid itemsSource |
| LockColumn(0,max,true) | cs:340~342 | 실행 | 전 컬럼 읽기전용(staticColumns INPUT_TP_CD 'S') |
| InitSpread() 리터럴 22컬럼·헤더 span·Freeze | cs:186·296 주석 | **사문(미실행)** | 미이식. 컬럼셋/2단헤더/정렬/폭/셀유형 = SCM_MST_SHEET_COLUMNS 메타 구동(fetchStaticColumns 23행 + SMALL_CLASS 2단) |
| SetSheetHeaderColumn(siMain,2) | cs:202 | 실행 | 메타 구동 2단 헤더(DataGrid staticColumns) |

## 5. 초과/미이식 (없음 명시)

- 사문 컨트롤 usrLayoutControl1/layoutControlGroup1(cs Designer, 미배선 dead) — TO-BE 미매핑(누락 아님).
- 셀 병합/Freeze/셀콤보/PIVOT/Measure/조건부색: AS-IS 없음 → TO-BE 없음.
- 저장/삽입/삭제/EditTracker/useProcMutation/useSaveWithValidation: AS-IS 없음(읽기전용) → TO-BE 미배선.

## 6. validations / buttonGuards 커버리지

- validations: 0 (design 00 checklist §4d — 필수 플래그 0). buttonGuards 백본 0(순수 early-return 없음, override 본문 판정 §1).
- gridSignals 29건: 실행 2(Query·LockColumn) + 가드 1(checkRequiredOfSearch) 매핑, 사문 27(InitSpread) 미이식(§4). 100% 판정.
