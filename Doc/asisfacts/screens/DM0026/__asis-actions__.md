# AS-IS 액션 대조표 — DM0026

> 원천: `Doc/asisfacts/screens/DM0026/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 89행 · 메서드 12 · 종류 GRID_INIT 18 · DATA_OP 11 · UI_PROP 10 · GRID_SET 10 · FLAG 7 · ENDPOINT 7 · UI_MISC 5 · RETURN 5 · COMBO_DATA 4 · LIST_REBIND 4 · MESSAGE 3 · CALL_EXT 1 · THROW 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 1


## DM0026_ESSChannelPSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d095e60 | this.Load | DM0026_ESSChannelPSI.cs:142 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-558d522d | this.Load | DM0026_ESSChannelPSI.cs:143 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-00072739 | this.Load | DM0026_ESSChannelPSI.cs:144 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0026_ESSChannelPSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50538a9e | Dispose | DM0026_ESSChannelPSI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0026_ESSChannelPSI.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87e22d52 | ExcelButton | DM0026_ESSChannelPSI.cs:296 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-3aa2f994 | ExcelButton | DM0026_ESSChannelPSI.cs:297 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-0fbd2dab | ExcelButton | DM0026_ESSChannelPSI.cs:298 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-72747de4 | ExcelButton | DM0026_ESSChannelPSI.cs:299 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-43e8bea2 | ExcelButton | DM0026_ESSChannelPSI.cs:300 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-93f73680 | ExcelButton | DM0026_ESSChannelPSI.cs:301 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-23ae66a8 | ExcelButton | DM0026_ESSChannelPSI.cs:303 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-81e7c971 | ExcelButton | DM0026_ESSChannelPSI.cs:304 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-d69ce372 | ExcelButton | DM0026_ESSChannelPSI.cs:306 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-5669b0f0 | ExcelButton | DM0026_ESSChannelPSI.cs:315 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fee6cfb4 | ExcelButton | DM0026_ESSChannelPSI.cs:320 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f1d8bde7 | ExcelButton | DM0026_ESSChannelPSI.cs:324 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0026_ESSChannelPSI.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa8762ed | FindButton | DM0026_ESSChannelPSI.cs:348 | if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-130196c8 | FindButton | DM0026_ESSChannelPSI.cs:350 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6834fa6 | FindButton | DM0026_ESSChannelPSI.cs:361 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc729b0f | FindButton | DM0026_ESSChannelPSI.cs:362 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d9d2940 | FindButton | DM0026_ESSChannelPSI.cs:367 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4edf077 | FindButton | DM0026_ESSChannelPSI.cs:369 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-cf7dcac1 | FindButton | DM0026_ESSChannelPSI.cs:371 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cd1b69d | FindButton | DM0026_ESSChannelPSI.cs:379 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f92f6e24 | FindButton | DM0026_ESSChannelPSI.cs:383 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0026_GET_ESS_CHANNEL_PSI_DATA") ⇒ DM.DM0026_GET_ESS_CHANNEL_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-19959c72 | FindButton | DM0026_ESSChannelPSI.cs:384 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f0eec00d | FindButton | DM0026_ESSChannelPSI.cs:385 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ece28f6b | FindButton | DM0026_ESSChannelPSI.cs:386 | lambda | DATA_OP | request.Parameters["p_item_id"] | sModel | 행/컬럼 값 대입 |  |  |  |
| AC-985fe6cd | FindButton | DM0026_ESSChannelPSI.cs:387 | lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-af7380e4 | FindButton | DM0026_ESSChannelPSI.cs:388 | lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-2e782d51 | FindButton | DM0026_ESSChannelPSI.cs:389 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b3296190 | FindButton | DM0026_ESSChannelPSI.cs:390 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e167960a | FindButton | DM0026_ESSChannelPSI.cs:392 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-943854d8 | FindButton | DM0026_ESSChannelPSI.cs:399 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-da7458b5 | FindButton | DM0026_ESSChannelPSI.cs:401 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7ff15c78 | FindButton | DM0026_ESSChannelPSI.cs:402 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33635744 | FindButton | DM0026_ESSChannelPSI.cs:403 |  | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-11df847a | FindButton | DM0026_ESSChannelPSI.cs:411 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0026_ESSChannelPSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-294cdfd6 | this.Load | DM0026_ESSChannelPSI.cs:106 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c54a0aaa | this.Load | DM0026_ESSChannelPSI.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0026_ESSChannelPSI.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-413085cd | this.Load | DM0026_ESSChannelPSI.cs:543 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_RESULT_DAY_RANGE") ⇒ DM.PR_GET_RESULT_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-6bf6001d | this.Load | DM0026_ESSChannelPSI.cs:544 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6a3f521f | this.Load | DM0026_ESSChannelPSI.cs:545 |  | DATA_OP | request.Parameters["p_month"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-f6f0f8c2 | this.Load | DM0026_ESSChannelPSI.cs:547 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4c71cb2 | this.Load | DM0026_ESSChannelPSI.cs:550 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0026_ESSChannelPSI.GetSpdTitle

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd6b183f | this.Load 외 1 | DM0026_ESSChannelPSI.cs:528 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0026_GET_SPREAD_TITLE") ⇒ DM.DM0026_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-d0c3558a | this.Load 외 1 | DM0026_ESSChannelPSI.cs:529 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-6a57a496 | this.Load 외 1 | DM0026_ESSChannelPSI.cs:530 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-e5cff7ee | this.Load 외 1 | DM0026_ESSChannelPSI.cs:531 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9c4ad874 | this.Load 외 1 | DM0026_ESSChannelPSI.cs:533 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-809d6955 | this.Load 외 1 | DM0026_ESSChannelPSI.cs:533 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DM0026_ESSChannelPSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f456323 | this.Load | DM0026_ESSChannelPSI.cs:119 |  | FLAG | dtDivision | Data.Common(Data.Type.ESS_DIVISION_ID, false, UserInfoContext.Current["NowGroupID"], UserI… ⇒ biz:CommonData.CommonDataList [code=ESS_DIVISION_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-709848ee | this.Load | DM0026_ESSChannelPSI.cs:119 |  | COMBO_DATA | Data.Common | (Data.Type.ESS_DIVISION_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=ESS_DIVISION_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-403e8dbb | this.Load | DM0026_ESSChannelPSI.cs:120 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1d945768 | this.Load | DM0026_ESSChannelPSI.cs:124 |  | FLAG | dtSalesSite | Data.Common(Data.Type.ESS_SCM_SITE_ID) ⇒ biz:CommonData.CommonDataList [code=ESS_SCM_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-66ccc537 | this.Load | DM0026_ESSChannelPSI.cs:124 |  | COMBO_DATA | Data.Common | (Data.Type.ESS_SCM_SITE_ID) ⇒ biz:CommonData.CommonDataList [code=ESS_SCM_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bebcddf | this.Load | DM0026_ESSChannelPSI.cs:125 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-33c1bedf | this.Load | DM0026_ESSChannelPSI.cs:127 |  | FLAG | dtModel | Data.Common(Data.Type.ESS_ITEM_ID) ⇒ biz:CommonData.CommonDataList [code=ESS_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-e703a97a | this.Load | DM0026_ESSChannelPSI.cs:127 |  | COMBO_DATA | Data.Common | (Data.Type.ESS_ITEM_ID) ⇒ biz:CommonData.CommonDataList [code=ESS_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71551f62 | this.Load | DM0026_ESSChannelPSI.cs:128 |  | LIST_REBIND | clsCtrl.setListBox | (dtModel, clbModel, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c857af17 | this.Load | DM0026_ESSChannelPSI.cs:130 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-0bf8064e | this.Load | DM0026_ESSChannelPSI.cs:132 |  | FLAG | dtBucketType | Data.Common(Data.Type.BucketType) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 화면 필드/플래그 변경 |  |  |  |
| AC-d4071586 | this.Load | DM0026_ESSChannelPSI.cs:132 |  | COMBO_DATA | Data.Common | (Data.Type.BucketType) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31e7be52 | this.Load | DM0026_ESSChannelPSI.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DM0026_ESSChannelPSI.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a4e88f | this.Load 외 1 | DM0026_ESSChannelPSI.cs:152 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0026_ESSChannelPSI.SetSpreadColumn

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [if (dtTitle != null && dtTitle.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cae4d088 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:483 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-37e6b237 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:488 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-babcb379 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:495 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-25e92abe | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:499 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-92b8df09 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:504 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-6363348a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:511 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2a045abf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0026_ESSChannelPSI.cs:515 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0026_ESSChannelPSI.SetSpreadHeaderSpan

진입점: this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [if (dtTitle != null && dtTitle.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8179f3f | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:188 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b89139c3 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:196 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-807cbfcd | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:209 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnLabels.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-4a43ecad | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:228 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aefb9030 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:229 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-315aa60e | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:234 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c158829 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:235 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4572218e | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:242 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb9a8418 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:243 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7340ec4f | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:254 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06b52905 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:255 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7a74e19 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:256 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b96e505d | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:257 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-527ae881 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:259 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d1a76fb0 | this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] 외 1 | DM0026_ESSChannelPSI.cs:260 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0026_ESSChannelPSI.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e9390f9 | this.spdMain.CellDoubleClick | DM0026_ESSChannelPSI.cs:428 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-ccf8ba17 | this.spdMain.CellDoubleClick | DM0026_ESSChannelPSI.cs:443 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |

