# AS-IS 액션 대조표 — DMF0072

> 원천: `Doc/asisfacts/screens/DMF0072/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 274행 · 메서드 24 · 종류 DATA_OP 49 · GRID_SET 25 · MESSAGE 23 · RETURN 22 · FLAG 20 · UI_PROP 19 · GRID_STYLE 18 · COMBO_DATA 17 · POPUP 15 · LIST_REBIND 13 · GRID_LOCK 11 · GRID_INIT 8 · UI_MISC 7 · ENDPOINT 7 · CALL_EXT 6 · GRID_COMBO 5 · STATE 4 · VALUE_SET 2 · THROW 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 6


## DMF0072_NNMasterMapping.btnModelType_Click

진입점: this.btnModelType.Click / this.umltModel.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78967013 | this.btnModelType.Click 외 1 | DMF0072_NNMasterMapping.cs:1039 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-299f742e | this.btnModelType.Click 외 1 | DMF0072_NNMasterMapping.cs:1041 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7f60b639 | this.btnModelType.Click 외 1 | DMF0072_NNMasterMapping.cs:1042 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6aa0ccdf | this.btnModelType.Click 외 1 | DMF0072_NNMasterMapping.cs:1043 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bd8368c9 | this.btnModelType.Click 외 1 | DMF0072_NNMasterMapping.cs:1045 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0072_NNMasterMapping.btnProject_Click

진입점: this.btnProject.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d37a373 | this.btnProject.Click 외 1 | DMF0072_NNMasterMapping.cs:1057 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-1b807464 | this.btnProject.Click 외 1 | DMF0072_NNMasterMapping.cs:1058 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-16bf7d47 | this.btnProject.Click 외 1 | DMF0072_NNMasterMapping.cs:1059 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4ca18b19 | this.btnProject.Click 외 1 | DMF0072_NNMasterMapping.cs:1060 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a276096 | this.btnProject.Click 외 1 | DMF0072_NNMasterMapping.cs:1062 |  | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0072_NNMasterMapping.clbDivision_SelectedIndexChanged

진입점: clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe940a25 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1075 | if (sDivision == "40") | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4ef01585 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1076 | if (sDivision == "40") | STATE | layoutControlItem9.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-201d3c70 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1077 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-327185a4 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1081 | else of (sDivision == "40") | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fbdc8999 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1082 | else of (sDivision == "40") | STATE | layoutControlItem9.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5604dcc4 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1083 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fe1ed814 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1091 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-125dc8b5 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1100 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f29eb47e | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1101 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer40, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb6ae013 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1106 | if (sDivision == "40") | COMBO_DATA | Data.ScmSitebyEndCustomer40 | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-543f3908 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1107 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2af7c3f5 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1113 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d9bb93a | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1114 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dd77ecc5 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1118 | else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a79f92a3 | clbDivisions.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1119 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0072_NNMasterMapping.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37689376 | this.clbEndCustomer.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1408 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0072_NNMasterMapping.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d97087a6 | this.clbTeam.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1421 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2f6689ee | this.clbTeam.SelectedIndexChanged | DMF0072_NNMasterMapping.cs:1429 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0072_NNMasterMapping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50dc7625 | this.Load | DMF0072_NNMasterMapping.cs:241 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a8142d47 | this.Load | DMF0072_NNMasterMapping.cs:242 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5cbb7ff | this.Load | DMF0072_NNMasterMapping.cs:243 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0072_NNMasterMapping.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e6922d2 | this.Load | DMF0072_NNMasterMapping.cs:210 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-d4815378 | this.Load | DMF0072_NNMasterMapping.cs:212 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b98d654f | this.Load | DMF0072_NNMasterMapping.cs:214 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9dea93f1 | this.Load | DMF0072_NNMasterMapping.cs:215 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-52c2ee56 | this.Load | DMF0072_NNMasterMapping.cs:216 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-1ff6a7bf | this.Load | DMF0072_NNMasterMapping.cs:217 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0072_NNMasterMapping.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d54205b | DeleteButton | DMF0072_NNMasterMapping.cs:278 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0072_NNMasterMapping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edee3fa0 | Dispose | DMF0072_NNMasterMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0072_NNMasterMapping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe858f33 | EditButton | DMF0072_NNMasterMapping.cs:285 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0f1ca65 | EditButton | DMF0072_NNMasterMapping.cs:286 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4129dedb | EditButton | DMF0072_NNMasterMapping.cs:293 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetColumnIndex(DefColumns.ITEM_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a59b604 | EditButton | DMF0072_NNMasterMapping.cs:296 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID_ORIGINAL), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c679a2bb | EditButton | DMF0072_NNMasterMapping.cs:299 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0072_NNMasterMapping.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd8b0c60 | ExcelButton | DMF0072_NNMasterMapping.cs:404 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-c273febf | ExcelButton | DMF0072_NNMasterMapping.cs:405 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-e6f54995 | ExcelButton | DMF0072_NNMasterMapping.cs:406 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-005f39b6 | ExcelButton | DMF0072_NNMasterMapping.cs:407 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-b037c26b | ExcelButton | DMF0072_NNMasterMapping.cs:408 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-948d4349 | ExcelButton | DMF0072_NNMasterMapping.cs:409 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-a3225240 | ExcelButton | DMF0072_NNMasterMapping.cs:411 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2479f75b | ExcelButton | DMF0072_NNMasterMapping.cs:412 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-72708573 | ExcelButton | DMF0072_NNMasterMapping.cs:414 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[Red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-09794bc3 | ExcelButton | DMF0072_NNMasterMapping.cs:423 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-52bf3ceb | ExcelButton | DMF0072_NNMasterMapping.cs:428 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-43f66bab | ExcelButton | DMF0072_NNMasterMapping.cs:432 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0072_NNMasterMapping.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e498b5c | FindButton 외 1 | DMF0072_NNMasterMapping.cs:462 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e2648e5 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:463 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72134e32 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:468 | try | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e827835 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:473 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd62c18e | FindButton 외 1 | DMF0072_NNMasterMapping.cs:477 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0072_GET_NNMASTER_MAPPING") ⇒ DM.DMF0072_GET_NNMASTER_MAPPING | 엔드포인트 요청 생성 |  |  |  |
| AC-28edec5d | FindButton 외 1 | DMF0072_NNMasterMapping.cs:479 | try ▸ lambda | DATA_OP | request.Parameters["p_data_type_code"] | p_data_type_code | 행/컬럼 값 대입 |  |  |  |
| AC-bde0a343 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:480 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fc650a4 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:481 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f226ef98 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:482 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-14f5bd29 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:483 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-77e2b403 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:484 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-bd9754c9 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:485 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc1b6abd | FindButton 외 1 | DMF0072_NNMasterMapping.cs:487 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7937d5ef | FindButton 외 1 | DMF0072_NNMasterMapping.cs:489 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-336583ec | FindButton 외 1 | DMF0072_NNMasterMapping.cs:493 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ed2f17d6 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:494 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba2221e2 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:497 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ef0d9c3a | FindButton 외 1 | DMF0072_NNMasterMapping.cs:505 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8a5c9553 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:510 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((iRow % 100) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-26d5e467 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:513 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cbbe48f7 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:515 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ed7321c | FindButton 외 1 | DMF0072_NNMasterMapping.cs:520 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID_ORIGINAL), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a86ae69 | FindButton 외 1 | DMF0072_NNMasterMapping.cs:524 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b5f8f8ef | FindButton 외 1 | DMF0072_NNMasterMapping.cs:529 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-71d6499d | FindButton 외 1 | DMF0072_NNMasterMapping.cs:530 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-8c7332ad | FindButton 외 1 | DMF0072_NNMasterMapping.cs:534 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0072_NNMasterMapping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2ac8b6e | this.Load | DMF0072_NNMasterMapping.cs:141 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-db6de3a6 | this.Load | DMF0072_NNMasterMapping.cs:142 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0072_NNMasterMapping.GetSpdTitle

진입점: this.Load / clbDivisions.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f1dc20f | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1456 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c0a4fc48 | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1457 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cb95ddf4 | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1458 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9af91b02 | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1459 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6759adbe | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1460 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0072" | 행/컬럼 값 대입 |  |  |  |
| AC-91322346 | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1461 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-abc48774 | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1462 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fe1459dc | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1464 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a065c3d | this.Load 외 3 | DMF0072_NNMasterMapping.cs:1466 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0072_NNMasterMapping.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba2a9f73 | this.Load | DMF0072_NNMasterMapping.cs:151 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e980c938 | this.Load | DMF0072_NNMasterMapping.cs:153 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-ef767061 | this.Load | DMF0072_NNMasterMapping.cs:153 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3fbacc55 | this.Load | DMF0072_NNMasterMapping.cs:154 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2703c4e9 | this.Load | DMF0072_NNMasterMapping.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d37ccba9 | this.Load | DMF0072_NNMasterMapping.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aa75b1fc | this.Load | DMF0072_NNMasterMapping.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-12cf5bc8 | this.Load | DMF0072_NNMasterMapping.cs:192 |  | FLAG | dtITEM_ID | Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], Us… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-7aeca41c | this.Load | DMF0072_NNMasterMapping.cs:192 |  | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-308c5c89 | this.Load | DMF0072_NNMasterMapping.cs:200 |  | FLAG | dtDM_EDI_DATA_TYPE_CODE | GSCM.Utils.CommonUtils.GetLookupValues("DM_EDI_DATA_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-a23f93bd | this.Load | DMF0072_NNMasterMapping.cs:200 |  | CALL_EXT | GSCM.Utils.CommonUtils.GetLookupValues | ("DM_EDI_DATA_TYPE_CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-40e738da | this.Load | DMF0072_NNMasterMapping.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtDM_EDI_DATA_TYPE_CODE, clbDataTypeCode, true, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |

## DMF0072_NNMasterMapping.InitSpread

진입점: this.Load / clbDivisions.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-581ceb20 | this.Load 외 3 | DMF0072_NNMasterMapping.cs:254 |  | FLAG | dtTitle | GetSpdTitle(siMain.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-1448370e | this.Load 외 3 | DMF0072_NNMasterMapping.cs:255 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0072_NNMasterMapping.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-269ee6cd | InsertButton | DMF0072_NNMasterMapping.cs:544 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0fb11ef | InsertButton | DMF0072_NNMasterMapping.cs:550 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE), "SCM") | 그리드 값 설정 |  |  |  |
| AC-284cf754 | InsertButton | DMF0072_NNMasterMapping.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE), siMain.ActiveRowIndex, siMain.Get… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c5465bcf | InsertButton | DMF0072_NNMasterMapping.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-69ee1bf8 | InsertButton | DMF0072_NNMasterMapping.cs:558 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | GSCM.Utils.CommonUtils.GetLookupValues | ("DM_EDI_COMPANY_LIST") | ⚠ 의미 확인 필요 |  |  |  |
| AC-81304448 | InsertButton | DMF0072_NNMasterMapping.cs:559 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.COMPANY_ID), dtCOMPANY_ID) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bf050fd9 | InsertButton | DMF0072_NNMasterMapping.cs:561 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-97f59c29 | InsertButton | DMF0072_NNMasterMapping.cs:562 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-57167c3a | InsertButton | DMF0072_NNMasterMapping.cs:567 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, "", UserInfoContext.Current["NowGrou… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c1130be | InsertButton | DMF0072_NNMasterMapping.cs:568 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-adc53392 | InsertButton | DMF0072_NNMasterMapping.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-985176a6 | InsertButton | DMF0072_NNMasterMapping.cs:573 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bda99cff | InsertButton | DMF0072_NNMasterMapping.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-32889940 | InsertButton | DMF0072_NNMasterMapping.cs:578 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-528c73ed | InsertButton | DMF0072_NNMasterMapping.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fb07763b | InsertButton | DMF0072_NNMasterMapping.cs:580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c0cc91bb | InsertButton | DMF0072_NNMasterMapping.cs:582 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8e110a12 | InsertButton | DMF0072_NNMasterMapping.cs:583 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2d233fa8 | InsertButton | DMF0072_NNMasterMapping.cs:586 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-53415db9 | InsertButton | DMF0072_NNMasterMapping.cs:589 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRowIndex, siMain.Ge… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b700826 | InsertButton | DMF0072_NNMasterMapping.cs:590 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveRowIndex, siMain.G… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0072_NNMasterMapping.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69805333 | SaveButton | DMF0072_NNMasterMapping.cs:696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Valid From, Valid To, Model Code" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25b5bf1f | SaveButton | DMF0072_NNMasterMapping.cs:700 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 그리드 표시 설정 |  |  |  |
| AC-f07acc5b | SaveButton | DMF0072_NNMasterMapping.cs:704 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)) | 그리드 표시 설정 |  |  |  |
| AC-a659da8f | SaveButton | DMF0072_NNMasterMapping.cs:708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)) | 그리드 표시 설정 |  |  |  |
| AC-8081c3db | SaveButton | DMF0072_NNMasterMapping.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-709ca22c | SaveButton | DMF0072_NNMasterMapping.cs:727 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f23a9e93 | SaveButton | DMF0072_NNMasterMapping.cs:728 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)) | 그리드 표시 설정 |  |  |  |
| AC-f352c882 | SaveButton | DMF0072_NNMasterMapping.cs:729 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83002c31 | SaveButton | DMF0072_NNMasterMapping.cs:734 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cca611c0 | SaveButton | DMF0072_NNMasterMapping.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)) | 그리드 표시 설정 |  |  |  |
| AC-ac3cdccf | SaveButton | DMF0072_NNMasterMapping.cs:736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56f2eb6f | SaveButton | DMF0072_NNMasterMapping.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00105") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f1e2290 | SaveButton | DMF0072_NNMasterMapping.cs:751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)) | 그리드 표시 설정 |  |  |  |
| AC-4a0636e3 | SaveButton | DMF0072_NNMasterMapping.cs:752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a23e794 | SaveButton | DMF0072_NNMasterMapping.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00106") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56f44fff | SaveButton | DMF0072_NNMasterMapping.cs:759 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)) | 그리드 표시 설정 |  |  |  |
| AC-59262dab | SaveButton | DMF0072_NNMasterMapping.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b13f2538 | SaveButton | DMF0072_NNMasterMapping.cs:789 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.DATA_TYPE_CODE }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eecf8482 | SaveButton | DMF0072_NNMasterMapping.cs:790 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE)) | 그리드 표시 설정 |  |  |  |
| AC-837705da | SaveButton | DMF0072_NNMasterMapping.cs:791 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ce1ca00 | SaveButton | DMF0072_NNMasterMapping.cs:795 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.END_CUSTOMER }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0272c4e4 | SaveButton | DMF0072_NNMasterMapping.cs:796 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) | 그리드 표시 설정 |  |  |  |
| AC-ce512509 | SaveButton | DMF0072_NNMasterMapping.cs:797 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6d9121f | SaveButton | DMF0072_NNMasterMapping.cs:830 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.SOLDTO_CODE }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b68a0a92 | SaveButton | DMF0072_NNMasterMapping.cs:831 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE)) | 그리드 표시 설정 |  |  |  |
| AC-cc608f21 | SaveButton | DMF0072_NNMasterMapping.cs:832 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba233647 | SaveButton | DMF0072_NNMasterMapping.cs:836 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.SHIPTO_CODE }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20be3675 | SaveButton | DMF0072_NNMasterMapping.cs:837 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE)) | 그리드 표시 설정 |  |  |  |
| AC-c30653c2 | SaveButton | DMF0072_NNMasterMapping.cs:838 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4fe3e1e | SaveButton | DMF0072_NNMasterMapping.cs:842 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.PROJECT_CODE }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6457c77f | SaveButton | DMF0072_NNMasterMapping.cs:843 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | 그리드 표시 설정 |  |  |  |
| AC-8897fab2 | SaveButton | DMF0072_NNMasterMapping.cs:844 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db356c58 | SaveButton | DMF0072_NNMasterMapping.cs:848 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.SCM_SITE_ID }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e966723 | SaveButton | DMF0072_NNMasterMapping.cs:849 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) | 그리드 표시 설정 |  |  |  |
| AC-a0ff7bb3 | SaveButton | DMF0072_NNMasterMapping.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae76fdef | SaveButton | DMF0072_NNMasterMapping.cs:854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.FCST_TYPE }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db718610 | SaveButton | DMF0072_NNMasterMapping.cs:855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.FCST_TYPE)) | 그리드 표시 설정 |  |  |  |
| AC-058b8c5b | SaveButton | DMF0072_NNMasterMapping.cs:856 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dca42064 | SaveButton | DMF0072_NNMasterMapping.cs:860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.INCOTERMS }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18dee464 | SaveButton | DMF0072_NNMasterMapping.cs:861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS)) | 그리드 표시 설정 |  |  |  |
| AC-0038272d | SaveButton | DMF0072_NNMasterMapping.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8255a303 | SaveButton | DMF0072_NNMasterMapping.cs:866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.DOM_EXP }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11464f3a | SaveButton | DMF0072_NNMasterMapping.cs:867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.DOM_EXP)) | 그리드 표시 설정 |  |  |  |
| AC-a48bb17b | SaveButton | DMF0072_NNMasterMapping.cs:868 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f3073cb | SaveButton | DMF0072_NNMasterMapping.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.ITEM_ID }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc8ee200 | SaveButton | DMF0072_NNMasterMapping.cs:873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 그리드 표시 설정 |  |  |  |
| AC-6a089239 | SaveButton | DMF0072_NNMasterMapping.cs:874 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4eff8693 | SaveButton | DMF0072_NNMasterMapping.cs:880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.ACTIVE_YN }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ab0e854 | SaveButton | DMF0072_NNMasterMapping.cs:881 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.ACTIVE_YN)) | 그리드 표시 설정 |  |  |  |
| AC-ddd44edd | SaveButton | DMF0072_NNMasterMapping.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-089debf1 | SaveButton | DMF0072_NNMasterMapping.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageBox.Show | ("최대 입력길이 초과") | 메시지 표시 |  |  |  |
| AC-620749a7 | SaveButton | DMF0072_NNMasterMapping.cs:895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-078c9a80 | SaveButton | DMF0072_NNMasterMapping.cs:951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0072_SAVE_NNMASTER_MAPPING | 엔드포인트 요청 생성 |  |  |  |
| AC-f724bb56 | SaveButton | DMF0072_NNMasterMapping.cs:952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-24c43d5a | SaveButton | DMF0072_NNMasterMapping.cs:953 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_COMPANY_ID"] | sCOMPANY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8725c067 | SaveButton | DMF0072_NNMasterMapping.cs:954 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_ACT_TYPE"] | sACT_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-655c72e4 | SaveButton | DMF0072_NNMasterMapping.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_CUST_FCST_TYPE"] | sDATA_TYPE_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-c713d8da | SaveButton | DMF0072_NNMasterMapping.cs:956 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_END_CUSTOMER"] | sEND_CUSTOMER | 행/컬럼 값 대입 |  |  |  |
| AC-b784b305 | SaveButton | DMF0072_NNMasterMapping.cs:957 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_CUST_UNLOAD"] | sCUST_UNLOAD | 행/컬럼 값 대입 |  |  |  |
| AC-3a9be0bc | SaveButton | DMF0072_NNMasterMapping.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_CUST_PLANT"] | sCUST_PLANT | 행/컬럼 값 대입 |  |  |  |
| AC-2fe7ffd0 | SaveButton | DMF0072_NNMasterMapping.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_SOLDTO"] | sSOLDTO | 행/컬럼 값 대입 |  |  |  |
| AC-0227be96 | SaveButton | DMF0072_NNMasterMapping.cs:960 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_SHIPTO"] | sSHIPTO | 행/컬럼 값 대입 |  |  |  |
| AC-10984ba9 | SaveButton | DMF0072_NNMasterMapping.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_PROJECT_CODE"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-67361908 | SaveButton | DMF0072_NNMasterMapping.cs:962 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_SCM_SITE_ID"] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-505d4c88 | SaveButton | DMF0072_NNMasterMapping.cs:963 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_FCST_TYPE"] | sFCST_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-08fc15ba | SaveButton | DMF0072_NNMasterMapping.cs:964 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_INCOTERMS"] | sINCOTERMS | 행/컬럼 값 대입 |  |  |  |
| AC-900c0916 | SaveButton | DMF0072_NNMasterMapping.cs:965 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_DOM_EXP"] | sDOM_EXP | 행/컬럼 값 대입 |  |  |  |
| AC-0bc1e878 | SaveButton | DMF0072_NNMasterMapping.cs:966 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_CUST_ITEM_ID"] | sCUST_ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-85de4714 | SaveButton | DMF0072_NNMasterMapping.cs:967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_MDM_CODE"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-61d46d9d | SaveButton | DMF0072_NNMasterMapping.cs:968 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_MAPPING_ITEM_ID"] | sMAPPING_ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-795d6e3a | SaveButton | DMF0072_NNMasterMapping.cs:969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_MAPPING_ITEM_ID_ORIGINAL"] | sMAPPING_ITEM_ID_ORIGINAL | 행/컬럼 값 대입 |  |  |  |
| AC-fb0cb57e | SaveButton | DMF0072_NNMasterMapping.cs:970 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_ACTIVE_FLAG"] | sACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-7d5c7ed9 | SaveButton | DMF0072_NNMasterMapping.cs:971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_VALID_FROM"] | sVALID_FROM | 행/컬럼 값 대입 |  |  |  |
| AC-9f98c646 | SaveButton | DMF0072_NNMasterMapping.cs:972 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_VALID_TO"] | sVALID_TO | 행/컬럼 값 대입 |  |  |  |
| AC-8d6490b5 | SaveButton | DMF0072_NNMasterMapping.cs:973 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | DATA_OP | request.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f733a7e3 | SaveButton | DMF0072_NNMasterMapping.cs:975 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-beed5d17 | SaveButton | DMF0072_NNMasterMapping.cs:980 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c24f307 | SaveButton | DMF0072_NNMasterMapping.cs:981 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fc644f7e | SaveButton | DMF0072_NNMasterMapping.cs:987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | MESSAGE | MessageBox.Show | (response.DataSet.Tables[0].Rows[0]["result_msg"].ToString()) | 메시지 표시 |  |  |  |
| AC-e859b94a | SaveButton | DMF0072_NNMasterMapping.cs:988 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-585f13c6 | SaveButton | DMF0072_NNMasterMapping.cs:993 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ t… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a19c16b | SaveButton | DMF0072_NNMasterMapping.cs:1002 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDATA_TYPE_CODE != "") ▸ c… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b264545 | SaveButton | DMF0072_NNMasterMapping.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDATA_TYPE_CODE != ""… | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0072_NNMasterMapping.SetChangeControl

진입점: this.clbTeam.SelectedIndexChanged / this.clbEndCustomer.SelectedIndexChanged / this.Load / clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-584919ae | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1310 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-80f2e9ac | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1311 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d5cda4cb | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1317 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-569fb782 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1317 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9e84aaa5 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1322 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7629d27a | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1324 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-72b6a600 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1324 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a0a154cc | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1329 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a4325a88 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1330 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-5f72ae91 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1332 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-befc040b | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1332 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8c7aa1c3 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1337 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-11030856 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1344 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-291f8035 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1345 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-d7c82995 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1346 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-4d9b4f48 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1348 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-95ffd9dc | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1348 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b3d31787 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1353 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-96c0778e | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1354 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-2a51a26e | this.clbTeam.SelectedIndexChanged 외 3 | DMF0072_NNMasterMapping.cs:1367 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |

## DMF0072_NNMasterMapping.SetLockRow

진입점: EditButton [if (this.fps != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d517fe57 | EditButton [if (this.fps != null)] | DMF0072_NNMasterMapping.cs:1443 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!sDATA_TYPE_CODE.Equals("SCM")) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE) + 1, iRow, siMain.GetMaxColumnInde… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0072_NNMasterMapping.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3dddec2 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1197 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31f0204f | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1231 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.MAPPIN… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-f5001685 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1235 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.MAPPIN… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-00ff37f4 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1236 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.MAPPIN… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b8de2e21 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1237 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.MAPPIN… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e6de9c8f | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1242 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.MAPPIN… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-d13e9970 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1260 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4a857b5f | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1261 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-863c8631 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1262 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-275746ca | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1263 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f1bbb04 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1269 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-d7f2c94d | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1286 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-07c87318 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1288 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | POPUP | popCustomer.Form_Load | (false, sDivision, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ea0713b8 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1289 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-961af6fd | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1290 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-97438694 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1294 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-15414ac5 | this.spdMain.CellDoubleClick | DMF0072_NNMasterMapping.cs:1295 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.M… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |

## DMF0072_NNMasterMapping.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-071ce563 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1139 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-7cd6d0f5 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1139 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-901957ae | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1143 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc38ce40 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1143 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46e080f2 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1149 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-9011b898 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1149 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90798991 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1150 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1cc0fa84 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1154 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-1e5cecca | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1156 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6932f5e1 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1158 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-7dbf543c | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1160 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-414500ec | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1162 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-4aecd121 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1169 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6bb89cf1 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1169 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2da96950 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1170 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f9af4704 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1173 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e7d68234 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1175 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-3df69705 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1177 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-35334b24 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1179 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5628d927 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1185 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-ef194f7f | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1187 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ca3a81f8 | this.spdMain.ComboSelChange | DMF0072_NNMasterMapping.cs:1189 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |

## DMF0072_NNMasterMapping.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18865702 | this.spdMain.KeyUp | DMF0072_NNMasterMapping.cs:1381 | if (e.Control == true && e.KeyCode == Keys.V) | CALL_EXT | spdMain.Sheets[0].ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e2557ed | this.spdMain.KeyUp | DMF0072_NNMasterMapping.cs:1388 | if (e.Control == true && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0072_NNMasterMapping.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d209f3d | this.spdMain.TopChange | DMF0072_NNMasterMapping.cs:1398 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

