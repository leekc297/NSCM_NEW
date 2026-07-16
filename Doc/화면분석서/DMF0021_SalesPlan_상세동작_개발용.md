# DMF0021 Sales Plan — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS 정본 `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs` (**실측 5,599줄** — 물리 LF `wc -l` 기준) + `.Designer.cs` (**1,451줄** LF) 전수 Read. ⚠ **구본 병존** — `GSCM.DM.Plan.UIL\DMF0021_SalesPlan.cs`(3,631줄) 및 Shipment 분기 `GSCM.DM.Shipment.UIL\DMF0021_SalesPlan.cs`(3,912줄) 이 함께 존재하나, [PJ202350699] 속도개선(BigFilter)·[PJ2024-50611] 자동차/ESS 편집·[PJ2025-50017] CELL_PROD_SITE_ID/RTF_SYS_RP 반영이 모두 들어간 **Forms.UIL 5,599줄 판을 정본 채택**. (구본 대비 활성 로직 최신)
> **데이터 접근**: 레거시 FoxData (`FoxDataClient`/`FoxAsyncProxy`/`DataService.GetDMInnerTable`(BigFilter)/`Data.Common`·`Data.User*`). 핵심 엔드포인트 `DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx`(조회, param 18, 5 result table) / `DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL`(저장, '^' bulk, param 18) / `DM.DMF0021_GET_SPREAD_TITLE`(동적 다단 헤더, param 5) / `DM.DMF0021_GET_SALES_PLAN_MEASUREINFO`(+`INFO2`) (메저 행 정보) — TO-BE 대응 = `PKG_DMF0021` SP.
> **범위**: 화면 이벤트/액션 **38 핸들러 전수** (Designer 배선 실측). 내역 = CRUD override 6 (Find/Insert/Delete/Edit/Save/Excel) + 그리드 이벤트 12 (Changed/CellDoubleClick/ComboSelChange/ClipboardPasted/LeaveCell/EnterCell/KeyUp/TopChange/EditModeStarting/EditModeOn/EditModeOff/TextChanged/EditChange) + 조회조건 cascade·버튼·팝업 20. 본 문서는 실동작 핸들러를 §1 에 32 항목으로 그룹핑하고, 진단용 no-op 5종은 [26] 에 일괄 기술.
> **화면 특성**: DMF0082(40 소형 전용) 와 달리 **Division 3종 지원** — 40(소형)/81(자동차)/82(ESS). Division 은 **단일 선택 콤보**(clbDivision, UsrCombo). Bucket 기본값 = **Monthly**(`DefineProperty` L543, DMF0082=Weekly 와 상이). **Version 필드 없음**(→ DMF0082 의 `isCurVersion` Insert/Edit 게이트가 본 화면엔 부재). 수량 배분(주→일, 월→주→일)은 FE 가 아닌 **저장 SP(`SAVE_ALL` 2,937줄) 내부에서 수행** → FE `Dsdm_Changed` 는 색상·SUM 터치만 하는 경량 구현.
> MSG 코드 문구 = 소스 인라인 주석 실측(대부분 확보). 인라인 문구 없는 코드는 "문구 미확인(실측 대사 필요)" 로 표기. ⚠ 메모리 `feedback_msg_id_text_reconciliation` 준수 — TO-BE 반영 전 사내 MSG_M 전수 대사 의무.

> ⚠ 이 문서는 **개발자용 기술 상세본**입니다. User 관점 가독본은 **UI분석서 시트 5** 참조. (§4 User 관점 변환 요지 = 시트5 반영용 요약)

---

## 1. 이벤트 · 액션 상세 (32 그룹 / 38 핸들러)

### ▣ 초기화

#### [1] Form_Load
- **트리거**: Form load  ·  **컨트롤/소스**: `this.Load += Form_Load` (ctor L299 배선, `UnFilterInsertRow=true` L301)
- **소스라인**: `299(wire)/304-320(body); InitControls 419-532; DefineProperty 534-555; CreateSpread 573-584; InitSpread 586-619; GetSpdTitle 640-659; SetSpreadHeaderSpan 3660-3747; InitSpreadFooterSum 621-638`  ·  **호출 메서드**: clsCtrl(CControl) 생성, InitForm(BaseForm), InitControls, CreateSpread(AddSheet→InitSpread), DefineProperty
- **데이터/SP**: `DataService.GetDMInnerTable`(BigFilter: MyDivision/UserTeamByDivision/EndCustomerByDivision/BizType/UserSiteByEndCustomer/UserPlantSiteByEndCustomer); `DM.DMF0003_GET_BUCKET_TYPE_CODE`(GetBucketType); `DM.PR_GET_DAY_RANGE`(GetDayRange); `SCM.SCM0001_GET_LOOKUP_VALUES`(ITEM_TYPE_CODE, GetItemType); `Data.Common`(SALES_PLAN_ITEM_ID/CURRENCY_LIST); `DM.DMF0021_GET_SALES_PLAN_MEASUREINFO`; `DM.UP_FX_GetCommonDataList_DM`(DM_CUSTOMS_HANDBOOK/FCST_TYPE); `DM.DMF0021_GET_SPREAD_TITLE`(InitSpread→GetSpdTitle, param 5)
- **Division 분기**: `InitControls` L440 `sDivision=="40"` → BizType/EndCustomer40 로드 + Project/PlantSite 라벨 **Disable**(455-460); else(81/82) → Project/PlantSite **Enable**(477-479)
- **실제 동작 (실측)** — 초기화 순서:

    ① 생성자(294-302): InitializeComponent → this.Load += Form_Load(299) → UnFilterInsertRow=true(301)
    ② Form_Load(304-320): clsCtrl=new CControl(this) → InitForm() → **InitControls()** → CreateSpread() → DefineProperty() (InitEvent/InitSaveDataTable 은 주석)
    ③ InitControls(419-532) BigFilter 로딩 순서:
      1. Division: `SetChangeControl("MyDivision")`(424) → dtDivision → clbDivision (단일 콤보, CODE/NAME)
      2. Team: `SetChangeControl("UserTeamByDivision", div)`(432) → clbTeam
      3. sDivision=="40"(440): BizType(445)+EndCustomer40(452) 로드, Project/layoutControlItem3/PlantSite **Enabled=false**(455-457), txtProject 클리어(459) / else(462): BizType(467)+EndCustomer(474), Project/PlantSite **Enabled=true**(477-479)
      4. clbColor/chkSum uncheck(486-487), layoutControlItem10 Hidden(489)
      5. EndCustomer→clbCustomer(491), SalesSite(`UserSiteByEndCustomer` 497)→clbSalesSite, PlantSite(`UserPlantSiteByEndCustomer` 504)→clbPlantSite
      6. Bucket(`DMF0003_GET_BUCKET_TYPE_CODE` 508)→cboBucketType, Period(`GetDayRange` 511)→drpPeriod, ItemType(`ITEM_TYPE_CODE` 513)→clbItemType
      7. dtITEM_ID(`SALES_PLAN_ITEM_ID` 519), dtCurrencyList(`CURRENCY_LIST` 522), dtMearsure(`MEASUREINFO` 525), dtCustomsHandbook(`DM_CUSTOMS_HANDBOOK` 529), dtFcstType(`FCST_TYPE` 530)
    ④ DefineProperty(534-555): 날짜 캐시(dtStartPeriod/dtEndPeriod 537-538), usrConditionPanel2.Height=105(540), **cboBucketType=Monthly**(543), siMain.ImagePopUp/cellTypeImage(대문자 강제, 545-550), `txtProject.KeyDown/txtItemId.KeyDown/clbDivision.SelectedIndexChanged` **코드 배선**(552-554, "최초 로드 시 이벤트 충돌 회피")
    ⑤ CreateSpread(573-584): AddSheet "Sales Plan" 헤더 3행(575) → InitSpread(true) → **`dsdm.Changed += Dsdm_Changed`** 코드 배선(583)
    ⑥ InitSpread(586-619): 기간 무변경+!isChangeHeader → RemoveRowAll(593) / else GetSpdTitle(`DMF0021_GET_SPREAD_TITLE`, param p_start/p_end/p_created_by/p_division_id/p_bucket 649-653) → CreateSheetHeaderColumn(3) → SetSpreadHeaderSpan(다단 span+토/일 색 3705-3708) → SetSpreadColumn → InitSpreadFooterSum(D_/M_/W_ 컬럼 Sum footer 630-636)

#### [2] DMF0021_SalesPlan_Load (미배선 stub)
- **소스라인**: `5490-5493`  ·  **실제 동작**: **빈 본문 (no-op)** — Designer 자동생성 Form.Load 스텁이나 ctor 에서 별도 배선 안 함(실 Load 는 [1]). 잔재 껍데기.

### ▣ 조회조건 (cascade)

#### [3] clbDivision_SelectedIndexChanged  ⭐
- **트리거**: Division combo change  ·  **컨트롤/소스**: clbDivision (UsrCombo; **코드 배선** DefineProperty L554 — Designer 아님, 최초 로드 충돌 회피)
- **소스라인**: `554(wire)/5095-5209(body)`  ·  **호출 메서드**: SetChangeControl(BigFilter), clsCtrl.setListBox, CString.GetCheckedListValue, InitSpread, DataService.FP_Log2
- **데이터/SP**: BigFilter `GetDMInnerTable`(UserTeamByDivision/BizType/EndCustomerByDivision/UserSiteByEndCustomer/UserPlantSiteByDivision); FP_Log2("SpeedUp"…) 성능 로깅
- **Division 분기**: `sDivision=="40"`(5120)→BizType+EndCustomer40+Project/PlantSite Disable / else(81/82)→BizType+EndCustomer+Project/PlantSite Enable
- **실제 동작 (실측)**:

    ① 재진입 가드 `blnWork` return(5100-5103) → blnWork=true(5105)
    ② FP_Log2 start(5097) → Team 재조회(`UserTeamByDivision` 5112)
    ③ `sDivision=="40"`(5120): BizType(5124)/EndCustomer40(5131) 재조회 + Project/layoutControlItem3/PlantSite **Disable**(5135-5137), txtProject 클리어(5139) / else(5142): BizType(5146)/EndCustomer(5153) + Project/PlantSite **Enable**(5157-5159)
    ④ EndCustomer→clbCustomer(5169), SalesSite(`UserSiteByEndCustomer` 5177)→clbSalesSite, PlantSite(`UserPlantSiteByDivision` 5184)→clbPlantSite
    ⑤ FP_Log2 end(5192) → txtProject/txtItemId/txtOwner 클리어(5194-5196) → **InitSpread(true)**(5198, 헤더 재생성) → finally blnWork=false

#### [4] clbTeam_SelectedIndexChanged
- **트리거**: Team checklist change  ·  **컨트롤/소스**: clbTeam (UsrCheckedList, Designer D.803)
- **소스라인**: `803(wire)/5293-5343(body)`  ·  **호출 메서드**: SetChangeControl(EndCustomerByDivision/UserSiteByEndCustomer), clsCtrl.setListBox
- **데이터/SP**: BigFilter EndCustomerByDivision / UserSiteByEndCustomer
- **Division 분기**: `"81*"||"82"`(5299)→Team 을 부서키로 EndCustomer/SalesSite(부서 무전달) / else(40)→EndCustomer40 + SalesSite(Team+Customer 키)
- **실제 동작 (실측)**:

    ① Division·Team 코드 추출
    ② `"81*"||"82"`(5299): EndCustomerByDivision(div,team 5310)→clbCustomer, UserSiteByEndCustomer(div,'',cust 5322)→SalesSite
    ③ else(40, 5325): EndCustomerByDivision(div,team 5329)→clbCustomer, UserSiteByEndCustomer(div,team,cust 5338)
    ④ setListBox(dtSalesSite, clbSalesSite)(5342)

#### [5] clbCustomer_SelectedIndexChanged
- **트리거**: End Customer checklist change  ·  **컨트롤/소스**: clbCustomer (UsrCheckedList, Designer D.763)
- **소스라인**: `763(wire)/5084-5093(body)`  ·  **호출 메서드**: SetChangeControl("UserSiteByEndCustomer"), clsCtrl.setListBox
- **데이터/SP**: BigFilter UserSiteByEndCustomer(div,'',customer)
- **실제 동작 (실측)**: ① SalesSite 만 재조회(5089) → clbSalesSite 재세팅(5090). (Team 무전달 = Customer 기준 SalesSite)

#### [6] cboBucketType_SelectedIndexChanged
- **트리거**: Bucket (Daily/Weekly/Monthly) change  ·  **컨트롤/소스**: cboBucketType (UsrCombo, Designer D.568)
- **소스라인**: `568(wire)/3536-3588(body)`  ·  **호출 메서드**: InitSpread, SetSpreadColumn, EditButton, BevelBorder/ResetBorder, siMain.IsLock
- **데이터/SP**: 그리드 컬럼 재렌더링 전용 — 재조회 없음(단 W→D 전환 시 InitSpread 로 헤더 재생성)
- **실제 동작 (실측)**:

    ① sBucket=현재값 캐시(3540)
    ② 이전(fBucket)이 Weekly/Monthly && 신규 Daily(3542) → **InitSpread(true)**(3544, 일자 컬럼 필요→헤더 재생성)
    ③ SetSpreadColumn()(3546) 로 D_/W_/M_ Visible 재구성
    ④ chkColor==false(3549): 당주 W_/당일 D_ 에 Green BevelBorder 재계산 + 반대 축 ResetBorder(3553-3578)
    ⑤ **편집 중(!IsLock)이면 EditButton() 재호출**(3583) — 새 버킷 기준 Lock 범위 재적용

#### [7] cboBucketType_Click
- **트리거**: Bucket combo click  ·  **컨트롤/소스**: cboBucketType (Designer D.569)
- **소스라인**: `569(wire)/5468-5488(body)`  ·  **호출 메서드**: siMain.IsLock, MessageHelper.GMessageBox
- **MSG**: **MSG00227** (문구 미확인 — 신규/수정 모드 Bucket 변경 금지)
- **실제 동작 (실측)**: ① `!siMain.IsLock()`(편집/신규 모드)(5473) → **MSG00227** + return 하여 Bucket 변경 차단. ([PJ2024-50611] 구 행 순회 방식 5479-5486 은 주석, IsLock 단일 판정으로 대체)

#### [8] chkSum_CheckedChanged
- **트리거**: Sum checkbox toggle  ·  **컨트롤/소스**: chkSum (UsrCheckBox, Designer D.389)
- **소스라인**: `389(wire)/4419-4425(body)`  ·  **호출 메서드**: SetSpreadColumn
- **실제 동작 (실측)**: ① `SetSpreadColumn()`(4423) 재호출만 — Daily 시 M_/W_, Weekly 시 M_ Visible 을 chkSum 상태에 토글(SetSpreadColumn L3602-3620). **FE 전용, SP 미전달**

#### [9] chkColor_CheckedChanged
- **트리거**: Color checkbox toggle  ·  **컨트롤/소스**: chkColor (UsrCheckBox, Designer D.281)
- **소스라인**: `281(wire)/5211-5217(body)`  ·  **호출 메서드**: SetSpreadColumn
- **실제 동작 (실측)**: ① `SetSpreadColumn()`(5215) 재호출 — chkColor==true → 실적구간 Gainsboro 회색/당월 White 방식, false → 당주/당월 헤더 Green Bold + BevelBorder 방식으로 전환(SetSpreadColumn L3623-3656, EditButton/Draw 도 동일 분기). 데이터 불변, 강조 방식만 토글

#### [10] cboKRW / cboUSD / cboLOC_SelectedIndexChanged (no-op 3종)
- **소스라인**: `cboKRW 5399-5407 / cboUSD 5409-5417 / cboLOC 5419-5427`  ·  **실제 동작**: 3종 모두 `siMain==null return` 이후 **본문 주석(no-op)** — 구 `SetAmountCalculating()`(환율 금액환산) 비활성. Designer 배선 미확인(컨트롤 잔존 여부 불명, 금액환산 기능 폐기 잔재). TO-BE 미구현 대상.

#### [11] txtProject_KeyDown
- **트리거**: Project 필드 Enter  ·  **컨트롤/소스**: txtProject (UsrMultiLineEditor; **코드 배선** DefineProperty L552)
- **소스라인**: `552(wire)/557-563(body)`  ·  **실제 동작**: ① Enter 키(559) → `btnProject_Click(null,null)`(561) 강제 호출 → Project 팝업

#### [12] txtItemId_KeyDown
- **트리거**: Item 필드 Enter  ·  **컨트롤/소스**: txtItemId (UsrMultiLineEditor; **코드 배선** DefineProperty L553)
- **소스라인**: `553(wire)/565-571(body)`  ·  **실제 동작**: ① Enter 키(567) → `btnItemId_Click(null,null)`(569) 강제 호출 → Item 팝업

### ▣ 조회조건 버튼 · 팝업

#### [13] btnProject_Click
- **트리거**: Project '...' 버튼 click (+ layoutControlItem3.Click D.1129)  ·  **컨트롤/소스**: btnProject (UsrButton, Designer D.499)
- **소스라인**: `499(wire)/3489-3506(body)`  ·  **호출 메서드**: SCM0002_ProjectbyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: 팝업 `SCM0002_ProjectbyDivisionPopupEx` (내부 SP)
- **Division 분기**: **`"81*"||"82"` 에서만 동작**(3491) — 40 은 Project 미사용(if 미진입 = 무동작)
- **실제 동작 (실측)**:

    ① Division 이 81/82(3491): Division/Team/EndCustomer/SalesSite/Project 수집 → new SCM0002_ProjectbyDivisionPopupEx → Form_Load(true, div, team, endCust, site, project)(3500) → CenterParent, ShowDialog
    ② 반환 popProject.ProjectCode → txtProject.Text(3504) (빈값이어도 대입 — silent)

#### [14] btnItemId_Click
- **트리거**: Model '...' 버튼 click  ·  **컨트롤/소스**: btnItemId (UsrButton, Designer D.353)
- **소스라인**: `353(wire)/3508-3527(body)`  ·  **호출 메서드**: DM0002_ItembyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: 팝업 `DM0002_ItembyDivisionPopupEx` (구 `SCM0002_ItembyDivisionPopupEx` 3518 주석 → DM 판 채택)
- **실제 동작 (실측)**: ① Division/Team/EndCustomer/Project/SalesSite/ItemId 수집 → Form_Load(true, div, team, endCust, site, project, itemId)(3522) → ShowDialog → 반환 popItem.ItemID → txtItemId.Text(3526)

#### [15] btnOwner_Click
- **트리거**: Owner '...' 버튼 click  ·  **컨트롤/소스**: btnOwner (UsrButton, Designer D.985)
- **소스라인**: `985(wire)/5447-5466(body)`  ·  **호출 메서드**: DM0020_OwnerbyDivisionPopup.Form_Load, ShowDialog
- **데이터/SP**: 팝업 `DM0020_OwnerbyDivisionPopup` (분석서 `DMF0020_POPUP_Owner`)
- **실제 동작 (실측)**: ① Division/Team/EndCustomer/Project/SalesSite/ItemId/Owner 수집 → Form_Load(true,…, owner)(5461) → ShowDialog → 반환 popItem.OwnerID → txtOwner.Text(5465)

#### [16] btnColumn_Click
- **트리거**: Column Show 버튼 click  ·  **컨트롤/소스**: btnColumn (UsrButton, Designer D.463)
- **소스라인**: `463(wire)/4427-4438(body)`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup(mode=**true**), InitSpread
- **데이터/SP**: 팝업 `DM0002_TitleSetForm_Popup`(컬럼셋 저장, 분석서 `DMF0020_POPUP_GridColumnSetting`) → OK 시 InitSpread 재조회
- **실제 동작 (실측)**: ① new DM0002_TitleSetForm_Popup(sProgram_Id="DMF0021", shtMain, **true**, clbDivision.ControlValues)(4430) — 3번째 true = 컬럼 Show/Hide → ShowDialog → DialogResult==OK 이면 InitSpread(true)(4436) 로 헤더/컬럼 재적용

#### [17] btnMeasure_Click
- **트리거**: Measure Show 버튼 click  ·  **컨트롤/소스**: btnMeasure (UsrButton, Designer D.426)
- **소스라인**: `426(wire)/4440-4451(body)`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup(mode=**false**), InitSpread
- **실제 동작 (실측)**: ① new DM0002_TitleSetForm_Popup("DMF0021", shtMain, **false**, div)(4443) — 3번째 false = Measure Show/Hide → ShowDialog → OK 이면 InitSpread(true)(4449) 재구성

### ▣ 그리드 편집 · 배분

#### [18] Dsdm_Changed  ⭐ 핵심(경량)
- **트리거**: Grid cell value changed  ·  **컨트롤/소스**: spdMain DefaultSheetDataModel.Changed (**코드 배선** CreateSpread L583 `dsdm.Changed += Dsdm_Changed`)
- **소스라인**: `583(wire)/3918-4085(body); SetSaveData 4102-4141; InitSaveDataTable 4087-4101`  ·  **호출 메서드**: siMain.IsLock/IsLockCell, siMain.GetColumnTag/GetText/SetColor
- **데이터/SP**: 없음 (셀 색상·SUM 셀 터치만) — ⚠ **수량 배분(주→일·월→주→일)은 저장 SP `DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL`(2,937줄) 내부에서 수행**. DMF0082 대비 FE 배분 로직 대폭 축소(구 배분 로직 4016-4058 전량 주석).
- **실제 동작 (실측)**:

    ① 재진입 가드: `IsLock` return(3921), `e.Column<0||e.Row<0` return(3926), `IsLockCell` return(3928)
    ② switch(e.Type) case **CellsUpdated**(3933):
      · Measure 컬럼보다 우측(값 영역)이 아니면 else(3069) → no-op
      · **`D_` 컬럼 태그면 return**(3937) — D_ 셀 직접 변경은 처리 안 함(W_/M_ 입력 통로만 처리)
      · Measure 값 공란(3941) → 셀 clear + return
      · **셀 색상 Red 세팅**(3948, 변경 표시)
      · Weekly Sum region(3956-3968): 좌측 최근접 W_ 다음 컬럼(iStartCol) 텍스트 재기입(터치)
      · Monthly Sum region(3971-3984): 좌측 최근접 M_ 다음 컬럼 재기입
      · 누적 합계 iMonthlySum 계산(3986-3996, W_·M_ 값 합산) — 실 SUM 반영은 ColumnFooter/SP 담당
    ③ (`SetSaveData` 4102·`InitSaveDataTable` 4087 = 구 dtSave upsert 헬퍼 — 현 저장 경로(SaveData 직접 '^' 조립)에서 미사용, 잔존)
    · ⚠ 구 주간/월간 실시간 배분(4016-4058)은 "Sum 계산 오류로 주석 20190306" 이후 SP 위임. TO-BE 는 SP 배분 로직을 정본으로 이관.

#### [19] spdMain_CellDoubleClick
- **트리거**: Grid cell / column-header double click  ·  **컨트롤/소스**: spdMain.CellDoubleClick (Designer D.158)
- **소스라인**: `158(wire)/3749-3916(body); 헤더토글 3751-3794; 데이터셀 3795-3915`  ·  **호출 메서드**: siMain.GetColumnTag/Columns[].Visible, SCM0002_ProjectbyDivisionPopupEx, DM0002_ItembyDivisionPopupEx, ShowDialog
- **데이터/SP**: 팝업 ProjectbyDivision / ItembyDivision (조회 전용, SP 직접호출 없음)
- **Division 분기**: Item 팝업은 `sDivision=="40" && sMeasure=="Catch_Up" && e.Column==ITEM_ID`(3863) 에서만
- **실제 동작 (실측)**:

    ① **컬럼 헤더 더블클릭**(3751): 태그 `M_`(월) → 해당 월 구간 W_ Visible 토글 + Daily 시 D_ 숨김, 다음 M_ 에서 break(3776) / 태그 `W_`(주) → Daily 시 D_ Visible 토글, 다음 W_ 에서 break(3790) (팝업 없음, 접기/펼치기)
    ② **데이터 셀**: 조기 가드 `IsLock || Action!='I'`(3797) return — 편집 팝업은 **신규 입력행(Action='I') + Unlock 에서만**
    ③ Project 컬럼(3834): SCM0002_ProjectbyDivisionPopupEx.Form_Load(false,…)(3837) → ProjectCode 반환 시 Project/Name/Status/BizTypeName/Owner 셀 SetText, Item/ItemClassName 클리어(3843-3859)
    ④ 40 && Catch_Up && ITEM_ID 컬럼(3863): DM0002_ItembyDivisionPopupEx.Form_Load(false,…, sMdmActive_Sw="Y", sMeasure_info) [E20231019-001234](3895) → ItemID 반환 시 Item/ItemType/NickName SetText(3906-3912)

#### [20] spdMain_ComboSelChange  ⭐
- **트리거**: In-grid combo cell selection change  ·  **컨트롤/소스**: spdMain.ComboSelChange (Designer D.159)
- **소스라인**: `159(wire)/4490-5082(body); Division 4500-4582; Dept 4583-4645(주석); Customer 4646-4680; EndCustomer40 4682-4709; ScmSiteId 4710-4742; ItemId 4743-4772; Measure 4774-5082`  ·  **호출 메서드**: Data.UserTeamByDivisionAuth, Data.UserEndCustomerByDivisionDeptAuth, Data.Common(EndCustomerByDivision40/CELL_PROD_SITE_ID), Data.UserSiteByEndCustomerAuth, Data.UserPlantSiteByDivision, SetCellTypeCombo, LockRange, dtITEM_ID.Select(GUBUN)
- **데이터/SP**: 콤보 UserTeamByDivisionAuth / EndCustomerByDivision(40)Auth / UserSiteByEndCustomerAuth / UserPlantSiteByDivision / CELL_PROD_SITE_ID / dtCustomsHandbook; dtITEM_ID GUBUN 40/81/82 in-memory filter
- **Division 분기**: ItemId 콤보 = `82→GUBUN='82'`(4555) / `"81*"→'81'`(4557) / `40→'40'`(4560, Catch_Up 이면 미바인딩 4702); PlantSite = `"81*"→Unlock / else Lock`(4543-4546)
- **실제 동작 (실측)**:

    ① **Division 셀 변경**(4500): Team(`UserTeamByDivisionAuth` 4506) → EndCustomer(`…DeptAuth` 4514) → EndCustomer40(`EndCustomerByDivision40` 4523) → SalesSite(`UserSiteByEndCustomerAuth` 4532) → PlantSite(`UserPlantSiteByDivision` 4538, "81*"만 Unlock) → ItemId(GUBUN 40/81/82 4551) → 하위 키 셀 전체 clear(4566-4581)
    ② Dept 셀(4583): **본문 전량 주석 (no-op)** ([PJ2024-50611] "팀 바뀌어도 조치 안 함")
    ③ EndCustomer 셀(4646): SalesSite(Auth) + ItemId 재바인딩 + 하위 clear
    ④ EndCustomer40 셀(4682): SalesSite(`UserSiteByEndCustomer`) + ItemId(40 Catch_Up 제외)
    ⑤ ScmSiteId 셀(4710): ItemId 재바인딩 + Project/Item/Text/ItemClass clear
    ⑥ ItemId 셀(4743): ItemClassName SetText(모델명 4753) + CELL_PROD_SITE_ID 콤보(`Data.Common` 4769)
    ⑦ **Measure 셀**(4774): 편집가능 시작컬럼(i_EditStartCol) 버킷별 재계산(Monthly→this_YYYYMM 4817 / Weekly→this_YYYYMMWW 4828); 40 && SalesAmt_LOC 당월/당주 포함(4846); **Measure=="Catch_Up"**(4865) → ItemId 이미지셀+clear(4870) + DomExp 콤보(dtCustomsHandbook)+Unlock(4877) (Catch_Up 은 M+3 이후 편집 셋업)

#### [21] spdMain_ClipboardPasted
- **트리거**: After clipboard paste into grid  ·  **컨트롤/소스**: spdMain.ClipboardPasted (Designer D.155)
- **소스라인**: `155(wire)/5572-5596(body)`  ·  **호출 메서드**: siMain.GetValue, Data.Common(CELL_PROD_SITE_ID), SetCellTypeCombo
- **실제 동작 (실측)**: ① 붙여넣기 셀범위 순회 → `iCol==ITEM_ID`(5578) 이면 Division/ScmSite/EndCustomer/ItemId 추출 → CELL_PROD_SITE_ID 콤보 재바인딩(`Data.Common` 5589). (ITEM_ID 붙여넣기 시 종속 셀생산지 콤보 갱신. Item 콤보 자체 재바인딩은 ComboSelChange 담당)

#### [22] spdMain_LeaveCell
- **트리거**: Grid leave cell  ·  **컨트롤/소스**: spdMain.LeaveCell (Designer D.156)
- **소스라인**: `156(wire)/4322-4398(body)`  ·  **호출 메서드**: siMain.GetBGColor, siMain.SetValue/SetRowFormat, siMain.GetColumnIndex(this_YYYYMM)
- **Division/Measure 분기**: `RTF_SYS_RP`(정수 포맷·음수 처리) / `SalesAmt_LOC`(소수3 포맷)
- **실제 동작 (실측)** [PJ2025-50017, DMF0082 와 로직 동일화]:

    ① 게이트: 셀 배경==UnLockColor(편집 노랑) && this_YYYYMM 이후 컬럼(4342) 에서만
    ② FcstType/Measure 추출(4344-4348), Val 취득
    ③ **RTF_SYS_RP && FcstType!="RMA" && Val<0**(4358) → 셀 clear + return (RMA 는 음수만 저장 가능, 그 외 메저는 양수만)
    ④ 포맷: RTF_SYS_RP→정수 `###,###,###,###`(4380) / SalesAmt_LOC→소수3 `…##0.000`(4384)
    ⑤ RTF_SYS_RP 소수부 있으면 정수 절삭(4390-4394)

#### [23] spdMain_EnterCell
- **트리거**: Grid enter cell  ·  **컨트롤/소스**: spdMain.EnterCell (Designer D.157)
- **소스라인**: `157(wire)/4289-4298(body)`  ·  **실제 동작**: ① Measure 우측(값 영역)이면 진입 셀 원본값을 `sOrigianlValue`(공란→"0")에 캐시(4296) — 배분 델타 계산용 잔재(현 배분 SP 위임으로 실사용 축소)

#### [24] spdMain_KeyUp
- **트리거**: Key up in grid (Ctrl+C / Ctrl+V)  ·  **컨트롤/소스**: spdMain.KeyUp (Designer D.163)
- **소스라인**: `163(wire)/5429-5445(body)`  ·  **호출 메서드**: ClipboardPaste/ClipboardCopy(AsStringSkipHidden), Clipboard.Clear
- **실제 동작 (실측)**: ① Measure 이하(키 영역) return(5431) ② `V` → ClipboardPaste(AsStringSkipHidden, 숨김열 제외 5435) ③ `C` → Clipboard.Clear + ClipboardCopy(AsStringSkipHidden 5442)

#### [25] spdMain_TopChange
- **트리거**: Grid vertical scroll (top row change)  ·  **컨트롤/소스**: spdMain.TopChange (Designer D.161)
- **소스라인**: `161(wire)/3529-3534(body)`  ·  **실제 동작**: ① CanModelChange=false → `siMain.SmartColMerge()`(3532) 뷰포트 좌측 키컬럼 세로 병합 재계산 → CanModelChange=true (스크롤 시 병합 셀 깨짐 방지)

#### [26] 진단용 no-op 그리드 이벤트 5종
- **소스라인/배선**: `spdMain_EditModeStarting 4412-4416(D.152) / spdMain_EditModeOn 4310-4314(D.153) / spdMain_EditModeOff 4316-4320(D.154) / spdMain_TextChanged 4400-4405(D.162) / spdMain_EditChange 4407-4411(D.160)`
- **실제 동작**: 5종 모두 배선은 있으나 **본문 주석(no-op)** — 이벤트 발생 순서 추적용(`sOrigianlValue2` 로깅) 코드 잔재. 실동작 없음. TO-BE 이관 제외 대상.

### ▣ CRUD 버튼 (BaseForm override)

#### [27] FindButton (override) → FindData()
- **트리거**: Find/Retrieve toolbar 버튼 / F5  ·  **컨트롤/소스**: Common toolbar (BaseForm hotkey)
- **소스라인**: `663-666(override) / FindData 1450-1632 (async) / Draw 1634-1920`  ·  **호출 메서드**: FindData(true), FoxAsyncProxy.ExecuteAsync('DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx'), siMain.Query/LockColumn/SmartColMerge, Draw, SetSpreadColumn
- **데이터/SP**: SP `DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx` (Timeout 30분, **param 18**; result: [0]본문 / [1]주차정보(THIS_YYYYMM/THIS_YYYYMMWW/PRE_*/BASIS_DATE/ISO_WEEK) / [2]편집권한(EDIT_AUTH_SalesAmt_LOC/EDIT_AUTH_RTF_SYS_RP) …)
- **MSG**: MSG00137, MSG00108, MSG00164, MSG00097
- **Division 분기**: p_division_id = clbDivision (40/81/82 그대로 전달, SP 내부 분기)
- **실제 동작 (실측)**:

    ① 재진입 `blnWork`→**MSG00137**("전 작업이 아직 실행 중입니다" 1460) return → blnWork=true
    ② 기간 검증: from>to→**MSG00108**(1474) return / `Value1.AddYears(3)<Value2`→**MSG00164**(1481) + Value2=Value1+3년 보정 후 return (⚠ 주석은 "2년까지" 이나 코드는 3년)
    ③ 파라미터 **18종**(1538-1555): p_division_id/p_dept_id/p_end_customer/p_scm_site_id/p_project_code/p_item_id/p_item_type/p_from_yyyymmdd/p_now_yyyymmdd/p_to_yyyymmdd/p_created_by/p_plant_site_id/p_biztype/p_userinfo/p_owner/**p_internal_yn(=InternalYN.Checked)**/p_bucket/p_user_dept_id. Division 공란→**MSG00097**(1513) return
    ④ CanModelChange=false → InitSpread(true)(1521, 헤더 재생성) → FoxAsyncProxy.ExecuteAsync 비동기 조회(1530)
    ⑤ Tables[0] 0행이면 return(1563); 마지막행 MEASURE≠"" 이면 Action 컬럼 추가→siMain.Query(dt)→**LockColumn(0,max,true 전체잠금)**(1575)
    ⑥ dsMain=ds(1588) → **Draw()**(1589): 행별 NOTATION(INTEGER/POINT/POINT3)→SetRowFormat 소수 포맷(1696-1762); 주차정보 소비(Tables[1] 1778-1784); PROJECT_CODE 셀 이미지타입/CELL_PROD_SITE_ID 가운데정렬(1807-1812); chkColor 별 실적구간 Gainsboro·당월 White(1892-1894) 또는 당주 Green BevelBorder(1898-1913)
    ⑦ SetSpreadColumn(1593) + dtSave.Clear + SmartColMerge; !blnInsert 이면 마지막 Update 셀로 이동(1602-1606); catch GMessageBoxForException(1618); finally blnWork=false

#### [28] InsertButton (override) → InsertRow()
- **트리거**: Insert toolbar 버튼 / F8  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `668-671(override) / InsertRow 2831-3382`  ·  **호출 메서드**: InsertRow(), siMain.Insert, Data.UserTeamByDivisionAuth/UserSiteByEndCustomerAuth/UserEndCustomerByDivisionDeptAuth, Data.Common(CELL_PROD_SITE_ID), SetCellTypeCombo, LockRange
- **데이터/SP**: 콤보 UserTeamByDivisionAuth / UserEndCustomerByDivisionDeptAuth / UserSiteByEndCustomerAuth / CELL_PROD_SITE_ID / dtMearsure / dtCurrencyList
- **Division 분기**: `sDivision=="40"` → DEPT_ID 콤보 편집 가능(2888)·Measure Unlock(2933 else Lock); 그 외 read-only 다수
- **실제 동작 (실측)**:

    ① **권한 게이트**: dsMain.Tables[2]["EDIT_AUTH_SalesAmt_LOC"]!="Y" 이면 `!bEDIT_AUTH_SalesAmt_LOC` **return (silent)**(2854-2857) — **기타매출(SalesAmt_LOC) 편집권한자만 Insert 허용**
    ② IsLock==false && shtMain 확인(2860) → siMain.Insert()(2867, Action='I' 신규행)
    ③ Division 셀 세팅+Lock(2881); `40 && DEPT_ID`→Team 콤보(UserTeamByDivisionAuth 2890) else Lock; EndCustomer/SCM_SITE_ID/CELL_PROD_SITE_ID 콤보(2911-2919)
    ④ **Measure 콤보(dtMearsure)+기본값 "SalesAmt_LOC"**(2925-2926); 40 아니면 Measure Lock(2935)
    ⑤ **FcstType 기본값 "ETC" + Lock**(2944-2945) — ⚠ Insert 신규행은 FCST Type=ETC 고정(SalesAmt_LOC 매출 = ETC 제약)
    ⑥ PROJECT_CODE 이미지셀(2940); CURRENCY 콤보(dtCurrencyList 3000); 그 외 20여 개 read-only 컬럼(ProjectName/Status/Owner/BizTypeName/ItemName/SalesCompany/NickName/PlantSite/INCOTERMS/Country/City/VMI_YN 등) LockRange(2949-3029)

#### [29] DeleteButton (override)
- **트리거**: Delete toolbar 버튼 / F9  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `673-679(body)`  ·  **호출 메서드**: siMain.GetText(Action), siMain.Delete
- **실제 동작 (실측)**: ① 활성행 Action=='I'(신규 삽입행)(675) 이면 **siMain.Delete()**(677) 로 즉시 행 삭제. ② **그 외(DB 조회행)는 무동작** — ⚠ DMF0082 와 달리 저장행 삭제(계획구간 0 세팅/권한 MSG00464)는 본 화면 미구현. 저장된 행 삭제는 SP(SAVE_ALL 내 stempAction "D" — SaveData L2565-2571: Price=="0"→Action="D") 경로로만 처리.

#### [30] EditButton (override)  ⭐
- **트리거**: Edit toolbar 버튼 / F2 (Bucket 변경 시에도 호출)  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `681-1108`  ·  **호출 메서드**: siMain.GetColumnIndex(필수컬럼), SwitchLock/LockColumn/LockRange, MessageHelper.GMessageBox, Data.UserTeamByDivisionAuth, dsMain.Tables[2] 권한
- **데이터/SP**: 없음(로컬 잠금/채색); dsMain.Tables[2] 편집권한(bEDIT_AUTH_SalesAmt_LOC / bEDIT_AUTH_RTF_SYS_RP)
- **MSG**: MSG00429{Team}, MSG00113, MSG00361 (구 MSG00109 40 read-only 는 주석 = 폐기)
- **Division/Measure 분기**: 필수컬럼 세트가 40/81/82 별 상이(703-717); 편집대상 Measure = SalesAmt_LOC(권한)·RTF_SYS_RP(권한)·Catch_Up(무조건); 40 은 당월부터 / RTF_SYS_RP 당월 Lock / Catch_Up M+3 이후
- **실제 동작 (실측)**:

    ① fps!=null(683); **필수 컬럼 존재 체크**(703-717): DIVISION_ID / (비40)PROJECT_CODE / (40)END_CUSTOMER40 / (비40)END_CUSTOMER / SCM_SITE_ID / ITEM_ID / (81)TEXT / DomExp / FcstType / INCOTERMS / MEASURE / CURRENCY / (40)DEPT_ID / (40)CELL_PROD_SITE_ID 중 결손 시 → `40&&DEPT_ID 결손`→**MSG00429 {Team}**(722) / `40&&CELL_PROD_SITE_ID 결손`→**MSG00113**(726) / else→**MSG00113**(730) return
    ② Bucket==Weekly||Monthly(736): SwitchLock → **LockColumn(0,max,true 전체잠금)**(742); list_EDIT_Week/Month 계산(760-812): `40`→M_ 당월 포함(766, [E20250520-000605] 당월부터 수정)·`else`→당월 제외(783), W_ 당주 포함(798)
    ③ 편집권한 취득(934-945): dsMain.Tables[2] → bEDIT_AUTH_SalesAmt_LOC / bEDIT_AUTH_RTF_SYS_RP
    ④ 행별 Unlock(952-1094): SALES_PLAN_ADJUST_YN=="N_Y" 행 중 (SalesAmt_LOC && 권한) || Catch_Up || (RTF_SYS_RP && 권한) 만; **Catch_Up = M+3 이후**만 Unlock(982); IsEditMode 시 **Monthly↔Weekly 상호 배제**(Monthly 편집 시 W_ Lock / Weekly 시 M_ Lock 999-1010, [PJ2025-50017]); **RTF_SYS_RP 당월 Lock**(1052-1064, [E20250520-000605])
    ⑤ Bucket==Daily(1101) → **MSG00361**(문구 미확인 — Daily 편집 불가) return

#### [31] SaveButton (override) → SaveData()
- **트리거**: Save toolbar 버튼 / F7  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `1110-1113(override) / SaveData 1922-2828 (async); fnValidation 4143-4275`  ·  **호출 메서드**: SaveData(), FoxDataClient.ExecuteDataSet('DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL'), FindData(재조회)
- **데이터/SP**: SP `DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL` (Timeout 10분, '^' bulk **param 18**); 성공 후 재조회 `GET_DM_PLN_SALES_PLAN_DATAEx`
- **MSG**: MSG00137, MSG00113, MSG00002{필드}, MSG00085{0}, MSG00146{line}, MSG00004{cnt} (+ SP 반환 messageCode^addmessage). ⚠ **저장확인 MSG00012 없음** — DMF0082 와 달리 즉시 저장.
- **Division 분기**: 필수 컬럼 세트·필드값 추출이 40/81/82 별 상이; PROJECT_CODE 슬롯 = 비40 Project / **40 은 END_CUSTOMER40 값**(2355)
- **실제 동작 (실측)**:

    ① 재진입 `blnWork`→**MSG00137**(1933) return; **IsLock==true(편집모드 아님)→return**(1940); shtMain 확인(1943)
    ② **필수 컬럼 존재 체크**(2007-2022, EditButton 과 동일 세트) 결손 시 **MSG00113**(2024) return
    ③ 행 순회 1차 검증(2028-2272): Action∈{I,M,D} 만; 값 추출 후 필수 누락 판정(2198-2207) → 첫 결손 필드로 **MSG00002 {필드명}**(2239, "[Division]/[Currency]/[Sales_Site]/[Model]/[Measure]/[TEAM]/[END_CUSTOMER]/[Customer Handbook]/[FcstType]/[INCOTERMS]/[CellProdSiteID]") + 셀 포커스(2243) return. (중복검사는 SP 위임 — 구 fnValidation 2250-2269 주석)
    ④ 행 순회 2차 payload 조립(2286-2674): Action(2563), Price=="0"→Action="D"(2571); **40 && Catch_Up && Price<0**→**MSG00085 {0}**("0 이상만 입력" 2587) return; iDateCount==0 행→**MSG00146 {line}**("날짜 값 없음" 2666) return; '^' join 누적(2618-2657)
    ⑤ SP 호출(2681-2706) **param 18**: p_active_flag/p_division_id/p_project_code(=40 EndCustomer)/p_scm_site_id/p_plant_site_id/p_item_id/p_dom_exp/p_fcst_type/p_incoterms/p_measure/p_yyyymmdd/p_qty/p_currency/p_created_by/p_last_updated_by/p_text/p_dept_id/p_cell_prod_site_id
    ⑥ 결과 판정(2717): Tables[0][0][0]=="success" → **MSG00004 {iCUD}**("N개 저장" 2794) + blnWork=false + **FindData 재조회**(blnInsert→FindData(true) / else→FindData(false, updRow, actCol) 2800-2803); ≠"success" → 문자열에 "^" 있으면 `messageCode^addmessage` split → GMessageBox(2776-2782) / else MessageBox.Show(원문 2788) + return
    · 참고: SP 내부(SAVE_ALL 2,937줄)가 수량 배분(주→일·월→주→일)·중복검증(YYYYMMDD 단위)·MERGE upsert 수행. 오류 시 RESULT_CODE='F' + ERR_MESSAGE/RESULT_MSG 반환(구 INVALID2/4/5 분기 2721-2772 주석 → messageCode^msg 통합 방식으로 대체).

#### [32] ExcelButton (override)
- **트리거**: Excel toolbar 버튼 / F12  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `1131-1175 (활성) ; ExportExcel 1184-1440 (구 방식, 미사용)`  ·  **호출 메서드**: SimplexelService.ExportFpSpread, MessageService.CloseProgress
- **데이터/SP**: 없음 (로컬 Export) [E20240906-001717 속도개선]
- **MSG**: MSG00003 (ExportExcel 경로, 현 활성 경로선 미사용)
- **실제 동작 (실측)**:

    ① SimpleExcelExportOption(1133): Merge=None, Border=All, AheadZero=HideZero, AmendZero=ShowZero, NullToZero=false, AmendDecimalFormat="#,##0.##0;[Red]-#,##0.##0"(1147)
    ② `SimplexelService.ExportFpSpread(fps, exportOption)`(1156) → 파일명 `StartupPath\DMF0021_SalesPlan_{yyyyMMddHHmmss}.xlsx`(1135)
    ③ finally MessageService.CloseProgress()(1165). (구 ExportExcel 1184-1440 = 컬럼 hidden 제거·Frozen 재계산·SaveExcel 방식, [E20231128-000738] 82 소수표기 대응 잔재 — 현재 미호출)

---

## 2. 버튼 인벤토리 (11) — AS-IS 실측

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/권한 | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find/Retrieve (common) | toolbar | FindData(true): 검증 + async 조회 + Draw | DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx (5 tables, param 18) | MSG00137/00108/00164/00097 | Always | 663-666 / 1450-1632 |
| 2 | Insert (common) | toolbar | InsertRow(): 신규행 Action='I' + Measure=SalesAmt_LOC + FcstType=ETC | (콤보 룩업) | — | **EDIT_AUTH_SalesAmt_LOC(기타매출) 권한자만** | 668-671 / 2831-3382 |
| 3 | Delete (common) | toolbar | Action=='I' 행만 즉시 삭제 (DB행 미삭제) | — | — | Edit 모드 | 673-679 |
| 4 | Edit (common) | toolbar | 필수컬럼 검증 + 버킷별 Unlock + 권한/당월/Catch_Up 분기 | — | MSG00429/00113/00361 | Weekly/Monthly만(Daily→MSG00361); 권한 Measure만 | 681-1108 |
| 5 | Save (common) | toolbar | SaveData(): 필수·중복 검증 → '^' 18 bulk 저장 | DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | MSG00137/00113/00002/00085/00146/00004 | Edit 모드; async void; **확인창 없음** | 1110-1113 / 1922-2828 |
| 6 | Excel (common) | toolbar | SimplexelService.ExportFpSpread | (로컬 export) | (MSG00003 구경로) | Always | 1131-1175 |
| 7 | btnProject '...' | 조회조건 Row2 | Project 팝업 → txtProject (**81/82만**) | SCM0002_ProjectbyDivisionPopupEx | — | 81/82 (40 미동작) | 499(wire)/3489-3506 |
| 8 | btnItemId '...' | 조회조건 Row2 | Item 팝업 → txtItemId | DM0002_ItembyDivisionPopupEx | — | Always | 353(wire)/3508-3527 |
| 9 | btnOwner '...' | 조회조건 Row2 | Owner 팝업 → txtOwner | DM0020_OwnerbyDivisionPopup | — | Always | 985(wire)/5447-5466 |
| 10 | btnColumn (Column Show) | 조회조건 | 컬럼 Show/Hide 팝업(true); OK→InitSpread | DM0002_TitleSetForm_Popup("DMF0021",true) | — | Always | 463(wire)/4427-4438 |
| 11 | btnMeasure (Measure Show) | 조회조건 | Measure Show/Hide 팝업(false); OK→InitSpread | DM0002_TitleSetForm_Popup("DMF0021",false) | — | Always | 426(wire)/4440-4451 |

> ※ 우클릭 컨텍스트 메뉴 없음. Project/Item 선택은 조회조건 버튼[7][8] + 그리드 셀 더블클릭[19]으로만 진입. Version 팝업·Exchange Rate·Price 일괄입력 버튼은 **DMF0021 에 없음**(DMF0082 전용 기능).

---

## 3. 조회조건 컨트롤 (20) — AS-IS 실측

| # | 컨트롤 | 라벨 | 유형 | 초기상태/기본값 | Division 분기 | Cascade | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | clbDivision | Division | **combo (UsrCombo single)** | MyDivision(BigFilter) | 40 vs 81/82 로직 분기 축 | SIC(코드배선) → Team/BizType/EC/Site/Plant 전 cascade + InitSpread | D.56; wire 554; body 5095 |
| 2 | clbTeam | Team | checkbox-list | UserTeamByDivision; ALL | 81/82=부서키 EC / 40=EC40 | SIC → EndCustomer + SalesSite | D.53; wire 803; body 5293 |
| 3 | clbCustomer | End Customer | checkbox-list | EndCustomerByDivision; ALL | — | SIC → SalesSite | D.52; wire 763; body 5084 |
| 4 | clbBizType | Biz Type | checkbox-list | BizType(BigFilter/SCM0001); ALL | 40=DM_BIZ_TYPE / else=SCM0001 | Division 변경 시 재바인딩 | D.51; (무배선) |
| 5 | clbSalesSite | Sales Site | checkbox-list | UserSiteByEndCustomer; ALL | — | Team/Customer 변경 시 재조회 | D.49; (무배선) |
| 6 | clbPlantSite | Plant Site | checkbox-list | UserPlantSiteByEndCustomer/ByDivision | 40 Disable / 81·82 Enable | Division 변경 시 재조회 | D.54; (무배선) |
| 7 | clbItemType | Item Type | checkbox-list | SCM0001 ITEM_TYPE_CODE; ALL | — | — | D.55; (무배선) |
| 8 | cboBucketType | Bucket | combo (Daily/Weekly/Monthly) | DMF0003_GET_BUCKET_TYPE_CODE; **기본 Monthly**(L543) | — | SIC → SetSpreadColumn/border/re-edit(D.568); Click → 편집모드면 MSG00227(D.569) | D.47; wire 568·569; body 3536·5468 |
| 9 | drpPeriod | Period | date range | InitValue=PR_GET_DAY_RANGE(당월~6개월) | — | FindData 검증(from≤to MSG00108, 3년 MSG00164) | D.48; (무배선) |
| 10 | txtProject (+btnProject) | Project | multiline + modal | 빈값; 40 시 Disable | 40 Disable / 81·82 팝업 | KeyDown Enter→btnProject(D.552); 팝업 세팅 | D.46; KeyDown 552; btn D.499 |
| 11 | txtItemId (+btnItemId) | Model | multiline + modal | 빈값 | — | KeyDown Enter→btnItemId(D.553); 팝업 세팅 | D.50; KeyDown 553; btn D.353 |
| 12 | txtOwner (+btnOwner) | Owner | multiline + modal | 빈값 | — | btnOwner 팝업 → txtOwner | D.57; btn D.985 |
| 13 | chkSum | Sum | checkbox | InitControls uncheck(487) | — | **FE 전용** CheckedChanged→SetSpreadColumn(D.389) | D.42; body 4419 |
| 14 | chkColor | Color | checkbox | InitControls uncheck(486) | — | **FE 전용** CheckedChanged→SetSpreadColumn 강조방식 토글(D.281) | D.39; body 5211 |
| 15 | InternalYN | Include Internal Txn | checkbox | (Designer) | — | **SP 파라미터** p_internal_yn (FindData 1553); 핸들러 없음 | (usrLayoutControl3 자식) |
| 16 | cboCellQty | (Qty 옵션) | checkbox | (Designer D.59) | — | 핸들러 미배선(잔재) | D.59; (무배선) |
| 17 | cboKRW | KRW | combo | — | — | **no-op**(금액환산 폐기, SetAmountCalculating 주석) | body 5399 |
| 18 | cboUSD | USD | combo | — | — | **no-op** | body 5409 |
| 19 | cboLOC | LOC | combo | — | — | **no-op** | body 5419 |
| 20 | btnColumn/btnMeasure | (Column/Measure Show) | button | Show/Hide 팝업 | — | 팝업 → InitSpread | D.44/D.43 |

> 그리드 `spdMain`(FpSpread, 시트 "Sales Plan"(shtMain), 헤더 3단 대분류(Qty/KRW/USD/LOC)/월/주·일) 별도. 배선 이벤트 12종(EditModeStarting/On/Off/ClipboardPasted/LeaveCell/EnterCell/CellDoubleClick/ComboSelChange/EditChange/TopChange/TextChanged/KeyUp) + DataModel.Changed(코드배선). 좌측 키 9컬럼 Freeze(SetSpreadHeaderSpan L3744, Measure 우측 고정).

---

## 4. ② User 관점 변환 요지 (시트 5 반영용)

> 개발 세부(메서드명·변수·라인·주석블록·no-op)를 제거하고, **업무 규칙 + MSG 의미**만 남긴 요지. UI분석서 시트5 "상세동작(User)" 에 반영.

### 4.1 화면 성격
- **매출계획(Sales Plan)** 화면. **사업부(Division) 3종**(소형 40 / 자동차 81 / ESS 82)을 한 화면에서 다룬다. 사업부를 바꾸면 그 아래 팀·고객·사이트·사업유형 목록이 모두 다시 채워지고, 소형(40)은 Project·Plant Site 를 쓰지 않아 비활성된다.
- Bucket(일/주/월) 단위로 수량을 보고, 편집 후 저장하면 하위 기간으로의 분배는 **서버가 자동 계산**한다. 기본은 월(Monthly).

### 4.2 조회
- Division 은 필수. 안 고르면 "Division 선택"(MSG00097) 안내.
- 조회 기간 시작일이 종료일보다 늦으면 안 되고(MSG00108), 3년을 초과하면 자동으로 3년으로 줄여준다(MSG00164). 이전 조회가 진행 중이면 "전 작업 실행 중"(MSG00137).
- Team → End Customer → Sales Site 가 위에서 아래로 연동된다. Project/Model/Owner 는 검색 버튼(또는 Enter)으로 팝업에서 고른다(Project 는 자동차/ESS 에서만).
- "Include Internal Txn" 체크는 내부거래 포함 여부(조회 조건).

### 4.3 편집·수량 입력
- 수정하려면 Edit 로 전환. 필수 항목(사업부/고객/사이트/모델/인코텀즈/예측유형/통관/메저/통화, 소형은 팀·셀생산지 추가)이 화면에 없으면 편집 불가(팀 누락 시 MSG00429, 그 외 MSG00113). **일(Daily) 버킷에서는 편집할 수 없다(MSG00361)** — 주(Weekly)·월(Monthly)에서만 가능.
- 편집 가능한 기간은 **금주/당월 이후**. 소형(40)은 당월부터, 그 외 사업부는 당월 다음부터. 가격/기타매출(SalesAmt_LOC)·RTF(RTF_SYS_RP)는 각 권한이 있어야 수정되고, Catch_Up 메저는 **4개월 뒤(M+3 이후)**부터 입력 가능하다. RTF 는 당월이 잠긴다. 지난 실적 구간은 회색으로 잠긴다.
- 월(Monthly) 편집 중에는 주 칸이, 주(Weekly) 편집 중에는 월 칸이 잠긴다(한 축만 입력). 값을 넣으면 그 셀은 빨간색으로 표시된다. **주/월 칸에 넣은 수량의 일자 분배는 저장 시 서버가 수행**한다.
- 편집 중에는 Bucket 을 못 바꾼다(MSG00227).

### 4.4 신규 추가
- **기타매출(SalesAmt_LOC) 편집 권한자만** 행을 추가할 수 있다(권한 없으면 버튼이 조용히 무시됨). 새 행의 메저는 SalesAmt_LOC, 예측유형은 ETC 로 고정되며, 사업부/팀(소형)/고객/사이트/모델/셀생산지/통화를 목록에서 고른다. Project·Model 칸은 셀 더블클릭으로 팝업 선택.

### 4.5 저장·삭제
- 저장은 **확인창 없이 즉시** 진행. 필수 항목이 비면 항목명으로 "필수 입력"(MSG00002), 소형 Catch_Up 에 음수를 넣으면 "0 이상만"(MSG00085), 날짜 값이 없는 행은 "날짜 값 없음"(MSG00146). 성공하면 "N건 저장"(MSG00004) 후 목록을 다시 불러온다. 서버 검증(중복·가격 규칙 등)에 걸리면 서버가 보낸 메시지를 그대로 보여준다.
- 삭제는 **방금 추가한 새 행만** 즉시 사라진다. 이미 저장된 행의 수량 제거는 값을 0으로 저장하는 방식(서버 처리)으로 이루어진다.

### 4.6 보조 기능
- **셀 더블클릭**: 월/주 헤더를 더블클릭하면 하위(주/일) 컬럼이 접히거나 펼쳐진다. 신규 행의 Project 칸(자동차/ESS), 소형 Catch_Up 의 Model 칸은 더블클릭으로 선택 팝업이 뜬다.
- **Column Show / Measure Show**: 화면에 보일 컬럼/메저를 사용자가 고른다. **Sum** 체크는 합계 컬럼 표시 토글, **Color** 체크는 강조 방식(회색 실적 vs 초록 당주) 전환 — 둘 다 조회 데이터에 영향 없음.
- 붙여넣기(Ctrl+V)·복사(Ctrl+C)는 숨김 열을 제외하고 처리되며, 모델을 붙여넣으면 셀생산지 목록이 자동 갱신된다.

---

> **실측 근거**: 본 문서의 모든 라인 번호·파라미터·MSG·분기는 `DMF0021_SalesPlan.cs`(5,599줄 LF, `GSCM.DM.Forms.UIL` 정본) + `.Designer.cs`(1,451줄 LF) 전수 Read 및 grep 교차검증(핸들러 정의 38, FoxDataRequest/GetDMInnerTable call-site 30+, GMessageBox 20, ShowDialog 6) 결과이며, 주석(비활성) 코드·구본(Plan.UIL 3,631 / Shipment 3,912)은 카운트에서 제외하고 활성 코드만 기술함. MSG 문구는 소스 인라인 주석 기준 표기이며, 미확인 건은 TO-BE 반영 전 사내 MSG_M 전수 대사 의무(메모리 `feedback_msg_id_text_reconciliation`).
