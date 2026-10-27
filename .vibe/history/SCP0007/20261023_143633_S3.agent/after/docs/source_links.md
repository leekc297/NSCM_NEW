# SCP0007 소스 링크 표

> 경로 기준: `06.UIL/` (GSCM AS-IS 소스 루트). 줄 번호는 Fact Pack 추출값이다.
> 약어: **BOD.cs** = `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs`, **BOD.Designer.cs** = 같은 폴더의 Designer, **POP.cs** = `06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs`, **POP.Designer.cs** = 같은 폴더의 Designer

## 1. 엔드포인트 호출 지점 (전수 18건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L65](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L65) | `<field:dtIncoterms>` | 65 | biz:CommonData.CommonDataList [code=LookupCommon] |
| [BOD.cs#L66](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L66) | `<field:dtTransMode>` | 66 | biz:CommonData.CommonDataList [code=LookupCommon] |
| [BOD.cs#L68](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L68) | `<field:dtValidYN>` | 68 | biz:CommonData.YesOrNo |
| [BOD.cs#L69](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L69) | `<field:dtIncotermsEdit>` | 69 | biz:CommonData.CommonDataList [code=incotermsEdit] |
| [BOD.cs#L553](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L553) | FindData_Main | 553 | SCP.SCP0007_GET_BOD |
| [BOD.cs#L626](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L626) | GetData_Country | 626 | SCP.SCP0007_GET_COUNTRY_CITY |
| [BOD.cs#L794](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L794) | SaveData_Main | 794 | SCP.SCP0007_SAVE_BOD |
| [BOD.cs#L1448](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1448) | SetCityCode | 1448 | SCP.SCP0007_GET_ROUTE_CNT |
| [POP.cs#L44](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L44) | `<field:dtFromCountry>` | 44 | biz:CommonData.CommonDataList [code=COUNTRY_MST] |
| [POP.cs#L46](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L46) | `<field:dtToCountry>` | 46 | biz:CommonData.CommonDataList [code=COUNTRY_MST] |
| [POP.cs#L48](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L48) | `<field:dtYesOrNo>` | 48 | biz:CommonData.YesOrNo |
| [POP.cs#L49](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L49) | `<field:dtTransMode>` | 49 | biz:CommonData.CommonDataList [code=LookupCommon] |
| [POP.cs#L436](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L436) | FindDataMain | 436 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE |
| [POP.cs#L540](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L540) | GetDivision | 540 | biz:CommonData.CommonDataList [code=MyDivision] |
| [POP.cs#L549](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L549) | GetFromSitebyDivision | 549 | biz:CommonData.CommonDataList [code=FromSiteByDivision] |
| [POP.cs#L557](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L557) | GetToSitebyDivision | 557 | biz:CommonData.CommonDataList [code=ToSiteByDivision] |
| [POP.cs#L569](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L569) | GetBodType | 569 | biz:CommonData.CommonDataList [code=BodType] |
| [POP.cs#L579](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L579) | GetTransMode | 579 | biz:CommonData.CommonDataList [code=TransportMode] |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L157](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L157) | .ctor | 157 | this.Load += Form_Load |
| [BOD.cs#L176](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L176) | InitEvent | 176 | clbDivision.SelectedIndexChanged += cboDivision_SelectedIndexChanged |
| [BOD.cs#L178](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L178) | InitEvent | 178 | spdMain.CellDoubleClick += spdMain_CellDoubleClick |
| [BOD.cs#L179](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L179) | InitEvent | 179 | spdMain.TopChange += SpdMain_TopChange |
| [BOD.cs#L180](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L180) | InitEvent | 180 | spdMain.ComboSelChange += SpdMain_ComboSelChange |
| [BOD.cs#L181](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L181) | InitEvent | 181 | spdMain.ClipboardPasted += SpdMain_ClipboardPasted |
| [BOD.cs#L182](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L182) | InitEvent | 182 | spdMain.KeyPress += SpdMain_KeyPress |
| [BOD.cs#L183](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L183) | InitEvent | 183 | spdMain.EditChange += SpdMain_EditChange |
| [BOD.cs#L186](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L186) | InitEvent | 186 | dsdm.Changed += SpdMain_Changed |
| [BOD.cs#L1073](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1073) | spdMain_CellDoubleClick | 1073 | dsdm.Changed -= SpdMain_Changed |
| [BOD.cs#L1104](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1104) | spdMain_CellDoubleClick | 1104 | dsdm.Changed += SpdMain_Changed |
| [BOD.cs#L1284](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1284) | SpdMain_Changed | 1284 | dsdm.Changed -= SpdMain_Changed |
| [BOD.cs#L1315](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1315) | SpdMain_Changed | 1315 | dsdm.Changed += SpdMain_Changed |
| [POP.Designer.cs#L168](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.Designer.cs#L168) | InitializeComponent | 168 | btnToSrch.Click += btnToSrch_Click |
| [POP.Designer.cs#L238](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.Designer.cs#L238) | InitializeComponent | 238 | btnFromSrch.Click += btnFromSrch_Click |
| [POP.Designer.cs#L394](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.Designer.cs#L394) | InitializeComponent | 394 | btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected |
| [POP.cs#L149](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L149) | .ctor | 149 | this.Load += Form_Load |
| [POP.cs#L201](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L201) | InitEvent | 201 | spdMain.CellDoubleClick += spdMain_CellDoubleClick |
| [POP.cs#L203](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L203) | InitEvent | 203 | dsdm.Changed += spdMainDataModel_Changed |
| [POP.cs#L489](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L489) | spdMainDataModel_Changed | 489 | dsdm.Changed -= spdMainDataModel_Changed |
| [POP.cs#L521](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L521) | spdMainDataModel_Changed | 521 | dsdm.Changed += spdMainDataModel_Changed |

## 3. Grid 구성 / 메타 소비 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L262](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L262) | CreateSpread | 262 | AddSheet("BOD", 2, 1, 30) |
| [BOD.cs#L271](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L271) | InitSpread | 271 | InitSheet(siMain.SheetName) |
| [BOD.cs#L275](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L275) | InitSpread | 275 | SetSheetHeaderColumn(siMain, 2): 메타 컬럼 생성 |
| [BOD.cs#L277](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L277) | InitSpread | 277 | CellType = cellTypeImage |
| [BOD.cs#L338](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L338) | InitSpread | 338 | SAFETY_STOCK Visible = false |
| [BOD.cs#L240](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L240) | SetChangeControl | 240 | GetCheckedListValue (CODE) |
| [BOD.cs#L517](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L517) | FindData_Main | 517, 518, 530~534 | GetCheckedListValue (CODE): 조회 파라미터 |
| [BOD.cs#L387](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L387) | InsertButton | 387 | SetCellTypeCombo DIVISION_ID ← dtMyDivision |
| [BOD.cs#L424](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L424) | InsertButton | 424, 425 | SetCellTypeCombo INCOTERMS / INCOTERMS_SSP ← dtIncotermsEdit |
| [BOD.cs#L450](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L450) | EditButton | 450 | GetSheetInfo |
| [BOD.cs#L476](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L476) | EditButton | 476 | drsTo[0]["SITE_TYPE"] |
| [BOD.cs#L484](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L484) | EditButton | 484, 490 | SetCellTypeCombo INCOTERMS_SSP (incotermsEdit / LookupCommon "INCOTERMS") |
| [BOD.cs#L1146](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1146) | SpdMain_ComboSelChange | 1146, 1154 | SetCellTypeCombo TO_SITE_CODE ← dtToSiteOfSpd |
| [POP.cs#L247](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L247) | CreateSpread | 247 | AddSheet("Distribution Route", 2, 1, 30) |
| [POP.cs#L264](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L264) | InitSpread | 264~297 | 하드코딩 Add*Column 33개 |
| [POP.cs#L301](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L301) | InitSpread | 301~335 | ColumnHeaderSpan 2단 헤더 |

## 4. DB 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L55](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L55) | `<field:dtFromSiteAll>` | 55 | UserInfoContext.Current.NowGroupID |
| [BOD.cs#L60](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L60) | `<field:dtFromSiteOfSpdAll>` | 60 | NowGroupID |
| [BOD.cs#L63](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L63) | `<field:dtToSiteOfSpdAll1>` / `2` | 63, 64 | NowGroupID |
| [BOD.cs#L930](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L930) | SaveData_Main | 930 | dtErr.Rows[0]["ERR_MESSAGE"] |
| [BOD.cs#L1068](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1068) | spdMain_CellDoubleClick | 1068~1089 | dr: ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~SUN, VALID_YN, LT_SUM, LT_TYPE |
| [BOD.cs#L1140](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1140) | SpdMain_ComboSelChange | 1140, 1165, 1176 | dr: OSP_YN, CITY |
| [BOD.cs#L1218](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1218) | SpdMain_ClipboardPasted | 1218, 1245, 1255 | dr: OSP_YN, CITY |
| [BOD.cs#L1344](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1344) | SpdMain_EditChange | 1344 | drsTo[0]["SITE_TYPE"] |
| [BOD.cs#L1368](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1368) | SetCityCode | 1368~1383 | drsFrom: COUNTRY, CITY / drsTo: COUNTRY, CITY, VMI_YN, SITE_TYPE |
| [BOD.cs#L1460](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1460) | SetCityCode | 1460 | ds.Tables[0].Rows[0]["route_cnt"] |
| [POP.cs#L58](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L58) | `<field:UserGroup>` | 58 | NowGroupID |
| [POP.cs#L214](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L214) | InitControls | 214~229 | 조건 컨트롤 Enabled=false, Text ← sFromCountry/sFromCity/sToCountry/sToCity |
| [POP.cs#L689](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L689) | btnFromSrch_Click | 689, 690 | txtFromCountry/City ← popCity.Country/City |
| [POP.cs#L707](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L707) | btnToSrch_Click | 707, 708 | txtToCountry/City ← popCity.Country/City |
