# SSP0024 소스 링크 (파일·줄 기준)

> 경로 기준: AS-IS GSCM 소스 루트 아래 `06.UIL/GSCM.SSP.Plan.UIL/`. 줄 번호는 Fact Pack 추출값입니다.
> 약어: **MAIN** = `06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs`, **MAIN.D** = `…/SSP0024_ShipmentMasterElectrode.Designer.cs`, **POP** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs`, **POP.D** = `…/Popup/SSP0024_ItembyDivisionPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 13건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [POP:267](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L267) | FindData | 267 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` (fox, MATCH) |
| [POP:405](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L405) | GetDivision | 405 | `SCM.SCM0001_GET_DIVISION` (fox, MATCH) |
| [POP:415](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L415) | GetDivisionbyPlantSiteCode | 415 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] (Data.Common → Data.CallBizCommonData) |
| [MAIN:37](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L37) | `<field:dtMyDivision>` | 37 | `biz:CommonData.CommonDataList` [code=MyDivision]. `UserInfoContext.Current["NowGroupID"]`를 읽음 |
| [MAIN:41](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L41) | `<field:dtPlantSiteByFactoryForSpread>` | 41 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] |
| [MAIN:49](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L49) | `<field:dtElectrodePostOperCode>` | 49 | `biz:CommonData.CommonDataList` [code=ElectrodePostOperCode] |
| [MAIN:51](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L51) | `<field:dtDomExpTypeCode>` | 51 | `biz:CommonData.CommonDataList` [code=DomExpTypeCode] |
| [MAIN:52](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L52) | `<field:dtBuilding>` | 52 | `biz:CommonData.CommonDataList` [code=BuildingForShipMasterElec] |
| [MAIN:55](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L55) | `<field:dtElectrodePackageType>` | 55 | `biz:CommonData.CommonDataList` [code=ElectrodePackageType] |
| [MAIN:191](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L191) | SetChangedControl | 191 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] |
| [MAIN:316](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L316) | FindData | 316 | `SSP.SSP0024_GET_SHIP_MASTER` (fox, MATCH) |
| [MAIN:467](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L467) | SaveData | 467 | `SSP.SSP0024_SAVE_SHIP_MASTER` (fox, MATCH) |
| [MAIN:883](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L883) | GetSSPUserCheck | 883 | `SSP.SSP0002_GET_USER_INFO_LIST` (fox, MATCH) |

## 2. 이벤트 배선 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [POP.D:184](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L184) | InitializeComponent | 184 | `this.clbDivisionId.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| [POP.D:277](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L277) | InitializeComponent | 277 | `this.btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected` |
| [POP.D:357](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L357) | InitializeComponent | 357 | `this.spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| [POP:156](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L156) | .ctor | 156 | `this.Load += Form_Load` |
| [MAIN:109](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L109) | .ctor | 109 | `this.Load += Form_Load` |
| [MAIN:177](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L177) | InitControls | 177 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| [MAIN:178](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L178) | InitControls | 178 | `spdMain.CellClick += SpdMain_CellClick` |
| [MAIN:179](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L179) | InitControls | 179 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| [MAIN:180](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L180) | InitControls | 180 | `spdMain.ClipboardPasted += SpdMain_ClipboardPasted` |
| [MAIN:181](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L181) | InitControls | 181 | `spdMain.KeyPress += SpdMain_KeyPress` |
| [MAIN:183](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L183) | InitControls | 183 | `this.btnMaterialId.Click += BtnMaterialId_Click` |
| [MAIN:184](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L184) | InitControls | 184 | `this.btnModelId.Click += BtnModelId_Click` |

## 3. Grid 정의 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [POP:202](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L202) | CreateSpread | 202 | AddSheet `Project` (SpdSheet.shtMain, 1, 1, 30) |
| [POP:203](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L203) | CreateSpread | 203 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| [POP:204](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L204) | CreateSpread | 204 | ChangeSheet |
| [POP:211](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L211) | InitSpread | 211 | InitSheet(siMain.SheetName) |
| [POP:214](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L214) | InitSpread | 214 | AddTextColumn DIVISION_ID (w60, visible, Center) |
| [POP:215](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L215) | InitSpread | 215 | AddTextColumn DIVISION_NAME (w80, **visible=false**) |
| [POP:216](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L216) | InitSpread | 216 | AddTextColumn PLANT_SITE_CODE (w80) |
| [POP:217](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L217) | InitSpread | 217 | AddTextColumn PLANT_SITE_ID (w80, Center) |
| [POP:218](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L218) | InitSpread | 218 | AddTextColumn MATERIAL_ID (w100, Center) |
| [POP:219](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L219) | InitSpread | 219 | AddTextColumn MODEL_ID (w150, Center) |
| [POP:220](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L220) | InitSpread | 220 | AddTextColumn CELL_TYPE (w80, Center) |
| [POP:221](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L221) | InitSpread | 221 | AddTextColumn NICK_NAME (w150, Center) |
| [POP:222](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L222) | InitSpread | 222 | AddTextColumn ELECTRODE_TYPE (w80, Center) |
| [POP:223](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L223) | InitSpread | 223 | AddTextColumn ITEM_UOM (w60, Center) |
| [POP:224](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L224) | InitSpread | 224 | AddTextColumn UOM_CONVERT_IN_TACT_TIME (w120) |
| [POP.D:373](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L373) | InitializeComponent | 373~376 | ColumnHeader 스타일 override(H/V Align General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |
| [MAIN:206](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L206) | CreateSpread | 206 | AddSheet `Ship Master Elec` (SpdSheet.shtMain, 1, 1, 30) |
| [MAIN:207](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L207) | CreateSpread | 207 | GetSheetInfo |
| [MAIN:208](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L208) | CreateSpread | 208 | ChangeSheet |
| [MAIN:215](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L215) | InitSpread | 215 | InitSheet(siMain.SheetName) |
| [MAIN:221](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L221) | InitSpread | 221 | `SetSheetHeaderColumn(siMain, 1)` — 메타 컬럼 생성 |
| [MAIN:252](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L252) | EditButton | 252 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| [MAIN:374](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L374) | InsertRow | 374 | SetCellTypeCombo DIVISION_ID ← dtMyDivisionIns |
| [MAIN:375](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L375) | InsertRow | 375 | SetCellTypeCombo PLANT_SITE_ID ← dtPlantSiteByFactoryForSpread |
| [MAIN:376](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L376) | InsertRow | 376 | SetCellTypeCombo POST_OPER ← dtElectrodePostOperCode |
| [MAIN:377](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L377) | InsertRow | 377 | SetCellTypeCombo BUILDING ← dtBuilding |
| [MAIN:700](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L700) | SpdMain_ClipboardPasted | 700 | SetCellTypeCombo PLANT_SITE_ID ← dtEmpty (DIVISION_ID 빈값일 때) |
| [MAIN:852](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L852) | SetCellCombo | 852 | SetCellTypeCombo(nRow, nCol, dtRstDataTable), 조건 `"" != pdivision` |
| [MAIN.D:469](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.Designer.cs#L469) | InitializeComponent | 469~472 | ColumnHeader 스타일 override(팝업과 같은 4항목) |

## 4. 메타·데이터 컬럼 읽기 / 컨트롤 값 변경
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [MAIN:136](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L136) | DefineProperty | 136 | `dr["CODE"]` |
| [MAIN:147](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L147) | DefineProperty | 147~148 | `drRow["CODE"]`, `drRow["NAME"]`, `dr["CODE"]` |
| [MAIN:156](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L156) | DefineProperty | 156~157 | `drAllRow["CODE"]`, `drAllRow["NAME"]` |
| [MAIN:189](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L189) | SetChangedControl | 189 | GetCheckedListValue (CODE) |
| [MAIN:194](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L194) | SetChangedControl | 194~195 | `txtMaterialId.Text = ""`, `txtModelId.Text = ""` |
| [MAIN:282](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L282) | SaveButton | 282 | SaveData 호출(4-2절은 PersonalSettingPopup.SaveData로 매핑 — 확인 필요) |
| [MAIN:301](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L301) | FindData | 301~302 | GetCheckedListValue ×2 |
| [MAIN:355](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L355) | Re_Design | 355~357 | GetCheckedListValue, `c["DIVISION_ID"]` |
| [MAIN:379](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L379) | InsertRow | 379 | GetCheckedListValue |
| [MAIN:612](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L612) | SpdMain_ComboSelChange | 612~621 | `c["CODE"]`, `row.Field("DIVISION_ID")`, `row.Field("CODE")`, `drOperLT["POST_OPER_LT"]` |
| [MAIN:746](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L746) | BtnMaterialId_Click | 746 | `txtMaterialId.Text = sMaterialId` |
| [MAIN:767](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L767) | BtnModelId_Click | 767 | `txtModelId.Text = sModelId` |
| [MAIN:838](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L838) | SetCellCombo | 838~847 | `drRow/dr["CODE"]`, `drRow/dr["NAME"]` |
| [MAIN:865](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L865) | GetSelectedListName | 865 | `dt.Rows[i]["CODE"]` |
| [POP:188](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L188) | InitControls | 188 | `txtMaterialId.Text = sMaterial` |
| [POP:190](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L190) | InitControls | 190~191 | `clbDivisionId.Enabled = false`, `clbPlantSiteId.Enabled = false` |
