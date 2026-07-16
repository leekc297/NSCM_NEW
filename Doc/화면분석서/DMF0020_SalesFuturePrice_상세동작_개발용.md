# DMF0020 Sales Future Price (판가) — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS 정본 `GSCM\06.UIL\GSCM.DM.Forms.UIL\Master\DMF0020_SalesFuturePrice\DMF0020_SalesFuturePrice.cs` (**실측 3,969줄** — 물리 LF `wc -l` 기준) + `.Designer.cs` (**1,599줄** LF) 전수 Read. ⚠ **3벌+dead copy 병존** — 동명 `DMF0020_SalesFuturePrice.cs` 가 `GSCM.DM.Plan.UIL` / `GSCM.DM.Shipment.UIL` 아래에도 존재하나, **유일하게 `.csproj` 에 참조되어 빌드 산출물로 들어가는 `GSCM.DM.Forms.UIL\Master` 판을 정본 채택**([PJ2025-50017] 소형사업부 매출계획 동기화·[PJ202350699] 속도개선·[E20240903-000738] Price Exist 검증 등 최신 활성 로직 반영판). (Plan/Shipment 사본은 dead copy — 카운트·라인 제외)
> **데이터 접근**: 레거시 FoxData (`FoxDataClient`/`FoxAsyncProxy`/`DataService.GetDMInnerTable`(BigFilter)/`Data.Common`·`Data.User*Auth`). 핵심 엔드포인트 — 조회 `DM.DMF0020_GET_SCM_MST_FUTURE_PRICE`(param 20+, 이중 OUT 커서 O_RC1 타이틀 + O_RESULT_CURSOR 본문, Timeout 10분) / 저장 `DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL`('^' bulk 16컬럼, DELETE-INSERT + _H 이력, Timeout 90분) / 일괄입력 팝업 저장 `DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` / 동적 다단 헤더 `DM.DMF0020_GET_SPREAD_TITLE` + `DM.DMF0020_GET_SPREAD_TITLE_DATE`(주차 컬럼) / 부가기능 패키지 `PKG_DMF0020`(4,609줄, 환율 `SAVE_DM_MST_EXCHANGE_RATE_ALL`·통화변환 `SAVE_SCM_MST_FUTURE_PRICE_CONVERSION`·FuturePriceInfo/OwnerData/PriceTemplate/PricePopup) — TO-BE 대응 = `PKG_DMF0020` SP.
> **범위**: 화면 이벤트/액션 **32 핸들러 전수** (Designer 배선 실측). 내역 = CRUD override 6 (Find/Insert/Delete/Edit/Save/Excel) + 그리드 이벤트 5 (CellClick/CellDoubleClick/ComboSelChange/TopChange/KeyUp) + DataModel.Changed(코드배선) + 조회조건 cascade 6 + 조회조건/화면 버튼·팝업 13 + Resize 1. 본 문서는 실동작 핸들러를 §1 에 **7 그룹 32 항목**으로 그룹핑한다.
> **화면 특성** — DMF0082(40 소형 전용) 와 달리 **Division 3종 지원**: 40(소형)/81*(자동차, 앞2자리 판정)/82(ESS/Power Tool). Division 은 **단일 선택 콤보**(clbDivisions, UsrCombo DropDownList). Bucket 기본 = **콤보(Weekly/Monthly)**, 신규행 존재 시 변경 차단(MSG00227). **Version 필드 有**(txtVersion + btnSPVer) — `isCurVersion`(txtVersion=='Current' 조회 시에만 true)이 **Insert/Edit 전면 게이트**(과거/특정 버전 조회는 읽기전용). **환율 팝업·Price 일괄입력 팝업**은 편집모드(!IsLock)에서만. 좌측 정보열 = measure 4행(LOC/USD/KRW/RTF) 세로 병합. 가격셀 편집 시 LOC 기준 KRW/USD **환율 자동 환산**(GetExchangeRate).
> MSG 코드 문구 = 소스 인라인 주석 실측(대부분 확보). 인라인 문구 없는 코드·`MSG_M 미등재` 는 "문구 미확인(실측 대사 필요)" 로 표기. ⚠ 메모리 `feedback_msg_id_text_reconciliation` 준수 — TO-BE 반영 전 사내 MSG_M 전수 대사 의무.

> ⚠ 이 문서는 **개발자용 기술 상세본**입니다. User 관점 가독본은 **UI분석서 시트 5** 참조. (§4 User 관점 변환 요지 = 시트5 반영용 요약)
> **짝 산출물**: `DMF0020_SalesFuturePrice_UI분석서_v1.1.xlsx`(10시트, User 관점 가독본 + Validation 96 + SP제약 41). 본 문서 말미 **부록 A/B** 에 SP제약·Validation 전수 실측표 보존.

---

## ⭐ 편집 가능 판정 — AS-IS vs TO-BE (핵심 규칙, 오기재 금지)

| 계층 | AS-IS 실측 | TO-BE 결정(2026-07-07) |
|---|---|---|
| 서버 편집권한 | `SCM_ADM_USER_MNU_EDIT_AUTH_V`(USER×MNU×UNIT_TP='D'×DIVISION) `NVL(EDIT_YN,'N')` — PKG 7 조회지점, 25 hit. **SP 본문에 division 하드코딩 없음** | (유지) 사용자별 권한은 그대로 |
| 화면 편집대상 | `EditButton` L870: `GetLookupValues("DM_UI_EDITABLE_DIVISION","DMF0020",division)` → **EDIT_YN=='N' 이면 MSG00448 return**. 위임목록(SEGMENT2='40')에 40 만 → **40=DMF0082 로 편집 위임(차단)**, **81·82 는 편집 진행**(필수컬럼 세트만 상이) | ⭐ `DM_EDITABLE_DIVISION_ALLOW`(SEGMENT1='DMF0020')=**`82`만** (신규 lookup, DB 미등재 시 FE fallback `{'82'}`) |
| FE 판정 | (구) `SalesFuturePriceGrid` `divisionId!==40` / `SalesFuturePrice` `isDiv82(===82)` 혼재 | `isEditableDivision(divisionId, editableSet)` 정확일치 멤버십 — `utils/editableDivision.ts`. **82(Power Tool)만 편집, 40/81/81_UC/81_HM/81_ST/81_HD/81_HG=제약** |
| .cs 편집 게이트 | `EditButton`(861): ① `!isCurVersion` return ② 40 → EDIT_YN='N' → MSG00448 ③ division별 필수컬럼(40/81/82 상이) 결손 → MSG00113 ④ PRICE_EXIST 결손 → MSG00412 ⑤ 82&NewFlag='Y' 행별 세부 Lock | FE 에 **82만 편집** 반영 |
| SAVE 재검증 | SAVE(ALL/POPUP)는 편집권한 재검증 **안 함** — 업무검증(필수/중복/가격편차)만 | (참고) 편집 게이팅 = 조회(isCurVersion)+FE 책임 |

> **함의**: AS-IS 는 **40 만 제외**(EDIT_YN='N' 위임)하고 81·82 는 편집 가능이며, 진짜 편집권한은 `사용자×사업부 EDIT_YN` 메타 모델이다. 사용자 요구(**82 만 편집** = **40·81·81_계열(81_HD/HG/HM/ST/UC)·EE계열 전체 편집불가** — 2026-07-14 재확인)는 AS-IS 대비 **81 계열을 제약하는 의도적 규칙 변경**이며, LOOKUP(`DM_EDITABLE_DIVISION_ALLOW`) 구동으로 소스화하여 FE 하드코딩을 제거함. ⚠ 본 규칙은 실측+사용자 확정(**40·81·81_계열·EE계열 편집불가 / 82만 편집가능**)으로 기술하며, AS-IS 를 "82만 편집" 으로 소급 오기재 금지(AS-IS 는 81 도 편집 가능이었음).

---

## 1. 이벤트 · 액션 상세 (7 그룹 / 32 핸들러)

### ▣ 초기화

#### [1] Form_Load
- **트리거**: Form load  ·  **컨트롤/소스**: `this.Load += Form_Load` (ctor L188 배선, `UnFilterInsertRow=true` L189)
- **소스라인**: `188(wire)/192-215(body); InitControls 293-416; CreateSpread(3행 헤더); DefineProperty 436-472; InitEvent(Dsdm.Changed+cboBucketType.SIC 코드배선)`  ·  **호출 메서드**: CControl 생성, InitForm(BaseForm), InitControls, CreateSpread(AddSheet 3,1,45→InitSpread(true)), DefineProperty, InitEvent
- **데이터/SP**: (하위 InitControls 참조)
- **Division 분기**: `clbDivisions.ControlValues.Substring(0,2)=="81"`(203) → btnExcelUpload/btnTemplate.Visible=true + layoutControlItem12/29 Always; else → Never/false (Excel 업/다운로드는 81 자동차 전용)
- **실제 동작 (실측)** — 초기화 순서:

    ① 생성자(183-190): InitializeComponent → this.Load += Form_Load(188) → UnFilterInsertRow=true(189)
    ② Form_Load(192-215): clsCtrl=new CControl → InitForm() → **InitControls()** → CreateSpread() → DefineProperty() → InitEvent()
    ③ Division 분기(203-214): 81* → Excel Upload/Template 버튼 노출 / else 숨김

#### [2] InitControls
- **트리거**: Form_Load 내부 호출  ·  **컨트롤/소스**: (조회조건 BigFilter 초기 세팅)
- **소스라인**: `293-416`  ·  **호출 메서드**: GetDayRange, SetChangeControl(BigFilter), clsCtrl.setListBox, GetMeasureCountInfo, GetFuturePriceInfo, GetWeekData, GetBucketType, CString.GetCheckedListValue
- **데이터/SP**: `DM.PR_GET_DAY_RANGE`(GetDayRange, p_month=6, drpDateTime InitValue 423); BigFilter `GetDMInnerTable`(MyDivision→clbDivisions / UserTeamByDivision→clbTeam / EndCustomerByDivision(40=EndCustomerByDivision40) / BizType / UserSiteByEndCustomer→clbSalesSite / UserPlantSiteByEndCustomer→clbPlantSite); `DM.DMF0003_GET_BUCKET_TYPE_CODE`(GetBucketType, 첫행 제거→cboBucketType); GetMeasureCountInfo/GetFuturePriceInfo/GetWeekData(PKG_DMF0020)
- **Division 분기**: `(sDivision.Substring(0,2)=="81" || sDivision=="82")`(320) → EndCustomerByDivision+BizType, lblProject/lblPlantSite/layoutControlItem6 Enabled=true; `sDivision=="82"`(339)만 checkInvalidExec.Enabled=true; else(40/기타) → EndCustomer/BizType, Project/PlantSite disable + clear, checkInvalidExec disable. `sDivision.IndexOf("81")!=-1`(385) → PlantSiteByEndCustomer 로드
- **실제 동작 (실측)**:

    ① drpDateTime.InitValue=GetDayRange(6개월)(423) → ② SetChangeControl("MyDivision")→dtDivision→clbDivisions(CODE/NAME) → ③ UserTeamByDivision→clbTeam → ④ Division 분기(320~) 필드 enable/콤보소스 → ⑤ lblBizType.Enabled=true 고정 → ⑥ UserSiteByEndCustomer→clbSalesSite, 81 포함 시 PlantSite → ⑦ dtMeasureCount/dtFuturePrice/dtWeek/dtBucketType 로드 → ⑧ **txtVersion.Text='Current'**(편집 기본 조건)

#### [3] DefineProperty
- **트리거**: Form_Load 내부 호출  ·  **컨트롤/소스**: (속성/권한/코드배선)
- **소스라인**: `436-472`  ·  **호출 메서드**: (siMain.ImagePopUp/cellTypeImage), switch(NowGroupID)
- **데이터/SP**: 없음 (로컬 속성)  ·  **Division 분기**: 없음 (권한 분기)
- **MSG**: 없음
- **실제 동작 (실측)**:

    ① dtStartPeriod/dtEndPeriod 저장, usrConditionPanel2.Height=105, clbDivisions.ControlValues='ALL'
    ② siMain.ImagePopUp=imageList1[0], cellTypeImage(우측 이미지, 대문자 강제) 생성
    ③ **권한 switch(NowGroupID)**: ADMIN / DM ADMIN → layoutControlItem5(**Batch 버튼**) Always, default Never
    ④ **코드 배선**: umltProject.KeyDown / umltModel.KeyDown / clbDivisions.SelectedIndexChanged 핸들러 등록 (최초 로드 이벤트 충돌 회피 — Designer 아님)

### ▣ 조회조건 (cascade)

#### [4] clbDivisions_SelectedIndexChanged  ⭐ 핵심
- **트리거**: Division combo change  ·  **컨트롤/소스**: clbDivisions (UsrCombo; **코드 배선** DefineProperty — Designer 아님)
- **소스라인**: `(코드 wire, DefineProperty)/2465-2601(body)`  ·  **호출 메서드**: SetChangeControl(BigFilter), clsCtrl.setListBox, GetBizTypebyDivision, InitSpread, FP_Log2
- **데이터/SP**: BigFilter `GetDMInnerTable`(UserTeamByDivision / EndCustomerByDivision / BizType(GetBizTypebyDivision=`SCM0001_GET_BIZ_TYPE_BY_DIVISION`) / UserSiteByEndCustomer / UserPlantSiteByEndCustomer)
- **Division 분기**: `(81* || 82)`(2491) → EndCustomerByDivision+BizType, lblProject/layoutControlItem6 enable; `81*`(2508) → PlantSiteByEndCustomer; `82`(2519) → checkInvalidExec.Enabled=true + plantSite disable/clear; else(40/기타) → EndCustomer/BizType, Project/PlantSite disable + clear. `81*`(2579) → Excel/Template 버튼+layoutControlItem12/29 노출 else 숨김
- **실제 동작 (실측)**:

    ① 재진입 가드 `blnWork` return → FP_Log2 start
    ② UserTeamByDivision → clbTeam 재바인딩
    ③ Division 분기(2491~): EndCustomer/BizType 재조회 + 필드 enable/disable + (81)PlantSite / (82)checkInvalidExec
    ④ lblBizType.Enabled=true, UserSiteByEndCustomer → clbSalesSite
    ⑤ txtOwner/umltProject/umltModel clear → **InitSpread(true)**(헤더 재생성)
    ⑥ 81* → Excel/Template 버튼 노출 / else 숨김

#### [5] clbTeam_SelectedIndexChanged
- **트리거**: Team checklist change  ·  **컨트롤/소스**: clbTeam (UsrCheckedList, Designer wire **638**)
- **소스라인**: `638(wire)/3655-3680(body)`  ·  **호출 메서드**: SetChangeControl(EndCustomerByDivision / UserSiteByEndCustomer), clsCtrl.setListBox
- **데이터/SP**: BigFilter EndCustomerByDivision(division,team) / UserSiteByEndCustomer
- **Division 분기**: `(81* || 82)`(3661) vs 기타 — 동일 SP, 분기 형태만
- **실제 동작 (실측)**: ① division 분기별 EndCustomerByDivision(division,team) → clbEndCustomer 재바인딩 → ② UserSiteByEndCustomer → clbSalesSite

#### [6] clbEndCustomer_SelectedIndexChanged
- **트리거**: End Customer checklist change  ·  **컨트롤/소스**: clbEndCustomer (UsrCheckedList, Designer wire **598**)
- **소스라인**: `598(wire)/3539-3545(body)`  ·  **호출 메서드**: SetChangeControl("UserSiteByEndCustomer"), clsCtrl.setListBox
- **실제 동작 (실측)**: ① SetChangeControl("UserSiteByEndCustomer", division,'',endCustomer)(3541) → clbSalesSite 재바인딩 (leaf cascade)

#### [7] cboBucketType_SelectedIndexChanged
- **트리거**: Bucket (Weekly/Monthly) change  ·  **컨트롤/소스**: cboBucketType (UsrCombo; **코드 배선** InitEvent)
- **소스라인**: `(코드 wire)/558-572(body)`  ·  **호출 메서드**: SetSpreadColumn, EditButton
- **데이터/SP**: 없음 (컬럼 재렌더링 전용)
- **실제 동작 (실측)**: ① siMain!=null 확인 → ② `SetSpreadColumn()` W_/M_ 태그 컬럼 Visible 토글(Weekly→W_보임/M_숨김, Monthly 반대) → ③ 편집모드(!IsLock)면 **EditButton() 재호출**로 새 버킷 기준 Lock 재적용

#### [8] cboBucketType_Click
- **트리거**: Bucket combo click  ·  **컨트롤/소스**: cboBucketType (Designer wire **894**)
- **소스라인**: `894(wire)/3817-3827(body)`  ·  **호출 메서드**: siMain.GetText(Action), MessageHelper.GMessageBox
- **MSG**: **MSG00227**("Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.")
- **실제 동작 (실측)**: ① 그리드 행 순회 → action=='I'(신규행) 존재 시 **MSG00227** + return 하여 Bucket 변경 차단

#### [9] usrDiscard_CheckedChanged (Search over range)
- **트리거**: 'Search over range' 체크박스 변경  ·  **컨트롤/소스**: usrDiscard (CheckEdit, Designer wire **906**)
- **소스라인**: `906(wire)/3829-3834(body)`  ·  **호출 메서드**: drpDateTime.Value 세팅
- **실제 동작 (실측)**: ① drpDateTime.Value1=이번주 월요일-7일, Value2=Value1+357일(52주) — 불일치(over range) 조회를 위한 기간 자동 52주 세팅. FindData 에서 p_over_range 로 전달

### ▣ 조회조건 버튼 · 팝업

#### [10] usrButton1_Click (Project 찾기)
- **트리거**: Project '...' 버튼 click / umltProject Enter  ·  **컨트롤/소스**: usrButton1 (Designer wire **373**; umltProject.KeyDown 코드배선 L474-480)
- **소스라인**: `373(wire)/2423-2440(body); KeyDown 474-480`  ·  **호출 메서드**: SCM0002_ProjectbyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: 팝업 `SCM0002_ProjectbyDivisionPopupEx`
- **Division 분기**: `clbDivisions.SelectedValue!="40"` 에서만 동작(2425) — 40 은 Project 미사용(무동작)
- **실제 동작 (실측)**: ① division!='40'(2425): division/team/endCustomer/scmSite/project 수집 → SCM0002_ProjectbyDivisionPopupEx.Form_Load → ShowDialog → ② umltProject.Text=선택 ProjectCode

#### [11] btnModelType_Click (Model 찾기)
- **트리거**: Model '...' 버튼(btnItemId) click / umltModel Enter  ·  **컨트롤/소스**: btnItemId (Designer wire **443**; umltModel.KeyDown 코드배선 L482-488)
- **소스라인**: `443(wire)/2442-2463(body); KeyDown 482-488`  ·  **호출 메서드**: DM0002_ItembyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: 팝업 `DM0002_ItembyDivisionPopupEx`
- **실제 동작 (실측)**: ① division/team/endCustomer/scmSite/project/item 수집 → DM0002_ItembyDivisionPopupEx.Form_Load → ShowDialog → ② umltModel.Text=선택 ItemID

#### [12] btnOwner_Click
- **트리거**: Owner '...' 버튼 click  ·  **컨트롤/소스**: btnOwner (Designer wire **820**)
- **소스라인**: `820(wire)/3771-3790(body)`  ·  **호출 메서드**: DM0020_OwnerbyDivisionPopup.Form_Load, ShowDialog
- **데이터/SP**: 팝업 `DM0020_OwnerbyDivisionPopup`(분석서 `DMF0020_POPUP_Owner`; PKG_DMF0020.GET_OWNER_DATA — 40/82=자기사업부 Owner, 81*=Owner UNION PM_TEAM_MAPPING 부서)
- **실제 동작 (실측)**: ① division/team/endCustomer/scmSite/project/item/owner 수집 → Form_Load → ShowDialog → ② txtOwner.Text=선택 OwnerID

#### [13] btnColumn_Click (Column Setting)
- **트리거**: Column 표시설정 버튼 click  ·  **컨트롤/소스**: btnColumn (Designer wire **857**)
- **소스라인**: `857(wire)/3792-3802(body)`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup, InitSpread
- **데이터/SP**: 팝업 `DM0002_TitleSetForm_Popup`("DMF0020","Sales Price",true,division) → OK 시 InitSpread 재구성
- **Division 분기**: division 파라미터 전달(사업부별 컬럼셋)
- **실제 동작 (실측)**: ① DM0002_TitleSetForm_Popup(true=컬럼 Show/Hide) → ShowDialog → DialogResult.OK 이면 **InitSpread(true)**(헤더 재구성)

#### [14] btnSPVer_Click (Version)
- **트리거**: Version '...' 버튼 click  ·  **컨트롤/소스**: btnSPVer (Designer wire **1014**)
- **소스라인**: `1014(wire)/3895-3922(body)`  ·  **호출 메서드**: DMF0073_VersionBySalesPricePopup.Form_Load, Data.MultiTimeZone
- **데이터/SP**: 팝업 `DMF0073_VersionBySalesPricePopup`(true,'SP',division,-3M~+3M)
- **Division 분기**: division 전달
- **MSG**: **MSG00255**("버전은 최대 2개까지 선택할 수 있습니다." — 2개 초과 선택 시 읽기전용)
- **실제 동작 (실측)**: ① DMF0073_VersionBySalesPricePopup 표출(-3개월~+3개월) → ② 선택 버전 `Split(',').Length>2` → **MSG00255**(3913) + 읽기전용 return → ③ txtVersion.Text=선택 버전 (⚠ 'Current' 외 버전 = isCurVersion=false → Insert/Edit 차단)

### ▣ 화면 전용 버튼 · 팝업 (편집/권한 게이트)

#### [15] btnExchangeRate_Click (Exchange Rate)  ⭐
- **트리거**: Exchange Rate 버튼 click  ·  **컨트롤/소스**: btnExchangeRate (Designer wire **337**)
- **소스라인**: `337(wire)/2395-2421(body)`  ·  **호출 메서드**: DMF0020_SalesFuturePricePopUp.LoadData, GetFuturePriceInfo, FindData
- **데이터/SP**: 팝업 `DMF0020_SalesFuturePricePopUp`(yyyyMM ~ +1년); 저장 SP `PKG_DMF0020.SAVE_DM_MST_EXCHANGE_RATE_ALL`('^' bulk 8컬럼, DELETE-INSERT → DM_MST_EXCHANGE_RATE); OK 후 GetFuturePriceInfo 재로드
- **Division 분기**: 없음
- **MSG**: **MSG00142**("환율 정보가 잠겨있어 변경할 수 없습니다." — 읽기모드 차단)
- **실제 동작 (실측)**: ① `!IsLock`(편집모드) 아니면 **MSG00142**(2404) return → ② DMF0020_SalesFuturePricePopUp 표출 → ③ OK 면 dtFuturePrice 재로드 + **FindData(true)** 재조회
- **TO-BE 대응**: `components/modals/ExchangeRateModal.tsx` (No. 코너 헤더 = hook #108 정본; `salesPriceExchange.ts` 환율 환산 유틸)

#### [16] btnSavePricePeriod_Click (Price 일괄입력)  ⭐
- **트리거**: Price일괄입력 버튼 click  ·  **컨트롤/소스**: btnSavePricePeriod (Designer wire **944**)
- **소스라인**: `944(wire)/2360-2393(body)`  ·  **호출 메서드**: DMF0020_SaveSalesFuturePrice_Popup.LoadData
- **데이터/SP**: 팝업 `DMF0020_SaveSalesFuturePrice_Popup`(division/기간/scmSite/project/endCustomer); 저장 SP `DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP`(Project/Item/Site-Item 유효성 e_invalid_data 하드검증, 통화 LOC/KRW/USD split insert)
- **Division 분기**: endCustomer=CString.GetCheckedListValue 전달; SP 내부 40 외 PROJECT 필수·81/40 Site-Item 검증
- **MSG**: **MSG00408**("Price 일괄 입력 조건이 충족되지 않았습니다." — 읽기모드 차단)
- **실제 동작 (실측)**: ① `!IsLock`(편집모드) 아니면 **MSG00408**(2369) return → ② DMF0020_SaveSalesFuturePrice_Popup.LoadData 표출
- **TO-BE 대응**: `components/modals/PriceBatchInputModal.tsx` + Range 초과 시 `SalesPriceRangeModal`

#### [17] btnBatch_Click (Batch Job)
- **트리거**: Batch Job 버튼 click (ADMIN/DM ADMIN 권한만 노출)  ·  **컨트롤/소스**: btnBatch (Designer wire **300**, 기본 Visible=false; DefineProperty 권한 시 layoutControlItem5 Always)
- **소스라인**: `300(wire)/3458-3494(body)`  ·  **호출 메서드**: FoxAsyncProxy.ExecuteAsync
- **데이터/SP**: `DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW`(division,createdBy, Timeout 3분)
- **Division 분기**: division 'ALL' 이면 실제코드 치환, ','→'^' 다중전달
- **MSG**: **MSG00143**(일괄 처리 결과 통보 — AS-IS 문구, MSG_M 미등재)
- **실제 동작 (실측)**: ① division ALL 치환+'^' 조립 → ② async PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 실행 → ③ 결과 취합 → **MSG00143**(division, 결과메시지)

#### [18] btnExcelUpload_Click (Upload)
- **트리거**: Upload 버튼 click (81 사업부만 노출)  ·  **컨트롤/소스**: btnExcelUpload (Designer wire **1057**)
- **소스라인**: `1057(wire)/3935-3947(body)`  ·  **호출 메서드**: ExcelUploadForm
- **데이터/SP**: `ExcelUploadForm`("DMF0020", sheetName, SaveExceptError=true) → `P_DMF0020_EXCEL_UPLOAD`(PKG)
- **Division 분기**: 81 자동차 전용
- **MSG**: **MSG00265**("Excel 업로드가 완료되었습니다. 재조회합니다.")
- **실제 동작 (실측)**: ① ExcelUploadForm(오류제외 저장) 표출 → ② MSG00265 Yes → **FindData(true)** 재조회

#### [19] btnTemplate_Click (Excel Form)
- **트리거**: Excel Form 버튼 click (81 사업부만 노출)  ·  **컨트롤/소스**: btnTemplate (Designer wire **1098**)
- **소스라인**: `1098(wire)/3924-3933(body)`  ·  **호출 메서드**: DMF0020_SalesPriceTemplatePopup
- **데이터/SP**: 팝업 `DMF0020_SalesPriceTemplatePopup`(division; PKG_DMF0020.GET_SALES_PRICE_TEMPLATE — FN_GET_DIVISION_YN 동적컬럼 VISIBLE_FLAG)
- **Division 분기**: 81 자동차 전용
- **실제 동작 (실측)**: ① DMF0020_SalesPriceTemplatePopup(division) 표출 (템플릿+데이터 다운로드)

### ▣ 그리드 편집 · 환율 배분

#### [20] Dsdm_Changed  ⭐ 핵심(환율 자동환산)
- **트리거**: Grid cell value changed  ·  **컨트롤/소스**: spdMain DefaultSheetDataModel.Changed (**코드 배선** InitEvent)
- **소스라인**: `(코드 wire)/2973-3103(body)`  ·  **호출 메서드**: siMain.IsLock/IsLockCell, GetCellIndexBySpanRowCells, GetExchangeRate, SetExchangeValues, Data.Common(SalesPlant), SetCellTypeCombo, CUIControl.SetActionFlagEx
- **데이터/SP**: 없음(로컬 환율 환산) — 환율원천 dtFuturePrice(GetFuturePriceInfo EXCHANGE_PRICE)
- **Division 분기**: `81*`(3080/3089) → PROJECT_CODE/ITEM_ID 변경 시 PlantSite(SalesPlant) 동적 콤보
- **실제 동작 (실측)**:

    ① 재진입 가드: `IsLock`(조회모드) return, `e.Row<0||e.Col<0`(2992) return, `IsLockCell` return
    ② CellsUpdated & Measure 우측(가격) 컬럼: 대표행 Currency 공란(3008)→값 clear; 값 입력 시 **ForeColor=Red 마킹** + **4행 GetExchangeRate 환율계산**(LOC 기준 KRW/USD, RTF_SYS_RP 제외) + `SetActionFlagEx 'M'`
    ③ **M_ 월합계 입력** → 같은 월 주차(W_) 컬럼에 `SetExchangeValues` 분배
    ④ 81* & PROJECT_CODE/ITEM_ID 변경(3080/3089) → PlantSite 콤보 재세팅
- **TO-BE 대응**: 가격셀 편집 시 measure별 환율 자동계산(LOC 기준)+월합계→주차 분배+빨강마킹+action 'M' (hook #59 cascade / `salesPriceExchange.ts`)

#### [21] spdMain_ComboSelChange  ⭐
- **트리거**: In-grid combo cell selection change  ·  **컨트롤/소스**: spdMain.ComboSelChange (Designer wire **164**)
- **소스라인**: `164(wire)/2603-2904(body)`  ·  **호출 메서드**: Data.UserTeamByDivision, Data.UserEndCustomerByDivisionDeptAuth, Data.Common(EndCustomerByDivision40/CELL_PROD_SITE_ID), Data.UserSiteByEndCustomerAuth, SetCellTypeCombo, CUIControl.SetCellRangeAligement, GetExchangeRate, SetExchangeValues
- **데이터/SP**: 콤보 UserTeamByDivision / (81/82)UserEndCustomerByDivisionDeptAuth·(40)EndCustomerByDivision40 / UserSiteByEndCustomerAuth / PlantSite; 환율 GetExchangeRate
- **Division 분기**: 그리드 셀 DIVISION 값 기준 `81/82`(Auth 콤보) vs `40`(Common EndCustomer40); 81 아니면 PlantSite Lock
- **실제 동작 (실측)** (셀별 cascade):

    ① `!IsLock`(편집모드)에서만 동작
    ② **DIVISION_ID 변경** → DEPT_ID(UserTeamByDivision)/END_CUSTOMER(81·82 Auth)|END_CUSTOMER40(40 Common)/SCM_SITE_ID(UserSiteByEndCustomerAuth)/PLANT_SITE 콤보 재세팅+SetCellRangeAligement, 81 아니면 PlantSite Lock, 하위 셀 clear
    ③ **DEPT_ID 변경** → EndCustomer/SalesSite 재세팅+하위 clear
    ④ **END_CUSTOMER 변경** → SalesSite 재세팅+하위 clear
    ⑤ **SCM_SITE_ID 변경** → Project/Item 하위 clear
    ⑥ **END_CUSTOMER40 변경** → SalesSite 재세팅
    ⑦ INCOTERMS/FcstType/DomExp/CURRENCY **빈값** → sTempRow(대표행) 값으로 auto-sync
    ⑧ **CURRENCY 변경(action!='I')** → 4배수 행 전체 Currency 재세팅+빨강, 과거주차 이후 컬럼 GetExchangeRate 재계산, M_ 월합계면 하위 주차 SetExchangeValues
- **TO-BE 대응**: 그리드 셀 cascade(beginningEdit dataMap 스왑 + **cellEditEnded 원복 필수**, hook #59). currency 변경 시 환율 재계산 자동동기

#### [22] spdMain_CellClick
- **트리거**: Grid cell click  ·  **컨트롤/소스**: spdMain.CellClick (Designer wire **162**)
- **소스라인**: `162(wire)/3684-3751(body)`  ·  **호출 메서드**: Raw_CellClick, Data.Common(PlantSiteByItem), GetLookupValues, SetRowSpanFucTwo
- **데이터/SP**: PlantSiteByItem(81) / INCOTERMS=GetLookupValues('INCOTERMS','ALL','Y') 유효코드
- **Division 분기**: `81`(3707) → PlantSite 콤보 갱신; `82`(3727/3731/3735/3743) → INCOTERMS/FcstType/DomExp/CURRENCY 4행 세로병합(SetRowSpanFucTwo)
- **MSG**: **MSG00447**("Currency 가 비어 있습니다." — CURRENCY 셀 & action!='I' 경고)
- **실제 동작 (실측)**: ① CURRENCY 셀 & 기존행(action!='I')(3690) → **MSG00447** → ② !IsLock & (PLANT_SITE 셀 or 81) → PlantSiteByItem 콤보 → ③ INCOTERMS 유효코드 콤보 + sTempRow 저장 → ④ 82 & 대표속성 셀 → SetRowSpanFucTwo(4행 세로병합)

#### [23] spdMain_CellDoubleClick
- **트리거**: Grid cell / column-header double click  ·  **컨트롤/소스**: spdMain.CellDoubleClick (Designer wire **163**)
- **소스라인**: `163(wire)/3211-3345(body)`  ·  **호출 메서드**: SCM0002_ProjectbyDivisionPopupEx, DM0002_ItembyDivisionPopupEx, SetTextCellsToRowSpanRange
- **데이터/SP**: 팝업 ProjectbyDivision / ItembyDivision (조회 전용)
- **Division 분기**: `40`(3237) → EndCustomer40 사용; 기타 → Project/EndCustomer
- **실제 동작 (실측)**:

    ① **데이터 셀** & !IsLock & **action=='I'(신규행)만**: Project/ProjectName 셀 → SCM0002_ProjectbyDivisionPopupEx → ProjectCode/Name/Status/BizType 세팅+하위 clear; Item 셀 → DM0002_ItembyDivisionPopupEx → ItemID/Class/Name+currency(4행 sync)
    ② **컬럼 헤더 더블클릭**(3213 e.ColumnHeader): M_ 헤더 → 해당 월 W_ 컬럼 visible 토글(확장/축소), W_ 헤더 → D_ 컬럼 토글

#### [24] spdMain_TopChange
- **트리거**: Grid vertical scroll (top row change)  ·  **컨트롤/소스**: spdMain.TopChange (Designer wire **165**)
- **소스라인**: `165(wire)/3347-3352(body)`  ·  **호출 메서드**: SmartColMerge
- **실제 동작 (실측)**: ① CanModelChange=false → `SmartColMerge()` 뷰포트 좌측 키컬럼 세로 병합 재계산 → CanModelChange=true (스크롤 시 병합 셀 깨짐 방지)
- **TO-BE 대응**: 세로 merge viewport sticky 재계산(hook #38)

#### [25] spdMain_KeyUp
- **트리거**: Key up in grid (Ctrl+C / Ctrl+V)  ·  **컨트롤/소스**: spdMain.KeyUp (Designer wire **166**)
- **소스라인**: `166(wire)/3753-3769(body)`  ·  **호출 메서드**: ClipboardPaste/ClipboardCopy(AsStringSkipHidden), Clipboard.Clear
- **실제 동작 (실측)**: ① Measure 좌측(키 영역) return(3755) → ② `V` → ClipboardPaste(AsStringSkipHidden, 숨김열 제외) → ③ `C` → Clipboard.Clear + ClipboardCopy(AsStringSkipHidden)

### ▣ CRUD 버튼 (BaseForm override)

#### [26] FindButton (override) → FindData  ⭐
- **트리거**: Find/Retrieve toolbar 버튼 / F5  ·  **컨트롤/소스**: Common toolbar (BaseForm hotkey)
- **소스라인**: `831-834(override) / FindData 1270-1536 (async) / Draw`  ·  **호출 메서드**: FindData(true), FoxDataClient.ExecuteDataSet('DM.DMF0020_GET_SCM_MST_FUTURE_PRICE'), InitSpread, SearchStartTime, SetSpreadColumn, GetFuturePriceInfo, SmartColMerge
- **데이터/SP**: SP `DM.DMF0020_GET_SCM_MST_FUTURE_PRICE`(L1349, Timeout 10분, 이중 OUT 커서 O_RC1 타이틀/O_RESULT_CURSOR 본문) + 동적헤더 GET_SPREAD_TITLE/GET_SPREAD_TITLE_DATE
- **Division 분기**: p_division_id = clbDivisions (40/81/82 그대로 전달, SP 내부 분기)
- **MSG**: MSG00137, MSG00283, MSG00108, MSG00097
- **실제 동작 (실측)**:

    ① 재진입 `blnWork`→**MSG00137**(1279) return; `txtVersion.Trim()==""`→**MSG00283**("버전을 선택하세요." 1286) return
    ② `isCurVersion=false`(1294) 초기화; 기간/over_range(usrDiscard)/invalid_exec(checkInvalidExec) Flag 산출; `sPeriod[0]>sPeriod[1]`→**MSG00108**(1307) return
    ③ 조건 수집(division/scm_site/plant_site/project/item/dept/end_customer/biztype/owner/version_type); `p_division_id==""`→**MSG00097**(1327) return
    ④ InitSpread(false) 헤더 재구성 → SearchStartTime() → **async ExecuteDataSet**(1349)
    ⑤ Tables[0] 0행이면 return(1380); 결과 정렬(Measure 좌측 ASC) → siMain.Query(ds) → **LockColumn 전체잠금**
    ⑥ Draw: SetSpreadColumn, 과거주차 Gainsboro/당월 White 배경(iResultCol/iResultMonth), ColList 토큰 Pink(범위초과), Project/Item 셀 이미지
    ⑦ **txtVersion=='Current' → isCurVersion=true**(1452, Insert/Edit 허용 조건) → SmartColMerge, dtFuturePrice 재로드, blnWork=false

#### [27] InsertButton (override) → InsertRow
- **트리거**: Insert toolbar 버튼 / F8  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `836-844(override, isCurVersion gate 839) / InsertRow 1983-2211`  ·  **호출 메서드**: GetCellNumbersByRow, Insert2, Data.UserTeamByDivisionAuth, Data.UserSiteByEndCustomer(Auth), Data.UserEndCustomerByDivisionDeptAuth, GetCustomsHandbook, GetLookupValues, SetCellTypeCombo, CUIControl.SetRowSpanFuc
- **데이터/SP**: 콤보 UserTeamByDivisionAuth / UserSiteByEndCustomerAuth / UserEndCustomerByDivisionDeptAuth / CustomsHandbook(40) / INCOTERMS=GetLookupValues('INCOTERMS','ALL','Y') / dtMeasureCount(4행)
- **Division 분기**: `40` → EndCustomer40/CustomsHandbook 콤보; `81` → PlantSite 편집; `82` → Auth 콤보 동일
- **실제 동작 (실측)**:

    ① **`!isCurVersion` return**(839, Current 조회만 신규 허용), HaltAutoFilter=true
    ② 활성행 기준 dtMeasureCount.Rows.Count(**4행: LOC/USD/KRW/RTF**) 만큼 Insert2
    ③ Division별 콤보 세팅(40=CustomsHandbook·UserSiteByEndCustomer / else=Auth 계열); DIVISION_ID 세팅+Lock
    ④ **MEASURE=LOOKUP_CODE** 세팅; LOC 아닌 행은 Measure+1~끝 Lock, LOC 행은 과거주차 Lock, PRICE_EXIST Lock
    ⑤ SetRowSpanFuc 로 좌측 정보열 **4행 병합**, ManualAutoFilter, IsChange=true

#### [28] DeleteButton (override)
- **트리거**: Delete toolbar 버튼 / F9  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `846-859(body)`  ·  **호출 메서드**: GetCellNumbersByRow, siMain.Delete
- **실제 동작 (실측)**: ① 활성행 Action 컬럼이 'I'(신규)가 아니면 return (**신규행만 삭제**) → ② GetCellNumbersByRow 로 **4배수 행 묶음**(measure 4행) 획득 후 역순 SetActiveCell+Delete. (기존 DB행 삭제는 SAVE 시 LOC price=0→ACTIVE_FLAG='D' 경로)

#### [29] EditButton (override)  ⭐ 편집 게이트
- **트리거**: Edit toolbar 버튼 / F2 (Bucket 변경 시에도 호출)  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `861-1222`  ·  **호출 메서드**: GetLookupValues(DM_UI_EDITABLE_DIVISION), siMain.GetColumnIndex(필수컬럼), siMain.SwitchLock/LockColumn2/LockRange2/SetBGColor2, MessageHelper.GMessageBox
- **데이터/SP**: `DM_UI_EDITABLE_DIVISION`("DMF0020",division) 편집위임 lookup; dsMain AUTHORITY_YN 행권한
- **Division 분기**: ★**40=편집금지**(EDIT_YN='N'→MSG00448, DMF0082 로 위임); 필수컬럼 셋 40(END_CUSTOMER40+…)/81(+PROJECT+PLANT_SITE)/82(PROJECT, plantsite 제외) 상이; `82&NewFlag='Y'` 행별 세부 Lock; LOC 만 CURRENCY 편집
- **MSG**: MSG00448, MSG00113, MSG00412
- **실제 동작 (실측)**:

    ① `!isCurVersion` return(864); fps!=null 확인(866)
    ② `GetLookupValues("DM_UI_EDITABLE_DIVISION","DMF0020",division)` EDIT_YN=='N'(870-874) → **MSG00448**(876) return (★40 편집금지)
    ③ **division별 필수 컬럼 존재 검증**: 40(881: END_CUSTOMER40/SCM_SITE/ITEM/INCOTERMS/FCST/DOM_EXP/CURRENCY) / 81*(911: SCM_SITE/PROJECT/ITEM/INCOTERMS/FCST/DOM_EXP/CURRENCY/PLANT_SITE) / 82(927: PLANT_SITE 제외) 결손 → **MSG00113** return
    ④ PRICE_EXIST 컬럼 결손(945) → **MSG00412**(952) return
    ⑤ siMain.SwitchLock()(960); DateTime 이번주 월요일(964) 기준 과거 W_/M_ 컬럼 LockColumn2
    ⑥ 행별 Lock: `82 & NewFlag='Y'` → 좌측 정보열 각각 Lock; else 전체 좌측 Lock. AUTHORITY_YN!='Y' 행은 데이터영역 Lock, action=='I' 편집행은 W_ 만 unlock
    ⑦ Measure=KRW/USD/RTF 행은 값 전체 Lock, **LOC 행만 CURRENCY unlock**+MergePolicy None
    ⑧ 과거주차 Gainsboro/당월 White 배경

#### [30] SaveButton (override) → SaveData  ⭐
- **트리거**: Save toolbar 버튼 / F7  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `1224-1228(override) / SaveData 1538-1970 (async); fnValidation`  ·  **호출 메서드**: fnValidation, GetCellNumbersByRow, GetCellIndexBySpanRowCells, CString.AppendStringEx, FoxDataClient.ExecuteDataSet('DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL'), FindData, DMF0020_SalesPriceRangePopUp
- **데이터/SP**: SP `DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL`(L1902, Timeout 90분, '^' bulk 16컬럼, DELETE-INSERT + _H 이력); Range 초과 팝업 `DMF0020_SalesPriceRangePopUp`
- **Division 분기**: 키 구성 40=END_CUSTOMER40 / 81=PROJECT_CODE+PLANT_SITE / 82=PROJECT_CODE(plantsite 없음). RTF/RTF_SYS_RP measure 저장 제외
- **MSG**: MSG00137, MSG00002, MSG00043, MSG00414, MSG00004
- **실제 동작 (실측)**:

    ① 재진입 `blnWork`→**MSG00137**(1551) return; **!IsLock(편집모드) 일 때만** 진행
    ② 필수 검증 루프(4배수 행): action=='I'(+NewFlag='Y'→'I') 행의 Division/Project(40=EndCustomer40, 81/82=ProjectCode)/SalesSite/(81)PlantSite/Model/Currency/Measure/DomExp/FcstType/Incoterms 공란 → **MSG00002 {필드명}**(1679) + 셀 포커스 return
    ③ `fnValidation()` 중복(동일 키 2건 이상, iValidation>1 L2333) → **MSG00043**(1703)
    ④ payload 조립: **변경(빨강 ForeColor) 셀만**, M_ 컬럼 제외 W_ 날짜별, LOC&price=0→action 'D'. iCUD 인덱스로 CString.AppendStringEx '^' 누적
    ⑤ p_PRICE 없으면 **MSG00414**(1890, 40 Project 관련 통보) return
    ⑥ **async ExecuteDataSet**(1902): Tables[0][0]!='success'→에러박스(1924/1929); Tables[3] 메시지 표출
    ⑦ **MSG00004**(1933, 저장건수); Tables[2](가격편차 Range 초과) 있으면 **DMF0020_SalesPriceRangePopUp** 표출
    ⑧ blnInsert면 FindData(true) else FindData(false, updateRow, col) 재조회
    · 참고: SP 내부(SAVE_ALL 1,028줄)가 LOC 기준 ACTIVE_FLAG 재설정·DELETE-INSERT·_H 이력·가격편차(SALES_PRICE_RANGE_RATE) 검증(O_RC1 경고, 저장은 막지 않음) 수행. ⚠ **저장확인 MSG 없음** — 즉시 저장.

#### [31] ExcelButton (override)
- **트리거**: Excel toolbar 버튼 / F12  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `1231-1263`  ·  **호출 메서드**: SimplexelService.ExportFpSpread, MessageService.CloseProgress
- **데이터/SP**: 없음 (로컬 Export)
- **실제 동작 (실측)**: ① SimpleExcelExportOption(Merge None/Border All/ShowZero/소수3자리) → ② `SimplexelService.ExportFpSpread(fps)` 파일 저장 → ③ finally MessageService.CloseProgress()

### ▣ 기타

#### [32] DMF0020_SalesFuturePrice_Resize
- **트리거**: Form resize  ·  **컨트롤/소스**: this.Resize (Designer wire **1487**)
- **소스라인**: `1487(wire)/3530-3537(body)`  ·  **실제 동작 (실측)**: ① panel1(progress) 보이면 화면 중앙 재배치. TO-BE = 진행 패널 중앙 정렬(ResizeObserver)

---

## 2. 버튼 인벤토리 (16) — AS-IS 실측

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/권한 · Division | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find/Retrieve (common) | toolbar | FindData(true): 검증 + async 조회 + Draw | DM.DMF0020_GET_SCM_MST_FUTURE_PRICE (+GET_SPREAD_TITLE/_DATE) | MSG00137/00283/00108/00097 | Always; division 전달, Current 조회만 isCurVersion=true | 831-834 / 1270-1536 |
| 2 | Insert (common) | toolbar | InsertRow(): 신규 measure 4행(LOC/USD/KRW/RTF) | (콤보 룩업) | — | **isCurVersion 필수**; 40=EndCustomer40/CustomsHandbook, 81/82=Auth+PlantSite | 836-844 / 1983-2211 |
| 3 | Delete (common) | toolbar | Action=='I' 행(4행 묶음)만 즉시 삭제 | — | — | Edit 모드 | 846-859 |
| 4 | Edit (common) | toolbar | 필수컬럼 검증 + 버킷별 Unlock + 권한/과거주차/82 분기 | DM_UI_EDITABLE_DIVISION lookup | MSG00448/00113/00412 | isCurVersion 필수; **★40 편집금지**(DMF0082 위임), 82&NewFlag 세부 lock, LOC만 currency | 861-1222 |
| 5 | Save (common) | toolbar | SaveData(): 필수·중복 검증 → '^' 16 bulk 저장 | DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (90분) | MSG00137/00002/00043/00414/00004 | Edit 모드; async; **확인창 없음**; 40=EC40/81=Project+Plant/82=Project 키 | 1224-1228 / 1538-1970 |
| 6 | Excel (common) | toolbar | SimplexelService.ExportFpSpread | (로컬 export) | — | Always | 1231-1263 |
| 7 | Exchange Rate | 화면버튼 btnExchangeRate | 환율 팝업 → 저장 후 재조회 | DMF0020_SalesFuturePricePopUp / PKG_DMF0020.SAVE_DM_MST_EXCHANGE_RATE_ALL | MSG00142 | 편집모드(!IsLock) 아니면 차단 | 337(wire)/2395-2421 |
| 8 | Price 일괄입력 (btnSavePricePeriod) | 화면버튼 | 일괄입력 팝업 | DMF0020_SaveSalesFuturePrice_Popup / SAVE_..._POPUP | MSG00408 | 편집모드 아니면 차단; division/기간/site/project/endCustomer 전달 | 944(wire)/2360-2393 |
| 9 | Version (btnSPVer) | 화면버튼 | 버전 선택 → txtVersion | DMF0073_VersionBySalesPricePopup | MSG00255 | Always; 2개 초과선택=읽기전용; -3M~+3M | 1014(wire)/3895-3922 |
| 10 | Owner (btnOwner) | 화면버튼 | Owner 팝업 → txtOwner | DM0020_OwnerbyDivisionPopup | — | Always | 820(wire)/3771-3790 |
| 11 | Column Setting (btnColumn) | 화면버튼 | 컬럼 Show/Hide 팝업(true); OK→InitSpread | DM0002_TitleSetForm_Popup("DMF0020",true) | — | Always; division 전달 | 857(wire)/3792-3802 |
| 12 | Project 찾기 (usrButton1) | 조회조건 | Project 팝업 → umltProject (**div!=40**) | SCM0002_ProjectbyDivisionPopupEx | — | 40 미동작 | 373(wire)/2423-2440 |
| 13 | Model 찾기 (btnItemId) | 조회조건 | Item 팝업 → umltModel | DM0002_ItembyDivisionPopupEx | — | Always | 443(wire)/2442-2463 |
| 14 | Batch Job (btnBatch) | 화면버튼(기본 Visible=false) | Local KRW 매출계획 생성 SP | DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | MSG00143 | **ADMIN/DM ADMIN** 만 layoutControlItem5 노출; division '^' 다중 | 300(wire)/3458-3494 |
| 15 | Upload (btnExcelUpload) | 화면버튼 | Excel 업로드(오류제외) → 재조회 | ExcelUploadForm / P_DMF0020_EXCEL_UPLOAD | MSG00265 | **81 사업부만 노출** | 1057(wire)/3935-3947 |
| 16 | Excel Form (btnTemplate) | 화면버튼 | Excel 템플릿 다운로드 팝업 | DMF0020_SalesPriceTemplatePopup | — | **81 사업부만 노출** | 1098(wire)/3924-3933 |

> ※ 우클릭 컨텍스트 메뉴 없음. Project/Item 선택 = 조회조건 버튼[12][13] + 그리드 셀 더블클릭[23]. Version·Exchange Rate·Price 일괄입력은 **DMF0020 전용**(DMF0021 에 없음).

---

## 3. 조회조건 컨트롤 (14) — AS-IS 실측

| # | 컨트롤 | 라벨 | 유형 | 데이터 원천 / 기본값 | Division 분기 | Cascade | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | clbDivisions | Division | **combo (UsrCombo single)** | MyDivision(BigFilter) [CODE/NAME] | **핵심 트리거** 81*/82 vs 40/기타 주도 | SIC(코드배선)→Team/EC/BizType/Site/Plant 전 cascade + 필드 enable + Excel버튼 + InitSpread | D.718-750; body 2465-2601 |
| 2 | clbTeam | Team | checkbox-list (One,ALL_VIEW) | UserTeamByDivision | — | SIC(D.638)→EndCustomer→SalesSite | D.600-638; body 3655-3680 |
| 3 | clbEndCustomer | End Customer | checkbox-list (One,ALL_VIEW) | EndCustomerByDivision (81/82 Auth, 40 Common=EndCustomerByDivision40) | 81/82 vs 40 SP 소스 상이 | SIC(D.598)→SalesSite | D.560-598; body 3539-3545 |
| 4 | clbSalesSite | Sales Site | checkbox-list (One,ALL_VIEW,RvSearch) | UserSiteByEndCustomer(div,'',endCustomer) | — | leaf | D.487-524 |
| 5 | clbPlantSite | Plant Site | checkbox-list (One,ALL_VIEW) | UserPlantSiteByEndCustomer | 81 포함시만 enable/세팅; 82 disable+clear; 40/기타 disable | division/endCustomer 종속 | D.640-677 |
| 6 | clbBizType | Biz Type | checkbox-list (One,ALL_VIEW) | GetBizTypebyDivision(SCM0001_GET_BIZ_TYPE_BY_DIVISION) | lblBizType 항상 Enabled=true | division 종속 | D.679-716 |
| 7 | cboBucketType | Bucket | combo (Weekly/Monthly) | GetBucketType(DMF0003_GET_BUCKET_TYPE_CODE, 첫행제거) | — | SIC→W_/M_ visible 스왑+편집유지(코드wire); Click(D.894)→신규행시 MSG00227 | D.859-894; body 558-572 / 3817-3827 |
| 8 | drpDateTime | Period | date range (From:To) | GetDayRange(PR_GET_DAY_RANGE, p_month=6) | — | FindData 검증(from≤to MSG00108); over range 체크시 자동 52주 | D.445-485; body 295-297,417-431 |
| 9 | umltProject (+usrButton1) | Project | multiline + modal | SCM0002_ProjectbyDivisionPopupEx | 40 disable/미동작 | Enter→팝업(코드wire 474) | D.375-407; btn D.373 |
| 10 | umltModel (+btnItemId) | Model/Nickname | multiline + modal | DM0002_ItembyDivisionPopupEx | — | Enter→팝업(코드wire 482) | D.526-558; btn D.443 |
| 11 | txtOwner (+btnOwner) | Owner | multiline + modal | DM0020_OwnerbyDivisionPopup | — | btnOwner 팝업 | D.752-820 |
| 12 | txtVersion (+btnSPVer) | Version | multiline(읽기) + modal | DMF0073_VersionBySalesPricePopup; **기본 'Current'** | division 전달 | 팝업 선택; **'Current' 여부가 isCurVersion(편집게이트)** | D.946-1014; body 3895-3922 |
| 13 | usrDiscard | Search over range | CheckEdit | 로컬 (p_over_range Y/N) | — | 체크시 기간 이번주월요일-7 ~ +357일 | D.896-906; body 3829-3834 |
| 14 | checkInvalidExec | Price 미등록 제외 | CheckEdit (layoutControlItem10 기본 Never) | 로컬 (p_invalid_exec Y/N) | ★**division=='82' 일 때만 Enabled=true**, 그외 disable | — | D.253-262,1361-1369; body 339-346,2519-2527 |

> 그리드 `spdMain`(FpSpread, 시트 "Sales Price"(shtMain), 3단 헤더 대분류(SUM/KRW/USD/LOC)/년월/주·일). 배선 이벤트 5종(CellClick D.162/CellDoubleClick D.163/ComboSelChange D.164/TopChange D.165/KeyUp D.166) + DefaultSheetDataModel.Changed(코드배선). 좌측 정보열 = measure **4행 세로 병합**(LOC/USD/KRW/RTF), Measure 우측 Freeze.

---

## 4. ② User 관점 변환 요지 (시트 5 반영용)

> 개발 세부(메서드명·변수·라인·주석블록)를 제거하고, **업무 규칙 + MSG 의미**만 남긴 요지. UI분석서 시트5 "상세동작(User)" 에 반영.

### 4.1 화면 성격
- **판가(Sales Future Price)** 화면. **사업부(Division) 3종**(소형 40 / 자동차 81* / ESS·파워툴 82)을 한 화면에서 다룬다. 사업부를 바꾸면 그 아래 팀·고객·사이트·사업유형·플랜트 목록이 모두 다시 채워지고, 소형(40)은 Project·Plant Site 를 쓰지 않아 비활성되며, ESS(82)에서만 'Price 미등록 제외' 옵션이 켜진다. 자동차(81)에서만 Excel 업로드/템플릿 버튼이 보인다.
- 좌측 한 품목은 **통화·메저 4줄(LOC/USD/KRW/RTF)** 이 세로로 묶여 있고, 오른쪽은 주(Week)/월(Month) 단위 가격이다. **LOC 가격을 입력하면 KRW/USD 는 환율로 자동 환산**된다.

### 4.2 조회
- **버전(Version)과 Division 은 필수**. 버전을 안 고르면 "버전을 선택하세요"(MSG00283), Division 을 안 고르면 "Division 을 선택하세요"(MSG00097). 조회 기간 시작일이 종료일보다 늦으면 "기간이 잘못되었습니다"(MSG00108). 이전 조회가 진행 중이면 "이전 작업이 실행 중"(MSG00137).
- Team → End Customer → Sales Site 가 위에서 아래로 연동된다. Project/Model/Owner 는 검색 버튼(또는 Enter)으로 팝업에서 고른다(Project 는 40 제외).
- **버전을 'Current'(현재)로 조회했을 때만 수정·추가가 가능**하다. 과거/특정 버전을 고르면 화면은 읽기 전용이다. 'Search over range' 를 켜면 조회 기간이 자동으로 1년(52주)으로 늘어난다.

### 4.3 편집·가격 입력
- 수정하려면 Edit 로 전환. **소형(40) 사업부는 이 화면에서 편집할 수 없고**(MSG00448) — 판가 편집은 FcstNPrice(DMF0082) 화면에서 한다. 필수 항목(사업부별로 고객/사이트/모델/인코텀즈/예측유형/통관/통화, 자동차는 플랜트 추가)이 화면에 없으면 편집 불가(MSG00113), Price Exist 정보가 없으면 편집 불가(MSG00412).
  > ⭐ TO-BE 현행 업무규칙: **82(파워툴)만 편집 가능**, **40·81·81_계열(81_HD/HG/HM/ST/UC)·EE계열은 전체 편집 불가**(2026-07-14 사용자 재확인 — AS-IS 는 81 도 편집 가능이었으나 의도적으로 좁힘, `DM_EDITABLE_DIVISION_ALLOW` 룩업 구동).
- 편집 가능한 구간은 **이번 주/당월 이후**. 지난 주차는 회색으로 잠긴다. **LOC(현지통화) 가격만 직접 입력**하고 KRW/USD/RTF 값은 잠긴 채 환율로 자동 계산된다. 값을 넣으면 그 셀은 빨간색으로 표시되고, 월 합계에 넣은 값은 그 달의 주차로 자동 분배된다. LOC 행에서만 통화(Currency)를 바꿀 수 있다.
- 편집 중 신규 추가행이 있으면 Bucket(주/월)을 바꿀 수 없다(MSG00227). 기존 행의 통화 칸을 빈 상태로 클릭하면 "Currency 가 비어 있습니다"(MSG00447).

### 4.4 신규 추가
- 'Current' 조회 상태에서만 행을 추가할 수 있다. 새로 추가하면 **한 품목당 4줄(LOC/USD/KRW/RTF)** 이 함께 생기고, 사업부별로 팀·고객·사이트·모델·통화·통관을 목록에서 고른다. Project·Model 칸은 셀 더블클릭으로 팝업 선택한다. 방금 추가한 새 행만 Delete 로 즉시 지울 수 있다.

### 4.5 저장·삭제
- 저장은 **확인창 없이 즉시** 진행. 필수 항목이 비면 항목명으로 "필수 입력"(MSG00002), 같은 키가 중복이면 "저장 시 중복 오류"(MSG00043). 성공하면 저장 건수를 알리고(MSG00004) 목록을 다시 불러온다. 저장한 가격이 기존 대비 **허용 편차율을 넘으면** 초과 목록 팝업(Sales Price Range)이 뜬다(저장은 막지 않고 경고).
- 이미 저장된 행의 가격 제거는 **LOC 값을 0으로 저장**하는 방식(서버가 삭제 처리)으로 이루어진다.

### 4.6 보조 기능
- **환율(Exchange Rate)**: 편집 모드에서만 열리며(읽기모드=MSG00142), 통화별 환율을 일괄 저장하면 화면 가격이 재계산된다.
- **Price 일괄입력**: 편집 모드에서만(MSG00408), 기간·사이트·프로젝트·고객 범위로 가격을 한 번에 채운다(존재하지 않는 프로젝트/품목은 저장 거부).
- **Column Setting**: 화면에 보일 컬럼을 사업부별로 고른다. **셀 더블클릭**: 월/주 헤더를 더블클릭하면 하위(주/일) 컬럼이 접히거나 펼쳐진다.
- **Batch Job**(관리자 전용): Local KRW 매출계획을 재생성한다. **Upload / Excel Form**(자동차 전용): 엑셀로 가격을 올리거나 템플릿을 내려받는다.

---

## 부록 A. SP 제약 (소스 유래 전수 41행)

> ⚠ 본 부록은 UI분석서 xlsx(시트 8 SQL제약)와 동기화되는 실측 보존본. 요약만 제시하며 전체 행은 xlsx 참조.

유형별: Division 8 · 편집제약 7 · 일자·캘린더 4 · Lookup 2 · NVL·기본값 3 · Bulk('^' split) 3 · 커서(OUT RC) 4 · 정렬 1 · 검증 8 · 중복(dedup) 1

### A.1 DMF0020_GET_SCM_MST_FUTURE_PRICE (PROCEDURE, 1194줄) — 조회
- **역할**: 메인/버전 그리드 조회. Division(40/81/82)·New-Model(ESS) 분기로 SalesPlan·FuturePrice 를 GTT 적재 후 PIVOT. 편집권한(EDIT_YN)은 SP 아닌 메타 뷰 산출. 이중 OUT 커서(O_RC1 타이틀 / O_RESULT_CURSOR 본문).
- 82(ESS)는 버전명에 주차·(NO PLAN) 표기(346-347,379-380,398-399,435-436) · 82&INVALID_EXEC='Z' 만 단품원본 적재(584,1008) · 40 은 PROJECT/STATUS/BIZ_TYPE='-' 고정+PIVOT 키를 END_CUSTOMER 로(587,699,735) · 편집권한 division 하드코딩 없음(SCM_ADM_USER_MNU_EDIT_AUTH_V 조인, AUTHORITY_YN=FN_GET_DEPT_LIST 677,746) · 조회구간 오늘~52주(BASIS_YYYYMMDD BETWEEN … SYSDATE+52*7) · NVL(…,'-') 27곳 PIVOT 정규화 · REGEXP_SUBSTR '[^^]+' 18곳 · EXCEPTION→RAISE_APPLICATION_ERROR(-20001) 표준 로그(1188-1193).

### A.2 DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (PROCEDURE, 1028줄) — 저장
- **역할**: 메인 저장. '^' 16컬럼 파싱→GTT→ACTIVE_FLAG 기준 DELETE / DELETE+INSERT + _H 이력. LOC 메저만 편집원천, 가격편차 위반은 O_RC1 경고(하드에러 아님).
- 16파라미터 '^' CONNECT BY 파싱(143-160) · ITEM_ID 개행/탭/공백 제거(169-170) · **LOC 기준 ACTIVE_FLAG 재설정**(환율0→KRW/USD=0 D오판 방지 227-230) · ACTIVE_FLAG='D'→DELETE만/그외 동일키 DELETE후 INSERT(MERGE 아님, 687/718/737) · 이력 SEQ1_..._H(799,834) · **가격편차 검증**(LOC & PRICE*RANGE_VAL<ABS(PRICE-기존) & MIN/MAX주차 → O_RC1 반환 949-965; QTY=0·FREE 예측유형 제외 474-481) · 검증구간 당주월요일~52주(470,533) · 이중 OUT(위반없으면 빈 커서) · END 로그에 delete/insert_count.

### A.3 DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP (PROCEDURE, 795줄) — 일괄입력 팝업 저장
- **역할**: PriceBatch 팝업 저장. GTT 적재 후 Project/Item/Site-Item 유효성을 **e_invalid_data 커스텀 예외로 하드 검증**, 통화(LOC/KRW/USD) split insert. OUT 단일 결과커서.
- div<>'40' & PROJECT_CODE 미존재 → 'Invalid Project Code !'(478-488) · ITEM_ID 미존재 → 'Invalid Item ID !'(491-499) · div IN('81','40') & site-item 조합 미존재 → 'Invalid Site Item ID !'(505-541) · 통화·사업부별 분기 insert(470,507,527) · 검증실패도 예외 대신 v_log_type='INVALID' 커서 반환.

### A.4 PKG_DMF0020 (PACKAGE BODY, 4609줄, 16멤버) — 부가기능
- **역할**: FuturePriceInfo/PriceTemplate/PricePopup/OwnerData/WeekData 조회 + ExchangeRate/PriceConversion 저장 + 엑셀업로드. 편집권한(EDIT_YN)·동적컬럼(VISIBLE_FLAG) 메타 산출이 핵심.
- **편집권한**: 조회 3멤버 공통 `INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V (USER×MNU×UNIT_TP='D')` → NVL(EDIT_YN,'N') — **SP 에 '82=편집' 하드코딩 없음**(422,2736,2986,3015,3135,3163,3847) · 동적컬럼 CASE FN_GET_DIVISION_YN THEN VISIBLE_FLAG(2431) · GET_OWNER_DATA 40/82=자기사업부 Owner, 81%=Owner UNION PM_TEAM_MAPPING 부서(3799-3838) · 과거/현재 컷오프=FN_NEXT_DAY('MON')-7, 현재 52주(2798,2874) · 환율저장 SAVE_DM_MST_EXCHANGE_RATE_ALL '^' 8컬럼 DELETE-INSERT(4112,4174) · 통화변환 SAVE_..._CONVERSION LOC→KRW/USD(EXCHANGE_PRICE, NVL 1배 4353-4385) · 룩업 FUTUREMEASURE/DMF0020_CURRENCY/GET_ADMIN_GROUP/DM_OWNER_DEPT/PM_TEAM_MAPPING/SALES_PRICE_RANGE_RATE · NVL 106곳 · EXCEPTION 표준 17곳.

### A.5 Function / 호출 PROC
| Function | 용도 |
|---|---|
| FN_GET_DIVISION_YN | 컬럼 DIVISION_ID 토큰에 현재 사업부 포함(Y/N) — 동적 컬럼 VISIBLE_FLAG |
| FN_NEXT_DAY | 기준일 이후 요일('MON') — 주차 컷오프(당주 월요일) |
| FN_GET_DEPT_LIST | 로그인 사용자 담당부서 포함(Y/N) — 행 AUTHORITY_YN |
| FN_GET_MULTI_OWNER_NAME | 복수 Owner 결합/추출 — Owner 필터 |
| PR_SCM_SYS_LOG_BATCH | 공통 배치 로그(START/END/ERROR, 80회) |
| PR_TMP*/PR_SCM_MST_FUTURE_PRICE(_OVER)/PR_DM_PLN_SALES_PLAN | GTT 적재/가공·편차초과 목록 헬퍼 |
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW / _SALES_PRICE_HIST | Batch·가격이력 재생성 |

---

## 부록 B. Validation 전수 (96 = main 72 + popup 24)

> ⚠ UI분석서 xlsx(시트 11 Validation)와 동기화되는 실측 보존본. 핵심 MSG 만 발췌하며 96행 전체는 xlsx 참조.

핵심 MSG (main): MSG00448(40 편집금지, 876) · MSG00113(필수컬럼 40=892/81=923/82=938) · MSG00412(PRICE_EXIST, 952) · MSG00137(연속작업, 1279/1551) · MSG00283(버전선택, 1286) · MSG00108(기간역전, 1307) · MSG00097(Division, 1327) · MSG00002(필수입력, 1679) · MSG00043(중복, 1703) · MSG00414(40 Project, 1890) · MSG00004(저장건수, 1933) · MSG00408(일괄입력 읽기모드, 2369) · MSG00142(환율 읽기모드, 2404) · MSG00447(Currency 공란, 3690) · MSG00227(신규행 Bucket, 3823) · MSG00265(업로드 완료, 3943) · MSG00255(버전 2개 초과, 3913) · MSG00143(Batch 결과, 3493 — MSG_M 미등재).

핵심 MSG (popup): 환율 팝업 MSG00109(읽기전용,225)/MSG00096(권한,279)/MSG00002(필수,385/446)/MSG00004(484) · 일괄입력 팝업 MSG00409(과거구간,1180 미등재)/MSG00330(월요일 아님,1189 미등재)/MSG00133(변경없음,1466 미등재)/MSG00002(1606)/MSG00043(1630)/MSG00004(1870).

> ⚠ `(MSG_M 미등재)` 표기 건은 AS-IS 인라인 문구 기준이며, TO-BE 반영 전 사내 MSG_M 전수 대사 의무(메모리 `feedback_msg_id_text_reconciliation`). 특히 실문구는 fallback 신뢰 금지 — 실 MSG_M 대사 필수.

---

## 각주 — 데이터 접근 (AS-IS ↔ TO-BE)

- AS-IS `DataService.GetDMInnerTable('MyDivision')` (BigFilter) → TO-BE `useTabComboQueries` / cascade store (`useSalesFuturePriceStore.ts`)
- AS-IS `FoxDataClient` SP 호출 → TO-BE `useTabProcQuery` / `useProcMutation` (메타 API_M/PROC_M 경유); '^' bulk 저장은 `apiClient.post` 직접 payload
- AS-IS 편집권한 `SCM_ADM_USER_MNU_EDIT_AUTH_V` EDIT_YN + `DM_UI_EDITABLE_DIVISION`(40 위임) → TO-BE 화면 LOOKUP `DM_EDITABLE_DIVISION_ALLOW`(82) + 사용자권한 유지 (`utils/editableDivision.ts` `isEditableDivision`)
- AS-IS 환율 환산 `GetExchangeRate`/`SetExchangeValues` → TO-BE `salesPriceExchange.ts` + `components/modals/ExchangeRateModal.tsx`(No. 코너 헤더 hook #108)
- 팝업 4종: Exchange Rate → `ExchangeRateModal` / Price 일괄입력 → `PriceBatchInputModal`(+`SalesPriceRangeModal`) / Version → `VersionModal`(DMF0073) / 공통 Project·Item·Owner·TitleSet → 공용 모달(master/components)

---

> **실측 근거**: 본 문서의 모든 라인 번호·파라미터·MSG·분기는 `DMF0020_SalesFuturePrice.cs`(**3,969줄 LF**, `GSCM.DM.Forms.UIL\Master` 정본) + `.Designer.cs`(**1,599줄 LF**) 전수 Read 및 grep 교차검증(Designer 이벤트 배선 20+, FoxDataRequest/GetDMInnerTable call-site 30+, GMessageBox 40+, ShowDialog 8, isCurVersion gate 2)과 `PKG_DMF0020`(4,609줄)·SAVE_ALL/POPUP SP 실측 결과이며, 주석(비활성) 코드·dead copy(Plan.UIL/Shipment.UIL 사본)는 카운트에서 제외하고 활성 코드만 기술함. ⚠ 편집규칙은 실측(**40 편집금지·81·82 편집가능(AS-IS)** / **82만 편집(TO-BE)**)으로 기술 — "82만 편집" 을 AS-IS 로 소급 오기재 금지. MSG 문구는 소스 인라인 주석 기준이며, 미확인·미등재 건은 TO-BE 반영 전 사내 MSG_M 전수 대사 의무.
