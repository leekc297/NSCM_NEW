# DMF0020 Sales Future Price — 주요 이벤트 상세분석

- **원천**: `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Master\DMF0020_SalesFuturePrice\DMF0020_SalesFuturePrice.cs` (**총 3,969행**, 처음~끝 전수 Read, 2026-07-27 실측)
- **보조 원천**: 동 폴더 `DMF0020_SalesFuturePrice.Designer.cs` (총 1,598행 — 컨트롤 정의·이벤트 배선 확인용)
- **기준 소스 버전**: 헤더 이력 L35~L57 기준 최신 = `2025-09-29 [E20250919-001699] INCOTERMS EDIT시는 과거코드 안나오도록 수정`. 직전 = `2025-01-20 [E20250113-000150] Edit시 Currency 수정기능 추가`, `[PJ2025-50017] 40사업부 편집 금지`.
- **표기 원칙**
  - 라인번호는 모두 실측 (`L1234~1250` 형식).
  - **주석 처리되어 실행되지 않는 코드는 반드시 "주석(비활성)"으로 명기**. 활성 코드와 혼동 금지.
  - 소스에 존재하지 않는 것은 "**없음**"으로 명기 (추정·창작 금지). 추정이 불가피한 경우 "(추정)" 으로 별도 표기.
- **그리드**: FarPoint Spread `spdMain` **단일 시트 `"Sales Price"`** (`SpdSheet.shtMain`, L115). 헤더 3단 (`AddSheet(..., 3, 1, 45)` L543).
  열 구조 = 고정속성 컬럼(`DIVISION_ID` ~ `MEASURE`) + 기간 PIVOT 컬럼(컬럼 Tag = `W_yyyymmdd` / `M_yyyymm`, `B_*` 는 숨김, `D_*` 는 코드상 참조만 존재).
- **행 구조 (핵심 전제)**: 1개 논리 레코드 = **`dtMeasureCount.Rows.Count` 개의 물리 행 블록** (Measure 별 1행: LOC / KRW / USD / RTF 계열). `GetCellIndexBySpanRowCells()`(L2929~2935) 가 블록의 첫 행을, `GetCellNumbersByRow()`(L2944~2971) 가 블록의 전 행 배열을 돌려준다. **단, `SaveData` 1차 검증 루프(L1566)와 `fnValidation`(L2223, L2267)은 `+= 4` 로 4행 블록을 하드코딩**하고 있어 `dtMeasureCount` 행수가 4가 아니면 어긋난다 (잠재결함, §5-1 / §6 참조).
- **상수**: `CAppSetting.StringAction`="Action", `StringI`/`FlagI`="I", `FlagM`="M", `FlagD`="D", `StringY`="Y", `StringALL`="ALL" (원천: `01.Framework\GSCM.Windows.Forms\Utility\CAppSetting.cs` L104~114).

---

## 0. 이벤트 인벤토리 (전수)

### 0-1. 라이프사이클 / 초기화

| # | 이벤트/메서드 | 트리거 | 라인 | 활성 |
|---:|---|---|---|:--:|
| 1 | `DMF0020_SalesFuturePrice()` (생성자) | 화면 인스턴스 생성 | L183~190 | 활성 |
| 2 | `Form_Load` | Form.Load (생성자 L188 배선) | L192~215 | 활성 |
| 3 | `InitForm()` | Form_Load 호출 (BaseForm 상속) | L196 (호출) | 활성 |
| 4 | `InitControls()` | Form_Load 호출 | L293~416 | 활성 |
| 5 | `CreateSpread()` | Form_Load 호출 | L541~548 | 활성 |
| 6 | `DefineProperty()` | Form_Load 호출 | L436~472 | 활성 |
| 7 | `InitEvent()` | Form_Load 호출 | L550~556 | 활성 |
| 8 | `InitSpread(bool)` | CreateSpread / FindData / clbDivisions 변경 / btnColumn | L574~595 | 활성 |
| 9 | `SetSpreadHeaderSpan(DataTable)` | InitSpread 내부 | L597~678 | 활성 |
| 10 | `SetSpreadColumn()` (무인자) | InitSpread·cboBucketType 변경·FindData | L680~718 | 활성 |
| 11 | `SetSpreadColumn(DataTable)` (오버로드) | — | L724~772 | **미호출(dead)** |
| 12 | `InitSpread_X()` | — | L774~825 | **미호출(dead)** |
| 13 | `DMF0020_SalesFuturePrice_Resize` | Form.Resize (Designer L1486) | L3530~3537 | 활성 |
| 14 | `backgroundWorker1_DoWork` | BackgroundWorker (Designer L1465) | L3516~3519 | 활성(Console 출력만) |
| 15 | `backgroundWorker1_ProgressChanged` | BackgroundWorker (Designer L1466) | L3521~3523 | 활성(빈 본문) |
| 16 | `backgroundWorker1_RunWorkerCompleted` | BackgroundWorker (Designer L1467) | L3525~3528 | 활성(Console 출력만) |

### 0-2. 툴바(공통버튼) override — BaseForm

| # | 이벤트/메서드 | 트리거 | 라인 | 활성 |
|---:|---|---|---|:--:|
| 17 | `FindButton()` | 공통 조회 버튼 | L831~834 | 활성 |
| 18 | `InsertButton()` | 공통 행추가 버튼 | L836~844 | 활성 |
| 19 | `DeleteButton()` | 공통 행삭제 버튼 | L846~859 | 활성 |
| 20 | `EditButton()` | 공통 편집 버튼 | L861~1222 | 활성 |
| 21 | `SaveButton()` | 공통 저장 버튼 | L1224~1228 | 활성 |
| 22 | `ExcelButton()` | 공통 엑셀 다운로드 버튼 | L1231~1263 | 활성 |

> ⚠️ **F-key / 툴바 단축키 명시적 오버라이드는 이 화면 소스에 없음.** 위 6개 `protected override` 가 BaseForm 의 공통버튼 훅이며, 화면 로컬에 `ProcessCmdKey` / `KeyPreview` / F5·F7 등 개별 키 핸들러는 **없음**. 그리드 키 처리는 `spdMain_KeyUp`(#43, Ctrl+C/V) 과 조회조건 `KeyDown`(#37·#38, Enter) 만 존재.

### 0-3. 핵심 로직

| # | 이벤트/메서드 | 트리거 | 라인 | 활성 |
|---:|---|---|---|:--:|
| 23 | `FindData(bool, int, int)` | FindButton / 저장 후 / Exchange Rate 팝업 OK / Excel Upload 후 | L1270~1536 | 활성 |
| 24 | `SaveData()` | SaveButton | L1538~1970 | 활성 |
| 25 | `InsertRow()` | InsertButton | L1983~2211 | 활성 |
| 26 | `fnValidation()` | SaveData 1차 검증 내부 | L2213~2348 | 활성 |
| 27 | `SetChangeControl(...)` | 조회조건 cascade 공통 진입 | L227~286 | 활성 |
| 28 | `SetExchangeValues(int,int,string)` | 월(M_) 셀 입력 시 주차 전개 | L3105~3156 | 활성 |
| 29 | `GetExchangeRate(...)` | 환산 계산 (4단계) | L3168~3209 | 활성 |
| 30 | `SetTextCellsToRowSpanRange(...)` | Item 팝업 선택 후 Currency 전파 | L2913~2922 | 활성 |
| 31 | `GetCellIndexBySpanRowCells(int)` | 블록 첫 행 산출 | L2929~2935 | 활성 |
| 32 | `GetCellNumbersByRow(int)` | 블록 전 행 배열 산출 | L2944~2971 | 활성 |
| 33 | `SetRowSpanFucTwo(...)` | 82사업부 셀 병합 재적용 | L3838~3875 | 활성 |
| 34 | `GetCellColor(...)` | — | L1972~1981 | **미호출(dead)** (호출부 L1804 주석) |
| 35 | `GetThisWeekMonday(DateTime)` | — | L3496~3514 | **미호출(dead)** |

### 0-4. 조회조건(SearchArea) 이벤트

| # | 이벤트/메서드 | 트리거 | 라인 | 활성 |
|---:|---|---|---|:--:|
| 36 | `clbDivisions_SelectedIndexChanged` | Division 체크리스트 변경 (배선 L471, **Designer 아님**) | L2465~2601 | 활성 |
| 37 | `clbTeam_SelectedIndexChanged` | Team 변경 (Designer L637) | L3655~3680 | 활성 |
| 38 | `clbEndCustomer_SelectedIndexChanged` | End Customer 변경 (Designer L597) | L3539~3545 | 활성 |
| 39 | `usrDiscard_CheckedChanged` | "Search over range" 체크 (Designer L905) | L3829~3834 | 활성 |
| 40 | `cboBucketType_SelectedIndexChanged` | Bucket 콤보 변경 (배선 L555 InitEvent) | L558~572 | 활성 |
| 41 | `cboBucketType_Click` | Bucket 콤보 클릭 (Designer L893) | L3817~3827 | 활성 |
| 42 | `umltProject_KeyDown` | Project 입력창 Enter (배선 L469) | L474~480 | 활성 |
| 43 | `umltModel_KeyDown` | Model 입력창 Enter (배선 L470) | L482~488 | 활성 |

> `checkInvalidExec`("Price 미등록 제외", Designer L258), `clbPlantSite`, `clbBizType`, `clbSalesSite`, `drpDateTime`, `txtOwner`, `txtVersion` 에는 **개별 이벤트 핸들러 없음** (값만 FindData 에서 읽음).

### 0-5. 버튼 Click 이벤트

| # | 이벤트/메서드 | 버튼(캡션) | 라인 | 활성 |
|---:|---|---|---|:--:|
| 44 | `usrButton1_Click` | Project 팝업 버튼 (layoutControlItem6) | L2423~2440 | 활성 |
| 45 | `btnModelType_Click` | `btnItemId` — Model 팝업 (Designer L442) | L2442~2463 | 활성 |
| 46 | `btnOwner_Click` | Owner 팝업 | L3771~3790 | 활성 |
| 47 | `btnColumn_Click` | 컬럼설정(TitleSet) | L3792~3802 | 활성 |
| 48 | `btnSPVer_Click` | Version 선택 팝업 | L3895~3922 | 활성 |
| 49 | `btnExchangeRate_Click` | "Exchange Rate" | L2395~2421 | 활성 |
| 50 | `btnSavePricePeriod_Click` | "Price일괄입력" | L2360~2393 | 활성 |
| 51 | `btnBatch_Click` | "Batch Job" (ADMIN/DM ADMIN 만 표시) | L3458~3494 | 활성 |
| 52 | `btnTemplate_Click` | "Excel Form" (81사업부 전용) | L3924~3933 | 활성 |
| 53 | `btnExcelUpload_Click` | "Upload" (81사업부 전용) | L3935~3947 | 활성 |

### 0-6. 그리드(spdMain) 이벤트

| # | 이벤트/메서드 | 트리거 (배선) | 라인 | 활성 |
|---:|---|---|---|:--:|
| 54 | `spdMain_CellClick` | CellClick (Designer L161) | L3684~3696 | 활성 |
| 55 | `Raw_CellClick(SpreadInfo,int,int)` | #54 에서 호출 | L3698~3751 | 활성 |
| 56 | `spdMain_CellDoubleClick` | CellDoubleClick (Designer L162) | L3211~3345 | 활성 |
| 57 | `spdMain_ComboSelChange` | ComboSelChange (Designer L163) | L2603~2904 | 활성 |
| 58 | `spdMain_TopChange` | TopChange (Designer L164) | L3347~3352 | 활성 |
| 59 | `spdMain_KeyUp` | KeyUp (Designer L165) | L3753~3769 | 활성 |
| 60 | `Dsdm_Changed` | `DefaultSheetDataModel.Changed` (배선 L552~553) | L2973~3103 | 활성 |

### 0-7. 데이터 조회 헬퍼 (SP 호출 전용)

| # | 메서드 | 라인 | 활성 |
|---:|---|---|:--:|
| 61 | `GetDayRange()` | L417~431 | 활성 |
| 62 | `GetWeekData()` | L490~505 | 활성 |
| 63 | `GetMeasureCountInfo()` | L507~520 | 활성 |
| 64 | `GetFuturePriceInfo()` | L522~539 | 활성 |
| 65 | `GetSpdTitle()` | L3546~3564 | 활성 |
| 66 | `GetBucketType()` | L3804~3815 | 활성 |
| 67 | `GetCustomsHandbook()` | L3877~3893 | 활성 |
| 68 | `GetLookupValues(6인자)` | L3951~3967 | 활성 |
| 69 | `GetBizTypebyDivision(string)` | L3625~3637 | 활성 (호출부 L2499) |
| 70 | `GetDivision()` | L3354~3366 | **dead** |
| 71 | `GetScmSitebyDivision(...)` | L3368~3382 | **dead** |
| 72 | `GetScmSiteInfobyDivision(...)` | L3384~3397 | **dead** |
| 73 | `GetTeambyDivision(string)` | L3399~3411 | **dead** (호출부 L313 주석) |
| 74 | `GetEndCustomerbyDivision(...)` | L3413~3426 | **dead** |
| 75 | `GetLookupValues(1인자)` | L3428~3440 | **dead** |
| 76 | `GetPlantSitebyEndCustomer(...)` | L3442~3456 | **dead** |
| 77 | `GetTeambyDivisionAsync(string)` | L3566~3577 | **dead** |
| 78 | `GetCustomerbyDivision(...)` | L3579~3592 | **dead** |
| 79 | `GetCustomerbyDivisionAsync(...)` | L3594~3607 | **dead** |
| 80 | `GetPlantSitebyEndCustomerAsync(...)` | L3609~3623 | **dead** (호출부 L2656 주석) |
| 81 | `GetScmSitebyDivisionAsync(...)` | L3639~3653 | **dead** (호출부 L2649 주석) |

**합계: 이벤트/메서드 81건** (활성 65 / 미호출·dead 16).

---

## 1. Form_Load — 화면 최초 진입

**트리거**: 화면(Form) 최초 Load. 생성자 L188 `this.Load += Form_Load;` 로 배선. 생성자에서 `UnFilterInsertRow = true`(L189) 선설정.

**선행 조건/가드**: 없음.

**처리 단계 (L192~215, 순서 고정)**

1. `clsCtrl = new CControl(this)` (L194).
2. `InitForm()` (L196) — BaseForm 상속 초기화.
3. **`InitControls()`** (L197) → §1-1.
4. **`CreateSpread()`** (L198) → §1-2.
5. **`DefineProperty()`** (L199) → §1-3.
6. **`InitEvent()`** (L200) → §1-4.
7. **엑셀 버튼 표시 분기** (L203~214): `clbDivisions.ControlValues.Substring(0,2) == "81"` 이면 `btnExcelUpload.Visible = btnTemplate.Visible = true` + `layoutControlItem12`(=btnExcelUpload) / `layoutControlItem29`(=btnTemplate) `Visibility = Always`. 아니면 모두 `false` / `Never`.
   - ⚠️ **실측 주의**: 직전 5단계 `DefineProperty` L444 에서 `clbDivisions.ControlValues = "ALL"` 로 덮어쓴다. 따라서 Load 시점의 판정값은 `"AL"` 이므로 **최초 진입 시 엑셀 업로드/폼 버튼은 항상 숨김**이며, 이후 `clbDivisions_SelectedIndexChanged`(L2579~2590) 의 동일 분기에서 비로소 표시된다.

**호출 SP/서비스**: §1-1 참조.
**결과/후속**: 조회조건 콤보 전부 세팅, 그리드 헤더 생성, Version="Current".
**예외·검증**: 없음 (MSG 없음).

### 1-1. InitControls (L293~416)

| 단계 | 라인 | 내용 |
|---:|---|---|
| 1 | L295 | `drpDateTime.InitValue = GetDayRange()` → SP `DM.PR_GET_DAY_RANGE` (`p_created_by`=UserId, `p_month`=6). 반환은 `DataSet.Tables[1].Rows[0][0]` (L427) |
| 2 | L296~297 | 지역변수 `sStartDate`/`sEndDate` 산출 — **이후 사용처 없음(dead)** |
| 3 | L299·L302 | `dtDivision=null` 후 `SetChangeControl("MyDivision")` → `DataService.GetDMInnerTable("MyDivision", Filter)` |
| — | L301 | 구소스 `Data.Common(Data.Type.MyDivision, ...)` — **주석(비활성)** |
| 4 | L304 | `clsCtrl.setListBox(dtDivision, clbDivisions, false, "CODE", "NAME")` (L303 `setListBox(dtDivision, clbDivisions, true)` 는 **주석(비활성)**) |
| 5 | L306 | `sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` — "ALL" 이면 CODE 전체를 콤마 결합 |
| — | L308 | `btnSavePricePeriod.Enabled = (sDivision=="82")` — **주석(비활성)** ⇒ Price일괄입력 버튼은 사업부 무관 항상 활성 |
| 6 | L310 | `dtDepartment = Data.Common(Data.Type.UpperDeptId, false, NowGroupID, UserId)` — **`dtDepartment` 이후 참조처 없음(dead 변수)** |
| 7 | L314~315 | `SetChangeControl("UserTeamByDivision", sDivision)` → `clbTeam` 바인딩 (L313 구소스 주석) |
| 8 | L317 | `sTeam` 산출 |
| 9 | L320 | **분기**: `sDivision.Substring(0,2)=="81" \|\| sDivision=="82"` |
| 9-a | L324~346 | (81/82) `EndCustomerByDivision(sDivision,sTeam)`→clbEndCustomer / `BizType(clbDivisions.ControlValues)`→clbBizType / `lblProject.Enabled=true`, `lblPlantSite.Enabled=true`, `layoutControlItem6.Enabled=true` / **82 일 때만** `checkInvalidExec.Enabled=true`, 그 외 false. (L334 `lblBizType.Enabled` 는 주석) |
| 9-b | L350~369 | (그 외=40 등) `EndCustomerByDivision(ControlValues, clbTeam.ControlValues)` / `BizType` / `lblProject.Enabled=false`, `lblPlantSite.Enabled=false`, `layoutControlItem6.Enabled=false`, `umltProject.Text=""`, `clbPlantSite.ControlValues=""`, `checkInvalidExec.Enabled=false` |
| 10 | L372~375 | `lblBizType.Enabled = true` 무조건. (L372~374 의 42/44 분기는 **주석(비활성)**) |
| 11 | L377·L381~382 | `sEndCustomer` 산출 → `SetChangeControl("UserSiteByEndCustomer", ControlValues, "", sEndCustomer)` → `clbSalesSite` |
| 12 | L385~392 | `sDivision.IndexOf("81") != -1` 이면 `UserPlantSiteByEndCustomer` → `clbPlantSite` (L389 구소스 주석) |
| — | L394~396 | CurrencyList 조회 — **주석(비활성)**. `dtCurrencyList` 는 선언(L91)만 되고 실제 채워지지 않음 |
| 13 | L399 | `dtMeasureCount = GetMeasureCountInfo()` → SP `DM.DMF0020_GET_MEASURE_COUNTINFO` (파라미터 없음) |
| 14 | L401 | `dtFuturePrice = GetFuturePriceInfo()` → SP `DM.DMF0020_GET_FUTUREPRICE_INFO` (`p_start_yyyymmdd`=Value1 yyyyMM+"01", `p_end_yyyymmdd`=Value2 yyyyMM+"01") |
| 15 | L405 | `dtWeek = GetWeekData()` → SP `DM.DMF0020_GET_WEEKDATA` (`p_yyyymmdd`=오늘) — 전주 이전 잠금 판정용 |
| 16 | L408~410 | `dtBucketType = GetBucketType()` → SP `DM.DMF0003_GET_BUCKET_TYPE_CODE`; **`Rows.RemoveAt(0)` 로 첫 행 제거** 후 `cboBucketType` 바인딩. (`BucketType` struct L118~123: Weekly/Monthly 활성, `Daily` 는 **주석(비활성)**) |
| 17 | L415 | `txtVersion.Text = "Current"` |

### 1-2. CreateSpread (L541~548)

1. `AddSheet(spdMain, "Sales Price", "Sales Price", 3, 1, 45)` (L543) — **헤더 3단**, 프리즈행 1, 행높이 45.
2. `siMain = GetSheetInfo(...)` (L544), `siMain.ChangeSheet()` (L545).
3. `InitSpread(true)` (L547).

### 1-3. DefineProperty (L436~472)

1. `dtStartPeriod/dtEndPeriod = drpDateTime.Value1/Value2` (L439~440).
2. `usrConditionPanel2.Height = 105` (L442).
3. **`clbDivisions.ControlValues = "ALL"`** (L444).
4. `siMain.ImagePopUp = imageList1.Images[0]`, `cellTypeImage`(TextCellType) 생성 — 배경이미지 우측정렬 + `CharacterCasing.Upper` (L446~450). → 팝업 셀(Project Code / Item ID) 표시에 사용.
5. **권한 분기** (L454~467): `UserInfoContext.Current["NowGroupID"]` 가 `"ADMIN"` 또는 `"DM ADMIN"` → `layoutControlItem5`(= `btnBatch`) `Visibility=Always`, 그 외 `Never`. (`btnCutOff` 관련 4줄 L458~459·L463~464 는 **주석(비활성)** — `btnCutOff` 컨트롤 자체가 이 화면에 없음)
6. 이벤트 배선 3건 (L469~471): `umltProject.KeyDown`, `umltModel.KeyDown`, **`clbDivisions.SelectedIndexChanged`**.

### 1-4. InitEvent (L550~556)

1. `DefaultSheetDataModel dsdm` 취득 후 `dsdm.Changed += Dsdm_Changed` (L552~553).
2. `cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged` (L555).

### 1-5. InitSpread(bool isChangeHeader) (L574~595)

- **분기 A** (L577~580): 기간(`dtStartPeriod`/`dtEndPeriod`)이 현재 `drpDateTime` 값과 **동일** 하고 `isChangeHeader==false` → `siMain.RemoveRowAll()` (**행만 비우고 헤더 유지**).
- **분기 B** (L582~593): 그 외 → 기간 재저장 → `GetSpdTitle()` (SP `DM.DMF0020_GET_SPREAD_TITLE`, 파라미터 `p_start_dt`, `p_end_dt`, `p_created_by`, `p_division_id`=`clbDivisions.SelectedValue`) → `siMain.CreateSheetHeaderColumn(siMain, 3, dsTitle.Tables[0])` → `SetSpreadHeaderSpan(...)` → `SetSpreadColumn()`.

**SetSpreadHeaderSpan (L597~678)** 상세
1. `MEASURE` 컬럼 인덱스+1 을 대·소분류 스팬 시작점으로 잡음 (L605~606).
2. 행 루프 (L612~668): `iCellCnt <= iSmallStartCol` 구간은 3행 병합 헤더(`ColumnHeaderSpan(0, iCellCnt, 3, 1, 20, COLUMN_LABEL_NAME, Center)`) — 고정속성 컬럼.
3. `COLUMN_NAME.IndexOf("B_") > 0` 인 컬럼은 **숨김** (`VisibleColumns(iCellCnt,false)`, L630~633).
4. `LARGE_CLASS_LABEL_NAME` 변경 시 대분류 스팬 + 2행 `"SUM"` 헤더 생성, `SMALL_CLASS_LABEL_NAME` 변경 시 소분류 스팬 (L642~663). (2행 SUM 관련 L651·L659·L671 은 **주석(비활성)**)
5. 루프 종료 후 잔여 스팬 마감 (L670~673).
6. `siMain.Freeze(0, MEASURE컬럼+1)` (L675) → 고정속성 컬럼 전체 프리즈.
7. `siMain.SmartColMerge()` (L677).

**SetSpreadColumn() (L680~718)** — Bucket 별 컬럼 표시 전환
- `cboBucketType.ControlValues == "WEEKLY"` → Tag 가 `W_` 로 시작하는 컬럼만 `Visible=true`, 그 외 `Visible=false` + `BackColor=White` (L686~702). (`D_` 처리 L689~692 는 **주석(비활성)**)
- 그 외(=MONTHLY) → `W_` 숨김+White, `M_` 표시 (L706~715).

---

## 2. FindButton / FindData — 조회

**트리거**: 공통 조회 버튼 → `FindButton()` (L831~834) → `FindData(true)`.
그 외 `FindData` 진입점: 저장 성공 후(L1952/L1954), Exchange Rate 팝업 OK 후(L2419), Excel Upload 후 MSG00265 Yes(L3945), `umltProject` Enter → `usrButton1_Click` → (팝업만, FindData 아님).

**시그니처**: `private async void FindData(bool blnInsert, int iUpdateRow = 0, int iUpdateCol = 0)` (L1270).

### 2-1. 선행 가드 (순서 고정)

| 순 | 라인 | 조건 | 처리 |
|---:|---|---|---|
| 1 | L1277~1281 | `blnWork == true` (연속작업 중) | **MSG00137** 후 return |
| 2 | L1284~1288 | `txtVersion.Text.Trim() == ""` | **MSG00283** ("Version을 선택하고 조회하세요") 후 return |
| 3 | L1291 | — | `blnWork = true` (동기 락) |
| 4 | L1294 | — | `isCurVersion = false` 초기화 |
| 5 | L1305~1309 | `int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])` (기간 역전) | **MSG00108** 후 return (finally 에서 blnWork 해제) |
| 6 | L1325~1329 | `p_division_id == ""` | **MSG00097** 후 return |

### 2-2. 파라미터 수집 (L1296~1323)

| 변수 | 소스 | 라인 |
|---|---|---|
| `sStartDate` / `sEndDate` | `drpDateTime.Value1/Value2` → `yyyyMMdd` | L1297~1298 |
| `sOverRange` | `usrDiscard.Checked ? "Y" : "N"` | L1302 |
| `sInvalidExec` | `checkInvalidExec.Checked ? "Y" : "N"` | L1303 |
| `p_division_id` | `CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` | L1312 |
| `p_scm_site_id` | `clbSalesSite.ControlValues` | L1313 |
| `p_plant_site_id` | `clbPlantSite.ControlValues` | L1314 |
| `p_project_code` | `umltProject.Text` | L1315 |
| `p_item_id` | `umltModel.Text` | L1316 |
| `p_dept_id` | `clbTeam.ControlValues` | L1318 |
| `p_end_customer` | `clbEndCustomer.ControlValues` | L1319 |
| `p_biztype` | `clbBizType.ControlValues` | L1320 |
| `p_owner` | `txtOwner.Text` | L1321 |
| `p_version_type` | `txtVersion.Text` | L1323 |

### 2-3. 처리 단계

1. `CanModelChange = false`, `prg.Show()` (L1331~1332).
2. **`InitSpread(false)`** (L1334) — 기간 미변경이면 행만 클리어, 변경되었으면 헤더 재생성.
3. `SearchStartTime()` (L1338).
4. **비동기 SP 호출** (L1342~1379): `FoxAsyncProxy(this){ShowProgress=false}` + `FoxDataClient` → **`DM.DMF0020_GET_SCM_MST_FUTURE_PRICE`**, `CommandTimeout = 10*60`(600초).
   - 전달 파라미터 (전수, L1353~1372): `p_division_id`, `p_dept_id`, `p_end_customer`, `p_scm_site_id`, `p_project_code`, `p_item_id`, `p_plant_site_id`, `p_customer_project_code`(**빈 문자열 고정**), `p_customer_model`(**빈 문자열 고정**), `p_from_yyyymmdd`, `p_to_yyyymmdd`, `p_biztype`, `p_created_by`, `p_userinfo`(=NowGroupID), `p_owner`, `p_over_range`, `p_invalid_exec`, `p_version_type`.
   - `p_user_dept_id` (JV Planner용) 은 L1370 **주석(비활성)**.
5. **결과 0행 가드** (L1380~1381): `ds.Tables[0].Rows.Count <= 0` → return (finally 에서 progress close·blnWork 해제).
6. **정렬 + 바인딩** (L1384~1407): 마지막 행 `MEASURE` 가 빈 값이 아니면
   - `Action` 컬럼(string) 추가 (L1388).
   - 정렬키 생성: 1 ~ (MEASURE컬럼-1) 컬럼명을 `" ASC,"` 로 결합. 단 컬럼명이 `COLMERGE` / `ACTION` 이면 스킵 (L1392~1399).
   - `Select("", sSortList).CopyToDataTable()` 로 정렬 테이블 생성 후 원 테이블 교체 (L1401~1403).
   - `siMain.Query(ds)` (L1405) → `siMain.LockColumn(0, GetMaxColumnIndex(), true)` — **조회 직후 전 컬럼 잠금(읽기전용)**.
7. `SearchEndTime()`, `SuspendLayout()` (L1409~1410).
8. **과거 구간 음영 + 당월 흰색** (L1416~1446): 이번 주 월요일 `sResultYYYYMMDD` 기준
   - Tag `W_` 이고 `sResultYYYYMMDD > W_값` 인 마지막 컬럼 = `iResultCol` (L1431~1434).
   - Tag `M_` 이고 당월과 같은 컬럼 = `iResultMonth` (L1436~1439).
   - `iResultCol > iStartCol` 이면 `SetBGColor2(0, iStartCol, maxRow, iResultCol, Color.Gainsboro)` 후 `iResultMonth` 열만 `Color.White` 로 복원 (L1442~1446).
9. **버전 상태 확정** (L1450~1453): `txtVersion.Text.Trim() == "Current"` → `isCurVersion = true`. ⇒ **Insert/Edit 가능 여부의 유일한 스위치**.
10. **팝업 셀 이미지 + 범위초과 셀 Pink** (L1460~1494, try/catch 로 감쌈)
    - 행 루프: `PROJECT_CODE` / `ITEM_ID` 컬럼이 존재하면 해당 셀 `CellType = cellTypeImage` (팝업 아이콘).
    - `COL_LIST` 값을 `,` 로 split → 각 컬럼을 `Color.Pink` 배경 처리 (L1476~1488) — [PJ20200138] 범위 초과(20% 초과) 표시.
    - (L1490~1491 `Application.DoEvents()` 는 **주석(비활성)**)
11. **업데이트 복귀 위치** (L1502~1506): `blnInsert == false` 이면 `SetActiveCell(iUpdateRow, iUpdateCol)` + `ShowActiveCell(Center, Center)`.
12. `siMain.SmartColMerge()` (L1507), `UIEndTime()` (L1510), `CanModelChange = true`, `ResumeLayout()` (L1512~1513).
13. **`dtFuturePrice = GetFuturePriceInfo()`** 재조회 (L1516) — 환율 캐시 갱신.
14. `blnWork = false` (L1518).

### 2-4. 예외 / finally

- `catch` (L1520~1529): `MessageHelper.GMessageBoxForException(ex)` → `blnWork=false` → **폼이 아직 보이면 `throw ex`** (닫힌 후 에러는 무시).
- `finally` (L1530~1535): `CanModelChange=true`, `blnWork=false`, `prg.Close()`.

### 2-5. 호출 SP

`DM.DMF0020_GET_SCM_MST_FUTURE_PRICE` (본 조회), `DM.DMF0020_GET_SPREAD_TITLE`(InitSpread 경유), `DM.DMF0020_GET_FUTUREPRICE_INFO`(후처리).

---

## 3. EditButton — 편집모드 진입/해제 (잠금 규칙 전수)

**트리거**: 공통 편집 버튼. 또한 **`cboBucketType_SelectedIndexChanged`(L567~568) 가 `EditButton()` 을 2회 연속 호출**하여 Bucket 변경 후 편집모드를 유지시킨다.

### 3-1. 선행 가드 (L861~957)

| 순 | 라인 | 조건 | 처리 |
|---:|---|---|---|
| 1 | L864 | `!isCurVersion` | **조용히 return** (메시지 없음). Current 버전으로 조회한 경우만 편집 가능 |
| 2 | L866 | `this.fps == null` | 전체 블록 미실행 |
| 3 | L870~878 | `GetLookupValues("DM_UI_EDITABLE_DIVISION", "DMF0020", clbDivisions.ControlValues, "", "", "")` 결과의 `EDIT_YN == "N"` | **MSG00448** 후 return — [PJ2025-50017] 40사업부는 DMF0082 에서 편집 |
| 4-a | L881~895 | Division `"40"`: `END_CUSTOMER40`/`SCM_SITE_ID`/`ITEM_ID`/`INCOTERMS`/`FCST_TYPE`/`DOM_EXP`/`CURRENCY` 중 하나라도 컬럼 미존재(`<0`) | **MSG00113** 후 return |
| — | L896~910 | 42/44 분기 (DEPT_ID 포함 7컬럼) | **주석(비활성)** |
| 4-b | L911~926 | Division `81*`: `SCM_SITE_ID`/`PROJECT_CODE`/`ITEM_ID`/`INCOTERMS`/`FCST_TYPE`/`DOM_EXP`/`CURRENCY`/**`PLANT_SITE_ID`** 중 미존재 | **MSG00113** 후 return |
| 4-c | L927~941 | Division `"82"`: `SCM_SITE_ID`/`PROJECT_CODE`/`ITEM_ID`/`INCOTERMS`/`FCST_TYPE`/`DOM_EXP`/`CURRENCY` 중 미존재 | **MSG00113** 후 return |
| 5 | L945~955 | `PRICE_EXIST` 컬럼 미존재 | `MessageHelper.GetTerm("PRICE_EXIST")` 를 인자로 **MSG00412** 후 return — [E20240903-000738] |

### 3-2. 편집모드 토글 (L959~961)

1. `siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)`.
2. **`siMain.SwitchLock()`** — 잠금 상태 반전 (조회모드 ↔ 편집모드).
3. `SuspendLayout()`. (L962 `LockColumn(0, MEASURE, true)` 는 **주석(비활성)**)

### 3-3. 컬럼 단위 잠금 (L964~1025)

기준값 `sYYYYMMDD` = **이번 주 월요일** (`DateTime.Today.AddDays(Monday - Today.DayOfWeek)`, L964~965).

- **Bucket = WEEKLY** (L972~993)
  - Tag `W_` 컬럼: 편집모드(`!IsLock`)면 `sYYYYMMDD > W_값` (과거 주차) 인 컬럼만 `LockColumn2(iCol,iCol,true)`. 조회모드면 **전부 잠금**.
  - Tag `W_` 아님 → 전부 잠금.
- **Bucket = MONTHLY** (L994~1014)
  - Tag `M_` 컬럼: 편집모드면 `yyyyMM > M_값` (과거 월) 인 컬럼만 잠금. 조회모드면 전부 잠금.
  - Tag `M_` 아님 → 전부 잠금.
- 부수 산출 (L1016~1024): `iResultCol` = 과거 주차 마지막 컬럼, `iResultMonth` = 당월 컬럼.

### 3-4. 행 단위 잠금 (L1027~1210)

**(A) 82사업부 + `NEW_FLAG='Y'` 행** (L1031~1063) — 존재하는 컬럼만 개별 잠금:
`DIVISION_ID`, `DEPT_ID`, `DEPT_NAME_KO`, `END_CUSTOMER`, `SCM_SITE_ID`, `PROJECT_CODE`, `PROJECT_NAME`, `PROJECT_STATUS`, `BIZ_TYPE`, `BIZ_TYPE_NAME`, `ITEM_ID`, `ITEM_CLASS_NAME`, `ITEM_NAME`, `NICK_NAME` + 마지막에 `MEASURE` (L1062).
⇒ **`INCOTERMS` / `FCST_TYPE` / `DOM_EXP` / `CURRENCY` / `PLANT_SITE_ID` 는 잠기지 않음** = ESS 신규행에서 편집 허용 대상.

**(B) 그 외 행** (L1064~1067): `LockRange2(iRow, DIVISION_ID, iRow, MEASURE, true)` — 고정속성 구간 일괄 잠금.

**(C) 권한 체크 — `AUTHORITY_YN != 'Y'` 인 행** (L1070~1160)
- `Action` 이 비어 있으면 → `LockRange2(iRow, MEASURE+1, iRow, maxCol, true)` (수치 영역 전체 잠금) (L1073~1074).
- `Action == 'I'` **AND** `IsEditMode == true` 이면 (L1075~1158):
  - WEEKLY: Tag `W_` 컬럼은 **잠금 해제(false)**, 그 외 잠금 (L1079~1092). (`W_` 과거주차 잠금 L1083~1085 는 **주석(비활성)**)
  - MONTHLY: **모든 컬럼 잠금 해제(false)** (L1093~1106 — `M_` 판정 및 else 잠금 로직 전체가 **주석(비활성)** 이라 무조건 unlock 됨).
  - `DIVISION_ID` 셀 잠금, `DIVISION_ID+1 ~ MEASURE` 잠금 해제 (L1108~1109).
  - Division `"40"` 이면 아무 것도 하지 않음 (L1112~1115, 내부 `ProjectStatus` 잠금은 **주석(비활성)**). 그 외이면 `PROJECT_NAME`, `PROJECT_STATUS`, `BIZ_TYPE_NAME` 존재 시 각각 잠금 (L1116~1124).
  - 공통 잠금: `ITEM_CLASS_NAME`, `ITEM_NAME`, `MEASURE`, `NICK_NAME` (L1126~1133).
  - **전주 이전 잠금** (L1137~1157): `drpDateTime.Value1 < Now.AddDays(-7)` 일 때만. `dtWeek` 를 순회하여 첫 `BASIS_START_DATE`(=`sThisWeek`) 와 다른 값이 나오는 순간 `LockRange2(iRow, MEASURE, iRow, GetColumnIndex("W_"+sLastWeek), true)` 후 break. 루프 상한이 `j <= dtWeek.Rows.Count` 라 마지막에 IndexOutOfRange 가 발생하지만 `catch { break; }` 로 삼킴 (L1155).

**(D) Measure 별 잠금** (L1171~1208)
- `sMeasure` 대문자에 **`KRW` / `USD` / `RTF` 중 하나라도 포함**되면 → `LockRange2(iRow, MEASURE+1, iRow, maxCol, true)` (수치 전 구간 잠금). 즉 **입력 가능 Measure 는 LOC 뿐** (L1179~1182). (L1173~1176 의 정확일치 버전, L1199~1208 의 KRW/USD 개별 분기는 **주석(비활성)**)
- `sMeasure == "LOC"` 이고 편집모드이면 (L1184~1197): `CURRENCY` 컬럼이 존재할 때 해당 셀 **잠금 해제** + `Columns["CURRENCY"].MergePolicy = MergePolicy.None` — [E20250113-000150] Edit 시 Currency 수정 허용. (L1194 `SetColumnMerge` 는 **주석(비활성)**)

### 3-5. 마무리 (L1212~1219)

- `GetMaxRowIndex() != -1 && iResultCol > iStartCol` → 과거 구간 `Gainsboro`, 당월(`iResultMonth`) `White` 재도색.
- `ResumeLayout()`.

**호출 SP**: `DM.UP_FX_GetCommonDataList_DM` (`CODE='DM_UI_EDITABLE_DIVISION'`, `PARAM1='DMF0020'`, `PARAM2=clbDivisions.ControlValues`).
**MSG**: MSG00448 / MSG00113 / MSG00412.

---

## 4. InsertButton / InsertRow — 행 추가

**트리거**: 공통 행추가 버튼 → `InsertButton()` (L836~844).

### 4-1. InsertButton (L836~844)

1. `!isCurVersion` → **조용히 return** (L839).
2. `HaltAutoFilter = true` → `InsertRow()` → `HaltAutoFilter = false` (L841~843).

### 4-2. InsertRow 가드 (L1985~1987)

- `siMain != null && siMain.IsLock(sheet) == false` (편집모드) **AND** `siMain.SheetName == "Sales Price"` 일 때만 실행. 아니면 무동작(메시지 없음).

### 4-3. 처리 단계

1. `HaltAutoFilter=true`, `SuspendLayout()` (L1989~1990).
2. 현재 활성 행이 속한 블록의 첫 행으로 이동: `iArray = GetCellNumbersByRow(ActiveRowIndex)` → `SetActiveCell(iArray[0], 2)` (L1992~1993).
3. **`siMain.Insert2(dtMeasureCount.Rows.Count)`** — Measure 개수만큼 행 삽입 (L1997).
4. **콤보 데이터 준비** (L2000~2025)
   - `sDivision = clbDivisions.SelectedValue.ToString()`.
   - `dtTeamAuth = Data.UserTeamByDivisionAuth(NowGroupID, UserId, sDivision)` (L2003).
   - Division `"40"` (L2007~2015): `dtSalesSiteAuth = Data.UserSiteByEndCustomer(...)`, `dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, ...)`, **`GetCustomsHandbook()`** 조회 후 `DOM_EXP` 셀 콤보 세팅 (SP `DM.UP_FX_GetCommonDataList_DM`, `CODE='DM_CUSTOMS_HANDBOOK'`).
   - 42/44 분기 (L2016~2020) — **주석(비활성)**.
   - 그 외 (L2021~2025): `Data.UserSiteByEndCustomerAuth(...)`, `Data.UserEndCustomerByDivisionDeptAuth(...)`.
5. **INCOTERMS 콤보** (L2026~2030, [E20250919-001699]): `dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "")` → `SetCellTypeCombo(ActiveRowIndex, INCOTERMS, ...)`. `PARAM2='Y'` 로 **VALID_YN='Y' 인 현행 코드만** 노출.
6. **첫 행 셀타입 배선** (L2033~2044): 존재하는 컬럼에 한해 `DEPT_ID`←dtTeamAuth, `SCM_SITE_ID`←dtSalesSiteAuth, `END_CUSTOMER`←dtEndCustomerAuth, `PROJECT_CODE`←`cellTypeImage`(팝업), `END_CUSTOMER40`←dtEndCustomerAuth, `ITEM_ID`←`cellTypeImage`(팝업). (`CURRENCY` 콤보 L2047~2048 은 **주석(비활성)** — UI Category 관리로 이관)
7. **Measure 행 루프** `for i in 0..dtMeasureCount.Rows.Count-1` (L2049~2176)
   - `DIVISION_ID` 에 `clbDivisions.SelectedValue` 세팅 후 **해당 셀 잠금** (L2051~2052).
   - `INCOTERMS` 콤보 재세팅 (L2055~2056), `ITEM_ID` 팝업 셀타입 (L2058~2059). (`CURRENCY` 콤보 L2061~2062 **주석(비활성)**)
   - `DEPT_ID` / `SCM_SITE_ID` 콤보 (L2065~2072). (`DEPT_ID` unlock L2068 **주석(비활성)**)
   - **`MEASURE` 에 `dtMeasureCount.Rows[i]["LOOKUP_CODE"]` 세팅** (L2073~2074).
   - `DIVISION_ID+1 ~ MEASURE` 구간 **잠금 해제** (L2076).
   - Division `"40"` → `END_CUSTOMER40` 콤보 (L2078~2082, 내부 ProjectStatus 잠금 **주석(비활성)**).
     그 외 → `END_CUSTOMER` 콤보, `PROJECT_CODE` 팝업셀, `PROJECT_NAME`/`PROJECT_STATUS`/`BIZ_TYPE_NAME` 잠금 (L2083~2095).
   - 공통 잠금: `ITEM_CLASS_NAME`, `ITEM_NAME`, `MEASURE`, `NICK_NAME` (L2099~2106). (`ITEM_ID` 잠금 L2098 **주석(비활성)**)
   - **Measure 별 분기** (L2108~2172)
     - `LOOKUP_CODE != "LOC"` → `LockRange2(row, MEASURE, row, maxCol, true)` — **수치 입력 불가**.
     - `LOOKUP_CODE == "LOC"` → 전주 이전 잠금 루프 (L2154~2170). `dtWeek` 순회하며 첫 `BASIS_START_DATE` 와 다른 값 만나면 `MEASURE ~ W_{sLastWeek}` 잠금 후 break. **`if (drpDateTime.Value1 < Now.AddDays(-7))` 조건은 주석 처리(L2151~2152, L2171)되어 항상 실행**. (L2114~2148 의 색상 기반 대체 로직 블록 전체는 **주석(비활성)**)
   - `PRICE_EXIST` 셀 잠금 (L2175).
8. **RowSpan 병합**: `CUIControl.SetRowSpanFuc(siMain, ActiveRowIndex, dtMeasureCount.Rows.Count-1, 1, MEASURE-1, Left, Center)` (L2180).
9. AutoFilter 재적용 (L2193~2195): `RowFilter.UnfilteredRows = null` → `ManualAutoFilter(siMain.SpreadObject)`.
10. `this.IsChange = true` (L2196), `SuspendLayout()`/`ResumeLayout()` (L2197~2198).
    (L2182~2208 사이 `SmartColMerge`, `CanModelChange`, `Refresh` 등 다수 라인은 **주석(비활성)**)

**호출 SP/서비스**: `Data.UserTeamByDivisionAuth`, `Data.UserSiteByEndCustomer(Auth)`, `Data.UserEndCustomerByDivisionDeptAuth`, `Data.Common(EndCustomerByDivision40)`, `DM.UP_FX_GetCommonDataList_DM`(CUSTOMS_HANDBOOK / INCOTERMS).
**MSG**: **없음** (InsertRow 경로에는 메시지 박스 없음).

---

## 5. DeleteButton — 행 삭제

**트리거**: 공통 행삭제 버튼 (L846~859).

1. **가드** (L848~849): 활성 행의 `Action` 컬럼 값이 `"I"` (신규 추가행) 가 **아니면 즉시 return**. ⇒ **기존(조회된) 행은 이 버튼으로 삭제 불가**, 메시지 없음.
   - `isCurVersion` 검사 **없음**, 편집모드(`IsLock`) 검사 **없음**.
2. `iResult = GetCellNumbersByRow(ActiveRowIndex)` — 블록 전 행 인덱스 (L851).
3. **역순 루프** `for i = iResult.Length-1 downto 0` (L853~858): `SetActiveCell(iResult[i], 2)` → `siMain.Delete()`. ⇒ Measure 블록 전체를 아래에서 위로 삭제.

**호출 SP**: 없음 (그리드 로컬 삭제).
**MSG**: 없음.

---

## 6. SaveButton / SaveData — 저장

**트리거**: 공통 저장 버튼 → `SaveButton()` (L1224~1228) → `SaveData()` (L1538~1970, `async void`).

### 6-1. 선행 가드

| 순 | 라인 | 조건 | 처리 |
|---:|---|---|---|
| 1 | L1549~1553 | `blnWork == true` | **MSG00137** 후 return |
| 2 | L1555 | — | `blnWork = true` |
| 3 | L1558 | `siMain != null && siMain.IsLock(sheet) == false` | **편집모드일 때만** 진행. 조회모드면 전체 스킵(메시지 없음) |
| 4 | L1562 | `siMain.SheetName == "Sales Price"` | 아니면 전체 스킵 |

### 6-2. 1차 검증 루프 — 신규(I) 행 필수값 + 중복 (L1566~1706)

루프: `for (int i = 0; i <= GetMaxRowIndex(); i += 4)` — **4행 블록 하드코딩** (주석 L1564~1565: "3의 배수 → RTF 추가로 4배수 변경").

1. `action = Action 셀 값` (L1569).
2. **NewFlag 보정** (L1573~1578): `NEW_FLAG` 컬럼이 있으면 값을 읽어, `NEW_FLAG=='Y' && action=='M'` → `action = 'I'` 로 승격 ([C20201217-000129]).
3. `action != 'I'` → `continue` (L1581~1582). ⇒ **필수값·중복 검증은 신규행에만 적용**. (같은 줄의 `&& action != M && action != D` 는 **주석(비활성)**)
4. `CurrentDataRow = i` 후 `if (sDIVISION_ID == "82" && sNewFlag == "Y") CurrentDataRow = GetCellIndexBySpanRowCells(i)` (L1596~1598).
   - ⚠️ **실측 결함**: `sDIVISION_ID` 는 L1583 에서 `""` 로 선언되고 **L1601 에서야 값이 할당**된다. 즉 L1597 시점에는 항상 `""` 이므로 **이 분기는 절대 성립하지 않는다**.
5. 값 수집 (L1601~1630) — 존재하는 컬럼만:
   - `sDIVISION_ID` ← `DIVISION_ID` (행 `i`)
   - `sPROJECT_CODE` ← Division `"40"` 이면 `END_CUSTOMER40`, `81*`/`82` 이면 `PROJECT_CODE` (L1606~1613). (42/44 분기 L1605 는 **주석(비활성)**)
   - `sSCM_SITE_ID`, `p_plant_site_id`, `sITEM_ID`, `sCURRENCY`, `sMEASURE` ← 행 `i`
   - `sDomExp`, `sFcstType`, `sINCOTERMS` ← 행 `CurrentDataRow`
6. **필수값 검증** (L1634~1685): `sDIVISION_ID` / `sPROJECT_CODE` / `sSCM_SITE_ID` / (`81*` 일 때 `p_plant_site_id`) / `sITEM_ID` / `sCURRENCY` / `sMEASURE` / `sDomExp` / `sFcstType` / `sINCOTERMS` 중 하나라도 빈 값이면
   - 누락 항목명을 `sMsg` 에 조립 (**else-if 체인이라 실제로는 최초 1건만 담김**): `[Division]` / `[End Customer]`(40) 또는 `[Project Code]`(81·82) / `[Sales Site]]`(원문 대괄호 오타 그대로) / `[Model]` / `[Currency]` / `[Measure]` / `[Customs Handbook]` / `[FCST Type]` / `[Incoterms]` / `[Plant Site]`.
   - **MSG00002** (인자 `sMsg`) → `SetActiveCell(i, 2)` 로 포커스 이동 → **return**.
   - ⚠️ `[Plant Site]` 분기(L1675~1676)는 앞의 `else if (sPROJECT_CODE=="")`… 체인 뒤에 있고 선행 조건이 모두 실패한 경우에만 도달하므로, PlantSite 단독 누락 시 `sMsg` 가 빈 문자열이 될 수 있음 (실측).
7. **중복 검증** (L1689~1705): `fnValidation()` 이 `false` 이면
   - `sMsg` = `[Division],` + (40 이면 `[End Customer],` / 그 외 `[Project Code],[PLANT_SITE_ID]`) + `[Sales Site],[Model],[INCOTERMS],[FcstType],[Customs Handbook],[Currency]`
   - **MSG00043** 후 return.

#### fnValidation (L2213~2348)

- 외부 루프 `iRow += 4`, 내부 루프 `iRow2 += 4` — **O(n²) 자기 대조**.
- 외부 루프는 `Action == 'I'` 인 행만 대상 (L2225).
- 키 구성 (Division 별, `clbDivisions.ControlValues` 기준):
  - `81*` (L2269~2285): `DIVISION_ID` + `PROJECT_CODE` + `SCM_SITE_ID` + `ITEM_ID` + `DOM_EXP` + `FCST_TYPE` + `INCOTERMS` + `CURRENCY` + `MEASURE` + **`PLANT_SITE_ID`** (10키)
  - `82` (L2286~2301): 위에서 `PLANT_SITE_ID` 제외 (9키)
  - 그 외(40) (L2316~2331): `PROJECT_CODE` 대신 **`END_CUSTOMER40`**, `PLANT_SITE_ID` 제외 (9키). 이때 `sDivision` 은 값 조회가 아니라 **문자열 `"40"` 을 하드코딩** (L2243).
  - 42/44 분기 (L2302~2315) — **주석(비활성)**
- 일치 카운트 `iValidation > 1` 이면 break 후 `false` 반환 (L2333~2345).

### 6-3. 2차 루프 — payload 조립 (L1724~1866)

루프: `for (int i = 0; i <= GetMaxRowIndex(); i++)` (**전 행**, 4배수 아님).

1. `action` / `sDIVISION_ID` 취득 (L1726~1729).
2. `action == 'I'` → `blnInsert = true` 플래그 (L1732~1733).
3. `action` 이 `I`/`M`/`D` 중 어느 것도 아니면 `continue` (L1735~1738).
4. **기준행 결정** (L1741~1746): `action=='I'` **또는** (`sDIVISION_ID=="82" && NEW_FLAG=='Y' && action=='M'`) 이면 `CurrentDataRow = GetCellIndexBySpanRowCells(i)` (블록 첫 행), 아니면 `i`.
5. 속성값 재수집 — **모두 `CurrentDataRow` 기준** (L1748~1780): `DIVISION_ID`, `SCM_SITE_ID`, `PROJECT_CODE`(40→`END_CUSTOMER40`, 81→`PROJECT_CODE`+`PLANT_SITE_ID`, 82→`PROJECT_CODE`), `ITEM_ID`, `INCOTERMS`, `CURRENCY`, `FCST_TYPE`, `DOM_EXP`.
   - `PLANT_SITE_ID` 는 **81 분기에서만** 채워짐 (L1765). 40/82 는 `""`.
6. 오류 표출용 백업 (L1784~1787): `sScmsiteid`, `sProjectcode`, `sItemid`, `sDivision` — [E20240206-000758].
7. **`sMEASURE` 는 원래 행 `i` 기준** (L1791).
8. **RTF 제외** (L1795): `sMEASURE == "RTF" || sMEASURE == "RTF_SYS_RP"` → `continue` (저장 대상 아님).
9. `iCUD = 0` 초기화 후 **컬럼 루프** `for j = MEASURE+1 .. maxCol` (L1798~1861)
   - **Red 색 필터** (L1803~1806): `iArray = GetCellNumbersByRow(i)` → **블록의 마지막 행**(`iArray[iArray.Length-1]`) 의 `j` 열 ForeColor 가 `Color.Red` 가 아니면 `continue`. ⇒ **변경 표식(Red)이 저장 대상 수집의 유일한 기준**. (L1808~1814 의 Action 기반 대체 판정은 **주석(비활성)**)
   - **`M_` 컬럼 제외** (L1816~1817): 월 SUM 컬럼은 payload 에 포함하지 않음 ⇒ **주차(`W_`) 컬럼만 저장**.
   - `sYYYYMMDD = GetColumnTag(j).Replace("W_","")` (L1819).
   - `sPRICE = Convert.ToString(GetValue(i, j))`; 빈 값이면 `"0"` (L1821~1825).
   - **stempAction 보정** (L1826~1836): `action != "D" && sMEASURE == "LOC" && sPRICE == "0"` → `stempAction = "D"` (0 입력 = 삭제). LOC 이외 Measure 는 0 이어도 상태 유지 ([E20240206-000758]). (`else stempAction=""` L1834~1835 는 **주석(비활성)**)
   - **17개 키에 `CString.AppendStringEx(기존값, 신규값, iCUD)` 로 누적** (L1838~1855) — 구분자 `"^"`.
   - `(j % 20) == 0` 마다 `Application.DoEvents()` (L1857~1858).
   - `iCUD++`.
10. `iUpdateRow = i`, `iCUD_R++`, `iCUD_Total += iCUD` (L1863~1865).
11. `prg.Close()` (L1868).

#### payload 구성 전수 (17 키)

`CString.AppendStringEx(string name, string value, int appendIndex, string delimiter = "^")` (원천: `01.Framework\GSCM.Windows.Forms\Utility\CString.cs` L641~654) — `appendIndex==0 && name==null` 이면 구분자 없이 최초 값, 그 외에는 `"^" + value` 를 append. `iCUD` 는 **행마다 0 으로 리셋**(L1798)되지만 `nvc[key]` 가 이미 non-null 이므로 두 번째 행부터는 정상적으로 `^` 가 붙는다. ⇒ **결과는 전 행·전 컬럼을 관통하는 단일 `^` 구분 문자열**.

| # | 파라미터 키 | 소스 | 기준 행 | 비고 |
|---:|---|---|---|---|
| 1 | `p_active_flag` | `stempAction` | 행 `i` 의 Action (+NewFlag/LOC-0 보정) | `I`/`M`/`D` |
| 2 | `p_DIVISION_ID` | `DIVISION_ID` | `CurrentDataRow` | |
| 3 | `p_PROJECT_CODE` | 40=`END_CUSTOMER40` / 81·82=`PROJECT_CODE` | `CurrentDataRow` | Division 분기 |
| 4 | `p_SCM_SITE_ID` | `SCM_SITE_ID` | `CurrentDataRow` | |
| 5 | `p_PLANT_SITE_ID` | `PLANT_SITE_ID` | `CurrentDataRow` | **81 사업부만 값 존재**, 40/82 는 `""` |
| 6 | `p_ITEM_ID` | `ITEM_ID` (GetText) | `CurrentDataRow` | |
| 7 | `p_YYYYMMDD` | 컬럼 Tag `W_` 제거값 | (컬럼) | **주차 시작일**. `M_` 컬럼은 제외 |
| 8 | `p_CURRENCY` | `CURRENCY` (GetText) | `CurrentDataRow` | |
| 9 | `p_MEASURE` | `MEASURE` (GetText) | **행 `i`** | `RTF`/`RTF_SYS_RP` 는 사전 제외 |
| 10 | `p_DOM_EXP` | `DOM_EXP` | `CurrentDataRow` | |
| 11 | `p_FCST_TYPE` | `FCST_TYPE` | `CurrentDataRow` | |
| 12 | `p_INCOTERMS` | `INCOTERMS` | `CurrentDataRow` | |
| 13 | `p_PRICE` | 셀 값, 빈값→`"0"` | 행 `i`, 컬럼 `j` | |
| 14 | `p_CREATED_BY` | `UserInfoContext.Current.UserId` | — | **감사 컬럼** |
| 15 | `p_CREATION_DATE` | `System.DateTime.Now.ToString()` | — | **감사 컬럼** (클라이언트 시각, 포맷 미지정) |
| 16 | `p_LAST_UPDATED_BY` | `UserInfoContext.Current.UserId` | — | **감사 컬럼** |
| 17 | `p_ROWNUM` | `(i + 1).ToString()` | 행 `i` | [PJ20200138] 초과 데이터 표시용 |

> `p_LAST_UPDATE_DATE` 는 **없음**. `p_MEASURE` 만 원래 행 기준이고 나머지 속성은 전부 블록 첫 행(`CurrentDataRow`) 기준이라는 점이 핵심 규약.

**조건부 포함/제외 요약**
- 제외: `Action` 이 `I`/`M`/`D` 아님 / `MEASURE` 가 `RTF`·`RTF_SYS_RP` / 컬럼 Tag 가 `M_` / 블록 마지막 행의 해당 셀 ForeColor 가 Red 아님.
- 변환: 빈 Price → `"0"`; LOC & Price 0 & action≠D → active_flag `"D"`.

### 6-4. Price 필수 검사 (L1871~1893)

```
sPrice = nvc["p_PRICE"];
if (!string.IsNullOrEmpty(sPrice)) { sPrice = sPrice.Replace("0","").Replace("^",""); }   // ← 결과 미사용 (dead)
else { MSG00414(sScmsiteid, sProjectname, sProjectcode, sItemid); return; }
```
- `sProjectname` = Division `"40"` 이면 `"END CUSTOMER"`, 그 외 `"PROJECT_CODE"` (L1880~1888).
- ⇒ **`p_PRICE` 가 비었을 때(=수집된 셀 0건)만 MSG00414 후 중단**. 비어있지 않은 경우의 `Replace` 결과는 어디에도 쓰이지 않는 **dead code**.

### 6-5. 저장 SP 호출 (L1896~1912)

- `FoxAsyncProxy(this)` (ShowProgress 기본값) + `FoxDataClient` → **`DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL`**
- `CommandTimeout = 90 * 60` (5,400초).
- `for (i=0; i<nvc.Count; i++) request.Parameters[nvc.GetKey(i)] = nvc[i];` — **NameValueCollection 을 그대로 전개**.

### 6-6. 결과 처리 (L1914~1954)

1. `ds.Tables[0].Rows[0][0] != "success"` → `Tables[0]` 0번 행의 **모든 컬럼을 `,` 로 이어붙여** `MessageBox.Show(sErrMsg, "Error!")` 후 return (L1915~1926). (`sErrMsg.TrimEnd(',')` 은 반환값 미사용 — 무효 라인 L1923)
2. `ds.Tables[3].Rows[0][0] != ""` → `MessageBox.Show(..., "Error!")` (L1928~1929) — **return 하지 않고 계속 진행**.
3. `panel1.Visible = false` (L1932) 후 **MSG00004** (인자 `iCUD_Total`) (L1933). (주석: `iCUD_R` 사용 안 함)
4. **Range Rate 초과 팝업** (L1939~1946): `ds.Tables[2].Rows.Count > 0` → `DMF0020_SalesPriceRangePopUp.LoadData(ds.Tables[2], sDivisionId)` → `ShowDialog()` (CenterParent).
   - `sDivisionId = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` (L1936).
   - `Tables[1]` 은 **사용처 없음**.
5. `blnWork = false` (L1948).
6. **후속 조회** (L1951~1954): `blnInsert` 이면 `FindData(true)`, 아니면 `FindData(false, iUpdateRow, ActiveSheet.ActiveColumnIndex)` (마지막 편집 셀로 복귀).

### 6-7. 예외 / finally

- `catch` (L1958~1962): `throw ex;` (재던짐). `blnWork=false` 는 **주석(비활성)** L1960.
- `finally` (L1963~1969): `prg.Close()`, `blnWork = false`.

**MSG**: MSG00137 / MSG00002 / MSG00043 / MSG00414 / MSG00004 + `MessageBox.Show` 2건(비 MSG-ID).

---

## 7. ExcelButton — 엑셀 다운로드

**트리거**: 공통 엑셀 버튼 (L1231~1263, [E20240903-000735] 속도 개선 반영).

1. `SimpleExcelExportOption` 생성 (L1233).
2. 파일명 = `Application.StartupPath + "\\" + this.Name + "_" + yyyyMMddHHmmss + ".xlsx"` (L1235).
3. 옵션 (L1237~1247): `Merge = None`, `Border = All`, `AheadZeroOption = ShowZero`, `AmendNullToZero = false`, `AheadNullToZero = false`, `AmendZeroOption = ShowZero`, `UserName = UserInfo.UserId`, `FileName = sFileName`, `AmendDecimalFormat = "#,##0.000;[Red]-#,##0.000"`. (`DateHeaderOption` L1246 은 **주석(비활성)**)
4. `SimplexelService.ExportFpSpread(fps, exportOption)` (L1251). (성능 측정용 `start2/end2` L1250·L1252 는 **주석(비활성)**)
5. `catch` → `throw e`; `finally` → `MessageService.CloseProgress()` (L1254~1261).

**선행 조건/가드**: 없음. **호출 SP**: 없음. **MSG**: 없음.

---

## 8. btnExcelUpload_Click — 엑셀 업로드 (81사업부 전용)

**트리거**: "Upload" 버튼 (Designer L1056). 표시 조건 = `clbDivisions.ControlValues.Substring(0,2) == "81"` (Form_Load L203~214 / clbDivisions 변경 L2579~2590).

1. `ExcelUploadForm frm = new ExcelUploadForm("DMF0020", spdMain.ActiveSheet.SheetName)` (L3938).
2. `frm.SaveExceptError = true` (L3939) — 오류 행 제외 저장.
3. `ShowDialog()` (CenterParent) (L3940~3941).
4. 닫힌 후 **MSG00265** 를 띄워 `DialogResult.Yes` 이면 `FindData(true)` (L3943~3946).

**호출 SP**: 없음 (업로드 폼 내부 처리). **MSG**: MSG00265.

---

## 9. btnTemplate_Click — 엑셀 양식/템플릿 (81사업부 전용)

**트리거**: "Excel Form" 버튼 (Designer L1097).

1. `MenuEtcFileDownButton("DMF0020_SalesFuturePric_Templete.xlsx")` — **주석(비활성)** (L3927).
2. `GSCM.DM.Master.UIL.POPUP.DMF0020_SalesPriceTemplatePopup frm = new ...(CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues))` (L3930).
3. `ShowDialog()` (CenterParent). 반환값 처리 **없음**.

**MSG**: 없음.

---

## 10. 조회조건 cascade

### 10-0. SetChangeControl 공통 진입 (L227~286)

모든 cascade 는 `DataService.GetDMInnerTable(triggerControl, Filter)` 로 통일. 공통 필터 (L229~230): `Filter["GROUP_ID"] = UserInfoContext.Current["NowGroupID"]`, `Filter["USER_ID"] = UserInfoContext.Current.UserId`.

| triggerControl | 추가 Filter | 대상 DataTable | 라인 |
|---|---|---|---|
| `MyDivision` | — | `dtDivision` | L234~238 |
| `UserTeamByDivision` | `DIVISION_ID` | `dtTeam` | L239~245 |
| `EndCustomerByDivision` | `DIVISION_ID`, `DEPT_ID` | `dtEndCustomer` | L246~253 |
| `BizType` | `DIVISION_ID` | `dtBizType` | L254~260 |
| `UserSiteByEndCustomer` | `DIVISION_ID`, `DEPT_ID`, `END_CUSTOMER` | `dtSalesSite` | L261~269 |
| `UserPlantSiteByDivision` | `DIVISION_ID` | `dtPlantSite` | L270~276 |
| `UserPlantSiteByEndCustomer` | `DIVISION_ID`, `END_CUSTOMER` | `dtPlantSiteByEndCustomer` | L277~284 |

### 10-1. clbDivisions_SelectedIndexChanged (L2465~2601)

**트리거**: Division 체크리스트 변경. 배선 위치 = `DefineProperty` L471 (Designer 아님).

1. **가드**: `blnWork == true` → **조용히 return** (L2470~2474, MSG00137 은 **주석(비활성)** L2472). 이후 `blnWork = true`.
2. `DataService.FP_Log2("SpeedUp","DMF0020","division_id_changed","start")` (L2479).
3. `sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` (L2480).
4. `SetChangeControl("UserTeamByDivision", sDivision)` → `clbTeam` 재바인딩 (L2484~2485), `sTeam` 산출 (L2487).
   - (L2489 `btnSavePricePeriod.Enabled` 는 **주석(비활성)**)
5. **분기 A — `81*` 또는 `82`** (L2491~2530)
   - `EndCustomerByDivision(sDivision, sTeam)` → `clbEndCustomer` (L2495~2496).
   - **`dtBizType = GetBizTypebyDivision(clbDivisions.ControlValues)` (L2499, 활성)** 직후 **`SetChangeControl("BizType", ...)` (L2500) 로 다시 덮어씀** — 두 호출이 연속으로 존재하며 최종 값은 후자. (L2498 주석은 "원소스 주석 처리" 라 되어 있으나 L2499 는 실제로 **주석 해제된 활성 코드**임에 주의)
   - `clbBizType` 바인딩, `lblProject.Enabled=true`, `layoutControlItem6.Enabled=true` (L2502~2506). (`lblBizType` L2505 **주석(비활성)**)
   - `sDivision.IndexOf("81") != -1` → `UserPlantSiteByEndCustomer` → `clbPlantSite` (L2508~2516).
   - `sDivision == "82"` → `checkInvalidExec.Enabled=true`, `lblPlantSite.Enabled=false`, `clbPlantSite.ControlValues=""`; 그 외 → `checkInvalidExec.Enabled=false`, `lblPlantSite.Enabled=true` (L2519~2529).
6. **분기 B — 그 외(40 등)** (L2531~2552): `EndCustomerByDivision(sDivision, clbTeam.ControlValues)`, `BizType`, `lblProject/lblPlantSite/layoutControlItem6` 모두 비활성, `checkInvalidExec.Enabled=false`, `clbPlantSite.ControlValues=""`.
7. `lblBizType.Enabled = true` 무조건 (L2553~2556, 42/44 분기 **주석(비활성)**).
8. **`sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbEndCustomer.ControlValues)`** (L2558)
   - ⚠️ **실측 결함**: `dtCustomer` 는 L90 에서 선언만 되고 **어디서도 채워지지 않는 null 필드**. `GetCheckedListValue` 는 `dt == null` 이면 `controlValues` 를 그대로 반환하므로(CString.cs L531~532) 결과적으로 `"ALL"` 이 그대로 전달된다. (`clbTeam_SelectedIndexChanged` L3674 도 동일 패턴)
9. `SetChangeControl("UserSiteByEndCustomer", sDivision, "", sEndCustomer)` → `clbSalesSite` (L2562~2563).
10. `FP_Log2(... "end")` (L2566). (PlantSite 구소스 L2568~2570 **주석(비활성)**)
11. **입력값 초기화** (L2572~2574): `txtOwner.Text=""`, `umltProject.Text=""`, `umltModel.Text=""`.
12. **`InitSpread(true)`** (L2576) — 헤더 강제 재생성 (Division 별 컬럼 구성이 다르므로).
13. **엑셀 버튼 표시 분기** (L2579~2590) — Form_Load L203~214 와 동일 로직.
14. `catch` → `blnWork=false; throw ex;` / `finally` → `blnWork = false` (L2592~2600).

**결과/후속**: 그리드는 헤더만 재생성되고 **데이터 재조회는 하지 않음** (사용자가 조회 버튼을 눌러야 함).
**MSG**: 없음(활성 기준).

### 10-2. clbTeam_SelectedIndexChanged (L3655~3680)

1. `sDivision`, `sTeam` 산출 (L3657~3658).
2. `clbDivisions.SelectedValue` 가 `81*` 또는 `"82"` → `SetChangeControl("EndCustomerByDivision", sDivision, sTeam)` (L3661~3666); 그 외 → `SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues)` (L3667~3672).
3. `clbEndCustomer` 재바인딩 (L3673).
4. `sEndCustomer = CString.GetCheckedListValue(dtCustomer, ...)` (L3674) — **§10-1 8번과 동일한 null `dtCustomer` 문제**.
5. `SetChangeControl("UserSiteByEndCustomer", sDivision, "", sEndCustomer)` → `clbSalesSite` (L3678~3679).

**가드**: 없음 (`blnWork` 체크 없음). **MSG**: 없음.

### 10-3. clbEndCustomer_SelectedIndexChanged (L3539~3545)

1. `SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, "", clbEndCustomer.ControlValues)` (L3543).
2. `clsCtrl.setListBox(dtSalesSite, clbSalesSite, true)` (L3544).

⚠️ **Plant Site 는 재조회하지 않음** (Division 변경 시에만 갱신). **가드/MSG 없음.**

### 10-4. usrDiscard_CheckedChanged — "Search over range" (L3829~3834)

- 체크 여부와 **무관하게** (`Checked` 값을 보지 않음) 실행:
  - `drpDateTime.Value1 = 이번 주 월요일 - 7일` (= 전주 월요일) (L3832).
  - `drpDateTime.Value2 = Value1 + 357일` (= 약 52주 후) (L3833).
- [PJ20200138] 규약. 실제 조회 시 `p_over_range` 는 `usrDiscard.Checked` 로 별도 전달 (FindData L1302).

### 10-5. cboBucketType_SelectedIndexChanged (L558~572)

1. `siMain != null` 일 때만 (L560).
2. **`SetSpreadColumn()`** (L562) — `W_`/`M_` 컬럼 표시 전환.
3. `!siMain.IsLock(sheet)` (편집모드) 이면 **`EditButton()` 을 2회 연속 호출** (L567~568) — 잠금 토글 2회로 원상복귀시키면서 Bucket 기준 잠금 규칙을 재계산.

### 10-6. cboBucketType_Click (L3817~3827)

- 전 행 순회하여 `siMain.GetText(iRow, 0) == "I"` (신규행 존재) 이면 **MSG00227** 후 return.
- ⚠️ 메시지만 띄우고 **콤보 조작을 실제로 차단하지는 않음** (Click 이벤트라 값 변경은 별도 `SelectedIndexChanged` 에서 발생).

### 10-7. umltProject_KeyDown / umltModel_KeyDown (L474~488)

- `umltProject`: `Keys.Enter` → `usrButton1_Click(null, null)` (Project 팝업).
- `umltModel`: `Keys.Enter` → `btnModelType_Click(null, null)` (Model 팝업).

---

## 11. 조회조건 팝업 버튼

### 11-1. usrButton1_Click — Project 팝업 (L2423~2440)

1. **가드** (L2425): `clbDivisions.SelectedValue.ToString() != "40"` 일 때만 실행. (40 사업부는 Project 개념 없음)
2. 파라미터: `sDivision`(=GetCheckedListValue), `sTeam`(=clbTeam.ControlValues), `sEndCustomer`, `sScmSite`, `sProject`(=umltProject.Text) (L2428~2432).
3. `SCM0002_ProjectbyDivisionPopupEx` → `Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject)` → `ShowDialog()` (CenterParent) (L2433~2436).
4. `umltProject.Text = popProject.ProjectCode` (L2438) — **취소 여부 검사 없이 무조건 대입**.

### 11-2. btnModelType_Click — Model 팝업 (L2442~2463)

1. 가드 **없음**.
2. 파라미터 6종 + `sItemId`(=umltModel.Text) (L2446~2452).
3. `DM0002_ItembyDivisionPopupEx.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId)` → `ShowDialog()` (L2455~2460). (`SCM0002_ItembyDivisionPopupEx` L2454 는 **주석(비활성)**)
4. `umltModel.Text = popItem.ItemID` (L2462).

### 11-3. btnOwner_Click — Owner 팝업 (L3771~3790)

1. 파라미터 7종 + `sOwner`(=txtOwner.Text) (L3774~3780).
2. `DM0020_OwnerbyDivisionPopup.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner)` → `ShowDialog()` (L3782~3787).
3. `txtOwner.Text = popItem.OwnerID` (L3789).

### 11-4. btnSPVer_Click — Version 팝업 (L3895~3922)

1. `sDivision` 산출 (L3898).
2. `dtTime = Data.MultiTimeZone(UserInfoContext.Current["TimeZone"])` → `sStartDate = dtTime.AddMonths(-3)`, `sEndDate = dtTime.AddMonths(3)` (L3900~3902).
3. `DMF0073_VersionBySalesPricePopup.Form_Load(true, "SP", sDivision, sStartDate, sEndDate)` → `ShowDialog()` (L3903~3906).
4. **결과 처리** (L3908~3921): `popVersion.sVersions != ""` 이면 `','` 로 split 하여
   - `Length > 2` → **MSG00255** ("읽기전용") 후 return.
   - 아니면 `txtVersion.Text = popVersion.sVersions` (L3918). (`drpPeriod.InitValue` L3919 **주석(비활성)**)

### 11-5. btnColumn_Click — 컬럼설정/타이틀셋 (L3792~3802)

1. `DM0002_TitleSetForm_Popup("DMF0020", "Sales Price", true, clbDivisions.ControlValues)` (L3794).
2. `ShowDialog()` (CenterParent).
3. `DialogResult == OK` → **`InitSpread(true)`** (L3798~3801) — 헤더 강제 재생성. **데이터 재조회는 하지 않음**.

**MSG**: 없음.

---

## 12. btnExchangeRate_Click — 환율 팝업 (L2395~2421)

1. **가드** (L2401~2406): `!siMain.IsLock(sheet)` (=편집모드) 이면 **MSG00142** 후 return. ⇒ **조회모드에서만 사용 가능**. (`IsEditMode()` 검사 L2399~2400, `MessageBox.Show("Edit Mode is not allowed.")` L2403 은 **주석(비활성)**)
2. `DMF0020_SalesFuturePricePopUp.LoadData(Value1.ToString("yyyyMM"), Value1.AddYears(1).ToString("yyyyMM"))` → `ShowDialog()` (L2408~2411).
3. **`popup.blnOK == true`** 이면 (L2413~2420):
   - `dtFuturePrice = GetFuturePriceInfo()` (환율 캐시 재적재, L2416).
   - `FindData(true)` (L2419). (`DefineProperty()` L2418 은 **주석(비활성)**)

---

## 13. btnSavePricePeriod_Click — Price 일괄입력 (L2360~2393)

1. **가드** (L2366~2371): `!siMain.IsLock(sheet)` (=편집모드) 이면 **MSG00408** ("수정모드에서는 입력할 수 없습니다") 후 return. (MSG00135 L2368 은 **주석(비활성)**, `IsEditMode()` 검사 L2364~2365 도 **주석(비활성)**)
2. `sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues)` (L2377).
3. `DMF0020_SaveSalesFuturePrice_Popup.LoadData(clbDivisions.ControlValues, Value1(yyyyMMdd), Value2(yyyyMMdd), clbSalesSite.ControlValues, umltProject.Text, sEndCustomer)` → `ShowDialog()` (L2374~2386).
4. **후속 처리 없음** — `popup.isSaveOK` 분기 및 `FindData(true)` 는 전부 **주석(비활성)** (L2388~2392). 주석에 "팝업창에서 데이터저장하고 창을 닫으면 sales price가 바로 조회된다" 라고만 기재.

---

## 14. btnBatch_Click — Batch Job (ADMIN 전용) (L3458~3494)

**표시 조건**: `DefineProperty` L454~467 에서 `NowGroupID` 가 `"ADMIN"` / `"DM ADMIN"` 인 경우에만 `layoutControlItem5` 표시.

1. `p_division_id = clbDivisions.ControlValues`; `"ALL"` 이면 `GetCheckedListValue(dtDivision, ...)` 로 전개 (L3460~3462).
2. **`p_division_id = p_division_id.Replace(",", "^")`** (L3464) — SP 전달용 `^` 구분.
3. 비동기 SP 호출 (L3469~3484): **`DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW`**, `CommandTimeout = 3*60`(180초), 파라미터 `p_division_id`, `p_CREATED_BY`. (`DM_H.DM0021_GET_DM_PLN_SALES_PLAN` L3473 은 **주석(비활성)**)
4. 결과: 모든 `ds.Tables[i].Rows[0][0]` 를 `";"` 로 이어 `sRMsg` 구성 (L3486~3490).
5. `p_division_id` 를 `^`→`,` 로 복원 후 **MSG00143** (인자 `p_division_id`, `sRMsg`) (L3492~3493).

**예외 처리**: try/catch **없음**.

---

## 15. Dsdm_Changed — 셀 값 변경 (핵심 cascade) (L2973~3103)

**트리거**: `DefaultSheetDataModel.Changed` (배선 L552~553). 편집모드에서 셀 값이 바뀔 때.

### 15-1. 가드 (순서 고정)

| 순 | 라인 | 조건 |
|---:|---|---|
| 1 | L2980~2981 | `siMain.IsLock(sheet) == true` (조회모드) → return |
| 2 | L2992~2993 | `e.Column < 0 \|\| e.Row < 0` → return (주석 L2990~2991: `IsLockCell` 에 -1 전달 시 이후 `InitSpread` 에서 에러) |
| 3 | L2994~2995 | `siMain.IsLockCell(e.Row, e.Column)` → return |
| — | L2976~2979 | `IsEditMode()` / `CanModelChange` 검사 — **주석(비활성)** |

`switch (e.Type)` 에서 **`CellsUpdated` 만 처리** (L2997~2999), 그 외 `default: break` (L3100~3101).

### 15-2. 수치 영역 처리 — `MEASURE < e.Column` (L3000~3074)

1. **블록 첫 행 산출**: `iFirstRow = GetCellIndexBySpanRowCells(e.Row)` (L3003).
2. `sCurrency` = 첫 행의 `CURRENCY`, `sDIVISION_ID` = 첫 행의 `DIVISION_ID` (L3004~3006).
3. **Currency 미지정 차단** (L3007~3012): `sCurrency == ""` 이면 방금 입력한 셀을 `""` 로 되돌리고 return.
4. `val = 입력값`; **빈 값이면 `"0"`** ([PJ20200138], L3015~3019).
5. **`val` 이 비어있지 않으면** (L3021~3045)
   - 입력 셀 ForeColor `Red` 설정 (L3024) — **저장 수집 표식**.
   - `for (i = dtMeasureCount.Rows.Count-1; i > 0; i--)` 역루프 (L3025~3044): 대상 행 `e.Row - i`
     - `sTargetER` = 대상 행의 `MEASURE`. **`RTF_SYS_RP` 이면 `continue`** (값 미기입, L3033).
     - `SetText2(e.Row-i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, 컬럼Tag.Substring(2,6), val, sTargetValue))` (L3036) — **환산값 자동 채움**.
     - 해당 셀 ForeColor `Red` (L3037).
     - 대상 행의 `Action`(0열) 이 `""` 이면 `CUIControl.SetActionFlagEx(spread, e.Row-i, "M")` (L3040~3042).
6. **`val` 이 비어있으면** (L3046~3058): 동일 역루프로 `e.Row-i` 셀을 `""` 로 지우고 Action 이 비면 `"M"` 설정. (`M_` 태그 검사 L3048·L3057 은 **주석(비활성)**)
7. **월(M_) SUM 셀 입력 시 주차 전개** (L3060~3073): 컬럼 Tag 가 `M_` 로 시작하면 `sYYYYMM = Tag.Substring(2,6)`, 이후 `e.Column+1 ~ maxCol` 중 Tag 의 `Substring(2,6)` 이 같은 컬럼마다 **`SetExchangeValues(i, e.Row, val)`** 호출.

### 15-3. Plant Site 재조회 cascade (L3076~3097)

- `sDivision = clbDivisions.ControlValues` (L3077). (행의 `DIVISION_ID` 사용은 L3076 **주석(비활성)**)
- `sDivision.Substring(0,2) == "81"` **AND** (`e.Column == PROJECT_CODE` 또는 `e.Column == ITEM_ID`) 이면
  - `dtPlantSite = Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId)` (L3085 / L3094)
  - `siMain.SetCellTypeCombo(e.Row, PLANT_SITE_ID, dtPlantSite)` (L3086 / L3095)

### 15-4. SetExchangeValues (L3105~3156)

1. `iFirstRow = GetCellIndexBySpanRowCells(iRow)`, `sCurrency`/`sDIVISION_ID` = 첫 행 기준 (L3108~3111).
2. **적용 가드** (L3113): 대상 셀 배경색이 `Color.Empty` **또는** `ControlColor.UnLockColor` 일 때만 진행 (= 편집 가능 셀만).
3. `sCurrency == ""` → 셀 비우고 return (L3116~3120).
4. `SetText2(iRow, iColumn, val)` (L3124) 후 Red 마킹, 그리고 §15-2 5번과 동일한 역루프로 나머지 Measure 행에 환산값 기입 + Red + Action `"M"` (L3125~3144).
   - ⚠️ 여기에는 **`RTF_SYS_RP` 제외 조건이 없다** (Dsdm_Changed 본체 L3033 과 달리 누락).
5. `val` 이 비면 역루프로 `""` 처리 + Action `"M"` (L3145~3154).

### 15-5. GetExchangeRate — 환산 4단계 (L3168~3209)

캐시 = `dtFuturePrice` (`DM.DMF0020_GET_FUTUREPRICE_INFO` 결과).

| 단계 | 라인 | 조건 | 계산 |
|---:|---|---|---|
| 1 | L3171~3172 | `sBaseER == sTargetER` | 입력값 그대로 반환 |
| 2 | L3175~3181 | `CURRENCY=sTargetER AND UNIT_CURRENCY=sBaseER AND YYYYMM AND DIVISION_ID` 행 존재 | `EXCHANGE_PRICE * sValue` (decimal) |
| 3 | L3183~3189 | `CURRENCY=sBaseER AND UNIT_CURRENCY=sTargetER ...` 행 존재 | `Round(1.0/EXCHANGE_PRICE, 5) * sValue` (double) |
| 4 | L3192~3203 | `CURRENCY='KRW' AND UNIT_CURRENCY=sBaseER` 및 `CURRENCY='KRW' AND UNIT_CURRENCY='USD'` 모두 존재 | `(sValue * dblKRW) / dblUSD` |
| 5 | L3205~3208 | 위 모두 미해당 | `sTargetVal == null` → `""`, 아니면 `"0"` |

---

## 16. spdMain_ComboSelChange — 그리드 콤보 선택 cascade (L2603~2904)

**트리거**: 그리드 셀 콤보 선택 변경 (Designer L163).
**전역 가드** (L2605): `siMain.IsLock(sheet) == false` (편집모드) 일 때만 전체 본문 실행.

기본값 (L2607~2610): `sDivision`/`sTeam`/`sEndCustomer`/`sScmSite` = `CAppSetting.StringALL`("ALL").

### 16-1. `e.Column == DIVISION_ID` (L2612~2680)

1. `sDivision` = 선택값.
2. `DEPT_ID` 컬럼 존재 시: `Data.UserTeamByDivision(NowGroupID, UserId, sDivision)` → `SetCellTypeCombo` → `CUIControl.SetCellRangeAligement(..., e.Row ~ e.Row+2, Left, Center)` (L2616~2624). (`UserTeamByDivisionAuth` L2619 **주석(비활성)**)
3. `END_CUSTOMER` 존재 시(81/82): `Data.UserEndCustomerByDivisionDeptAuth(...)` → 콤보 + 정렬 (L2626~2635).
   `END_CUSTOMER40` 존재 시(40): `Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, ...)` → 콤보 + 정렬 (L2636~2645).
4. `dtSalesSite = Data.UserSiteByEndCustomerAuth(...)` → `SCM_SITE_ID` 콤보 + 정렬 (L2648~2651).
5. `PLANT_SITE_ID` 콤보를 **기존 `dtPlantSite`** 로 세팅 (L2657) — 이 시점에 `dtPlantSite` 는 갱신되지 않음(구소스 L2655~2656 **주석(비활성)**).
6. **PlantSite 잠금 분기** (L2660~2663): `sDivision.Substring(0,2) != "81"` → 잠금, `81*` → 해제.
7. **After refresh — 하위 값 초기화** (L2665~2679): 존재하는 컬럼에 한해 `DEPT_ID`, `END_CUSTOMER`, `SCM_SITE_ID`, `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `ITEM_CLASS_NAME` 를 `""` 로 초기화.

> ⚠️ **도달 가능성(추정)**: `DIVISION_ID` 셀은 `InsertRow` L2052 와 `EditButton` L1034/L1066 에서 항상 잠기므로 실사용에서 이 분기가 발화하기 어렵다. 소스상으로는 활성 코드.

### 16-2. `e.Column == DEPT_ID` (L2681~2718)

1. `END_CUSTOMER` 또는 `END_CUSTOMER40` 컬럼이 존재할 때만 (L2683).
2. `sDivision`/`sTeam` 을 해당 행에서 재취득 (L2685~2686).
3. `81*` 또는 `82` → `Data.UserEndCustomerByDivisionDeptAuth(...)` → `END_CUSTOMER` 콤보; 그 외 → `Data.Common(EndCustomerByDivision40, false, sDivision, sTeam, ...)` → `END_CUSTOMER40` 콤보 (L2688~2701).
4. `Data.UserSiteByEndCustomerAuth(...)` → `SCM_SITE_ID` 콤보 + 정렬 (L2702~2704).
5. 하위 초기화 (L2706~2717): `END_CUSTOMER`, `SCM_SITE_ID`, `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `ITEM_CLASS_NAME` → `""`.

### 16-3. `e.Column == END_CUSTOMER` (L2719~2737)

1. `Data.UserSiteByEndCustomerAuth(NowGroupID, UserId, sDivision, sEndCustomer)` → `SCM_SITE_ID` 콤보 + 정렬 2회 (L2722~2725).
   - ⚠️ 이 분기에서 `sDivision` 은 초기값 `"ALL"` 그대로 (행에서 재취득하지 않음, 실측).
2. 하위 초기화: `SCM_SITE_ID`, `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `ITEM_CLASS_NAME` → `""` (L2727~2736).

### 16-4. `e.Column == SCM_SITE_ID` (L2738~2748)

- 하위 초기화만: `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `ITEM_CLASS_NAME` → `""`.

### 16-5. `e.Column == END_CUSTOMER40` (L2750~2758, 40 사업부)

1. 행에서 `sDivision`, `sEndCustomer` 재취득.
2. `Data.UserSiteByEndCustomer(NowGroupID, UserId, sDivision, sEndCustomer)` → `SCM_SITE_ID` 콤보 + 정렬 (L2755~2757).
3. **하위 초기화 없음**.

### 16-6. 공백 보정 3종 — 82사업부 자동완성 (L2761~2772)

`sTempRow` (= `Raw_CellClick` L3722 에서 기록한 최근 클릭 행) 의 값을 현재 행에 복사.

| 조건 | 라인 | 처리 |
|---|---|---|
| `e.Column == INCOTERMS` **AND** 현재 값이 `""` | L2761~2764 | `SetValue(e.Row, INCOTERMS, GetValue(sTempRow, INCOTERMS))` |
| `e.Column == FCST_TYPE` **AND** 현재 값이 `""` | L2765~2768 | 동일 패턴 |
| `e.Column == DOM_EXP` **AND** 현재 값이 `""` | L2769~2772 | 동일 패턴 |

### 16-7. `e.Column == CURRENCY` **AND** 현재 값이 `""` (L2774~2777)

- `sTempRow` 의 `CURRENCY` 값을 복사 ([C20200702-000136]).

### 16-8. `e.Column == CURRENCY` **AND** `Action != 'I'` — Currency 변경 재환산 (L2780~2901)

[E20250113-000150] 신규. **기존 행(조회된 행)의 Currency 를 바꾸면 전 기간을 재환산**한다.

1. (L2782~2786) `MSG00447` 안내와 `SetCurrencyChange(...)` 호출은 **주석(비활성)**. ⇒ 안내 메시지는 이 경로가 아니라 `spdMain_CellClick`(§18) 에서 나온다.
2. **Currency 값을 블록 전 행에 전파** (L2791~2798): `for (i = dtMeasureCount.Rows.Count-1; i > 0; i--)` → `SetText2(e.Row-i, e.Column, sCurrency)` + Red 마킹.
3. **재환산 시작 컬럼 산출** (L2801~2825): 이번 주 월요일 기준으로 `iResultCol`(과거 주차 마지막), `iResultMonth`(당월) 계산. `iResultCol > iStartCol` 일 때의 색상 처리(L2824)는 **주석(비활성)**.
4. **`iCCol = iResultCol+1 ~ maxCol` 전 컬럼 루프** (L2826~2900) — 각 컬럼마다
   - `iFirstRow = e.Row` (⚠️ 여기서는 `GetCellIndexBySpanRowCells` 를 쓰지 않고 **현재 행을 그대로 첫 행으로 간주**, L2829 — Dsdm_Changed L3003 과 다름).
   - `sCurrency == ""` → 셀 비우고 **return**(루프 전체 중단, L2834~2838).
   - `val = 해당 셀 값`, 빈 값이면 `"0"` (L2841~2845).
   - Red 마킹 후 역루프로 나머지 Measure 행에 `GetExchangeRate(...)` 결과 기입 + Red + Action `"M"` (L2847~2871). `RTF_SYS_RP` 는 `continue` (L2859).
   - `val` 이 비면 역루프로 `""` + Action `"M"` (L2872~2884).
   - 컬럼 Tag 가 `M_` 이면 같은 `yyyyMM` 인 후속 컬럼들에 `SetExchangeValues(i, e.Row, val)` (L2886~2899).

---

## 17. spdMain_CellDoubleClick — 팝업 호출 / 헤더 접기 (L3211~3345)

**트리거**: 그리드 더블클릭 (Designer L162).

### 17-1. 데이터 셀 (`e.ColumnHeader == false`) (L3213~3313)

1. `siMain.Sheet().Rows.Count <= 0` → return (L3215~3216).
2. `siMain.IsLock(sheet)` (조회모드) → **빈 블록**, 아무 동작 없음 (L3218~3221).
3. 편집모드일 때 (L3222~3312):
   - **가드** (L3224~3227): `IsLock` 이거나 해당 행 `Action != 'I'` → return. ⇒ **신규 추가행에서만 팝업 호출 가능**.
   - 행에서 `sDivision`, `sScmSiteId`, `sTeam` 취득; `sItemId = ""` 고정 (L3229~3232, `ItemId` 조회는 **주석(비활성)**).
   - Division `"40"` → `sEndCustomer = END_CUSTOMER40`; 그 외 → `sProject = PROJECT_CODE`, `sEndCustomer = END_CUSTOMER` (L3236~3245, 42/44 분기 **주석(비활성)**).
   - **A. `PROJECT_NAME` 또는 `PROJECT_CODE` 컬럼 더블클릭** (L3249~3290)
     - `SCM0002_ProjectbyDivisionPopupEx.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject)` → `ShowDialog()`.
     - 반환값 7종 수집: `ProjectCode`, `ProjectName`, `ProjectStatus`, `BizType`, `Currency`, `ProjectVerSeq`, `ProjectOwner` (L3264~3270) — **이 중 `BizType`/`Currency`/`ProjectVerSeq`/`ProjectOwner` 는 이후 사용되지 않음**.
     - 조건 `popProject.ProjectCode != "" || popProject.ProjectCode != null` (L3272) — **항상 참인 조건식** (실측).
     - 그리드 반영: `PROJECT_CODE`, `PROJECT_NAME`, `PROJECT_STATUS`, `BIZ_TYPE_NAME`(← `popProject.BizTypeName`) (L3274~3281).
     - After refresh: `ITEM_ID`, `ITEM_CLASS_NAME` → `""` (L3285~3288).
   - **B. `ITEM_CLASS_NAME` 또는 `ITEM_ID` 컬럼 더블클릭** (L3291~3310)
     - `DM0002_ItembyDivisionPopupEx.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId)` → `ShowDialog()`.
     - 조건 `popItem.ItemID != "" || popItem.ItemID != null` (L3298) — **항상 참** (실측).
     - 반영: `ITEM_ID`, `ITEM_CLASS_NAME`, `ITEM_NAME` (L3300~3305).
     - **`SetTextCellsToRowSpanRange(popItem.currency, e.Row, CURRENCY, dtMeasureCount.Rows.Count)`** (L3307~3308) → 블록 전 행의 `CURRENCY` 에 값 전파. (`SetTextCellsToRowSpanRange` L2913~2922: `SetValue` 후 컬럼명이 `"FCST_TYPE"` 이 아닐 때만 `SetText2` 도 수행)

### 17-2. 컬럼 헤더 더블클릭 — 접기/펼치기 (L3314~3344)

- Tag 가 **`M_`** 인 헤더 (L3317~3332): `e.Column` 부터 다음 `M_` 컬럼 직전까지 순회하며
  - `W_` 컬럼 → `Visible` 토글.
  - `D_` 컬럼 → 보이는 상태면 숨김.
- Tag 가 **`W_`** 인 헤더 (L3333~3343): `e.Column` 부터 다음 `W_` 컬럼 직전까지 `D_` 컬럼 `Visible` 토글.

**MSG**: 없음.

---

## 18. spdMain_CellClick / Raw_CellClick (L3684~3751)

### 18-1. spdMain_CellClick (L3684~3696)

1. **Currency 변경 안내** (L3686~3691): `e.Column == CURRENCY` **AND** 해당 행 `Action != 'I'` → **MSG00447** ("화면에 조회된 기간의 데이터만 Currency가 변경됩니다").
   - ⚠️ **편집모드 여부와 무관하게** 발화한다 (`IsLock` 검사 없음).
2. `sender == null || e == null` → return (L3693~3694).
3. `Raw_CellClick(siMain, e.Column, e.Row)` (L3695).

### 18-2. Raw_CellClick (L3698~3751)

**가드** (L3704): `!spread.IsLock(sheetName)` (편집모드) 일 때만.

1. `SuspendLayout()` (L3706).
2. **Plant Site 콤보 재조회** (L3707~3716): `_Column == PLANT_SITE_ID` **또는** `sDivision.Substring(0,2) == "81"` 이면
   - 행에서 `sDivision`, `sProject`(PROJECT_CODE), `sItem`(ITEM_ID) 취득.
   - `dtPlantSite = Data.Common(Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem)` → `SetCellTypeCombo(_Row, PLANT_SITE_ID, dtPlantSite)`.
   - ⚠️ 조건이 OR 이므로 **81사업부에서는 어느 셀을 클릭하든 매번 재조회**한다.
3. **INCOTERMS 콤보 재세팅** (L3717~3720, [E20250919-001699]): `GetLookupValues("INCOTERMS","ALL","Y","","","")` → `SetCellTypeCombo(_Row, INCOTERMS, ...)`. **컬럼 존재 검사 없이 무조건 호출**.
4. **`sTempRow = _Row`** (L3722) — §16-6/16-7 공백 보정의 기준 행 기록.
5. **82사업부 병합 재적용** (L3727~3738): `sDivision == "82"` 이고 클릭 컬럼이 `INCOTERMS` / `FCST_TYPE` / `DOM_EXP` 중 하나면
   `SetRowSpanFucTwo(spread, blockFirstRow, blockFirstRow + 3, col, col)` — **`+3` 하드코딩** (주석 L3725: "RTF 가 추가되었으므로 머지를 ROW+2가 아닌 +3으로").
   - `CURRENCY` 에 대한 동일 처리(L3742~3747)는 **주석(비활성)** — [E20250113-000150] 으로 Currency 개별 편집 허용하면서 병합 해제.
6. `ResumeLayout()` (L3748).

**SetRowSpanFucTwo (L3838~3875)**: 지정 행 범위에서 값이 바뀌는 지점마다 `AddSpanCell` 로 세로 병합 후 `HorizontalAlignment/VerticalAlignment = Center` 적용. (내부 `sFYear` 를 매 루프 재대입하므로 `sFYear != GetText(j,i)` 조건은 성립하지 않고, 실질적으로 `j == iEndRow` 시점의 `AddSpanCell(iFRow, i, iLRow, 1)` 만 수행됨 — 실측)

---

## 19. spdMain_KeyUp — 클립보드 복사/붙여넣기 (L3753~3769)

1. **가드** (L3755): `siMain.GetColumnIndex(MEASURE) >= siMain.ActiveColumnIndex` → return. ⇒ **수치(PIVOT) 영역에서만 동작**.
2. **붙여넣기** (L3757~3761): `(e.Control && e.KeyCode == Keys.V) || (!e.Control && e.KeyCode == Keys.V)` — 즉 **V 키만 눌러도 발화**(조건식이 Ctrl 유무를 모두 포함) → `spdMain.ActiveSheet.ClipboardPaste(ClipboardPasteOptions.AsStringSkipHidden)`.
3. **복사** (L3763~3768): 동일 구조로 **C 키** → `Clipboard.Clear()` 후 `spdMain.Sheets[0].ClipboardCopy(ClipboardCopyOptions.AsStringSkipHidden)`.
   - ⚠️ 복사는 `Sheets[0]` 고정, 붙여넣기는 `ActiveSheet` 기준 (본 화면은 단일 시트라 결과는 동일).

**MSG**: 없음. **편집모드 검사 없음**.

---

## 20. spdMain_TopChange (L3347~3352)

- 스크롤(최상단 행 변경) 시 `CanModelChange = false` → **`siMain.SmartColMerge()`** → `CanModelChange = true`.
- 목적: 병합 셀의 표시 텍스트를 뷰포트 기준으로 재계산.

---

## 21. DMF0020_SalesFuturePrice_Resize (L3530~3537)

- `panel1.Visible == true` 일 때만 `panel1` 을 폼 중앙으로 재배치 (`Left/Top` 계산).
- `panel1` 은 Designer L1443 에서 `Visible = false` 로 시작하며, 저장 성공 시 L1932 에서 다시 `false` 로 설정된다 (`true` 로 만드는 코드는 **이 화면 소스에 없음**).

---

## 22. BackgroundWorker 3종 (L3516~3528)

| 이벤트 | 라인 | 본문 |
|---|---|---|
| `backgroundWorker1_DoWork` | L3516~3519 | `Console.WriteLine("D" + DateTime.Now)` 만 |
| `backgroundWorker1_ProgressChanged` | L3521~3523 | **빈 본문** |
| `backgroundWorker1_RunWorkerCompleted` | L3525~3528 | `Console.WriteLine("E" + DateTime.Now)` 만 |

`RunWorkerAsync()` 호출부는 **이 화면 소스에 없음** ⇒ 실제 실행되지 않음.

---

## 부록 A. MSG ID 전수

### A-1. 활성 (실행되는 코드)

| # | MSG ID | 라인 | 발생 지점 | 인자 | 소스 주석 상 의미 |
|---:|---|---|---|---|---|
| 1 | `MSG00448` | L876 | EditButton — `DM_UI_EDITABLE_DIVISION.EDIT_YN='N'` | 없음 | 40사업부 편집 불가 ([PJ2025-50017]) |
| 2 | `MSG00113` | L892 | EditButton — Division 40 필수컬럼 미존재 | 없음 | 필수 컬럼 누락 |
| 3 | `MSG00113` | L923 | EditButton — Division 81* 필수컬럼 미존재 | 없음 | 동일 |
| 4 | `MSG00113` | L938 | EditButton — Division 82 필수컬럼 미존재 | 없음 | 동일 |
| 5 | `MSG00412` | L952 | EditButton — `PRICE_EXIST` 컬럼 미존재 | `GetTerm("PRICE_EXIST")` | "[{0}] 은 필수 입력사항입니다" ([E20240903-000738]) |
| 6 | `MSG00137` | L1279 | FindData — 연속 작업 중 | 없음 | 작업 중 재실행 차단 |
| 7 | `MSG00283` | L1286 | FindData — Version 미선택 | 없음 | "Version을 선택하고 조회하세요" |
| 8 | `MSG00108` | L1307 | FindData — 기간 역전 | 없음 | 기간 오류 |
| 9 | `MSG00097` | L1327 | FindData — Division 미선택 | 없음 | 필수 조회조건 |
| 10 | `MSG00137` | L1551 | SaveData — 연속 작업 중 | 없음 | 동일 |
| 11 | `MSG00002` | L1679 | SaveData — 신규행 필수값 누락 | `sMsg`(항목명) | 필수 입력 |
| 12 | `MSG00043` | L1703 | SaveData — `fnValidation()` 실패 | `sMsg`(키 목록) | "저장시 중복 오류가 발생하였습니다.{0}" |
| 13 | `MSG00414` | L1890 | SaveData — `p_PRICE` 비어있음 | `sScmsiteid`, `sProjectname`, `sProjectcode`, `sItemid` | 가격 미입력 안내 ([E20240206-000758]) |
| 14 | `MSG00004` | L1933 | SaveData — 저장 성공 | `iCUD_Total` | "{0}개의 데이터가 저장되었습니다" |
| 15 | `MSG00408` | L2369 | btnSavePricePeriod — 편집모드 | 없음 | "수정모드에서는 입력할 수 없습니다" |
| 16 | `MSG00142` | L2404 | btnExchangeRate — 편집모드 | 없음 | Edit Mode 불가 |
| 17 | `MSG00143` | L3493 | btnBatch — 배치 완료 | `p_division_id`, `sRMsg` | 배치 결과 |
| 18 | `MSG00447` | L3690 | spdMain_CellClick — CURRENCY 셀 & Action≠'I' | 없음 | "화면에 조회된 기간의 데이터만 Currency가 변경됩니다" |
| 19 | `MSG00227` | L3823 | cboBucketType_Click — 신규행 존재 | 없음 | 신규행 존재 시 Bucket 변경 경고 |
| 20 | `MSG00255` | L3913 | btnSPVer — 선택 버전 3개 이상 | `null` | "읽기전용" |
| 21 | `MSG00265` | L3943 | btnExcelUpload — 업로드 폼 종료 후 | 없음 | 재조회 확인 (Yes/No) |

**고유 MSG ID: 18종** (`MSG00113` 3회 / `MSG00137` 2회 중복 제외) — MSG00002, MSG00004, MSG00043, MSG00097, MSG00108, MSG00113, MSG00137, MSG00142, MSG00143, MSG00227, MSG00255, MSG00265, MSG00283, MSG00408, MSG00412, MSG00414, MSG00447, MSG00448.
**총 호출 지점: 21개소.**

### A-2. 비활성 (주석 처리 — 실행되지 않음)

| MSG ID | 라인 | 위치 | 비고 |
|---|---|---|---|
| `MSG00113` | L907 | EditButton 42/44 분기 | 분기 전체 주석 |
| `MSG00137` | L2472 | clbDivisions_SelectedIndexChanged | 조용히 return 으로 대체 |
| `MSG00135` | L2368 | btnSavePricePeriod | MSG00408 로 대체 |
| `MSG00447` | L2784 | spdMain_ComboSelChange CURRENCY 분기 | L3690(CellClick) 로 이관 |

### A-3. MSG ID 없는 메시지 박스

| # | 라인 | 내용 |
|---:|---|---|
| 1 | L1924 | `MessageBox.Show(sErrMsg, "Error!")` — SaveData 결과 `Tables[0]` 첫 행 전 컬럼 `,` 결합 |
| 2 | L1929 | `MessageBox.Show(ds.Tables[3].Rows[0][0], "Error!")` — SaveData 부가 오류 |
| 3 | L1522 | `MessageHelper.GMessageBoxForException(ex)` — FindData 예외 |
| — | L2403 / L3760 / L3767 | `MessageBox.Show(...)` — **주석(비활성)** |

---

## 부록 B. 호출 SP · 서비스 전수

### B-1. FoxDataRequest 직접 호출 SP — 활성

| # | SP | 호출 메서드(라인) | 파라미터 | Timeout |
|---:|---|---|---|---|
| 1 | `DM.PR_GET_DAY_RANGE` | `GetDayRange` L423 | `p_created_by`, `p_month`(=6) | 기본 |
| 2 | `DM.DMF0020_GET_WEEKDATA` | `GetWeekData` L498 | `p_yyyymmdd` | 기본 |
| 3 | `DM.DMF0020_GET_MEASURE_COUNTINFO` | `GetMeasureCountInfo` L514 | 없음 | 기본 |
| 4 | `DM.DMF0020_GET_FUTUREPRICE_INFO` | `GetFuturePriceInfo` L531 | `p_start_yyyymmdd`, `p_end_yyyymmdd` | 기본 |
| 5 | `DM.DMF0020_GET_SPREAD_TITLE` | `GetSpdTitle` L3554 | `p_start_dt`, `p_end_dt`, `p_created_by`, `p_division_id` | 기본 |
| 6 | **`DM.DMF0020_GET_SCM_MST_FUTURE_PRICE`** | `FindData` L1349 | 18종 (§2-3 4번) | **600초** |
| 7 | **`DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL`** | `SaveData` L1902 | `nvc` 17키 (§6-3 표) | **5,400초** |
| 8 | `DM.DMF0003_GET_BUCKET_TYPE_CODE` | `GetBucketType` L3810 | 없음 | 기본 |
| 9 | `DM.UP_FX_GetCommonDataList_DM` | `GetCustomsHandbook` L3883 | `CODE='DM_CUSTOMS_HANDBOOK'`, `PARAM1~5=''` | 기본 |
| 10 | `DM.UP_FX_GetCommonDataList_DM` | `GetLookupValues(6)` L3957 | `CODE`, `PARAM1~5` — 실제 사용: `DM_UI_EDITABLE_DIVISION`(L870), `INCOTERMS`(L2027, L2056, L3718) | 기본 |
| 11 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | `GetBizTypebyDivision` L3631 (호출부 L2499) | `p_division_id` | 기본 |
| 12 | `DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW` | `btnBatch_Click` L3474 | `p_division_id`(`^` 구분), `p_CREATED_BY` | **180초** |

**바인딩**: `sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc"` (L76), `sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc"` (L74). (`sPlanBinding` L75 는 **주석(비활성)**)

### B-2. FoxDataRequest SP — dead 메서드 내부 (호출되지 않음)

| SP | 메서드(라인) |
|---|---|
| `SCM.SCM0001_GET_DIVISION` | `GetDivision` L3360 |
| `SCM.SCM0001_GET_SITE_BY_DIVISION` | `GetScmSitebyDivision` L3374 / `GetScmSitebyDivisionAsync` L3645 |
| `SCM.SCM0001_GET_SITE_INFO_BY_DIVISION` | `GetScmSiteInfobyDivision` L3390 |
| `SCM.SCM0001_GET_TEAM_BY_DIVISION` | `GetTeambyDivision` L3405 / `GetTeambyDivisionAsync` L3572 |
| `SCM.SCM0001_GET_CUSTOMER_BY_DIVISION` | `GetEndCustomerbyDivision` L3419 / `GetCustomerbyDivision` L3585 / `GetCustomerbyDivisionAsync` L3600 |
| `SCM.SCM0001_GET_LOOKUP_VALUES` | `GetLookupValues(1)` L3434 |
| `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER` | `GetPlantSitebyEndCustomer` L3448 / `GetPlantSitebyEndCustomerAsync` L3615 |
| `DM.DMF0020_GET_SPREAD_TITLE_DATE` | `InitSpread_X` L786 (`CUIControl.GetDataUsingByDBEx`) |

### B-3. DataService 서비스 호출 (속도개선 프로젝트 경로)

| 서비스 | 호출 형태 | 라인 |
|---|---|---|
| `DataService.GetDMInnerTable("MyDivision", Filter)` | `SetChangeControl` | L236 |
| `DataService.GetDMInnerTable("UserTeamByDivision", Filter)` | 〃 | L243 |
| `DataService.GetDMInnerTable("EndCustomerByDivision", Filter)` | 〃 | L251 |
| `DataService.GetDMInnerTable("BizType", Filter)` | 〃 | L258 |
| `DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter)` | 〃 | L267 |
| `DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter)` | 〃 | L274 — **호출 케이스 없음**(`SetChangeControl` 인자로 전달되는 지점 없음) |
| `DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter)` | 〃 | L282 |
| `DataService.FP_Log2("SpeedUp","DMF0020","division_id_changed", "start"/"end")` | clbDivisions 변경 | L2479 / L2566 |

### B-4. Data.* 정적 데이터 헬퍼

| 호출 | 라인 |
|---|---|
| `Data.Common(Data.Type.UpperDeptId, ...)` | L310 (`dtDepartment` — 미사용) |
| `Data.Common(Data.Type.EndCustomerByDivision40, ...)` | L2010, L2640, L2697 |
| `Data.Common(Data.Type.SalesPlant, ...)` | L3085, L3094 |
| `Data.Common(Data.Type.PlantSiteByItem, ...)` | L3713 |
| `Data.UserTeamByDivision(...)` | L2618 |
| `Data.UserTeamByDivisionAuth(...)` | L2003 |
| `Data.UserSiteByEndCustomer(...)` | L2009, L2755 |
| `Data.UserSiteByEndCustomerAuth(...)` | L2023, L2648, L2702, L2722 |
| `Data.UserEndCustomerByDivisionDeptAuth(...)` | L2024, L2630, L2690 |
| `Data.MultiTimeZone(...)` | L3900 |

### B-5. 기타 서비스

| 서비스 | 라인 | 용도 |
|---|---|---|
| `SimplexelService.ExportFpSpread(fps, exportOption)` | L1251 | 엑셀 다운로드 |
| `MessageService.CloseProgress()` | L1260 | 진행창 종료 |
| `CUIControl.SetActionFlagEx(spread, row, "M")` | L2868, L3042, L3055, L3142, L3152 | Action 플래그 세팅 |
| `CUIControl.SetCellRangeAligement(...)` | L2621, L2632, L2642, L2651, L2658, L2693, L2700, L2704, L2724, L2725, L2757 | 콤보 셀 정렬 |
| `CUIControl.SetRowSpanFuc(...)` | L2180 | 신규행 RowSpan 병합 |
| `MessageHelper.GetTerm("PRICE_EXIST")` | L948 | 용어 조회 |

---

## 부록 C. 호출 POPUP 전수

| # | 팝업 클래스 | 호출 지점 | 인자 | 반환 사용 |
|---:|---|---|---|---|
| 1 | `SCM0002_ProjectbyDivisionPopupEx` | `usrButton1_Click` L2433 | `Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject)` | `ProjectCode` → `umltProject.Text` |
| 2 | `SCM0002_ProjectbyDivisionPopupEx` | `spdMain_CellDoubleClick` L3259 | `Form_Load(false, ...)` | `ProjectCode`, `ProjectName`, `ProjectStatus`, `BizTypeName` → 그리드 |
| 3 | `DM0002_ItembyDivisionPopupEx` | `btnModelType_Click` L2455 | `Form_Load(true, ...)` | `ItemID` → `umltModel.Text` |
| 4 | `DM0002_ItembyDivisionPopupEx` | `spdMain_CellDoubleClick` L3293 | `Form_Load(false, ...)` | `ItemID`, `ItemClassName`, `ItemName`, `currency` → 그리드 |
| 5 | `DM0020_OwnerbyDivisionPopup` | `btnOwner_Click` L3782 | `Form_Load(true, ..., sOwner)` | `OwnerID` → `txtOwner.Text` |
| 6 | `DM0002_TitleSetForm_Popup` | `btnColumn_Click` L3794 | `("DMF0020","Sales Price", true, clbDivisions.ControlValues)` | `DialogResult.OK` → `InitSpread(true)` |
| 7 | `DMF0073_VersionBySalesPricePopup` | `btnSPVer_Click` L3903 | `Form_Load(true,"SP", sDivision, sStartDate, sEndDate)` | `sVersions` → `txtVersion.Text` (3개 이상이면 MSG00255) |
| 8 | `DMF0020_SalesFuturePricePopUp` | `btnExchangeRate_Click` L2408 | `LoadData(yyyyMM, +1년 yyyyMM)` | `blnOK` → 환율 재적재 + `FindData(true)` |
| 9 | `DMF0020_SaveSalesFuturePrice_Popup` | `btnSavePricePeriod_Click` L2374 | `LoadData(division, from, to, salesSite, project, endCustomer)` | **없음** (`isSaveOK` 분기 주석) |
| 10 | `DMF0020_SalesPriceRangePopUp` | `SaveData` L1941 | `LoadData(ds.Tables[2], sDivisionId)` | 없음 (표시 전용) |
| 11 | `DMF0020_SalesPriceTemplatePopup` | `btnTemplate_Click` L3930 | `(division)` | 없음 |
| 12 | `ExcelUploadForm` | `btnExcelUpload_Click` L3938 | `("DMF0020", ActiveSheet.SheetName)`, `SaveExceptError=true` | MSG00265 Yes → `FindData(true)` |

---

## 부록 D. 실측 결함·주의점 요약 (TO-BE 전환 시 확인 필요)

| # | 위치 | 내용 |
|---:|---|---|
| 1 | L1566 / L2223 / L2267 | `i += 4` 하드코딩 vs `dtMeasureCount.Rows.Count` 동적 값 — Measure 수가 4가 아니면 검증 누락 |
| 2 | L1597 | `sDIVISION_ID` 가 선언 직후(값 할당 전) 비교되어 82+NewFlag 분기가 **절대 성립하지 않음** |
| 3 | L1675~1676 | 필수값 메시지 else-if 체인 순서상 `[Plant Site]` 단독 누락 시 `sMsg` 가 빈 문자열이 될 수 있음 |
| 4 | L1871~1875 | `sPrice.Replace(...)` 결과 미사용 (dead) |
| 5 | L1923 | `sErrMsg.TrimEnd(',')` 반환값 미대입 (무효) |
| 6 | L2558 / L3674 | `dtCustomer` 가 **항상 null** → `GetCheckedListValue` 가 `"ALL"` 을 그대로 반환 |
| 7 | L2722 | `END_CUSTOMER` 콤보 변경 분기에서 `sDivision` 이 초기값 `"ALL"` 그대로 사용됨 |
| 8 | L2829 | Currency 재환산 루프의 `iFirstRow = e.Row` (블록 첫 행 산출 미적용) — Dsdm_Changed(L3003)와 불일치 |
| 9 | L3129~3143 | `SetExchangeValues` 에 `RTF_SYS_RP` 제외 조건 없음 (Dsdm_Changed L3033 과 불일치) |
| 10 | L1141 / L2155 | `for (j = 0; j <= dtWeek.Rows.Count; j++)` off-by-one — `catch { break; }` 로 은폐 |
| 11 | L3272 / L3298 | `x != "" \|\| x != null` — **항상 참**인 조건식 (팝업 취소 시에도 반영됨) |
| 12 | L3757 / L3763 | `(e.Control && V) \|\| (!e.Control && V)` — Ctrl 없이 **V/C 단독 입력만으로** 붙여넣기·복사 발화 |
| 13 | L203 / L444 | Form_Load 의 81 판정 시점에 `ControlValues` 가 이미 `"ALL"` 이라 최초 진입 시 엑셀 버튼 항상 숨김 |
| 14 | L2499~2500 | `GetBizTypebyDivision`(SCM SP) 호출 직후 `SetChangeControl("BizType")` 가 결과를 덮어씀 — 불필요한 왕복 1회 |
| 15 | L3707 | 81사업부에서 **모든 셀 클릭마다** PlantSite SP 재조회 (OR 조건) + L3718 INCOTERMS 매 클릭 재조회 |
| 16 | L1093~1106 | Monthly Bucket + 신규행일 때 **모든 컬럼이 무조건 unlock** (분기 로직 전체 주석) |
| 17 | L1928~1929 | `Tables[3]` 오류 메시지 표시 후 **return 없이 계속 진행**하여 성공 메시지(MSG00004)도 함께 출력됨 |
