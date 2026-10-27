# AS-IS 액션 대조표 — DMF0066

> 원천: `Doc/asisfacts/screens/DMF0066/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 426행 · 메서드 37 · 종류 DATA_OP 84 · GRID_SET 72 · FLAG 29 · RETURN 25 · UI_PROP 24 · POPUP 22 · COMBO_DATA 22 · GRID_INIT 22 · MESSAGE 19 · CALL_EXT 16 · GRID_LOCK 16 · ENDPOINT 16 · GRID_STYLE 14 · LIST_REBIND 13 · UI_MISC 12 · STATE_RESET 7 · VALUE_SET 5 · GRID_COMBO 4 · STATE 2 · GRID_BIND 1 · VALIDATE 1 · ⚠ 의미 확인 필요 16


## DMF0066_ShipmentRequest_JV.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfa5d316 | this.btnColumn.Click | DMF0066_ShipmentRequest_JV.cs:2197 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF0045", SpdSheet.shtPack, true) | 팝업/폼 생성 |  |  |  |
| AC-1ba26a8a | this.btnColumn.Click | DMF0066_ShipmentRequest_JV.cs:2198 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a912b618 | this.btnColumn.Click | DMF0066_ShipmentRequest_JV.cs:2199 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0066_ShipmentRequest_JV.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89860596 | this.btnItemId.Click | DMF0066_ShipmentRequest_JV.cs:2182 |  | POPUP | new DMF0047_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4fb25e6c | this.btnItemId.Click | DMF0066_ShipmentRequest_JV.cs:2183 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId, sBizType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-875daa1c | this.btnItemId.Click | DMF0066_ShipmentRequest_JV.cs:2184 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-66517d52 | this.btnItemId.Click | DMF0066_ShipmentRequest_JV.cs:2185 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fd46e0c1 | this.btnItemId.Click | DMF0066_ShipmentRequest_JV.cs:2191 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-048f3315 | this.btnMeasure.Click | DMF0066_ShipmentRequest_JV.cs:2368 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0066", strSheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-653a5f71 | this.btnMeasure.Click | DMF0066_ShipmentRequest_JV.cs:2370 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-69d2a866 | this.btnMeasure.Click | DMF0066_ShipmentRequest_JV.cs:2371 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0066_ShipmentRequest_JV.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d26156f2 | this.btnProject.Click | DMF0066_ShipmentRequest_JV.cs:2158 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c7f1bd78 | this.btnProject.Click | DMF0066_ShipmentRequest_JV.cs:2160 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-644d7433 | this.btnProject.Click | DMF0066_ShipmentRequest_JV.cs:2161 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-22a8a15d | this.btnProject.Click | DMF0066_ShipmentRequest_JV.cs:2162 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-591bdcd3 | this.btnProject.Click | DMF0066_ShipmentRequest_JV.cs:2168 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.cboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa7a8729 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1140 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-616bb9e5 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1140 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1098a63c | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1141 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9fc6c69a | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1145 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-418cdda6 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1145 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9e60bd3 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1146 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-da1fad4b | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1150 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d6d9706a | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1150 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a12fd83 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1151 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-866e6ac3 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1153 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-81f9079a | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1153 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc950459 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1157 |  | CALL_EXT | dic_JV_Plant.TryGetValue | (sDivision, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5228b8fe | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1161 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | DATA_OP | dtPlantSite.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c84c95c | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1162 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | DATA_OP | dtPlantSite.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34039d54 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1165 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | STATE_RESET | dtPlantSite.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c9604f6b | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1169 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) | DATA_OP | dtFromSite_Tmp_data.Select().Where(c => c["CODE"].ToString().Contains(getValue_split[i])).… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af31b186 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1169 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) | DATA_OP | dtFromSite_Tmp_data.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-983cac1e | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1169 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) ▸ lambda | DATA_OP | c["CODE"].ToString().Contains | (getValue_split[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-45e12b54 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1173 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) ▸ for (j < dtFromSite_Tmp.… | DATA_OP | dtPlantSite.ImportRow | (dtFromSite_Tmp.Rows[j]) | 데이터 객체 조작/조회 |  |  |  |
| AC-601218e5 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1177 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | STATE_RESET | dtFromSite_Tmp.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3a6ad76b | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1178 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | STATE_RESET | dtFromSite_Tmp_data.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-6a338a1b | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1180 | if (get_JV_Value == "") | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-ab3a8c5a | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1181 | else of (get_JV_Value == "") | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-cea745d3 | this.cboDivision.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1184 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0066_ShipmentRequest_JV.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2dd20d4 | this.clbCustomer.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1203 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0ba2bc6d | this.clbCustomer.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1203 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d31833e1 | this.clbCustomer.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1204 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0066_ShipmentRequest_JV.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f423565d | this.clbTeam.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1191 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d0b80db5 | this.clbTeam.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1191 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-827786a0 | this.clbTeam.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1192 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a566b409 | this.clbTeam.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1195 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-541ff987 | this.clbTeam.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1195 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38846638 | this.clbTeam.SelectedIndexChanged | DMF0066_ShipmentRequest_JV.cs:1196 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0066_ShipmentRequest_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8362401 | this.Load | DMF0066_ShipmentRequest_JV.cs:294 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPack, SpdSheet.shtPack, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6265d4c7 | this.Load | DMF0066_ShipmentRequest_JV.cs:295 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPack) | 화면 필드/플래그 변경 |  |  |  |
| AC-064be2bb | this.Load | DMF0066_ShipmentRequest_JV.cs:296 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7574139a | this.Load | DMF0066_ShipmentRequest_JV.cs:299 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtCell, SpdSheet.shtCell, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e5c00c0 | this.Load | DMF0066_ShipmentRequest_JV.cs:300 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtCell) | 화면 필드/플래그 변경 |  |  |  |
| AC-55e69887 | this.Load | DMF0066_ShipmentRequest_JV.cs:301 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtCell) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de204808 | this.Load | DMF0066_ShipmentRequest_JV.cs:304 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0066_ShipmentRequest_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cc648e4 | this.Load | DMF0066_ShipmentRequest_JV.cs:279 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-21c9753b | this.Load | DMF0066_ShipmentRequest_JV.cs:280 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-a937e694 | this.Load | DMF0066_ShipmentRequest_JV.cs:282 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa6ee8cf | this.Load | DMF0066_ShipmentRequest_JV.cs:283 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-36561966 | this.Load | DMF0066_ShipmentRequest_JV.cs:284 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-16b8463b | this.Load | DMF0066_ShipmentRequest_JV.cs:285 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-7c2812b9 | this.Load | DMF0066_ShipmentRequest_JV.cs:288 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-203f36c1 | DeleteButton | DMF0066_ShipmentRequest_JV.cs:480 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0066_ShipmentRequest_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33bbd21f | Dispose | DMF0066_ShipmentRequest_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0066_ShipmentRequest_JV.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9934a255 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:488 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbfa5e8e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:489 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8a464552 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:491 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.Requestor), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cb38f4d0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:498 | if (this.fps != null) | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb1f7495 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:498 | if (this.fps != null) | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dd4ee1e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:501 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1, siMain.ActiveSheet.RowCount - 1, siMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1812359 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:508 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b2065e0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:531 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-401412e8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:535 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 표시 설정 |  |  |  |
| AC-7d25a9e7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:547 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, iFrom, iRow, iTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-97556397 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:550 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be52e336 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:560 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ToSite)).ToString… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84c82887 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:584 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-be3d8822 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:585 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-53308ef7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:590 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol + FrozenCnt + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-38cb9cbc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:595 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FcstType), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d55f889 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:596 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.FcstType), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-594ab7da | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:601 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ else of (siMain.GetText(iRow, siMain.GetColumnIndex(De… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol + FrozenCnt + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed0797a2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0066_ShipmentRequest_JV.cs:606 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (FrozenCnt != 0) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0066_ShipmentRequest_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ddecf9a | FindButton | DMF0066_ShipmentRequest_JV.cs:465 | if (p_scm_site_id.ToString() == "" && clbPlantSite.ALL_VIEW == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b08b31d9 | FindButton | DMF0066_ShipmentRequest_JV.cs:466 | if (p_scm_site_id.ToString() == "" && clbPlantSite.ALL_VIEW == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0066_ShipmentRequest_JV.FindData

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b97ca39 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:624 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e3fa86ab | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:624 |  | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4753307d | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:626 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7b51b89d | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:634 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5556a5da | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:635 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ec5925a | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:639 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-928553a0 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:644 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d238f428 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:650 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-723cbe8d | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:654 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0045_GET_SHIPMENT_REQUEST") ⇒ DM.DMF0045_GET_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-212f7eb2 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:656 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d7b74286 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:658 | try ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | siMain.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-2c9ad38e | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:659 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0b8aea99 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:660 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | (sTeam=="ALL")?"":sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-35268759 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:661 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | (clbCustomer.ControlValues=="ALL")?"": clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e5a1f630 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:662 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues=="ALL")?"": clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0b54fce6 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:664 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | CString.GetCheckedListValue(dtPlantSite, clbPlantSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-15277791 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:665 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7196cf49 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:666 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0f466e12 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:667 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-edff3d2a | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:668 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-265378a2 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:669 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-90f4de9d | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:670 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-81a1aacc | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:672 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-878f5bac | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:674 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-38ab6c26 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:687 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4119ab1 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:687 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a79fa975 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:691 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-39e0426e | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:692 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5ac44e4 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:693 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-a14c9a6f | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:699 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-10e864b9 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:710 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e45b907c | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:733 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-e7a589f8 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:737 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 표시 설정 |  |  |  |
| AC-56ba0f25 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:750 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns… | GRID_STYLE | siMain.SetBGColor | (iRow, iFrom, iRow, iTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-d3966ddf | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:756 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4fe7f754 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:764 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b68b236 | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:768 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b33185ce | FindButton 외 1 | DMF0066_ShipmentRequest_JV.cs:770 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0066_ShipmentRequest_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ed299bc | this.Load | DMF0066_ShipmentRequest_JV.cs:2381 |  | STATE | clbPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5cf8410d | this.Load | DMF0066_ShipmentRequest_JV.cs:2384 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-67e7cade | this.Load | DMF0066_ShipmentRequest_JV.cs:2388 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-adf0f708 | this.Load | DMF0066_ShipmentRequest_JV.cs:2390 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-e1fbb237 | this.Load | DMF0066_ShipmentRequest_JV.cs:2391 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4a15618d | this.Load | DMF0066_ShipmentRequest_JV.cs:2392 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-126cf350 | this.Load | DMF0066_ShipmentRequest_JV.cs:2393 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-3e11da95 | this.Load | DMF0066_ShipmentRequest_JV.cs:2394 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99b07315 | this.Load | DMF0066_ShipmentRequest_JV.cs:2396 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cc0d38dd | this.Load | DMF0066_ShipmentRequest_JV.cs:2405 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8f4101d | this.Load | DMF0066_ShipmentRequest_JV.cs:2407 |  | STATE | clbPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## DMF0066_ShipmentRequest_JV.fnValidation

진입점: SaveButton [try ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00d31264 | SaveButton [try ▸ if (fps.Name == "spdMain")] | DMF0066_ShipmentRequest_JV.cs:2313 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-fb676f47 | SaveButton [try ▸ if (fps.Name == "spdMain")] | DMF0066_ShipmentRequest_JV.cs:2316 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0066_ShipmentRequest_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61be1d48 | this.Load | DMF0066_ShipmentRequest_JV.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c2de0511 | this.Load | DMF0066_ShipmentRequest_JV.cs:175 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0066_ShipmentRequest_JV.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-213cd9c3 | (진입점 미연결) | DMF0066_ShipmentRequest_JV.cs:2353 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-018e2c06 | (진입점 미연결) | DMF0066_ShipmentRequest_JV.cs:2354 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1cadb5bc | (진입점 미연결) | DMF0066_ShipmentRequest_JV.cs:2355 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f2d9a2c | (진입점 미연결) | DMF0066_ShipmentRequest_JV.cs:2358 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0066_ShipmentRequest_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc664474 | this.Load | DMF0066_ShipmentRequest_JV.cs:2341 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-f594a138 | this.Load | DMF0066_ShipmentRequest_JV.cs:2342 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8dd9861 | this.Load | DMF0066_ShipmentRequest_JV.cs:2344 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0066_ShipmentRequest_JV.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0aaf6573 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2324 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0045_GET_SPREAD_TITLE") ⇒ DM.DMF0045_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-907a476f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2325 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7278ce23 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2326 |  | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-8ea99926 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2327 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bbd9382c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2328 |  | DATA_OP | request.Parameters["p_start_dt"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-971a1571 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2329 |  | DATA_OP | request.Parameters["p_end_dt"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-0129d090 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2331 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2648506e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2331 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4e07332 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2332 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-053b4c79 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:2332 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0066_ShipmentRequest_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae344bd | this.Load | DMF0066_ShipmentRequest_JV.cs:206 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c8e13d1 | this.Load | DMF0066_ShipmentRequest_JV.cs:206 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef853ef2 | this.Load | DMF0066_ShipmentRequest_JV.cs:210 | for (i <= dtDivision.Rows.Count - 1) ▸ if (dtDivision.Rows[i]["CODE"].ToString() == "40") | DATA_OP | dtDivision.Rows.RemoveAt | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-04f2ac83 | this.Load | DMF0066_ShipmentRequest_JV.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eadc1a24 | this.Load | DMF0066_ShipmentRequest_JV.cs:215 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-78684892 | this.Load | DMF0066_ShipmentRequest_JV.cs:215 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-65c73954 | this.Load | DMF0066_ShipmentRequest_JV.cs:216 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6c959f79 | this.Load | DMF0066_ShipmentRequest_JV.cs:216 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06f8c350 | this.Load | DMF0066_ShipmentRequest_JV.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aeabd262 | this.Load | DMF0066_ShipmentRequest_JV.cs:220 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-19ba7b62 | this.Load | DMF0066_ShipmentRequest_JV.cs:220 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b0d7e44 | this.Load | DMF0066_ShipmentRequest_JV.cs:221 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-034e903d | this.Load | DMF0066_ShipmentRequest_JV.cs:225 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-79fce056 | this.Load | DMF0066_ShipmentRequest_JV.cs:225 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bcc0b14d | this.Load | DMF0066_ShipmentRequest_JV.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3b663314 | this.Load | DMF0066_ShipmentRequest_JV.cs:228 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-eadcffe2 | this.Load | DMF0066_ShipmentRequest_JV.cs:228 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60c75a5b | this.Load | DMF0066_ShipmentRequest_JV.cs:233 |  | CALL_EXT | dic_JV_Plant.TryGetValue | (sDivision, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9199ff7e | this.Load | DMF0066_ShipmentRequest_JV.cs:239 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | DATA_OP | dtPlantSite.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-721d5832 | this.Load | DMF0066_ShipmentRequest_JV.cs:240 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | DATA_OP | dtPlantSite.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d831b99 | this.Load | DMF0066_ShipmentRequest_JV.cs:243 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | STATE_RESET | dtPlantSite.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7b037257 | this.Load | DMF0066_ShipmentRequest_JV.cs:247 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) | DATA_OP | dtFromSite_Tmp_data.Select().Where(c => c["CODE"].ToString().Contains(getValue_split[i])).… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3be5de1d | this.Load | DMF0066_ShipmentRequest_JV.cs:247 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) | DATA_OP | dtFromSite_Tmp_data.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad011d2b | this.Load | DMF0066_ShipmentRequest_JV.cs:247 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) ▸ lambda | DATA_OP | c["CODE"].ToString().Contains | (getValue_split[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-37c4d159 | this.Load | DMF0066_ShipmentRequest_JV.cs:251 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) ▸ for (i < getValue_split.Length) ▸ for (j < dtFromSite_Tmp.… | DATA_OP | dtPlantSite.ImportRow | (dtFromSite_Tmp.Rows[j]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a921cc2 | this.Load | DMF0066_ShipmentRequest_JV.cs:255 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | STATE_RESET | dtFromSite_Tmp.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-6d357192 | this.Load | DMF0066_ShipmentRequest_JV.cs:256 | if (get_JV_Value != "" && (dtPlantSite.Rows.Count != 0 && dtPlantSite != null)) | STATE_RESET | dtFromSite_Tmp_data.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1075c678 | this.Load | DMF0066_ShipmentRequest_JV.cs:258 | if (get_JV_Value == "") | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-59fed5c0 | this.Load | DMF0066_ShipmentRequest_JV.cs:259 | else of (get_JV_Value == "") | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-16bfe235 | this.Load | DMF0066_ShipmentRequest_JV.cs:262 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6bcd73b9 | this.Load | DMF0066_ShipmentRequest_JV.cs:264 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-21822b70 | this.Load | DMF0066_ShipmentRequest_JV.cs:265 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e8f12ef7 | this.Load | DMF0066_ShipmentRequest_JV.cs:268 |  | VALUE_SET | drpPeriod.InitValue | DateTime.Now.ToString("yyyyMMdd") + ":" + DateTime.Now.AddDays(55).ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-a248483c | this.Load | DMF0066_ShipmentRequest_JV.cs:270 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-6400a3d4 | this.Load | DMF0066_ShipmentRequest_JV.cs:270 |  | COMBO_DATA | Data.Common | (Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b5cc512 | this.Load | DMF0066_ShipmentRequest_JV.cs:273 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f882235c | this.Load | DMF0066_ShipmentRequest_JV.cs:274 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |

## DMF0066_ShipmentRequest_JV.InitSaveDataTable

진입점: this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e0e2e23 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:439 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-22c565f8 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:440 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b461e59 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:441 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c88cfc6 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:442 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FromSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-84256bb5 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:443 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bd035de | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:444 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1178de9 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:445 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a037333 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:446 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.TrMode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-599c2b53 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:447 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba95c467 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:448 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ToSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec8db812 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:449 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3b88853 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:452 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BodId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7edd7d80 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0066_ShipmentRequest_JV.cs:453 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0066_ShipmentRequest_JV.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4673d48 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:311 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0066_ShipmentRequest_JV.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acc8881f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:324 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4ee528f5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:325 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-7c40a54f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:332 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-06abcfc8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:333 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e075a5b4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:334 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-7e29a22c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:335 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad872e32 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1033 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fac7d582 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33e72957 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1cfd0ec0 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1039 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-fd772294 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TrMode)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-616fb04d | InsertButton | DMF0066_ShipmentRequest_JV.cs:1046 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2ad89a2 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1047 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.Common | (Data.Type.FCST_TYPE) ⇒ biz:CommonData.CommonDataList [code=FCST_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37a50229 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1049 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), dtFcstType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cbec8d15 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1050 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e25394e7 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1050 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5872ec1c | InsertButton | DMF0066_ShipmentRequest_JV.cs:1051 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3f1a4145 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1055 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlVal… | 그리드 값 설정 |  |  |  |
| AC-9ca98b2f | InsertButton | DMF0066_ShipmentRequest_JV.cs:1056 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), "SHIP_REQ") | 그리드 값 설정 |  |  |  |
| AC-1b1d7238 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1061 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-29f048c2 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1062 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NickName), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c68d240d | InsertButton | DMF0066_ShipmentRequest_JV.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.R… | 그리드 편집 잠금/해제 |  |  |  |
| AC-71d7d350 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1088 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iResultCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ecfbc739 | InsertButton | DMF0066_ShipmentRequest_JV.cs:1089 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-964069dd | InsertButton | DMF0066_ShipmentRequest_JV.cs:1090 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-815f33cf | InsertButton | DMF0066_ShipmentRequest_JV.cs:1103 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0cf4c3ea | InsertButton | DMF0066_ShipmentRequest_JV.cs:1110 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad5c84ac | InsertButton | DMF0066_ShipmentRequest_JV.cs:1117 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06268c1a | InsertButton | DMF0066_ShipmentRequest_JV.cs:1122 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0066_ShipmentRequest_JV.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d538f64 | OnShown | DMF0066_ShipmentRequest_JV.cs:193 | if (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-aeb83d35 | OnShown | DMF0066_ShipmentRequest_JV.cs:197 | else of (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48cbb4aa | SaveButton | DMF0066_ShipmentRequest_JV.cs:849 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2622ccd0 | SaveButton | DMF0066_ShipmentRequest_JV.cs:853 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d5420ca | SaveButton | DMF0066_ShipmentRequest_JV.cs:858 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10aba09e | SaveButton | DMF0066_ShipmentRequest_JV.cs:861 | try ▸ if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-467386a2 | SaveButton | DMF0066_ShipmentRequest_JV.cs:861 | try ▸ if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fd342be | SaveButton | DMF0066_ShipmentRequest_JV.cs:866 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c73a030f | SaveButton | DMF0066_ShipmentRequest_JV.cs:867 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d888f71 | SaveButton | DMF0066_ShipmentRequest_JV.cs:911 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-c97a7370 | SaveButton | DMF0066_ShipmentRequest_JV.cs:912 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31980063 | SaveButton | DMF0066_ShipmentRequest_JV.cs:913 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca4fc84c | SaveButton | DMF0066_ShipmentRequest_JV.cs:939 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-35029cc2 | SaveButton | DMF0066_ShipmentRequest_JV.cs:942 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("DM.DMF0045_SAVE_SHIPMENT_REQUEST") ⇒ DM.DMF0045_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-4de2b4fc | SaveButton | DMF0066_ShipmentRequest_JV.cs:945 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9027abd5 | SaveButton | DMF0066_ShipmentRequest_JV.cs:947 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1cf4358 | SaveButton | DMF0066_ShipmentRequest_JV.cs:951 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7fad0b8e | SaveButton | DMF0066_ShipmentRequest_JV.cs:953 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-ed5b375b | SaveButton | DMF0066_ShipmentRequest_JV.cs:954 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b508b2ae | SaveButton | DMF0066_ShipmentRequest_JV.cs:955 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e56e50d4 | SaveButton | DMF0066_ShipmentRequest_JV.cs:956 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-66c3f4c4 | SaveButton | DMF0066_ShipmentRequest_JV.cs:957 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-29f5fadd | SaveButton | DMF0066_ShipmentRequest_JV.cs:958 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-318d6e36 | SaveButton | DMF0066_ShipmentRequest_JV.cs:959 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-6ee9a17e | SaveButton | DMF0066_ShipmentRequest_JV.cs:960 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-210aacc3 | SaveButton | DMF0066_ShipmentRequest_JV.cs:961 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-d4c70e34 | SaveButton | DMF0066_ShipmentRequest_JV.cs:962 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-d71e8f15 | SaveButton | DMF0066_ShipmentRequest_JV.cs:963 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-bf6a2d96 | SaveButton | DMF0066_ShipmentRequest_JV.cs:964 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-03044189 | SaveButton | DMF0066_ShipmentRequest_JV.cs:965 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-73b1c322 | SaveButton | DMF0066_ShipmentRequest_JV.cs:966 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-06215326 | SaveButton | DMF0066_ShipmentRequest_JV.cs:967 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2f3000b4 | SaveButton | DMF0066_ShipmentRequest_JV.cs:969 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96ad3735 | SaveButton | DMF0066_ShipmentRequest_JV.cs:969 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-58b13f8b | SaveButton | DMF0066_ShipmentRequest_JV.cs:980 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-074e132d | SaveButton | DMF0066_ShipmentRequest_JV.cs:981 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-668e2e1c | SaveButton | DMF0066_ShipmentRequest_JV.cs:983 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-90112d06 | SaveButton | DMF0066_ShipmentRequest_JV.cs:985 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-feee7faa | SaveButton | DMF0066_ShipmentRequest_JV.cs:986 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bd6653f5 | SaveButton | DMF0066_ShipmentRequest_JV.cs:996 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ac90296e | SaveButton | DMF0066_ShipmentRequest_JV.cs:997 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-998214e3 | SaveButton | DMF0066_ShipmentRequest_JV.cs:1002 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0798e8bf | SaveButton | DMF0066_ShipmentRequest_JV.cs:1003 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59c53888 | SaveButton | DMF0066_ShipmentRequest_JV.cs:1009 | try ▸ if (fps.Name == "spdMain") ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8cd1e64 | SaveButton | DMF0066_ShipmentRequest_JV.cs:1015 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fa7304c1 | SaveButton | DMF0066_ShipmentRequest_JV.cs:1016 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab800fe2 | SaveButton | DMF0066_ShipmentRequest_JV.cs:1022 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0066_ShipmentRequest_JV.Set_SumValues

진입점: FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19c41621 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0066_ShipmentRequest_JV.cs:790 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3a6f165 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0066_ShipmentRequest_JV.cs:794 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcadb5fa | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0066_ShipmentRequest_JV.cs:829 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |
| AC-c1fdca26 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0066_ShipmentRequest_JV.cs:834 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efd937ab | (진입점 미연결) | DMF0066_ShipmentRequest_JV.cs:1527 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TrMode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.SetSaveData

진입점: dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)] / dsdmCell.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fa4958e | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2098 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-937da334 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2102 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ace1cb40 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2103 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cd4bb9e2 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2104 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-d83956bd | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2105 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FromSite] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3860227c | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2106 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-a26f03fe | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2107 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-f8174755 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2108 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-821c7467 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2109 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-57975cb6 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2110 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ToSite] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-0e08a0a1 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2111 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-e2cda072 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2112 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-a46f4bdf | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2114 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-06b9bc2a | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2115 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e6379b69 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2119 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-7d776c2b | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0066_ShipmentRequest_JV.cs:2120 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0066_ShipmentRequest_JV.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0)] / SaveButton [try ▸ if (fps.N…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49d66146 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2227 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-52f85f01 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2232 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e623c24d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2239 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-67596a26 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2243 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a4e8c8df | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2248 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-6b9a0dad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2255 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-80957098 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0066_ShipmentRequest_JV.cs:2259 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e72dad8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:366 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c5fb32b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:374 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae786b6c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:385 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-06236129 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:391 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44e30559 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:392 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b3153af | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:397 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-530438d0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:398 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21d903cb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:405 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cd21d25 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:406 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16358ead | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:417 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf79f8a1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:418 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03dc513c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:419 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1f5f54a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:420 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-529bf343 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:422 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eac12ab4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0066_ShipmentRequest_JV.cs:424 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0066_ShipmentRequest_JV.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b935d2d | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1286 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-0eca354a | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1292 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-7ff0fb8d | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1308 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-ff0ce354 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1322 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b12930b8 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1343 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-6b7fc8c4 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1344 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-704b0501 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1345 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e4d6cd1f | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1346 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8a3e5cf9 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1358 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-3c790a7d | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1362 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-c2d92e51 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1367 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-d021fc10 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1372 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), sBizType) | 그리드 값 설정 |  |  |  |
| AC-7c6e46d8 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1377 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectOwner), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-f39da8f3 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1382 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-b0515b01 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1389 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId)) | 그리드 표시 설정 |  |  |  |
| AC-3be94372 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1398 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5920945e | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1405 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new DMF0046_GetBODItemPrjRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-d14b5ee4 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1406 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_division_id | p_divisionId | 속성 p_division_id 설정 |  |  |  |
| AC-75c62ef8 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1407 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_item_id | p_item_id | 속성 p_item_id 설정 |  |  |  |
| AC-347dd9d1 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1408 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_from_site | p_from_site | 속성 p_from_site 설정 |  |  |  |
| AC-77f65127 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1410 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4e3229b2 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1411 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | bodPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f0714f48 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1433 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), sFromSite) | 그리드 값 설정 |  |  |  |
| AC-181ad7d2 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1438 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ToSite), sToSite) | 그리드 값 설정 |  |  |  |
| AC-6cbbd734 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1443 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-950d5994 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1448 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TrMode), sTransportMode) | 그리드 값 설정 |  |  |  |
| AC-6b7b70e1 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1452 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BodId), sBodId) | 그리드 값 설정 |  |  |  |
| AC-e4a206fc | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1456 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-379f44d4 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1460 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-029e2ebf | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1464 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sDeptNameKo) | 그리드 값 설정 |  |  |  |
| AC-924eed15 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1471 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId)) | 그리드 표시 설정 |  |  |  |
| AC-c2428faf | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1485 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | new DMF0047_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a5bb90da | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1486 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.Form_Load | (false, p_divisionId, "", "", "", "", "", sBizType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c5cd9263 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1487 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-44e65356 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1488 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-118a417e | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1498 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |
| AC-18d3fb94 | this.spdMain.CellDoubleClick | DMF0066_ShipmentRequest_JV.cs:1502 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.spdMain_Changed

진입점: dsdmPack.Changed / dsdmCell.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74cd9264 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1535 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f947dba | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1570 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Division ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8273114c | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1572 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-abc41536 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1574 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ec0e827 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1578 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Project Code" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1fd08992 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1580 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-1b6a9fd2 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1582 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-feaa2e0b | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1586 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Sales Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80b3dde4 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1588 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-42c05999 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1590 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-508063ca | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1594 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Item ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f718af7 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1596 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-3a104b6e | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1598 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89efb6c9 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1602 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "FCST Type" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0682dddc | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1604 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-3483b3ff | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1606 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ce30ced | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1610 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Incoterms" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a5bec16 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1612 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-d916e74f | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1614 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b794e02 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1618 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05d0f10c | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1620 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-6bd799a8 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1622 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd685ab5 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1626 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plant Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9280563c | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1628 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-07093717 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1630 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6120b387 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1657 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-cf46fa24 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1680 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-92616e05 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1694 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.ActiveSheet.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-d8361469 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1760 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e78a1854 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1768 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2416c8ba | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1783 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-c98a69b1 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1791 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-ed4cf97f | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1813 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-3d38dc6c | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1824 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-606ededa | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1838 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-71fb010e | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1848 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iSetCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-86077ca8 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1876 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-18bdfb5e | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1886 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-075f8999 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1967 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-deef96d7 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1975 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ede9c3ba | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1989 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-8a023cb2 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:1997 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-b83e2dfa | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:2014 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-d3d6bc54 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:2044 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2ca4635c | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:2049 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7ec17b51 | dsdmPack.Changed 외 1 | DMF0066_ShipmentRequest_JV.cs:2075 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31fc1ac6 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1232 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-486c2748 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1232 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09c1c4d5 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1233 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-df17be19 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1237 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-69920763 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1241 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "") | 그리드 값 설정 |  |  |  |
| AC-07f31168 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1246 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "") | 그리드 값 설정 |  |  |  |
| AC-7d232ce5 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1251 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), "") | 그리드 값 설정 |  |  |  |
| AC-8e8d4ca3 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1256 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-c312d55f | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1261 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-a62d0300 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1269 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e760e65a | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1269 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-49c463a4 | this.spdMain.ComboSelChange | DMF0066_ShipmentRequest_JV.cs:1270 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0066_ShipmentRequest_JV.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30cc78dc | this.spdMain.KeyUp | DMF0066_ShipmentRequest_JV.cs:2134 | if (siMain.GetColumnIndex(DefColumns.Requestor) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60b4b3d2 | this.spdMain.KeyUp | DMF0066_ShipmentRequest_JV.cs:2138 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04d1a7f0 | this.spdMain.KeyUp | DMF0066_ShipmentRequest_JV.cs:2143 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fb29d9e | this.spdMain.KeyUp | DMF0066_ShipmentRequest_JV.cs:2144 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0066_ShipmentRequest_JV.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baca8f20 | this.spdMain.TopChange | DMF0066_ShipmentRequest_JV.cs:2128 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

