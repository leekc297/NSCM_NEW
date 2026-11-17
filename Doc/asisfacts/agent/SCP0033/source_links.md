# SCP0033 소스 링크

기준 폴더: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0033_Shipment_semi_dept_day\`

## 1. 엔드포인트 호출 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0033_Shipment_semi_dept_day.cs | `<field:dtDepartureDay>` | 43 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common → Data.CallBizCommonData) |
| SCP0033_Shipment_semi_dept_day.cs | `<field:dtYesOrNo>` | 44 | `biz:CommonData.YesOrNo` (Data.Common → Data.CallBizData) |
| SCP0033_Shipment_semi_dept_day.cs | FindData_Main | 258 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| SCP0033_Shipment_semi_dept_day.cs | SaveData_Main | 380 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |

## 2. 이벤트 등록

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0033_Shipment_semi_dept_day.cs | .ctor | 83 | `this.Load += Form_Load` |
| SCP0033_Shipment_semi_dept_day.cs | .ctor | 84 | `this.spdMain.CellClick += SpdMain_CellClick` |
| SCP0033_Shipment_semi_dept_day.cs | .ctor | 85 | `this.spdMain.KeyPress += SpdMain_KeyPress` |
| SCP0033_Shipment_semi_dept_day.cs | InitEvent | 107 | `spdMain.TopChange += SpdMain_TopChange` |

## 3. Grid·메타 관련

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0033_Shipment_semi_dept_day.cs | CreateSpread | 147 | AddSheet (spdMain, SpdSheet.shtMain = "Shipment Semi Dept Day", 1, 1, 30) |
| SCP0033_Shipment_semi_dept_day.cs | CreateSpread | 148 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| SCP0033_Shipment_semi_dept_day.cs | CreateSpread | 149 | ChangeSheet |
| SCP0033_Shipment_semi_dept_day.cs | InitSpread | 156 | InitSheet(siMain.SheetName) |
| SCP0033_Shipment_semi_dept_day.cs | InitSpread | 161 | SetSheetHeaderColumn(siMain, 1): 메타 컬럼 생성 |
| SCP0033_Shipment_semi_dept_day.cs | InsertButton | 204 | SetCellTypeCombo(ActiveRowIndex, DIVISION_ID, dtMyDivision = BLUtils.GetDivision(false, "")) |
| SCP0033_Shipment_semi_dept_day.cs | EditButton | 219 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| SCP0033_Shipment_semi_dept_day.cs | FindData_Main | 241, 242, 244 | GetCheckedListValue (CODE) |
| SCP0033_Shipment_semi_dept_day.Designer.cs | InitializeComponent | 270~273 | 컬럼 헤더 스타일 (Horizontal/VerticalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 컨트롤 선언 (Designer.cs)

| 파일 | 컨트롤 | 줄 |
|---|---|---:|
| Designer.cs | usrLayoutControl1 / layoutControlGroup1 / usrConditionPanel1 / usrLayoutControl2 | 33 / 34 / 35 / 36 |
| Designer.cs | cboValidYN / txtItemId / clbDivision | 37 / 38 / 39 |
| Designer.cs | layoutControlGroup2 / layoutControlItem13 / emptySpaceItem3 / layoutControlItem3 / layoutControlItem4 | 40 / 41 / 42 / 43 / 44 |
| Designer.cs | spdMain / spdMain_Sheet1 / imageList1 | 45 / 46 / 47 |
