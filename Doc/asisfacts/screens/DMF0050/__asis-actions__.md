# AS-IS 액션 대조표 — DMF0050

> 원천: `Doc/asisfacts/screens/DMF0050/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 204행 · 메서드 28 · 종류 FLAG 26 · GRID_INIT 23 · GRID_SET 21 · CALL_EXT 18 · DATA_OP 18 · RETURN 17 · UI_PROP 16 · UI_MISC 11 · POPUP 10 · ENDPOINT 9 · VALUE_SET 7 · MESSAGE 7 · COMBO_DATA 5 · LIST_REBIND 4 · THROW 4 · GRID_STYLE 2 · STATE 2 · VALUE_CLEAR 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 18


## DMF0050_EDIWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b44c2082 | this.btnColumn.Click | DMF0050_EDIWaterfall.cs:851 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-8f5d9a01 | this.btnColumn.Click | DMF0050_EDIWaterfall.cs:852 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0bdb1231 | this.btnColumn.Click | DMF0050_EDIWaterfall.cs:853 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0050_EDIWaterfall.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9c4d2fa | this.btnItemId.Click | DMF0050_EDIWaterfall.cs:1127 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-cf28883c | this.btnItemId.Click | DMF0050_EDIWaterfall.cs:1129 |  | POPUP | popItem.Form_Load | (true, sDivision, null, sEndCustomer, null, null, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6c6347de | this.btnItemId.Click | DMF0050_EDIWaterfall.cs:1130 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0fe38297 | this.btnItemId.Click | DMF0050_EDIWaterfall.cs:1131 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1d6c67de | this.btnItemId.Click | DMF0050_EDIWaterfall.cs:1133 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0050_EDIWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05bc38a2 | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1148 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-60b671ed | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1149 |  | POPUP | popVersion.Form_Load | (true, "EC", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8eb7d11a | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1150 |  | CALL_EXT | popVersion.dayChecked | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-804864f6 | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1151 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0613c0a9 | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1152 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-daf2f48a | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1156 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-20b3bfcb | this.btnVersion.Click 외 1 | DMF0050_EDIWaterfall.cs:1157 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0050_EDIWaterfall.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-819fa4d6 | this.cboBucketType.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:739 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## DMF0050_EDIWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be575600 | this.clbCustomer.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:1114 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-881b2f2b | this.clbCustomer.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:1116 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.ClbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b17afd1 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:688 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-da299efe | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:695 | try ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString()… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ff4ae9e1 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:695 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString(), all /* Te… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7955cd4d | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:700 | try ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4a0b6c28 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:700 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, all /* … | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-91363d58 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:705 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-435f2228 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:710 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f46e8db3 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:718 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-60fc2973 | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:719 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b492d10b | this.clbDivision.SelectedIndexChanged | DMF0050_EDIWaterfall.cs:723 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0050_EDIWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92c142b3 | this.Load | DMF0050_EDIWaterfall.cs:261 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-05e53ef9 | this.Load | DMF0050_EDIWaterfall.cs:262 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-86ac3ea0 | this.Load | DMF0050_EDIWaterfall.cs:263 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0050_EDIWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f37fc68 | this.Load | DMF0050_EDIWaterfall.cs:248 |  | UI_PROP | usrConditionPanel1.Height | 85 | 속성 Height 설정 |  |  |  |
| AC-73cfaa68 | this.Load | DMF0050_EDIWaterfall.cs:249 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-1d136155 | this.Load | DMF0050_EDIWaterfall.cs:252 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-204f12e2 | this.Load | DMF0050_EDIWaterfall.cs:253 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DMF0050_EDIWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a69adbd | Dispose | DMF0050_EDIWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0050_EDIWaterfall.DM0050_EDIWaterfall_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac6a52c3 | this.FormClosed | DMF0050_EDIWaterfall.cs:1165 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-541e9f1e | this.FormClosed | DMF0050_EDIWaterfall.cs:1167 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00f49ee0 | this.FormClosed | DMF0050_EDIWaterfall.cs:1168 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ee3db89 | this.FormClosed | DMF0050_EDIWaterfall.cs:1169 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0050_EDIWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f100953c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0050_EDIWaterfall.cs:376 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0a94eaa1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0050_EDIWaterfall.cs:377 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4281f50b | ExcelButton | DMF0050_EDIWaterfall.cs:391 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-f8d153aa | ExcelButton | DMF0050_EDIWaterfall.cs:392 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-0721d440 | ExcelButton | DMF0050_EDIWaterfall.cs:393 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-06a0e2c7 | ExcelButton | DMF0050_EDIWaterfall.cs:394 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-279fc19f | ExcelButton | DMF0050_EDIWaterfall.cs:395 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-e32dd5ed | ExcelButton | DMF0050_EDIWaterfall.cs:396 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-1d920100 | ExcelButton | DMF0050_EDIWaterfall.cs:398 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-ca08585c | ExcelButton | DMF0050_EDIWaterfall.cs:399 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-9670c893 | ExcelButton | DMF0050_EDIWaterfall.cs:401 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-368dd088 | ExcelButton | DMF0050_EDIWaterfall.cs:406 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e6f2857 | ExcelButton | DMF0050_EDIWaterfall.cs:411 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-23f865b8 | ExcelButton | DMF0050_EDIWaterfall.cs:415 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0050_EDIWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37efd7eb | FindButton | DMF0050_EDIWaterfall.cs:428 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d325d4d2 | FindButton | DMF0050_EDIWaterfall.cs:435 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-091904bb | FindButton | DMF0050_EDIWaterfall.cs:436 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-905986da | FindButton | DMF0050_EDIWaterfall.cs:439 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cd7cae31 | FindButton | DMF0050_EDIWaterfall.cs:441 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-80cd69aa | FindButton | DMF0050_EDIWaterfall.cs:441 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aab386d2 | FindButton | DMF0050_EDIWaterfall.cs:451 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5c8da67 | FindButton | DMF0050_EDIWaterfall.cs:452 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c95023f5 | FindButton | DMF0050_EDIWaterfall.cs:458 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e47a6ed | FindButton | DMF0050_EDIWaterfall.cs:460 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-0b132beb | FindButton | DMF0050_EDIWaterfall.cs:462 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8fb8b13 | FindButton | DMF0050_EDIWaterfall.cs:466 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b71a5d5 | FindButton | DMF0050_EDIWaterfall.cs:468 | try | CALL_EXT | Convert.ToInt32(sEndDate).CompareTo | (Convert.ToInt32(sNowDate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d43c797d | FindButton | DMF0050_EDIWaterfall.cs:481 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3889311 | FindButton | DMF0050_EDIWaterfall.cs:482 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28f55890 | FindButton | DMF0050_EDIWaterfall.cs:486 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e6fc0407 | FindButton | DMF0050_EDIWaterfall.cs:496 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d1e638d5 | FindButton | DMF0050_EDIWaterfall.cs:498 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e951926 | FindButton | DMF0050_EDIWaterfall.cs:503 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0050_GET_EDI_WATERFALL") ⇒ DM.DMF0050_GET_EDI_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-2e9b3620 | FindButton | DMF0050_EDIWaterfall.cs:505 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6ae264c2 | FindButton | DMF0050_EDIWaterfall.cs:507 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e5e7f6c | FindButton | DMF0050_EDIWaterfall.cs:508 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-9e56a49e | FindButton | DMF0050_EDIWaterfall.cs:509 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-18373967 | FindButton | DMF0050_EDIWaterfall.cs:510 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-50ca0bec | FindButton | DMF0050_EDIWaterfall.cs:512 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-6a956b32 | FindButton | DMF0050_EDIWaterfall.cs:513 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-090f727e | FindButton | DMF0050_EDIWaterfall.cs:514 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-10694aa7 | FindButton | DMF0050_EDIWaterfall.cs:515 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-6c2d0a6a | FindButton | DMF0050_EDIWaterfall.cs:517 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c2e5447 | FindButton | DMF0050_EDIWaterfall.cs:519 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9778fd3f | FindButton | DMF0050_EDIWaterfall.cs:524 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a632ab4d | FindButton | DMF0050_EDIWaterfall.cs:530 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["BACK_ORDER"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a5e437e | FindButton | DMF0050_EDIWaterfall.cs:533 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["BACK_ORDER"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-40aaa756 | FindButton | DMF0050_EDIWaterfall.cs:535 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["BACK_ORDER"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-32dc4d7e | FindButton | DMF0050_EDIWaterfall.cs:536 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["BACK_ORDER"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c4f5f18 | FindButton | DMF0050_EDIWaterfall.cs:539 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["BACK_ORDER"].ToString() != "") ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-b9857eba | FindButton | DMF0050_EDIWaterfall.cs:543 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c6c4bdc | FindButton | DMF0050_EDIWaterfall.cs:556 | try ▸ try ▸ if (siMain.GetMaxRowIndex() > 0 && ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bc0a25ec | FindButton | DMF0050_EDIWaterfall.cs:562 | try ▸ try ▸ if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5de14807 | FindButton | DMF0050_EDIWaterfall.cs:594 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | calendar.GetWeekOfYear | (referenceDate, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b8fd86d | FindButton | DMF0050_EDIWaterfall.cs:619 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-0d63a377 | FindButton | DMF0050_EDIWaterfall.cs:624 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) ▸ if (siMain.GetCo… | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-c821aaaa | FindButton | DMF0050_EDIWaterfall.cs:636 | try ▸ catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBoxForException | (e) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-26c76048 | FindButton | DMF0050_EDIWaterfall.cs:644 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5f71178c | FindButton | DMF0050_EDIWaterfall.cs:645 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-191eccd1 | FindButton | DMF0050_EDIWaterfall.cs:655 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d195b45 | FindButton | DMF0050_EDIWaterfall.cs:661 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e01e489c | FindButton | DMF0050_EDIWaterfall.cs:668 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1268d168 | FindButton | DMF0050_EDIWaterfall.cs:674 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5901127c | FindButton | DMF0050_EDIWaterfall.cs:675 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0dc86711 | FindButton | DMF0050_EDIWaterfall.cs:676 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0050_EDIWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d3d18de | this.Load | DMF0050_EDIWaterfall.cs:176 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ce779e8 | this.Load | DMF0050_EDIWaterfall.cs:178 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0050_EDIWaterfall.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7063bd0 | this.Load [try] | DMF0050_EDIWaterfall.cs:1064 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b0dbb29e | this.Load [try] | DMF0050_EDIWaterfall.cs:1065 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8cf7f7d | this.Load [try] | DMF0050_EDIWaterfall.cs:1068 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba2fcac | this.Load [try] | DMF0050_EDIWaterfall.cs:1028 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-843a58b5 | this.Load [try] | DMF0050_EDIWaterfall.cs:1029 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e799815b | this.Load [try] | DMF0050_EDIWaterfall.cs:1030 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-a8036b83 | this.Load [try] | DMF0050_EDIWaterfall.cs:1032 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5164919 | this.Load [try] | DMF0050_EDIWaterfall.cs:1035 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.GetLastWeekSunDayByDate

진입점: FindButton [try ▸ try ▸ if (chkMem.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-756de2a2 | FindButton [try ▸ try ▸ if (chkMem.Checked == true)] | DMF0050_EDIWaterfall.cs:1107 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToSt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb4e962e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1041 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-28f75991 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1045 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0050_GET_SPREAD_TITLE") ⇒ DM.DMF0050_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-5dd85ca1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1046 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-f209fbaa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1047 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-936ebaef | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1048 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-94bf9b97 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1049 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-f70831bf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1050 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-d3f03008 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1052 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2fd22884 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1052 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0f4ab40 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:1055 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdf1f4ef | FindButton [try] | DMF0050_EDIWaterfall.cs:1087 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e557554c | this.Load | DMF0050_EDIWaterfall.cs:194 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae96d30 | this.Load | DMF0050_EDIWaterfall.cs:197 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c8a6206c | this.Load | DMF0050_EDIWaterfall.cs:198 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fdd16629 | this.Load | DMF0050_EDIWaterfall.cs:200 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-c479b1ff | this.Load | DMF0050_EDIWaterfall.cs:204 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e509dc2f | this.Load | DMF0050_EDIWaterfall.cs:204 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f212fbe6 | this.Load | DMF0050_EDIWaterfall.cs:205 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3ebc8e92 | this.Load | DMF0050_EDIWaterfall.cs:210 | try ▸ if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString()… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-5e33241f | this.Load | DMF0050_EDIWaterfall.cs:210 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString(), all /* Te… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2b43622 | this.Load | DMF0050_EDIWaterfall.cs:213 | try ▸ else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4367c52d | this.Load | DMF0050_EDIWaterfall.cs:213 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9fc65c5d | this.Load | DMF0050_EDIWaterfall.cs:216 | try | VALUE_SET | chkMem.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-c24dece7 | this.Load | DMF0050_EDIWaterfall.cs:218 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0cc4a169 | this.Load | DMF0050_EDIWaterfall.cs:223 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0aadb1db | this.Load | DMF0050_EDIWaterfall.cs:224 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e79d342f | this.Load | DMF0050_EDIWaterfall.cs:230 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a11c122 | this.Load | DMF0050_EDIWaterfall.cs:236 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-4737c46d | this.Load | DMF0050_EDIWaterfall.cs:240 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3108da5b | this.Load | DMF0050_EDIWaterfall.cs:241 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0050_EDIWaterfall.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0a05a32 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:272 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0fd68ea3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:278 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ce66b2b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:283 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-5af0c87f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:284 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c490968d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:288 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-36eb97d4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:292 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ … | STATE | chkSum.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a7c3ac1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:293 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ … | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-e2f97524 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:299 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ … | STATE | chkSum.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-23bfbb46 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:312 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-a778dda2 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:316 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0050_EDIWaterfall.InitSpreadFooterSum

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToSt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c229bac0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:323 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-285d7b9b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:324 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-556787e1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:330 |  | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iStCol-1, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-52c18136 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:331 |  | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iStCol - 1, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-474ef955 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:332 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iStCol - 1].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-79dea9f5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:333 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iStCol - 1].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-c93db37a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:339 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1347d556 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:340 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9bbf475 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:341 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-38b0f8ae | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:342 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0050_EDIWaterfall.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.clbDivision.SelectedIndexChanged [try ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("y…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b12b43f5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:997 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-31d6df3c | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:1000 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c43e38ff | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:1005 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2e61181b | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:1007 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-eb86c08c | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:1010 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-715cc4e0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:1015 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0f64d521 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DMF0050_EDIWaterfall.cs:1017 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0050_EDIWaterfall.SetSpreadHeader

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ if (cboBucketType.ControlV…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c304010 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:885 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt < iStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3dcb66e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:893 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iStartCol, 0, iStartCol].Text | sLargeLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-e95faab5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:894 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, iStartCol, 1, iStartCol].Text | sSmallLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-36124cf0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:895 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, iStartCol, 2, iStartCol].Text | "SUM" | 그리드 속성/값 설정 |  |  |  |
| AC-fbe3d527 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:899 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.BACK_ORDER) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af422983 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:900 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0050_EDIWaterfall.SetSpreadHeaderSpan

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ else of (cboBucketTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f82814c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:928 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cf27c42 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:936 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-260cd5b2 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:946 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d895b75d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:952 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43bb588a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:953 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7888256 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:958 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8d879b7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:959 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b806be3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:966 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cb8475f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:967 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa8fb636 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:978 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ad5a5a0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:979 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb7e5f84 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:980 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-459cec47 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:981 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cc1021a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:983 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.BACK_ORDER) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-96626413 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0050_EDIWaterfall.cs:985 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0050_EDIWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a49371 | this.spdMain.CellDoubleClick | DMF0050_EDIWaterfall.cs:784 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-50f4570a | this.spdMain.CellDoubleClick | DMF0050_EDIWaterfall.cs:790 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-b712cb3b | this.spdMain.CellDoubleClick | DMF0050_EDIWaterfall.cs:796 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-cfd40865 | this.spdMain.CellDoubleClick | DMF0050_EDIWaterfall.cs:813 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-d7ed3d16 | this.spdMain.CellDoubleClick | DMF0050_EDIWaterfall.cs:824 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0050_EDIWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bea025a | this.spdMain.KeyUp | DMF0050_EDIWaterfall.cs:837 | if (siMain.GetColumnIndex(DefColumns.BACK_ORDER) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb564a09 | this.spdMain.KeyUp | DMF0050_EDIWaterfall.cs:840 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b904682f | this.spdMain.KeyUp | DMF0050_EDIWaterfall.cs:844 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a00665a | this.spdMain.KeyUp | DMF0050_EDIWaterfall.cs:845 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0050_EDIWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff428c99 | this.spdMain.TopChange | DMF0050_EDIWaterfall.cs:831 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

