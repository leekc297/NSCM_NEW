# AS-IS 액션 대조표 — DMF0082

> 원천: `Doc/asisfacts/screens/DMF0082/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1182행 · 메서드 88 · 종류 DATA_OP 265 · FLAG 128 · RETURN 121 · GRID_SET 108 · UI_MISC 86 · UI_PROP 60 · CALL_EXT 59 · ENDPOINT 53 · GRID_LOCK 49 · MESSAGE 42 · GRID_INIT 39 · POPUP 37 · COMBO_DATA 30 · GRID_COMBO 30 · VALUE_SET 22 · LIST_REBIND 14 · GRID_STYLE 14 · STATE_RESET 8 · STATE 8 · THROW 5 · GRID_BIND 2 · CALL_BASE 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 60


## DMF0082_FcstNPrice_Mgmt.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-573a4496 | this.btnColumn.Click | DMF0082_FcstNPrice_Mgmt.cs:3426 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0082", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-a9707a65 | this.btnColumn.Click | DMF0082_FcstNPrice_Mgmt.cs:3427 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a9d0ed8f | this.btnColumn.Click | DMF0082_FcstNPrice_Mgmt.cs:3428 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-403b15aa | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3122 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cb1353b | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3123 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0391cfeb | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3142 |  | POPUP | new POPUP.DMF0000_ExchangeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-74e951e3 | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3143 |  | CALL_EXT | popup.LoadData | (drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), clbDivision.Con… | ⚠ 의미 확인 필요 |  |  |  |
| AC-42538bca | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3145 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-35f46852 | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3146 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e207014e | this.btnExchangeRate.Click | DMF0082_FcstNPrice_Mgmt.cs:3150 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a634082 | this.btnItemId.Click | DMF0082_FcstNPrice_Mgmt.cs:3383 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-384bdbb9 | this.btnItemId.Click | DMF0082_FcstNPrice_Mgmt.cs:3385 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a151d329 | this.btnItemId.Click | DMF0082_FcstNPrice_Mgmt.cs:3386 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8b9d1b86 | this.btnItemId.Click | DMF0082_FcstNPrice_Mgmt.cs:3387 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8550c0d7 | this.btnItemId.Click | DMF0082_FcstNPrice_Mgmt.cs:3393 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-355b8d5f | this.btnMeasure.Click | DMF0082_FcstNPrice_Mgmt.cs:3439 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0082", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-45131f19 | this.btnMeasure.Click | DMF0082_FcstNPrice_Mgmt.cs:3441 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fbb8241d | this.btnMeasure.Click | DMF0082_FcstNPrice_Mgmt.cs:3442 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.btnSavePricePeriod_Click

진입점: this.btnSavePricePeriod.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2520f4a | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3464 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00408") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa72adf2 | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3465 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c002dfb1 | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3469 |  | POPUP | new DMF0082_SaveSalesFuturePrice_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-7ba66daa | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3474 |  | CALL_EXT | popup.LoadData | (clbDivision.ControlValues.ToString() , drpPeriod.Value1.ToString("yyyyMMdd"), drpPeriod.V… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec0ec249 | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3480 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-183524a0 | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3481 |  | UI_PROP | popup.Size | new Size(1200, 600) | 속성 Size 설정 |  |  |  |
| AC-c6e16197 | this.btnSavePricePeriod.Click | DMF0082_FcstNPrice_Mgmt.cs:3482 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.btnVersion_Click

진입점: this.btnVersion.Click / this.btnVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9e76c8e | this.btnVersion.Click 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3404 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ce896d9c | this.btnVersion.Click 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3408 |  | POPUP | popVersion.Form_Load | (true, "MF_SP_SF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3fff5263 | this.btnVersion.Click 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3409 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e1b66eab | this.btnVersion.Click 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3410 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-403152a4 | this.btnVersion.Click 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3414 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-90f15300 | this.btnVersion.Click 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3415 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09d42108 | this.cboBucketType.Click | DMF0082_FcstNPrice_Mgmt.cs:3367 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9047126f | this.cboBucketType.Click | DMF0082_FcstNPrice_Mgmt.cs:3368 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bf58f9a | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3268 | if (siMain != null) ▸ try ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ try | VALUE_SET | cboBucketType.ControlValues | sBfBucket | 컨트롤 값 설정 |  |  |  |
| AC-eae6c11e | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3270 | if (siMain != null) ▸ try ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ try | VALUE_SET | cboBucketType.ControlValues | sAfBucket | 컨트롤 값 설정 |  |  |  |
| AC-7cb5931b | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3277 | if (siMain != null) ▸ try | FLAG | sBfBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-da581244 | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3279 | if (siMain != null) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ea99bff3 | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3291 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-570b2748 | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3292 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ if (cboBucketType.ControlValues == BucketType.Daily) | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6757374c | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3323 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-4791f233 | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3327 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-aa0528aa | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3328 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-e858efeb | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3334 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-4ebbd504 | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3338 | if (siMain != null) ▸ try ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-be6f375f | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3342 | if (siMain != null) ▸ try | UI_MISC | siMain.SpreadObject.ResumeLayout | (true) | 화면 갱신/대기창 |  |  |  |
| AC-3cfd77ee | this.cboBucketType.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3355 | if (siMain != null) ▸ finally ▸ if (siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.ResumeLayout | (true) | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fde5b3a | this.clbCustomer.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3067 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6cd9a58 | this.clbCustomer.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3071 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | GetSalesSite40(clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["… | 화면 필드/플래그 변경 |  |  |  |
| AC-6cffeb39 | this.clbCustomer.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3073 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42a7f181 | this.clbTeam.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3053 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-04737a61 | this.clbTeam.SelectedIndexChanged | DMF0082_FcstNPrice_Mgmt.cs:3060 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bd62620 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:388 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f1f26dae | this.Load | DMF0082_FcstNPrice_Mgmt.cs:389 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1920592d | this.Load | DMF0082_FcstNPrice_Mgmt.cs:390 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2dbc7b7 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:391 |  | FLAG | sv | siMain.Sheet(siMain.SpreadObject.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63bb0331 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:397 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-2e22d539 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:399 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-cf17a364 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:400 |  | FLAG | sBfBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-e374ca84 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:402 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-efac3428 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:404 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-1d7c6aab | this.Load | DMF0082_FcstNPrice_Mgmt.cs:405 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-442e2eea | this.Load | DMF0082_FcstNPrice_Mgmt.cs:406 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-22f86c31 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:407 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c88c3c4 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:688 |  | CALL_EXT | sv.GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21cde308 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:690 | if (sv.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-067ff6c4 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:697 | if (cr is null) | GRID_STYLE | sv.SetActiveCell | (sv.ActiveRowIndex, sv.ActiveColumnIndex) | 그리드 표시 설정 |  |  |  |
| AC-0cab603c | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:701 | else of (cr is null) | CALL_EXT | siMain.SetSelection | (sv.ActiveRowIndex, sv.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a320292a | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:730 | if (list_EDIT_Day.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e40da9bf | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:784 | if (sAction == "D") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e8d4bc88 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:794 | else of (sAction == "D") ▸ if (sAction == "I") | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c17b16f8 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:804 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00464") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36ea487a | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:805 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-881c2a27 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:810 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00464") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50b9640e | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:811 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51b4f83f | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:816 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00464") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ad4f0aa | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:817 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09460f64 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:822 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00464") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-900ac30b | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:823 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d593136 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:833 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8369d26a | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:858 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | GRID_SET | siMain.SetValue | (iActRow, iDayCol, iQty) | 그리드 값 설정 |  |  |  |
| AC-9d2c563b | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:889 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | DATA_OP | alDelDayList.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b15c8b8c | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:896 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | GRID_SET | siMain.SetValue | (iActRow, iCol, iQty) | 그리드 값 설정 |  |  |  |
| AC-6e8fa546 | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:913 | else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \… | GRID_SET | siMain.SetValue | (iActRow, iDayCol, iQty) | 그리드 값 설정 |  |  |  |
| AC-133c823e | DeleteButton | DMF0082_FcstNPrice_Mgmt.cs:929 |  | UI_MISC | siMain.SpreadObject.Refresh | () | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f0f05f | Dispose | DMF0082_FcstNPrice_Mgmt.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.Draw

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e41d019 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1802 | if (ds.Tables[1] != null) | FLAG | this_YYYYMMWW | "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-610a57f5 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1803 | if (ds.Tables[1] != null) | FLAG | this_YYYYMM | "M_" + this_YYYYMMWW.Substring(2, 6) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0c51c54 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1808 | if (ds.Tables[0] != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d53ed045 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1810 | if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3d644156 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1811 | if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0c14190 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1812 | if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fde69877 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1814 | if (ds.Tables[0] != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-08268ef5 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1819 | if (ds.Tables[2].Rows.Count > 0) | FLAG | this_YYYYMMWW | ds.Tables[2].Rows[0]["THIS_YYYYMMWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-48f0dc10 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1820 | if (ds.Tables[2].Rows.Count > 0) | FLAG | iso_week | ds.Tables[2].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa750f7d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1827 | if (siMain.GetMaxRowIndex() > 0) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dccffb52 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1828 | if (siMain.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7fad96ec | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1829 | if (siMain.GetMaxRowIndex() > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a5576f75 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1832 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3c10b3e5 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1862 | try ▸ if (data_start_pos < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00796118 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1876 | try | UI_PROP | gc.NegativeRed | true | 속성 NegativeRed 설정 |  |  |  |
| AC-b53e1e95 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1878 | try | UI_PROP | gc.FormatString | "###,###,###,##0.000" | 속성 FormatString 설정 |  |  |  |
| AC-f0877ecc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1879 | try | UI_PROP | gc.NullDisplay | "" | 속성 NullDisplay 설정 |  |  |  |
| AC-5cd6eead | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1880 | try | UI_PROP | gc.OmitZero | false | 속성 OmitZero 설정 |  |  |  |
| AC-e027af15 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1885 | try ▸ for (i < maxRow) | DATA_OP | rNotation[i] | ds.Tables[0].Rows[i]["NOTATION"].String().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-1789e036 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1885 | try ▸ for (i < maxRow) | CALL_EXT | ds.Tables[0].Rows[i]["NOTATION"].String | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-906b0b84 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1886 | try ▸ for (i < maxRow) | CALL_EXT | ds.Tables[0].Rows[i]["MEASURE"].String | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cac0321b | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1896 | try ▸ for (i < maxRow) ▸ switch (rNotation[i]) case "INTEGER": | DATA_OP | rMeasureType[i] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-7e629edb | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1899 | try ▸ for (i < maxRow) ▸ switch (rNotation[i]) case "POINT": | DATA_OP | rMeasureType[i] | 2 | 행/컬럼 값 대입 |  |  |  |
| AC-3e005b6a | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1902 | try ▸ for (i < maxRow) ▸ switch (rNotation[i]) case "POINT3": | DATA_OP | rMeasureType[i] | 3 | 행/컬럼 값 대입 |  |  |  |
| AC-d907dc84 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1911 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 1: | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a8929250 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1912 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 1: | UI_PROP | gc.FormatString | "###,###,###,###" | 속성 FormatString 설정 |  |  |  |
| AC-a812c161 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1913 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 1: | GRID_SET | siMain.ActiveSheet.Cells[i, iStartCol, i, siMain.GetMaxColumnIndex()].CellType | gc | 그리드 속성/값 설정 |  |  |  |
| AC-621d6b34 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1914 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 1: | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2d370deb | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1917 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 3: | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-40f16ce7 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1918 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 3: | UI_PROP | gc.FormatString | "###,###,###,##0.000" | 속성 FormatString 설정 |  |  |  |
| AC-6b94d00c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1919 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 3: | GRID_SET | siMain.ActiveSheet.Cells[i, iStartCol, i, siMain.GetMaxColumnIndex()].CellType | gc | 그리드 속성/값 설정 |  |  |  |
| AC-226301d3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1920 | try ▸ for (i < maxRow) ▸ switch (rMeasureType[i]) case 3: | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-81ee7127 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1935 | if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-876b55c9 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1936 | if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSaveFinal.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7aea15c2 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1941 | if (siMain.GetMaxRowIndex() >= 0) | FLAG | iResultCol | iStartCol | 화면 필드/플래그 변경 |  |  |  |
| AC-2ac357df | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1944 | if (siMain.GetMaxRowIndex() >= 0) | FLAG | count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c0368b4d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1949 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && int.Parse… | FLAG | iResultCol | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-df1a88b5 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1955 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && iso_week … | FLAG | count | count++ | 화면 필드 증감 |  |  |  |
| AC-40878968 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1960 | if (siMain.GetMaxRowIndex() >= 0) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-554c6fe7 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1966 | if (siMain.GetMaxRowIndex() >= 0) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) ▸ if (siMain.GetColumnTag(iResultMonth)… | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-45601793 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1998 | if (siMain.GetMaxRowIndex() >= 0) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ i… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-68f41626 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:2002 | if (siMain.GetMaxRowIndex() >= 0) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ i… | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-a6801e9d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:2003 | if (siMain.GetMaxRowIndex() >= 0) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ i… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-a3875c72 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:2009 | if (siMain.GetMaxRowIndex() >= 0) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ e… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-23297fec | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:2016 | if (siMain.GetMaxRowIndex() >= 0) ▸ else of (cboBucketType.ControlValues != BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketTyp… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-027f5d24 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:2021 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ try ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ try] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39111b42 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1534 | if (!isCurVersion) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c0ae1bf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1538 | if (this.fps != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-67ed0247 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1552 | if (this.fps != null) ▸ try ▸ if (clbDivision.ControlValues == "40") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siMain.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8959238 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1553 | if (this.fps != null) ▸ try ▸ if (clbDivision.ControlValues == "40") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siMain.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba086912 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1561 | if (this.fps != null) ▸ try ▸ if ((dtWeek == null) \|\| (dtWeek.Rows.Count == 0)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00259") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e85bdfe0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1562 | if (this.fps != null) ▸ try ▸ if ((dtWeek == null) \|\| (dtWeek.Rows.Count == 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63105c3b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1565 | if (this.fps != null) ▸ try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-55072653 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1572 | if (this.fps != null) ▸ try ▸ if (sv.Columns[xCol1].Visible == false) | GRID_SET | sv.Columns[xCol1].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cb63f569 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1573 | if (this.fps != null) ▸ try ▸ if (sv.Columns[xCol1].Visible == false) | GRID_LOCK | siMain.SetLockFlag | (sv.SheetName, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-df9357d8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1578 | if (this.fps != null) ▸ try ▸ else of (sv.Columns[xCol1].Visible == false) | GRID_SET | sv.Columns[xCol1].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-915d77da | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1579 | if (this.fps != null) ▸ try ▸ else of (sv.Columns[xCol1].Visible == false) | GRID_LOCK | siMain.LockColumn2 | (xCol1 + 1, sv.Columns.Count - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e5c2fc64 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1581 | if (this.fps != null) ▸ try ▸ else of (sv.Columns[xCol1].Visible == false) | GRID_LOCK | siMain.SetLockFlag | (sv.SheetName, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a62d4ad | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1591 | if (this.fps != null) ▸ try ▸ if (siMain.GetMaxRowIndex() != -1 && iResultCol != -1 && iResultCol != iStartCol) | GRID_STYLE | siMain.SetBGColor2 | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-41d99487 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1596 | if (this.fps != null) ▸ try ▸ if (siMain.GetMaxRowIndex() != -1 && iResultCol != -1 && iResultCol != iStartCol) ▸ if (siMain.GetColumnIndex(… | GRID_STYLE | siMain.SetBGColor2 | (0, siMain.GetColumnIndex(this_YYYYMM), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(thi… | 그리드 표시 설정 |  |  |  |
| AC-03efa31d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:1605 | if (this.fps != null) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | (true) | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bdf897b | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1624 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-06f160c3 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1625 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-422cd022 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1626 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-9e6a4ea5 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1627 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-07a80547 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1628 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-7f5b9799 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1629 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-41b182ec | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1631 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-1e682f88 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1632 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-b40aa8cb | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1634 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-434a1af5 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1643 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fd3aebf | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1648 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-db741fb3 | ExcelButton | DMF0082_FcstNPrice_Mgmt.cs:1652 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.FindData

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61d0fa6f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1666 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1b6b213d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1674 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9afb8df3 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1676 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2775a17 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1682 | try ▸ if (txtVersion.Text.Trim() == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8060872 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1683 | try ▸ if (txtVersion.Text.Trim() == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1e9eec8 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1687 | try | FLAG | isCurVersion | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e51cc48f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1695 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8aa8968b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1696 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e39270c7 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1701 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa7bc25d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1703 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-5cfa52de | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1705 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfecf04d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1708 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-742e356c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1717 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8e8325d8 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1719 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9cb55ed2 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1723 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_GET_MAIN_DATA") ⇒ DM.DMF0082_GET_MAIN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-8fe278be | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1725 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-44bccd5d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1727 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e727a42a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1728 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b5bc4be6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1729 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0af04eb7 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1730 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d46fdefc | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1731 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ec3fde02 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1732 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-29b38b15 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1733 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-c08e47eb | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1734 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b8f8e3e0 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1735 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-e1050bbe | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1736 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-1527a8be | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1737 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-24feed60 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1738 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6a986d5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1740 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-18036c2c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1742 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3669565f | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1748 | try ▸ if (ds.Tables.Count >= 2) | FLAG | dtWeek | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-6af051f5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1752 | try ▸ if (ds.Tables.Count >= 5) | FLAG | dtCalendarDetail | ds.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-18a81951 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1758 | try | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-0ec61370 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1765 | try | FLAG | dtCustomsHandbook | GetCustomsHandbook() | 화면 필드/플래그 변경 |  |  |  |
| AC-66bd00ab | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1766 | try | FLAG | dtWarrType | GetFcstType() | 화면 필드/플래그 변경 |  |  |  |
| AC-85bac735 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1773 | try | FLAG | sDefaultDay | Data.Common(Data.Type.DefaultBucketDay, false, sDivision, cboBucketType.ControlValues).Row… ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 화면 필드/플래그 변경 |  |  |  |
| AC-dfd952d9 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1773 | try | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, cboBucketType.ControlValues) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09f6b246 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1778 | try ▸ if (txtVersion.Text.Trim() == "Current") | FLAG | isCurVersion | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a63688d9 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1783 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-505ee5be | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1787 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dd3c7671 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:1788 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d9aa59d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2222 |  | STATE_RESET | dtSaveFinal.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-be5e810f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2223 |  | FLAG | bInputCheck2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c1f526ac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2336 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ … | FLAG | bInputCheck2 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-258b06e8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2356 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | bInputCnt[iIdex] | iCnt | 행/컬럼 값 대입 |  |  |  |
| AC-e145e115 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2371 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-ba905498 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2375 | else of (iValidation > 1) ▸ if (!bInputCheck) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-de811625 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2395 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ for (iRow <= siMain.GetMaxRowIndex()) | DATA_OP | dtSave.Select | (filterExpression) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6807d80 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2401 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (filteredRows.Count() > 0) ▸ foreach (DataRo… | DATA_OP | dtSaveFinal.ImportRow | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-44bae1d1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2408 | else of (iValidation > 1) ▸ else of (!bInputCheck) | FLAG | dtSaveFinal | dtSaveFinal.DefaultView.ToTable(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c191c36 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2408 | else of (iValidation > 1) ▸ else of (!bInputCheck) | DATA_OP | dtSaveFinal.DefaultView.ToTable | (true) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ea6459a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2409 | else of (iValidation > 1) ▸ else of (!bInputCheck) | DATA_OP | dtSaveFinal.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c953198 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0082_FcstNPrice_Mgmt.cs:2489 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23cb3b35 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:314 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c5102bc | this.Load | DMF0082_FcstNPrice_Mgmt.cs:315 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-866eabc9 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0082_FcstNPrice_Mgmt.cs:3086 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c6f33097 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0082_FcstNPrice_Mgmt.cs:3087 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ebc0aba6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0082_FcstNPrice_Mgmt.cs:3088 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d8628e7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0082_FcstNPrice_Mgmt.cs:3090 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ad072dc | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3230 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-804181c1 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3231 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c05b0b1 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3233 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6fad7a3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8699 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-da9fe178 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8700 |  | DATA_OP | request.Parameters["CODE"] | "DM_CUSTOMS_HANDBOOK" | 행/컬럼 값 대입 |  |  |  |
| AC-31c1ab95 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8701 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b515b039 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8702 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c267207 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8703 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c8c3d680 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8704 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-179ec937 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8705 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d7e91f3 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8706 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aacd5e30 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8708 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.getDayOfWeek

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) ▸ if ((sBucketType == BucketType.Weekly) && sColName.IndexOf("W_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (sMeasure != "LOC") ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c2682a3 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | DMF0082_FcstNPrice_Mgmt.cs:3245 |  | RETURN | return (int)Convert.ToDateTime(strD2).DayOfWeek; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0302f02d | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3103 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-b0eaaf0c | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3104 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e250e789 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3105 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-aecfd118 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3107 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b4327822 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:3110 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetFcstType

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b4490ce | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8659 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-7593a6fc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8660 |  | DATA_OP | request.Parameters["CODE"] | "FCST_TYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-7a114452 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8661 |  | DATA_OP | request.Parameters["PARAM1"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9bc1f0e0 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8662 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73b2350d | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8663 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-63b889d8 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8664 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ccb7a058 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8665 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb96a70a | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8666 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1fb4c5a6 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:8668 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b724da5 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3166 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO") ⇒ DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-f7d07231 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3167 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-0dc3d6e6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3168 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-8f5df62d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3170 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5699c20 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 1 | DMF0082_FcstNPrice_Mgmt.cs:3173 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetIncotermsType

진입점: this.spdMain.ClipboardPasted [if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4284e50e | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8681 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-b5cb8e02 | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8682 |  | DATA_OP | request.Parameters["CODE"] | "AS_INCOTERMS" | 행/컬럼 값 대입 |  |  |  |
| AC-85b58e3f | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8683 |  | DATA_OP | request.Parameters["PARAM1"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-478bf0aa | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8684 |  | DATA_OP | request.Parameters["PARAM2"] | sScmSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-568d85f9 | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8685 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce0012ee | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8686 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-302219f9 | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8687 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-30c5bdb8 | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8688 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d92a1e74 | this.spdMain.ClipboardPasted [if (range != null && range.Row… | DMF0082_FcstNPrice_Mgmt.cs:8690 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetLookupValues

진입점: this.spdMain.ClipboardPasted [if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)] / this.spdMain.CellDoubleClick [else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f64f8d36 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8719 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-5c5e7810 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8720 |  | DATA_OP | request.Parameters["CODE"] | p_code | 행/컬럼 값 대입 |  |  |  |
| AC-574cf177 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8721 |  | DATA_OP | request.Parameters["PARAM1"] | p_param1 | 행/컬럼 값 대입 |  |  |  |
| AC-f03f4692 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8722 |  | DATA_OP | request.Parameters["PARAM2"] | p_param2 | 행/컬럼 값 대입 |  |  |  |
| AC-a72f035b | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8723 |  | DATA_OP | request.Parameters["PARAM3"] | p_param3 | 행/컬럼 값 대입 |  |  |  |
| AC-adfa165d | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8724 |  | DATA_OP | request.Parameters["PARAM4"] | p_param4 | 행/컬럼 값 대입 |  |  |  |
| AC-e6614194 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8725 |  | DATA_OP | request.Parameters["PARAM5"] | p_param5 | 행/컬럼 값 대입 |  |  |  |
| AC-e2bedff0 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8726 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f82ba216 | this.spdMain.ClipboardPasted [if (range != null && range.Row… 외 4 | DMF0082_FcstNPrice_Mgmt.cs:8728 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetSalesSite

진입점: this.clbCustomer.SelectedIndexChanged [if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0f05b26 | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3186 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-920f55ec | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3187 |  | DATA_OP | request.Parameters["CODE"] | "SiteByEndCustomer" | 행/컬럼 값 대입 |  |  |  |
| AC-bb13e57b | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3188 |  | DATA_OP | request.Parameters["PARAM1"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-bd37502f | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3189 |  | DATA_OP | request.Parameters["PARAM2"] | sCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-c89a0569 | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3190 |  | DATA_OP | request.Parameters["PARAM3"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-d25d4378 | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3191 |  | DATA_OP | request.Parameters["PARAM4"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-63d17a3e | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3192 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7ab6b000 | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3193 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eba600ec | this.clbCustomer.SelectedIndexChanged [if ((clbDivision.Cont… | DMF0082_FcstNPrice_Mgmt.cs:3195 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetSalesSite40

진입점: this.clbCustomer.SelectedIndexChanged [else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a29e3ea8 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3208 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-6349ea97 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3209 |  | DATA_OP | request.Parameters["CODE"] | "SiteByEndCustomer40" | 행/컬럼 값 대입 |  |  |  |
| AC-7f02ea29 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3210 |  | DATA_OP | request.Parameters["PARAM1"] | sTeamID | 행/컬럼 값 대입 |  |  |  |
| AC-89663963 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3211 |  | DATA_OP | request.Parameters["PARAM2"] | sCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-a62dd769 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3212 |  | DATA_OP | request.Parameters["PARAM3"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-da594a49 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3213 |  | DATA_OP | request.Parameters["PARAM4"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-5f47e167 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3214 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3bf6df98 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3215 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-22655935 | this.clbCustomer.SelectedIndexChanged [else of ((clbDivision… | DMF0082_FcstNPrice_Mgmt.cs:3217 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-568358f0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:438 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_GET_SPREAD_TITLE") ⇒ DM.DMF0082_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-7f1facd8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:440 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-33211609 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:441 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-643e9adf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:442 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ae5bda85 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:443 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5f9022d3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:445 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-991a7a35 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:445 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0082_FcstNPrice_Mgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c422fa6 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:342 |  | FLAG | dtDivision | dtDivision.Select("CODE = '40'").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-e44ca715 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:342 |  | DATA_OP | dtDivision.Select("CODE = '40'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f4ee815 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:342 |  | DATA_OP | dtDivision.Select | ("CODE = '40'") | 데이터 객체 조작/조회 |  |  |  |
| AC-008e0832 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:343 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f91aaf31 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:348 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c956de0a | this.Load | DMF0082_FcstNPrice_Mgmt.cs:353 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bfe4bd02 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:357 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b111a43f | this.Load | DMF0082_FcstNPrice_Mgmt.cs:358 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-584fd027 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:361 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-5fd6e413 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:365 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e8f09562 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:368 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f24ef33 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:369 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d86220c6 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:372 |  | VALUE_SET | txtVersion.Text | "Current" | 컨트롤 값 설정 |  |  |  |
| AC-e7509c83 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:376 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2c363e0 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:377 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3ae7f4c | this.Load | DMF0082_FcstNPrice_Mgmt.cs:380 |  | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-d9c65d6a | this.Load | DMF0082_FcstNPrice_Mgmt.cs:382 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-756ba915 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:633 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-9654361e | this.Load | DMF0082_FcstNPrice_Mgmt.cs:634 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e52f6ad6 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:635 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cdfa800 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:636 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5b5b5b | this.Load | DMF0082_FcstNPrice_Mgmt.cs:637 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Customer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93633c88 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:638 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4938467 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:639 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9abf0fc3 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:640 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac4ff5d1 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:641 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3279b4a | this.Load | DMF0082_FcstNPrice_Mgmt.cs:642 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9df425e9 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:643 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f108527 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:644 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlantSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-665894f0 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:645 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CELL_PROD_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae9fb736 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:646 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f4d77f6 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:647 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CURRENCY, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6354f07 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:648 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b33e0e9e | this.Load | DMF0082_FcstNPrice_Mgmt.cs:650 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-687c912e | this.Load | DMF0082_FcstNPrice_Mgmt.cs:651 |  | DATA_OP | dtSaveFinal.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-427f8104 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:652 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa4e7505 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:653 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf231892 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:654 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Customer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ca18b95 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:655 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b25faeb0 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:656 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a610c54 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:657 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-30a0d8a6 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:658 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-849e3ba0 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:659 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18845d2f | this.Load | DMF0082_FcstNPrice_Mgmt.cs:660 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bd15ca5 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:661 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.PlantSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-888379ae | this.Load | DMF0082_FcstNPrice_Mgmt.cs:662 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.CELL_PROD_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-26c9efe7 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:663 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f86f3526 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:664 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.CURRENCY, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8673b792 | this.Load | DMF0082_FcstNPrice_Mgmt.cs:665 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Qty, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40261dfd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:421 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baec45ff | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:614 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b9eddb44 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:615 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-e3be37b8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:623 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-38d29c16 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:624 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0bf363d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:625 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-bd754ed1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:626 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.Insert

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9c792bf | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9299 | if (siMain.IsLock(sv.SheetName) == true) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-01099da5 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9306 | if (c == null) | DATA_OP | this.sv.Rows.Add | (iIndex, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-173e33d0 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9308 | if (c == null) | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-221a4ceb | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9311 | if (c == null) | VALUE_SET | range1.Text | CAppSetting.StringI | 컨트롤 값 설정 |  |  |  |
| AC-f494d80b | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9312 | if (c == null) | UI_PROP | range1.ForeColor | ControlColor.FGAction | 속성 ForeColor 설정 |  |  |  |
| AC-63ff8f77 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9313 | if (c == null) | UI_PROP | range1.BackColor | ControlColor.BGInserted | 속성 BackColor 설정 |  |  |  |
| AC-3cbe6da8 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9319 | if (c == null) | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-889d40e3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9325 | if (c == null) | VALUE_SET | range1.Text | CAppSetting.StringI | 컨트롤 값 설정 |  |  |  |
| AC-2f2afc0c | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9326 | if (c == null) | UI_PROP | range1.ForeColor | ControlColor.FGAction | 속성 ForeColor 설정 |  |  |  |
| AC-29b3b472 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9327 | if (c == null) | UI_PROP | range1.BackColor | ControlColor.BGInserted | 속성 BackColor 설정 |  |  |  |
| AC-798d9048 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9332 | if (c == null) | STATE | range3.Locked | false | 컨트롤 상태 Locked |  |  |  |
| AC-99070c84 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9333 | if (c == null) | UI_PROP | range3.BackColor | ControlColor.UnLockColor | 속성 BackColor 설정 |  |  |  |
| AC-3491ea88 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9337 | if (c == null) | RETURN | return range1; |  | 처리 중단/반환 |  |  |  |
| AC-ac92077f | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9341 |  | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a82adbfc | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9374 |  | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0082c78c | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9379 |  | GRID_STYLE | sv.SetActiveCell | (sv.ActiveRowIndex, 0) | 그리드 표시 설정 |  |  |  |
| AC-e625d54d | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9384 | if (xRow1 < 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6645f3c0 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9387 |  | DATA_OP | sv.Rows.Add | (xRow1, xRow2 - xRow1 + 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba94b48b | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9390 |  | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c4385e9 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9396 |  | VALUE_SET | range1.Text | CAppSetting.StringI | 컨트롤 값 설정 |  |  |  |
| AC-4d3be4df | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9397 |  | UI_PROP | range1.ForeColor | ControlColor.FGAction | 속성 ForeColor 설정 |  |  |  |
| AC-3941be45 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9398 |  | UI_PROP | range1.BackColor | ControlColor.BGInserted | 속성 BackColor 설정 |  |  |  |
| AC-73e16a33 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9407 |  | CALL_EXT | this.sv.GetColumnFromTag | (null, CAppSetting.StringSelect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e1f19a8 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9409 | if (this.sv.GetColumnFromTag(null, CAppSetting.StringSelect) != null) | CALL_EXT | this.sv.GetColumnFromTag | (null, CAppSetting.StringSelect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f02a53a | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9409 | if (this.sv.GetColumnFromTag(null, CAppSetting.StringSelect) != null) | CALL_EXT | this.sv.GetColumnFromTag | (null, CAppSetting.StringSelect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-491aeba9 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9414 |  | FLAG | base.IsChange | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3017ddc2 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0082_FcstNPrice_Mgmt.cs:9415 |  | RETURN | return range1; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-734b5a9f | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:681 | if (!isCurVersion) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdfc40f2 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2500 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-67d0f1ec | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f04b38f | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2528 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtincotermsEditType | GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-0bd91418 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2531 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5c000ee3 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2532 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2e17f3b2 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2540 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0aaeaaf4 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2541 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | GRID_SET | siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.ItemId)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-53709348 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2545 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c3991114 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2546 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Division), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-b8e2f899 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f226bc95 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2552 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2de94b22 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2571 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!siMain.SpreadObject.IsLay… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a85c6546 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.FcstType), dtWarrType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7e4c472e | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37a2de99 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-491feac9 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2590 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f540fa43 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2591 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Customer), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-230d508c | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2595 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3c3f6595 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2596 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-70295ac0 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2600 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e747e870 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2605 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-125d7603 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | FLAG | dtincotermsEditType | GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-247c23dc | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2617 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6378e164 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2621 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | FLAG | dtMeasure | GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteID, cboBucketType… ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-ee9f535c | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-63a800b7 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-b03f991f | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9dec8063 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2626 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-361b1812 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-e7d2d75a | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6a26d23 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2630 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-68b4b277 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2638 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-08d5103c | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2640 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Division), siMain.GetValue(iFocusRow, siMain.Ge… | 그리드 값 설정 |  |  |  |
| AC-4a07c32a | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-69af82d5 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2643 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Customer), siMain.GetValue(iFocusRow, siMain.Ge… | 그리드 값 설정 |  |  |  |
| AC-86eb8264 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2645 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ded1cb5b | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2646 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), siMain.GetValue(iFocusRow, siMain.G… | 그리드 값 설정 |  |  |  |
| AC-efd58402 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2648 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-67fd5fe0 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2649 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.ItemId), siMain.GetValue(iFocusRow, siMain.GetC… | 그리드 값 설정 |  |  |  |
| AC-4907b03e | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2651 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-499415d6 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2652 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), siMain.GetValue(iFocusRow, siMain.G… | 그리드 값 설정 |  |  |  |
| AC-709cde5e | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2654 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ce9ed423 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.FcstType), siMain.GetValue(iFocusRow, siMain.Ge… | 그리드 값 설정 |  |  |  |
| AC-3cd9873c | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2657 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d0c89e3 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2658 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.DomExp), siMain.GetValue(iFocusRow, siMain.GetC… | 그리드 값 설정 |  |  |  |
| AC-26e098ea | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2660 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6508e35b | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2661 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), siMain.GetValue(iFocusRow, … | 그리드 값 설정 |  |  |  |
| AC-9aaf01e2 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2663 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-eca41d99 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2664 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.GetValue(iFocusRow, siMain.Ge… | 그리드 값 설정 |  |  |  |
| AC-e67758cb | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2666 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) ▸ if (!siMain.Sp… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ab4449a4 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetValue(iFocusRow, siMain.Get… | 그리드 값 설정 |  |  |  |
| AC-5e912444 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (bFocusYN) ▸ if (!siMa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e813448a | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2674 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (bFocusYN) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), "MKT_FCST") | 그리드 값 설정 |  |  |  |
| AC-6ccc4a8f | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2689 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!siMain.SpreadObject.IsLay… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-37e5c923 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(this… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-294962d3 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2721 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(this… | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-3b46fee4 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(this… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-492667c5 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2728 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(this… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5dc67814 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2733 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(this… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-0d288ef6 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (string sColName in ar… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-29f4abd9 | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:2751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (string sColName in ar… | GRID_LOCK | siMain.LockRange2 | (iActRow, siMain.GetColumnIndex(sColName), iRowCount, siMain.GetColumnIndex(sColName), fal… | 그리드 편집 잠금 전환 |  |  |  |
| AC-b4f741fd | InsertButton | DMF0082_FcstNPrice_Mgmt.cs:3031 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | (true) | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d413281 | OnShown | DMF0082_FcstNPrice_Mgmt.cs:330 | if (sDivision == "40") | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ccf35ee | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2057 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bInputCheck2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Currency" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d27903fe | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2058 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bInputCheck2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bace6f42 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!bInputCheck) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4c5ae67 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2065 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!bInputCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cc82681 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!bInputCheck) | MESSAGE | MessageHelper.GMessageBox | ("MSG00449") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28ec6ead | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!bInputCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6387061a | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2129 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f5e60126 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2133 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (confirmR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8592443 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2135 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0608b164 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2136 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5a0f2195 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2145 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0082_SAVE_MAIN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-180c6523 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2146 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-007fe810 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2147 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7a976e38 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2148 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-e35a53b3 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-37d02a98 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2150 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-983f9ff9 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2151 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-05721623 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2152 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-4e77b455 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2153 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-72c447a7 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-37ec8e7b | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2155 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-34b1145a | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2156 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-99305528 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_prod_site_id"] | sCellProdSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-8d564e0c | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2158 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-9f767413 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2159 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-d0bf6706 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2160 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-e42c9d06 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2161 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-bad382b8 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2163 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-31e87ea8 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62709df9 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | DATA_OP | response.DataSet.Tables[0].Columns.Contains | ("RESULT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9eea4fac | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0]["RESULT_CNT"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dd333a1 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb4bacf0 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-ca660189 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c70001de | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2180 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | DATA_OP | response.DataSet.Tables[0].Columns.Contains | ("RESULT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9be4ec04 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2184 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | DATA_OP | response.DataSet.Tables[0].Columns.Contains | ("ERR_MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fefc24f3 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2186 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageBox.Show | (response.DataSet.Tables[0].Rows[0]["ERR_MESSAGE"].ToString()) | 메시지 표시 |  |  |  |
| AC-44cca6d6 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2190 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | DATA_OP | response.DataSet.Tables[0].Columns.Contains | ("RESULT_MSG") | 데이터 객체 조작/조회 |  |  |  |
| AC-f194bae6 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2192 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageBox.Show | (response.DataSet.Tables[0].Rows[0]["RESULT_MSG"].ToString()) | 메시지 표시 |  |  |  |
| AC-8b0d71b5 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2203 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98efa024 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2207 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-75ab9409 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2208 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally | STATE_RESET | dtSaveFinal.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5e13dde2 | SaveButton | DMF0082_FcstNPrice_Mgmt.cs:2213 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00449") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetChangeControl

진입점: this.clbTeam.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37522a02 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8739 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4884399c | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8740 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0810e512 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8745 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a92d8917 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8745 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e55dc1f7 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8748 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d672bd96 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8749 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f92cc2ea | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8749 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3af5b2f8 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8752 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7063355d | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8753 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b9ff1b22 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8754 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c30571e | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8754 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-41b5e61a | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8757 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ee6b92a8 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8758 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-75371b70 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8758 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e95b01a9 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8761 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cc4e2d30 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8762 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-04bf3e6f | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8763 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-fada8ce7 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8764 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-64373a4d | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8764 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4237943e | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8767 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-572b7c53 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8768 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-fc45fb1d | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8769 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-efeee3a4 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8769 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e83a7859 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8772 | switch (triggerControl) case "EdiSender": | FLAG | dtEdiSender | DataService.GetDMInnerTable("EdiSender", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a966f8 | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8772 | switch (triggerControl) case "EdiSender": | COMBO_DATA | DataService.GetDMInnerTable | ("EdiSender", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-48943e7b | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8775 | switch (triggerControl) case "ScmSitebyEndCustomer40": | FLAG | dtSalesSite40 | DataService.GetDMInnerTable("ScmSitebyEndCustomer40", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c97f3ce | this.clbTeam.SelectedIndexChanged 외 1 | DMF0082_FcstNPrice_Mgmt.cs:8775 | switch (triggerControl) case "ScmSitebyEndCustomer40": | COMBO_DATA | DataService.GetDMInnerTable | ("ScmSitebyEndCustomer40", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetEditList

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count > 0) ▸ if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE") && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50459464 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9064 |  | STATE_RESET | list_EDIT_Week.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e7f5b4c7 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9065 |  | STATE_RESET | list_EDIT_Month.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cbc3344f | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9066 |  | STATE_RESET | list_EDIT_Day.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5b0c66d1 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9067 |  | STATE_RESET | list_EDIT_Month_M4.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-383acb26 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9087 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (int.Parse(this_YYYYMM.Replace("M_", "")) … | DATA_OP | list_EDIT_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-dac7b63e | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9092 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (int.Parse(this_YYYYMM.Replace("M_", "")) … | DATA_OP | list_EDIT_Month_M4.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-2338f122 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9114 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && siMain.GetColumnIndex(this_YYYYMMWW) > 0 && s… | DATA_OP | list_EDIT_Week.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-381d12e1 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9122 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && siMain.GetColumnIndex(this_YYYYMMWW) > 0… | DATA_OP | list_EDIT_Week.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fb3de14 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9135 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸ if (int.Parse(sResultYYYYMMDD) <= int.Parse(s… | DATA_OP | list_EDIT_Day.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-166b5d51 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9145 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | dsMain.Tables[3].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58051d14 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9168 | if (dsMain != null && dsMain.Tables.Count >= 3) | FLAG | bEDIT_AUTH_SCM_FCST | (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "SCM_FCST" select r.Field… | 화면 필드/플래그 변경 |  |  |  |
| AC-b9011f60 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9168 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-05787da1 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9168 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("EDIT_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-42d318e5 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9170 | if (dsMain != null && dsMain.Tables.Count >= 3) | FLAG | bEDIT_AUTH_MKT_FCST | (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "MKT_FCST" select r.Field… | 화면 필드/플래그 변경 |  |  |  |
| AC-3de04f98 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9170 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-65701a5c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9170 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("EDIT_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-988e9507 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9172 | if (dsMain != null && dsMain.Tables.Count >= 3) | FLAG | bEDIT_AUTH_LOC | (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "LOC" select r.Field<stri… | 화면 필드/플래그 변경 |  |  |  |
| AC-46cb372c | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9172 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c1a9d02 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9172 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("EDIT_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-8691863b | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9174 | if (dsMain != null && dsMain.Tables.Count >= 3) | FLAG | bEDIT_AUTH_VMI_IN_REQ | (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "VMI_In_Req" select r.Fie… | 화면 필드/플래그 변경 |  |  |  |
| AC-a72813c7 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9174 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b9a7f77 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DMF0082_FcstNPrice_Mgmt.cs:9174 | if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | r.Field | ("EDIT_FLAG") | 데이터 객체 조작/조회 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetLockRange

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ try ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ try ▸ if (this.fps != null) ▸ try] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I") ▸ if (sColName == "CURRENCY" \|\| sColName == "MEASURE") ▸ if (sColName == "MEASURE")] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / EditButton [if (this.fps != null) ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdb2f987 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0082_FcstNPrice_Mgmt.cs:9190 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-99f3f663 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0082_FcstNPrice_Mgmt.cs:9253 | for (iRow <= iEndRow) ▸ if (sAction == CAppSetting.StringI) | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금 전환 |  |  |  |
| AC-29c977be | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0082_FcstNPrice_Mgmt.cs:9261 | for (iRow <= iEndRow) ▸ foreach (int idx in list_Edit_Target_Idx) ▸ switch (sMeasure) case "LOC": | GRID_LOCK | siMain.LockRange2 | (iRow, idx, iRow, idx, bLockFlag, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-6e453b62 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0082_FcstNPrice_Mgmt.cs:9269 | for (iRow <= iEndRow) ▸ foreach (int idx in list_Edit_Target_Idx) ▸ switch (sMeasure) case "MKT_FCST": case "SCM_FCST": case "VMI_In_Req": ▸… | DATA_OP | list_EDIT_Month_M4.Contains | (idx) | 데이터 객체 조작/조회 |  |  |  |
| AC-abd9cc04 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0082_FcstNPrice_Mgmt.cs:9271 | for (iRow <= iEndRow) ▸ foreach (int idx in list_Edit_Target_Idx) ▸ switch (sMeasure) case "MKT_FCST": case "SCM_FCST": case "VMI_In_Req": ▸… | GRID_LOCK | siMain.LockRange2 | (iRow, idx, iRow, idx, bLockFlag, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-49493124 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0082_FcstNPrice_Mgmt.cs:9276 | for (iRow <= iEndRow) ▸ foreach (int idx in list_Edit_Target_Idx) ▸ switch (sMeasure) case "MKT_FCST": case "SCM_FCST": case "VMI_In_Req": ▸… | GRID_LOCK | siMain.LockRange2 | (iRow, idx, iRow, idx, bLockFlag, true) | 그리드 편집 잠금 전환 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetSaveData

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)] / DeleteButton [else of (sAction == "D") ▸ else of (sAction == "I") ▸ if (sMeasure == "MKT_FCST" \|\| sMeasure == "VMI_In_Req" \|\| sMeasure == "SCM_FCST" \|\| sMeasure == "LOC") ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ if (alDelDayList.Count > 0) ▸ if (!isDayValExists) ▸ foreach (int iDayCol in alDelDayList)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7050b09 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7658 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd12897a | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7666 | if (sDivision == "40") ▸ if (sEndCustomer == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b743196d | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7671 | if (sDivision == "40") ▸ if (sScmSiteId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97332a0d | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7676 | if (sDivision == "40") ▸ if (sItemId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9060e448 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7683 | if (sIncoterms == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdfa4ed2 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7688 | if (sFcstType == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42d72bbe | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7693 | if (((sDivision == "40") \|\| (sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) && (sDomExp == "")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df5894da | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7698 | if (sMeasure == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fc242f3 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7702 | if (sYYYYMMDD.Length != 8) | MESSAGE | MessageBox.Show | ("YYYYMMDD형식이 맞지 않습니다.") | 메시지 표시 |  |  |  |
| AC-aa8eddfd | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7703 | if (sYYYYMMDD.Length != 8) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6798c370 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7708 | if (sCellProdSiteID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cd3e420 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7713 | if (sMeasure == "LOC" && sCurrency == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e49e3e68 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7751 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-d82646b8 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7755 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec41eab7 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7756 | if (drFind.Length == 0) | DATA_OP | drNew["Action"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-4a8a07a9 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7757 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-47ab711e | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7758 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-8af76202 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7759 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Customer] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-b47558fe | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7760 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSiteId] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-53853143 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7761 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-909c20ca | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7762 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-de5f873c | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7763 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-87c53d6e | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7764 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-41b2911c | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7765 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-b11c7d5c | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7766 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlantSiteId] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-bffc1f77 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7767 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CELL_PROD_SITE_ID] | sCellProdSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-b08307db | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7768 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-af3f6bad | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7769 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CURRENCY] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-ecc6845e | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7770 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-3bb19116 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7772 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-fed726dd | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7773 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0634ec5b | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7778 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-a2d22b02 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7779 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetSaveDataRemove

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) ▸ else of ((sBucketType == BucketType.Weekly) && sColName.IndexOf("W_") == 0) ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if (sColName.IndexOf("D_") != 0 && sColName.IndexOf("W_") != 0 && sColName.IndexOf("M_") != 0 && sColName.Trim() != "COLMERG…) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)] / DeleteButton [if (sAction == "D"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e68353eb | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7790 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4297c0f | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7798 | if (sDivision == "40") ▸ if (sEndCustomer == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d69d67a | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7803 | if (sDivision == "40") ▸ if (sScmSiteId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0c32313 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7808 | if (sDivision == "40") ▸ if (sItemId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d39f3db8 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7815 | if (sIncoterms == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf5e19d5 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7820 | if (sFcstType == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfe2ca98 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7825 | if (sDomExp == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e81849f5 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7830 | if (sMeasure == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-810a7355 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7835 | if (sCellProdSiteID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea3c5c61 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7851 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7ac5d04 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7857 | if (drFind.Length > 0) ▸ for (i < drFind.Length) | DATA_OP | dtSave.Rows.Remove | (drFind[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b0c86ab | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… 외 1 | DMF0082_FcstNPrice_Mgmt.cs:7858 | if (drFind.Length > 0) ▸ for (i < drFind.Length) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ try] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b78488b0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:547 |  | FLAG | sResultYYYYMMDD | dateTime2.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-10d59b22 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:555 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ec7fc5bb | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:559 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-79a48e02 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:565 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d203d358 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:567 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-23b35d78 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:571 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0f95fa6a | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:577 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4e7ed13 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:579 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e6abb281 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:586 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(iCol).Substring(2) ==… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-b1be956a | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:587 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(iCol).Substring(2) ==… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-687a6463 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:595 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-d6bef241 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:596 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-ca1dfc43 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:603 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-e5428fee | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0082_FcstNPrice_Mgmt.cs:604 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a7ed51c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:476 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c3d30bd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:484 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6987aa81 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:497 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-645296c6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:507 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-450b4216 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:508 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00956ca5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:513 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d65aa7a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:514 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef5f4de7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:521 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1ce81ad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:522 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68a076d4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:533 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e1cb3d7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:534 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85ddc0a7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:535 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a30259e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:536 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-478d3366 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:538 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e3ba3958 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0082_FcstNPrice_Mgmt.cs:540 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c440eb33 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3544 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-2fdf6f77 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3550 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5fdc26e8 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3566 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") != -1) ▸ … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-784afbbf | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3611 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ae8ca0f | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3658 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP") ⇒ DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-6bc7efd8 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3660 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6c2b27b9 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3667 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | sPeriod[0] | sMonday.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ea5e41c9 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3668 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | sPeriod[1] | sMonday.AddDays(20).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8ad5e947 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3672 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4804c1cf | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3673 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_scm_site_id"] | ScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-636b82f2 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3678 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_project_code"] | Customer | 행/컬럼 값 대입 |  |  |  |
| AC-c7167970 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3679 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-d72d16e7 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3681 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_dom_exp"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-ae8acfc2 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3682 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-ae5697a8 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3683 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-1916fa67 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3684 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | DATA_OP | request.Parameters["p_yyyymmdd"] | sYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c80d96ac | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3695 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0bcf24f | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3697 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | POPUP | new DMF0003_SspSyncComparePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-7d4f8171 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3698 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | CALL_EXT | popup.LoadData | (response.DataSet.Tables[0], sDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1ab9ecd | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3699 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-85fe3e18 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3700 | else of (e.ColumnHeader) ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sC… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9c638fa2 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3710 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4aba96bd | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3735 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4b39fa37 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3737 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dfae9dcb | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3738 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0d9b3d4d | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3739 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fc65f2a8 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3749 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-83b9c31e | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3753 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-18980468 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3758 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-07bb6caa | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3763 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), sBizType) | 그리드 값 설정 |  |  |  |
| AC-987f53c6 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3768 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectOwner), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-a7554141 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3800 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-58d2c355 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3804 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId, sMdmActive_Sw, sMeasu… | 팝업 초기화(인자 전달) |  |  |  |
| AC-3cebf2e6 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3805 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-81443074 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3806 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6e1431a1 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3815 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-0029068a | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3818 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemName), sItemName) | 그리드 값 설정 |  |  |  |
| AC-91c5e7b9 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3820 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType) | 그리드 값 설정 |  |  |  |
| AC-5496b7b5 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3822 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |
| AC-6e39b570 | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3828 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | FLAG | dtincotermsEditType | GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-d599afdc | this.spdMain.CellDoubleClick | DMF0082_FcstNPrice_Mgmt.cs:3829 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a608639e | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5539 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb4f40dd | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5542 | if (e.Column <= 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1b6f0b4 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5628 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-58cd46b3 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5628 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0fbdf7f | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5633 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e90a8e7a | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5634 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3aa858a8 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5635 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ae0f5f0e | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5639 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | FLAG | dtCurrency | GetLookupValues("NO_DATA", "", "", "", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-7ece6038 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5643 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d0d032f4 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5644 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-99544a52 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5645 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-83b7cd52 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5655 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-320771fd | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5657 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange2 | (e.Row, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, e.Row, siMain.GetMaxColumnIndex(), … | 그리드 편집 잠금 전환 |  |  |  |
| AC-b1cdae1f | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5659 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-10096bf2 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5745 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b14f2dc0 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5749 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | CALL_EXT | siMain.SetRowFormat | (e.Row, iStartCol, -1, "###,###,###,##0.000") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8838580 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5753 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | CALL_EXT | siMain.SetRowFormat | (e.Row, iStartCol, -1, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-56553564 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5756 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ffee9e15 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5772 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7468aafd | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5779 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e2bee8d | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5788 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72fda03d | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5794 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b14a81b | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5799 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0522ad59 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5805 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8070c405 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5810 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aeb13683 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5815 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7b2be2a | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5820 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a338352 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5825 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bba55cb9 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5830 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-546d7fca | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5841 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | FLAG | dtMeasure | GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteId, cboBucketType… ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-4bcc155d | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5843 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c53b2315 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5844 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-717e9a94 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5845 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3d46e027 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5855 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-77d70b37 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5855 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3cca2d99 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5857 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9c86a0c7 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5858 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-07a16e2f | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5859 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0d21be1d | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5864 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | FLAG | dtSalesBucket | GetLookupValues("SALES_BUCKET", sDivision, sScmSiteId, sIncoterms, "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-52779e78 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5867 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), dtSalesBucket.Rows[0]["BUCKET"].ToString… | 그리드 값 설정 |  |  |  |
| AC-717468c0 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5871 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), "") | 그리드 값 설정 |  |  |  |
| AC-5c1f0272 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5951 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-b0be8dd2 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5953 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c52360e | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:5954 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3e73631 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6026 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strBucket == "" \|\| strBucket == "0000000"… | CALL_EXT | dBucket.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b200563a | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6058 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ for (i < 7) | DATA_OP | dBucket.Add | (i, (strBucket.ToCharArray())[i].ToString() == "1" ? true : false) | 데이터 객체 조작/조회 |  |  |  |
| AC-3163ed98 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6058 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ for (i < 7) | CALL_EXT | strBucket.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c34beeae | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6092 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | CALL_EXT | Math.Truncate | (iWeeklySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49d1963e | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6097 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | CALL_EXT | Math.Truncate | (Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36afb0b2 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6102 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, iCol, data) | 그리드 값 설정 |  |  |  |
| AC-93653c12 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6118 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, data) | 그리드 값 설정 |  |  |  |
| AC-f27e3542 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6128 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, data) | 그리드 값 설정 |  |  |  |
| AC-d01125f8 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6152 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | CALL_EXT | Math.Truncate | (iMonthlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7911540c | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6157 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | CALL_EXT | Math.Truncate | (Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b58984e2 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6162 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, iCol, data) | 그리드 값 설정 |  |  |  |
| AC-7caa6a4a | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6178 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, data) | 그리드 값 설정 |  |  |  |
| AC-4a3d64c7 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6187 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, data) | 그리드 값 설정 |  |  |  |
| AC-774853ab | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6594 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | CALL_EXT | Math.Truncate | (iWeeklyQty / iWeekBucketCnt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bdcfc19 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6613 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, idx, data) | 그리드 값 설정 |  |  |  |
| AC-4d5d78be | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6631 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iLastDayOfWeek, data) | 그리드 값 설정 |  |  |  |
| AC-f03296a6 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6641 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-247ea4e2 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6649 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | DATA_OP | arrTargetDayIdx.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-847edae6 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6669 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, data) | 그리드 값 설정 |  |  |  |
| AC-d3d52cb8 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6678 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-d93819f7 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6728 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, data) | 그리드 값 설정 |  |  |  |
| AC-a60b5804 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:6737 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, data) | 그리드 값 설정 |  |  |  |
| AC-6b92f246 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7222 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | DATA_OP | dtCalendarDetail.Select | ("BASIS_YYYYMMDD = " + "'" + sYYYYMMDD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-01fa9a82 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7226 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | CALL_EXT | Math.Truncate | (iMonthlySum / vMONTH_DAY_CNT) | ⚠ 의미 확인 필요 |  |  |  |
| AC-750d89aa | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7227 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | CALL_EXT | Math.Truncate | (iWeeklyQty / iWeekBucketCnt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4251aec | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7247 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, idx, data) | 그리드 값 설정 |  |  |  |
| AC-ba348b47 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7261 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | DATA_OP | arrTargetDayIdx.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-42383740 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7269 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-bf032064 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7277 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | DATA_OP | arrTargetDayIdx.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-13157da8 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7297 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, data) | 그리드 값 설정 |  |  |  |
| AC-c71cc5c3 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7306 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-3d1160dd | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7324 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | DATA_OP | arrTargetDayIdx.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01dec3ec | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7337 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | CALL_EXT | Math.Truncate | (iRemnant / iWeekBucketCnt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61210011 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7363 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, idx, data) | 그리드 값 설정 |  |  |  |
| AC-2d570f04 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7393 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, data) | 그리드 값 설정 |  |  |  |
| AC-538de367 | dsdm.Changed | DMF0082_FcstNPrice_Mgmt.cs:7594 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sCo… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b45d84e | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7917 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9a4ac574 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7918 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), siMain.GetValue(iStartRow, siMain.GetC… | 그리드 값 설정 |  |  |  |
| AC-eb53608d | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7919 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-67ae5bdb | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7922 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | FLAG | dtMeasure | GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivisionID, sScmSiteID, cboBucketTy… ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-0f8000ec | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7925 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fc21660b | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7926 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-50a481a3 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7927 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtIncotermsType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-591f63fc | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7928 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7093bf5f | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7970 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-83b44553 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7971 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ItemId), siMain.GetValue(iStartRow, siMain.GetColu… | 그리드 값 설정 |  |  |  |
| AC-46855b8c | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7972 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6774fb30 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7979 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-c980309a | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7979 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab423f5c | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7981 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8fb1cc5a | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7982 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c66b2bee | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:7983 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a3b89635 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8001 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-f0407bc3 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8001 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-230368fc | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8003 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-75b00b2c | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8004 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3ce843f3 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8005 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-de3cfa54 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8010 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2b01c2a9 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8011 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), siMain.GetValue(iStartRow, siM… | 그리드 값 설정 |  |  |  |
| AC-20e9a71a | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8012 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3e0658ac | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8027 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | FLAG | dtMeasure | GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivisionID, sScmSiteID, cboBucketTy… ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-c8f642d9 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8029 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5f02f751 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8030 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-12ba91ea | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8031 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-45c85b83 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8036 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-eab69f77 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8037 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.GetValue(iStartRow, siMain.GetCol… | 그리드 값 설정 |  |  |  |
| AC-88bc0fce | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8038 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5465461d | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8046 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d145d77f | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8047 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | GRID_SET | siMain.SetValue | (iRow, iCol, siMain.GetValue(iStartRow, iCol).ToString()) | 그리드 값 설정 |  |  |  |
| AC-27563b81 | this.spdMain.ClipboardPasted | DMF0082_FcstNPrice_Mgmt.cs:8048 | if (range != null && range.Row > -1) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow) ▸ for (iCol < e.CellRange.Column + e.Ce… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aabdef12 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8217 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | FLAG | dtTeamSpr | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-70b7cbbe | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8217 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be06ca75 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8219 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Team), dtTeamSpr) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-612d6e2c | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8230 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | FLAG | dtCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-04c749d7 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8230 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5940a073 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8231 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-57c79638 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8237 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if ((clbDivision.ControlValues.Substring(0, 2) == "40")) | FLAG | dtSalesSite40 | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4d4cbca6 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8237 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if ((clbDivision.ControlValues.Substring(0, 2) == "40")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d56e512d | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8238 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if ((clbDivision.ControlValues.Substring(0, 2) == "40")) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d72e14f5 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8246 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf1fc43b | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8247 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51740d51 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8250 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2) == "81") | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5a33015 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8252 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (sDivision != null && sDivision != "" && sDivision.Substring(0, 2) == … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7433f76f | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8261 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | FLAG | dtMeasure | GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteID, cboBucketType… ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-c52ed412 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8262 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bf0b186f | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8277 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-e9f9790e | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8277 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-819e9e3b | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8280 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9937de1f | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8283 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-26b67ae9 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8283 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-042ace8c | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8284 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-314ff554 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8294 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-20ae2933 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8294 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2cb00bbf | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8295 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ea346d23 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8308 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtMeasure | GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteID, cboBucketType… ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-c76da74b | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8309 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c4706d58 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8312 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtSalesBucket | GetLookupValues("SALES_BUCKET", sDivision, sScmSiteID, sIncoterms, "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-a4421f16 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8315 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), dtSalesBucket.Rows[0]["BUCKET"].ToString… | 그리드 값 설정 |  |  |  |
| AC-0cd7b6a6 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8319 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), "") | 그리드 값 설정 |  |  |  |
| AC-92925d6a | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8332 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtSalesBucket | GetLookupValues("SALES_BUCKET", sDivision, sScmSiteID, sIncoterms, "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-ffd19881 | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8335 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), dtSalesBucket.Rows[0]["BUCKET"].ToString… | 그리드 값 설정 |  |  |  |
| AC-8c0e84eb | this.spdMain.ComboSelChange | DMF0082_FcstNPrice_Mgmt.cs:8339 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), "") | 그리드 값 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f68c36ae | this.spdMain.EditChange | DMF0082_FcstNPrice_Mgmt.cs:8377 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67768fd9 | this.spdMain.EditChange | DMF0082_FcstNPrice_Mgmt.cs:8379 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04ce4717 | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8386 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ca7babf | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8398 |  | FLAG | range | spdMain.Sheets[0].GetSelection(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d077015 | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8398 |  | CALL_EXT | spdMain.Sheets[0].GetSelection | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-26609625 | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8402 | try | UI_PROP | this.Cursor | Cursors.WaitCursor | 속성 Cursor 설정 |  |  |  |
| AC-d5047ea8 | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8408 | try ▸ if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | fps.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f58a0578 | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8410 | try ▸ if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b9c8cba4 | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8416 | try ▸ if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fae30c8b | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8417 | try ▸ if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | fps.ActiveSheet.ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a09152dc | this.spdMain.KeyUp | DMF0082_FcstNPrice_Mgmt.cs:8423 | finally | UI_PROP | this.Cursor | Cursors.Default | 속성 Cursor 설정 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8475c237 | this.spdMain.TopChange | DMF0082_FcstNPrice_Mgmt.cs:8491 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0082_FcstNPrice_Mgmt.ValidationCheck

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I") ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sColName.IndexO…) ▸ if (sDivision == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-750d345e | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | DMF0082_FcstNPrice_Mgmt.cs:7631 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0d4eee1 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | DMF0082_FcstNPrice_Mgmt.cs:7633 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-6255b6f7 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | DMF0082_FcstNPrice_Mgmt.cs:7635 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1d50c07 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0082_SaveSalesFuturePrice_Popup.cs:2763 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0d044cda | this.btnButtonList.UsrButtonList_Click_Detected | DMF0082_SaveSalesFuturePrice_Popup.cs:2766 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.clbDivisions_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5074638 | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2308 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d3e1173 | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2311 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b8832fcd | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2328 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1a98943f | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2351 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c79c8b60 | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2367 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b22b82d | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2367 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8adcfd43 | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2368 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b1f95ecb | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2383 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-42cc80e2 | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2384 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-394427e2 | this.clbDivisions.SelectedIndexChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2388 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a58bb62b | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:498 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-92248748 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:499 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48f6af34 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:500 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85c316ed | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:393 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-dfadaf49 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:396 |  | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2e9ae38e | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:397 |  | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-43cbe5b2 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:402 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-988b69e0 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:405 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-90481233 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:406 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-525d3d35 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:407 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-10ab0269 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:408 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4733b2d2 | Dispose | DMF0082_SaveSalesFuturePrice_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.drpDateTime_Load

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17b3c36d | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2784 |  | UI_PROP | drpDateTime.Value1 | mondayDate2 | 속성 Value1 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.drpDateTime_ValueChange

진입점: this.drpDateTime.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deaf4933 | this.drpDateTime.ValueChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2801 |  | UI_PROP | drpDateTime.Text1 | gMondayDate3 | 속성 Text1 설정 |  |  |  |
| AC-6b72d0fe | this.drpDateTime.ValueChanged | DMF0082_SaveSalesFuturePrice_Popup.cs:2802 |  | UI_PROP | drpDateTime.Text2 | gMondayDate4 | 속성 Text2 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.Dsdm_Changed

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf111d0f | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2450 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74c8e6d4 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2462 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45ad342e | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2463 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db18ac34 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2464 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ed6297b | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2479 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-d3750633 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2480 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c953851d | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2493 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f4ee8fc | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2501 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Sub… | 그리드 값 설정 |  |  |  |
| AC-56e861d9 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2502 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row - i, e.Column, e.Row - i, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72f1de2a | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2507 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-12e39006 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2517 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-172831b6 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2520 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9e77c51 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2549 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-903ab819 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2549 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9756cfc2 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2550 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision.Substring(0, 2) == "81" && e.Column == … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a1e97abc | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2558 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-3dc69c2c | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2558 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f066c13 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2559 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sDivision.Substring(0, 2) == "81" && e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08f161ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:849 | if (this.fps != null) ▸ if (clbDivisions.ControlValues == "40") ▸ if (( siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0) \|\| (siMain.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b03bbbfd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:850 | if (this.fps != null) ▸ if (clbDivisions.ControlValues == "40") ▸ if (( siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0) \|\| (siMain.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f9172fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:880 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if ((siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0abb1310 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:881 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ if (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if ((siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1677fb7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:895 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if (cl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5905a31e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:896 | if (this.fps != null) ▸ else of (clbDivisions.ControlValues == "40") ▸ else of (clbDivisions.ControlValues.Substring(0, 2) == "81") ▸ if (cl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ead2042d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:900 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1336c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:901 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b94f569a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:929 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ if (!siMain.IsLock(si… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f3a28d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:937 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ if (!siMain.IsLock(si… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c93677bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:944 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ▸ else of (!siMain.IsLo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-196160a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:949 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1963ebd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:993 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ae3185f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:995 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), iRow, siMain.GetColumnIndex(DefColumns.D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22b4ed45 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:997 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DEPT_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab99c92a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:999 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a19411a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1001 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-de5b6b9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1003 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-27d2c18e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1005 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc74e7a7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1007 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c18f2df5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1009 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BizType), iRow, siMain.GetColumnIndex(DefColumns.B… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcfaa74f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1011 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a52a147 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1013 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-226253f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1015 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-194e606f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1017 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c94c96e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1019 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e5b4226 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1021 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e626d19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1025 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-659e6a63 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1033 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6adb8917 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1045 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a7f069a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1049 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b963eaca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1067 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6624ddca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1068 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f1c7f6a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1078 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a12af24 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1080 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebee644d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1082 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-94af8284 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1086 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-82de2c55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1088 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc372032 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1090 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba9a77f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1092 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81d8dc0e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1110 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).To… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex("W_" + sLast… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c63f74f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1126 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "KRW") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3deec0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1130 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure.ToUpper() == "KRW") ▸ if (sMeasure.ToUpper() == "USD") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4e6ca90 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1137 | if (this.fps != null) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-39ed7d58 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1138 | if (this.fps != null) ▸ if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol)) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3154f8e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1155 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-57d21dea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1162 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfeca603 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1163 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22637a47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1166 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c5d44df7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1179 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c6bc96d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1180 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9803b684 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1197 | try ▸ if (int.Parse(gMondayDate) > int.Parse(sStartDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00409") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44d8b5ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1198 | try ▸ if (int.Parse(gMondayDate) > int.Parse(sStartDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10842824 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1206 | try ▸ if (dateYmdF.DayOfWeek != DayOfWeek.Monday \|\| dateYmdT.DayOfWeek != DayOfWeek.Monday) | MESSAGE | MessageHelper.GMessageBox | ("MSG00330") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c9f3c21 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1207 | try ▸ if (dateYmdF.DayOfWeek != DayOfWeek.Monday \|\| dateYmdT.DayOfWeek != DayOfWeek.Monday) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e01e6753 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1226 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60a39088 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1227 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfc6d495 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1231 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3d1e22dd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1244 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b4b3ce3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1246 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9952a01e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1250 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP") ⇒ DM.DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-38d1d2ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1252 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-711003d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1254 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0580c566 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1255 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-50296090 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1256 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-d76c5a0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1257 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-98c3c6ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1258 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-6e52b2d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1259 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-42e59d81 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1260 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-549b851d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1261 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c30ec74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1262 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a6a8840f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1263 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-aaaf175c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1264 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ca5bd3ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1265 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-c617c2f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1266 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-10c76453 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1267 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0bec09d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1268 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-ee4a5254 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1269 | try ▸ lambda | DATA_OP | request.Parameters["p_over_range"] | sOverRange | 행/컬럼 값 대입 |  |  |  |
| AC-fa146c59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1270 | try ▸ lambda | DATA_OP | request.Parameters["p_invalid_exec"] | sInvalidExec | 행/컬럼 값 대입 |  |  |  |
| AC-1c73a417 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1272 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba4484c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1274 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8188b2a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1279 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78fd2210 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1289 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5faf4ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1291 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("PriceAll", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3df99d12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1305 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select("", sSortList).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-737676df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1305 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select | ("", sSortList) | 데이터 객체 조작/조회 |  |  |  |
| AC-d86df8d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1306 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Remove | (ds.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b65e96c0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1307 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e0d1fd4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1309 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0c8e9cd5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1310 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98edef3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1315 | try | FLAG | dtCellProdSiteID | GetLookupValues("LOOKUP_COMBO", "SP_CELL_PROD_SITE", "SEGMENT1", "ATTRIBUTE1", "", "") ⇒ DM.UP_FX_GetCommonDataList_DM | 화면 필드/플래그 변경 |  |  |  |
| AC-6af7134e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1324 | try ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.PriceAll), test) | 그리드 값 설정 |  |  |  |
| AC-7a228aa1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1329 | try ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3d0da47f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1334 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-093e1b08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1368 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-10738e2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1369 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-6702d8c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1376 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9c0711c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1384 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-46eccbb1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1389 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c4175fdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1402 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (!sColList.Equals("")) ▸ for (i < result.Length) | GRID_STYLE | siMain.SetBGColor | (iRow, iResultCol, iRow, iResultCol, Color.Pink) | 그리드 표시 설정 |  |  |  |
| AC-8fd70cc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1411 | try ▸ catch ((Exception exi)) | THROW | throw exi; |  | 예외 발생 |  |  |  |
| AC-4fbdf053 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1412 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e00cbf8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1418 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f1f0705 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1423 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-09ba3666 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1424 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-463c7d0c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1433 | try | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbcba87e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1435 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5e91513b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1439 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b53a8a19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1441 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-71b37bec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1445 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-39e1b9e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1450 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-503b16f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:1451 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.fnValidation

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a20906f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2240 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-2057b1ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2243 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8de585f | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:178 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0f21031 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:180 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6fc9459c | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:183 |  | VALUE_SET | clbDivisions.ControlValues | _sDivision | 컨트롤 값 설정 |  |  |  |
| AC-1e416a4d | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:194 |  | UI_PROP | drpDateTime.MinDate1 | mondayDate2 | 속성 MinDate1 설정 |  |  |  |
| AC-5f9bf342 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:198 |  | UI_PROP | drpDateTime.Text1 | sdFromYYYYMMdd | 속성 Text1 설정 |  |  |  |
| AC-439c7b6b | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:202 |  | UI_PROP | drpDateTime.Text2 | sdToYYYYMMdd | 속성 Text2 설정 |  |  |  |
| AC-9f9c072c | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:205 |  | VALUE_SET | clbSalesSite.ControlValues | _sSiteid | 컨트롤 값 설정 |  |  |  |
| AC-ef68512a | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:206 |  | VALUE_SET | umltProject.Text | _sProject | 컨트롤 값 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4952978f | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2108 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetCellIndexBySpanRowCells

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "82" && sNewFlag == CAppSetting.StringY)] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "82" && sNewFlag == CAppSetting.StringY)] / (진입점…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ad3fa64 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:2402 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd4ca69d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0082_SaveSalesFuturePrice_Popup.cs:2403 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetCellNumbersByRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26c9016e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2434 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-833b807b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2439 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97daddb1 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:377 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-28df1edf | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:378 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-015593a7 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:379 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-9c1e6db9 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:381 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b2e323d | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:384 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetExchangeRate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb3d2bd | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2637 | if (sBaseER == sTargetER) | RETURN | return sValue; |  | 처리 중단/반환 |  |  |  |
| AC-4c5b4598 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2640 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sTargetER + "' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-c89afae9 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2644 | if (row.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-ad88f9e1 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2648 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sBaseER + "' AND UNIT_CURRENCY = '" + sTargetER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-7983040c | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2653 | if (row1.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-fe0ee3ea | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2657 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' A… | 데이터 객체 조작/조회 |  |  |  |
| AC-76587cda | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2661 | if (row4.Length > 0) | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' AND YYYYMM = '" + sYYYYMM + "' AND DIVISION_… | 데이터 객체 조작/조회 |  |  |  |
| AC-4dce2ab0 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2666 | if (row4.Length > 0) ▸ if (row5.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-647bd733 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2671 | if (sTargetVal == null) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-3f1a7592 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2673 | else of (sTargetVal == null) | RETURN | return "0"; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetFuturePriceInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc4a26cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:486 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO") ⇒ DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-9bf00bdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:487 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-273c64ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:488 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1b9bf348 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:490 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-202f83d3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:493 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetLookupValues

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9abaf06 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2683 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-319ed005 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2684 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-d5c60802 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2685 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5612bb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2688 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-2ea2b310 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2813 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-1ce90192 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2814 |  | DATA_OP | request.Parameters["CODE"] | p_code | 행/컬럼 값 대입 |  |  |  |
| AC-cd693e9e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2815 |  | DATA_OP | request.Parameters["PARAM1"] | p_param1 | 행/컬럼 값 대입 |  |  |  |
| AC-f2f98668 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2816 |  | DATA_OP | request.Parameters["PARAM2"] | p_param2 | 행/컬럼 값 대입 |  |  |  |
| AC-84fd3e56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2817 |  | DATA_OP | request.Parameters["PARAM3"] | p_param3 | 행/컬럼 값 대입 |  |  |  |
| AC-aaf65d05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2818 |  | DATA_OP | request.Parameters["PARAM4"] | p_param4 | 행/컬럼 값 대입 |  |  |  |
| AC-e7e58cac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2819 |  | DATA_OP | request.Parameters["PARAM5"] | p_param5 | 행/컬럼 값 대입 |  |  |  |
| AC-79586fbc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2820 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e9e062e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0082_SaveSalesFuturePrice_Popup.cs:2822 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetMeasureCountInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24ab0047 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:461 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE") ⇒ DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-629f202e | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:462 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eeba1a60 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:469 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO") ⇒ DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-a2ee9f22 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:470 |  | FLAG | dtMeasureCountAll | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc44f0a4 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:470 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0abab1b | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:474 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetSaveDateFromTo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ad4fb01 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2731 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE") ⇒ DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-a36e888f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2732 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-12426e11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2733 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-16da9706 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2734 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8630e4ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2735 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-eb62101b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2737 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec1a97e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2740 |  | DATA_OP | dsDate.Tables[0].Select("COLUMN_NAME LIKE 'W_2%' ", "").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d587c937 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2740 |  | DATA_OP | dsDate.Tables[0].Select | ("COLUMN_NAME LIKE 'W_2%' ", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-0da11941 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2741 |  | DATA_OP | dsDate.Tables.Remove | (dsDate.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7749e00 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2742 |  | DATA_OP | dsDate.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-09f4e8bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2745 |  | RETURN | return dsDate; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ else of …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d63f2030 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2706 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE") ⇒ DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-935a9f23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2707 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-4087d61d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2709 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-466bd421 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2710 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fd110150 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2711 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivisions.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-86ac15de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2713 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-43fc9373 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2713 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3439c967 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:2716 |  | RETURN | return dsSpdTitle; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.GetWeekData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db7288cb | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:439 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_POPUP_GET_WEEKDATA") ⇒ DM.DMF0082_POPUP_GET_WEEKDATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a105e67f | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:440 |  | DATA_OP | request.Parameters["p_yyyymmdd"] | System.DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a2ad96a2 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:442 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d00150a5 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:445 |  | RETURN | return dsWeek; |  | 처리 중단/반환 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c005e5fa | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:235 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-ca85f87d | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:241 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-99bfa1d6 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:243 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-15dd7272 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:243 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2356f13e | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:245 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d8878160 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:248 |  | VALUE_SET | clbDivisions.ControlValues | _sDivision | 컨트롤 값 설정 |  |  |  |
| AC-10baf1e1 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:253 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf70bda3 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:253 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4193ff46 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:257 |  | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7cee94b2 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:260 |  | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8023514 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:260 |  | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-33c09c23 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec99bf75 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:263 |  | VALUE_SET | clbCustomer.ControlValues | _sEndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-19e5f85c | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:281 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d7513fca | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:313 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d430bee5 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:318 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | umltProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8c7233cf | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:336 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f0cbfec5 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:336 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c6f712b | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:337 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d57cf330 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:344 |  | FLAG | dtItemType | GetLookupValues("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-9ba9758e | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:345 |  | FLAG | dtINCOTERMSType | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-cb70f9c3 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:347 |  | FLAG | dtFcstType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-88f16634 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:348 |  | FLAG | dtDomExp | GetLookupValues("DOM/EXP") | 화면 필드/플래그 변경 |  |  |  |
| AC-63c3fae3 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:355 |  | FLAG | dtMeasureCount | GetMeasureCountInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-a1eaa808 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:357 |  | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-868d52ee | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:361 |  | FLAG | dtWeek | GetWeekData() | 화면 필드/플래그 변경 |  |  |  |
| AC-f624f759 | this.Load | DMF0082_SaveSalesFuturePrice_Popup.cs:369 |  | STATE | clbDivisions.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / this.clbDivisions.SelectedIndexChanged [try] / FindButton [try] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa664912 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:534 | if (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c20c1e92 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:539 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-9029e140 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:540 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-09548a23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:544 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dsTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c2f38e | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:218 |  | FLAG | _sDivision | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-30938fdf | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:219 |  | FLAG | _sFromYYYYMMdd | sFromYYYYMMdd | 화면 필드/플래그 변경 |  |  |  |
| AC-51abdcf8 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:220 |  | FLAG | _sToYYYYMMdd | sToYYYYMMdd | 화면 필드/플래그 변경 |  |  |  |
| AC-547e170a | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:221 |  | FLAG | _sSiteid | sSiteid | 화면 필드/플래그 변경 |  |  |  |
| AC-c27feaab | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:222 |  | FLAG | _sProject | sProject | 화면 필드/플래그 변경 |  |  |  |
| AC-494765d9 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:225 |  | FLAG | _sEndCustomer | sEndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-b5191556 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:227 |  | FLAG | isSaveOK | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d17c5541 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1456 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2d1b355d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1467 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-290c22f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1468 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73b95ed7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1479 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1], j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9ee1132 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1488 | try ▸ if (isEdit==false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea21e5df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1489 | try ▸ if (isEdit==false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32fe089c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1505 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d0e8b10b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1633 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa23dd04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1636 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-848a0741 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1638 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d908357 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1656 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd4b7da5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1657 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09db0aa2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1663 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7d28fd3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1737 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1], iStartCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a65995d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1740 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | siMain.GetColumnTag(j).Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-22ab33f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1763 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], param_active_flag, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8b4f79aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1764 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_division_id"] | CString.AppendStringEx(nvc["p_division_id"], param_division_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-a7aa16fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1765 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_project_code"] | CString.AppendStringEx(nvc["p_project_code"], param_project_code, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-71e06dc5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1766 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_end_customer"] | CString.AppendStringEx(nvc["p_end_customer"], param_end_customer, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-0fa57fc0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1767 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_scm_site_id"] | CString.AppendStringEx(nvc["p_scm_site_id"], param_scm_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f54fecde | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1768 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_item_id"] | CString.AppendStringEx(nvc["p_item_id"], param_item_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-44a42585 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1769 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_dom_exp"] | CString.AppendStringEx(nvc["p_dom_exp"], param_dom_exp, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1c88d674 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1770 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_fcst_type"] | CString.AppendStringEx(nvc["p_fcst_type"], param_fcst_type, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-96516c72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1771 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_incoterms"] | CString.AppendStringEx(nvc["p_incoterms"], param_incoterms, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-a6f8ae44 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1772 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_measure"] | CString.AppendStringEx(nvc["p_measure"], param_measure, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-48d7a756 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1773 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_plant_site_id"] | CString.AppendStringEx(nvc["p_plant_site_id"], param_plant_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-c3ac9540 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1774 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_cell_prod_site_id"] | CString.AppendStringEx(nvc["p_cell_prod_site_id"], param_cell_prod_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b5857011 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1775 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_yyyymmdd"] | CString.AppendStringEx(nvc["p_yyyymmdd"], param_yyyymmdd, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3d475a45 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1776 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_currency"] | CString.AppendStringEx(nvc["p_currency"], param_currency, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3a567734 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1777 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_qty"] | CString.AppendStringEx(nvc["p_qty"], param_qty, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e95c63ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1778 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ fo… | DATA_OP | nvc["p_created_by"] | CString.AppendStringEx(nvc["p_created_by"], param_created_by, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-def5c0ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1969 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-166b3b55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1982 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb27262f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1986 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | ENDPOINT | new FoxDataRequest | ("DM.DMF0082_SAVE_MAIN_DATA") ⇒ DM.DMF0082_SAVE_MAIN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-e67cf079 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1987 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-521f4151 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1990 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-3e8d9cdb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1990 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6dd49bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1992 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-446702db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:1994 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ la… | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-339440ad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2000 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | DATA_OP | ds.Tables[0].Columns.Contains | ("RESULT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4679d959 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2003 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0]["RESULT_CNT"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af9aabd4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2012 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | DATA_OP | ds.Tables[0].Columns.Contains | ("RESULT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cde2a71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2016 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | DATA_OP | ds.Tables[0].Columns.Contains | ("ERR_MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e22b983b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2018 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | MESSAGE | MessageBox.Show | (ds.Tables[0].Rows[0]["ERR_MESSAGE"].ToString()) | 메시지 표시 |  |  |  |
| AC-4c77cd74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2019 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90ff2bc5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2023 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | DATA_OP | ds.Tables[0].Columns.Contains | ("RESULT_MSG") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e535b35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2025 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | MESSAGE | MessageBox.Show | (ds.Tables[0].Rows[0]["RESULT_MSG"].ToString()) | 메시지 표시 |  |  |  |
| AC-ed2038b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2031 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | DATA_OP | ds.Tables[1].Columns.Contains | ("TITLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4970c02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2036 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | POPUP | new DMF0003_SspSyncPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-6deb4d73 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2037 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | CALL_EXT | popup.LoadData | (ds.Tables[1], "40") | ⚠ 의미 확인 필요 |  |  |  |
| AC-abfacce1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2038 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc44f502 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2039 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c403fcfc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2042 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bef00e11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2064 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | isSaveOK | true | 화면 필드/플래그 변경 |  |  |  |
| AC-32672cc5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2065 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9f70a7a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2081 | try ▸ if (dsSaveDate != null && siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cd72c6e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2089 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-16050529 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2093 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-02e4e55b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2095 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.SetExchangeValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfebf1a4 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2577 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6e7b881 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2577 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8f85ca2 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2583 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (sCurrency =… | GRID_SET | siMain.SetText | (iRow, iColumn, "") | 그리드 값 설정 |  |  |  |
| AC-df33b275 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2584 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (sCurrency =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc3e8afb | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2589 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) | GRID_SET | siMain.SetText | (iRow, iColumn, val) | 그리드 값 설정 |  |  |  |
| AC-47ad905d | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2593 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetColor | (iRow, iColumn, iRow, iColumn, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca820092 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2601 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | GRID_SET | siMain.SetText | (iRow - i, iColumn, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Subst… | 그리드 값 설정 |  |  |  |
| AC-dbc87fcc | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2602 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | siMain.SetColor | (iRow - i, iColumn, iRow - i, iColumn, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ff3fed5 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2607 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ if (!string.IsN… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e77906c2 | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2614 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ else of (!strin… | GRID_SET | siMain.SetText | (iRow - i, iColumn, "") | 그리드 값 설정 |  |  |  |
| AC-e63ba1bc | (진입점 미연결) | DMF0082_SaveSalesFuturePrice_Popup.cs:2617 | if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) \|\| (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor)) ▸ else of (!strin… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, iRow - i, "M") | ⚠ 의미 확인 필요 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.SetSpreadColumn

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0)] / SaveButton [try ▸ if (dsSaveDate != null && siMain != null && siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ed78fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:670 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6dd64a9f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:674 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5524e302 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:675 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-6ffb4cbf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:712 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["MMDD"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 1… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8dbbe17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:717 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 120, true, FPHAlign.Right… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0eba5d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:723 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMeasureCol + iWeek, 1, 1, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0760369d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:731 | for (i < dt.Rows.Count) ▸ else of (i == 0) ▸ if (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15114f79 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:737 | for (i < dt.Rows.Count) ▸ else of (i == 0) ▸ else of (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30bf261c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | DMF0082_SaveSalesFuturePrice_Popup.cs:742 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMeasureCol + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].ToString(), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.SetSpreadHeaderSpan

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.clbDivisions.SelectedIndexChanged [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ else of …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9c478e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:590 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-300310bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:598 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e798fe0a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:612 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-747dc251 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:619 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15cbae29 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:628 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a97907a7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:640 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aec44d5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:642 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48618c32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:648 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PriceAll) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b2dcbe4b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DMF0082_SaveSalesFuturePrice_Popup.cs:649 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.usrButton1_Click

진입점: this.usrButton1.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-553febb6 | this.usrButton1.Click 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2261 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c15da099 | this.usrButton1.Click 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2263 | if (clbDivisions.SelectedValue.ToString() != "40") | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a2cf274e | this.usrButton1.Click 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2264 | if (clbDivisions.SelectedValue.ToString() != "40") | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b8067616 | this.usrButton1.Click 외 1 | DMF0082_SaveSalesFuturePrice_Popup.cs:2266 | if (clbDivisions.SelectedValue.ToString() != "40") | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0082_SaveSalesFuturePrice_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52bad638 | this.usrButton2.Click | DMF0082_SaveSalesFuturePrice_Popup.cs:2287 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a8e4b0f5 | this.usrButton2.Click | DMF0082_SaveSalesFuturePrice_Popup.cs:2290 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-aa56ad46 | this.usrButton2.Click | DMF0082_SaveSalesFuturePrice_Popup.cs:2291 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-448dd3a5 | this.usrButton2.Click | DMF0082_SaveSalesFuturePrice_Popup.cs:2292 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d82eae7c | this.usrButton2.Click | DMF0082_SaveSalesFuturePrice_Popup.cs:2294 |  | VALUE_SET | umltItem.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

