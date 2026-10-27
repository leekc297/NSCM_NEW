# AS-IS 액션 대조표 — FP00731

> 원천: `Doc/asisfacts/screens/FP00731/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 111행 · 메서드 20 · 종류 DATA_OP 24 · FLAG 19 · UI_PROP 11 · RETURN 9 · COMBO_DATA 8 · UI_MISC 6 · LIST_REBIND 6 · GRID_INIT 5 · POPUP 4 · STATE 4 · ENDPOINT 3 · CALL_EXT 3 · THROW 2 · EXCEL 1 · MESSAGE 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · GRID_SET 1 · ⚠ 의미 확인 필요 3


## FP00731_Stock.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caba56d4 | this.btnSql.Click | FP00731_Stock.cs:443 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-af74beb7 | this.btnSql.Click | FP00731_Stock.cs:444 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-130f5095 | this.btnSql.Click | FP00731_Stock.cs:446 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00731_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2db6f6d | this.btnSql.Click | FP00731_Stock.cs:447 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00731_Stock.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ecfab1a | (진입점 미연결) | FP00731_Stock.cs:714 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00731_Stock.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-323edb75 | this.Load | FP00731_Stock.cs:393 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a16c64b6 | this.Load | FP00731_Stock.cs:394 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9daf22d2 | this.Load | FP00731_Stock.cs:395 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00731_Stock.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bb975e6 | this.Load | FP00731_Stock.cs:158 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-767e29c9 | this.Load | FP00731_Stock.cs:159 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-26d20de8 | this.Load | FP00731_Stock.cs:160 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b101f9fa | this.Load | FP00731_Stock.cs:164 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-360887b3 | this.Load | FP00731_Stock.cs:165 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2ccdd77e | this.Load | FP00731_Stock.cs:166 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00731_Stock.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8eb7089 | Dispose | FP00731_Stock.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00731_Stock.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e268994a | EditButton | FP00731_Stock.cs:421 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00731_Stock.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af67aa7 | ExcelButton | FP00731_Stock.cs:431 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00731_Stock.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] / FindButton [try ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f329176 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:575 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00731_STOCK") ⇒ FP_Planning.PR_UI_FP00731_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-292ed97b | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:576 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b42fb58c | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:577 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9bd92899 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:578 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-c01b9277 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:579 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-998693c4 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:580 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-eedd1de2 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:582 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-c521f9ea | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:583 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-3e9c4e54 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:584 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-8babb03c | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:585 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-837e71d0 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:586 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-980f0c48 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:587 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-0c77b1f0 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:588 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-7b8bf1fd | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:590 | try | DATA_OP | request.Parameters["p_stock_type"] | pStockType.Equals("ALL") ? DBNull.Value : pStockType | 행/컬럼 값 대입 |  |  |  |
| AC-837193df | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:591 | try | DATA_OP | request.Parameters["p_fp_apply_item_id"] | pFpApplyItemId.Equals("ALL") ? DBNull.Value : pFpApplyItemId | 행/컬럼 값 대입 |  |  |  |
| AC-fd1f13c8 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:592 | try | DATA_OP | request.Parameters["p_packer"] | pPacker.Equals("ALL") ? DBNull.Value : pPacker | 행/컬럼 값 대입 |  |  |  |
| AC-70587ad7 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:593 | try | DATA_OP | request.Parameters["p_status"] | pStatus.Equals("ALL") ? DBNull.Value : pStatus | 행/컬럼 값 대입 |  |  |  |
| AC-c5532ef9 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:594 | try | DATA_OP | request.Parameters["p_cutoff_date"] | pCutoffDate.Equals("ALL") ? DBNull.Value : pCutoffDate | 행/컬럼 값 대입 |  |  |  |
| AC-4d6189eb | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:595 | try | DATA_OP | request.Parameters["p_is_all_fac"] | pIsAllFac | 행/컬럼 값 대입 |  |  |  |
| AC-3c39e495 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:597 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df9ab73f | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:599 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9befa560 | popSql.OnSql [if (programID == "PR_UI_FP00731_STOCK")] 외 1 | FP00731_Stock.cs:606 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00731_Stock.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6848522 | FindButton | FP00731_Stock.cs:455 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-da7aeefa | FindButton | FP00731_Stock.cs:461 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35de034c | FindButton | FP00731_Stock.cs:462 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7127231 | FindButton | FP00731_Stock.cs:465 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0e4d22c8 | FindButton | FP00731_Stock.cs:470 | try ▸ try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-53549e9d | FindButton | FP00731_Stock.cs:470 | try ▸ try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14213423 | FindButton | FP00731_Stock.cs:476 | try ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5255d1a9 | FindButton | FP00731_Stock.cs:483 | try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-123db4b6 | FindButton | FP00731_Stock.cs:485 | try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b669808 | FindButton | FP00731_Stock.cs:494 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8dbb17c9 | FindButton | FP00731_Stock.cs:495 | try ▸ try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1d1c1870 | FindButton | FP00731_Stock.cs:499 | try ▸ try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-26bcbe13 | FindButton | FP00731_Stock.cs:502 | try ▸ try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6658bb5e | FindButton | FP00731_Stock.cs:518 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c36bdfe2 | FindButton | FP00731_Stock.cs:520 | try ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-63918957 | FindButton | FP00731_Stock.cs:526 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-6f4e0e4e | FindButton | FP00731_Stock.cs:530 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00731_Stock.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e616b9b | this.Load | FP00731_Stock.cs:137 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00731_Stock.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3663f80f | this.Load | FP00731_Stock.cs:801 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ae906a03 | this.Load | FP00731_Stock.cs:802 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf3181dc | this.Load | FP00731_Stock.cs:802 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4e9a867f | this.Load | FP00731_Stock.cs:803 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00731_Stock.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d94c5352 | this.Load | FP00731_Stock.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b494b5b5 | this.Load | FP00731_Stock.cs:180 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2b1982cc | this.Load | FP00731_Stock.cs:181 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-70e8cd8c | this.Load | FP00731_Stock.cs:183 |  | FLAG | dtYesNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-58372b73 | this.Load | FP00731_Stock.cs:183 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5fcc7af | this.Load | FP00731_Stock.cs:190 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-e31f07ba | this.Load | FP00731_Stock.cs:190 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5537de51 | this.Load | FP00731_Stock.cs:192 |  | FLAG | sCurDate | (string)dtCurDate.Rows[0]["CUR_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-21548ea6 | this.Load | FP00731_Stock.cs:193 |  | FLAG | sPlanDate | sCurDate.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-5e01fc9a | this.Load | FP00731_Stock.cs:194 |  | FLAG | sPrevDate | sCurDate | 화면 필드/플래그 변경 |  |  |  |
| AC-838dbf97 | this.Load | FP00731_Stock.cs:196 |  | VALUE_SET | drpCutoffDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-d43e7c92 | this.Load | FP00731_Stock.cs:199 |  | FLAG | dtStockType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00731_Stock", "STOCK_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-508c2493 | this.Load | FP00731_Stock.cs:199 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00731_Stock", "STOCK_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-50257b7c | this.Load | FP00731_Stock.cs:210 |  | LIST_REBIND | clsCtrl.setListBox | (dtStockType, clbStockType, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00731_Stock.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83cbc70b | this.Load | FP00731_Stock.cs:371 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d6d64b01 | this.Load | FP00731_Stock.cs:372 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b6cd5d83 | this.Load | FP00731_Stock.cs:373 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5866cbf9 | this.Load | FP00731_Stock.cs:374 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e15774c2 | this.Load | FP00731_Stock.cs:375 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-46f87e23 | this.Load | FP00731_Stock.cs:376 |  | UI_PROP | clbStockType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00731_Stock.InitSpread

진입점: this.Load / FindButton [try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebdaf8cc | this.Load 외 1 | FP00731_Stock.cs:402 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b7abb9cc | this.Load 외 1 | FP00731_Stock.cs:404 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-36799fd1 | this.Load 외 1 | FP00731_Stock.cs:406 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00731_Stock.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b28a38bd | popSql.OnSql | FP00731_Stock.cs:727 | if (programID == "PR_UI_FP00731_STOCK") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-171c3871 | popSql.OnSql | FP00731_Stock.cs:730 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00731_Stock.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ae36b21 | SaveButton | FP00731_Stock.cs:436 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00731_Stock.Search_After

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-538a792f | (진입점 미연결) | FP00731_Stock.cs:654 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP00731_Stock.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71f6f1e2 | this.Load 외 5 | FP00731_Stock.cs:229 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-20c0aea6 | this.Load 외 5 | FP00731_Stock.cs:229 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b112fae4 | this.Load 외 5 | FP00731_Stock.cs:234 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d9b07daf | this.Load 외 5 | FP00731_Stock.cs:238 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea90864a | this.Load 외 5 | FP00731_Stock.cs:238 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4ba573e4 | this.Load 외 5 | FP00731_Stock.cs:239 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5f291cab | this.Load 외 5 | FP00731_Stock.cs:245 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-29ee5045 | this.Load 외 5 | FP00731_Stock.cs:246 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1dd88e1 | this.Load 외 5 | FP00731_Stock.cs:246 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-78b67054 | this.Load 외 5 | FP00731_Stock.cs:247 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5371b284 | this.Load 외 5 | FP00731_Stock.cs:253 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-04a31581 | this.Load 외 5 | FP00731_Stock.cs:254 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-6e574a1b | this.Load 외 5 | FP00731_Stock.cs:254 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e261af80 | this.Load 외 5 | FP00731_Stock.cs:255 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b2165737 | this.Load 외 5 | FP00731_Stock.cs:262 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8ae9e287 | this.Load 외 5 | FP00731_Stock.cs:263 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4f74e9f | this.Load 외 5 | FP00731_Stock.cs:263 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e3dbbc2b | this.Load 외 5 | FP00731_Stock.cs:264 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-882436c7 | this.Load 외 5 | FP00731_Stock.cs:270 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00731_Stock.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6077f6b | this.spdMain.CellClick | FP00731_Stock.cs:752 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5b7aec6 | this.spdMain.CellClick | FP00731_Stock.cs:763 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-113b88f6 | this.spdMain.CellClick | FP00731_Stock.cs:765 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals… | GRID_SET | siMain.SetText | (i, 0, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |

## FP00731_Stock.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05502621 | this.spdMain.EditChange | FP00731_Stock.cs:796 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

