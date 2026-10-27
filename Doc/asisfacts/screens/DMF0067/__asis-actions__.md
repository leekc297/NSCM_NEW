# AS-IS 액션 대조표 — DMF0067

> 원천: `Doc/asisfacts/screens/DMF0067/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 588행 · 메서드 50 · 종류 DATA_OP 93 · GRID_LOCK 78 · GRID_SET 61 · FLAG 56 · RETURN 44 · POPUP 30 · COMBO_DATA 30 · UI_PROP 28 · STATE 26 · LIST_REBIND 24 · MESSAGE 23 · CALL_EXT 22 · ENDPOINT 21 · GRID_INIT 19 · GRID_COMBO 13 · UI_MISC 9 · VALUE_SET 5 · VALUE_CLEAR 3 · GRID_STYLE 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 22


## DMF0067_BizPlanRaw.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49f071c0 | this.btnColumn.Click | DMF0067_BizPlanRaw.cs:2876 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042_3", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b648accb | this.btnColumn.Click | DMF0067_BizPlanRaw.cs:2877 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-43521c78 | this.btnColumn.Click | DMF0067_BizPlanRaw.cs:2878 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0067_BizPlanRaw.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-639f3c4f | this.btnCutOff.Click | DMF0067_BizPlanRaw.cs:2911 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-b032d52b | this.btnCutOff.Click | DMF0067_BizPlanRaw.cs:2912 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76014e34 | this.btnCutOff.Click | DMF0067_BizPlanRaw.cs:2919 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-19527ecd | this.btnCutOff.Click | DMF0067_BizPlanRaw.cs:2924 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8854365 | this.btnCutOff.Click | DMF0067_BizPlanRaw.cs:2926 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-57c806ac | this.btnCutOff.Click | DMF0067_BizPlanRaw.cs:2927 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0067_BizPlanRaw.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-041edbe4 | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3106 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d634e742 | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3107 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc9438e5 | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3110 |  | POPUP | new POPUP.DMF0042_ExchangeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-a1a34f8d | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3111 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP", clbDivisi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d04a3d6e | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3113 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa2b7549 | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3114 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1fa7a9b1 | this.btnExchangeRate.Click | DMF0067_BizPlanRaw.cs:3118 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0067_BizPlanRaw.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f60d2071 | this.btnItemId.Click | DMF0067_BizPlanRaw.cs:2860 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-54105c57 | this.btnItemId.Click | DMF0067_BizPlanRaw.cs:2862 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4cd396e9 | this.btnItemId.Click | DMF0067_BizPlanRaw.cs:2863 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-42366146 | this.btnItemId.Click | DMF0067_BizPlanRaw.cs:2864 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cb06c4e3 | this.btnItemId.Click | DMF0067_BizPlanRaw.cs:2870 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0067_BizPlanRaw.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baf7e1b3 | this.btnMeasure.Click | DMF0067_BizPlanRaw.cs:2888 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042_3", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-e5586204 | this.btnMeasure.Click | DMF0067_BizPlanRaw.cs:2890 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-53c0d265 | this.btnMeasure.Click | DMF0067_BizPlanRaw.cs:2891 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0067_BizPlanRaw.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3eaee7ee | this.btnOwner.Click | DMF0067_BizPlanRaw.cs:3070 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-05feb725 | this.btnOwner.Click | DMF0067_BizPlanRaw.cs:3073 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6ac3818d | this.btnOwner.Click | DMF0067_BizPlanRaw.cs:3074 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-084efd37 | this.btnOwner.Click | DMF0067_BizPlanRaw.cs:3075 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ebe8a3c5 | this.btnOwner.Click | DMF0067_BizPlanRaw.cs:3077 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0067_BizPlanRaw.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2bde1b5 | this.btnProject.Click 외 1 | DMF0067_BizPlanRaw.cs:2838 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-7c63afdf | this.btnProject.Click 외 1 | DMF0067_BizPlanRaw.cs:2839 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-47b3e15d | this.btnProject.Click 외 1 | DMF0067_BizPlanRaw.cs:2840 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aa24af17 | this.btnProject.Click 외 1 | DMF0067_BizPlanRaw.cs:2841 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-94248ce3 | this.btnProject.Click 외 1 | DMF0067_BizPlanRaw.cs:2847 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0067_BizPlanRaw.btnReplace_Click

진입점: this.btnReplace.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fc2d52c | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3504 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-04c9ab61 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3505 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5607882 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3512 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-dafaeed2 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3513 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4d3ce7c | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3518 |  | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8491e906 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3522 |  | DATA_OP | dt.Columns.Add | ("YYYYMM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-247fdc38 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3526 | if (spdMain.Sheets[0].RowCount == 0) | MESSAGE | MessageBox.Show | ("데이터 조회 후 다시 시도해 주시기 바랍니다.") | 메시지 표시 |  |  |  |
| AC-11e22787 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3527 | if (spdMain.Sheets[0].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4f38a90 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3546 | else of (cr == null) ▸ for (i <= ColEnd) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1857d30d | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3550 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | row["YYYYMM"] | colTag.Substring(2, 6).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f5907bf | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3551 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-37431d3a | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3579 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-66da5626 | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3583 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4df4c26c | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3585 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3f10736e | this.btnReplace.Click | DMF0067_BizPlanRaw.cs:3586 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0067_BizPlanRaw.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d0d82b4 | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3234 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00282") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4a280bc | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3235 | if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0eef6db | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3241 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | 엔드포인트 요청 생성 |  |  |  |
| AC-9796ca0c | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3243 |  | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ea32ec46 | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3245 |  | DATA_OP | request.Parameters["s_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd7ab9dc | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3246 |  | DATA_OP | request.Parameters["s_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0b3eefa6 | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3247 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6678cac | this.btnSetPrice.Click | DMF0067_BizPlanRaw.cs:3250 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0067_BizPlanRaw.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33bb34e6 | this.cboBucketType.Click | DMF0067_BizPlanRaw.cs:3086 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56aa6d07 | this.cboBucketType.Click | DMF0067_BizPlanRaw.cs:3087 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db9b1a2b | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1497 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-b02fb480 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1497 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b15b6db5 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1498 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20d03cc5 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1506 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-07187b8b | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1506 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2045c410 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1507 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f0ee1bb | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1509 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-e290fc7d | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1509 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c86bf4cc | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1511 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b2509248 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1512 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c1b45b98 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1513 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e4c39970 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1514 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-963a4885 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1518 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f4a04dd | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1519 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-58fd232c | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1521 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad796ab3 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1521 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4de36f12 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1523 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b39bbb1b | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1524 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83ead1e6 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1525 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a411f366 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1527 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-e430eeb3 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1531 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-85067ab1 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1532 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a4ba69a4 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1534 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1e5fb174 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1534 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00f3d88b | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1536 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e106eabb | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1537 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-64d12c97 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1538 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-04b6c548 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1540 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-63cd9633 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1544 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4f0913fe | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1546 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bff5ccb2 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1549 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7a9e7c79 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1549 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ee5a4f7 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1550 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fc87536e | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1552 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-38bb7210 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1552 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6df625a | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1553 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3831706f | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1555 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-f42a4523 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1556 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eed77fe1 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1558 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-c0cc7df3 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1560 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-4ad185ea | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1561 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4b4f57c3 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1564 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1b01839 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1565 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-110160cf | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1567 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-c86d8a47 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1567 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ac91695 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1569 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d42cfe99 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1571 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e7292deb | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1572 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e69a0ec7 | clbDivision.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1573 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0067_BizPlanRaw.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4468e83f | this.clbCustomer.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1607 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-84c72342 | this.clbCustomer.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1607 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-abe002c1 | this.clbCustomer.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1611 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-649e8a7c | this.clbCustomer.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1611 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9023dbe2 | this.clbCustomer.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1613 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0067_BizPlanRaw.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fafde829 | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1585 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b8990ef0 | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1585 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d46db12d | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1586 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2b9afef7 | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1588 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e1de7324 | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1588 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3948863b | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1592 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-cab6dfbf | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1592 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e7e5319 | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1593 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-71a974f3 | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1595 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-afa3454a | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1595 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-052201ed | this.clbTeam.SelectedIndexChanged | DMF0067_BizPlanRaw.cs:1599 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0067_BizPlanRaw.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7950a1a | this.Load | DMF0067_BizPlanRaw.cs:389 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97cd28a8 | this.Load | DMF0067_BizPlanRaw.cs:390 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7e87ae4 | this.Load | DMF0067_BizPlanRaw.cs:391 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0067_BizPlanRaw.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec321934 | this.Load | DMF0067_BizPlanRaw.cs:352 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-720d80b9 | this.Load | DMF0067_BizPlanRaw.cs:354 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-18cb8238 | this.Load | DMF0067_BizPlanRaw.cs:356 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e3eb219d | this.Load | DMF0067_BizPlanRaw.cs:357 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-9d05499a | this.Load | DMF0067_BizPlanRaw.cs:358 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-bd0956d1 | this.Load | DMF0067_BizPlanRaw.cs:359 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-adc39037 | this.Load | DMF0067_BizPlanRaw.cs:369 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7ff34f19 | this.Load | DMF0067_BizPlanRaw.cs:370 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-499b198c | this.Load | DMF0067_BizPlanRaw.cs:374 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1f2fe05a | this.Load | DMF0067_BizPlanRaw.cs:375 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0067_BizPlanRaw.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64fdfff5 | DeleteButton | DMF0067_BizPlanRaw.cs:554 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21c14d1e | DeleteButton | DMF0067_BizPlanRaw.cs:560 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-1c6c5447 | DeleteButton | DMF0067_BizPlanRaw.cs:561 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0067_BizPlanRaw.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a31220ad | Dispose | DMF0067_BizPlanRaw.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0067_BizPlanRaw.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae515774 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:574 | if (this.fps != null) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e73e11e4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:575 | if (this.fps != null) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-600de707 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:578 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a2e26e5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:579 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c6682f83 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:581 | if (this.fps != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dd24c3d0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:588 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-0cbf005a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:596 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (siMain.… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ca1356cb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:604 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-108419b9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:612 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f431c64d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:617 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-cab7465d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:624 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2e9d9b4c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:632 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-753d63d2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:637 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-c6f72add | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:652 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange2 | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-451db8a7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:661 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sDivisi… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-af119435 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:662 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sDivisi… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-0269512f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:667 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sD… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-775193a2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:669 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sD… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-3f55dcb1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:683 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && (sMeasure == "Business_Plan")) ▸ for (… | GRID_LOCK | siMain.LockRange2 | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-7532e164 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:691 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && (sMeasure == "Business_Plan")) | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금 전환 |  |  |  |
| AC-9722c021 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:697 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!IsEditMode) | GRID_LOCK | siMain.LockRange2 | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-fc2bfa21 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0067_BizPlanRaw.cs:700 | if (this.fps != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0067_BizPlanRaw.FindData

진입점: this.btnSetPrice.Click / this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e84cfff | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:717 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b6f49a7a | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:726 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50d636a0 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:727 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e53b661 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:734 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-671b3867 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:735 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-117ed590 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:740 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00276") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed791fd9 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:741 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(6) | 속성 Value2 설정 |  |  |  |
| AC-c867e8ed | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:742 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29d6f169 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:747 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5d0adda | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:749 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a57cbe34 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:753 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-804b0273 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:754 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e6f9ed39 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:757 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c230e127 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:764 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6d6cd3b | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:768 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_3_Get_BizPlan") ⇒ DM.DMF0042_3_Get_BizPlan | 엔드포인트 요청 생성 |  |  |  |
| AC-263cf2b3 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:770 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3506200f | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:772 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2e75596a | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:773 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8235dffa | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:774 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-087b3ec4 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:775 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-60647151 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:776 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-52abe79f | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:777 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ee78c43a | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:778 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5c0df548 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:779 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-75fef16f | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:780 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-bc4888d8 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:781 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-49cfee1b | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:782 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d43ce8b4 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:783 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-78903338 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:784 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d71cd399 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:785 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86d54096 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:786 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-9a11a0f1 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:787 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d2036248 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:789 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcfe9466 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:791 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-43553e32 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:796 | try | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2dde8f48 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:797 | try | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed3e3b30 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:801 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | valid_YN | ds.Tables[1].Rows[0]["VALID_YN"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-98523256 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:802 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYQQ | ds.Tables[1].Rows[0]["START_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-26287782 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:803 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYQQ | ds.Tables[1].Rows[0]["END_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5bccfc48 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:804 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYMM | ds.Tables[1].Rows[0]["START_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a93b405b | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:805 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYMM | ds.Tables[1].Rows[0]["END_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7e5bc2f | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:806 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYY | ds.Tables[1].Rows[0]["START_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e9b15e | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:807 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYY | ds.Tables[1].Rows[0]["END_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1343fccb | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:810 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77a34790 | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:819 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecbce0be | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:823 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bd6b6a7a | this.btnSetPrice.Click 외 3 | DMF0067_BizPlanRaw.cs:825 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0067_BizPlanRaw.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-835cd7f3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0067_BizPlanRaw.cs:3390 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-69d28173 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0067_BizPlanRaw.cs:3393 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ead63c32 | this.Load | DMF0067_BizPlanRaw.cs:236 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1007460b | this.Load | DMF0067_BizPlanRaw.cs:237 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0067_BizPlanRaw.GetBizTypebyDivision

진입점: this.Load [if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83907bba | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0067_BizPlanRaw.cs:3037 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3f10a89c | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0067_BizPlanRaw.cs:3038 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3f604504 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0067_BizPlanRaw.cs:3039 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-611bd756 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0067_BizPlanRaw.cs:3041 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) \|\| (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == e.Column))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49b69c32 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0067_BizPlanRaw.cs:3404 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b488fa0 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0067_BizPlanRaw.cs:3194 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a459394 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0067_BizPlanRaw.cs:3195 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-198684d2 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0067_BizPlanRaw.cs:3182 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-39090384 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0067_BizPlanRaw.cs:3187 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetCellProdSite

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a66ae130 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3487 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-7706ae69 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3488 |  | DATA_OP | request.Parameters["CODE"] | "DM_CELL_PROD_SITE" | 행/컬럼 값 대입 |  |  |  |
| AC-81c0a6f3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3489 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec2009af | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3490 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f154e1d | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3491 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f14853a3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3492 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9b00ae1 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3493 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f9df4b97 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3494 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2a49670 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0067_BizPlanRaw.cs:3496 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetComboData

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load [if (sDivision != null && sDivision != "") ▸ if (sDivision == "40")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ if (sDivision == "40")] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d5a8cb3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2954 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_CODE") ⇒ DM.DMF0009_GET_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-99215c83 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2955 |  | DATA_OP | request.Parameters["p_code_type"] | code | 행/컬럼 값 대입 |  |  |  |
| AC-41bd9bee | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2956 |  | DATA_OP | request.Parameters["p_param1"] | (param1 == null ? "" : param1) | 행/컬럼 값 대입 |  |  |  |
| AC-ba523c45 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2957 |  | DATA_OP | request.Parameters["p_param2"] | (param2 == null ? "" : param2) | 행/컬럼 값 대입 |  |  |  |
| AC-2f3031df | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2958 |  | DATA_OP | request.Parameters["p_param3"] | (param3 == null ? "" : param3) | 행/컬럼 값 대입 |  |  |  |
| AC-cad71f55 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2960 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7d9caae9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2962 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6de3af5 | this.Load 외 1 | DMF0067_BizPlanRaw.cs:2991 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-9f114701 | this.Load 외 1 | DMF0067_BizPlanRaw.cs:2992 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-61ef959f | this.Load 외 1 | DMF0067_BizPlanRaw.cs:2993 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-192a2cef | this.Load 외 1 | DMF0067_BizPlanRaw.cs:2995 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f414e25e | this.Load 외 1 | DMF0067_BizPlanRaw.cs:2998 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce1ce683 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0067_BizPlanRaw.cs:3132 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_EXCHANGE_PRICE") ⇒ DM.DMF0042_GET_EXCHANGE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-c801c1f9 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0067_BizPlanRaw.cs:3133 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-86696b2f | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0067_BizPlanRaw.cs:3134 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e5ab21a5 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0067_BizPlanRaw.cs:3135 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84531df4 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0067_BizPlanRaw.cs:3137 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetLookupData

진입점: this.Load / clbDivision.SelectedIndexChanged / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-159a63ea | this.Load 외 2 | DMF0067_BizPlanRaw.cs:3024 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-cb106978 | this.Load 외 2 | DMF0067_BizPlanRaw.cs:3025 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-5a8f1c99 | this.Load 외 2 | DMF0067_BizPlanRaw.cs:3026 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-67f70ac8 | this.Load 외 2 | DMF0067_BizPlanRaw.cs:3028 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-896217da | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3007 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_3_GET_SPREAD_TITLE") ⇒ DM.DMF0042_3_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-baceb72a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3009 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-2ac55599 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3010 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-1d68043f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3011 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e023a7e8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3012 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f7f56313 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3014 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe69a398 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:3014 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0067_BizPlanRaw.GetThisWeekMonday

진입점: this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-110ace46 | this.btnSetPrice.Click [try] 외 3 | DMF0067_BizPlanRaw.cs:3158 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25a052e6 | this.Load | DMF0067_BizPlanRaw.cs:259 |  | DATA_OP | this.ConditionNotUseList.Add | (cboClosed) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e72bd46 | this.Load | DMF0067_BizPlanRaw.cs:261 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-b83ee50f | this.Load | DMF0067_BizPlanRaw.cs:261 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b60f279a | this.Load | DMF0067_BizPlanRaw.cs:262 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e33b1434 | this.Load | DMF0067_BizPlanRaw.cs:265 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-77ab1751 | this.Load | DMF0067_BizPlanRaw.cs:265 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e31c047 | this.Load | DMF0067_BizPlanRaw.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a89f8317 | this.Load | DMF0067_BizPlanRaw.cs:269 |  | LIST_REBIND | clsCtrl.setListBox | (dtYn, cboClosed, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bbc0cf32 | this.Load | DMF0067_BizPlanRaw.cs:279 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d1dc8b7 | this.Load | DMF0067_BizPlanRaw.cs:279 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3916432f | this.Load | DMF0067_BizPlanRaw.cs:280 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f5161520 | this.Load | DMF0067_BizPlanRaw.cs:282 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-7484c32d | this.Load | DMF0067_BizPlanRaw.cs:282 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1b13301 | this.Load | DMF0067_BizPlanRaw.cs:284 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c7eafd12 | this.Load | DMF0067_BizPlanRaw.cs:285 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c79479f1 | this.Load | DMF0067_BizPlanRaw.cs:286 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-73c50030 | this.Load | DMF0067_BizPlanRaw.cs:287 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-a08092dc | this.Load | DMF0067_BizPlanRaw.cs:291 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-57b55741 | this.Load | DMF0067_BizPlanRaw.cs:292 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-77f146ef | this.Load | DMF0067_BizPlanRaw.cs:294 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7c4dd23d | this.Load | DMF0067_BizPlanRaw.cs:294 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-494e28da | this.Load | DMF0067_BizPlanRaw.cs:296 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-af54aaa3 | this.Load | DMF0067_BizPlanRaw.cs:297 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-94bbd520 | this.Load | DMF0067_BizPlanRaw.cs:298 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-df1ccccf | this.Load | DMF0067_BizPlanRaw.cs:300 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-02f493ca | this.Load | DMF0067_BizPlanRaw.cs:305 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-21997211 | this.Load | DMF0067_BizPlanRaw.cs:306 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-228d5676 | this.Load | DMF0067_BizPlanRaw.cs:308 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c62109ce | this.Load | DMF0067_BizPlanRaw.cs:308 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d8bef68 | this.Load | DMF0067_BizPlanRaw.cs:310 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-28b1593d | this.Load | DMF0067_BizPlanRaw.cs:311 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ec8a7ead | this.Load | DMF0067_BizPlanRaw.cs:312 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-279c3da8 | this.Load | DMF0067_BizPlanRaw.cs:314 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-0bab6660 | this.Load | DMF0067_BizPlanRaw.cs:318 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9f993f1d | this.Load | DMF0067_BizPlanRaw.cs:320 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-975ce90e | this.Load | DMF0067_BizPlanRaw.cs:323 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-318b5187 | this.Load | DMF0067_BizPlanRaw.cs:323 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f789787c | this.Load | DMF0067_BizPlanRaw.cs:324 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9bcd74c1 | this.Load | DMF0067_BizPlanRaw.cs:327 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9584fe2 | this.Load | DMF0067_BizPlanRaw.cs:327 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-084515a8 | this.Load | DMF0067_BizPlanRaw.cs:328 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4bf63bca | this.Load | DMF0067_BizPlanRaw.cs:330 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-328f661f | this.Load | DMF0067_BizPlanRaw.cs:331 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16c47007 | this.Load | DMF0067_BizPlanRaw.cs:333 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-3e709787 | this.Load | DMF0067_BizPlanRaw.cs:335 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-c54b8ae9 | this.Load | DMF0067_BizPlanRaw.cs:336 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bf95731e | this.Load | DMF0067_BizPlanRaw.cs:339 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-947702cc | this.Load | DMF0067_BizPlanRaw.cs:340 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-82d40e17 | this.Load | DMF0067_BizPlanRaw.cs:342 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-8e3e72af | this.Load | DMF0067_BizPlanRaw.cs:342 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4977f58 | this.Load | DMF0067_BizPlanRaw.cs:344 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f5321f6f | this.Load | DMF0067_BizPlanRaw.cs:346 |  | UI_PROP | lblBucket1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-543b2f2f | this.Load | DMF0067_BizPlanRaw.cs:347 |  | STATE | cboClosed.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0067_BizPlanRaw.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4edddd72 | this.Load 외 1 | DMF0067_BizPlanRaw.cs:528 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-2810f3ad | this.Load 외 1 | DMF0067_BizPlanRaw.cs:529 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c38f896 | this.Load 외 1 | DMF0067_BizPlanRaw.cs:530 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2123103e | this.Load 외 1 | DMF0067_BizPlanRaw.cs:533 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-faad61ef | this.Load 외 1 | DMF0067_BizPlanRaw.cs:534 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0067_BizPlanRaw.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6642d116 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:400 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0067_BizPlanRaw.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2470b8d3 | InsertButton | DMF0067_BizPlanRaw.cs:1203 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-9bc3c2c5 | InsertButton | DMF0067_BizPlanRaw.cs:1205 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasure.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1915079 | InsertButton | DMF0067_BizPlanRaw.cs:1218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-cebb0369 | InsertButton | DMF0067_BizPlanRaw.cs:1218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07ca8c22 | InsertButton | DMF0067_BizPlanRaw.cs:1222 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5228a6f7 | InsertButton | DMF0067_BizPlanRaw.cs:1224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4ea085ee | InsertButton | DMF0067_BizPlanRaw.cs:1226 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-bbfbef9f | InsertButton | DMF0067_BizPlanRaw.cs:1228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID40… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-02f66d4a | InsertButton | DMF0067_BizPlanRaw.cs:1230 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-71a62c6a | InsertButton | DMF0067_BizPlanRaw.cs:1233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60f865f0 | InsertButton | DMF0067_BizPlanRaw.cs:1234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-283bc8aa | InsertButton | DMF0067_BizPlanRaw.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47dd3bd6 | InsertButton | DMF0067_BizPlanRaw.cs:1240 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID40), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d0da82bc | InsertButton | DMF0067_BizPlanRaw.cs:1242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision != "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-139ec244 | InsertButton | DMF0067_BizPlanRaw.cs:1244 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-252b2f12 | InsertButton | DMF0067_BizPlanRaw.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-21054d29 | InsertButton | DMF0067_BizPlanRaw.cs:1248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6e9df59d | InsertButton | DMF0067_BizPlanRaw.cs:1250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2e5e8efc | InsertButton | DMF0067_BizPlanRaw.cs:1252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e7b5771a | InsertButton | DMF0067_BizPlanRaw.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b85fa375 | InsertButton | DMF0067_BizPlanRaw.cs:1262 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE), GetCellProdSite(… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-40470595 | InsertButton | DMF0067_BizPlanRaw.cs:1264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2f9268db | InsertButton | DMF0067_BizPlanRaw.cs:1270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-2874039c | InsertButton | DMF0067_BizPlanRaw.cs:1271 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-77a6d38e | InsertButton | DMF0067_BizPlanRaw.cs:1278 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ec3bc412 | InsertButton | DMF0067_BizPlanRaw.cs:1282 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-0a0bae8d | InsertButton | DMF0067_BizPlanRaw.cs:1284 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금 전환 |  |  |  |
| AC-3d34dc64 | InsertButton | DMF0067_BizPlanRaw.cs:1286 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-c7f21062 | InsertButton | DMF0067_BizPlanRaw.cs:1288 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-49c411ac | InsertButton | DMF0067_BizPlanRaw.cs:1290 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-419d3519 | InsertButton | DMF0067_BizPlanRaw.cs:1294 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금 전환 |  |  |  |
| AC-d7efe85d | InsertButton | DMF0067_BizPlanRaw.cs:1296 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금 전환 |  |  |  |
| AC-44d72b2f | InsertButton | DMF0067_BizPlanRaw.cs:1298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금 전환 |  |  |  |
| AC-b3c27f30 | InsertButton | DMF0067_BizPlanRaw.cs:1300 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8b9185ba | InsertButton | DMF0067_BizPlanRaw.cs:1302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-948f5511 | InsertButton | DMF0067_BizPlanRaw.cs:1304 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ba6a8cf8 | InsertButton | DMF0067_BizPlanRaw.cs:1308 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-3a310103 | InsertButton | DMF0067_BizPlanRaw.cs:1310 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.KWH), iRowNo, siMain.GetColumnIndex(DefColumns.K… | 그리드 편집 잠금 전환 |  |  |  |
| AC-93a0a036 | InsertButton | DMF0067_BizPlanRaw.cs:1312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-da6afb1e | InsertButton | DMF0067_BizPlanRaw.cs:1314 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_CODE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-751ae5e5 | InsertButton | DMF0067_BizPlanRaw.cs:1318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ab14b5e9 | InsertButton | DMF0067_BizPlanRaw.cs:1320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_PACK), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-12494504 | InsertButton | DMF0067_BizPlanRaw.cs:1322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_PACK), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금 전환 |  |  |  |
| AC-156095d7 | InsertButton | DMF0067_BizPlanRaw.cs:1329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-f6094325 | InsertButton | DMF0067_BizPlanRaw.cs:1332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-5f7334ce | InsertButton | DMF0067_BizPlanRaw.cs:1334 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), iRowNo, siMain.Get… | 그리드 편집 잠금 전환 |  |  |  |
| AC-01b24e8c | InsertButton | DMF0067_BizPlanRaw.cs:1336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowNo, siMain.G… | 그리드 편집 잠금 전환 |  |  |  |
| AC-da141e81 | InsertButton | DMF0067_BizPlanRaw.cs:1338 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-94f650d8 | InsertButton | DMF0067_BizPlanRaw.cs:1340 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8f17d222 | InsertButton | DMF0067_BizPlanRaw.cs:1342 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-498f4923 | InsertButton | DMF0067_BizPlanRaw.cs:1344 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-941c4e89 | InsertButton | DMF0067_BizPlanRaw.cs:1346 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금 전환 |  |  |  |
| AC-3ba3715a | InsertButton | DMF0067_BizPlanRaw.cs:1348 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-05ef4029 | InsertButton | DMF0067_BizPlanRaw.cs:1350 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowNo, siMain.GetCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-6ab0ceec | InsertButton | DMF0067_BizPlanRaw.cs:1352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-994e0ece | InsertButton | DMF0067_BizPlanRaw.cs:1354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowNo, siMain.GetColumnIndex… | 그리드 편집 잠금 전환 |  |  |  |
| AC-888d68e8 | InsertButton | DMF0067_BizPlanRaw.cs:1356 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금 전환 |  |  |  |
| AC-661a5936 | InsertButton | DMF0067_BizPlanRaw.cs:1358 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowNo, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금 전환 |  |  |  |
| AC-26699cb4 | InsertButton | DMF0067_BizPlanRaw.cs:1366 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-0b0a8f32 | InsertButton | DMF0067_BizPlanRaw.cs:1368 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-16d766fb | InsertButton | DMF0067_BizPlanRaw.cs:1370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금 전환 |  |  |  |
| AC-310d2787 | InsertButton | DMF0067_BizPlanRaw.cs:1372 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-4bbe6646 | InsertButton | DMF0067_BizPlanRaw.cs:1374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ddacb432 | InsertButton | DMF0067_BizPlanRaw.cs:1376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-c9aa869d | InsertButton | DMF0067_BizPlanRaw.cs:1378 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-491fce11 | InsertButton | DMF0067_BizPlanRaw.cs:1380 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-421f4ddc | InsertButton | DMF0067_BizPlanRaw.cs:1382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-6b40d24e | InsertButton | DMF0067_BizPlanRaw.cs:1384 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-5567b4e9 | InsertButton | DMF0067_BizPlanRaw.cs:1386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금 전환 |  |  |  |
| AC-b6dcee07 | InsertButton | DMF0067_BizPlanRaw.cs:1388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ec704acd | InsertButton | DMF0067_BizPlanRaw.cs:1392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8ba4fbf2 | InsertButton | DMF0067_BizPlanRaw.cs:1394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금 전환 |  |  |  |
| AC-f991aa9f | InsertButton | DMF0067_BizPlanRaw.cs:1397 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-b259c4c4 | InsertButton | DMF0067_BizPlanRaw.cs:1398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-9a8a6469 | InsertButton | DMF0067_BizPlanRaw.cs:1403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex()… | 그리드 편집 잠금 전환 |  |  |  |
| AC-a8b5814c | InsertButton | DMF0067_BizPlanRaw.cs:1413 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5c0bb2b6 | InsertButton | DMF0067_BizPlanRaw.cs:1421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ea62adab | InsertButton | DMF0067_BizPlanRaw.cs:1429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f49042d3 | InsertButton | DMF0067_BizPlanRaw.cs:1437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-6e5bfb72 | InsertButton | DMF0067_BizPlanRaw.cs:1442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-db928ad9 | InsertButton | DMF0067_BizPlanRaw.cs:1449 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-8237636b | InsertButton | DMF0067_BizPlanRaw.cs:1457 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-26ddeb20 | InsertButton | DMF0067_BizPlanRaw.cs:1462 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed65aad1 | InsertButton | DMF0067_BizPlanRaw.cs:1473 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange2 | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2c9972c9 | InsertButton | DMF0067_BizPlanRaw.cs:1479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4381735e | InsertButton | DMF0067_BizPlanRaw.cs:1480 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0067_BizPlanRaw.MinColumnChk

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9058e514 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0067_BizPlanRaw.cs:3438 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c21af881 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0067_BizPlanRaw.cs:3455 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8be3976c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0067_BizPlanRaw.cs:3474 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9680dcee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0067_BizPlanRaw.cs:3477 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.ParameterString

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (i != iLOCRow)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97f4d840 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0067_BizPlanRaw.cs:3229 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0067_BizPlanRaw.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c55ae1f4 | SaveButton | DMF0067_BizPlanRaw.cs:839 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe0e94de | SaveButton | DMF0067_BizPlanRaw.cs:840 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abdc03ae | SaveButton | DMF0067_BizPlanRaw.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-937a04dd | SaveButton | DMF0067_BizPlanRaw.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5eaa8313 | SaveButton | DMF0067_BizPlanRaw.cs:989 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66fefe89 | SaveButton | DMF0067_BizPlanRaw.cs:990 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d89cc3c | SaveButton | DMF0067_BizPlanRaw.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bff1ee9 | SaveButton | DMF0067_BizPlanRaw.cs:1014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ca9213f | SaveButton | DMF0067_BizPlanRaw.cs:1133 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ebe65a48 | SaveButton | DMF0067_BizPlanRaw.cs:1134 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-723303ff | SaveButton | DMF0067_BizPlanRaw.cs:1139 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c589866c | SaveButton | DMF0067_BizPlanRaw.cs:1140 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec020ce8 | SaveButton | DMF0067_BizPlanRaw.cs:1147 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-b7053fe0 | SaveButton | DMF0067_BizPlanRaw.cs:1148 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0780cbb2 | SaveButton | DMF0067_BizPlanRaw.cs:1148 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e5cb114 | SaveButton | DMF0067_BizPlanRaw.cs:1149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | sDIVISION_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0a7d4be9 | SaveButton | DMF0067_BizPlanRaw.cs:1149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sDIVISION_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-09d1db3e | SaveButton | DMF0067_BizPlanRaw.cs:1150 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE"] | sPROJECT_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-33e0a196 | SaveButton | DMF0067_BizPlanRaw.cs:1150 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sPROJECT_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-537d906f | SaveButton | DMF0067_BizPlanRaw.cs:1151 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_NAME"] | sPROJECT_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b8cb2fea | SaveButton | DMF0067_BizPlanRaw.cs:1151 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sPROJECT_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3bbbb3 | SaveButton | DMF0067_BizPlanRaw.cs:1152 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | sSCM_SITE_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-57815f56 | SaveButton | DMF0067_BizPlanRaw.cs:1152 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sSCM_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5df8099a | SaveButton | DMF0067_BizPlanRaw.cs:1153 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | sPLANT_SITE_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c75b80c1 | SaveButton | DMF0067_BizPlanRaw.cs:1153 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sPLANT_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6339e202 | SaveButton | DMF0067_BizPlanRaw.cs:1154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID"] | sITEM_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7d8d8c57 | SaveButton | DMF0067_BizPlanRaw.cs:1154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sITEM_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4416e61 | SaveButton | DMF0067_BizPlanRaw.cs:1156 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | sFCST_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-9b0c9b7e | SaveButton | DMF0067_BizPlanRaw.cs:1156 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sFCST_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb7b0a03 | SaveButton | DMF0067_BizPlanRaw.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | sINCOTERMS.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-fa850017 | SaveButton | DMF0067_BizPlanRaw.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sINCOTERMS.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c699212 | SaveButton | DMF0067_BizPlanRaw.cs:1158 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE"] | sMEASURE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-e90f9883 | SaveButton | DMF0067_BizPlanRaw.cs:1158 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sMEASURE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-688b423c | SaveButton | DMF0067_BizPlanRaw.cs:1159 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM"] | sYYYYMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0c2720ac | SaveButton | DMF0067_BizPlanRaw.cs:1159 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sYYYYMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b306688e | SaveButton | DMF0067_BizPlanRaw.cs:1160 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY"] | pInput.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b73334f0 | SaveButton | DMF0067_BizPlanRaw.cs:1160 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pInput.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b803032 | SaveButton | DMF0067_BizPlanRaw.cs:1161 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY"] | sCURRENCY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-003559f8 | SaveButton | DMF0067_BizPlanRaw.cs:1161 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sCURRENCY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-01a6954c | SaveButton | DMF0067_BizPlanRaw.cs:1164 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sDEPT_ID"] | sDEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-92e571c9 | SaveButton | DMF0067_BizPlanRaw.cs:1164 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sDEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d28ad5d | SaveButton | DMF0067_BizPlanRaw.cs:1165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sEND_CUSTOMER"] | sEND_CUSTOMER.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-927c75bd | SaveButton | DMF0067_BizPlanRaw.cs:1165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sEND_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa44678f | SaveButton | DMF0067_BizPlanRaw.cs:1166 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sBIZ_TYPE"] | sBIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-25beb5fb | SaveButton | DMF0067_BizPlanRaw.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sITEM_USE"] | sITEM_USE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7e9faae2 | SaveButton | DMF0067_BizPlanRaw.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sITEM_USE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ac9cf22 | SaveButton | DMF0067_BizPlanRaw.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sUNIT_ENERGY"] | sUNIT_ENERGY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5b74492e | SaveButton | DMF0067_BizPlanRaw.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sUNIT_ENERGY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-56187118 | SaveButton | DMF0067_BizPlanRaw.cs:1174 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | sCELL_PROD_SITE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-785f0bb3 | SaveButton | DMF0067_BizPlanRaw.cs:1174 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sCELL_PROD_SITE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-206b642f | SaveButton | DMF0067_BizPlanRaw.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-955055c2 | SaveButton | DMF0067_BizPlanRaw.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe4c6991 | SaveButton | DMF0067_BizPlanRaw.cs:1177 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4a4c9aa7 | SaveButton | DMF0067_BizPlanRaw.cs:1177 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-72c74c2a | SaveButton | DMF0067_BizPlanRaw.cs:1179 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27aa54a9 | SaveButton | DMF0067_BizPlanRaw.cs:1184 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-3ca949d4 | SaveButton | DMF0067_BizPlanRaw.cs:1185 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dde0b60 | SaveButton | DMF0067_BizPlanRaw.cs:1189 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0067_BizPlanRaw.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt == iCheck)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccef50d6 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0067_BizPlanRaw.cs:3413 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0067_BizPlanRaw.SetComboCol

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-240090f5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2971 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae8961ca | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2972 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-623eed5c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2976 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-e9942a10 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2977 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-b1916f01 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2978 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-483fcc19 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2979 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-5e99920f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2983 |  | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |

## DMF0067_BizPlanRaw.SetComboColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e7d636f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:2944 |  | DATA_OP | dtTitle.Select | ($"COLUMN_NAME = '{columnName}'") | 데이터 객체 조작/조회 |  |  |  |

## DMF0067_BizPlanRaw.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivisio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eb57b9b | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:501 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c41256d3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:504 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-37c133e9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:509 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3a569ab6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:511 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-59ee1138 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:514 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-bc6e246a | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:519 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ff19bfbd | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0067_BizPlanRaw.cs:521 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0067_BizPlanRaw.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4b65642 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:436 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9899015 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:444 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f09cacf9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:456 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b85ea4c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:457 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7e53174 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:462 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa5c281d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:463 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e36a8b87 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:470 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-482993ae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:471 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80376ff4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:482 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90167cf0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:483 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72b105a1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:484 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3be08cde | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:485 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e22ba30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:487 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-08d1c229 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0067_BizPlanRaw.cs:489 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0067_BizPlanRaw.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65e62d40 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1675 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-9baf1908 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1681 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-4e11c02c | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1697 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1c6a99d6 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1712 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-908fd257 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1743 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-906e756e | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1745 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8b1170e1 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1746 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-faa56ee4 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1747 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c35f972a | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1756 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-fa456296 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1759 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-8a4c0ce4 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1761 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID40), sItemId) | 그리드 값 설정 |  |  |  |
| AC-d0fb6b34 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1763 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-12df28bb | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1793 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-27d35a87 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1795 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f1572d5f | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1796 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9ddc2c8 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1797 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0327ebdd | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1807 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-c986c35f | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1810 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-0be5977b | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1812 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), sBizType) | 그리드 값 설정 |  |  |  |
| AC-0b0ccd74 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1843 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-22411a99 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1845 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-be6563bc | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1846 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25b9a8a3 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1847 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e79b8d7b | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1857 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-f9f21cc9 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1860 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME)… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-ab13a986 | this.spdMain.CellDoubleClick | DMF0067_BizPlanRaw.cs:1862 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), sBizType) | 그리드 값 설정 |  |  |  |

## DMF0067_BizPlanRaw.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-883edd27 | dsdm.Changed | DMF0067_BizPlanRaw.cs:1869 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4801e8ea | dsdm.Changed | DMF0067_BizPlanRaw.cs:1872 | if (e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-555bf68c | dsdm.Changed | DMF0067_BizPlanRaw.cs:1873 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84f6b289 | dsdm.Changed | DMF0067_BizPlanRaw.cs:1877 | if (siMain.GetValue(e.Row, e.Column).ToString() == "") | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-a519dece | dsdm.Changed | DMF0067_BizPlanRaw.cs:1904 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2bbb2aa | dsdm.Changed | DMF0067_BizPlanRaw.cs:1915 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c0d609b | dsdm.Changed | DMF0067_BizPlanRaw.cs:1919 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | GRID_SET | siMain.SetValue | (e.Row, e.Column, strValue[0] + ".000") | 그리드 값 설정 |  |  |  |
| AC-5d368c5b | dsdm.Changed | DMF0067_BizPlanRaw.cs:1920 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00289") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13700732 | dsdm.Changed | DMF0067_BizPlanRaw.cs:1946 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-426e34f2 | dsdm.Changed | DMF0067_BizPlanRaw.cs:1948 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea78bbff | dsdm.Changed | DMF0067_BizPlanRaw.cs:1954 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-51639c4d | dsdm.Changed | DMF0067_BizPlanRaw.cs:1974 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c5752a5 | dsdm.Changed | DMF0067_BizPlanRaw.cs:1981 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-973425c5 | dsdm.Changed | DMF0067_BizPlanRaw.cs:1995 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2384afd | dsdm.Changed | DMF0067_BizPlanRaw.cs:2036 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (iQuarterlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55d7050a | dsdm.Changed | DMF0067_BizPlanRaw.cs:2061 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-c233a1f1 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2067 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e01b2ba9 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2081 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-f95a38da | dsdm.Changed | DMF0067_BizPlanRaw.cs:2087 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-ba190d7b | dsdm.Changed | DMF0067_BizPlanRaw.cs:2108 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-0df6bd78 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2136 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e321b9a5 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2144 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-0a4f9545 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2162 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (Convert.ToDecimal(siMain.GetValue(e.Row, e.Column))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3e82a80 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2171 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0959bfef | dsdm.Changed | DMF0067_BizPlanRaw.cs:2171 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DateTime.Today.DayOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eefe1b93 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2229 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2759cffd | dsdm.Changed | DMF0067_BizPlanRaw.cs:2235 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-cc68cd65 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2251 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-b1b643b5 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2257 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-4f51ca6b | dsdm.Changed | DMF0067_BizPlanRaw.cs:2279 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-27edc7d1 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2314 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ad4f6258 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2319 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b9f4290a | dsdm.Changed | DMF0067_BizPlanRaw.cs:2341 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-962a0ffa | dsdm.Changed | DMF0067_BizPlanRaw.cs:2348 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, iQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |
| AC-c73889fa | dsdm.Changed | DMF0067_BizPlanRaw.cs:2386 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b05cfa39 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2413 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-90e265d7 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2493 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-5d881a5b | dsdm.Changed | DMF0067_BizPlanRaw.cs:2499 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-c4ed76f8 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2513 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-d20cf535 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2519 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-6d29b8e0 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2540 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-1d6d4b01 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2576 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-989d8659 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2661 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-742242a0 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2667 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d6343d77 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2683 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-c770c1a5 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2689 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-47860616 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2711 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-434b8683 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2746 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-36af431c | dsdm.Changed | DMF0067_BizPlanRaw.cs:2751 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-4e2d2960 | dsdm.Changed | DMF0067_BizPlanRaw.cs:2780 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0067_BizPlanRaw.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6054580f | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1640 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed40d4e8 | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1641 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-91baacad | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1653 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4347ddc | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1656 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-851b8162 | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1659 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1f6a546d | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1659 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f73fe903 | this.spdMain.ComboSelChange | DMF0067_BizPlanRaw.cs:1660 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0067_BizPlanRaw.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aabbf823 | this.spdMain.EditChange | DMF0067_BizPlanRaw.cs:3094 | if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78967c32 | this.spdMain.EditChange | DMF0067_BizPlanRaw.cs:3096 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0067_BizPlanRaw.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c5a66bd | this.spdMain.TopChange | DMF0067_BizPlanRaw.cs:2806 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0067_BizPlanRaw.ValidationCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9abb887 | (진입점 미연결) | DMF0067_BizPlanRaw.cs:2795 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18269ea4 | (진입점 미연결) | DMF0067_BizPlanRaw.cs:2798 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-a5015a4c | (진입점 미연결) | DMF0067_BizPlanRaw.cs:2800 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

