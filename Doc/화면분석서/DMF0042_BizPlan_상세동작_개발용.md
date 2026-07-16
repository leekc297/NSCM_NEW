# DMF0042 Business Plan (사업계획) — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS `GSCM.DM.Forms.UIL\Plan\DMF0042_1_BizPlan\DMF0042_1_BizPlan.cs` (**실측 3,477줄** — 물리 LF `wc -l` 기준) + `.Designer.cs` (**1,613줄**) 전수 Read.
> ⚠ **5벌+파생 병존** — 동일 `Plan.UIL` 하위에 `DMF0042_BizPlan`(3,563/1,643) · **`DMF0042_1_BizPlan`(3,477/1,613 ← 정본 채택)** · `DMF0042_3_BizPlan`(3,590/1,613) 이 공존. **_1 정본 채택** 근거 = 자동차(81)/ESS(82) 파생 컬럼(CELL_PER_CAR·MODULE_PER_CAR·UNIT_ENERGY·ITEM_USE) 최신 반영 + `DMF0042_ExchangeRatePopup`(전용 환율 팝업) 배선 + `[C20220513-000327]`/`[PJ20200138]` 최신 패치 누적. `_BizPlan`(구 base)·`_3`(파생) 은 대조용.
> **전용 팝업**: `GSCM.DM.Plan.UIL\POPUP\DMF0042_ExchangeRatePopup.cs` (환율 등록/조회, 실측 677줄 + Designer 473) · `DMF0042_1_RTF.cs` (RTF 상세, 1,748 + Designer 268). 공용 팝업: `SCM0002_ProjectbyDivisionPopupEx`(Project) · `DM0002_ItembyDivisionPopupEx`(Item) · `DM0020_OwnerbyDivisionPopup`(Owner) · `DM0002_TitleSetForm_Popup`(Column/Measure Show) · `VersionCutOffPopUp`(610) · `ReplaceByCutOffPopUp`(562).
> **데이터 접근**: 레거시 FoxData (`FoxDataClient` / `FoxAsyncProxy.ExecuteAsync` / `Data.Common` / `Data.User*` / `GetLookupData`). 핵심 엔드포인트 —
> `DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA`(조회, 16 param) / `DM.DMF0042_SAVE_DM_PLN_BP_FCST`(저장, '^' bulk 27 param) / `DM.DMF0042_1_GET_SPREAD_TITLE`(동적 헤더) / `DM.DMF0042_GET_EXCHANGE_PRICE`(환율단가) / `DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV`(가격환산) / `DM.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF`(컷오프) / `DM.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF`(컷오프 대체) / `DM.PR_GET_DAY_RANGE`(기본기간) / `SCM.SCM0001_GET_LOOKUP_VALUES`·`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`·`DM.UP_FX_GetCommonDataList_DM`(룩업) — **TO-BE 대응 = `PKG_DMF0042` SP**.
> **범위**: 화면 이벤트/액션 **28 전수** 상세 (핸들러 wire + body + 호출메서드 1-depth). 화면 특성 = **Division 3분기 화면(40 소형 / 81·81_JV 자동차 / 82 ESS)** — 조회조건 Division 콤보로 전 컬럼셋·Measure·필수값·저장 파라미터가 갈림. Bucket = **Monthly / Quarterly / Yearly** (기본 Monthly, `BUCKET2_TYPE_CODE`). ⚠ 같은 Plan 계열이라도 DMF0082(Daily/Weekly/Monthly)와 **버킷 축이 다름**.
> **편집제어 방식**: 본 화면은 GADM/`DM_UI_EDITABLE` 방식이 **아니라 그리드 `EDIT_FLAG` 컬럼('Y')** 로 행 편집을 제어함(GET SP 가 행별 EDIT_FLAG 세팅 → `EditButton` 이 `EDIT_FLAG=='Y' && Measure=='Business_Plan'` 조건에서만 Incoterms/FcstType unlock). MSG 코드 = 사내 MSG_M, 일부 인라인 하드코드 리터럴("Edit Mode is not allowed." 등).

> ⚠ 이 문서는 **개발자용 기술 상세본**입니다. User 관점 가독본은 **UI분석서 시트 5** 참조. (§4 User 관점 변환 요지 = 시트5 반영용 요약)

---

## 1. 이벤트 · 액션 상세 (28)

> Division 분기 표기 규약: **40** = 소형(IT/Small, Project 미사용·End Customer 키) / **81·81_JV** = 자동차(Project 키·CELL_PER_CAR/MODULE_PER_CAR 파생) / **82** = ESS(UNIT_ENERGY/ITEM_USE 파생). `sDivision.Substring(0,2)=="81"` 로 81 계열 판별.

### ▣ 초기화

#### [1] Form_Load
- **트리거**: Form load  ·  **컨트롤/소스**: `this.Load += Form_Load` (ctor L204; `UnFilterInsertRow=true` L206)
- **소스라인**: `199-207(ctor)/209-217(body); InitControls 231-323; CreateSpread 362-369; InitSpread 371-382; DefineProperty 325-360; InitSaveDataTable 500-510`  ·  **호출 메서드**: `CControl` 생성(211), `InitForm`(BaseForm, 212), `InitControls`(213), `CreateSpread`→`AddSheet`/`InitSpread`→`GetSpdTitle`/`SetSpreadHeaderSpan`/`SetSpreadColumn`(214), `DefineProperty`(215), `InitSaveDataTable`(216)
- **데이터/SP**: `Data.Common`(MyDivision/DM_BIZ_TYPE/EndCustomerByDivision40/DMF0042_BP_Measure/CURRENCY_LIST); `Data.UserTeamByDivision`/`UserEndCustomerByDivisionDept`/`UserSiteByEndCustomer`/`UserPlantSiteByDivision`; `GetLookupData`→`SCM.SCM0001_GET_LOOKUP_VALUES`(DM_YN/BUCKET2_TYPE_CODE/ITEM_TYPE_CODE); `GetBizTypebyDivision`→`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`; `GetDayRange`→`DM.PR_GET_DAY_RANGE`(p_month=7); `GetSpdTitle`→`DM.DMF0042_1_GET_SPREAD_TITLE`
- **Division 분기** (InitControls 250-291): `sDivision=="40"`→Biz Type=DM_BIZ_TYPE(공통)·Customer=EndCustomerByDivision40·**Project/PlantSite 비활성**(259-261)·Measure=DMF0042_BP_Measure("40") / `Substring(0,2)=="81"`→Biz Type=GetBizTypebyDivision·Customer=UserEndCustomerByDivisionDept·**Project/PlantSite 활성**·Measure("81") / else(82)→동일 구조·Measure("82")
- **실제 동작 (실측)**:

    ① ctor(199-207): InitializeComponent → `this.Load += Form_Load`(204) → `UnFilterInsertRow=true`(206, 필터 상태에서도 Insert 허용)
    ② Form_Load(209-217): clsCtrl=`new CControl(this)` → `InitForm()`(BaseForm) → InitControls → CreateSpread → DefineProperty → InitSaveDataTable 순차
    ③ InitControls(231-323): 조회조건저장 예외 `cboClosed` 등록(234) → Division 콤보(MyDivision, 236-237) → **Division 값에 따라 3분기**(250-291) 로 Biz Type/Customer/Measure/Project·PlantSite 활성 세팅 → SalesSite(UserSiteByEndCustomer, 298) → PlantSite(UserPlantSiteByDivision, 302) → Bucket(BUCKET2_TYPE_CODE, 305) → Period(`drpPeriod.InitValue=GetDayRange()`, 308) → ItemType(311) → ToolTip → Currency(317) → `layoutControlItem4`·`lblBucket1` 숨김(319-321)·`cboClosed.Enabled=false`(322)
    ④ CreateSpread(362-369): `AddSheet(spdMain,"Biz Plan","Biz Plan",3,1,20)`(헤더 3단) → siMain 확보 → `InitSpread`
    ⑤ InitSpread(371-382): `GetSpdTitle()`(DMF0042_1_GET_SPREAD_TITLE) → `CreateSheetHeaderColumnDtDiv(…, clbDivision.SelectedValue)`(**[PJ20200138] Division 조건부 컬럼 생성**, 375) → dtTitle 행 존재 시 `SetSpreadHeaderSpan`(대/소분류 Y_/Q_/M_ 3단 + SUM 헤더) + `SetSpreadColumn`(버킷 가시성)
    ⑥ DefineProperty(325-360): 조회패널 Height=105 → 이미지 셀타입(대문자 강제, 팝업버튼) → **CutOff 권한**(340-353: NowGroupID∈{ADMIN, DM ADMIN} 만 `btnCutOff` 표시) → **`dsdm.Changed += spdMain_Changed`**(그리드 값변경 배선, 356) → `clbDivision.SelectedIndexChanged += cboDivision_SelectedIndexChanged`(358) + `cboBucketType.SelectedIndexChanged += …`(359, Designer D.537 와 이중 배선)
    ⑦ InitSaveDataTable(500-510): dtSave/dtSaveFinal("MktFcstSave") 스키마 생성

#### [2] OnShown (override)
- **트리거**: Form first shown  ·  **컨트롤/소스**: Form (BaseForm override)
- **소스라인**: `219-226`  ·  **호출 메서드**: `base.OnShown`
- **데이터/SP**: 없음
- **실제 동작 (실측)**:

    ① `base.OnShown(e)` 호출(221) → `sDivision` 값만 읽고 별도 처리 없음(223) — **사실상 no-op**(DMF0082 의 Bucket 기본세팅 분기가 여기 없음; 본 화면 Bucket 기본값은 InitControls 의 BUCKET2_TYPE_CODE 콤보 로딩으로 처리)

### ▣ 조회조건 (cascade)

#### [3] cboDivision_SelectedIndexChanged  ⭐ 화면 3분기 재초기화
- **트리거**: Division combo change  ·  **컨트롤/소스**: clbDivision (`SelectedIndexChanged` 코드 배선 L358 — 핸들러명은 `cboDivision_…`)
- **소스라인**: `1422-1507(body)`  ·  **호출 메서드**: `InitSpread`, `InitSaveDataTable`, `Data.UserTeamByDivision`, `Data.Common`(DM_BIZ_TYPE/EndCustomerByDivision40/DMF0042_BP_Measure/CURRENCY_LIST), `GetBizTypebyDivision`, `Data.UserEndCustomerByDivisionDept`, `Data.UserSiteByEndCustomer`, `Data.UserPlantSiteByDivision`, `GetLookupData`, `GetDayRange`
- **데이터/SP**: `DM.DMF0042_1_GET_SPREAD_TITLE`(InitSpread) + 위 콤보 룩업 전량 재조회
- **Division 분기**: Form_Load [1]③ 과 **동일 3분기**(1437-1474) — 40=Project/PlantSite 비활성·Measure("40") / 81=활성·Measure(sDivision) / 82=활성·Measure("82")
- **실제 동작 (실측)**:

    ① Division 변경 시 `InitSpread()`(1427, 헤더 컬럼셋 Division 기준 재생성) + `InitSaveDataTable()`(1428, 저장버퍼 리셋)
    ② Team 재조회(UserTeamByDivision, 1430) → **Division 3분기**(1437-1474) 로 Biz Type/Customer/Measure/Project·PlantSite 활성 재세팅
    ③ Customer(1479)/SalesSite(1482)/PlantSite(1485)/Bucket(1488)/Period(1491)/ItemType(1493)/Currency(1500) 전량 재바인딩
    ④ `layoutControlItem4` 숨김(1502) + **txtProject/txtItemId/txtOwner 입력 초기화**(1504-1506)

#### [4] clbTeam_SelectedIndexChanged
- **트리거**: Team checklist change  ·  **컨트롤/소스**: clbTeam (`UsrCheckedList`, Designer D.772)
- **소스라인**: `772(wire)/1509-1533(body)`  ·  **호출 메서드**: `Data.UserEndCustomerByDivisionDept`, `Data.Common`(EndCustomerByDivision40/SiteByEndCustomer40), `Data.UserSiteByEndCustomer`, `clsCtrl.setListBox`
- **데이터/SP**: 콤보 룩업 (Customer + SalesSite 재조회)
- **Division 분기**: `Substring(0,2)=="81" || =="82"`(1516) → UserEndCustomerByDivisionDept + UserSiteByEndCustomer(division 키) / else(40) → EndCustomerByDivision40 + **SiteByEndCustomer40(team 키)**(1525-1528)
- **실제 동작 (실측)**: ① Division·Team 추출 → ② 81/82 는 division 키로 Customer/SalesSite 재조회, 40 은 **team 키(SiteByEndCustomer40)** 로 재조회 → ③ `setListBox(dtSalesSite, clbSalesSite)`(1532)

#### [5] clbCustomer_SelectedIndexChanged
- **트리거**: End Customer checklist change  ·  **컨트롤/소스**: clbCustomer (`UsrCheckedList`, Designer D.732)
- **소스라인**: `732(wire)/1535-1547(body)`  ·  **호출 메서드**: `Data.UserSiteByEndCustomer`, `Data.Common`(SiteByEndCustomer40), `clsCtrl.setListBox`
- **데이터/SP**: SalesSite 콤보 재조회
- **Division 분기**: `Substring(0,2)=="81" || =="82"`(1538) → UserSiteByEndCustomer / else(40) → **SiteByEndCustomer40(team 키)**(1544)
- **실제 동작 (실측)**: ① Customer 변경 → Division 분기로 SalesSite 재조회 → ② `setListBox(dtSalesSite, clbSalesSite)`(1546)

#### [6] cboBucketType_SelectedIndexChanged
- **트리거**: Bucket(Monthly/Quarterly/Yearly) change  ·  **컨트롤/소스**: cboBucketType (Designer D.537 + 코드 재배선 L359)
- **소스라인**: `537(wire)/1549-1563(body); SetSpreadColumn 466-498`  ·  **호출 메서드**: `SetSpreadColumn`, `EditButton`(×2)
- **데이터/SP**: 그리드 컬럼 가시성 재렌더링 전용 (재조회 없음)
- **실제 동작 (실측)**:

    ① `SetSpreadColumn()`(1553) → 버킷별 Visible 재구성(466-498): Monthly=M_/Q_ 표시·Y_는 chkSum / Quarterly=M_숨김·Q_표시·Y_는 chkSum / Yearly=Q_/M_숨김·Y_표시
    ② 편집 중(`!IsLock`)이면 **`EditButton()` 을 연속 2회 호출**(1558-1559) — Lock↔Edit 토글이므로 2회=Edit 모드 유지(새 버킷 컬럼에 lock 재적용) 패턴

#### [7] cboBucketType_Click
- **트리거**: Bucket combo click  ·  **컨트롤/소스**: cboBucketType (Designer D.538)
- **소스라인**: `538(wire)/2963-2973(body)`  ·  **호출 메서드**: `siMain.GetText`(Action 컬럼), `MessageHelper.GMessageBox`
- **데이터/SP**: 없음  ·  **MSG**: MSG00227
- **실제 동작 (실측)**: ① 전체 행 순회 → Action=='I'(신규 삽입행) 존재 시 **MSG00227**(삽입 행 존재 시 Bucket 변경 불가) + return(2967-2970) → 삽입행 없으면 무동작(SelectedIndexChanged 가 실제 변경 처리)

#### [8] chkSum_CheckedChanged
- **트리거**: Sum checkbox toggle  ·  **컨트롤/소스**: chkSum (Designer D.358)
- **소스라인**: `358(wire)/2832-2838(body)`  ·  **호출 메서드**: `SetSpreadColumn`
- **데이터/SP**: 없음 (FE 전용, SP 미전달)
- **실제 동작 (실측)**: ① `SetSpreadColumn()`(2836) 재호출만 — Monthly/Quarterly 버킷에서 Y_(및 Q_) SUM 컬럼 가시성을 chkSum 상태로 토글(466-498). 데이터 불변

### ▣ 조회조건 버튼 · 팝업

#### [9] btnProject_Click
- **트리거**: Project '...' 버튼 click  ·  **컨트롤/소스**: btnProject (Designer D.468; `layoutControlItem3.Click` D.1245 에도 동일 배선)
- **소스라인**: `468(wire)/2762-2782(body)`  ·  **호출 메서드**: `SCM0002_ProjectbyDivisionPopupEx.Form_Load`, `ShowDialog`
- **데이터/SP**: 팝업 `SCM0002_ProjectbyDivisionPopupEx`(내부 SP)  ·  **Division 분기**: 40 은 btnProject 비활성([1]③) → 81/82 전용
- **실제 동작 (실측)**: ① Division/Team/Customer/SalesSite/Project 수집 → `Form_Load(true, …)`(2772) 모달 → ② `popProject.ProjectCode ≠ ""` 이면 `txtProject.Text` 반영(2778-2781, 빈값 silent)

#### [10] btnItemId_Click
- **트리거**: Model '...' 버튼 click  ·  **컨트롤/소스**: btnItemId (Designer D.320)
- **소스라인**: `320(wire)/2784-2805(body)`  ·  **호출 메서드**: `DM0002_ItembyDivisionPopupEx.Form_Load`, `ShowDialog`
- **데이터/SP**: 팝업 `DM0002_ItembyDivisionPopupEx`
- **실제 동작 (실측)**: ① Division/Team/Customer/Site/Project/ItemId 수집 → `Form_Load(true, …)`(2795) 모달 → ② `ItemID ≠ ""` 이면 `txtItemId.Text` 반영(2801-2804, silent)

#### [11] btnOwner_Click
- **트리거**: Owner 버튼 click  ·  **컨트롤/소스**: btnOwner (Designer D.954)
- **소스라인**: `954(wire)/2942-2961(body)`  ·  **호출 메서드**: `DM0020_OwnerbyDivisionPopup.Form_Load`, `ShowDialog`
- **데이터/SP**: 팝업 `DM0020_OwnerbyDivisionPopup`
- **실제 동작 (실측)**: ① Division/Team/Customer/Project/Site/Item/Owner 수집 → `Form_Load(true, …)`(2956) 모달 → ② `txtOwner.Text = popItem.OwnerID`(2960, 무조건 대입)

#### [12] btnColumn_Click
- **트리거**: Column Show 버튼 click  ·  **컨트롤/소스**: btnColumn (Designer D.432, ToolTip "Column Show")
- **소스라인**: `432(wire)/2807-2817(body)`  ·  **호출 메서드**: `DM0002_TitleSetForm_Popup(mode=true)`, `InitSpread`
- **데이터/SP**: `DM0002_TitleSetForm_Popup` (컬럼셋 저장) → OK 시 `InitSpread` 재조회
- **실제 동작 (실측)**: ① `new DM0002_TitleSetForm_Popup("DMF0042","Biz Plan",**true**, clbDivision.ControlValues)`(2809, true=컬럼 Show/Hide 모드) 모달 → ② `DialogResult==OK` 이면 `InitSpread()`(2815) 로 헤더/스팬/색상 재적용

#### [13] btnMeasure_Click
- **트리거**: Measure Show 버튼 click  ·  **컨트롤/소스**: btnMeasure (Designer D.395, ToolTip "Measure")
- **소스라인**: `395(wire)/2819-2830(body)`  ·  **호출 메서드**: `DM0002_TitleSetForm_Popup(mode=false)`, `InitSpread`
- **데이터/SP**: `DM0002_TitleSetForm_Popup` (Measure 메타)
- **실제 동작 (실측)**: ① `new DM0002_TitleSetForm_Popup("DMF0042","Biz Plan",**false**, clbDivision.ControlValues)`(2821, false=Measure Show/Hide 모드) 모달 → ② `DialogResult==OK` 이면 `InitSpread()`(2828) 재구성

### ▣ 그리드 편집 · 배분

#### [14] spdMain_Changed  ⭐ 핵심 (수량 배분 · 롤업)
- **트리거**: Grid cell value changed (edit/paste)  ·  **컨트롤/소스**: `dsdm.Changed += spdMain_Changed` (코드 배선 L356)
- **소스라인**: `356(wire)/1800-2723(body); Business_Plan(정수) 1857-2288; LOC/else(실수) 2289-2720; MSG00289 1843-1855`  ·  **호출 메서드**: `siMain.GetColumnTag`(M_/Q_/Y_ 태그), `GetCellColor`/`SetCellColor`(빨강=수정표시), `siMain.SetText`/`SetValue`, `GetCellIndexBySpanRowCells`
- **데이터/SP**: 없음 (셀 내부 계산·SetSaveData 없음 — 저장은 SaveData [26] 가 그리드 스캔) ·  **MSG**: MSG00289(Business_Plan 소수 입력 차단)
- **Division 분기**: 없음(측정치=Measure/버킷 기준 분기)
- **실제 동작 (실측)**:

    ① 재진입 가드: `!CanModelChange` return(1802), `e.Column<0`/`e.Row<0` return(1804-1806) — 두 번째 이벤트는 e.Column=-1 로 재진입하므로 차단
    ② 빈 셀 → "0" 정규화(1808-1811)
    ③ `case CellsUpdated`(1815): sBucketType/sColName(태그)/strCheckMeasure(행 Measure) 추출
    ④ **소수점 검사**(1843-1855): 수량영역(Measure 우측) 또는 UNIT_ENERGY 컬럼이고 셀 ForeColor==Red 이며 값이 소수 + `Measure=="Business_Plan"` 이면 → 소수부 절삭(`strValue[0]+".000"`) + **MSG00289**(소수 입력 불가)
    ⑤ **Measure=="Business_Plan"**(1857-2288, `long` 정수 연산):
      · **Monthly+M_**(1862-1918): 좌측 Q_ 이후 M_ 합산→Quarterly Sum 셀 갱신(1887) + 좌측 Y_ 이후 Q_ 합산→Yearly Sum 셀 갱신(1914) (상위 롤업만)
      · **Quarterly+Q_**(1919-2082): 입력 분기값을 하위 M_ 개수로 `분기합/일수` 균등 배분 + 마지막 칸에 나머지(dRemnant) 가산(1987-2003), 버킷 없으면(bWeekAll) 하위 M_ 전부 clear(2032-2051) → Yearly Sum 재계산(2063-2081)
      · **Yearly+Y_**(2083-2287): 연값을 하위 M_ 개수로 균등 배분 + 나머지 가산, 실적구간(금주 월요일 이전 M_) continue 스킵(2206/2232), 없으면 `sDefaultDay` 요일 칸에만 기입(2226-2262) → Quarterly Sum 재계산(2265-2286)
    ⑥ **else(LOC·기타 Measure)**(2289-2720, `double` 실수·**배분 아닌 copy**): 동일 3버킷 구조지만 하위 배분 시 `Business_Plan 만 split, 나머지는 dRemnant=0 로 동일값 copy`(2394-2403 등) — 가격(LOC)은 나누지 않고 매 칸 동일값·상위 SUM은 0 유지(2341/2503)
    · ⚠ 배분·롤업은 모두 FE 그리드 셀 상에서만 수행. **CAR/CELL/ENERGY·가격(KRW/USD/SalesAmt) 파생은 여기서 계산하지 않고 저장 SP `DMF0042_SAVE_DM_PLN_BP_FCST` 및 가격환산 SP `DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV`([25]) 에서 산출**(FE 는 Business_Plan 수량만 기입·배분)

#### [15] spdMain_CellDoubleClick
- **트리거**: Grid cell / column-header double click  ·  **컨트롤/소스**: spdMain.CellDoubleClick (Designer D.157)
- **소스라인**: `157(wire)/1598-1798(body); 헤더토글 1600-1639; Item팝업 1640-1698; Project팝업(81) 1699-1753; Project팝업(82) 1754-1797`  ·  **호출 메서드**: `siMain.GetColumnTag`, `DM0002_ItembyDivisionPopupEx`, `SCM0002_ProjectbyDivisionPopupEx`, `ShowDialog`, `siMain.SetText`
- **데이터/SP**: 팝업 Item / Project (내부 SP)
- **Division 분기**: ITEM_ID(81/82)·ITEM_ID40(40) 각각 진입; PROJECT_CODE(81)·PROJECT_CODE82(82) 각각 진입
- **실제 동작 (실측)**:

    ① **컬럼 헤더 더블클릭**(1600-1639): 태그 'Y_' → 하위 Q_ Visible 토글 + 열린 M_ 숨김·다음 Y_ 에서 break(1602-1623) / 'Q_' → 하위 M_ Visible 토글·다음 Q_ 에서 break(1624-1638) (팝업 없음, 드릴다운 표시)
    ② **ITEM_ID / ITEM_ID40 셀**(1640-1698): `IsLock` 또는 Action≠'I'(신규행 아님)이면 return(1643) → Division/Team/Customer/Site/Project/Item 수집 → `DM0002_ItembyDivisionPopupEx.Form_Load(false,…)`(1678) → ItemID≠"" 시 Item/ItemName 셀 SetText(1687-1697)
    ③ **PROJECT_CODE 셀(81)**(1699-1753): `SCM0002_ProjectbyDivisionPopupEx.Form_Load(false,…)`(1728) → Project≠"" 시 Project/ProjectName/BizType(81) SetText(1738-1751)
    ④ **PROJECT_CODE82 셀(82)**(1754-1797): 동일 팝업(1778) → Project/ProjectName/BizType(82) SetText(1788-1796)

#### [16] spdMain_ComboSelChange
- **트리거**: In-grid combo cell selection change  ·  **컨트롤/소스**: spdMain.ComboSelChange (Designer D.158)
- **소스라인**: `158(wire)/1565-1596(body)`  ·  **호출 메서드**: `Data.UserSiteByEndCustomer`, `Data.Common`(EndCustomerByDivision40), `siMain.SetCellTypeCombo`
- **데이터/SP**: 콤보 UserSiteByEndCustomer / EndCustomerByDivision40
- **Division 분기**: `sDivision=="40"` 전용(1570/1577)
- **실제 동작 (실측)**:

    ① **END_CUSTOMER40 셀 변경**(1568-1576): 40 이면 선택 고객으로 SalesSite 재조회 → `SetCellTypeCombo(SCM_SITE_ID40)`(1574)
    ② **DEPT_ID40 셀 변경**(1577-1595): 40 이면 팀(공란 시 조회조건 팀) → Customer(EndCustomerByDivision40) 콤보 재설정(1589) → SalesSite 콤보 재설정(1593)

#### [17] spdMain_EditChange
- **트리거**: Grid cell edit begin/change  ·  **컨트롤/소스**: spdMain.EditChange (Designer D.159)
- **소스라인**: `159(wire)/2975-2982(body)`  ·  **호출 메서드**: `bPasteContinue` 플래그
- **데이터/SP**: 없음
- **실제 동작 (실측)**: ① 활성 컬럼이 DIVISION_ID 이하(좌측 키/메타)면 return(2977) → ② 그 외(수량/편집영역)면 `bPasteContinue=true`(2979) — ValidationCheck[MSG00002] 재검증 게이트 플래그

#### [18] spdMain_TopChange
- **트리거**: Grid vertical scroll (top row change)  ·  **컨트롤/소스**: spdMain.TopChange (Designer D.160)
- **소스라인**: `160(wire)/2736-2741(body)`  ·  **호출 메서드**: `CanModelChange` 가드, `siMain.SmartColMerge`
- **데이터/SP**: 없음
- **실제 동작 (실측)**: ① `CanModelChange=false`(2738) → `SmartColMerge()`(2739, 뷰포트 진입 좌측 키 컬럼 세로병합 재계산) → `CanModelChange=true`(2740) (스크롤 시 병합 깨짐 방지)

#### [19] spdMain_KeyUp
- **트리거**: Key up in grid  ·  **컨트롤/소스**: spdMain.KeyUp (Designer D.161)
- **소스라인**: `161(wire)/2743-2760(body 전량 주석)`  ·  **호출 메서드**: 없음
- **데이터/SP**: 없음
- **실제 동작 (실측)**: ① **본문 전부 주석 (no-op)** — 구 Ctrl+C/Ctrl+V ClipboardCopy/Paste·bPasteContinue 로직 잔존(비활성). 배선만 유지

### ▣ CRUD 버튼 (BaseForm override)

#### [20] FindButton (override) → FindData()
- **트리거**: Find toolbar 버튼 / F5  ·  **컨트롤/소스**: Common toolbar (BaseForm hotkey)
- **소스라인**: `515-518(override) / FindData 684-799 (async); GetThisWeekMonday 3023-3042; InitSpread 371-382`  ·  **호출 메서드**: `FindData()`, `FoxAsyncProxy.ExecuteAsync('DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA')`, `GetThisWeekMonday`, `InitSpread`, `siMain.Query`/`LockColumn`/`SmartColMerge`
- **데이터/SP**: SP `DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA` (**Table[0]=본문 그리드**, **Table[1]=편집가능구간 메타**: VALID_YN/START_END YYYYQQ·YYYYMM·YYYY)  ·  **MSG**: MSG00097, MSG00108, MSG00276
- **Division 분기**: 파라미터 `p_division_id`=조회 Division; Table[1] 의 valid_YN/start~end 는 40 편집구간 제어([27] EditButton 에서 소비)
- **실제 동작 (실측)**:

    ① `CanModelChange=false`(686) + 검증: Division 공란→**MSG00097**(697) return / from>to→**MSG00108**(705) return / `Value1.AddYears(6) < Value2`(709) → **MSG00276**(기간 6년 초과) + Value2 를 Value1+6년으로 보정 후 return
    ② 금주 월요일 산정(`GetThisWeekMonday`, 717) → `InitSpread()`(723, 헤더 재생성) → ProgressForm 표시 + `SearchStartTime`
    ③ `FoxAsyncProxy.ExecuteAsync DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA`(Timeout 30분, 741) — **파라미터 16종**: p_division_id/p_dept_id/p_end_customer/p_scm_site_id/p_project_code/p_item_id/p_item_type/p_from_yyyymmdd/**p_now_yyyymmdd(=금주월요일)**/p_to_yyyymmdd/p_created_by/p_plant_site_id/p_biztype/p_userinfo/p_owner/**p_qty_yn(cboQty Y/N)**
    ④ 결과: `siMain.Query(Tables[0])`(767) + `LockColumn(0,max,true)`(768, 전체 잠금) → **Tables[1] 편집구간 메타 7종 캐시**(770-779: valid_YN/start_YYYYQQ/end_YYYYQQ/start_YYYYMM/end_YYYYMM/start_YYYY/end_YYYY) → `SmartColMerge`(781) + `SearchEndTime`
    ⑤ catch: `GMessageBoxForException`(790); finally: ProgressForm.Close + ResumeLayout(792-797)

#### [21] InsertButton (override) → InsertRow()
- **트리거**: Insert toolbar 버튼 / F8  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `520-523(override) / InsertRow 1150-1417`  ·  **호출 메서드**: `siMain.Insert(dtMeasure.Rows.Count)`, `siMain.SetCellTypeCombo`, `cellTypeImage`(팝업버튼), `siMain.LockRange`(메타 전 컬럼), `Data.User*`/`GetLookupData`/`GetCellProdSite`, `CUIControl.SetRowSpanFuc`
- **데이터/SP**: 콤보 DM_BIZ_TYPE_81 / EndCustomerByDivision40·UserEndCustomerByDivisionDeptAuth / UserSiteByEndCustomer(Auth) / UserTeamByDivisionAuth / CURRENCY_LIST / `DM.UP_FX_GetCommonDataList_DM`(DM_CELL_PROD_SITE)
- **Division 분기**: `sDivision=="40"`→SalesSiteAuth·DEPT_ID40 콤보·`[C20220513-000327]` CELL_PROD_SITE 콤보(1213) / else→UserEndCustomerByDivisionDeptAuth·DEPT_ID 콤보; ITEM_ID40/PROJECT_CODE82 vs ITEM_ID/PROJECT_CODE 조건부
- **실제 동작 (실측)**:

    ① `IsLock==false && SheetName==shtMain` 확인(1152-1154) → 활성행 기준 `Insert(dtMeasure.Rows.Count)`(1159) — **Measure 개수만큼 행 블록 삽입**(한 키셋에 Business_Plan/LOC/KRW/USD/… 여러 Measure 행)
    ② 팝업 셀타입: PROJECT_CODE/PROJECT_CODE82/ITEM_ID/ITEM_ID40 에 `cellTypeImage`(팝업버튼, 1175-1182); CURRENCY 콤보(1184)
    ③ 콤보 바인딩(1187-1214): DEPT_ID(40=DEPT_ID40)/END_CUSTOMER(40)/SCM_SITE_ID(40/81/82)/CURRENCY/BIZ_TYPE_NAME81; 40 전용 CELL_PROD_SITE 콤보(`GetCellProdSite`, 1213)
    ④ **메타 컬럼 전량 Lock**(1218-1409): DIVISION_ID~REPORT_GROUP8 + EDIT_FLAG + `[PJ20200138]` CELL_PER_CAR/MODULE_PER_CAR lock(1322-1325) → Measure 텍스트 세팅(1328); Measure 가 **KRW/USD/SalesAmt_KRW/USD/LOC/CAR_QTY(계산결과)** 이면 수량영역 전체 lock(1336), 그 외(Business_Plan/LOC 입력)면 **버킷별 편집구간 unlock**(1341-1408: Monthly=M_·40 valid 구간 / Quarterly=Q_ / Yearly=Y_; 금년 이전 컬럼 lock)
    ⑤ `CUIControl.SetRowSpanFuc`(1412, Measure 블록 세로 병합)

#### [22] DeleteButton (override)
- **트리거**: Delete toolbar 버튼 / F9  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `525-537`  ·  **호출 메서드**: `siMain.GetText`(Action), `GetCellNumbersByRow`, `siMain.Delete`
- **데이터/SP**: 없음 (로컬 그리드)
- **실제 동작 (실측)**: ① 활성행 Action ≠ 'I'(신규 삽입행 아님)이면 return(527) — **DB 조회행은 Delete 불가, 신규 추가행만 삭제** → ② `GetCellNumbersByRow`(530, Measure 블록 전 행) 역순으로 `Delete()`(534-536)

#### [23] EditButton (override)  ⭐ EDIT_FLAG 행제어
- **트리거**: Edit toolbar 버튼 / F2 (Bucket 변경 시에도 호출)  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `539-673`  ·  **호출 메서드**: `MinColumnChk`, `siMain.SwitchLock`, `siMain.LockColumn`/`LockRange`, `siMain.GetValue`(EDIT_FLAG/MEASURE)
- **데이터/SP**: 없음 (로컬 잠금)  ·  **MSG**: MSG00113  ·  **Division 분기**: 40 전용 편집구간(valid_YN/start~end YYYYMM/QQ/YYYY, [20]④ 캐시) + 40+Business_Plan 만 Incoterms/FcstType unlock
- **실제 동작 (실측)**:

    ① `MinColumnChk()==false` → **MSG00113**(필수 컬럼 누락)(548) return
    ② `siMain.SwitchLock()`(553, Lock↔Edit 토글) → **버킷별 컬럼 잠금**(556-614): Monthly=M_ 외 lock·40+valid_YN=='Y' 면 start_YYYYMM~end_YYYYMM 범위 밖 lock / Quarterly=Q_ / Yearly=Y_ (40 편집구간 외 전부 lock)
    ③ **행별 EDIT_FLAG 제어**(616-671): `siMain.LockRange(iRow,0,…,MEASURE,true)`(625, 좌측 키 잠금) → **`EDIT_FLAG=='Y'(StringY) && Measure=="Business_Plan" && Division=="40" && Incoterms=="" && FcstType==""`**(628) 이면 Incoterms/FcstType unlock(634-635), 아니면 lock(639-642)
    ④ `EDIT_FLAG=='Y' && (Measure=="Business_Plan" || =="LOC")`(646) 이면 수량영역 중 **금년 이후 컬럼만 unlock**(648-660, 금년 이전 lock), 그 외 Measure 는 수량영역 전체 lock(664)
    ⑤ Edit 모드 해제 시(`!IsEditMode`) 좌측 키 재잠금(669-670)

#### [24] SaveButton (override) → SaveData()
- **트리거**: Save toolbar 버튼 / F7  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `675-678(override) / SaveData 801-1148 (async); ParameterString 3081-3113; fnValidation 3138-3277; MinColumnChk 3299-3360`  ·  **호출 메서드**: `SaveData()`, `MinColumnChk`, `ParameterString`('^' 누적), `GetCellColor`, `fnValidation`, `FoxDataClient.ExecuteDataSet('DM.DMF0042_SAVE_DM_PLN_BP_FCST')`, `FindData`(재조회)
- **데이터/SP**: SP `DM.DMF0042_SAVE_DM_PLN_BP_FCST` ('^' bulk **27 param**); 성공 후 `FindData()` 재조회  ·  **MSG**: MSG00113, MSG00310, MSG00275, MSG00043, MSG00004 (+ 인라인 sRet)
- **Division 분기**: 저장 파라미터 조립 시 **40/81/82 각각 다른 키 컬럼 매핑**(897-1057) — 40: END_CUSTOMER40→p_PROJECT_CODE·SCM_SITE_ID40·ITEM_ID40·DEPT_ID40·BIZ_TYPE_NAME40 / 81: PROJECT_CODE·SCM_SITE_ID81·ITEM_ID·DEPT_ID·PLANT_SITE_ID·BIZ_TYPE_NAME81 / 82: PROJECT_CODE82·SCM_SITE_ID82·ITEM_ID·UNIT_ENERGY·BIZ_TYPE_NAME82
- **실제 동작 (실측)**:

    ① `IsLock==false && SheetName==shtMain` 아니면 무시(803-805)
    ② `MinColumnChk()==false` → **MSG00113**(810) return
    ③ **Measure 블록 단위 스캔**(846-1083, `i += dtMeasure.Rows.Count`): 블록 내 LOC 행 위치(iLOCRow) 탐색 → Action 이 I/M 아니면 continue(863), Measure∈{Business_Plan, LOC, MKT_FCST} 아니면 continue(866) → M_ 컬럼별 순회(872): 값 있는 첫 년월 또는 빨강(수정) 셀만 파라미터 누적
    ④ **Division 3분기 필수값 검증 + 파라미터 조립**(887-1057): 40/81/82 각 필수 키(END_CUSTOMER40/PROJECT_CODE·DEPT_ID/UNIT_ENERGY 등) 공란 시 **MSG00310**(신규행 필수 입력)(912/943/967) return; `ParameterString`(3081) 으로 '^' 누적(INCOTERMS/FCST_TYPE 공란→" ", UNIT_ENERGY 공란→"0")
    ⑤ 누적 0건(iCount==0) → **MSG00275**(저장 대상 없음)(1087) return
    ⑥ `fnValidation()==false`(중복 키) → **MSG00043**(저장 중복 오류)(1093) return
    ⑦ `DM.DMF0042_SAVE_DM_PLN_BP_FCST` 호출(1101-1133) — **27 파라미터**: p_active_flag/p_DIVISION_ID/p_PROJECT_CODE/p_PROJECT_NAME/p_SCM_SITE_ID/p_PLANT_SITE_ID/p_ITEM_ID/p_FCST_TYPE/p_INCOTERMS/p_MEASURE/p_YYYYMM/p_QTY/p_CURRENCY/p_DEPT_ID/p_END_CUSTOMER/p_BIZ_TYPE/p_ITEM_USE/p_UNIT_ENERGY/p_CELL_PROD_SITE/p_CREATED_BY/p_LAST_UPDATED_BY (각 '^' 조인, 선두 '^' Remove)
    ⑧ 결과: `sRet != "success"` → 인라인 `MessageBox.Show(sRet,"Error!")`(1138, SP 오류문 passthrough) return / else → **MSG00004 {iCount}**(N건 저장)(1143) + **`FindData()` 재조회**(1145)
    · ⚠ SP 내부(`DMF0042_SAVE_DM_PLN_BP_FCST`, 1,434줄)에서 **CAR/CELL(CELL_PER_CAR·MODULE_PER_CAR 기준)·ENERGY(UNIT_ENERGY 기준) 파생 수량 및 SalesAmt 산출**(FE 는 Business_Plan 수량만 전달)

### ▣ 액션 버튼 (버전 · 환율 · 가격환산)

#### [25] btnSetPrice_Click — Price 환산(가격→금액)
- **트리거**: Set Price(가격환산) 버튼 click  ·  **컨트롤/소스**: btnSetPrice (Designer D.991)
- **소스라인**: `991(wire)/3115-3136(body)`  ·  **호출 메서드**: `MessageHelper.GMessageBox`(확인), `FoxDataClient.ExecuteDataSet('DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV')`, `FindData`
- **데이터/SP**: SP `DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV`(가격→KRW/USD/SalesAmt 환산, Timeout 30분)  ·  **MSG**: MSG00282
- **실제 동작 (실측)**: ① **MSG00282**(가격환산 실행 확인) No 면 return(3117) → ② `DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV`(s_flag=""/s_division_id) 호출(3124-3130) → ③ 반환 메시지 GMessageBox(3133) + **`FindData()` 재조회**(3135) (환율×수량 → 금액 Measure 갱신)

#### [26] btnExchangeRate_Click — 환율 등록/조회
- **트리거**: Exchange Rate 버튼 click  ·  **컨트롤/소스**: btnExchangeRate (Designer D.1028)
- **소스라인**: `1028(wire)/2985-3005(body); GetFuturePriceInfo 3007-3021`  ·  **호출 메서드**: `siMain.IsLock`, `DMF0042_ExchangeRatePopup.LoadData`, `ShowDialog`, `GetFuturePriceInfo`, `FindData`
- **데이터/SP**: 전용 팝업 `POPUP.DMF0042_ExchangeRatePopup`(677줄) + OK 후 `DM.DMF0042_GET_EXCHANGE_PRICE`(GetFuturePriceInfo) 재조회  ·  **MSG**: MSG00142
- **실제 동작 (실측)**: ① 편집모드(`!IsLock`)면 **MSG00142**(Edit 모드 환율 금지)(2989) return → ② `new DMF0042_ExchangeRatePopup()` → `LoadData(from"yyyyMM", to"yyyyMM", **"BP"**, division)`(2994, `[PJ20200138]` Division 추가) 모달 → ③ `popup.blnOK` 이면 `dtFuturePrice=GetFuturePriceInfo()`(3001) + **`FindData()` 재조회**(3003)

#### [27] btnCutOff_Click — 버전 컷오프
- **트리거**: Cut-Off 버튼 click  ·  **컨트롤/소스**: btnCutOff (Designer D.1065; **권한 = ADMIN/DM ADMIN 만 표시**, DefineProperty 340-353)
- **소스라인**: `1065(wire)/2840-2866(body)`  ·  **호출 메서드**: `siMain.IsLock`, `VersionCutOffPopUp.LoadDataDiv`, `ShowDialog`
- **데이터/SP**: 팝업 `VersionCutOffPopUp` → 저장 SP `DM.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF` (버전타입 "BP_M")  ·  **MSG**: 인라인 "Edit Mode is not allowed."
- **실제 동작 (실측)**: ① 편집모드(`!IsLock`)면 인라인 `MessageBox.Show("Edit Mode is not allowed.")`(2844) return → ② `VersionCutOffPopUp.LoadDataDiv("BP_M","DM.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF", division)`(2857) 모달(`[PJ20200138]` Division 추가) → ③ `popup.blnOK` 후 처리 없음(2862, 팝업 자체 저장)

#### [28] btnReplace_Click — 컷오프본으로 대체
- **트리거**: Replace 버튼 click  ·  **컨트롤/소스**: btnReplace (Designer D.284)
- **소스라인**: `284(wire)/3382-3474(body)`  ·  **호출 메서드**: `siMain.IsLock`, `spdMain.GetSelection`, `ReplaceByCutOffPopUp.LoadDataDiv`, `ShowDialog`
- **데이터/SP**: 팝업 `ReplaceByCutOffPopUp`(562줄) → SP `DM.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF` (버전타입 "BP_M")  ·  **MSG**: 인라인 "Edit Mode is not allowed." / "데이터 조회 후 다시 시도…"
- **실제 동작 (실측)**: ① 편집모드(`!IsLock`)면 인라인 안내 return(3386) → ② **권한 게이트**: NowGroupID ∉ {ADMIN, DM ADMIN} 이면 인라인 안내 return(3392) → ③ 조회 0행이면 "데이터 조회 후…" return(3408) → ④ 선택 셀 범위(GetSelection)의 M_ 태그에서 YYYYMM from~to 산출(3422-3450, 미선택 시 조회기간 전체) → ⑤ `ReplaceByCutOffPopUp.LoadDataDiv("BP_M", from, to, "DM.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF", division)`(3465) 모달

> ※ **비활성 핸들러**: `btnIncotermsChg_Click`(MasterChg 팝업 `DM0002_MatsterChgPopup`) 는 **전량 주석 처리**(2927-2940) — 배선·호출 없음. TO-BE 이관 대상 아님(기능 격차 검토 시 참고).
> ※ 우클릭 컨텍스트 메뉴 없음. Version 은 별도 텍스트 콤보 없이 컷오프/대체 팝업으로만 관리.

---

## 2. 버튼 인벤토리 (14) — AS-IS 실측

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/권한 | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find/Retrieve (toolbar) | toolbar | FindData(): 검증 + async 조회 + Query 바인딩 | DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA (2 tables) | MSG00097/00108/00276 | Always | 515-518 / 684-799 |
| 2 | Insert (toolbar) | toolbar | InsertRow(): Measure 블록 삽입 + 콤보·Lock | (콤보 룩업) | — | Edit 모드 | 520-523 / 1150-1417 |
| 3 | Delete (toolbar) | toolbar | 신규행(Action='I')만 삭제 | — | — | Action='I' 만 | 525-537 |
| 4 | Edit (toolbar) | toolbar | SwitchLock + 버킷/EDIT_FLAG 별 unlock | — | MSG00113 | Edit; MinColumnChk | 539-673 |
| 5 | Save (toolbar) | toolbar | SaveData(): 3분기 조립 + '^' 27 bulk 저장 | DM.DMF0042_SAVE_DM_PLN_BP_FCST | MSG00113/00310/00275/00043/00004 | Edit 모드; async void | 675-678 / 801-1148 |
| 6 | Excel (toolbar) | toolbar | BaseForm 기본 Export (override 없음) | (로컬) | — | Always | (BaseForm) |
| 7 | btnColumn 'Column Show' | 조회조건 | 컬럼 Show/Hide 팝업(true) → InitSpread | DM0002_TitleSetForm_Popup(true) | — | Always | 432 / 2807-2817 |
| 8 | btnMeasure 'Measure' | 조회조건 | Measure Show/Hide 팝업(false) → InitSpread | DM0002_TitleSetForm_Popup(false) | — | Always | 395 / 2819-2830 |
| 9 | btnProject '...' | Project 필드 | Project 팝업 → txtProject | SCM0002_ProjectbyDivisionPopupEx | — | 81/82 만(40 비활성) | 468 / 2762-2782 |
| 10 | btnItemId '...' | Model 필드 | Item 팝업 → txtItemId | DM0002_ItembyDivisionPopupEx | — | Always | 320 / 2784-2805 |
| 11 | btnOwner | Owner 필드 | Owner 팝업 → txtOwner | DM0020_OwnerbyDivisionPopup | — | Always | 954 / 2942-2961 |
| 12 | btnSetPrice (가격환산) | 조회조건 | 가격→금액 환산 SP + 재조회 | DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | MSG00282 | Always | 991 / 3115-3136 |
| 13 | btnExchangeRate 'Exchange Rate' | 조회조건 | 환율 팝업 → GetFuturePriceInfo + FindData | DMF0042_ExchangeRatePopup; DM.DMF0042_GET_EXCHANGE_PRICE | MSG00142 | 비편집(Lock) 만 | 1028 / 2985-3005 |
| 14 | btnCutOff | 조회조건 | 버전 컷오프 팝업 | VersionCutOffPopUp; DM.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF | (인라인) | **ADMIN/DM ADMIN 만** | 1065 / 2840-2866 |
| 15 | btnReplace | 조회조건 | 컷오프본 대체 팝업 | ReplaceByCutOffPopUp; DM.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF | (인라인) | **ADMIN/DM ADMIN 만** | 284 / 3382-3474 |

> ※ `btnIncotermsChg`(MasterChg) = 전량 주석(비활성). Excel 은 화면 override 없이 BaseForm 기본 동작.

---

## 3. 조회조건 컨트롤 — AS-IS 실측 (Division 3분기 중심)

| # | 컨트롤 | 라벨 | 유형 | 기본값 | Division 분기 | Cascade | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | clbDivision | Division | combo | MyDivision | **화면 전체 3분기 트리거** | SIC(L358) → InitSpread + 전 콤보/Measure 재초기화 | code wire 358; body 1422 |
| 2 | clbTeam | Team | checkbox-list | UserTeamByDivision; ALL | 81/82=div키 / 40=team키 | SIC → Customer + SalesSite | D.772; 1509 |
| 3 | clbCustomer | End Customer | checkbox-list | (Division별) ; ALL | 40=SiteByEndCustomer40 / 81·82=UserSite | SIC → SalesSite | D.732; 1535 |
| 4 | clbBizType | Biz Type | checkbox-list | 40=DM_BIZ_TYPE / 81·82=GetBizTypebyDivision | ✓ | Division 변경 시 재바인딩 | (무배선) |
| 5 | clbSalesSite | Sales Site | checkbox-list | UserSiteByEndCustomer; ALL | 40=SiteByEndCustomer40 | Team/Customer 연동 | (무배선) |
| 6 | clbPlantSite | Plant Site | checkbox-list | UserPlantSiteByDivision | 40 비활성 | Division 연동 | (무배선) |
| 7 | clbItemType | Item Type | checkbox-list | ITEM_TYPE_CODE; ALL | — | — | (무배선) |
| 8 | cboBucketType | Bucket | combo (Monthly/Quarterly/Yearly) | BUCKET2_TYPE_CODE; 기본 Monthly | — | SIC → SetSpreadColumn + EditButton×2 / Click → 삽입행 시 MSG00227 | D.537/538; 1549/2963 |
| 9 | drpPeriod | Period | date range | PR_GET_DAY_RANGE(p_month=7) 당월1일~7개월 | — | FindData 검증(from≤to MSG00108, 6년 MSG00276) | (무배선) |
| 10 | txtProject (+btnProject) | Project | text + modal | 빈값 | 40 비활성 | btnProject 팝업 | D.468 |
| 11 | txtItemId (+btnItemId) | Model | text + modal | 빈값 | — | btnItemId 팝업 | D.320 |
| 12 | txtOwner (+btnOwner) | Owner | text + modal | 빈값 | — | btnOwner 팝업 | D.954 |
| 13 | cboQty | Qty≥0 | checkbox | N | — | **SP 파라미터** p_qty_yn (FindData 758) | (무배선) |
| 14 | chkSum | Sum | checkbox | N | — | FE 전용 CheckedChanged → SetSpreadColumn | D.358; 2832 |
| 15 | cboClosed | (Closed) | combo | DM_YN; **Enabled=false** | — | 조회조건저장 예외(234), 숨김 | (무배선) |

> 그리드 `spdMain`(FpSpread, 시트 "Biz Plan", 헤더 3단 Y_/Q_/M_ + SUM). 배선 이벤트 6종(CellDoubleClick/ComboSelChange/EditChange/TopChange/KeyUp + 코드배선 Changed).

---

## 4. ② User 관점 변환 요지 (시트 5 반영용)

> 개발 세부(메서드명·라인·detach/attach·주석블록)를 제거하고 **업무 규칙 + MSG 의미**만 남긴 요지. UI분석서 시트5 "상세동작(User)" 반영.

### 4.1 화면 성격
- **사업계획(Business Plan)** 을 사업부별로 세우는 화면. **Division 을 무엇으로 고르느냐에 따라 화면 전체(컬럼·측정치·필수 입력항목·저장 방식)가 3가지로 갈린다**: **소형(40)** 은 End Customer 기준(프로젝트 없음, 셀생산지 필수), **자동차(81·JV)** 는 프로젝트 기준(CAR/CELL 환산 사용), **ESS(82)** 는 에너지(UNIT_ENERGY) 기준.
- 기간 단위는 **월(Monthly)·분기(Quarterly)·연(Yearly)** 로 보며(기본 월), 상위 칸에 숫자를 넣으면 하위 기간으로 자동 나눠진다.

### 4.2 조회
- Division 은 필수(미선택 시 "Division 선택" MSG00097). 시작일이 종료일보다 늦으면 안 되고(MSG00108), 6년을 초과하면 자동으로 6년으로 줄여준다(MSG00276).
- Team → End Customer → Sales Site 가 위에서 아래로 연동된다(사업부별 조회 방식이 다름). Qty≥0·Sum 체크로 표시를 조절한다.

### 4.3 편집·수량 입력
- 수정하려면 Edit 로 전환. 필수 항목(사업부별로 다름 — 40: 고객/사이트/모델/인코텀즈/예측유형/통화/셀생산지, 81: 프로젝트/사이트/공장/모델/부서/고객/통화, 82: 부서/에너지/통화)이 화면에 없으면 편집 불가(MSG00113).
- 편집 가능한 구간은 **금년 이후(소형 40 은 조회로 받은 유효 구간 안)** 만이며, 지난 실적은 잠긴다. **사업계획(Business_Plan) 행에 월/분기/연 숫자를 넣으면 하위 기간으로 균등 분배**(나머지는 마지막 칸에 몰아줌)되고, **가격(LOC) 은 나누지 않고 같은 값이 채워진다**. 사업계획은 정수만 입력 가능(소수 입력 시 MSG00289).
- 신규 행에 필수 항목이 비면 항목별 "필수 입력"(MSG00310), 편집영역 필수값 누락은 MSG00002. 편집 중에는 Bucket 을 못 바꾼다(추가 행이 있으면 MSG00227).

### 4.4 저장
- 저장 시 3분기 규칙대로 데이터를 모아 한 번에 저장한다. 저장 대상이 없으면 안내(MSG00275), 같은 키가 중복이면 저장 실패(MSG00043), 성공하면 "N건 저장"(MSG00004) 후 다시 조회한다. 서버 오류는 서버 메시지를 그대로 보여준다.
- **CAR/CELL(자동차)·에너지(ESS)·금액(KRW/USD/판매금액)** 은 사용자가 직접 넣지 않고, 저장 시 서버가 사업계획 수량과 원단위(CELL_PER_CAR/MODULE_PER_CAR·UNIT_ENERGY)·환율로 자동 산출한다.

### 4.5 보조 기능
- **가격환산(Set Price)**: 확인(MSG00282) 후 가격×수량으로 금액 측정치를 다시 계산한다.
- **Exchange Rate**: 환율 등록/조회 창(편집모드에서는 못 열고 MSG00142). 닫으면 화면을 다시 조회해 반영.
- **Cut-Off / Replace**: 버전 확정(컷오프)·컷오프본 대체 — **관리자(ADMIN/DM ADMIN)** 전용, 편집모드에서는 불가.
- **Column Show / Measure**: 화면에 보일 컬럼/측정치를 사용자가 고른다. 셀 더블클릭 = 연/분기 헤더는 하위 기간 펼치기, 신규 행의 Project/Model 칸은 선택 팝업.

---

> **실측 근거**: 본 문서의 라인 번호·파라미터·MSG·Division 분기는 `DMF0042_1_BizPlan.cs`(**3,477줄**) + `.Designer.cs`(**1,613줄**) 전수 Read 및 Designer 이벤트 배선 grep 교차검증(`+= new … EventHandler` 20 hit + 코드배선 3), 5벌 병존(_BizPlan/_1/_3) 대조, 기존 분석자료(`analysis.md`·`__asis-mapping__.md` Validation 99/Expression 66) 대조 결과이며, 주석(비활성) 코드(`btnIncotermsChg_Click`/`spdMain_KeyUp` 등)는 별도 명시하고 활성 코드만 기술함.
