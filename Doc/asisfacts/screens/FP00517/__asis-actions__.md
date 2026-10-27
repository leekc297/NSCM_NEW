# AS-IS 액션 대조표 — FP00517

> 원천: `Doc/asisfacts/screens/FP00517/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 145행 · 메서드 21 · 종류 DATA_OP 31 · FLAG 23 · RETURN 17 · UI_PROP 12 · GRID_SET 9 · GRID_LOCK 7 · POPUP 6 · MESSAGE 5 · ENDPOINT 5 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · COMBO_DATA 4 · LIST_REBIND 3 · VALIDATE 2 · THROW 2 · CALL_EXT 2 · GRID_COMBO 2 · EXCEL 1 · GRID_BIND 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 3


## FP00517_Domestic_Model_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5065f938 | this.btnSql.Click | FP00517_Domestic_Model_Master.cs:298 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-79d2e26a | this.btnSql.Click | FP00517_Domestic_Model_Master.cs:299 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25c67b7a | this.btnSql.Click | FP00517_Domestic_Model_Master.cs:301 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00517_DOMESTIC_MODEL_MASTER") | 데이터 객체 조작/조회 |  |  |  |
| AC-78180fcf | this.btnSql.Click | FP00517_Domestic_Model_Master.cs:302 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00517_Domestic_Model_Master.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-104208f0 | (진입점 미연결) | FP00517_Domestic_Model_Master.cs:761 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00517_Domestic_Model_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4240848e | this.Load | FP00517_Domestic_Model_Master.cs:208 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2680499c | this.Load | FP00517_Domestic_Model_Master.cs:209 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-10b40c06 | this.Load | FP00517_Domestic_Model_Master.cs:211 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00517_Domestic_Model_Master.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25f71fa | this.Load | FP00517_Domestic_Model_Master.cs:127 |  | UI_PROP | siMain.ImagePopUp | imgList.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-403a6ba5 | this.Load | FP00517_Domestic_Model_Master.cs:129 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4f8e549 | this.Load | FP00517_Domestic_Model_Master.cs:130 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-47aff72d | this.Load | FP00517_Domestic_Model_Master.cs:131 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-b29c43e0 | this.Load | FP00517_Domestic_Model_Master.cs:136 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5bd89997 | this.Load | FP00517_Domestic_Model_Master.cs:137 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0d20e1ef | this.Load | FP00517_Domestic_Model_Master.cs:138 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-45ea3331 | this.Load | FP00517_Domestic_Model_Master.cs:142 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f78da241 | this.Load | FP00517_Domestic_Model_Master.cs:143 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a7613ac5 | this.Load | FP00517_Domestic_Model_Master.cs:144 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00517_Domestic_Model_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-366debb5 | Dispose | FP00517_Domestic_Model_Master.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00517_Domestic_Model_Master.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a77d8716 | EditButton | FP00517_Domestic_Model_Master.cs:247 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-950b0c61 | EditButton | FP00517_Domestic_Model_Master.cs:249 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-877e0e2d | EditButton | FP00517_Domestic_Model_Master.cs:251 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.PRODUCTIO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d4d6475e | EditButton | FP00517_Domestic_Model_Master.cs:252 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | ( siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.UPDATE_TIM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-456e0f8d | EditButton | FP00517_Domestic_Model_Master.cs:259 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-92a43c66 | EditButton | FP00517_Domestic_Model_Master.cs:264 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-0770a761 | EditButton | FP00517_Domestic_Model_Master.cs:265 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |

## FP00517_Domestic_Model_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f19d094 | ExcelButton | FP00517_Domestic_Model_Master.cs:291 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00517_Domestic_Model_Master.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ab9ed9d | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:310 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-735bc1ce | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:316 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c79d91ee | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:317 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b256868a | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:320 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e857b23a | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:322 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-38061404 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:322 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68810938 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:328 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2f797782 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:335 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5dee3b35 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:336 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a6c7912 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:345 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-160650b9 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:347 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a723c30c | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:350 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5f94054a | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:363 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ebd68745 | FindButton 외 1 | FP00517_Domestic_Model_Master.cs:364 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00517_Domestic_Model_Master.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL_MASTER")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aea78f3d | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:379 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-36414231 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:381 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddfa18ed | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:382 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d1032c | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:383 | try ▸ lambda | FLAG | pActive | CString.GetCheckedListValue(dtActive, cboActive.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-77d3dad0 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:402 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00517_DOMESTIC_MODEL_MASTER") ⇒ FP_Master.PR_UI_FP00517_DOMESTIC_MODEL_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-0bbe8496 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:403 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6eef1f9f | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:404 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1370cf81 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:405 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-5b33e134 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:406 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b188f7e | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:407 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-83f62cc4 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:409 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-47b0c73e | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:410 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-0257ed27 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:411 | try | DATA_OP | request.Parameters["p_active"] | pActive.Equals("ALL") ? DBNull.Value : pActive | 행/컬럼 값 대입 |  |  |  |
| AC-68e84222 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:412 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f5156478 | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:415 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bece53aa | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:417 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bb53723b | popSql.OnSql [if (programID == "PR_UI_FP00517_DOMESTIC_MODEL… 외 2 | FP00517_Domestic_Model_Master.cs:424 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00517_Domestic_Model_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aa2a433 | this.Load | FP00517_Domestic_Model_Master.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00517_Domestic_Model_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db3e3efc | this.Load | FP00517_Domestic_Model_Master.cs:151 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f646964 | this.Load | FP00517_Domestic_Model_Master.cs:158 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2bdf73f8 | this.Load | FP00517_Domestic_Model_Master.cs:159 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-10f985ea | this.Load | FP00517_Domestic_Model_Master.cs:162 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-2f830687 | this.Load | FP00517_Domestic_Model_Master.cs:162 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4fdedc86 | this.Load | FP00517_Domestic_Model_Master.cs:163 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f7a0766f | this.Load | FP00517_Domestic_Model_Master.cs:165 |  | FLAG | dtProductionType | Data_FP.Common_FP(Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sN… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-7a26a3d7 | this.Load | FP00517_Domestic_Model_Master.cs:165 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4db4501 | this.Load | FP00517_Domestic_Model_Master.cs:167 |  | FLAG | dtActive | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-703a824e | this.Load | FP00517_Domestic_Model_Master.cs:167 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40260a74 | this.Load | FP00517_Domestic_Model_Master.cs:168 |  | LIST_REBIND | clsCtrl.setListBox | (dtActive, cboActive, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00517_Domestic_Model_Master.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aeb548e4 | this.Load | FP00517_Domestic_Model_Master.cs:193 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-05c37cca | this.Load | FP00517_Domestic_Model_Master.cs:194 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00517_Domestic_Model_Master.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a396ad7a | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:218 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-546809d6 | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:220 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a169c941 | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:223 |  | CALL_EXT | siMain.SetColumnCombo | ("PRODUCTION_TYPE", dtProductionType) | ⚠ 의미 확인 필요 |  |  |  |

## FP00517_Domestic_Model_Master.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4249cc0c | InsertButton | FP00517_Domestic_Model_Master.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46a0b6dd | InsertButton | FP00517_Domestic_Model_Master.cs:584 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5788ccf7 | InsertButton | FP00517_Domestic_Model_Master.cs:587 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DEFAULT_MARKET, "D") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b755684 | InsertButton | FP00517_Domestic_Model_Master.cs:588 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-42e9d082 | InsertButton | FP00517_Domestic_Model_Master.cs:590 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-bca90121 | InsertButton | FP00517_Domestic_Model_Master.cs:592 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e77f7e7c | InsertButton | FP00517_Domestic_Model_Master.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.DE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51253b71 | InsertButton | FP00517_Domestic_Model_Master.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## FP00517_Domestic_Model_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ea6b741 | popSql.OnSql | FP00517_Domestic_Model_Master.cs:774 | if (programID == "PR_UI_FP00517_DOMESTIC_MODEL_MASTER") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-305badb4 | popSql.OnSql | FP00517_Domestic_Model_Master.cs:777 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00517_Domestic_Model_Master.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-122f8575 | SaveButton | FP00517_Domestic_Model_Master.cs:430 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-baf2cc31 | SaveButton | FP00517_Domestic_Model_Master.cs:432 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b4a65ce | SaveButton | FP00517_Domestic_Model_Master.cs:437 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-393a0af4 | SaveButton | FP00517_Domestic_Model_Master.cs:438 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75d0a37a | SaveButton | FP00517_Domestic_Model_Master.cs:441 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-aa72f1fa | SaveButton | FP00517_Domestic_Model_Master.cs:448 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-1f6d7501 | SaveButton | FP00517_Domestic_Model_Master.cs:450 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-842af142 | SaveButton | FP00517_Domestic_Model_Master.cs:451 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b17151fa | SaveButton | FP00517_Domestic_Model_Master.cs:456 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-720129e3 | SaveButton | FP00517_Domestic_Model_Master.cs:461 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22b62374 | SaveButton | FP00517_Domestic_Model_Master.cs:470 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b46eaea | SaveButton | FP00517_Domestic_Model_Master.cs:474 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bcac44c3 | SaveButton | FP00517_Domestic_Model_Master.cs:478 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a0b30ac8 | SaveButton | FP00517_Domestic_Model_Master.cs:479 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-e613f6bf | SaveButton | FP00517_Domestic_Model_Master.cs:483 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00517_Domestic_Model_Master.Save_Data_Execute

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2d2ea7d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:540 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00517_SAVE") ⇒ FP_Master.PR_UI_FP00517_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-5aba1e3c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:541 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-02937af6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:543 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-11105bdf | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:544 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-060d1f07 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:545 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d5f6d35c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:546 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-227a40a9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:548 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-18a519a6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:549 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c753e32b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:550 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-cacb4e02 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:551 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5accecf6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:552 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-ec3c4a3b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:553 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-a8a2208a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:554 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-108e9d5b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:556 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-733f210b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:557 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a5573f32 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:563 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-09cd16bf | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00517_Domestic_Model_Master.cs:569 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00517_Domestic_Model_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d64ac25 | SaveButton | FP00517_Domestic_Model_Master.cs:279 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00517_Domestic_Model_Master.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e78ecac6 | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:180 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-5113c9c5 | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:181 | if (argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-701bc1c6 | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:183 | if (argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-11e93e4a | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:183 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff72b94e | this.Load 외 2 | FP00517_Domestic_Model_Master.cs:184 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00517_Domestic_Model_Master.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-357eaf52 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:639 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b04009de | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:641 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-006e74e9 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:662 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | DATA_OP | searchParam.Add | ("DIVISION_ID", pDivisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-147631d4 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:663 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | DATA_OP | searchParam.Add | ("SITE_ID", pSiteID) | 데이터 객체 조작/조회 |  |  |  |
| AC-80352647 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:664 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | DATA_OP | searchParam.Add | ("LEVEL_2_CODE_FLAG", "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc3b479c | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:666 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | new FPC0003_ItemPopup | (bFilterEnable, bMultiSelect, searchParam) | 팝업/폼 생성 |  |  |  |
| AC-cfc5e31b | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:667 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c31b3956 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:668 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7a8b5a28 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:678 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-d79fb341 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:679 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-c313e7d5 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:680 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-3bc2442f | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:681 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemID) | 그리드 값 설정 |  |  |  |
| AC-20b8e143 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:682 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-cb128a4e | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:692 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc49d8d0 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:695 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de876983 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:696 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b2f676f | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:700 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2745d232 | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:705 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf6f04cb | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:709 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1bd50fde | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:715 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), dtActive) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-74440d4f | this.spdMain.CellClick | FP00517_Domestic_Model_Master.cs:723 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00517_Domestic_Model_Master.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cf4b44e | this.spdMain.Change | FP00517_Domestic_Model_Master.cs:620 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("ACTIVE_FLAG")) | CALL_EXT | siMain.SetHAlign | (e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), e.Row, siMain.GetColumnIndex(DefCol… | ⚠ 의미 확인 필요 |  |  |  |

