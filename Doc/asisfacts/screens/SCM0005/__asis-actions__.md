# AS-IS 액션 대조표 — SCM0005

> 원천: `Doc/asisfacts/screens/SCM0005/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 390행 · 메서드 43 · 종류 DATA_OP 78 · GRID_INIT 71 · UI_PROP 33 · ENDPOINT 32 · FLAG 23 · RETURN 23 · GRID_SET 21 · GRID_LOCK 20 · CALL_EXT 17 · VALUE_SET 16 · GRID_COMBO 11 · POPUP 10 · UI_MISC 8 · COMBO_DATA 7 · GRID_BIND 7 · THROW 5 · LIST_REBIND 3 · MESSAGE 3 · GRID_STYLE 1 · LIST_BIND 1 · ⚠ 의미 확인 필요 17


## SCM0005_DynamicQueryList.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74f9af9a | this.Load | SCM0005_DynamicQueryList.cs:174 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7cf11d5e | this.Load | SCM0005_DynamicQueryList.cs:176 |  | GRID_INIT | this.AddSheet | (fpResult, SpdSheet.shtResult, SpdSheet.shtResult, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8fe86fd3 | this.Load | SCM0005_DynamicQueryList.cs:177 |  | GRID_INIT | this.AddSheet | (fpWhere, SpdSheet.shtWhere, SpdSheet.shtWhere, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d7c09be | this.Load | SCM0005_DynamicQueryList.cs:178 |  | GRID_INIT | this.AddSheet | (fpGroup, SpdSheet.shtGroup, SpdSheet.shtGroup, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b4748f8c | this.Load | SCM0005_DynamicQueryList.cs:181 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-481d80a8 | this.Load | SCM0005_DynamicQueryList.cs:183 |  | FLAG | siResult | GetSheetInfo(fpResult.Name, fpResult.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb3cb818 | this.Load | SCM0005_DynamicQueryList.cs:184 |  | FLAG | siWhere | GetSheetInfo(fpWhere.Name, fpWhere.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7cc2683a | this.Load | SCM0005_DynamicQueryList.cs:185 |  | FLAG | siGRoup | GetSheetInfo(fpGroup.Name, fpGroup.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b058292f | this.Load | SCM0005_DynamicQueryList.cs:187 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3394f7f | this.Load | SCM0005_DynamicQueryList.cs:198 |  | FLAG | dsdmWhere | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siWhere.Sheet(SpdSheet.shtWhere).Models.D… | 화면 필드/플래그 변경 |  |  |  |
| AC-2e4df670 | this.Load | SCM0005_DynamicQueryList.cs:202 |  | FLAG | dsdmGroup | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siGRoup.Sheet(SpdSheet.shtGroup).Models.D… | 화면 필드/플래그 변경 |  |  |  |

## SCM0005_DynamicQueryList.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4344c351 | this.Load | SCM0005_DynamicQueryList.cs:159 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd20bb12 | this.Load | SCM0005_DynamicQueryList.cs:159 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0ed0c9cd | this.Load | SCM0005_DynamicQueryList.cs:161 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9369a746 | this.Load | SCM0005_DynamicQueryList.cs:161 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "ALL", "ALL") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCM0005_DynamicQueryList.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3051764d | DeleteButton | SCM0005_DynamicQueryList.cs:298 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0005_DynamicQueryList.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2691f18 | Dispose | SCM0005_DynamicQueryList.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0005_DynamicQueryList.DsdmGroup_Changed

진입점: dsdmGroup.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-636159a4 | dsdmGroup.Changed | SCM0005_DynamicQueryList.cs:1181 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcc1e98e | dsdmGroup.Changed | SCM0005_DynamicQueryList.cs:1201 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCM0005_DynamicQueryList.DsdmWhere_Changed

진입점: dsdmWhere.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f965076 | dsdmWhere.Changed | SCM0005_DynamicQueryList.cs:1140 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-945b9230 | dsdmWhere.Changed | SCM0005_DynamicQueryList.cs:1160 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCM0005_DynamicQueryList.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a39b8dc | EditButton | SCM0005_DynamicQueryList.cs:307 | if (tabQuery.SelectedIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ace2ef81 | EditButton | SCM0005_DynamicQueryList.cs:308 | if (tabQuery.SelectedIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3f7418cb | EditButton | SCM0005_DynamicQueryList.cs:310 | if (tabQuery.SelectedIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ROLE), siMain.GetColumnIndex(DefColumns.ROLE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfa6c832 | EditButton | SCM0005_DynamicQueryList.cs:311 | if (tabQuery.SelectedIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.ADMIN_ONLY… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0005_DynamicQueryList.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb5b62ce | FindButton 외 1 | SCM0005_DynamicQueryList.cs:330 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-95dbb295 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:335 | if (tabQuery.SelectedIndex == 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2f60941f | FindButton 외 1 | SCM0005_DynamicQueryList.cs:340 | if (tabQuery.SelectedIndex == 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f83ddff2 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:342 | if (tabQuery.SelectedIndex == 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2aa3bd6 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:346 | if (tabQuery.SelectedIndex == 0) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-786a1132 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:347 | if (tabQuery.SelectedIndex == 0) ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bef10b42 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:348 | if (tabQuery.SelectedIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_dq_id"] | txtDescription.Text | 행/컬럼 값 대입 |  |  |  |
| AC-825e15f3 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:349 | if (tabQuery.SelectedIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_dq_name"] | umltReportName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3c9f5f78 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:350 | if (tabQuery.SelectedIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_role"] | clbRole.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0c210dd6 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:351 | if (tabQuery.SelectedIndex == 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5cca0625 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:353 | if (tabQuery.SelectedIndex == 0) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4213dbd4 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:357 | if (tabQuery.SelectedIndex == 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-408798b2 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:358 | if (tabQuery.SelectedIndex == 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd144d1d | FindButton 외 1 | SCM0005_DynamicQueryList.cs:366 | if (tabQuery.SelectedIndex == 0) ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-47caebc8 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:367 | if (tabQuery.SelectedIndex == 0) ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-50b8e2d6 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:370 | if (tabQuery.SelectedIndex == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4db9cd24 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:376 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ if (siMain.ActiveRowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31b71735 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:380 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9f070ada | FindButton 외 1 | SCM0005_DynamicQueryList.cs:389 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | ENDPOINT | clsQuerys.GetDatatableFromSpread | (siGRoup) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-93933995 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:390 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | UI_PROP | dtGroup.DefaultView.Sort | "SEQNO ASC" | 속성 Sort 설정 |  |  |  |
| AC-e3920e6a | FindButton 외 1 | SCM0005_DynamicQueryList.cs:391 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | DATA_OP | dtGroup.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e13d3a9 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:392 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | DATA_OP | dtGroup.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e1ffa0f | FindButton 외 1 | SCM0005_DynamicQueryList.cs:437 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ for (i <= siWhere.GetMaxRowIndex()) ▸ if (sWhereValue.Index… | DATA_OP | nvcParameter[sWhereValue] | siWhere.GetValue(i, siWhere.GetColumnIndex(WhereColumns.VALUE)).ToString().Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-897e446e | FindButton 외 1 | SCM0005_DynamicQueryList.cs:499 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a261eed6 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:501 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54d95659 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:505 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2") ⇒ DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | 엔드포인트 요청 생성 |  |  |  |
| AC-d91e25d5 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:506 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5f813854 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:507 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | DATA_OP | request.Parameters["v_sql_text"] | Substitute(sFinalSql) | 행/컬럼 값 대입 |  |  |  |
| AC-5e636935 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:509 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5254b2c4 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:511 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a7a6cbef | FindButton 외 1 | SCM0005_DynamicQueryList.cs:521 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-86104c99 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:523 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-566ee6cb | FindButton 외 1 | SCM0005_DynamicQueryList.cs:527 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ADM_DQ_EXECUTE_HIST") ⇒ DM_H.PR_DM_ADM_DQ_EXECUTE_HIST | 엔드포인트 요청 생성 |  |  |  |
| AC-881e5274 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:528 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-85125a59 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:529 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | DATA_OP | request.Parameters["p_DQ_ID"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9e443178 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:530 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | DATA_OP | request.Parameters["p_DQ_TEXT"] | Substitute(sFinalSql) | 행/컬럼 값 대입 |  |  |  |
| AC-bb5440e4 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:531 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | DATA_OP | request.Parameters["p_CREATED_BY"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-71d8df5a | FindButton 외 1 | SCM0005_DynamicQueryList.cs:532 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | System.DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-0ab609af | FindButton 외 1 | SCM0005_DynamicQueryList.cs:534 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-569402f2 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:535 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b5b99a30 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:541 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | VALUE_SET | rtxtSQL.Text | sFinalSql | 컨트롤 값 설정 |  |  |  |
| AC-24b7d437 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:543 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | GRID_INIT | siResult.InitSheet | (siResult.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7a592a3c | FindButton 외 1 | SCM0005_DynamicQueryList.cs:544 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | GRID_INIT | siResult.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9c95626 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:545 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | LIST_BIND | siResult.SpreadObject.DataSource | ds | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ddadb388 | FindButton 외 1 | SCM0005_DynamicQueryList.cs:587 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try | CALL_EXT | CUIControl.SetPreferredWidth | (siResult.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e84ad4c | FindButton 외 1 | SCM0005_DynamicQueryList.cs:594 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-cc5a068c | FindButton 외 1 | SCM0005_DynamicQueryList.cs:599 | else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCM0005_DynamicQueryList.FindData_Result

진입점: FindButton [else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (blnInsert) ▸ else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f514c6de | FindButton [else of (tabQuery.SelectedIndex == 0) ▸ if (tabQ… 외 1 | SCM0005_DynamicQueryList.cs:682 | if (sFinalSql.ToUpper().IndexOf("@PARAM")!= -1) ▸ if (strTemp.Length > 1) | DATA_OP | Array.Sort | (sParams) | 데이터 객체 조작/조회 |  |  |  |
| AC-7043d2d8 | FindButton [else of (tabQuery.SelectedIndex == 0) ▸ if (tabQ… 외 1 | SCM0005_DynamicQueryList.cs:684 | if (sFinalSql.ToUpper().IndexOf("@PARAM")!= -1) ▸ if (strTemp.Length > 1) | CALL_EXT | clsQuerys.RemoveDuplicateValue | (sParams) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c27e630 | FindButton [else of (tabQuery.SelectedIndex == 0) ▸ if (tabQ… 외 1 | SCM0005_DynamicQueryList.cs:697 |  | RETURN | return sFinalSql; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryList.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15fd31ac | this.Load | SCM0005_DynamicQueryList.cs:134 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b6ede9 | this.Load | SCM0005_DynamicQueryList.cs:136 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0005_DynamicQueryList.GroupData

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa6e3d8e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:612 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | 엔드포인트 요청 생성 |  |  |  |
| AC-ca4dab21 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:613 |  | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-99896415 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:614 |  | DATA_OP | request.Parameters["p_dq_id"] | dq_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ef3361b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:615 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a4fef8d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:617 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryList.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f11ed3c | this.Load | SCM0005_DynamicQueryList.cs:147 |  | FLAG | dtRole | clsQuerys.GetCommonDataByDB("ROLES") | 화면 필드/플래그 변경 |  |  |  |
| AC-04b4a3f9 | this.Load | SCM0005_DynamicQueryList.cs:147 |  | COMBO_DATA | clsQuerys.GetCommonDataByDB | ("ROLES") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4c50a4d2 | this.Load | SCM0005_DynamicQueryList.cs:148 |  | LIST_REBIND | clsCtrl.setListBox | (dtRole, clbRole, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-356689ab | this.Load | SCM0005_DynamicQueryList.cs:150 |  | LIST_REBIND | clsCtrl.setListBox | (dtRole, clbRoleResult, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0005_DynamicQueryList.InitSpread_Group

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f02d9496 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:249 |  | GRID_INIT | siGRoup.InitSheet | (siGRoup.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-024aa302 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:251 |  | GRID_INIT | siGRoup.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da7273d0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:252 |  | GRID_INIT | siGRoup.AddTextColumn | ("Column", GroupColumns.NAME, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c46e6ce5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:253 |  | GRID_INIT | siGRoup.AddTextColumn | ("Type", GroupColumns.TYPE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8ec0de3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:254 |  | GRID_INIT | siGRoup.AddComboColumn | ("Vaild", GroupColumns.VALID, FPMerge.None, 80, false, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d868f54d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:256 |  | GRID_INIT | siGRoup.AddTextColumn | ("AGGREGATE", GroupColumns.AGGREGATE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b330c70f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:257 |  | GRID_INIT | siGRoup.AddNumColumn | ("SEQNO", GroupColumns.SEQNO, FPMerge.None, 80, true, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26634cab | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:258 |  | GRID_INIT | siGRoup.AddComboColumn | ("USE", GroupColumns.USE, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e957ac9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:260 |  | GRID_INIT | siGRoup.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-320ef574 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:261 |  | GRID_INIT | siGRoup.ColumnHeaderSpan | (0, 1, 1, 6, 25, "Column", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0005_DynamicQueryList.InitSpread_Register

진입점: this.Load / FindButton [if (tabQuery.SelectedIndex == 0)] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (blnInsert) ▸ if (tabQuery.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e6739e9 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:208 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9977e8a1 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:210 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a1013eef | this.Load 외 2 | SCM0005_DynamicQueryList.cs:211 |  | GRID_INIT | siMain.AddTextColumn | ("Report Name", DefColumns.DQ_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0dca7ca3 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:212 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.DESC, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8414dd2c | this.Load 외 2 | SCM0005_DynamicQueryList.cs:213 |  | GRID_INIT | siMain.AddTextColumn | ("Role", DefColumns.ROLE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1513bf7 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:214 |  | GRID_INIT | siMain.AddComboColumn | ("Valid", DefColumns.VALID_YN, FPMerge.None, 120, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d095e96c | this.Load 외 2 | SCM0005_DynamicQueryList.cs:216 |  | GRID_INIT | siMain.AddTextColumn | ("Created By", DefColumns.CREATED_BY, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-209db696 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:217 |  | GRID_INIT | siMain.AddTextColumn | ("Created Date", DefColumns.CREATION_DATE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b1ed76e | this.Load 외 2 | SCM0005_DynamicQueryList.cs:218 |  | GRID_INIT | siMain.AddTextColumn | ("Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d9ae025b | this.Load 외 2 | SCM0005_DynamicQueryList.cs:219 |  | GRID_INIT | siMain.AddTextColumn | ("Updated Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76285bed | this.Load 외 2 | SCM0005_DynamicQueryList.cs:220 |  | GRID_INIT | siMain.AddTextColumn | ("DQ_ID", DefColumns.DQ_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf7ee142 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:221 |  | GRID_INIT | siMain.AddTextColumn | ("DIVISION_ID", DefColumns.DIVISION_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cc20d9d | this.Load 외 2 | SCM0005_DynamicQueryList.cs:222 |  | GRID_INIT | siMain.AddTextColumn | ("QUERY", DefColumns.QUERY, FPMerge.None, 0, true, FPHAlign.Left, FPVAlign.Top, true, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-535e527e | this.Load 외 2 | SCM0005_DynamicQueryList.cs:223 |  | GRID_INIT | siMain.AddComboColumn | ("Admin", DefColumns.ADMIN_ONLY_YN, FPMerge.None, 0, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-892e973c | this.Load 외 2 | SCM0005_DynamicQueryList.cs:225 |  | GRID_INIT | siMain.AddTextColumn | ("ROLE_ID", DefColumns.ROLE_ID, FPMerge.None, 0, true, FPHAlign.Left, FPVAlign.Top, true, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d73606b1 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:226 |  | GRID_INIT | siMain.AddTextColumn | ("COMUMNS", DefColumns.COMUMNS, FPMerge.None, 0, true, FPHAlign.Left, FPVAlign.Top, true, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe47ec23 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:227 |  | GRID_INIT | siMain.AddTextColumn | ("PARAMETERS", DefColumns.PARAMETERS, FPMerge.None, 0, true, FPHAlign.Left, FPVAlign.Top, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6e2fe35 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:228 |  | GRID_INIT | siMain.AddTextColumn | ("POPUPFLAG", DefColumns.POPUPFLAG, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36ee7d41 | this.Load 외 2 | SCM0005_DynamicQueryList.cs:230 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0005_DynamicQueryList.InitSpread_Result

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f450c924 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:235 |  | GRID_INIT | siResult.InitSheet | (siResult.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2bf01f6f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:237 |  | GRID_INIT | siResult.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b60af37 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:239 |  | GRID_INIT | siResult.AddTextColumn | ("Col1", "Col1", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5cfe6aa | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:240 |  | GRID_INIT | siResult.AddTextColumn | ("Col2", "Col2", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abe973d8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:241 |  | GRID_INIT | siResult.AddTextColumn | ("Col3", "Col3", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67d94345 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:242 |  | GRID_INIT | siResult.AddTextColumn | ("Col4", "Col4", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c38e22c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:243 |  | GRID_INIT | siResult.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0005_DynamicQueryList.InitSpread_Where

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dee90d1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:265 |  | GRID_INIT | siWhere.InitSheet | (siWhere.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6105fc17 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:267 |  | GRID_INIT | siWhere.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7a81aa50 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:268 |  | GRID_INIT | siWhere.AddComboColumn | ("Type", WhereColumns.TYPE, FPMerge.None, 80, true, dtDataType, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f75160ae | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:269 |  | GRID_INIT | siWhere.AddTextColumn | ("Column", WhereColumns.COLUMN, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f02eb75 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:270 |  | GRID_INIT | siWhere.AddComboColumn | ("Vaild", WhereColumns.VALID, FPMerge.None, 80, false, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec2f9ec5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:272 |  | GRID_INIT | siWhere.AddTextColumn | ("OPORATOR", WhereColumns.OPORATOR, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64e59b0a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:273 |  | GRID_INIT | siWhere.AddTextColumn | ("VALUE", WhereColumns.VALUE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11f57b1a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:274 |  | GRID_INIT | siWhere.AddComboColumn | ("USE", WhereColumns.USE, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-838b0087 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:276 |  | GRID_INIT | siWhere.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-194a75cf | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0005_DynamicQueryList.cs:277 |  | GRID_INIT | siWhere.ColumnHeaderSpan | (0, 1, 1, 6, 25, "Condition", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0005_DynamicQueryList.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acb4b022 | InsertButton | SCM0005_DynamicQueryList.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64f23799 | InsertButton | SCM0005_DynamicQueryList.cs:951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ROLE), siMain.ActiveRowIndex, siM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36be3c00 | InsertButton | SCM0005_DynamicQueryList.cs:952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-79579a7b | InsertButton | SCM0005_DynamicQueryList.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae56009e | InsertButton | SCM0005_DynamicQueryList.cs:956 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ADMIN_ONLY_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-5884e1b1 | InsertButton | SCM0005_DynamicQueryList.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCM0005_DynamicQueryList.ParameterData

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03039a14 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:628 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | 엔드포인트 요청 생성 |  |  |  |
| AC-ac410850 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:629 |  | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ebc0db92 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:630 |  | DATA_OP | request.Parameters["p_dq_id"] | dq_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ab881f9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:631 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7df99ee | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:633 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryList.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06f01cc4 | SaveButton | SCM0005_DynamicQueryList.cs:747 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName != SpdSheet.shtMain) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d251164 | SaveButton | SCM0005_DynamicQueryList.cs:781 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3834b3de | SaveButton | SCM0005_DynamicQueryList.cs:785 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ADM_DQ_CREATE") ⇒ DM_H.PR_DM_ADM_DQ_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-7e7a29a8 | SaveButton | SCM0005_DynamicQueryList.cs:786 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-86d275c8 | SaveButton | SCM0005_DynamicQueryList.cs:787 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-842b60b0 | SaveButton | SCM0005_DynamicQueryList.cs:788 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_DQ_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DQ_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96afeb3d | SaveButton | SCM0005_DynamicQueryList.cs:789 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_DIVISION_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d91b75c7 | SaveButton | SCM0005_DynamicQueryList.cs:790 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_DQ_NAME"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DQ_NAME)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79ebbc9a | SaveButton | SCM0005_DynamicQueryList.cs:791 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DESC)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63ee3585 | SaveButton | SCM0005_DynamicQueryList.cs:792 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_DQ_TEXT"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.QUERY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-374c482e | SaveButton | SCM0005_DynamicQueryList.cs:793 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_VALID_YN"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c259db03 | SaveButton | SCM0005_DynamicQueryList.cs:794 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_ADMIN_ONLY_YN"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ADMIN_ONLY_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3f8faed | SaveButton | SCM0005_DynamicQueryList.cs:795 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_CREATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-bf66eac8 | SaveButton | SCM0005_DynamicQueryList.cs:796 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-4a63eed3 | SaveButton | SCM0005_DynamicQueryList.cs:798 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5cb66a78 | SaveButton | SCM0005_DynamicQueryList.cs:798 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-cd3cfe55 | SaveButton | SCM0005_DynamicQueryList.cs:805 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sRMSG.Trim() != "success") | THROW | throw new Exception(sRMSG); |  | 예외 발생 |  |  |  |
| AC-1d7be427 | SaveButton | SCM0005_DynamicQueryList.cs:832 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP") ⇒ DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-e0051cfa | SaveButton | SCM0005_DynamicQueryList.cs:833 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2573a02e | SaveButton | SCM0005_DynamicQueryList.cs:835 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | request.Parameters["p_DQ_ID"] | sDB_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b1b85823 | SaveButton | SCM0005_DynamicQueryList.cs:836 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | request.Parameters["p_GROUP_ID"] | sRole_ID | 행/컬럼 값 대입 |  |  |  |
| AC-5293e409 | SaveButton | SCM0005_DynamicQueryList.cs:837 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | request.Parameters["p_VALID_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-502309f8 | SaveButton | SCM0005_DynamicQueryList.cs:838 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | request.Parameters["p_CREATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-da14c7e6 | SaveButton | SCM0005_DynamicQueryList.cs:839 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-09bcfaca | SaveButton | SCM0005_DynamicQueryList.cs:841 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-01f086e5 | SaveButton | SCM0005_DynamicQueryList.cs:849 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") | CALL_EXT | clsQuerys.mGetGroupDataByPopUp | (sColumnData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54fe5e2a | SaveButton | SCM0005_DynamicQueryList.cs:863 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ADM_DQ_CREATE_COLUMN") ⇒ DM_H.PR_DM_ADM_DQ_CREATE_COLUMN | 엔드포인트 요청 생성 |  |  |  |
| AC-e1636040 | SaveButton | SCM0005_DynamicQueryList.cs:864 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-168f14b7 | SaveButton | SCM0005_DynamicQueryList.cs:865 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_active_flag"] | dtGroup.Rows[j]["A"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ae20e63 | SaveButton | SCM0005_DynamicQueryList.cs:866 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_DQ_ID"] | sDB_ID | 행/컬럼 값 대입 |  |  |  |
| AC-5ab96e85 | SaveButton | SCM0005_DynamicQueryList.cs:867 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_COLUMN_NAME"] | dtGroup.Rows[j]["COLUMN_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58435d7d | SaveButton | SCM0005_DynamicQueryList.cs:868 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_VALUE_YN"] | 'Y' | 행/컬럼 값 대입 |  |  |  |
| AC-851a4990 | SaveButton | SCM0005_DynamicQueryList.cs:869 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_VALUE_TYPE"] | dtGroup.Rows[j]["VALUE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69a35136 | SaveButton | SCM0005_DynamicQueryList.cs:870 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_VALID_YN"] | dtGroup.Rows[j]["VALID_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54f6f9f0 | SaveButton | SCM0005_DynamicQueryList.cs:871 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_SEQNO"] | dtGroup.Rows[j]["SEQNO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2afdd028 | SaveButton | SCM0005_DynamicQueryList.cs:872 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_CREATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-f2f0257d | SaveButton | SCM0005_DynamicQueryList.cs:873 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-7aede8b1 | SaveButton | SCM0005_DynamicQueryList.cs:875 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sColumnData != "") ▸ for (j… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-588359bf | SaveButton | SCM0005_DynamicQueryList.cs:886 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") | CALL_EXT | clsQuerys.mGetWhereDataByPopUp | (sPARAMETERData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0906f9f | SaveButton | SCM0005_DynamicQueryList.cs:900 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER") ⇒ DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER | 엔드포인트 요청 생성 |  |  |  |
| AC-ee18cd81 | SaveButton | SCM0005_DynamicQueryList.cs:901 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f326346a | SaveButton | SCM0005_DynamicQueryList.cs:902 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_active_flag"] | dtParameter.Rows[j]["A"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-110e5476 | SaveButton | SCM0005_DynamicQueryList.cs:903 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_DQ_ID"] | sDB_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e6d5bf91 | SaveButton | SCM0005_DynamicQueryList.cs:904 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_PARAMETER_ID"] | dtParameter.Rows[j]["PARAMETER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-057cde08 | SaveButton | SCM0005_DynamicQueryList.cs:905 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_PARAMETER_TYPE"] | dtParameter.Rows[j]["TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0da5150e | SaveButton | SCM0005_DynamicQueryList.cs:906 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2aa6de8 | SaveButton | SCM0005_DynamicQueryList.cs:907 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_VALID_YN"] | dtParameter.Rows[j]["VALID_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4b33aeb | SaveButton | SCM0005_DynamicQueryList.cs:908 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_SEQNO"] | dtParameter.Rows[j]["SEQNO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27f894d3 | SaveButton | SCM0005_DynamicQueryList.cs:909 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_REP_YN"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84415ad5 | SaveButton | SCM0005_DynamicQueryList.cs:910 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_CREATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-44f0f059 | SaveButton | SCM0005_DynamicQueryList.cs:911 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-686844e3 | SaveButton | SCM0005_DynamicQueryList.cs:913 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sPARAMETERData != "") ▸ for… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96cc4bd2 | SaveButton | SCM0005_DynamicQueryList.cs:923 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b57fa17 | SaveButton | SCM0005_DynamicQueryList.cs:936 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCM0005_DynamicQueryList.Setting_ViewTab

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75459454 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1039 |  | GRID_BIND | siGRoup.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4fd975e0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1040 |  | GRID_LOCK | siGRoup.LockColumn | (0, siGRoup.GetMaxColumnIndex() - 3, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5af4eeff | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1043 | if (siGRoup.GetMaxRowIndex() >= 0) | GRID_LOCK | siGRoup.LockRange | (0, siGRoup.GetColumnIndex(GroupColumns.AGGREGATE), siGRoup.GetMaxRowIndex(), siGRoup.GetC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e9ba566 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1051 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) ▸ if (type == "System.String") | GRID_SET | siGRoup.SetText | (i, siGRoup.GetColumnIndex(GroupColumns.AGGREGATE), "Group") | 그리드 값 설정 |  |  |  |
| AC-55725f12 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1052 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) ▸ if (type == "System.String") | GRID_LOCK | siGRoup.LockRange | (i, siGRoup.GetColumnIndex(GroupColumns.AGGREGATE), i, siGRoup.GetColumnIndex(GroupColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-528b9126 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1056 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) ▸ else of (type == "System.String") | GRID_COMBO | siGRoup.SetCellTypeCombo | (i, siGRoup.GetColumnIndex(GroupColumns.AGGREGATE), clsQuerys.GetCommonDataByDB("AGGREGATE… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c9256acc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1056 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) ▸ else of (type == "System.String") | COMBO_DATA | clsQuerys.GetCommonDataByDB | ("AGGREGATE") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-728282e8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1057 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) ▸ else of (type == "System.String") | GRID_SET | siGRoup.SetText | (i, siGRoup.GetColumnIndex(GroupColumns.AGGREGATE), "SUM") | 그리드 값 설정 |  |  |  |
| AC-7c446142 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1061 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) ▸ if (sSEQNO == "0") | GRID_SET | siGRoup.SetText | (i, siGRoup.GetColumnIndex(GroupColumns.SEQNO), (i + 1).ToString()) | 그리드 값 설정 |  |  |  |
| AC-4ce19a92 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1062 | if (siGRoup.GetMaxRowIndex() >= 0) ▸ for (i <= siGRoup.GetMaxRowIndex()) | GRID_SET | siGRoup.SetText | (i, siGRoup.GetColumnIndex(GroupColumns.USE), "Y") | 그리드 값 설정 |  |  |  |
| AC-b536a76b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1070 |  | GRID_BIND | siWhere.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-15b17024 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1071 |  | GRID_LOCK | siWhere.LockColumn | (0, siWhere.GetMaxColumnIndex() - 3, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-90b1159d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1074 | if (siWhere.GetMaxRowIndex() >= 0) | GRID_LOCK | siWhere.LockRange | (0, siWhere.GetColumnIndex(WhereColumns.OPORATOR), siWhere.GetMaxRowIndex(), siWhere.GetMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-10502664 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1077 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) | GRID_COMBO | siWhere.SetCellTypeCombo | (i, siWhere.GetColumnIndex(WhereColumns.OPORATOR), clsQuerys.GetCommonDataByDB("OPORATOR")… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7861bb85 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1077 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) | COMBO_DATA | clsQuerys.GetCommonDataByDB | ("OPORATOR") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-31781851 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1078 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) | GRID_SET | siWhere.SetText | (i, siWhere.GetColumnIndex(WhereColumns.OPORATOR), "=") | 그리드 값 설정 |  |  |  |
| AC-90fd194a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1080 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) | GRID_LOCK | siWhere.LockRange | (i, siWhere.GetColumnIndex(WhereColumns.OPORATOR), i, siWhere.GetColumnIndex(WhereColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca3ccb41 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1081 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) | GRID_SET | siWhere.SetText | (i, siWhere.GetColumnIndex(WhereColumns.USE), "Y") | 그리드 값 설정 |  |  |  |
| AC-20cf3d49 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1090 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) ▸ if (siWhere.GetText(i, siWhere.GetColumnIndex(WhereColumns.TYPE))… | GRID_COMBO | siWhere.SetCellTypeCombo | (i, siWhere.GetColumnIndex(WhereColumns.VALUE), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-35ee6fa2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1093 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) ▸ if (siWhere.GetText(i, siWhere.GetColumnIndex(WhereColumns.TYPE))… | GRID_COMBO | siWhere.SetCellTypeCombo | (i, siWhere.GetColumnIndex(WhereColumns.VALUE), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4cee630e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1099 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) ▸ else of (siWhere.GetText(i, siWhere.GetColumnIndex(WhereColumns.T… | GRID_INIT | siWhere.SetCellTypeDateTime | (i, siWhere.GetColumnIndex(WhereColumns.VALUE)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-adfb5b93 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1103 | if (siWhere.GetMaxRowIndex() >= 0) ▸ for (i <= siWhere.GetMaxRowIndex()) ▸ else of (siWhere.GetText(i, siWhere.GetColumnIndex(WhereColumns.T… | GRID_INIT | siWhere.SetCellTypeNumber | (i, siWhere.GetColumnIndex(WhereColumns.VALUE)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c6a74aaf | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1112 |  | VALUE_SET | umltReportNameResult.Text | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.DQ_NAME)) | 컨트롤 값 설정 |  |  |  |
| AC-f2c7c54d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1113 |  | VALUE_SET | txtDescrptionResult.Text | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.DESC)) | 컨트롤 값 설정 |  |  |  |
| AC-a3ae75c9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1114 |  | VALUE_SET | clbRoleResult.ControlValues | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ROLE_ID)) | 컨트롤 값 설정 |  |  |  |
| AC-fb8cc846 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0005_DynamicQueryList.cs:1115 |  | VALUE_SET | rtxtSQL.Text | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.QUERY)) | 컨트롤 값 설정 |  |  |  |

## SCM0005_DynamicQueryList.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b17a35c0 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:972 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e17b6605 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:978 | if (siMain.IsLock(siMain.SheetName)) ▸ if (action == "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e315b2e | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:982 | if (siMain.IsLock(siMain.SheetName)) | CALL_EXT | tabQuery.SelectTab | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e71e3dc | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:988 | if (siMain.IsLock(siMain.SheetName)) | VALUE_SET | lbl_DQ_ID.Text | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DQ_ID)).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-64e05257 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:996 | else of (siMain.IsLock(siMain.SheetName)) | POPUP | new POPUP.SCM0005_DynamicQueryListPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-c772c8ea | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:997 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData | new DyamicSqlPopup() | 속성 clsData 설정 |  |  |  |
| AC-11462f3f | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:997 | else of (siMain.IsLock(siMain.SheetName)) | POPUP | new DyamicSqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-277f98ac | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:998 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sDq_ID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DQ_ID)) | 속성 sDq_ID 설정 |  |  |  |
| AC-c04b8e7f | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:999 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sReport_Name | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DQ_NAME)) | 속성 sReport_Name 설정 |  |  |  |
| AC-04722421 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1000 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sDes | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DESC)) | 속성 sDes 설정 |  |  |  |
| AC-845bb73b | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1001 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sSql | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.QUERY)) | 속성 sSql 설정 |  |  |  |
| AC-0239ca1f | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1002 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sRole_ID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ROLE_ID)) | 속성 sRole_ID 설정 |  |  |  |
| AC-7991e152 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1003 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sRole_Name | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ROLE)) | 속성 sRole_Name 설정 |  |  |  |
| AC-eb7a87fa | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1004 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sColumns | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.COMUMNS)) | 속성 sColumns 설정 |  |  |  |
| AC-7b0b2942 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1005 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sParameters | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PARAMETERS)) | 속성 sParameters 설정 |  |  |  |
| AC-deb7b761 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1006 | else of (siMain.IsLock(siMain.SheetName)) | UI_PROP | popup.clsData.sFlag | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.POPUPFLAG)) | 속성 sFlag 설정 |  |  |  |
| AC-fd1cc1d8 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1008 | else of (siMain.IsLock(siMain.SheetName)) | CALL_EXT | popup.LoadData | (popup.clsData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-995de6b4 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1009 | else of (siMain.IsLock(siMain.SheetName)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-17d260dc | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1013 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DQ_NAME), popup.clsData.sReport_Name) | 그리드 값 설정 |  |  |  |
| AC-6fc05246 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1014 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DESC), popup.clsData.sDes) | 그리드 값 설정 |  |  |  |
| AC-5e1957e3 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1015 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.QUERY), popup.clsData.sSql) | 그리드 값 설정 |  |  |  |
| AC-2bd7b3d2 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1016 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ROLE), popup.clsData.sRole_Name) | 그리드 값 설정 |  |  |  |
| AC-c3794cad | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1017 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ROLE_ID), popup.clsData.sRole_ID) | 그리드 값 설정 |  |  |  |
| AC-26476c45 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1018 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMUMNS), popup.clsData.sColumns) | 그리드 값 설정 |  |  |  |
| AC-54d30730 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1019 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PARAMETERS), popup.clsData.sParameters) | 그리드 값 설정 |  |  |  |
| AC-f6eb1647 | this.spdMain.CellDoubleClick | SCM0005_DynamicQueryList.cs:1020 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (popup.clsData.sFlag != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.POPUPFLAG), popup.clsData.sFlag) | 그리드 값 설정 |  |  |  |

## SCM0005_DynamicQueryList.Substitute

진입점: FindButton [else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (blnInsert) ▸ else of (tabQuery.SelectedIndex == 0) ▸ if (tabQuery.SelectedIndex == 1) ▸ try ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf56fea | FindButton [else of (tabQuery.SelectedIndex == 0) ▸ if (tabQ… 외 1 | SCM0005_DynamicQueryList.cs:1252 |  | RETURN | return strOri; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryListPopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb197369 | this.btnButtonList.UsrButtonList_Click_Detected | SCM0005_DynamicQueryListPopUp.cs:479 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc869909 | this.btnButtonList.UsrButtonList_Click_Detected | SCM0005_DynamicQueryListPopUp.cs:482 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCM0005_DynamicQueryListPopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92fb8e33 | this.Load | SCM0005_DynamicQueryListPopUp.cs:160 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-52f4b1b2 | this.Load | SCM0005_DynamicQueryListPopUp.cs:161 |  | GRID_INIT | this.AddSheet | (fpWhere, SpdSheet.shtWhere, SpdSheet.shtWhere, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7a7baa06 | this.Load | SCM0005_DynamicQueryListPopUp.cs:163 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-83a74425 | this.Load | SCM0005_DynamicQueryListPopUp.cs:164 |  | FLAG | siWhere | GetSheetInfo(fpWhere.Name, fpWhere.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## SCM0005_DynamicQueryListPopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c1f58d4 | this.Load | SCM0005_DynamicQueryListPopUp.cs:155 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCM0005_DynamicQueryListPopUp.Delete_Button

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08334649 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:503 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-627ae82b | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:506 | else of (fps.Name == "spdMain") | DATA_OP | siWhere.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0005_DynamicQueryListPopUp.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c4d2601 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:208 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b087b778 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:211 | else of (fps.Name == "spdMain") | DATA_OP | siWhere.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0005_DynamicQueryListPopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aeb42224 | Dispose | SCM0005_DynamicQueryListPopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0005_DynamicQueryListPopUp.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b42f8cd6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:220 | if (dtCols == null) ▸ if (FindData("FIND") == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3db61c2d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:226 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-89bc658d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:227 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7b4ab521 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:228 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(GroupColumns.NAME), siMain.GetColumnIndex(GroupColumns.TYPE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-894a7625 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:240 | if (siMain.GetMaxRowIndex() < 0) ▸ for (i < dtCompareList.Rows.Count) | GRID_SET | siMain.SetValue | (i, 1, dtCompareList.Rows[i]["CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-5ecec521 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:241 | if (siMain.GetMaxRowIndex() < 0) ▸ for (i < dtCompareList.Rows.Count) | GRID_SET | siMain.SetValue | (i, 2, dtCompareList.Rows[i]["NAME"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-297a4290 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:242 | if (siMain.GetMaxRowIndex() < 0) ▸ for (i < dtCompareList.Rows.Count) | GRID_SET | siMain.SetValue | (i, 4, i+1) | 그리드 값 설정 |  |  |  |
| AC-29b3d520 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:246 | if (siMain.GetMaxRowIndex() < 0) | CALL_EXT | CUIControl.SetPreferredWidth | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a39e6c23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:250 |  | FLAG | siWhere | GetSheetInfo(fpWhere.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0de7f843 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:251 |  | GRID_LOCK | siWhere.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-82786878 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0005_DynamicQueryListPopUp.cs:252 |  | GRID_LOCK | siWhere.LockColumn | (siWhere.GetColumnIndex(WhereColumns.TYPE), siWhere.GetColumnIndex(WhereColumns.COLUMN), t… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0005_DynamicQueryListPopUp.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm:] / this.Load / EditButton [if (dtCols == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed3823d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:297 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | txtReportName.Text | clsData.sReport_Name | 컨트롤 값 설정 |  |  |  |
| AC-a9c6c1ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:298 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | txtDescription.Text | clsData.sDes | 컨트롤 값 설정 |  |  |  |
| AC-2e000b7e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:299 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | clbRole.ControlValues | clsData.sRole_ID | 컨트롤 값 설정 |  |  |  |
| AC-cd3eed35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:300 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | rtxtSQL.Text | clsData.sSql | 컨트롤 값 설정 |  |  |  |
| AC-a909e8b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:325 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-72c89940 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:326 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d516c3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:328 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | CALL_EXT | CUIControl.SetPreferredWidth | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4d18f1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:332 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_BIND | siWhere.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-877f69a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:333 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_LOCK | siWhere.LockColumn | (0, siWhere.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-358c94ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:336 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | CALL_EXT | CUIControl.SetPreferredWidth | (siWhere.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a3f4ee4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:343 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") ▸ if (lbl_DQ_ID.Text == "") | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-bf5806e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:349 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-4df85cc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:350 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | DATA_OP | request.Parameters["p_dq_id"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-021a0869 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:351 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | DATA_OP | request.Parameters["p_dq_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-21ccfdc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:352 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | DATA_OP | request.Parameters["p_role"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-864b73ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:353 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3db62011 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:360 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | txtReportName.Text | ds.Tables[0].Rows[0]["DQ_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-38d5efb3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:361 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | txtDescription.Text | ds.Tables[0].Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-543cc597 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:371 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | clbRole.ControlValues | sRoles | 컨트롤 값 설정 |  |  |  |
| AC-00c5d231 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:372 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | rtxtSQL.Text | ds.Tables[0].Rows[0]["DQ_TEXT"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-47be5a55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:378 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0cf27ff7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:379 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c70f6232 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:381 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | CALL_EXT | CUIControl.SetPreferredWidth | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-525a8c6f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:385 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_BIND | siWhere.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f1d59cc8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:386 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_LOCK | siWhere.LockColumn | (0, siWhere.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c429c208 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:388 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | CALL_EXT | CUIControl.SetPreferredWidth | (siWhere.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cefd0d60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:398 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (rtxtSQL.Text.Trim() == "") | POPUP | FoxMessageBox.Show | ("No SQL.") | 팝업/폼 열기 |  |  |  |
| AC-da0885e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:399 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (rtxtSQL.Text.Trim() == "") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-bdcd3890 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:409 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") | CALL_EXT | clsQuerys.ReplaceFirstOccurence | ("SELECT", "SELECT TOP 0 ", sSQL, ref sParamArray) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b5f232c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:411 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") | ENDPOINT | clsQuerys.GetDataByDB | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9aeedc07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:415 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (dtSQL.Rows.Count == 1) | POPUP | FoxMessageBox.Show | ("Error : " + dtSQL.Rows[0][1].ToString()) | 팝업/폼 열기 |  |  |  |
| AC-f5194a35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:416 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (dtSQL.Rows.Count == 1) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-841f97d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:420 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | FLAG | this.dtCols | clsQuerys.GetColumnList(dtSQL) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ae73bab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:420 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | CALL_EXT | clsQuerys.GetColumnList | (dtSQL) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6323aafa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:421 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | FLAG | this.dtTypes | clsQuerys.GetColumnTypeList(dtSQL) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdce33bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:421 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | CALL_EXT | clsQuerys.GetColumnTypeList | (dtSQL) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6c35cff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:422 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | FLAG | this.dtCompareList | clsQuerys.GetColumnCompareList(dtSQL) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ec5d71e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:422 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | CALL_EXT | clsQuerys.GetColumnCompareList | (dtSQL) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3b219c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:423 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | FLAG | this.dtParameter | clsQuerys.GetParameterList(sParamArray) | 화면 필드/플래그 변경 |  |  |  |
| AC-321ba9cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:423 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | CALL_EXT | clsQuerys.GetParameterList | (sParamArray) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f3947b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:426 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00148") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad77926c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:432 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryListPopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f9c7764 | this.Load | SCM0005_DynamicQueryListPopUp.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d3fe36f | this.Load | SCM0005_DynamicQueryListPopUp.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0005_DynamicQueryListPopUp.fpWhere_CellDoubleClick

진입점: this.fpWhere.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa7775f | this.fpWhere.CellDoubleClick | SCM0005_DynamicQueryListPopUp.cs:710 | if (siWhere.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryListPopUp.fpWhere_ComboSelChange

진입점: this.fpWhere.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8727dd | this.fpWhere.ComboSelChange | SCM0005_DynamicQueryListPopUp.cs:750 | if (e.Column == siWhere.GetColumnIndex(WhereColumns.TYPE)) ▸ if (sType == "Combo") | GRID_COMBO | siWhere.SetCellTypeCombo | (e.Row, 2, clsQuerys.GetCommonDataByDB("COMBO")) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-39b408e4 | this.fpWhere.ComboSelChange | SCM0005_DynamicQueryListPopUp.cs:750 | if (e.Column == siWhere.GetColumnIndex(WhereColumns.TYPE)) ▸ if (sType == "Combo") | COMBO_DATA | clsQuerys.GetCommonDataByDB | ("COMBO") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fd7a8958 | this.fpWhere.ComboSelChange | SCM0005_DynamicQueryListPopUp.cs:754 | if (e.Column == siWhere.GetColumnIndex(WhereColumns.TYPE)) ▸ else of (sType == "Combo") ▸ if (sType == "Parameter") | GRID_COMBO | siWhere.SetCellTypeCombo | (e.Row, 2, dtParameter) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2774b7a6 | this.fpWhere.ComboSelChange | SCM0005_DynamicQueryListPopUp.cs:758 | if (e.Column == siWhere.GetColumnIndex(WhereColumns.TYPE)) ▸ else of (sType == "Combo") ▸ else of (sType == "Parameter") | GRID_COMBO | siWhere.SetCellTypeCombo | (e.Row, 2, dtCols) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCM0005_DynamicQueryListPopUp.GroupData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm: ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / this.Load [if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / EditButton [if (dtCols == null) ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e07c85e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:443 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | 엔드포인트 요청 생성 |  |  |  |
| AC-83e26e00 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:444 |  | DATA_OP | request.Parameters["p_dq_id"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-38e46290 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:445 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b9f0e69 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:447 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryListPopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-124f72ce | this.Load | SCM0005_DynamicQueryListPopUp.cs:134 |  | FLAG | dtRole | clsQuerys.GetCommonDataByDB("ROLES") | 화면 필드/플래그 변경 |  |  |  |
| AC-0a93f786 | this.Load | SCM0005_DynamicQueryListPopUp.cs:134 |  | COMBO_DATA | clsQuerys.GetCommonDataByDB | ("ROLES") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-88ee3bf4 | this.Load | SCM0005_DynamicQueryListPopUp.cs:135 |  | LIST_REBIND | clsCtrl.setListBox | (dtRole, clbRole, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0005_DynamicQueryListPopUp.InitSpread_Group

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9634398b | this.Load | SCM0005_DynamicQueryListPopUp.cs:683 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7bc1c362 | this.Load | SCM0005_DynamicQueryListPopUp.cs:685 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2eb5efb4 | this.Load | SCM0005_DynamicQueryListPopUp.cs:686 |  | GRID_INIT | siMain.AddTextColumn | ("Column", GroupColumns.NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f9ee24a | this.Load | SCM0005_DynamicQueryListPopUp.cs:687 |  | GRID_INIT | siMain.AddTextColumn | ("Type", GroupColumns.TYPE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34bb0d24 | this.Load | SCM0005_DynamicQueryListPopUp.cs:688 |  | GRID_INIT | siMain.AddComboColumn | ("Valid", GroupColumns.VALID, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49700423 | this.Load | SCM0005_DynamicQueryListPopUp.cs:689 |  | GRID_INIT | siMain.AddTextColumn | ("Seq No", GroupColumns.SEQNO, FPMerge.None, 80, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d42a8cb3 | this.Load | SCM0005_DynamicQueryListPopUp.cs:691 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 1, 1, 4, 25, "Column", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0005_DynamicQueryListPopUp.InitSpread_Where

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-905d1c50 | this.Load | SCM0005_DynamicQueryListPopUp.cs:696 |  | GRID_INIT | siWhere.InitSheet | (siWhere.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-dab6acb2 | this.Load | SCM0005_DynamicQueryListPopUp.cs:698 |  | GRID_INIT | siWhere.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cc3d5bb9 | this.Load | SCM0005_DynamicQueryListPopUp.cs:699 |  | GRID_INIT | siWhere.AddComboColumn | ("Type", WhereColumns.TYPE, FPMerge.None, 120, true, dtDataType, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-924c5107 | this.Load | SCM0005_DynamicQueryListPopUp.cs:700 |  | GRID_INIT | siWhere.AddTextColumn | ("Column", WhereColumns.COLUMN, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-199340b1 | this.Load | SCM0005_DynamicQueryListPopUp.cs:701 |  | GRID_INIT | siWhere.AddComboColumn | ("Valid", WhereColumns.VALID, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00d9c5ee | this.Load | SCM0005_DynamicQueryListPopUp.cs:702 |  | GRID_INIT | siWhere.AddTextColumn | ("Seq No", GroupColumns.SEQNO, FPMerge.None, 80, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59b4290e | this.Load | SCM0005_DynamicQueryListPopUp.cs:704 |  | GRID_INIT | siWhere.ColumnHeaderSpan | (0, 1, 1, 4, 25, "Condition", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0005_DynamicQueryListPopUp.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton / EditButton [if (siMain.GetMaxRowIndex() < 0) ▸ for (i < dtCompareList.Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72a066c9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:631 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9db8fbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:639 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4eaff0c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:642 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(GroupColumns.NAME), dtCols) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6f9aa91e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:643 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(GroupColumns.TYPE), dtTypes) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-10f3e666 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:649 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (GroupColumns.VALID, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6cbf228 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:650 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (GroupColumns.SEQNO, insCell.Row.Index +1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c877324 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:652 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-229252b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:663 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | DATA_OP | siWhere.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ed51a08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:666 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | GRID_COMBO | siWhere.SetCellTypeCombo | (insCell.Row.Index, siWhere.GetColumnIndex(WhereColumns.TYPE), dtDataType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-72e6275a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:667 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | GRID_COMBO | siWhere.SetCellTypeCombo | (insCell.Row.Index, siWhere.GetColumnIndex(WhereColumns.COLUMN), dtCols) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ba0cf0be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:672 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | DATA_OP | defaultData.Add | (WhereColumns.VALID, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-7113f0cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:673 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | DATA_OP | defaultData.Add | (GroupColumns.SEQNO, insCell.Row.Index +1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1db2b9f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:675 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | GRID_SET | siWhere.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCM0005_DynamicQueryListPopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65b5f188 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:121 |  | FLAG | this.clsData | clsData | 화면 필드/플래그 변경 |  |  |  |
| AC-740b6113 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:123 |  | VALUE_SET | lbl_DQ_ID.Text | clsData.sDq_ID | 컨트롤 값 설정 |  |  |  |

## SCM0005_DynamicQueryListPopUp.mSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d19563ad | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:524 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_ADM_DQ_CREATE") ⇒ DM.PR_DM_ADM_DQ_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-c2b56803 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:525 |  | DATA_OP | request.Parameters["p_active_flag"] | sFlag | 행/컬럼 값 대입 |  |  |  |
| AC-12b31993 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:526 |  | DATA_OP | request.Parameters["p_DQ_ID"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d12d6890 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:527 |  | DATA_OP | request.Parameters["p_DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98c6dd18 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:528 |  | DATA_OP | request.Parameters["p_DQ_NAME"] | txtReportName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ed4ca048 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:529 |  | DATA_OP | request.Parameters["p_DESC"] | txtDescription.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7c4b0d19 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:530 |  | DATA_OP | request.Parameters["p_QUERY"] | rtxtSQL.Text | 행/컬럼 값 대입 |  |  |  |
| AC-12cdc317 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:531 |  | DATA_OP | request.Parameters["p_VALID_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d3ec90b4 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:532 |  | DATA_OP | request.Parameters["p_ADMIN_ONLY_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-c66e211f | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:533 |  | DATA_OP | request.Parameters["p_CREATED_BY"] | "DB" | 행/컬럼 값 대입 |  |  |  |
| AC-8d754074 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:534 |  | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | "DB" | 행/컬럼 값 대입 |  |  |  |
| AC-d0552819 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:535 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f2b7f2b | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:545 | if (sRMSG.Trim() == "success") | VALUE_SET | lbl_DQ_ID.Text | response.DataSet.Tables[response.DataSet.Tables.Count - 1].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fbcc0aa9 | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:548 | if (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "저장 되었습니다." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ec2b71b | (진입점 미연결) | SCM0005_DynamicQueryListPopUp.cs:561 | else of (sRMSG.Trim() == "success") | POPUP | FoxMessageBox.Show | (sRMSG, "Error!") | 팝업/폼 열기 |  |  |  |

## SCM0005_DynamicQueryListPopUp.ParameterData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm: ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / this.Load [if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / EditButton [if (dtCols == null) ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7218aec8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:458 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | 엔드포인트 요청 생성 |  |  |  |
| AC-584e708f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:459 |  | DATA_OP | request.Parameters["p_dq_id"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8c55943c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:460 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-768a7242 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCM0005_DynamicQueryListPopUp.cs:462 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## SCM0005_DynamicQueryListPopUp.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-235d342e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:574 |  | FLAG | this.clsData | new DyamicSqlPopup() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c261e8a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:574 |  | POPUP | new DyamicSqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1c4ab578 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:576 |  | UI_PROP | this.clsData.sFlag | "true" | 속성 sFlag 설정 |  |  |  |
| AC-e811ee35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:577 |  | UI_PROP | this.clsData.sDq_ID | lbl_DQ_ID.Text | 속성 sDq_ID 설정 |  |  |  |
| AC-d0f7b281 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:578 |  | UI_PROP | this.clsData.sReport_Name | txtReportName.Text | 속성 sReport_Name 설정 |  |  |  |
| AC-b817bb50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:579 |  | UI_PROP | this.clsData.sDes | txtDescription.Text | 속성 sDes 설정 |  |  |  |
| AC-539dcacc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:580 |  | UI_PROP | this.clsData.sSql | rtxtSQL.Text | 속성 sSql 설정 |  |  |  |
| AC-8d4d94ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:581 |  | UI_PROP | this.clsData.sRole_ID | clbRole.ControlValues | 속성 sRole_ID 설정 |  |  |  |
| AC-58b0d06e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:582 |  | UI_PROP | this.clsData.sRole_Name | clbRole.NameList | 속성 sRole_Name 설정 |  |  |  |
| AC-98f2f9d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:604 |  | UI_PROP | this.clsData.sColumns | p_active_flag | 속성 sColumns 설정 |  |  |  |
| AC-1c6d1a8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0005_DynamicQueryListPopUp.cs:625 |  | UI_PROP | this.clsData.sParameters | p_active_flag | 속성 sParameters 설정 |  |  |  |

## SCM0005_DynamicQueryListPopUp.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad0aee9e | this.spdMain.ComboSelChange | SCM0005_DynamicQueryListPopUp.cs:731 | if (e.Column == siMain.GetColumnIndex(GroupColumns.NAME)) | DATA_OP | myRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-64ee4c4a | this.spdMain.ComboSelChange | SCM0005_DynamicQueryListPopUp.cs:736 | if (e.Column == siMain.GetColumnIndex(GroupColumns.NAME)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(GroupColumns.TYPE), row["NAME"].ToString()) | 그리드 값 설정 |  |  |  |

