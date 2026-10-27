# AS-IS 액션 대조표 — DMF0020

> 원천: `Doc/asisfacts/screens/DMF0020/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1863행 · 메서드 196 · 종류 DATA_OP 320 · RETURN 180 · FLAG 176 · CALL_EXT 146 · ENDPOINT 141 · GRID_LOCK 121 · GRID_INIT 108 · UI_PROP 98 · GRID_SET 83 · POPUP 70 · COMBO_DATA 68 · MESSAGE 66 · STATE 55 · UI_MISC 50 · GRID_COMBO 48 · LIST_REBIND 41 · VALUE_SET 27 · GRID_STYLE 25 · THROW 16 · VALUE_CLEAR 12 · GRID_BIND 7 · CALL_BASE 5 · ⚠ 의미 확인 필요 151


## _DMF0020_SalesFuturePrice.btnBatch_Click

진입점: this.btnBatch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23f0ce6c | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2399 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-13751519 | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2404 | lambda | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW") ⇒ DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | 엔드포인트 요청 생성 |  |  |  |
| AC-7050485c | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2406 | lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-abff793a | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2408 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb41d3d2 | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2409 | lambda | DATA_OP | request.Parameters["p_CREATED_BY"] | p_CREATED_BY | 행/컬럼 값 대입 |  |  |  |
| AC-5aa54450 | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2410 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-583851b9 | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2412 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-904088ae | this.btnBatch.Click | _DMF0020_SalesFuturePrice.cs:2425 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00143", new object[] { p_division_id, sRMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## _DMF0020_SalesFuturePrice.btnColumn_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b612556 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2820 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0020", SpdSheet.shtMain, true, clbDivisions.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-c1423cb2 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2821 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-978577c4 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2822 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## _DMF0020_SalesFuturePrice.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2e4804b | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1478 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2f53164 | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1479 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d0a45ae | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1482 |  | POPUP | new POPUP.DM0020_SalesFuturePricePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-694e2361 | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1483 |  | CALL_EXT | popup.LoadData | (drpDateTime.Value1.ToString("yyyyMM"), drpDateTime.Value1.AddYears(1).ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4f584fb | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1484 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bf3de115 | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1485 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cf8c887f | this.btnExchangeRate.Click | _DMF0020_SalesFuturePrice.cs:1490 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## _DMF0020_SalesFuturePrice.btnModelType_Click

진입점: this.btnItemId.Click / this.umltModel.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b00fb71 | this.btnItemId.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1529 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-47dec62f | this.btnItemId.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1532 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8e43486e | this.btnItemId.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1533 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5387f47b | this.btnItemId.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1534 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8b7ac2ac | this.btnItemId.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1536 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## _DMF0020_SalesFuturePrice.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9920361 | this.btnOwner.Click | _DMF0020_SalesFuturePrice.cs:2808 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-79d3303c | this.btnOwner.Click | _DMF0020_SalesFuturePrice.cs:2811 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-480ff472 | this.btnOwner.Click | _DMF0020_SalesFuturePrice.cs:2812 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ef5199a0 | this.btnOwner.Click | _DMF0020_SalesFuturePrice.cs:2813 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3e164232 | this.btnOwner.Click | _DMF0020_SalesFuturePrice.cs:2815 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## _DMF0020_SalesFuturePrice.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b836ba97 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2434 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION") ⇒ DM.DM0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-e92c2fb8 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2436 |  | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-72fc64e8 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2438 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-48d0dd32 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2439 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4429e64 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2445 |  | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-744de270 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2448 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76cc795a | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2456 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d11a9e31 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2459 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-104ce4c8 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2465 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00144") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cffbb0e3 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2466 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f6af1ff | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2471 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00145") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef47fb4b | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2476 | try | UI_PROP | Cursor.Current | Cursors.WaitCursor | 속성 Current 설정 |  |  |  |
| AC-cf9f1830 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2479 | try | STATE | panel1.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-52bb8da4 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2480 | try | CALL_EXT | panel1.BringToFront | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-80e2c32b | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2481 | try | UI_PROP | panel1.Left | (this.ClientSize.Width - panel1.Width) / 2 | 속성 Left 설정 |  |  |  |
| AC-7f9cebd4 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2482 | try | UI_PROP | panel1.Top | (this.ClientSize.Height - panel1.Height) / 2 | 속성 Top 설정 |  |  |  |
| AC-9a4174fa | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2484 | try | VALUE_SET | lblProgress.Text | "Recalculating" | 컨트롤 값 설정 |  |  |  |
| AC-ba1e2230 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2486 | try | UI_PROP | progressBar1.Maximum | (siMain.GetMaxRowIndex() + 1) * (siMain.GetMaxColumnIndex() + 1 - siMain.GetColumnIndex(De… | 속성 Maximum 설정 |  |  |  |
| AC-8d977580 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2487 | try | VALUE_SET | progressBar1.Value | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7eff0f5f | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2496 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure != "LOC") ▸ try | VALUE_SET | lblProgress.Text | "Recalculating" + ((sProcess.Length == 4) ? sProcess = "." : sProcess = sProcess + ".") | 컨트롤 값 설정 |  |  |  |
| AC-89b53bc9 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2497 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure != "LOC") ▸ try | VALUE_SET | progressBar1.Value | += (siMain.GetMaxColumnIndex() - siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 컨트롤 값 설정 |  |  |  |
| AC-b5aa9903 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2507 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ try | VALUE_SET | lblProgress.Text | "Recalculating" + ((sProcess.Length == 4) ? sProcess = "." : sProcess = sProcess + ".") | 컨트롤 값 설정 |  |  |  |
| AC-24b6bd7b | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2508 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ try | VALUE_SET | progressBar1.Value | += 1 | 컨트롤 값 설정 |  |  |  |
| AC-5dcdeded | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2515 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.IsLockCell | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20a96b5d | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2517 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetForeColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac16fa51 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2527 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.SetValue | (i, j, "0") | 그리드 값 설정 |  |  |  |
| AC-75f35d1f | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2528 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.SetValue | (i, j, sValue) | 그리드 값 설정 |  |  |  |
| AC-497bb25f | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2532 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if ((i % 2) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-466cbe61 | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2538 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cb1093ab | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2539 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-198d7d9e | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2543 | finally | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f4e548af | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2544 | finally | UI_PROP | Cursor.Current | Cursors.Default | 속성 Current 설정 |  |  |  |
| AC-82e7208d | this.btnSetPrice.Click | _DMF0020_SalesFuturePrice.cs:2546 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## _DMF0020_SalesFuturePrice.clbDivisions_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-769e18fd | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1550 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-498d96b9 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1553 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-57c3dfc6 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1574 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-5ae626fb | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1574 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa0384dd | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1575 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02cb8920 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1582 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-181b33e1 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1582 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fdfe5573 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1583 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6d4b1bfd | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1585 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e23bc887 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1586 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8bb0a034 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1587 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-385a59a8 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1588 | try ▸ if (clbDivisions.SelectedValue.ToString() != "40") | STATE | layoutControlItem6.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-724f19d9 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1592 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-621826c9 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1592 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f355f08b | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1593 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f4716300 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1595 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d5af9f2b | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1596 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-092d8e79 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1597 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblBizType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a5733dd6 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1598 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | layoutControlItem6.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0332046c | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1600 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | VALUE_CLEAR | umltProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e1375ee7 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1601 | try ▸ else of (clbDivisions.SelectedValue.ToString() != "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-66742aed | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1606 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d15b8bc0 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1606 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc4f6d7d | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1607 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f25e9959 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1609 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-f65b3314 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1609 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-064408a4 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1610 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-32c6678a | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1612 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b5be78e | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1613 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1a7beac8 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1619 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e10895d0 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1620 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ae73fb19 | this.clbDivisions.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:1624 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## _DMF0020_SalesFuturePrice.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fa383cf | this.clbEndCustomer.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2595 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc7a541e | this.clbEndCustomer.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2595 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c850b41 | this.clbEndCustomer.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2596 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## _DMF0020_SalesFuturePrice.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68a55e1e | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2759 | if (clbDivisions.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c59dd50c | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2759 | if (clbDivisions.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d205e5d5 | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2760 | if (clbDivisions.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-172b1586 | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2764 | else of (clbDivisions.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-b70b0977 | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2764 | else of (clbDivisions.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5325ac40 | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2765 | else of (clbDivisions.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-608defb4 | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2770 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ccb9e31d | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2770 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d98e3ad | this.clbTeam.SelectedIndexChanged | _DMF0020_SalesFuturePrice.cs:2771 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## _DMF0020_SalesFuturePrice.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48dba7ad | this.Load | _DMF0020_SalesFuturePrice.cs:382 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f43f312e | this.Load | _DMF0020_SalesFuturePrice.cs:383 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3ca37cb | this.Load | _DMF0020_SalesFuturePrice.cs:384 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## _DMF0020_SalesFuturePrice.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e959a0f | this.Load | _DMF0020_SalesFuturePrice.cs:271 |  | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-f5a58f26 | this.Load | _DMF0020_SalesFuturePrice.cs:272 |  | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-0724e2df | this.Load | _DMF0020_SalesFuturePrice.cs:274 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-e0932207 | this.Load | _DMF0020_SalesFuturePrice.cs:276 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-c50e9855 | this.Load | _DMF0020_SalesFuturePrice.cs:278 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c8c4cb8d | this.Load | _DMF0020_SalesFuturePrice.cs:279 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-27e2e2b4 | this.Load | _DMF0020_SalesFuturePrice.cs:280 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-65071698 | this.Load | _DMF0020_SalesFuturePrice.cs:281 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-2d644f47 | this.Load | _DMF0020_SalesFuturePrice.cs:282 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-094fd32f | this.Load | _DMF0020_SalesFuturePrice.cs:292 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d69d199b | this.Load | _DMF0020_SalesFuturePrice.cs:293 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3d3aa275 | this.Load | _DMF0020_SalesFuturePrice.cs:298 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7ea24499 | this.Load | _DMF0020_SalesFuturePrice.cs:299 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## _DMF0020_SalesFuturePrice.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32284fdc | DeleteButton | _DMF0020_SalesFuturePrice.cs:540 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce8df430 | DeleteButton | _DMF0020_SalesFuturePrice.cs:547 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-0110da0f | DeleteButton | _DMF0020_SalesFuturePrice.cs:548 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## _DMF0020_SalesFuturePrice.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de809dd9 | Dispose | _DMF0020_SalesFuturePrice.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## _DMF0020_SalesFuturePrice.DM0020_SalesFuturePrice_Resize

진입점: this.Resize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1d2ec5b | this.Resize | _DMF0020_SalesFuturePrice.cs:2588 | if (panel1.Visible == true) | UI_PROP | panel1.Left | (this.ClientSize.Width - panel1.Width) / 2 | 속성 Left 설정 |  |  |  |
| AC-e020fa23 | this.Resize | _DMF0020_SalesFuturePrice.cs:2589 | if (panel1.Visible == true) | UI_PROP | panel1.Top | (this.ClientSize.Height - panel1.Height) / 2 | 속성 Top 설정 |  |  |  |

## _DMF0020_SalesFuturePrice.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da536f86 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2007 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e76099fa | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2012 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-610acce7 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2013 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f57b384 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2014 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3e24aec | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2029 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-3b6e4111 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2030 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32480b17 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2038 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-136d5278 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2046 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Sub… | 그리드 값 설정 |  |  |  |
| AC-4fb67eee | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2047 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row - i, e.Column, e.Row - i, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bed0b9ca | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2052 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-db6fabff | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2071 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-646e8a84 | dsdm.Changed | _DMF0020_SalesFuturePrice.cs:2074 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |

## _DMF0020_SalesFuturePrice.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d77da5 | EditButton | _DMF0020_SalesFuturePrice.cs:596 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f082664 | EditButton | _DMF0020_SalesFuturePrice.cs:597 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-02f4ea1d | EditButton | _DMF0020_SalesFuturePrice.cs:600 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b884c4d6 | EditButton | _DMF0020_SalesFuturePrice.cs:608 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fccc56de | EditButton | _DMF0020_SalesFuturePrice.cs:618 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, i, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff9e2cdc | EditButton | _DMF0020_SalesFuturePrice.cs:623 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (i, 0, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4c061e4 | EditButton | _DMF0020_SalesFuturePrice.cs:650 | if (this.fps != null) ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-87d6c715 | EditButton | _DMF0020_SalesFuturePrice.cs:663 | if (this.fps != null) ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) ▸ try ▸ if (sThisWeek != sL… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MEASURE), siMain.GetColumnIndex(sLastWeek), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c135b37c | EditButton | _DMF0020_SalesFuturePrice.cs:664 | if (this.fps != null) ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) ▸ try ▸ if (sThisWeek != sL… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |

## _DMF0020_SalesFuturePrice.FindData

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.btnSetPrice.Click / FindButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a188169c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:686 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0f2aead6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:693 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54e18c98 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:694 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d54d48b6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:697 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c139343f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:707 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7873677d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:708 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc39b7fb | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:727 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9136e2a5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:728 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d734b34 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:732 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f65a3b17 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:743 | try | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-19f24fb1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:744 | try | DATA_OP | nvc["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-c79ce1ab | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:745 | try | DATA_OP | nvc["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-837d8188 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:746 | try | DATA_OP | nvc["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-790d573b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:747 | try | DATA_OP | nvc["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-7317e9f1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:748 | try | DATA_OP | nvc["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a9722233 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:749 | try | DATA_OP | nvc["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6eda620b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:750 | try | DATA_OP | nvc["p_customer_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97b39544 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:751 | try | DATA_OP | nvc["p_customer_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4c8dbd0 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:752 | try | DATA_OP | nvc["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d07830f5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:753 | try | DATA_OP | nvc["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-d45a0b51 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:754 | try | DATA_OP | nvc["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-bca96fda | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:755 | try | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-929f432d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:756 | try | DATA_OP | nvc["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ccd7dc77 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:757 | try | DATA_OP | nvc["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-1403cae3 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:759 | try | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDBEx | (this, "DM_H.DMF0020_GET_SCM_MST_FUTURE_PRICE", nvc) ⇒ DM_H.DMF0020_GET_SCM_MST_FUTURE_PRICE | 엔드포인트 호출 |  |  |  |
| AC-f234c088 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:759 | try | ENDPOINT | new CUIControl | () ⇒ DM_H.DMF0020_GET_SCM_MST_FUTURE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-3f25f1dd | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:762 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7fd85d2 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:769 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49bd9cc3 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:782 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select("", sSortList).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f52599e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:782 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select | ("", sSortList) | 데이터 객체 조작/조회 |  |  |  |
| AC-63bfdb18 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:783 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Remove | (ds.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-056e2911 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:784 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-44d9fbed | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:786 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-de935aeb | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:787 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ae4423d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:791 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53df47f4 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:808 | try ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) ▸ try ▸ if (sThisWeek != sLastWeek) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-72fcf9df | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:834 | try ▸ catch ((Exception exl)) | THROW | throw new Exception("Join =>", exl); |  | 예외 발생 |  |  |  |
| AC-8bbe3e3a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:840 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f08002ee | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:848 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3761921c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:853 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-78e111b8 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:860 | try ▸ catch ((Exception exi)) | THROW | throw exi; |  | 예외 발생 |  |  |  |
| AC-b1dbb4d2 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:861 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-647f86c6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:867 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cd90410 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:880 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-1f0a0a2e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:881 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1695e4ff | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:890 | try | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-93d150eb | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:892 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e5dc34f3 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:896 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6e75998e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:897 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-42aa8f6f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:901 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-90fb0746 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:906 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ad41daa8 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | _DMF0020_SalesFuturePrice.cs:907 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## _DMF0020_SalesFuturePrice.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cd78dd3 | this.Load | _DMF0020_SalesFuturePrice.cs:152 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-51db9324 | this.Load | _DMF0020_SalesFuturePrice.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## _DMF0020_SalesFuturePrice.GetBizTypebyDivision

진입점: this.Load / this.clbDivisions.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8840d41 | this.Load 외 1 | _DMF0020_SalesFuturePrice.cs:2719 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d71583e2 | this.Load 외 1 | _DMF0020_SalesFuturePrice.cs:2720 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cc6c8a84 | this.Load 외 1 | _DMF0020_SalesFuturePrice.cs:2721 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7895c6ac | this.Load 외 1 | _DMF0020_SalesFuturePrice.cs:2724 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f63c5c07 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:1308 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetCellIndexBySpanRowCells

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72c2bcb2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 3 | _DMF0020_SalesFuturePrice.cs:1959 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a2e2526 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 3 | _DMF0020_SalesFuturePrice.cs:1960 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27dea9b8 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 2 | _DMF0020_SalesFuturePrice.cs:1991 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-68740628 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 2 | _DMF0020_SalesFuturePrice.cs:1996 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetCurrencyBySCM_MST_SITE_ITEM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91f042ac | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2263 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-180797ee | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2266 | if (ds.Tables[0].Rows.Count == 0) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-127bcc79 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2268 | else of (ds.Tables[0].Rows.Count == 0) | RETURN | return ds.Tables[0].Rows[0]["CURRENCY"].ToString(); |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39bb7a1d | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2659 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4bc70a92 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2660 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4f4b8e6c | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2661 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-3f25d5c9 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2662 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d5ba3972 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2665 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c172b459 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2674 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c6184b9f | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2675 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-80e17b0d | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2676 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-75bc6e54 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2677 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c97ac8c | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2680 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd512cc4 | this.Load | _DMF0020_SalesFuturePrice.cs:255 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-7aa1664f | this.Load | _DMF0020_SalesFuturePrice.cs:256 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5443aa1d | this.Load | _DMF0020_SalesFuturePrice.cs:257 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-d67a3d02 | this.Load | _DMF0020_SalesFuturePrice.cs:259 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-220178dc | this.Load | _DMF0020_SalesFuturePrice.cs:262 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d893c57 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2284 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-58c43a96 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2286 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31b967a4 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2289 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4c5d442 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2343 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e6267752 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2344 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-577ab6ed | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2345 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-96c7e828 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2346 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8be93dd | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2349 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetExchangeRate

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) ▸ if (!string.IsNullOrEmpty(val)) ▸ for (i > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a3280ca | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2099 | if (sBaseER == sTargetER) | RETURN | return sValue; |  | 처리 중단/반환 |  |  |  |
| AC-8ad2ea08 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2102 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sTargetER + "' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-8ee6aaed | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2106 | if (row.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-fc9ebec1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2110 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sBaseER + "' AND UNIT_CURRENCY = '" + sTargetER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-932affb5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2115 | if (row1.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-a8bb3550 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2119 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' A… | 데이터 객체 조작/조회 |  |  |  |
| AC-f691d18f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2123 | if (row4.Length > 0) | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' AND YYYYMM = '" + sYYYYMM + "' AND DIVISION_… | 데이터 객체 조작/조회 |  |  |  |
| AC-66d5574a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2128 | if (row4.Length > 0) ▸ if (row5.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-8af8689d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2133 | if (sTargetVal == null) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-a65b9a7c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | _DMF0020_SalesFuturePrice.cs:2135 | else of (sTargetVal == null) | RETURN | return "0"; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.btnSetPrice.Click [try] / this.Load / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd7146e0 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | _DMF0020_SalesFuturePrice.cs:374 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ddf8e8ce | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | _DMF0020_SalesFuturePrice.cs:377 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a51a3a | this.Load | _DMF0020_SalesFuturePrice.cs:2358 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-43696441 | this.Load | _DMF0020_SalesFuturePrice.cs:2359 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-f3dc64c1 | this.Load | _DMF0020_SalesFuturePrice.cs:2360 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ffe2bf3 | this.Load | _DMF0020_SalesFuturePrice.cs:2363 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetMeasureCountInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93b2e8d4 | this.Load | _DMF0020_SalesFuturePrice.cs:358 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-285622d9 | this.Load | _DMF0020_SalesFuturePrice.cs:360 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c78b3fb | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2372 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-ad637d86 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2373 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b622d9af | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2374 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ed0d9330 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2375 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-65f0f539 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2376 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6bcfcadb | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2379 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66013ead | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2696 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-1419731f | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2697 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7837adb1 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2698 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8874b11a | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2699 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-79cac5d3 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2700 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de9f8597 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2703 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65494a5b | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2298 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-739f08b1 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2299 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2bd7de44 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2300 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-1778a981 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2301 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-a23a9393 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2302 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fae3fda7 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2305 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67a523b3 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2733 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e95f0399 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2734 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-41c92462 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2735 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-acb2403d | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2736 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-038577ff | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2737 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c54efe5 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2740 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetScmSiteInfobyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6029991b | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2314 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9200ce4f | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2315 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-eb64ef9c | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2316 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-f38051bf | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2317 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7cd6bb3e | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2320 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetSpdTitle

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnSetPrice.Click [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21260ba8 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2620 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ffa7e09c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2621 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a742080 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2622 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76baec3d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2623 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2c6c3593 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2625 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0020" | 행/컬럼 값 대입 |  |  |  |
| AC-46a15825 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2626 |  | DATA_OP | request.Parameters["p_sheet_name"] | "Sales Price" | 행/컬럼 값 대입 |  |  |  |
| AC-783955e3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2627 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-1f6e0d37 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2629 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ca0d5008 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2629 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-571a2eb5 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:2632 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29f0d8fc | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2329 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-493e73bc | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2330 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-51c3263c | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2331 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-018e2757 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2334 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6ac4f59 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2641 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ef6fdeb8 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2642 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-20c97c93 | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2643 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ab95bfe | (진입점 미연결) | _DMF0020_SalesFuturePrice.cs:2650 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetThisWeekMonday

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.btnSetPrice.Click [try] / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04162c5d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 3 | _DMF0020_SalesFuturePrice.cs:2567 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.GetWeekData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0f59ce8 | this.Load | _DMF0020_SalesFuturePrice.cs:335 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e326828 | this.Load | _DMF0020_SalesFuturePrice.cs:338 |  | RETURN | return dsWeek.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## _DMF0020_SalesFuturePrice.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-559c31b2 | this.Load | _DMF0020_SalesFuturePrice.cs:167 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-fed4da9d | this.Load | _DMF0020_SalesFuturePrice.cs:177 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e72bdcae | this.Load | _DMF0020_SalesFuturePrice.cs:179 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-de089ed4 | this.Load | _DMF0020_SalesFuturePrice.cs:179 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a18817c | this.Load | _DMF0020_SalesFuturePrice.cs:181 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5485295c | this.Load | _DMF0020_SalesFuturePrice.cs:185 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-45cee747 | this.Load | _DMF0020_SalesFuturePrice.cs:185 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2dfc17cc | this.Load | _DMF0020_SalesFuturePrice.cs:187 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-f66ff519 | this.Load | _DMF0020_SalesFuturePrice.cs:187 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-426a78b4 | this.Load | _DMF0020_SalesFuturePrice.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6fa389a4 | this.Load | _DMF0020_SalesFuturePrice.cs:195 | if (clbDivisions.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-32869d83 | this.Load | _DMF0020_SalesFuturePrice.cs:195 | if (clbDivisions.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c635105 | this.Load | _DMF0020_SalesFuturePrice.cs:196 | if (clbDivisions.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1df1dbbe | this.Load | _DMF0020_SalesFuturePrice.cs:198 | if (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e31dcc76 | this.Load | _DMF0020_SalesFuturePrice.cs:199 | if (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c5963d9b | this.Load | _DMF0020_SalesFuturePrice.cs:200 | if (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c6a34999 | this.Load | _DMF0020_SalesFuturePrice.cs:201 | if (clbDivisions.SelectedValue.ToString() != "40") | STATE | layoutControlItem6.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c55106ec | this.Load | _DMF0020_SalesFuturePrice.cs:205 | else of (clbDivisions.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-efb6cb77 | this.Load | _DMF0020_SalesFuturePrice.cs:205 | else of (clbDivisions.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d7682ce | this.Load | _DMF0020_SalesFuturePrice.cs:206 | else of (clbDivisions.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-26db7209 | this.Load | _DMF0020_SalesFuturePrice.cs:208 | else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-450001d4 | this.Load | _DMF0020_SalesFuturePrice.cs:209 | else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d8cdf32e | this.Load | _DMF0020_SalesFuturePrice.cs:210 | else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | lblBizType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b602eea1 | this.Load | _DMF0020_SalesFuturePrice.cs:211 | else of (clbDivisions.SelectedValue.ToString() != "40") | STATE | layoutControlItem6.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-76712762 | this.Load | _DMF0020_SalesFuturePrice.cs:213 | else of (clbDivisions.SelectedValue.ToString() != "40") | VALUE_CLEAR | umltProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d92e5fda | this.Load | _DMF0020_SalesFuturePrice.cs:214 | else of (clbDivisions.SelectedValue.ToString() != "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-8ac1e564 | this.Load | _DMF0020_SalesFuturePrice.cs:219 |  | FLAG | dtBizType | GetBizTypebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bc6fec74 | this.Load | _DMF0020_SalesFuturePrice.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c658b601 | this.Load | _DMF0020_SalesFuturePrice.cs:224 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9f07fa1b | this.Load | _DMF0020_SalesFuturePrice.cs:224 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af1bfb5b | this.Load | _DMF0020_SalesFuturePrice.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a184775e | this.Load | _DMF0020_SalesFuturePrice.cs:227 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-b0fe6034 | this.Load | _DMF0020_SalesFuturePrice.cs:227 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-497ae4c0 | this.Load | _DMF0020_SalesFuturePrice.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0fc7f678 | this.Load | _DMF0020_SalesFuturePrice.cs:230 |  | FLAG | dtItemType | GetLookupValues("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-fbb9a3b0 | this.Load | _DMF0020_SalesFuturePrice.cs:231 |  | FLAG | dtINCOTERMSType | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-3a1230cd | this.Load | _DMF0020_SalesFuturePrice.cs:233 |  | FLAG | dtFcstType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-534aa12b | this.Load | _DMF0020_SalesFuturePrice.cs:234 |  | FLAG | dtDomExp | GetLookupValues("DOM/EXP") | 화면 필드/플래그 변경 |  |  |  |
| AC-04623c71 | this.Load | _DMF0020_SalesFuturePrice.cs:237 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3e12c62 | this.Load | _DMF0020_SalesFuturePrice.cs:237 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d83df3a6 | this.Load | _DMF0020_SalesFuturePrice.cs:240 |  | FLAG | dtMeasureCount | GetMeasureCountInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-f225b637 | this.Load | _DMF0020_SalesFuturePrice.cs:242 |  | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-e718f1dc | this.Load | _DMF0020_SalesFuturePrice.cs:246 |  | FLAG | dtWeek | GetWeekData() | 화면 필드/플래그 변경 |  |  |  |

## _DMF0020_SalesFuturePrice.InitSpread

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.btnSetPrice.Click [try] / this.Load / this.clbDivisions.SelectedIndexChanged [try] / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ba9eb4d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | _DMF0020_SalesFuturePrice.cs:416 | if (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-06d48ca3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | _DMF0020_SalesFuturePrice.cs:421 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-af969da0 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | _DMF0020_SalesFuturePrice.cs:422 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-7d85963b | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | _DMF0020_SalesFuturePrice.cs:426 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## _DMF0020_SalesFuturePrice.InitSpread_X

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnSetPrice.Click [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45e3c3ae | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:462 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5362f76d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:478 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-e3f84e00 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:479 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e38d80cf | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:480 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-676d4589 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:482 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0020_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0020_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c2ca13e | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:482 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0020_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-4b092ba9 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:497 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["DATE_SHORT1_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPM… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1df7163d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:499 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.MEASURE) + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].T… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef7eab36 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:505 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4842d12 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:514 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c04447e | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | _DMF0020_SalesFuturePrice.cs:520 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## _DMF0020_SalesFuturePrice.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ee7b487 | InsertButton | _DMF0020_SalesFuturePrice.cs:1322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-c64d16ab | InsertButton | _DMF0020_SalesFuturePrice.cs:1325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasureCount.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-05e1ebdb | InsertButton | _DMF0020_SalesFuturePrice.cs:1334 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a80c1503 | InsertButton | _DMF0020_SalesFuturePrice.cs:1336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45a43cca | InsertButton | _DMF0020_SalesFuturePrice.cs:1339 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68a715d7 | InsertButton | _DMF0020_SalesFuturePrice.cs:1343 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-750a0343 | InsertButton | _DMF0020_SalesFuturePrice.cs:1348 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-86802536 | InsertButton | _DMF0020_SalesFuturePrice.cs:1350 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3ea84969 | InsertButton | _DMF0020_SalesFuturePrice.cs:1352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fae8e355 | InsertButton | _DMF0020_SalesFuturePrice.cs:1354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-06ed082b | InsertButton | _DMF0020_SalesFuturePrice.cs:1356 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomerAut… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b26eb5d4 | InsertButton | _DMF0020_SalesFuturePrice.cs:1358 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-fc674023 | InsertButton | _DMF0020_SalesFuturePrice.cs:1362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40e02331 | InsertButton | _DMF0020_SalesFuturePrice.cs:1373 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e1230aeb | InsertButton | _DMF0020_SalesFuturePrice.cs:1376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivisions.Se… | 그리드 값 설정 |  |  |  |
| AC-86578929 | InsertButton | _DMF0020_SalesFuturePrice.cs:1377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-df4a0a26 | InsertButton | _DMF0020_SalesFuturePrice.cs:1379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c85f23c0 | InsertButton | _DMF0020_SalesFuturePrice.cs:1388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-10c9b5cb | InsertButton | _DMF0020_SalesFuturePrice.cs:1390 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cf30cbe1 | InsertButton | _DMF0020_SalesFuturePrice.cs:1392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cca15edc | InsertButton | _DMF0020_SalesFuturePrice.cs:1394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasureCount.Rows… | 그리드 값 설정 |  |  |  |
| AC-84a2f249 | InsertButton | _DMF0020_SalesFuturePrice.cs:1395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac59df3d | InsertButton | _DMF0020_SalesFuturePrice.cs:1398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DEPT_ID), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d407fe4b | InsertButton | _DMF0020_SalesFuturePrice.cs:1404 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerA… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3f8ebc81 | InsertButton | _DMF0020_SalesFuturePrice.cs:1405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJE… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9c96f4ee | InsertButton | _DMF0020_SalesFuturePrice.cs:1406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd972f6a | InsertButton | _DMF0020_SalesFuturePrice.cs:1407 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b3d81c01 | InsertButton | _DMF0020_SalesFuturePrice.cs:1408 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a705413e | InsertButton | _DMF0020_SalesFuturePrice.cs:1412 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustome… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-35fb9011 | InsertButton | _DMF0020_SalesFuturePrice.cs:1419 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-69d9abd2 | InsertButton | _DMF0020_SalesFuturePrice.cs:1421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e7a7744 | InsertButton | _DMF0020_SalesFuturePrice.cs:1423 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f2edf36 | InsertButton | _DMF0020_SalesFuturePrice.cs:1425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-18fc6bd6 | InsertButton | _DMF0020_SalesFuturePrice.cs:1428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f28b008 | InsertButton | _DMF0020_SalesFuturePrice.cs:1446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-78186074 | InsertButton | _DMF0020_SalesFuturePrice.cs:1457 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasureCount.Rows.Count - 1, 1, siMain.GetColumnIndex(De… | ⚠ 의미 확인 필요 |  |  |  |

## _DMF0020_SalesFuturePrice.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7ccf946 | SaveButton | _DMF0020_SalesFuturePrice.cs:913 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2ceb8813 | SaveButton | _DMF0020_SalesFuturePrice.cs:924 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1588dd06 | SaveButton | _DMF0020_SalesFuturePrice.cs:925 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f89d6326 | SaveButton | _DMF0020_SalesFuturePrice.cs:928 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c9909899 | SaveButton | _DMF0020_SalesFuturePrice.cs:1035 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e93edd4 | SaveButton | _DMF0020_SalesFuturePrice.cs:1038 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-31901341 | SaveButton | _DMF0020_SalesFuturePrice.cs:1040 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-072d10bf | SaveButton | _DMF0020_SalesFuturePrice.cs:1076 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("ACTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-af3b5ed6 | SaveButton | _DMF0020_SalesFuturePrice.cs:1077 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e98eaa73 | SaveButton | _DMF0020_SalesFuturePrice.cs:1078 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e3e93db | SaveButton | _DMF0020_SalesFuturePrice.cs:1079 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("SCM_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-50d3fb70 | SaveButton | _DMF0020_SalesFuturePrice.cs:1080 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("PLANT_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2707a6dd | SaveButton | _DMF0020_SalesFuturePrice.cs:1081 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a59fce5f | SaveButton | _DMF0020_SalesFuturePrice.cs:1082 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("CURRENCY") | 데이터 객체 조작/조회 |  |  |  |
| AC-a50e1a41 | SaveButton | _DMF0020_SalesFuturePrice.cs:1083 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c220ece | SaveButton | _DMF0020_SalesFuturePrice.cs:1084 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("DOM_EXP") | 데이터 객체 조작/조회 |  |  |  |
| AC-0af89da8 | SaveButton | _DMF0020_SalesFuturePrice.cs:1085 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2134002d | SaveButton | _DMF0020_SalesFuturePrice.cs:1086 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9ecdade | SaveButton | _DMF0020_SalesFuturePrice.cs:1094 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { msg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-487bbe2a | SaveButton | _DMF0020_SalesFuturePrice.cs:1097 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-268060c7 | SaveButton | _DMF0020_SalesFuturePrice.cs:1098 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fda21e51 | SaveButton | _DMF0020_SalesFuturePrice.cs:1111 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4fc48337 | SaveButton | _DMF0020_SalesFuturePrice.cs:1164 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1], j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78bc348c | SaveButton | _DMF0020_SalesFuturePrice.cs:1184 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-87f71dce | SaveButton | _DMF0020_SalesFuturePrice.cs:1185 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-765b201c | SaveButton | _DMF0020_SalesFuturePrice.cs:1186 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-a762bf07 | SaveButton | _DMF0020_SalesFuturePrice.cs:1187 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1a099174 | SaveButton | _DMF0020_SalesFuturePrice.cs:1188 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], p_plant_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-a149e55c | SaveButton | _DMF0020_SalesFuturePrice.cs:1189 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d1859322 | SaveButton | _DMF0020_SalesFuturePrice.cs:1190 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7a024621 | SaveButton | _DMF0020_SalesFuturePrice.cs:1191 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-baaaec5c | SaveButton | _DMF0020_SalesFuturePrice.cs:1193 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], sMEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4a3e2abc | SaveButton | _DMF0020_SalesFuturePrice.cs:1194 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], sDomExp, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-6bcf380f | SaveButton | _DMF0020_SalesFuturePrice.cs:1195 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], sFcstType, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-02cf9b1c | SaveButton | _DMF0020_SalesFuturePrice.cs:1196 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-51bc02ef | SaveButton | _DMF0020_SalesFuturePrice.cs:1197 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PRICE"] | CString.AppendStringEx(nvc["p_PRICE"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ee24059c | SaveButton | _DMF0020_SalesFuturePrice.cs:1198 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4c7b74df | SaveButton | _DMF0020_SalesFuturePrice.cs:1199 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-c492e34c | SaveButton | _DMF0020_SalesFuturePrice.cs:1200 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-50201748 | SaveButton | _DMF0020_SalesFuturePrice.cs:1203 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-1ce8c319 | SaveButton | _DMF0020_SalesFuturePrice.cs:1212 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-43fd6cd3 | SaveButton | _DMF0020_SalesFuturePrice.cs:1221 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[Price]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66cbc9b2 | SaveButton | _DMF0020_SalesFuturePrice.cs:1222 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-279190c4 | SaveButton | _DMF0020_SalesFuturePrice.cs:1233 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef135a36 | SaveButton | _DMF0020_SalesFuturePrice.cs:1237 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL") ⇒ DM_H.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-46c5608f | SaveButton | _DMF0020_SalesFuturePrice.cs:1238 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-aa37ce1c | SaveButton | _DMF0020_SalesFuturePrice.cs:1241 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Co… | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-1f7e1859 | SaveButton | _DMF0020_SalesFuturePrice.cs:1241 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Co… | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b62f8a8 | SaveButton | _DMF0020_SalesFuturePrice.cs:1243 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-38974d43 | SaveButton | _DMF0020_SalesFuturePrice.cs:1245 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dd5dca22 | SaveButton | _DMF0020_SalesFuturePrice.cs:1259 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "succe… | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-ddf5c8c4 | SaveButton | _DMF0020_SalesFuturePrice.cs:1260 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "succe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2ca4241 | SaveButton | _DMF0020_SalesFuturePrice.cs:1265 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b14ba8b8 | SaveButton | _DMF0020_SalesFuturePrice.cs:1266 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-362e2593 | SaveButton | _DMF0020_SalesFuturePrice.cs:1269 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-965e7525 | SaveButton | _DMF0020_SalesFuturePrice.cs:1282 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-5ef38d4d | SaveButton | _DMF0020_SalesFuturePrice.cs:1286 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a04f51bf | SaveButton | _DMF0020_SalesFuturePrice.cs:1288 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## _DMF0020_SalesFuturePrice.SetTextCellsToRowSpanRange

진입점: this.spdMain.CellDoubleClick [else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siMain.GetColumn…) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME)) \|\| siMain.GetCol…) ▸ if (popItem.ItemID != "" \|\| popItem.ItemID != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f232900 | this.spdMain.CellDoubleClick [else of (siMain.IsLock(siMain.… | _DMF0020_SalesFuturePrice.cs:1945 | for (i < iMeasureCount) | GRID_SET | siMain.SetValue | (iActiveRow + i, siMain.GetColumnIndex(sColName), objValue) | 그리드 값 설정 |  |  |  |
| AC-35e66d34 | this.spdMain.CellDoubleClick [else of (siMain.IsLock(siMain.… | _DMF0020_SalesFuturePrice.cs:1946 | for (i < iMeasureCount) | GRID_SET | siMain.SetText | (iActiveRow + i, siMain.GetColumnIndex(sColName), objValue.ToString()) | 그리드 값 설정 |  |  |  |

## _DMF0020_SalesFuturePrice.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ddeeb41 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2141 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94b4f20a | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2151 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00490ec6 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2186 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a188b666 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2187 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a776f3c6 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2188 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b7ebaa17 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2189 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-777c06ce | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2207 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-90aeee02 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2209 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-e59b431d | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2211 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-b4a952d9 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2213 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName) | 그리드 값 설정 |  |  |  |
| AC-4bc4ba15 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2218 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7f24ae05 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2220 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-9f416ac0 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2227 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4b953a2b | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2229 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9f041caf | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2230 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8ad143ca | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2231 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-85ebe0f6 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2235 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-ceaf7954 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2236 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName) | 그리드 값 설정 |  |  |  |
| AC-00704f38 | this.spdMain.CellDoubleClick | _DMF0020_SalesFuturePrice.cs:2237 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName) | 그리드 값 설정 |  |  |  |

## _DMF0020_SalesFuturePrice.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91513289 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1643 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-7566d378 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1643 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-34e0f176 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1645 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9791ebdf | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1646 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row + 2, siMain.GetColumnInde… | ⚠ 의미 확인 필요 |  |  |  |
| AC-636bb8c6 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1655 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-b793fcac | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1655 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-297ca040 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1656 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3c4876cc | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1657 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fa7f22d | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1665 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-f5bdfa35 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1665 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1537db43 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1666 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-82c49155 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1667 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetCol… | ⚠ 의미 확인 필요 |  |  |  |
| AC-97e68a1a | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1673 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-25030911 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1673 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42d7ec20 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1675 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-eed9ea28 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1676 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7cccb2d0 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1679 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-79ebf309 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1679 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57f751f9 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1681 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3436ec5f | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1682 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row + 2, siMain.GetColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ee09e17 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1691 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3154b4e | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1693 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6cdfe6db | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1713 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-526952da | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1715 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-57a7e9d8 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1717 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9716b4fc | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1719 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-94528e99 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1721 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d8fce043 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1723 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-4478b35a | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1725 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-c66134bd | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1739 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-346edddc | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1739 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3999ad41 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1740 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b2198772 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1742 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-175b7fbd | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1746 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-856899f5 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1746 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9316ee1b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1747 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6b03dc6b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1749 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetCol… | ⚠ 의미 확인 필요 |  |  |  |
| AC-42e8b247 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1754 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-3ee0d23b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1754 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35aa7ca6 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1756 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-91216866 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1757 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e1ae71e | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1785 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-1bd7d972 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1787 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5cad016b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1789 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-b2b2e504 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1791 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-ab24f30b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1793 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-844d2bbe | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1795 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-c34ed61b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1806 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-9ad71a86 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1806 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13a1f2cc | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1807 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-88bdb798 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1808 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c1d1fdd | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1809 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cc0248b | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1815 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7660a3ec | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1817 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-b6d450d9 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1819 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-4d02fb18 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1821 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-8c232f55 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1823 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-01a7a84f | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1832 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-a0190e46 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1834 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-4b11d5ac | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1836 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b6a60150 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1838 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-aa20e8ce | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1846 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-16d2b46f | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1846 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42b60de1 | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1847 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bd7b7dfa | this.spdMain.ComboSelChange | _DMF0020_SalesFuturePrice.cs:1848 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetCol… | ⚠ 의미 확인 필요 |  |  |  |

## _DMF0020_SalesFuturePrice.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a5386f5 | this.spdMain.KeyUp | _DMF0020_SalesFuturePrice.cs:2781 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-954d01e2 | this.spdMain.KeyUp | _DMF0020_SalesFuturePrice.cs:2785 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1573f4b | this.spdMain.KeyUp | _DMF0020_SalesFuturePrice.cs:2791 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-459a6174 | this.spdMain.KeyUp | _DMF0020_SalesFuturePrice.cs:2792 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## _DMF0020_SalesFuturePrice.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b97bcd6 | this.spdMain.TopChange | _DMF0020_SalesFuturePrice.cs:2274 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## _DMF0020_SalesFuturePrice.usrButton1_Click

진입점: this.usrButton1.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-699695d6 | this.usrButton1.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1507 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-7a664f5e | this.usrButton1.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1508 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-52910a30 | this.usrButton1.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1509 | if (clbDivisions.SelectedValue.ToString() != "40") | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cfae222e | this.usrButton1.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1510 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-143bcd6a | this.usrButton1.Click 외 1 | _DMF0020_SalesFuturePrice.cs:1512 | if (clbDivisions.SelectedValue.ToString() != "40") | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.btnBatch_Click

진입점: this.btnBatch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81ad3f9c | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3469 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa17e85f | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3474 | lambda | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW") ⇒ DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | 엔드포인트 요청 생성 |  |  |  |
| AC-35439ac5 | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3476 | lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a9b12d88 | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3478 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-98f5ce2a | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3479 | lambda | DATA_OP | request.Parameters["p_CREATED_BY"] | p_CREATED_BY | 행/컬럼 값 대입 |  |  |  |
| AC-e6c41a8c | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3480 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4c7201d | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3482 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4f4ef562 | this.btnBatch.Click | DMF0020_SalesFuturePrice.cs:3493 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00143", new object[] { p_division_id, sRMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0020_SalesFuturePrice.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80a5217b | this.btnColumn.Click | DMF0020_SalesFuturePrice.cs:3794 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0020", SpdSheet.shtMain, true, clbDivisions.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-bd8b856d | this.btnColumn.Click | DMF0020_SalesFuturePrice.cs:3795 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-464f4951 | this.btnColumn.Click | DMF0020_SalesFuturePrice.cs:3796 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0020_SalesFuturePrice.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c6d6ca0 | this.btnExcelUpload.Click | DMF0020_SalesFuturePrice.cs:3938 |  | POPUP | new ExcelUploadForm | ("DMF0020", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-c90213f9 | this.btnExcelUpload.Click | DMF0020_SalesFuturePrice.cs:3939 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-3c93735a | this.btnExcelUpload.Click | DMF0020_SalesFuturePrice.cs:3940 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b36a7f03 | this.btnExcelUpload.Click | DMF0020_SalesFuturePrice.cs:3941 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4f64ae7e | this.btnExcelUpload.Click | DMF0020_SalesFuturePrice.cs:3943 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0020_SalesFuturePrice.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a005165d | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2404 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b229e8f | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2405 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc022257 | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2408 |  | POPUP | new DMF0020_SalesFuturePricePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-bcc405cb | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2409 |  | CALL_EXT | popup.LoadData | (drpDateTime.Value1.ToString("yyyyMM"), drpDateTime.Value1.AddYears(1).ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2511a0e5 | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2410 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-33006328 | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2411 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4640dd78 | this.btnExchangeRate.Click | DMF0020_SalesFuturePrice.cs:2416 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesFuturePrice.btnModelType_Click

진입점: this.btnItemId.Click / this.umltModel.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1aad2ec4 | this.btnItemId.Click 외 1 | DMF0020_SalesFuturePrice.cs:2455 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e824e393 | this.btnItemId.Click 외 1 | DMF0020_SalesFuturePrice.cs:2458 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8ac9950e | this.btnItemId.Click 외 1 | DMF0020_SalesFuturePrice.cs:2459 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-76042d7a | this.btnItemId.Click 외 1 | DMF0020_SalesFuturePrice.cs:2460 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4af2f1e6 | this.btnItemId.Click 외 1 | DMF0020_SalesFuturePrice.cs:2462 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-144cb547 | this.btnOwner.Click | DMF0020_SalesFuturePrice.cs:3782 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9d3a944c | this.btnOwner.Click | DMF0020_SalesFuturePrice.cs:3785 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c697bc10 | this.btnOwner.Click | DMF0020_SalesFuturePrice.cs:3786 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5ed06717 | this.btnOwner.Click | DMF0020_SalesFuturePrice.cs:3787 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e2bf5657 | this.btnOwner.Click | DMF0020_SalesFuturePrice.cs:3789 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.btnSavePricePeriod_Click

진입점: this.btnSavePricePeriod.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2257b97 | this.btnSavePricePeriod.Click | DMF0020_SalesFuturePrice.cs:2369 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00408") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0d491dd | this.btnSavePricePeriod.Click | DMF0020_SalesFuturePrice.cs:2370 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-296506e3 | this.btnSavePricePeriod.Click | DMF0020_SalesFuturePrice.cs:2374 |  | POPUP | new DMF0020_SaveSalesFuturePrice_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-6d247e41 | this.btnSavePricePeriod.Click | DMF0020_SalesFuturePrice.cs:2379 |  | CALL_EXT | popup.LoadData | (clbDivisions.ControlValues.ToString() , drpDateTime.Value1.ToString("yyyyMMdd"), drpDateT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bf99b5b | this.btnSavePricePeriod.Click | DMF0020_SalesFuturePrice.cs:2385 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4b4f30f6 | this.btnSavePricePeriod.Click | DMF0020_SalesFuturePrice.cs:2386 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0020_SalesFuturePrice.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ab7e276 | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3900 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd862662 | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3903 |  | POPUP | new DMF0073_VersionBySalesPricePopup | () | 팝업/폼 생성 |  |  |  |
| AC-0ddde25d | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3904 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartDate, sEndDate) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7313432b | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3905 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4cf01ee0 | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3906 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-12081d15 | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3913 | if (popVersion.sVersions != "") ▸ if (sVersion.Length > 2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00255", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-549681fa | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3914 | if (popVersion.sVersions != "") ▸ if (sVersion.Length > 2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba6af6a1 | this.btnSPVer.Click | DMF0020_SalesFuturePrice.cs:3918 | if (popVersion.sVersions != "") ▸ else of (sVersion.Length > 2) | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.btnTemplate_Click

진입점: this.btnTemplate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ceeb2a | this.btnTemplate.Click | DMF0020_SalesFuturePrice.cs:3930 |  | POPUP | new GSCM.DM.Master.UIL.POPUP.DMF0020_SalesPriceTemplatePopup | (CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)) | 팝업/폼 생성 |  |  |  |
| AC-73bdb29c | this.btnTemplate.Click | DMF0020_SalesFuturePrice.cs:3931 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c21a058d | this.btnTemplate.Click | DMF0020_SalesFuturePrice.cs:3932 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0020_SalesFuturePrice.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29596563 | this.cboBucketType.Click | DMF0020_SalesFuturePrice.cs:3823 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f4f6b3a | this.cboBucketType.Click | DMF0020_SalesFuturePrice.cs:3824 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.clbDivisions_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a78bcb5 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2473 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b8f291c | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2476 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6ac4300d | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2485 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-edd9d426 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2496 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-918721ea | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2499 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtBizType | GetBizTypebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bda2a31f | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2502 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d60c3fba | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2504 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e0e425f9 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2506 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | layoutControlItem6.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-eeeb9370 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2515 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision.IndexOf("81") != -1) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByEndCustomer, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-480a9d33 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2521 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "82") | STATE | checkInvalidExec.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0f0b3445 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2522 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "82") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2d3181b8 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2523 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "82") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-b6d1ccb7 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2527 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ else of (sDivision == "82") | STATE | checkInvalidExec.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c757321b | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2528 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ else of (sDivision == "82") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f694e79f | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2536 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2eee23cb | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2542 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-05a9be8b | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2544 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4cfd0ada | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2545 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fa5c4a8b | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2547 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | layoutControlItem6.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6681a555 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2549 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | checkInvalidExec.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5f2cf34a | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2551 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-5353ff44 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2556 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f405b5ae | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2563 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3cdd7540 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2572 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a8de5742 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2573 | try | VALUE_CLEAR | this.umltProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e3b53c27 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2574 | try | VALUE_CLEAR | this.umltModel.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-25cb7383 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2581 | try ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnExcelUpload.Visible | btnTemplate.Visible = true | 컨트롤 상태 Visible |  |  |  |
| AC-dedfc6f8 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2581 | try ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnTemplate.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-6807ba1e | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2582 | try ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c45c2d91 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2583 | try ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem29.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-50b29b96 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2587 | try ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnExcelUpload.Visible | btnTemplate.Visible = false | 컨트롤 상태 Visible |  |  |  |
| AC-3670fea8 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2587 | try ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnTemplate.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-ecf0c3e4 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2588 | try ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-74e022ff | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2589 | try ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem29.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a5c521eb | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2594 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-76853949 | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2595 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-582b550a | this.clbDivisions.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:2599 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesFuturePrice.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-521058c8 | this.clbEndCustomer.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:3544 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0020_SalesFuturePrice.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11a2317b | this.clbTeam.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:3673 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d47f3659 | this.clbTeam.SelectedIndexChanged | DMF0020_SalesFuturePrice.cs:3679 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0020_SalesFuturePrice.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d868809 | this.Load | DMF0020_SalesFuturePrice.cs:543 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3da6d313 | this.Load | DMF0020_SalesFuturePrice.cs:544 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e284a95 | this.Load | DMF0020_SalesFuturePrice.cs:545 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesFuturePrice.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3aabcb32 | this.Load | DMF0020_SalesFuturePrice.cs:439 |  | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-75f9e7d3 | this.Load | DMF0020_SalesFuturePrice.cs:440 |  | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-d6e085e4 | this.Load | DMF0020_SalesFuturePrice.cs:442 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-f2a7ddd0 | this.Load | DMF0020_SalesFuturePrice.cs:444 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-a86d5dd3 | this.Load | DMF0020_SalesFuturePrice.cs:446 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-cb9d892c | this.Load | DMF0020_SalesFuturePrice.cs:447 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c441106 | this.Load | DMF0020_SalesFuturePrice.cs:448 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-fbb9ee77 | this.Load | DMF0020_SalesFuturePrice.cs:449 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-5a7529bf | this.Load | DMF0020_SalesFuturePrice.cs:450 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-510cf2a9 | this.Load | DMF0020_SalesFuturePrice.cs:460 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-eb8732ed | this.Load | DMF0020_SalesFuturePrice.cs:465 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0020_SalesFuturePrice.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e0fdf1e | DeleteButton | DMF0020_SalesFuturePrice.cs:849 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-428c69d3 | DeleteButton | DMF0020_SalesFuturePrice.cs:856 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-847d3c7a | DeleteButton | DMF0020_SalesFuturePrice.cs:857 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0020_SalesFuturePrice.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65173717 | Dispose | DMF0020_SalesFuturePrice.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesFuturePrice.DMF0020_SalesFuturePrice_Resize

진입점: this.Resize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e973f2da | this.Resize | DMF0020_SalesFuturePrice.cs:3534 | if (panel1.Visible == true) | UI_PROP | panel1.Left | (this.ClientSize.Width - panel1.Width) / 2 | 속성 Left 설정 |  |  |  |
| AC-d27151dd | this.Resize | DMF0020_SalesFuturePrice.cs:3535 | if (panel1.Visible == true) | UI_PROP | panel1.Top | (this.ClientSize.Height - panel1.Height) / 2 | 속성 Top 설정 |  |  |  |

## DMF0020_SalesFuturePrice.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e308c08 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:2981 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adb46ddb | dsdm.Changed | DMF0020_SalesFuturePrice.cs:2993 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7d5e5a3 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:2994 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e145c76c | dsdm.Changed | DMF0020_SalesFuturePrice.cs:2995 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da8bc30a | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3010 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetText2 | (e.Row, e.Column, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-327359d8 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3011 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c878a9d | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3024 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d8736ed | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3036 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetText2 | (e.Row - i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Sub… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bde1538b | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3037 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row - i, e.Column, e.Row - i, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d3e7216 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3042 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bbdcd4ca | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3052 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetText2 | (e.Row - i, e.Column, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c04476f3 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3055 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-35343418 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3085 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-013bcdcd | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3085 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea016d09 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3086 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c6fa103c | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3094 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-8c796533 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3094 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf7fd9e7 | dsdm.Changed | DMF0020_SalesFuturePrice.cs:3095 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0020_SalesFuturePrice.EditButton

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b52129 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:864 | if (!isCurVersion) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1302665f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:870 | if (this.fps != null) | FLAG | dtDM_UI_EDITABLE_DIVISION | GetLookupValues("DM_UI_EDITABLE_DIVISION", "DMF0020", clbDivisions.ControlValues, "", "", … ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-05db1d87 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:873 | if (this.fps != null) | DATA_OP | dtDM_UI_EDITABLE_DIVISION.Columns.Contains | ("EDIT_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bc16668 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:874 | if (this.fps != null) | CALL_EXT | dtDM_UI_EDITABLE_DIVISION.Rows[0]["EDIT_YN"].String | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca529aff | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:876 | if (this.fps != null) ▸ if (dtDM_UI_EDITABLE_DIVISION != null && dtDM_UI_EDITABLE_DIVISION.Rows.Count > 0 && dtDM_UI_EDITABLE_DIVISION.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00448") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-375aaae0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:877 | if (this.fps != null) ▸ if (dtDM_UI_EDITABLE_DIVISION != null && dtDM_UI_EDITABLE_DIVISION.Rows.Count > 0 && dtDM_UI_EDITABLE_DIVISION.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bb44e16 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:892 | if (this.fps != null) ▸ if (clbDivisions.ControlValues == "40") ▸ if ((siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0) \|\| (siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-219fb381 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:893 | if (this.fps != null) ▸ if (clbDivisions.ControlValues == "40") ▸ if ((siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0) \|\| (siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e67df7f9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:923 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if ((siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c367e4a8 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:924 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if ((siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef1c4339 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:938 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if (cl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d74ecad6 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:939 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if (cl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94afe1bc | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:952 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.PRICE_EXIST) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00412", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe7a6461 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:954 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.PRICE_EXIST) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4ed4430 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:959 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb8208b0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:960 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6dcc878b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:961 | if (this.fps != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-75ed5d52 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:980 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetCol… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5291c3ec | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:986 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetCol… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-778e74c3 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:991 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f73969f8 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1002 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucke… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-393d9388 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1007 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucke… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3ecd9801 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1012 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucke… | GRID_LOCK | siMain.LockColumn2 | (iCol, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f695260a | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1034 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-34083807 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1036 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), iRow, siMain.GetColumnIndex(DefColumns.D… | 그리드 편집 잠금 전환 |  |  |  |
| AC-bfc3555c | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1038 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.DEPT_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-22ca269b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1040 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-d70b53d7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1042 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e6f5589e | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1044 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-6d5782ce | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1046 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-d153103a | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1048 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-2db0d2c8 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1050 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.BizType), iRow, siMain.GetColumnIndex(DefColumns.B… | 그리드 편집 잠금 전환 |  |  |  |
| AC-4c27cae9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1052 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e2cbb726 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1054 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e881a018 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1056 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8c4a15dd | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1058 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-136743ff | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1060 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed071c73 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1062 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금 전환 |  |  |  |
| AC-5ffe3543 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1066 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e4188c7c | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1074 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금 전환 |  |  |  |
| AC-fec96ac6 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1086 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-6d6d249c | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1090 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-52422467 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1100 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-07fea65d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1108 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-221c0595 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1109 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-09ffef7b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1119 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-fec47da9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1121 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금 전환 |  |  |  |
| AC-9414ce98 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1123 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-31cd752f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1127 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-fac2d1bc | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1129 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8bc16bf7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1131 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금 전환 |  |  |  |
| AC-c5dcbf47 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1133 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금 전환 |  |  |  |
| AC-91cef40f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1151 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex("W_" + sLast… | 그리드 편집 잠금 전환 |  |  |  |
| AC-9fcaa02d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1181 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper().IndexOf("KRW") > -1 \|\| sMeasure.ToUpper().IndexOf("… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금 전환 |  |  |  |
| AC-83c76f7b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1192 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "LOC") ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ i… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.CURRENCY), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-1ff5a977 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1193 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "LOC") ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ i… | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.CURRENCY].MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 그리드 속성/값 설정 |  |  |  |
| AC-d46a2bbd | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1214 | if (this.fps != null) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor2 | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-18f338ba | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1215 | if (this.fps != null) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor2 | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-436c17bb | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0020_SalesFuturePrice.cs:1218 | if (this.fps != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0020_SalesFuturePrice.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-499f3971 | ExcelButton | DMF0020_SalesFuturePrice.cs:1237 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-ef2a8957 | ExcelButton | DMF0020_SalesFuturePrice.cs:1238 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-c0b0dd51 | ExcelButton | DMF0020_SalesFuturePrice.cs:1239 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-a54e545a | ExcelButton | DMF0020_SalesFuturePrice.cs:1240 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-ff5b469a | ExcelButton | DMF0020_SalesFuturePrice.cs:1241 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-152f8353 | ExcelButton | DMF0020_SalesFuturePrice.cs:1242 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-be272f5c | ExcelButton | DMF0020_SalesFuturePrice.cs:1244 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-a7d07ab5 | ExcelButton | DMF0020_SalesFuturePrice.cs:1245 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-1ee94d60 | ExcelButton | DMF0020_SalesFuturePrice.cs:1247 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-0854e1fa | ExcelButton | DMF0020_SalesFuturePrice.cs:1251 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b905848 | ExcelButton | DMF0020_SalesFuturePrice.cs:1256 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-027d9eec | ExcelButton | DMF0020_SalesFuturePrice.cs:1260 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0020_SalesFuturePrice.FindData

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f82fe140 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1272 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-997dd658 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1279 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4da649dd | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1280 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6df9f915 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1286 | try ▸ if (txtVersion.Text.Trim() == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ae0678a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1287 | try ▸ if (txtVersion.Text.Trim() == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-602c1ef7 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1291 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-874c99a5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1294 | try | FLAG | isCurVersion | false | 화면 필드/플래그 변경 |  |  |  |
| AC-790a4fce | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1307 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-902a5e07 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1308 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6b1399a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1327 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4306a43c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1328 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac4b1db8 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1332 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28fafba6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1343 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5d97108c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1345 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd73d6e6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1349 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_SCM_MST_FUTURE_PRICE") ⇒ DM.DMF0020_GET_SCM_MST_FUTURE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-8f88a581 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1351 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3a572d30 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1353 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff4ec936 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1354 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7e12c4d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1355 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-2e43ce37 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1356 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e8a7220e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1357 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-551e978f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1358 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-38636aae | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1359 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-33f242b4 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1360 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-27263412 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1361 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8928bd7 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1362 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-287dd24e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1363 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-497740b1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1364 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-62d9ed58 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1365 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d63a3627 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1366 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-28957159 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1367 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-10e3d721 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1368 | try ▸ lambda | DATA_OP | request.Parameters["p_over_range"] | sOverRange | 행/컬럼 값 대입 |  |  |  |
| AC-591587fd | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1369 | try ▸ lambda | DATA_OP | request.Parameters["p_invalid_exec"] | sInvalidExec | 행/컬럼 값 대입 |  |  |  |
| AC-a9e12205 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1372 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-d38ddc2a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1374 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5db3b873 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1376 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-78eabde1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1381 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6c69056 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1388 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5905d24f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1401 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select("", sSortList).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a9fea1fc | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1401 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select | ("", sSortList) | 데이터 객체 조작/조회 |  |  |  |
| AC-02e14b02 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1402 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Remove | (ds.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c79f1d2 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1403 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-041b0da5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1405 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8eacca6c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1406 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f38c41f5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1410 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-eeeff88b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1444 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor2 | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-eb57d8c9 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1445 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor2 | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-9fbb486a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1452 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (txtVersion.Text.Trim() == "Current") | FLAG | isCurVersion | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cda73c6c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1467 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-69711416 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1472 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f02682e0 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1485 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!sColList.Equals("")) ▸ for (i < result.Length) | GRID_STYLE | siMain.SetBGColor2 | (iRow, iResultCol, iRow, iResultCol, Color.Pink) | 그리드 표시 설정 |  |  |  |
| AC-26020143 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1494 | try ▸ catch ((Exception exi)) | THROW | throw exi; |  | 예외 발생 |  |  |  |
| AC-336ea226 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1504 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-b01a0db2 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1505 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-62d10df5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1507 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5b7a7f4 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1513 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-79ede317 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1516 | try | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-d35bace4 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1518 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2a33bbbd | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1522 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecbda4bc | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1524 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bb370bf4 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1528 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b5cec8ae | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1533 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e86c2fcf | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DMF0020_SalesFuturePrice.cs:1534 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesFuturePrice.fnValidation

진입점: SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e5922d5 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | DMF0020_SalesFuturePrice.cs:2344 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-3fac7f58 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | DMF0020_SalesFuturePrice.cs:2347 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cfb23ec | this.Load | DMF0020_SalesFuturePrice.cs:194 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa3b687f | this.Load | DMF0020_SalesFuturePrice.cs:196 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e244130e | this.Load | DMF0020_SalesFuturePrice.cs:205 | if (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnExcelUpload.Visible | btnTemplate.Visible = true | 컨트롤 상태 Visible |  |  |  |
| AC-7b5110d1 | this.Load | DMF0020_SalesFuturePrice.cs:205 | if (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnTemplate.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-326b3c6d | this.Load | DMF0020_SalesFuturePrice.cs:206 | if (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9926664e | this.Load | DMF0020_SalesFuturePrice.cs:207 | if (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem29.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-94819650 | this.Load | DMF0020_SalesFuturePrice.cs:211 | else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnExcelUpload.Visible | btnTemplate.Visible = false | 컨트롤 상태 Visible |  |  |  |
| AC-a04475f9 | this.Load | DMF0020_SalesFuturePrice.cs:211 | else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | STATE | btnTemplate.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9c65c8b4 | this.Load | DMF0020_SalesFuturePrice.cs:212 | else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-053392e5 | this.Load | DMF0020_SalesFuturePrice.cs:213 | else of (clbDivisions.ControlValues.Substring(0, 2) == "81") | UI_PROP | layoutControlItem29.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0020_SalesFuturePrice.GetBizTypebyDivision

진입점: this.clbDivisions.SelectedIndexChanged [try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2075561f | this.clbDivisions.SelectedIndexChanged [try ▸ if ((sDivision… | DMF0020_SalesFuturePrice.cs:3631 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-cec03e7a | this.clbDivisions.SelectedIndexChanged [try ▸ if ((sDivision… | DMF0020_SalesFuturePrice.cs:3632 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ce5f78db | this.clbDivisions.SelectedIndexChanged [try ▸ if ((sDivision… | DMF0020_SalesFuturePrice.cs:3633 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35bbe232 | this.clbDivisions.SelectedIndexChanged [try ▸ if ((sDivision… | DMF0020_SalesFuturePrice.cs:3636 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e94836a | this.Load | DMF0020_SalesFuturePrice.cs:3810 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-da0366ba | this.Load | DMF0020_SalesFuturePrice.cs:3811 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b7ea1f7 | this.Load | DMF0020_SalesFuturePrice.cs:3814 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a59ae7f3 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:1980 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetCellIndexBySpanRowCells

진입점: this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveSheet.SheetName)) ▸ if (sDivision == "82" && (_Column == spread.GetColumnIndex(DefColumns.INCOTERMS)))] / this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ else of (e.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45d08fbc | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 5 | DMF0020_SalesFuturePrice.cs:2933 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbded52c | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 5 | DMF0020_SalesFuturePrice.cs:2934 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14b71a61 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 2 | DMF0020_SalesFuturePrice.cs:2965 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-ca945ebe | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 2 | DMF0020_SalesFuturePrice.cs:2970 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79e9d84f | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3585 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-535bef19 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3586 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ca9f6ee1 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3587 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-34c2fc7d | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3588 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a29982b | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3591 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4fb69a6 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3600 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-42f08c4a | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3601 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bed6a9d0 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3602 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-fde0127f | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3603 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d1d2069f | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3606 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetCustomsHandbook

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d4d4fb5 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3883 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-8ff786e6 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3884 |  | DATA_OP | request.Parameters["CODE"] | "DM_CUSTOMS_HANDBOOK" | 행/컬럼 값 대입 |  |  |  |
| AC-2a6eafa1 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3885 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5266b04a | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3886 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-52c6d607 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3887 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89a6cc2e | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3888 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f5ea7df | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3889 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a091f2a | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3890 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d907389a | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0020_SalesFuturePrice.cs:3892 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6650b155 | this.Load | DMF0020_SalesFuturePrice.cs:423 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-c2f191a7 | this.Load | DMF0020_SalesFuturePrice.cs:424 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-239bc9ed | this.Load | DMF0020_SalesFuturePrice.cs:425 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-383bba11 | this.Load | DMF0020_SalesFuturePrice.cs:427 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e17cf9fd | this.Load | DMF0020_SalesFuturePrice.cs:430 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d56dbfab | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3360 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3aa92ba6 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3362 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d03a752 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3365 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2538767c | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3419 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-28570355 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3420 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0cf1fbdc | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3421 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-1c4f2b56 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3422 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5150a09d | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3425 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetExchangeRate

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOT…) ▸ else of (e.Column == siMain.GetColumnIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7f48c6d | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3172 | if (sBaseER == sTargetER) | RETURN | return sValue; |  | 처리 중단/반환 |  |  |  |
| AC-05c7eb9a | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3175 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sTargetER + "' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-ae0ac266 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3179 | if (row.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-0eb44da3 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3183 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sBaseER + "' AND UNIT_CURRENCY = '" + sTargetER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-619c72e5 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3188 | if (row1.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-0fe9b2f1 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3192 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' A… | 데이터 객체 조작/조회 |  |  |  |
| AC-67cf4347 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3196 | if (row4.Length > 0) | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' AND YYYYMM = '" + sYYYYMM + "' AND DIVISION_… | 데이터 객체 조작/조회 |  |  |  |
| AC-97953773 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3201 | if (row4.Length > 0) ▸ if (row5.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-243b61fb | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3206 | if (sTargetVal == null) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-5297c9c8 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3208 | else of (sTargetVal == null) | RETURN | return "0"; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.Load / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e5df66c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | DMF0020_SalesFuturePrice.cs:531 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_FUTUREPRICE_INFO") ⇒ DM.DMF0020_GET_FUTUREPRICE_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-2d193616 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | DMF0020_SalesFuturePrice.cs:532 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-37692992 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | DMF0020_SalesFuturePrice.cs:533 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e17bc970 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | DMF0020_SalesFuturePrice.cs:535 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1a132003 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 4 | DMF0020_SalesFuturePrice.cs:538 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetLookupValues

진입점: this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveSheet.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / EditButton [if (this.fps != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f021c5d | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3434 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-1f5e0671 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3435 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-905221a0 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3436 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-350e49ab | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3439 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-cab984b3 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3957 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-5ab4b8fd | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3958 |  | DATA_OP | request.Parameters["CODE"] | p_code | 행/컬럼 값 대입 |  |  |  |
| AC-a6159d00 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3959 |  | DATA_OP | request.Parameters["PARAM1"] | p_param1 | 행/컬럼 값 대입 |  |  |  |
| AC-b8b12b6d | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3960 |  | DATA_OP | request.Parameters["PARAM2"] | p_param2 | 행/컬럼 값 대입 |  |  |  |
| AC-587fbe16 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3961 |  | DATA_OP | request.Parameters["PARAM3"] | p_param3 | 행/컬럼 값 대입 |  |  |  |
| AC-9813ed50 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3962 |  | DATA_OP | request.Parameters["PARAM4"] | p_param4 | 행/컬럼 값 대입 |  |  |  |
| AC-20945aa5 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3963 |  | DATA_OP | request.Parameters["PARAM5"] | p_param5 | 행/컬럼 값 대입 |  |  |  |
| AC-d78f8c0c | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3964 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7648ff0c | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… 외 3 | DMF0020_SalesFuturePrice.cs:3966 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetMeasureCountInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fe00b39 | this.Load | DMF0020_SalesFuturePrice.cs:514 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_MEASURE_COUNTINFO") ⇒ DM.DMF0020_GET_MEASURE_COUNTINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-157a5852 | this.Load | DMF0020_SalesFuturePrice.cs:516 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cee901a7 | this.Load | DMF0020_SalesFuturePrice.cs:519 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aff76a0f | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3448 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-f22c0822 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3449 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1971d804 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3450 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ac0e2dc8 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3451 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-146d43fd | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3452 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31fffffb | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3455 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47a68e45 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3615 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-bfb49c3f | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3616 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-73a0b4df | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3617 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-4651bb49 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3618 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-1be77e7e | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3619 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06a0e81d | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3622 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a134e063 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3374 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3e329b70 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3375 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c317f092 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3376 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-14d1bf47 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3377 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-63397501 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3378 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37a53186 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3381 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c04592 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3645 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7aade7f7 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3646 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-beaf877e | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3647 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b24231eb | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3648 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-628a8e37 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3649 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e80ed3f3 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3652 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetScmSiteInfobyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d3601f0 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3390 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d8257b68 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3391 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1bd34a9a | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3392 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-02618237 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3393 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fdcf0656 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3396 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetSpdTitle

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yy…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b6ec155 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3554 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_SPREAD_TITLE") ⇒ DM.DMF0020_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-65fd88ce | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3555 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-c997d2b3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3556 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-d6e9ecdc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3557 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f91cfa43 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3558 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-8ad13d60 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3560 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2a322f7d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3560 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5575674c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:3563 |  | RETURN | return dsSpdTitle; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccfd07ed | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3405 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b8bd5611 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3406 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-74a2240c | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3407 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7bbd29d | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3410 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcb43c49 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3572 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d2f515e0 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3573 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8862f32f | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3574 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f5b46bdf | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3576 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetThisWeekMonday

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4826fa6b | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:3513 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.GetWeekData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54c87c4d | this.Load | DMF0020_SalesFuturePrice.cs:498 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_WEEKDATA") ⇒ DM.DMF0020_GET_WEEKDATA | 엔드포인트 요청 생성 |  |  |  |
| AC-973b0347 | this.Load | DMF0020_SalesFuturePrice.cs:499 |  | DATA_OP | request.Parameters["p_yyyymmdd"] | System.DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-22286f4a | this.Load | DMF0020_SalesFuturePrice.cs:501 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c525e5bc | this.Load | DMF0020_SalesFuturePrice.cs:504 |  | RETURN | return dsWeek; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5bd3504 | this.Load | DMF0020_SalesFuturePrice.cs:295 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-f0e22949 | this.Load | DMF0020_SalesFuturePrice.cs:299 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-26b1a424 | this.Load | DMF0020_SalesFuturePrice.cs:304 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-87624991 | this.Load | DMF0020_SalesFuturePrice.cs:310 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-1cfcb1bc | this.Load | DMF0020_SalesFuturePrice.cs:310 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13bb59f6 | this.Load | DMF0020_SalesFuturePrice.cs:315 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7a5b38bb | this.Load | DMF0020_SalesFuturePrice.cs:325 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-54e6dfcf | this.Load | DMF0020_SalesFuturePrice.cs:330 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ca517dbd | this.Load | DMF0020_SalesFuturePrice.cs:332 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2938a539 | this.Load | DMF0020_SalesFuturePrice.cs:333 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5312c172 | this.Load | DMF0020_SalesFuturePrice.cs:335 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | layoutControlItem6.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5239adc2 | this.Load | DMF0020_SalesFuturePrice.cs:341 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "82") | STATE | checkInvalidExec.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c7bb828c | this.Load | DMF0020_SalesFuturePrice.cs:345 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ else of (sDivision == "82") | STATE | checkInvalidExec.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b084ffaf | this.Load | DMF0020_SalesFuturePrice.cs:353 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6123a09a | this.Load | DMF0020_SalesFuturePrice.cs:358 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-10090ce5 | this.Load | DMF0020_SalesFuturePrice.cs:360 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0e7fc188 | this.Load | DMF0020_SalesFuturePrice.cs:361 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-10644d06 | this.Load | DMF0020_SalesFuturePrice.cs:363 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | layoutControlItem6.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e0340662 | this.Load | DMF0020_SalesFuturePrice.cs:365 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | umltProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-19aadd16 | this.Load | DMF0020_SalesFuturePrice.cs:366 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-cb8b42f5 | this.Load | DMF0020_SalesFuturePrice.cs:369 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | checkInvalidExec.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-36edad4b | this.Load | DMF0020_SalesFuturePrice.cs:375 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b7396673 | this.Load | DMF0020_SalesFuturePrice.cs:382 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-db09b30c | this.Load | DMF0020_SalesFuturePrice.cs:391 | if (sDivision.IndexOf("81") != -1) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByEndCustomer, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-802bdbc4 | this.Load | DMF0020_SalesFuturePrice.cs:399 |  | FLAG | dtMeasureCount | GetMeasureCountInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-d3179dc1 | this.Load | DMF0020_SalesFuturePrice.cs:401 |  | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-19fa1daa | this.Load | DMF0020_SalesFuturePrice.cs:405 |  | FLAG | dtWeek | GetWeekData() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ec8a401 | this.Load | DMF0020_SalesFuturePrice.cs:408 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a1af03fa | this.Load | DMF0020_SalesFuturePrice.cs:409 |  | DATA_OP | dtBucketType.Rows.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-b42b948e | this.Load | DMF0020_SalesFuturePrice.cs:410 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-264b7859 | this.Load | DMF0020_SalesFuturePrice.cs:415 |  | VALUE_SET | txtVersion.Text | "Current" | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.InitSpread

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.Load / this.clbDivisions.SelectedIndexChanged [try] / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3979434 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | DMF0020_SalesFuturePrice.cs:579 | if (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f2e7abc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | DMF0020_SalesFuturePrice.cs:584 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e551177a | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | DMF0020_SalesFuturePrice.cs:585 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-b33b95c2 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 6 | DMF0020_SalesFuturePrice.cs:589 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dsTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |

## DMF0020_SalesFuturePrice.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7927afd8 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:776 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a58ff9a5 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:782 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-8615334e | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:783 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b346faaa | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:784 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4deae8ab | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:786 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0020_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM.DMF0020_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c943545b | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:786 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0020_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-5722e9d9 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:801 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["DATE_SHORT1_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPM… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbaddf57 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:803 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.MEASURE) + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].T… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff28ca04 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:809 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2799e73b | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:818 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c3888c2 | (진입점 미연결) | DMF0020_SalesFuturePrice.cs:824 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0020_SalesFuturePrice.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d007a413 | InsertButton | DMF0020_SalesFuturePrice.cs:839 | if (!isCurVersion) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89c5e139 | InsertButton | DMF0020_SalesFuturePrice.cs:1990 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8b67a617 | InsertButton | DMF0020_SalesFuturePrice.cs:1993 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-03a49d74 | InsertButton | DMF0020_SalesFuturePrice.cs:1996 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-26bbb24b | InsertButton | DMF0020_SalesFuturePrice.cs:1997 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.Insert2 | (dtMeasureCount.Rows.Count) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae032d48 | InsertButton | DMF0020_SalesFuturePrice.cs:2003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-141af1d6 | InsertButton | DMF0020_SalesFuturePrice.cs:2009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-62041385 | InsertButton | DMF0020_SalesFuturePrice.cs:2010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a7f1f61 | InsertButton | DMF0020_SalesFuturePrice.cs:2013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bf09bc71 | InsertButton | DMF0020_SalesFuturePrice.cs:2023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3468d54b | InsertButton | DMF0020_SalesFuturePrice.cs:2024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90f8d2ec | InsertButton | DMF0020_SalesFuturePrice.cs:2027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtincotermsEditType | GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-abaaf60d | InsertButton | DMF0020_SalesFuturePrice.cs:2029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtincotermsEditType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8d7646b5 | InsertButton | DMF0020_SalesFuturePrice.cs:2034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e84f62de | InsertButton | DMF0020_SalesFuturePrice.cs:2036 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-04fba5cc | InsertButton | DMF0020_SalesFuturePrice.cs:2038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c0f74c61 | InsertButton | DMF0020_SalesFuturePrice.cs:2040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-89886735 | InsertButton | DMF0020_SalesFuturePrice.cs:2042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomerAut… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-038a45f8 | InsertButton | DMF0020_SalesFuturePrice.cs:2044 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-97ac9a1a | InsertButton | DMF0020_SalesFuturePrice.cs:2051 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | CALL_EXT | siMain.SetText2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivisions.Se… | ⚠ 의미 확인 필요 |  |  |  |
| AC-445a881d | InsertButton | DMF0020_SalesFuturePrice.cs:2052 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-5bf13318 | InsertButton | DMF0020_SalesFuturePrice.cs:2056 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtincotermsEditType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f717aa51 | InsertButton | DMF0020_SalesFuturePrice.cs:2059 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4a78284b | InsertButton | DMF0020_SalesFuturePrice.cs:2067 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4f795646 | InsertButton | DMF0020_SalesFuturePrice.cs:2072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-275da236 | InsertButton | DMF0020_SalesFuturePrice.cs:2074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | CALL_EXT | siMain.SetText2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasureCount.Rows… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b75577d0 | InsertButton | DMF0020_SalesFuturePrice.cs:2076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, siMain.Acti… | 그리드 편집 잠금 전환 |  |  |  |
| AC-4de26e24 | InsertButton | DMF0020_SalesFuturePrice.cs:2080 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustome… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ec3e10a6 | InsertButton | DMF0020_SalesFuturePrice.cs:2086 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerA… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4a28078f | InsertButton | DMF0020_SalesFuturePrice.cs:2088 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJE… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3ce44f40 | InsertButton | DMF0020_SalesFuturePrice.cs:2090 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveR… | 그리드 편집 잠금 전환 |  |  |  |
| AC-1b4c89c9 | InsertButton | DMF0020_SalesFuturePrice.cs:2092 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.Active… | 그리드 편집 잠금 전환 |  |  |  |
| AC-2fc8eb2f | InsertButton | DMF0020_SalesFuturePrice.cs:2094 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-f9687d22 | InsertButton | DMF0020_SalesFuturePrice.cs:2100 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.Acti… | 그리드 편집 잠금 전환 |  |  |  |
| AC-7690fa04 | InsertButton | DMF0020_SalesFuturePrice.cs:2102 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowI… | 그리드 편집 잠금 전환 |  |  |  |
| AC-34062533 | InsertButton | DMF0020_SalesFuturePrice.cs:2104 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e4643147 | InsertButton | DMF0020_SalesFuturePrice.cs:2106 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.ActiveRowI… | 그리드 편집 잠금 전환 |  |  |  |
| AC-c9cb6dfe | InsertButton | DMF0020_SalesFuturePrice.cs:2110 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-19fefe7f | InsertButton | DMF0020_SalesFuturePrice.cs:2165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-bfe55002 | InsertButton | DMF0020_SalesFuturePrice.cs:2175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange2 | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PRICE_EXIST), siMain.ActiveRo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ff1975e0 | InsertButton | DMF0020_SalesFuturePrice.cs:2180 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasureCount.Rows.Count - 1, 1, siMain.GetColumnIndex(De… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a4672f0 | InsertButton | DMF0020_SalesFuturePrice.cs:2194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain != null && siMain.A… | GRID_SET | siMain.ActiveSheet.RowFilter.UnfilteredRows | null | 그리드 속성/값 설정 |  |  |  |
| AC-280d1fed | InsertButton | DMF0020_SalesFuturePrice.cs:2195 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_BASE | ManualAutoFilter | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aacb2050 | InsertButton | DMF0020_SalesFuturePrice.cs:2196 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | this.IsChange | true | 속성 IsChange 설정 |  |  |  |
| AC-1530da2d | InsertButton | DMF0020_SalesFuturePrice.cs:2197 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-59d5b350 | InsertButton | DMF0020_SalesFuturePrice.cs:2198 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0020_SalesFuturePrice.Raw_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2b580b3 | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3706 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) | UI_MISC | spread.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1b0b73bf | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3713 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) ▸ if (_Column == spread.GetColumnIndex(DefColumns.PLANT_SITE_ID) \|\| sDivision.Substring(… | FLAG | dtPlantSite | Data.Common(Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByItem] | 화면 필드/플래그 변경 |  |  |  |
| AC-444114be | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3713 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) ▸ if (_Column == spread.GetColumnIndex(DefColumns.PLANT_SITE_ID) \|\| sDivision.Substring(… | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByItem] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70ae08bd | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3714 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) ▸ if (_Column == spread.GetColumnIndex(DefColumns.PLANT_SITE_ID) \|\| sDivision.Substring(… | GRID_COMBO | spread.SetCellTypeCombo | (_Row, spread.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b80a7b6b | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3718 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) | FLAG | dtincotermsEditType | GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-ea87054c | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3719 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) | GRID_COMBO | spread.SetCellTypeCombo | (_Row, spread.GetColumnIndex(DefColumns.INCOTERMS), dtincotermsEditType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-76f5b514 | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3722 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) | FLAG | sTempRow | _Row | 화면 필드/플래그 변경 |  |  |  |
| AC-14e72b40 | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3748 | if (!spread.IsLock(spread.ActiveSheet.SheetName)) | UI_MISC | spread.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0020_SalesFuturePrice.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce59f575 | SaveButton | DMF0020_SalesFuturePrice.cs:1540 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-520761bd | SaveButton | DMF0020_SalesFuturePrice.cs:1551 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-470004d6 | SaveButton | DMF0020_SalesFuturePrice.cs:1552 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c808d9b6 | SaveButton | DMF0020_SalesFuturePrice.cs:1555 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a0e7c62c | SaveButton | DMF0020_SalesFuturePrice.cs:1679 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-130f978b | SaveButton | DMF0020_SalesFuturePrice.cs:1682 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-207c16b1 | SaveButton | DMF0020_SalesFuturePrice.cs:1684 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cdce4d9 | SaveButton | DMF0020_SalesFuturePrice.cs:1703 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1ee837a | SaveButton | DMF0020_SalesFuturePrice.cs:1704 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb98cd9d | SaveButton | DMF0020_SalesFuturePrice.cs:1710 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-af25dfa5 | SaveButton | DMF0020_SalesFuturePrice.cs:1805 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1], j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a19ee73 | SaveButton | DMF0020_SalesFuturePrice.cs:1838 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-41dbf7b0 | SaveButton | DMF0020_SalesFuturePrice.cs:1839 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f15c2c0c | SaveButton | DMF0020_SalesFuturePrice.cs:1840 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-82be8096 | SaveButton | DMF0020_SalesFuturePrice.cs:1841 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-590c32af | SaveButton | DMF0020_SalesFuturePrice.cs:1842 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], p_plant_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ca81a684 | SaveButton | DMF0020_SalesFuturePrice.cs:1843 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7720813a | SaveButton | DMF0020_SalesFuturePrice.cs:1844 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-823c6395 | SaveButton | DMF0020_SalesFuturePrice.cs:1845 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-69f00d2b | SaveButton | DMF0020_SalesFuturePrice.cs:1847 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], sMEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-15db4d8f | SaveButton | DMF0020_SalesFuturePrice.cs:1848 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], sDomExp, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-29700ab9 | SaveButton | DMF0020_SalesFuturePrice.cs:1849 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], sFcstType, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-c1dddb99 | SaveButton | DMF0020_SalesFuturePrice.cs:1850 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f9d5fe3c | SaveButton | DMF0020_SalesFuturePrice.cs:1851 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PRICE"] | CString.AppendStringEx(nvc["p_PRICE"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7ae66611 | SaveButton | DMF0020_SalesFuturePrice.cs:1852 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-5e23e32a | SaveButton | DMF0020_SalesFuturePrice.cs:1853 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-edebaa8b | SaveButton | DMF0020_SalesFuturePrice.cs:1854 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-33ae6d94 | SaveButton | DMF0020_SalesFuturePrice.cs:1855 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_ROWNUM"] | CString.AppendStringEx(nvc["p_ROWNUM"], (i + 1).ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-fd237e50 | SaveButton | DMF0020_SalesFuturePrice.cs:1858 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-424d04af | SaveButton | DMF0020_SalesFuturePrice.cs:1868 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-69c881f6 | SaveButton | DMF0020_SalesFuturePrice.cs:1890 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (string.IsNullOr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00414", new object[] { sScmsiteid, sProjectname, sProjectcode, sItemid }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3aa1d102 | SaveButton | DMF0020_SalesFuturePrice.cs:1891 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (string.IsNullOr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35090f1f | SaveButton | DMF0020_SalesFuturePrice.cs:1898 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b47817f | SaveButton | DMF0020_SalesFuturePrice.cs:1902 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL") ⇒ DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-28cda1a7 | SaveButton | DMF0020_SalesFuturePrice.cs:1903 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-95190feb | SaveButton | DMF0020_SalesFuturePrice.cs:1906 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Co… | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-9a83304e | SaveButton | DMF0020_SalesFuturePrice.cs:1906 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Co… | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86804a88 | SaveButton | DMF0020_SalesFuturePrice.cs:1908 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6b42a30 | SaveButton | DMF0020_SalesFuturePrice.cs:1910 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8bc7e16f | SaveButton | DMF0020_SalesFuturePrice.cs:1924 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "succe… | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-088fa8b7 | SaveButton | DMF0020_SalesFuturePrice.cs:1925 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "succe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d05011d | SaveButton | DMF0020_SalesFuturePrice.cs:1929 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[3].Rows[0]… | MESSAGE | MessageBox.Show | (ds.Tables[3].Rows[0][0].ToString(), "Error!") | 메시지 표시 |  |  |  |
| AC-16ad9f5c | SaveButton | DMF0020_SalesFuturePrice.cs:1932 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-cf57424a | SaveButton | DMF0020_SalesFuturePrice.cs:1933 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_Total }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5383de56 | SaveButton | DMF0020_SalesFuturePrice.cs:1941 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[2].Rows.Co… | POPUP | new DMF0020_SalesPriceRangePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-79a4695a | SaveButton | DMF0020_SalesFuturePrice.cs:1942 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[2].Rows.Co… | CALL_EXT | popup.LoadData | (ds.Tables[2], sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-857fa889 | SaveButton | DMF0020_SalesFuturePrice.cs:1943 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[2].Rows.Co… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db99e5b0 | SaveButton | DMF0020_SalesFuturePrice.cs:1944 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[2].Rows.Co… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0e1fba3c | SaveButton | DMF0020_SalesFuturePrice.cs:1948 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-67adee0c | SaveButton | DMF0020_SalesFuturePrice.cs:1961 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-715a622d | SaveButton | DMF0020_SalesFuturePrice.cs:1965 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3645d44a | SaveButton | DMF0020_SalesFuturePrice.cs:1967 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesFuturePrice.SetChangeControl

진입점: this.clbEndCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if ((clbDivisions.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivisions.SelectedValue.ToString() == "82"))] / this.Load / this.clbDivisions.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b6f1cc7 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:229 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4dcbf7e3 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:230 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f424e3b2 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:236 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9bbba8d3 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:236 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-78cef61c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:241 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1c0bd5f8 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:243 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9bd65ca5 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:243 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-200634b2 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:248 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a9763b53 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:249 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-cd8628fe | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:251 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-35fe8abf | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:251 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0f0c2a3f | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:256 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-93f2e48c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:258 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-799e0012 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:258 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-62f0813c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:263 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7e90526a | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:264 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-5b844496 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:265 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-ccf3ac38 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:267 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b70b77b | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:267 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d4a888d7 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:272 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-92853cac | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:274 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-20039b68 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:274 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-724cf6e7 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:279 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2cf7aebf | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:280 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-3827f5b7 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:282 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSiteByEndCustomer | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-19824503 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0020_SalesFuturePrice.cs:282 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0020_SalesFuturePrice.SetExchangeValues

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOT…) ▸ else of (e.Column == siMain.GetColumnIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc6dc172 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3113 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3eb9f1b9 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3113 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-579527b7 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3118 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (sCurrency =… | CALL_EXT | siMain.SetText2 | (iRow, iColumn, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f63f268 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3119 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (sCurrency =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b82d68ec | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3124 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) | CALL_EXT | siMain.SetText2 | (iRow, iColumn, val) | ⚠ 의미 확인 필요 |  |  |  |
| AC-463c0b15 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3128 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetColor | (iRow, iColumn, iRow, iColumn, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b4d0ebb | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3136 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetText2 | (iRow - i, iColumn, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Subst… | ⚠ 의미 확인 필요 |  |  |  |
| AC-20cfc897 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3137 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetColor | (iRow - i, iColumn, iRow - i, iColumn, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-897f3b65 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3142 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-407a66dd | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3149 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ else of (!strin… | CALL_EXT | siMain.SetText2 | (iRow - i, iColumn, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-21df2e86 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0020_SalesFuturePrice.cs:3152 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ else of (!strin… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow - i, "M") | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesFuturePrice.SetRowSpanFucTwo

진입점: this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveSheet.SheetName)) ▸ if (sDivision == "82" && (_Column == spread.GetColumnIndex(DefColumns.INCOTERMS)))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38105a94 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… | DMF0020_SalesFuturePrice.cs:3857 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (sFYear != siSpread.GetText(j, i)) | GRID_STYLE | siSpread.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow - 1, 1) | 그리드 표시 설정 |  |  |  |
| AC-ea4bd99c | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… | DMF0020_SalesFuturePrice.cs:3865 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (j == iEndRow) | GRID_STYLE | siSpread.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow, 1) | 그리드 표시 설정 |  |  |  |
| AC-4f5447f4 | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… | DMF0020_SalesFuturePrice.cs:3872 | for (i <= iEndCol) | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-0a1e8cae | this.spdMain.CellClick [if (!spread.IsLock(spread.ActiveShee… | DMF0020_SalesFuturePrice.cs:3873 | for (i <= iEndCol) | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |

## DMF0020_SalesFuturePrice.SetSpreadColumn

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedInd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f27113c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:696 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3cc1d56f | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:700 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-28a9717a | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:701 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-d6d51336 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:708 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c3f1016b | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:709 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-946d749c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:714 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (siMain.GetColumnTag(iCol).I… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-01648622 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:738 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["MMDD"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 1… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3efc96fd | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:743 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 120, true, FPHAlign.Right… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5adcf221 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:749 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMeasureCol + iWeek, 1, 1, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-216b1fed | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:757 | for (i < dt.Rows.Count) ▸ else of (i == 0) ▸ if (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9fc1b3f | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:763 | for (i < dt.Rows.Count) ▸ else of (i == 0) ▸ else of (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c783ad03 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (siM… 외 7 | DMF0020_SalesFuturePrice.cs:768 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMeasureCol + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].ToString(), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesFuturePrice.SetSpreadHeaderSpan

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yy…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6c00ef0 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:624 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21be3140 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:632 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-590ca50f | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:644 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-063feb2b | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:645 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd96c15b | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:650 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fcb68c3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:658 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cac8f548 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:670 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67866a22 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:672 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90dfb5cc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:673 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-419d31ab | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:675 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-91789fb9 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 6 | DMF0020_SalesFuturePrice.cs:677 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesFuturePrice.SetTextCellsToRowSpanRange

진입점: this.spdMain.CellDoubleClick [if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siMain.GetColumn…) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME)) \|\| siMain.GetCol…) ▸ if (popItem.ItemID != "" \|\| popItem.ItemID != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199bd8d9 | this.spdMain.CellDoubleClick [if (e.ColumnHeader == false) ▸… | DMF0020_SalesFuturePrice.cs:2917 | for (i < iMeasureCount) | GRID_SET | siMain.SetValue | (iActiveRow + i, siMain.GetColumnIndex(sColName), objValue) | 그리드 값 설정 |  |  |  |
| AC-06016833 | this.spdMain.CellDoubleClick [if (e.ColumnHeader == false) ▸… | DMF0020_SalesFuturePrice.cs:2920 | for (i < iMeasureCount) ▸ if (sColName != "FCST_TYPE") | CALL_EXT | siMain.SetText2 | (iActiveRow + i, siMain.GetColumnIndex(sColName), objValue.ToString()) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesFuturePrice.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76df9162 | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3690 | if (e.Column == siMain.GetColumnIndex(DefColumns.CURRENCY) && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.String…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00447") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47d5b437 | this.spdMain.CellClick | DMF0020_SalesFuturePrice.cs:3694 | if (sender == null \|\| e == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePrice.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b5fb820 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3216 | if (e.ColumnHeader == false) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a225ded1 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3226 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae18f7a6 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3259 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e6b7f080 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3260 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-834512dc | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3261 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-015ca785 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3262 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e395bfed | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3275 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b82d540 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3277 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eff9ff09 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3279 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28c6d689 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3281 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49200517 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3286 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-423157ae | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3288 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.G… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-187bf1b0 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3293 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-6341dded | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3294 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-08981ab4 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3295 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8d12819c | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3296 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1ce0b26b | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3301 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ebefec3 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3303 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be11d7d7 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3305 | if (e.ColumnHeader == false) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siM… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebfced88 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3322 | else of (e.ColumnHeader == false) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (si… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-7c0ea7b2 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3326 | else of (e.ColumnHeader == false) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else o… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-3a418e92 | this.spdMain.CellDoubleClick | DMF0020_SalesFuturePrice.cs:3338 | else of (e.ColumnHeader == false) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12b46353 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2618 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c8acba18 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2618 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2249785 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2620 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8469680a | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2621 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row + 2, siMain.GetColumnInde… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a1644e5 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2630 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-e5aa3f2c | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2630 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9ba84c06 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2631 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aa81ee3b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2632 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f65a2bd | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2640 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-bc428903 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2640 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6e8b97e | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2641 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6d96a63e | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2642 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (siMain.GetColumnIn… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetCol… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1bfeb6a | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2648 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-2e95bf29 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2648 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b0552fb | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2650 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5ca4ee84 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2651 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-18265035 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2657 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2317f598 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2658 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row + 2, siMain.GetColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb3578b6 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2661 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivision.Substring(0, … | GRID_LOCK | siMain.LockRange2 | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e9fe658b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2663 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivision.Substrin… | GRID_LOCK | siMain.LockRange2 | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-81420631 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2667 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb28e65 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2669 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-91b2b53a | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2671 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ba9d08d | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2673 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4549941f | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2675 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-53571d38 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2677 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bae0f3d0 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2679 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b641879 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2690 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-d262d5ff | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2690 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca267d2e | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2691 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6cc55e68 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2693 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ac9292e | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2697 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-6c1b340b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2697 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc26bda1 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2698 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2157395e | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2700 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetCol… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5366eca3 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2702 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-0131f243 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2702 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-51a97f5c | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2703 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f695c1e7 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2704 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a14fdff3 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2707 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-20e24c6e | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2709 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-89b5d46b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2711 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5bfa4d57 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2713 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6bd4a8d9 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2715 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff6e3597 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2717 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-79567157 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2722 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-2997fe4b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2722 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be12afcf | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2723 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-88924805 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2724 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-47db47d0 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2725 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d68d6643 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2728 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f324f8d5 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2730 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6f121de | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2732 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-160d9b42 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2734 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ac9f53f | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2736 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc24c6d3 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2741 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-081fc1e1 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2743 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b0f83eb | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2745 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d1b76ee | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2747 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2390bf69 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2755 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ff889a6d | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2755 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92a9b2db | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2756 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fc3182e3 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2757 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetCol… | ⚠ 의미 확인 필요 |  |  |  |
| AC-695911e0 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2763 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), siMain.GetValue(sTempRow, siMain.GetC… | 그리드 값 설정 |  |  |  |
| AC-b4c6751c | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2767 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType), siMain.GetValue(sTempRow, siMain.GetCo… | 그리드 값 설정 |  |  |  |
| AC-c139b59d | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2771 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp), siMain.GetValue(sTempRow, siMain.GetColu… | 그리드 값 설정 |  |  |  |
| AC-fb051bf7 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2776 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.GetValue(sTempRow, siMain.GetCo… | 그리드 값 설정 |  |  |  |
| AC-7991d45d | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2796 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row - i, e.Column, sCurrency) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2457c0f6 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2797 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetColor | (e.Row - i, iCurrencyCol, e.Row - i, iCurrencyCol, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-356d4b5c | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2836 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row, e.Column, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c929ec17 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2837 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-169e5670 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2850 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetColor | (e.Row, iCCol, e.Row, iCCol, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74f64c3c | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2862 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row - i, iCCol, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Substr… | ⚠ 의미 확인 필요 |  |  |  |
| AC-52200cd3 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2863 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetColor | (e.Row - i, iCCol, e.Row - i, iCCol, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7df7060b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2868 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd6a279b | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2878 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | siMain.SetText2 | (e.Row - i, iCCol, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d36f89d1 | this.spdMain.ComboSelChange | DMF0020_SalesFuturePrice.cs:2881 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesFuturePrice.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71ec4d08 | this.spdMain.KeyUp | DMF0020_SalesFuturePrice.cs:3755 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58ef9012 | this.spdMain.KeyUp | DMF0020_SalesFuturePrice.cs:3759 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e16aa49 | this.spdMain.KeyUp | DMF0020_SalesFuturePrice.cs:3765 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-48299a94 | this.spdMain.KeyUp | DMF0020_SalesFuturePrice.cs:3766 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesFuturePrice.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32d32ae1 | this.spdMain.TopChange | DMF0020_SalesFuturePrice.cs:3350 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesFuturePrice.usrButton1_Click

진입점: this.usrButton1.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fe502a6 | this.usrButton1.Click 외 1 | DMF0020_SalesFuturePrice.cs:2433 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e662e6e6 | this.usrButton1.Click 외 1 | DMF0020_SalesFuturePrice.cs:2434 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-61f946e1 | this.usrButton1.Click 외 1 | DMF0020_SalesFuturePrice.cs:2435 | if (clbDivisions.SelectedValue.ToString() != "40") | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-704eed2d | this.usrButton1.Click 외 1 | DMF0020_SalesFuturePrice.cs:2436 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8c5b9005 | this.usrButton1.Click 외 1 | DMF0020_SalesFuturePrice.cs:2438 | if (clbDivisions.SelectedValue.ToString() != "40") | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesFuturePrice.usrDiscard_CheckedChanged

진입점: this.usrDiscard.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c07881b3 | this.usrDiscard.CheckedChanged | DMF0020_SalesFuturePrice.cs:3832 |  | UI_PROP | drpDateTime.Value1 | DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.… | 속성 Value1 설정 |  |  |  |
| AC-162b0943 | this.usrDiscard.CheckedChanged | DMF0020_SalesFuturePrice.cs:3833 |  | UI_PROP | drpDateTime.Value2 | drpDateTime.Value1.AddDays(357) | 속성 Value2 설정 |  |  |  |

## DMF0020_SalesFuturePricePopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-705e92cf | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesFuturePricePopUp.cs:563 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-aa4cb7c0 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesFuturePricePopUp.cs:566 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d7f732a8 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesFuturePricePopUp.cs:569 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesFuturePricePopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68567795 | this.Load | DMF0020_SalesFuturePricePopUp.cs:134 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d882705f | this.Load | DMF0020_SalesFuturePricePopUp.cs:135 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d853a3fd | this.Load | DMF0020_SalesFuturePricePopUp.cs:136 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesFuturePricePopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4da2626c | this.Load | DMF0020_SalesFuturePricePopUp.cs:127 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0020_SalesFuturePricePopUp.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a92b7dc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:215 | if (vAction1 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3390bfa2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:217 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0020_SalesFuturePricePopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-641988b9 | Dispose | DMF0020_SalesFuturePricePopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesFuturePricePopUp.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8127db77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:225 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2de1042a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:226 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePricePopUp.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c6ffeba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:299 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-186480fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:300 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-0ebe9955 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:301 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-7ef26f17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:302 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6887f6e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:303 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP", nvc) ⇒ DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b4b4a5da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:303 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-691be843 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:305 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-49281158 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:306 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-492c8dd9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:309 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain,"")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d7e6fecd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:309 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain,"") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b5709d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:313 |  | CALL_EXT | nvc.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-571efaa8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:314 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4235e711 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:315 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-a7dd8e04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:316 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-03e24733 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:317 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-08b62557 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:318 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA", nvc) ⇒ DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-227aea06 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:318 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a6c05baa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:328 | for (i < dt.Rows.Count) | DATA_OP | dsSpread.Tables[0].Select | (" CURRENCY = '" + sCURRENCY.Trim() + "' AND [UNIT_CURRENCY] = '" + sUNIT_CURRENCY.Trim() … | 데이터 객체 조작/조회 |  |  |  |
| AC-a0325f11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:331 | for (i < dt.Rows.Count) | GRID_SET | siMain.SetText | (iRowindex, siMain.GetColumnIndex(sYYYYMMDD), sEXCHANGE_PRICE) | 그리드 값 설정 |  |  |  |
| AC-1b524371 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:334 |  | DATA_OP | dsSpread.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e90a7eff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:337 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4161a293 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:340 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d685288d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:343 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesFuturePricePopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da9a43ef | this.Load | DMF0020_SalesFuturePricePopUp.cs:91 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-07efab2f | this.Load | DMF0020_SalesFuturePricePopUp.cs:93 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0020_SalesFuturePricePopUp.GetCellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e3259fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:534 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePricePopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbf9af33 | this.Load | DMF0020_SalesFuturePricePopUp.cs:115 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4aec3e90 | this.Load | DMF0020_SalesFuturePricePopUp.cs:116 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a3559e7c | this.Load | DMF0020_SalesFuturePricePopUp.cs:116 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a7ceaa9 | this.Load | DMF0020_SalesFuturePricePopUp.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cfca6385 | this.Load | DMF0020_SalesFuturePricePopUp.cs:119 |  | FLAG | dtDivision2 | Data.Common(Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-f7b05c27 | this.Load | DMF0020_SalesFuturePricePopUp.cs:119 |  | COMBO_DATA | Data.Common | (Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0387bf73 | this.Load | DMF0020_SalesFuturePricePopUp.cs:120 |  | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-2bc8f39f | this.Load | DMF0020_SalesFuturePricePopUp.cs:120 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0020_SalesFuturePricePopUp.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51096933 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:143 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-085148c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:145 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-176c6a60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:146 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 120, true, dtDivision2, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9a1e743 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:147 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f92458f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:148 |  | GRID_INIT | siMain.AddComboColumn | ("Unit", DefColumns.UNIT_CURRENCY, FPMerge.None, 50, true, dtCurrency, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a792c95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:149 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY_UNITCURRENCY, FPMerge.Restricted, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6df591f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:150 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e78bdde | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:156 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE") ⇒ DM.DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c171037a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:157 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-c0cb89dd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:158 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-39baf5a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:159 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f3ebb11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:173 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_MONTH"].ToString(), "D" + dt.Rows[i]["BASIS_START_DATE"].ToString(),… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ca3c29a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:178 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sFYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe3cf8bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:186 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-292e6028 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:191 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1d6ee2a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SalesFuturePricePopUp.cs:192 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0020_SalesFuturePricePopUp.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-412d274d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:497 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-72c7a586 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:500 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CURRENCY, "KRW") | 데이터 객체 조작/조회 |  |  |  |
| AC-19c57dcf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:501 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-5e517a8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5257b2c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed35eea2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:517 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iMonth < iTime) ▸ for (i <… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY), siMain.Ac… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0020_SalesFuturePricePopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10dfe777 | (진입점 미연결) | DMF0020_SalesFuturePricePopUp.cs:103 |  | UI_PROP | usrMonthFrom.MonthText | sFromYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-94fd5a60 | (진입점 미연결) | DMF0020_SalesFuturePricePopUp.cs:104 |  | UI_PROP | usrMonthTo.MonthText | sToYYYYMM | 속성 MonthText 설정 |  |  |  |

## DMF0020_SalesFuturePricePopUp.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60fb0848 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0020_SalesFuturePricePopUp.cs:576 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesFuturePricePopUp.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0db9bf06 | SaveButton | DMF0020_SalesFuturePricePopUp.cs:279 | switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00cf0abe | SaveButton | DMF0020_SalesFuturePricePopUp.cs:280 | switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesFuturePricePopUp.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2341ee7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dee008a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-42c4da86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:390 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29f125ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-03f8f4de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_division_id"] | CString.AppendStringEx(nvc["p_division_id"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-40d77bf8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-29cd0d9d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-acd79a13 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-6989faa8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_EXCHANGE_PRICE"] | CString.AppendStringEx(nvc["p_EXCHANGE_PRICE"], sEXCHANGE_PRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3cb4ca94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:430 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ef39ce03 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:431 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-9309d9ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[EXCHANGE_PRICE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-257eaacc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:447 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3091597 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:452 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14d96215 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:456 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL") ⇒ DM.DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-eab75785 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:460 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-9e595c78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:460 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d70122d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:462 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c38aed5a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-449d2617 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-d2e42a3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d31d96b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesFuturePricePopUp.cs:484 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0020_SalesFuturePricePopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b654187c | this.spdMain.TopChange | DMF0020_SalesFuturePricePopUp.cs:582 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesPriceRangePopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7a0e2ae | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesPriceRangePopUp.cs:496 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2707c357 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesPriceRangePopUp.cs:499 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesPriceRangePopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2c043b3 | this.Load | DMF0020_SalesPriceRangePopUp.cs:134 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7074f5c | this.Load | DMF0020_SalesPriceRangePopUp.cs:135 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b0ec392 | this.Load | DMF0020_SalesPriceRangePopUp.cs:137 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesPriceRangePopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd50387 | this.Load | DMF0020_SalesPriceRangePopUp.cs:123 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-777b3726 | this.Load | DMF0020_SalesPriceRangePopUp.cs:127 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesPriceRangePopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c8bfa24 | Dispose | DMF0020_SalesPriceRangePopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesPriceRangePopUp.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9207ed4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:195 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3ce3cb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:196 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c97d0235 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:198 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42550afc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:202 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0816faa6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:203 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ST_YYYYMMDD), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0020_SalesPriceRangePopUp.FindData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b60f1ee | this.Load | DMF0020_SalesPriceRangePopUp.cs:225 |  | GRID_BIND | siMain.Query | (dt) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f337be0f | this.Load | DMF0020_SalesPriceRangePopUp.cs:226 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0020_SalesPriceRangePopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0091eb91 | this.Load | DMF0020_SalesPriceRangePopUp.cs:95 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b084d2a | this.Load | DMF0020_SalesPriceRangePopUp.cs:97 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0020_SalesPriceRangePopUp.GetCellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d15c4439 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:477 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesPriceRangePopUp.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51c75436 | this.Load | DMF0020_SalesPriceRangePopUp.cs:145 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-19ed658e | this.Load | DMF0020_SalesPriceRangePopUp.cs:147 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ed56e2a9 | this.Load | DMF0020_SalesPriceRangePopUp.cs:149 |  | GRID_INIT | siMain.AddTextColumn | ("ROWNUM", DefColumns.ROWNUM, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ed556cb | this.Load | DMF0020_SalesPriceRangePopUp.cs:150 |  | GRID_INIT | siMain.AddTextColumn | ("DIVISION_ID", DefColumns.DIVISION_ID, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f845b0d | this.Load | DMF0020_SalesPriceRangePopUp.cs:151 |  | GRID_INIT | siMain.AddTextColumn | ("PLANT_SITE_ID", DefColumns.PLANT_SITE_ID, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-337051c7 | this.Load | DMF0020_SalesPriceRangePopUp.cs:152 |  | GRID_INIT | siMain.AddTextColumn | ("MEASURE", DefColumns.MEASURE, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e64e204 | this.Load | DMF0020_SalesPriceRangePopUp.cs:153 |  | GRID_INIT | siMain.AddTextColumn | ("DOM_EXP", DefColumns.DOM_EXP, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab111171 | this.Load | DMF0020_SalesPriceRangePopUp.cs:156 |  | GRID_INIT | siMain.AddTextColumn | ("End Customer", DefColumns.END_CUSTOMER, FPMerge.Restricted, 70, true, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34e6d23b | this.Load | DMF0020_SalesPriceRangePopUp.cs:160 | if (_sDivisionId.Equals("82")) | GRID_INIT | siMain.AddTextColumn | ("Project", DefColumns.PROJECT_CODE, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c74af683 | this.Load | DMF0020_SalesPriceRangePopUp.cs:164 | else of (_sDivisionId.Equals("82")) | GRID_INIT | siMain.AddTextColumn | ("Project", DefColumns.PROJECT_CODE, FPMerge.None, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8211496 | this.Load | DMF0020_SalesPriceRangePopUp.cs:167 |  | GRID_INIT | siMain.AddTextColumn | ("Sales Site", DefColumns.SCM_SITE_ID, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9000a245 | this.Load | DMF0020_SalesPriceRangePopUp.cs:168 |  | GRID_INIT | siMain.AddTextColumn | ("Model", DefColumns.ITEM_ID, FPMerge.Restricted, 140, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2720d36 | this.Load | DMF0020_SalesPriceRangePopUp.cs:169 |  | GRID_INIT | siMain.AddTextColumn | ("Incoterms", DefColumns.INCOTERMS, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e89f369 | this.Load | DMF0020_SalesPriceRangePopUp.cs:170 |  | GRID_INIT | siMain.AddTextColumn | ("Fcst Type", DefColumns.FCST_TYPE, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09da47dd | this.Load | DMF0020_SalesPriceRangePopUp.cs:171 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaa9d4cb | this.Load | DMF0020_SalesPriceRangePopUp.cs:172 |  | GRID_INIT | siMain.AddTextColumn | ("YYYYMMDD", DefColumns.CH_YYYYMMDD, FPMerge.Restricted, 90, true, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b631619 | this.Load | DMF0020_SalesPriceRangePopUp.cs:173 |  | GRID_INIT | siMain.AddNumColumn | ("Price", DefColumns.CH_PRICE, FPMerge.None, 70, true, FPHAlign.Right, FPVAlign.Center, 3,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b192c87b | this.Load | DMF0020_SalesPriceRangePopUp.cs:174 |  | GRID_INIT | siMain.AddTextColumn | ("YYYYMMDD", DefColumns.ST_YYYYMMDD, FPMerge.Restricted, 90, true, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37a9b5ed | this.Load | DMF0020_SalesPriceRangePopUp.cs:175 |  | GRID_INIT | siMain.AddNumColumn | ("Price", DefColumns.ST_PRICE, FPMerge.None, 70, true, FPHAlign.Right, FPVAlign.Center, 3,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d476f5b | this.Load | DMF0020_SalesPriceRangePopUp.cs:177 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0695e003 | this.Load | DMF0020_SalesPriceRangePopUp.cs:179 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CH_YYYYMMDD), 1, 2, 25, "입력값", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33db8913 | this.Load | DMF0020_SalesPriceRangePopUp.cs:180 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ST_YYYYMMDD), 1, 2, 25, "비교값", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cd50107 | this.Load | DMF0020_SalesPriceRangePopUp.cs:182 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesPriceRangePopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e6a170e | (진입점 미연결) | DMF0020_SalesPriceRangePopUp.cs:107 |  | FLAG | _dtRange | dtRange | 화면 필드/플래그 변경 |  |  |  |
| AC-9e2efae1 | (진입점 미연결) | DMF0020_SalesPriceRangePopUp.cs:108 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesPriceRangePopUp.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c477c41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:310 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4b33e92 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-2379d481 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-946d076b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], sAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8f0c8723 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDivisionId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b99d66fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:393 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sProjectCode, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d99074bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sScmSiteId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-872f6404 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], sPlantSiteId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8a4cdbba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:396 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sItemId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-92ea0c40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:397 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sChYyyymmdd, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8824f1ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCurrency, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-49e537f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:400 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], sMeasure, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-08b2adaa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:401 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], sDomExp, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-336fe71e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], sFcstType, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-62337555 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sIncoterms, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f788f999 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:404 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_PRICE"] | CString.AppendStringEx(nvc["p_PRICE"], sChPrice, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-23549ce6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-9fbde134 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-6be20978 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:407 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-867c3d94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[EXCHANGE_PRICE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66f4c5ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-947d5e38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-444d788b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:432 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP") ⇒ DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-fde8deea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c80cd0b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-319178d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-baeadaef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a09c40e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-47015792 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:454 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-fcb80460 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:455 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a0be496 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:459 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f47fe9d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceRangePopUp.cs:463 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesPriceRangePopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e3109a6 | this.spdMain.TopChange | DMF0020_SalesPriceRangePopUp.cs:507 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesPriceTemplatePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f544fb61 | .ctor | DMF0020_SalesPriceTemplatePopup.cs:66 |  | FLAG | sDivision_id | pDivId | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0dd203a | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesPriceTemplatePopup.cs:249 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3e507841 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesPriceTemplatePopup.cs:252 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-936c6187 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SalesPriceTemplatePopup.cs:255 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a42ef17 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:111 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 15) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3123e0ce | this.Load | DMF0020_SalesPriceTemplatePopup.cs:112 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2cf4fd4e | this.Load | DMF0020_SalesPriceTemplatePopup.cs:113 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95cc1d81 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:103 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdbf8ed8 | Dispose | DMF0020_SalesPriceTemplatePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc3c8aa4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:161 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3dc3be57 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:170 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb90d295 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:171 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12e7df65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:175 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0ddaedd6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:186 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5daf2631 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:188 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-987ed048 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:192 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_SALES_PRICE_TEMPLATE") ⇒ DM.DMF0020_GET_SALES_PRICE_TEMPLATE | 엔드포인트 요청 생성 |  |  |  |
| AC-2e0da0cc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:194 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1e8f945c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:196 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fe899ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:198 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ccd01ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:200 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-94360001 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:204 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3a99fb78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:205 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-85af031b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:208 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-282c31bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:215 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-384fe1cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:220 | try ▸ if (ds.Tables[0].Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00019") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-669b02b3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:225 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb039c2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:229 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-6b603639 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SalesPriceTemplatePopup.cs:234 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-260e9f6d | this.Load | DMF0020_SalesPriceTemplatePopup.cs:73 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-24f6f0db | this.Load | DMF0020_SalesPriceTemplatePopup.cs:75 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b9a397d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:279 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-7046908a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:280 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed75202d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:281 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b60a19f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:282 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d806c226 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:283 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0020" | 행/컬럼 값 대입 |  |  |  |
| AC-76479da9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:284 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-7af225e4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:285 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a153b60b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:287 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ecdbe867 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:289 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06581fa0 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:92 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d447c9b9 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:93 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-afaa9254 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:93 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ae53448 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:94 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ea36c539 | this.Load | DMF0020_SalesPriceTemplatePopup.cs:96 |  | VALUE_SET | clbDivisions.ControlValues | this.sDivision_id | 컨트롤 값 설정 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d607a94e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:123 |  | FLAG | dtTitle | GetSpdTitle(siMain.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b075e51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SalesPriceTemplatePopup.cs:124 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43a3ff91 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0020_SalesPriceTemplatePopup.cs:262 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SalesPriceTemplatePopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee47d6c2 | this.spdMain.TopChange | DMF0020_SalesPriceTemplatePopup.cs:268 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-975916e6 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SaveSalesFuturePrice_Popup.cs:2569 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ade897d5 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0020_SaveSalesFuturePrice_Popup.cs:2572 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.clbDivisions_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cda6462c | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2114 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84de422f | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2117 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0c7a101a | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2134 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2959e5dd | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2157 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-413747e3 | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2173 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-59f69b8f | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2173 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e401a5a0 | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2174 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-905c6f58 | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2189 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d77ea0ef | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2190 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ee6fc1df | this.clbDivisions.SelectedIndexChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2194 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15a91b8e | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:480 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6f183b75 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:481 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f53aac13 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:482 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ceaf4bd | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:375 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-8ca8bf4b | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:378 |  | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-b794be57 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:379 |  | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-7affeb41 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:384 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-46f894db | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:387 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-042da89b | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:388 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-a7ece1d2 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:389 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-4e38acc3 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:390 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea9cce2b | Dispose | DMF0020_SaveSalesFuturePrice_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.drpDateTime_Load

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bd97b22 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2590 |  | UI_PROP | drpDateTime.Value1 | mondayDate2 | 속성 Value1 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.drpDateTime_ValueChange

진입점: this.drpDateTime.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae6169a | this.drpDateTime.ValueChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2607 |  | UI_PROP | drpDateTime.Text1 | gMondayDate3 | 속성 Text1 설정 |  |  |  |
| AC-7835dce2 | this.drpDateTime.ValueChanged | DMF0020_SaveSalesFuturePrice_Popup.cs:2608 |  | UI_PROP | drpDateTime.Text2 | gMondayDate4 | 속성 Text2 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.Dsdm_Changed

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fc8b321 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2256 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2130ac76 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2268 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0325fee4 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2269 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2ec28c4 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2270 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9fad0e0 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2285 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-ef117eba | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2286 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d066551 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2299 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72f82c10 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2307 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Sub… | 그리드 값 설정 |  |  |  |
| AC-0faf2468 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2308 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row - i, e.Column, e.Row - i, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c366666 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2313 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bcb2d3e1 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2323 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-1196574b | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2326 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-da4c1e42 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2355 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-d76946b9 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2355 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eae0c56f | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2356 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5343d990 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2364 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-309983ef | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2364 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-437bdc01 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2365 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac624588 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:832 | if (this.fps != null) ▸ if (clbDivisions.ControlValues == "40") ▸ if (( siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0) \|\| (siMain.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a52b9566 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:833 | if (this.fps != null) ▸ if (clbDivisions.ControlValues == "40") ▸ if (( siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0) \|\| (siMain.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6972ecb6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:863 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if ((siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54347227 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:864 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if ((siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abee9aba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:878 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if (cl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b12e080b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:879 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if (cl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65c6beae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:883 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e319c58 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:884 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-23f4e6fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:912 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ if (!siMain.IsLock(si… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7e9d35b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:920 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ if (!siMain.IsLock(si… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-142314df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:927 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ else of (!siMain.IsLo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f1e66f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:932 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d6406223 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:976 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c919e01 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:978 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), iRow, siMain.GetColumnIndex(DefColumns.D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d89f80b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:980 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DEPT_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-510c8f89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:982 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4db83f3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:984 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c2c873f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:986 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b4514f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:988 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1db7c025 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:990 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0663d73c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:992 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BizType), iRow, siMain.GetColumnIndex(DefColumns.B… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3283f167 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:994 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-be82ec6a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:996 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cefea7f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:998 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a19c74c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1000 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-44b58feb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1002 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3539df1d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1004 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07242797 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1008 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aa2b91e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1016 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c57a301a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1028 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d99dfbd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1032 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4507e11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1050 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1bed18e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1051 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2148b6c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1061 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-63d2bd2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1063 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a2088bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1065 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8a47a2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1069 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0856cc75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1071 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b438c13 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1073 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b2a1218 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1075 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c19fbc3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1093 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex("W_" + sLast… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a27ea4b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1109 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "KRW") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-750eeb24 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1113 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure.ToUpper() == "KRW") ▸ if (sMeasure.ToUpper() == "USD") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51b7ce85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1120 | if (this.fps != null) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-6c1eb94b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1121 | if (this.fps != null) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-921884ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1138 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4c90f2f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1145 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b25d3655 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1146 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-771b3849 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1149 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c1a5c39d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1162 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b230fd2d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1163 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6947f482 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1180 | try ▸ if (int.Parse(gMondayDate) > int.Parse(sStartDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00409") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4befe9b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1181 | try ▸ if (int.Parse(gMondayDate) > int.Parse(sStartDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f26f9b19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1189 | try ▸ if (dateYmdF.DayOfWeek != DayOfWeek.Monday \|\| dateYmdT.DayOfWeek != DayOfWeek.Monday) | MESSAGE | MessageHelper.GMessageBox | ("MSG00330") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b9f2839 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1190 | try ▸ if (dateYmdF.DayOfWeek != DayOfWeek.Monday \|\| dateYmdT.DayOfWeek != DayOfWeek.Monday) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad2f2a78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1209 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92bf5650 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1210 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef72f587 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1214 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-31a9fdd5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1227 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e24b06d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1229 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-86fa8644 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1233 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP") ⇒ DM.DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-49073ffc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1235 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9fc86cf4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1237 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-72ba2c10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1238 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-9aea71c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1239 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-4399aea8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1240 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-c0469f9e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1241 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-4dc14836 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1242 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3cdb25e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1243 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e42d89bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1244 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56e86b02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1245 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbf03d8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1246 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-6e88d1e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1247 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-47fbfe33 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1248 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-76141fb7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1249 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aec19370 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1250 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5d118113 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1251 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-8ac375f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1252 | try ▸ lambda | DATA_OP | request.Parameters["p_over_range"] | sOverRange | 행/컬럼 값 대입 |  |  |  |
| AC-21329fa7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1253 | try ▸ lambda | DATA_OP | request.Parameters["p_invalid_exec"] | sInvalidExec | 행/컬럼 값 대입 |  |  |  |
| AC-ce432d40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1255 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-752ab92f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1257 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-933b7e2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1262 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f81f86c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1272 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3ea1202 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1274 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("PriceAll", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b40f49cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1288 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select("", sSortList).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97e5d303 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1288 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select | ("", sSortList) | 데이터 객체 조작/조회 |  |  |  |
| AC-496cf1be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1289 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Remove | (ds.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-3907bd93 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1290 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-e85ff0c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1292 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9fd7ab51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1293 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d768665 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1305 | try ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.PriceAll), test) | 그리드 값 설정 |  |  |  |
| AC-7741a32f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1312 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b45a2ae9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1346 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-bfff5823 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1347 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-3b3257c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1354 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f2be6537 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1362 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-0174a08f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1367 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-0a414a72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1380 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!sColList.Equals("")) ▸ for (i < result.Length) | GRID_STYLE | siMain.SetBGColor | (iRow, iResultCol, iRow, iResultCol, Color.Pink) | 그리드 표시 설정 |  |  |  |
| AC-5f637600 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1389 | try ▸ catch ((Exception exi)) | THROW | throw exi; |  | 예외 발생 |  |  |  |
| AC-5aa7f21a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1390 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-61b82ca0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1396 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-937e6c38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1401 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-41b88bf2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1402 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfbad023 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1411 | try | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-0344a929 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1413 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-988b5795 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1417 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a32533e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1419 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6faa3519 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1423 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-94aaf563 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1428 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f437fa45 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:1429 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.fnValidation

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39de4eb7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2046 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-ff33a852 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2049 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04271149 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-018b7615 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:176 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-da93706e | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:179 |  | VALUE_SET | clbDivisions.ControlValues | _sDivision | 컨트롤 값 설정 |  |  |  |
| AC-c6b285f1 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:190 |  | UI_PROP | drpDateTime.MinDate1 | mondayDate2 | 속성 MinDate1 설정 |  |  |  |
| AC-7607d4c3 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:194 |  | UI_PROP | drpDateTime.Text1 | sdFromYYYYMMdd | 속성 Text1 설정 |  |  |  |
| AC-47f4e91f | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:198 |  | UI_PROP | drpDateTime.Text2 | sdToYYYYMMdd | 속성 Text2 설정 |  |  |  |
| AC-b8bbac3d | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:201 |  | VALUE_SET | clbSalesSite.ControlValues | _sSiteid | 컨트롤 값 설정 |  |  |  |
| AC-ac0caa17 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:202 |  | VALUE_SET | umltProject.Text | _sProject | 컨트롤 값 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e407e4a2 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:1914 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetCellIndexBySpanRowCells

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "82" && sNewFlag == CAppSetting.StringY)] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "82" && sNewFlag == CAppSetting.StringY)] / (진입점…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ad6b519 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2208 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f2f48f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2209 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetCellNumbersByRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56be02e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2240 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-94538630 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2245 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f9e20ca | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:359 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-fe398d29 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:360 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-063154f0 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:361 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-00a1c109 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:363 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c4d60c5 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:366 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetExchangeRate

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (!string.IsNullOrEmpty(sPRICE)) ▸ foreach (DataRow drMeasuer in dtMeasureCountAll.Rows) ▸ foreach (DataRow drDate in dsSaveDate.Tables[0].Rows) ▸ if (saveMEASURE != "LOC")] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == fals…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-301d79fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2443 | if (sBaseER == sTargetER) | RETURN | return sValue; |  | 처리 중단/반환 |  |  |  |
| AC-0a56cd29 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2446 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sTargetER + "' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-41f55c70 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2450 | if (row.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-946d72de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2454 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sBaseER + "' AND UNIT_CURRENCY = '" + sTargetER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-8224d739 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2459 | if (row1.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-cdd539f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2463 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' A… | 데이터 객체 조작/조회 |  |  |  |
| AC-982d9ec9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2467 | if (row4.Length > 0) | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' AND YYYYMM = '" + sYYYYMM + "' AND DIVISION_… | 데이터 객체 조작/조회 |  |  |  |
| AC-98a94ecc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2472 | if (row4.Length > 0) ▸ if (row5.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-66310070 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2477 | if (sTargetVal == null) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-060588d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0020_SaveSalesFuturePrice_Popup.cs:2479 | else of (sTargetVal == null) | RETURN | return "0"; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetFuturePriceInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dcfceee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SaveSalesFuturePrice_Popup.cs:468 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_FUTUREPRICE_INFO") ⇒ DM.DMF0020_GET_FUTUREPRICE_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-5c510956 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SaveSalesFuturePrice_Popup.cs:469 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-425d23ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SaveSalesFuturePrice_Popup.cs:470 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b659dc85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SaveSalesFuturePrice_Popup.cs:472 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb617ac0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0020_SaveSalesFuturePrice_Popup.cs:475 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a036c54 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:2489 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-181d78b8 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:2490 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-53c4b72c | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:2491 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8de5ed91 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:2494 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetMeasureCountInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a46ee1be | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:443 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE") ⇒ DM.DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-ae5868f4 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:444 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7b7bcd7 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:451 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_MEASURE_COUNTINFO") ⇒ DM.DMF0020_GET_MEASURE_COUNTINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-3cb6c96c | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:452 |  | FLAG | dtMeasureCountAll | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-27e2d2cd | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:452 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57923c7e | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:456 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetSaveDateFromTo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d203f4b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2537 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_SPREAD_TITLE_SAVE_PRICE") ⇒ DM.DMF0020_GET_SPREAD_TITLE_SAVE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-0b56be7b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2538 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-23a30820 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2539 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-209b3ff0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2540 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0f0226a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2541 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-60f7bd8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2543 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-057014d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2546 |  | DATA_OP | dsDate.Tables[0].Select("COLUMN_NAME LIKE 'W_2%' ", "").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d249edbd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2546 |  | DATA_OP | dsDate.Tables[0].Select | ("COLUMN_NAME LIKE 'W_2%' ", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee94e581 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2547 |  | DATA_OP | dsDate.Tables.Remove | (dsDate.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cfde60c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2548 |  | DATA_OP | dsDate.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e1badbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2551 |  | RETURN | return dsDate; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ else of …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-537f98bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2512 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_SPREAD_TITLE_SAVE_PRICE") ⇒ DM.DMF0020_GET_SPREAD_TITLE_SAVE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-5d96c8f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2513 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d9799ed9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2515 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-637e710b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2516 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a422ef17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2517 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-faa99a7f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2519 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-13596e0e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2519 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95c31516 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:2522 |  | RETURN | return dsSpdTitle; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.GetWeekData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a24be6a8 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:421 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_WEEKDATA") ⇒ DM.DMF0020_GET_WEEKDATA | 엔드포인트 요청 생성 |  |  |  |
| AC-8803f97e | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:422 |  | DATA_OP | request.Parameters["p_yyyymmdd"] | System.DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a65d2777 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:424 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9733d019 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:427 |  | RETURN | return dsWeek; |  | 처리 중단/반환 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94cec3d4 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:229 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-1104833e | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:235 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f5a028cc | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:237 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c7a4d72 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:237 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb602234 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1d582cbe | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:242 |  | VALUE_SET | clbDivisions.ControlValues | _sDivision | 컨트롤 값 설정 |  |  |  |
| AC-422d61c1 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:247 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe19d9e7 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:247 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d30b596d | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:263 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a831e971 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:295 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-060e9ae7 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:300 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | umltProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-46e4dbf8 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:318 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-aec00e56 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:318 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f73e05f6 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:319 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fc4bafed | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:326 |  | FLAG | dtItemType | GetLookupValues("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-83bbda7e | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:327 |  | FLAG | dtINCOTERMSType | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-60de1945 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:329 |  | FLAG | dtFcstType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-2da24596 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:330 |  | FLAG | dtDomExp | GetLookupValues("DOM/EXP") | 화면 필드/플래그 변경 |  |  |  |
| AC-21d4df88 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:337 |  | FLAG | dtMeasureCount | GetMeasureCountInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-e56c5032 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:339 |  | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-e6c24c8b | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:343 |  | FLAG | dtWeek | GetWeekData() | 화면 필드/플래그 변경 |  |  |  |
| AC-b784ced5 | this.Load | DMF0020_SaveSalesFuturePrice_Popup.cs:351 |  | STATE | clbDivisions.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / this.clbDivisions.SelectedIndexChanged [try] / FindButton [try] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e66d8ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:516 | if (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8edf2809 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:521 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d5428690 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:522 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-58a4c267 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:526 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dsTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2afa01c | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:734 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d61f70d | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:740 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-928027e7 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:741 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-a8142b9b | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:742 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ea678a25 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:744 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0020_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM.DMF0020_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d6ed631d | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:744 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0020_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-951b5526 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:759 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["DATE_SHORT1_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPM… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e6f00a4 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:761 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.MEASURE) + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].T… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c44236e6 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:767 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f3cf378 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:776 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a257600d | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:782 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a02b1d1 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:214 |  | FLAG | _sDivision | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-d54614c1 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:215 |  | FLAG | _sFromYYYYMMdd | sFromYYYYMMdd | 화면 필드/플래그 변경 |  |  |  |
| AC-eeed5651 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:216 |  | FLAG | _sToYYYYMMdd | sToYYYYMMdd | 화면 필드/플래그 변경 |  |  |  |
| AC-65d4ec19 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:217 |  | FLAG | _sSiteid | sSiteid | 화면 필드/플래그 변경 |  |  |  |
| AC-16e76f2f | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:218 |  | FLAG | _sProject | sProject | 화면 필드/플래그 변경 |  |  |  |
| AC-e40d70c5 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:219 |  | FLAG | sEndCustomer | sEndCustomer_ | 화면 필드/플래그 변경 |  |  |  |
| AC-8fbed508 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:221 |  | FLAG | isSaveOK | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddbf563b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1434 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-215698eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1445 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58420e97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1446 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67e75c68 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1457 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1], j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cf47822 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1466 | try ▸ if (isEdit==false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e34345f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1467 | try ▸ if (isEdit==false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa81b0cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1483 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ba0eca22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1606 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6eab9fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1609 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-d7df8a51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1611 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eab75303 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1630 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d68919f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1631 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91ba0644 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1638 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c84d8d04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1714 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1], j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-532b2681 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1784 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-43def3f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1785 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-bc3e28c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1786 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b5c68d77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1787 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-038d8dae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1788 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], p_plant_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d59bcaf7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1789 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1c182564 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1790 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], saveYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-dea7bbca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1791 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-a8d9369e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1793 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], saveMEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2861707c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1794 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], sDomExp, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d250e9f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1795 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], sFcstType, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-6d1f47dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1796 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2a6014ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1797 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_PRICE"] | CString.AppendStringEx(nvc["p_PRICE"], savePRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e92dadaf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1798 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-fff29592 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1799 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e6cbd3e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1800 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d2427294 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1801 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_ROWNUM"] | CString.AppendStringEx(nvc["p_ROWNUM"], (iSaveRow).ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-47b95434 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1804 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-31ec4b40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1820 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3de37a35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1835 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41d29ca6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1839 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL") ⇒ DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-f1763169 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1840 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-433d49a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1843 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-3b6a81f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1843 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b06ecda | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1845 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b936ef85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1847 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ed649bba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1861 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-73a8d172 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1862 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1f866a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1868 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | isSaveOK | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ba61f977 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1869 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3b2582ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1870 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_Total }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cee945a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1878 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | POPUP | new DMF0020_SalesPriceRangePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-76dfea6f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1879 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | CALL_EXT | popup.LoadData | (ds.Tables[2], sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-571ffc42 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1880 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-36911aac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1881 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-94616ba8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1887 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ca3f0703 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1895 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-f0d1f577 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1899 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-31ec66f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:1901 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.SetExchangeValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d979fde5 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2383 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b916a594 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2383 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3d1a73a | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2389 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (sCurrency =… | GRID_SET | siMain.SetText | (iRow, iColumn, "") | 그리드 값 설정 |  |  |  |
| AC-5af347de | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2390 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (sCurrency =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c550be8 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2395 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) | GRID_SET | siMain.SetText | (iRow, iColumn, val) | 그리드 값 설정 |  |  |  |
| AC-1d6c9050 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2399 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetColor | (iRow, iColumn, iRow, iColumn, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a059676 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2407 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | GRID_SET | siMain.SetText | (iRow - i, iColumn, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Subst… | 그리드 값 설정 |  |  |  |
| AC-7376d491 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2408 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetColor | (iRow - i, iColumn, iRow - i, iColumn, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c95550a2 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2413 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fe5be97 | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2420 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ else of (!strin… | GRID_SET | siMain.SetText | (iRow - i, iColumn, "") | 그리드 값 설정 |  |  |  |
| AC-b050a0ce | (진입점 미연결) | DMF0020_SaveSalesFuturePrice_Popup.cs:2423 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ else of (!strin… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow - i, "M") | ⚠ 의미 확인 필요 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.SetSpreadColumn

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0)] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5af76ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:654 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3691b7fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:658 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bedde170 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:659 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-274e0d5e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:696 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["MMDD"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 1… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61e121be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:701 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 120, true, FPHAlign.Right… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fda5fadb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:707 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMeasureCol + iWeek, 1, 1, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f80e5f3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:715 | for (i < dt.Rows.Count) ▸ else of (i == 0) ▸ if (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb22b257 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:721 | for (i < dt.Rows.Count) ▸ else of (i == 0) ▸ else of (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8292e857 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0020_SaveSalesFuturePrice_Popup.cs:726 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMeasureCol + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].ToString(), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.SetSpreadHeaderSpan

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ else of …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-093d0389 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:574 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6b0fcd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:582 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1405e8b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:596 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8bda014 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:603 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a889bcf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:612 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de739666 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:624 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-178c917d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:626 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbf6d14b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:632 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PriceAll) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c4a38c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0020_SaveSalesFuturePrice_Popup.cs:633 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.usrButton1_Click

진입점: this.usrButton1.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-632afadc | this.usrButton1.Click 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2067 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-5ca2f3cb | this.usrButton1.Click 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2069 | if (clbDivisions.SelectedValue.ToString() != "40") | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-43198152 | this.usrButton1.Click 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2070 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-47884524 | this.usrButton1.Click 외 1 | DMF0020_SaveSalesFuturePrice_Popup.cs:2072 | if (clbDivisions.SelectedValue.ToString() != "40") | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0020_SaveSalesFuturePrice_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ceee808 | this.usrButton2.Click | DMF0020_SaveSalesFuturePrice_Popup.cs:2093 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-666ffb60 | this.usrButton2.Click | DMF0020_SaveSalesFuturePrice_Popup.cs:2096 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c01094f1 | this.usrButton2.Click | DMF0020_SaveSalesFuturePrice_Popup.cs:2097 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2ec69abb | this.usrButton2.Click | DMF0020_SaveSalesFuturePrice_Popup.cs:2098 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cbf29876 | this.usrButton2.Click | DMF0020_SaveSalesFuturePrice_Popup.cs:2100 |  | VALUE_SET | umltItem.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

