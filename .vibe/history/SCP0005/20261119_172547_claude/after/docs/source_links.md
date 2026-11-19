# SCP0005 소스 링크 표

> 경로는 AS-IS 소스 루트(`06.UIL\…`) 기준 상대경로입니다. 줄 번호는 Fact Pack 의 정적 추출값입니다.

약칭
- **M** = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.cs`
- **MD** = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.Designer.cs`
- **P** = `06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.cs`
- **PD** = `06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 14건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | `<field:dtFromCountry>` | 44 | biz:CommonData.CommonDataList [code=COUNTRY_MST] (Data.Common → Data.CallBizCommonData) |
| M | `<field:dtToCountry>` | 46 | biz:CommonData.CommonDataList [code=COUNTRY_MST] |
| M | `<field:dtYesOrNo>` | 48 | biz:CommonData.YesOrNo (Data.Common → Data.CallBizData) |
| M | `<field:dtTransMode>` | 49 | biz:CommonData.CommonDataList [code=LookupCommon] |
| M | `<field:dtValidYN>` | 51 | biz:CommonData.YesOrNo |
| M | FindDataMain | 424 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE |
| M | FindDataReceive | 499 | SCP.SCP0005_GET_DISTRIBUTION_ROUTEID |
| M | SaveData | 752 | SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE |
| M | GetData_Country | 916 | SCP.SCP0005_GET_COUNTRY_CITY |
| M | GetFromSitebyDivision | 1187 | biz:CommonData.CommonDataList [code=FromSiteByDivision] |
| M | GetToSitebyDivision | 1195 | biz:CommonData.CommonDataList [code=ToSiteByDivision] |
| M | GetBodType | 1207 | biz:CommonData.CommonDataList [code=BodType] |
| M | GetTransMode | 1217 | biz:CommonData.CommonDataList [code=TransportMode] |
| P | FindData | 171 | SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| P | .ctor | 98 | `this.Load += Form_Load` |
| M | .ctor | 144 | `this.Load += Form_Load` |
| MD | InitializeComponent | 244 | `this.btnToSrch.Click += btnToSrch_Click` |
| MD | InitializeComponent | 280 | `this.btnFromSrch.Click += btnFromSrch_Click` |
| MD | InitializeComponent | 327 | `this.btnExcel_Form.Click += btnExcel_Form_Click` |
| M | InitEvent | 187 | `spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| M | InitEvent | 189 | `this.btnEaxel_Upload.Click += btnEaxel_Upload_Click` |
| M | InitEvent | 192 | `dsdm.Changed += spdMainDataModel_Changed` |
| M | spdMainDataModel_Changed | 970 | `dsdm.Changed -= spdMainDataModel_Changed` |
| M | spdMainDataModel_Changed | 1082 | `dsdm.Changed += spdMainDataModel_Changed` |
| M | spdMain_CellDoubleClick | 1135 | `dsdm.Changed -= spdMainDataModel_Changed` |
| M | spdMain_CellDoubleClick | 1164 | `dsdm.Changed += spdMainDataModel_Changed` |

## 3. Grid 생성 / 메타 소비 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| P | CreateSpread | 122 | AddSheet `POPUP` (args: … ¦ POPUP ¦ POPUP ¦ 2 ¦ 1 ¦ 30) |
| P | CreateSpread | 123 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| P | CreateSpread | 125 | ChangeSheet |
| P | InitSpread | 134 | InitSheet — `if(spreadInfo.SheetName == "POPUP")` |
| P | InitSpread | 136 | SetSheetHeaderColumn(spreadInfo, 2) — 메타 컬럼 생성 |
| PD | InitializeComponent | 65~68 | ColumnHeader 기본 스타일(HorizontalAlignment/NoteIndicatorColor/Parent/VerticalAlignment) |
| M | CreateSpread | 233 | AddSheet `Distribution Route` (args: … ¦ Distribution Route ¦ Distribution Route ¦ 2 ¦ 1 ¦ 30) |
| M | CreateSpread | 234 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| M | CreateSpread | 236 | ChangeSheet |
| M | InitSpread | 245 | InitSheet — `if(spreadInfo.SheetName == "Distribution Route")` |
| M | InitSpread | 246 | SetSheetHeaderColumn(spreadInfo, 2) — 메타 컬럼 생성 |
| M | EditButton | 318 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) — `if(this.fps != null) ⟫ if(fps.Name == "spdMain")` |
| M | SaveButton | 333 | SaveData 호출(4-2 표에서 PersonalSettingPopup.SaveData 로 매핑됨 — 확인 필요) |
| M | FindDataMain | 404 | CString.GetCheckedListValue — 메타 컬럼 CODE |
| M | FindDataMain | 452 | local:SetSpreadColumn(siMain) — `if(ds != null && ds.Tables[0].Rows.Count > 0)` |
| M | FindDataReceive | 521 | local:SetSpreadColumn(siMain) — 같은 조건 |
| MD | InitializeComponent | 515~518 | ColumnHeader 기본 스타일 |

## 4. 컨트롤 값 / 데이터 컬럼 사용 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | `<field:UserGroup>` | 60 | UserInfoContext.Current["NowGroupID"] |
| M | CSafeSetText | 162 | `ctl.Text = text` |
| M | InitControls | 208 | c["ControlName"] |
| M | InitControls | 210 | ManualSearchCondition.Tables[0].Rows[0]["ControlValue"] |
| M | btnFromSrch_Click | 350 | `txtFromCountry.Text = popCity.Country` |
| M | btnFromSrch_Click | 351 | `txtFromCity.Text = popCity.City` |
| M | btnToSrch_Click | 368 | `txtToCountry.Text = popCity.Country` |
| M | btnToSrch_Click | 369 | `txtToCity.Text = popCity.City` |
| M | SaveData | 871 | dtErr.Rows[0]["ERR_MESSAGE"] |
| M | SetCityCode | 1350~1352 | drsFrom[0]["COUNTRY" / "CITY" / "CITY_NAME"] |
| M | SetCityCode | 1365~1367 | drsTo[0]["COUNTRY" / "CITY" / "CITY_NAME"] |

## 5. 컨트롤 선언 위치 (Designer)

| 파일 | 줄 | 컨트롤 | 유형 |
|---|---:|---|---|
| PD | 31 | spdMain | FarPoint.Win.Spread.FpSpread |
| PD | 32 | spdMain_Sheet1 | SheetView |
| MD | 33 | usrLayoutControl1 | UsrLayoutControl |
| MD | 34 | layoutControlGroup1 | LayoutControlGroup |
| MD | 35 | usrConditionPanel1 | UsrConditionPanel |
| MD | 36 | usrLayoutControl2 | UsrLayoutControl |
| MD | 37 | cboValidYN | UsrCombo |
| MD | 38 | clbTransMode | UsrCheckedList |
| MD | 39 | btnToSrch | UsrButton |
| MD | 40 | btnFromSrch | UsrButton |
| MD | 41~44 | txtFromCountry, txtFromCity, txtToCountry, txtToCity | TextBox |
| MD | 45 | btnEaxel_Upload | SimpleButton |
| MD | 46 | btnExcel_Form | SimpleButton |
| MD | 47~59 | layoutControlGroup2, emptySpaceItem1/4, layoutControlItem1~10 | DevExpress Layout |
| MD | 60 | spdMain | FpSpread |
| MD | 61 | spdMain_Sheet1 | SheetView |
| MD | 62 | imageList1 | ImageList |
