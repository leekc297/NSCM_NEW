# AS-IS 액션 대조표 — FP00210

> 원천: `Doc/asisfacts/screens/FP00210/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 239행 · 메서드 36 · 종류 DATA_OP 55 · UI_PROP 36 · FLAG 30 · GRID_INIT 26 · RETURN 17 · CALL_EXT 14 · UI_MISC 11 · ENDPOINT 9 · POPUP 8 · GRID_LOCK 5 · LIST_REBIND 5 · STATE 4 · COMBO_DATA 4 · GRID_BIND 3 · THROW 3 · MESSAGE 2 · VALIDATE 2 · CALL_BASE 2 · EXCEL 1 · GRID_CLEAR 1 · GRID_SET 1 · ⚠ 의미 확인 필요 16


## clsFP00210_Search_Cond.Clear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b7efce6 | (진입점 미연결) | FP00210_BOM.cs:856 |  | FLAG | this.COMPANY_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4f94b5c9 | (진입점 미연결) | FP00210_BOM.cs:857 |  | FLAG | this.DIVISION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-6aceb197 | (진입점 미연결) | FP00210_BOM.cs:858 |  | FLAG | this.SITE_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f67e107c | (진입점 미연결) | FP00210_BOM.cs:859 |  | FLAG | this.PLANT_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-55ea4869 | (진입점 미연결) | FP00210_BOM.cs:860 |  | FLAG | this.PARENT_ITEM_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP00210_BOM.btnBom_Click

진입점: this.btnBom.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7212ccd | this.btnBom.Click | FP00210_BOM.cs:867 |  | DATA_OP | Filter["COMPANY_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f3a437a7 | this.btnBom.Click | FP00210_BOM.cs:868 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-25ebead3 | this.btnBom.Click | FP00210_BOM.cs:869 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-a94707e8 | this.btnBom.Click | FP00210_BOM.cs:870 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-bf400b3a | this.btnBom.Click | FP00210_BOM.cs:871 |  | DATA_OP | Filter["PARENT_ITEM_ID"] | txtParentItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9dee05c7 | this.btnBom.Click | FP00210_BOM.cs:872 |  | DATA_OP | Filter["CHILD_ITEM_ID"] | txtChildItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-58d68339 | this.btnBom.Click | FP00210_BOM.cs:873 |  | DATA_OP | Filter["PARENT_NICK_NAME"] | txtParentNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e24275cf | this.btnBom.Click | FP00210_BOM.cs:874 |  | DATA_OP | Filter["CHILD_NICK_NAME"] | txtChildNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b6c22855 | this.btnBom.Click | FP00210_BOM.cs:876 |  | POPUP | new FP00210_BOMViewPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f27c96d6 | this.btnBom.Click | FP00210_BOM.cs:877 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e9a69dba | this.btnBom.Click | FP00210_BOM.cs:877 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04885806 | this.btnBom.Click | FP00210_BOM.cs:878 |  | UI_PROP | popup.Width | 830 | 속성 Width 설정 |  |  |  |
| AC-29374e7a | this.btnBom.Click | FP00210_BOM.cs:879 |  | UI_PROP | popup.Height | 530 | 속성 Height 설정 |  |  |  |
| AC-0c2ff4c9 | this.btnBom.Click | FP00210_BOM.cs:880 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8534250a | this.btnBom.Click | FP00210_BOM.cs:882 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-3ec10090 | this.btnBom.Click | FP00210_BOM.cs:884 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00210_BOM.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faa9e0d2 | this.btnSql.Click | FP00210_BOM.cs:356 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-59c4f89b | this.btnSql.Click | FP00210_BOM.cs:357 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cb117178 | this.btnSql.Click | FP00210_BOM.cs:359 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00210_BOM") | 데이터 객체 조작/조회 |  |  |  |
| AC-33e11665 | this.btnSql.Click | FP00210_BOM.cs:360 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00210_BOM.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5691cc0 | (진입점 미연결) | FP00210_BOM.cs:739 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOM.ClbDivision_SelectedIndexChanged

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b6c8bf3 | this.Load 외 1 | FP00210_BOM.cs:666 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6f2cd603 | this.Load 외 1 | FP00210_BOM.cs:668 |  | UI_PROP | clbSite.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00210_BOM.ClbSite_SelectedIndexChanged

진입점: this.Load / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0bc1389 | this.Load 외 1 | FP00210_BOM.cs:673 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-359e1663 | this.Load 외 1 | FP00210_BOM.cs:675 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00210_BOM.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a168b3d1 | this.Load | FP00210_BOM.cs:264 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b892be67 | this.Load | FP00210_BOM.cs:265 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c79282f6 | this.Load | FP00210_BOM.cs:269 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8ce87852 | this.Load | FP00210_BOM.cs:270 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-a5607011 | this.Load | FP00210_BOM.cs:272 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4aa692f | this.Load | FP00210_BOM.cs:275 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00210_BOM.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24e9e03e | this.Load | FP00210_BOM.cs:160 |  | UI_PROP | siMain.ImagePopUp | imgList.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-dd9b20e4 | this.Load | FP00210_BOM.cs:162 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-82e31dcd | this.Load | FP00210_BOM.cs:163 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-deec3404 | this.Load | FP00210_BOM.cs:164 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-ae5526ce | this.Load | FP00210_BOM.cs:166 |  | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f74c5ff1 | this.Load | FP00210_BOM.cs:173 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0cf63c2f | this.Load | FP00210_BOM.cs:174 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-586ed696 | this.Load | FP00210_BOM.cs:175 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-af813577 | this.Load | FP00210_BOM.cs:179 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2619b48a | this.Load | FP00210_BOM.cs:180 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4142285a | this.Load | FP00210_BOM.cs:181 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00210_BOM.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2b57a6f | Dispose | FP00210_BOM.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00210_BOM.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9699654f | EditButton | FP00210_BOM.cs:333 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOM.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85ccc25f | ExcelButton | FP00210_BOM.cs:349 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00210_BOM.Find_Data

진입점: FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdMain":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7fc6830 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:368 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ef2357bf | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:374 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c1f67b1 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:375 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-238e5df1 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:378 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0d450204 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:380 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-47fc37fa | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:380 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dbdfa82c | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:386 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e9af61dd | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:393 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-60e2d84a | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:395 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b85cc770 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:405 | try | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-339aefe2 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:407 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-67d2d440 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:408 | try | CALL_EXT | siMain.SetFormat | ("#,##0.######", 6, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c322ff2f | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:409 | try | CALL_EXT | siMain.SetFormat | ("#,##0.######", 9, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8ccb1e4 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:410 | try | CALL_EXT | siMain.SetFormat | ("#,##0.######", 12, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3400c21b | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:411 | try | CALL_EXT | siMain.SetFormat | ("####-##-##", 14, 2, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-032a9227 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:414 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-01eb7693 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:417 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fb1e1b3b | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:430 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8892353f | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:431 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-566f5e16 | FindButton [if (this.fps != null) ▸ switch (fps.Name) case "… | FP00210_BOM.cs:432 | finally | GRID_CLEAR | SpreadInfo.ClearDataSource | (siSub.SpreadObject) | 그리드 데이터/선택 비움 |  |  |  |

## FP00210_BOM.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] / FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-665ff332 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:603 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pCompanyID = ""; pDivisionID = CString.GetCheckedListValu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e200a637 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:606 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d5aaf9d | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:607 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-312de09d | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:608 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f2cb20a | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:631 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00210_BOM") ⇒ FP_Master.PR_UI_FP00210_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-7196863e | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:632 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b77cca16 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:633 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-4a182dfe | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:634 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-225fd117 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:635 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6724ef95 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:636 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-7e8ffced | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:638 | try | DATA_OP | request.Parameters["p_company_id"] | pCompanyID.Equals("ALL") ? DBNull.Value : pCompanyID | 행/컬럼 값 대입 |  |  |  |
| AC-864b8f54 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:639 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-3ebe0b48 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:640 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-7b956f94 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:641 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-6fa8c0a6 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:642 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f376c63c | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:643 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-08095846 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:644 | try | DATA_OP | request.Parameters["p_child_item_id"] | pChildItemId.Equals("ALL") ? DBNull.Value : pChildItemId | 행/컬럼 값 대입 |  |  |  |
| AC-d5cce006 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:645 | try | DATA_OP | request.Parameters["p_child_nick_name"] | pChildNickName.Equals("ALL") ? DBNull.Value : pChildNickName | 행/컬럼 값 대입 |  |  |  |
| AC-944a7da7 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:647 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b184d714 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:649 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9d1bd5f1 | popSql.OnSql [if (programID == "PR_UI_FP00210_BOM")] 외 1 | FP00210_BOM.cs:656 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00210_BOM.Find_Data_Sub

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdSub":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-567b0d3b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:442 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4b2197a5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:447 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ca7491fd | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:447 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c098021f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:450 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7f2b6cd | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:451 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-305d1121 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:454 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8384df3b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:459 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5aaaa2d1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:466 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-40780117 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:468 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Sub_Execute(true, search, queryFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e5cfe73 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:478 | try | GRID_BIND | siSub.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-928ab2bb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:480 | try | CALL_EXT | siSub.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-39d5e7f3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:481 | try | CALL_EXT | siSub.SetFormat | ("#,##0.######", 9, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-721bdbf6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:482 | try | CALL_EXT | siSub.SetFormat | ("#,##0.######", 11, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4888585d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:483 | try | CALL_EXT | siSub.SetFormat | ("####-##-##", 13, 2, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c801cceb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:488 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bbd2e78c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:491 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c1f1d1dd | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:505 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2529c9c9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:506 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00210_BOM.Find_Data_Sub_Execute

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try ▸ lambda] / FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f1876e0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:523 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pCompanyID = ""; pDivisionID = CString.GetCheckedListValu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-de2792ad | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:526 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f446845f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:527 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bccec8bf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:528 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bda022e0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:539 | try ▸ lambda ▸ if (queryFlag.Equals("SUB")) | FLAG | pDivisionID | search.DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-0f768a12 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:540 | try ▸ lambda ▸ if (queryFlag.Equals("SUB")) | FLAG | pSiteID | search.SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-d39b1815 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:541 | try ▸ lambda ▸ if (queryFlag.Equals("SUB")) | FLAG | pPlantID | search.PLANT_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-79a7e9ef | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:561 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00210_BOM") ⇒ FP_Master.PR_UI_FP00210_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-c2c2d900 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:562 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-aebf54c7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:563 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-cdf69870 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:564 | try | DATA_OP | request.Parameters["p_sys_flag"] | queryFlag | 행/컬럼 값 대입 |  |  |  |
| AC-d012e614 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:565 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5953a406 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:566 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-6694fe6c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:568 | try | DATA_OP | request.Parameters["p_company_id"] | pCompanyID.Equals("ALL") ? DBNull.Value : pCompanyID | 행/컬럼 값 대입 |  |  |  |
| AC-bad0302d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:569 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-038245c0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:570 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-a806adbb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:571 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-e9539ed1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:572 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-0784a82d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:573 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-2666c1f9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:574 | try | DATA_OP | request.Parameters["p_child_item_id"] | pChildItemId.Equals("ALL") ? DBNull.Value : pChildItemId | 행/컬럼 값 대입 |  |  |  |
| AC-077268e2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:575 | try | DATA_OP | request.Parameters["p_child_nick_name"] | pChildNickName.Equals("ALL") ? DBNull.Value : pChildNickName | 행/컬럼 값 대입 |  |  |  |
| AC-afaa9550 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:577 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a64b124 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:579 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ab0473ac | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:586 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00210_BOM.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2aa2b7f9 | FindButton | FP00210_BOM.cs:318 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8e10c1f3 | FindButton | FP00210_BOM.cs:322 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## FP00210_BOM.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95f97edb | this.Load | FP00210_BOM.cs:141 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00210_BOM.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6beb8844 | this.Load | FP00210_BOM.cs:946 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6f769b9d | this.Load | FP00210_BOM.cs:947 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c61bd9c | this.Load | FP00210_BOM.cs:947 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-06d12fcd | this.Load | FP00210_BOM.cs:948 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00210_BOM.GetDtValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42e2c334 | (진입점 미연결) | FP00210_BOM.cs:793 | try | DATA_OP | dRow.Field | (targetRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a5d06a2 | (진입점 미연결) | FP00210_BOM.cs:805 | try ▸ if (rows != null) ▸ foreach (var row_ in rows) ▸ if (row_ != null) ▸ if (!string.IsNullOrWhiteSpace(each_value)) | DATA_OP | return_values.Contains | (each_value) | 데이터 객체 조작/조회 |  |  |  |
| AC-70fbdfa4 | (진입점 미연결) | FP00210_BOM.cs:807 | try ▸ if (rows != null) ▸ foreach (var row_ in rows) ▸ if (row_ != null) ▸ if (!string.IsNullOrWhiteSpace(each_value)) ▸ if (!return_values.… | DATA_OP | return_values.Add | (each_value) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c3a8ae1 | (진입점 미연결) | FP00210_BOM.cs:825 | catch () | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-21072166 | (진입점 미연결) | FP00210_BOM.cs:826 |  | RETURN | return return_value; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOM.GetSearchCondition

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (row > -1)] / FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (row > -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2535137c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:832 |  | DATA_OP | siMain.GetBindingRow | (row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-41984f60 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:834 |  | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-627e2640 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:836 |  | UI_PROP | _search.COMPANY_ID | dRow["COMPANY_ID"] as string | 속성 COMPANY_ID 설정 |  |  |  |
| AC-58aabdb6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:837 |  | UI_PROP | _search.DIVISION_ID | dRow["DIVISION_ID"] as string | 속성 DIVISION_ID 설정 |  |  |  |
| AC-dcf096a8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:838 |  | UI_PROP | _search.SITE_ID | dRow["SITE_ID"] as string | 속성 SITE_ID 설정 |  |  |  |
| AC-6f28382f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:839 |  | UI_PROP | _search.PLANT_ID | dRow["PLANT_ID"] as string | 속성 PLANT_ID 설정 |  |  |  |
| AC-8b642753 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:840 |  | UI_PROP | _search.PARENT_ITEM_ID | dRow["PARENT_ITEM_ID"] as string | 속성 PARENT_ITEM_ID 설정 |  |  |  |
| AC-9ab962e9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:842 |  | RETURN | return _search; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOM.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f132378 | this.Load | FP00210_BOM.cs:189 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-95ad71bf | this.Load | FP00210_BOM.cs:195 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-918e2924 | this.Load | FP00210_BOM.cs:196 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00210_BOM.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8d4b673 | this.Load 외 2 | FP00210_BOM.cs:285 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-57099c0b | this.Load 외 2 | FP00210_BOM.cs:287 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3d9e4d09 | this.Load 외 2 | FP00210_BOM.cs:293 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2e4850f4 | this.Load 외 2 | FP00210_BOM.cs:295 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a5b517de | this.Load 외 2 | FP00210_BOM.cs:296 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00210_BOM.lfn_SearchDetailGrid

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [if (this.fps != null) ▸ switch (fps.Name) case "spdSub":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45eeb79b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:761 | if (row > -1) | FLAG | _search | GetSearchCondition(row) | 화면 필드/플래그 변경 |  |  |  |
| AC-41d5cccb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 1 | FP00210_BOM.cs:763 | else of (row > -1) | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00210_BOM.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fac34652 | popSql.OnSql | FP00210_BOM.cs:752 | if (programID == "PR_UI_FP00210_BOM") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-5fce82e0 | popSql.OnSql | FP00210_BOM.cs:755 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOM.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c7508b5 | SaveButton | FP00210_BOM.cs:339 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOM.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d1e149 | this.Load 외 3 | FP00210_BOM.cs:908 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-17f230b3 | this.Load 외 3 | FP00210_BOM.cs:908 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d8a2d753 | this.Load 외 3 | FP00210_BOM.cs:913 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-71893847 | this.Load 외 3 | FP00210_BOM.cs:917 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a561e186 | this.Load 외 3 | FP00210_BOM.cs:917 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-42b083d4 | this.Load 외 3 | FP00210_BOM.cs:919 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)clbSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9aec7a7e | this.Load 외 3 | FP00210_BOM.cs:921 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)clbSite is UsrCombo) ▸ if ((object)clbSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-71892e6d | this.Load 외 3 | FP00210_BOM.cs:927 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-18e0c5f1 | this.Load 외 3 | FP00210_BOM.cs:928 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-27f31377 | this.Load 외 3 | FP00210_BOM.cs:928 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f9f79876 | this.Load 외 3 | FP00210_BOM.cs:930 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8a12d40c | this.Load 외 3 | FP00210_BOM.cs:932 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5beeec39 | this.Load 외 3 | FP00210_BOM.cs:938 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00210_BOM.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0db3a27 | this.spdMain.CellDoubleClick | FP00210_BOM.cs:687 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2c4d549 | this.spdMain.CellDoubleClick | FP00210_BOM.cs:693 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, e.Column).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00210_BOMViewPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f268c1a8 | this.Load | FP00210_BOMViewPopup.cs:118 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e8fd999 | this.Load | FP00210_BOMViewPopup.cs:119 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cfc21d56 | this.Load | FP00210_BOMViewPopup.cs:120 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00210_BOMViewPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a1464dd | this.Load | FP00210_BOMViewPopup.cs:108 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-35420a7a | this.Load | FP00210_BOMViewPopup.cs:113 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |

## FP00210_BOMViewPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f677f82 | Dispose | FP00210_BOMViewPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00210_BOMViewPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37107163 | ExcelButton | FP00210_BOMViewPopup.cs:165 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.Casecaded | 속성 Merge 설정 |  |  |  |
| AC-bf780ec6 | ExcelButton | FP00210_BOMViewPopup.cs:166 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-3b5ee1ab | ExcelButton | FP00210_BOMViewPopup.cs:167 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-46631c76 | ExcelButton | FP00210_BOMViewPopup.cs:170 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-1cb4b153 | ExcelButton | FP00210_BOMViewPopup.cs:171 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-77213faa | ExcelButton | FP00210_BOMViewPopup.cs:172 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-2886690b | ExcelButton | FP00210_BOMViewPopup.cs:174 |  | UI_PROP | exportOption.UserName | UserInfoContext.Current.UserId | 속성 UserName 설정 |  |  |  |
| AC-99ca4d90 | ExcelButton | FP00210_BOMViewPopup.cs:175 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-a8165d37 | ExcelButton | FP00210_BOMViewPopup.cs:178 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##########;[red]-#,##0.##########" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-0f7b90ce | ExcelButton | FP00210_BOMViewPopup.cs:190 | try | CALL_EXT | SimplexelService.ExportFpSpreadFast | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3667519d | ExcelButton | FP00210_BOMViewPopup.cs:194 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f21f60f7 | ExcelButton | FP00210_BOMViewPopup.cs:198 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00210_BOMViewPopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-570ce47c | this.Load 외 2 | FP00210_BOMViewPopup.cs:217 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-765a2c11 | this.Load 외 2 | FP00210_BOMViewPopup.cs:221 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00210_BOM") ⇒ FP_Master.PR_UI_FP00210_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-6669a403 | this.Load 외 2 | FP00210_BOMViewPopup.cs:222 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ac0c38a5 | this.Load 외 2 | FP00210_BOMViewPopup.cs:223 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-e415da6d | this.Load 외 2 | FP00210_BOMViewPopup.cs:224 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "BOM_VIEW" | 행/컬럼 값 대입 |  |  |  |
| AC-5e12f04b | this.Load 외 2 | FP00210_BOMViewPopup.cs:225 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-09066611 | this.Load 외 2 | FP00210_BOMViewPopup.cs:226 | lambda | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-5ca3e5d0 | this.Load 외 2 | FP00210_BOMViewPopup.cs:228 | lambda | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-db7cb217 | this.Load 외 2 | FP00210_BOMViewPopup.cs:229 | lambda | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6479383e | this.Load 외 2 | FP00210_BOMViewPopup.cs:230 | lambda | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62cf0b19 | this.Load 외 2 | FP00210_BOMViewPopup.cs:231 | lambda | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ea6b32f | this.Load 외 2 | FP00210_BOMViewPopup.cs:232 | lambda | DATA_OP | request.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6c14eafe | this.Load 외 2 | FP00210_BOMViewPopup.cs:233 | lambda | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d698c03 | this.Load 외 2 | FP00210_BOMViewPopup.cs:234 | lambda | DATA_OP | request.Parameters["p_child_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f74770bf | this.Load 외 2 | FP00210_BOMViewPopup.cs:235 | lambda | DATA_OP | request.Parameters["p_child_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5347d898 | this.Load 외 2 | FP00210_BOMViewPopup.cs:237 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db8f000b | this.Load 외 2 | FP00210_BOMViewPopup.cs:239 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b13e6065 | this.Load 외 2 | FP00210_BOMViewPopup.cs:244 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-210b2451 | this.Load 외 2 | FP00210_BOMViewPopup.cs:245 |  | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6aaf1dfc | this.Load 외 2 | FP00210_BOMViewPopup.cs:246 |  | CALL_EXT | siMain.SetFormat | ("#,##0.#####", 9, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ff6d962 | this.Load 외 2 | FP00210_BOMViewPopup.cs:248 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4fa892f | this.Load 외 2 | FP00210_BOMViewPopup.cs:251 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00210_BOMViewPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ac38db9 | this.Load | FP00210_BOMViewPopup.cs:93 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-920fe604 | this.Load | FP00210_BOMViewPopup.cs:96 |  | GRID_SET | spdMain.ActiveSheet.RowHeader.Columns[0].Width | 56 | 그리드 속성/값 설정 |  |  |  |

## FP00210_BOMViewPopup.InitSpread

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e289e70c | this.Load 외 2 | FP00210_BOMViewPopup.cs:127 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4a43fbf8 | this.Load 외 2 | FP00210_BOMViewPopup.cs:129 |  | GRID_INIT | siMain.AddTextColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Gen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f26701fd | this.Load 외 2 | FP00210_BOMViewPopup.cs:130 |  | GRID_INIT | siMain.AddTextColumn | ("Site", DefColumns.SITE_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-960186bb | this.Load 외 2 | FP00210_BOMViewPopup.cs:131 |  | GRID_INIT | siMain.AddTextColumn | ("Model", DefColumns.MODEL_ID, FPMerge.None, 120, true, FPHAlign.Left, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40a677e6 | this.Load 외 2 | FP00210_BOMViewPopup.cs:132 |  | GRID_INIT | siMain.AddTextColumn | ("PJT Code", DefColumns.NICK_NAME, FPMerge.None, 150, true, FPHAlign.Left, FPVAlign.Genera… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eea181ca | this.Load 외 2 | FP00210_BOMViewPopup.cs:133 |  | GRID_INIT | siMain.AddTextColumn | ("Assembly", DefColumns.PARENT_ITEM_ID, FPMerge.None, 120, true, FPHAlign.Left, FPVAlign.G… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41b8f212 | this.Load 외 2 | FP00210_BOMViewPopup.cs:134 |  | GRID_INIT | siMain.AddTextColumn | ("Category Name", DefColumns.CATEGORY_NAME, FPMerge.None, 150, true, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3610735a | this.Load 외 2 | FP00210_BOMViewPopup.cs:135 |  | GRID_INIT | siMain.AddTextColumn | ("Part No", DefColumns.CHILD_ITEM_ID, FPMerge.None, 120, true, FPHAlign.Left, FPVAlign.Gen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96e99761 | this.Load 외 2 | FP00210_BOMViewPopup.cs:136 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.None, 150, true, FPHAlign.Left, FPVAlign.G… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c534f5cb | this.Load 외 2 | FP00210_BOMViewPopup.cs:137 |  | GRID_INIT | siMain.AddTextColumn | ("SPEC", DefColumns.SPEC, FPMerge.None, 250, true, FPHAlign.Left, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39bc3bb0 | this.Load 외 2 | FP00210_BOMViewPopup.cs:138 |  | GRID_INIT | siMain.AddTextColumn | ("QTY", DefColumns.QTY, FPMerge.None, 80, true, FPHAlign.Right, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-339637e0 | this.Load 외 2 | FP00210_BOMViewPopup.cs:139 |  | GRID_INIT | siMain.AddTextColumn | ("UOM", DefColumns.ITEM_UOM, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a123853 | this.Load 외 2 | FP00210_BOMViewPopup.cs:140 |  | GRID_INIT | siMain.AddTextColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 90, true, FPHAlign.Center, FPVAlign.Gener… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3c66d13 | this.Load 외 2 | FP00210_BOMViewPopup.cs:141 |  | GRID_INIT | siMain.AddDateTextColumn | ("DATE", DefColumns.DATE, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00210_BOMViewPopup.OkButtonClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2ec6657 | (진입점 미연결) | FP00210_BOMViewPopup.cs:299 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00210_BOMViewPopup.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-073707d0 | (진입점 미연결) | FP00210_BOMViewPopup.cs:323 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

