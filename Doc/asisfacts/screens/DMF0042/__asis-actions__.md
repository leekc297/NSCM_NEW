# AS-IS 액션 대조표 — DMF0042

> 원천: `Doc/asisfacts/screens/DMF0042/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 3192행 · 메서드 276 · 종류 DATA_OP 623 · GRID_SET 338 · GRID_LOCK 309 · FLAG 290 · RETURN 219 · UI_PROP 193 · COMBO_DATA 169 · POPUP 150 · ENDPOINT 143 · STATE 141 · LIST_REBIND 120 · MESSAGE 115 · GRID_INIT 110 · CALL_EXT 109 · GRID_COMBO 58 · UI_MISC 41 · VALUE_SET 26 · VALUE_CLEAR 15 · GRID_STYLE 11 · GRID_BIND 10 · THROW 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 110


## DMF0042_1_BizPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1f24fa7 | this.btnColumn.Click | DMF0042_1_BizPlan.cs:2809 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-a06a02ce | this.btnColumn.Click | DMF0042_1_BizPlan.cs:2810 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d3231209 | this.btnColumn.Click | DMF0042_1_BizPlan.cs:2811 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_1_BizPlan.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a42280 | this.btnCutOff.Click | DMF0042_1_BizPlan.cs:2844 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-c41c697d | this.btnCutOff.Click | DMF0042_1_BizPlan.cs:2845 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30745a5c | this.btnCutOff.Click | DMF0042_1_BizPlan.cs:2852 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-e8b88695 | this.btnCutOff.Click | DMF0042_1_BizPlan.cs:2857 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47b19397 | this.btnCutOff.Click | DMF0042_1_BizPlan.cs:2859 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3922a78d | this.btnCutOff.Click | DMF0042_1_BizPlan.cs:2860 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_1_BizPlan.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d32bae5 | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:2989 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e01a4b6 | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:2990 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a01d5eca | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:2993 |  | POPUP | new POPUP.DMF0042_ExchangeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-ef3c99be | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:2994 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP", clbDivisi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5976a39d | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:2996 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8cfeb753 | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:2997 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7e7768f7 | this.btnExchangeRate.Click | DMF0042_1_BizPlan.cs:3001 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_1_BizPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de045b80 | this.btnItemId.Click | DMF0042_1_BizPlan.cs:2793 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-83dc7819 | this.btnItemId.Click | DMF0042_1_BizPlan.cs:2795 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6e945866 | this.btnItemId.Click | DMF0042_1_BizPlan.cs:2796 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e1e27a69 | this.btnItemId.Click | DMF0042_1_BizPlan.cs:2797 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ad5491df | this.btnItemId.Click | DMF0042_1_BizPlan.cs:2803 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0042_1_BizPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3eb3345a | this.btnMeasure.Click | DMF0042_1_BizPlan.cs:2821 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-7b08408b | this.btnMeasure.Click | DMF0042_1_BizPlan.cs:2823 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6af1b461 | this.btnMeasure.Click | DMF0042_1_BizPlan.cs:2824 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_1_BizPlan.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4c4d1af | this.btnOwner.Click | DMF0042_1_BizPlan.cs:2953 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2912ae3d | this.btnOwner.Click | DMF0042_1_BizPlan.cs:2956 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-53ca493f | this.btnOwner.Click | DMF0042_1_BizPlan.cs:2957 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-76886962 | this.btnOwner.Click | DMF0042_1_BizPlan.cs:2958 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c0eb893d | this.btnOwner.Click | DMF0042_1_BizPlan.cs:2960 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0042_1_BizPlan.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c95263b7 | this.btnProject.Click 외 1 | DMF0042_1_BizPlan.cs:2771 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-448107bc | this.btnProject.Click 외 1 | DMF0042_1_BizPlan.cs:2772 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-845ab27a | this.btnProject.Click 외 1 | DMF0042_1_BizPlan.cs:2773 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c2e4aff | this.btnProject.Click 외 1 | DMF0042_1_BizPlan.cs:2774 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e1dc8b3 | this.btnProject.Click 외 1 | DMF0042_1_BizPlan.cs:2780 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0042_1_BizPlan.btnReplace_Click

진입점: this.btnReplace.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10009dd7 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3386 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-849f024a | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3387 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d4fcd42 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3394 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-0eb80f49 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3395 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30b42898 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3400 |  | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fba3ed5f | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3404 |  | DATA_OP | dt.Columns.Add | ("YYYYMM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a0805c1 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3408 | if (spdMain.Sheets[0].RowCount == 0) | MESSAGE | MessageBox.Show | ("데이터 조회 후 다시 시도해 주시기 바랍니다.") | 메시지 표시 |  |  |  |
| AC-fe52fe10 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3409 | if (spdMain.Sheets[0].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9d9aee8 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3428 | else of (cr == null) ▸ for (i <= ColEnd) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cfd1556 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3432 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | row["YYYYMM"] | colTag.Substring(2, 6).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-801c9d08 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3433 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-a62f29ce | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3461 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-ac8e0617 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3465 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1373dfb | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3467 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1bb89634 | this.btnReplace.Click | DMF0042_1_BizPlan.cs:3468 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_1_BizPlan.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0908d387 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3117 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00282") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-662d19b7 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3118 | if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26f967b3 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3124 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | 엔드포인트 요청 생성 |  |  |  |
| AC-73d46e26 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3126 |  | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c912f307 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3128 |  | DATA_OP | request.Parameters["s_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2a29803 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3129 |  | DATA_OP | request.Parameters["s_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1eda4bfd | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3130 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-753cae03 | this.btnSetPrice.Click | DMF0042_1_BizPlan.cs:3133 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_1_BizPlan.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8665af38 | this.cboBucketType.Click | DMF0042_1_BizPlan.cs:2969 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-246623c7 | this.cboBucketType.Click | DMF0042_1_BizPlan.cs:2970 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eae195f | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1430 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6381aa9d | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1430 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6c9b3f0 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1431 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e93cf79e | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1439 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-26777159 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1439 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45da1c1e | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1440 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-46321075 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1442 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-9830b21c | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1442 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c28914b | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1444 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e636d0a8 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1445 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0f02db23 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1446 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fc90da8e | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1447 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-c90cf0f6 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1447 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d9334cc7 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1451 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1cd8f6d | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1452 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a64d12e8 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1454 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6706a41b | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1454 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75b02f0e | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1456 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8b91e16b | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1457 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-343d63f4 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1458 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-49459ab1 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1460 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-89d65856 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1460 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e772d34 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1464 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-f41adae4 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1465 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-da711c96 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1467 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-16dc22da | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1467 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bf05d3b5 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1469 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bcf12efc | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1470 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a3eac24a | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1471 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e4fc30c9 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1473 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-907be82c | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1473 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81a3af06 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1477 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f8b53d6a | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1479 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c116674b | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1482 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9f97a9f | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1482 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9ce5452 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1483 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0a679275 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1485 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-bd7e1ef5 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1485 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b06a0ce7 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1486 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ff591a6b | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1488 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-6fe5052e | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1489 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d109118 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1491 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-c51b8652 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1493 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-6db729cd | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1494 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cce746df | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1497 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-26f2c58d | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1498 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1928f251 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1500 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0663716 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1500 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-394f084e | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1502 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f0b6dc08 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1504 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0f691d4b | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1505 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7c0accb8 | clbDivision.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1506 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0042_1_BizPlan.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a12e5af | this.clbCustomer.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1540 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-eaf64856 | this.clbCustomer.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1540 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dacd0c4d | this.clbCustomer.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1544 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-3a3fd58d | this.clbCustomer.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1544 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab6b258b | this.clbCustomer.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1546 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_1_BizPlan.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4127bc45 | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1518 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-abc5e32c | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1518 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb516b47 | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1519 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-affb35c0 | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1521 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-da09c7cd | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1521 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b919700 | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1525 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-9bc6081b | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1525 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a6837ca | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1526 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c024c1a9 | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1528 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-81e8f801 | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1528 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc58b46e | this.clbTeam.SelectedIndexChanged | DMF0042_1_BizPlan.cs:1532 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_1_BizPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55979f8d | this.Load | DMF0042_1_BizPlan.cs:364 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2faa796d | this.Load | DMF0042_1_BizPlan.cs:365 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-41d31c50 | this.Load | DMF0042_1_BizPlan.cs:366 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_1_BizPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ae94f80 | this.Load | DMF0042_1_BizPlan.cs:327 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-5b683a62 | this.Load | DMF0042_1_BizPlan.cs:329 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-516ed92b | this.Load | DMF0042_1_BizPlan.cs:331 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-2404557e | this.Load | DMF0042_1_BizPlan.cs:332 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f6521032 | this.Load | DMF0042_1_BizPlan.cs:333 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-6d8499cb | this.Load | DMF0042_1_BizPlan.cs:334 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-8fefd3cc | this.Load | DMF0042_1_BizPlan.cs:344 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-be002962 | this.Load | DMF0042_1_BizPlan.cs:345 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-f410520f | this.Load | DMF0042_1_BizPlan.cs:349 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eda55ea1 | this.Load | DMF0042_1_BizPlan.cs:350 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0042_1_BizPlan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8593b812 | DeleteButton | DMF0042_1_BizPlan.cs:528 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a28942d9 | DeleteButton | DMF0042_1_BizPlan.cs:534 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-fa69868e | DeleteButton | DMF0042_1_BizPlan.cs:535 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_1_BizPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c0e0fa | Dispose | DMF0042_1_BizPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_1_BizPlan.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a350118 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:548 | if (this.fps != null) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c41ec8e4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:549 | if (this.fps != null) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dbc7e49 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:552 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c815cbe | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:553 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3f31265c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:561 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06cd5935 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:569 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (siMain.… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0bd42ec | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:577 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd984e47 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:585 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff38e17f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:590 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c201855 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:597 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e559790e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:605 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f1037e88 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:610 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-19063782 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:625 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-57538ca7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:634 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sDivisi… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08614600 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:635 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sDivisi… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-21edf849 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:640 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sD… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-27eb9da9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:642 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sD… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e7b9824 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:656 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") \|\| (s… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6bb54672 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:664 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") \|… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1738ebed | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_1_BizPlan.cs:670 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!IsEditMode) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_1_BizPlan.FindData

진입점: this.btnSetPrice.Click / this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dabd509b | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:688 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-304a804e | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:697 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b3e798e | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:698 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ff7e35c | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:705 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11507ef7 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:706 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a57c3bf | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:711 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00276") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6fb6560 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:712 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(6) | 속성 Value2 설정 |  |  |  |
| AC-5dec091e | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:713 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5f16aa4 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:718 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92408a7a | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:720 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ef076fa | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:725 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-035117d6 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:728 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-101f86e8 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:735 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2134b296 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:739 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA") ⇒ DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-08a11a5a | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:741 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5ae6456a | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:743 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-99b8e710 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:744 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dac6c70b | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:745 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5ab64acb | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:746 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-14f37101 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:747 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e4561cba | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:748 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-43a79845 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:749 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b3a35f53 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:750 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ac15a36b | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:751 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-c49313f2 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:752 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-4fa25d67 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:753 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4eee1532 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:754 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-32eded37 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:755 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-91e8c67f | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:756 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6b58e4ce | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:757 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-a6eda9c7 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:758 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-7fb586a0 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:760 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b789839 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:762 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fe94e568 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:767 | try | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d772d74e | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:768 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b822c49 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:772 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | valid_YN | ds.Tables[1].Rows[0]["VALID_YN"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eea54c1d | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:773 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYQQ | ds.Tables[1].Rows[0]["START_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d05957c8 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:774 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYQQ | ds.Tables[1].Rows[0]["END_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-42fddbd5 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:775 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYMM | ds.Tables[1].Rows[0]["START_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-af7d1d2d | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:776 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYMM | ds.Tables[1].Rows[0]["END_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e4f873bb | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:777 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYY | ds.Tables[1].Rows[0]["START_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ce67178d | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:778 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYY | ds.Tables[1].Rows[0]["END_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-111c6e84 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:781 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0f91083 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:786 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cbda39ba | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:790 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b90c07d3 | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:794 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4402448a | this.btnSetPrice.Click 외 3 | DMF0042_1_BizPlan.cs:796 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0042_1_BizPlan.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb9f36e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_1_BizPlan.cs:3273 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-56a22df9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_1_BizPlan.cs:3276 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-209c6a88 | this.Load | DMF0042_1_BizPlan.cs:211 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e73ed030 | this.Load | DMF0042_1_BizPlan.cs:212 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_1_BizPlan.GetBizTypebyDivision

진입점: this.Load [if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1da0cd29 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_1_BizPlan.cs:2920 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-453efad3 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_1_BizPlan.cs:2921 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-89c4ee59 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_1_BizPlan.cs:2922 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12da587b | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_1_BizPlan.cs:2924 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) \|\| (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == e.Column))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c25460c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_1_BizPlan.cs:3287 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f7535b3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_1_BizPlan.cs:3077 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dad3a743 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_1_BizPlan.cs:3078 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b6689d3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_1_BizPlan.cs:3065 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-ca00a00d | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_1_BizPlan.cs:3070 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetCellProdSite

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1085d7fb | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3369 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-1e0b3b95 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3370 |  | DATA_OP | request.Parameters["CODE"] | "DM_CELL_PROD_SITE" | 행/컬럼 값 대입 |  |  |  |
| AC-e0471bf8 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3371 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b3431da9 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3372 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9919cb8c | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3373 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b1387a6 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3374 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9ccf1a55 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3375 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa1adc94 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3376 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48061982 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_1_BizPlan.cs:3378 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd2daea6 | this.Load 외 1 | DMF0042_1_BizPlan.cs:2874 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-e9f21105 | this.Load 외 1 | DMF0042_1_BizPlan.cs:2875 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5e1cb328 | this.Load 외 1 | DMF0042_1_BizPlan.cs:2876 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-1a1019c0 | this.Load 외 1 | DMF0042_1_BizPlan.cs:2878 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3cf4bfd8 | this.Load 외 1 | DMF0042_1_BizPlan.cs:2881 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b1cda89 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_1_BizPlan.cs:3015 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_EXCHANGE_PRICE") ⇒ DM.DMF0042_GET_EXCHANGE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-60ce00b9 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_1_BizPlan.cs:3016 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d09b80c2 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_1_BizPlan.cs:3017 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b3d7affa | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_1_BizPlan.cs:3018 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71716726 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_1_BizPlan.cs:3020 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetLookupData

진입점: this.Load / clbDivision.SelectedIndexChanged / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c72ee82 | this.Load 외 2 | DMF0042_1_BizPlan.cs:2907 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-b1e25d36 | this.Load 외 2 | DMF0042_1_BizPlan.cs:2908 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-7e2d76e3 | this.Load 외 2 | DMF0042_1_BizPlan.cs:2909 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b0d80308 | this.Load 외 2 | DMF0042_1_BizPlan.cs:2911 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47f1a30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2890 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_SPREAD_TITLE") ⇒ DM.DMF0042_1_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-485e1a76 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2892 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-60864ced | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2893 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-827998f2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2894 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d196ac48 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2895 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0496ac97 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2897 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-73b5fd91 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:2897 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0042_1_BizPlan.GetThisWeekMonday

진입점: this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91f32d95 | this.btnSetPrice.Click [try] 외 3 | DMF0042_1_BizPlan.cs:3041 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ac507a8 | this.Load | DMF0042_1_BizPlan.cs:234 |  | DATA_OP | this.ConditionNotUseList.Add | (cboClosed) | 데이터 객체 조작/조회 |  |  |  |
| AC-f34786c3 | this.Load | DMF0042_1_BizPlan.cs:236 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-f6ae04a0 | this.Load | DMF0042_1_BizPlan.cs:236 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19b3cc42 | this.Load | DMF0042_1_BizPlan.cs:237 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b8f58b18 | this.Load | DMF0042_1_BizPlan.cs:240 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-b02d0b5b | this.Load | DMF0042_1_BizPlan.cs:240 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-163abbbf | this.Load | DMF0042_1_BizPlan.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-678968ce | this.Load | DMF0042_1_BizPlan.cs:244 |  | LIST_REBIND | clsCtrl.setListBox | (dtYn, cboClosed, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-018b8b4d | this.Load | DMF0042_1_BizPlan.cs:254 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6106272c | this.Load | DMF0042_1_BizPlan.cs:254 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4de52d98 | this.Load | DMF0042_1_BizPlan.cs:255 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-08c3d084 | this.Load | DMF0042_1_BizPlan.cs:257 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-0848eac3 | this.Load | DMF0042_1_BizPlan.cs:257 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-300353f7 | this.Load | DMF0042_1_BizPlan.cs:259 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1a34765e | this.Load | DMF0042_1_BizPlan.cs:260 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dfe47178 | this.Load | DMF0042_1_BizPlan.cs:261 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4e8d63f0 | this.Load | DMF0042_1_BizPlan.cs:262 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-49eadb4c | this.Load | DMF0042_1_BizPlan.cs:262 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fdd89ee8 | this.Load | DMF0042_1_BizPlan.cs:266 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0355080 | this.Load | DMF0042_1_BizPlan.cs:267 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3404747f | this.Load | DMF0042_1_BizPlan.cs:269 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-41d76d6b | this.Load | DMF0042_1_BizPlan.cs:269 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3af71b85 | this.Load | DMF0042_1_BizPlan.cs:271 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ce53ee49 | this.Load | DMF0042_1_BizPlan.cs:272 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cc021a4a | this.Load | DMF0042_1_BizPlan.cs:273 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b16886ee | this.Load | DMF0042_1_BizPlan.cs:275 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e44f032f | this.Load | DMF0042_1_BizPlan.cs:275 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4e4aa23 | this.Load | DMF0042_1_BizPlan.cs:280 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b50f514 | this.Load | DMF0042_1_BizPlan.cs:281 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-54bb0c28 | this.Load | DMF0042_1_BizPlan.cs:283 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5ad5730f | this.Load | DMF0042_1_BizPlan.cs:283 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cfa6505b | this.Load | DMF0042_1_BizPlan.cs:285 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-21debe26 | this.Load | DMF0042_1_BizPlan.cs:286 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-94a9b66b | this.Load | DMF0042_1_BizPlan.cs:287 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-91c00c16 | this.Load | DMF0042_1_BizPlan.cs:289 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c39fd88 | this.Load | DMF0042_1_BizPlan.cs:289 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d40a098 | this.Load | DMF0042_1_BizPlan.cs:293 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-81c70d54 | this.Load | DMF0042_1_BizPlan.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-03ba4e2b | this.Load | DMF0042_1_BizPlan.cs:298 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9dfce56a | this.Load | DMF0042_1_BizPlan.cs:298 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7015880a | this.Load | DMF0042_1_BizPlan.cs:299 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-72ccc90d | this.Load | DMF0042_1_BizPlan.cs:302 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-7aa06025 | this.Load | DMF0042_1_BizPlan.cs:302 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82e3fcc8 | this.Load | DMF0042_1_BizPlan.cs:303 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e5384179 | this.Load | DMF0042_1_BizPlan.cs:305 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-c32afc1a | this.Load | DMF0042_1_BizPlan.cs:306 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6ea64358 | this.Load | DMF0042_1_BizPlan.cs:308 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-5a34cac2 | this.Load | DMF0042_1_BizPlan.cs:310 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-221a61f6 | this.Load | DMF0042_1_BizPlan.cs:311 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d313e947 | this.Load | DMF0042_1_BizPlan.cs:314 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3c4c2dc | this.Load | DMF0042_1_BizPlan.cs:315 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-004e609d | this.Load | DMF0042_1_BizPlan.cs:317 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-e12745ff | this.Load | DMF0042_1_BizPlan.cs:317 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7fc3982 | this.Load | DMF0042_1_BizPlan.cs:319 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6554dbe2 | this.Load | DMF0042_1_BizPlan.cs:321 |  | UI_PROP | lblBucket1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-98d4d085 | this.Load | DMF0042_1_BizPlan.cs:322 |  | STATE | cboClosed.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0042_1_BizPlan.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49aa6f7a | this.Load 외 1 | DMF0042_1_BizPlan.cs:502 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-0f2b86ca | this.Load 외 1 | DMF0042_1_BizPlan.cs:503 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e887ba35 | this.Load 외 1 | DMF0042_1_BizPlan.cs:504 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a957a10 | this.Load 외 1 | DMF0042_1_BizPlan.cs:507 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-7abdeb05 | this.Load 외 1 | DMF0042_1_BizPlan.cs:508 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_1_BizPlan.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f3a1615 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:375 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0042_1_BizPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67203bd3 | InsertButton | DMF0042_1_BizPlan.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-bd71b41b | InsertButton | DMF0042_1_BizPlan.cs:1159 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasure.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bde2a61 | InsertButton | DMF0042_1_BizPlan.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-4e20a41a | InsertButton | DMF0042_1_BizPlan.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87e70659 | InsertButton | DMF0042_1_BizPlan.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b70e8003 | InsertButton | DMF0042_1_BizPlan.cs:1178 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7215b01c | InsertButton | DMF0042_1_BizPlan.cs:1180 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-fdb5ab17 | InsertButton | DMF0042_1_BizPlan.cs:1182 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID40… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-57811e26 | InsertButton | DMF0042_1_BizPlan.cs:1184 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3e483a68 | InsertButton | DMF0042_1_BizPlan.cs:1187 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37854987 | InsertButton | DMF0042_1_BizPlan.cs:1188 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1fd44727 | InsertButton | DMF0042_1_BizPlan.cs:1191 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05bcd343 | InsertButton | DMF0042_1_BizPlan.cs:1194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID40), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-168c408c | InsertButton | DMF0042_1_BizPlan.cs:1196 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision != "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f4c671eb | InsertButton | DMF0042_1_BizPlan.cs:1198 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ea477167 | InsertButton | DMF0042_1_BizPlan.cs:1200 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f2222661 | InsertButton | DMF0042_1_BizPlan.cs:1202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ce03bd33 | InsertButton | DMF0042_1_BizPlan.cs:1204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-70ff5720 | InsertButton | DMF0042_1_BizPlan.cs:1206 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-998e1582 | InsertButton | DMF0042_1_BizPlan.cs:1208 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d9a12db5 | InsertButton | DMF0042_1_BizPlan.cs:1210 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), dtBizType81) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5561db80 | InsertButton | DMF0042_1_BizPlan.cs:1214 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE), GetCellProdSite(… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-704f1af4 | InsertButton | DMF0042_1_BizPlan.cs:1222 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-2050a1e7 | InsertButton | DMF0042_1_BizPlan.cs:1223 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4b3da9e | InsertButton | DMF0042_1_BizPlan.cs:1230 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9abc351a | InsertButton | DMF0042_1_BizPlan.cs:1234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-13576768 | InsertButton | DMF0042_1_BizPlan.cs:1236 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-93a9c1cb | InsertButton | DMF0042_1_BizPlan.cs:1238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3bd8e9db | InsertButton | DMF0042_1_BizPlan.cs:1240 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ba10cdf | InsertButton | DMF0042_1_BizPlan.cs:1242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08f20393 | InsertButton | DMF0042_1_BizPlan.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f2b98e5 | InsertButton | DMF0042_1_BizPlan.cs:1248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-034128a2 | InsertButton | DMF0042_1_BizPlan.cs:1250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e51dfce | InsertButton | DMF0042_1_BizPlan.cs:1252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc6301e2 | InsertButton | DMF0042_1_BizPlan.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f233310b | InsertButton | DMF0042_1_BizPlan.cs:1256 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b035e67 | InsertButton | DMF0042_1_BizPlan.cs:1260 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3a820fde | InsertButton | DMF0042_1_BizPlan.cs:1263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5e841a7 | InsertButton | DMF0042_1_BizPlan.cs:1265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), iRowNo, siMain.Get… | 그리드 편집 잠금/해제 |  |  |  |
| AC-740fba02 | InsertButton | DMF0042_1_BizPlan.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowNo, siMain.G… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c498fa85 | InsertButton | DMF0042_1_BizPlan.cs:1269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-af999daa | InsertButton | DMF0042_1_BizPlan.cs:1271 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0c852cc6 | InsertButton | DMF0042_1_BizPlan.cs:1273 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b81faea0 | InsertButton | DMF0042_1_BizPlan.cs:1275 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f4e901c | InsertButton | DMF0042_1_BizPlan.cs:1277 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-116dcbb5 | InsertButton | DMF0042_1_BizPlan.cs:1279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a195d23 | InsertButton | DMF0042_1_BizPlan.cs:1281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowNo, siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd762a5f | InsertButton | DMF0042_1_BizPlan.cs:1283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-158eac25 | InsertButton | DMF0042_1_BizPlan.cs:1285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowNo, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-56169a5d | InsertButton | DMF0042_1_BizPlan.cs:1287 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcaa6fdb | InsertButton | DMF0042_1_BizPlan.cs:1289 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowNo, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebf16604 | InsertButton | DMF0042_1_BizPlan.cs:1297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-272f0b72 | InsertButton | DMF0042_1_BizPlan.cs:1299 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7dada89a | InsertButton | DMF0042_1_BizPlan.cs:1301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec5315f8 | InsertButton | DMF0042_1_BizPlan.cs:1303 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-444e0ac9 | InsertButton | DMF0042_1_BizPlan.cs:1305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-798588bd | InsertButton | DMF0042_1_BizPlan.cs:1307 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d8f0e5b | InsertButton | DMF0042_1_BizPlan.cs:1309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e4bf3a5 | InsertButton | DMF0042_1_BizPlan.cs:1311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9c3edf7 | InsertButton | DMF0042_1_BizPlan.cs:1313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-93bea957 | InsertButton | DMF0042_1_BizPlan.cs:1315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88a0345e | InsertButton | DMF0042_1_BizPlan.cs:1317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b5ee396 | InsertButton | DMF0042_1_BizPlan.cs:1319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b54d1f1c | InsertButton | DMF0042_1_BizPlan.cs:1323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07995ea0 | InsertButton | DMF0042_1_BizPlan.cs:1325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6935c44 | InsertButton | DMF0042_1_BizPlan.cs:1328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-9a14b8e9 | InsertButton | DMF0042_1_BizPlan.cs:1329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-02f798d4 | InsertButton | DMF0042_1_BizPlan.cs:1336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex()… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1de11694 | InsertButton | DMF0042_1_BizPlan.cs:1346 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa293ec6 | InsertButton | DMF0042_1_BizPlan.cs:1354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9cbcbe5e | InsertButton | DMF0042_1_BizPlan.cs:1362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-458ffd0a | InsertButton | DMF0042_1_BizPlan.cs:1370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86dc05fe | InsertButton | DMF0042_1_BizPlan.cs:1375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8221cbff | InsertButton | DMF0042_1_BizPlan.cs:1382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-720f1f9c | InsertButton | DMF0042_1_BizPlan.cs:1390 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-72354b45 | InsertButton | DMF0042_1_BizPlan.cs:1395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae58cbbb | InsertButton | DMF0042_1_BizPlan.cs:1406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a43ef427 | InsertButton | DMF0042_1_BizPlan.cs:1412 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_1_BizPlan.MinColumnChk

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ccdfe1e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_1_BizPlan.cs:3320 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-db367b5c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_1_BizPlan.cs:3337 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-30543f07 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_1_BizPlan.cs:3356 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-92f35be4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_1_BizPlan.cs:3359 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.ParameterString

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (i != iLOCRow)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d77f301 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_1_BizPlan.cs:3112 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_BizPlan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-148d3d6c | SaveButton | DMF0042_1_BizPlan.cs:810 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e0d6c596 | SaveButton | DMF0042_1_BizPlan.cs:811 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f223df93 | SaveButton | DMF0042_1_BizPlan.cs:912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46c024fb | SaveButton | DMF0042_1_BizPlan.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ecca12e | SaveButton | DMF0042_1_BizPlan.cs:943 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8e036ee | SaveButton | DMF0042_1_BizPlan.cs:944 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eddf7b5c | SaveButton | DMF0042_1_BizPlan.cs:967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae5bc830 | SaveButton | DMF0042_1_BizPlan.cs:968 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f4455ec | SaveButton | DMF0042_1_BizPlan.cs:1087 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e7851c8b | SaveButton | DMF0042_1_BizPlan.cs:1088 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c89d0f4 | SaveButton | DMF0042_1_BizPlan.cs:1093 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f662489d | SaveButton | DMF0042_1_BizPlan.cs:1094 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed62caad | SaveButton | DMF0042_1_BizPlan.cs:1101 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-f16e7c76 | SaveButton | DMF0042_1_BizPlan.cs:1102 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-42275653 | SaveButton | DMF0042_1_BizPlan.cs:1102 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d477b7b8 | SaveButton | DMF0042_1_BizPlan.cs:1103 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | pDivision.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b7e0d29c | SaveButton | DMF0042_1_BizPlan.cs:1103 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDivision.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6746d951 | SaveButton | DMF0042_1_BizPlan.cs:1104 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE"] | pProjectCode.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5ee2b5bb | SaveButton | DMF0042_1_BizPlan.cs:1104 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pProjectCode.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddbe81c7 | SaveButton | DMF0042_1_BizPlan.cs:1105 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_NAME"] | pProjectName.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c282af9c | SaveButton | DMF0042_1_BizPlan.cs:1105 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pProjectName.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b84d132 | SaveButton | DMF0042_1_BizPlan.cs:1106 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | pScm_Site_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4b8ffa05 | SaveButton | DMF0042_1_BizPlan.cs:1106 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pScm_Site_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c24dedfc | SaveButton | DMF0042_1_BizPlan.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | pPlant_Site_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-117ba8f6 | SaveButton | DMF0042_1_BizPlan.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPlant_Site_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c622ba91 | SaveButton | DMF0042_1_BizPlan.cs:1108 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID"] | pItem_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a29afafa | SaveButton | DMF0042_1_BizPlan.cs:1108 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pItem_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1242a34 | SaveButton | DMF0042_1_BizPlan.cs:1110 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | pFcst_Type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-afd9de82 | SaveButton | DMF0042_1_BizPlan.cs:1110 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pFcst_Type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-11913882 | SaveButton | DMF0042_1_BizPlan.cs:1111 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | pIncoterms.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3c9ba113 | SaveButton | DMF0042_1_BizPlan.cs:1111 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pIncoterms.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-550644e8 | SaveButton | DMF0042_1_BizPlan.cs:1112 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE"] | pMeasure.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b8eafcb6 | SaveButton | DMF0042_1_BizPlan.cs:1112 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pMeasure.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-516765ea | SaveButton | DMF0042_1_BizPlan.cs:1113 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM"] | pYyyyMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-50123cd0 | SaveButton | DMF0042_1_BizPlan.cs:1113 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pYyyyMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-79dfe985 | SaveButton | DMF0042_1_BizPlan.cs:1114 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY"] | pInput.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ca9e5c2c | SaveButton | DMF0042_1_BizPlan.cs:1114 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pInput.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4656f6a3 | SaveButton | DMF0042_1_BizPlan.cs:1115 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY"] | pCurrency.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-337dc698 | SaveButton | DMF0042_1_BizPlan.cs:1115 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCurrency.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa06c7c8 | SaveButton | DMF0042_1_BizPlan.cs:1118 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DEPT_ID"] | p_DEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-28da36fb | SaveButton | DMF0042_1_BizPlan.cs:1118 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_DEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-73c896b9 | SaveButton | DMF0042_1_BizPlan.cs:1119 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_END_CUSTOMER"] | p_END_CUSTOMER.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-83ca2b3a | SaveButton | DMF0042_1_BizPlan.cs:1119 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_END_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-344c553c | SaveButton | DMF0042_1_BizPlan.cs:1120 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_BIZ_TYPE"] | p_BIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-44c2ee39 | SaveButton | DMF0042_1_BizPlan.cs:1120 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_BIZ_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-84d40357 | SaveButton | DMF0042_1_BizPlan.cs:1126 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_USE"] | p_ITEM_USE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b25976c6 | SaveButton | DMF0042_1_BizPlan.cs:1126 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_ITEM_USE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0d1f1b8 | SaveButton | DMF0042_1_BizPlan.cs:1127 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_UNIT_ENERGY"] | p_UNIT_ENERGY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-44604cdb | SaveButton | DMF0042_1_BizPlan.cs:1127 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_UNIT_ENERGY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-94c0e0ca | SaveButton | DMF0042_1_BizPlan.cs:1128 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | pCell_Prod_Site.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c50e623f | SaveButton | DMF0042_1_BizPlan.cs:1128 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCell_Prod_Site.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e671049a | SaveButton | DMF0042_1_BizPlan.cs:1130 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-47acac31 | SaveButton | DMF0042_1_BizPlan.cs:1130 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-92e73a14 | SaveButton | DMF0042_1_BizPlan.cs:1131 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-938948e4 | SaveButton | DMF0042_1_BizPlan.cs:1131 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-42db7deb | SaveButton | DMF0042_1_BizPlan.cs:1133 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c9b3c7e2 | SaveButton | DMF0042_1_BizPlan.cs:1138 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-3001ad81 | SaveButton | DMF0042_1_BizPlan.cs:1139 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09258bfa | SaveButton | DMF0042_1_BizPlan.cs:1143 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_1_BizPlan.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt == iCheck)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-668aea6f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_1_BizPlan.cs:3296 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0042_1_BizPlan.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivisio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7989e46 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:475 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-43d7660a | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:478 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-00672ea2 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:483 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b46f6bba | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:485 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-934c0b87 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:488 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9483f6fb | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:493 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5b08fdce | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_1_BizPlan.cs:495 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0042_1_BizPlan.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1154b34f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:410 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64509e15 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:418 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af58136d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:430 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36192f64 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:431 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d8233f7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:436 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f4ebbdf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:437 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fb4dc30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:444 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2dc1057f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:445 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-47f03713 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:456 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ea20692d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:457 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-140c4d21 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:458 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37559d17 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:459 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5aa78c3d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:461 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8090bb4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_1_BizPlan.cs:463 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_1_BizPlan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-910215fd | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1608 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5cb0aac1 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1614 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-05a065c8 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1630 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-c855ba70 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1645 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3185b4b6 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1676 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-03211e72 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1678 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9bc5b990 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1679 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6814af7a | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1680 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-595b29a6 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1689 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-34126e58 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1692 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-12e30c60 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1694 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID40), sItemId) | 그리드 값 설정 |  |  |  |
| AC-6cb0d3b3 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1696 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-05f23658 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1726 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a7a06730 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1728 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1c44f295 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1729 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-851fb828 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1730 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d8304f84 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1740 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-cdc988a3 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1743 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-5f12ec2e | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1745 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), sBizType) | 그리드 값 설정 |  |  |  |
| AC-06888311 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1776 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3ba35742 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1778 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-aaad7546 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1779 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-416ac369 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1780 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c5a45ea9 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1790 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-1640f1c0 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1793 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME)… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-fdea1f72 | this.spdMain.CellDoubleClick | DMF0042_1_BizPlan.cs:1795 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), sBizType) | 그리드 값 설정 |  |  |  |

## DMF0042_1_BizPlan.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92dedbc5 | dsdm.Changed | DMF0042_1_BizPlan.cs:1802 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-073db3aa | dsdm.Changed | DMF0042_1_BizPlan.cs:1805 | if (e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df374e0f | dsdm.Changed | DMF0042_1_BizPlan.cs:1806 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84b2907a | dsdm.Changed | DMF0042_1_BizPlan.cs:1810 | if (siMain.GetValue(e.Row, e.Column).ToString() == "") | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-a60a89c1 | dsdm.Changed | DMF0042_1_BizPlan.cs:1837 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fff811c3 | dsdm.Changed | DMF0042_1_BizPlan.cs:1848 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9098a87 | dsdm.Changed | DMF0042_1_BizPlan.cs:1852 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | GRID_SET | siMain.SetValue | (e.Row, e.Column, strValue[0] + ".000") | 그리드 값 설정 |  |  |  |
| AC-e91ee171 | dsdm.Changed | DMF0042_1_BizPlan.cs:1853 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00289") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9cb84cc3 | dsdm.Changed | DMF0042_1_BizPlan.cs:1879 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf4d66cb | dsdm.Changed | DMF0042_1_BizPlan.cs:1881 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fabb56f2 | dsdm.Changed | DMF0042_1_BizPlan.cs:1887 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7fd67c57 | dsdm.Changed | DMF0042_1_BizPlan.cs:1907 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef659a43 | dsdm.Changed | DMF0042_1_BizPlan.cs:1914 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-4cd5d7fb | dsdm.Changed | DMF0042_1_BizPlan.cs:1928 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72c57ba6 | dsdm.Changed | DMF0042_1_BizPlan.cs:1969 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (iQuarterlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-314508f6 | dsdm.Changed | DMF0042_1_BizPlan.cs:1994 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-92f80542 | dsdm.Changed | DMF0042_1_BizPlan.cs:2000 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-67c9a468 | dsdm.Changed | DMF0042_1_BizPlan.cs:2014 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-927339ef | dsdm.Changed | DMF0042_1_BizPlan.cs:2020 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-5b262e89 | dsdm.Changed | DMF0042_1_BizPlan.cs:2041 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-6c8af69a | dsdm.Changed | DMF0042_1_BizPlan.cs:2069 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7697936 | dsdm.Changed | DMF0042_1_BizPlan.cs:2077 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-377d5dbe | dsdm.Changed | DMF0042_1_BizPlan.cs:2095 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (Convert.ToDecimal(siMain.GetValue(e.Row, e.Column))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20c4cb1c | dsdm.Changed | DMF0042_1_BizPlan.cs:2104 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee4c58a9 | dsdm.Changed | DMF0042_1_BizPlan.cs:2104 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DateTime.Today.DayOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-101bec56 | dsdm.Changed | DMF0042_1_BizPlan.cs:2162 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6164a79f | dsdm.Changed | DMF0042_1_BizPlan.cs:2168 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-bb9ce766 | dsdm.Changed | DMF0042_1_BizPlan.cs:2184 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-88977711 | dsdm.Changed | DMF0042_1_BizPlan.cs:2190 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-1c60e788 | dsdm.Changed | DMF0042_1_BizPlan.cs:2212 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-e348598e | dsdm.Changed | DMF0042_1_BizPlan.cs:2247 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-bade7749 | dsdm.Changed | DMF0042_1_BizPlan.cs:2252 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-11639da9 | dsdm.Changed | DMF0042_1_BizPlan.cs:2274 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1f57179 | dsdm.Changed | DMF0042_1_BizPlan.cs:2281 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, iQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |
| AC-2f323f01 | dsdm.Changed | DMF0042_1_BizPlan.cs:2319 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-3d843569 | dsdm.Changed | DMF0042_1_BizPlan.cs:2346 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-df376a41 | dsdm.Changed | DMF0042_1_BizPlan.cs:2426 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-39117c73 | dsdm.Changed | DMF0042_1_BizPlan.cs:2432 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e9c01848 | dsdm.Changed | DMF0042_1_BizPlan.cs:2446 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-7a22adbc | dsdm.Changed | DMF0042_1_BizPlan.cs:2452 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-1d1aa227 | dsdm.Changed | DMF0042_1_BizPlan.cs:2473 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-eecaa091 | dsdm.Changed | DMF0042_1_BizPlan.cs:2509 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-77bb2a9b | dsdm.Changed | DMF0042_1_BizPlan.cs:2594 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ab10c866 | dsdm.Changed | DMF0042_1_BizPlan.cs:2600 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-af8116d1 | dsdm.Changed | DMF0042_1_BizPlan.cs:2616 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-b3601562 | dsdm.Changed | DMF0042_1_BizPlan.cs:2622 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-eda6a4df | dsdm.Changed | DMF0042_1_BizPlan.cs:2644 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-c612677c | dsdm.Changed | DMF0042_1_BizPlan.cs:2679 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-11408286 | dsdm.Changed | DMF0042_1_BizPlan.cs:2684 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e1cce399 | dsdm.Changed | DMF0042_1_BizPlan.cs:2713 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0042_1_BizPlan.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-291d866a | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1573 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7771b1f5 | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1574 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-300fd025 | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1586 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26ec8426 | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1589 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5e57a438 | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1592 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-af383990 | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1592 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6761b427 | this.spdMain.ComboSelChange | DMF0042_1_BizPlan.cs:1593 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0042_1_BizPlan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-066bb5d0 | this.spdMain.EditChange | DMF0042_1_BizPlan.cs:2977 | if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13a7dd46 | this.spdMain.EditChange | DMF0042_1_BizPlan.cs:2979 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_1_BizPlan.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48906fb4 | this.spdMain.TopChange | DMF0042_1_BizPlan.cs:2739 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_1_BizPlan.ValidationCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08806395 | (진입점 미연결) | DMF0042_1_BizPlan.cs:2728 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60120ff0 | (진입점 미연결) | DMF0042_1_BizPlan.cs:2731 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-d2d7b6a3 | (진입점 미연결) | DMF0042_1_BizPlan.cs:2733 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_1_RTF.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36c97de3 | (진입점 미연결) | DMF0042_1_RTF.cs:264 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-4f8fb5f5 | (진입점 미연결) | DMF0042_1_RTF.cs:265 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c9fa3008 | (진입점 미연결) | DMF0042_1_RTF.cs:279 | switch (buttonItem.UserType) case ButtonListType.Save: ▸ else of (this._MEASURE == "Demand Plan (1st)" && DateTime.Now.ToString("yyyyMM") ==… | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-75c52e7e | (진입점 미연결) | DMF0042_1_RTF.cs:280 | switch (buttonItem.UserType) case ButtonListType.Save: ▸ else of (this._MEASURE == "Demand Plan (1st)" && DateTime.Now.ToString("yyyyMM") ==… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0042_1_RTF.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58bb8202 | this.Load | DMF0042_1_RTF.cs:192 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31ab9be8 | this.Load | DMF0042_1_RTF.cs:193 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b5e703c | this.Load | DMF0042_1_RTF.cs:194 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_1_RTF.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6b3302b | Dispose | DMF0042_1_RTF.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_1_RTF.DMF0003_CustDemandAnalysis_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-542f505a | this.FormClosing | DMF0042_1_RTF.cs:1740 |  | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |

## DMF0042_1_RTF.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05590027 | EditButton | DMF0042_1_RTF.cs:354 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_1_RTF.FindData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d7a873a | this.Load | DMF0042_1_RTF.cs:297 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5a78d90d | this.Load | DMF0042_1_RTF.cs:304 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c3c4d9d | this.Load | DMF0042_1_RTF.cs:308 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_BIZPLAN_RTF") ⇒ DM.DMF0042_1_GET_BIZPLAN_RTF | 엔드포인트 요청 생성 |  |  |  |
| AC-fe47032c | this.Load | DMF0042_1_RTF.cs:310 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-601f0209 | this.Load | DMF0042_1_RTF.cs:312 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-df636f77 | this.Load | DMF0042_1_RTF.cs:313 | lambda | DATA_OP | request.Parameters["p_project_code"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-10c1a1e4 | this.Load | DMF0042_1_RTF.cs:315 | lambda | DATA_OP | request.Parameters["p_item_id"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-837b9199 | this.Load | DMF0042_1_RTF.cs:317 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c46ffa7 | this.Load | DMF0042_1_RTF.cs:319 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9a84a586 | this.Load | DMF0042_1_RTF.cs:324 |  | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7b1dd246 | this.Load | DMF0042_1_RTF.cs:325 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_1_RTF.FindDataMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d103afd6 | (진입점 미연결) | DMF0042_1_RTF.cs:686 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_1_RTF.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6298ebc9 | this.Load | DMF0042_1_RTF.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c785fe7d | this.Load | DMF0042_1_RTF.cs:118 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0c2c7712 | this.Load | DMF0042_1_RTF.cs:134 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-2138a7c1 | this.Load | DMF0042_1_RTF.cs:135 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c802d0ed | this.Load | DMF0042_1_RTF.cs:136 |  | FLAG | _PROJECT_NAME | PROJECT_NAME | 화면 필드/플래그 변경 |  |  |  |
| AC-2cf852fb | this.Load | DMF0042_1_RTF.cs:137 |  | FLAG | _ITEM_ID | ITEM_ID | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_1_RTF.GetSLOC

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6a07633 | (진입점 미연결) | DMF0042_1_RTF.cs:823 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-914c2e00 | (진입점 미연결) | DMF0042_1_RTF.cs:824 |  | DATA_OP | request.Parameters["CODE"] | "PR_SLOC" | 행/컬럼 값 대입 |  |  |  |
| AC-8e30d7c0 | (진입점 미연결) | DMF0042_1_RTF.cs:825 |  | DATA_OP | request.Parameters["PARAM1"] | SPlant | 행/컬럼 값 대입 |  |  |  |
| AC-7b1f89fc | (진입점 미연결) | DMF0042_1_RTF.cs:826 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6958f363 | (진입점 미연결) | DMF0042_1_RTF.cs:827 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-69b3c104 | (진입점 미연결) | DMF0042_1_RTF.cs:828 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-abe8227f | (진입점 미연결) | DMF0042_1_RTF.cs:829 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4640752e | (진입점 미연결) | DMF0042_1_RTF.cs:830 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be8a2d53 | (진입점 미연결) | DMF0042_1_RTF.cs:832 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_RTF.GetSPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c975c9b1 | (진입점 미연결) | DMF0042_1_RTF.cs:805 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-87f0686c | (진입점 미연결) | DMF0042_1_RTF.cs:806 |  | DATA_OP | request.Parameters["CODE"] | "PR_SPLANT" | 행/컬럼 값 대입 |  |  |  |
| AC-288f6648 | (진입점 미연결) | DMF0042_1_RTF.cs:807 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38476d45 | (진입점 미연결) | DMF0042_1_RTF.cs:808 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c4d2176 | (진입점 미연결) | DMF0042_1_RTF.cs:809 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-110848d8 | (진입점 미연결) | DMF0042_1_RTF.cs:810 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7886e3dd | (진입점 미연결) | DMF0042_1_RTF.cs:811 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-885bcc83 | (진입점 미연결) | DMF0042_1_RTF.cs:812 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99a5f276 | (진입점 미연결) | DMF0042_1_RTF.cs:814 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_RTF.GetSplit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99727aee | (진입점 미연결) | DMF0042_1_RTF.cs:772 |  | RETURN | return sar.Split('^'); |  | 처리 중단/반환 |  |  |  |

## DMF0042_1_RTF.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a4b4d27 | this.Load | DMF0042_1_RTF.cs:155 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0042_1_RTF.InitSpread

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffbbad67 | this.Load 외 1 | DMF0042_1_RTF.cs:207 |  | DATA_OP | dtTitle.Columns.Add | ("PROGRAM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-00822a21 | this.Load 외 1 | DMF0042_1_RTF.cs:208 |  | DATA_OP | dtTitle.Columns.Add | ("SHEET_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-92410984 | this.Load 외 1 | DMF0042_1_RTF.cs:209 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed9147c8 | this.Load 외 1 | DMF0042_1_RTF.cs:210 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d303cff | this.Load 외 1 | DMF0042_1_RTF.cs:211 |  | DATA_OP | dtTitle.Columns.Add | ("SORT_ORDER_NO", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75dddc05 | this.Load 외 1 | DMF0042_1_RTF.cs:212 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_SORT_METHOD_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dadf0f18 | this.Load 외 1 | DMF0042_1_RTF.cs:213 |  | DATA_OP | dtTitle.Columns.Add | ("SMALL_CLASS_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-846141d7 | this.Load 외 1 | DMF0042_1_RTF.cs:214 |  | DATA_OP | dtTitle.Columns.Add | ("LARGE_CLASS_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-deb72c1d | this.Load 외 1 | DMF0042_1_RTF.cs:215 |  | DATA_OP | dtTitle.Columns.Add | ("FIXED_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3e33ff6 | this.Load 외 1 | DMF0042_1_RTF.cs:216 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_WIDTH", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-20d34211 | this.Load 외 1 | DMF0042_1_RTF.cs:217 |  | DATA_OP | dtTitle.Columns.Add | ("CELL_CONTROL_OBJECT_TYPE_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-789a7f26 | this.Load 외 1 | DMF0042_1_RTF.cs:218 |  | DATA_OP | dtTitle.Columns.Add | ("CELL_COMBO_DATA_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60443970 | this.Load 외 1 | DMF0042_1_RTF.cs:219 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_SCALE_NUMBER", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-935e21b2 | this.Load 외 1 | DMF0042_1_RTF.cs:220 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_MAX_LENGTH", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-321f50ff | this.Load 외 1 | DMF0042_1_RTF.cs:221 |  | DATA_OP | dtTitle.Columns.Add | ("HORIZONTAL_ALIGN_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-67d7916b | this.Load 외 1 | DMF0042_1_RTF.cs:222 |  | DATA_OP | dtTitle.Columns.Add | ("UPPERCASE_APPLY_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2729063a | this.Load 외 1 | DMF0042_1_RTF.cs:223 |  | DATA_OP | dtTitle.Columns.Add | ("VISIBLE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8af6a89 | this.Load 외 1 | DMF0042_1_RTF.cs:224 |  | DATA_OP | dtTitle.Columns.Add | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43c28594 | this.Load 외 1 | DMF0042_1_RTF.cs:225 |  | DATA_OP | dtTitle.Columns.Add | ("DEFAULT_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-426b1e7d | this.Load 외 1 | DMF0042_1_RTF.cs:226 |  | DATA_OP | dtTitle.Columns.Add | ("USER_SELECTABLE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a24fa64 | this.Load 외 1 | DMF0042_1_RTF.cs:227 |  | DATA_OP | dtTitle.Columns.Add | ("VALID_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6898969 | this.Load 외 1 | DMF0042_1_RTF.cs:230 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "PROJECT_CODE", "Project Code", "20", "", "Proje… | 데이터 객체 조작/조회 |  |  |  |
| AC-9814d583 | this.Load 외 1 | DMF0042_1_RTF.cs:232 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "ITEM_ID", "Model Code", "30", "", "Model Code",… | 데이터 객체 조작/조회 |  |  |  |
| AC-aadd235a | this.Load 외 1 | DMF0042_1_RTF.cs:234 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "EE_PROD", "전극생산지", "50", "", "전극생산지", "전극생산지", … | 데이터 객체 조작/조회 |  |  |  |
| AC-9c76d96f | this.Load 외 1 | DMF0042_1_RTF.cs:235 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "CELL_PROD", "Cell생산지", "60", "", "Cell생산지", "Ce… | 데이터 객체 조작/조회 |  |  |  |
| AC-19bd9de1 | this.Load 외 1 | DMF0042_1_RTF.cs:236 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "PACK_PROD", "PACK생산지", "70", "", "PACK생산지", "PA… | 데이터 객체 조작/조회 |  |  |  |
| AC-62864eb3 | this.Load 외 1 | DMF0042_1_RTF.cs:237 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "EXT_INT", "외주여부", "80", "", "외주여부", "외주여부", "",… | 데이터 객체 조작/조회 |  |  |  |
| AC-1834f6fc | this.Load 외 1 | DMF0042_1_RTF.cs:238 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "MEASURE", "MEASURE", "90", "", "MEASURE", "MEAS… | 데이터 객체 조작/조회 |  |  |  |
| AC-c68a9e3a | this.Load 외 1 | DMF0042_1_RTF.cs:244 | for (i <= 60) | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "M_" + month, month.Substring(0, 4) + "'" + mont… | 데이터 객체 조작/조회 |  |  |  |
| AC-6cdea6b1 | this.Load 외 1 | DMF0042_1_RTF.cs:247 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0042_1", "RTF POPUP", "TOTAL", "TOTAL", "420", "", "TOTAL", "TOTAL", "… | 데이터 객체 조작/조회 |  |  |  |
| AC-3a22c519 | this.Load 외 1 | DMF0042_1_RTF.cs:250 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0042_1_RTF.SaveData

진입점: SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d171ca8c | SaveButton 외 1 | DMF0042_1_RTF.cs:464 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM. | 엔드포인트 요청 생성 |  |  |  |
| AC-48dffdbb | SaveButton 외 1 | DMF0042_1_RTF.cs:466 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-084f4315 | SaveButton 외 1 | DMF0042_1_RTF.cs:467 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-0d28cee0 | SaveButton 외 1 | DMF0042_1_RTF.cs:468 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_yyyymm"] | sYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-cb201aad | SaveButton 외 1 | DMF0042_1_RTF.cs:469 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_cust_fcst_m"] | sCUST_FCST_M | 행/컬럼 값 대입 |  |  |  |
| AC-6638fb3d | SaveButton 외 1 | DMF0042_1_RTF.cs:470 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMEASUE | 행/컬럼 값 대입 |  |  |  |
| AC-6519f031 | SaveButton 외 1 | DMF0042_1_RTF.cs:471 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_qtycd1"] | sQTYCD1 | 행/컬럼 값 대입 |  |  |  |
| AC-18af3ee1 | SaveButton 외 1 | DMF0042_1_RTF.cs:472 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_qtycd2"] | sQTYCD2 | 행/컬럼 값 대입 |  |  |  |
| AC-1f8138c7 | SaveButton 외 1 | DMF0042_1_RTF.cs:473 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_qtycd3"] | sQTYCD3 | 행/컬럼 값 대입 |  |  |  |
| AC-efc9f046 | SaveButton 외 1 | DMF0042_1_RTF.cs:474 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_seq"] | sSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-677d4622 | SaveButton 외 1 | DMF0042_1_RTF.cs:475 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_qty"] | sQTY | 행/컬럼 값 대입 |  |  |  |
| AC-d1616e7e | SaveButton 외 1 | DMF0042_1_RTF.cs:476 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_mkt_fcst_m"] | sMKT_FCST_M | 행/컬럼 값 대입 |  |  |  |
| AC-84dbab8f | SaveButton 외 1 | DMF0042_1_RTF.cs:477 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_desc"] | sDESC | 행/컬럼 값 대입 |  |  |  |
| AC-866ecd6a | SaveButton 외 1 | DMF0042_1_RTF.cs:478 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_input_limit"] | sINPUT_LIMIT | 행/컬럼 값 대입 |  |  |  |
| AC-684be751 | SaveButton 외 1 | DMF0042_1_RTF.cs:479 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sCREATED_BY | 행/컬럼 값 대입 |  |  |  |
| AC-9f36eb55 | SaveButton 외 1 | DMF0042_1_RTF.cs:481 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8aab7e48 | SaveButton 외 1 | DMF0042_1_RTF.cs:501 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3188e0ef | SaveButton 외 1 | DMF0042_1_RTF.cs:508 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-452baabd | SaveButton 외 1 | DMF0042_1_RTF.cs:509 | if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0042_1_RTF.Select_DpInit_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b24c8d5 | (진입점 미연결) | DMF0042_1_RTF.cs:1030 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fe6cc450 | (진입점 미연결) | DMF0042_1_RTF.cs:1032 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20ef7f0d | (진입점 미연결) | DMF0042_1_RTF.cs:1036 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_DM_ANL_MKT_PSI_DPINIT") ⇒ DM.DMF0003_GET_DM_ANL_MKT_PSI_DPINIT | 엔드포인트 요청 생성 |  |  |  |
| AC-abc0e42b | (진입점 미연결) | DMF0042_1_RTF.cs:1038 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | _DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-47d2256c | (진입점 미연결) | DMF0042_1_RTF.cs:1039 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | _PROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-97e93d0e | (진입점 미연결) | DMF0042_1_RTF.cs:1040 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | _YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-0c7eaba4 | (진입점 미연결) | DMF0042_1_RTF.cs:1041 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0ebd9248 | (진입점 미연결) | DMF0042_1_RTF.cs:1043 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d9796010 | (진입점 미연결) | DMF0042_1_RTF.cs:1045 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ba84098e | (진입점 미연결) | DMF0042_1_RTF.cs:1050 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-82e1fb7e | (진입점 미연결) | DMF0042_1_RTF.cs:1053 | try | FLAG | dtSave | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-323bc818 | (진입점 미연결) | DMF0042_1_RTF.cs:1139 | try ▸ for (i < 5) | DATA_OP | dt.Rows.Add | (new object[] { _PROJECT_CODE, _YYYYMM, _EDI_QTY, 0, "", "", "", "", _MKT_FCST }) | 데이터 객체 조작/조회 |  |  |  |
| AC-acd46f12 | (진입점 미연결) | DMF0042_1_RTF.cs:1142 | try | GRID_BIND | siMain.Query | (dt.DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-21db11f4 | (진입점 미연결) | DMF0042_1_RTF.cs:1149 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1f90e749 | (진입점 미연결) | DMF0042_1_RTF.cs:1159 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c413eb3 | (진입점 미연결) | DMF0042_1_RTF.cs:1165 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cc4e46d8 | (진입점 미연결) | DMF0042_1_RTF.cs:1175 |  | UI_PROP | cmbImputation.Items | (new String[] { "고객", "당사" }) | 속성 Items 설정 |  |  |  |
| AC-ea4d21e0 | (진입점 미연결) | DMF0042_1_RTF.cs:1176 |  | UI_PROP | cmbImputation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-9b4bbc4b | (진입점 미연결) | DMF0042_1_RTF.cs:1177 |  | STATE | cmbImputation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-7688a85a | (진입점 미연결) | DMF0042_1_RTF.cs:1178 |  | UI_PROP | cmbImputation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-df52ef99 | (진입점 미연결) | DMF0042_1_RTF.cs:1183 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.IMPUTATION_YN)].CellType | cmbImputation | 그리드 속성/값 설정 |  |  |  |
| AC-23f03c34 | (진입점 미연결) | DMF0042_1_RTF.cs:1188 |  | UI_PROP | cmbDemandOperation.Items | (new String[] { "수요", "운영" }) | 속성 Items 설정 |  |  |  |
| AC-2b195e4d | (진입점 미연결) | DMF0042_1_RTF.cs:1189 |  | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-0fb5bec5 | (진입점 미연결) | DMF0042_1_RTF.cs:1190 |  | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-0039e2bb | (진입점 미연결) | DMF0042_1_RTF.cs:1191 |  | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-2575c99b | (진입점 미연결) | DMF0042_1_RTF.cs:1196 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.DEMAND_OPERATION)].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-a61661c7 | (진입점 미연결) | DMF0042_1_RTF.cs:1200 |  | UI_PROP | cmbVariationFactor.Items | (new String[] { "차량생산", "차량판매", "물류이슈", "시점조정", "모델믹스" }) | 속성 Items 설정 |  |  |  |
| AC-96833184 | (진입점 미연결) | DMF0042_1_RTF.cs:1201 |  | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-3fa5d1db | (진입점 미연결) | DMF0042_1_RTF.cs:1202 |  | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-a319be21 | (진입점 미연결) | DMF0042_1_RTF.cs:1203 |  | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-79c6c101 | (진입점 미연결) | DMF0042_1_RTF.cs:1208 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VARIATION_FACTOR)].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-a81784f2 | (진입점 미연결) | DMF0042_1_RTF.cs:1295 | if (DateTime.Now.ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-66101840 | (진입점 미연결) | DMF0042_1_RTF.cs:1300 | if (DateTime.Now.ToString("yyyyMM") != _YYYYMM) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-deb46d49 | (진입점 미연결) | DMF0042_1_RTF.cs:1306 | else of (DateTime.Now.ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EDI_QTY), siMain.GetColumnIndex(DefColumns.EDI_QTY), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-992bf908 | (진입점 미연결) | DMF0042_1_RTF.cs:1307 | else of (DateTime.Now.ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.RESULT), siMain.GetColumnIndex(DefColumns.RESULT), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-08b1f668 | (진입점 미연결) | DMF0042_1_RTF.cs:1308 | else of (DateTime.Now.ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MKT_FCST), siMain.GetColumnIndex(DefColumns.MKT_FCST), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9864981d | (진입점 미연결) | DMF0042_1_RTF.cs:1309 | else of (DateTime.Now.ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.GAP), siMain.GetColumnIndex(DefColumns.GAP), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-34fddaad | (진입점 미연결) | DMF0042_1_RTF.cs:1316 |  | GRID_SET | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.EDI_QTY)].RowSpan | siMain.GetMaxRowIndex() + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-d2d4ec24 | (진입점 미연결) | DMF0042_1_RTF.cs:1317 |  | GRID_SET | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.MKT_FCST)].RowSpan | siMain.GetMaxRowIndex() + 1 | 그리드 속성/값 설정 |  |  |  |

## DMF0042_1_RTF.Select_DpResult_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7a12426 | (진입점 미연결) | DMF0042_1_RTF.cs:1383 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3983fbba | (진입점 미연결) | DMF0042_1_RTF.cs:1385 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f43dc086 | (진입점 미연결) | DMF0042_1_RTF.cs:1389 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT") ⇒ DM.DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-dc946f50 | (진입점 미연결) | DMF0042_1_RTF.cs:1391 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | _DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f26ec66f | (진입점 미연결) | DMF0042_1_RTF.cs:1392 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | _PROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-975b14c0 | (진입점 미연결) | DMF0042_1_RTF.cs:1393 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | _YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-baef885d | (진입점 미연결) | DMF0042_1_RTF.cs:1394 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c116347a | (진입점 미연결) | DMF0042_1_RTF.cs:1396 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-060e1507 | (진입점 미연결) | DMF0042_1_RTF.cs:1398 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-72fb1163 | (진입점 미연결) | DMF0042_1_RTF.cs:1403 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d98697cb | (진입점 미연결) | DMF0042_1_RTF.cs:1406 | try | FLAG | dtSave | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b8bea55 | (진입점 미연결) | DMF0042_1_RTF.cs:1489 | try ▸ for (i < 5) | DATA_OP | dt.Rows.Add | (new object[] { _PROJECT_CODE, _YYYYMM, _EDI_QTY.Split('^')[0], 0, "", "", "", "", _MKT_FC… | 데이터 객체 조작/조회 |  |  |  |
| AC-2559a10b | (진입점 미연결) | DMF0042_1_RTF.cs:1493 | try | GRID_BIND | siMain.Query | (dt.DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b74037cd | (진입점 미연결) | DMF0042_1_RTF.cs:1501 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-17580db6 | (진입점 미연결) | DMF0042_1_RTF.cs:1511 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71690608 | (진입점 미연결) | DMF0042_1_RTF.cs:1517 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0bd79618 | (진입점 미연결) | DMF0042_1_RTF.cs:1521 |  | UI_PROP | cmbImputation.Items | (new String[] { "고객", "당사" }) | 속성 Items 설정 |  |  |  |
| AC-76beb3a5 | (진입점 미연결) | DMF0042_1_RTF.cs:1522 |  | UI_PROP | cmbImputation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-b38b4b66 | (진입점 미연결) | DMF0042_1_RTF.cs:1523 |  | STATE | cmbImputation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-5a52703b | (진입점 미연결) | DMF0042_1_RTF.cs:1524 |  | UI_PROP | cmbImputation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-41169cd3 | (진입점 미연결) | DMF0042_1_RTF.cs:1529 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.IMPUTATION_YN)].CellType | cmbImputation | 그리드 속성/값 설정 |  |  |  |
| AC-91223f0a | (진입점 미연결) | DMF0042_1_RTF.cs:1534 |  | UI_PROP | cmbDemandOperation.Items | (new String[] { "수요", "운영" }) | 속성 Items 설정 |  |  |  |
| AC-399aab2e | (진입점 미연결) | DMF0042_1_RTF.cs:1535 |  | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-583434b2 | (진입점 미연결) | DMF0042_1_RTF.cs:1536 |  | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-dbe00b9e | (진입점 미연결) | DMF0042_1_RTF.cs:1537 |  | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-e4d84b24 | (진입점 미연결) | DMF0042_1_RTF.cs:1542 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.DEMAND_OPERATION)].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-47356171 | (진입점 미연결) | DMF0042_1_RTF.cs:1546 |  | UI_PROP | cmbVariationFactor.Items | (new String[] { "차량생산", "차량판매", "물류이슈", "시점조정", "모델믹스" }) | 속성 Items 설정 |  |  |  |
| AC-a55fffe0 | (진입점 미연결) | DMF0042_1_RTF.cs:1547 |  | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-f5d52262 | (진입점 미연결) | DMF0042_1_RTF.cs:1548 |  | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-f57217d8 | (진입점 미연결) | DMF0042_1_RTF.cs:1549 |  | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-79da7877 | (진입점 미연결) | DMF0042_1_RTF.cs:1554 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VARIATION_FACTOR)].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-71efc821 | (진입점 미연결) | DMF0042_1_RTF.cs:1563 | if (DateTime.Now.AddMonths(-1).ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-acd94a8d | (진입점 미연결) | DMF0042_1_RTF.cs:1568 | if (DateTime.Now.AddMonths(-1).ToString("yyyyMM") != _YYYYMM) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-2daae39f | (진입점 미연결) | DMF0042_1_RTF.cs:1574 | else of (DateTime.Now.AddMonths(-1).ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EDI_QTY), siMain.GetColumnIndex(DefColumns.EDI_QTY), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a974aa8 | (진입점 미연결) | DMF0042_1_RTF.cs:1575 | else of (DateTime.Now.AddMonths(-1).ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.RESULT), siMain.GetColumnIndex(DefColumns.RESULT), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab3ea3da | (진입점 미연결) | DMF0042_1_RTF.cs:1576 | else of (DateTime.Now.AddMonths(-1).ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MKT_FCST), siMain.GetColumnIndex(DefColumns.MKT_FCST), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-85aa7623 | (진입점 미연결) | DMF0042_1_RTF.cs:1577 | else of (DateTime.Now.AddMonths(-1).ToString("yyyyMM") != _YYYYMM) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.GAP), siMain.GetColumnIndex(DefColumns.GAP), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-31b32688 | (진입점 미연결) | DMF0042_1_RTF.cs:1584 |  | GRID_SET | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.EDI_QTY)].RowSpan | siMain.GetMaxRowIndex() + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-b9225637 | (진입점 미연결) | DMF0042_1_RTF.cs:1585 |  | GRID_SET | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.MKT_FCST)].RowSpan | siMain.GetMaxRowIndex() + 1 | 그리드 속성/값 설정 |  |  |  |

## DMF0042_1_RTF.Select_In_De_Demand

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74ef67cb | (진입점 미연결) | DMF0042_1_RTF.cs:1626 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.RESULT), indedemand) | 그리드 값 설정 |  |  |  |
| AC-526a9d71 | (진입점 미연결) | DMF0042_1_RTF.cs:1627 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.GAP), gap) | 그리드 값 설정 |  |  |  |
| AC-5951e0fd | (진입점 미연결) | DMF0042_1_RTF.cs:1629 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.RESULT)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-06bb11ca | (진입점 미연결) | DMF0042_1_RTF.cs:1630 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |

## DMF0042_1_RTF.sheetSetting

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d4be302 | (진입점 미연결) | DMF0042_1_RTF.cs:1640 | for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.GetColumnIndex(DefColumns.DESC) + 1) | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |

## DMF0042_1_RTF.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1dfaf65 | (진입점 미연결) | DMF0042_1_RTF.cs:931 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.Items | (new String[] { "수요" }) | 속성 Items 설정 |  |  |  |
| AC-14e83d5e | (진입점 미연결) | DMF0042_1_RTF.cs:932 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-ba7f9659 | (진입점 미연결) | DMF0042_1_RTF.cs:933 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-0cb18b93 | (진입점 미연결) | DMF0042_1_RTF.cs:934 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-3a92585f | (진입점 미연결) | DMF0042_1_RTF.cs:938 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, 7].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-84e74d47 | (진입점 미연결) | DMF0042_1_RTF.cs:946 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.Items | (new String[] { "운영" }) | 속성 Items 설정 |  |  |  |
| AC-cd573218 | (진입점 미연결) | DMF0042_1_RTF.cs:947 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-ab2e4916 | (진입점 미연결) | DMF0042_1_RTF.cs:948 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-300856bd | (진입점 미연결) | DMF0042_1_RTF.cs:949 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-c08e844d | (진입점 미연결) | DMF0042_1_RTF.cs:953 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") ▸ for (i <= siMain.GetMaxRowIn… | GRID_SET | siMain.ActiveSheet.Cells[i, 7].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-0e6a3f5f | (진입점 미연결) | DMF0042_1_RTF.cs:958 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d256b991 | (진입점 미연결) | DMF0042_1_RTF.cs:966 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.Items | (new String[] { "차량생산", "차량판매", "물류이슈" }) | 속성 Items 설정 |  |  |  |
| AC-68c3add4 | (진입점 미연결) | DMF0042_1_RTF.cs:967 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-99593064 | (진입점 미연결) | DMF0042_1_RTF.cs:968 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-c9bd5854 | (진입점 미연결) | DMF0042_1_RTF.cs:969 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-8651c40e | (진입점 미연결) | DMF0042_1_RTF.cs:973 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | GRID_SET | siMain.ActiveSheet.Cells[i, 8].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-aa8e3db7 | (진입점 미연결) | DMF0042_1_RTF.cs:981 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.Items | (new String[] { "시점조정", "모델믹스" }) | 속성 Items 설정 |  |  |  |
| AC-70b40345 | (진입점 미연결) | DMF0042_1_RTF.cs:982 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-d339f220 | (진입점 미연결) | DMF0042_1_RTF.cs:983 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-98344217 | (진입점 미연결) | DMF0042_1_RTF.cs:984 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-b6f13691 | (진입점 미연결) | DMF0042_1_RTF.cs:988 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | GRID_SET | siMain.ActiveSheet.Cells[i, 8].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-6d2bb44f | (진입점 미연결) | DMF0042_1_RTF.cs:993 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_1_RTF.spdMain_ComboCloseUp

진입점: this.spdMain.ComboCloseUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e995408b | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1667 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.Items | (new String[] { "수요" }) | 속성 Items 설정 |  |  |  |
| AC-3b2b659e | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1668 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-ebce05dd | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1669 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (cboText == "고객") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-4b6af01c | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1670 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-ad3f96d1 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1677 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (cboText == "고객") | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DEMAND_OPERATION)].CellTy… | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-7f3afbb1 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1684 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.Items | (new String[] { "운영" }) | 속성 Items 설정 |  |  |  |
| AC-a5d75eb7 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1685 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-e5952f4b | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1686 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-dd3b2e55 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1687 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-f6fe1404 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1694 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.DEMAND_OPERATION)].CellTy… | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-8dfb4cfb | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1697 | if (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-093194fc | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1705 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "… | UI_PROP | cmbVariationFactor.Items | (new String[] { "차량생산", "차량판매", "물류이슈" }) | 속성 Items 설정 |  |  |  |
| AC-d518eaa2 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1706 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-6aeb8a57 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1707 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-c27939f7 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1708 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-8fcec016 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1715 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.VARIATION_FACTOR)].CellTy… | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-8866dff0 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1721 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText… | UI_PROP | cmbVariationFactor.Items | (new String[] { "시점조정", "모델믹스" }) | 속성 Items 설정 |  |  |  |
| AC-7b7151d0 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1722 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-50e6a667 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1723 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-80b0d9dd | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1724 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-9d1084c3 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1731 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.VARIATION_FACTOR)].CellTy… | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-7cd072c9 | this.spdMain.ComboCloseUp | DMF0042_1_RTF.cs:1734 | else of (siMain.GetColumnValue(e.Column) == "IMPUTATION_YN") ▸ if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_2_BizPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c7ea5d4 | this.btnColumn.Click | DMF0042_2_BizPlan.cs:3030 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042_1", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-5740875a | this.btnColumn.Click | DMF0042_2_BizPlan.cs:3031 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d0320db2 | this.btnColumn.Click | DMF0042_2_BizPlan.cs:3032 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_2_BizPlan.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c040c2b9 | this.btnCutOff.Click | DMF0042_2_BizPlan.cs:3065 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-0d772434 | this.btnCutOff.Click | DMF0042_2_BizPlan.cs:3066 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f313f0f1 | this.btnCutOff.Click | DMF0042_2_BizPlan.cs:3073 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-b85d974b | this.btnCutOff.Click | DMF0042_2_BizPlan.cs:3078 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ebe8466 | this.btnCutOff.Click | DMF0042_2_BizPlan.cs:3080 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9b0dba10 | this.btnCutOff.Click | DMF0042_2_BizPlan.cs:3081 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_2_BizPlan.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d7d39e3 | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3213 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1eb24fc | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3214 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91ae50c1 | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3217 |  | POPUP | new POPUP.DMF0042_ExchangeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-10f15fa3 | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3218 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP", clbDivisi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5b00201 | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3220 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eea480a6 | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3221 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-70973df5 | this.btnExchangeRate.Click | DMF0042_2_BizPlan.cs:3225 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_2_BizPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-314de4a7 | this.btnItemId.Click | DMF0042_2_BizPlan.cs:3014 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-48edb511 | this.btnItemId.Click | DMF0042_2_BizPlan.cs:3016 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-82b87c7a | this.btnItemId.Click | DMF0042_2_BizPlan.cs:3017 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f1b9b388 | this.btnItemId.Click | DMF0042_2_BizPlan.cs:3018 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8303842d | this.btnItemId.Click | DMF0042_2_BizPlan.cs:3024 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0042_2_BizPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d1b9545 | this.btnMeasure.Click | DMF0042_2_BizPlan.cs:3042 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042_1", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-4f6229d0 | this.btnMeasure.Click | DMF0042_2_BizPlan.cs:3044 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c8a0fa7d | this.btnMeasure.Click | DMF0042_2_BizPlan.cs:3045 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_2_BizPlan.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc188231 | this.btnOwner.Click | DMF0042_2_BizPlan.cs:3177 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-590f0a97 | this.btnOwner.Click | DMF0042_2_BizPlan.cs:3180 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-23b09bc3 | this.btnOwner.Click | DMF0042_2_BizPlan.cs:3181 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f5c55d07 | this.btnOwner.Click | DMF0042_2_BizPlan.cs:3182 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eca47e02 | this.btnOwner.Click | DMF0042_2_BizPlan.cs:3184 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0042_2_BizPlan.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48298c6f | this.btnProject.Click 외 1 | DMF0042_2_BizPlan.cs:2992 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-1ca31fe8 | this.btnProject.Click 외 1 | DMF0042_2_BizPlan.cs:2993 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2437251c | this.btnProject.Click 외 1 | DMF0042_2_BizPlan.cs:2994 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7d0652a2 | this.btnProject.Click 외 1 | DMF0042_2_BizPlan.cs:2995 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9af6fe02 | this.btnProject.Click 외 1 | DMF0042_2_BizPlan.cs:3001 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0042_2_BizPlan.btnReplace_Click

진입점: this.btnReplace.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba5c9356 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3549 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-091dd89e | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3550 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d64adcc1 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3557 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-f4751fc7 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3558 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2325d559 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3563 |  | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3fbd976 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3567 |  | DATA_OP | dt.Columns.Add | ("YYYYMM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e5331f6 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3571 | if (spdMain.Sheets[0].RowCount == 0) | MESSAGE | MessageBox.Show | ("데이터 조회 후 다시 시도해 주시기 바랍니다.") | 메시지 표시 |  |  |  |
| AC-5dff33bd | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3572 | if (spdMain.Sheets[0].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0487ffee | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3593 | else of (cr == null) ▸ for (i <= ColEnd) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d4480e2 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3597 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | row["YYYYMM"] | colTag.Substring(2, 6).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-92d61e30 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3598 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bc75810 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3626 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-b68e761c | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3630 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b855add0 | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3632 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e76a7fbf | this.btnReplace.Click | DMF0042_2_BizPlan.cs:3633 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_2_BizPlan.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9646eb32 | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3341 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00282") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af63afc1 | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3342 | if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d2450fb | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3348 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_SAVE_DM_PLN_BP_FCST_PRICE_CONV") ⇒ DM.DMF0042_1_SAVE_DM_PLN_BP_FCST_PRICE_CONV | 엔드포인트 요청 생성 |  |  |  |
| AC-26289b18 | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3350 |  | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8c31bbc8 | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3352 |  | DATA_OP | request.Parameters["s_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d71d749 | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3353 |  | DATA_OP | request.Parameters["s_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3f18d88e | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3354 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da9ef789 | this.btnSetPrice.Click | DMF0042_2_BizPlan.cs:3357 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_2_BizPlan.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56c21447 | this.cboBucketType.Click | DMF0042_2_BizPlan.cs:3193 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e684cccb | this.cboBucketType.Click | DMF0042_2_BizPlan.cs:3194 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99c0ce7b | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1543 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6a14850e | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1543 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af981afe | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1544 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-00095259 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1552 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9b64ff81 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1552 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c74ae927 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1553 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f66c3f7a | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1555 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-1faa42a1 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1555 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bbecca1 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1557 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c1151562 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1558 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-55b0e0f7 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1559 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bcd32927 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1560 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_1_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-9f4c7e93 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1560 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_1_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c17996c9 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1564 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-74f8ff51 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1565 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb25660e | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1567 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e450b448 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1567 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23c78d60 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1569 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2382bfb5 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1570 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0ec88bac | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1571 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f37f6316 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1573 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_1_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-a0ce7950 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1573 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_1_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a96ea5ac | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1577 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-6037773e | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1578 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-062cacc8 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1580 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-69b7bfbd | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1580 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-777fcdf4 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1582 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-762e5eda | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1583 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-388aaf38 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1584 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e8b1378b | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1586 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_1_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-462199e9 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1586 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_1_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-debce1c2 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1590 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dfbf15ca | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1592 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a0f0b654 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1595 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f01c362f | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1595 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-12857d53 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1596 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d7f446c | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1598 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-a6c55294 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1598 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca2aec91 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1599 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-07f33752 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1601 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-88609f8d | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1602 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ce1e8516 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1604 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-66a4a537 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1606 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-988714c1 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1607 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-07281e6f | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1610 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e17c063c | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1611 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-35019776 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1613 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-1ae5604e | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1613 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6aed3f27 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1615 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c63ef010 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1617 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-76508c76 | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1618 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cedffd2d | clbDivision.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1619 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d162c2c | this.clbCustomer.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1653 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-aee2839f | this.clbCustomer.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1653 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55075a6e | this.clbCustomer.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1657 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f3cec6d | this.clbCustomer.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1657 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ca1da42 | this.clbCustomer.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1659 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b0d847b | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1631 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b9ec9e86 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1631 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d174487 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1632 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b31571f | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1634 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0612c150 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1634 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b76b6ed9 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1638 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-3203eef2 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1638 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d395274 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1639 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3b4023b1 | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1641 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec6e596c | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1641 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-420fabbd | this.clbTeam.SelectedIndexChanged | DMF0042_2_BizPlan.cs:1645 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_2_BizPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b1ff1f6 | this.Load | DMF0042_2_BizPlan.cs:355 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7e3a19e | this.Load | DMF0042_2_BizPlan.cs:356 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-858ff5c9 | this.Load | DMF0042_2_BizPlan.cs:357 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_2_BizPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d165e6c0 | this.Load | DMF0042_2_BizPlan.cs:318 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-56ff700d | this.Load | DMF0042_2_BizPlan.cs:320 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-69992e16 | this.Load | DMF0042_2_BizPlan.cs:322 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-28dbd4ec | this.Load | DMF0042_2_BizPlan.cs:323 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f66b3b21 | this.Load | DMF0042_2_BizPlan.cs:324 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-cb73ee68 | this.Load | DMF0042_2_BizPlan.cs:325 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-0c142a5b | this.Load | DMF0042_2_BizPlan.cs:335 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-09f538d8 | this.Load | DMF0042_2_BizPlan.cs:336 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8d0f81fc | this.Load | DMF0042_2_BizPlan.cs:340 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-de9b2f8d | this.Load | DMF0042_2_BizPlan.cs:341 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0042_2_BizPlan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfc95dcf | DeleteButton | DMF0042_2_BizPlan.cs:524 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-037ebce4 | DeleteButton | DMF0042_2_BizPlan.cs:530 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-5659d3eb | DeleteButton | DMF0042_2_BizPlan.cs:531 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_2_BizPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1725e31e | Dispose | DMF0042_2_BizPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_2_BizPlan.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa5a6086 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:544 | if (this.fps != null) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3ef2aa8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:545 | if (this.fps != null) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bcc143f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:548 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-62a918ca | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:549 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1891df66 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:557 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c46b48c4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:563 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a37093e8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:566 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4a55f90 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:572 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-28bab801 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:575 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c6092b0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:589 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8dd75983 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:605 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan"))) ▸ for… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-858b04a0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:627 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan"))) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5cf005f3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_2_BizPlan.cs:633 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!IsEditMode) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_2_BizPlan.FindData

진입점: this.btnSetPrice.Click / this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ff489e | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:651 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ebd01976 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:660 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df8af250 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:661 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a849daa3 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:668 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd502ed1 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:669 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57b9e7ad | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:674 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00276") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8794f596 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:675 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(6) | 속성 Value2 설정 |  |  |  |
| AC-e7d2a0a0 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:676 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9148973e | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:681 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-532200d7 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:683 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3969de18 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:688 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-69cca7c1 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:691 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1b55f00e | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:698 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4abe1c04 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:702 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_DM_PLN_BUSINESS_PLAN_DATA") ⇒ DM.DMF0042_1_GET_DM_PLN_BUSINESS_PLAN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-18429f4b | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:704 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2098a377 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:706 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bde73a1e | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dc6b3ce1 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0bfacd83 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-251ac68f | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b4f175cf | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a4188efa | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-31530993 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-4bf23247 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:714 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-8805619e | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-a0ecbe66 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e63ad5fe | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-aa13baca | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:718 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7b4788a5 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:719 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bd703e99 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:720 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-e83f1b00 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:721 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-ce09ef60 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:723 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f01d194a | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:725 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-68f26025 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:730 | try | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5fa95309 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:731 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b3c6b68f | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:735 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | valid_YN | ds.Tables[1].Rows[0]["VALID_YN"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-483be7db | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:736 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYQQ | ds.Tables[1].Rows[0]["START_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8512db94 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:737 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYQQ | ds.Tables[1].Rows[0]["END_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b569af1 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:738 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYMM | ds.Tables[1].Rows[0]["START_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-143bdfb2 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:739 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYMM | ds.Tables[1].Rows[0]["END_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1eda5cbf | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:740 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYY | ds.Tables[1].Rows[0]["START_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4b63384b | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:741 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYY | ds.Tables[1].Rows[0]["END_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a18669b | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:744 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a296b3c4 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:755 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i != siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEASUR… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.AliceBlue | 그리드 속성/값 설정 |  |  |  |
| AC-2af98a4d | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:756 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i != siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEASUR… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.DarkBlue | 그리드 속성/값 설정 |  |  |  |
| AC-e9d18585 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:764 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-328d037f | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:768 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce23d321 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:772 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-287319c8 | this.btnSetPrice.Click 외 3 | DMF0042_2_BizPlan.cs:774 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0042_2_BizPlan.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-488be3ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_2_BizPlan.cs:3474 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-97557fa4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_2_BizPlan.cs:3477 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e86b702b | this.Load | DMF0042_2_BizPlan.cs:182 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a295f27 | this.Load | DMF0042_2_BizPlan.cs:183 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_2_BizPlan.GetBizTypebyDivision

진입점: this.Load [if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-137f7d63 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_2_BizPlan.cs:3144 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-0751ea08 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_2_BizPlan.cs:3145 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-28aa4e4f | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_2_BizPlan.cs:3146 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ddc8b0d8 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_2_BizPlan.cs:3148 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetCellColor

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (c <= siMain.GetMaxColumnIndex()-1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9918ae6c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_2_BizPlan.cs:3488 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95814158 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_2_BizPlan.cs:3301 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-269d68ed | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_2_BizPlan.cs:3302 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c6ececc | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_2_BizPlan.cs:3289 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-e2348ea3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_2_BizPlan.cs:3294 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetCellProdSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cead7559 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3532 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-b9593421 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3533 |  | DATA_OP | request.Parameters["CODE"] | "DM_CELL_PROD_SITE" | 행/컬럼 값 대입 |  |  |  |
| AC-23cb7f83 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3534 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f852711 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3535 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6cf6fcaf | (진입점 미연결) | DMF0042_2_BizPlan.cs:3536 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5dd42823 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3537 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c00a6b55 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3538 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ca9879de | (진입점 미연결) | DMF0042_2_BizPlan.cs:3539 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c742369 | (진입점 미연결) | DMF0042_2_BizPlan.cs:3541 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0324f0f5 | this.Load 외 1 | DMF0042_2_BizPlan.cs:3098 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-fbadab72 | this.Load 외 1 | DMF0042_2_BizPlan.cs:3099 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cb96154b | this.Load 외 1 | DMF0042_2_BizPlan.cs:3100 |  | DATA_OP | request.Parameters["p_month"] | remainMonths + 61 | 행/컬럼 값 대입 |  |  |  |
| AC-9ef56c39 | this.Load 외 1 | DMF0042_2_BizPlan.cs:3102 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a6bdde6 | this.Load 외 1 | DMF0042_2_BizPlan.cs:3105 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c61cd43b | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_2_BizPlan.cs:3239 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_EXCHANGE_PRICE") ⇒ DM.DMF0042_GET_EXCHANGE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-906b1245 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_2_BizPlan.cs:3240 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-58df7489 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_2_BizPlan.cs:3241 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-91de436c | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_2_BizPlan.cs:3242 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6de1a448 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_2_BizPlan.cs:3244 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetLookupData

진입점: this.Load / clbDivision.SelectedIndexChanged / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a60c08d6 | this.Load 외 2 | DMF0042_2_BizPlan.cs:3131 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-cc55b8b8 | this.Load 외 2 | DMF0042_2_BizPlan.cs:3132 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-ab0204b9 | this.Load 외 2 | DMF0042_2_BizPlan.cs:3133 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ed0d808 | this.Load 외 2 | DMF0042_2_BizPlan.cs:3135 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f9b63d6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3114 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_SPREAD_TITLE") ⇒ DM.DMF0042_1_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-bcad1c98 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3116 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-fc63a35d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3117 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-e300472e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3118 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cd77902f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3119 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1d7ab638 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3121 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-25f895e2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:3121 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0042_2_BizPlan.GetThisWeekMonday

진입점: this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17c7b398 | this.btnSetPrice.Click [try] 외 3 | DMF0042_2_BizPlan.cs:3265 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62233292 | this.Load | DMF0042_2_BizPlan.cs:205 |  | DATA_OP | this.ConditionNotUseList.Add | (cboClosed) | 데이터 객체 조작/조회 |  |  |  |
| AC-733cf33b | this.Load | DMF0042_2_BizPlan.cs:210 |  | DATA_OP | dtDivision.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-410f96fe | this.Load | DMF0042_2_BizPlan.cs:211 |  | DATA_OP | dtDivision.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e0e4476 | this.Load | DMF0042_2_BizPlan.cs:213 |  | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b7666901 | this.Load | DMF0042_2_BizPlan.cs:214 |  | DATA_OP | row1["CODE"] | "81" | 행/컬럼 값 대입 |  |  |  |
| AC-0052a9e1 | this.Load | DMF0042_2_BizPlan.cs:215 |  | DATA_OP | row1["NAME"] | "81 Automotive Battery" | 행/컬럼 값 대입 |  |  |  |
| AC-ada34057 | this.Load | DMF0042_2_BizPlan.cs:216 |  | DATA_OP | dtDivision.Rows.Add | (row1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1132c5ea | this.Load | DMF0042_2_BizPlan.cs:218 |  | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb91a809 | this.Load | DMF0042_2_BizPlan.cs:219 |  | DATA_OP | row2["CODE"] | "81_UC" | 행/컬럼 값 대입 |  |  |  |
| AC-45cdc2be | this.Load | DMF0042_2_BizPlan.cs:220 |  | DATA_OP | row2["NAME"] | "81_UC Automotive Battery(UC)" | 행/컬럼 값 대입 |  |  |  |
| AC-b893fae2 | this.Load | DMF0042_2_BizPlan.cs:221 |  | DATA_OP | dtDivision.Rows.Add | (row2) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bb3a13f | this.Load | DMF0042_2_BizPlan.cs:223 |  | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cbd21bea | this.Load | DMF0042_2_BizPlan.cs:224 |  | DATA_OP | row3["CODE"] | "81_HM" | 행/컬럼 값 대입 |  |  |  |
| AC-a2583396 | this.Load | DMF0042_2_BizPlan.cs:225 |  | DATA_OP | row3["NAME"] | "81_HM Automotive Battery(HM)" | 행/컬럼 값 대입 |  |  |  |
| AC-be76e061 | this.Load | DMF0042_2_BizPlan.cs:226 |  | DATA_OP | dtDivision.Rows.Add | (row3) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba5a01ae | this.Load | DMF0042_2_BizPlan.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a3a3d2cf | this.Load | DMF0042_2_BizPlan.cs:231 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a499f52 | this.Load | DMF0042_2_BizPlan.cs:231 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-517de0d8 | this.Load | DMF0042_2_BizPlan.cs:232 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e0506af1 | this.Load | DMF0042_2_BizPlan.cs:235 |  | LIST_REBIND | clsCtrl.setListBox | (dtYn, cboClosed, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-96b408d2 | this.Load | DMF0042_2_BizPlan.cs:245 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-7d4920fe | this.Load | DMF0042_2_BizPlan.cs:245 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c56ff781 | this.Load | DMF0042_2_BizPlan.cs:246 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-384294d9 | this.Load | DMF0042_2_BizPlan.cs:248 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-2f8f7491 | this.Load | DMF0042_2_BizPlan.cs:248 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc3eaefd | this.Load | DMF0042_2_BizPlan.cs:250 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d09c04e3 | this.Load | DMF0042_2_BizPlan.cs:251 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1ba6db4c | this.Load | DMF0042_2_BizPlan.cs:252 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e3e70e51 | this.Load | DMF0042_2_BizPlan.cs:253 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_1_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-4a6a5c08 | this.Load | DMF0042_2_BizPlan.cs:253 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_1_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-affc10a8 | this.Load | DMF0042_2_BizPlan.cs:257 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-a96fc583 | this.Load | DMF0042_2_BizPlan.cs:258 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-af3af17f | this.Load | DMF0042_2_BizPlan.cs:260 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7b36436b | this.Load | DMF0042_2_BizPlan.cs:260 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-742aea85 | this.Load | DMF0042_2_BizPlan.cs:262 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-349a80bc | this.Load | DMF0042_2_BizPlan.cs:263 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-50566659 | this.Load | DMF0042_2_BizPlan.cs:264 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ad3264fc | this.Load | DMF0042_2_BizPlan.cs:266 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_1_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-a1b5317e | this.Load | DMF0042_2_BizPlan.cs:266 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_1_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71ea4fe9 | this.Load | DMF0042_2_BizPlan.cs:271 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d478486 | this.Load | DMF0042_2_BizPlan.cs:272 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7a553c6d | this.Load | DMF0042_2_BizPlan.cs:274 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-76a92f67 | this.Load | DMF0042_2_BizPlan.cs:274 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9e5ba1e | this.Load | DMF0042_2_BizPlan.cs:276 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a8f8a527 | this.Load | DMF0042_2_BizPlan.cs:277 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2fd7d96c | this.Load | DMF0042_2_BizPlan.cs:278 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d4872ee | this.Load | DMF0042_2_BizPlan.cs:280 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_1_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-02e91720 | this.Load | DMF0042_2_BizPlan.cs:280 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_1_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e00f35f | this.Load | DMF0042_2_BizPlan.cs:284 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a11aaf6b | this.Load | DMF0042_2_BizPlan.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3ad8df6e | this.Load | DMF0042_2_BizPlan.cs:289 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9e96112 | this.Load | DMF0042_2_BizPlan.cs:289 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7647fec0 | this.Load | DMF0042_2_BizPlan.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a7105be3 | this.Load | DMF0042_2_BizPlan.cs:293 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-2dff9eed | this.Load | DMF0042_2_BizPlan.cs:293 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b61f875 | this.Load | DMF0042_2_BizPlan.cs:294 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20c76f6f | this.Load | DMF0042_2_BizPlan.cs:296 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-bd785325 | this.Load | DMF0042_2_BizPlan.cs:297 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16ad4585 | this.Load | DMF0042_2_BizPlan.cs:299 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-bf03862e | this.Load | DMF0042_2_BizPlan.cs:301 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-3998eead | this.Load | DMF0042_2_BizPlan.cs:302 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b32f389f | this.Load | DMF0042_2_BizPlan.cs:305 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2716eb4a | this.Load | DMF0042_2_BizPlan.cs:306 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-41f0ec97 | this.Load | DMF0042_2_BizPlan.cs:308 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-5131cccb | this.Load | DMF0042_2_BizPlan.cs:308 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-77d208e3 | this.Load | DMF0042_2_BizPlan.cs:310 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-78434943 | this.Load | DMF0042_2_BizPlan.cs:312 |  | UI_PROP | lblBucket1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b71266fe | this.Load | DMF0042_2_BizPlan.cs:313 |  | STATE | cboClosed.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0042_2_BizPlan.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8fa23a | this.Load 외 1 | DMF0042_2_BizPlan.cs:498 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-0cbb73d1 | this.Load 외 1 | DMF0042_2_BizPlan.cs:499 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f97be75f | this.Load 외 1 | DMF0042_2_BizPlan.cs:500 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa8cfe17 | this.Load 외 1 | DMF0042_2_BizPlan.cs:503 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-19cafc7c | this.Load 외 1 | DMF0042_2_BizPlan.cs:504 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_2_BizPlan.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a7b2032 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:366 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0042_2_BizPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adc5d0f1 | InsertButton | DMF0042_2_BizPlan.cs:1309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-1ac200b5 | InsertButton | DMF0042_2_BizPlan.cs:1311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasure.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d406f59 | InsertButton | DMF0042_2_BizPlan.cs:1328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6e1a3d4 | InsertButton | DMF0042_2_BizPlan.cs:1328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c1658e4d | InsertButton | DMF0042_2_BizPlan.cs:1332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-253441e9 | InsertButton | DMF0042_2_BizPlan.cs:1334 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8b32841c | InsertButton | DMF0042_2_BizPlan.cs:1336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3b9160f6 | InsertButton | DMF0042_2_BizPlan.cs:1342 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae34180f | InsertButton | DMF0042_2_BizPlan.cs:1344 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-01dd91ad | InsertButton | DMF0042_2_BizPlan.cs:1348 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_NAME_KO), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8ef3d3c1 | InsertButton | DMF0042_2_BizPlan.cs:1350 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cdd0b84c | InsertButton | DMF0042_2_BizPlan.cs:1352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aeca51f0 | InsertButton | DMF0042_2_BizPlan.cs:1354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ff915f36 | InsertButton | DMF0042_2_BizPlan.cs:1365 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-e7db537c | InsertButton | DMF0042_2_BizPlan.cs:1366 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4805d76 | InsertButton | DMF0042_2_BizPlan.cs:1373 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3f60ed4 | InsertButton | DMF0042_2_BizPlan.cs:1462 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee1e8142 | InsertButton | DMF0042_2_BizPlan.cs:1466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-7ebb308d | InsertButton | DMF0042_2_BizPlan.cs:1467 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-75c3b711 | InsertButton | DMF0042_2_BizPlan.cs:1472 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex()… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0177855 | InsertButton | DMF0042_2_BizPlan.cs:1482 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fb788bc4 | InsertButton | DMF0042_2_BizPlan.cs:1488 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3bca3ae8 | InsertButton | DMF0042_2_BizPlan.cs:1493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14b7155d | InsertButton | DMF0042_2_BizPlan.cs:1500 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e9a9ebc | InsertButton | DMF0042_2_BizPlan.cs:1505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bad2cecc | InsertButton | DMF0042_2_BizPlan.cs:1518 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-23a46124 | InsertButton | DMF0042_2_BizPlan.cs:1525 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_2_BizPlan.MinColumnChk

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34c9c7eb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_2_BizPlan.cs:3518 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dcb1ea96 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_2_BizPlan.cs:3522 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.ParameterString

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (c <= siMain.GetMaxColumnIndex()-1) ▸ if (action != "I" && action2 != "I") ▸ if (i != iLOCRow) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2d64d55 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_2_BizPlan.cs:3336 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0042_2_BizPlan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4686424c | SaveButton | DMF0042_2_BizPlan.cs:788 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-749fc079 | SaveButton | DMF0042_2_BizPlan.cs:789 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3902580d | SaveButton | DMF0042_2_BizPlan.cs:912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f26f27e | SaveButton | DMF0042_2_BizPlan.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3887d0e0 | SaveButton | DMF0042_2_BizPlan.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b2064a8 | SaveButton | DMF0042_2_BizPlan.cs:1072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0376509f | SaveButton | DMF0042_2_BizPlan.cs:1219 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e27f2ec2 | SaveButton | DMF0042_2_BizPlan.cs:1220 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5fc781a | SaveButton | DMF0042_2_BizPlan.cs:1225 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb1f710e | SaveButton | DMF0042_2_BizPlan.cs:1226 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fba0bbf9 | SaveButton | DMF0042_2_BizPlan.cs:1233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_SAVE_DM_PLN_BP_FCST") ⇒ DM.DMF0042_1_SAVE_DM_PLN_BP_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-5b750a85 | SaveButton | DMF0042_2_BizPlan.cs:1234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag" ] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4cc6e4bd | SaveButton | DMF0042_2_BizPlan.cs:1234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-18246adc | SaveButton | DMF0042_2_BizPlan.cs:1235 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | pDIVISION_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-d0034254 | SaveButton | DMF0042_2_BizPlan.cs:1235 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDIVISION_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-801768a2 | SaveButton | DMF0042_2_BizPlan.cs:1236 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (pDEPT_ID != "") | DATA_OP | request.Parameters["p_DEPT_ID"] | pDEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-98e058ad | SaveButton | DMF0042_2_BizPlan.cs:1236 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (pDEPT_ID != "") | DATA_OP | pDEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b95a461 | SaveButton | DMF0042_2_BizPlan.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DEPT_NAME_KO" ] | pDEPT_NAME_KO.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-9e7ca29f | SaveButton | DMF0042_2_BizPlan.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDEPT_NAME_KO.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5282cca8 | SaveButton | DMF0042_2_BizPlan.cs:1238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID" ] | pSCM_SITE_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-e384fcfe | SaveButton | DMF0042_2_BizPlan.cs:1238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pSCM_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-89593578 | SaveButton | DMF0042_2_BizPlan.cs:1239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CUSTOMER_CODE" ] | pCUSTOMER_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-af21bd13 | SaveButton | DMF0042_2_BizPlan.cs:1239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCUSTOMER_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b68b648 | SaveButton | DMF0042_2_BizPlan.cs:1240 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_END_CUSTOMER" ] | pEND_CUSTOMER.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b3cb5656 | SaveButton | DMF0042_2_BizPlan.cs:1240 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pEND_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5220dd1 | SaveButton | DMF0042_2_BizPlan.cs:1241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_END_CUSTOMER_NAME" ] | pEND_CUSTOMER_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7eea07d1 | SaveButton | DMF0042_2_BizPlan.cs:1241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pEND_CUSTOMER_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a123f473 | SaveButton | DMF0042_2_BizPlan.cs:1242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SOLDTO_CODE" ] | pSOLDTO_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-48ec3542 | SaveButton | DMF0042_2_BizPlan.cs:1242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pSOLDTO_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-74bf67e5 | SaveButton | DMF0042_2_BizPlan.cs:1243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SOLDTO_NAME" ] | pSOLDTO_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-26f97859 | SaveButton | DMF0042_2_BizPlan.cs:1243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pSOLDTO_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3eee4e4 | SaveButton | DMF0042_2_BizPlan.cs:1244 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SHIPTO_CODE" ] | pSHIPTO_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-45c99353 | SaveButton | DMF0042_2_BizPlan.cs:1244 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pSHIPTO_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-53ede815 | SaveButton | DMF0042_2_BizPlan.cs:1245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SHIPTO_NAME" ] | pSHIPTO_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a66769b2 | SaveButton | DMF0042_2_BizPlan.cs:1245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pSHIPTO_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f03bcd28 | SaveButton | DMF0042_2_BizPlan.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CITY" ] | pCITY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-088c7705 | SaveButton | DMF0042_2_BizPlan.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCITY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-25da31d8 | SaveButton | DMF0042_2_BizPlan.cs:1247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_COUNTRY" ] | pCOUNTRY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-57c61a97 | SaveButton | DMF0042_2_BizPlan.cs:1247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCOUNTRY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a9d5177 | SaveButton | DMF0042_2_BizPlan.cs:1248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE" ] | pPROJECT_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-65786c28 | SaveButton | DMF0042_2_BizPlan.cs:1248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPROJECT_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-91302bc0 | SaveButton | DMF0042_2_BizPlan.cs:1249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_NAME" ] | pPROJECT_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-aac243ac | SaveButton | DMF0042_2_BizPlan.cs:1249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPROJECT_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-40f91ad2 | SaveButton | DMF0042_2_BizPlan.cs:1250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_BIZ_TYPE" ] | pBIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-36bfbdd5 | SaveButton | DMF0042_2_BizPlan.cs:1250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pBIZ_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfbfc216 | SaveButton | DMF0042_2_BizPlan.cs:1251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_BIZ_TYPE_NAME" ] | pBIZ_TYPE_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2447108e | SaveButton | DMF0042_2_BizPlan.cs:1251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pBIZ_TYPE_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae0ebf6d | SaveButton | DMF0042_2_BizPlan.cs:1252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID" ] | pITEM_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-9674a768 | SaveButton | DMF0042_2_BizPlan.cs:1252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pITEM_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-92f0ab28 | SaveButton | DMF0042_2_BizPlan.cs:1253 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_NICK_NAME" ] | pITEM_NICK_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-bc48b08f | SaveButton | DMF0042_2_BizPlan.cs:1253 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pITEM_NICK_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-96480c23 | SaveButton | DMF0042_2_BizPlan.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_TYPE" ] | pITEM_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f41abfe7 | SaveButton | DMF0042_2_BizPlan.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pITEM_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa9df569 | SaveButton | DMF0042_2_BizPlan.cs:1255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_CODE" ] | pCELL_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-94d8a958 | SaveButton | DMF0042_2_BizPlan.cs:1255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCELL_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9612f95c | SaveButton | DMF0042_2_BizPlan.cs:1256 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_NICK_NAME" ] | pCELL_NICK_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-fdb43be3 | SaveButton | DMF0042_2_BizPlan.cs:1256 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCELL_NICK_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-19fec42f | SaveButton | DMF0042_2_BizPlan.cs:1257 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_CAPA" ] | pCELL_CAPA.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-1ba86507 | SaveButton | DMF0042_2_BizPlan.cs:1257 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCELL_CAPA.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f879b4c | SaveButton | DMF0042_2_BizPlan.cs:1258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PER_MODULE" ] | pCELL_PER_MODULE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-97764987 | SaveButton | DMF0042_2_BizPlan.cs:1258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCELL_PER_MODULE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6cd04f2 | SaveButton | DMF0042_2_BizPlan.cs:1259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MODULE_PER_PACK" ] | pMODULE_PER_PACK.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-77e95122 | SaveButton | DMF0042_2_BizPlan.cs:1259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pMODULE_PER_PACK.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-96082373 | SaveButton | DMF0042_2_BizPlan.cs:1260 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PER_PACK" ] | pCELL_PER_PACK.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-eace3038 | SaveButton | DMF0042_2_BizPlan.cs:1260 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCELL_PER_PACK.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d233259f | SaveButton | DMF0042_2_BizPlan.cs:1261 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PRODUCT_GROUP" ] | pPRODUCT_GROUP.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-72ca1a4d | SaveButton | DMF0042_2_BizPlan.cs:1261 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPRODUCT_GROUP.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a152c18 | SaveButton | DMF0042_2_BizPlan.cs:1262 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PRODUCT_GROUP_NAME"] | pPRODUCT_GROUP_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-444e33fd | SaveButton | DMF0042_2_BizPlan.cs:1262 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPRODUCT_GROUP_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd03d2f | SaveButton | DMF0042_2_BizPlan.cs:1263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_COMPANY_NAME" ] | pCOMPANY_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-93b4d406 | SaveButton | DMF0042_2_BizPlan.cs:1263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCOMPANY_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8e11c89 | SaveButton | DMF0042_2_BizPlan.cs:1264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ALT_SIM_YN" ] | pALT_SIM_YN.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ed709964 | SaveButton | DMF0042_2_BizPlan.cs:1264 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pALT_SIM_YN.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4c5e24c | SaveButton | DMF0042_2_BizPlan.cs:1265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_P_BOM" ] | pP_BOM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-22fa5760 | SaveButton | DMF0042_2_BizPlan.cs:1265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pP_BOM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e5fdb65 | SaveButton | DMF0042_2_BizPlan.cs:1266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY" ] | pCURRENCY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ce906ae3 | SaveButton | DMF0042_2_BizPlan.cs:1266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCURRENCY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-174ed0ef | SaveButton | DMF0042_2_BizPlan.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_EE_CORP_ID" ] | pEE_CORP_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f5f890f8 | SaveButton | DMF0042_2_BizPlan.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pEE_CORP_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cddb8c63 | SaveButton | DMF0042_2_BizPlan.cs:1268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_CORP_ID" ] | pCELL_CORP_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-69625106 | SaveButton | DMF0042_2_BizPlan.cs:1268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCELL_CORP_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-98b64936 | SaveButton | DMF0042_2_BizPlan.cs:1269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PACK_CORP_ID" ] | pPACK_CORP_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-975cee82 | SaveButton | DMF0042_2_BizPlan.cs:1269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPACK_CORP_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a62b90ed | SaveButton | DMF0042_2_BizPlan.cs:1270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_EXT_INT" ] | pEXT_INT.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2dbc2d56 | SaveButton | DMF0042_2_BizPlan.cs:1270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pEXT_INT.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6773c351 | SaveButton | DMF0042_2_BizPlan.cs:1272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | pPLANT_SITE_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-fa7acfe2 | SaveButton | DMF0042_2_BizPlan.cs:1272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPLANT_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d5b4958 | SaveButton | DMF0042_2_BizPlan.cs:1273 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | pFCST_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-98676503 | SaveButton | DMF0042_2_BizPlan.cs:1273 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pFCST_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3f77144 | SaveButton | DMF0042_2_BizPlan.cs:1274 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DOM_EXP"] | pDOM_EXP.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-d023efef | SaveButton | DMF0042_2_BizPlan.cs:1274 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDOM_EXP.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-36fb8d0d | SaveButton | DMF0042_2_BizPlan.cs:1275 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | pINCOTERMS.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-eeee8491 | SaveButton | DMF0042_2_BizPlan.cs:1275 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pINCOTERMS.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c7c8ec8 | SaveButton | DMF0042_2_BizPlan.cs:1279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE" ] | pMEASURE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f8f69047 | SaveButton | DMF0042_2_BizPlan.cs:1279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pMEASURE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce745d1f | SaveButton | DMF0042_2_BizPlan.cs:1280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM" ] | pYYYYMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7e15e8b4 | SaveButton | DMF0042_2_BizPlan.cs:1280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pYYYYMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-57cb7906 | SaveButton | DMF0042_2_BizPlan.cs:1281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY" ] | pInput.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-10e310e8 | SaveButton | DMF0042_2_BizPlan.cs:1281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pInput.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c93ec529 | SaveButton | DMF0042_2_BizPlan.cs:1282 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY" ] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3c4df14f | SaveButton | DMF0042_2_BizPlan.cs:1282 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d2904a4 | SaveButton | DMF0042_2_BizPlan.cs:1283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY" ] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-cf4afb4b | SaveButton | DMF0042_2_BizPlan.cs:1283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9712a7d | SaveButton | DMF0042_2_BizPlan.cs:1285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52645fc3 | SaveButton | DMF0042_2_BizPlan.cs:1290 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-538ba81a | SaveButton | DMF0042_2_BizPlan.cs:1291 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa43d5ea | SaveButton | DMF0042_2_BizPlan.cs:1295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_2_BizPlan.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt == iCheck)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-455ac0da | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_2_BizPlan.cs:3497 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0042_2_BizPlan.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivisio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b38dd2f0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:467 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9cf6a17a | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:469 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Q… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-711889f3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:471 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ceedb730 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:480 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-97100b11 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:482 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-17932ed5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:484 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0bc24c45 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:489 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-520a3268 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_2_BizPlan.cs:491 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0042_2_BizPlan.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c466e996 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:399 | foreach (DataRow dr in dt.Rows) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 5, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e753fe9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:453 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-068b0b01 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_2_BizPlan.cs:455 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_2_BizPlan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c34faf2a | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1756 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString(… | POPUP | popup.Form_Load | (sDIVISION_ID, sPROJECT_CODE, sSCM_SITE_ID, sITEM_ID, sINCOTERMS) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d7d4a4b9 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1757 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString(… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-258b4651 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1758 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString(… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-945f74bb | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1769 | if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Q_… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-8074eec4 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1775 | if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-3dd06522 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1791 | else of (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ for (iCol <= siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-fe780966 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1805 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fd0e0c9 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1827 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-d9ea4956 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1829 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a0cd269d | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1830 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c1a8ad7 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1831 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6a7dd2aa | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1838 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (sItemId == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c1c82d7 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1843 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_BIZPLAN_INFO") ⇒ DM.DMF0042_1_GET_BIZPLAN_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-ed8e8ae3 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1844 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_ref_type"] | "SSPM" | 행/컬럼 값 대입 |  |  |  |
| AC-eb669390 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1845 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-139dbb48 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1846 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_project_code"] | sProject | 행/컬럼 값 대입 |  |  |  |
| AC-fa3ebdbe | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1847 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-11b02671 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1848 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-5cc0e4d1 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1849 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_currency"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f388dd8 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1851 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c84b1be3 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1853 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa0ed496 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1854 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f84173d9 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1855 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eeeaf627 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1856 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec6301de | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1857 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20b0da80 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1858 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be55a50b | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1864 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.COMPANY_NAME) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sSaleCompany) | 그리드 값 설정 |  |  |  |
| AC-6c729f77 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1866 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_NICK_NAME) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sCellName) | 그리드 값 설정 |  |  |  |
| AC-b3912821 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1868 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_CAPA) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sKWH) | 그리드 값 설정 |  |  |  |
| AC-5ab80550 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1870 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_PER_PACK) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sCellPerPack) | 그리드 값 설정 |  |  |  |
| AC-df0115fa | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1872 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sCellPerModule) | 그리드 값 설정 |  |  |  |
| AC-58161003 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1874 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.MODULE_PER_PACK) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sModulePerPack) | 그리드 값 설정 |  |  |  |
| AC-8f0e8780 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1879 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_BIZPLAN_INFO") ⇒ DM.DMF0042_1_GET_BIZPLAN_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-ab3c3065 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1880 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_ref_type"] | "PRODUCT_CORP" | 행/컬럼 값 대입 |  |  |  |
| AC-2fce3477 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1881 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c5df3091 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1882 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_project_code"] | sProject | 행/컬럼 값 대입 |  |  |  |
| AC-10b14549 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1883 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-1459f463 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1884 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f881bbf3 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1885 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | DATA_OP | request.Parameters["p_currency"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df04aaa1 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1888 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d60d1243 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1896 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (dt.Rows.Count > 0) ▸ if (dt.Rows[0][0].ToString() == "Y") ▸ if (siMain.Ge… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PACK_CORP_ID), sEECorp) | 그리드 값 설정 |  |  |  |
| AC-b02ec68b | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1902 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (dt.Rows.Count > 0) ▸ else of (dt.Rows[0][0].ToString() == "Y") ▸ if (dt.R… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_CORP_ID), sCellCorp) | 그리드 값 설정 |  |  |  |
| AC-a190b7db | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1908 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (dt.Rows.Count > 0) ▸ else of (dt.Rows[0][0].ToString() == "Y") ▸ else of … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.EE_CORP_ID), sEECorp) | 그리드 값 설정 |  |  |  |
| AC-96e5562d | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1919 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.COMPANY_NAME) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sSaleCompany) | 그리드 값 설정 |  |  |  |
| AC-059ea580 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1921 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_NICK_NAME) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_NICK_NAME), sCellName) | 그리드 값 설정 |  |  |  |
| AC-74a518f9 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1923 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_CAPA) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_CAPA), sKWH) | 그리드 값 설정 |  |  |  |
| AC-e63cf653 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1925 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_PER_PACK) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_PACK), sCellPerPack) | 그리드 값 설정 |  |  |  |
| AC-44ee8900 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1927 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), sCellPerModule) | 그리드 값 설정 |  |  |  |
| AC-7f456de4 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1929 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (siMain.GetColumnIndex(DefColumns.MODULE_PER_PACK) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_PACK), sModulePerPack) | 그리드 값 설정 |  |  |  |
| AC-4300c155 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1934 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (sItemId != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-e5403b77 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1937 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (sItemId != "") ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-0ecc8c45 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1939 | if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))) ▸ if (sItemId != "") ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_NICK_NAME) > 0… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NICK_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-263313fb | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1972 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-606fc6c7 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1974 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6f80e127 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1975 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e786ed77 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1976 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7fbafaec | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1984 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sDivision == null \|\| sProject == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04be5a5c | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1988 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_BIZPLAN_INFO") ⇒ DM.DMF0042_1_GET_BIZPLAN_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-a3c31193 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1989 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | request.Parameters["p_ref_type"] | "PROJECT" | 행/컬럼 값 대입 |  |  |  |
| AC-cfc444b5 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1990 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-54395d36 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1991 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | request.Parameters["p_project_code"] | sProject | 행/컬럼 값 대입 |  |  |  |
| AC-2cc06151 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1992 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | request.Parameters["p_scm_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-215aea01 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1993 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebae7cb4 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1994 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | request.Parameters["p_currency"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2aaae35c | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1996 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d98d9151 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1997 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35d588bb | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:1998 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-126c176c | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2001 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | DATA_OP | sBizTypeName.Contains | ("Cell") | 데이터 객체 조작/조회 |  |  |  |
| AC-15033fbc | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2005 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (sBizTypeName.Contains("Cell") == true) | DATA_OP | popProject.BizTypeName.Contains | ("Module") | 데이터 객체 조작/조회 |  |  |  |
| AC-9291b06b | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2009 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (sBizTypeName.Contains("Cell") == true) ▸ else of (popProject.BizT… | DATA_OP | popProject.BizTypeName.Contains | ("Pack") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab05b750 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2016 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-bc8457d5 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2019 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-b5cc70fa | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2021 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE), sBizType) | 그리드 값 설정 |  |  |  |
| AC-5f1edd46 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2023 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME) … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME), sBizTypeName) | 그리드 값 설정 |  |  |  |
| AC-25856caf | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2025 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_UNIT) > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_UNIT), sBizUnit) | 그리드 값 설정 |  |  |  |
| AC-c030935d | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2027 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP) … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), sProductGroupCode) | 그리드 값 설정 |  |  |  |
| AC-d3404fd7 | this.spdMain.CellDoubleClick | DMF0042_2_BizPlan.cs:2029 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_N… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), sProductGroupName) | 그리드 값 설정 |  |  |  |

## DMF0042_2_BizPlan.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee7e1395 | dsdm.Changed | DMF0042_2_BizPlan.cs:2038 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dd94993 | dsdm.Changed | DMF0042_2_BizPlan.cs:2041 | if (e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17de7df4 | dsdm.Changed | DMF0042_2_BizPlan.cs:2042 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3177f277 | dsdm.Changed | DMF0042_2_BizPlan.cs:2046 | if (siMain.GetValue(e.Row, e.Column).ToString() == "") | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-e988d394 | dsdm.Changed | DMF0042_2_BizPlan.cs:2073 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74c3a767 | dsdm.Changed | DMF0042_2_BizPlan.cs:2100 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0fc1fcd5 | dsdm.Changed | DMF0042_2_BizPlan.cs:2102 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba110ec6 | dsdm.Changed | DMF0042_2_BizPlan.cs:2108 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-44e7af50 | dsdm.Changed | DMF0042_2_BizPlan.cs:2128 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9690d58 | dsdm.Changed | DMF0042_2_BizPlan.cs:2135 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-91d796a4 | dsdm.Changed | DMF0042_2_BizPlan.cs:2149 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afbef316 | dsdm.Changed | DMF0042_2_BizPlan.cs:2190 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (iQuarterlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b322ca27 | dsdm.Changed | DMF0042_2_BizPlan.cs:2215 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b9e8d11d | dsdm.Changed | DMF0042_2_BizPlan.cs:2221 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-00878bad | dsdm.Changed | DMF0042_2_BizPlan.cs:2235 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-0ca999b7 | dsdm.Changed | DMF0042_2_BizPlan.cs:2241 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-f4f5e055 | dsdm.Changed | DMF0042_2_BizPlan.cs:2262 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-96a95535 | dsdm.Changed | DMF0042_2_BizPlan.cs:2290 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f812272 | dsdm.Changed | DMF0042_2_BizPlan.cs:2298 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9540ae08 | dsdm.Changed | DMF0042_2_BizPlan.cs:2316 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (Convert.ToDecimal(siMain.GetValue(e.Row, e.Column))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d104726 | dsdm.Changed | DMF0042_2_BizPlan.cs:2325 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13b60289 | dsdm.Changed | DMF0042_2_BizPlan.cs:2325 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DateTime.Today.DayOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b172864 | dsdm.Changed | DMF0042_2_BizPlan.cs:2383 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-54005d7b | dsdm.Changed | DMF0042_2_BizPlan.cs:2389 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-09f5ccca | dsdm.Changed | DMF0042_2_BizPlan.cs:2405 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-fa998fb0 | dsdm.Changed | DMF0042_2_BizPlan.cs:2411 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-dc3d3a9d | dsdm.Changed | DMF0042_2_BizPlan.cs:2433 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-cab126cd | dsdm.Changed | DMF0042_2_BizPlan.cs:2468 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-42d78505 | dsdm.Changed | DMF0042_2_BizPlan.cs:2473 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-00f1fd13 | dsdm.Changed | DMF0042_2_BizPlan.cs:2495 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a633aa9b | dsdm.Changed | DMF0042_2_BizPlan.cs:2502 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, iQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |
| AC-8832b20b | dsdm.Changed | DMF0042_2_BizPlan.cs:2540 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-134df482 | dsdm.Changed | DMF0042_2_BizPlan.cs:2567 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-0d5ebf9f | dsdm.Changed | DMF0042_2_BizPlan.cs:2647 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-fb311f17 | dsdm.Changed | DMF0042_2_BizPlan.cs:2653 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-aa1869c7 | dsdm.Changed | DMF0042_2_BizPlan.cs:2667 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-82bd45a4 | dsdm.Changed | DMF0042_2_BizPlan.cs:2673 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-8f3436eb | dsdm.Changed | DMF0042_2_BizPlan.cs:2694 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-23c2ce40 | dsdm.Changed | DMF0042_2_BizPlan.cs:2730 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-87016885 | dsdm.Changed | DMF0042_2_BizPlan.cs:2815 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-38884415 | dsdm.Changed | DMF0042_2_BizPlan.cs:2821 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-293ae4b8 | dsdm.Changed | DMF0042_2_BizPlan.cs:2837 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-6e0d6b79 | dsdm.Changed | DMF0042_2_BizPlan.cs:2843 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-2cda1065 | dsdm.Changed | DMF0042_2_BizPlan.cs:2865 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-6dd705ed | dsdm.Changed | DMF0042_2_BizPlan.cs:2900 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-44764542 | dsdm.Changed | DMF0042_2_BizPlan.cs:2905 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-1425863e | dsdm.Changed | DMF0042_2_BizPlan.cs:2934 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0042_2_BizPlan.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3a41f46 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1686 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (sDivision == "81") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-479af753 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1687 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (sDivision == "81") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c1cc9157 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1697 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a796e9cc | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1698 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e242401c | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1705 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_1_GET_BIZPLAN_INFO") ⇒ DM.DMF0042_1_GET_BIZPLAN_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-34219190 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1706 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | DATA_OP | request.Parameters["p_ref_type" ] | "SITE" | 행/컬럼 값 대입 |  |  |  |
| AC-b1307185 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1707 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | DATA_OP | request.Parameters["p_division_id" ] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e42affd1 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1708 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | DATA_OP | request.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e67630e | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1709 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | DATA_OP | request.Parameters["p_scm_site_id" ] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-af02a443 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1710 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | DATA_OP | request.Parameters["p_item_id" ] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b1b1b890 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1711 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | DATA_OP | request.Parameters["p_currency" ] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c87edec4 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1713 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77929273 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1714 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-982d7189 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1715 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36ecff4b | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1715 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f923a56 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1716 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4f1f4c0 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1717 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2eab8506 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1718 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e9b6561 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1719 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7f958d2 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1724 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COUNTRY), sCountry) | 그리드 값 설정 |  |  |  |
| AC-8a2545f3 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1726 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CITY), sCity) | 그리드 값 설정 |  |  |  |
| AC-48444f83 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1728 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), sSoldtoCode) | 그리드 값 설정 |  |  |  |
| AC-d9db10c8 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1730 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_NAME), sSoldtoName) | 그리드 값 설정 |  |  |  |
| AC-57adcc55 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1732 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), sShiptoCode) | 그리드 값 설정 |  |  |  |
| AC-bebf1819 | this.spdMain.ComboSelChange | DMF0042_2_BizPlan.cs:1734 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ if (… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_NAME), sShiptoName) | 그리드 값 설정 |  |  |  |

## DMF0042_2_BizPlan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49652419 | this.spdMain.EditChange | DMF0042_2_BizPlan.cs:3201 | if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30a60e84 | this.spdMain.EditChange | DMF0042_2_BizPlan.cs:3203 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_2_BizPlan.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-683e9a87 | this.spdMain.TopChange | DMF0042_2_BizPlan.cs:2960 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_2_BizPlan.ValidationCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c81b9be | (진입점 미연결) | DMF0042_2_BizPlan.cs:2949 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d709f1e4 | (진입점 미연결) | DMF0042_2_BizPlan.cs:2952 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-ecde7265 | (진입점 미연결) | DMF0042_2_BizPlan.cs:2954 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_3_BizPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4641cd90 | this.btnColumn.Click | DMF0042_3_BizPlan.cs:2873 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042_3", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-7dce8060 | this.btnColumn.Click | DMF0042_3_BizPlan.cs:2874 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3b51bf0c | this.btnColumn.Click | DMF0042_3_BizPlan.cs:2875 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_3_BizPlan.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a813010f | this.btnCutOff.Click | DMF0042_3_BizPlan.cs:2908 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-dcd7d474 | this.btnCutOff.Click | DMF0042_3_BizPlan.cs:2909 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4ca80da | this.btnCutOff.Click | DMF0042_3_BizPlan.cs:2916 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-b799ea4f | this.btnCutOff.Click | DMF0042_3_BizPlan.cs:2921 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea984241 | this.btnCutOff.Click | DMF0042_3_BizPlan.cs:2923 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-599767f6 | this.btnCutOff.Click | DMF0042_3_BizPlan.cs:2924 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_3_BizPlan.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2953acb | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3103 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d80ae416 | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3104 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bf87ef3 | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3107 |  | POPUP | new POPUP.DMF0042_ExchangeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-e75b487b | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3108 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP", clbDivisi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9ded94e | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3110 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc63bcd9 | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3111 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5b683c48 | this.btnExchangeRate.Click | DMF0042_3_BizPlan.cs:3115 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_3_BizPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09172c0e | this.btnItemId.Click | DMF0042_3_BizPlan.cs:2857 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3da73b6e | this.btnItemId.Click | DMF0042_3_BizPlan.cs:2859 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cb44ab17 | this.btnItemId.Click | DMF0042_3_BizPlan.cs:2860 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18d4d4cb | this.btnItemId.Click | DMF0042_3_BizPlan.cs:2861 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e90f32e9 | this.btnItemId.Click | DMF0042_3_BizPlan.cs:2867 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0042_3_BizPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-070a75e5 | this.btnMeasure.Click | DMF0042_3_BizPlan.cs:2885 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042_3", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-a33c9f95 | this.btnMeasure.Click | DMF0042_3_BizPlan.cs:2887 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc4fff9d | this.btnMeasure.Click | DMF0042_3_BizPlan.cs:2888 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_3_BizPlan.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4546228 | this.btnOwner.Click | DMF0042_3_BizPlan.cs:3067 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b2f291ac | this.btnOwner.Click | DMF0042_3_BizPlan.cs:3070 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-81a48f56 | this.btnOwner.Click | DMF0042_3_BizPlan.cs:3071 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d0a8121f | this.btnOwner.Click | DMF0042_3_BizPlan.cs:3072 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1df67fd0 | this.btnOwner.Click | DMF0042_3_BizPlan.cs:3074 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0042_3_BizPlan.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-714f1da8 | this.btnProject.Click 외 1 | DMF0042_3_BizPlan.cs:2835 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-b89f7099 | this.btnProject.Click 외 1 | DMF0042_3_BizPlan.cs:2836 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-39842992 | this.btnProject.Click 외 1 | DMF0042_3_BizPlan.cs:2837 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc605af4 | this.btnProject.Click 외 1 | DMF0042_3_BizPlan.cs:2838 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-79b08dee | this.btnProject.Click 외 1 | DMF0042_3_BizPlan.cs:2844 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0042_3_BizPlan.btnReplace_Click

진입점: this.btnReplace.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a32f29 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3501 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-6b262391 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3502 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6176dc0f | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3509 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-749ed9f4 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3510 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8c13940 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3515 |  | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5605a94 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3519 |  | DATA_OP | dt.Columns.Add | ("YYYYMM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-222365d1 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3523 | if (spdMain.Sheets[0].RowCount == 0) | MESSAGE | MessageBox.Show | ("데이터 조회 후 다시 시도해 주시기 바랍니다.") | 메시지 표시 |  |  |  |
| AC-7c04562a | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3524 | if (spdMain.Sheets[0].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ad84de0 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3543 | else of (cr == null) ▸ for (i <= ColEnd) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f8a09957 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3547 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | row["YYYYMM"] | colTag.Substring(2, 6).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87293081 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3548 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-681551ef | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3576 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-882e74da | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3580 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eff5ddf1 | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3582 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b8fd5eae | this.btnReplace.Click | DMF0042_3_BizPlan.cs:3583 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_3_BizPlan.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39fef0ed | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3231 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00282") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8c17bc2 | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3232 | if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0c677df | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3238 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | 엔드포인트 요청 생성 |  |  |  |
| AC-de29d839 | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3240 |  | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9c465494 | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3242 |  | DATA_OP | request.Parameters["s_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c69d456 | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3243 |  | DATA_OP | request.Parameters["s_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6ab1a8d1 | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3244 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-070b9bd5 | this.btnSetPrice.Click | DMF0042_3_BizPlan.cs:3247 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_3_BizPlan.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59de20c | this.cboBucketType.Click | DMF0042_3_BizPlan.cs:3083 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43be11ec | this.cboBucketType.Click | DMF0042_3_BizPlan.cs:3084 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6173dab4 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1494 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-8403827f | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1494 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-559f238c | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1495 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f1a250e2 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1503 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-fd1e42ff | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1503 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d9c8e22 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1504 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5fd330b4 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1506 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a32b52f8 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1506 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c081d57 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1508 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-db089b3a | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1509 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-051fc755 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1510 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-84b6941d | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1511 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-4baaa52c | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1515 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-d95dcada | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1516 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a2387a88 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1518 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9c82882 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1518 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d9d5f11 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1520 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-81630f1d | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1521 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cbede86e | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1522 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2b7ce2a8 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1524 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-4330df25 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1528 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9b8377f | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1529 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-37e525cd | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1531 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e09d18d9 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1531 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1baa4e09 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1533 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6be76012 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1534 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cc995656 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1535 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-93561980 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1537 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-425ad639 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1541 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-451cff79 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1543 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-de3f47f2 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1546 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d982f4e3 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1546 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8bb0ebb | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1547 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3f7f034e | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1549 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-9ac4c74d | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1549 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-14688d29 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1550 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-61eed4b0 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1552 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-5beeddc9 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1553 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7a0cc1d6 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1555 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-92c2bf63 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1557 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-4934bfa8 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1558 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7434a4e6 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1561 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ac88d91 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1562 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-96eaf1e5 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1564 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-358a1ae9 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1564 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dac92f74 | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1566 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7930f7bc | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1568 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3453f49c | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1569 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-189f17ee | clbDivision.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1570 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0042_3_BizPlan.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-344a28b3 | this.clbCustomer.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1604 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1975157d | this.clbCustomer.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1604 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-533859c3 | this.clbCustomer.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1608 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-96bb080b | this.clbCustomer.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1608 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c237049 | this.clbCustomer.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1610 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_3_BizPlan.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05eb7619 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1582 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1ec26bc8 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1582 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f1e8697 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1583 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f66c43a8 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1585 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f75b7de | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1585 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43c894ec | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1589 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-9e478f43 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1589 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-27a7bc3b | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1590 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f347b12 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1592 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-54937d99 | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1592 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ace8a48b | this.clbTeam.SelectedIndexChanged | DMF0042_3_BizPlan.cs:1596 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_3_BizPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57985b3f | this.Load | DMF0042_3_BizPlan.cs:389 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-220874e1 | this.Load | DMF0042_3_BizPlan.cs:390 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b0517dd | this.Load | DMF0042_3_BizPlan.cs:391 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_3_BizPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd5fb072 | this.Load | DMF0042_3_BizPlan.cs:352 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-0a466169 | this.Load | DMF0042_3_BizPlan.cs:354 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-4120d4de | this.Load | DMF0042_3_BizPlan.cs:356 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e1aaf2f7 | this.Load | DMF0042_3_BizPlan.cs:357 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-35d35b57 | this.Load | DMF0042_3_BizPlan.cs:358 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-90eb807b | this.Load | DMF0042_3_BizPlan.cs:359 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-9359a4b0 | this.Load | DMF0042_3_BizPlan.cs:369 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e37d308 | this.Load | DMF0042_3_BizPlan.cs:370 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-d7cf4b94 | this.Load | DMF0042_3_BizPlan.cs:374 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ccc77d5a | this.Load | DMF0042_3_BizPlan.cs:375 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0042_3_BizPlan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03c1e708 | DeleteButton | DMF0042_3_BizPlan.cs:554 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa61e053 | DeleteButton | DMF0042_3_BizPlan.cs:560 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-53b651e6 | DeleteButton | DMF0042_3_BizPlan.cs:561 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_3_BizPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d9a0470 | Dispose | DMF0042_3_BizPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_3_BizPlan.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba231ec9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:574 | if (this.fps != null) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dad735c3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:575 | if (this.fps != null) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ce146a1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:578 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c13141e4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:579 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c7045724 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:587 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc854808 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:595 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (siMain.… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f711ac0a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:603 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea2cd2b2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:611 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1b64cba | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:616 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-82038952 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:623 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-793a481b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:631 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-782e4d99 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:636 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0dcdbb58 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:651 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-64feb538 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:660 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sDivisi… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36a2ede3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:661 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sDivisi… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-372e7210 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:666 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sD… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-67001f16 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:668 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && sMeasure == "Business_Plan" && sD… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b36e91f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:682 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && (sMeasure == "Business_Plan")) ▸ for (… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6adae14 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:690 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && (sMeasure == "Business_Plan")) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3db578d7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_3_BizPlan.cs:696 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!IsEditMode) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_3_BizPlan.FindData

진입점: this.btnSetPrice.Click / this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fc7cc70 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:714 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-23067b6d | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:723 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a89fc533 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:724 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bb7a1c4 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:731 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d74ef661 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:732 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-579fdcc0 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:737 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00276") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1680f19 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:738 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(6) | 속성 Value2 설정 |  |  |  |
| AC-78c4b1fb | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:739 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce308686 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:744 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bcbeaaa | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:746 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0792ff8a | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:751 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4a5710fd | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:754 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e7cc0d42 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:761 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a33c18a2 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:765 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_3_Get_BizPlan") ⇒ DM.DMF0042_3_Get_BizPlan | 엔드포인트 요청 생성 |  |  |  |
| AC-7a81e5ea | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:767 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-227fd898 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:769 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1a4b7a6b | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:770 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d5b1b0ae | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:771 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9d82f771 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:772 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-61acfcba | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:773 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5656ec4a | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:774 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1c4f561b | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:775 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-60d304df | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:776 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-668afe28 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:777 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-5ed057c2 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:778 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-05ab5314 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:779 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d6bcd1cb | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:780 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-942a2e3e | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:781 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-87efb6dc | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:782 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87e779c8 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:783 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-e00bd281 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:784 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-af6de9a1 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:786 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f09b70b4 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:788 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1ff08195 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:793 | try | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4348968d | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:794 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0678f205 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:798 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | valid_YN | ds.Tables[1].Rows[0]["VALID_YN"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-78236b9f | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:799 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYQQ | ds.Tables[1].Rows[0]["START_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c293ba56 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:800 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYQQ | ds.Tables[1].Rows[0]["END_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e3ef31b7 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:801 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYMM | ds.Tables[1].Rows[0]["START_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-feafb4c6 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:802 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYMM | ds.Tables[1].Rows[0]["END_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b9fb3556 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:803 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYY | ds.Tables[1].Rows[0]["START_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e8e0c09 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:804 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYY | ds.Tables[1].Rows[0]["END_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-174aa001 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:807 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66d6367d | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:812 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3c8e75f1 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:816 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6631a140 | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:820 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6c6dd52f | this.btnSetPrice.Click 외 3 | DMF0042_3_BizPlan.cs:822 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0042_3_BizPlan.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f730aad7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_3_BizPlan.cs:3387 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-6e6c3971 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_3_BizPlan.cs:3390 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d31187c4 | this.Load | DMF0042_3_BizPlan.cs:236 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-df56a71c | this.Load | DMF0042_3_BizPlan.cs:237 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_3_BizPlan.GetBizTypebyDivision

진입점: this.Load [if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd6b5666 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_3_BizPlan.cs:3034 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-92964fe6 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_3_BizPlan.cs:3035 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f99420a7 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_3_BizPlan.cs:3036 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5fd84964 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_3_BizPlan.cs:3038 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) \|\| (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == e.Column))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38f4e815 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_3_BizPlan.cs:3401 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-425e9efa | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_3_BizPlan.cs:3191 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b97534cb | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_3_BizPlan.cs:3192 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e73a779 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_3_BizPlan.cs:3179 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-0b2be6f6 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_3_BizPlan.cs:3184 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetCellProdSite

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-652c0f5c | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3484 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-c7a56b11 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3485 |  | DATA_OP | request.Parameters["CODE"] | "DM_CELL_PROD_SITE" | 행/컬럼 값 대입 |  |  |  |
| AC-7064eff1 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3486 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c4f8f8ac | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3487 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-92187a29 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3488 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-228bd6cd | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3489 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-59134564 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3490 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1851b711 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3491 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bf14cff2 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0042_3_BizPlan.cs:3493 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetComboData

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load [if (sDivision != null && sDivision != "") ▸ if (sDivision == "40")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ if (sDivision == "40")] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d55763e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2951 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_CODE") ⇒ DM.DMF0009_GET_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-ee310c00 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2952 |  | DATA_OP | request.Parameters["p_code_type"] | code | 행/컬럼 값 대입 |  |  |  |
| AC-18d1f88e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2953 |  | DATA_OP | request.Parameters["p_param1"] | (param1 == null ? "" : param1) | 행/컬럼 값 대입 |  |  |  |
| AC-3fa8c7e0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2954 |  | DATA_OP | request.Parameters["p_param2"] | (param2 == null ? "" : param2) | 행/컬럼 값 대입 |  |  |  |
| AC-cd93a244 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2955 |  | DATA_OP | request.Parameters["p_param3"] | (param3 == null ? "" : param3) | 행/컬럼 값 대입 |  |  |  |
| AC-62218f48 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2957 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81697bfd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2959 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3185a247 | this.Load 외 1 | DMF0042_3_BizPlan.cs:2988 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-5880a092 | this.Load 외 1 | DMF0042_3_BizPlan.cs:2989 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b5885014 | this.Load 외 1 | DMF0042_3_BizPlan.cs:2990 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-8d24b8f9 | this.Load 외 1 | DMF0042_3_BizPlan.cs:2992 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35144fd1 | this.Load 외 1 | DMF0042_3_BizPlan.cs:2995 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a349e4b7 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_3_BizPlan.cs:3129 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_EXCHANGE_PRICE") ⇒ DM.DMF0042_GET_EXCHANGE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-eb452c09 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_3_BizPlan.cs:3130 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-8555b388 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_3_BizPlan.cs:3131 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-f48f7c69 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_3_BizPlan.cs:3132 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b79cd61c | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_3_BizPlan.cs:3134 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetLookupData

진입점: this.Load / clbDivision.SelectedIndexChanged / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad76a08e | this.Load 외 2 | DMF0042_3_BizPlan.cs:3021 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-b58a4a50 | this.Load 외 2 | DMF0042_3_BizPlan.cs:3022 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-24d53477 | this.Load 외 2 | DMF0042_3_BizPlan.cs:3023 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5dbcff46 | this.Load 외 2 | DMF0042_3_BizPlan.cs:3025 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8103a1e6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3004 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_3_GET_SPREAD_TITLE") ⇒ DM.DMF0042_3_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-2a6cc595 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3006 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-c96ab4c8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3007 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-01b84afd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3008 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fb58d0d8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3009 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-2185f69c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3011 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-14028376 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:3011 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0042_3_BizPlan.GetThisWeekMonday

진입점: this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3ef26a1 | this.btnSetPrice.Click [try] 외 3 | DMF0042_3_BizPlan.cs:3155 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aca1d62b | this.Load | DMF0042_3_BizPlan.cs:259 |  | DATA_OP | this.ConditionNotUseList.Add | (cboClosed) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d933731 | this.Load | DMF0042_3_BizPlan.cs:261 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc3d4fb3 | this.Load | DMF0042_3_BizPlan.cs:261 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68ac84de | this.Load | DMF0042_3_BizPlan.cs:262 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b8596969 | this.Load | DMF0042_3_BizPlan.cs:265 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-7b26c7d8 | this.Load | DMF0042_3_BizPlan.cs:265 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66268c7e | this.Load | DMF0042_3_BizPlan.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fe1538f9 | this.Load | DMF0042_3_BizPlan.cs:269 |  | LIST_REBIND | clsCtrl.setListBox | (dtYn, cboClosed, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3632f65b | this.Load | DMF0042_3_BizPlan.cs:279 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-97274ef6 | this.Load | DMF0042_3_BizPlan.cs:279 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63b0a05f | this.Load | DMF0042_3_BizPlan.cs:280 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-736c36bb | this.Load | DMF0042_3_BizPlan.cs:282 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ce1f2968 | this.Load | DMF0042_3_BizPlan.cs:282 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9099e38 | this.Load | DMF0042_3_BizPlan.cs:284 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d41d60d3 | this.Load | DMF0042_3_BizPlan.cs:285 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-210797a8 | this.Load | DMF0042_3_BizPlan.cs:286 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-01c2d779 | this.Load | DMF0042_3_BizPlan.cs:287 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-b564cc53 | this.Load | DMF0042_3_BizPlan.cs:291 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-94534f55 | this.Load | DMF0042_3_BizPlan.cs:292 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-30972ca2 | this.Load | DMF0042_3_BizPlan.cs:294 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d381cf75 | this.Load | DMF0042_3_BizPlan.cs:294 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3a29b3a | this.Load | DMF0042_3_BizPlan.cs:296 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3186f506 | this.Load | DMF0042_3_BizPlan.cs:297 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-44028880 | this.Load | DMF0042_3_BizPlan.cs:298 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-35755494 | this.Load | DMF0042_3_BizPlan.cs:300 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-226b84fa | this.Load | DMF0042_3_BizPlan.cs:305 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-4989a07c | this.Load | DMF0042_3_BizPlan.cs:306 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-db075cff | this.Load | DMF0042_3_BizPlan.cs:308 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f57cf92b | this.Load | DMF0042_3_BizPlan.cs:308 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6d777d1 | this.Load | DMF0042_3_BizPlan.cs:310 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-adcae77c | this.Load | DMF0042_3_BizPlan.cs:311 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-323dc13e | this.Load | DMF0042_3_BizPlan.cs:312 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-02cb0088 | this.Load | DMF0042_3_BizPlan.cs:314 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | this.GetComboData(MEASURE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-934ec282 | this.Load | DMF0042_3_BizPlan.cs:318 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-85ffda7e | this.Load | DMF0042_3_BizPlan.cs:320 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d87aaa23 | this.Load | DMF0042_3_BizPlan.cs:323 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6ceed434 | this.Load | DMF0042_3_BizPlan.cs:323 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-311b25a1 | this.Load | DMF0042_3_BizPlan.cs:324 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b47722d | this.Load | DMF0042_3_BizPlan.cs:327 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-40fcb53b | this.Load | DMF0042_3_BizPlan.cs:327 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1dc2c742 | this.Load | DMF0042_3_BizPlan.cs:328 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-21fbd1a2 | this.Load | DMF0042_3_BizPlan.cs:330 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-d3aa7aeb | this.Load | DMF0042_3_BizPlan.cs:331 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b4b0d03f | this.Load | DMF0042_3_BizPlan.cs:333 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-4992d792 | this.Load | DMF0042_3_BizPlan.cs:335 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-bd312d8f | this.Load | DMF0042_3_BizPlan.cs:336 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1897d0b6 | this.Load | DMF0042_3_BizPlan.cs:339 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fa0cdf7 | this.Load | DMF0042_3_BizPlan.cs:340 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-17024f1f | this.Load | DMF0042_3_BizPlan.cs:342 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-b8c3ba60 | this.Load | DMF0042_3_BizPlan.cs:342 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87f5c983 | this.Load | DMF0042_3_BizPlan.cs:344 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e48e27b0 | this.Load | DMF0042_3_BizPlan.cs:346 |  | UI_PROP | lblBucket1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-58704f83 | this.Load | DMF0042_3_BizPlan.cs:347 |  | STATE | cboClosed.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0042_3_BizPlan.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04a1b461 | this.Load 외 1 | DMF0042_3_BizPlan.cs:528 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-26f157f0 | this.Load 외 1 | DMF0042_3_BizPlan.cs:529 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-485ec30e | this.Load 외 1 | DMF0042_3_BizPlan.cs:530 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de7bce34 | this.Load 외 1 | DMF0042_3_BizPlan.cs:533 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e9466f | this.Load 외 1 | DMF0042_3_BizPlan.cs:534 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_3_BizPlan.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19ee248e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:400 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0042_3_BizPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b58aef95 | InsertButton | DMF0042_3_BizPlan.cs:1200 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-4531d1e8 | InsertButton | DMF0042_3_BizPlan.cs:1202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasure.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b28ff52 | InsertButton | DMF0042_3_BizPlan.cs:1215 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e7ca797 | InsertButton | DMF0042_3_BizPlan.cs:1215 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbc2c9f4 | InsertButton | DMF0042_3_BizPlan.cs:1219 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5030398b | InsertButton | DMF0042_3_BizPlan.cs:1221 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-120c0ec3 | InsertButton | DMF0042_3_BizPlan.cs:1223 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-0a15e8e3 | InsertButton | DMF0042_3_BizPlan.cs:1225 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID40… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8b299cf1 | InsertButton | DMF0042_3_BizPlan.cs:1227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ce72ab43 | InsertButton | DMF0042_3_BizPlan.cs:1230 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a6ceb257 | InsertButton | DMF0042_3_BizPlan.cs:1231 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-806d5572 | InsertButton | DMF0042_3_BizPlan.cs:1234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f81b36f | InsertButton | DMF0042_3_BizPlan.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID40), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-64f37836 | InsertButton | DMF0042_3_BizPlan.cs:1239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision != "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-14079436 | InsertButton | DMF0042_3_BizPlan.cs:1241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9946159d | InsertButton | DMF0042_3_BizPlan.cs:1243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-094d9d04 | InsertButton | DMF0042_3_BizPlan.cs:1245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b09d1b1b | InsertButton | DMF0042_3_BizPlan.cs:1247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-34bcb718 | InsertButton | DMF0042_3_BizPlan.cs:1249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-11abf944 | InsertButton | DMF0042_3_BizPlan.cs:1251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7b330a36 | InsertButton | DMF0042_3_BizPlan.cs:1259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE), GetCellProdSite(… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a4070f6b | InsertButton | DMF0042_3_BizPlan.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-f900aab8 | InsertButton | DMF0042_3_BizPlan.cs:1268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5b0ca92 | InsertButton | DMF0042_3_BizPlan.cs:1275 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ff3907e | InsertButton | DMF0042_3_BizPlan.cs:1279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-33a2780a | InsertButton | DMF0042_3_BizPlan.cs:1281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f634756 | InsertButton | DMF0042_3_BizPlan.cs:1283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-576d155b | InsertButton | DMF0042_3_BizPlan.cs:1285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-264e6f7c | InsertButton | DMF0042_3_BizPlan.cs:1287 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff49f2a6 | InsertButton | DMF0042_3_BizPlan.cs:1291 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-14bc62a2 | InsertButton | DMF0042_3_BizPlan.cs:1293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-392f3903 | InsertButton | DMF0042_3_BizPlan.cs:1295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-40912628 | InsertButton | DMF0042_3_BizPlan.cs:1297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8166e507 | InsertButton | DMF0042_3_BizPlan.cs:1299 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-84af0a1a | InsertButton | DMF0042_3_BizPlan.cs:1301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-004b4793 | InsertButton | DMF0042_3_BizPlan.cs:1305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7d93afb | InsertButton | DMF0042_3_BizPlan.cs:1307 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.KWH), iRowNo, siMain.GetColumnIndex(DefColumns.K… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4e22f70 | InsertButton | DMF0042_3_BizPlan.cs:1309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-20a3b7ec | InsertButton | DMF0042_3_BizPlan.cs:1311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_CODE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a7280c6d | InsertButton | DMF0042_3_BizPlan.cs:1315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36c520e5 | InsertButton | DMF0042_3_BizPlan.cs:1317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_PACK), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-622c45cc | InsertButton | DMF0042_3_BizPlan.cs:1319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_PACK), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-67ff6754 | InsertButton | DMF0042_3_BizPlan.cs:1326 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-34edbd27 | InsertButton | DMF0042_3_BizPlan.cs:1329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-686fcd28 | InsertButton | DMF0042_3_BizPlan.cs:1331 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), iRowNo, siMain.Get… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88292e27 | InsertButton | DMF0042_3_BizPlan.cs:1333 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowNo, siMain.G… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cefe1aa7 | InsertButton | DMF0042_3_BizPlan.cs:1335 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a02c89a | InsertButton | DMF0042_3_BizPlan.cs:1337 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f44149b | InsertButton | DMF0042_3_BizPlan.cs:1339 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-deb8bc60 | InsertButton | DMF0042_3_BizPlan.cs:1341 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b345ed5 | InsertButton | DMF0042_3_BizPlan.cs:1343 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3fdbff63 | InsertButton | DMF0042_3_BizPlan.cs:1345 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e9575d5 | InsertButton | DMF0042_3_BizPlan.cs:1347 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowNo, siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c300d41 | InsertButton | DMF0042_3_BizPlan.cs:1349 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a20bbd1 | InsertButton | DMF0042_3_BizPlan.cs:1351 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowNo, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9f35b6e | InsertButton | DMF0042_3_BizPlan.cs:1353 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2efcdd49 | InsertButton | DMF0042_3_BizPlan.cs:1355 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowNo, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-54dbb121 | InsertButton | DMF0042_3_BizPlan.cs:1363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1737342e | InsertButton | DMF0042_3_BizPlan.cs:1365 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd5f2631 | InsertButton | DMF0042_3_BizPlan.cs:1367 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-573e6d4d | InsertButton | DMF0042_3_BizPlan.cs:1369 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f6aff36 | InsertButton | DMF0042_3_BizPlan.cs:1371 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-14a1d91a | InsertButton | DMF0042_3_BizPlan.cs:1373 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3f3df65 | InsertButton | DMF0042_3_BizPlan.cs:1375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f5dc488 | InsertButton | DMF0042_3_BizPlan.cs:1377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7e44dd67 | InsertButton | DMF0042_3_BizPlan.cs:1379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01aab6c3 | InsertButton | DMF0042_3_BizPlan.cs:1381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fced1eab | InsertButton | DMF0042_3_BizPlan.cs:1383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36cde958 | InsertButton | DMF0042_3_BizPlan.cs:1385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9c85ff47 | InsertButton | DMF0042_3_BizPlan.cs:1389 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae9f0e1e | InsertButton | DMF0042_3_BizPlan.cs:1391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c6c3ee1 | InsertButton | DMF0042_3_BizPlan.cs:1394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-cec7f0c2 | InsertButton | DMF0042_3_BizPlan.cs:1395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f0a4a19 | InsertButton | DMF0042_3_BizPlan.cs:1400 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex()… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e616d743 | InsertButton | DMF0042_3_BizPlan.cs:1410 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-89acaa95 | InsertButton | DMF0042_3_BizPlan.cs:1418 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-27d89701 | InsertButton | DMF0042_3_BizPlan.cs:1426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b324a45 | InsertButton | DMF0042_3_BizPlan.cs:1434 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-be3d6fa6 | InsertButton | DMF0042_3_BizPlan.cs:1439 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff3cdb1e | InsertButton | DMF0042_3_BizPlan.cs:1446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7676a772 | InsertButton | DMF0042_3_BizPlan.cs:1454 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-32cf4b00 | InsertButton | DMF0042_3_BizPlan.cs:1459 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ecc5074 | InsertButton | DMF0042_3_BizPlan.cs:1470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-401a6baf | InsertButton | DMF0042_3_BizPlan.cs:1476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_3_BizPlan.MinColumnChk

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec2b1f19 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_3_BizPlan.cs:3435 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f9136481 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_3_BizPlan.cs:3452 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e50b952d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_3_BizPlan.cs:3471 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-84b16063 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0042_3_BizPlan.cs:3474 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.ParameterString

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (i != iLOCRow)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9636dbd3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_3_BizPlan.cs:3226 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0042_3_BizPlan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b275b2a | SaveButton | DMF0042_3_BizPlan.cs:836 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-834f28d8 | SaveButton | DMF0042_3_BizPlan.cs:837 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2490af48 | SaveButton | DMF0042_3_BizPlan.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-131f3614 | SaveButton | DMF0042_3_BizPlan.cs:956 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de05ff02 | SaveButton | DMF0042_3_BizPlan.cs:986 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce9c86ef | SaveButton | DMF0042_3_BizPlan.cs:987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbc20ce5 | SaveButton | DMF0042_3_BizPlan.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80101254 | SaveButton | DMF0042_3_BizPlan.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79efe53a | SaveButton | DMF0042_3_BizPlan.cs:1130 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8c9b571 | SaveButton | DMF0042_3_BizPlan.cs:1131 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fb9c13f | SaveButton | DMF0042_3_BizPlan.cs:1136 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bf070ab | SaveButton | DMF0042_3_BizPlan.cs:1137 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63d3dd83 | SaveButton | DMF0042_3_BizPlan.cs:1144 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-d1c0775f | SaveButton | DMF0042_3_BizPlan.cs:1145 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-36c84b8d | SaveButton | DMF0042_3_BizPlan.cs:1145 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f4dbe1a | SaveButton | DMF0042_3_BizPlan.cs:1146 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | sDIVISION_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0d57487c | SaveButton | DMF0042_3_BizPlan.cs:1146 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sDIVISION_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a4f75c5 | SaveButton | DMF0042_3_BizPlan.cs:1147 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE"] | sPROJECT_CODE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ecb3b4ea | SaveButton | DMF0042_3_BizPlan.cs:1147 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sPROJECT_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-efe47be7 | SaveButton | DMF0042_3_BizPlan.cs:1148 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_NAME"] | sPROJECT_NAME.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2b507a6d | SaveButton | DMF0042_3_BizPlan.cs:1148 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sPROJECT_NAME.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-55b62019 | SaveButton | DMF0042_3_BizPlan.cs:1149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | sSCM_SITE_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-bbf9d644 | SaveButton | DMF0042_3_BizPlan.cs:1149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sSCM_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9370e986 | SaveButton | DMF0042_3_BizPlan.cs:1150 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | sPLANT_SITE_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0f834f7d | SaveButton | DMF0042_3_BizPlan.cs:1150 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sPLANT_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a0a9e5f | SaveButton | DMF0042_3_BizPlan.cs:1151 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID"] | sITEM_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-547d7083 | SaveButton | DMF0042_3_BizPlan.cs:1151 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sITEM_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b518767d | SaveButton | DMF0042_3_BizPlan.cs:1153 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | sFCST_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3a9f7ffd | SaveButton | DMF0042_3_BizPlan.cs:1153 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sFCST_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c35c421 | SaveButton | DMF0042_3_BizPlan.cs:1154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | sINCOTERMS.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-cf06e02b | SaveButton | DMF0042_3_BizPlan.cs:1154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sINCOTERMS.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca723e94 | SaveButton | DMF0042_3_BizPlan.cs:1155 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE"] | sMEASURE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ec1c922b | SaveButton | DMF0042_3_BizPlan.cs:1155 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sMEASURE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-42bf8e4a | SaveButton | DMF0042_3_BizPlan.cs:1156 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM"] | sYYYYMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c98fb4f2 | SaveButton | DMF0042_3_BizPlan.cs:1156 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sYYYYMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef2cffab | SaveButton | DMF0042_3_BizPlan.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY"] | pInput.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-adfb708d | SaveButton | DMF0042_3_BizPlan.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pInput.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cc571be | SaveButton | DMF0042_3_BizPlan.cs:1158 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY"] | sCURRENCY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b8103ba0 | SaveButton | DMF0042_3_BizPlan.cs:1158 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sCURRENCY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3a626a3 | SaveButton | DMF0042_3_BizPlan.cs:1161 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sDEPT_ID"] | sDEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-e0b3fdf5 | SaveButton | DMF0042_3_BizPlan.cs:1161 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sDEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-915281f7 | SaveButton | DMF0042_3_BizPlan.cs:1162 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sEND_CUSTOMER"] | sEND_CUSTOMER.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c5a0f06e | SaveButton | DMF0042_3_BizPlan.cs:1162 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sEND_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d4a2e61 | SaveButton | DMF0042_3_BizPlan.cs:1163 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sBIZ_TYPE"] | sBIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6a025925 | SaveButton | DMF0042_3_BizPlan.cs:1169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sITEM_USE"] | sITEM_USE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6553a389 | SaveButton | DMF0042_3_BizPlan.cs:1169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sITEM_USE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-570b59df | SaveButton | DMF0042_3_BizPlan.cs:1170 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["sUNIT_ENERGY"] | sUNIT_ENERGY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-399a2da2 | SaveButton | DMF0042_3_BizPlan.cs:1170 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sUNIT_ENERGY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-db6548d4 | SaveButton | DMF0042_3_BizPlan.cs:1171 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | sCELL_PROD_SITE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5c5e821d | SaveButton | DMF0042_3_BizPlan.cs:1171 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sCELL_PROD_SITE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb3a004e | SaveButton | DMF0042_3_BizPlan.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4c0f3cc4 | SaveButton | DMF0042_3_BizPlan.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd9cf5c0 | SaveButton | DMF0042_3_BizPlan.cs:1174 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b8efa44e | SaveButton | DMF0042_3_BizPlan.cs:1174 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c63395bc | SaveButton | DMF0042_3_BizPlan.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b9559afe | SaveButton | DMF0042_3_BizPlan.cs:1181 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-1244c336 | SaveButton | DMF0042_3_BizPlan.cs:1182 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e41c0fcc | SaveButton | DMF0042_3_BizPlan.cs:1186 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_3_BizPlan.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt == iCheck)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f188e0cf | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_3_BizPlan.cs:3410 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0042_3_BizPlan.SetComboCol

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-617eb49b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2968 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a48ffe6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2969 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-51b75c71 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2973 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-8fe78cdb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2974 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-07d76e2f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2975 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-48b66a48 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2976 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-6c924750 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2980 |  | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |

## DMF0042_3_BizPlan.SetComboColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d4d0030 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:2941 |  | DATA_OP | dtTitle.Select | ($"COLUMN_NAME = '{columnName}'") | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_3_BizPlan.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivisio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-814630a0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:501 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0e09120d | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:504 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-bdb3c06e | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:509 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6347dbd9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:511 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-82cdb428 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:514 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-25b945d6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:519 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d04750c5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_3_BizPlan.cs:521 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0042_3_BizPlan.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8341c6fb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:436 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af04cc0f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:444 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eac5f57b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:456 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b623921f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:457 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e323f64 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:462 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc964357 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:463 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef2cdd77 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:470 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9585dd73 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:471 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf2c59f3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:482 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9598f7b5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:483 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f96e7d8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:484 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4551bd1f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:485 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-253bfec7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:487 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37ffefb2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_3_BizPlan.cs:489 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_3_BizPlan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d110795 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1672 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-50e0319f | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1678 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-ab447a50 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1694 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-2c0088de | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1709 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-681783b8 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1740 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-54ebba2c | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1742 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a985adce | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1743 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8b0aac9a | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1744 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-84478c27 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1753 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-40a34e6d | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1756 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-16a60251 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1758 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID40), sItemId) | 그리드 값 설정 |  |  |  |
| AC-e4a66bd0 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1760 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-ae7af267 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1790 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4a34503a | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1792 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2cd4dad4 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1793 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c22c69bf | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1794 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a6055cf9 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1804 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-88b4f953 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1807 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-3cf3b28f | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1809 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), sBizType) | 그리드 값 설정 |  |  |  |
| AC-f007d479 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1840 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-54575331 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1842 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ddeffbeb | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1843 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8d459623 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1844 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e7dd8aad | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1854 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-0702adb9 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1857 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME)… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-e3557c50 | this.spdMain.CellDoubleClick | DMF0042_3_BizPlan.cs:1859 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), sBizType) | 그리드 값 설정 |  |  |  |

## DMF0042_3_BizPlan.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82228b24 | dsdm.Changed | DMF0042_3_BizPlan.cs:1866 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4ba795b | dsdm.Changed | DMF0042_3_BizPlan.cs:1869 | if (e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c50c25a | dsdm.Changed | DMF0042_3_BizPlan.cs:1870 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f55a2378 | dsdm.Changed | DMF0042_3_BizPlan.cs:1874 | if (siMain.GetValue(e.Row, e.Column).ToString() == "") | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-760672a5 | dsdm.Changed | DMF0042_3_BizPlan.cs:1901 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a426b381 | dsdm.Changed | DMF0042_3_BizPlan.cs:1912 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bdd6bb5 | dsdm.Changed | DMF0042_3_BizPlan.cs:1916 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | GRID_SET | siMain.SetValue | (e.Row, e.Column, strValue[0] + ".000") | 그리드 값 설정 |  |  |  |
| AC-95726160 | dsdm.Changed | DMF0042_3_BizPlan.cs:1917 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00289") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-945e0cc1 | dsdm.Changed | DMF0042_3_BizPlan.cs:1943 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00bed2f6 | dsdm.Changed | DMF0042_3_BizPlan.cs:1945 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad495413 | dsdm.Changed | DMF0042_3_BizPlan.cs:1951 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-88ef879a | dsdm.Changed | DMF0042_3_BizPlan.cs:1971 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2396c61f | dsdm.Changed | DMF0042_3_BizPlan.cs:1978 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d72bf3bb | dsdm.Changed | DMF0042_3_BizPlan.cs:1992 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-392f98c8 | dsdm.Changed | DMF0042_3_BizPlan.cs:2033 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (iQuarterlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-455e34a8 | dsdm.Changed | DMF0042_3_BizPlan.cs:2058 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b405ca79 | dsdm.Changed | DMF0042_3_BizPlan.cs:2064 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-988ada0a | dsdm.Changed | DMF0042_3_BizPlan.cs:2078 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-c021f2a2 | dsdm.Changed | DMF0042_3_BizPlan.cs:2084 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-228f1757 | dsdm.Changed | DMF0042_3_BizPlan.cs:2105 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-813e1f7c | dsdm.Changed | DMF0042_3_BizPlan.cs:2133 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a679fa10 | dsdm.Changed | DMF0042_3_BizPlan.cs:2141 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b56181ba | dsdm.Changed | DMF0042_3_BizPlan.cs:2159 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (Convert.ToDecimal(siMain.GetValue(e.Row, e.Column))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3299ad8 | dsdm.Changed | DMF0042_3_BizPlan.cs:2168 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42e01806 | dsdm.Changed | DMF0042_3_BizPlan.cs:2168 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DateTime.Today.DayOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-211c28f3 | dsdm.Changed | DMF0042_3_BizPlan.cs:2226 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-68b838fc | dsdm.Changed | DMF0042_3_BizPlan.cs:2232 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-98ce6b4e | dsdm.Changed | DMF0042_3_BizPlan.cs:2248 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-118dce67 | dsdm.Changed | DMF0042_3_BizPlan.cs:2254 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-073755d2 | dsdm.Changed | DMF0042_3_BizPlan.cs:2276 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-cced05e6 | dsdm.Changed | DMF0042_3_BizPlan.cs:2311 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6e379627 | dsdm.Changed | DMF0042_3_BizPlan.cs:2316 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ffc8e23d | dsdm.Changed | DMF0042_3_BizPlan.cs:2338 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7aeb3a10 | dsdm.Changed | DMF0042_3_BizPlan.cs:2345 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, iQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |
| AC-50b89268 | dsdm.Changed | DMF0042_3_BizPlan.cs:2383 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6180b036 | dsdm.Changed | DMF0042_3_BizPlan.cs:2410 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d88963ef | dsdm.Changed | DMF0042_3_BizPlan.cs:2490 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-752a7ad1 | dsdm.Changed | DMF0042_3_BizPlan.cs:2496 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-43019e50 | dsdm.Changed | DMF0042_3_BizPlan.cs:2510 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-4ed6c07b | dsdm.Changed | DMF0042_3_BizPlan.cs:2516 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-3babf097 | dsdm.Changed | DMF0042_3_BizPlan.cs:2537 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-245cd250 | dsdm.Changed | DMF0042_3_BizPlan.cs:2573 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2230dd4e | dsdm.Changed | DMF0042_3_BizPlan.cs:2658 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b62283a8 | dsdm.Changed | DMF0042_3_BizPlan.cs:2664 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-60c6810f | dsdm.Changed | DMF0042_3_BizPlan.cs:2680 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-65135232 | dsdm.Changed | DMF0042_3_BizPlan.cs:2686 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-32fd7306 | dsdm.Changed | DMF0042_3_BizPlan.cs:2708 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-2544d030 | dsdm.Changed | DMF0042_3_BizPlan.cs:2743 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-3074834c | dsdm.Changed | DMF0042_3_BizPlan.cs:2748 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-0733d56e | dsdm.Changed | DMF0042_3_BizPlan.cs:2777 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0042_3_BizPlan.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ea8e3af | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1637 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-64a3d5d3 | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1638 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1c89f91e | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1650 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b13a295 | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1653 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8e5f5690 | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1656 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-65998461 | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1656 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0116f5bb | this.spdMain.ComboSelChange | DMF0042_3_BizPlan.cs:1657 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0042_3_BizPlan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94c6c136 | this.spdMain.EditChange | DMF0042_3_BizPlan.cs:3091 | if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-969f453e | this.spdMain.EditChange | DMF0042_3_BizPlan.cs:3093 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_3_BizPlan.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5fefb95 | this.spdMain.TopChange | DMF0042_3_BizPlan.cs:2803 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_3_BizPlan.ValidationCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ed9e88f | (진입점 미연결) | DMF0042_3_BizPlan.cs:2792 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bac8edea | (진입점 미연결) | DMF0042_3_BizPlan.cs:2795 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-08ce1b9a | (진입점 미연결) | DMF0042_3_BizPlan.cs:2797 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_BizPlan_old.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db4b3b6d | this.btnColumn.Click | DMF0042_BizPlan_old.cs:2081 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-c00e1745 | this.btnColumn.Click | DMF0042_BizPlan_old.cs:2082 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1c3bc3ef | this.btnColumn.Click | DMF0042_BizPlan_old.cs:2083 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan_old.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47d05251 | this.btnCutOff.Click | DMF0042_BizPlan_old.cs:2116 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-c01937ac | this.btnCutOff.Click | DMF0042_BizPlan_old.cs:2117 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f426d6f2 | this.btnCutOff.Click | DMF0042_BizPlan_old.cs:2124 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-5e8e7ce3 | this.btnCutOff.Click | DMF0042_BizPlan_old.cs:2126 |  | CALL_EXT | popup.LoadData | (sVersion_Type, sFoxData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f01b7611 | this.btnCutOff.Click | DMF0042_BizPlan_old.cs:2127 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6e861e1c | this.btnCutOff.Click | DMF0042_BizPlan_old.cs:2128 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan_old.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-356e33af | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2255 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bb3f623 | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2256 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1783685 | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2259 |  | POPUP | new POPUP.DMF0020_SalesFuturePricePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-6ca8f94a | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2260 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a1c66cb | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2262 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-832d0f91 | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2263 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1af2e73e | this.btnExchangeRate.Click | DMF0042_BizPlan_old.cs:2267 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_BizPlan_old.btnIncotermsChg_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faf32f02 | (진입점 미연결) | DMF0042_BizPlan_old.cs:2203 |  | POPUP | new DM0002_MatsterChgPopup | () | 팝업/폼 생성 |  |  |  |
| AC-51c44487 | (진입점 미연결) | DMF0042_BizPlan_old.cs:2204 |  | POPUP | popAdjst.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-813fc830 | (진입점 미연결) | DMF0042_BizPlan_old.cs:2206 |  | UI_PROP | popAdjst.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c4c3f60c | (진입점 미연결) | DMF0042_BizPlan_old.cs:2207 |  | POPUP | popAdjst.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan_old.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ce47c8b | this.btnItemId.Click | DMF0042_BizPlan_old.cs:2065 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-30acee61 | this.btnItemId.Click | DMF0042_BizPlan_old.cs:2067 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6f51a2c6 | this.btnItemId.Click | DMF0042_BizPlan_old.cs:2068 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c3364b5d | this.btnItemId.Click | DMF0042_BizPlan_old.cs:2069 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0c8d8647 | this.btnItemId.Click | DMF0042_BizPlan_old.cs:2075 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0042_BizPlan_old.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f727c20b | this.btnMeasure.Click | DMF0042_BizPlan_old.cs:2093 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-58a6ffd0 | this.btnMeasure.Click | DMF0042_BizPlan_old.cs:2095 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1556add5 | this.btnMeasure.Click | DMF0042_BizPlan_old.cs:2096 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan_old.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c43773c1 | this.btnOwner.Click | DMF0042_BizPlan_old.cs:2221 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fff99d32 | this.btnOwner.Click | DMF0042_BizPlan_old.cs:2224 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-aa100dac | this.btnOwner.Click | DMF0042_BizPlan_old.cs:2225 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a5d6d5e | this.btnOwner.Click | DMF0042_BizPlan_old.cs:2226 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7c24c941 | this.btnOwner.Click | DMF0042_BizPlan_old.cs:2228 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0042_BizPlan_old.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d894c464 | this.btnProject.Click | DMF0042_BizPlan_old.cs:2043 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e0336ba5 | this.btnProject.Click | DMF0042_BizPlan_old.cs:2044 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ad7d7602 | this.btnProject.Click | DMF0042_BizPlan_old.cs:2045 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c15a4386 | this.btnProject.Click | DMF0042_BizPlan_old.cs:2046 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e096271f | this.btnProject.Click | DMF0042_BizPlan_old.cs:2052 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0042_BizPlan_old.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d5fde6d | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2383 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00282") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86d1b80a | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2384 | if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65665856 | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2390 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | 엔드포인트 요청 생성 |  |  |  |
| AC-ebd52a5f | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2392 |  | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8aa8566d | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2394 |  | DATA_OP | request.Parameters["s_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-33ea779a | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2395 |  | DATA_OP | request.Parameters["s_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e424b083 | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2396 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27532ee2 | this.btnSetPrice.Click | DMF0042_BizPlan_old.cs:2399 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_BizPlan_old.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70d2809b | this.cboBucketType.Click | DMF0042_BizPlan_old.cs:2237 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc70d842 | this.cboBucketType.Click | DMF0042_BizPlan_old.cs:2238 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b84a8e1e | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1157 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-788f56e5 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1157 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ce9bd0e | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1158 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-955d7e11 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1164 | if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b9988f11 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1164 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7749232a | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1165 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57a729e5 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1167 | if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-2d876ae4 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1167 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-071c6649 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1169 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-aca8ee44 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1170 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e8998749 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1171 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1afaa2c9 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1172 | if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-75ec8460 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1172 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2472b931 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1176 | else of (sDivision == "40") ▸ if (sDivision == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-39740188 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1177 | else of (sDivision == "40") ▸ if (sDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f69300f6 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1179 | else of (sDivision == "40") ▸ if (sDivision == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fd26913e | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1179 | else of (sDivision == "40") ▸ if (sDivision == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2380dd31 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1181 | else of (sDivision == "40") ▸ if (sDivision == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b1b5978a | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1182 | else of (sDivision == "40") ▸ if (sDivision == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-347e9482 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1183 | else of (sDivision == "40") ▸ if (sDivision == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2f5cc59a | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1185 | else of (sDivision == "40") ▸ if (sDivision == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "81", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-35efd09b | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1185 | else of (sDivision == "40") ▸ if (sDivision == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "81", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e251a6ed | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1189 | else of (sDivision == "40") ▸ else of (sDivision == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1caa97e | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1190 | else of (sDivision == "40") ▸ else of (sDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-65ffba2b | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1192 | else of (sDivision == "40") ▸ else of (sDivision == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c7cd5f8a | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1192 | else of (sDivision == "40") ▸ else of (sDivision == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4a465569 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1194 | else of (sDivision == "40") ▸ else of (sDivision == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-35ed5eb3 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1195 | else of (sDivision == "40") ▸ else of (sDivision == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-227fc5f0 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1196 | else of (sDivision == "40") ▸ else of (sDivision == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4f0cc4aa | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1198 | else of (sDivision == "40") ▸ else of (sDivision == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e60758c | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1198 | else of (sDivision == "40") ▸ else of (sDivision == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e136174 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1200 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6a839157 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1202 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-43889c32 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1205 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4ebbdda9 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1205 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60e0b5f4 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1206 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-849ac841 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1208 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-837bd242 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1208 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87fbd32f | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1209 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a1609f5 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1211 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-b5610db3 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1212 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ab54a964 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1214 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-561cedef | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1216 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-45c27c7e | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1217 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-888ce818 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1220 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0714d1a4 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1221 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f21db9b | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1223 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdaf9c2d | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1223 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07f29c33 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1225 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ddac82b9 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1227 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7d456d1b | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1228 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-caae90dc | clbDivision.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1229 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0042_BizPlan_old.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76d8ef84 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1260 | if ((clbDivision.ControlValues == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d8757745 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1260 | if ((clbDivision.ControlValues == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b464abe | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1264 | else of ((clbDivision.ControlValues == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-d38dd1d1 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1264 | else of ((clbDivision.ControlValues == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0af78a5 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1266 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_BizPlan_old.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce6ee28 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1239 | if ((sDivision == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e0de909 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1239 | if ((sDivision == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36795162 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1240 | if ((sDivision == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c5954202 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1242 | if ((sDivision == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b5d438 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1242 | if ((sDivision == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07046665 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1246 | else of ((sDivision == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-9fcb0de7 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1246 | else of ((sDivision == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-522e9433 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1247 | else of ((sDivision == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-09b3a29e | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1249 | else of ((sDivision == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ac973669 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1249 | else of ((sDivision == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dda124a5 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan_old.cs:1252 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_BizPlan_old.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbe18a89 | this.Load | DMF0042_BizPlan_old.cs:336 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3bfd50c | this.Load | DMF0042_BizPlan_old.cs:337 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-65535326 | this.Load | DMF0042_BizPlan_old.cs:338 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_BizPlan_old.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5821095 | this.Load | DMF0042_BizPlan_old.cs:297 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-4e5c060e | this.Load | DMF0042_BizPlan_old.cs:299 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-d36834d4 | this.Load | DMF0042_BizPlan_old.cs:301 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-655503c2 | this.Load | DMF0042_BizPlan_old.cs:302 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-92e95bd8 | this.Load | DMF0042_BizPlan_old.cs:303 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-d1905975 | this.Load | DMF0042_BizPlan_old.cs:304 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-2ba6e760 | this.Load | DMF0042_BizPlan_old.cs:308 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9677f426 | this.Load | DMF0042_BizPlan_old.cs:314 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2abe15b3 | this.Load | DMF0042_BizPlan_old.cs:315 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-fb14e8fc | this.Load | DMF0042_BizPlan_old.cs:316 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a8b1197a | this.Load | DMF0042_BizPlan_old.cs:321 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-540b3b13 | this.Load | DMF0042_BizPlan_old.cs:322 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3a5a456f | this.Load | DMF0042_BizPlan_old.cs:323 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0042_BizPlan_old.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe13f9b3 | DeleteButton | DMF0042_BizPlan_old.cs:499 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ee148dd | DeleteButton | DMF0042_BizPlan_old.cs:505 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-21fa2454 | DeleteButton | DMF0042_BizPlan_old.cs:506 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_BizPlan_old.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88ba78dd | Dispose | DMF0042_BizPlan_old.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_BizPlan_old.EditButton

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-532db310 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:517 | if (this.fps != null) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ab13e10 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:518 | if (this.fps != null) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e682c7e | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:521 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f6a3491 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:522 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0440740d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:530 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-073bb532 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:535 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c129200 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:540 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-37eef7e6 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:548 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-10c2645e | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:560 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") \|\| (s… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-deaa1c98 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0042_BizPlan_old.cs:567 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") \|… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_BizPlan_old.FindData

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.btnSetPrice.Click / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a33e5e1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:586 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fc544334 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:595 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-194ae42d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:596 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59fda96f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:603 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa25c75a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:604 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44cefb80 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:609 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00276") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ebe44e1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:610 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(6) | 속성 Value2 설정 |  |  |  |
| AC-aab31a80 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:611 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05bf3f11 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:616 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-381c9510 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:618 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abcfca8d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:623 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3be1703b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:626 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8ebda41d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:633 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-13cc53c9 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:637 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA") ⇒ DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-fb564385 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:639 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8941316b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:641 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8bd4400f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:642 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-2dd19bb8 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:643 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a966ae8a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:644 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7940eb0d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:645 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0bea82d0 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:646 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-68846640 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:647 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d517ba04 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:648 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-941d0cde | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:649 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-a5c437d2 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:650 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-dcad1952 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:651 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2cceecee | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:652 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-bd6e81aa | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:653 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7a354455 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:654 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c45f0da | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:655 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-e1306d40 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:657 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-820d5877 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:659 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cb820eb4 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:664 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-57798024 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:665 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8eb1ea07 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:667 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-015edda3 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:672 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0cc061a0 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:676 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a005b02 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:680 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-52ddb937 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0042_BizPlan_old.cs:682 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0042_BizPlan_old.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8b18e7c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan_old.cs:2513 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-d1c8485c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan_old.cs:2516 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ed58822 | this.Load | DMF0042_BizPlan_old.cs:195 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-305cffc5 | this.Load | DMF0042_BizPlan_old.cs:196 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_BizPlan_old.GetBizTypebyDivision

진입점: this.Load [else of (sDivision == "40") ▸ if (sDivision == "81")] / clbDivision.SelectedIndexChanged [else of (sDivision == "40") ▸ if (sDivision == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9985a38 | this.Load [else of (sDivision == "40") ▸ if (sDivision == "8… 외 1 | DMF0042_BizPlan_old.cs:2188 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e37449be | this.Load [else of (sDivision == "40") ▸ if (sDivision == "8… 외 1 | DMF0042_BizPlan_old.cs:2189 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-306b8449 | this.Load [else of (sDivision == "40") ▸ if (sDivision == "8… 외 1 | DMF0042_BizPlan_old.cs:2190 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bf719fca | this.Load [else of (sDivision == "40") ▸ if (sDivision == "8… 외 1 | DMF0042_BizPlan_old.cs:2192 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cfa14cc | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_BizPlan_old.cs:2527 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da0c82a8 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan_old.cs:2343 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-752f7d06 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan_old.cs:2344 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f72a96a3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan_old.cs:2331 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-2b974187 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan_old.cs:2336 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a449bc8 | this.Load 외 1 | DMF0042_BizPlan_old.cs:2142 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-f6e2c4f8 | this.Load 외 1 | DMF0042_BizPlan_old.cs:2143 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f7799b46 | this.Load 외 1 | DMF0042_BizPlan_old.cs:2144 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-df30df1e | this.Load 외 1 | DMF0042_BizPlan_old.cs:2146 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3eb7bf5 | this.Load 외 1 | DMF0042_BizPlan_old.cs:2149 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a6d71ae | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan_old.cs:2281 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_EXCHANGE_PRICE") ⇒ DM.DMF0042_GET_EXCHANGE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-19cb37d6 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan_old.cs:2282 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-925f39b5 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan_old.cs:2283 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1f21ee8a | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan_old.cs:2284 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa7a9d7a | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan_old.cs:2286 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetLookupData

진입점: this.Load / clbDivision.SelectedIndexChanged / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1acc56b7 | this.Load 외 2 | DMF0042_BizPlan_old.cs:2175 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-0e0136bc | this.Load 외 2 | DMF0042_BizPlan_old.cs:2176 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-7cd9d501 | this.Load 외 2 | DMF0042_BizPlan_old.cs:2177 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a686a481 | this.Load 외 2 | DMF0042_BizPlan_old.cs:2179 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.btnSetPrice.Click [try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac6ac8f3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2158 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_SPREAD_TITLE") ⇒ DM.DMF0042_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-3d564b05 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2160 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-b16b4aab | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2161 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-ae1473b1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2162 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-08b06218 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2163 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e1c4c1a7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2165 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-da64c79a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:2165 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0042_BizPlan_old.GetThisWeekMonday

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.btnSetPrice.Click [try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c84d1482 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 3 | DMF0042_BizPlan_old.cs:2307 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89673fa6 | this.Load | DMF0042_BizPlan_old.cs:217 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-246bcd96 | this.Load | DMF0042_BizPlan_old.cs:217 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-62cb3644 | this.Load | DMF0042_BizPlan_old.cs:218 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-54e9c8d5 | this.Load | DMF0042_BizPlan_old.cs:221 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-fe23a27f | this.Load | DMF0042_BizPlan_old.cs:221 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c2e5e7c | this.Load | DMF0042_BizPlan_old.cs:222 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e91ee4ae | this.Load | DMF0042_BizPlan_old.cs:229 | if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b73dd839 | this.Load | DMF0042_BizPlan_old.cs:229 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d3b9cc8 | this.Load | DMF0042_BizPlan_old.cs:230 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1a8db0e9 | this.Load | DMF0042_BizPlan_old.cs:232 | if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-231c414c | this.Load | DMF0042_BizPlan_old.cs:232 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7e1e768 | this.Load | DMF0042_BizPlan_old.cs:234 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-95676005 | this.Load | DMF0042_BizPlan_old.cs:235 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eaeb1c9b | this.Load | DMF0042_BizPlan_old.cs:236 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-157e8636 | this.Load | DMF0042_BizPlan_old.cs:237 | if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-60cced81 | this.Load | DMF0042_BizPlan_old.cs:237 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75fe80e8 | this.Load | DMF0042_BizPlan_old.cs:241 | else of (sDivision == "40") ▸ if (sDivision == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-2543bdec | this.Load | DMF0042_BizPlan_old.cs:242 | else of (sDivision == "40") ▸ if (sDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-11c4a6eb | this.Load | DMF0042_BizPlan_old.cs:244 | else of (sDivision == "40") ▸ if (sDivision == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-71daa948 | this.Load | DMF0042_BizPlan_old.cs:244 | else of (sDivision == "40") ▸ if (sDivision == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ab65858 | this.Load | DMF0042_BizPlan_old.cs:246 | else of (sDivision == "40") ▸ if (sDivision == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b91c792b | this.Load | DMF0042_BizPlan_old.cs:247 | else of (sDivision == "40") ▸ if (sDivision == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-744b61cb | this.Load | DMF0042_BizPlan_old.cs:248 | else of (sDivision == "40") ▸ if (sDivision == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d1db4115 | this.Load | DMF0042_BizPlan_old.cs:250 | else of (sDivision == "40") ▸ if (sDivision == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "81", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-5f32cff1 | this.Load | DMF0042_BizPlan_old.cs:250 | else of (sDivision == "40") ▸ if (sDivision == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "81", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53345fbe | this.Load | DMF0042_BizPlan_old.cs:254 | else of (sDivision == "40") ▸ else of (sDivision == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-8200862c | this.Load | DMF0042_BizPlan_old.cs:255 | else of (sDivision == "40") ▸ else of (sDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b1ff6eb3 | this.Load | DMF0042_BizPlan_old.cs:257 | else of (sDivision == "40") ▸ else of (sDivision == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-074d2818 | this.Load | DMF0042_BizPlan_old.cs:257 | else of (sDivision == "40") ▸ else of (sDivision == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2edfc1fc | this.Load | DMF0042_BizPlan_old.cs:259 | else of (sDivision == "40") ▸ else of (sDivision == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f04ad5cb | this.Load | DMF0042_BizPlan_old.cs:260 | else of (sDivision == "40") ▸ else of (sDivision == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a8288aa1 | this.Load | DMF0042_BizPlan_old.cs:261 | else of (sDivision == "40") ▸ else of (sDivision == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a19e1f78 | this.Load | DMF0042_BizPlan_old.cs:263 | else of (sDivision == "40") ▸ else of (sDivision == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-3190856b | this.Load | DMF0042_BizPlan_old.cs:263 | else of (sDivision == "40") ▸ else of (sDivision == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1eb2b196 | this.Load | DMF0042_BizPlan_old.cs:265 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0501172e | this.Load | DMF0042_BizPlan_old.cs:267 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a610d561 | this.Load | DMF0042_BizPlan_old.cs:270 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a0748e53 | this.Load | DMF0042_BizPlan_old.cs:270 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24c48117 | this.Load | DMF0042_BizPlan_old.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dacc1081 | this.Load | DMF0042_BizPlan_old.cs:273 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-db47bb82 | this.Load | DMF0042_BizPlan_old.cs:273 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dcba2fd0 | this.Load | DMF0042_BizPlan_old.cs:274 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d302ad99 | this.Load | DMF0042_BizPlan_old.cs:276 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-bd13c657 | this.Load | DMF0042_BizPlan_old.cs:277 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d7c868b4 | this.Load | DMF0042_BizPlan_old.cs:279 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-8fc82376 | this.Load | DMF0042_BizPlan_old.cs:281 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-2059fcda | this.Load | DMF0042_BizPlan_old.cs:282 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-46097ed3 | this.Load | DMF0042_BizPlan_old.cs:285 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9224dbc | this.Load | DMF0042_BizPlan_old.cs:286 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-682a811b | this.Load | DMF0042_BizPlan_old.cs:288 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-d8ab31f6 | this.Load | DMF0042_BizPlan_old.cs:288 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9429f224 | this.Load | DMF0042_BizPlan_old.cs:292 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0042_BizPlan_old.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4be7bd9 | this.Load 외 1 | DMF0042_BizPlan_old.cs:473 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-318d6d79 | this.Load 외 1 | DMF0042_BizPlan_old.cs:474 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7585095f | this.Load 외 1 | DMF0042_BizPlan_old.cs:475 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16dbf274 | this.Load 외 1 | DMF0042_BizPlan_old.cs:478 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-09c92032 | this.Load 외 1 | DMF0042_BizPlan_old.cs:479 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_BizPlan_old.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.btnSetPrice.Click [try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ba7f7a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:346 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0042_BizPlan_old.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74193f29 | InsertButton | DMF0042_BizPlan_old.cs:944 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-249ac661 | InsertButton | DMF0042_BizPlan_old.cs:946 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasure.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-81466b18 | InsertButton | DMF0042_BizPlan_old.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-b000fc64 | InsertButton | DMF0042_BizPlan_old.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-620f6543 | InsertButton | DMF0042_BizPlan_old.cs:963 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3a6de2da | InsertButton | DMF0042_BizPlan_old.cs:965 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c062e832 | InsertButton | DMF0042_BizPlan_old.cs:967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-565ecf01 | InsertButton | DMF0042_BizPlan_old.cs:969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID40… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-0b1def84 | InsertButton | DMF0042_BizPlan_old.cs:971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-734f875f | InsertButton | DMF0042_BizPlan_old.cs:974 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0d46e05e | InsertButton | DMF0042_BizPlan_old.cs:977 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-82b837d4 | InsertButton | DMF0042_BizPlan_old.cs:981 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-af84c6c0 | InsertButton | DMF0042_BizPlan_old.cs:983 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-54faf101 | InsertButton | DMF0042_BizPlan_old.cs:985 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dbe44d79 | InsertButton | DMF0042_BizPlan_old.cs:987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-87f31361 | InsertButton | DMF0042_BizPlan_old.cs:989 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7e9142af | InsertButton | DMF0042_BizPlan_old.cs:991 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-99112894 | InsertButton | DMF0042_BizPlan_old.cs:993 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), dtBizType81) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e1bf94cd | InsertButton | DMF0042_BizPlan_old.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-3b83e7da | InsertButton | DMF0042_BizPlan_old.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb45d58b | InsertButton | DMF0042_BizPlan_old.cs:1008 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1bfe061d | InsertButton | DMF0042_BizPlan_old.cs:1012 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f59c14ce | InsertButton | DMF0042_BizPlan_old.cs:1014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f443c39a | InsertButton | DMF0042_BizPlan_old.cs:1016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22561d59 | InsertButton | DMF0042_BizPlan_old.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22a9c9f0 | InsertButton | DMF0042_BizPlan_old.cs:1020 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0a57581 | InsertButton | DMF0042_BizPlan_old.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-44d2d9c9 | InsertButton | DMF0042_BizPlan_old.cs:1026 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2bbcac1d | InsertButton | DMF0042_BizPlan_old.cs:1028 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3e594663 | InsertButton | DMF0042_BizPlan_old.cs:1030 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d22ac67 | InsertButton | DMF0042_BizPlan_old.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe90a926 | InsertButton | DMF0042_BizPlan_old.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f70529e6 | InsertButton | DMF0042_BizPlan_old.cs:1036 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-163c72fc | InsertButton | DMF0042_BizPlan_old.cs:1038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4df244bc | InsertButton | DMF0042_BizPlan_old.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), iRowNo, siMain.Get… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d26220c | InsertButton | DMF0042_BizPlan_old.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowNo, siMain.G… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6535f1d1 | InsertButton | DMF0042_BizPlan_old.cs:1044 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9760090f | InsertButton | DMF0042_BizPlan_old.cs:1046 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-656afc53 | InsertButton | DMF0042_BizPlan_old.cs:1048 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b81cbeb2 | InsertButton | DMF0042_BizPlan_old.cs:1050 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9085d2e | InsertButton | DMF0042_BizPlan_old.cs:1052 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d4015ec | InsertButton | DMF0042_BizPlan_old.cs:1054 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-63ec3b4d | InsertButton | DMF0042_BizPlan_old.cs:1056 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowNo, siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8842c93 | InsertButton | DMF0042_BizPlan_old.cs:1058 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4cca7d7f | InsertButton | DMF0042_BizPlan_old.cs:1060 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowNo, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6926d782 | InsertButton | DMF0042_BizPlan_old.cs:1062 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e76d631 | InsertButton | DMF0042_BizPlan_old.cs:1064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowNo, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b95332b | InsertButton | DMF0042_BizPlan_old.cs:1072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-34d4b11b | InsertButton | DMF0042_BizPlan_old.cs:1074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a6d8f9db | InsertButton | DMF0042_BizPlan_old.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f75db34c | InsertButton | DMF0042_BizPlan_old.cs:1078 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e22e120 | InsertButton | DMF0042_BizPlan_old.cs:1080 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b7f5875 | InsertButton | DMF0042_BizPlan_old.cs:1082 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53e0a780 | InsertButton | DMF0042_BizPlan_old.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-17d5ade0 | InsertButton | DMF0042_BizPlan_old.cs:1086 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-580f8794 | InsertButton | DMF0042_BizPlan_old.cs:1088 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-566b2533 | InsertButton | DMF0042_BizPlan_old.cs:1090 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bcb3827b | InsertButton | DMF0042_BizPlan_old.cs:1092 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1de144c | InsertButton | DMF0042_BizPlan_old.cs:1094 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-450012a7 | InsertButton | DMF0042_BizPlan_old.cs:1098 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-2e9ac886 | InsertButton | DMF0042_BizPlan_old.cs:1099 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-99e27910 | InsertButton | DMF0042_BizPlan_old.cs:1105 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex()… | 그리드 편집 잠금/해제 |  |  |  |
| AC-37df1cc7 | InsertButton | DMF0042_BizPlan_old.cs:1115 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e62643b1 | InsertButton | DMF0042_BizPlan_old.cs:1121 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-84a04a3b | InsertButton | DMF0042_BizPlan_old.cs:1127 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-43e87048 | InsertButton | DMF0042_BizPlan_old.cs:1139 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_BizPlan_old.MinColumnChk

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-377e571f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 2 | DMF0042_BizPlan_old.cs:2555 | if (clbDivision.SelectedValue.ToString() == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetColumnIndex(DefCo… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a4960fb4 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 2 | DMF0042_BizPlan_old.cs:2568 | else of (clbDivision.SelectedValue.ToString() == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetColumnIndex(DefCo… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-acc46947 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 2 | DMF0042_BizPlan_old.cs:2582 | else of (clbDivision.SelectedValue.ToString() == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetColumnIndex(… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-06f4931c | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 2 | DMF0042_BizPlan_old.cs:2585 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.ParameterString

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f31d897a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan_old.cs:2378 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan_old.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5267270e | SaveButton | DMF0042_BizPlan_old.cs:696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd252de7 | SaveButton | DMF0042_BizPlan_old.cs:697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f27400f1 | SaveButton | DMF0042_BizPlan_old.cs:879 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ab8b2cd | SaveButton | DMF0042_BizPlan_old.cs:880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19a13ad0 | SaveButton | DMF0042_BizPlan_old.cs:885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93d7d485 | SaveButton | DMF0042_BizPlan_old.cs:886 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-457af747 | SaveButton | DMF0042_BizPlan_old.cs:893 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-2b46061f | SaveButton | DMF0042_BizPlan_old.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4c11fcc4 | SaveButton | DMF0042_BizPlan_old.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0c4caa5 | SaveButton | DMF0042_BizPlan_old.cs:895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | pDivision.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c800e55e | SaveButton | DMF0042_BizPlan_old.cs:895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDivision.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d419b3d | SaveButton | DMF0042_BizPlan_old.cs:896 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE"] | pProjectCode.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3bf6beeb | SaveButton | DMF0042_BizPlan_old.cs:896 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pProjectCode.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8367f2b | SaveButton | DMF0042_BizPlan_old.cs:897 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_NAME"] | pProjectName.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ad088b45 | SaveButton | DMF0042_BizPlan_old.cs:897 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pProjectName.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-79de7a02 | SaveButton | DMF0042_BizPlan_old.cs:898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | pScm_Site_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6a706d4a | SaveButton | DMF0042_BizPlan_old.cs:898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pScm_Site_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-116bfefe | SaveButton | DMF0042_BizPlan_old.cs:899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | pPlant_Site_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-62fe8875 | SaveButton | DMF0042_BizPlan_old.cs:899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPlant_Site_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d12cc6bd | SaveButton | DMF0042_BizPlan_old.cs:900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID"] | pItem_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-73d10042 | SaveButton | DMF0042_BizPlan_old.cs:900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pItem_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1933959 | SaveButton | DMF0042_BizPlan_old.cs:901 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DOM_EXP"] | pDom_Exp.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-d70cd16f | SaveButton | DMF0042_BizPlan_old.cs:901 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDom_Exp.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d781ed9b | SaveButton | DMF0042_BizPlan_old.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | pFcst_Type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-14f227b0 | SaveButton | DMF0042_BizPlan_old.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pFcst_Type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-23a2b4bc | SaveButton | DMF0042_BizPlan_old.cs:903 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | pIncoterms.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b28231d2 | SaveButton | DMF0042_BizPlan_old.cs:903 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pIncoterms.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a6071c8 | SaveButton | DMF0042_BizPlan_old.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE"] | pMeasure.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f0b33de9 | SaveButton | DMF0042_BizPlan_old.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pMeasure.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e49a7c7 | SaveButton | DMF0042_BizPlan_old.cs:905 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM"] | pYyyyMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4f6db67f | SaveButton | DMF0042_BizPlan_old.cs:905 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pYyyyMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-047cdcab | SaveButton | DMF0042_BizPlan_old.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY"] | pInput.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-43e8d17f | SaveButton | DMF0042_BizPlan_old.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pInput.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f25e4bd4 | SaveButton | DMF0042_BizPlan_old.cs:907 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY"] | pCurrency.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b8ee97db | SaveButton | DMF0042_BizPlan_old.cs:907 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCurrency.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-94a21251 | SaveButton | DMF0042_BizPlan_old.cs:910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DEPT_ID"] | p_DEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0a446cb0 | SaveButton | DMF0042_BizPlan_old.cs:910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_DEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5e66c90 | SaveButton | DMF0042_BizPlan_old.cs:911 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_END_CUSTOMER"] | p_END_CUSTOMER.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-9d50c558 | SaveButton | DMF0042_BizPlan_old.cs:911 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_END_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2713e52 | SaveButton | DMF0042_BizPlan_old.cs:912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_BIZ_TYPE"] | p_BIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2617340b | SaveButton | DMF0042_BizPlan_old.cs:912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_BIZ_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b9516cc | SaveButton | DMF0042_BizPlan_old.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PER_PACK"] | p_CELL_PER_PACK.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-57b0ea40 | SaveButton | DMF0042_BizPlan_old.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_CELL_PER_PACK.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2450b43a | SaveButton | DMF0042_BizPlan_old.cs:914 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PER_MODULE"] | p_CELL_PER_MODULE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-833033e5 | SaveButton | DMF0042_BizPlan_old.cs:914 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_CELL_PER_MODULE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1461d1bd | SaveButton | DMF0042_BizPlan_old.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MODULE_PER_PACK"] | p_MODULE_PER_PACK.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2ff32ff1 | SaveButton | DMF0042_BizPlan_old.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_MODULE_PER_PACK.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-33ac5510 | SaveButton | DMF0042_BizPlan_old.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7fd57254 | SaveButton | DMF0042_BizPlan_old.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcb6fd12 | SaveButton | DMF0042_BizPlan_old.cs:918 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-432da161 | SaveButton | DMF0042_BizPlan_old.cs:918 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4e8509d | SaveButton | DMF0042_BizPlan_old.cs:920 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a6db4c5 | SaveButton | DMF0042_BizPlan_old.cs:925 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-f29eb77b | SaveButton | DMF0042_BizPlan_old.cs:926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25492eba | SaveButton | DMF0042_BizPlan_old.cs:930 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_BizPlan_old.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt <= iCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e032f3d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0042_BizPlan_old.cs:2536 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0042_BizPlan_old.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Coun…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90b08ef2 | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:446 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-768528a9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:449 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d75353fa | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:454 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3acf9b48 | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:456 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5626b72a | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:459 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e91b80b5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:464 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-74e4ef9f | this.chkSum.CheckedChanged [if (siMain != null)] 외 9 | DMF0042_BizPlan_old.cs:466 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0042_BizPlan_old.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25778408 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:381 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5590bee3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:389 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e7386fc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:401 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7142e30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:402 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ab24584 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:407 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89b2e5ad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:408 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b618726 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:415 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88172794 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:416 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-237a4abc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:427 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cb30973 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:428 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3e3de3e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:429 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41e13934 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:430 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc7ff652 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:432 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8a742396 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan_old.cs:434 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_BizPlan_old.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00ec756f | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1307 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-77dd9254 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1313 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-0e1388c6 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1329 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-55d3e516 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1344 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53df7202 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1373 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-1d2ff56e | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1375 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2f31779b | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1376 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cf02af4c | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1377 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4272ac02 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1386 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-bd30404c | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1389 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-897d6ca6 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1391 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID40), sItemId) | 그리드 값 설정 |  |  |  |
| AC-7054ba23 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1393 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-181214cd | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1423 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e318787d | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1425 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-94789466 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1426 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2b6955c9 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1427 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7dbe3064 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1437 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) ▸ if (sProj… | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-5762bfdc | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1440 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) ▸ if (sProj… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-a2a0635e | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1442 | if ((e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CO…) ▸ if (sProj… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), sBizType) | 그리드 값 설정 |  |  |  |
| AC-68a10b2a | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1473 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-1a348271 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1475 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7dfec6b2 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1476 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-71ff0385 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1477 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eec7af11 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1487 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-663afa43 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1490 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME)… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-d8f6a485 | this.spdMain.CellDoubleClick | DMF0042_BizPlan_old.cs:1492 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), sBizType) | 그리드 값 설정 |  |  |  |

## DMF0042_BizPlan_old.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0de5d20d | dsdm.Changed | DMF0042_BizPlan_old.cs:1499 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0adfdc2 | dsdm.Changed | DMF0042_BizPlan_old.cs:1527 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2d0ff97 | dsdm.Changed | DMF0042_BizPlan_old.cs:1537 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f0b2eed | dsdm.Changed | DMF0042_BizPlan_old.cs:1541 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetValue | (e.Row, e.Column, strValue[0] + ".000") | 그리드 값 설정 |  |  |  |
| AC-28618ff4 | dsdm.Changed | DMF0042_BizPlan_old.cs:1542 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | MESSAGE | MessageHelper.GMessageBox | ("MSG00289") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da0f9c14 | dsdm.Changed | DMF0042_BizPlan_old.cs:1571 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Monthly && sColName.Ind… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e7d26456 | dsdm.Changed | DMF0042_BizPlan_old.cs:1598 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Monthly && sColName.Ind… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-0b661d59 | dsdm.Changed | DMF0042_BizPlan_old.cs:1675 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-dcb81213 | dsdm.Changed | DMF0042_BizPlan_old.cs:1681 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9b20e13d | dsdm.Changed | DMF0042_BizPlan_old.cs:1695 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-d25cb1ec | dsdm.Changed | DMF0042_BizPlan_old.cs:1701 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-35b29d66 | dsdm.Changed | DMF0042_BizPlan_old.cs:1722 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-e351f92a | dsdm.Changed | DMF0042_BizPlan_old.cs:1745 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9d15edca | dsdm.Changed | DMF0042_BizPlan_old.cs:1755 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iSetCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2f577299 | dsdm.Changed | DMF0042_BizPlan_old.cs:1787 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-60dc7a30 | dsdm.Changed | DMF0042_BizPlan_old.cs:1870 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d9c2cb62 | dsdm.Changed | DMF0042_BizPlan_old.cs:1876 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ac01e637 | dsdm.Changed | DMF0042_BizPlan_old.cs:1889 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-2560bdfb | dsdm.Changed | DMF0042_BizPlan_old.cs:1895 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-e676e577 | dsdm.Changed | DMF0042_BizPlan_old.cs:1917 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-497aa14f | dsdm.Changed | DMF0042_BizPlan_old.cs:1952 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6a221cd7 | dsdm.Changed | DMF0042_BizPlan_old.cs:1957 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-72ac1144 | dsdm.Changed | DMF0042_BizPlan_old.cs:1986 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Monthly && sColNam… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0042_BizPlan_old.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce9a6063 | this.spdMain.EditChange | DMF0042_BizPlan_old.cs:2245 | if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfc651a3 | this.spdMain.EditChange | DMF0042_BizPlan_old.cs:2247 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_BizPlan_old.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3da64b0f | this.spdMain.TopChange | DMF0042_BizPlan_old.cs:2011 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_BizPlan_old.ValidationCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4d63a09 | (진입점 미연결) | DMF0042_BizPlan_old.cs:2000 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f7af383 | (진입점 미연결) | DMF0042_BizPlan_old.cs:2003 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-b31d361a | (진입점 미연결) | DMF0042_BizPlan_old.cs:2005 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_BizPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bd081df | this.btnColumn.Click | DMF0042_BizPlan.cs:2872 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-04193147 | this.btnColumn.Click | DMF0042_BizPlan.cs:2873 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2192f7dd | this.btnColumn.Click | DMF0042_BizPlan.cs:2874 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2d244e2 | this.btnCutOff.Click | DMF0042_BizPlan.cs:2907 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-fd82cce3 | this.btnCutOff.Click | DMF0042_BizPlan.cs:2908 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fc13635 | this.btnCutOff.Click | DMF0042_BizPlan.cs:2915 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-d57cb385 | this.btnCutOff.Click | DMF0042_BizPlan.cs:2920 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dcef959 | this.btnCutOff.Click | DMF0042_BizPlan.cs:2922 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-90bb9dc9 | this.btnCutOff.Click | DMF0042_BizPlan.cs:2923 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdc6acfc | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3052 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8067001 | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3053 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d42edadf | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3056 |  | POPUP | new POPUP.DMF0042_ExchangeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-9244f207 | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3057 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP", clbDivisi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-db163230 | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3059 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6513cf9e | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3060 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3d9659fc | this.btnExchangeRate.Click | DMF0042_BizPlan.cs:3064 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_BizPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb1fba0c | this.btnItemId.Click | DMF0042_BizPlan.cs:2856 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-74b7325e | this.btnItemId.Click | DMF0042_BizPlan.cs:2858 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-844f6674 | this.btnItemId.Click | DMF0042_BizPlan.cs:2859 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3d8752a0 | this.btnItemId.Click | DMF0042_BizPlan.cs:2860 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f1412818 | this.btnItemId.Click | DMF0042_BizPlan.cs:2866 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0042_BizPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eac4f6d | this.btnMeasure.Click | DMF0042_BizPlan.cs:2884 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0042", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-d63e9979 | this.btnMeasure.Click | DMF0042_BizPlan.cs:2886 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2ffaf970 | this.btnMeasure.Click | DMF0042_BizPlan.cs:2887 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d5a7ce0 | this.btnOwner.Click | DMF0042_BizPlan.cs:3016 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e14e73d6 | this.btnOwner.Click | DMF0042_BizPlan.cs:3019 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-32601438 | this.btnOwner.Click | DMF0042_BizPlan.cs:3020 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-112b2fd0 | this.btnOwner.Click | DMF0042_BizPlan.cs:3021 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c8d28e81 | this.btnOwner.Click | DMF0042_BizPlan.cs:3023 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0042_BizPlan.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f0a0a10 | this.btnProject.Click 외 1 | DMF0042_BizPlan.cs:2834 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3c4c814d | this.btnProject.Click 외 1 | DMF0042_BizPlan.cs:2835 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-01e40adf | this.btnProject.Click 외 1 | DMF0042_BizPlan.cs:2836 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-88e3a169 | this.btnProject.Click 외 1 | DMF0042_BizPlan.cs:2837 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-03fbfae2 | this.btnProject.Click 외 1 | DMF0042_BizPlan.cs:2843 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0042_BizPlan.btnReplace_Click

진입점: this.btnReplace.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86a3d0b8 | this.btnReplace.Click | DMF0042_BizPlan.cs:3474 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-d81874e2 | this.btnReplace.Click | DMF0042_BizPlan.cs:3475 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efbbfb1e | this.btnReplace.Click | DMF0042_BizPlan.cs:3482 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-b3013c68 | this.btnReplace.Click | DMF0042_BizPlan.cs:3483 | if (GroupId != "ADMIN" && GroupId != "DM ADMIN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18eb446c | this.btnReplace.Click | DMF0042_BizPlan.cs:3488 |  | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98553c32 | this.btnReplace.Click | DMF0042_BizPlan.cs:3492 |  | DATA_OP | dt.Columns.Add | ("YYYYMM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da9b6b5f | this.btnReplace.Click | DMF0042_BizPlan.cs:3496 | if (spdMain.Sheets[0].RowCount == 0) | MESSAGE | MessageBox.Show | ("데이터 조회 후 다시 시도해 주시기 바랍니다.") | 메시지 표시 |  |  |  |
| AC-fbb3b54f | this.btnReplace.Click | DMF0042_BizPlan.cs:3497 | if (spdMain.Sheets[0].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8481bca | this.btnReplace.Click | DMF0042_BizPlan.cs:3516 | else of (cr == null) ▸ for (i <= ColEnd) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9753d0f8 | this.btnReplace.Click | DMF0042_BizPlan.cs:3520 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | row["YYYYMM"] | colTag.Substring(2, 6).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a1c7983 | this.btnReplace.Click | DMF0042_BizPlan.cs:3521 | else of (cr == null) ▸ for (i <= ColEnd) ▸ if (colTag.Substring(0, 2) == "M_") | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c73ea3 | this.btnReplace.Click | DMF0042_BizPlan.cs:3549 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-c852b34a | this.btnReplace.Click | DMF0042_BizPlan.cs:3553 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-90e54206 | this.btnReplace.Click | DMF0042_BizPlan.cs:3555 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39eb8404 | this.btnReplace.Click | DMF0042_BizPlan.cs:3556 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0042_BizPlan.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1714ff65 | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3180 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00282") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb0f7da0 | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3181 | if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2f5f322 | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3187 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | 엔드포인트 요청 생성 |  |  |  |
| AC-b5573a16 | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3189 |  | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3be053e2 | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3191 |  | DATA_OP | request.Parameters["s_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ccda92a | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3192 |  | DATA_OP | request.Parameters["s_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-79fffbf4 | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3193 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-857cf04e | this.btnSetPrice.Click | DMF0042_BizPlan.cs:3196 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_BizPlan.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94de95ae | this.cboBucketType.Click | DMF0042_BizPlan.cs:3032 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c0109f2 | this.cboBucketType.Click | DMF0042_BizPlan.cs:3033 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23eb76bd | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1493 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-44f571dc | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1493 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92e5c429 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1494 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad0149e1 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1502 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ac40d703 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1502 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f84f958 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1503 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-74bdb0d6 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1505 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-85a47739 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1505 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3aecbb83 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1507 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4115a625 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1508 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1da3b9fd | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1509 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f9b371ae | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1510 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-d2bf3608 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1510 | if (sDivision != null & sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66466266 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1514 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-56cb71c0 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1515 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-39cc6248 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1517 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-97b2c09a | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1517 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dbd9dd83 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1519 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-00d9da2f | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1520 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-08136d28 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1521 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6dbb12e7 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1523 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-ea45f9d9 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1523 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4cfbf8d9 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1527 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-21decf38 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1528 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-84adfc15 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1530 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a1edd37f | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1530 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb11e1fd | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1532 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0c3e8182 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1533 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bb54d346 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1534 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-40d2e6c4 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1536 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-7a698164 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1536 | if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3366ec1b | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1540 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f8237a25 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1542 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1c3b0e40 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1545 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b787634e | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1545 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47391a51 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1546 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-337fbe28 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1548 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-d81c22dc | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1548 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f39f9d81 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1549 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-984a5a19 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1551 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-15d2e98d | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1552 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-561ffa3d | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1554 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-9d0607e7 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1556 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-c9074cff | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1557 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9adbfc81 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1560 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b99cf43 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1561 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9efe76ed | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1563 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-3dc4c88d | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1563 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a666a196 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1565 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bdfd3c9f | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1567 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a06421f5 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1568 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e07360f2 | clbDivision.SelectedIndexChanged | DMF0042_BizPlan.cs:1569 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0042_BizPlan.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd3fa533 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan.cs:1603 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e35b97e8 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan.cs:1603 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-435830af | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan.cs:1607 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-56ac862e | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan.cs:1607 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c32deae3 | this.clbCustomer.SelectedIndexChanged | DMF0042_BizPlan.cs:1609 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_BizPlan.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02f757c0 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1581 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b7e8fbd | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1581 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d86db068 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1582 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0dccb36d | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1584 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-937c3ac6 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1584 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54d890df | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1588 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-9f6ff59b | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1588 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1085846 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1589 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f12c38ce | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1591 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-86706cb7 | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1591 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d83f94f | this.clbTeam.SelectedIndexChanged | DMF0042_BizPlan.cs:1595 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0042_BizPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-214bfa7b | this.Load | DMF0042_BizPlan.cs:378 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b81c81b | this.Load | DMF0042_BizPlan.cs:379 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2fe79bdc | this.Load | DMF0042_BizPlan.cs:380 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_BizPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bc62b34 | this.Load | DMF0042_BizPlan.cs:341 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-64c33612 | this.Load | DMF0042_BizPlan.cs:343 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-bbe5af13 | this.Load | DMF0042_BizPlan.cs:345 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-33f69244 | this.Load | DMF0042_BizPlan.cs:346 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-fba4dee9 | this.Load | DMF0042_BizPlan.cs:347 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-55c26dc7 | this.Load | DMF0042_BizPlan.cs:348 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-67cee340 | this.Load | DMF0042_BizPlan.cs:358 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6281fafc | this.Load | DMF0042_BizPlan.cs:359 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-16364a09 | this.Load | DMF0042_BizPlan.cs:363 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48b8bb1a | this.Load | DMF0042_BizPlan.cs:364 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0042_BizPlan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-099935e3 | DeleteButton | DMF0042_BizPlan.cs:552 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65a342f8 | DeleteButton | DMF0042_BizPlan.cs:558 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-c8b21146 | DeleteButton | DMF0042_BizPlan.cs:559 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_BizPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d53c7cd | Dispose | DMF0042_BizPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_BizPlan.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e92cb04 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:576 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-33f53997 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:577 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6d5b8e15 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:585 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-330631cc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:593 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (siMain.… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c6a5a5b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:601 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e368e9dc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:609 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce959fa7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:614 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-58f201bf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:621 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93728ef5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:629 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d5a0538 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:634 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b943f07 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:649 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a9696042 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:680 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") \|\| (s… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-42db5b7c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:688 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") \|… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ccb85693 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0042_BizPlan.cs:694 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!IsEditMode) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_BizPlan.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49132d97 | ExcelButton | DMF0042_BizPlan.cs:711 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-a2ce7aeb | ExcelButton | DMF0042_BizPlan.cs:712 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-8ff8db5e | ExcelButton | DMF0042_BizPlan.cs:713 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-ebc2717a | ExcelButton | DMF0042_BizPlan.cs:714 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-ca4b89a4 | ExcelButton | DMF0042_BizPlan.cs:715 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-9f38a648 | ExcelButton | DMF0042_BizPlan.cs:716 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-6f050988 | ExcelButton | DMF0042_BizPlan.cs:718 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-9a199099 | ExcelButton | DMF0042_BizPlan.cs:719 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-bbce28c9 | ExcelButton | DMF0042_BizPlan.cs:721 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-1586c0b6 | ExcelButton | DMF0042_BizPlan.cs:725 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78d3f6f3 | ExcelButton | DMF0042_BizPlan.cs:730 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-a7f9059c | ExcelButton | DMF0042_BizPlan.cs:734 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_BizPlan.FindData

진입점: this.btnSetPrice.Click / this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be7d9c4 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:749 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-907b02fc | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:758 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec29c7b4 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:759 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05afb293 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:766 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-48688975 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:767 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ce8bc85 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:772 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00276") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b629976c | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:773 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(6) | 속성 Value2 설정 |  |  |  |
| AC-afd2d242 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:774 | try ▸ if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7d56658 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:779 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9313482e | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:781 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d104b1b4 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:786 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3ae0d2bb | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:789 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-629f483e | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:796 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a495bb3 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:800 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA") ⇒ DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-9dbb544b | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:802 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1ec22f38 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:804 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d367b696 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:805 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4182ed84 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:806 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8d06dc05 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:807 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0a5de82f | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:808 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-389e0bde | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:809 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-21ea43be | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:810 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0a49931c | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:811 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-9aedb20f | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:812 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-120f531f | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:813 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-36729e7f | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:814 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-94a4cdd9 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:815 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-188df462 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:816 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5825a2a7 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:817 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f85090ce | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:818 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-9c22cd88 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:819 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-73bdca72 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:821 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4450469 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:823 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-369babee | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:828 | try | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-87b51685 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:829 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c817c070 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:833 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | valid_YN | ds.Tables[1].Rows[0]["VALID_YN"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4ea2fd39 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:834 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYQQ | ds.Tables[1].Rows[0]["START_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d4410591 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:835 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYQQ | ds.Tables[1].Rows[0]["END_YYYYQQ"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4a5c841 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:836 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYYMM | ds.Tables[1].Rows[0]["START_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e31f7de5 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:837 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYYMM | ds.Tables[1].Rows[0]["END_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bada4455 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:838 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | start_YYYY | ds.Tables[1].Rows[0]["START_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3bb2a6d8 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:839 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | end_YYYY | ds.Tables[1].Rows[0]["END_YYYY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-68eef12c | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:842 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72042d4b | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:847 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-77561b48 | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:851 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23b14d1f | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:855 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1fc7740d | this.btnSetPrice.Click 외 3 | DMF0042_BizPlan.cs:857 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0042_BizPlan.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea912bd3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3336 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-3a73c7a2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3339 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e87102bc | this.Load | DMF0042_BizPlan.cs:225 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c3288cb | this.Load | DMF0042_BizPlan.cs:226 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_BizPlan.GetBizTypebyDivision

진입점: this.Load [if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")] / clbDivision.SelectedIndexChanged [if (sDivision != null & sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8b53b4c | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_BizPlan.cs:2983 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-04236784 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_BizPlan.cs:2984 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fd8b7859 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_BizPlan.cs:2985 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c96779f2 | this.Load [if (sDivision != null && sDivision != "") ▸ else … 외 1 | DMF0042_BizPlan.cs:2987 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) \|\| (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == e.Column))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae2158d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_BizPlan.cs:3350 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ee87610 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan.cs:3140 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee16dedf | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan.cs:3141 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f575b6c7 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan.cs:3128 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-2ad9ed93 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0042_BizPlan.cs:3133 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetCellProdSite

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)] / this.btnSetPrice.Click [try ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefCol…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6413b79c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3457 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-db288367 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3458 |  | DATA_OP | request.Parameters["CODE"] | sCode | 행/컬럼 값 대입 |  |  |  |
| AC-3d525a26 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3459 |  | DATA_OP | request.Parameters["PARAM1"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-18c6602b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3460 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6dcb2594 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3461 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ca6d673 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3462 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-370334cc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3463 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-817ebfe0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3464 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4eb41e07 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | DMF0042_BizPlan.cs:3466 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e6d3041 | this.Load 외 1 | DMF0042_BizPlan.cs:2937 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-f481df6c | this.Load 외 1 | DMF0042_BizPlan.cs:2938 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-79f657c4 | this.Load 외 1 | DMF0042_BizPlan.cs:2939 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-e56c746a | this.Load 외 1 | DMF0042_BizPlan.cs:2941 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-218d18f2 | this.Load 외 1 | DMF0042_BizPlan.cs:2944 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f54a1860 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan.cs:3078 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_EXCHANGE_PRICE") ⇒ DM.DMF0042_GET_EXCHANGE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-1a20520d | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan.cs:3079 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-a2ca24a5 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan.cs:3080 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-bab08541 | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan.cs:3081 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2e47abc | this.btnExchangeRate.Click [if (popup.blnOK)] | DMF0042_BizPlan.cs:3083 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetLookupData

진입점: this.Load / clbDivision.SelectedIndexChanged / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0164ea37 | this.Load 외 2 | DMF0042_BizPlan.cs:2970 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-b5edbfdd | this.Load 외 2 | DMF0042_BizPlan.cs:2971 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-59ddb6a6 | this.Load 외 2 | DMF0042_BizPlan.cs:2972 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd9a8b19 | this.Load 외 2 | DMF0042_BizPlan.cs:2974 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f61d5c93 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2953 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_GET_SPREAD_TITLE") ⇒ DM.DMF0042_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-07cb460e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2955 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-b57192ea | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2956 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-7a8104c3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2957 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f62f1c61 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2958 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-fc6c63ef | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2960 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f2ca633a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:2960 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0042_BizPlan.GetThisWeekMonday

진입점: this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08fc9106 | this.btnSetPrice.Click [try] 외 3 | DMF0042_BizPlan.cs:3104 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e685b074 | this.Load | DMF0042_BizPlan.cs:248 |  | DATA_OP | this.ConditionNotUseList.Add | (cboClosed) | 데이터 객체 조작/조회 |  |  |  |
| AC-21dd5888 | this.Load | DMF0042_BizPlan.cs:250 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-832123f4 | this.Load | DMF0042_BizPlan.cs:250 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1deeabde | this.Load | DMF0042_BizPlan.cs:251 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-537784b4 | this.Load | DMF0042_BizPlan.cs:254 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-3944101a | this.Load | DMF0042_BizPlan.cs:254 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8dc45b4b | this.Load | DMF0042_BizPlan.cs:255 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-993bb30e | this.Load | DMF0042_BizPlan.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtYn, cboClosed, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cf2ecd4e | this.Load | DMF0042_BizPlan.cs:268 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5db64b5d | this.Load | DMF0042_BizPlan.cs:268 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eea82080 | this.Load | DMF0042_BizPlan.cs:269 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c4652255 | this.Load | DMF0042_BizPlan.cs:271 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-2cc10094 | this.Load | DMF0042_BizPlan.cs:271 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99adea76 | this.Load | DMF0042_BizPlan.cs:273 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-712ca8f9 | this.Load | DMF0042_BizPlan.cs:274 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ed84c495 | this.Load | DMF0042_BizPlan.cs:275 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ab26de60 | this.Load | DMF0042_BizPlan.cs:276 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-94c5a0a8 | this.Load | DMF0042_BizPlan.cs:276 | if (sDivision != null && sDivision != "") ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0d450fa | this.Load | DMF0042_BizPlan.cs:280 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd44ff05 | this.Load | DMF0042_BizPlan.cs:281 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-52ce9996 | this.Load | DMF0042_BizPlan.cs:283 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d8247468 | this.Load | DMF0042_BizPlan.cs:283 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fec0f52c | this.Load | DMF0042_BizPlan.cs:285 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-02eac006 | this.Load | DMF0042_BizPlan.cs:286 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7db24722 | this.Load | DMF0042_BizPlan.cs:287 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6ccafd21 | this.Load | DMF0042_BizPlan.cs:289 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e6220be6 | this.Load | DMF0042_BizPlan.cs:289 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ if (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e7d5be70 | this.Load | DMF0042_BizPlan.cs:294 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec4dbf51 | this.Load | DMF0042_BizPlan.cs:295 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-743fd845 | this.Load | DMF0042_BizPlan.cs:297 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c35fc663 | this.Load | DMF0042_BizPlan.cs:297 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-faf7cf65 | this.Load | DMF0042_BizPlan.cs:299 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4cc540a1 | this.Load | DMF0042_BizPlan.cs:300 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b129496f | this.Load | DMF0042_BizPlan.cs:301 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e51e0b5e | this.Load | DMF0042_BizPlan.cs:303 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-734791d5 | this.Load | DMF0042_BizPlan.cs:303 | if (sDivision != null && sDivision != "") ▸ else of (sDivision == "40") ▸ else of (sDivision.Substring(0, 2) == "81") | COMBO_DATA | Data.Common | (Data.Type.DMF0042_BP_Measure, false, "82", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0042_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f82c5c1a | this.Load | DMF0042_BizPlan.cs:307 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e7f2d5ac | this.Load | DMF0042_BizPlan.cs:309 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-341a9518 | this.Load | DMF0042_BizPlan.cs:312 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba4954d8 | this.Load | DMF0042_BizPlan.cs:312 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7901e20b | this.Load | DMF0042_BizPlan.cs:313 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e36f0e39 | this.Load | DMF0042_BizPlan.cs:316 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-0f90036c | this.Load | DMF0042_BizPlan.cs:316 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-059f12b8 | this.Load | DMF0042_BizPlan.cs:317 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ece6d668 | this.Load | DMF0042_BizPlan.cs:319 |  | FLAG | dtBucketType | GetLookupData("BUCKET2_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-077b0236 | this.Load | DMF0042_BizPlan.cs:320 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-20f38ac5 | this.Load | DMF0042_BizPlan.cs:322 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-0c335768 | this.Load | DMF0042_BizPlan.cs:324 |  | FLAG | dtItemType | GetLookupData("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-0b2d6b57 | this.Load | DMF0042_BizPlan.cs:325 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b14fd1c8 | this.Load | DMF0042_BizPlan.cs:328 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ea7a84c | this.Load | DMF0042_BizPlan.cs:329 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3d04c23 | this.Load | DMF0042_BizPlan.cs:331 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-5925addf | this.Load | DMF0042_BizPlan.cs:331 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8e2640c | this.Load | DMF0042_BizPlan.cs:333 |  | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5a8f2ebb | this.Load | DMF0042_BizPlan.cs:335 |  | UI_PROP | lblBucket1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a7a43b9e | this.Load | DMF0042_BizPlan.cs:336 |  | STATE | cboClosed.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0042_BizPlan.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e1bd78d | this.Load 외 1 | DMF0042_BizPlan.cs:526 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-a3934a63 | this.Load 외 1 | DMF0042_BizPlan.cs:527 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7626fbff | this.Load 외 1 | DMF0042_BizPlan.cs:528 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac4ded0 | this.Load 외 1 | DMF0042_BizPlan.cs:531 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-6f27b033 | this.Load 외 1 | DMF0042_BizPlan.cs:532 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_BizPlan.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnSetPrice.Click [try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b849b5e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:389 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0042_BizPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0c6f739 | InsertButton | DMF0042_BizPlan.cs:1218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-0424a7e8 | InsertButton | DMF0042_BizPlan.cs:1220 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasure.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfcbaa17 | InsertButton | DMF0042_BizPlan.cs:1233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-5ec99c48 | InsertButton | DMF0042_BizPlan.cs:1233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2f513639 | InsertButton | DMF0042_BizPlan.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a1298bf5 | InsertButton | DMF0042_BizPlan.cs:1239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8d929f5e | InsertButton | DMF0042_BizPlan.cs:1241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2e5075e2 | InsertButton | DMF0042_BizPlan.cs:1243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID40… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-bf7230e9 | InsertButton | DMF0042_BizPlan.cs:1245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c54d99ef | InsertButton | DMF0042_BizPlan.cs:1248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a027a524 | InsertButton | DMF0042_BizPlan.cs:1249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41028e31 | InsertButton | DMF0042_BizPlan.cs:1252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bd9b15d | InsertButton | DMF0042_BizPlan.cs:1255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID40), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8e9a3895 | InsertButton | DMF0042_BizPlan.cs:1257 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision != "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ad924f01 | InsertButton | DMF0042_BizPlan.cs:1259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-960291f3 | InsertButton | DMF0042_BizPlan.cs:1261 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-59fff678 | InsertButton | DMF0042_BizPlan.cs:1263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-74f778bd | InsertButton | DMF0042_BizPlan.cs:1265 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-24990d8c | InsertButton | DMF0042_BizPlan.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4042ba94 | InsertButton | DMF0042_BizPlan.cs:1269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-04a218f2 | InsertButton | DMF0042_BizPlan.cs:1271 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), dtBizType81) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c1f1a356 | InsertButton | DMF0042_BizPlan.cs:1277 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" && siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE), GetCellProdSite(… ⇒ DM.UP_FX_GetCommonDataList_DM | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-69f8d668 | InsertButton | DMF0042_BizPlan.cs:1285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-cc39551a | InsertButton | DMF0042_BizPlan.cs:1286 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-df769502 | InsertButton | DMF0042_BizPlan.cs:1293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef6ee78f | InsertButton | DMF0042_BizPlan.cs:1297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b344203 | InsertButton | DMF0042_BizPlan.cs:1299 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d35986f8 | InsertButton | DMF0042_BizPlan.cs:1301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d654560 | InsertButton | DMF0042_BizPlan.cs:1303 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ac3fbb0 | InsertButton | DMF0042_BizPlan.cs:1305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), iRowNo, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b8774163 | InsertButton | DMF0042_BizPlan.cs:1309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a23ef06f | InsertButton | DMF0042_BizPlan.cs:1311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-284a2eed | InsertButton | DMF0042_BizPlan.cs:1313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0be4763b | InsertButton | DMF0042_BizPlan.cs:1315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f1fb8163 | InsertButton | DMF0042_BizPlan.cs:1317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6951292 | InsertButton | DMF0042_BizPlan.cs:1319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e7a540b | InsertButton | DMF0042_BizPlan.cs:1323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f646d50 | InsertButton | DMF0042_BizPlan.cs:1326 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), iRowNo, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3909593 | InsertButton | DMF0042_BizPlan.cs:1328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), iRowNo, siMain.Get… | 그리드 편집 잠금/해제 |  |  |  |
| AC-95596a24 | InsertButton | DMF0042_BizPlan.cs:1330 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowNo, siMain.G… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1fdc7cf7 | InsertButton | DMF0042_BizPlan.cs:1332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ba4baa1 | InsertButton | DMF0042_BizPlan.cs:1334 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bd10a62a | InsertButton | DMF0042_BizPlan.cs:1336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-21f8b55d | InsertButton | DMF0042_BizPlan.cs:1338 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a95b573 | InsertButton | DMF0042_BizPlan.cs:1340 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cef2348b | InsertButton | DMF0042_BizPlan.cs:1342 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-13cb564c | InsertButton | DMF0042_BizPlan.cs:1344 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowNo, siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ecc8208 | InsertButton | DMF0042_BizPlan.cs:1346 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowNo, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e2862ecb | InsertButton | DMF0042_BizPlan.cs:1348 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowNo, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae4d1b3a | InsertButton | DMF0042_BizPlan.cs:1350 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-10a100df | InsertButton | DMF0042_BizPlan.cs:1352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowNo, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a18294b6 | InsertButton | DMF0042_BizPlan.cs:1360 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9e135b3 | InsertButton | DMF0042_BizPlan.cs:1362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dbb4b56d | InsertButton | DMF0042_BizPlan.cs:1364 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d4a9de37 | InsertButton | DMF0042_BizPlan.cs:1366 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2799fadc | InsertButton | DMF0042_BizPlan.cs:1368 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ad8b647 | InsertButton | DMF0042_BizPlan.cs:1370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc2e9975 | InsertButton | DMF0042_BizPlan.cs:1372 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ae0b54d | InsertButton | DMF0042_BizPlan.cs:1374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e534394 | InsertButton | DMF0042_BizPlan.cs:1376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-98a527c1 | InsertButton | DMF0042_BizPlan.cs:1378 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e3ea6d0 | InsertButton | DMF0042_BizPlan.cs:1380 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1aed87ff | InsertButton | DMF0042_BizPlan.cs:1382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-980652e6 | InsertButton | DMF0042_BizPlan.cs:1386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c75dc86 | InsertButton | DMF0042_BizPlan.cs:1388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRowNo, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e5ead0a | InsertButton | DMF0042_BizPlan.cs:1391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-066751c3 | InsertButton | DMF0042_BizPlan.cs:1392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5afe668 | InsertButton | DMF0042_BizPlan.cs:1399 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex()… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f055051f | InsertButton | DMF0042_BizPlan.cs:1409 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d808ca0d | InsertButton | DMF0042_BizPlan.cs:1417 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc23afef | InsertButton | DMF0042_BizPlan.cs:1425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f404c19 | InsertButton | DMF0042_BizPlan.cs:1433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86614ddb | InsertButton | DMF0042_BizPlan.cs:1438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aded7953 | InsertButton | DMF0042_BizPlan.cs:1445 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-029f7009 | InsertButton | DMF0042_BizPlan.cs:1453 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-db4fab3e | InsertButton | DMF0042_BizPlan.cs:1458 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4709a415 | InsertButton | DMF0042_BizPlan.cs:1469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count… | GRID_LOCK | siMain.LockRange | (iRowNo, iCol, iRowNo, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-af2ec5da | InsertButton | DMF0042_BizPlan.cs:1475 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_BizPlan.MinColumnChk

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87be5e33 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3408 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d4818e77 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3425 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4e65ecf6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3444 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-269d02bc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3447 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.ParameterString

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex() - 1) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (i != iLOCRow)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bdbf195 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0042_BizPlan.cs:3175 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0042_BizPlan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-878ef64d | SaveButton | DMF0042_BizPlan.cs:871 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06b1e546 | SaveButton | DMF0042_BizPlan.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d70aa44 | SaveButton | DMF0042_BizPlan.cs:973 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3c5d402 | SaveButton | DMF0042_BizPlan.cs:974 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fb4118d | SaveButton | DMF0042_BizPlan.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d01f4b3e | SaveButton | DMF0042_BizPlan.cs:1005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c03ce3df | SaveButton | DMF0042_BizPlan.cs:1028 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00310") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4d9a14c | SaveButton | DMF0042_BizPlan.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38e576fb | SaveButton | DMF0042_BizPlan.cs:1148 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ed07173 | SaveButton | DMF0042_BizPlan.cs:1149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4072b303 | SaveButton | DMF0042_BizPlan.cs:1154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c190267 | SaveButton | DMF0042_BizPlan.cs:1155 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f36b058e | SaveButton | DMF0042_BizPlan.cs:1162 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_PLN_BP_FCST") ⇒ DM.DMF0042_SAVE_DM_PLN_BP_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-0cf4eb2f | SaveButton | DMF0042_BizPlan.cs:1163 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-965d727c | SaveButton | DMF0042_BizPlan.cs:1163 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-98de4f63 | SaveButton | DMF0042_BizPlan.cs:1164 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | pDivision.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c120b962 | SaveButton | DMF0042_BizPlan.cs:1164 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pDivision.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeca85e1 | SaveButton | DMF0042_BizPlan.cs:1165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE"] | pProjectCode.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3b2a85dd | SaveButton | DMF0042_BizPlan.cs:1165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pProjectCode.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4845560 | SaveButton | DMF0042_BizPlan.cs:1166 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_NAME"] | pProjectName.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-403980a3 | SaveButton | DMF0042_BizPlan.cs:1166 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pProjectName.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-048cbbda | SaveButton | DMF0042_BizPlan.cs:1167 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | pScm_Site_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0eeaf076 | SaveButton | DMF0042_BizPlan.cs:1167 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pScm_Site_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b9f6912 | SaveButton | DMF0042_BizPlan.cs:1168 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | pPlant_Site_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-180c237c | SaveButton | DMF0042_BizPlan.cs:1168 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pPlant_Site_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-abb86306 | SaveButton | DMF0042_BizPlan.cs:1169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID"] | pItem_Id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f4fe469a | SaveButton | DMF0042_BizPlan.cs:1169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pItem_Id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-68a92615 | SaveButton | DMF0042_BizPlan.cs:1171 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | pFcst_Type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-12c29bcf | SaveButton | DMF0042_BizPlan.cs:1171 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pFcst_Type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b19979c | SaveButton | DMF0042_BizPlan.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | pIncoterms.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-e353d892 | SaveButton | DMF0042_BizPlan.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pIncoterms.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-54ceaa89 | SaveButton | DMF0042_BizPlan.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE"] | pMeasure.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a0949531 | SaveButton | DMF0042_BizPlan.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pMeasure.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c02f9a0 | SaveButton | DMF0042_BizPlan.cs:1174 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM"] | pYyyyMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a2a3dccc | SaveButton | DMF0042_BizPlan.cs:1174 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pYyyyMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e78a46f3 | SaveButton | DMF0042_BizPlan.cs:1175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY"] | pInput.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-23114b12 | SaveButton | DMF0042_BizPlan.cs:1175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pInput.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8c1dd88 | SaveButton | DMF0042_BizPlan.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY"] | pCurrency.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2738ba25 | SaveButton | DMF0042_BizPlan.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCurrency.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b2206ff | SaveButton | DMF0042_BizPlan.cs:1179 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DEPT_ID"] | p_DEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ae83b9b7 | SaveButton | DMF0042_BizPlan.cs:1179 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_DEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-df34399a | SaveButton | DMF0042_BizPlan.cs:1180 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_END_CUSTOMER"] | p_END_CUSTOMER.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3ac13379 | SaveButton | DMF0042_BizPlan.cs:1180 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_END_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e969819c | SaveButton | DMF0042_BizPlan.cs:1181 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_BIZ_TYPE"] | p_BIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-60d9d5b4 | SaveButton | DMF0042_BizPlan.cs:1181 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_BIZ_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc7079e7 | SaveButton | DMF0042_BizPlan.cs:1187 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_USE"] | p_ITEM_USE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-76c0092c | SaveButton | DMF0042_BizPlan.cs:1187 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_ITEM_USE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e64fee33 | SaveButton | DMF0042_BizPlan.cs:1188 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_UNIT_ENERGY"] | p_UNIT_ENERGY.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-481b2219 | SaveButton | DMF0042_BizPlan.cs:1188 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | p_UNIT_ENERGY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f8e188 | SaveButton | DMF0042_BizPlan.cs:1189 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | pCell_Prod_Site.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-55c23338 | SaveButton | DMF0042_BizPlan.cs:1189 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pCell_Prod_Site.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e6602ea | SaveButton | DMF0042_BizPlan.cs:1191 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4d115d9b | SaveButton | DMF0042_BizPlan.cs:1191 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd6e911f | SaveButton | DMF0042_BizPlan.cs:1192 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | pUserID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-1dc2edbd | SaveButton | DMF0042_BizPlan.cs:1192 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | pUserID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbc85b8b | SaveButton | DMF0042_BizPlan.cs:1194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a533f6f | SaveButton | DMF0042_BizPlan.cs:1199 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-a1f7f7b6 | SaveButton | DMF0042_BizPlan.cs:1200 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec2d1c5e | SaveButton | DMF0042_BizPlan.cs:1204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_BizPlan.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt == iCheck)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= dtMeasure.Rows.Count - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d72478d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0042_BizPlan.cs:3359 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0042_BizPlan.SetComboCol

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)] / this.btnSetPrice.Click [try ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefCol…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea96bc87 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3370 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-10839331 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3371 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb48db79 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3375 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-87e687d8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3376 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-f251aa74 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3377 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-99ff59e6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3378 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-dccccc66 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:3382 |  | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |

## DMF0042_BizPlan.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivisio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcce4a61 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:499 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bc08b8f5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:502 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-21aaad81 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:507 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e6177f70 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:509 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2f56b8a9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:512 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f188be2f | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:517 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-33f206de | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | DMF0042_BizPlan.cs:519 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0042_BizPlan.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnSetPrice.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7969edd2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:434 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-baf4dccd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:442 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f31cd39a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:454 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afa64bb8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:455 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d69f77bf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:460 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48897a13 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:461 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8037c6b7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:468 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-415582fc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:469 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e1c13c1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:480 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b70c0000 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:481 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05a4236b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:482 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15e00669 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:483 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03cdb907 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:485 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5fe0ff66 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0042_BizPlan.cs:487 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_BizPlan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-092d5797 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1671 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-b5b0b4bb | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1677 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-bdf0712a | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1693 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-25951dd9 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1708 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee778906 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1739 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-dc4ec442 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1741 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f8c6f476 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1742 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-041ed8a0 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1743 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b2277775 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1752 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-013e5402 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1755 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-67679f07 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1757 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID40), sItemId) | 그리드 값 설정 |  |  |  |
| AC-dbbad421 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1759 | else of (e.ColumnHeader) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) \|\| (e.Column == siMain.GetColumnIndex(DefColumns.IT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-e5e1ee4a | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1789 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-779ee379 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1791 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1e65951c | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1792 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0f11f991 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1793 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-85e1af07 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1803 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-8c78cd68 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1806 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-ff4c0e06 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1808 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), sBizType) | 그리드 값 설정 |  |  |  |
| AC-024491a5 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1839 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-8559d237 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1841 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-196f3479 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1842 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f14893c9 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1843 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-74f6161c | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1853 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-e2655043 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1856 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME)… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-717e1d82 | this.spdMain.CellDoubleClick | DMF0042_BizPlan.cs:1858 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), sBizType) | 그리드 값 설정 |  |  |  |

## DMF0042_BizPlan.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-552f2240 | dsdm.Changed | DMF0042_BizPlan.cs:1865 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-169a92c4 | dsdm.Changed | DMF0042_BizPlan.cs:1868 | if (e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11d00be9 | dsdm.Changed | DMF0042_BizPlan.cs:1869 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67b43b5f | dsdm.Changed | DMF0042_BizPlan.cs:1873 | if (siMain.GetValue(e.Row, e.Column).ToString() == "") | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-26003384 | dsdm.Changed | DMF0042_BizPlan.cs:1900 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b64d424c | dsdm.Changed | DMF0042_BizPlan.cs:1911 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f37f6b1 | dsdm.Changed | DMF0042_BizPlan.cs:1915 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | GRID_SET | siMain.SetValue | (e.Row, e.Column, strValue[0] + ".000") | 그리드 값 설정 |  |  |  |
| AC-a27300ba | dsdm.Changed | DMF0042_BizPlan.cs:1916 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00289") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4fbf7c76 | dsdm.Changed | DMF0042_BizPlan.cs:1942 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ecbd867e | dsdm.Changed | DMF0042_BizPlan.cs:1944 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b261f65a | dsdm.Changed | DMF0042_BizPlan.cs:1950 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7f639913 | dsdm.Changed | DMF0042_BizPlan.cs:1970 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16204251 | dsdm.Changed | DMF0042_BizPlan.cs:1977 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ if (sBucket… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-4c06ab11 | dsdm.Changed | DMF0042_BizPlan.cs:1991 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac4c8c35 | dsdm.Changed | DMF0042_BizPlan.cs:2032 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (iQuarterlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce4acad3 | dsdm.Changed | DMF0042_BizPlan.cs:2057 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b4c81c97 | dsdm.Changed | DMF0042_BizPlan.cs:2063 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b4bb599c | dsdm.Changed | DMF0042_BizPlan.cs:2077 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-0f9b525f | dsdm.Changed | DMF0042_BizPlan.cs:2083 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-c805b4bf | dsdm.Changed | DMF0042_BizPlan.cs:2104 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-08afa535 | dsdm.Changed | DMF0042_BizPlan.cs:2132 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a602495b | dsdm.Changed | DMF0042_BizPlan.cs:2140 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-501f4607 | dsdm.Changed | DMF0042_BizPlan.cs:2158 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (Convert.ToDecimal(siMain.GetValue(e.Row, e.Column))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac2ee3f0 | dsdm.Changed | DMF0042_BizPlan.cs:2167 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4cc4034 | dsdm.Changed | DMF0042_BizPlan.cs:2167 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (DateTime.Today.DayOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c05a9dae | dsdm.Changed | DMF0042_BizPlan.cs:2225 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-80eeac38 | dsdm.Changed | DMF0042_BizPlan.cs:2231 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-58f909e5 | dsdm.Changed | DMF0042_BizPlan.cs:2247 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-ddca60f7 | dsdm.Changed | DMF0042_BizPlan.cs:2253 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-5f7f15a4 | dsdm.Changed | DMF0042_BizPlan.cs:2275 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-98d2a7a8 | dsdm.Changed | DMF0042_BizPlan.cs:2310 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-5075283d | dsdm.Changed | DMF0042_BizPlan.cs:2315 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-3a78d9ef | dsdm.Changed | DMF0042_BizPlan.cs:2337 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21818f16 | dsdm.Changed | DMF0042_BizPlan.cs:2344 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan") ▸ else of (sB… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, iQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |
| AC-2ec30516 | dsdm.Changed | DMF0042_BizPlan.cs:2382 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-df3654bc | dsdm.Changed | DMF0042_BizPlan.cs:2409 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ if (sB… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6c7ee847 | dsdm.Changed | DMF0042_BizPlan.cs:2489 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-286e06b5 | dsdm.Changed | DMF0042_BizPlan.cs:2495 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e30e151e | dsdm.Changed | DMF0042_BizPlan.cs:2509 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-975fa226 | dsdm.Changed | DMF0042_BizPlan.cs:2515 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-b7f2b432 | dsdm.Changed | DMF0042_BizPlan.cs:2536 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-19d4e2eb | dsdm.Changed | DMF0042_BizPlan.cs:2572 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-cc15167a | dsdm.Changed | DMF0042_BizPlan.cs:2657 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7125f831 | dsdm.Changed | DMF0042_BizPlan.cs:2663 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7e59955b | dsdm.Changed | DMF0042_BizPlan.cs:2679 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-503c0dc4 | dsdm.Changed | DMF0042_BizPlan.cs:2685 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-38166f5c | dsdm.Changed | DMF0042_BizPlan.cs:2707 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-9c6a5795 | dsdm.Changed | DMF0042_BizPlan.cs:2742 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-8df93ccc | dsdm.Changed | DMF0042_BizPlan.cs:2747 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e040b6b5 | dsdm.Changed | DMF0042_BizPlan.cs:2776 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0042_BizPlan.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6813e2c7 | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1636 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56584fe7 | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1637 | if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dcca5cf9 | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1649 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6dd2b0b | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1652 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1c0a37f2 | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1655 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-44df8eff | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1655 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4404cad1 | this.spdMain.ComboSelChange | DMF0042_BizPlan.cs:1656 | else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0042_BizPlan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e36f572 | this.spdMain.EditChange | DMF0042_BizPlan.cs:3040 | if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c752c22 | this.spdMain.EditChange | DMF0042_BizPlan.cs:3042 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_BizPlan.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84fb47f7 | this.spdMain.TopChange | DMF0042_BizPlan.cs:2802 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_BizPlan.ValidationCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5d39ac6 | (진입점 미연결) | DMF0042_BizPlan.cs:2791 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-678fc887 | (진입점 미연결) | DMF0042_BizPlan.cs:2794 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-fca7fc81 | (진입점 미연결) | DMF0042_BizPlan.cs:2796 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_ExchangeRatePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e0e2049 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0042_ExchangeRatePopup.cs:654 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a9743102 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0042_ExchangeRatePopup.cs:657 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-73f4e21d | this.btnButtonList.UsrButtonList_Click_Detected | DMF0042_ExchangeRatePopup.cs:660 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_ExchangeRatePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a6138a1 | this.Load | DMF0042_ExchangeRatePopup.cs:145 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a2790a2 | this.Load | DMF0042_ExchangeRatePopup.cs:146 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d3302db | this.Load | DMF0042_ExchangeRatePopup.cs:147 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_ExchangeRatePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81cd262d | this.Load | DMF0042_ExchangeRatePopup.cs:122 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-43ea29df | this.Load | DMF0042_ExchangeRatePopup.cs:133 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-252ac62a | this.Load | DMF0042_ExchangeRatePopup.cs:134 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-48f4ce75 | this.Load | DMF0042_ExchangeRatePopup.cs:135 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fb3478b | this.Load | DMF0042_ExchangeRatePopup.cs:138 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_ExchangeRatePopup.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2477a649 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:295 | if (vAction1 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a3a160f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:297 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0042_ExchangeRatePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd6b1303 | Dispose | DMF0042_ExchangeRatePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0042_ExchangeRatePopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fdaaee8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:311 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageBox.Show | (" You don't have the permissions to access it", "Information.") | 메시지 표시 |  |  |  |
| AC-3dea976c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:312 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f0b890f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:315 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-77e8195c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:316 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ae39f904 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:319 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(sColName), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a3e79c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:330 | if (this.fps != null) ▸ if (_cate == "BP") ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ if (iCompareYear >= iThisYear) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CURRENCY), i - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b20e4e30 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:349 | if (this.fps != null) ▸ else of (_cate == "BP") ▸ if (iMonth < iTime) ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ if (iLockMonth >= iTime) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CURRENCY), i - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_ExchangeRatePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1db20bc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:385 |  | VALUE_SET | clbDivision.ControlValues | _division | 컨트롤 값 설정 |  |  |  |
| AC-25e015fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:386 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0825d38b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:391 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c2f2fd1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:392 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-2335051b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:393 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-2a211236 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:394 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d515d4aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:395 |  | DATA_OP | nvc["p_cate"] | _cate | 행/컬럼 값 대입 |  |  |  |
| AC-ca486287 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:397 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP", nvc) ⇒ DM.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8f4bd2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:397 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-1bf7c1d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:399 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-143c591e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:400 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93b910c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:403 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain, "")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cc0345a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:403 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain, "") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd6b0db1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:406 |  | CALL_EXT | nvc.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c41de2da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:407 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b0c42db9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:408 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-8f2028e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:409 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-bfb06551 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:410 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-241426b2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:411 |  | DATA_OP | nvc["p_cate"] | _cate | 행/컬럼 값 대입 |  |  |  |
| AC-e6872745 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:413 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA", nvc) ⇒ DM.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8de8af6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:413 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-f87404a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:423 | for (i < dt.Rows.Count) | DATA_OP | dsSpread.Tables[0].Select | (" CURRENCY = '" + sCURRENCY.Trim() + "' AND [UNIT_CURRENCY] = '" + sUNIT_CURRENCY.Trim() … | 데이터 객체 조작/조회 |  |  |  |
| AC-78349a05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:428 | for (i < dt.Rows.Count) ▸ if (rows.Length > 0) | GRID_SET | siMain.SetText | (iRowindex, siMain.GetColumnIndex(sYYYYMMDD), sEXCHANGE_PRICE) | 그리드 값 설정 |  |  |  |
| AC-2a955a6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:432 |  | DATA_OP | dsSpread.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2627a237 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:433 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d15a50a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:434 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-544e6f73 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:435 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0042_ExchangeRatePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-732eb7b5 | this.Load | DMF0042_ExchangeRatePopup.cs:82 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1eab4764 | this.Load | DMF0042_ExchangeRatePopup.cs:84 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0042_ExchangeRatePopup.GetCellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b734cf7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:625 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0042_ExchangeRatePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-706c146a | this.Load | DMF0042_ExchangeRatePopup.cs:110 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d9550891 | this.Load | DMF0042_ExchangeRatePopup.cs:111 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-2eaa96d2 | this.Load | DMF0042_ExchangeRatePopup.cs:111 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1b998fa | this.Load | DMF0042_ExchangeRatePopup.cs:112 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fb5f3baf | this.Load | DMF0042_ExchangeRatePopup.cs:114 |  | FLAG | dtDivision2 | Data.Common(Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-33d6220e | this.Load | DMF0042_ExchangeRatePopup.cs:114 |  | COMBO_DATA | Data.Common | (Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ad60386 | this.Load | DMF0042_ExchangeRatePopup.cs:115 |  | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d41b4c7 | this.Load | DMF0042_ExchangeRatePopup.cs:115 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0042_ExchangeRatePopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a00f201f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:224 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-617c21ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:226 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e426e69f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:227 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 120, true, dtDivision2, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f644f91 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:228 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6c3ba12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:229 |  | GRID_INIT | siMain.AddComboColumn | ("Unit", DefColumns.UNIT_CURRENCY, FPMerge.None, 50, true, dtCurrency, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d77ca12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:230 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY_UNITCURRENCY, FPMerge.Restricted, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d57ae80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:231 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55706350 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:237 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE") ⇒ DM.DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-7faea36a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:238 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-507ae253 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:239 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-6a10a867 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:240 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d13098d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:254 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_MONTH"].ToString(), "D" + dt.Rows[i]["BASIS_START_DATE"].ToString(),… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f09cd5e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:259 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sFYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8152b8ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:266 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f004ef60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:271 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c46da664 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0042_ExchangeRatePopup.cs:272 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0042_ExchangeRatePopup.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d87e46a5 | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:154 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-50629780 | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:156 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-66c4ee5a | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:157 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e3d09ed | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:158 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-909e1f2c | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:167 |  | ENDPOINT | CUIControl.GetDataUsingSQLByDB | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd8ed9fa | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:184 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["WEEK_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.No… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30cb3b5b | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:189 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow-1, 25, sFYear + "년", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20f05d7f | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:197 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count-1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear + "년", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39f6ff5e | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:209 | for (i < dt.Rows.Count) ▸ if (sFMonth != dt.Rows[i]["CALENDAR_MONTH"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMonthFRow, 1, iMonthLRow - 1, 25, sFMonth + "월", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a745d767 | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:216 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMonthFRow, 1, iMonthLRow, 25, sFMonth + "월", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0042_ExchangeRatePopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dec4b0ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:588 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-798642a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:591 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CURRENCY, "KRW") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c71df78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:592 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0bc78b81 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c9ccb126 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2483965a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:608 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iMonth < iTime) ▸ for (i <… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY), siMain.Ac… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0042_ExchangeRatePopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f49e501 | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:95 |  | UI_PROP | usrMonthFrom.MonthText | sFromYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-4d73b5ce | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:96 |  | UI_PROP | usrMonthTo.MonthText | sToYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-ff3d7afa | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:98 |  | FLAG | _division | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-5228a568 | (진입점 미연결) | DMF0042_ExchangeRatePopup.cs:101 |  | FLAG | _cate | sCate | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_ExchangeRatePopup.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f83cc0c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0042_ExchangeRatePopup.cs:667 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0042_ExchangeRatePopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27012792 | SaveButton | DMF0042_ExchangeRatePopup.cs:367 | switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7134f7f5 | SaveButton | DMF0042_ExchangeRatePopup.cs:368 | switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0042_ExchangeRatePopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81b5c56f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-369cd8a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-1a69cc78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:481 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a12e26f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:515 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-0d28654d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:516 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_division_id"] | CString.AppendStringEx(nvc["p_division_id"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-570c7d55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:517 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-a66188b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:518 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ab7cd944 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-352147c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:520 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_EXCHANGE_PRICE"] | CString.AppendStringEx(nvc["p_EXCHANGE_PRICE"], sEXCHANGE_PRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-12c0a1c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:521 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-007e9b95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:522 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1e9e6583 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:537 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[EXCHANGE_PRICE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-073adf41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:538 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ac4be1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:543 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5cc8c9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:547 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0042_SAVE_DM_BP_EXCHANGE_RATE") ⇒ DM.DMF0042_SAVE_DM_BP_EXCHANGE_RATE | 엔드포인트 요청 생성 |  |  |  |
| AC-07f0d3e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-b083bbce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c981cc3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fbb16998 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:555 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6ecc87a0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:569 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-a042e161 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:570 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9841463 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0042_ExchangeRatePopup.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0042_ExchangeRatePopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ca00f7c | this.spdMain.TopChange | DMF0042_ExchangeRatePopup.cs:673 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

