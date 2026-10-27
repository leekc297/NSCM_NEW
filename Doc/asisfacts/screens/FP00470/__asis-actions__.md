# AS-IS 액션 대조표 — FP00470

> 원천: `Doc/asisfacts/screens/FP00470/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 109행 · 메서드 15 · 종류 FLAG 31 · DATA_OP 16 · UI_PROP 9 · COMBO_DATA 8 · RETURN 7 · LIST_REBIND 7 · GRID_INIT 6 · POPUP 4 · STATE 4 · UI_MISC 4 · ENDPOINT 3 · MESSAGE 2 · VALUE_SET 2 · EXCEL 1 · CALL_BASE 1 · THROW 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 1


## FP00470_Master_Data_Validation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fc794f5 | this.btnSql.Click | FP00470_Master_Data_Validation.cs:299 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5ef36083 | this.btnSql.Click | FP00470_Master_Data_Validation.cs:300 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c4139f29 | this.btnSql.Click | FP00470_Master_Data_Validation.cs:302 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00470_MASTER_DATA_VALIDATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa87520e | this.btnSql.Click | FP00470_Master_Data_Validation.cs:303 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00470_Master_Data_Validation.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6c91d2e | (진입점 미연결) | FP00470_Master_Data_Validation.cs:508 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00470_Master_Data_Validation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfb10f0f | this.Load | FP00470_Master_Data_Validation.cs:253 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c74dd364 | this.Load | FP00470_Master_Data_Validation.cs:254 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-08d86b1d | this.Load | FP00470_Master_Data_Validation.cs:255 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00470_Master_Data_Validation.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eac343ea | this.Load | FP00470_Master_Data_Validation.cs:130 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-67d6339a | this.Load | FP00470_Master_Data_Validation.cs:131 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0729b539 | this.Load | FP00470_Master_Data_Validation.cs:132 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-653a3f1c | this.Load | FP00470_Master_Data_Validation.cs:136 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48cd9c88 | this.Load | FP00470_Master_Data_Validation.cs:137 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-51b1697d | this.Load | FP00470_Master_Data_Validation.cs:138 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00470_Master_Data_Validation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc88d0bb | Dispose | FP00470_Master_Data_Validation.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00470_Master_Data_Validation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3627a92f | EditButton | FP00470_Master_Data_Validation.cs:281 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7e4d45a | EditButton | FP00470_Master_Data_Validation.cs:282 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00470_Master_Data_Validation.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d853bdc | ExcelButton | FP00470_Master_Data_Validation.cs:292 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00470_Master_Data_Validation.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VALIDATION")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85bce680 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:390 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e296ff64 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:392 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-970fe01b | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:393 | try ▸ lambda | FLAG | pPlanDate | drpPlanDate.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-b3190bd7 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:394 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c26e0350 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:395 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5550d9 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:396 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf9cf509 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:397 | try ▸ lambda | FLAG | pProblemType | CString.GetCheckedListValue(dtProblemType, clbProblemType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-83c893f4 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:398 | try ▸ lambda | FLAG | pCheckUI | CString.GetCheckedListValue(dtCheckUI, clbCheckUI.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d192af77 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:417 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00470_MASTER_DATA_VALIDATION") ⇒ FP_Master.PR_UI_FP00470_MASTER_DATA_VALIDATION | 엔드포인트 요청 생성 |  |  |  |
| AC-16186098 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:418 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-105c111f | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:419 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8452df7e | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:420 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-61a56562 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:421 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f1d0d87 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:422 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-3092b942 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:424 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-c5844d6d | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:425 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate.Equals("ALL") ? DBNull.Value : pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-bac7f210 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:426 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-186940db | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:427 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-4c9cbd2d | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:428 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-316cdbd9 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:429 | try | DATA_OP | request.Parameters["p_check_category"] | pCheckCategory.Equals("ALL") ? DBNull.Value : pCheckCategory | 행/컬럼 값 대입 |  |  |  |
| AC-84be7130 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:430 | try | DATA_OP | request.Parameters["p_problem_type"] | pProblemType.Equals("ALL") ? DBNull.Value : pProblemType | 행/컬럼 값 대입 |  |  |  |
| AC-9326086f | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:431 | try | DATA_OP | request.Parameters["p_check_data"] | pCheckData.Equals("ALL") ? DBNull.Value : pCheckData | 행/컬럼 값 대입 |  |  |  |
| AC-90c181f6 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:432 | try | DATA_OP | request.Parameters["p_check_ui"] | pCheckUI.Equals("ALL") ? DBNull.Value : pCheckUI | 행/컬럼 값 대입 |  |  |  |
| AC-9a5853fb | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:433 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-a2034383 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:436 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69e441f4 | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:438 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c0a3420d | popSql.OnSql [if (programID == "PR_UI_FP00470_MASTER_DATA_VA… 외 1 | FP00470_Master_Data_Validation.cs:445 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00470_Master_Data_Validation.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49f8dcd9 | FindButton | FP00470_Master_Data_Validation.cs:311 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-36eb0c14 | FindButton | FP00470_Master_Data_Validation.cs:317 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c3dd0dc | FindButton | FP00470_Master_Data_Validation.cs:318 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-082d21f2 | FindButton | FP00470_Master_Data_Validation.cs:321 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-810f31da | FindButton | FP00470_Master_Data_Validation.cs:323 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-50b0f004 | FindButton | FP00470_Master_Data_Validation.cs:323 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ad40cf8 | FindButton | FP00470_Master_Data_Validation.cs:329 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5b27368e | FindButton | FP00470_Master_Data_Validation.cs:336 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a7b7f3ef | FindButton | FP00470_Master_Data_Validation.cs:338 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-398cc9b1 | FindButton | FP00470_Master_Data_Validation.cs:348 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cc3f2df9 | FindButton | FP00470_Master_Data_Validation.cs:349 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bd658358 | FindButton | FP00470_Master_Data_Validation.cs:352 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-492c0da8 | FindButton | FP00470_Master_Data_Validation.cs:356 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aee3fbb8 | FindButton | FP00470_Master_Data_Validation.cs:366 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-caa73cff | FindButton | FP00470_Master_Data_Validation.cs:367 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00470_Master_Data_Validation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-642106a4 | this.Load | FP00470_Master_Data_Validation.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00470_Master_Data_Validation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-406c1519 | this.Load | FP00470_Master_Data_Validation.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-92cd0dcd | this.Load | FP00470_Master_Data_Validation.cs:147 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-785ebfc6 | this.Load | FP00470_Master_Data_Validation.cs:152 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-54e2fa1b | this.Load | FP00470_Master_Data_Validation.cs:153 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-83d008bb | this.Load | FP00470_Master_Data_Validation.cs:155 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0c3ec0b9 | this.Load | FP00470_Master_Data_Validation.cs:155 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-876271ce | this.Load | FP00470_Master_Data_Validation.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-38e61ef7 | this.Load | FP00470_Master_Data_Validation.cs:158 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-bb91b949 | this.Load | FP00470_Master_Data_Validation.cs:158 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e38928a2 | this.Load | FP00470_Master_Data_Validation.cs:161 |  | FLAG | dtProblemType | DataCommon.GetUserFormCodeData(_FormProcedure, "ListLookup", "VALIDATION", "PROBLEM TYPE") ⇒ FP_Master.PR_UI_FP00470_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-262dd67b | this.Load | FP00470_Master_Data_Validation.cs:161 |  | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "ListLookup", "VALIDATION", "PROBLEM TYPE") ⇒ FP_Master.PR_UI_FP00470_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa36712d | this.Load | FP00470_Master_Data_Validation.cs:162 |  | LIST_REBIND | clsCtrl.setListBox | (dtProblemType, clbProblemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-535a5218 | this.Load | FP00470_Master_Data_Validation.cs:164 |  | FLAG | dtCheckUI | DataCommon.GetUserFormCodeData(_FormProcedure, "ListLookup", "VALIDATION", "UI") ⇒ FP_Master.PR_UI_FP00470_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-55b2f9c6 | this.Load | FP00470_Master_Data_Validation.cs:164 |  | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "ListLookup", "VALIDATION", "UI") ⇒ FP_Master.PR_UI_FP00470_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f42b4548 | this.Load | FP00470_Master_Data_Validation.cs:165 |  | LIST_REBIND | clsCtrl.setListBox | (dtCheckUI, clbCheckUI, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00470_Master_Data_Validation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91c59785 | this.Load | FP00470_Master_Data_Validation.cs:234 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8044bf0e | this.Load | FP00470_Master_Data_Validation.cs:235 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f9523d0d | this.Load | FP00470_Master_Data_Validation.cs:236 |  | UI_PROP | clbProblemType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6abfc68b | this.Load | FP00470_Master_Data_Validation.cs:237 |  | UI_PROP | clbCheckUI.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00470_Master_Data_Validation.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c2457f | this.Load 외 1 | FP00470_Master_Data_Validation.cs:262 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-780668d5 | this.Load 외 1 | FP00470_Master_Data_Validation.cs:264 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d355b069 | this.Load 외 1 | FP00470_Master_Data_Validation.cs:266 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00470_Master_Data_Validation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b36bf23f | popSql.OnSql | FP00470_Master_Data_Validation.cs:521 | if (programID == "PR_UI_FP00470_MASTER_DATA_VALIDATION") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-71fbdff5 | popSql.OnSql | FP00470_Master_Data_Validation.cs:524 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00470_Master_Data_Validation.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ccc570a | this.Load 외 3 | FP00470_Master_Data_Validation.cs:176 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | VALUE_SET | drpPlanDate.InitValue | (string)dtCurDate.Rows[0]["CUR_DATE"] | 컨트롤 값 설정 |  |  |  |
| AC-cd02221d | this.Load 외 3 | FP00470_Master_Data_Validation.cs:177 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(dtCurDate.Rows[0]["CUR_DATE"].ToString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-12edd9b4 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:182 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-382a54f6 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:183 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-e108ddeb | this.Load 외 3 | FP00470_Master_Data_Validation.cs:184 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-a01d184a | this.Load 외 3 | FP00470_Master_Data_Validation.cs:184 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-752d9767 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:185 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b3aebfe | this.Load 외 3 | FP00470_Master_Data_Validation.cs:189 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f83391e | this.Load 외 3 | FP00470_Master_Data_Validation.cs:190 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-cba139d9 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:191 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-88d3c23c | this.Load 외 3 | FP00470_Master_Data_Validation.cs:191 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstanc… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6261e6a | this.Load 외 3 | FP00470_Master_Data_Validation.cs:192 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c1a8013d | this.Load 외 3 | FP00470_Master_Data_Validation.cs:196 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcd90832 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:197 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-ad12f6a8 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:198 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-0dfc47e1 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:198 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef44cd21 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:199 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-42a8926a | this.Load 외 3 | FP00470_Master_Data_Validation.cs:220 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9627f716 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:221 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b9ad1ffd | this.Load 외 3 | FP00470_Master_Data_Validation.cs:222 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-546edc2f | this.Load 외 3 | FP00470_Master_Data_Validation.cs:223 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-a6559669 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:224 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf324f43 | this.Load 외 3 | FP00470_Master_Data_Validation.cs:224 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c00db4f | this.Load 외 3 | FP00470_Master_Data_Validation.cs:225 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "DIVISION" \|\| argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

