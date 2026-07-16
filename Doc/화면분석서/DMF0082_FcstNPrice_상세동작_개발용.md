# DMF0082 Fcst&Price Mgmt — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS `GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs` (**실측 9,418줄** — 물리 LF 기준; 의뢰문 병존 수치 "8,295줄"은 구버전 표기, 실측값 9,418 채택) + `.Designer.cs` (1,299줄) 전수 실측. 전용 팝업 `GSCM.DM.Plan.UIL\POPUP\DMF0082_SaveSalesFuturePrice_Popup.cs` (Price 일괄입력, 실측 2,827줄) + `.Designer.cs` (897줄).
> **데이터 접근**: 레거시 FoxData (`FoxDataRequest` / `FoxAsyncProxy` / `DataService.GetDMInnerTable` / `Data.Common`·`Data.User*`). 핵심 엔드포인트 `DM.DMF0082_GET_MAIN_DATA`(조회) / `DM.DMF0082_SAVE_MAIN_DATA`(저장, '^' bulk 16) / `DM.DMF0082_GET_SPREAD_TITLE`(동적 헤더) / `DM.DMF0082_POPUP_*`(환율·일괄입력) — TO-BE 대응 = `PKG_DMF0082` SP.
> **범위**: 화면 이벤트/액션 **29 전수** 상세 (핸들러 + 호출메서드 본문 1-depth). 화면 특성 = Division **40(소형) 고정**(`dtDivision.Select("CODE='40'")`) · Bucket 기본 **Weekly** · Version 기본 **"Current"**(Current 조회일 때만 Insert/Edit 허용). [PJ2025-50188] 속도개선으로 구 로직 대부분 주석 보존 + 신규 함수(`SetEditList`/`SetLockRange`/`LockRange2`) 재작성 → 활성 코드만 기술.
> MSG 코드 문구 = 사내 MSG_M, 일부 인라인 = 하드코드 한글 리터럴("YYYYMMDD형식이 맞지 않습니다.").

> ⚠ 이 문서는 **개발자용 기술 상세본**입니다. User 관점 가독본은 **UI분석서 시트 5** 참조. (§4 User 관점 변환 요지 = 시트5 반영용 요약)

---

## 1. 이벤트 · 액션 상세 (29)

### ▣ 초기화

#### [1] Form_Load
- **트리거**: Form load  ·  **컨트롤/소스**: this.Load (ctor L308 배선, `UnFilterInsertRow=true` L309)
- **소스라인**: `308(wire)/312-320(body); InitControls 337-384; CreateSpread 386-393; DefineProperty 395-416; InitSpread 418-429; InitSaveDataTable 631-666`  ·  **호출 메서드**: clsCtrl 생성, InitForm, InitControls, CreateSpread(AddSheet/InitSpread), DefineProperty, InitSaveDataTable, SetChangeControl, GetDayRange, GetBucketType, GetFuturePriceInfo
- **데이터/SP**: `DataService.GetDMInnerTable` (MyDivision/UserTeamByDivision/EndCustomerByDivision/BizType/ScmSitebyEndCustomer40); `DM.PR_GET_DAY_RANGE`(p_month=6); `DM.DMF0003_GET_BUCKET_TYPE_CODE`; `DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO`; `DM.DMF0082_GET_SPREAD_TITLE`(InitSpread→GetSpdTitle)
- **Division 분기**: `dtDivision.Select("CODE='40'")`(342)로 Division 콤보 40 고정 (본 화면 전체가 40 전용)
- **실제 동작 (실측)** — InitControls 콤보 로딩 9단계:

    ① 생성자(304-310): InitializeComponent → this.Load += Form_Load(308) → UnFilterInsertRow=true(309, 필터 상태에서도 Insert 허용)
    ② Form_Load(312-320): clsCtrl=new CControl(this) → InitForm()(BaseForm) → InitControls() → CreateSpread() → DefineProperty() → InitSaveDataTable()
    ③ InitControls 콤보 9단계:
      1. Division: `SetChangeControl("MyDivision")`(341) → dtDivision **"CODE='40'" 필터**(342) → clbDivision (40 고정)
      2. Team: `SetChangeControl("UserTeamByDivision", sDivision)`(347) → clbTeam
      3. End Customer: `SetChangeControl("EndCustomerByDivision", sDivision, sTeam)`(352) → clbCustomer
      4. Biz Type: `SetChangeControl("BizType", sDivision)`(356) → clbBizType
      5. Period: `drpPeriod.InitValue = GetDayRange()`(361) — 기본 조회기간 = `DM.PR_GET_DAY_RANGE`(p_month=6) 반환 (당월 1일~6개월)
      6. Sales Site: `SetChangeControl("ScmSitebyEndCustomer40")`(364) → dtSalesSite40 (40 전용 QueryID) → clbSalesSite
      7. Bucket: `GetBucketType()`(368) = `DM.DMF0003_GET_BUCKET_TYPE_CODE` → cboBucketType (기본값 Weekly)
      8. Version: `txtVersion.Text = "Current"`(372) — 기본 Current
      9. ToolTip(375-377) + `dtFuturePrice = GetFuturePriceInfo()`(380) + `chkSum.Checked = false`(382)
    ④ CreateSpread(386-393): AddSheet "FcstNPrice" 헤더 3행 → InitSpread
    ⑤ DefineProperty(395-416): 조회패널 Height=108, cboBucketType=Weekly(399), 이미지 셀타입(대문자 강제), `dsdm.Changed += spdMain_Changed`(412), `spdMain.KeyUp -= base.BaseForm_KeyUp`(415, 붙여넣기 속도개선으로 기본 KeyUp 제거)
    ⑥ InitSpread(418-429): GetSpdTitle(`DM.DMF0082_GET_SPREAD_TITLE`) → CreateSheetHeaderColumn(3) → SetSpreadHeaderSpan/SetSpreadColumn/InitSpreadFooterSum
    ⑦ InitSaveDataTable(631-666): dtSave/dtSaveFinal("MktFcstSave") = Action + 키 12컬럼 + YYYYMMDD + CURRENCY(string) + QTY(decimal) 스키마 생성

#### [2] OnShown (override)
- **트리거**: Form first shown  ·  **컨트롤/소스**: Form (BaseForm override)
- **소스라인**: `322-332`  ·  **호출 메서드**: base.OnShown
- **데이터/SP**: 없음 (로컬 상태 세팅)
- **Division 분기**: `sDivision == "40"`(328) → Bucket 기본값 Weekly
- **실제 동작 (실측)**:

    ① base.OnShown(e) 호출
    ② sDivision == "40"(화면 고정) 이면 cboBucketType.ControlValues = Weekly(330) 로 주단위 기본 세팅
    ③ (본 화면은 40 고정이라 항상 Weekly 진입. DMF0003 대비 82=Daily 분기가 없음)

### ▣ 조회조건 (cascade)

#### [3] clbDivision_SelectedIndexChanged
- **트리거**: Division combo change  ·  **컨트롤/소스**: clbDivision (UsrCombo; Designer 는 `Click += clbDivision_SelectedIndexChanged` D.594 로 배선 ⚠ Click 이벤트에 배선)
- **소스라인**: `594(wire)/3039-3041(body)`  ·  **호출 메서드**: 없음
- **데이터/SP**: 없음
- **Division 분기**: 없음 (40 고정)
- **실제 동작 (실측)**:

    ① **빈 본문 (no-op)** — Division 이 40 고정이므로 cascade 없음. 배선만 존재하고 실동작 없음

#### [4] clbTeam_SelectedIndexChanged
- **트리거**: Team checklist change  ·  **컨트롤/소스**: clbTeam (UsrCheckedList, Designer D.559)
- **소스라인**: `559(wire)/3043-3061(body)`  ·  **호출 메서드**: SetChangeControl, clsCtrl.setListBox, CString.GetCheckedListValue
- **데이터/SP**: `DataService.GetDMInnerTable(EndCustomerByDivision, UserSiteByEndCustomer)`
- **Division 분기**: 40 은 Team 을 부서키로 EndCustomer/SalesSite 재조회
- **실제 동작 (실측)**:

    ① Division·Team 코드 추출
    ② `SetChangeControl("EndCustomerByDivision", div, team)`(3049) → clbCustomer 재세팅(3052-3053)
    ③ `SetChangeControl("UserSiteByEndCustomer", div, team, customer)`(3056) → clbSalesSite 재세팅(3058-3060)

#### [5] clbCustomer_SelectedIndexChanged
- **트리거**: End Customer checklist change  ·  **컨트롤/소스**: clbCustomer (UsrCheckedList, Designer D.519)
- **소스라인**: `519(wire)/3063-3074(body); GetSalesSite 3180-3196; GetSalesSite40 3202-3218`  ·  **호출 메서드**: GetSalesSite, GetSalesSite40, clsCtrl.setListBox
- **데이터/SP**: `DM.UP_FX_GetCommonDataList_DM` CODE=SiteByEndCustomer / SiteByEndCustomer40
- **Division 분기**: `Substring(0,2)=="81"||"82"`(3065) → GetSalesSite(division key) / else(40계열) → **GetSalesSite40(team key)**
- **실제 동작 (실측)**:

    ① Division·Customer 코드 추출
    ② `Substring(0,2)=="81"||"82"` 이면 dtSalesSite = GetSalesSite(division, customer, …) (`SiteByEndCustomer`, div key) — ⚠ 40 고정 화면이라 사실상 dead branch
    ③ else(40) 이면 dtSalesSite = **GetSalesSite40(team, customer, …)** (`SiteByEndCustomer40`, team key) — 실사용 경로
    ④ setListBox(dtSalesSite, clbSalesSite) 로 SalesSite 목록 갱신

#### [6] cboBucketType_SelectedIndexChanged
- **트리거**: Bucket (Daily/Weekly/Monthly) change  ·  **컨트롤/소스**: cboBucketType (UsrCombo, Designer D.358 + 코드 재배선 3274)
- **소스라인**: `358(wire)/3248-3359(body)`  ·  **호출 메서드**: SetSpreadColumn, EditButton, siMain.IsLock, 이전버킷(sBfBucket) 캐시, BevelBorder/ResetBorder
- **데이터/SP**: 그리드 컬럼 재렌더링 전용 — 재조회/SetChangeControl 없음
- **실제 동작 (실측)**:

    ① 편집 중(!IsLock)이면 detach(`cboBucketType.SelectedIndexChanged -=` 3264) 후, 이전 버킷(sBfBucket) 기준으로 EditButton() 재호출하여 Lock 해제 → 새 버킷 적용 → 재부착(3274) (Edit 상태 보존 패턴)
    ② `SetSpreadColumn()`(3281) 로 D_/W_/M_ Visible 재구성 (Daily=D_/W_ 표시·M_는 chkSum / Weekly=D_ 숨김·W_ 표시 / Monthly=M_만)
    ③ 당월 M_/당주 W_ 컬럼에 Green BevelBorder 재계산 + ResetBorder (3291/3323/3328/3334/3338)
    ④ 편집상태였으면 EditButton() 재적용(3346-3349)

#### [7] cboBucketType_Click
- **트리거**: Bucket combo click  ·  **컨트롤/소스**: cboBucketType (Designer D.359)
- **소스라인**: `359(wire)/3361-3371(body)`  ·  **호출 메서드**: siMain.GetText(Action 컬럼), MessageHelper.GMessageBox
- **데이터/SP**: 그리드 Action 컬럼 검사 — SP 없음
- **MSG**: MSG00227
- **실제 동작 (실측)**:

    ① 그리드 전체 행 순회
    ② 각 행 Action 컬럼 텍스트가 'I'(신규 삽입행)이면
    ③ **MSG00227**(삽입 행 존재 시 Bucket 변경 불가) 후 return 하여 Bucket 변경 차단
    ④ 삽입행이 없으면 무동작 (SelectedIndexChanged 가 실제 변경 처리)

#### [8] chkSum_CheckedChanged
- **트리거**: Sum checkbox toggle  ·  **컨트롤/소스**: chkSum (UsrCheckBox "Sum", Designer D.209)
- **소스라인**: `209(wire)/9046-9052(body)`  ·  **호출 메서드**: SetSpreadColumn
- **데이터/SP**: 그리드 SUM 컬럼 가시성 재렌더링 전용 — **FE 전용, SP 미전달**
- **실제 동작 (실측)**:

    ① `SetSpreadColumn()`(9046) 재호출만 — Daily 버킷 시 M_/W_ Visible, Weekly 버킷 시 M_ Visible 을 chkSum 상태에 따라 토글 (2025-07-07 신설). Monthly 버킷엔 영향 없음(M_ 항상 표시). 데이터 불변, 컬럼 가시성만 재계산

#### [9] txtVersion_KeyDown
- **트리거**: Version 필드 키 입력  ·  **컨트롤/소스**: btnVersion (⚠ Designer 배선은 `btnVersion.KeyDown += txtVersion_KeyDown` D.774)
- **소스라인**: `774(wire)/3419-3422(body)`  ·  **호출 메서드**: btnVersion_Click
- **데이터/SP**: 없음 (팝업 위임)
- **실제 동작 (실측)**:

    ① 아무 키나 입력 시 btnVersion_Click(null,null) 강제 호출 → Version 팝업 오픈 (직접 타이핑 차단, Version 은 반드시 팝업으로 선택)

### ▣ 조회조건 버튼 · 팝업

#### [10] btnItemId_Click
- **트리거**: Model '...' 버튼 click  ·  **컨트롤/소스**: btnItemId (UsrButton, Designer D.736)
- **소스라인**: `736(wire)/3373-3395(body)`  ·  **호출 메서드**: DM0002_ItembyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: `DM0002_ItembyDivisionPopupEx` 팝업(내부 SP) — 본 핸들러 SP 직접호출 없음
- **실제 동작 (실측)**:

    ① 조회조건 Division/Team/EndCustomer/SalesSite/ItemId 값 수집(txtItemId.Text 포함)
    ② new DM0002_ItembyDivisionPopupEx() → Form_Load(true, div, team, endCust, site, "", itemId)(3385)
    ③ CenterParent, ShowDialog() 모달
    ④ 반환 popItem.ItemID ≠ "" 이면 txtItemId.Text 반영 (빈값이면 미변경, silent)

#### [11] btnVersion_Click
- **트리거**: Version '...' 버튼 click  ·  **컨트롤/소스**: btnVersion (UsrButton, Designer D.773)
- **소스라인**: `773(wire)/3397-3417(body)`  ·  **호출 메서드**: SCM0002_VersionByWaterfallPopup.Form_Load, ShowDialog
- **데이터/SP**: `SCM0002_VersionByWaterfallPopup` 팝업(내부 SP `SCM0002_GET_VERSIONBYWATERFALLPOPUP`, 축 "MF_SP_SF")
- **실제 동작 (실측)**:

    ① Division/기간(startYYYYMMDD·endYYYYMMDD) 수집
    ② new SCM0002_VersionByWaterfallPopup() → Form_Load(true, **"MF_SP_SF"**, div, start, end)(3408)
    ③ ShowDialog 모달
    ④ 반환 sVersions ≠ "" 이면 txtVersion.Text = sVersions **+ drpPeriod.InitValue = sPeriod**(3414-3415) — Version 과 Period 동시 세팅 (빈값이면 미변경, silent)

#### [12] btnColumn_Click
- **트리거**: Column Show 버튼 click  ·  **컨트롤/소스**: btnColumn (UsrButton Tag="Column Show", Designer D.321)
- **소스라인**: `321(wire)/3424-3434(body)`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup(mode=true), InitSpread
- **데이터/SP**: `DM0002_TitleSetForm_Popup` (컬럼셋 저장 SP) → OK 시 InitSpread 가 GetSpdTitle 재조회
- **실제 동작 (실측)**:

    ① new DM0002_TitleSetForm_Popup("DMF0082", shtMain="FcstNPrice", **true**, clbDivision)(3426) — 3번째 인자 true = 컬럼 Show/Hide 모드
    ② CenterParent, ShowDialog 모달
    ③ DialogResult==OK 이면 InitSpread() 재호출로 변경된 컬럼 타이틀/스팬/색상/footer 재적용

#### [13] btnMeasure_Click
- **트리거**: Measure 버튼 click  ·  **컨트롤/소스**: btnMeasure (UsrButton Tag="Measure Show", Designer D.283)
- **소스라인**: `283(wire)/3436-3448(body)`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup(mode=false), InitSpread
- **데이터/SP**: `DM0002_TitleSetForm_Popup` 내부(TitleSet 메타 저장)
- **실제 동작 (실측)**:

    ① new DM0002_TitleSetForm_Popup("DMF0082", "FcstNPrice", **false**, clbDivision)(3439) — 3번째 인자 false = Measure Show/Hide 모드
    ② CenterParent, ShowDialog 모달
    ③ DialogResult==OK 이면 InitSpread() 재실행하여 새 Measure 셋으로 그리드 컬럼/시트 재구성

#### [14] btnExchangeRate_Click
- **트리거**: Exchange Rate 버튼 click  ·  **컨트롤/소스**: btnExchangeRate (커스텀 액션 버튼, Designer D.811)
- **소스라인**: `811(wire)/3113-3154(body); GetFuturePriceInfo 3156-3174`  ·  **호출 메서드**: siMain.IsLock, DMF0000_ExchangeRatePopup.LoadData, ShowDialog, GetFuturePriceInfo, FindData
- **데이터/SP**: 팝업 `DMF0000_ExchangeRatePopup` + OK 후 `DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO` 재조회
- **MSG**: MSG00142
- **실제 동작 (실측)**:

    ① 편집모드(!IsLock)이면 **MSG00142**(Edit Mode 환율 팝업 금지)(3122) return
    ② new DMF0000_ExchangeRatePopup() → LoadData(drpPeriod.Value1 "yyyyMM", Value2 "yyyyMM", division)(3142-3143)
    ③ ShowDialog 모달
    ④ popup.blnOK 이면 dtFuturePrice = GetFuturePriceInfo() 재조회 + **FindData() 재조회**(환율 반영은 SP 재조회 방식). (구 DMF0020_SalesFuturePricePopUp 는 주석 3126-3139)

#### [15] btnSavePricePeriod_Click — Price 일괄입력
- **트리거**: Price일괄입력 버튼 click  ·  **컨트롤/소스**: btnSavePricePeriod (커스텀 액션 버튼 Text="Price일괄입력", Designer D.666)
- **소스라인**: `666(wire)/3455-3489(body)`  ·  **호출 메서드**: siMain.IsLock, DMF0082_SaveSalesFuturePrice_Popup.LoadData, ShowDialog
- **데이터/SP**: 전용 팝업 `DMF0082_SaveSalesFuturePrice_Popup` (내부 저장 SP `DM.DMF0082_SAVE_MAIN_DATA` 공유)
- **MSG**: MSG00408
- **실제 동작 (실측)**:

    ① 편집모드(!IsLock)이면 **MSG00408**(수정모드에서는 입력할 수 없습니다)(3464) return
    ② new DMF0082_SaveSalesFuturePrice_Popup() → LoadData(div, drpPeriod.Value1 "yyyyMMdd", Value2 "yyyyMMdd", clbSalesSite, ""(project), clbCustomer)(3474-3479) — End Customer 조건은 [PJ2025-50188] 추가
    ③ Size 1200×600, CenterParent, ShowDialog 모달
    ④ **저장 후 자동 재조회 없음** (반환 처리 주석 3484-3488 — 팝업이 자체 저장/재조회, `isSaveOK` 플래그만 노출)
    · (전용 팝업 내부: Period 는 항상 주 **월요일 스냅**, LOC measure 행만 편집·KRW/USD 행 잠금, 주차 W_ 셀은 직접편집 불가·PRICE_ALL 컬럼만 입력 통로, 저장 SP = `DMF0082_SAVE_MAIN_DATA` 16 param 공유)

### ▣ 그리드 편집 · 배분

#### [16] spdMain_Changed  ⭐ 핵심
- **트리거**: Grid cell value changed (edit/paste)  ·  **컨트롤/소스**: spdMain DefaultSheetDataModel.Changed (`dsdm.Changed += spdMain_Changed` 코드 배선 L412, 종단 재부착 L7624)
- **소스라인**: `412/7624(wire)/5537-7627(body); CELL변경 5620-5960; 수량배분 6072-7398; else키변경 7550-7616; ValidationCheck 7628-7636; SetSaveData 7638-7781; SetSaveDataRemove 7783-7862`  ·  **호출 메서드**: ValidationCheck, SetSaveData, SetSaveDataRemove, GetLookupValues(FCST_PRICE_EDIT_MEASURE/SALES_BUCKET), Data.Common(CURRENCY_LIST/CELL_PROD_SITE_ID), SetRowFormat, LockRange2, SetLockRange, dtCalendarDetail 배분
- **데이터/SP**: 그리드 셀(dtSave 내부 누적) — SP 직접호출 없음(저장은 SaveData); dtCalendarDetail(FindData Tables[4]) M+4 배분 기준; MSG00002/MSG00260
- **MSG**: MSG00002(×11 필드, ValidationCheck 경유), MSG00260(신규행 중복)
- **Division 분기**: Insert Validation 에서 `"81*"||"82"→Project`(5776) vs `"40"→End Customer`(5785); 중복검사는 `clb=="40"`(5923)에서만; else 키변경 시 `clb=="40"→sDivision="40" 강제`(7561)
- **실제 동작 (실측)**:

    ① 재진입 가드: `!CanModelChange` return(5539), `e.Column<=1`(Action/Select 컬럼) return(5541)
    ② **detach** `dsdm.Changed -=`(5547) → try 진입 → finally **재부착** `+=`(7624) — 내부 SetText/SetValue 재귀 차단 ([PJ2025-50188])
    ③ switch(e.Type) case CellsUpdated 진입
    ④ CELL 변경 region(5620-5960, Action=="I" 신규행만):
      · CURRENCY/MEASURE 변경(5624-5646): Measure=="LOC"→CURRENCY_LIST 콤보, 아니면 NO_DATA(빈 콤보)
      · MEASURE 변경(5648-5758): 행 전체 Lock→Unlock 재적용, LOC→SetRowFormat 소수3자리 / 그외 정수
      · Insert Validation(5762-5832): 버킷·태그 일치 시 필수 11필드 ValidationCheck — Division(5771) / "81*"||"82"→Project(5776) / "40"→End Customer(5785) / SalesSite(5793) / Item(5798) / Customs Handbook(5804) / FCST Type(5809) / Incoterms(5814) / Measure(5819) / Cell Prod Site(5824) / LOC+Currency(5829). 각 실패 시 **MSG00002 {필드}** + 셀 clear + return
      · 콤보 cascade(5833-5875): FCST_PRICE_EDIT_MEASURE→Measure 콤보 / ItemId→CELL_PROD_SITE_ID / ScmSiteId·Incoterms→SALES_BUCKET→BUCKET SetText
      · 중복행 체크(5878-5958, e.Column<=Measure): `clb=="40"` 8키 완전일치 카운트 → iDouble>=2(5948) 셀 clear + **GMessageBox("MSG00260")**(5953) + return
    ⑤ 수량 변경 — 활성 분기 정확히 4개:
      · **Daily + D_**(6072-6205): 좌측 최근접 W_ 부터 D_ 합산 → 주 Sum 갱신(MKT_FCST/VMI_In_Req/SCM_FCST 는 Math.Truncate 정수화) → 좌측 M_ 부터 W_ 합산 → 월 Sum 갱신 → 해당 일자 **SetSaveData**(6204)
      · **Weekly + W_**(6544-6742): 비LOC=주량을 BUCKET 비트 요일에 `Truncate(주합/버킷수)` 균등배분 + 마지막 버킷요일에 잔량(6597-6604), D_ SetText+SetSaveData; 버킷요일 없는 주=마지막일 전량; 나머지 일자 SetText("")+SetSaveData 0. LOC=매달 1일/월요일(월요일 강제)만 값 기입, 그외 0. 월 Sum 재계산(비LOC=합계 / **LOC=주 평균**)
      · **Monthly + M_**(7116-7398, [PJ2025-50188] M+4 배분): 실적구간(금주 월요일 이전 D_) continue(7198-7201); 주차별 `Truncate(월합/MONTH_DAY_CNT)×WEEK_DAY_CNT`(dtCalendarDetail) = 주 물량 → 주 내 버킷요일 균등 Truncate + 마지막 버킷요일 잔량, iWeeklyQtySum 누적 + iRemnant 추적(7252-7253); LOC=1일/월요일 그대로; 월 잔량은 마지막 버킷 보유 주차에 재분배(기존값 가산, 7349-7351); 마지막 W_ Sum 전체 재계산
      · **else 키컬럼 변경**(7550-7616): `clb=="40"→sDivision="40" 강제`(7561) + 키 재취득 → 해당 행 D_/W_/M_ 전부 SetText("")(7586-7612) → **SetSaveDataRemove**(7613) (키 바뀌면 기존 수량 무의미)
    ⑥ SetSaveData(7638-7781) upsert: 필수값 미비 시 조용히 return (Msg 주석화); YYYYMMDD 8자리 아니면 인라인 MessageBox("YYYYMMDD형식이 맞지 않습니다.")(7702); dedup 키 = LOC 14키(CURRENCY 포함) / 비LOC 13키. ⚠ **PROJECT_CODE 슬롯에 sEndCustomer 저장**(40 사업부 Project 미사용)
    ⑦ (활성 SetSaveData 호출 11곳 / SetSaveDataRemove 1곳 / 활성 GMessageBox 1건=MSG00260)
    · ⚠ 구 Monthly 로직(주석 6746-7110)의 **MSG00225**(실적 수량보다 작은 숫자 입력 불가)는 신 배분 로직에 승계처 없음 — 기능 격차 후보

#### [17] spdMain_CellDoubleClick
- **트리거**: Grid cell / column-header double click  ·  **컨트롤/소스**: spdMain.CellDoubleClick (Designer D.1144)
- **소스라인**: `1144(wire)/3534-3833(활성); 헤더토글 3536-3575; Sync팝업 3582-3705; 조기가드 3708-3711; Project 3713-3772; Item 3773-3824; Incoterms 3826-3830 (3835-5535 주석블록)`  ·  **호출 메서드**: GetColumnTag, Columns[].Visible 토글, FoxDataRequest('DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP'), DMF0003_SspSyncComparePopUp/SCM0002_ProjectbyDivisionPopupEx/DM0002_ItembyDivisionPopupEx, GetLookupValues(INCOTERMS)
- **데이터/SP**: `DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP`; 팝업 SspSyncCompare / ProjectbyDivision / ItembyDivision
- **Division 분기**: Sync 팝업은 `sDivision=="40" && sMeasure=="MKT_FCST" && BackColor∈{PaleGreen,PapayaWhip}`(3646) 에서만
- **실제 동작 (실측)**:

    ① 컬럼 헤더 더블클릭(3536-3575): 태그 'M_'(월) → 해당 월 구간 W_ Visible 토글 + 열린 D_ 숨김, 다음 M_ 에서 break / 'W_'(주) → 해당 주 구간 D_ Visible 토글 (팝업 없음)
    ② 데이터 셀: sBucketType=cboBucketType, sColName=GetColumnTag(e.Column)(3579-3580); 태그 길이 < 10 이면 return(3611)
    ③ MKT/SSP 동기화 비교 팝업(3582-3705): 버킷·태그 일치 AND `sDivision=="40"(화면필터) && sMeasure=="MKT_FCST"(행값) && 셀 BackColor==PaleGreen(A) 또는 PapayaWhip(P)` 이면 FoxData `DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP`(Timeout 30분, 3658) 호출 — 파라미터 division/scm_site/**project_code(=Customer)**/item/dom_exp/fcst_type/incoterms/yyyymmdd, 기간 당주 월요일~+20일 재계산 → DMF0003_SspSyncComparePopUp.LoadData(Tables[0], div) ShowDialog (조회 전용, 셀 반영 없음)
    ④ 조기 가드(3708-3711): IsLock 또는 Action != 'I'(신규행 아님)면 return — 이하 편집 팝업은 **신규 입력행 + Unlock 에서만**
    ⑤ Project 컬럼(3713-3772): SCM0002_ProjectbyDivisionPopupEx.Form_Load(false,…) → ProjectCode≠"" 시 Project/Name/Status/BizType/Owner 셀 SetText
    ⑥ ItemId 컬럼(3773-3824): DM0002_ItembyDivisionPopupEx.Form_Load(false,…,sMdmActive_Sw="Y", sMeasure_info) [E20231019-001234] → ItemID≠"" 시 Item/Name/Type/NickName SetText
    ⑦ Incoterms 컬럼(3826-3830, [E20250919-001699]): `GetLookupValues("INCOTERMS","ALL","Y")` 후 SetCellTypeCombo (과거코드 미노출, 팝업 아님)

#### [18] spdMain_ComboSelChange
- **트리거**: In-grid combo cell selection change  ·  **컨트롤/소스**: spdMain.ComboSelChange (Designer D.1145)
- **소스라인**: `1145(wire)/8201-8373(body); Division 8211-8265; Team 8266-8286; Customer 8287-8296; ScmSiteId 8297-8322; Incoterms 8324-8342; Measure 8347-8370(주석)`  ·  **호출 메서드**: Data.UserTeamByDivisionAuth, Data.Common(EndCustomerByDivision40), Data.UserSiteByEndCustomer, GetBizTypebyDivision, GetLookupValues(FCST_PRICE_EDIT_MEASURE/SALES_BUCKET), SetCellTypeCombo, LockRange, SetText
- **데이터/SP**: 콤보 UserTeamByDivisionAuth / EndCustomerByDivision40 / UserSiteByEndCustomer / FCST_PRICE_EDIT_MEASURE / SALES_BUCKET; `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`
- **Division 분기**: `Substring(0,2)=="40"→SalesSite40`(8235); `Substring(0,2)=="81"→PlantSiteId Unlock / else Lock`(8249)
- **실제 동작 (실측)**:

    ① Division 셀 변경(8211-8265): Team 콤보(UserTeamByDivisionAuth 8217) → Customer 콤보(EndCustomerByDivision40 8231) → **"40"→SalesSite40**(UserSiteByEndCustomer 8237) → BizType 재바인딩(`SCM0001_GET_BIZ_TYPE_BY_DIVISION` 8246) → **"81"→PlantSiteId Unlock / else Lock**(8250-8252) → Measure 콤보(8254-8263)
    ② Team 셀(8266-8286): Customer + SalesSite 콤보 재설정
    ③ Customer 셀(8287-8296): SalesSite 콤보 재설정
    ④ ScmSiteId 셀(8297-8322): Measure 콤보 + SALES_BUCKET 룩업 → BUCKET SetText
    ⑤ Incoterms 셀(8324-8342): SALES_BUCKET → BUCKET SetText
    ⑥ Measure 셀(8347-8370): **본문 전부 주석 (no-op)**

#### [19] spdMain_ClipboardPasted
- **트리거**: After clipboard paste into grid  ·  **컨트롤/소스**: spdMain.ClipboardPasted (Designer D.1142)
- **소스라인**: `1142(wire)/7864-8199(body)`  ·  **호출 메서드**: GetIncotermsType(AS_INCOTERMS), GetLookupValues(FCST_PRICE_EDIT_MEASURE), Data.Common(CELL_PROD_SITE_ID), SetCellTypeCombo
- **데이터/SP**: 셀 콤보 재바인딩용 룩업 (AS_INCOTERMS / FCST_PRICE_EDIT_MEASURE / CELL_PROD_SITE_ID)
- **Division 분기**: 없음(40 고정)
- **실제 동작 (실측)**:

    ① 대상 게이트: Action=="M"/"I" 행 + 셀 BackColor==UnLockColor(노랑) 만 처리 (헤더선택·잠금셀 continue)
    ② ScmSiteId 열(7905-7930): FCST_PRICE_EDIT_MEASURE→Measure 콤보 + GetIncotermsType(AS_INCOTERMS)→Incoterms 콤보 재설정
    ③ ItemId 열(7956-7985): Data.Common(CELL_PROD_SITE_ID)→CELL_PROD_SITE_ID 콤보
    ④ CELL_PROD_SITE_ID 열(7986-8014) / Measure 열(8015-8040): 콤보 재설정
    ⑤ Measure 좌측 열(8041-8050): 1행 복사 → 다중행 붙여넣기 시 첫 행 값 복제

#### [20] spdMain_EditChange
- **트리거**: Grid cell edit begin/change  ·  **컨트롤/소스**: spdMain.EditChange (Designer D.1146)
- **소스라인**: `1146(wire)/8375-8381(body)`  ·  **호출 메서드**: bPasteContinue 플래그
- **데이터/SP**: 없음(플래그 세팅만)
- **실제 동작 (실측)**:

    ① 활성 셀이 Measure 이하(좌측 키/메타 영역)이면 return(8377)
    ② 그 외(수량/우측 편집영역)면 bPasteContinue=true 세팅 (후속 Changed/Paste 재계산 파이프라인 가드 플래그)

#### [21] spdMain_KeyUp
- **트리거**: Key up in grid (Ctrl+C / Ctrl+V)  ·  **컨트롤/소스**: spdMain.KeyUp (Designer D.1148; 기본 KeyUp 은 DefineProperty 415 에서 detach)
- **소스라인**: `1148(wire)/8384-8425(활성; 8428-8484 두번째 정의는 블록주석)`  ·  **호출 메서드**: ClipboardPaste/ClipboardCopy(AsStringSkipHidden), GetSelection, bPasteContinue
- **데이터/SP**: 없음(클립보드)
- **실제 동작 (실측)**:

    ① fps==null 이면 return(8386)
    ② Ctrl+V → ClipboardPaste(AsStringSkipHidden)(숨김열 제외 붙여넣기) + bPasteContinue=true
    ③ Ctrl+C → Clipboard.Clear + ClipboardCopy(AsStringSkipHidden)
    ④ range = GetSelection(0)(8398) 저장 (붙여넣기 후처리용 selection 캐시)

#### [22] spdMain_TopChange
- **트리거**: Grid vertical scroll (top row change)  ·  **컨트롤/소스**: spdMain.TopChange (Designer D.1147)
- **소스라인**: `1147(wire)/8488-8493(body)`  ·  **호출 메서드**: CanModelChange 가드, siMain.SmartColMerge
- **데이터/SP**: 없음(그리드 병합 재계산)
- **실제 동작 (실측)**:

    ① CanModelChange=false 로 재진입 가드
    ② siMain.SmartColMerge() 호출하여 뷰포트에 새로 들어온 좌측 키 컬럼의 세로 병합 재계산
    ③ CanModelChange=true 복원 (스크롤 시 병합 셀 깨짐 방지)

#### [23] spdMain_LeaveCell
- **트리거**: Grid leave cell  ·  **컨트롤/소스**: spdMain.LeaveCell (Designer D.1143)
- **소스라인**: `1143(wire)/8495-8645(전량 주석)`  ·  **호출 메서드**: 없음
- **데이터/SP**: 없음
- **실제 동작 (실측)**:

    ① **본문 전부 주석 (no-op)** — 포맷 세팅은 spdMain_Changed 로 이관. 배선은 유지(껍데기만 활성). 구 KRW/USD/LOC/MKT_AMT_* 소수3 포맷 로직 잔존(비활성)

### ▣ CRUD 버튼 (BaseForm override)

#### [24] FindButton (override) → FindData()
- **트리거**: Find toolbar 버튼 / F-key  ·  **컨트롤/소스**: Common toolbar Find/Retrieve (BaseForm hotkey)
- **소스라인**: `671-676(override) / FindData 1662-1790 (async) / Draw 1793-2022`  ·  **호출 메서드**: FindData(), FoxAsyncProxy.ExecuteAsync('DM.DMF0082_GET_MAIN_DATA'), siMain.Query/SmartColMerge/LockColumn, Draw, SetEditList, SetSpreadColumn
- **데이터/SP**: SP `DM.DMF0082_GET_MAIN_DATA` (5 result tables: [0]본문 / [1]dtWeek(ISO_WEEK·MONTH_NAME) / [2]THIS_YYYYMMWW·ISO_WEEK / [3]Measure 편집권한 / [4]dtCalendarDetail)
- **MSG**: MSG00097, MSG00283, MSG00108, MSG00164
- **Division 분기**: 40 고정 (파라미터 p_division_id = clbDivision)
- **실제 동작 (실측)**:

    ① CanModelChange=false + 검증: Division 공란→**MSG00097**(1674) / Version 공란→**MSG00283**(1682) / from>to→**MSG00108**(1695) / 기간 3년 초과→**MSG00164** + Value2 를 Value1+2년으로 보정 후 return(1701-1705)
    ② FoxAsyncProxy.ExecuteAsync `DM.DMF0082_GET_MAIN_DATA`(Timeout 30분, 1723) — 파라미터 **12종**: p_division_id/p_team_id/p_customer/p_biz_type/p_from~to_yyyymmdd/p_scm_site_id/p_item_id/**p_version_type(=txtVersion)**/**p_qty_yn(=cboQty Y/N, 1736)**/p_created_by/p_user_group
    ③ 결과 소비: Tables[1]→dtWeek, Tables[3]→Measure별 편집권한(SetEditList 소비 → bEDIT_AUTH_* 4 플래그), Tables[4]→dtCalendarDetail(M+4 배분 기준)
    ④ Version=="Current" 이면 isCurVersion=true(1776-1779) — Insert/Edit 게이트
    ⑤ Draw()(1793-2022): siMain.Query(Tables[0]) + SmartColMerge + LockColumn(0,max,true 전체잠금 1812), NOTATION 별 행 포맷(INTEGER=정수/POINT3=소수3), 실적구간 Gainsboro·당월 White(1960/1966), 당주 Green BevelBorder, SetEditList/GetCustomsHandbook/GetFcstType/sDefaultDay 세팅
    ⑥ catch: GMessageBoxForException(1783)

#### [25] InsertButton (override) → InsertRow()
- **트리거**: Insert toolbar 버튼  ·  **컨트롤/소스**: Common toolbar Insert (BaseForm)
- **소스라인**: `678-684(override) / InsertRow 2492-3034 / Insert 9292-9417`  ·  **호출 메서드**: InsertRow(), siMain.Insert, GetLookupValues(INCOTERMS), Data.Common(EndCustomerByDivision40/CELL_PROD_SITE_ID/CURRENCY_LIST), Data.UserSiteByEndCustomer, SetCellTypeCombo, LockRange2, SetLockRange
- **데이터/SP**: 콤보 INCOTERMS / EndCustomerByDivision40 / UserSiteByEndCustomer / FCST_PRICE_EDIT_MEASURE / CELL_PROD_SITE_ID / CURRENCY_LIST / FCST_TYPE(dtWarrType) / DM_CUSTOMS_HANDBOOK
- **Division 분기**: `!isCurVersion` return(681); `Substring=="40"`(2536)→ItemId 팝업셀+DomExp 콤보; `sDivision=="40"`(2577)→신규행 콤보 6종
- **실제 동작 (실측)**:

    ① `!isCurVersion` 이면 return(681) — **Current 버전 조회일 때만 Insert 허용**
    ② IsLock==true 이면 로직 전체 미수행(2494); 편집모드+shtMain 확인
    ③ 선택영역 기준 복사행 산정(2503-2517) → `Insert()`(2520)(신규행 Action='I')
    ④ INCOTERMS 콤보 = GetLookupValues("INCOTERMS","ALL","Y")(2528, 과거코드 제외); `Substring=="40"`(2536) → ItemId 셀=cellTypeImage(팝업버튼) + Division 값 + DomExp 콤보; FcstType 콤보=dtWarrType(2572)
    ⑤ `sDivision=="40"`(2577) → 신규행 콤보 6종: EndCustomer(EndCustomerByDivision40) / SalesSite(UserSiteByEndCustomer) / Incoterms / Measure(FCST_PRICE_EDIT_MEASURE) / CellProdSite(CELL_PROD_SITE_ID) / Currency(CURRENCY_LIST)
    ⑥ 선택행 키 복사(2636-2669); 선택행 없으면 Measure="MKT_FCST" 기본(2674)
    ⑦ 녹색 실적구분선(2687-2734), 편집 key 9열 LockRange2 unlock(2744-2752: END_CUSTOMER/SCM_SITE_ID/ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CELL_PROD_SITE_ID/CURRENCY/MEASURE), `SetLockRange(iActRow,iActRow,false)`(2855) 기간구간 unlock

#### [26] DeleteButton (override)
- **트리거**: Delete toolbar 버튼  ·  **컨트롤/소스**: Common toolbar Delete (BaseForm)
- **소스라인**: `686-930`  ·  **호출 메서드**: siMain.GetText(Action/Measure), SetSaveDataRemove, siMain.Delete/DeleteRow, SetValue+SetSaveData(0), bEDIT_AUTH_* 권한 플래그
- **데이터/SP**: 없음(로컬 그리드 + dtSave 조작); MSG00464
- **MSG**: MSG00464 (×4 메저)
- **Division 분기**: 없음(40 고정)
- **실제 동작 (실측)**:

    ① 단일셀 강제(695-702), list_EDIT_Day 없으면 return(728); 활성행 Action 판정
    ② Action=="D"(781-785): 삭제취소 (SetSaveDataRemove + Delete 표시 해제)
    ③ Action=="I"(788-795): SetSaveDataRemove + DeleteRow 즉시 삭제 [E20250929-000202]
    ④ else(DB 조회행)(797-922): Measure ∈ {MKT_FCST, VMI_In_Req, SCM_FCST, LOC} 만 삭제 진행(799); **권한 플래그(bEDIT_AUTH_*) 미보유 시 MSG00464(수정할 수 없는 메져입니다) ×4**(SCM_FCST 802 / MKT_FCST 810 / LOC 816 / VMI_In_Req 822) return; Action 이 "M"이었으면 기존 수집 제거(827-831); Delete()로 'D' 표시(833) 후 계획구간 일자 순회하며 Qty=0 SetValue + SetSaveData(0)(836-920) (실적구간 미변경 — 파라미터 폭증 방지); Refresh(929)

#### [27] EditButton (override)
- **트리거**: Edit toolbar 버튼 (버킷 변경 시에도 호출)  ·  **컨트롤/소스**: Common toolbar Edit (BaseForm)
- **소스라인**: `1531-1610 (구버전 933-1519 전량 주석)`  ·  **호출 메서드**: siMain.GetColumnIndex(필수컬럼), MessageHelper.GMessageBox, Action 컬럼 Visible 토글, SetBGColor2, SetLockRange
- **데이터/SP**: 없음(로컬 잠금/채색); dtWeek(FindData Tables[1]) 조회이력 확인
- **MSG**: MSG00113, MSG00259
- **Division 분기**: `!isCurVersion` return(1534); `clb=="40"`(1543) 필수 9컬럼 검증
- **실제 동작 (실측)**:

    ① `!isCurVersion` 이면 return(1534) — Current 아니면 편집모드 진입 차단
    ② `clb=="40"`(1543): 필수 9컬럼(Division/Customer/ScmSiteId/ItemId/DomExp/FcstType/Incoterms/Measure/CELL_PROD_SITE_ID) 중 하나라도 그리드에 없으면 **MSG00113**(1552) return
    ③ dtWeek null/0행(미조회)이면 **MSG00259**(조회 후 수정모드로 가능)(1561) return
    ④ Action 컬럼 Visible 토글 = Lock↔Edit 모드 전환(1568-1583), off 시 LockColumn2 전 컬럼 재잠금
    ⑤ 실적컬럼 Gainsboro/당월 흰색 재도색(1589-1598), `SetLockRange(0, MaxRow, !IsEditMode)`(1600) — 버킷별 편집가능 범위(list_EDIT_Day/Week/Month, FCST 3메저 Monthly 는 M+4만) unlock

#### [28] SaveButton (override) → SaveData()
- **트리거**: Save toolbar 버튼  ·  **컨트롤/소스**: Common toolbar Save (BaseForm)
- **소스라인**: `1612-1615(override) / SaveData 2025-2217 (async) / fnValidation 2220-2490`  ·  **호출 메서드**: SaveData(), fnValidation, FoxAsyncProxy('DM.DMF0082_SAVE_MAIN_DATA'), DMF0003_SspSyncPopUp, FindData(재조회)
- **데이터/SP**: SP `DM.DMF0082_SAVE_MAIN_DATA` ('^' bulk 16 param); 성공 후 재조회 `DM.DMF0082_GET_MAIN_DATA`
- **MSG**: MSG00002, MSG00043, MSG00449, MSG00012, MSG00004 (+ 인라인 ERR_MESSAGE/RESULT_MSG)
- **Division 분기**: fnValidation 중복검사 `Substring(0,2)=="40"`(2284)에서만
- **실제 동작 (실측)**:

    ① IsLock==true(편집모드 아님) 또는 SheetName≠shtMain 이면 저장 전체 무시(2027-2029)
    ② **fnValidation()**(2052, 2220-2490): dtSaveFinal.Clear 후 재구성 → Insert 행 수 집계(2232-2238) → `clb=="40"`(2257) 키값 읽기 → `Substring(0,2)=="40"`(2284) 중복 키 체크(Div+Customer+Site+Item+DomExp+Fcst+Incoterms+Measure(+LOC 시 Currency)+CellProdSite 완전일치 2행↑ → bValidation=false) → LOC && Currency=="" → bInputCheck2=true(2334) → Insert 행 D_ 수량 0칸 → bInputCheck=false(2347-2376) → 정상: dtSave→키필터 Select→dtSaveFinal ImportRow + ToTable(true) dedup(그리드 잔존 행만)
    ③ bInputCheck2==true → **MSG00002 {Currency}**(2057) return; fnValidation false(!bInputCheck) → **MSG00043**(중복 데이터)(2064) return
    ④ dtSaveFinal 각 행을 '^' join(Qty 공란→"0", 2081) — **16 파라미터**: p_active_flag(Action I/M/D) / p_division_id / **p_project_code(=End Customer 값)** / p_end_customer / p_scm_site_id / p_item_id / p_dom_exp / p_fcst_type / p_incoterms / p_measure / p_plant_site_id / p_cell_prod_site_id / p_yyyymmdd / p_currency / p_qty / p_created_by(UserId '^' 반복)
    ⑤ 저장 직전 확인 **MSG00012**(저장 하시겠습니까)(2129) — Yes 아니면 return
    ⑥ FoxAsyncProxy `DM.DMF0082_SAVE_MAIN_DATA`(Timeout 10분, 2031) 비동기 호출
    ⑦ 결과 판정: RESULT_CODE=="S" → **MSG00004 {RESULT_CNT}**(2172) + viewport TopRow 보존 후 **FindData() 재조회** + IsChange=false; RESULT_CODE=="F" → 인라인 `MessageBox.Show(ERR_MESSAGE)`(SQL 오류)(2186) 또는 `MessageBox.Show(RESULT_MSG)`(SP validation)(2192) + IsEditMode 유지 (+Tables[1] TITLE="SSP_SYNC_T_ERR" 시 DMF0003_SspSyncPopUp)
    ⑧ iCount==0 → **MSG00449**(2213); catch: GMessageBoxForException(2203); finally: dtSaveFinal.Clear
    · 참고(SP 내부 주의): 저장 SP 내부에서 `PR_DM_PLN_CFM_TO_MKT_FCST` 실행(MKT_KRW/MKT_LOC 재설정), LOC 삭제 시 52주 구간 MKT FCST/RTF 존재 validation (ERR_RTN → RESULT_MSG passthrough)

#### [29] ExcelButton (override)
- **트리거**: Excel toolbar 버튼  ·  **컨트롤/소스**: Common toolbar Excel (BaseForm)
- **소스라인**: `1618-1654`  ·  **호출 메서드**: SimplexelService.ExportFpSpread, MessageService.CloseProgress
- **데이터/SP**: 없음 (로컬 Export) [E20240906-001717]
- **실제 동작 (실측)**:

    ① SimplexelService.ExportFpSpread(fps, exportOption) — Merge=None, Border=All, AheadZero=HideZero, AmendZero=ShowZero, NullToZero=false, AmendDecimalFormat="#,##0.##0;[Red]-#,##0.##0"
    ② 파일명 = `StartupPath\DMF0082_FcstNPrice_Mgmt_{yyyyMMddHHmmss}.xlsx`
    ③ finally MessageService.CloseProgress()

---

## 2. 버튼 인벤토리 (12) — AS-IS 실측

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/권한 | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find / Retrieve (common toolbar) | toolbar (BaseForm) | FindData(): 검증 + async 조회 + Draw 바인딩 | DM.DMF0082_GET_MAIN_DATA (5 tables) | MSG00097/00283/00108/00164 | Always | 671-676 / 1662-1790 |
| 2 | Insert (common toolbar) | toolbar | InsertRow(): 신규행 Action='I' + 콤보 6종 | (콤보 룩업) | — | **`!isCurVersion` 시 차단**(Current 조회만) | 678-684 / 2492-3034 |
| 3 | Delete (common toolbar) | toolbar | Action 분기: D=취소 / I=즉시삭제 / DB행=계획구간 0 | — | MSG00464 ×4 | 4메저(MKT/SCM/LOC/VMI) 권한 없으면 차단 | 686-930 |
| 4 | Edit (common toolbar) | toolbar | Action 컬럼 Visible 토글 = Lock/Edit + 버킷별 unlock | — | MSG00113/00259 | **`!isCurVersion` 시 차단**; 필수 9컬럼 | 1531-1610 |
| 5 | Save (common toolbar) | toolbar | SaveData(): fnValidation → '^' 16 bulk 저장 | DM.DMF0082_SAVE_MAIN_DATA; DMF0003_SspSyncPopUp | MSG00002/00043/00449/00012/00004 | Edit 모드; async void | 1612-1615 / 2025-2217 |
| 6 | Excel (common toolbar) | toolbar | SimplexelService.ExportFpSpread | (로컬 export) | — | Always | 1618-1654 |
| 7 | btnColumn 'Column Show' | 조회조건 영역 | 컬럼 Show/Hide 팝업(true); OK 시 InitSpread | DM0002_TitleSetForm_Popup("DMF0082",true,div) | — | Always | 321(wire) / 3424-3434 |
| 8 | btnMeasure 'Measure Show' | 조회조건 영역 | Measure Show/Hide 팝업(false); OK 시 InitSpread | DM0002_TitleSetForm_Popup("DMF0082",false,div) | — | Always | 283(wire) / 3436-3448 |
| 9 | btnItemId '...' | Model 필드 | Item 선택 팝업 → txtItemId | DM0002_ItembyDivisionPopupEx | — | Always | 736(wire) / 3373-3395 |
| 10 | btnVersion '...' | Version 필드 | Version 팝업(MF_SP_SF) → Version+Period 세팅 | SCM0002_VersionByWaterfallPopup | — | Always (직접 타이핑=KeyDown 위임) | 773(wire) / 3397-3417 |
| 11 | btnExchangeRate 'Exchange Rate' | 조회조건 영역 | 환율 팝업 → OK 시 GetFuturePriceInfo + FindData 재조회 | DMF0000_ExchangeRatePopup | MSG00142 | Lock(비편집) 상태만 | 811(wire) / 3113-3154 |
| 12 | btnSavePricePeriod 'Price일괄입력' | 조회조건 영역 | Price 일괄입력 전용 팝업(1200×600); 자체 저장 | DMF0082_SaveSalesFuturePrice_Popup | MSG00408 | Lock(비편집) 상태만 | 666(wire) / 3455-3489 |

> ※ 우클릭 컨텍스트 메뉴 없음 (DMF0003 와 달리 contextMenuStrip 미배선). Sync 비교는 셀 더블클릭[17]으로만 진입.

---

## 3. 조회조건 컨트롤 (17) — AS-IS 실측

| # | 컨트롤 | 라벨 | 유형 | 초기상태/기본값 | Division 분기 | Cascade | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | clbDivision | Division | combo (UsrCombo single) | MyDivision **"CODE='40'" 필터**로 40 고정 | 화면 전체 40 전용 | Click 배선(D.594)이나 **핸들러 no-op** | D.561/594; body 3039 |
| 2 | clbTeam | Team | checkbox-list | UserTeamByDivision; ALL | 40 은 Team=부서키 | SIC → EndCustomer + SalesSite 재조회 | D.521/559; body 3043 |
| 3 | clbCustomer | End Customer | checkbox-list | EndCustomerByDivision; ALL | 40 → GetSalesSite40(team) / 81·82 → GetSalesSite | SIC → SalesSite 재조회 | D.481/519; body 3063 |
| 4 | clbBizType | Biz Type | checkbox-list | BizType; ALL | — | Division/grid Division 콤보 변경 시 재바인딩 | D.442/(무배선) |
| 5 | clbSalesSite | Sales Site | checkbox-list | ScmSitebyEndCustomer40 → UserSiteByEndCustomer; ALL | 40 → SiteByEndCustomer40 | Team/Customer 변경 시 재조회 | D.403/(무배선) |
| 6 | cboBucketType | Bucket | combo (Daily/Weekly/Monthly) | DMF0003_GET_BUCKET_TYPE_CODE; **기본 Weekly** | 40 → Weekly (OnShown) | SIC → SetSpreadColumn/green border/re-edit; Click → Insert 행 있으면 MSG00227 | D.323/358·359; body 3248/3361 |
| 7 | drpPeriod | Period | date range | InitValue = PR_GET_DAY_RANGE(p_month=6) 당월1일~6개월 | — | FindData 검증(from≤to MSG00108, 3년 MSG00164); Version 팝업이 재세팅 | D.361/(무배선) |
| 8 | txtItemId (+ btnItemId) | Model / Nickname | text + modal | 빈값 | — | btnItemId 팝업이 세팅 | D.668; btn D.736 |
| 9 | txtVersion (+ btnVersion) | Version | text + modal | **"Current"** | — | btnVersion(MF_SP_SF) 팝업이 Version+Period 세팅; KeyDown→팝업 위임. **Current 만 Insert/Edit 허용(isCurVersion)** | D.596; btn D.773/KeyDown D.774 |
| 10 | cboQty | Qty≥0 | checkbox | InitValue "N" | — | **SP 파라미터** p_qty_yn (FindData 1736); 핸들러 없음 | D.211/(무배선) |
| 11 | chkSum | Sum | checkbox | InitValue "N"; InitControls false(382) | — | **FE 전용** CheckedChanged → SetSpreadColumn (Sum 컬럼 토글, SP 미전달) | D.174/209; body 9046 |
| 12 | btnColumn | (Column Show) | button (icon) | Tag "Column Show" | — | 팝업(true) → InitSpread | D.285/321 |
| 13 | btnMeasure | (Measure Show) | button (icon) | Tag "Measure Show" | — | 팝업(false) → InitSpread | D.248/283 |
| 14 | btnItemId | (Model 검색) | button (icon) | — | — | Item 팝업 → txtItemId | D.702/736 |
| 15 | btnVersion | (Version 검색) | button (icon) | — | — | Version 팝업 → txtVersion+Period | D.738/773 |
| 16 | btnSavePricePeriod | Price일괄입력 | button (text) | 커스텀 액션 | — | 전용 팝업(1200×600); Edit 모드면 MSG00408 | D.630/666 |
| 17 | btnExchangeRate | Exchange Rate | button (text) | 커스텀 액션 | — | 환율 팝업; Edit 모드면 MSG00142 | D.776/811 |

> 그리드 `spdMain`(FpSpread, 시트 "FcstNPrice", 헤더 3단 월/주/일) 별도. 배선 이벤트 7종(ClipboardPasted/LeaveCell/CellDoubleClick/ComboSelChange/EditChange/TopChange/KeyUp).

---

## 4. ② User 관점 변환 요지 (시트 5 반영용)

> 개발 세부(메서드명·변수·라인·detach/attach·주석블록)를 제거하고, **업무 규칙 + MSG 의미**만 남긴 요지. UI분석서 시트5 "상세동작(User)" 에 반영.

### 4.1 화면 성격
- **소형(Division 40) 전용** Fcst & Price 관리 화면. 조회 시 **버전(Version)** 을 반드시 선택하며, 기본값 "Current"(현재 버전) 조회일 때만 신규 추가·수정이 가능하다. 과거 버전은 조회 전용.
- Bucket(일/주/월) 단위로 수량을 보고, 한 셀에 입력하면 하위 기간으로 자동 분배된다. 기본은 주(Weekly).

### 4.2 조회
- Division·Version 은 필수. 안 고르면 각각 "Division 선택"·"Version 을 선택하고 조회하세요"(MSG00097/MSG00283) 안내.
- 조회 기간은 시작일이 종료일보다 늦으면 안 되고(MSG00108), 3년을 초과하면 자동으로 2년으로 줄여준다(MSG00164).
- Team → End Customer → Sales Site 가 위에서 아래로 연동되어 목록이 좁혀진다.

### 4.3 편집·수량 입력
- 수정하려면 Edit 로 전환. 조회를 먼저 하지 않았거나 필수 항목(고객/사이트/모델/인코텀즈/예측유형/통관/메저/셀생산지)이 없으면 편집 불가(MSG00259/MSG00113).
- 편집 가능한 기간은 **금주(당주/당월) 이후**만. 단 예측 메저(MKT/SCM FCST·VMI)는 월 기준 **4개월 뒤(M+4)부터**, 가격(LOC)은 당월부터 수정 가능. 지난 실적 구간은 회색으로 잠긴다.
- **주 칸에 수량을 넣으면 그 주의 요일들에 균등 분배**(나머지는 마지막 요일에 몰아줌), **월 칸에 넣으면 주→일 순으로 분배**된다. 가격(LOC)은 나누지 않고 매달 1일/월요일에 그대로 들어간다.
- 신규 행에 필수 항목이 비면 해당 항목명으로 "필수 입력" 안내(MSG00002), 같은 조합이 두 번 들어가면 "중복" 안내(MSG00260).
- 편집 중에는 Bucket 을 못 바꾼다(추가 행이 있으면 MSG00227).

### 4.4 저장
- 저장 전 "저장하시겠습니까?"(MSG00012) 확인. 성공하면 "N건 저장"(MSG00004) 후 목록을 다시 불러온다.
- 중복 조합이 있으면 저장 실패(MSG00043), 가격(LOC) 행에 통화(Currency)가 비면 "Currency 필수"(MSG00002), 저장할 내용이 없으면 안내(MSG00449).
- 서버 검증(예: 가격 삭제 시 향후 52주 예측/RTF 존재)에 걸리면 서버 메시지를 그대로 보여준다.

### 4.5 삭제
- 한 셀을 골라 삭제. 이미 추가한 새 행은 즉시 사라지고, 저장된 행은 해당 메저를 수정할 권한이 없으면 "수정할 수 없는 메져입니다"(MSG00464). 삭제는 계획 구간 수량을 0으로 만드는 방식(실적은 건드리지 않음).

### 4.6 보조 기능
- **Price 일괄입력**: 여러 사이트/고객의 가격을 주 단위로 한 번에 입력하는 별도 창(편집모드에서는 못 열고 MSG00408). 가격(LOC) 행만 입력되고 KRW/USD 는 환율로 자동 계산되어 잠긴다.
- **Exchange Rate**: 환율 조회/등록 창(편집모드에서는 못 열고 MSG00142). 닫으면 화면을 다시 조회해 반영.
- **셀 더블클릭**: MKT FCST 동기화 셀(초록/살구색)을 더블클릭하면 SSP 대비 수량 비교 창이 뜬다. 신규 행의 Project/Model 칸은 더블클릭으로 선택 팝업.
- **Column Show / Measure Show**: 화면에 보일 컬럼/메저를 사용자가 고른다. **Sum** 체크는 합계 컬럼 표시 토글(조회에 영향 없음), **Qty≥0** 체크는 조회 필터.

---

> **실측 근거**: 본 문서의 모든 라인 번호·파라미터·MSG·분기는 `DMF0082_FcstNPrice_Mgmt.cs`(9,418줄) + `.Designer.cs`(1,299줄) + 전용 팝업(2,827줄) 전수 Read 및 grep 교차검증(GMessageBox 56 hit, ValidationCheck 22 hit, FoxDataRequest 16 call-site, ShowDialog 10) 결과이며, 주석(비활성) 코드는 카운트에서 제외하고 활성 코드만 기술함.
