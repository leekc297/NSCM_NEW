# AS-IS 액션 대조표 — FP00590

> 원천: `Doc/asisfacts/screens/FP00590/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 4164행 · 메서드 275 · 종류 DATA_OP 1629 · FLAG 720 · RETURN 421 · UI_PROP 290 · MESSAGE 165 · GRID_SET 154 · ENDPOINT 142 · VALUE_SET 107 · GRID_INIT 100 · COMBO_DATA 96 · UI_MISC 79 · POPUP 56 · STATE 40 · GRID_LOCK 37 · CALL_EXT 37 · THROW 16 · GRID_STYLE 12 · VALIDATE 12 · GRID_BIND 10 · LIST_REBIND 9 · VALUE_CLEAR 9 · EXCEL 6 · CALL_BASE 5 · FOCUS 4 · LIST_CLEAR 4 · LIST_BIND 2 · GRID_COMBO 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 42


## FP00590_CapaValidationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9d62e52 | .ctor | FP00590_CapaValidationPopup.cs:106 |  | UI_PROP | SpdSheet.shtMain | sSheetName | 속성 shtMain 설정 |  |  |  |
| AC-3118caa6 | .ctor | FP00590_CapaValidationPopup.cs:107 |  | FLAG | _dsSheet | dsSheet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b900cd17 | .ctor | FP00590_CapaValidationPopup.cs:107 |  | DATA_OP | dsSheet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00590_CapaValidationPopup.btnCancel_Click

진입점: this.btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f2d3d4c | this.btnCancel.Click | FP00590_CapaValidationPopup.cs:212 |  | UI_PROP | this.DialogResult | DialogResult.Cancel | 속성 DialogResult 설정 |  |  |  |
| AC-aa7adc4f | this.btnCancel.Click | FP00590_CapaValidationPopup.cs:213 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_CapaValidationPopup.btnRelease_Click

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88596479 | this.btnRelease.Click | FP00590_CapaValidationPopup.cs:206 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1f8d45a0 | this.btnRelease.Click | FP00590_CapaValidationPopup.cs:207 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_CapaValidationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfce6687 | this.Load | FP00590_CapaValidationPopup.cs:157 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff029584 | this.Load | FP00590_CapaValidationPopup.cs:158 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ebf2e9a0 | this.Load | FP00590_CapaValidationPopup.cs:159 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_CapaValidationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b247ac1 | this.Load | FP00590_CapaValidationPopup.cs:151 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_CapaValidationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb934e5c | Dispose | FP00590_CapaValidationPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_CapaValidationPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3175497b | ExcelButton | FP00590_CapaValidationPopup.cs:222 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00590_CapaValidationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b497f2cb | this.Load | FP00590_CapaValidationPopup.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-72b2a8d6 | this.Load | FP00590_CapaValidationPopup.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00590_CapaValidationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58b83897 | this.Load | FP00590_CapaValidationPopup.cs:143 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e1c0f70 | this.Load | FP00590_CapaValidationPopup.cs:145 |  | VALUE_SET | lblTitle.Text | " Capa Validation" | 컨트롤 값 설정 |  |  |  |

## FP00590_CapaValidationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0292c61f | this.Load | FP00590_CapaValidationPopup.cs:171 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cccf05c6 | this.Load | FP00590_CapaValidationPopup.cs:172 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_CapaValidationPopup.SetGrid_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c237623 | this.Load | FP00590_CapaValidationPopup.cs:231 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12b04393 | this.Load | FP00590_CapaValidationPopup.cs:235 | try | GRID_BIND | siMain.Query | (_dsSheet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1b982371 | this.Load | FP00590_CapaValidationPopup.cs:240 | try ▸ if (_dsSheet.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00590_CapaValidationPopup.SetRowColor

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ec6162d | this.Load [try] | FP00590_CapaValidationPopup.cs:264 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMaterial.IndexOf("Load") != -1) | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 220, 180)) | 그리드 표시 설정 |  |  |  |
| AC-1879b0ef | this.Load [try] | FP00590_CapaValidationPopup.cs:268 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sMaterial.IndexOf("Load") != -1) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | System.Drawing.Color.FromArgb(255, 255, 255) | 그리드 속성/값 설정 |  |  |  |

## FP00590_CapaValidationPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfb6b3fb | this.Load [try] | FP00590_CapaValidationPopup.cs:183 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-660ae959 | this.Load [try] | FP00590_CapaValidationPopup.cs:184 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-0e2573c6 | this.Load [try] | FP00590_CapaValidationPopup.cs:188 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b11ee895 | this.Load [try] | FP00590_CapaValidationPopup.cs:189 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-976737c3 | this.Load [try] | FP00590_CapaValidationPopup.cs:191 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00590_GroupReleaseTotalPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c9f87a3 | .ctor | FP00590_GroupReleaseTotalPopup.cs:147 |  | UI_PROP | SpdSheet.shtMain | "ReleaseGroupTotalPopup" | 속성 shtMain 설정 |  |  |  |
| AC-8f216423 | .ctor | FP00590_GroupReleaseTotalPopup.cs:149 |  | FLAG | _sSite | sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-bf7e33c3 | .ctor | FP00590_GroupReleaseTotalPopup.cs:150 |  | FLAG | _sPlanGroup | sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-9c894d34 | .ctor | FP00590_GroupReleaseTotalPopup.cs:151 |  | FLAG | _sPlanDate | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-926aecd4 | .ctor | FP00590_GroupReleaseTotalPopup.cs:152 |  | FLAG | _sPlanID | sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-472b0742 | .ctor | FP00590_GroupReleaseTotalPopup.cs:153 |  | FLAG | _sIsSamePlanID | sIsSamePlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-544b9f40 | .ctor | FP00590_GroupReleaseTotalPopup.cs:154 |  | FLAG | _sDescription | sDescription | 화면 필드/플래그 변경 |  |  |  |

## FP00590_GroupReleaseTotalPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0327f32 | this.btnClose.Click | FP00590_GroupReleaseTotalPopup.cs:3184 | if (blnReleaseRun == true) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-fc499fd9 | this.btnClose.Click | FP00590_GroupReleaseTotalPopup.cs:3185 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_GroupReleaseTotalPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52ec0496 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3191 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e51790bb | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3192 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1f835bac | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3194 |  | DATA_OP | popSql.Services.Add | ("SELECT_GROUP_RELEASE_TOTAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-715b4ad2 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3195 |  | DATA_OP | popSql.Services.Add | ("CONFIRM_GROUP_VALIDATION_1") | 데이터 객체 조작/조회 |  |  |  |
| AC-f62b206b | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3196 |  | DATA_OP | popSql.Services.Add | ("CONFIRM_GROUP_VALIDATION_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab712c18 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3197 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_GROUP_RELEASE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8d711f0 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3198 |  | DATA_OP | popSql.Services.Add | ("UPDATE_GROUP_DIVISIONLIST") | 데이터 객체 조작/조회 |  |  |  |
| AC-76b921e0 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3199 |  | DATA_OP | popSql.Services.Add | ("INSERT_RUNNING_RELEASE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d61b4e30 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3200 |  | DATA_OP | popSql.Services.Add | ("DELETE_RUNNING_RELEASE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e996d8e5 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3201 |  | DATA_OP | popSql.Services.Add | ("RELEASE_GROUP_VALIDATION_1") | 데이터 객체 조작/조회 |  |  |  |
| AC-785c6942 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3202 |  | DATA_OP | popSql.Services.Add | ("RELEASE_GROUP_VALIDATION_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-8776bd6a | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3203 |  | DATA_OP | popSql.Services.Add | ("UPDATE_GROUP_RELEASE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-986960db | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3204 |  | DATA_OP | popSql.Services.Add | ("UPDATE_GROUP_RELEASE_PLANLIST_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-5de7a1c1 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3205 |  | DATA_OP | popSql.Services.Add | ("INSERT_HIST_GROUP_DETAIL") | 데이터 객체 조작/조회 |  |  |  |
| AC-827699b2 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3206 |  | DATA_OP | popSql.Services.Add | ("INSERT_OT_NET_JOB") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee399d73 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3207 |  | DATA_OP | popSql.Services.Add | ("EXEC_SENDMAIL_FINALTOTAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-21b7087a | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3208 |  | DATA_OP | popSql.Services.Add | ("EXEC_SEND_SMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-d081c44d | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3209 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_MES_ERP_WO_MASTER") | 데이터 객체 조작/조회 |  |  |  |
| AC-5476c0d0 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3210 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dd75352 | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3211 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5012adf | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3212 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-421fa06d | this.btnSql.Click | FP00590_GroupReleaseTotalPopup.cs:3214 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Check_CapaValidation

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec63731a | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3584 | if (dtInstance.Rows[0]["CAPA_VALIDATION"].ToString() != "Y") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-8980353f | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3604 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecbe41ae | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3609 | if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b764a47f | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3614 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CapaValidation", _sPlanGroup, _sPlanID, _sPlanDate, _sPlanE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80c3649b | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3630 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | POPUP | new FP00590_CapaValidationPopup | ("CapaValidationPopup", dtCapaValid.DataSet) | 팝업/폼 생성 |  |  |  |
| AC-addb309f | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3631 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | UI_PROP | popCapaValid.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-f67e8c39 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3632 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | UI_PROP | popCapaValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f2ffdba | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3634 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | POPUP | popCapaValid.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7ccf8496 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3636 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) ▸ if (popCapaValid.ShowDialog() == DialogResult.OK) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-c8d4080b | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3642 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) ▸ else of (popCapaValid.ShowDialog() == DialogResult.OK) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ae36d41b | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3647 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Check_ConfirmValidation

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba02569c | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3534 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b15a58d8 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3542 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | POPUP | new FP00590_ValidationPopup | ("GroupConfirmValid1Popup", dsValid_1) | 팝업/폼 생성 |  |  |  |
| AC-c200b2c8 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3543 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | UI_PROP | popConfirmValid1.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6b670777 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3544 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | POPUP | popConfirmValid1.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7012e7ed | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3545 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-90f38dab | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3559 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c86b97b6 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3565 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | POPUP | new FP00590_ValidationPopup | ("GroupConfirmValid2Popup", dsValid_2) | 팝업/폼 생성 |  |  |  |
| AC-0bb01efe | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3566 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | UI_PROP | popConfirmValid2.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e7de7887 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3567 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | POPUP | popConfirmValid2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a931055c | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3568 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e4b5e3a6 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3572 | if (dsValid_2 != null) ▸ else of (dsValid_2.Tables[0].Rows.Count > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-af53df3b | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3576 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Check_Exec_IsRunningEngine

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3abb2edd | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3338 | switch (sType) case "SELECT_INIT": | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release", _sPlanGroup, p_facoty_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd30ebac | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3345 | switch (sType) case "SELECT_INIT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10f9fb8f | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3346 | switch (sType) case "SELECT_INIT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-38e6a1ce | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3372 | switch (sType) case "INSERT": ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7c22d8ed | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3377 | switch (sType) case "INSERT": | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b118d4ee | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3398 | switch (sType) case "SELECT": | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release", _sPlanGroup, p_facoty_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7e0f06a7 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3409 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) ▸ for (i < dtIsRunRelease.Rows.Count) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2342ddd1 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3410 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) ▸ for (i < dtIsRunRelease.Rows.Count) ▸ if … | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9100f532 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3412 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) ▸ for (i < dtIsRunRelease.Rows.Count) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bf7101ba | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3417 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ else of (dtIsRunRelease.Rows.Count > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0a81c864 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3440 | switch (sType) case "DELETE": ▸ else of (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b5564487 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3443 | switch (sType) case "DELETE": | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1aa284ca | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3446 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Check_isConfirmed

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6e55069 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3481 | if (iCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_Group_isConfirmed", p_sql, _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5fa3c1aa | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3503 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ if (dtConfirm.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d6e8060 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3504 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ if (dtConfirm.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eb5d6cc5 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3508 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ else of (dtConfirm.Rows.Count > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0de623b8 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3512 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Check_IsPastDate

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3cc4934 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3655 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isPast", _sSite, _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fed9075c | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3663 | if (dtPastdate != null) ▸ if (dtPastdate.Rows.Count > 0) ▸ if (dtPastdate.Rows[0]["DATE_VALID"].ToString() == "Y") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-68621b00 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3669 | if (dtPastdate != null) ▸ if (dtPastdate.Rows.Count > 0) ▸ else of (dtPastdate.Rows[0]["DATE_VALID"].ToString() == "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8a279317 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:3675 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b78dda4 | this.Load | FP00590_GroupReleaseTotalPopup.cs:272 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7897774b | this.Load | FP00590_GroupReleaseTotalPopup.cs:273 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0acbdf5c | this.Load | FP00590_GroupReleaseTotalPopup.cs:274 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_GroupReleaseTotalPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aec58902 | this.Load | FP00590_GroupReleaseTotalPopup.cs:266 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Delete_Is_Running_Release

진입점: this.btnSave.Click [try ▸ switch (sType) case "DELETE":] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ if (programID == "DELETE_RUNNING_RELEASE") ▸ if (bCheck == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d447b17a | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2257 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-1455cdca | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2258 | try | FLAG | p_sys_flag | "DELETE_RUNNING_RELEASE" | 화면 필드/플래그 변경 |  |  |  |
| AC-814e46d9 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2259 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d6a8c327 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2260 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-9c7f6230 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2261 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-3993682a | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2263 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4a08e211 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2267 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-3b6c11f4 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2268 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b748a568 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2270 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e88fe826 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2271 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bd38ebfe | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2272 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d8fea7ef | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2273 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f3bb932 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2275 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ecb74446 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2276 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b98af83 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2277 | try | DATA_OP | req.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-8ae67290 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2278 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e039bcb | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2279 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4601276 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2280 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb04e41e | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2281 | try | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1219372d | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2282 | try | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0672383 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2283 | try | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8274a8a5 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2284 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-41a29056 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2285 | try | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-addedf8c | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2286 | try | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-90a3bc55 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2287 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-71c34971 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2288 | try | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42c9489e | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2289 | try | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d61eaf71 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2290 | try | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8fb4379f | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2291 | try | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-680e1834 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2292 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9df363bf | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2293 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-456dd555 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2295 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b89838c1 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2296 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-009be0b0 | this.btnSave.Click [try ▸ switch (sType) case "DELETE":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2302 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b423673 | Dispose | FP00590_GroupReleaseTotalPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_GroupReleaseTotalPopup.EditButton

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ if (ds != null)] / this.btnFind.Click [try ▸ if (ds != null)] / this.Load [try ▸ if (ds != null)] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b490685 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:346 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-9291d207 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:348 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8d6f33ed | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:352 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SITE_ID), siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6cc004a8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:353 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ISENABLE), siMain.GetColumnIndex(DefColumns.ISCHK), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6898752f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:363 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_ID… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.CHK), i, siMain.GetColumnIndex(DefColumns.CONFIRM_FLA… | 그리드 편집 잠금 전환 |  |  |  |
| AC-38348ddc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:364 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_ID… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.ISENABLE), i, siMain.GetColumnIndex(DefColumns.ISCHK)… | 그리드 편집 잠금 전환 |  |  |  |
| AC-059749b3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:368 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |
| AC-7284d538 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:372 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_MES_ERP_WO_MASTER

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ else of (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80f7a17d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2642 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e512921c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2649 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_GroupReleasePlanList"… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c5a640ae | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2649 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_GroupReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sP… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a88b2b3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2651 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-6c0d7b02 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2652 | try | FLAG | p_sys_flag | "EXECUTE_MES_ERP_WO_MASTER" | 화면 필드/플래그 변경 |  |  |  |
| AC-258f21dd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2653 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1bb8feb5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2654 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-46cf5bbc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2667 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-77812755 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2668 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2d8dc2ae | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2670 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-add751e3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2671 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-36572a43 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2672 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-289ffb9e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2673 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-efee0984 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2675 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-201322a2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2676 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8a379a2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2677 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89a7e35c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2678 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a709b2be | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2679 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f3c1cb9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2680 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-96e6e97b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2681 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fba0978d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2682 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4950efa5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2683 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10e5d7f5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2684 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dae73e33 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2685 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-61f70c80 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2686 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b42f89ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2687 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf169c62 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2688 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-362a15cd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2689 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f804b04 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2690 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-464db19f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2691 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1629373 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2692 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8270ad5c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2693 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-5a2e188e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2695 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7381d6b9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2701 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-65bc100a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2706 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_PR_SCM_OF_ASSY_ELEC_REPORT

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf2ee41b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2814 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-5596ff20 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2815 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-7f883bc5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2816 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-b9f06541 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2817 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2d35126 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2818 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f847a6a3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2820 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6b31a0a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2821 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2f567d0a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2822 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-29b27a94 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2823 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-1c0ab991 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2824 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73f4be70 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2825 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6a99d8f8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2826 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8890d94d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2827 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-629b7608 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2828 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01bffe40 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2829 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8260b9d5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2830 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0675c51f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2831 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81b52dac | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2832 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f32b8c02 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2833 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9f8c709 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2834 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c07f626 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2835 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f639c52d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2836 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1f6ffe0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2837 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4efaa599 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2838 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e7de4dd5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2840 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-04ef188e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2842 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-21e8ef8a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2847 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_PR_SCM_OF_CELL_DELIVERY_PLAN

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84a91f54 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3028 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6dadc61a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3032 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-6a7e1d70 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3033 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-8678a065 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3034 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN" | 행/컬럼 값 대입 |  |  |  |
| AC-9771be2a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3035 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-19b2f22d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3036 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4346fb03 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3038 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b37dea8b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3039 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46d6aef5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3040 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2738901 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3041 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-cfcc2009 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3042 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d195bbb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3043 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7dfcb2ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3044 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8df7cd51 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3045 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad44e9bc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3046 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1147fa6c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3047 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0de2021f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3048 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28df913e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3049 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-80f44c9f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3050 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb1d1978 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3051 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5cfbbfc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3052 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a38b1be | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3053 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76c6882a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3054 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da267665 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3055 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c27dbe7f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3056 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-9f8be08d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3058 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-090e6919 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3060 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-12ad88f2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3065 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_PR_SCM_OF_PACK_REQUIRE_CEL

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["PACK_INHOUSE_OPTION"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47c38206 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2872 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a37eaa5d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2876 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-4cc759bf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2877 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-0b4ebfb4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2878 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL" | 행/컬럼 값 대입 |  |  |  |
| AC-af21c2db | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2879 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05b818b1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2880 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e9ac64d4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2882 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10534e1a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2883 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7d15100a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2884 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f90aeca3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2885 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-029d701d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2886 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f76dfbbb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2887 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce4812b6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2888 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e7483356 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2889 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-990870a2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2890 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6975b7b7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2891 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-82585d8e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2892 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c7cec42b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2893 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-86eb6696 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2894 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dae6a324 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2895 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91a5d1d8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2896 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2bccb0e2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2897 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b4310559 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2898 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-77cdd47b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2899 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b8b5c36 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2900 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-422aee3d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2902 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fd85743 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2904 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-167646da | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2909 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_PR_SCM_OF_PACK_TO_CELL

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["PACK_INHOUSE_OPTION"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-395979f2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2938 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-997c91ce | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2945 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_GroupReleasePlanList"… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7400caa7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2945 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_GroupReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sP… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09eee54a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2947 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-d56ea6c6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2948 | try | FLAG | p_sys_flag | "EXECUTE_PR_SCM_OF_PACK_TO_CELL" | 화면 필드/플래그 변경 |  |  |  |
| AC-ab310a4d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2949 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a8daa659 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2950 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-33e21625 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2965 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-9ae7e78f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2966 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b65b5cba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2968 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-254532cf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2969 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6badb1c2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2970 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a17e9b40 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2971 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c8137c2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2973 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d914d094 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2974 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a30af6e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2975 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c5fdaaf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2976 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-fa117e9b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2977 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1f8e58d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2978 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-dda68dec | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2979 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7997f921 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2980 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65b6c04f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2981 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b4cbb033 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2982 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1544ffd6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2983 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7744cc44 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2984 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbdd6bc3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2985 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2bad9a22 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2986 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-823e9023 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2987 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-af0efc68 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2988 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c7e632c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2989 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a0a11d8e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2990 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e87339d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2991 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-048f66fb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2993 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3b64035 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2999 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f3f7853c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3004 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_PR_SCM_PIC_ALARM

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88c33c64 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3101 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "INSTANCE_OPTION", _sSite, _sPlanGroup, _sPlanDate, _sPlanID, sFactory_LT… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d18c06d2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3103 | try ▸ if (dtTmp.Rows[0]["PIC_ALARM"].ToString() != "Y") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8306bf5d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3105 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-328383f5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3106 | try | FLAG | p_sys_flag | "PR_SCM_PIC_ALARM" | 화면 필드/플래그 변경 |  |  |  |
| AC-578ebd79 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3107 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c10772ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3108 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-2ff1bd3f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3121 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-90295842 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3122 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-aea17b1a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3124 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-04aee5e6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3125 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b2fa1849 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3126 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-bb4962aa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3127 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a7d9184 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3129 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a611953c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3130 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2caa2c25 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3131 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-64a5bd21 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3132 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-4e5c0589 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3133 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-64cb9a1a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3134 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-4b3ef245 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3135 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2003e239 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3136 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d6dd555 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3137 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3100d5e4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3138 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e5fdf95d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3139 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6cb40421 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3140 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6071f251 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3141 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b5fcfa4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3142 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28a2f45c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3143 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4b4ca127 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3144 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ffb27126 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3145 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74d7f886 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3146 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5c369d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3147 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1d9d455d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3149 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0887dd89 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3155 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-7830feba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:3160 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_Release_Main

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c32f602c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1240 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ if (dsResult.Tables[idx].Rows.Count > 0) ▸ else of … | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8a7c81e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1242 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ if (dsResult.Tables[idx].Rows.Count > 0) ▸ else of … | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-1dc68ac1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1250 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ else of (dsResult.Tables[idx].Rows.Count > 0) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-528ec93e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1252 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ else of (dsResult.Tables[idx].Rows.Count > 0) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-728c2350 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1262 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ else of (dsResult != null) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-0cc940cd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1264 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ else of (dsResult != null) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-80795623 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1283 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsAll != null) ▸ if (dsAll.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-41b5f63e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1286 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsAll != null) ▸ if (dsAll.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-79978890 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1319 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (Find_Duplicate_Check(sInstance, sFactory) == false) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-bbb641e0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1335 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsRelease != null) ▸ if (dsRelease.Tables[0].Rows[0][0].ToString() != "0") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c801bdbb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1338 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsRelease != null) ▸ if (dsRelease.Tables[0].Rows[0][0].ToString() != "0") | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-fa70b66b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1345 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ else of (dsRelease != null) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-30efde7d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1346 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ else of (dsRelease != null) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-e1a32389 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1362 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsSendMail != null) ▸ if (dsSendMail.Tables[0].Rows[0][0].ToString() != "1") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-9052b706 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1373 | try ▸ if (iCount == 0) | MESSAGE | MessageBox.Show | ("Please, check row!. Check Row Count is Zero!", "Warning", MessageBoxButtons.OK, MessageB… | 메시지 표시 |  |  |  |
| AC-0325b081 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1374 | try ▸ if (iCount == 0) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-23e677a6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1387 | try ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F") | RETURN | return "PROCEED"; |  | 처리 중단/반환 |  |  |  |
| AC-11f5de9d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1390 | try | RETURN | return "PROCEED"; |  | 처리 중단/반환 |  |  |  |
| AC-50a551cc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1395 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-3b33ba9e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1396 | catch ((Exception ex)) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_Release_Plan

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex())] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ if (programID == "EXECUTE_GROUP_RELEASE") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !string.IsNullOrEmpty(siMain.Ge…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d416c3d4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1586 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-d5c892ba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1587 | try | FLAG | p_sys_flag | "EXECUTE_GROUP_RELEASE" | 화면 필드/플래그 변경 |  |  |  |
| AC-f8585e4d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1588 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9d14794f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1589 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-1373e432 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1590 | try | FLAG | p_division_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-45cd1ad3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1591 | try | FLAG | p_site_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e4f289ad | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1592 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5bc6d659 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1593 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2fcbfe9b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1594 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3de3182 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1595 | try | FLAG | p_plan_id | txtPlanID.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f9b4b621 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1596 | try | FLAG | p_flag | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FLAG)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b1750cc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1597 | try | FLAG | p_insert_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSERT_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-31923678 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1598 | try | FLAG | p_release_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.RELEASE_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-dc3bb331 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1599 | try | FLAG | p_is_enable_rel | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d61818a1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1600 | try | FLAG | p_confirm_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-25ebc25b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1601 | try | FLAG | p_confirm_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-34827ccb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1602 | try | FLAG | p_description | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4936d9b6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1603 | try | FLAG | p_isenable | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISENABLE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-475f29e9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1604 | try | FLAG | p_ischk | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISCHK)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-605c9737 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1605 | try | FLAG | p_next_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-20ac4147 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1606 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-43835ba2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1607 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d0d00b3a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1609 | try | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b96d645b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1609 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-638dd788 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1616 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9db57f3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1619 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd15688f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1619 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-378ab703 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1623 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0d9a305 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1626 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ if (dtResult.Rows.Count > 0) | FLAG | p_plan_type | dtResult.Rows[0]["PLAN_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b11460c9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1628 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-32260768 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1632 | try ▸ if (dtPlanID != null) ▸ else of (dtPlanID.Rows.Count > 0) | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-72ceeffc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1638 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-e459a696 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1639 | try | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cfd1bc3d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1641 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b8c444c0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1642 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-620588cb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1643 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-2b4a8137 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1644 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-306cb28d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1646 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-70287b54 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1647 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d442569f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1648 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf87b3b1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1649 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c8ce785 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1650 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-3ea6da34 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1651 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-07e85efb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1652 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3af327c4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1653 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-e463e2c1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1654 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-1e740285 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1655 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-a07c9f05 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1656 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-99da2621 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1657 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-20db1730 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1658 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f5c5326f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1659 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-99a49ee8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1660 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-9075850b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1661 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-45105069 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1662 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e56a245a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1663 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-861beb09 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1664 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-77af6a68 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1666 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-285e94b8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1667 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dd6f4094 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1674 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-66a5b69b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1675 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_Release_Queue

진입점: this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5492e9f6 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1129 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-e2bbd3bd | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1130 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4e56bd11 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1132 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e2ed8b11 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1133 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9108241f | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1134 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-03716821 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1135 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bce0bd5e | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1137 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c32c0ebc | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1138 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b204a778 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1139 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ca7d4e2 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1140 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-83443870 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1141 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-9055840a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1142 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-96352d3a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1143 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c8a2a536 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1144 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-2da03adf | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1145 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-d41a3ce0 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1146 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-239188ca | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1147 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a912ff1 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1148 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-d4e00e2e | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1149 | try | DATA_OP | req.Parameters["p_description"] | p_description.Replace("'", "''") | 행/컬럼 값 대입 |  |  |  |
| AC-e54e4e3e | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1150 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-41a8cbf9 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1151 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-67703510 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1152 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7d6d618 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1153 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1ec5e9b6 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1154 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-90398ca7 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1155 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c397f561 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1157 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99068b9e | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1158 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-93186c73 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_GroupReleaseTotalPopup.cs:1166 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_RollBack_Release

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if (dsReleaseValid_1 != null) ▸ if (dsReleaseValid_1.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb9f9f37 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1849 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-607b7f3d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1850 | try | FLAG | p_sys_flag | pSysFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-8a12fdb7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1851 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0e171ed9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1852 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-3e24d52b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1853 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4ae49a1c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1854 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-914f38be | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1855 | try | FLAG | p_factory_id | sFactory_LT | 화면 필드/플래그 변경 |  |  |  |
| AC-9bd52aa3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1856 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-d787f305 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1857 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-9e3cf6d5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1858 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-0381fb03 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1859 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fe12c942 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1860 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5344daf1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1861 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-16a001d5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1862 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-956b1ec6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1863 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4005a514 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1864 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1f8a2f32 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1865 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fc9af259 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1866 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c8533767 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1867 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-763f53e3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1868 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0a51d6e1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1869 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1cbc65bf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1870 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c16bc985 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1874 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-0609fc22 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1875 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-00dfd564 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1877 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6de4a9ff | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1878 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d1185553 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1879 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e5f107f9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1880 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a4eb5279 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1882 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5affb808 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1883 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-67295a3d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1884 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d6e9348 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1885 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d7a5de7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1886 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-8938265e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1887 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ce2433c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1888 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-62781899 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1889 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-998a4e13 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1890 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-0e1f2a6b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1891 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-575d125a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1892 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-6eb6f3eb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1893 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-9a9268bb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1894 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-d4f7ee1f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1895 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-3287a3b6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1896 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-470dbfb4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1897 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-a86050f1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1898 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e6421198 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1899 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-de90e764 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1900 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-af32bf3b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1902 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0557cc38 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1903 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-56d5535f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1910 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_Send_Mail_Quantity_Check

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cb6aeb6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1690 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-24ca33d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1691 | try | FLAG | p_sys_flag | "EXECUTE_GROUP_SENDMAIL_QUANTITY_CHECK" | 화면 필드/플래그 변경 |  |  |  |
| AC-fd4a3e0e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1692 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9c9be124 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1693 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-092c6d44 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1694 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2315bb52 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1695 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-31472c8b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1696 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d4dd22dc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1701 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-5cd8b296 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1702 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c48b1296 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1704 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a34c9bd1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1705 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c88f5023 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1706 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f5891d9e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1707 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a0e586d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1709 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f890c7b4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1710 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2bceef99 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1711 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-dbcc39b4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1712 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-4894697e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1713 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-5187760e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1714 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e4071782 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1715 | try | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e13b18f7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1716 | try | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7ccf13c1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1717 | try | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c3da51db | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1718 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6346a901 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1719 | try | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8324d7f5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1720 | try | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb41dbcd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1721 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28e9b39d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1722 | try | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5fcb8d2d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1723 | try | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9ded0dc1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1724 | try | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fafd309b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1725 | try | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5b6da91f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1726 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b3b8d448 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1727 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-4486afa4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1729 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c1806927 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1730 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7a5ea9e5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1737 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_Send_SMS

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e21df34 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2548 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f023e81e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2555 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_GroupReleasePlanList"… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fe65e03c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2555 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_GroupReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sP… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c80097a9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2557 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-e76a82ab | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2558 | try | FLAG | p_sys_flag | "EXECUTE_SMS" | 화면 필드/플래그 변경 |  |  |  |
| AC-fff54397 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2559 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2a501a79 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2560 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-6e35933e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2576 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-4ee114ec | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2577 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bc5a9f05 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2579 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-77d6b9b4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2580 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-28528351 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2581 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-2f33d445 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2582 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec3f3c19 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2584 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-953784ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2585 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76a955d0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2586 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | sFacoty | 행/컬럼 값 대입 |  |  |  |
| AC-6c10e95b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2587 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-48697c0d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2588 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8350b4fb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2589 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-eeb09389 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2590 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-643c98eb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2591 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b559084 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2592 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d355b008 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2593 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9f3a6db | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2594 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45579fdf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2595 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-311fa9fa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2596 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c9a8903c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2597 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-770ccfbd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2598 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-63c02e9b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2599 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad62329c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2600 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b87eeb76 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2601 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e70a6b1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2602 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-f7af8cff | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2604 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f52ce15 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2610 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-84034eb8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2615 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Exec_SendMail_FinalTotal

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89e96302 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2397 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-b304c3a7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2398 | try | FLAG | p_sys_flag | "EXECUTE_GROUP_RELEASE_PLAN_SEND" | 화면 필드/플래그 변경 |  |  |  |
| AC-c2b97acf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2399 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0ed951d0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2400 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-5480d767 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2419 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-b810c48b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2420 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2adfbcfa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2422 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1c53b0cb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2423 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c2437030 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2424 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-7a4e098f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2425 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd2bf4aa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2427 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50603b74 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2428 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5dac55ba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2429 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_factory_id"] | sFacoty | 행/컬럼 값 대입 |  |  |  |
| AC-7ad62169 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2430 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-73b7cbba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2431 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-23474b87 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2432 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6e98b42 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2433 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fd8116ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2434 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b885ffbb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2435 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-125a2c32 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2436 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cbc72a0c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2437 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d26ddcc9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2438 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-24ffd2ce | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2439 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_description"] | sDescription | 행/컬럼 값 대입 |  |  |  |
| AC-1e391c5e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2440 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cbf044ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2441 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-433b9a27 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2442 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2faede05 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2443 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-29458297 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2444 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c100aa9f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2445 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e123545f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2447 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2017e11 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2453 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-65945e1e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:2458 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Execute_Calcuration

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3099d53c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1434 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-49e0a698 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1435 | try | FLAG | p_sys_flag | "EXECUTE_GROUP_CALCURATION" | 화면 필드/플래그 변경 |  |  |  |
| AC-67665104 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1436 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0a8e65e5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1437 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-bb8c2ab1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1438 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7ed96046 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1439 | try | FLAG | p_site_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6cc458dc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1440 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-09bfd0fa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1441 | try | FLAG | p_instance_id | pPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-598ace79 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1442 | try | FLAG | p_plan_date | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-80c2c398 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1443 | try | FLAG | p_plan_id | pPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-3eb00ec7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1444 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e633d8c5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1445 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dc591964 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1446 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c5217300 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1447 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2967b0be | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1448 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-842b3bf2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1449 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dbe073f4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1450 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-60f1e67d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1451 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-030f49ab | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1452 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-22ee1d04 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1453 | try | FLAG | p_next_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-34112f92 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1454 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2c5f6139 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1455 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dc64db96 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1460 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-94dd341a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1461 | try | UI_PROP | req.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4b18b859 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1463 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d8b46ed2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1464 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-19e57813 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1465 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-983e27dd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1466 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-352c980f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1468 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7588e0d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1469 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f531434 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1470 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2577fa4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1471 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-a62ac1d3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1472 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b944c645 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1473 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-9e5eea49 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1474 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-471159c8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1475 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-fd3927bf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1476 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-5903ee8b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1477 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-e6aea058 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1478 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a127ec5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1479 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-d7eb4860 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1480 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-b2a137ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1481 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-087a24df | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1482 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-a36e00be | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1483 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-41c9809c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1484 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-99274be4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1485 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f15e709f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1486 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-75d9ff1d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1488 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c93a4768 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1489 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ccb3a9da | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1495 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-e2f102c7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1496 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Find_Confirm_Valid

진입점: this.btnSave.Click [try] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ if (programID == "CONFIRM_GROUP_VALIDATION_1")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07a5518a | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2314 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c67a7518 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2319 | try ▸ if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-08ab5ab9 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2332 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ed228a53 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2344 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c0a10de9 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2348 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-565439e2 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2349 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-651d860c | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2350 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-473950cb | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2351 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-698b5191 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2352 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-22f0be71 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2354 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31c98ace | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2355 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-f492ff61 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2356 | try | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-14b9eb88 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2357 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-202cad75 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2358 | try | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-bbea8146 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2359 | try | DATA_OP | request.Parameters["p_plan_id"] | _sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-92813d29 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2360 | try | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-86518795 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2361 | try | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6a1f252e | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2362 | try | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-801ee0d0 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2363 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6dd9e0e4 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2364 | try | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0726531c | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2365 | try | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-abbb86f3 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2366 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4283ffea | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2367 | try | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4db6ed52 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2368 | try | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a66650dd | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2369 | try | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-519b2414 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2370 | try | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-08841474 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2371 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5f6c7428 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2372 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c6157391 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2374 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f442d331 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2376 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7d4f9f05 | this.btnSave.Click [try] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2381 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Find_Data_Sub

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_GROUP_RELEASE_TOTAL")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5432b225 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:479 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-dc360014 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:480 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-6ca4942b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:481 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_GROUP_RELEASE_TOTAL" | 행/컬럼 값 대입 |  |  |  |
| AC-9579c57f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:482 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a2a98cda | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:483 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-63328378 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:485 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8646ea7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:486 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-204cb05c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:487 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d5c04bd3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:488 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-d6f795b4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:489 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-2dfdde04 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:490 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-ddb90484 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:491 | try | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-91765ca3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:492 | try | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7ddf8e0a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:493 | try | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3a332bba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:494 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-168a3fd4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:495 | try | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-66751abe | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:496 | try | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ef21800c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:497 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-538b9f43 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:498 | try | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-46bdc667 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:499 | try | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6522d4b7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:500 | try | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-214f9bf1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:501 | try | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c654828a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:502 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a44fde83 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:503 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-526f59ca | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:505 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4b782df | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:507 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b51ac2db | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 3 | FP00590_GroupReleaseTotalPopup.cs:512 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Find_Duplicate_Check

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23f818c0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1405 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_dupGroupReleaseCheck", pInstanceId, pFactoryId) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-185a9282 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1414 | if (dtDuplication != null) ▸ if (dtDuplication.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3a4cf33 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_GroupReleaseTotalPopup.cs:1421 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Find_Release_Plan_List_2

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked)] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_GROUP_VALIDATION_1") ▸ else of (programID == "RELEASE_GROUP_VALIDATION…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c77b07dd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2125 | try ▸ if (iCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_GroupReleasePlanList2", _sSite, _sPlanGroup, _sPlanDate, _s… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f88e0f3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2132 | try ▸ if (iCount > 0) | RETURN | return dtReleasePlanList2; |  | 처리 중단/반환 |  |  |  |
| AC-adc44b6e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2136 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-df6458f7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2141 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Find_Release_Valid

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F")] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ if (programID == "RELEASE_GROUP_VALIDATION_1")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c67e8ca5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1750 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58066183 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1755 | try ▸ if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count >0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1db1e29a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1785 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-745db70d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1786 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-14c42101 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1787 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-ed553142 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1788 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6c7b18a0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1789 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4c00d57f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1791 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-53b62d93 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1792 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-67e0ea91 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1793 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-60b84091 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1794 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-80a645d3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1795 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-ee2abebe | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1796 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_id"] | sPlanID_LT | 행/컬럼 값 대입 |  |  |  |
| AC-b1d9e733 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1797 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b8c16177 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1798 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a8fe0ddc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1799 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3988d781 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1800 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd7d37fb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1801 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1b763727 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1802 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-754c6439 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1803 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d3bddd17 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1804 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2f6bb640 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1805 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4fd05a6b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1806 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-39e6bf37 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1807 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8fb2ee9f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1808 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-78177a13 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1809 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-10dd69a0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1811 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-546cb5ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1813 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bca13b0b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1818 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0676b4b0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1823 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.FindData_Sub

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")] / this.btnFind.Click / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8848b69 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:394 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8f3dcd6d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:400 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-93d067dc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:400 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-824dcd99 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:405 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-96a70e6a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:408 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d486001b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:414 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-df123fa3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:416 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Sub("SELECT", pSite, pPlanGroup, pPlanDate, pPlanID) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f6d48a57 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:424 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9854c8c7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:429 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ad39321 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:438 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-95d68645 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:441 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2fa6e4e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:449 | try ▸ if (ds != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-91f8cc53 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:453 | try ▸ if (ds != null) ▸ for (i < row_count) | GRID_SET | siMain.ActiveSheet.Rows[i].Height | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-2c0b7e4e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:463 | catch () | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-caeb794c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:467 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d63408c9 | this.Load | FP00590_GroupReleaseTotalPopup.cs:165 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca378e80 | this.Load | FP00590_GroupReleaseTotalPopup.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bcc3fca1 | this.Load | FP00590_GroupReleaseTotalPopup.cs:179 | if (string.IsNullOrEmpty(_sPlanGroup)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Parameter: Plan Group(Instance) is Null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec1f94d3 | this.Load | FP00590_GroupReleaseTotalPopup.cs:180 | if (string.IsNullOrEmpty(_sPlanGroup)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26d2cd67 | this.Load | FP00590_GroupReleaseTotalPopup.cs:184 | if (string.IsNullOrEmpty(_sPlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Parameter: Plan Date is Null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54a1ef63 | this.Load | FP00590_GroupReleaseTotalPopup.cs:185 | if (string.IsNullOrEmpty(_sPlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24215959 | this.Load | FP00590_GroupReleaseTotalPopup.cs:189 | if (string.IsNullOrEmpty(_sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Parameter: Plan ID is Null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14c889cd | this.Load | FP00590_GroupReleaseTotalPopup.cs:190 | if (string.IsNullOrEmpty(_sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.FP00590_GroupReleaseTotalPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1ab266e | this.FormClosing | FP00590_GroupReleaseTotalPopup.cs:3268 | if (blnReleaseRun == true) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Get_FactoryDescription

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ if (dtReleasePlanList2.Rows.Count > 0) ▸ for (i < dtReleasePlanList2.Rows.Count)] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_GROU…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d64bf8e6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3692 |  | RETURN | return sRtnValue; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.GetPlanType

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc252e80 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:520 |  | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6890f70e | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:520 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2f829b72 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:527 | if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d22dd31 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:530 | if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dda53417 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:530 | if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd30aa43 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:534 | if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b0a0724 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:537 | if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ if (dtResult.Rows.Count > 0) | FLAG | _sPlanType | dtResult.Rows[0]["PLAN_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f297584 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:539 | if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | _sPlanType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b2e238d8 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:543 | if (dtPlanID != null) ▸ else of (dtPlanID.Rows.Count > 0) | FLAG | _sPlanType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-785b8f52 | this.btnSave.Click [try] | FP00590_GroupReleaseTotalPopup.cs:547 |  | RETURN | return _sPlanType; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b0f0b4c | this.Load | FP00590_GroupReleaseTotalPopup.cs:220 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d6adf41 | this.Load | FP00590_GroupReleaseTotalPopup.cs:226 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-89d8b7c9 | this.Load | FP00590_GroupReleaseTotalPopup.cs:227 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4e074260 | this.Load | FP00590_GroupReleaseTotalPopup.cs:232 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-9f005985 | this.Load | FP00590_GroupReleaseTotalPopup.cs:234 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-b05cd446 | this.Load | FP00590_GroupReleaseTotalPopup.cs:237 | try | VALUE_SET | txtPlanID.Text | _sPlanID | 컨트롤 값 설정 |  |  |  |
| AC-6784318c | this.Load | FP00590_GroupReleaseTotalPopup.cs:238 | try | VALUE_SET | txtPlanGroup.Text | _sPlanGroup | 컨트롤 값 설정 |  |  |  |
| AC-d5d083bb | this.Load | FP00590_GroupReleaseTotalPopup.cs:239 | try | VALUE_SET | txtDescription.Text | _sDescription | 컨트롤 값 설정 |  |  |  |
| AC-536cb830 | this.Load | FP00590_GroupReleaseTotalPopup.cs:242 | try | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_instanceInfo", _sPlan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d228c0d6 | this.Load | FP00590_GroupReleaseTotalPopup.cs:242 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_instanceInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4af7221 | this.Load | FP00590_GroupReleaseTotalPopup.cs:246 | try ▸ if (dtInstance.Rows.Count > 0) | FLAG | _sWoWStatus | dtInstance.Rows[0]["USE_WOW_STATUS"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7e5b58d2 | this.Load | FP00590_GroupReleaseTotalPopup.cs:252 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2b6716d0 | this.Load | FP00590_GroupReleaseTotalPopup.cs:253 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-11303ba6 | this.Load | FP00590_GroupReleaseTotalPopup.cs:254 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3388ee77 | this.Load | FP00590_GroupReleaseTotalPopup.cs:260 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_GroupReleaseTotalPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2366d8de | this.Load | FP00590_GroupReleaseTotalPopup.cs:286 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ece8fc2 | this.Load | FP00590_GroupReleaseTotalPopup.cs:287 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Insert_Hist_Detail

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sPlanType != "F")] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_GROUP_VALIDATION_1") ▸ else of (programID == "RELEASE_GROUP_VALIDATIO…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b03e951 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2483 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9abef4c4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2487 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-17a6fd77 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2488 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-676ab108 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2489 | try | DATA_OP | request.Parameters["p_sys_flag"] | "INSERT_HIST_GROUP_DETAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-8b5523f5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2490 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-942c22e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2491 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5c6d2d70 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2493 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6bae3bbe | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2494 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-5cfa7d1a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2495 | try | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-8f7848f0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2496 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-b749c641 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2497 | try | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-dff2fd9b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2498 | try | DATA_OP | request.Parameters["p_plan_id"] | _sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-b8627d95 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2499 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-555c7e80 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2500 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6d9dab18 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2501 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0101900 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2502 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98c7a7f6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2503 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f517d52 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2504 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b096ab6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2505 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e0a11fac | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2506 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b05cca71 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2507 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49cea2ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2508 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c7da6881 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2509 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e2f6f35 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2510 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-78a10592 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2511 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e5c5c440 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2513 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-abb60204 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2515 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c11d1b76 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2520 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Insert_Is_Running_Release

진입점: this.btnSave.Click [try ▸ switch (sType) case "INSERT":] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ if (programID == "INSERT_RUNNING_RELEASE") ▸ if (bCheck == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-024aeb78 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2196 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-97d634af | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2197 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2a1ad3b4 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2199 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8fb82e75 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2200 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4da38a78 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2201 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-7e5eac2e | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2202 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebfed076 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2204 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1479d93 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2205 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e3aa1e3 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2206 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b7163a0 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2207 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d3a4b53 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2208 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b9563531 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2209 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-0313ebd6 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2210 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-912e008c | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2211 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-47d532d8 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2212 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-1872b708 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2213 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-789f68ed | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2214 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5838270 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2215 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-6bbb3dde | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2216 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-6384aa58 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2217 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-6eab1809 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2218 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-d860cac3 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2219 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce6e0777 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2220 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-02823715 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2221 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-df6e09af | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2222 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e6691f22 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2224 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-454b38ef | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2225 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-05c7cae0 | this.btnSave.Click [try ▸ switch (sType) case "INSERT":] 외 1 | FP00590_GroupReleaseTotalPopup.cs:2231 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Insert_OT_NET_JOB

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (_sPlanGroup.IndexOf("CELL") == -1 \|\| _sPlanGroup.IndexOf("PACK") == -1 \|\| _sPlanGroup.IndexOf("E_PRE") == -1)] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8899ee43 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2728 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_GroupReleasePlanList"… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4c2c6844 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2728 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_GroupReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sP… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd62ff4a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2730 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-aad499bd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2731 | try | FLAG | p_sys_flag | "INSERT_OT_NET_JOB" | 화면 필드/플래그 변경 |  |  |  |
| AC-37d9da69 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2732 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ef0467e4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2733 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-06e4bba1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2749 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-5267d29a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2750 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cbfc241c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2752 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b48c4d8e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2753 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b2bca944 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2754 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-8c56e865 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2755 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-da2e884b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2757 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45403208 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2758 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e55bfae0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2759 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c409d165 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2760 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-8c107130 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2761 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-b00d71ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2762 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-a68e3ceb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2763 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5083372 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2764 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3e06e238 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2765 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a57da714 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2766 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-791a23d7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2767 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-037f6caf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2768 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f790b977 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2769 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bcf89afb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2770 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-26c35f73 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2771 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36e93373 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2772 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd55fff1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2773 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbf752ca | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2774 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91ce55fa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2775 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-946fe9e0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2777 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a035f56 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2783 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-74601874 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2788 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e82e83a | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3715 | if (programID == "SELECT_GROUP_RELEASE_TOTAL") | RETURN | return Find_Data_Sub("SQL", pSiteID, pPlanGroup, pPlanDate, pPlanID); |  | 처리 중단/반환 |  |  |  |
| AC-170279dc | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3720 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ if (programID == "CONFIRM_GROUP_VALIDATION_1") | RETURN | return Find_Confirm_Valid("SQL", "CONFIRM_GROUP_VALIDATION_1"); |  | 처리 중단/반환 |  |  |  |
| AC-a75bf1dd | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3725 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ if (programID == "CONFIRM_GROUP_… | RETURN | return Find_Confirm_Valid("SQL", "CONFIRM_GROUP_VALIDATION_2"); |  | 처리 중단/반환 |  |  |  |
| AC-326f992c | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3731 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-76db5194 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3731 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f081ad4 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3743 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Exec_Release_Plan(i, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-800f6254 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3753 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Update_DivisionList(i,"SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-914f29cb | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3769 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Insert_Is_Running_Release("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f5b87145 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3784 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Delete_Is_Running_Release("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-00c35224 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3788 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Find_Release_Valid("SQL", "RELEASE_GROUP_VALIDATION_1"); |  | 처리 중단/반환 |  |  |  |
| AC-8af7e981 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3792 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Find_Release_Valid("SQL", "RELEASE_GROUP_VALIDATION_2"); |  | 처리 중단/반환 |  |  |  |
| AC-2871dcc1 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3796 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Update_Release_Flag("UPDATE_GROUP_RELEASE_FLAG", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-956dbfaa | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3800 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Update_Release_PlanList_2("UPDATE_GROUP_RELEASE_PLANLIST_2", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8ed7d08e | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3804 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Insert_Hist_Detail("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6aeed259 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3818 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return Insert_OT_NET_JOB("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7ff130c5 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3841 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-309eae8f | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3842 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_PLAN_RESULT_SEND " + "'" + pPlanGroup + "', " + "'" + pPlanDate + "', " + "'… | 데이터 객체 조작/조회 |  |  |  |
| AC-01d4f0da | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3843 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e438440a | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3845 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-307dee87 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3869 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e576c276 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3870 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_CONFIRM_SMS_SEND " + "'" + pPlanGroup + "', " + "'" + pPlanID + "', " + "'" … | 데이터 객체 조작/조회 |  |  |  |
| AC-9f98c076 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3871 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-45ec90f6 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3873 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4951aa1c | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3883 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4392175f | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3884 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Rows.Add | ("EXEC PR_XIF_MES_ERP_WO_MASTER " + "'" + pPlanID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-74823749 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3885 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2550302 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3887 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-30b7ec43 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3896 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7c42410 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3897 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_ASSY_ELEC_REPORT " + "'" + pPlanGroup + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f6423f3 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3898 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f721786d | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3900 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a6c5fc66 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3909 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3dee1cb | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3910 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_PACK_REQUIRE_CEL " + "'" + pPlanGroup + "', " + "'', " + "'Y', " + "'', '… | 데이터 객체 조작/조회 |  |  |  |
| AC-4458d117 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3911 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0390308c | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3913 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-039541ee | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3922 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0c6a7a6 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3923 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_CELL_DELIVERY_PLAN " + "'" + pPlanGroup + "', " + "'', " + "'Y', " + "'',… | 데이터 객체 조작/조회 |  |  |  |
| AC-b55fb619 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3924 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-2835ef1b | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3926 | else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_G… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-99b963f8 | popSql.OnSql | FP00590_GroupReleaseTotalPopup.cs:3928 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Save_Release

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c32d463 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:559 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-26b728a2 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:561 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-dfa3ce23 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:561 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-343f4dff | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:563 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45b615c6 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:567 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b3894e9c | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:576 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_RELEASE_LIMIT_YN == "Y") | MESSAGE | MessageHelper.GMessageBox | ("Unable to release. Contact GSCM.FP PI representative for details.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bb6d6c2 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:577 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_RELEASE_LIMIT_YN == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ac5e4c9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:585 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d37cde1a | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:586 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72cd02ea | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:611 | try ▸ if (iChkCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91064aeb | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:612 | try ▸ if (iChkCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3d62e22 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:619 | try ▸ if (bExistComplete == false) | MESSAGE | MessageBox.Show | ("Already exisit Confirm Plan ID. Will you proceed?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-2f8253bb | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:621 | try ▸ if (bExistComplete == false) ▸ if (MessageBox.Show("Already exisit Confirm Plan ID. Will you proceed?", "Confrim", MessageBoxButtons.Y… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eeeb0fac | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:630 | try ▸ else of (bExistComplete == false) | MESSAGE | MessageBox.Show | ("Will you Confirm proceed?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-5a15e916 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:632 | try ▸ else of (bExistComplete == false) ▸ if (MessageBox.Show("Will you Confirm proceed?", "Confrim", MessageBoxButtons.YesNo) == DialogResu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a88402b8 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:668 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") | FLAG | dtIsRunReleaseBySite | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_is_running_release_by… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5096e413 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:668 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release_bySite", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7b67a0e | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:676 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") ▸ if (dtIsRunReleaseBySite != null) ▸ if (dtIsRunReleaseBySite.Rows.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dcd9b71 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:677 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") ▸ if (dtIsRunReleaseBySite != null) ▸ if (dtIsRunReleaseBySite.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-483c6c3c | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:683 | try ▸ if (Check_Exec_IsRunningEngine("SELECT_INIT") == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c96e2e9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:689 | try ▸ if (Check_isConfirmed() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-695347a7 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:693 | try ▸ if (Check_ConfirmValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-252d279c | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:696 | try ▸ if (Check_CapaValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7a5d363 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:702 | try ▸ if (Check_IsPastDate() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01321143 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:703 | try ▸ if (Check_IsPastDate() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-206cc7fb | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:707 | try ▸ if (Check_Exec_IsRunningEngine("SELECT") == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-290b309f | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:711 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9df3efec | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:729 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | ENDPOINT | proxyPivot.ExecuteAsync | (() => Exec_Release_Queue("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bd99e9c | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:749 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_watingTime", _sPlanGroup, _sSite, sFactory_LT) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bbbc1626 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:767 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnReleaseRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-28c06786 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:769 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | MESSAGE | MessageBox.Show | (sMsg, "Excute", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-b87bdfe1 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:773 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (MessageBox.Show(sMsg, "Excute", MessageBoxButtons.OK) == DialogR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65e86c6f | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:805 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8ba8ca30 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:806 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f127dda3 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:807 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c6db1bb | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:833 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a4be5680 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:836 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | new FP00590_ValidationPopup | ("GroupReleaseValid1Popup", dsReleaseValid_1, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-f4fd36fd | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:837 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_PROP | popReleaseValid1.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0e2e2dcd | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:838 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | popReleaseValid1.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d5bceca6 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:844 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9068e685 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:851 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-aed70ef9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:852 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0e116774 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:853 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5c209bc | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:870 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-818bb58d | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:880 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a707c820 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:883 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | new FP00590_ValidationPopup | ("GroupReleaseValid2Popup", dsReleaseValid_2, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-5b7416f9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:884 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_PROP | popReleaseValid2.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fcddc73e | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:885 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | popReleaseValid2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4547ff44 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:891 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdc219b9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:898 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d723218d | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:899 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d25563 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:900 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc12b775 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:932 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked) ▸ for (i < dtRelPlanLT.Rows.Count) | DATA_OP | FilterTmp["MASTER_ID"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-c27ec2b9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:933 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked) ▸ for (i < dtRelPlanLT.Rows.Count) | DATA_OP | FilterTmp["PLAN_ID"] | dtRelPlanLT.Rows[i]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9523318c | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:934 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked) ▸ for (i < dtRelPlanLT.Rows.Count) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00590_RELEASE_P", "update_MRP_Transit", FilterTmp.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=update_MRP_Transit] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-be36a098 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:961 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dsSendTotal == null \|\| dsSendTotal.Tables[0].Rows[0][0].T… | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-44a2ab1d | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1050 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f86a0bc0 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1052 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnReleaseRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-493425ae | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1054 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { _sPlanID }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e839cdb9 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1060 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2722d14c | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1061 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-26148c63 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1065 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d0a113c3 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1066 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d4bf516b | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1070 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ca73a5d6 | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1075 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a283a2db | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1076 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a3b6d7cf | this.btnSave.Click | FP00590_GroupReleaseTotalPopup.cs:1077 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_GroupReleaseTotalPopup.SetCheckRow

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnFind.Click [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.Load [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06a8face | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 2 | FP00590_GroupReleaseTotalPopup.cs:3942 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sCheckYn != "Y") | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |

## FP00590_GroupReleaseTotalPopup.SetCleraVariable

진입점: this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ lambda] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ if (programID == "EXECUTE_GROUP_RELEASE") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !string.IsNullOrEmpty(siMain.Ge…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-109dad78 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3281 |  | FLAG | p_sys_type | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-257709fb | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3282 |  | FLAG | p_sys_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-93cc4cd1 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3283 |  | FLAG | p_sys_gubun | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c8f522ae | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3284 |  | FLAG | p_user_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-dc7b7183 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3285 |  | FLAG | p_division_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-53672b35 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3286 |  | FLAG | p_site_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-cbad3ffa | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3287 |  | FLAG | p_factory_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-cdb8ca22 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3288 |  | FLAG | p_instance_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9b4f1eb5 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3289 |  | FLAG | p_plan_date | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fe446e61 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3290 |  | FLAG | p_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-191295e9 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3291 |  | FLAG | p_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-dfff1671 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3292 |  | FLAG | p_insert_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-935efe6e | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3293 |  | FLAG | p_release_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7c4decd1 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3294 |  | FLAG | p_is_enable_rel | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-227ef61c | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3295 |  | FLAG | p_confirm_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1631d898 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3296 |  | FLAG | p_confirm_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-65b8f200 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3297 |  | FLAG | p_description | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7b1b161a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3298 |  | FLAG | p_isenable | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b849ad39 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3299 |  | FLAG | p_ischk | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0c05083a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3300 |  | FLAG | p_next_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9b2a7dbb | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… 외 1 | FP00590_GroupReleaseTotalPopup.cs:3301 |  | FLAG | p_release_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP00590_GroupReleaseTotalPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b2e4da6 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:298 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8168378f | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:299 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-85fcda78 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:303 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6e5e79c3 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:304 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7a174c97 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:306 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-79617a7e | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:307 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-db3ad72a | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:308 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e1a4fadd | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:309 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e77d70ae | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:310 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bf0eed06 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:311 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4fd6930 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:312 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8f1d9034 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:314 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-874e255e | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:315 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSERT_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ae5e4952 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:316 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.RELEASE_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f0af6307 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:317 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ec84d86f | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:318 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-01c085ce | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:319 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-90094441 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:320 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ISENABLE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6dfd60aa | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:321 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ISCHK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6d809845 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:331 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-09bd618a | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:332 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-523a96c2 | this.Load [try] | FP00590_GroupReleaseTotalPopup.cs:333 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## FP00590_GroupReleaseTotalPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2da6480 | this.spdMain.CellClick | FP00590_GroupReleaseTotalPopup.cs:3232 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-3d9823ed | this.spdMain.CellClick | FP00590_GroupReleaseTotalPopup.cs:3237 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-cf786339 | this.spdMain.CellClick | FP00590_GroupReleaseTotalPopup.cs:3244 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, bChk) | 그리드 값 설정 |  |  |  |
| AC-cdeb5eaf | this.spdMain.CellClick | FP00590_GroupReleaseTotalPopup.cs:3257 |  | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Update_DivisionList

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex())] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ if (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !string.IsNullOrEmpty(siMain.Ge…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acc58395 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1511 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-984bda91 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1512 | try | FLAG | p_sys_flag | "UPDATE_GROUP_DIVISIONLIST" | 화면 필드/플래그 변경 |  |  |  |
| AC-f049ccd4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1513 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9eb5f877 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1514 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4134a29a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1515 | try | FLAG | p_division_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ba76ab5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1516 | try | FLAG | p_site_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fdb8c95f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1517 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d173d541 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1518 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7b771243 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1519 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7dafd71e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1520 | try | FLAG | p_plan_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9bb3683b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1521 | try | FLAG | p_flag | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FLAG)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-be9bc059 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1522 | try | FLAG | p_insert_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSERT_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a485a16 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1523 | try | FLAG | p_release_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.RELEASE_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-35b0733b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1524 | try | FLAG | p_is_enable_rel | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-08ba9c9e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1525 | try | FLAG | p_confirm_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5e19d24c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1526 | try | FLAG | p_confirm_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-95e70e50 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1527 | try | FLAG | p_description | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4cd91ab7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1528 | try | FLAG | p_isenable | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISENABLE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5cdfe6a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1529 | try | FLAG | p_ischk | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISCHK)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-668bc096 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1530 | try | FLAG | p_next_plan_id | txtPlanID.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-09976a39 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1531 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8bdf4075 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1532 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-84403e9a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1536 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-d0ebaca1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1537 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-58e93477 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1539 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ee8f5d76 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1540 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-af17a1cd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1541 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9f039ed4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1542 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-84f9dd66 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1544 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee9764c4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1545 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d5eaa25 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1546 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-74d198b5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1547 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-72c43227 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1548 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-0a268aa1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1549 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-73e36606 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1550 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-800fe52a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1551 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-71cc62c3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1552 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-609a5b13 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1553 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-3646f11e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1554 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3e15efe7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1555 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-f07d3aef | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1556 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-55642afd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1557 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-ecef359b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1558 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-4e4b2019 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1559 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b3d9ba8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1560 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-83c77507 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1561 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a405ad2e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1562 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c26274ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1564 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-209a015f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1565 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b0ee8a18 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1571 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Update_Release_Flag

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ else of (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F")] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_GROUP_VALIDATION_1") ▸ else…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1d0f5e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1935 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-5dae4199 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1936 | try | FLAG | p_sys_flag | pSysFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-bc17942b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1937 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0916108f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1938 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-ddcf77ca | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1939 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9165f792 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1940 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-3cd6ee07 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1941 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d1c1fb13 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1942 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-70e0ec7a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1943 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-e3e5cb89 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1944 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-554edd41 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1945 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ab2649f2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1946 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cf5840dc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1947 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-85c812f0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1948 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-43c5930e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1949 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c32b09d0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1950 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cd74f09e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1951 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-06df873c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1952 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fe7f4fc3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1953 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-daf754ca | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1954 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6f912d00 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1955 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f75210f2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1956 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-67d91ca1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1960 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-3d1fc3c7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1961 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ec94ca04 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1963 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c9ea42c9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1964 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ca7b6fbc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1965 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-24428b0f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1966 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c21418a6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1968 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd6bd9d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1969 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6eba7eb5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1970 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-1caba557 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1971 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9e99a6aa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1972 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-c1dbb93a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1973 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fdcbe4c1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1974 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1a04cbc1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1975 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-8cfd9f7c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1976 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-f48c9186 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1977 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-bd033fdb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1978 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb196704 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1979 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-2f9f64ce | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1980 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-5fa617b4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1981 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-d47efbde | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1982 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-236c9faf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1983 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-52618132 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1984 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-58de5258 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1985 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-33516570 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1986 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-0a141161 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1988 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-867d261d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1989 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b518ad56 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:1996 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_GroupReleaseTotalPopup.Update_Release_PlanList_2

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")] / popSql.OnSql [else of (programID == "SELECT_GROUP_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_1") ▸ else of (programID == "CONFIRM_GROUP_VALIDATION_2") ▸ else of (programID == "EXECUTE_GROUP_RELEASE") ▸ else of (programID == "UPDATE_GROUP_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_GROUP_VALIDATION_1") ▸ else of (programID == "RELEASE_GROUP_VALIDATION_2") ▸ else of (program…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86000326 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2055 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-dc3e831a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2056 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5c8e5cef | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2058 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-fe5de7f4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2059 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1fa87762 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2060 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-91c984e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2061 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2692435c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2063 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b9b01661 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2064 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b7854b61 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2065 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-0aa2425d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2066 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-33eba0d8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2067 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-aee27b9a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2068 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-97919b74 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2069 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bf3bba8a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2070 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-74ca2519 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2071 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-72e4e7ef | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2072 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-b8dd6546 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2073 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-31a5e59b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2074 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-26a5c435 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2075 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e0680c5f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2076 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-01889fd0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2077 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-34457113 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2078 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d38938c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2079 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-384ce6fa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2080 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8ebf07b3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2081 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-8fe0f764 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2083 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33cf2427 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2084 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7a6df4e3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2089 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2a3dff8d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… 외 1 | FP00590_GroupReleaseTotalPopup.cs:2094 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_MasterValidationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e650bf0 | .ctor | FP00590_MasterValidationPopup.cs:101 |  | UI_PROP | SpdSheet.shtMain | sSheetName | 속성 shtMain 설정 |  |  |  |
| AC-aed65415 | .ctor | FP00590_MasterValidationPopup.cs:102 |  | FLAG | _dsSheet | dsSheet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c13aa750 | .ctor | FP00590_MasterValidationPopup.cs:102 |  | DATA_OP | dsSheet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-08f6fbdb | .ctor | FP00590_MasterValidationPopup.cs:103 |  | FLAG | _sMessage | sMessage | 화면 필드/플래그 변경 |  |  |  |

## FP00590_MasterValidationPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0424a850 | this.btnClose.Click | FP00590_MasterValidationPopup.cs:216 |  | UI_PROP | this.DialogResult | DialogResult.Cancel | 속성 DialogResult 설정 |  |  |  |
| AC-78de9d4e | this.btnClose.Click | FP00590_MasterValidationPopup.cs:217 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_MasterValidationPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78b47384 | this.btnExport.Click | FP00590_MasterValidationPopup.cs:210 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-94b04467 | this.btnExport.Click | FP00590_MasterValidationPopup.cs:211 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00590_MasterValidationPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5df52d39 | this.btnOK.Click | FP00590_MasterValidationPopup.cs:221 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-c8922fb5 | this.btnOK.Click | FP00590_MasterValidationPopup.cs:222 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_MasterValidationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-095221f2 | this.Load | FP00590_MasterValidationPopup.cs:157 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-539bb22d | this.Load | FP00590_MasterValidationPopup.cs:158 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-88fe8baf | this.Load | FP00590_MasterValidationPopup.cs:159 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_MasterValidationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a3a1502 | this.Load | FP00590_MasterValidationPopup.cs:151 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_MasterValidationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c628e61f | Dispose | FP00590_MasterValidationPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_MasterValidationPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-febdb8cf | ExcelButton | FP00590_MasterValidationPopup.cs:232 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00590_MasterValidationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a6d6694 | this.Load | FP00590_MasterValidationPopup.cs:113 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-997b3122 | this.Load | FP00590_MasterValidationPopup.cs:115 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-170d696e | this.Load | FP00590_MasterValidationPopup.cs:129 | if (!string.IsNullOrEmpty(_sMessage)) | MESSAGE | MessageBox.Show | (_sMessage, "Validation", MessageBoxButtons.OK, MessageBoxIcon.Information) | 메시지 표시 |  |  |  |

## FP00590_MasterValidationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c627ee48 | this.Load | FP00590_MasterValidationPopup.cs:143 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |

## FP00590_MasterValidationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edb256d4 | this.Load | FP00590_MasterValidationPopup.cs:171 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-302b13c7 | this.Load | FP00590_MasterValidationPopup.cs:172 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_MasterValidationPopup.RefreshHeadAndBody

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a63b4a2c | this.Load [try] | FP00590_MasterValidationPopup.cs:286 |  | CALL_EXT | FPExtensions.ColorFromName | ("orange") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1aea5aab | this.Load [try] | FP00590_MasterValidationPopup.cs:315 | switch (sheetName) case "ReleaseValid2Popup": ▸ if (current_src != null) ▸ for (rowindex < current_src.Rows.Count) ▸ if (_MSG_NUM == "1") | GRID_STYLE | siMain.SetBGColor3 | (rowindex, child_line, rowindex, child_line, orangeColor) | 그리드 표시 설정 |  |  |  |
| AC-78367c48 | this.Load [try] | FP00590_MasterValidationPopup.cs:319 | switch (sheetName) case "ReleaseValid2Popup": ▸ if (current_src != null) ▸ for (rowindex < current_src.Rows.Count) ▸ else of (_MSG_NUM == "1… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, child_prio, rowindex, child_prio, orangeColor) | 그리드 표시 설정 |  |  |  |
| AC-e1ea360c | this.Load [try] | FP00590_MasterValidationPopup.cs:323 | switch (sheetName) case "ReleaseValid2Popup": ▸ if (current_src != null) ▸ for (rowindex < current_src.Rows.Count) ▸ else of (_MSG_NUM == "1… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, child_Item, rowindex, child_Item, orangeColor) | 그리드 표시 설정 |  |  |  |

## FP00590_MasterValidationPopup.SetGrid_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81d94766 | this.Load | FP00590_MasterValidationPopup.cs:241 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14d9287b | this.Load | FP00590_MasterValidationPopup.cs:245 | try | GRID_BIND | siMain.Query | (_dsSheet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a2ec5e18 | this.Load | FP00590_MasterValidationPopup.cs:250 | try ▸ if (_dsSheet.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-10ef1d0a | this.Load | FP00590_MasterValidationPopup.cs:254 | try | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8466c4b6 | this.Load | FP00590_MasterValidationPopup.cs:258 | try | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00590_MasterValidationPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b559dd87 | this.Load [try] | FP00590_MasterValidationPopup.cs:183 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99ff5e55 | this.Load [try] | FP00590_MasterValidationPopup.cs:184 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-766c3388 | this.Load [try] | FP00590_MasterValidationPopup.cs:188 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9df896ce | this.Load [try] | FP00590_MasterValidationPopup.cs:189 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_Plan_Control.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-152a3dfb | this.btnPlanInfo.Click | FP00590_Plan_Control.cs:1155 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4d028595 | this.btnPlanInfo.Click | FP00590_Plan_Control.cs:1156 | if (fc != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d1159e3 | this.btnPlanInfo.Click | FP00590_Plan_Control.cs:1159 |  | POPUP | new FP00590_PlanInfoPopup | (sSite, sPlanGroup, sPlanDate, sPlanID) | 팝업/폼 생성 |  |  |  |
| AC-74c2b379 | this.btnPlanInfo.Click | FP00590_Plan_Control.cs:1160 |  | UI_PROP | popPlanInfo.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-331cc79c | this.btnPlanInfo.Click | FP00590_Plan_Control.cs:1161 |  | POPUP | popPlanInfo.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_Plan_Control.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6367871e | this.btnSql.Click | FP00590_Plan_Control.cs:1174 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e4914560 | this.btnSql.Click | FP00590_Plan_Control.cs:1175 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2582939f | this.btnSql.Click | FP00590_Plan_Control.cs:1177 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_PLAN_CONTROL") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d5e1407 | this.btnSql.Click | FP00590_Plan_Control.cs:1178 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_VALIDATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-48735004 | this.btnSql.Click | FP00590_Plan_Control.cs:1179 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_ENGINE_RUN") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f6e1ba8 | this.btnSql.Click | FP00590_Plan_Control.cs:1180 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_Plan_Control.btnWowStatus_Click

진입점: this.btnWowStatus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f5ad061 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1092 | if (iClickRow < 0 \|\| siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3aa4f144 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1101 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_instanceInfo", pPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e45fe980 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1101 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_instanceInfo", pPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a51be0bb | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1107 | if (!sWoWStatus.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe0903f4 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1109 |  | DATA_OP | dtLocalPlanGroup.Select | (string.Format("CODE = '{0}'", pPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93cc8325 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1110 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6cff7694 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1120 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d623f86c | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1123 | try | POPUP | new FP00590_WoWStatusPopup | (pSite, pPlanGroup, pPlanDate, pPlanID, sIsSamePlanID, sConfirmArea, sWoWStatus) | 팝업/폼 생성 |  |  |  |
| AC-92f348dc | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1124 | try | UI_PROP | popWowStatus.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f6ff7165 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1125 | try | POPUP | popWowStatus.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4f52fbb7 | this.btnWowStatus.Click | FP00590_Plan_Control.cs:1131 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_Plan_Control.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab51fb72 | cboPlanGroup.SelectedIndexChanged | FP00590_Plan_Control.cs:1224 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sDataID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04f68f60 | cboPlanGroup.SelectedIndexChanged | FP00590_Plan_Control.cs:1229 | try | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00590_Plan_Control.ChartThread_Start

진입점: this.chkStatus.CheckedChanged [if (chkStatus.Checked == true)] / this.Activated [if (chkStatus.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f58a3b28 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1300 | try ▸ if (siMain.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5da44427 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1302 | try ▸ if (string.IsNullOrEmpty(siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffc86a8e | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1304 | try | FLAG | _DoEngineRunSelectEvent1 | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7ff96e64 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1310 | try ▸ if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3728d5b4 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1311 | try ▸ if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |
| AC-45b7e401 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1313 | try | FLAG | _EngineRunthread | new Thread(new ThreadStart(ExcuteEventEngineRunThread)) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd76bf05 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1314 | try | CALL_EXT | _EngineRunthread.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe548f84 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00590_Plan_Control.cs:1315 | try | UI_PROP | _EngineRunthread.IsBackground | true | 속성 IsBackground 설정 |  |  |  |

## FP00590_Plan_Control.chkStatus_CheckedChanged

진입점: this.chkStatus.CheckedChanged / this.Activated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f101841b | this.chkStatus.CheckedChanged 외 1 | FP00590_Plan_Control.cs:1287 | else of (chkStatus.Checked == true) ▸ if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e89f118 | this.chkStatus.CheckedChanged 외 1 | FP00590_Plan_Control.cs:1288 | else of (chkStatus.Checked == true) ▸ if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6729d004 | this.Load | FP00590_Plan_Control.cs:292 | try | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c3480cf5 | this.Load | FP00590_Plan_Control.cs:293 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-890f4a01 | this.Load | FP00590_Plan_Control.cs:294 | try | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c338a04 | this.Load | FP00590_Plan_Control.cs:298 | try | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0208f4fd | this.Load | FP00590_Plan_Control.cs:299 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1361fdf | this.Load | FP00590_Plan_Control.cs:300 | try | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0698f6e6 | this.Load | FP00590_Plan_Control.cs:308 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-a251064e | this.Load | FP00590_Plan_Control.cs:309 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_Plan_Control.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4832465c | this.Load | FP00590_Plan_Control.cs:182 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c11dd47f | this.Load | FP00590_Plan_Control.cs:184 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-65dddf7c | this.Load | FP00590_Plan_Control.cs:185 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-7a00befe | this.Load | FP00590_Plan_Control.cs:186 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00590_Plan_Control.DisplayEngineRunData

진입점: this._DoEngineRunSelectEvent1

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59f91653 | this._DoEngineRunSelectEvent1 | FP00590_Plan_Control.cs:1357 | try | CALL_EXT | spdMain.Invoke | (new MethodInvoker(delegate () { FindData_Sub(sPlanGroup, sPlanId); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2638acfa | this._DoEngineRunSelectEvent1 | FP00590_Plan_Control.cs:1365 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_Plan_Control.Dispose

진입점: this.FormClosing / Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-853127f7 | this.FormClosing 외 1 | FP00590_Plan_Control.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_Plan_Control.dtpPlanDate_ValueChanged

진입점: this.dtpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7acde53 | this.dtpPlanDate.ValueChanged | FP00590_Plan_Control.cs:1193 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c19b6dd1 | this.dtpPlanDate.ValueChanged | FP00590_Plan_Control.cs:1203 | if (Convert.ToDecimal(sPlanData) > Convert.ToDecimal(sUTDate)) | MESSAGE | MessageBox.Show | ("Future dates can not be selected. (Including basis time)") | 메시지 표시 |  |  |  |
| AC-78587ab1 | this.dtpPlanDate.ValueChanged | FP00590_Plan_Control.cs:1205 | if (Convert.ToDecimal(sPlanData) > Convert.ToDecimal(sUTDate)) | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sSetDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00590_Plan_Control.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15bd46f1 | EditButton | FP00590_Plan_Control.cs:429 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13f77877 | EditButton | FP00590_Plan_Control.cs:433 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dba9b924 | ExcelButton | FP00590_Plan_Control.cs:479 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00590_Plan_Control.Excute_Valid

진입점: this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87a93b92 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:794 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cbff659b | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:796 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e9ca399 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:801 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38b2b21d | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:802 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38836cfb | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:805 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-735ff610 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:812 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-51ab5dee | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:814 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3ec9bd39 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:815 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-751eac4e | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:829 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | proxyPivot.ExecuteAsync | (() => ExcuteRunValidation(pProcName, pSite, pPlanGroup, pPlanID, pPlanDate) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ddbc9f0e | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:834 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-21f9fe15 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:841 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageBox.Show | ("Validation Execute Complete!", "Confrim", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-34976022 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:853 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25df19f8 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:859 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-08b7d3b0 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:864 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2b8a1a8d | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:865 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-26d1c550 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:870 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8e7c329d | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:871 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.ExcuteEventEngineRunThread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-255e516e | (진입점 미연결) | FP00590_Plan_Control.cs:1333 | while (true) ▸ try | CALL_EXT | spdMain.Invoke | (new MethodInvoker(delegate () { pPlanGroup = CString.GetCheckedListValue(dtLocalPlanGroup… | ⚠ 의미 확인 필요 |  |  |  |
| AC-89e5d6d9 | (진입점 미연결) | FP00590_Plan_Control.cs:1338 | while (true) ▸ try ▸ lambda | CALL_BASE | _DoEngineRunSelectEvent1 | (pPlanGroup, pPlanID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cad2c199 | (진입점 미연결) | FP00590_Plan_Control.cs:1342 | while (true) ▸ try | CALL_EXT | Thread.Sleep | (5000) | ⚠ 의미 확인 필요 |  |  |  |

## FP00590_Plan_Control.ExcuteRunValidation

진입점: this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a85d9a | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:883 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-db70fc7d | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:884 | try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4421e20a | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:886 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-7df91daf | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:887 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_VALIDATION" | 행/컬럼 값 대입 |  |  |  |
| AC-a0713f33 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:888 | try | DATA_OP | request.Parameters["p_sys_gubun"] | pProcName | 행/컬럼 값 대입 |  |  |  |
| AC-713b483f | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:889 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ee85781e | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:890 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-e29fd508 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:891 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-41b4aba1 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:892 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-e1c22adb | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:893 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-d2c38ea9 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:894 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cc3f6684 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:895 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3e020959 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:896 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a950b64c | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:897 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9c89c552 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:898 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f3c7df25 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:899 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-372fd0f9 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:900 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3f08bdd5 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:901 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-522adde6 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:902 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0860655e | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:903 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-81e591dd | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:904 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-923ae63a | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:905 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7bf70d5f | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:906 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c576d153 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:907 | try | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-71a69e51 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:909 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4c8d816 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:910 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-aa584eb8 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00590_Plan_Control.cs:915 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_Plan_Control.Find_Data_Main

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(D…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e484eba3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:618 |  | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-7c65678e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:620 |  | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-57949782 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:622 |  | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-3c1977f6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:623 |  | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_CONTROL" | 행/컬럼 값 대입 |  |  |  |
| AC-09b7b00f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:624 |  | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1874d923 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:625 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-35bab872 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:626 |  | DATA_OP | request.Parameters["p_site_id"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-b2266051 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:627 |  | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-bdf2c63e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:628 |  | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-7084c792 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:629 |  | DATA_OP | request.Parameters["p_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9eb10d85 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:630 |  | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-45461e3d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:631 |  | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9a43baf3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:632 |  | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bd2ab1e3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:633 |  | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-540445ce | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:634 |  | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c6ff9d2d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:635 |  | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0ba29d36 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:636 |  | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d0b27fdd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:637 |  | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be665259 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:638 |  | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-737a1875 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:639 |  | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8aa8e778 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:640 |  | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9c17a5d2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:641 |  | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b8770dc2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:642 |  | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c940d41e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:643 |  | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-980f598a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:645 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d321264 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00590_Plan_Control.cs:647 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## FP00590_Plan_Control.Find_Data_Sub

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda ▸ if (ds != null) ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevision.Rows.Count > 0) ▸ try ▸ lambda] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f551a91 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:754 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-2c5e297f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:755 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-f776a90f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:756 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ENGINE_RUN" | 행/컬럼 값 대입 |  |  |  |
| AC-cbaa3df3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:757 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-25e1c35d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:758 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b7b7499d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:760 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b2a4c6ef | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:761 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-a1e58e2e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:762 | try | DATA_OP | request.Parameters["p_plan_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-11ea90a6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:763 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-d33118fb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:765 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-72538d37 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:766 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ef2088d1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:767 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e6a6b49d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:768 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e5148f88 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:769 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d35bb439 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:770 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-69387c4b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:771 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-34386940 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:772 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0481a7f6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:773 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fb3d65dc | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:774 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-816bd9e6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:775 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-55cd3a44 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:776 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1cbd1170 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:777 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cc870e48 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:778 | try | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b9bb8e8c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:780 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-249320d7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:782 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b90dda9d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00590_Plan_Control.cs:787 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_Plan_Control.FindData_Main

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTIO…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11671095 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:490 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3dbb3f4c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:495 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53736930 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:496 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-134dbf1b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:499 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-78f04575 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:505 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2214c8a8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:505 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-361de1f8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:511 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e52b01be | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:514 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15578e57 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:525 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Main(pSiteID, pPlanGroup, pPlanDate, "SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30b05500 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:530 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (ds != null) { //조회 End 시간 및 UI 시작 시간 SearchEndTime();… | ⚠ 의미 확인 필요 |  |  |  |
| AC-54ea3236 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:538 | try ▸ lambda ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c9449d8c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:543 | try ▸ lambda ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09868ddc | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:558 | try ▸ lambda ▸ if (ds != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Rows[0, siMain.GetMaxRowIndex()].Height | 40 | 그리드 속성/값 설정 |  |  |  |
| AC-7d5e6a63 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:569 | try ▸ lambda ▸ if (ds != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_runValidationMaster", pPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e972c3f3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:573 | try ▸ lambda ▸ if (ds != null) ▸ if (dtValidation.Rows.Count == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5aa7a1c8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:575 | try ▸ lambda ▸ if (ds != null) ▸ if (dtValidation.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96d5fa35 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:580 | try ▸ lambda ▸ if (ds != null) | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_instanceInfo", pPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3e7b6ddd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:580 | try ▸ lambda ▸ if (ds != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_instanceInfo", pPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b6526f7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:589 | try ▸ lambda ▸ if (ds != null) ▸ if (sWoWStatus.Equals("Y")) | STATE | btnWowStatus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a1ec25a5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:593 | try ▸ lambda ▸ if (ds != null) ▸ else of (sWoWStatus.Equals("Y")) | STATE | btnWowStatus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0f7ca1b9 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:606 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6efcec70 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:607 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f05aff44 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:608 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.FindData_Sub

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda ▸ if (ds != null) ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevision.Rows.Count > 0)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColum…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed6c8fc5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:655 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4996b838 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:660 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2485b504 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:660 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec1aed93 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:669 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e22093fb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:674 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { ds = Find_Data_Sub("SELECT", pPlanGroup, pPlanID); ////조회… | ⚠ 의미 확인 필요 |  |  |  |
| AC-123d85e7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:682 | try ▸ lambda | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c925f4cf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:696 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-e725eb4c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:700 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-513beb2a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:701 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-ff946e47 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:705 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-e82d9f6b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:706 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-f480a2bc | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:707 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-34560650 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:711 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-de28bbc3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:712 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-554fea39 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:713 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-ffd6b8cd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:714 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP4)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-9427b643 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00590_Plan_Control.cs:740 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_Plan_Control.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3c1a21f | this.Load | FP00590_Plan_Control.cs:157 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00590_Plan_Control.FP00590_Plan_Control_Deactivate

진입점: this.Deactivate

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12620ce7 | this.Deactivate | FP00590_Plan_Control.cs:1817 | if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4eb5ba5 | this.Deactivate | FP00590_Plan_Control.cs:1818 | if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.FP00590_Plan_Control_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b8b7cfa | this.FormClosing | FP00590_Plan_Control.cs:1826 | if (_EngineRunthread != null) ▸ if (!_EngineRunthread.Join(500)) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb7b2c0 | this.FormClosing | FP00590_Plan_Control.cs:1828 | if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b2f0f1e5 | this.FormClosing | FP00590_Plan_Control.cs:1834 | if (EngineRunTimer != null) | CALL_EXT | EngineRunTimer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-058b256c | this.FormClosing | FP00590_Plan_Control.cs:1835 | if (EngineRunTimer != null) | UI_MISC | EngineRunTimer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-bb0b3bde | this.FormClosing | FP00590_Plan_Control.cs:1836 | if (EngineRunTimer != null) | FLAG | EngineRunTimer | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.GetStepValid

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (sUseWoWStatus.Equals("Y"))] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ el…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1593a37c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:2057 |  | FLAG | dtStepValid | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_getStepValid", pPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f7c4c415 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:2057 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_getStepValid", pPlanGroup, pPlanDate, pStep) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68f5ccd7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:2071 | else of (UserInfoContext.Current.UserId == "pangaowei") ▸ if (dtStepValid.Rows.Count > 0) ▸ if (dtStepValid.Rows[0]["CHECK_FLAG"].ToString()… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b16ae257 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:2083 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## FP00590_Plan_Control.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c40d0bb0 | this.Load | FP00590_Plan_Control.cs:195 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-63509d85 | this.Load | FP00590_Plan_Control.cs:201 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-52b85a6e | this.Load | FP00590_Plan_Control.cs:202 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-94b86531 | this.Load | FP00590_Plan_Control.cs:207 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-254e9257 | this.Load | FP00590_Plan_Control.cs:209 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-e1292d56 | this.Load | FP00590_Plan_Control.cs:213 | try | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-4d1e95aa | this.Load | FP00590_Plan_Control.cs:213 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f8b5ba7 | this.Load | FP00590_Plan_Control.cs:214 | try | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9594cc7c | this.Load | FP00590_Plan_Control.cs:219 | try | FLAG | dtLocalPlanGroup | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findInstance", sDataID, "I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-007eacb5 | this.Load | FP00590_Plan_Control.cs:219 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findInstance", sDataID, "INSTANCE_ID") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4a5f332 | this.Load | FP00590_Plan_Control.cs:220 | try | LIST_REBIND | clsCtrl.setListBox | (dtLocalPlanGroup, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a864b007 | this.Load | FP00590_Plan_Control.cs:225 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sDataID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36665455 | this.Load | FP00590_Plan_Control.cs:229 | try | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-59fcddb3 | this.Load | FP00590_Plan_Control.cs:233 | try | STATE | btnWowStatus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-35ec9f30 | this.Load | FP00590_Plan_Control.cs:238 | try ▸ if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b539e582 | this.Load | FP00590_Plan_Control.cs:239 | try ▸ if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b32f60a5 | this.Load | FP00590_Plan_Control.cs:246 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4a5129ae | this.Load | FP00590_Plan_Control.cs:247 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d0cbbbae | this.Load | FP00590_Plan_Control.cs:248 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-704b7cfc | this.Load | FP00590_Plan_Control.cs:254 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-fcffa666 | this.Load | FP00590_Plan_Control.cs:255 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_Plan_Control.InitSpread

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e08cec8e | this.Load [try] | FP00590_Plan_Control.cs:321 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0571854b | this.Load [try] | FP00590_Plan_Control.cs:324 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8e361924 | this.Load [try] | FP00590_Plan_Control.cs:329 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37ea4bff | this.Load [try] | FP00590_Plan_Control.cs:332 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-00316742 | this.Load [try] | FP00590_Plan_Control.cs:333 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-92b595ea | this.Load [try] | FP00590_Plan_Control.cs:334 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.WOW_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8e7af0ab | this.Load [try] | FP00590_Plan_Control.cs:335 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ROLE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-856ef5b7 | this.Load [try] | FP00590_Plan_Control.cs:336 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ROLE_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-32a6b299 | this.Load [try] | FP00590_Plan_Control.cs:337 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6809dd1c | this.Load [try] | FP00590_Plan_Control.cs:338 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_01_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-696a12dc | this.Load [try] | FP00590_Plan_Control.cs:339 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_01_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9c691461 | this.Load [try] | FP00590_Plan_Control.cs:340 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_02_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6f344c36 | this.Load [try] | FP00590_Plan_Control.cs:341 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_02_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0d11f74c | this.Load [try] | FP00590_Plan_Control.cs:342 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_03_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-25313e3e | this.Load [try] | FP00590_Plan_Control.cs:343 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_03_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c982ba84 | this.Load [try] | FP00590_Plan_Control.cs:344 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_03_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1926b63f | this.Load [try] | FP00590_Plan_Control.cs:345 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_04_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5ca7b9eb | this.Load [try] | FP00590_Plan_Control.cs:346 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_04_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-046f47ff | this.Load [try] | FP00590_Plan_Control.cs:347 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_05_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a1d91cca | this.Load [try] | FP00590_Plan_Control.cs:348 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_05_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e53991d2 | this.Load [try] | FP00590_Plan_Control.cs:349 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_06_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c676c65b | this.Load [try] | FP00590_Plan_Control.cs:350 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_06_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cd791065 | this.Load [try] | FP00590_Plan_Control.cs:351 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_06_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7e4db33a | this.Load [try] | FP00590_Plan_Control.cs:352 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2ae29759 | this.Load [try] | FP00590_Plan_Control.cs:353 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_USER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-34636b2a | this.Load [try] | FP00590_Plan_Control.cs:360 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d02899cd | this.Load [try] | FP00590_Plan_Control.cs:363 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d2e89d00 | this.Load [try] | FP00590_Plan_Control.cs:365 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f874ebaa | this.Load [try] | FP00590_Plan_Control.cs:368 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ENGINE_STATUS)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4df6e706 | this.Load [try] | FP00590_Plan_Control.cs:369 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d8e71570 | this.Load [try] | FP00590_Plan_Control.cs:370 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c93c94ad | this.Load [try] | FP00590_Plan_Control.cs:371 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_START)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cc75fb76 | this.Load [try] | FP00590_Plan_Control.cs:372 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_END)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a7dc8ec3 | this.Load [try] | FP00590_Plan_Control.cs:375 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ENGINE_STATUS), siSub.GetColumnIndex(DefColumns.STATUS_MS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-560e9b5f | this.Load [try] | FP00590_Plan_Control.cs:383 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_Plan_Control.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89947641 | popSql.OnSql | FP00590_Plan_Control.cs:1866 | if (programID == "PR_UI_FP00590_PLAN_CONTROL") | RETURN | return Find_Data_Main(pSiteID, pPlanGroup, pPlanDate, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-bf95cee2 | popSql.OnSql | FP00590_Plan_Control.cs:1875 | else of (programID == "PR_UI_FP00590_PLAN_CONTROL") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7ed1b72 | popSql.OnSql | FP00590_Plan_Control.cs:1876 | else of (programID == "PR_UI_FP00590_PLAN_CONTROL") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_AF_MASTER_VALIDATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-76bdeb3b | popSql.OnSql | FP00590_Plan_Control.cs:1877 | else of (programID == "PR_UI_FP00590_PLAN_CONTROL") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7b4111b | popSql.OnSql | FP00590_Plan_Control.cs:1878 | else of (programID == "PR_UI_FP00590_PLAN_CONTROL") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3026c408 | popSql.OnSql | FP00590_Plan_Control.cs:1889 | else of (programID == "PR_UI_FP00590_PLAN_CONTROL") ▸ else of (programID == "PR_UI_FP00590_VALIDATION") ▸ if (programID == "PR_UI_FP00590_EN… | RETURN | return Find_Data_Sub("SQL", pPlanGroup, pPlanID); |  | 처리 중단/반환 |  |  |  |
| AC-eb4cdad5 | popSql.OnSql | FP00590_Plan_Control.cs:1893 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_Plan_Control.Save_End_Action

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42afa545 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:927 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54a39d5a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:928 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19aeec85 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:931 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d79f9d8e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:941 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-87ccc28e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:957 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-298db308 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:963 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-61aae7c0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:967 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f2c5ba7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:968 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { ex.Message.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31ee4dab | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:973 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7d800ede | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:974 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.Save_End_Action_Run

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6161e97 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1024 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-541425c1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1025 | try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5db01b0d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1027 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-8e5cee66 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1028 | try | DATA_OP | request.Parameters["p_sys_flag"] | "UPDATE_STATUS" | 행/컬럼 값 대입 |  |  |  |
| AC-61e643fa | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1029 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-91c0657a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1030 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-64f6be51 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1031 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-26f5128d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1032 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-25032ac7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1033 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-f286e953 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1034 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-b6ada0b1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1035 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-08fa5b71 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1036 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e7aee7a5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1037 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-49c89cd5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1038 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2fd447de | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1039 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-56be8a88 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1040 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0542b97a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1041 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-febcccf0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1042 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-91669182 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1043 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fb96c105 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1044 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-556e77b6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1045 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4aa5a142 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1046 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f160ead1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1047 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-648f7ab7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1048 | try | DATA_OP | request.Parameters["p_wow_id"] | p_wow_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2edac2a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1050 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-971f3820 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1051 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3c4121f1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00590_Plan_Control.cs:1063 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_Plan_Control.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5866667 | SaveButton | FP00590_Plan_Control.cs:465 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8feda87 | SaveButton | FP00590_Plan_Control.cs:466 |  | MESSAGE | MessageBox.Show | ("Save button[F7] can't use!") | 메시지 표시 |  |  |  |

## FP00590_Plan_Control.SetChangedControl

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f9e3bde | cboSite.SelectedIndexChanged | FP00590_Plan_Control.cs:270 | try | FLAG | dtLocalPlanGroup | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findInstance", sDataID, "I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-64c4ab6e | cboSite.SelectedIndexChanged | FP00590_Plan_Control.cs:270 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findInstance", sDataID, "INSTANCE_ID") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23760676 | cboSite.SelectedIndexChanged | FP00590_Plan_Control.cs:271 | try | LIST_REBIND | clsCtrl.setListBox | (dtLocalPlanGroup, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c6f0090c | cboSite.SelectedIndexChanged | FP00590_Plan_Control.cs:275 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ba178ec | cboSite.SelectedIndexChanged | FP00590_Plan_Control.cs:280 | try | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-f22dd343 | cboSite.SelectedIndexChanged | FP00590_Plan_Control.cs:284 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |

## FP00590_Plan_Control.SetInitMainSheetByRevision

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda ▸ if (ds != null)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4d7c2d6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1909 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e60470d7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1910 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7193aba9 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1911 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b9b5b80 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1912 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f29c6de | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1913 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-040831aa | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1914 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("INSERT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e5fdf92 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1915 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("INSERT_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65907ed2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1916 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("CONFIRM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83600581 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1917 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dtResult.Columns.Add | ("CONFIRM_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14c68961 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1920 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c74d9c98 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1936 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-4874f0ad | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1941 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.INSERT_ID), dtResult.Rows[0]["INSERT_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-5844e893 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1942 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.DESCRIPTION), dtResult.Rows[0]["DESCRIPTION"].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-ff599dcd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1943 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), dtResult.Rows[0]["CONFIRM_ID"].ToString(… | 그리드 값 설정 |  |  |  |
| AC-b2bef0f1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1944 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), dtResult.Rows[0]["CONFIRM_TIME"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-70e0e1fa | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1948 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.INSERT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9b77cb2b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1949 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-7e3b715d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1950 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d243716a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1951 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-89cd1b92 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1953 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | CALL_EXT | spdMain.Update | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d490fa7b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1954 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision != null) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00590_Plan_Control.SetMainSheetControl

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda ▸ if (ds != null)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab945d97 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1965 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sPlanGroup | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-886f21c5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1966 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sScpProductTarget | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cef7b508 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1967 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sMasterValidation | siMain.GetValue(1, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-09fc51fe | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1968 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sPlanIDCreate | siMain.GetValue(2, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-debe6b03 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1969 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sRevision | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2baf23b5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1970 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sRelease | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b29e9301 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1974 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | btncellType | new FarPoint.Win.Spread.CellType.ButtonCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d9ea05c5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1975 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ButtonColor | Color.DarkGray | 속성 ButtonColor 설정 |  |  |  |
| AC-8a9a280b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1976 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.DarkColor | Color.DarkCyan | 속성 DarkColor 설정 |  |  |  |
| AC-af4d6d49 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1977 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.LightColor | Color.AliceBlue | 속성 LightColor 설정 |  |  |  |
| AC-8bb63d63 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1978 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TwoState | false | 속성 TwoState 설정 |  |  |  |
| AC-bd520e8b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1979 | if (siMain.ActiveSheet.RowCount > 0) | VALUE_SET | btncellType.Text | _sMasterValidation | 컨트롤 값 설정 |  |  |  |
| AC-4d06f789 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1980 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TextDown | _sMasterValidation | 속성 TextDown 설정 |  |  |  |
| AC-6a514f03 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1981 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ShadowSize | 3 | 속성 ShadowSize 설정 |  |  |  |
| AC-8a8a4f1c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1982 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[1, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)].CellType | btncellType | 그리드 속성/값 설정 |  |  |  |
| AC-7b6ae9a6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1985 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | btncellType | new FarPoint.Win.Spread.CellType.ButtonCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-439b1a81 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1986 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ButtonColor | Color.DarkGray | 속성 ButtonColor 설정 |  |  |  |
| AC-4c1445f1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1987 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.DarkColor | Color.DarkCyan | 속성 DarkColor 설정 |  |  |  |
| AC-1de9f605 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1988 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.LightColor | Color.AliceBlue | 속성 LightColor 설정 |  |  |  |
| AC-46254baa | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1989 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TwoState | false | 속성 TwoState 설정 |  |  |  |
| AC-fe61a36b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1990 | if (siMain.ActiveSheet.RowCount > 0) | VALUE_SET | btncellType.Text | _sPlanIDCreate | 컨트롤 값 설정 |  |  |  |
| AC-2183abd5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1991 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TextDown | _sPlanIDCreate | 속성 TextDown 설정 |  |  |  |
| AC-381ac795 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1992 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ShadowSize | 3 | 속성 ShadowSize 설정 |  |  |  |
| AC-951719fb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1993 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[2, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)].CellType | btncellType | 그리드 속성/값 설정 |  |  |  |
| AC-08bf43bb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1996 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | btncellType | new FarPoint.Win.Spread.CellType.ButtonCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-30d38314 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1997 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ButtonColor | Color.DarkGray | 속성 ButtonColor 설정 |  |  |  |
| AC-383b88d7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1998 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.DarkColor | Color.DarkCyan | 속성 DarkColor 설정 |  |  |  |
| AC-5143813d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:1999 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.LightColor | Color.AliceBlue | 속성 LightColor 설정 |  |  |  |
| AC-6bf17665 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2000 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TwoState | false | 속성 TwoState 설정 |  |  |  |
| AC-213d85ba | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2001 | if (siMain.ActiveSheet.RowCount > 0) | VALUE_SET | btncellType.Text | _sRelease | 컨트롤 값 설정 |  |  |  |
| AC-c8fcb0ef | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2002 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TextDown | _sRelease | 속성 TextDown 설정 |  |  |  |
| AC-fb09b940 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2003 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ShadowSize | 3 | 속성 ShadowSize 설정 |  |  |  |
| AC-2e1402d0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2004 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[3, siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)].CellType | btncellType | 그리드 속성/값 설정 |  |  |  |
| AC-8369d5fc | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2007 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | dtRevision | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-51d82f99 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2007 | if (siMain.ActiveSheet.RowCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, pPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4242655c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2013 | if (siMain.ActiveSheet.RowCount > 0) ▸ foreach (DataRow dr in dtRevision.Rows) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b18922ce | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2014 | if (siMain.ActiveSheet.RowCount > 0) ▸ foreach (DataRow dr in dtRevision.Rows) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-29bbd819 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2016 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | combocellType | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e8ebd269 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2017 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.ItemData | (string[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-88774aa5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2018 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.Items | (string[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-36c54d4f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2019 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-a01993cf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2020 | if (siMain.ActiveSheet.RowCount > 0) | STATE | combocellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-7ffd88bf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2021 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.MaxDrop | 10 | 속성 MaxDrop 설정 |  |  |  |
| AC-a98b8af2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2022 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | this.siMain.ActiveSheet.Cells.Get(3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).Bac… | Color.Aqua | 그리드 속성/값 설정 |  |  |  |
| AC-a7eb31ea | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2022 | if (siMain.ActiveSheet.RowCount > 0) | CALL_EXT | this.siMain.ActiveSheet.Cells.Get | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afc3dc37 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2024 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.ButtonAlign | FarPoint.Win.ButtonAlign.Right | 속성 ButtonAlign 설정 |  |  |  |
| AC-66340c73 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2025 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)].CellType | combocellType | 그리드 속성/값 설정 |  |  |  |
| AC-c743e3be | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2029 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevision.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), _sRevision) | 그리드 값 설정 |  |  |  |
| AC-3fa47f31 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2036 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (dtRevision.Rows.Count > 0) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |

## FP00590_Plan_Control.SetspdMainLock

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda ▸ if (ds != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3db5b66a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2106 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.WOW_NAME), 3, siMain.GetColumnIndex(DefColumns.WOW_NA… | 그리드 편집 잠금 전환 |  |  |  |
| AC-7a49a188 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2108 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME), 0, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-70923dea | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2109 |  | GRID_LOCK | siMain.LockRange2 | (2, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME), 2, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-1c9573b8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2110 |  | GRID_LOCK | siMain.LockRange2 | (3, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME), 3, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8b235d3b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2112 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), 1, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-6e1bbb14 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2113 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME), 3, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-aa7a0eba | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2115 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_05_NAME), 3, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-01d5f2e5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2116 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.STATUS), 2, siMain.GetColumnIndex(DefColumns.STATUS),… | 그리드 편집 잠금 전환 |  |  |  |
| AC-dbf5f023 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2117 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.INSERT_ID), 3, siMain.GetColumnIndex(DefColumns.INSER… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e363b531 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2118 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.DESCRIPTION), 3, siMain.GetColumnIndex(DefColumns.DES… | 그리드 편집 잠금 전환 |  |  |  |
| AC-8664d187 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2119 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), 3, siMain.GetColumnIndex(DefColumns.CONF… | 그리드 편집 잠금 전환 |  |  |  |
| AC-14edf617 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00590_Plan_Control.cs:2120 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), 3, siMain.GetColumnIndex(DefColumns.CO… | 그리드 편집 잠금 전환 |  |  |  |

## FP00590_Plan_Control.SpdMain_CellClick

진입점: this.spdMain.CellClick / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc8f1528 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1464 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-fc84b37c | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1465 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9143a559 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1481 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (this.ViewModel != null) ▸ if (!V… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a49a273 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1482 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (this.ViewModel != null) ▸ if (!V… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82ab5f45 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1494 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforSite != sSite) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ffabb2aa | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1495 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforSite != sSite) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65211e71 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1499 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforePlanDate != sPlanDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af5502ad | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1500 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforePlanDate != sPlanDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15e13da0 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1503 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d865aac | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1517 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47b8ccc1 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1518 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed26e3d3 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1529 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8102d7f | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1530 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7ee9ba2 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1534 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdb0e3ec | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1535 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df6f8c61 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1539 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | dtPlanRunFlag | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findIsRunningPlan", sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5b3c3f75 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1539 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5269ac38 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1546 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bb62502 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1547 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdb9e598 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1552 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtLocalPlanGroup.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-449d399d | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1553 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-09e5c6de | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1558 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8ea4b227 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1562 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-12ac31ff | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1564 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-53521748 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1565 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aafdc6bf | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1566 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-075535a6 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1575 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | dtRevision | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", sPlanGroup,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-eef4ae1f | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1575 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-398d2cd0 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1578 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea32d405 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1579 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88acf0a4 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1583 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Rows.Add | (dr["CODE"].ToString(), dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-340ec579 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1588 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0bd9157a | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1594 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-be7e8b95 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1637 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63367d51 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1638 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc49b790 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1650 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af95693a | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1651 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96937b8a | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1655 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6883d50a | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1656 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81a63500 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1662 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51a99530 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1663 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3384ab7d | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1667 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | FLAG | dtEngineFlag | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findEngineFlag", sPlanGrou… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7d22b5e0 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1667 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0c819c4 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1674 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f720c6b | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1675 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2375ba69 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1682 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-412792d2 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1683 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c08c30f3 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1718 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtLocalPlanGroup.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44de9670 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1719 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bad843a5 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1726 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtRevision.Select | (string.Format("PLAN_ID = '{0}'", sPlanID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37e1c735 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1727 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | drs3.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-277de1b1 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1729 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtResult.Columns.Add | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff35e849 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1733 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ca87af4 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1738 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-76552805 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1753 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2c97147 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1759 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b237cb52 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1763 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-76e5e4f9 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1765 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-e1f1856a | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1766 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c8581dc3 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1767 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e5d1c807 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1780 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-59da3d55 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1783 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-ed177c78 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1784 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-99603049 | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1785 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6db3179b | this.spdMain.CellClick 외 1 | FP00590_Plan_Control.cs:1797 | if (siMain != null) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00590_Plan_Control.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddc65874 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1388 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (chkStatus.Checked == true) | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-22237469 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1398 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e51aed8a | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1399 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dad465f6 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1400 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6281eac6 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1401 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a469f8d | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1402 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-951477ed | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1403 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("INSERT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a70c07c3 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1404 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("INSERT_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52c86756 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1405 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("CONFIRM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6175289d | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1406 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Columns.Add | ("CONFIRM_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e84b5892 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1409 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f2a7b04 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1417 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-8e78844f | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1422 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.INSERT_ID), dtResult.Rows[0]["INSERT_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-3cd89c7b | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1423 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.DESCRIPTION), dtResult.Rows[0]["DESCRIPTION"].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-fb19b5f3 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1424 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), dtResult.Rows[0]["CONFIRM_ID"].ToString(… | 그리드 값 설정 |  |  |  |
| AC-ac191b04 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1425 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), dtResult.Rows[0]["CONFIRM_TIME"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-90c1bf99 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1429 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.INSERT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-8fbaf803 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1430 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-3bc79da8 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1431 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6853bd45 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1432 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-7cb78388 | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1434 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | CALL_EXT | spdMain.Update | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e56673a | this.spdMain.ComboSelChange | FP00590_Plan_Control.cs:1435 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevision.Rows.… | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00590_PlanInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f727b538 | .ctor | FP00590_PlanInfoPopup.cs:92 |  | FLAG | this._sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-9162d701 | .ctor | FP00590_PlanInfoPopup.cs:93 |  | FLAG | this._sPlanGroup | pPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-77c3c98f | .ctor | FP00590_PlanInfoPopup.cs:94 |  | FLAG | this._sPlanDate | pPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-37d52528 | .ctor | FP00590_PlanInfoPopup.cs:95 |  | FLAG | this._sPlanID | pPlanID | 화면 필드/플래그 변경 |  |  |  |

## FP00590_PlanInfoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-628618cf | this.btnClose.Click | FP00590_PlanInfoPopup.cs:184 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_PlanInfoPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f3ee710 | this.btnSql.Click | FP00590_PlanInfoPopup.cs:190 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-aa0430ad | this.btnSql.Click | FP00590_PlanInfoPopup.cs:191 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed4c2800 | this.btnSql.Click | FP00590_PlanInfoPopup.cs:193 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_PLANINFO_UPDATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-835ea983 | this.btnSql.Click | FP00590_PlanInfoPopup.cs:194 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_PlanInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbeb23bf | this.Load | FP00590_PlanInfoPopup.cs:166 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_PlanInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a2c8897 | Dispose | FP00590_PlanInfoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_PlanInfoPopup.Find_Data

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4159d4ed | this.btnFind.Click | FP00590_PlanInfoPopup.cs:203 |  | FLAG | dtPlanInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findPlanInfo", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c5c503ce | this.btnFind.Click | FP00590_PlanInfoPopup.cs:203 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findPlanInfo", _sPlanGroup, _sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-30fc38da | this.btnFind.Click | FP00590_PlanInfoPopup.cs:207 | if (dtPlanInfo.Rows.Count > 0) | FLAG | _sSite | dtPlanInfo.Rows[0]["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3b42f02 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:208 | if (dtPlanInfo.Rows.Count > 0) | FLAG | _sPlanGroup | dtPlanInfo.Rows[0]["INSTANCE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-59adbe0c | this.btnFind.Click | FP00590_PlanInfoPopup.cs:209 | if (dtPlanInfo.Rows.Count > 0) | FLAG | _sPlanID | dtPlanInfo.Rows[0]["PLAN_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b72f54d6 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:210 | if (dtPlanInfo.Rows.Count > 0) | FLAG | _sPlanDate | dtPlanInfo.Rows[0]["PLAN_START_TIME"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-baa1e695 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:212 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtPlanType.Text | dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ca9b42f7 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:213 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtStartDate.Text | dtPlanInfo.Rows[0]["PLAN_START_TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-15496849 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:214 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtEndDate.Text | dtPlanInfo.Rows[0]["PLAN_END_TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ea9999f2 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:215 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtPlanHorizon.Text | ((int)Convert.ToDouble(dtPlanInfo.Rows[0]["PLAN_HORIZON"].ToString())).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-12c5f78b | this.btnFind.Click | FP00590_PlanInfoPopup.cs:216 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtFixOption.Text | dtPlanInfo.Rows[0]["PRE_FIX_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bcf0dce5 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:218 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtFixDate.Text | dtPlanInfo.Rows[0]["PRE_FIX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cf4b2c68 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:219 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtConfigSet.Text | dtPlanInfo.Rows[0]["CONFIG_SET_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d5d4a65d | this.btnFind.Click | FP00590_PlanInfoPopup.cs:220 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtBasisPlan.Text | dtPlanInfo.Rows[0]["BASIS_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fbd92633 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:221 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtDemandHorizon.Text | ((int)Convert.ToDouble(dtPlanInfo.Rows[0]["DEMAND_HORIZON"].ToString())).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e6de0e11 | this.btnFind.Click | FP00590_PlanInfoPopup.cs:222 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtAmendFixDate.Text | dtPlanInfo.Rows[0]["AMEND_FIX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP00590_PlanInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09a5feb8 | this.Load | FP00590_PlanInfoPopup.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f74321f0 | this.Load | FP00590_PlanInfoPopup.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00590_PlanInfoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-337b98bd | this.Load | FP00590_PlanInfoPopup.cs:122 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7edc4cc2 | this.Load | FP00590_PlanInfoPopup.cs:126 |  | FLAG | dtLocalPlanGroup | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findInstance", _sSite, "IN… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-37574512 | this.Load | FP00590_PlanInfoPopup.cs:126 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findInstance", _sSite, "INSTANCE_ID") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f5f3ed1 | this.Load | FP00590_PlanInfoPopup.cs:129 |  | FLAG | dtRevision | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-2799166f | this.Load | FP00590_PlanInfoPopup.cs:129 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d6590f7 | this.Load | FP00590_PlanInfoPopup.cs:130 |  | LIST_REBIND | clsCtrl.setListBox | (dtRevision, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c8c47408 | this.Load | FP00590_PlanInfoPopup.cs:131 |  | VALUE_SET | cboPlanID.SelectedValue | _sPlanID | 컨트롤 값 설정 |  |  |  |
| AC-0e20c789 | this.Load | FP00590_PlanInfoPopup.cs:134 |  | FLAG | dtPlanInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findPlanInfo", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b2719f8f | this.Load | FP00590_PlanInfoPopup.cs:134 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findPlanInfo", _sPlanGroup, _sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-071e9366 | this.Load | FP00590_PlanInfoPopup.cs:138 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtPlanType.Text | dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-535d5fd3 | this.Load | FP00590_PlanInfoPopup.cs:139 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtStartDate.Text | dtPlanInfo.Rows[0]["PLAN_START_TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f4740f25 | this.Load | FP00590_PlanInfoPopup.cs:140 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtEndDate.Text | dtPlanInfo.Rows[0]["PLAN_END_TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7e961ddd | this.Load | FP00590_PlanInfoPopup.cs:141 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtPlanHorizon.Text | ((int)Convert.ToDouble(dtPlanInfo.Rows[0]["PLAN_HORIZON"].ToString())).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cc4438e5 | this.Load | FP00590_PlanInfoPopup.cs:142 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtFixOption.Text | dtPlanInfo.Rows[0]["PRE_FIX_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d99bf05d | this.Load | FP00590_PlanInfoPopup.cs:144 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtFixDate.Text | dtPlanInfo.Rows[0]["PRE_FIX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b0305c1c | this.Load | FP00590_PlanInfoPopup.cs:145 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtConfigSet.Text | dtPlanInfo.Rows[0]["CONFIG_SET_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c1a1bccd | this.Load | FP00590_PlanInfoPopup.cs:146 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtBasisPlan.Text | dtPlanInfo.Rows[0]["BASIS_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-15350f55 | this.Load | FP00590_PlanInfoPopup.cs:147 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtDemandHorizon.Text | ((int)Convert.ToDouble(dtPlanInfo.Rows[0]["DEMAND_HORIZON"].ToString())).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ec3da683 | this.Load | FP00590_PlanInfoPopup.cs:148 | if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtAmendFixDate.Text | dtPlanInfo.Rows[0]["AMEND_FIX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f041a05e | this.Load | FP00590_PlanInfoPopup.cs:157 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9027be4d | this.Load | FP00590_PlanInfoPopup.cs:158 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2aadf87c | this.Load | FP00590_PlanInfoPopup.cs:159 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00590_PlanInfoPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8478cad4 | popSql.OnSql | FP00590_PlanInfoPopup.cs:353 | if (programID == "PR_UI_FP00590_PLANINFO_UPDATE") | RETURN | return Save_Data_PlanInfo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-cf17c562 | popSql.OnSql | FP00590_PlanInfoPopup.cs:355 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanInfoPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6863d5e | this.btnSave.Click | FP00590_PlanInfoPopup.cs:243 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d7133a5 | this.btnSave.Click | FP00590_PlanInfoPopup.cs:250 | try ▸ else of (dsResult == null) ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c3534b2 | this.btnSave.Click | FP00590_PlanInfoPopup.cs:255 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00590_PlanInfoPopup.Save_Data_PlanInfo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDATE")] / this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84c95d6 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:272 | if (txtPlanHorizon.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { " 0 " }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-438dc0c7 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:273 | if (txtPlanHorizon.Text == "") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3ac0f61f | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:277 | else of (txtPlanHorizon.Text == "") ▸ if (txtPlanType.Text.ToString() == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Plan Type" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e26d47b | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:278 | else of (txtPlanHorizon.Text == "") ▸ if (txtPlanType.Text.ToString() == "") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-498bca6c | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:284 | if (string.IsNullOrEmpty(p_plan_id)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Plan ID is null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e98f4792 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:285 | if (string.IsNullOrEmpty(p_plan_id)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-073aaa50 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:295 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-c964c183 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:296 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-68b07d31 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:297 | try | DATA_OP | request.Parameters["p_sys_flag"] | "UPDATE_PLANIFO" | 행/컬럼 값 대입 |  |  |  |
| AC-11c543bf | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:298 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c419e63 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:299 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c3168f89 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:301 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-5bde3e8e | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:302 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-fa869d71 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:303 | try | DATA_OP | request.Parameters["p_plan_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-eea6e1e5 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:304 | try | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-3bdeff05 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:306 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ab1818ca | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:307 | try | DATA_OP | request.Parameters["p_plan_horizon"] | p_plan_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-6fd3b087 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:308 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-79cd5bc7 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:309 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e7f3452e | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:310 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-15d2fc8a | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:311 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e50befac | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:312 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-01b3b26b | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:313 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a1c990ae | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:314 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8bb031cc | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:315 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d7ab446 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:316 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-01ad25af | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:317 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-73472efb | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:318 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c2143098 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:319 | try | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fcb9bd66 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:321 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80b602a9 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:323 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-52e14706 | popSql.OnSql [if (programID == "PR_UI_FP00590_PLANINFO_UPDAT… 외 1 | FP00590_PlanInfoPopup.cs:328 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50c4f838 | .ctor | FP00590_PlanTotalPopup.cs:171 |  | FLAG | _sSite | sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-3db74233 | .ctor | FP00590_PlanTotalPopup.cs:172 |  | FLAG | _sPlanGroup | sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-d2b6ce8b | .ctor | FP00590_PlanTotalPopup.cs:173 |  | FLAG | _sPlanDate | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-aa54e7a1 | .ctor | FP00590_PlanTotalPopup.cs:174 |  | FLAG | _sPlanID | sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-76d7679d | .ctor | FP00590_PlanTotalPopup.cs:175 |  | FLAG | dtLocalPlanGroup | _dtParam.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-826e286d | .ctor | FP00590_PlanTotalPopup.cs:175 |  | DATA_OP | _dtParam.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1dd70045 | .ctor | FP00590_PlanTotalPopup.cs:179 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.SITE_ID | _sSite | 속성 SITE_ID 설정 |  |  |  |
| AC-c1f88d1a | .ctor | FP00590_PlanTotalPopup.cs:180 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.INSTANCE_ID | dtLocalPlanGroup.Rows[0]["CODE"].ToString() | 속성 INSTANCE_ID 설정 |  |  |  |
| AC-4af50736 | .ctor | FP00590_PlanTotalPopup.cs:181 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.INSTANCE_NAME | dtLocalPlanGroup.Rows[0]["NAME"].ToString() | 속성 INSTANCE_NAME 설정 |  |  |  |
| AC-5c05e4d2 | .ctor | FP00590_PlanTotalPopup.cs:182 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_DATE | _sPlanDate | 속성 PLAN_DATE 설정 |  |  |  |
| AC-5eb432e3 | .ctor | FP00590_PlanTotalPopup.cs:183 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_ID | _sPlanID | 속성 PLAN_ID 설정 |  |  |  |
| AC-eb8b2cff | .ctor | FP00590_PlanTotalPopup.cs:184 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.CONFIRM_AREA | dtLocalPlanGroup.Rows[0]["CONFIRM_AREA"].ToString() | 속성 CONFIRM_AREA 설정 |  |  |  |
| AC-56843564 | .ctor | FP00590_PlanTotalPopup.cs:185 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.IS_SAME_PLAN_ID | dtLocalPlanGroup.Rows[0]["IS_SAME_PLAN_ID"].ToString() | 속성 IS_SAME_PLAN_ID 설정 |  |  |  |
| AC-456b3be5 | .ctor | FP00590_PlanTotalPopup.cs:186 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.USE_WOW_STATUS | dtLocalPlanGroup.Rows[0]["USE_WOW_STATUS"].ToString() | 속성 USE_WOW_STATUS 설정 |  |  |  |
| AC-f9ec01c3 | .ctor | FP00590_PlanTotalPopup.cs:187 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.AMEND_TYPE | dtLocalPlanGroup.Rows[0]["AMEND_TYPE"].ToString() | 속성 AMEND_TYPE 설정 |  |  |  |
| AC-2b9d35e5 | .ctor | FP00590_PlanTotalPopup.cs:188 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.FIX_DATE_SYNC | dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() | 속성 FIX_DATE_SYNC 설정 |  |  |  |
| AC-a4d99f8b | .ctor | FP00590_PlanTotalPopup.cs:189 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.SYNC_YN | dtLocalPlanGroup.Rows[0]["SYNC_YN"].ToString() | 속성 SYNC_YN 설정 |  |  |  |
| AC-d40d2bae | .ctor | FP00590_PlanTotalPopup.cs:190 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_TARGET_ID | "" | 속성 PRE_FIX_TARGET_ID 설정 |  |  |  |
| AC-14c10f49 | .ctor | FP00590_PlanTotalPopup.cs:191 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_FLAG | "N" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-ea4ac0b7 | .ctor | FP00590_PlanTotalPopup.cs:192 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_TYPE | "" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-30f28b01 | .ctor | FP00590_PlanTotalPopup.cs:193 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_DATE | "" | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-c130b7ae | .ctor | FP00590_PlanTotalPopup.cs:194 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_TYPE | "" | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-3c2bdbfc | .ctor | FP00590_PlanTotalPopup.cs:195 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_END_TIME | "" | 속성 PLAN_END_TIME 설정 |  |  |  |
| AC-408d9b4c | .ctor | FP00590_PlanTotalPopup.cs:196 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_HORIZON | "" | 속성 PLAN_HORIZON 설정 |  |  |  |
| AC-5765fbe9 | .ctor | FP00590_PlanTotalPopup.cs:197 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.DEMAND_HORIZON | "" | 속성 DEMAND_HORIZON 설정 |  |  |  |
| AC-286ecf82 | .ctor | FP00590_PlanTotalPopup.cs:198 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.DESCRIPTION | "" | 속성 DESCRIPTION 설정 |  |  |  |
| AC-6f72fb5a | .ctor | FP00590_PlanTotalPopup.cs:199 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.BASIS_PLAN_ID | "" | 속성 BASIS_PLAN_ID 설정 |  |  |  |
| AC-a703d635 | .ctor | FP00590_PlanTotalPopup.cs:200 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.SYNC_OPERATION_ID | "" | 속성 SYNC_OPERATION_ID 설정 |  |  |  |
| AC-0910d00d | .ctor | FP00590_PlanTotalPopup.cs:201 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_DATE2 | "" | 속성 PRE_FIX_DATE2 설정 |  |  |  |
| AC-828340e3 | .ctor | FP00590_PlanTotalPopup.cs:202 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_TYPE2 | "" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-a1f2674a | .ctor | FP00590_PlanTotalPopup.cs:203 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_2_FLAG | "" | 속성 PRE_FIX_2_FLAG 설정 |  |  |  |
| AC-12d29c21 | .ctor | FP00590_PlanTotalPopup.cs:204 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.ALLOWFIXDATENULL | "" | 속성 ALLOWFIXDATENULL 설정 |  |  |  |

## FP00590_PlanTotalPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96be1773 | this.btnClose.Click | FP00590_PlanTotalPopup.cs:1165 | if (blnCreateRun == false) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ef7c8371 | this.btnClose.Click | FP00590_PlanTotalPopup.cs:1169 | else of (blnCreateRun == false) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_PlanTotalPopup.btnCreatePlan_ClickAsync

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a17280f | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:658 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4ff116d | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:659 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cfa3a35 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:666 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", DsinData.INSTANCE_ID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a3a5edf | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:679 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_CREATE_PLAN_LIMIT_YN == "Y") | MESSAGE | MessageHelper.GMessageBox | ("Unable to create a FP plan ID. Contact GSCM.FP PI representative for details.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27333ace | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:680 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_CREATE_PLAN_LIMIT_YN == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-635fe1e2 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:687 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_CREATE_PLAN_FIX_DATE_YN == "Y") ▸ if (DsinData.PRE_FIX_DATE != _CREATE_PLAN_FI… | MESSAGE | MessageHelper.GMessageBox | ("Enter the fix date below. : " + _CREATE_PLAN_FIX_DATE) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f419051 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:688 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_CREATE_PLAN_FIX_DATE_YN == "Y") ▸ if (DsinData.PRE_FIX_DATE != _CREATE_PLAN_FI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82fa5f1f | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:696 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_CREATE_PLAN_FIX_TYPE_YN == "Y") ▸ if (DsinData.PRE_FIX_TYPE != _CREATE_PLAN_FI… | MESSAGE | MessageHelper.GMessageBox | ("Enter the fix date below. : " + _CREATE_PLAN_FIX_DATE) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0d1e85a | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:697 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_CREATE_PLAN_FIX_TYPE_YN == "Y") ▸ if (DsinData.PRE_FIX_TYPE != _CREATE_PLAN_FI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faf041be | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:710 | if (rdoGroup1.SelectedIndex == 1) ▸ if (string.IsNullOrEmpty(sBasePlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Target Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8a0df17 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:711 | if (rdoGroup1.SelectedIndex == 1) ▸ if (string.IsNullOrEmpty(sBasePlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e377297 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:717 | if (string.IsNullOrEmpty(txtDescription.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Description" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b54fefa | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:718 | if (string.IsNullOrEmpty(txtDescription.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d55f4f2a | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:731 | if (sConfirmArea.Equals("PLAN GROUP") && sUseWowStatus.Equals("Y")) | FLAG | dtStepValid | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_getStepValid", _sPlan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-08dab4a3 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:731 | if (sConfirmArea.Equals("PLAN GROUP") && sUseWowStatus.Equals("Y")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_getStepValid", _sPlanGroup, _sPlanDate, sStep) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-67ee99ca | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:758 | if (sConfirmArea.Equals("PLAN GROUP") && sUseWowStatus.Equals("Y")) ▸ if (bValid == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a665d0c9 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:759 | if (sConfirmArea.Equals("PLAN GROUP") && sUseWowStatus.Equals("Y")) ▸ if (bValid == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0f01895 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:768 | if (_sPlanGroup.IndexOf("FORM") != -1) | FLAG | dtCheckMasterInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_checkMasterInfo", _sP… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-2e1ee187 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:768 | if (_sPlanGroup.IndexOf("FORM") != -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_checkMasterInfo", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-419555e8 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:775 | if (_sPlanGroup.IndexOf("FORM") != -1) ▸ if (dtCheckMasterInfo != null) ▸ if (dtCheckMasterInfo.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91909a1a | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:776 | if (_sPlanGroup.IndexOf("FORM") != -1) ▸ if (dtCheckMasterInfo != null) ▸ if (dtCheckMasterInfo.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f51ddc9c | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:781 | if (_sPlanGroup.IndexOf("FORM") != -1) ▸ else of (dtCheckMasterInfo != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90aa59d1 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:782 | if (_sPlanGroup.IndexOf("FORM") != -1) ▸ else of (dtCheckMasterInfo != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-915919e3 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:791 | if (_sPlanGroup.IndexOf("_E_PRE") != -1 && rdoGroup1.SelectedIndex == 1) ▸ if (string.IsNullOrEmpty(DsinData.PRE_FIX_DATE)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Fix Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03cc6768 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:792 | if (_sPlanGroup.IndexOf("_E_PRE") != -1 && rdoGroup1.SelectedIndex == 1) ▸ if (string.IsNullOrEmpty(DsinData.PRE_FIX_DATE)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8ea1a46 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:801 | else of (_sPlanGroup.IndexOf("_E_PRE") != -1 && rdoGroup1.SelectedIndex == 1) ▸ if (DsinData.ALLOWFIXDATENULL == "N") ▸ if (string.IsNullOrE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Fix Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e16993e2 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:802 | else of (_sPlanGroup.IndexOf("_E_PRE") != -1 && rdoGroup1.SelectedIndex == 1) ▸ if (DsinData.ALLOWFIXDATENULL == "N") ▸ if (string.IsNullOrE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15cc58d2 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:813 | if (chkPreFix2.Checked == true) ▸ if (string.IsNullOrEmpty(DsinData.PRE_FIX_DATE)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Enter the Fix Date (required for Fix option 2)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68e16acd | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:814 | if (chkPreFix2.Checked == true) ▸ if (string.IsNullOrEmpty(DsinData.PRE_FIX_DATE)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f357871e | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:822 | if (chkPreFix2.Checked == true) ▸ if (DsinData.ALLOWFIXDATENULL.Equals("N")) ▸ if (string.IsNullOrEmpty(DsinData.PRE_FIX_DATE2)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Fix Date 2" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb34e78c | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:823 | if (chkPreFix2.Checked == true) ▸ if (DsinData.ALLOWFIXDATENULL.Equals("N")) ▸ if (string.IsNullOrEmpty(DsinData.PRE_FIX_DATE2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a951ae4a | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:832 | if (chkPreFix2.Checked == true) ▸ if (!string.IsNullOrEmpty(DsinData.PRE_FIX_DATE2)) ▸ if (Convert.ToDouble(DsinData.PRE_FIX_DATE) >= Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "[Fix Date 2] must be later than [Fix Date]!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b02150c | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:833 | if (chkPreFix2.Checked == true) ▸ if (!string.IsNullOrEmpty(DsinData.PRE_FIX_DATE2)) ▸ if (Convert.ToDouble(DsinData.PRE_FIX_DATE) >= Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39dd4c8c | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:841 | if (chkPreFix2.Checked == true) ▸ if ((rdoGroup2.SelectedIndex == 0 && rdoGroup3.SelectedIndex == 0) \|\| (rdoGroup2.SelectedIndex == 1 && r… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "You can not choose the same two [Fix Option] to each other.!"… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7097dc9 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:842 | if (chkPreFix2.Checked == true) ▸ if ((rdoGroup2.SelectedIndex == 0 && rdoGroup3.SelectedIndex == 0) \|\| (rdoGroup2.SelectedIndex == 1 && r… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33448558 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:846 |  | FLAG | dtLocalCurrDate | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_CurrUTDate", _sPlanGr… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a380a288 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:846 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2aa47b6f | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:855 | if (dtLocalCurrDate != null) ▸ if (dtLocalCurrDate.Rows.Count > 0) ▸ if (Convert.ToDouble(_sPlanDate) < Convert.ToDouble(sCurrDate)) | MESSAGE | MessageBox.Show | ("A plan of the past date will be created. Will you proceed?", "Excute", MessageBoxButtons… | 메시지 표시 |  |  |  |
| AC-9f63f834 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:857 | if (dtLocalCurrDate != null) ▸ if (dtLocalCurrDate.Rows.Count > 0) ▸ if (Convert.ToDouble(_sPlanDate) < Convert.ToDouble(sCurrDate)) ▸ if (M… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87565fd5 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:864 |  | FLAG | dtRefInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_refInfo", _sSite, _sP… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-16a5f839 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:864 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_refInfo", _sSite, _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6325f429 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:873 | if (dtRefInfo != null) ▸ if (dtRefInfo.Rows.Count > 0) ▸ if (sEnableFlag != "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "The engine can not be started before the reference data(open … | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f110db3 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:874 | if (dtRefInfo != null) ▸ if (dtRefInfo.Rows.Count > 0) ▸ if (sEnableFlag != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b1ac021 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:880 |  | FLAG | dtSaveAuth | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_isSaveAuth", _sPlanGr… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b7d10ead | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:880 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isSaveAuth", _sPlanGroup, UserInfoContext.Current.UserId) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-310d49d8 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:888 | if (dtSaveAuth != null) ▸ if (dtSaveAuth.Rows.Count > 0) ▸ if (dtSaveAuth.Equals("0")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "You don't have 'Save' permission for this instance!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a76a83d5 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:889 | if (dtSaveAuth != null) ▸ if (dtSaveAuth.Rows.Count > 0) ▸ if (dtSaveAuth.Equals("0")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52ad47f4 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:897 | if (DsinData.INSTANCE_ID.IndexOf("FORM") != -1) | FLAG | dtFormAging | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_formAging", _sSite, _… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5ec9a836 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:897 | if (DsinData.INSTANCE_ID.IndexOf("FORM") != -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_formAging", _sSite, _sPlanDate, _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-663c645b | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:905 | if (DsinData.INSTANCE_ID.IndexOf("FORM") != -1) ▸ if (dtFormAging != null) ▸ if (dtFormAging.Rows.Count > 0) ▸ if (sAgingFlag.Equals("0")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Aging Stock is not available yet. (Formation)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d122908 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:906 | if (DsinData.INSTANCE_ID.IndexOf("FORM") != -1) ▸ if (dtFormAging != null) ▸ if (dtFormAging.Rows.Count > 0) ▸ if (sAgingFlag.Equals("0")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-900cb7c2 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:914 |  | FLAG | dtRunningPlan | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findIsRunningPlan", _sPlan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d7769b28 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:914 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa7e7f49 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:926 | if (dtRunningPlan != null) ▸ if (dtRunningPlan.Rows.Count > 0) ▸ if (Convert.ToInt32(sRunningFlag) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93e31e84 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:927 | if (dtRunningPlan != null) ▸ if (dtRunningPlan.Rows.Count > 0) ▸ if (Convert.ToInt32(sRunningFlag) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8a70882 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:934 |  | DATA_OP | FilterTmp["INSTANCE_ID"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-e47f5be1 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:935 |  | FLAG | dsIsTotalInstance | DataService.FP_ExecuteQuery2("FP00591", "findIsTotalInstance", FilterTmp.Dictionary, "Plan… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsTotalInstance] \| FP\Plan… | 화면 필드/플래그 변경 |  |  |  |
| AC-f4849970 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:935 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findIsTotalInstance", FilterTmp.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsTotalInstance] \| FP\Plan… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1272f1be | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:938 | if (dsIsTotalInstance.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageHelper.GMessageBox | ("Run that plan in the 'Plan Control(Integration)' UI.\r\n\r\n해당 plan 은 'Plan Control(Inte… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb06e772 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:939 | if (dsIsTotalInstance.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup.btnNoFixDate1_Click

진입점: this.btnNoFixDate1.Click / this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ try ▸ try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ else of (!string.IsNullOrEmpty(sPreFixDate))] / cboBasePlanID.SelectedIndexChanged [try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ else of (!string.IsNullOrEmpty(sPreFixDate))] / rdoGroup1.SelectedIndexChanged [else of (radioGroup.SelectedIndex == 0) ▸ try ▸ try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ else of (!string.IsNullOrEmpty(sPreFixDate))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4a1ce3a | this.btnNoFixDate1.Click 외 3 | FP00590_PlanTotalPopup.cs:2089 | if (rdoGroup1.SelectedIndex == 1) ▸ if (cboBasePlanID.Items.Count == 0) | UI_PROP | dtpFixDate1.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-8c6bba08 | this.btnNoFixDate1.Click 외 3 | FP00590_PlanTotalPopup.cs:2090 | if (rdoGroup1.SelectedIndex == 1) ▸ if (cboBasePlanID.Items.Count == 0) | UI_PROP | dtpFixDate1.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-37b86980 | this.btnNoFixDate1.Click 외 3 | FP00590_PlanTotalPopup.cs:2092 | if (rdoGroup1.SelectedIndex == 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-beb73902 | this.btnNoFixDate1.Click 외 3 | FP00590_PlanTotalPopup.cs:2095 |  | UI_PROP | dtpFixDate1.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-1a68ac6c | this.btnNoFixDate1.Click 외 3 | FP00590_PlanTotalPopup.cs:2096 |  | UI_PROP | dtpFixDate1.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |

## FP00590_PlanTotalPopup.btnNoFixDate2_Click

진입점: this.btnNoFixDate2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea4da2a3 | this.btnNoFixDate2.Click | FP00590_PlanTotalPopup.cs:2105 |  | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-e4bc8bb0 | this.btnNoFixDate2.Click | FP00590_PlanTotalPopup.cs:2106 |  | UI_PROP | dtpFixDate2.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |

## FP00590_PlanTotalPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61b69338 | this.btnSql.Click | FP00590_PlanTotalPopup.cs:1153 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ca5bc52d | this.btnSql.Click | FP00590_PlanTotalPopup.cs:1154 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-355b730a | this.btnSql.Click | FP00590_PlanTotalPopup.cs:1156 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_CREATE_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a175ad17 | this.btnSql.Click | FP00590_PlanTotalPopup.cs:1157 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_ENGINE_RUN") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a304a98 | this.btnSql.Click | FP00590_PlanTotalPopup.cs:1158 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_PlanTotalPopup.cboOperation_SelectedIndexChanged

진입점: this.cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41aaf567 | this.cboOperation.SelectedIndexChanged | FP00590_PlanTotalPopup.cs:2048 |  | UI_PROP | DsinData.SYNC_OPERATION_ID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 속성 SYNC_OPERATION_ID 설정 |  |  |  |

## FP00590_PlanTotalPopup.chkPreFix_Click

진입점: this.chkPreFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b909cb | this.chkPreFix.Click | FP00590_PlanTotalPopup.cs:2075 | if (chkPreFix.Checked == true) | UI_PROP | DsinData.PRE_FIX_FLAG | "Y" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-b8b2382c | this.chkPreFix.Click | FP00590_PlanTotalPopup.cs:2079 | else of (chkPreFix.Checked == true) | UI_PROP | DsinData.PRE_FIX_FLAG | "N" | 속성 PRE_FIX_FLAG 설정 |  |  |  |

## FP00590_PlanTotalPopup.chkPreFix2_Click

진입점: this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DEMO") != -1)] / this.chkPreFix2.Click / this.Load [try ▸ if (sUserID.IndexOf("DEMO") != -1)] / rdoGroup1.SelectedIndexChanged [if (sUserID.IndexOf("DEMO") != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05a0c0c9 | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2055 | if (chkPreFix2.Checked == true) | STATE | rdoGroup3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9a58041c | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2057 | if (chkPreFix2.Checked == true) | STATE | dtpFixDate2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-521be3a5 | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2058 | if (chkPreFix2.Checked == true) | STATE | btnNoFixDate2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0e07489b | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2063 | else of (chkPreFix2.Checked == true) | STATE | rdoGroup3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e08b0b3e | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2064 | else of (chkPreFix2.Checked == true) | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-bf90b71a | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2065 | else of (chkPreFix2.Checked == true) | UI_PROP | dtpFixDate2.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-90af7061 | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2067 | else of (chkPreFix2.Checked == true) | STATE | dtpFixDate2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-731c48e0 | this.rdoGroup2.SelectedIndexChanged [if (sUserID.IndexOf("DE… 외 3 | FP00590_PlanTotalPopup.cs:2068 | else of (chkPreFix2.Checked == true) | STATE | btnNoFixDate2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00590_PlanTotalPopup.chkStatus_Click

진입점: this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true)] / this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.chkStatus.Click / this.Load [try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6890a42 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2118 | if (chkStatus.Checked == true) | FLAG | bRun1 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e7034381 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2118 | if (chkStatus.Checked == true) | FLAG | bRun2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6533d90b | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2118 | if (chkStatus.Checked == true) | FLAG | bRun3 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b47c5f98 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2118 | if (chkStatus.Checked == true) | FLAG | bRunError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-44c4212e | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2120 | if (chkStatus.Checked == true) | FLAG | EngineCheckTimer | new System.Timers.Timer() | 화면 필드/플래그 변경 |  |  |  |
| AC-2b7b6f6f | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2121 | if (chkStatus.Checked == true) | UI_PROP | EngineCheckTimer.Interval | 5000 | 속성 Interval 설정 |  |  |  |
| AC-72d57bfc | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2131 | if (chkStatus.Checked == true) ▸ lambda | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8b909b5 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2135 | if (chkStatus.Checked == true) | CALL_EXT | EngineCheckTimer.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4015d88 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2142 | else of (chkStatus.Checked == true) ▸ if (EngineCheckTimer != null) | CALL_EXT | EngineCheckTimer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a3d1285 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2143 | else of (chkStatus.Checked == true) ▸ if (EngineCheckTimer != null) | UI_MISC | EngineCheckTimer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-03d06cb3 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda ▸ if (ds.T… 외 4 | FP00590_PlanTotalPopup.cs:2144 | else of (chkStatus.Checked == true) ▸ if (EngineCheckTimer != null) | FLAG | EngineCheckTimer | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_PlanTotalPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbf63e89 | this.Load | FP00590_PlanTotalPopup.cs:597 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5e100ffa | this.Load | FP00590_PlanTotalPopup.cs:598 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c7a5132 | this.Load | FP00590_PlanTotalPopup.cs:599 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_PlanTotalPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aadc61dc | this.Load | FP00590_PlanTotalPopup.cs:242 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_PlanTotalPopup.Dispose

진입점: this.FormClosing / Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47e3a63d | this.FormClosing 외 1 | FP00590_PlanTotalPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_PlanTotalPopup.dtpFixDate1_CloseUp

진입점: this.dtpFixDate1.CloseUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f774cce | this.dtpFixDate1.CloseUp | FP00590_PlanTotalPopup.cs:2202 | if (string.IsNullOrEmpty(sDay) \|\| sDay == " ") | UI_PROP | dtpFixDate1.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-165c969b | this.dtpFixDate1.CloseUp | FP00590_PlanTotalPopup.cs:2203 | if (string.IsNullOrEmpty(sDay) \|\| sDay == " ") | UI_PROP | dtpFixDate1.CustomFormat | null | 속성 CustomFormat 설정 |  |  |  |
| AC-cb6a5c16 | this.dtpFixDate1.CloseUp | FP00590_PlanTotalPopup.cs:2205 | if (string.IsNullOrEmpty(sDay) \|\| sDay == " ") | VALUE_SET | dtpFixDate1.Text | dtpFixDate1.Value.ToString("yyyy-MM-dd") | 컨트롤 값 설정 |  |  |  |

## FP00590_PlanTotalPopup.dtpFixDate1_ValueChanged

진입점: dtpFixDate1.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f72e8b23 | dtpFixDate1.ValueChanged | FP00590_PlanTotalPopup.cs:2167 | try | FLAG | dtfixDateInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_fixDateInfo", _sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7aef59cd | dtpFixDate1.ValueChanged | FP00590_PlanTotalPopup.cs:2167 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_fixDateInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74f867e2 | dtpFixDate1.ValueChanged | FP00590_PlanTotalPopup.cs:2185 | try ▸ if (Convert.ToDecimal(sDay) < Convert.ToDecimal(sPlanCheckDay)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Before(the plan start date(" + sMinFixDate + ") cannot be sel… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-734414ee | dtpFixDate1.ValueChanged | FP00590_PlanTotalPopup.cs:2186 | try ▸ if (Convert.ToDecimal(sDay) < Convert.ToDecimal(sPlanCheckDay)) | VALUE_SET | dtpFixDate1.Value | drpPeriod.Value1 | 컨트롤 값 설정 |  |  |  |
| AC-1409379f | dtpFixDate1.ValueChanged | FP00590_PlanTotalPopup.cs:2192 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_PlanTotalPopup.dtpFixDate2_CloseUp

진입점: this.dtpFixDate2.CloseUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-953e76f5 | this.dtpFixDate2.CloseUp | FP00590_PlanTotalPopup.cs:2151 |  | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Short | 속성 Format 설정 |  |  |  |

## FP00590_PlanTotalPopup.ExcuteRunValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bf3709b | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1778 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-5afe1fea | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1779 | try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9ded4b30 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1781 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-83826aba | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1782 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_VALIDATION_INSTANCE" | 행/컬럼 값 대입 |  |  |  |
| AC-980d7a74 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1783 | try | DATA_OP | request.Parameters["p_sys_gubun"] | pProcName | 행/컬럼 값 대입 |  |  |  |
| AC-057c4acf | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1784 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-df465cb6 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1785 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-7a2443b0 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1786 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-dda56bb2 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1787 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-9c410535 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1788 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-dde2b3f3 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1789 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7ba4a43c | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1790 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc367f04 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1791 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-599915e8 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1792 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d383b250 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1793 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-74e53ffa | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1794 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-52db3068 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1795 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5a146110 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1796 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b853eb3 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1797 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d429a5f3 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1798 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-16d1d812 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1799 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-38a1fc62 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1800 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-97de502c | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1801 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3a612630 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1802 | try | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8f1fde92 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1804 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8b215d5 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1805 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b28570bd | (진입점 미연결) | FP00590_PlanTotalPopup.cs:1810 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup.Find_Data_Sub

진입점: this.cboPlanID.SelectedIndexChanged [try ▸ lambda] / this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (chkStatus.Checked == true) ▸ lambda ▸ try ▸ lambda] / this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambda ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [else of (programID == "PR_UI_FP00590_CREATE_PLAN") ▸ if (programID == "PR_UI_FP00590_ENGINE_RUN")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41a9edfc | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1317 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-526bfabd | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1318 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c2bd3cf8 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1319 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ENGINE_RUN" | 행/컬럼 값 대입 |  |  |  |
| AC-18c37335 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1320 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-042b0049 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1321 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dc4431f9 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1323 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-63e8a1ee | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1324 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-430c5a60 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1325 | try | DATA_OP | request.Parameters["p_plan_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-726c085f | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1326 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-12093eb9 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1328 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fcc20af5 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1329 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2dc0e63d | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1330 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8fa95514 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1331 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6867284b | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1332 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9aac4773 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1333 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-02152a15 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1334 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8f3ef54 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1335 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b5d2ae8a | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1336 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ac557ab9 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1337 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e9e14338 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1338 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6fb449ad | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1339 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-768a0350 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1340 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d5cf1e72 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1341 | try | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6f4ba17d | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1343 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62d8a94d | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1345 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-73ac4512 | this.cboPlanID.SelectedIndexChanged [try ▸ lambda] 외 5 | FP00590_PlanTotalPopup.cs:1350 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup.FindData_Sub

진입점: this.cboPlanID.SelectedIndexChanged / this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (chkStatus.Checked == true) ▸ lambda] / this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambda] / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d714d8bb | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1185 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-9d11f0ac | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1185 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16631ee2 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1188 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b901962 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1193 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { ds = Find_Data_Sub("SELECT", pPlanGroup, pPlanID); //쿼리결과… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7603ffb7 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1197 | try ▸ lambda | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-98b651c5 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1214 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equ… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-b7cc329b | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1218 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-b5f0cac4 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1219 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-351b6cec | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1223 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-36b0dda3 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1224 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-0a95586f | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1225 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-59bf2168 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1229 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-d71148aa | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1230 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-fca56a82 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1231 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-65c6a29e | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1232 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP4)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-1b4374cd | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1239 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (i ==0) ▸ if (sFlag.Equals("C")) | FLAG | bRun1 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9e41ddca | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1241 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (i ==0) ▸ else of (sFlag.Equals("C")) ▸ if (sFlag.E… | FLAG | bRunError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f4f0d13a | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1243 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (i ==0) ▸ else of (sFlag.Equals("C")) ▸ else of (sF… | FLAG | bRun1 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-20c5c87d | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1249 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ if (i == 1) ▸ if (sFlag.Equals("C")) | FLAG | bRun2 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1a1479d3 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1251 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ if (i == 1) ▸ else of (sFlag.Equals(… | FLAG | bRunError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-75d23415 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1253 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ if (i == 1) ▸ else of (sFlag.Equals(… | FLAG | bRun2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9c15a30b | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1259 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ else of (i == 1) ▸ if (i == 2) ▸ if … | FLAG | bRun3 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e1af9efb | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1261 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ else of (i == 1) ▸ if (i == 2) ▸ els… | FLAG | bRunError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-882af9bd | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1263 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ else of (i == 1) ▸ if (i == 2) ▸ els… | FLAG | bRun3 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bce92b57 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1268 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | FLAG | bRunError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a413aad | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1269 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | UI_PROP | lblEngineStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c45ec7f8 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1270 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | STATE | lblStatusText.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4fa1ab4f | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1271 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-d2059c3d | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1273 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | MESSAGE | MessageBox.Show | ("FP Engine Run Error Occur!", "Check", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-f61c6567 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1280 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-8bd9a474 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1282 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | FLAG | blnCreateRun | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e47e5e4f | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1284 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | MESSAGE | MessageBox.Show | ("FP Engine Completed!", "Complete", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-a2578ba7 | this.cboPlanID.SelectedIndexChanged 외 4 | FP00590_PlanTotalPopup.cs:1287 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_PlanTotalPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-055d6a7d | this.Load | FP00590_PlanTotalPopup.cs:213 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2857fb5f | this.Load | FP00590_PlanTotalPopup.cs:225 |  | FOCUS | txtDescription.Focus | () | 포커스 이동 |  |  |  |

## FP00590_PlanTotalPopup.FP00590_PlanTotalPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e077a4b | this.FormClosing | FP00590_PlanTotalPopup.cs:2291 | if (EngineCheckTimer != null) | CALL_EXT | EngineCheckTimer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-67ad84f7 | this.FormClosing | FP00590_PlanTotalPopup.cs:2292 | if (EngineCheckTimer != null) | UI_MISC | EngineCheckTimer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-22adb957 | this.FormClosing | FP00590_PlanTotalPopup.cs:2293 | if (EngineCheckTimer != null) | FLAG | EngineCheckTimer | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_PlanTotalPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9e6d8a5 | this.Load | FP00590_PlanTotalPopup.cs:258 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-de40da9f | this.Load | FP00590_PlanTotalPopup.cs:264 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e10e4cf4 | this.Load | FP00590_PlanTotalPopup.cs:265 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-451f0517 | this.Load | FP00590_PlanTotalPopup.cs:267 | try | VALUE_SET | txtSite.Text | _sSite | 컨트롤 값 설정 |  |  |  |
| AC-be194eb1 | this.Load | FP00590_PlanTotalPopup.cs:268 | try | VALUE_SET | txtPlanGroup.Text | _sPlanGroup | 컨트롤 값 설정 |  |  |  |
| AC-8ada3143 | this.Load | FP00590_PlanTotalPopup.cs:269 | try | UI_PROP | lblEngineStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6136c232 | this.Load | FP00590_PlanTotalPopup.cs:275 | try | VALUE_SET | dtpFixDate1.Value | dDate | 컨트롤 값 설정 |  |  |  |
| AC-80930936 | this.Load | FP00590_PlanTotalPopup.cs:277 | try | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-98b92a8d | this.Load | FP00590_PlanTotalPopup.cs:278 | try | UI_PROP | dtpFixDate2.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-ef8e6e08 | this.Load | FP00590_PlanTotalPopup.cs:285 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-0499cfb5 | this.Load | FP00590_PlanTotalPopup.cs:288 | try | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-f533069b | this.Load | FP00590_PlanTotalPopup.cs:295 | try ▸ for (i < itemValues2.Length) | DATA_OP | rdoGroup2.Properties.Items.Add | (new RadioGroupItem(itemValues2[i], itemDescriptions2[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-d508a823 | this.Load | FP00590_PlanTotalPopup.cs:298 | try | VALUE_SET | rdoGroup2.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-25bcfbcc | this.Load | FP00590_PlanTotalPopup.cs:305 | try ▸ for (i < itemValues3.Length) | DATA_OP | rdoGroup3.Properties.Items.Add | (new RadioGroupItem(itemValues3[i], itemDescriptions3[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-06419477 | this.Load | FP00590_PlanTotalPopup.cs:308 | try | VALUE_SET | rdoGroup3.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-d234e0f1 | this.Load | FP00590_PlanTotalPopup.cs:311 | try | UI_PROP | lblchkPreFix1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-adcc87d2 | this.Load | FP00590_PlanTotalPopup.cs:318 | try | DATA_OP | inFilter["LOOKUP_TYPE_CODE"] | "INSTANCE AMEND UI" | 행/컬럼 값 대입 |  |  |  |
| AC-9a1b28fa | this.Load | FP00590_PlanTotalPopup.cs:319 | try | DATA_OP | inFilter["SEGMENT1"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-84780a01 | this.Load | FP00590_PlanTotalPopup.cs:320 | try | DATA_OP | inFilter["SEGMENT2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66889e59 | this.Load | FP00590_PlanTotalPopup.cs:321 | try | DATA_OP | inFilter["SEGMENT3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-06ba8b87 | this.Load | FP00590_PlanTotalPopup.cs:322 | try | DATA_OP | inFilter["SEGMENT4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dad764b6 | this.Load | FP00590_PlanTotalPopup.cs:323 | try | DATA_OP | inFilter["SEGMENT5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0bdd9e40 | this.Load | FP00590_PlanTotalPopup.cs:325 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_LookUp_AllData", inFilter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LookUp_AllData] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2163827b | this.Load | FP00590_PlanTotalPopup.cs:340 | try ▸ if (isFixOption) | UI_PROP | lblbtnNoFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-112dbe70 | this.Load | FP00590_PlanTotalPopup.cs:341 | try ▸ if (isFixOption) | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-46437f48 | this.Load | FP00590_PlanTotalPopup.cs:343 | try ▸ if (isFixOption) | UI_PROP | lblGroup3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-427974ac | this.Load | FP00590_PlanTotalPopup.cs:350 | try ▸ else of (isFixOption) | CALL_EXT | UserService.HasPIRole | (sUserID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4845fceb | this.Load | FP00590_PlanTotalPopup.cs:352 | try ▸ else of (isFixOption) ▸ if ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("PACK"… | UI_PROP | lblbtnNoFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0b118304 | this.Load | FP00590_PlanTotalPopup.cs:353 | try ▸ else of (isFixOption) ▸ if ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("PACK"… | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-146b14fc | this.Load | FP00590_PlanTotalPopup.cs:355 | try ▸ else of (isFixOption) ▸ if ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("PACK"… | UI_PROP | lblGroup3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a5b39c65 | this.Load | FP00590_PlanTotalPopup.cs:362 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblbtnNoFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-083674d1 | this.Load | FP00590_PlanTotalPopup.cs:363 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-25e12892 | this.Load | FP00590_PlanTotalPopup.cs:364 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-42a2f6ea | this.Load | FP00590_PlanTotalPopup.cs:366 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblGroup3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7a2301a6 | this.Load | FP00590_PlanTotalPopup.cs:368 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblchkPreFix2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-db47f5c9 | this.Load | FP00590_PlanTotalPopup.cs:372 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblbtnNoFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2eba26bd | this.Load | FP00590_PlanTotalPopup.cs:373 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-55ebe67c | this.Load | FP00590_PlanTotalPopup.cs:374 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ee322a92 | this.Load | FP00590_PlanTotalPopup.cs:376 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblGroup3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9cfe8523 | this.Load | FP00590_PlanTotalPopup.cs:378 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | UI_PROP | lblchkPreFix2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-01ebab29 | this.Load | FP00590_PlanTotalPopup.cs:386 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | DATA_OP | rdoGroup2.Properties.Items.Remove | (item) | 데이터 객체 조작/조회 |  |  |  |
| AC-97b2bbc8 | this.Load | FP00590_PlanTotalPopup.cs:387 | try ▸ else of (isFixOption) ▸ else of ((_sPlanGroup.IndexOf("E_PRE") != -1 \|\| _sPlanGroup.IndexOf("CELL") != -1 \|\| _sPlanGroup.IndexOf("… | DATA_OP | hiddenItems.Add | (item) | 데이터 객체 조작/조회 |  |  |  |
| AC-f299b611 | this.Load | FP00590_PlanTotalPopup.cs:395 | try | STATE | drpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1e4852ed | this.Load | FP00590_PlanTotalPopup.cs:399 | try | FLAG | dtRevision | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f5e10783 | this.Load | FP00590_PlanTotalPopup.cs:399 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac638166 | this.Load | FP00590_PlanTotalPopup.cs:400 | try | LIST_REBIND | clsCtrl.setListBox | (dtRevision, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-293ae3ad | this.Load | FP00590_PlanTotalPopup.cs:401 | try | VALUE_SET | cboPlanID.SelectedValue | _sPlanID | 컨트롤 값 설정 |  |  |  |
| AC-2d93cecb | this.Load | FP00590_PlanTotalPopup.cs:404 | try | FLAG | dtLookupByInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_lookupByInstance", _s… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a09fdd46 | this.Load | FP00590_PlanTotalPopup.cs:404 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_lookupByInstance", _sPlanGroup,_sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66f72d1b | this.Load | FP00590_PlanTotalPopup.cs:407 | try | VALUE_SET | drpPeriod.InitValue | _sPlanDate.ToString() + ":" + sPlanEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-02020da0 | this.Load | FP00590_PlanTotalPopup.cs:413 | try ▸ if (_sPlanGroup.Equals("KR_CELL") \|\| _sPlanGroup.Equals("CN_CELL") \|\| _sPlanGroup.Equals("US_CELL") \|\| _sPlanGroup.Equals("P…) | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findSyncOperationList",_sS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fbef1494 | this.Load | FP00590_PlanTotalPopup.cs:413 | try ▸ if (_sPlanGroup.Equals("KR_CELL") \|\| _sPlanGroup.Equals("CN_CELL") \|\| _sPlanGroup.Equals("US_CELL") \|\| _sPlanGroup.Equals("P…) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findSyncOperationList",_sSite, _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d70b621 | this.Load | FP00590_PlanTotalPopup.cs:415 | try ▸ if (_sPlanGroup.Equals("KR_CELL") \|\| _sPlanGroup.Equals("CN_CELL") \|\| _sPlanGroup.Equals("US_CELL") \|\| _sPlanGroup.Equals("P…) ▸… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2d4bc9ae | this.Load | FP00590_PlanTotalPopup.cs:419 | try | FLAG | dtBasisPlan | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findEndRevision", _sPlanGr… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-225379cc | this.Load | FP00590_PlanTotalPopup.cs:419 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEndRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c49f45f | this.Load | FP00590_PlanTotalPopup.cs:420 | try | LIST_REBIND | clsCtrl.setListBox | (dtBasisPlan, cboBasePlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-43baabc1 | this.Load | FP00590_PlanTotalPopup.cs:423 | try | FLAG | dtfixDateInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_fixDateInfo", _sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4a4dc90a | this.Load | FP00590_PlanTotalPopup.cs:423 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_fixDateInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-49876a03 | this.Load | FP00590_PlanTotalPopup.cs:431 | try ▸ if (dtfixDateInfo.Rows[0]["ALLOWED_FIX_DATE_NULL"].ToString().Equals("Y")) | UI_PROP | lblbtnNoFixDate1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ebcc99b7 | this.Load | FP00590_PlanTotalPopup.cs:436 | try ▸ else of (dtfixDateInfo.Rows[0]["ALLOWED_FIX_DATE_NULL"].ToString().Equals("Y")) | UI_PROP | lblbtnNoFixDate1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c30e8f4e | this.Load | FP00590_PlanTotalPopup.cs:442 | try ▸ if (dtLocalPlanGroup.Rows[0]["SYNC_YN"].ToString().Equals("N")) | STATE | lblGroup1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b9d9e1c8 | this.Load | FP00590_PlanTotalPopup.cs:446 | try ▸ else of (dtLocalPlanGroup.Rows[0]["SYNC_YN"].ToString().Equals("N")) | STATE | lblGroup1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e08fc046 | this.Load | FP00590_PlanTotalPopup.cs:451 | try ▸ if (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | UI_PROP | dtpFixDate1.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-8754bea9 | this.Load | FP00590_PlanTotalPopup.cs:452 | try ▸ if (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | VALUE_CLEAR | dtpFixDate1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3a6435f1 | this.Load | FP00590_PlanTotalPopup.cs:464 | try ▸ else of (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | VALUE_SET | dtpFixDate1.Value | dPrefixDate | 컨트롤 값 설정 |  |  |  |
| AC-fb9fe5e3 | this.Load | FP00590_PlanTotalPopup.cs:468 | try | FLAG | dtFixDateOptionInit | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_fixTypeInit", _sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d7dd3fbb | this.Load | FP00590_PlanTotalPopup.cs:468 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_fixTypeInit", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28eed3ab | this.Load | FP00590_PlanTotalPopup.cs:472 | try ▸ if (dtFixDateOptionInit.Rows.Count == 0) | VALUE_SET | rdoGroup2.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-66355ed5 | this.Load | FP00590_PlanTotalPopup.cs:480 | try ▸ else of (dtFixDateOptionInit.Rows.Count == 0) ▸ if (sFixOptionValue.Equals("QTY_FIX")) | VALUE_SET | rdoGroup2.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-6d2d5f65 | this.Load | FP00590_PlanTotalPopup.cs:484 | try ▸ else of (dtFixDateOptionInit.Rows.Count == 0) ▸ else of (sFixOptionValue.Equals("QTY_FIX")) ▸ if (sFixOptionValue.Equals("SEQ_FIX")) | VALUE_SET | rdoGroup2.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-91d44ce3 | this.Load | FP00590_PlanTotalPopup.cs:491 | try ▸ else of (dtFixDateOptionInit.Rows.Count == 0) ▸ else of (sFixOptionValue.Equals("QTY_FIX")) ▸ else of (sFixOptionValue.Equals("SEQ_FIX… | VALUE_SET | rdoGroup2.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-3718918d | this.Load | FP00590_PlanTotalPopup.cs:493 | try ▸ else of (dtFixDateOptionInit.Rows.Count == 0) ▸ else of (sFixOptionValue.Equals("QTY_FIX")) ▸ else of (sFixOptionValue.Equals("SEQ_FIX… | VALUE_SET | rdoGroup2.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-3ac73575 | this.Load | FP00590_PlanTotalPopup.cs:504 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5c83a63a | this.Load | FP00590_PlanTotalPopup.cs:505 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e72332c5 | this.Load | FP00590_PlanTotalPopup.cs:506 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dccfd305 | this.Load | FP00590_PlanTotalPopup.cs:510 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_fixDate", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce8b1a36 | this.Load | FP00590_PlanTotalPopup.cs:513 | try | FLAG | _sDefFixDate | sFixDt | 화면 필드/플래그 변경 |  |  |  |
| AC-4779e5dc | this.Load | FP00590_PlanTotalPopup.cs:519 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | LIST_CLEAR | rdoGroup1.Properties.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-00d4ee1c | this.Load | FP00590_PlanTotalPopup.cs:520 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | LIST_CLEAR | rdoGroup2.Properties.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-5d936468 | this.Load | FP00590_PlanTotalPopup.cs:527 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bc82174 | this.Load | FP00590_PlanTotalPopup.cs:530 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-dd6dc809 | this.Load | FP00590_PlanTotalPopup.cs:537 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) ▸ for (i < itemValues2.Length) | DATA_OP | rdoGroup2.Properties.Items.Add | (new RadioGroupItem(itemValues2[i], itemDescriptions2[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-025a5734 | this.Load | FP00590_PlanTotalPopup.cs:540 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | VALUE_SET | rdoGroup2.EditValue | 3 | 컨트롤 값 설정 |  |  |  |
| AC-aa80ca08 | this.Load | FP00590_PlanTotalPopup.cs:547 | try | UI_PROP | dtpFixDate1.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-6416a8d2 | this.Load | FP00590_PlanTotalPopup.cs:548 | try | UI_PROP | dtpFixDate1.CustomFormat | null | 속성 CustomFormat 설정 |  |  |  |
| AC-4b13b388 | this.Load | FP00590_PlanTotalPopup.cs:550 | try | VALUE_SET | dtpFixDate1.Value | new DateTime( _sDefFixDate.Substring(0, 4).SafeUnInt() , _sDefFixDate.Substring(4, 2).Safe… | 컨트롤 값 설정 |  |  |  |
| AC-640687bd | this.Load | FP00590_PlanTotalPopup.cs:550 | try | CALL_EXT | _sDefFixDate.Substring(0, 4).SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e33c6e4 | this.Load | FP00590_PlanTotalPopup.cs:551 | try | CALL_EXT | _sDefFixDate.Substring(4, 2).SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fe19ee0 | this.Load | FP00590_PlanTotalPopup.cs:552 | try | CALL_EXT | _sDefFixDate.Substring(6, 2).SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e93b1bde | this.Load | FP00590_PlanTotalPopup.cs:554 | try | UI_PROP | dtpFixDate1.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-d603b3fa | this.Load | FP00590_PlanTotalPopup.cs:560 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | UI_PROP | dtpFixDate1.CustomFormat | null | 속성 CustomFormat 설정 |  |  |  |
| AC-5a7f53ed | this.Load | FP00590_PlanTotalPopup.cs:565 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | VALUE_SET | dtpFixDate1.Value | dDate2 | 컨트롤 값 설정 |  |  |  |
| AC-e37d9195 | this.Load | FP00590_PlanTotalPopup.cs:569 | try | VALUE_SET | dtp_MstChk_EndDate.Value | dtpFixDate1.Value | 컨트롤 값 설정 |  |  |  |
| AC-be3309aa | this.Load | FP00590_PlanTotalPopup.cs:577 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_PlanTotalPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c26ac81 | this.Load | FP00590_PlanTotalPopup.cs:612 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-828154cc | this.Load | FP00590_PlanTotalPopup.cs:615 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-a83548cf | this.Load | FP00590_PlanTotalPopup.cs:617 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9155d1b1 | this.Load | FP00590_PlanTotalPopup.cs:620 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ENGINE_STATUS)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-985103f2 | this.Load | FP00590_PlanTotalPopup.cs:621 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-af5bfe32 | this.Load | FP00590_PlanTotalPopup.cs:622 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e7b8e99d | this.Load | FP00590_PlanTotalPopup.cs:623 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_START)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-81d11f0b | this.Load | FP00590_PlanTotalPopup.cs:624 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_END)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-53e25e66 | this.Load | FP00590_PlanTotalPopup.cs:627 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ENGINE_STATUS), siSub.GetColumnIndex(DefColumns.STATUS_MS… | 그리드 편집 잠금/해제 |  |  |  |

## FP00590_PlanTotalPopup.rdoPD

진입점: this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] / rdoGroup1.SelectedIndexChanged [if (radioGroup.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86c561dc | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1920 | try | VALUE_CLEAR | cboBasePlanID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-252015b6 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1921 | try | STATE | cboBasePlanID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2cf78670 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1923 | try | VALUE_CLEAR | cboOperation.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-d17c5415 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1924 | try | STATE | cboOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b2fbbdd7 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1927 | try | FLAG | dtfixDateInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_fixDateInfo", _sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ba789600 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1927 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_fixDateInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dde86c66 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1929 | try | UI_PROP | DsinData.ALLOWFIXDATENULL | dtfixDateInfo.Rows[0]["ALLOWED_FIX_DATE_NULL"].ToString() | 속성 ALLOWFIXDATENULL 설정 |  |  |  |
| AC-05d7de9a | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1936 | try ▸ if (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | VALUE_CLEAR | dtpFixDate1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-eae6d334 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1937 | try ▸ if (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | UI_PROP | dtpFixDate1.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-03f51c52 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1938 | try ▸ if (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | UI_PROP | dtpFixDate1.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-8a51528d | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1957 | try ▸ else of (sMinFixDate.Equals("0") \|\| sDefaultFixDate.Equals("0")) | VALUE_SET | dtpFixDate1.Value | dPrefixDate | 컨트롤 값 설정 |  |  |  |
| AC-7759afa5 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1960 | try | STATE | dtpFixDate1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8d281cfc | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1963 | try | STATE | rdoGroup2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cb8bacd3 | this.Load [try ▸ if (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1968 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_PlanTotalPopup.rdoPS

진입점: this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] / rdoGroup1.SelectedIndexChanged [else of (radioGroup.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80c50601 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1985 | try | STATE | cboBasePlanID.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5eb14dd7 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1987 | try | UI_PROP | lblchkPreFix1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ddc6d971 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1991 | try | UI_PROP | lblchkPreFix1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-26a1e166 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:1998 | try ▸ if (_sPlanGroup.Equals("KR_CELL") \|\| _sPlanGroup.Equals("CN_CELL") \|\| _sPlanGroup.Equals("US_CELL") \|\| _sPlanGroup.Equals("C…) | STATE | cboOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e37c5b25 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2000 | try ▸ if (_sPlanGroup.Equals("KR_CELL") \|\| _sPlanGroup.Equals("CN_CELL") \|\| _sPlanGroup.Equals("US_CELL") \|\| _sPlanGroup.Equals("C…) ▸… | VALUE_SET | cboOperation.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b2d6d54c | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2002 | try ▸ if (_sPlanGroup.Equals("KR_CELL") \|\| _sPlanGroup.Equals("CN_CELL") \|\| _sPlanGroup.Equals("US_CELL") \|\| _sPlanGroup.Equals("C…) ▸… | VALUE_CLEAR | cboOperation.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-69e3e220 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2007 | try ▸ if (_sPlanGroup.IndexOf("_E_PRE") != -1) | STATE | dtpFixDate1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1d11ace8 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2016 | try ▸ if (_sPlanGroup.IndexOf("_E_PRE") != -1) ▸ if (itemToShow != null) ▸ if (indexToInsert != -1) | DATA_OP | rdoGroup2.Properties.Items.Insert | (indexToInsert, itemToShow) | 데이터 객체 조작/조회 |  |  |  |
| AC-462ca1db | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2018 | try ▸ if (_sPlanGroup.IndexOf("_E_PRE") != -1) ▸ if (itemToShow != null) ▸ else of (indexToInsert != -1) | DATA_OP | rdoGroup2.Properties.Items.Add | (itemToShow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e859d152 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2020 | try ▸ if (_sPlanGroup.IndexOf("_E_PRE") != -1) ▸ if (itemToShow != null) | DATA_OP | hiddenItems.Remove | (itemToShow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e19c426 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2022 | try ▸ if (_sPlanGroup.IndexOf("_E_PRE") != -1) | VALUE_SET | rdoGroup2.EditValue | 2 | 컨트롤 값 설정 |  |  |  |
| AC-131c8f50 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2023 | try ▸ if (_sPlanGroup.IndexOf("_E_PRE") != -1) | STATE | rdoGroup2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b16b1ee7 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2027 | try ▸ else of (_sPlanGroup.IndexOf("_E_PRE") != -1) | STATE | dtpFixDate1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a74c2ab2 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2034 | try ▸ if (cboBasePlanID.Items.Count > 0) | VALUE_SET | cboBasePlanID.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a7307c0a | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2036 | try ▸ else of (cboBasePlanID.Items.Count > 0) | VALUE_CLEAR | cboBasePlanID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-33dded15 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0)] 외 1 | FP00590_PlanTotalPopup.cs:2041 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_PlanTotalPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7563fbf2 | popSql.OnSql | FP00590_PlanTotalPopup.cs:2435 | if (programID == "PR_UI_FP00590_CREATE_PLAN") | RETURN | return Save_Create_PlanData("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e57b5289 | popSql.OnSql | FP00590_PlanTotalPopup.cs:2441 | else of (programID == "PR_UI_FP00590_CREATE_PLAN") ▸ if (programID == "PR_UI_FP00590_ENGINE_RUN") | FLAG | dtRevision | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0042560e | popSql.OnSql | FP00590_PlanTotalPopup.cs:2441 | else of (programID == "PR_UI_FP00590_CREATE_PLAN") ▸ if (programID == "PR_UI_FP00590_ENGINE_RUN") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dbffbcb0 | popSql.OnSql | FP00590_PlanTotalPopup.cs:2447 | else of (programID == "PR_UI_FP00590_CREATE_PLAN") ▸ if (programID == "PR_UI_FP00590_ENGINE_RUN") | RETURN | return Find_Data_Sub("SQL", pPlanGroup, pPlanID); |  | 처리 중단/반환 |  |  |  |
| AC-f7b432b2 | popSql.OnSql | FP00590_PlanTotalPopup.cs:2450 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup.Save_Create_Plan

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9fc38a5 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1357 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-dc598e66 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1357 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60cddbaa | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1359 | if (siSub == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bfd64dc | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1366 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d13b610 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1367 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea32d8f9 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1370 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b65146ab | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1385 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-19a4717a | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1386 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a108d2e7 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1399 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds3.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f52e092 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1402 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | FLAG | dtRevision | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a788c9f1 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1402 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7151be7c | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1403 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | LIST_REBIND | clsCtrl.setListBox | (dtRevision, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1ea73d69 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1404 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | VALUE_SET | cboPlanID.SelectedValue | DsinData.PLAN_ID | 컨트롤 값 설정 |  |  |  |
| AC-3eb920fa | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1407 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | FLAG | blnCreateRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-05d85049 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1410 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[… | VALUE_SET | chkStatus.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-1d622184 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1419 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ else of (ds3.Tables[0].… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c6b21e9 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1428 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ else of (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b848e4c | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1438 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00632df4 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1442 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-03f9fcf2 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1446 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e55eacc5 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1451 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d2689986 | this.btnCreatePlan.Click | FP00590_PlanTotalPopup.cs:1452 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_PlanTotalPopup.Save_Create_PlanData

진입점: this.btnCreatePlan.Click [try] / popSql.OnSql [if (programID == "PR_UI_FP00590_CREATE_PLAN")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91bea2cf | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1492 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findNewPlan", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf6ec062 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1498 | try ▸ if (dtNewPlanID.Rows.Count > 0) | FLAG | this._NewPlanId | sNewPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-28329889 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1503 | try ▸ if (dtNewPlanID.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sNewPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6fdffeed | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1504 | try ▸ if (dtNewPlanID.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sNewPlanID)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-afe58bd5 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1508 | try | UI_PROP | DsinData.PLAN_ID | sNewPlanID | 속성 PLAN_ID 설정 |  |  |  |
| AC-f2df8355 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1512 | try ▸ if (DsinData.PLAN_TYPE.Equals("PRE")) | UI_PROP | DsinData.BASIS_PLAN_ID | sNewPlanID | 속성 BASIS_PLAN_ID 설정 |  |  |  |
| AC-1271396d | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1540 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-3d56d583 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1541 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1c6aa74f | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1543 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ffeee429 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1544 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a6b18109 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1545 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d2884e50 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1546 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4238335 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1548 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a57113ee | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1549 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-85667329 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1550 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-6e2bcd75 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1551 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc234d69 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1553 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-6d0b9742 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1554 | try | DATA_OP | req.Parameters["p_plan_horizon"] | p_plan_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-0f764006 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1555 | try | DATA_OP | req.Parameters["p_demand_horizon"] | p_demand_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-042d3d73 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1556 | try | DATA_OP | req.Parameters["p_basis_plan_id"] | p_basis_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b12e98a | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1557 | try | DATA_OP | req.Parameters["p_pre_fix_flag"] | p_pre_fix_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a88f166f | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1558 | try | DATA_OP | req.Parameters["p_pre_fix_target_id"] | p_pre_fix_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e1bb0f1 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1559 | try | DATA_OP | req.Parameters["p_sync_operation"] | p_sync_operation | 행/컬럼 값 대입 |  |  |  |
| AC-f97b9fc0 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1560 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f640d0e8 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1561 | try | DATA_OP | req.Parameters["p_pre_fix_type"] | p_pre_fix_type | 행/컬럼 값 대입 |  |  |  |
| AC-331592c8 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1562 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-0b05ab0f | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1563 | try | DATA_OP | req.Parameters["p_pre_fix_2_flag"] | p_pre_fix_2_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d01e3999 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1564 | try | DATA_OP | req.Parameters["p_pre_fix_date2"] | p_pre_fix_date2 | 행/컬럼 값 대입 |  |  |  |
| AC-96ad1689 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1565 | try | DATA_OP | req.Parameters["p_pre_fix_type2"] | p_pre_fix_type2 | 행/컬럼 값 대입 |  |  |  |
| AC-0d18bc10 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1566 | try | DATA_OP | req.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2abdc998 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1568 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02f7c14a | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1569 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6520fad2 | this.btnCreatePlan.Click [try] 외 1 | FP00590_PlanTotalPopup.cs:1576 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup.SetDsinDataByControl

진입점: this.btnCreatePlan.Click / popSql.OnSql [if (programID == "PR_UI_FP00590_CREATE_PLAN") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74cbbeec | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1000 |  | UI_PROP | DsinData.PLAN_HORIZON | dtLookupByInstance.Rows[0]["PLAN_HORIZON"].ToString() | 속성 PLAN_HORIZON 설정 |  |  |  |
| AC-6e9ef894 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1001 |  | UI_PROP | DsinData.DEMAND_HORIZON | dtLookupByInstance.Rows[0]["DEMAND_HORIZON"].ToString() | 속성 DEMAND_HORIZON 설정 |  |  |  |
| AC-d6d4f7db | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1004 |  | UI_PROP | DsinData.ALLOWFIXDATENULL | dtfixDateInfo.Rows[0]["ALLOWED_FIX_DATE_NULL"].ToString() | 속성 ALLOWFIXDATENULL 설정 |  |  |  |
| AC-ff31d231 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1006 |  | UI_PROP | DsinData.SITE_ID | txtSite.Text.Trim() | 속성 SITE_ID 설정 |  |  |  |
| AC-a3079d31 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1007 |  | UI_PROP | DsinData.INSTANCE_ID | txtPlanGroup.Text.Trim() | 속성 INSTANCE_ID 설정 |  |  |  |
| AC-5cce605f | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1008 |  | UI_PROP | DsinData.PLAN_DATE | drpPeriod.Text1.Replace("-", "").Replace("/","").Replace(".","") | 속성 PLAN_DATE 설정 |  |  |  |
| AC-14f10837 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1009 |  | UI_PROP | DsinData.PLAN_END_TIME | drpPeriod.Text2.Replace("-", "").Replace("/", "").Replace(".", "") | 속성 PLAN_END_TIME 설정 |  |  |  |
| AC-438b4aea | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1010 |  | UI_PROP | DsinData.DESCRIPTION | txtDescription.Text.Trim().Replace("'","''") | 속성 DESCRIPTION 설정 |  |  |  |
| AC-cd3fab99 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1014 | if (rdoGroup1.SelectedIndex == 0) | UI_PROP | DsinData.PLAN_TYPE | "PRE" | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-8f2e872f | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1019 | else of (rdoGroup1.SelectedIndex == 0) | UI_PROP | DsinData.PLAN_TYPE | "SYNC" | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-669cc7a0 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1020 | else of (rdoGroup1.SelectedIndex == 0) | UI_PROP | DsinData.BASIS_PLAN_ID | CString.GetCheckedListValue(dtBasisPlan, cboBasePlanID.ControlValues, true) | 속성 BASIS_PLAN_ID 설정 |  |  |  |
| AC-87b27606 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1023 |  | UI_PROP | DsinData.SYNC_OPERATION_ID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues, true) | 속성 SYNC_OPERATION_ID 설정 |  |  |  |
| AC-f8be9f6b | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1024 |  | UI_PROP | DsinData.PRE_FIX_TARGET_ID | "" | 속성 PRE_FIX_TARGET_ID 설정 |  |  |  |
| AC-7f0f1e8e | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1027 | if (chkPreFix.Checked == true) | UI_PROP | DsinData.PRE_FIX_FLAG | "Y" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-0d869b86 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1029 | else of (chkPreFix.Checked == true) | UI_PROP | DsinData.PRE_FIX_FLAG | "N" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-2d33c489 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1036 | if (sFixOption1.Equals("1")) | UI_PROP | DsinData.PRE_FIX_TYPE | "QTY_FIX" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-d183e062 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1040 | else of (sFixOption1.Equals("1")) ▸ if (sFixOption1.Equals("2")) | UI_PROP | DsinData.PRE_FIX_TYPE | "SEQ_FIX" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-8d4a835b | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1044 | else of (sFixOption1.Equals("1")) ▸ else of (sFixOption1.Equals("2")) ▸ if (sFixOption1.Equals("3")) | UI_PROP | DsinData.PRE_FIX_TYPE | "QTY_KEEP" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-54a99125 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1048 | else of (sFixOption1.Equals("1")) ▸ else of (sFixOption1.Equals("2")) ▸ else of (sFixOption1.Equals("3")) | UI_PROP | DsinData.PRE_FIX_TYPE | "QTY_FIX" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-f3ebff6f | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1084 | if (chkPreFix2.Checked == true) | UI_PROP | DsinData.PRE_FIX_2_FLAG | "Y" | 속성 PRE_FIX_2_FLAG 설정 |  |  |  |
| AC-b629bf15 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1088 | if (chkPreFix2.Checked == true) ▸ if (rdoGroup3.SelectedIndex == 0) | UI_PROP | DsinData.PRE_FIX_TYPE2 | "QTY_FIX" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-5da0cd72 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1095 | if (chkPreFix2.Checked == true) ▸ else of (rdoGroup3.SelectedIndex == 0) ▸ if (rdoGroup3.SelectedIndex == 1) ▸ if (sValue.Equals("2")) | UI_PROP | DsinData.PRE_FIX_TYPE2 | "SEQ_FIX" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-16e58e06 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1097 | if (chkPreFix2.Checked == true) ▸ else of (rdoGroup3.SelectedIndex == 0) ▸ if (rdoGroup3.SelectedIndex == 1) ▸ else of (sValue.Equals("2")) … | UI_PROP | DsinData.PRE_FIX_TYPE2 | "QTY_KEEP" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-84228155 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1104 | if (chkPreFix2.Checked == true) ▸ else of (rdoGroup3.SelectedIndex == 0) ▸ else of (rdoGroup3.SelectedIndex == 1) ▸ if (rdoGroup3.SelectedIn… | UI_PROP | DsinData.PRE_FIX_TYPE2 | "SEQ_FIX" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-e82bcefc | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1106 | if (chkPreFix2.Checked == true) ▸ else of (rdoGroup3.SelectedIndex == 0) ▸ else of (rdoGroup3.SelectedIndex == 1) ▸ if (rdoGroup3.SelectedIn… | UI_PROP | DsinData.PRE_FIX_TYPE2 | "QTY_KEEP" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-1b8654cb | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1110 | if (chkPreFix2.Checked == true) ▸ else of (rdoGroup3.SelectedIndex == 0) ▸ else of (rdoGroup3.SelectedIndex == 1) ▸ else of (rdoGroup3.Selec… | UI_PROP | DsinData.PRE_FIX_TYPE2 | "QTY_FIX" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-21e61a45 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1115 | else of (chkPreFix2.Checked == true) | UI_PROP | DsinData.PRE_FIX_2_FLAG | "N" | 속성 PRE_FIX_2_FLAG 설정 |  |  |  |
| AC-e4d67cc6 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1116 | else of (chkPreFix2.Checked == true) | UI_PROP | DsinData.PRE_FIX_TYPE2 | "" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-611acc39 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1122 | if (dtpFixDate2.Enabled == false) | UI_PROP | DsinData.PRE_FIX_DATE | dtpFixDate1.Text.ToString().Replace("-", "").Replace("/","").Replace(".","").Trim() | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-53fbc725 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1126 | if (dtpFixDate2.Enabled == false) ▸ if (!string.IsNullOrEmpty(dtpFixDate1.Text.ToString().Replace("-", "").Replace("/", "").Replace(".", "")… | UI_PROP | DsinData.PRE_FIX_DATE | dtpFixDate1.Value.ToString("yyyyMMdd") | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-061b20eb | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1129 | if (dtpFixDate2.Enabled == false) | UI_PROP | DsinData.PRE_FIX_DATE2 | "" | 속성 PRE_FIX_DATE2 설정 |  |  |  |
| AC-04a04024 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1133 | else of (dtpFixDate2.Enabled == false) | UI_PROP | DsinData.PRE_FIX_DATE | dtpFixDate1.Text.ToString().Replace("-", "").Replace("/", "").Replace(".", "").Trim() | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-26bc3bc3 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1137 | else of (dtpFixDate2.Enabled == false) ▸ if (!string.IsNullOrEmpty(dtpFixDate1.Text.ToString().Replace("-", "").Replace("/", "").Replace("."… | UI_PROP | DsinData.PRE_FIX_DATE | dtpFixDate1.Value.ToString("yyyyMMdd") | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-2a313adb | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1140 | else of (dtpFixDate2.Enabled == false) | UI_PROP | DsinData.PRE_FIX_DATE2 | dtpFixDate2.Text.ToString().Replace("-", "").Replace("/", "").Replace(".", "").Trim() | 속성 PRE_FIX_DATE2 설정 |  |  |  |
| AC-b9a6d167 | this.btnCreatePlan.Click 외 1 | FP00590_PlanTotalPopup.cs:1143 | else of (dtpFixDate2.Enabled == false) ▸ if (!string.IsNullOrEmpty(dtpFixDate2.Text.ToString().Replace("-", "").Replace("/", "").Replace("."… | UI_PROP | DsinData.PRE_FIX_DATE2 | dtpFixDate2.Value.ToString("yyyyMMdd") | 속성 PRE_FIX_DATE2 설정 |  |  |  |

## FP00590_PlanTotalPopup.SetFixOption2_Default

진입점: this.rdoGroup2.SelectedIndexChanged / this.Load [try] / rdoGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6aa29ca | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2385 | else of (sUserID.IndexOf("DEMO") != -1) | CALL_EXT | UserService.HasPIRole | (sUserID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bde0d2ac | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2397 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ if (pFixOptionValu… | UI_PROP | lblGroup3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-961aa795 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2398 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ if (pFixOptionValu… | UI_PROP | lblbtnNoFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4de31db8 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2399 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ if (pFixOptionValu… | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-525941a7 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2401 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ if (pFixOptionValu… | VALUE_SET | chkPreFix2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-dbf01728 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2407 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ else of (pFixOptio… | UI_PROP | lblGroup3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-52c61e35 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2408 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ else of (pFixOptio… | UI_PROP | lblbtnNoFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dd1d7345 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2409 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ else of (pFixOptio… | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e1d162c1 | this.rdoGroup2.SelectedIndexChanged 외 2 | FP00590_PlanTotalPopup.cs:2411 | else of (sUserID.IndexOf("DEMO") != -1) ▸ else of (UserService.HasPIRole(sUserID)) ▸ if (_sPlanGroup.Equals("PL_PACK")) ▸ else of (pFixOptio… | VALUE_SET | chkPreFix2.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00590_PlanTotalPopup.SetPreFixDate

진입점: this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ try] / cboBasePlanID.SelectedIndexChanged / rdoGroup1.SelectedIndexChanged [else of (radioGroup.SelectedIndex == 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da7923df | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2316 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") | FLAG | dtBasisPlan | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findEndRevision", _sPlanGr… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8529eb18 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2316 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEndRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2f9c91d | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2324 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ if (dtBasisPlan != null) ▸ if (dtBasisPlan.Rows.Count > 0) | DATA_OP | dtResult.Columns.Add | ("PRE_FIX_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a297c8ea | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2328 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ if (dtBasisPlan != null) ▸ if (dtBasisPlan.Rows.Count > 0) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6c9f287 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2333 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ if (dtBasisPlan != null) ▸ if (dtBasisPlan.Rows.Count > 0) ▸ foreac… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed446b7b | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2349 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ if (!string.IsNullOrEmpty(sPreFixDate)) ▸ if (!sPreFixDate.Equals("… | VALUE_SET | dtpFixDate1.Value | dDate | 컨트롤 값 설정 |  |  |  |
| AC-e202246b | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2351 | try ▸ if (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") ▸ if (!string.IsNullOrEmpty(sPreFixDate)) ▸ if (!sPreFixDate.Equals("… | UI_PROP | dtpFixDate1.Format | DateTimePickerFormat.Short | 속성 Format 설정 |  |  |  |
| AC-7d15af1c | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2364 | try ▸ else of (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") | UI_PROP | dtpFixDate1.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-fe619b0a | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2365 | try ▸ else of (dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() == "Y") | VALUE_CLEAR | dtpFixDate1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c49738a3 | this.Load [try ▸ else of (radioGroup.SelectedIndex == 0) ▸ t… 외 2 | FP00590_PlanTotalPopup.cs:2372 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_PlanTotalPopup.SpdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10bc8e14 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:2239 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f40251dc | (진입점 미연결) | FP00590_PlanTotalPopup.cs:2240 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b110a9ab | (진입점 미연결) | FP00590_PlanTotalPopup.cs:2260 | if (siSub != null) ▸ if (e.Row == 1) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc5b03f9 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:2261 | if (siSub != null) ▸ if (e.Row == 1) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da942952 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:2273 | if (siSub != null) ▸ if (e.Row == 1) ▸ else of (this.ViewModel != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c52180b5 | (진입점 미연결) | FP00590_PlanTotalPopup.cs:2280 | if (siSub != null) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00590_PlanTotalPopup.Update_Clear_Status

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32c8cbb4 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1635 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-61b296bd | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1636 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-351f0857 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1638 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-abbb012d | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1639 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7e23082f | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1640 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9dd49109 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1641 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-64aa34d8 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1643 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7ed45c1a | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1644 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-63d80465 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1645 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-8b1fe316 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1646 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c58534a | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1648 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0465bd64 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1649 | try | DATA_OP | req.Parameters["p_plan_horizon"] | p_plan_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-e4ed66d1 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1650 | try | DATA_OP | req.Parameters["p_demand_horizon"] | p_demand_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-b911eedd | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1651 | try | DATA_OP | req.Parameters["p_basis_plan_id"] | p_basis_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb2f95ae | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1652 | try | DATA_OP | req.Parameters["p_pre_fix_flag"] | p_pre_fix_flag | 행/컬럼 값 대입 |  |  |  |
| AC-df64f34e | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1653 | try | DATA_OP | req.Parameters["p_pre_fix_target_id"] | p_pre_fix_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc8b9c6b | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1654 | try | DATA_OP | req.Parameters["p_sync_operation"] | p_sync_operation | 행/컬럼 값 대입 |  |  |  |
| AC-44600bd9 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1655 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-26ceecae | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1656 | try | DATA_OP | req.Parameters["p_pre_fix_type"] | p_pre_fix_type | 행/컬럼 값 대입 |  |  |  |
| AC-b2ea9909 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1657 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-42bf913f | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1658 | try | DATA_OP | req.Parameters["p_pre_fix_2_flag"] | p_pre_fix_2_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ae1bd85c | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1659 | try | DATA_OP | req.Parameters["p_pre_fix_date2"] | p_pre_fix_date2 | 행/컬럼 값 대입 |  |  |  |
| AC-f93bc6eb | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1660 | try | DATA_OP | req.Parameters["p_pre_fix_type2"] | p_pre_fix_type2 | 행/컬럼 값 대입 |  |  |  |
| AC-5616afa3 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1661 | try | DATA_OP | req.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-59551ccd | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1663 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-40ef09fa | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1664 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0d1f8561 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1671 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_PlanTotalPopup.Update_Engine_Run

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c169bd73 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1730 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-09569691 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1731 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f20759c5 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1733 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-38c4901b | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1734 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-548e6292 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1735 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-445ae7eb | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1736 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb6d359c | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1738 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-11011136 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1739 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5e3bb62 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1740 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-612e6941 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1741 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb63835 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1743 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-dcb6290d | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1744 | try | DATA_OP | req.Parameters["p_plan_horizon"] | p_plan_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-e9184b36 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1745 | try | DATA_OP | req.Parameters["p_demand_horizon"] | p_demand_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-24ef25ea | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1746 | try | DATA_OP | req.Parameters["p_basis_plan_id"] | p_basis_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd430817 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1747 | try | DATA_OP | req.Parameters["p_pre_fix_flag"] | p_pre_fix_flag | 행/컬럼 값 대입 |  |  |  |
| AC-49529fb8 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1748 | try | DATA_OP | req.Parameters["p_pre_fix_target_id"] | p_pre_fix_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-f70960d3 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1749 | try | DATA_OP | req.Parameters["p_sync_operation"] | p_sync_operation | 행/컬럼 값 대입 |  |  |  |
| AC-364f5f6c | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1750 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f669fcfd | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1751 | try | DATA_OP | req.Parameters["p_pre_fix_type"] | p_pre_fix_type | 행/컬럼 값 대입 |  |  |  |
| AC-137f4d08 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1752 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-1b3df0cb | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1753 | try | DATA_OP | req.Parameters["p_pre_fix_2_flag"] | p_pre_fix_2_flag | 행/컬럼 값 대입 |  |  |  |
| AC-82dcff3d | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1754 | try | DATA_OP | req.Parameters["p_pre_fix_date2"] | p_pre_fix_date2 | 행/컬럼 값 대입 |  |  |  |
| AC-84bb0880 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1755 | try | DATA_OP | req.Parameters["p_pre_fix_type2"] | p_pre_fix_type2 | 행/컬럼 값 대입 |  |  |  |
| AC-b16d0648 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1756 | try | DATA_OP | req.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-314b5949 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1758 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba8732aa | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1759 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3725c575 | this.btnCreatePlan.Click [try ▸ if (ds.Tables[0].Rows[0][0].… | FP00590_PlanTotalPopup.cs:1765 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9132b56f | .ctor | FP00590_ReleaseTotalPopup.cs:147 |  | UI_PROP | SpdSheet.shtMain | "ReleaseTotalPopup" | 속성 shtMain 설정 |  |  |  |
| AC-064d97a9 | .ctor | FP00590_ReleaseTotalPopup.cs:149 |  | FLAG | _sSite | sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-9d74a525 | .ctor | FP00590_ReleaseTotalPopup.cs:150 |  | FLAG | _sPlanGroup | sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-28f88b5a | .ctor | FP00590_ReleaseTotalPopup.cs:151 |  | FLAG | _sPlanDate | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-d7ab3d12 | .ctor | FP00590_ReleaseTotalPopup.cs:152 |  | FLAG | _sPlanID | sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-115e29e6 | .ctor | FP00590_ReleaseTotalPopup.cs:153 |  | FLAG | _sIsSamePlanID | sIsSamePlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-e8dd4a49 | .ctor | FP00590_ReleaseTotalPopup.cs:154 |  | FLAG | _sDescription | sDescription | 화면 필드/플래그 변경 |  |  |  |

## FP00590_ReleaseTotalPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0710327 | this.btnClose.Click | FP00590_ReleaseTotalPopup.cs:3137 | if (blnReleaseRun == true) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1bffee89 | this.btnClose.Click | FP00590_ReleaseTotalPopup.cs:3139 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_ReleaseTotalPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d83a9c37 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3145 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a755a6b2 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3146 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e8cba1c0 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3148 |  | DATA_OP | popSql.Services.Add | ("SELECT_RELEASE_TOTAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea39bca8 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3149 |  | DATA_OP | popSql.Services.Add | ("CONFIRM_VALIDATION_1") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c5f1c75 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3150 |  | DATA_OP | popSql.Services.Add | ("CONFIRM_VALIDATION_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-0adc1a51 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3151 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_RELEASE") | 데이터 객체 조작/조회 |  |  |  |
| AC-47963e45 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3152 |  | DATA_OP | popSql.Services.Add | ("UPDATE_DIVISIONLIST") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d7479fd | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3153 |  | DATA_OP | popSql.Services.Add | ("INSERT_RUNNING_RELEASE") | 데이터 객체 조작/조회 |  |  |  |
| AC-97844f32 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3154 |  | DATA_OP | popSql.Services.Add | ("DELETE_RUNNING_RELEASE") | 데이터 객체 조작/조회 |  |  |  |
| AC-40bc5a36 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3155 |  | DATA_OP | popSql.Services.Add | ("RELEASE_VALIDATION_1") | 데이터 객체 조작/조회 |  |  |  |
| AC-19a8b88e | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3156 |  | DATA_OP | popSql.Services.Add | ("RELEASE_VALIDATION_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-aea61464 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3157 |  | DATA_OP | popSql.Services.Add | ("UPDATE_RELEASE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-611b5537 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3158 |  | DATA_OP | popSql.Services.Add | ("UPDATE_RELEASE_PLANLIST_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-84f02ddf | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3159 |  | DATA_OP | popSql.Services.Add | ("INSERT_HIST_DETAIL") | 데이터 객체 조작/조회 |  |  |  |
| AC-816443ab | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3160 |  | DATA_OP | popSql.Services.Add | ("INSERT_OT_NET_JOB") | 데이터 객체 조작/조회 |  |  |  |
| AC-4728266d | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3161 |  | DATA_OP | popSql.Services.Add | ("EXEC_SENDMAIL_FINALTOTAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-be2bb9c4 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3162 |  | DATA_OP | popSql.Services.Add | ("EXEC_SEND_SMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f4b26aa | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3163 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_MES_ERP_WO_MASTER") | 데이터 객체 조작/조회 |  |  |  |
| AC-d06a5ac6 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3164 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b681a06 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3165 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-e95df8bf | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3166 |  | DATA_OP | popSql.Services.Add | ("EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-c46edfb9 | this.btnSql.Click | FP00590_ReleaseTotalPopup.cs:3168 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_ReleaseTotalPopup.Check_CapaValidation

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c31bc67 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3539 | if (dtInstance.Rows[0]["CAPA_VALIDATION"].ToString() != "Y") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-94c42b14 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3559 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2da9689 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3564 | if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c5a6eb63 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3569 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CapaValidation", _sPlanGroup, _sPlanID, _sPlanDate, _sPlanE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4cadff2c | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3584 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | POPUP | new FP00590_CapaValidationPopup | ("CapaValidationPopup", dtCapaValid.DataSet) | 팝업/폼 생성 |  |  |  |
| AC-9a075e4d | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3585 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | UI_PROP | popCapaValid.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-81c9679c | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3586 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | UI_PROP | popCapaValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a6309b5c | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3588 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) | POPUP | popCapaValid.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7743686b | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3590 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) ▸ if (popCapaValid.ShowDialog() == DialogResult.OK) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3fc1d650 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3596 | if (dtCapaValid != null) ▸ if (dtCapaValid.Rows.Count > 0) ▸ else of (popCapaValid.ShowDialog() == DialogResult.OK) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ce0297a3 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3601 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Check_ConfirmValidation

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45127c27 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3501 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | POPUP | new FP00590_ValidationPopup | ("ConfirmValid1Popup", dsValid_1, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-423b542e | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3502 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | UI_PROP | popConfirmValid1.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-699b0913 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3503 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | POPUP | popConfirmValid1.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3278d43a | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3504 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3168b251 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3523 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | POPUP | new FP00590_ValidationPopup | ("ConfirmValid2Popup", dsValid_2, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-ddb56b49 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3524 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | UI_PROP | popConfirmValid2.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5de9755a | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3525 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | POPUP | popConfirmValid2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-92af6e82 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3526 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-29bd4e97 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3530 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Check_Exec_IsRunningEngine

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f6b6300 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3292 | switch (sType) case "SELECT_INIT": | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release", _sPlanGroup, p_facoty_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6411bf5 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3299 | switch (sType) case "SELECT_INIT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9147694d | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3300 | switch (sType) case "SELECT_INIT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e68ee166 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3326 | switch (sType) case "INSERT": ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-84fd0f02 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3331 | switch (sType) case "INSERT": | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d9db643f | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3352 | switch (sType) case "SELECT": | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release", _sPlanGroup, p_facoty_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-490b7119 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3363 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) ▸ for (i < dtIsRunRelease.Rows.Count) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf9d67db | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3364 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) ▸ for (i < dtIsRunRelease.Rows.Count) ▸ if … | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-44a47773 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3366 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) ▸ for (i < dtIsRunRelease.Rows.Count) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-05353083 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3371 | switch (sType) case "SELECT": ▸ if (dtIsRunRelease != null) ▸ else of (dtIsRunRelease.Rows.Count > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4152c6cc | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3397 | switch (sType) case "DELETE": ▸ if (ds1 != null) ▸ else of (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-ccffd454 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3403 | switch (sType) case "DELETE": | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-dc29d0e8 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3406 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Check_isConfirmed

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e82a2e3a | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3441 | if (iCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isConfirmed", p_sql) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c1a2eaa7 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3462 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ if (dtConfirm.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-372bdf6e | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3463 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ if (dtConfirm.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fa51c47b | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3467 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ else of (dtConfirm.Rows.Count > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6edca663 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3472 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Check_IsPastDate

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0ec5d07 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3609 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isPast", _sSite, _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f5fb7ca4 | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3616 | if (dtPastdate != null) ▸ if (dtPastdate.Rows.Count > 0) ▸ if (dtPastdate.Rows[0]["DATE_VALID"].ToString() == "Y") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f946893a | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3622 | if (dtPastdate != null) ▸ if (dtPastdate.Rows.Count > 0) ▸ else of (dtPastdate.Rows[0]["DATE_VALID"].ToString() == "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6868a25d | this.btnSave.Click [try] | FP00590_ReleaseTotalPopup.cs:3628 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d205fe7 | this.Load | FP00590_ReleaseTotalPopup.cs:272 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89290de8 | this.Load | FP00590_ReleaseTotalPopup.cs:273 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c94208ff | this.Load | FP00590_ReleaseTotalPopup.cs:274 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_ReleaseTotalPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bb4ee1d | this.Load | FP00590_ReleaseTotalPopup.cs:266 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_ReleaseTotalPopup.Delete_Is_Running_Release

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ if (programID == "DELETE_RUNNING_RELEASE") ▸ if (bCheck == true)] / this.btnSave.Click [try ▸ switch (sType) case "DELETE":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ec88f08 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2210 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-2952028d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2211 | try | FLAG | p_sys_flag | "DELETE_RUNNING_RELEASE" | 화면 필드/플래그 변경 |  |  |  |
| AC-105aeabd | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2212 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e0d585ab | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2213 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-32fcd1cd | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2214 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-f0b7f47a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2216 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-07d4210d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2220 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-fd04effc | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2221 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-648d9eb0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2223 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-5a72aa0a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2224 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-798d9c30 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2225 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-fdfd62ed | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2226 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-923ea63f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2228 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b3483fa | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2229 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62c8abe4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2230 | try | DATA_OP | req.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-37399ab2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2231 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-53bf16b6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2232 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0979fa5b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2233 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-efb1d835 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2234 | try | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6708eb9f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2235 | try | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe211c43 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2236 | try | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-525a26f8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2237 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7d2223e2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2238 | try | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-abf20d9b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2239 | try | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b4319314 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2240 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df18c23b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2241 | try | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62ff43fc | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2242 | try | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-089827fa | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2243 | try | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65c20d2b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2244 | try | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aad33110 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2245 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3bd9aad4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2246 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e1a9902c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2248 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b33961de | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2249 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5718a593 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2255 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1cad123 | Dispose | FP00590_ReleaseTotalPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_ReleaseTotalPopup.EditButton

진입점: this.Load [try ▸ if (ds != null)] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ if (ds != null)] / this.btnFind.Click [try ▸ if (ds != null)] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beebab51 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:345 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccf0c8f5 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:347 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-44fd1363 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:351 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SITE_ID), siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-58dbe878 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:352 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ISENABLE), siMain.GetColumnIndex(DefColumns.ISCHK), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c549e8f | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:362 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_ID… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.CHK), i, siMain.GetColumnIndex(DefColumns.CONFIRM_FLA… | 그리드 편집 잠금 전환 |  |  |  |
| AC-30179497 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:363 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_ID… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.ISENABLE), i, siMain.GetColumnIndex(DefColumns.ISCHK)… | 그리드 편집 잠금 전환 |  |  |  |
| AC-b6bd9209 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:368 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |
| AC-9a3f3971 | this.Load [try ▸ if (ds != null)] 외 3 | FP00590_ReleaseTotalPopup.cs:372 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_MES_ERP_WO_MASTER

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ else of (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dfa852c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2595 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-05dd1557 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2602 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4b360fcf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2602 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c53f6e8a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2604 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-70e125de | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2605 | try | FLAG | p_sys_flag | "EXECUTE_MES_ERP_WO_MASTER" | 화면 필드/플래그 변경 |  |  |  |
| AC-caea9281 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2606 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2836a262 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2607 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-411053b6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2620 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-b883ff99 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2621 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f7af4a46 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2623 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d17b633e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2624 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-67c5c4fb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2625 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e449bff6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2626 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e2d2542 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2628 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6473bb36 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2629 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e315262 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2630 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ec3ddd0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2631 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdecb5f1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2632 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bd44bfe5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2633 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-d6f33475 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2634 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-906273a8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2635 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa069ac9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2636 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-249e4ca7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2637 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3a08c0ba | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2638 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84c0ed95 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2639 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cad4b517 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2640 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5726d2f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2641 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-22d912cb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2642 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c12409de | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2643 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-40ff2a19 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2644 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f061b08 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2645 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c62dd3be | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2646 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-cac4f800 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2648 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c2bca09 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2654 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ef2e3889 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2659 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_PR_SCM_OF_ASSY_ELEC_REPORT

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (_sPlanGroup.IndexOf("E_POST") == -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-589c6760 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2767 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-cc94cd6d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2768 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-886da92f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2769 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-e1533126 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2770 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-159c59ac | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2771 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-338704ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2773 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f9d435c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2774 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8daf999c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2775 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8baf24f8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2776 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-b02e1862 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2777 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-22aefb09 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2778 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1ab887e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2779 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-159dfef8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2780 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f40eb711 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2781 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0eda714b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2782 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e5867f5a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2783 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2752ced1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2784 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-44f99271 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2785 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-58c57091 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2786 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f0317d0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2787 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e343be30 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2788 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce39efa0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2789 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81d9ecde | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2790 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68a224a3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2791 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c3a4be93 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2793 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41b82796 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2795 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b13b3116 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2800 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_PR_SCM_OF_CELL_DELIVERY_PLAN

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eceb643a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2981 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c5fe7c37 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2985 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-2f5a0ed3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2986 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-f630b3a4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2987 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN" | 행/컬럼 값 대입 |  |  |  |
| AC-8eb8c833 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2988 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd05e62e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2989 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-848c9d12 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2991 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d27bfa52 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2992 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f953597 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2993 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de66fc07 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2994 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-719b8acd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2995 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b90b47b9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2996 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-332ac1d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2997 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c2407e72 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2998 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8cb1e51e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2999 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e93c821f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3000 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d45491fd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3001 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ddd08fe8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3002 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9c06341 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3003 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2eb5be5d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3004 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f1ad8d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3005 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85cb29a3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3006 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-127eef36 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3007 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ceef74c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3008 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98653cfa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3009 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ed5e0fb0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3011 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a17e2182 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3013 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-702dc94b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3018 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_PR_SCM_OF_PACK_REQUIRE_CEL

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["PACK_INHOUSE_OPTION"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c5b1d30 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2825 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1708c84e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2829 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-964e4585 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2830 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-72d1fd7b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2831 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL" | 행/컬럼 값 대입 |  |  |  |
| AC-dc09f74f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2832 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d14365b5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2833 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fa64de7d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2835 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4574e5cf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2836 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91b294ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2837 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eea1e87c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2838 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-3627e3de | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2839 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f70b273 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2840 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f05a67d0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2841 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bc3e4282 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2842 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c507969 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2843 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ac48251 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2844 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9059c485 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2845 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8da01039 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2846 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-09b751cf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2847 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc403616 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2848 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-18666f01 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2849 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c1862701 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2850 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fcab7544 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2851 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6d0426f8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2852 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b69e883c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2853 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ffb3043c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2855 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9c267a4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2857 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ee9e70f0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2862 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_PR_SCM_OF_PACK_TO_CELL

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["PACK_INHOUSE_OPTION"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb4da072 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2891 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e765b06f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2898 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8e441d8d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2898 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d82e42b5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2900 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-4218cb1b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2901 | try | FLAG | p_sys_flag | "EXECUTE_PR_SCM_OF_PACK_TO_CELL" | 화면 필드/플래그 변경 |  |  |  |
| AC-c2eeea98 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2902 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-af9979d6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2903 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-66567744 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2918 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-c5074eb8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2919 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4cd17739 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2921 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-43a0b517 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2922 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-77dd4ebc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2923 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-56df5b48 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2924 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-21167a15 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2926 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f0f43e4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2927 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ab58d81 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2928 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c825fcf8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2929 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-6ad36019 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2930 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5b9192b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2931 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-6344ef51 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2932 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc6d1bcf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2933 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab42c1f4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2934 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9ff13f3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2935 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84e7615e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2936 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-71a50fd8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2937 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-965a1f98 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2938 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6d9a2592 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2939 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d580c2b6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2940 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84a5087c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2941 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-15ccdfa4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2942 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-47521f1f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2943 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-75d52281 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2944 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b35fe70c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2946 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f207f05b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2952 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-2a1c92c5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2957 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_PR_SCM_PIC_ALARM

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e34df5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3054 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "INSTANCE_OPTION", _sSite, _sPlanGroup, _sPlanDate, _sPlanID, sFactory_LT… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7cfce2bd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3056 | try ▸ if (dtTmp.Rows[0]["PIC_ALARM"].ToString() != "Y") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-06597de4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3058 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-6545ffcb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3059 | try | FLAG | p_sys_flag | "PR_SCM_PIC_ALARM" | 화면 필드/플래그 변경 |  |  |  |
| AC-cc538ea6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3060 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7e855c4e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3061 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-7c0f18bb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3074 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-27f77907 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3075 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d5b9e94f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3077 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-4fc56f89 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3078 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-66e51543 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3079 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-903c386c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3080 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0d2a3bc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3082 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e573b96f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3083 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bef3261f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3084 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f0bb1c0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3085 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-b5b77ccd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3086 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-140cb3c2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3087 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-85470488 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3088 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5ddc8d7d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3089 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2fb2d8c4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3090 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f544f85a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3091 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42d8d4d2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3092 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f70f614 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3093 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cdd19760 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3094 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dcddd746 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3095 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89d1d33f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3096 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-61e09485 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3097 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42d9f341 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3098 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bccef3a7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3099 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73ecc8e0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3100 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-34151ddf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3102 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07a15f28 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3108 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-80eb03eb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:3113 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_Release_Main

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57bbcbe1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1183 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ if (dsResult.Tables[idx].Rows.Count > 0) ▸ else of … | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-b6aa8d0c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1185 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ if (dsResult.Tables[idx].Rows.Count > 0) ▸ else of … | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-cc9f964f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1193 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ else of (dsResult.Tables[idx].Rows.Count > 0) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-f43f7524 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1195 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ else of (dsResult.Tables[idx].Rows.Count > 0) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-b9ad25ff | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1205 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ else of (dsResult != null) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-d92d507f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1207 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ else of (dsResult != null) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-cf87e7bf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1225 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsAll != null) ▸ if (dsAll.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-758359bf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1228 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsAll != null) ▸ if (dsAll.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-a23bc114 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1262 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (Find_Duplicate_Check(sInstance, sFactory) == false) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-23c2c7a1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1280 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (dsRelease != null) ▸ if (dsRelease.Tables[0].Rows[0][0].ToString() != "0") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-eb88aab2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1282 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (dsRelease != null) ▸ if (dsRelease.Tables[0].Rows[0][0].ToString() != "0") | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-779a64ff | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1289 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ else of (dsRelease != null) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-bf81da7b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1290 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ else of (dsRelease != null) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-020e0a71 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1306 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (dsSendMail != null) ▸ if (dsSendMail.Tables[0].Rows[0][0].ToString() != "1") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-640e16d7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1316 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ catch ((Exception ex2)) | MESSAGE | MessageBox.Show | (ex2.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-c6c2a531 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1317 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ catch ((Exception ex2)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-439e1c9b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1323 | try ▸ if (iCount == 0) | MESSAGE | MessageBox.Show | ("Please, check row!. Check Row Count is Zero!", "Warning", MessageBoxButtons.OK, MessageB… | 메시지 표시 |  |  |  |
| AC-706c30d3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1324 | try ▸ if (iCount == 0) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-8222084e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1337 | try ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F") | RETURN | return "PROCEED"; |  | 처리 중단/반환 |  |  |  |
| AC-e0fd6beb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1341 | try | RETURN | return "PROCEED"; |  | 처리 중단/반환 |  |  |  |
| AC-da22f462 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1346 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-0234bdcd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1347 | catch ((Exception ex)) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_Release_Plan

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ if (programID == "EXECUTE_RELEASE") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !string.IsNullOrEmpty(siMain.Ge…)] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e559ab27 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1534 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-b24b7bd2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1535 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-919561b4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1536 | try | FLAG | p_sys_flag | "EXECUTE_RELEASE" | 화면 필드/플래그 변경 |  |  |  |
| AC-cdf06940 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1537 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3551dd21 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1538 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-96663f2c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1539 | try | FLAG | p_division_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f0570f03 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1540 | try | FLAG | p_site_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d9943ae0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1541 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9b728a14 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1542 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f977b323 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1543 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9859a5e9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1544 | try | FLAG | p_plan_id | txtPlanID.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8254340e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1545 | try | FLAG | p_flag | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FLAG)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-550d1717 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1546 | try | FLAG | p_insert_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSERT_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-76893609 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1547 | try | FLAG | p_release_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.RELEASE_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-078f7e04 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1548 | try | FLAG | p_is_enable_rel | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f683dc2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1549 | try | FLAG | p_confirm_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4899f7a0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1550 | try | FLAG | p_confirm_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7008be4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1551 | try | FLAG | p_description | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec716e89 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1552 | try | FLAG | p_isenable | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISENABLE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fc7235a4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1553 | try | FLAG | p_ischk | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISCHK)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-97369f70 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1554 | try | FLAG | p_next_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-dd5b5dcb | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1555 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a49f0ef6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1559 | try | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-565b8763 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1559 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0dd7faba | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1566 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count>0) | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c066488 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1569 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count>0) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-79727e5c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1569 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count>0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc52ba6d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1573 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count>0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e47a29c2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1576 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count>0) ▸ if (dtResult.Rows.Count > 0) | FLAG | p_plan_type | dtResult.Rows[0]["PLAN_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f06596e7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1578 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count>0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-76c372c2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1582 | try ▸ if (dtPlanID != null) ▸ else of (dtPlanID.Rows.Count>0) | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e4a263a7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1588 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-9884d848 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1589 | try | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e9533581 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1591 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a42e5522 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1592 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e83cf13c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1593 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-450d9553 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1594 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a1d6450 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1596 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-eaf85749 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1597 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fe3e496 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1598 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-7569f745 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1599 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa9e15bf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1600 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-f0b90ef6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1601 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b1142c87 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1602 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cb0672e6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1603 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-40ae9935 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1604 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-cfdc4281 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1605 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-711ad9ab | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1606 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0d17601 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1607 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-ca9f8839 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1608 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-df45f100 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1609 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-c58526d0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1610 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-b31e06c1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1611 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f4f2d42 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1612 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bcaa77fe | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1613 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-215ec692 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1614 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-5991fac4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1616 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d1291fa9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1617 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-76daf8f6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1624 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-1eb0c99f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1625 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_Release_Queue

진입점: this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2a8bfdb | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1073 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-bfdc3c50 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1074 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-49f6c50f | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1076 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-bd39e076 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1077 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-329609d0 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1078 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-11e86b45 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1079 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4c06bc6 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1081 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-14af0f81 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1082 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e51c5af3 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1083 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-6bed51d3 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1084 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1c387da | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1085 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-da0f010f | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1086 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4a2c2c5 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1087 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8e969ccb | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1088 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-14dcb44a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1089 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-1c3508df | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1090 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-9b4cdc59 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1091 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e5f580f | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1092 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-ebe30c35 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1093 | try | DATA_OP | req.Parameters["p_description"] | p_description.Replace("'", "''") | 행/컬럼 값 대입 |  |  |  |
| AC-79c8cfd6 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1094 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-6ceba6fe | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1095 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-e788bd6a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1096 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-5256cdc1 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1097 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-de9edd5d | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1098 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-616ca667 | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1099 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-2d3e22ad | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1101 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11eed67a | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1102 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-60e416fe | this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QU… | FP00590_ReleaseTotalPopup.cs:1110 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_RollBack_Release

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if (dsReleaseValid_1 != null) ▸ if (dsReleaseValid_1.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80594867 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1802 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-477dc9c6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1803 | try | FLAG | p_sys_flag | pSysFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-aa4a8a42 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1804 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d84a1522 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1805 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-dff5803b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1806 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-45b620cc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1807 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-7559104a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1808 | try | FLAG | p_factory_id | sFactory_LT | 화면 필드/플래그 변경 |  |  |  |
| AC-29a2903b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1809 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-731e0105 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1810 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-b46bb2ce | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1811 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-ba96ee90 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1812 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c202bf51 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1813 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-72379b0e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1814 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0a2c74df | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1815 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6c949d7a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1816 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-eb46758b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1817 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8c18bfca | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1818 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c1552452 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1819 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a541b497 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1820 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7601c48d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1821 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-79e0efef | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1822 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dd3ff0a4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1823 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f0d969c3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1827 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-7a2a755f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1828 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-956c79e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1830 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3d601179 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1831 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ef1d51e8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1832 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5d2db2ff | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1833 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-30fca1ea | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1835 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-69f0c79e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1836 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b75e7bb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1837 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-273231aa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1838 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-511db330 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1839 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-ed972e00 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1840 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-70d7dee9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1841 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a7f6e24e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1842 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-529b910c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1843 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-f99d92f8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1844 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-7ffb44df | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1845 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ff4126e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1846 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-747ae5d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1847 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-238bced7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1848 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-9e8c9ed6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1849 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-a76acbf5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1850 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-92d9c028 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1851 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-eabb22cf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1852 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-6ebc5ea0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1853 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-def024a8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1855 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-852fc656 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1856 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-97b201d1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1863 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_Send_Mail_Quantity_Check

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf6c4045 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1640 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-a80017a7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1641 | try | FLAG | p_sys_flag | "EXECUTE_SENDMAIL_QUANTITY_CHECK" | 화면 필드/플래그 변경 |  |  |  |
| AC-5d582cd1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1642 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-713837f4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1643 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-77b84df7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1644 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e012d96d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1645 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2dec8555 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1646 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a567bec | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1651 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-b14e4359 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1652 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-44e7b863 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1654 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-01dbe71b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1655 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-20798287 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1656 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5c2eb9f2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1657 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-79592e83 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1659 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97d2bffe | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1660 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c95a929a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1661 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6af7f65 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1662 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-341b34b9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1663 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-1a32d0e7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1664 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42909c15 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1665 | try | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0460065b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1666 | try | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99fa2791 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1667 | try | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e8006cd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1668 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99cd4e3b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1669 | try | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb28bc97 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1670 | try | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c6201af | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1671 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d0a5d33e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1672 | try | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb358f9c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1673 | try | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-108cb5e3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1674 | try | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-831d1d58 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1675 | try | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb87b925 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1676 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36be4105 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1677 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-644430b0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1679 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84179809 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1680 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b7c3d1a2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1687 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-565ac4bf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1688 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_Send_SMS

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e490acbd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2501 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-bdd447f5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2508 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5b713a4b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2508 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a02e798f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2510 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-f625e0ff | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2511 | try | FLAG | p_sys_flag | "EXECUTE_SMS" | 화면 필드/플래그 변경 |  |  |  |
| AC-5b534ca1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2512 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-22df737d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2513 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-ef7f50b1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2529 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-36a463c5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2530 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e102e8bd | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2532 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e7d24f04 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2533 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ff800f09 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2534 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f2419262 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2535 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7294fb14 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2537 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01ebe2b3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2538 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ca50157 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2539 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | sFacoty | 행/컬럼 값 대입 |  |  |  |
| AC-4d3bf92a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2540 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-827a6a49 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2541 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ba21a3c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2542 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-ef92b1bc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2543 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2aee96db | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2544 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e01c9110 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2545 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2000345 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2546 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-757ab9b6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2547 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a320bc57 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2548 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6346bced | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2549 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9442d165 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2550 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8aec8bc0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2551 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dde7824b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2552 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57f57632 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2553 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a2e07a1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2554 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad331ef0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2555 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b2d3e70b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2557 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-833f305c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2563 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-74bd3540 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2568 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Exec_SendMail_FinalTotal

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea75d895 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2350 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-b44f35e6 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2351 | try | FLAG | p_sys_flag | "EXECUTE_RELEASE_PLAN_SEND" | 화면 필드/플래그 변경 |  |  |  |
| AC-64ff4f8e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2352 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ed2911e9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2353 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-890b35a7 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2372 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-5c35863d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2373 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c1b99a6a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2375 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1e6d90d9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2376 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b1b28af0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2377 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-b05a7242 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2378 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-db7cfd19 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2380 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d6d6efc2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2381 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0286ba53 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2382 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_factory_id"] | sFacoty | 행/컬럼 값 대입 |  |  |  |
| AC-a2e45b91 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2383 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-bf6f45e4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2384 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-cd48b1fc | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2385 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8daecbf | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2386 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d00eeb0 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2387 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56f6b9f2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2388 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c7022ae | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2389 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5648da75 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2390 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45640608 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2391 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e757a943 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2392 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_description"] | sDescription | 행/컬럼 값 대입 |  |  |  |
| AC-bd5eb809 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2393 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c4a67435 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2394 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7650466a | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2395 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fd2305b3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2396 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d6709f3 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2397 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfba7b52 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2398 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-be87ad50 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2400 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c941ef16 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2406 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-2b1f6b09 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:2411 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Execute_Calcuration

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79224316 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1382 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-37ad8c14 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1383 | try | FLAG | p_sys_flag | "EXECUTE_CALCURATION" | 화면 필드/플래그 변경 |  |  |  |
| AC-801951d1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1384 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d0add6ac | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1385 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-1d805b28 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1386 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ecc5cbc2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1387 | try | FLAG | p_site_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2e112964 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1388 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-62d85d80 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1389 | try | FLAG | p_instance_id | pPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-45d1ebf4 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1390 | try | FLAG | p_plan_date | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2dcb4397 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1391 | try | FLAG | p_plan_id | pPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-227857aa | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1392 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ac3daa01 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1393 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fe86ce9d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1394 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d53a2541 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1395 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4a81298b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1396 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-adb3181f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1397 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-385072ec | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1398 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3060434d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1399 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-06be3674 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1400 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-31179961 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1401 | try | FLAG | p_next_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-e896351e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1402 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3e200151 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1403 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-30e73189 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1408 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-2efd2398 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1409 | try | UI_PROP | req.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-de2166d2 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1411 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-efb96865 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1412 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ef368283 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1413 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-1ac66d40 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1414 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-531b7170 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1416 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-223b715c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1417 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3ce0591 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1418 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a704665 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1419 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9eb25c9e | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1420 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-c59f7e5c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1421 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d814f9b5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1422 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6129934c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1423 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-f9f8993b | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1424 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-253142de | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1425 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-1148b7c5 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1426 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a720d63 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1427 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-0f833ae8 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1428 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-c14690ca | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1429 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-7730dc5d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1430 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-e779da8f | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1431 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-49a55db9 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1432 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c242849d | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1433 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-55b630ee | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1434 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-850132b1 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1436 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24d4bccb | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1437 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-65997720 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1443 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-34851b98 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1444 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Find_Confirm_Valid

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ if (programID == "CONFIRM_VALIDATION_1")] / this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d6d9f4c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2267 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fda9471 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2272 | try ▸ if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c50bd22 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2285 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-65f6aefd | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2297 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7d072893 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2301 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-3cc8df0c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2302 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-8259d182 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2303 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-95ea512e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2304 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7098885c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2305 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a088ffe2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2307 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bf6a2f4f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2308 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-f7b799fc | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2309 | try | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-ee269c38 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2310 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-a9c892a0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2311 | try | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-0e02463a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2312 | try | DATA_OP | request.Parameters["p_plan_id"] | _sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-923c65c0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2313 | try | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4f3d904b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2314 | try | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e4d6764 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2315 | try | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dbcf28d7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2316 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e441348 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2317 | try | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e65f5e77 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2318 | try | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-52952cc0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2319 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0c5da4d8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2320 | try | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2e8d4706 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2321 | try | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4127d866 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2322 | try | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-788e99fe | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2323 | try | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dd9269b2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2324 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-200f203f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2325 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-af54bda5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2327 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-818daf8c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2329 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-837c998d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2334 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Find_Data_Sub

진입점: this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_RELEASE_TOTAL")] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb35864a | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:476 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-af94c982 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:477 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-6ff17fd3 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:478 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_RELEASE_TOTAL" | 행/컬럼 값 대입 |  |  |  |
| AC-5f38b6a8 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:479 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-80fdc43a | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:480 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-84ffff7b | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:482 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-138344bf | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:483 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-059cec31 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:484 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d8eeb24a | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:485 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-0d89c1d8 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:486 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-aa634014 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:487 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-89fcd3c6 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:488 | try | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-226f9665 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:489 | try | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-150e0c7b | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:490 | try | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6d3a50da | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:491 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-23166b85 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:492 | try | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-63a8418b | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:493 | try | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-df51abf8 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:494 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e27157cf | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:495 | try | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf85f54a | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:496 | try | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-14afda5f | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:497 | try | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-24868f2c | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:498 | try | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-50786c55 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:499 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d74d29de | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:500 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-3c678cbe | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:502 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed63d665 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:504 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6a950813 | this.Load [try ▸ lambda] 외 3 | FP00590_ReleaseTotalPopup.cs:509 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Find_Duplicate_Check

진입점: this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01555910 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1356 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_dupReleaseCheck", pInstanceId, pFactoryId) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd8ce917 | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1363 | if (dtDuplication.Rows.Count > 0) | MESSAGE | MessageBox.Show | (sMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-8445593c | this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA… | FP00590_ReleaseTotalPopup.cs:1369 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Find_Release_Plan_List_2

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_VALIDATION_1") ▸ else of (programID == "RELEASE_VALIDATION_2") ▸ else of (programID == "UPDATE_RELEASE_FLAG") ▸ if (programID == "UPDATE_RELEASE_PLANLIST_2") ▸ try] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0][…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c4e7df7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2078 | try ▸ if (iCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList2", _sSite, _sPlanGroup, _sPlanDate, _sPlanI… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d0d6717 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2085 | try ▸ if (iCount > 0) | RETURN | return dtReleasePlanList2; |  | 처리 중단/반환 |  |  |  |
| AC-5010a862 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2089 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-35ab2b7d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2094 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Find_Release_Valid

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ if (programID == "RELEASE_VALIDATION_1")] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5263990b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1701 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-355079a3 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1706 | try ▸ if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-84b6651f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1738 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-0ed8ff37 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1739 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-947f17ec | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1740 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-64cf8788 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1741 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1cb5e950 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1742 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-515b1316 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1744 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-832e1d69 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1745 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e86cc63f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1746 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-638be547 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1747 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-668c8200 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1748 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-be0902e4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1749 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_id"] | sPlanID_LT | 행/컬럼 값 대입 |  |  |  |
| AC-224a43d5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1750 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-53224a1b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1751 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b15672da | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1752 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-23ce7d14 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1753 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-605d56a9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1754 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a031f89b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1755 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-98cb81b5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1756 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-81cc25ee | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1757 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ec2e0fed | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1758 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1911d0e9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1759 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fe7241b1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1760 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-815b52b6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1761 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1487aebc | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1762 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-fa78c5fb | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1764 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a85fd97 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1766 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ea31bb51 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1771 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c6061b56 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1776 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.FindData_Sub

진입점: this.Load / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y")] / this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e8c3e93 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:393 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1ca8088e | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:399 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-362da0f3 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:399 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b39723d | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:404 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2820affd | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:407 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c17bcab | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:413 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d5dd1c81 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:415 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Sub("SELECT", pSite, pPlanGroup, pPlanDate, pPlanID) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e81b7d61 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:423 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-18f436fc | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:428 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c250693 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:437 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3ea60d09 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:440 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9382c69c | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:447 | try ▸ if (ds != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-65121678 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:451 | try ▸ if (ds != null) ▸ for (i< row_count) | GRID_SET | siMain.ActiveSheet.Rows[i].Height | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-c42b7bc4 | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:460 | catch () | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-684d7bda | this.Load 외 2 | FP00590_ReleaseTotalPopup.cs:464 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_ReleaseTotalPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6d9b576 | this.Load | FP00590_ReleaseTotalPopup.cs:165 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-630e65b5 | this.Load | FP00590_ReleaseTotalPopup.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-83c96c60 | this.Load | FP00590_ReleaseTotalPopup.cs:180 | if (string.IsNullOrEmpty(_sPlanGroup)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Parameter: Plan Group(Instance) is Null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-deecc966 | this.Load | FP00590_ReleaseTotalPopup.cs:181 | if (string.IsNullOrEmpty(_sPlanGroup)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1ed7122 | this.Load | FP00590_ReleaseTotalPopup.cs:185 | if (string.IsNullOrEmpty(_sPlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Parameter: Plan Date is Null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c5210f1 | this.Load | FP00590_ReleaseTotalPopup.cs:186 | if (string.IsNullOrEmpty(_sPlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ff99d49 | this.Load | FP00590_ReleaseTotalPopup.cs:190 | if (string.IsNullOrEmpty(_sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Parameter: Plan ID is Null" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46bc0371 | this.Load | FP00590_ReleaseTotalPopup.cs:191 | if (string.IsNullOrEmpty(_sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.FP00590_ReleaseTotalPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10deeaf1 | this.FormClosing | FP00590_ReleaseTotalPopup.cs:3222 | if (blnReleaseRun == true) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FP00590_ReleaseTotalPopup.Get_FactoryDescription

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_VALIDATION_1") ▸ else of (programID == "RELEASE_VALIDATION_2") ▸ else of (programID == "UPDATE_RELEASE_FLAG") ▸ if (programID == "UPDATE_RELEASE_PLANLIST_2") ▸ try ▸ if (dtReleasePlanList2.Rows.Count > 0) ▸ for (i < dtRel…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77ccb425 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3645 |  | RETURN | return sRtnValue; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3d32b30 | this.Load | FP00590_ReleaseTotalPopup.cs:220 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a09acff1 | this.Load | FP00590_ReleaseTotalPopup.cs:226 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-47969bb2 | this.Load | FP00590_ReleaseTotalPopup.cs:227 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-bcf53d60 | this.Load | FP00590_ReleaseTotalPopup.cs:232 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-53f2defb | this.Load | FP00590_ReleaseTotalPopup.cs:234 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-89fcded3 | this.Load | FP00590_ReleaseTotalPopup.cs:237 | try | VALUE_SET | txtPlanID.Text | _sPlanID | 컨트롤 값 설정 |  |  |  |
| AC-9d45b791 | this.Load | FP00590_ReleaseTotalPopup.cs:238 | try | VALUE_SET | txtPlanGroup.Text | _sPlanGroup | 컨트롤 값 설정 |  |  |  |
| AC-23bc2a32 | this.Load | FP00590_ReleaseTotalPopup.cs:239 | try | VALUE_SET | txtDescription.Text | _sDescription | 컨트롤 값 설정 |  |  |  |
| AC-0b0bd28a | this.Load | FP00590_ReleaseTotalPopup.cs:242 | try | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_instanceInfo", _sPlan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-33c346d5 | this.Load | FP00590_ReleaseTotalPopup.cs:242 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_instanceInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bfc65b4 | this.Load | FP00590_ReleaseTotalPopup.cs:246 | try ▸ if (dtInstance.Rows.Count > 0) | FLAG | _sWoWStatus | dtInstance.Rows[0]["USE_WOW_STATUS"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bc352227 | this.Load | FP00590_ReleaseTotalPopup.cs:252 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-41133110 | this.Load | FP00590_ReleaseTotalPopup.cs:253 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a73067bd | this.Load | FP00590_ReleaseTotalPopup.cs:254 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5522002c | this.Load | FP00590_ReleaseTotalPopup.cs:260 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_ReleaseTotalPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f288ae0 | this.Load | FP00590_ReleaseTotalPopup.cs:286 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ce2a792 | this.Load | FP00590_ReleaseTotalPopup.cs:287 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_ReleaseTotalPopup.Insert_Hist_Detail

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_VALIDATION_1") ▸ else of (programID == "RELEASE_VALIDATION_2") ▸ else of (programID == "UPDATE_RELEASE_FLAG") ▸ else of (programID == "UPDATE_RELEASE_PLANLIST_2") ▸ if (programID == "INSERT_HIST_DETAIL")] / this.btnSave.C…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a972d926 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2436 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-eecc92e3 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2440 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-76796e98 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2441 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-d016d15c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2442 | try | DATA_OP | request.Parameters["p_sys_flag"] | "INSERT_HIST_DETAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-72cf0db1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2443 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3515783 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2444 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2a69571d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2446 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ecfc97b4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2447 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-d16019f4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2448 | try | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-27f6d7aa | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2449 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-5a909da7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2450 | try | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-bcd1db21 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2451 | try | DATA_OP | request.Parameters["p_plan_id"] | _sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-bfe2b810 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2452 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ea769df | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2453 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-efb88104 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2454 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d411d996 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2455 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cd698a54 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2456 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a5225bf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2457 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-587a6afb | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2458 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d4c8284b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2459 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8588ff57 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2460 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7722a1f3 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2461 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-77ca69d3 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2462 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ff7106b8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2463 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d098dd87 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2464 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e92f278a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2466 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0cab103e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2468 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3431ce59 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2473 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Insert_Is_Running_Release

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ if (programID == "INSERT_RUNNING_RELEASE") ▸ if (bCheck == true)] / this.btnSave.Click [try ▸ switch (sType) case "INSERT":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-410a084d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2149 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-0da654cf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2150 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-26b487a7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2152 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6a261272 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2153 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-15b89fc8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2154 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-184dd59d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2155 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-334080b6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2157 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fb55a84 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2158 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e40e1f7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2159 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-13dd350e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2160 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-893bf844 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2161 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-945be0ca | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2162 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7d852d6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2163 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5bdb4c46 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2164 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-7b769a1f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2165 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-f7a98a2f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2166 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-bc79e68a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2167 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-f24fdfb9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2168 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-e5a985e1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2169 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-0f8d444b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2170 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-692db9ad | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2171 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-68c0eae4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2172 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-af4db0f9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2173 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8d6f803e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2174 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4b4ed82c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2175 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-d331d953 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2177 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a894c49b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2178 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e7f50de2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2184 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Insert_OT_NET_JOB

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_VALIDATION_1") ▸ else of (programID == "RELEASE_VALIDATION_2") ▸ else of (programID == "UPDATE_RELEASE_FLAG") ▸ else of (programID == "UPDATE_RELEASE_PLANLIST_2") ▸ else of (programID == "INSERT_HIST_DETAIL") ▸ if (progra…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5814fd5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2681 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5b5f1f69 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2681 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75d26c6f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2683 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-dd404661 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2684 | try | FLAG | p_sys_flag | "INSERT_OT_NET_JOB" | 화면 필드/플래그 변경 |  |  |  |
| AC-b0c7782f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2685 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9ebf8d60 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2686 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-807b713a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2702 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-2d3e7674 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2703 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9501a032 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2705 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3c58ecff | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2706 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-085f4f7b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2707 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a9befd61 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2708 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-884be12e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2710 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28f05bc7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2711 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3f71dc4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2712 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f413db32 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2713 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-86842ea8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2714 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-32a66fc6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2715 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-c2bc12a9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2716 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3b6d9c7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2717 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6b78c36 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2718 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a184ced5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2719 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70050aa0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2720 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f2029e1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2721 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe305abb | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2722 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0eeb1549 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2723 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2c411e1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2724 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9fa06451 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2725 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-defba19b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2726 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e42f4ab6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2727 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e8a2844 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2728 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-51eee38e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2730 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-26abe773 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2736 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ace51219 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2741 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e52bf7b6 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3668 | if (programID == "SELECT_RELEASE_TOTAL") | RETURN | return Find_Data_Sub("SQL", pSiteID, pPlanGroup, pPlanDate, pPlanID); |  | 처리 중단/반환 |  |  |  |
| AC-657f9b05 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3673 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ if (programID == "CONFIRM_VALIDATION_1") | RETURN | return Find_Confirm_Valid("SQL", "CONFIRM_VALIDATION_1"); |  | 처리 중단/반환 |  |  |  |
| AC-eba5a765 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3678 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ if (programID == "CONFIRM_VALIDATION_2") | RETURN | return Find_Confirm_Valid("SQL", "CONFIRM_VALIDATION_2"); |  | 처리 중단/반환 |  |  |  |
| AC-548d089f | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3684 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-679b113a | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3684 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e069a45 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3696 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Exec_Release_Plan(i, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e9432f5f | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3706 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Update_DivisionList(i, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7a675b91 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3722 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Insert_Is_Running_Release("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-16cea1c9 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3737 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Delete_Is_Running_Release("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7c19a5e7 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3741 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Find_Release_Valid("SQL", "RELEASE_VALIDATION_1"); |  | 처리 중단/반환 |  |  |  |
| AC-474e98ec | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3745 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Find_Release_Valid("SQL", "RELEASE_VALIDATION_2"); |  | 처리 중단/반환 |  |  |  |
| AC-a64ec7b7 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3749 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Update_Release_Flag("UPDATE_RELEASE_FLAG", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-25fc8586 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3753 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Update_Release_PlanList_2("UPDATE_RELEASE_PLANLIST_2", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-115bc552 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3757 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Insert_Hist_Detail("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-2a711368 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3771 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Insert_OT_NET_JOB("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-c1a50aaf | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3794 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8105d722 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3795 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_PLAN_RESULT_SEND " + "'" + pPlanGroup + "', " + "'" + pPlanDate + "', " + "'… | 데이터 객체 조작/조회 |  |  |  |
| AC-2b90ac53 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3796 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a30ca023 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3798 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c3212204 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3822 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b497deae | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3823 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_CONFIRM_SMS_SEND " + "'" + pPlanGroup +"', " + "'" + pPlanID + "', " + "'" +… | 데이터 객체 조작/조회 |  |  |  |
| AC-34f62515 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3824 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-2933a556 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3826 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3c38a44b | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3836 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3e02ff1 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3837 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_XIF_MES_ERP_WO_MASTER " + "'" + pPlanID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1354a35b | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3838 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-94883ab1 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3840 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e53cf8b8 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3849 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-94bbc60b | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3850 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_ASSY_ELEC_REPORT " + "'" + pPlanGroup + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-857687db | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3851 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1c0fa75 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3853 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-13aba707 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3862 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-918dd5dc | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3863 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_PACK_REQUIRE_CEL " + "'" + pPlanGroup + "', " + "'', " + "'Y', " + "'', '… | 데이터 객체 조작/조회 |  |  |  |
| AC-183bb9f4 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3864 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9a34797 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3866 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-33e9db55 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3875 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9f9d00e | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3876 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_CELL_DELIVERY_PLAN " + "'" + pPlanGroup + "', " + "'', " + "'Y', " + "'',… | 데이터 객체 조작/조회 |  |  |  |
| AC-fb197eba | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3877 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0447022 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3879 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-9107f379 | popSql.OnSql | FP00590_ReleaseTotalPopup.cs:3881 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Save_Release

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8f5c1e2 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:522 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-737541a0 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:526 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce6568ef | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:530 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f7f33e33 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:539 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_RELEASE_LIMIT_YN == "Y") | MESSAGE | MessageHelper.GMessageBox | ("Unable to release. Contact GSCM.FP PI representative for details.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10d91424 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:540 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_RELEASE_LIMIT_YN == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1e86394 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:548 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df6a5469 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:549 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-673fee49 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:573 | try ▸ if (iChkCount == 0) | MESSAGE | MessageBox.Show | ("Please select check plan group or factory before proceed") | 메시지 표시 |  |  |  |
| AC-c1e93c25 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:574 | try ▸ if (iChkCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-295f630a | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:580 | try ▸ if (bExistComplete == false) | MESSAGE | MessageBox.Show | ("Already exisit Confirm Plan ID. Will you proceed?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-737db620 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:582 | try ▸ if (bExistComplete == false) ▸ if (MessageBox.Show("Already exisit Confirm Plan ID. Will you proceed?", "Confrim", MessageBoxButtons.Y… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35344fb0 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:591 | try ▸ else of (bExistComplete == false) | MESSAGE | MessageBox.Show | ("Will you Confirm proceed?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-3f3e0b9a | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:593 | try ▸ else of (bExistComplete == false) ▸ if (MessageBox.Show("Will you Confirm proceed?", "Confrim", MessageBoxButtons.YesNo) == DialogResu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22b8343d | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:601 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") | FLAG | dtIsRunReleaseBySite | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_is_running_release_by… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-00d0ec8b | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:601 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release_bySite", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-48e7d07e | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:610 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") ▸ if (dtIsRunReleaseBySite != null) ▸ if (dtIsRunReleaseBySite.Rows.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afda67b5 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:611 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") ▸ if (dtIsRunReleaseBySite != null) ▸ if (dtIsRunReleaseBySite.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3f192bb | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:616 | try ▸ if (Check_Exec_IsRunningEngine("SELECT_INIT") == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8088809f | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:622 | try ▸ if (Check_isConfirmed() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fad982c | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:628 | try ▸ if (Check_ConfirmValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-edbcf950 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:631 | try ▸ if (Check_CapaValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-000a8a46 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:639 | try ▸ if (Check_IsPastDate() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46c3a283 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:640 | try ▸ if (Check_IsPastDate() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83681ebc | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:645 | try ▸ if (Check_Exec_IsRunningEngine("SELECT") == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cae06a5 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:649 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0bff5ef5 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:667 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | ENDPOINT | proxyPivot.ExecuteAsync | (() => Exec_Release_Queue("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8002e14 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:687 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_watingTime",_sPlanGroup, _sSite, sFactory_LT) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b5f3ad2 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:705 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnReleaseRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5c248bac | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:707 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | MESSAGE | MessageBox.Show | (sMsg, "Excute", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-9218448b | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:711 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (MessageBox.Show(sMsg, "Excute", MessageBoxButtons.OK) == DialogR… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-99c0e5f7 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:712 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (MessageBox.Show(sMsg, "Excute", MessageBoxButtons.OK) == DialogR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f48dbf3 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:714 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-76cd7678 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:748 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-10069cf7 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:749 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-33e78f87 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:750 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3795724 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:779 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-dafe5eea | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:782 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | new FP00590_ValidationPopup | ("ReleaseValid1Popup", dsReleaseValid_1, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-e8939646 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:783 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_PROP | popReleaseValid1.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c74f6fc9 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:784 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | popReleaseValid1.Show | () | 팝업/폼 열기 |  |  |  |
| AC-76b0e509 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:790 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e57a6ba | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:797 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2c99ae89 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:798 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5c9afc3d | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:799 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4879e901 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:823 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0193030f | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:826 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | new FP00590_ValidationPopup | ("ReleaseValid2Popup", dsReleaseValid_2, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-0838b158 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:827 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_PROP | popReleaseValid2.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-65d08e51 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:828 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | POPUP | popReleaseValid2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0a7514c6 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:834 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-26446f09 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:841 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-adcfe2f7 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:842 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-7db03665 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:878 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked) ▸ for (i < dtRelPlanLT.Rows.Count) | DATA_OP | FilterTmp["MASTER_ID"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-7163f4ab | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:879 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked) ▸ for (i < dtRelPlanLT.Rows.Count) | DATA_OP | FilterTmp["PLAN_ID"] | dtRelPlanLT.Rows[i]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d8dc0b0 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:880 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (chk_MRP.Checked) ▸ for (i < dtRelPlanLT.Rows.Count) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00590_RELEASE_P", "update_MRP_Transit", FilterTmp.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=update_MRP_Transit] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9b349967 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:906 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dsSendTotal == null \|\| dsSendTotal.Tables[0].Rows[0][0].T… | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-aa027e88 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:994 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e7080e25 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:996 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnReleaseRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-801c7763 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:999 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { _sPlanID }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4411e219 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1005 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-08b10730 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1006 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-44698c45 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1010 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-81063f5c | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1011 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1678b9a4 | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1015 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8b10bf4f | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1019 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c1fe6a6e | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1020 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1a90b9eb | this.btnSave.Click | FP00590_ReleaseTotalPopup.cs:1022 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_ReleaseTotalPopup.SetCheckRow

진입점: this.Load [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnFind.Click [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25597af0 | this.Load [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Cou… 외 2 | FP00590_ReleaseTotalPopup.cs:3895 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sCheckYn != "Y") | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |

## FP00590_ReleaseTotalPopup.SetCleraVariable

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ if (programID == "EXECUTE_RELEASE") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !string.IsNullOrEmpty(siMain.Ge…)] / this.btnSave.Click [try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3566d34 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3234 |  | FLAG | p_sys_type | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-84641f47 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3235 |  | FLAG | p_sys_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-77d209d1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3236 |  | FLAG | p_sys_gubun | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-78dd3be2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3237 |  | FLAG | p_user_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-92a35b0e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3238 |  | FLAG | p_division_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b27d0355 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3239 |  | FLAG | p_site_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3967c9a9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3240 |  | FLAG | p_factory_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-08fc199c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3241 |  | FLAG | p_instance_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-871786b1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3242 |  | FLAG | p_plan_date | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-58fda715 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3243 |  | FLAG | p_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-05637e4b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3244 |  | FLAG | p_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b09ad773 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3245 |  | FLAG | p_insert_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fc10d975 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3246 |  | FLAG | p_release_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-cedf7651 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3247 |  | FLAG | p_is_enable_rel | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f61fc3b2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3248 |  | FLAG | p_confirm_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f53dd3c3 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3249 |  | FLAG | p_confirm_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-352e09d4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3250 |  | FLAG | p_description | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-92890434 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3251 |  | FLAG | p_isenable | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c5e112ea | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3252 |  | FLAG | p_ischk | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-32b3c0b4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3253 |  | FLAG | p_next_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a5591fa8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:3254 |  | FLAG | p_release_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP00590_ReleaseTotalPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9de1b810 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:298 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-981dc0dd | this.Load [try] | FP00590_ReleaseTotalPopup.cs:299 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-0cba999f | this.Load [try] | FP00590_ReleaseTotalPopup.cs:303 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-dfd90aaa | this.Load [try] | FP00590_ReleaseTotalPopup.cs:304 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9939421d | this.Load [try] | FP00590_ReleaseTotalPopup.cs:306 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-15471249 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:307 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bc59400e | this.Load [try] | FP00590_ReleaseTotalPopup.cs:308 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ca1492f3 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:309 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-11e1dbc4 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:310 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e18ab51e | this.Load [try] | FP00590_ReleaseTotalPopup.cs:311 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-58fc4e6a | this.Load [try] | FP00590_ReleaseTotalPopup.cs:313 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b58954f6 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:314 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSERT_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4c7e852d | this.Load [try] | FP00590_ReleaseTotalPopup.cs:315 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.RELEASE_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dfd9bea5 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:316 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-12bd8745 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:317 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7ea0f409 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:318 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f8879014 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:319 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ISENABLE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c01d5f60 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:320 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ISCHK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-491319be | this.Load [try] | FP00590_ReleaseTotalPopup.cs:330 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-803b05a1 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:331 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-65703a52 | this.Load [try] | FP00590_ReleaseTotalPopup.cs:332 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## FP00590_ReleaseTotalPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d643a7a9 | this.spdMain.CellClick | FP00590_ReleaseTotalPopup.cs:3186 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-defba751 | this.spdMain.CellClick | FP00590_ReleaseTotalPopup.cs:3191 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-99af323e | this.spdMain.CellClick | FP00590_ReleaseTotalPopup.cs:3198 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, bChk) | 그리드 값 설정 |  |  |  |
| AC-c6bd382b | this.spdMain.CellClick | FP00590_ReleaseTotalPopup.cs:3211 |  | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_ReleaseTotalPopup.Update_DivisionList

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ if (programID == "UPDATE_DIVISIONLIST") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !string.IsNullOrEmpty(siMain.Ge…)] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ try ▸ for (k <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c6fba8e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1459 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-33aafe38 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1460 | try | FLAG | p_sys_flag | "UPDATE_DIVISIONLIST" | 화면 필드/플래그 변경 |  |  |  |
| AC-d82b3f70 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1461 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0cc47b48 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1462 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-05354203 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1463 | try | FLAG | p_division_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5e640388 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1464 | try | FLAG | p_site_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f2daf88 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1465 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee643203 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1466 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec29046d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1467 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c13b6c5b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1468 | try | FLAG | p_plan_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e9d96ae | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1469 | try | FLAG | p_flag | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FLAG)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-304029bc | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1470 | try | FLAG | p_insert_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSERT_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe74cf24 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1471 | try | FLAG | p_release_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.RELEASE_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4bf6177 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1472 | try | FLAG | p_is_enable_rel | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5431a84 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1473 | try | FLAG | p_confirm_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3c29b04a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1474 | try | FLAG | p_confirm_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1487a59c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1475 | try | FLAG | p_description | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-08433727 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1476 | try | FLAG | p_isenable | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISENABLE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b3ab1e75 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1477 | try | FLAG | p_ischk | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISCHK)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-648c0ac1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1478 | try | FLAG | p_next_plan_id | txtPlanID.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6ea80909 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1479 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5f316e60 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1480 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-47f8d720 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1484 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-202a4a86 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1485 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9230b70d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1487 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-17b22217 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1488 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-39fd1edb | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1489 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-8b1d5809 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1490 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c399d95 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1492 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c10aeff | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1493 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-55349341 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1494 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-a65e2331 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1495 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-8956b174 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1496 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-356d2931 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1497 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6650176 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1498 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-eb25f22d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1499 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-2b077d4a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1500 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-1d098c80 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1501 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-fe363f93 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1502 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3e499f8b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1503 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-8f904c28 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1504 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-50e7f954 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1505 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-db33c2ee | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1506 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-bc646d88 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1507 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-413de530 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1508 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6c61ffcd | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1509 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-452ba069 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1510 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e3aa0124 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1512 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-196246bf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1513 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-878619de | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1519 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Update_Release_Flag

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_VALIDATION_1") ▸ else of (programID == "RELEASE_VALIDATION_2") ▸ if (programID == "UPDATE_RELEASE_FLAG")] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ else of (dtInsta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b3502d4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1888 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-6c65fced | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1889 | try | FLAG | p_sys_flag | pSysFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-c2a53ebf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1890 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8cbadfe6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1891 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-f49e37be | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1892 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b2e1b079 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1893 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-ba524985 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1894 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-21c3c700 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1895 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-facc1a60 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1896 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-cbef7865 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1897 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-48a146cc | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1898 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-047844b4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1899 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-129a0d27 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1900 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c47209b7 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1901 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f1547f93 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1902 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4ee0680a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1903 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-07969a6a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1904 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f75e732a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1905 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7b163b9f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1906 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7d122598 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1907 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9f3fd571 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1908 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dc045553 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1909 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-23d74c2f | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1913 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-72b69210 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1914 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bf542f7d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1916 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0eeda0cd | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1917 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f61c3211 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1918 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-848f36aa | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1919 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c996ea12 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1921 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d87aa00 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1922 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5af7a2b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1923 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d896031 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1924 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-283e5329 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1925 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-d0a117c1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1926 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d157eaf4 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1927 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fdda6cf5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1928 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-5bcf509e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1929 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-45f774a6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1930 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-445fb96a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1931 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-18973207 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1932 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-51c2d4c1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1933 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-7fdbbb77 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1934 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-95664b9d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1935 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-8c044bbf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1936 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2335d3ff | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1937 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-36bf6da9 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1938 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cdef3c18 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1939 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-73ecdced | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1941 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c476425e | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1942 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7e945e61 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:1949 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ReleaseTotalPopup.Update_Release_PlanList_2

진입점: popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2") ▸ else of (programID == "EXECUTE_RELEASE") ▸ else of (programID == "UPDATE_DIVISIONLIST") ▸ else of (programID == "INSERT_RUNNING_RELEASE") ▸ else of (programID == "DELETE_RUNNING_RELEASE") ▸ else of (programID == "RELEASE_VALIDATION_1") ▸ else of (programID == "RELEASE_VALIDATION_2") ▸ else of (programID == "UPDATE_RELEASE_FLAG") ▸ if (programID == "UPDATE_RELEASE_PLANLIST_2")] / this.btnSave.Click [try ▸ else of (dtInstance.Rows[0]["RELEA…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bfb85d1 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2008 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-0924da8a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2009 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4192673d | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2011 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-dcff202c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2012 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6e103f50 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2013 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-22a7bdc6 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2014 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3851385c | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2016 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-48a3a572 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2017 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f395207 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2018 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6d685ea | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2019 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b24115d3 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2020 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-7b45c1ce | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2021 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-102b3389 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2022 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a9aabfc0 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2023 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-b3cf9c48 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2024 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-716c5522 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2025 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-396a073a | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2026 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-8598cd76 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2027 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-6a462a75 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2028 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-d47b4557 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2029 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-df18a2a8 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2030 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-00e1c0b2 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2031 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-27a57709 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2032 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8c6b7faf | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2033 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f3c45fa | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2034 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-5d19c3d5 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2036 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-edf57515 | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2037 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d10fd14b | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2042 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a4dcb7be | popSql.OnSql [else of (programID == "SELECT_RELEASE_TOTAL") … 외 1 | FP00590_ReleaseTotalPopup.cs:2047 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_RePlanTotalPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad5b9e03 | .ctor | FP00590_RePlanTotalPopup.cs:160 |  | FLAG | _sSite | sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-72000288 | .ctor | FP00590_RePlanTotalPopup.cs:161 |  | FLAG | _sPlanGroup | sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-50d9839e | .ctor | FP00590_RePlanTotalPopup.cs:162 |  | FLAG | _sPlanDate | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-60e22718 | .ctor | FP00590_RePlanTotalPopup.cs:163 |  | FLAG | _sPlanID | sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-172e5655 | .ctor | FP00590_RePlanTotalPopup.cs:164 |  | FLAG | _sPlanType | sPlanType | 화면 필드/플래그 변경 |  |  |  |
| AC-3a9da581 | .ctor | FP00590_RePlanTotalPopup.cs:165 |  | FLAG | _sComfirmArea | sComfirmArea | 화면 필드/플래그 변경 |  |  |  |
| AC-62a47603 | .ctor | FP00590_RePlanTotalPopup.cs:166 |  | FLAG | _sIsSamePlanID | sIsSamePlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-4a07c55b | .ctor | FP00590_RePlanTotalPopup.cs:167 |  | FLAG | _sUseWoWStatus | sUseWoWStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-17ef9b77 | .ctor | FP00590_RePlanTotalPopup.cs:168 |  | FLAG | _sAmendType | sAmendType | 화면 필드/플래그 변경 |  |  |  |
| AC-bbb1c901 | .ctor | FP00590_RePlanTotalPopup.cs:179 |  | FLAG | _sSite | sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-fcab8dbb | .ctor | FP00590_RePlanTotalPopup.cs:180 |  | FLAG | _sPlanGroup | sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-6e0f22fe | .ctor | FP00590_RePlanTotalPopup.cs:181 |  | FLAG | _sPlanDate | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-345a7524 | .ctor | FP00590_RePlanTotalPopup.cs:182 |  | FLAG | _sPlanID | sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-7cdb0935 | .ctor | FP00590_RePlanTotalPopup.cs:183 |  | FLAG | dtLocalPlanGroup | _dtParam.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-560c19ec | .ctor | FP00590_RePlanTotalPopup.cs:183 |  | DATA_OP | _dtParam.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-83947fa0 | .ctor | FP00590_RePlanTotalPopup.cs:187 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.SITE_ID | _sSite | 속성 SITE_ID 설정 |  |  |  |
| AC-9ed0926a | .ctor | FP00590_RePlanTotalPopup.cs:188 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.INSTANCE_ID | dtLocalPlanGroup.Rows[0]["CODE"].ToString() | 속성 INSTANCE_ID 설정 |  |  |  |
| AC-bdb8cda5 | .ctor | FP00590_RePlanTotalPopup.cs:189 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.INSTANCE_NAME | dtLocalPlanGroup.Rows[0]["NAME"].ToString() | 속성 INSTANCE_NAME 설정 |  |  |  |
| AC-a099490a | .ctor | FP00590_RePlanTotalPopup.cs:190 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_DATE | _sPlanDate | 속성 PLAN_DATE 설정 |  |  |  |
| AC-9e51298d | .ctor | FP00590_RePlanTotalPopup.cs:191 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_ID | _sPlanID | 속성 PLAN_ID 설정 |  |  |  |
| AC-f719ae67 | .ctor | FP00590_RePlanTotalPopup.cs:192 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.CONFIRM_AREA | dtLocalPlanGroup.Rows[0]["CONFIRM_AREA"].ToString() | 속성 CONFIRM_AREA 설정 |  |  |  |
| AC-4cb20367 | .ctor | FP00590_RePlanTotalPopup.cs:193 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.IS_SAME_PLAN_ID | dtLocalPlanGroup.Rows[0]["IS_SAME_PLAN_ID"].ToString() | 속성 IS_SAME_PLAN_ID 설정 |  |  |  |
| AC-54bbe1db | .ctor | FP00590_RePlanTotalPopup.cs:194 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.USE_WOW_STATUS | dtLocalPlanGroup.Rows[0]["USE_WOW_STATUS"].ToString() | 속성 USE_WOW_STATUS 설정 |  |  |  |
| AC-4ed3cf8c | .ctor | FP00590_RePlanTotalPopup.cs:195 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.AMEND_TYPE | dtLocalPlanGroup.Rows[0]["AMEND_TYPE"].ToString() | 속성 AMEND_TYPE 설정 |  |  |  |
| AC-3d5297f5 | .ctor | FP00590_RePlanTotalPopup.cs:196 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.FIX_DATE_SYNC | dtLocalPlanGroup.Rows[0]["FIX_DATE_SYNC"].ToString() | 속성 FIX_DATE_SYNC 설정 |  |  |  |
| AC-47425bf5 | .ctor | FP00590_RePlanTotalPopup.cs:197 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.SYNC_YN | dtLocalPlanGroup.Rows[0]["SYNC_YN"].ToString() | 속성 SYNC_YN 설정 |  |  |  |
| AC-0f2ec95f | .ctor | FP00590_RePlanTotalPopup.cs:198 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_TARGET_ID | "" | 속성 PRE_FIX_TARGET_ID 설정 |  |  |  |
| AC-f3282a7a | .ctor | FP00590_RePlanTotalPopup.cs:199 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_FLAG | "N" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-5963c7cf | .ctor | FP00590_RePlanTotalPopup.cs:200 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_TYPE | "" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-fa42edec | .ctor | FP00590_RePlanTotalPopup.cs:201 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_DATE | "" | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-c0b489dc | .ctor | FP00590_RePlanTotalPopup.cs:202 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_TYPE | dtLocalPlanGroup.Rows[0]["PLAN_TYPE"].ToString() | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-b8bb66e0 | .ctor | FP00590_RePlanTotalPopup.cs:203 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_END_TIME | "" | 속성 PLAN_END_TIME 설정 |  |  |  |
| AC-c90baf89 | .ctor | FP00590_RePlanTotalPopup.cs:204 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PLAN_HORIZON | "" | 속성 PLAN_HORIZON 설정 |  |  |  |
| AC-7c8ccf8a | .ctor | FP00590_RePlanTotalPopup.cs:205 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.DEMAND_HORIZON | "" | 속성 DEMAND_HORIZON 설정 |  |  |  |
| AC-68fdd73a | .ctor | FP00590_RePlanTotalPopup.cs:206 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.DESCRIPTION | "" | 속성 DESCRIPTION 설정 |  |  |  |
| AC-aaa238a6 | .ctor | FP00590_RePlanTotalPopup.cs:207 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.BASIS_PLAN_ID | "" | 속성 BASIS_PLAN_ID 설정 |  |  |  |
| AC-e5286fc6 | .ctor | FP00590_RePlanTotalPopup.cs:208 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.SYNC_OPERATION_ID | "" | 속성 SYNC_OPERATION_ID 설정 |  |  |  |
| AC-89d0ccc3 | .ctor | FP00590_RePlanTotalPopup.cs:209 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_DATE2 | "" | 속성 PRE_FIX_DATE2 설정 |  |  |  |
| AC-65529bdd | .ctor | FP00590_RePlanTotalPopup.cs:210 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_TYPE2 | "" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-764eaf64 | .ctor | FP00590_RePlanTotalPopup.cs:211 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.PRE_FIX_2_FLAG | "" | 속성 PRE_FIX_2_FLAG 설정 |  |  |  |
| AC-3b4d6393 | .ctor | FP00590_RePlanTotalPopup.cs:212 | if (dtLocalPlanGroup.Rows.Count > 0) | UI_PROP | DsinData.ALLOWFIXDATENULL | "" | 속성 ALLOWFIXDATENULL 설정 |  |  |  |

## FP00590_RePlanTotalPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dfd72af | this.btnClose.Click | FP00590_RePlanTotalPopup.cs:619 | if (blnCreateRun) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3b837510 | this.btnClose.Click | FP00590_RePlanTotalPopup.cs:623 | else of (blnCreateRun) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_RePlanTotalPopup.btnRun_Click

진입점: this.btnRun.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d4d46d | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:535 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24e863b4 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:536 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59d417c6 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:541 |  | FLAG | dtRunningPlan | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findIsRunningPlan", _sPlan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a51f945a | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:541 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56e71df4 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:553 | if (dtRunningPlan != null) ▸ if (dtRunningPlan.Rows.Count > 0) ▸ if (Convert.ToInt32(sRunningFlag) > 0) | MESSAGE | MessageBox.Show | (sMsg, "Check", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-e25fca24 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:554 | if (dtRunningPlan != null) ▸ if (dtRunningPlan.Rows.Count > 0) ▸ if (Convert.ToInt32(sRunningFlag) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fce6914 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:565 |  | MESSAGE | MessageBox.Show | (" Will you Excute Engine?", "Excute", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-3bb2ec44 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:567 | if (MessageBox.Show(" Will you Excute Engine?", "Excute", MessageBoxButtons.YesNo) == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89370d64 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:574 |  | STATE | lblStatusText.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-85d5a6e0 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:582 | if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds3.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e6d910c | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:585 | if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") | FLAG | blnCreateRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7539d069 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:588 | if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") | VALUE_SET | chkStatus.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-176630b5 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:597 | else of (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00590_RePlanTotalPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81a9dad5 | this.btnSql.Click | FP00590_RePlanTotalPopup.cs:607 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-afd9de1a | this.btnSql.Click | FP00590_RePlanTotalPopup.cs:608 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-85fdacb8 | this.btnSql.Click | FP00590_RePlanTotalPopup.cs:610 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_REPLAN_ENGINE_RUN_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad084e28 | this.btnSql.Click | FP00590_RePlanTotalPopup.cs:611 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_REPLAN_FIX_PLAN_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7306c092 | this.btnSql.Click | FP00590_RePlanTotalPopup.cs:612 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_RePlanTotalPopup.chkStatus_Click

진입점: this.chkStatus.Click / this.btnRun.Click [if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f37123a | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1103 | if (chkStatus.Checked == true) | FLAG | bRun1 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1fbaeee7 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1103 | if (chkStatus.Checked == true) | FLAG | bRun2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fcadd655 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1103 | if (chkStatus.Checked == true) | FLAG | bRun3 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-119e3914 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1103 | if (chkStatus.Checked == true) | FLAG | bRunError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-260c5310 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1105 | if (chkStatus.Checked == true) | FLAG | EngineCheckTimer | new System.Timers.Timer() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b8681f6 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1106 | if (chkStatus.Checked == true) | UI_PROP | EngineCheckTimer.Interval | 5000 | 속성 Interval 설정 |  |  |  |
| AC-563114ac | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1116 | if (chkStatus.Checked == true) ▸ lambda | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b754720c | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1120 | if (chkStatus.Checked == true) | CALL_EXT | EngineCheckTimer.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5958dbaf | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1127 | else of (chkStatus.Checked == true) ▸ if (EngineCheckTimer != null) | CALL_EXT | EngineCheckTimer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5671e01 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1128 | else of (chkStatus.Checked == true) ▸ if (EngineCheckTimer != null) | UI_MISC | EngineCheckTimer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-73fc3e27 | this.chkStatus.Click 외 1 | FP00590_RePlanTotalPopup.cs:1129 | else of (chkStatus.Checked == true) ▸ if (EngineCheckTimer != null) | FLAG | EngineCheckTimer | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_RePlanTotalPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad60d2b9 | this.Load | FP00590_RePlanTotalPopup.cs:479 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-57d26b6e | this.Load | FP00590_RePlanTotalPopup.cs:480 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-602a6a3d | this.Load | FP00590_RePlanTotalPopup.cs:481 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_RePlanTotalPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e75d56ce | this.Load | FP00590_RePlanTotalPopup.cs:253 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_RePlanTotalPopup.Dispose

진입점: this.FormClosing / Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f94a07b6 | this.FormClosing 외 1 | FP00590_RePlanTotalPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_RePlanTotalPopup.dtpFixDate2_CloseUp

진입점: this.dtpFixDate2.CloseUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-719f5809 | this.dtpFixDate2.CloseUp | FP00590_RePlanTotalPopup.cs:1091 |  | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Short | 속성 Format 설정 |  |  |  |

## FP00590_RePlanTotalPopup.ExcuteRunValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c34baae | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1050 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_REPLAN_POPUP") ⇒ FP_Planning.PR_UI_FP00590_REPLAN_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-8261f3f2 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1051 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-2f53df7d | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1052 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_VALIDATION" | 행/컬럼 값 대입 |  |  |  |
| AC-013efdc3 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1053 | try | DATA_OP | request.Parameters["p_sys_gubun"] | pProcName | 행/컬럼 값 대입 |  |  |  |
| AC-77e0a411 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1054 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-14f3b74e | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1056 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-7101a530 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1057 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-2e81ce4c | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1058 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-712aa6f6 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1059 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-3990a337 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1060 | try | DATA_OP | request.Parameters["p_active_01_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6555efbb | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1061 | try | DATA_OP | request.Parameters["p_active_01_value"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2afd08cd | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1062 | try | DATA_OP | request.Parameters["p_active_01_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ff9a8726 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1063 | try | DATA_OP | request.Parameters["p_active_02_value"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8dedeb78 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1064 | try | DATA_OP | request.Parameters["p_active_02_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-187dd6da | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1065 | try | DATA_OP | request.Parameters["p_active_03_value"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3cff5d52 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1066 | try | DATA_OP | request.Parameters["p_active_03_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f86df089 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1067 | try | DATA_OP | request.Parameters["p_active_04_value"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fd1c5792 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1068 | try | DATA_OP | request.Parameters["p_active_04_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-af94bcdb | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1069 | try | DATA_OP | request.Parameters["p_active_05_value"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aac01176 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1070 | try | DATA_OP | request.Parameters["p_active_05_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-88761623 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1071 | try | DATA_OP | request.Parameters["p_active_06_value"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d429bdaf | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1072 | try | DATA_OP | request.Parameters["p_active_06_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-081e4e26 | (진입점 미연결) | FP00590_RePlanTotalPopup.cs:1074 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## FP00590_RePlanTotalPopup.Find_Data_Sub

진입점: popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_RUN_SELECT")] / this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambda ▸ try ▸ lambda] / this.btnRun.Click [if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (chkStatus.Checked == true) ▸ lambda ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfa9c3e2 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:767 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_REPLAN_POPUP") ⇒ FP_Planning.PR_UI_FP00590_REPLAN_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-6d29ee37 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:768 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-d97e8719 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:769 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ENGINE_RUN" | 행/컬럼 값 대입 |  |  |  |
| AC-83112500 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:770 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7dfaf04d | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:771 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-079e1452 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:773 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be3746c5 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:774 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-e87e9376 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:775 | try | DATA_OP | request.Parameters["p_plan_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bffa4a38 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:776 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-30e57b2d | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:778 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-97c849d0 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:779 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4c0abef2 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:780 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b65f450 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:781 | try | DATA_OP | request.Parameters["p_amend_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-783d9921 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:784 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8c98a5c | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:786 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6cc84d31 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_ENGINE_… 외 2 | FP00590_RePlanTotalPopup.cs:791 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_RePlanTotalPopup.FindData_Sub

진입점: this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambda] / this.btnRun.Click [if (ds3.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (chkStatus.Checked == true) ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f11c077 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:639 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-44dc1483 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:639 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69cb34a6 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:642 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c18e813e | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:647 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { ds = Find_Data_Sub("SELECT", pPlanGroup, pPlanID); //쿼리결과… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e579e55d | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:651 | try ▸ lambda | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7f69adc6 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:668 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equ… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-5cf27901 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:672 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-4db47f30 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:673 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-9f905387 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:677 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-65241dbf | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:678 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-9b8abf01 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:679 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-27f2b38a | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:683 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-b37a24a0 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:684 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-8300aa2e | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:685 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-914ad868 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:686 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString(… | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP4)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-9f1831bf | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:693 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (i ==0) ▸ if (sFlag.Equals("C")) | FLAG | bRun1 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9c879085 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:695 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (i ==0) ▸ else of (sFlag.Equals("C")) ▸ if (sFlag.E… | FLAG | bRunError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-097a04bc | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:697 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (i ==0) ▸ else of (sFlag.Equals("C")) ▸ else of (sF… | FLAG | bRun1 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6fbfae91 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:703 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ if (i == 1) ▸ if (sFlag.Equals("C")) | FLAG | bRun2 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a385b27 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:705 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ if (i == 1) ▸ else of (sFlag.Equals(… | FLAG | bRunError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a97544f | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:707 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ if (i == 1) ▸ else of (sFlag.Equals(… | FLAG | bRun2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c810dd62 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:713 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ else of (i == 1) ▸ if (i == 2) ▸ if … | FLAG | bRun3 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-72344df1 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:715 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ else of (i == 1) ▸ if (i == 2) ▸ els… | FLAG | bRunError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-decd433b | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:717 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (i ==0) ▸ else of (i == 1) ▸ if (i == 2) ▸ els… | FLAG | bRun3 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ded08032 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:722 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | FLAG | bRunError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a80719a | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:723 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | UI_PROP | lblEngineStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6c904d7c | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:724 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | STATE | lblStatusText.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a010b659 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:725 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (bRunError == true) | MESSAGE | MessageBox.Show | ("FP Engine Run Error Occur!", "Check", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-2f6fb223 | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:732 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | FLAG | blnCreateRun | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8397861c | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:734 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | MESSAGE | MessageBox.Show | ("FP Engine Completed!", "Complete", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-98f2578b | this.chkStatus.Click [if (chkStatus.Checked == true) ▸ lambd… 외 1 | FP00590_RePlanTotalPopup.cs:737 | try ▸ lambda ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (blnCreateRun == true) ▸ if (bRun1 == true && bRun1… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_RePlanTotalPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ee860ac | this.Load | FP00590_RePlanTotalPopup.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-27464130 | this.Load | FP00590_RePlanTotalPopup.cs:233 |  | VALUE_SET | chkStatus.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-4242efb7 | this.Load | FP00590_RePlanTotalPopup.cs:236 |  | FOCUS | txtDescription.Focus | () | 포커스 이동 |  |  |  |

## FP00590_RePlanTotalPopup.FP00590_RePlanTotalPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e37082f1 | this.FormClosing | FP00590_RePlanTotalPopup.cs:1145 | if (EngineCheckTimer != null) | CALL_EXT | EngineCheckTimer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-025b6166 | this.FormClosing | FP00590_RePlanTotalPopup.cs:1146 | if (EngineCheckTimer != null) | UI_MISC | EngineCheckTimer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-b0796966 | this.FormClosing | FP00590_RePlanTotalPopup.cs:1147 | if (EngineCheckTimer != null) | FLAG | EngineCheckTimer | null | 화면 필드/플래그 변경 |  |  |  |

## FP00590_RePlanTotalPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0c7d912 | this.Load | FP00590_RePlanTotalPopup.cs:269 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c433b6c | this.Load | FP00590_RePlanTotalPopup.cs:275 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-42261bd5 | this.Load | FP00590_RePlanTotalPopup.cs:276 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ae9179b3 | this.Load | FP00590_RePlanTotalPopup.cs:278 | try | VALUE_SET | txtSite.Text | _sSite | 컨트롤 값 설정 |  |  |  |
| AC-05a062a5 | this.Load | FP00590_RePlanTotalPopup.cs:279 | try | VALUE_SET | txtPlanGroup.Text | _sPlanGroup | 컨트롤 값 설정 |  |  |  |
| AC-77ab54c4 | this.Load | FP00590_RePlanTotalPopup.cs:280 | try | UI_PROP | lblEngineStatus.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bbcaff04 | this.Load | FP00590_RePlanTotalPopup.cs:286 | try | VALUE_SET | dtpFixDate1.Value | dDate | 컨트롤 값 설정 |  |  |  |
| AC-9607bb11 | this.Load | FP00590_RePlanTotalPopup.cs:288 | try | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Custom | 속성 Format 설정 |  |  |  |
| AC-b3fd1373 | this.Load | FP00590_RePlanTotalPopup.cs:289 | try | UI_PROP | dtpFixDate2.CustomFormat | " " | 속성 CustomFormat 설정 |  |  |  |
| AC-4a383d79 | this.Load | FP00590_RePlanTotalPopup.cs:296 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d9605ba | this.Load | FP00590_RePlanTotalPopup.cs:305 | try ▸ for (i < itemValues2.Length) | DATA_OP | rdoGroup2.Properties.Items.Add | (new RadioGroupItem(itemValues2[i], itemDescriptions2[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-71fd700c | this.Load | FP00590_RePlanTotalPopup.cs:351 | try | UI_PROP | lbldtpFixDate2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4268f35c | this.Load | FP00590_RePlanTotalPopup.cs:353 | try | STATE | drpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4516ce27 | this.Load | FP00590_RePlanTotalPopup.cs:355 | try | VALUE_SET | txtPlanGroup.Text | _sPlanGroup | 컨트롤 값 설정 |  |  |  |
| AC-fe1ba3ba | this.Load | FP00590_RePlanTotalPopup.cs:356 | try | VALUE_SET | txtPlanID.Text | _sPlanID | 컨트롤 값 설정 |  |  |  |
| AC-13a66127 | this.Load | FP00590_RePlanTotalPopup.cs:359 | try | FLAG | dtPlanInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_Replan_findPlanInfo", _sPl… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f5c81e77 | this.Load | FP00590_RePlanTotalPopup.cs:359 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_Replan_findPlanInfo", _sPlanGroup, _sPlanID, DsinData.PLAN_TYPE) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07a06020 | this.Load | FP00590_RePlanTotalPopup.cs:370 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString().Equals("PRE")) | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-8b62c86d | this.Load | FP00590_RePlanTotalPopup.cs:372 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ else of (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString().Equals("PRE")) ▸ if (dt… | VALUE_SET | rdoGroup1.EditValue | 2 | 컨트롤 값 설정 |  |  |  |
| AC-986ef1e7 | this.Load | FP00590_RePlanTotalPopup.cs:374 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ else of (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString().Equals("PRE")) ▸ else o… | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-11d712bc | this.Load | FP00590_RePlanTotalPopup.cs:377 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ if (dtPlanInfo.Rows[0]["PRE_FIX_TYPE"].ToString().Equals("QTY_FIX")) | VALUE_SET | rdoGroup2.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-2d48b391 | this.Load | FP00590_RePlanTotalPopup.cs:379 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ else of (dtPlanInfo.Rows[0]["PRE_FIX_TYPE"].ToString().Equals("QTY_FIX")) ▸… | VALUE_SET | rdoGroup2.EditValue | 2 | 컨트롤 값 설정 |  |  |  |
| AC-e52c7581 | this.Load | FP00590_RePlanTotalPopup.cs:381 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ else of (dtPlanInfo.Rows[0]["PRE_FIX_TYPE"].ToString().Equals("QTY_FIX")) ▸… | VALUE_SET | rdoGroup2.EditValue | 3 | 컨트롤 값 설정 |  |  |  |
| AC-8c9c4953 | this.Load | FP00590_RePlanTotalPopup.cs:383 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) ▸ else of (dtPlanInfo.Rows[0]["PRE_FIX_TYPE"].ToString().Equals("QTY_FIX")) ▸… | VALUE_SET | rdoGroup2.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-9be68ce5 | this.Load | FP00590_RePlanTotalPopup.cs:385 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtBasePlanID.Text | dtPlanInfo.Rows[0]["BASIS_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1bfca081 | this.Load | FP00590_RePlanTotalPopup.cs:386 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | txtDescription.Text | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-89bf2e28 | this.Load | FP00590_RePlanTotalPopup.cs:393 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | dtpFixDate1.Value | dFixDate | 컨트롤 값 설정 |  |  |  |
| AC-deb91299 | this.Load | FP00590_RePlanTotalPopup.cs:396 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | dtpFixDate2.Value | dAmendFixDate | 컨트롤 값 설정 |  |  |  |
| AC-10ca6bb5 | this.Load | FP00590_RePlanTotalPopup.cs:397 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) | VALUE_SET | dtpFixDate2.Text | dtpFixDate2.Value.ToString("yyyy-MM-dd") | 컨트롤 값 설정 |  |  |  |
| AC-87f933c6 | this.Load | FP00590_RePlanTotalPopup.cs:398 | try ▸ if (dtPlanInfo != null) ▸ if (dtPlanInfo.Rows.Count > 0) | UI_PROP | dtpFixDate2.Format | DateTimePickerFormat.Short | 속성 Format 설정 |  |  |  |
| AC-024d155e | this.Load | FP00590_RePlanTotalPopup.cs:407 | try | VALUE_SET | drpPeriod.InitValue | _sPlanDate.ToString() + ":" + sPlanEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d2381310 | this.Load | FP00590_RePlanTotalPopup.cs:413 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-8a78a5f7 | this.Load | FP00590_RePlanTotalPopup.cs:414 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-33225168 | this.Load | FP00590_RePlanTotalPopup.cs:415 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cd97af46 | this.Load | FP00590_RePlanTotalPopup.cs:422 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | LIST_CLEAR | rdoGroup1.Properties.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-408fe371 | this.Load | FP00590_RePlanTotalPopup.cs:423 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | LIST_CLEAR | rdoGroup2.Properties.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-30f21733 | this.Load | FP00590_RePlanTotalPopup.cs:430 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-e25fbc54 | this.Load | FP00590_RePlanTotalPopup.cs:433 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-b990305c | this.Load | FP00590_RePlanTotalPopup.cs:440 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) ▸ for (i < itemValues2.Length) | DATA_OP | rdoGroup2.Properties.Items.Add | (new RadioGroupItem(itemValues2[i], itemDescriptions2[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-4faa31a2 | this.Load | FP00590_RePlanTotalPopup.cs:443 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | VALUE_SET | rdoGroup2.EditValue | 3 | 컨트롤 값 설정 |  |  |  |
| AC-15c5fdf8 | this.Load | FP00590_RePlanTotalPopup.cs:449 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | UI_PROP | dtpFixDate2.CustomFormat | null | 속성 CustomFormat 설정 |  |  |  |
| AC-d47179ed | this.Load | FP00590_RePlanTotalPopup.cs:454 | try ▸ if (DsinData.INSTANCE_ID.IndexOf("POST") != -1) | VALUE_SET | dtpFixDate2.Value | dDate2 | 컨트롤 값 설정 |  |  |  |
| AC-d7b42a6f | this.Load | FP00590_RePlanTotalPopup.cs:459 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_RePlanTotalPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b899f96 | this.Load | FP00590_RePlanTotalPopup.cs:494 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-122fb40e | this.Load | FP00590_RePlanTotalPopup.cs:497 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-befa1e84 | this.Load | FP00590_RePlanTotalPopup.cs:499 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9703a961 | this.Load | FP00590_RePlanTotalPopup.cs:502 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ENGINE_STATUS)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0f228128 | this.Load | FP00590_RePlanTotalPopup.cs:503 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5db3fcaf | this.Load | FP00590_RePlanTotalPopup.cs:504 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4055792e | this.Load | FP00590_RePlanTotalPopup.cs:505 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_START)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-57a7ef71 | this.Load | FP00590_RePlanTotalPopup.cs:506 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_END)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bf351a09 | this.Load | FP00590_RePlanTotalPopup.cs:509 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ENGINE_STATUS), siSub.GetColumnIndex(DefColumns.STATUS_MS… | 그리드 편집 잠금/해제 |  |  |  |

## FP00590_RePlanTotalPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02d69fdc | popSql.OnSql | FP00590_RePlanTotalPopup.cs:1165 | if (programID == "PR_UI_FP00590_REPLAN_ENGINE_RUN_SELECT") | RETURN | return Find_Data_Sub("SQL", txtPlanGroup.Text.ToString(), txtPlanID.Text.ToStrin… |  | 처리 중단/반환 |  |  |  |
| AC-51790005 | popSql.OnSql | FP00590_RePlanTotalPopup.cs:1171 | if (programID == "PR_UI_FP00590_REPLAN_FIX_PLAN_SAVE") | RETURN | return Save_Fix_PlanData("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6579ab82 | popSql.OnSql | FP00590_RePlanTotalPopup.cs:1174 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_RePlanTotalPopup.Save_Fix_Plan

진입점: this.btnRun.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df53e6f1 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:800 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-599d6655 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:800 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7acf619 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:802 | if (siSub == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2513eb4 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:809 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba70dc2c | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:810 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-706d11b9 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:813 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-28743f88 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:820 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d69df0fe | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:821 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ecf6fa9 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:830 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-3a125df1 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:839 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-7a978d9f | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:846 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-719cca29 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:850 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3e440ccd | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:854 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3d70b348 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:858 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dff79b6a | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:859 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00590_RePlanTotalPopup.Save_Fix_PlanData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLAN_SAVE")] / this.btnRun.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5d09eeb | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:892 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_REPLAN_POPUP") ⇒ FP_Planning.PR_UI_FP00590_REPLAN_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-3d325d0d | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:893 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-915ef645 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:895 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-42a9ae64 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:896 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c3dccb22 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:897 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-babcb1db | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:898 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-217d685e | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:900 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ecc8f614 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:901 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-8efd5530 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:902 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-2b60889d | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:903 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-88dfbf7e | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:905 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b8fe4235 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:906 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e6e1f897 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:907 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-1a41977e | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:908 | try | DATA_OP | req.Parameters["p_amend_fix_date"] | p_amend_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-2cee9d11 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:910 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b74fc5b8 | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:911 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f57d31ce | popSql.OnSql [if (programID == "PR_UI_FP00590_REPLAN_FIX_PLA… 외 1 | FP00590_RePlanTotalPopup.cs:917 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_RePlanTotalPopup.Update_Clear_Status

진입점: this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf568af1 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:951 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_REPLAN_POPUP") ⇒ FP_Planning.PR_UI_FP00590_REPLAN_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-b230c05d | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:952 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1dee4baa | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:954 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3f78545b | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:955 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b4bdaf2a | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:956 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-c6bbd9f4 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:957 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4717f54 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:959 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8c24c0d | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:960 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a1c66c7 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:961 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-c53e8eb9 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:962 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b370b9ba | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:964 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cdf154cb | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:965 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-62812403 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:966 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-59c5e598 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:967 | try | DATA_OP | req.Parameters["p_amend_fix_date"] | p_amend_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-55d4f2a5 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:970 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1fdadc77 | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:971 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0918d8cd | this.btnRun.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStrin… | FP00590_RePlanTotalPopup.cs:978 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_RePlanTotalPopup.Update_Engine_Run

진입점: this.btnRun.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f795be93 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1012 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_REPLAN_POPUP") ⇒ FP_Planning.PR_UI_FP00590_REPLAN_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-3a5e7574 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1013 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d59778cf | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1015 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-7ed494c5 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1016 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-71e47470 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1017 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5d2b6d12 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1018 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b549485a | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1020 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a2d697a | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1021 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8107fd8 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1022 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b78b47bc | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1023 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-42a294fd | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1025 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-83a3c8cf | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1026 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-a235c4b5 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1027 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-18d32572 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1028 | try | DATA_OP | req.Parameters["p_amend_fix_date"] | p_amend_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-90de6c6d | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1030 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfc09d34 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1031 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f4eac003 | this.btnRun.Click | FP00590_RePlanTotalPopup.cs:1037 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_ValidationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e7ca71c | .ctor | FP00590_ValidationPopup.cs:96 |  | UI_PROP | SpdSheet.shtMain | sSheetName | 속성 shtMain 설정 |  |  |  |
| AC-558529f5 | .ctor | FP00590_ValidationPopup.cs:97 |  | FLAG | _dsSheet | dsSheet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-3043b898 | .ctor | FP00590_ValidationPopup.cs:97 |  | DATA_OP | dsSheet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bd35eba6 | .ctor | FP00590_ValidationPopup.cs:98 |  | FLAG | _sMessage | sMessage | 화면 필드/플래그 변경 |  |  |  |

## FP00590_ValidationPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6b8dcbb | this.btnClose.Click | FP00590_ValidationPopup.cs:227 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_ValidationPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f3c328f | this.btnExport.Click | FP00590_ValidationPopup.cs:221 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-3da26c6e | this.btnExport.Click | FP00590_ValidationPopup.cs:222 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00590_ValidationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f8aedc0 | this.Load | FP00590_ValidationPopup.cs:168 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a27ae8c0 | this.Load | FP00590_ValidationPopup.cs:169 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fc1e92a | this.Load | FP00590_ValidationPopup.cs:170 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_ValidationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70590d4f | this.Load | FP00590_ValidationPopup.cs:162 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_ValidationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b6fe69e | Dispose | FP00590_ValidationPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_ValidationPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4335cfb4 | ExcelButton | FP00590_ValidationPopup.cs:236 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00590_ValidationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f965027 | this.Load | FP00590_ValidationPopup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c91d22dd | this.Load | FP00590_ValidationPopup.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ff2999cd | this.Load | FP00590_ValidationPopup.cs:124 | if (!string.IsNullOrEmpty(_sMessage)) | MESSAGE | MessageBox.Show | (_sMessage, "Validation", MessageBoxButtons.OK, MessageBoxIcon.Information) | 메시지 표시 |  |  |  |

## FP00590_ValidationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97dde318 | this.Load | FP00590_ValidationPopup.cs:138 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-690e6677 | this.Load | FP00590_ValidationPopup.cs:141 | if (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") | VALUE_SET | lblTitle.Text | " Confirm Validation [1] Results" | 컨트롤 값 설정 |  |  |  |
| AC-08dc3513 | this.Load | FP00590_ValidationPopup.cs:143 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ if (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") | VALUE_SET | lblTitle.Text | " Confirm Validation [2] Results" | 컨트롤 값 설정 |  |  |  |
| AC-11b84107 | this.Load | FP00590_ValidationPopup.cs:145 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ if (SpdSheet… | VALUE_SET | lblTitle.Text | " Release Validation [1] Results" | 컨트롤 값 설정 |  |  |  |
| AC-7d5c4b43 | this.Load | FP00590_ValidationPopup.cs:147 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ else of (Spd… | VALUE_SET | lblTitle.Text | " Release Validation [2] Results" | 컨트롤 값 설정 |  |  |  |
| AC-fa74dc96 | this.Load | FP00590_ValidationPopup.cs:149 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ else of (Spd… | VALUE_SET | lblTitle.Text | " Group Confirm Validation [1] Results" | 컨트롤 값 설정 |  |  |  |
| AC-2896f0d4 | this.Load | FP00590_ValidationPopup.cs:151 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ else of (Spd… | VALUE_SET | lblTitle.Text | " Group Confirm Validation [2] Results" | 컨트롤 값 설정 |  |  |  |
| AC-8cc9e4b5 | this.Load | FP00590_ValidationPopup.cs:153 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ else of (Spd… | VALUE_SET | lblTitle.Text | " Group Release Validation [1] Results" | 컨트롤 값 설정 |  |  |  |
| AC-af18e55f | this.Load | FP00590_ValidationPopup.cs:155 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ else of (Spd… | VALUE_SET | lblTitle.Text | " Group Release Validation [2] Results" | 컨트롤 값 설정 |  |  |  |
| AC-0ae925d7 | this.Load | FP00590_ValidationPopup.cs:157 | else of (SpdSheet.shtMain.ToString() == "ConfirmValid1Popup") ▸ else of (SpdSheet.shtMain.ToString() == "ConfirmValid2Popup") ▸ else of (Spd… | VALUE_SET | lblTitle.Text | " Release Validation Results" | 컨트롤 값 설정 |  |  |  |

## FP00590_ValidationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5f44fc5 | this.Load | FP00590_ValidationPopup.cs:182 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb2fac54 | this.Load | FP00590_ValidationPopup.cs:183 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_ValidationPopup.RefreshHeadAndBody

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58dd1bab | this.Load [try] | FP00590_ValidationPopup.cs:290 |  | CALL_EXT | FPExtensions.ColorFromName | ("orange") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbcd37e5 | this.Load [try] | FP00590_ValidationPopup.cs:319 | switch (sheetName) case "ReleaseValid2Popup": ▸ if (current_src != null) ▸ for (rowindex < current_src.Rows.Count) ▸ if (_MSG_NUM == "1") | GRID_STYLE | siMain.SetBGColor3 | (rowindex, child_line, rowindex, child_line, orangeColor) | 그리드 표시 설정 |  |  |  |
| AC-2e0ce940 | this.Load [try] | FP00590_ValidationPopup.cs:323 | switch (sheetName) case "ReleaseValid2Popup": ▸ if (current_src != null) ▸ for (rowindex < current_src.Rows.Count) ▸ else of (_MSG_NUM == "1… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, child_prio, rowindex, child_prio, orangeColor) | 그리드 표시 설정 |  |  |  |
| AC-200b20d1 | this.Load [try] | FP00590_ValidationPopup.cs:327 | switch (sheetName) case "ReleaseValid2Popup": ▸ if (current_src != null) ▸ for (rowindex < current_src.Rows.Count) ▸ else of (_MSG_NUM == "1… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, child_Item, rowindex, child_Item, orangeColor) | 그리드 표시 설정 |  |  |  |

## FP00590_ValidationPopup.SetGrid_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-286ddfb2 | this.Load | FP00590_ValidationPopup.cs:245 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d7e54d1 | this.Load | FP00590_ValidationPopup.cs:249 | try | GRID_BIND | siMain.Query | (_dsSheet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-31acbd02 | this.Load | FP00590_ValidationPopup.cs:254 | try ▸ if (_dsSheet.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f39b78e | this.Load | FP00590_ValidationPopup.cs:258 | try | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0eb3c767 | this.Load | FP00590_ValidationPopup.cs:262 | try | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00590_ValidationPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37ca3e9d | this.Load [try] | FP00590_ValidationPopup.cs:194 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b39a6fa | this.Load [try] | FP00590_ValidationPopup.cs:195 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-7aad40d5 | this.Load [try] | FP00590_ValidationPopup.cs:199 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-575a68e3 | this.Load [try] | FP00590_ValidationPopup.cs:200 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_WoWStatusPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5179390 | .ctor | FP00590_WoWStatusPopup.cs:161 |  | UI_PROP | SpdSheet.shtMain | "WoWStatusPopup" | 속성 shtMain 설정 |  |  |  |
| AC-c8adef97 | .ctor | FP00590_WoWStatusPopup.cs:163 |  | FLAG | _sSite | sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-a6825382 | .ctor | FP00590_WoWStatusPopup.cs:164 |  | FLAG | _sPlanGroup | sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-620e1819 | .ctor | FP00590_WoWStatusPopup.cs:165 |  | FLAG | _sPlanDate | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-0fb985b8 | .ctor | FP00590_WoWStatusPopup.cs:166 |  | FLAG | _sPlanID | sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-b9f97ae5 | .ctor | FP00590_WoWStatusPopup.cs:167 |  | FLAG | _sIsSamePlanID | sIsSamePlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-54d3aeb5 | .ctor | FP00590_WoWStatusPopup.cs:168 |  | FLAG | _sConfirmArea | sConfirmArea | 화면 필드/플래그 변경 |  |  |  |
| AC-dc08d2dd | .ctor | FP00590_WoWStatusPopup.cs:169 |  | FLAG | _sWoWStatus | sWoWStatus | 화면 필드/플래그 변경 |  |  |  |

## FP00590_WoWStatusPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed93f820 | this.btnClose.Click | FP00590_WoWStatusPopup.cs:897 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00590_WoWStatusPopup.btnReset_Click

진입점: this.btnReset.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c27c111 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:887 |  | MESSAGE | MessageBox.Show | ("Would you like to create New wow status?\r\n( current status will be cleared !!)", "Conf… | 메시지 표시 |  |  |  |
| AC-07307885 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:889 | if (MessageBox.Show("Would you like to create New wow status?\r\n( current status will be cleared !!)", "Confrim", MessageBo…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026899d0 | this.btnSql.Click | FP00590_WoWStatusPopup.cs:903 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-782379fd | this.btnSql.Click | FP00590_WoWStatusPopup.cs:904 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1a83b386 | this.btnSql.Click | FP00590_WoWStatusPopup.cs:906 |  | DATA_OP | popSql.Services.Add | ("SELECT_WOW_STATUS") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b5a3946 | this.btnSql.Click | FP00590_WoWStatusPopup.cs:907 |  | DATA_OP | popSql.Services.Add | ("UPDATE_RESET_SUBMIT") | 데이터 객체 조작/조회 |  |  |  |
| AC-29644feb | this.btnSql.Click | FP00590_WoWStatusPopup.cs:908 |  | DATA_OP | popSql.Services.Add | ("UPDATE_STEP_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3696b5 | this.btnSql.Click | FP00590_WoWStatusPopup.cs:909 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00590_WoWStatusPopup.cboDraftPlanID_Click

진입점: this.cboDraftPlanID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2b85549 | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:918 |  | FLAG | dtPrePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_prePlanList", _sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4db72be4 | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:918 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_prePlanList", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f0413f7 | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:919 |  | LIST_REBIND | clsCtrl.setListBox | (dtPrePlanList, cboDraftPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f848e9ed | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:921 |  | DATA_OP | dtPrePlanList.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b7ead6d | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:922 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-83c5325e | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:928 | foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bc4f08fb | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:932 | foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8bb4ce2 | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:935 |  | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a79e4cd | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:936 |  | LIST_BIND | cboDraftPlanID.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-66ffc016 | this.cboDraftPlanID.Click | FP00590_WoWStatusPopup.cs:938 |  | FLAG | _sPreDraftPlanID | CString.GetCheckedListValue(dtPrePlanList, cboDraftPlanID.ControlValues) | 화면 필드/플래그 변경 |  |  |  |

## FP00590_WoWStatusPopup.cboDraftPlanID_MouseHover

진입점: this.cboDraftPlanID.MouseHover

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17acd243 | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:946 | if (string.IsNullOrEmpty(sDraftPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cd3344f | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:949 |  | DATA_OP | dtResult.Columns.Add | ("USER_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-772e04ae | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:950 |  | DATA_OP | dtResult.Columns.Add | ("INSERT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb9b699b | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:951 |  | DATA_OP | dtResult.Columns.Add | ("INSERT_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b7fb80d | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:952 |  | DATA_OP | dtResult.Columns.Add | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-40b101a4 | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:958 | if (dtPrePlanList.Rows.Count > 0) | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-809193ae | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:963 | if (dtPrePlanList.Rows.Count > 0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4809c41 | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:966 | if (dtPrePlanList.Rows.Count > 0) | DATA_OP | dtResult.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2bbcef94 | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:968 | if (dtPrePlanList.Rows.Count > 0) | UI_PROP | btnToolTip.UseFading | true | 속성 UseFading 설정 |  |  |  |
| AC-5df73d28 | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:969 | if (dtPrePlanList.Rows.Count > 0) | UI_PROP | btnToolTip.AutoPopDelay | 2000 | 속성 AutoPopDelay 설정 |  |  |  |
| AC-7d3ad38c | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:970 | if (dtPrePlanList.Rows.Count > 0) | UI_PROP | btnToolTip.InitialDelay | 1000 | 속성 InitialDelay 설정 |  |  |  |
| AC-2810f79c | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:971 | if (dtPrePlanList.Rows.Count > 0) | UI_PROP | btnToolTip.ReshowDelay | 0 | 속성 ReshowDelay 설정 |  |  |  |
| AC-bd4f14ee | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:972 | if (dtPrePlanList.Rows.Count > 0) | UI_PROP | btnToolTip.ToolTipTitle | "* Insert User : " + dtResult.Rows[0]["USER_NAME"].ToString() + "(" + dtResult.Rows[0]["IN… | 속성 ToolTipTitle 설정 |  |  |  |
| AC-f8e7821a | this.cboDraftPlanID.MouseHover | FP00590_WoWStatusPopup.cs:976 | if (dtPrePlanList.Rows.Count > 0) | CALL_EXT | btnToolTip.SetToolTip | (cboDraftPlanID, cboDraftPlanID.Text) | ⚠ 의미 확인 필요 |  |  |  |

## FP00590_WoWStatusPopup.cboDraftPlanID_SelectionChangeCommitted

진입점: this.cboDraftPlanID.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6cc261c | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:989 | if (string.IsNullOrEmpty(sDraftPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23779252 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:994 | if (dtCurrStageInfo.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4076e23 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:995 | if (dtCurrStageInfo.Rows.Count == 0) | FLAG | bDraftCheckFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0b8bc078 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:996 | if (dtCurrStageInfo.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a58107ee | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1004 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6957cf42 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1006 | if (MessageHelper.GMessageBox("MSG00183", new object[] { sMsg }) == DialogResult.No) | VALUE_CLEAR | cboDraftPlanID.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-b5741fad | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1007 | if (MessageHelper.GMessageBox("MSG00183", new object[] { sMsg }) == DialogResult.No) | FLAG | bDraftCheckFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fae764ff | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1008 | if (MessageHelper.GMessageBox("MSG00183", new object[] { sMsg }) == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22b7dc29 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1011 | if (GetCurrSeq() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c62aec19 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1029 | if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ad8073c | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1038 | else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00590_WoWStatusPopup.cboSyncPlanID_Click

진입점: this.cboSyncPlanID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21c586c7 | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1049 |  | FLAG | dtSyncPlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_syncPlanList", _sPlan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c74e4e04 | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1049 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_syncPlanList", _sPlanGroup, _sPlanDate, sDataID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8971bd07 | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1050 |  | DATA_OP | dtPrePlanList.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ce1cb04d | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1051 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aaa6bac1 | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1057 | foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3fb2388 | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1061 | foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f90c21d4 | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1064 |  | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-43764a6d | this.cboSyncPlanID.Click | FP00590_WoWStatusPopup.cs:1065 |  | LIST_BIND | cboSyncPlanID.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |

## FP00590_WoWStatusPopup.cboSyncPlanID_SelectionChangeCommitted

진입점: this.cboSyncPlanID.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ced83ba0 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1077 | if (dtCurrStageInfo.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3f207cd | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1081 | if (string.IsNullOrEmpty(sDraftPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d4b728b | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1082 | if (string.IsNullOrEmpty(sDraftPlanID)) | VALUE_CLEAR | cboSyncPlanID.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-2e5a6878 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1083 | if (string.IsNullOrEmpty(sDraftPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d81c87b | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1085 | if (string.IsNullOrEmpty(sSyncPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09e1b1c8 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1099 | if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9fac57c | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1108 | else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00590_WoWStatusPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf8409b | this.Load | FP00590_WoWStatusPopup.cs:306 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cb27b868 | this.Load | FP00590_WoWStatusPopup.cs:307 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3124535 | this.Load | FP00590_WoWStatusPopup.cs:308 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00590_WoWStatusPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7c54756 | this.Load | FP00590_WoWStatusPopup.cs:301 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00590_WoWStatusPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50d66b4e | Dispose | FP00590_WoWStatusPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00590_WoWStatusPopup.EditButton

진입점: this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.cboSyncPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.cboDraftPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.Load [if (dtData.Rows.Count > 0) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08a1f568 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00590_WoWStatusPopup.cs:457 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-24a2d741 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00590_WoWStatusPopup.cs:459 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-70632356 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00590_WoWStatusPopup.cs:461 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.STEP_DESC), siMain.GetColumnIndex(DefColumns.STEP_DESC),… | 그리드 편집 잠금/해제 |  |  |  |

## FP00590_WoWStatusPopup.Find_Data_Sub

진입점: this.btnFind.Click [try] / this.cboSyncPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.cboDraftPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.Load [if (dtData.Rows.Count > 0) ▸ try] / popSql.OnSql [if (programID == "SELECT_WOW_STATUS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1440580b | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:522 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-8e785311 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:523 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-a93ece24 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:524 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_WOW_STATUS" | 행/컬럼 값 대입 |  |  |  |
| AC-2c2d3656 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:525 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-15b28c9a | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:526 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ec07c863 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:528 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3e027720 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:529 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-86370390 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:530 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d378c0ac | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:531 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-f9142e89 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:532 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-6fd96498 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:533 | try | DATA_OP | request.Parameters["p_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2b5e2ffd | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:534 | try | DATA_OP | request.Parameters["p_step_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d251c94d | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:535 | try | DATA_OP | request.Parameters["p_date_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bfcd2fe6 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:536 | try | DATA_OP | request.Parameters["p_user_group_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bbb6828c | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:537 | try | DATA_OP | request.Parameters["p_set_step"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b2560811 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:538 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-413f5233 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:539 | try | DATA_OP | request.Parameters["p_draft_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1d91df43 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:540 | try | DATA_OP | request.Parameters["p_sync_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2b800a64 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:542 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e9552d2 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:544 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9d993b75 | this.btnFind.Click [try] 외 5 | FP00590_WoWStatusPopup.cs:549 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.FindData_Sub

진입점: this.btnFind.Click / this.cboSyncPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.cboDraftPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.Load [if (dtData.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1fa6ac0 | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:472 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f35774d3 | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:476 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-32199063 | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:476 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb4c4920 | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:478 | try ▸ if (string.IsNullOrEmpty(txtSCPTargetID.Text.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4dc8360a | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:482 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c083bc0 | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:490 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-92deb25f | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:495 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e77610ac | this.btnFind.Click 외 4 | FP00590_WoWStatusPopup.cs:503 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00590_WoWStatusPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a462667b | this.Load | FP00590_WoWStatusPopup.cs:180 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7ab36ea | this.Load | FP00590_WoWStatusPopup.cs:182 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5a416c25 | this.Load | FP00590_WoWStatusPopup.cs:192 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findDataCheck", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00590_WoWStatusPopup.GetCheckActive_Flag

진입점: this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.GetCellType(e.Row, e.Column).ToString() == "CheckBoxCellType") ▸ if (sValue.Equals("True")) ▸ if (siMain.ActiveSheet.Cells[e.Row, e.Column].Locked == false) ▸ if (MessageBox.Show(sMsg, "Confrim", MessageBoxButtons.YesNo) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2277eef3 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1353 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrSeq", _sPlanGroup, _sPlanDate, sDateSeq) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8c23219 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1359 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_currChk", _sPlanGroup, _sPlanDate, sStepID, sDateSeq, sUser… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-39fb23df | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1364 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ if (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-503d2b65 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1365 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ if (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-972389b7 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1372 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ else of (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_currUpperChk", _sPlanGroup, _sPlanDate, sStepID, sDateSeq) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87c16fac | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1377 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ else of (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") ▸ if (dtCurrUpperChk.R… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-69aac5ed | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1385 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ else of (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") ▸ else of (dtCurrUpper… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5ded026 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1386 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ else of (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") ▸ else of (dtCurrUpper… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b6ad41b8 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1390 | if (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") ▸ else of (dtCurrChk.Rows[0]["CHECK_FLAG"].ToString() == "Y") ▸ else of (dtCurrUpper… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-271cca18 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1400 | else of (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18d47783 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1401 | else of (dtCurrSeq.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.GetCurrSeq

진입점: this.cboDraftPlanID.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3366a496 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1295 |  | FLAG | dtStatusValid | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_CurrSeq", _sPlanGroup… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-1683bb02 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1295 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrSeq", _sPlanGroup, _sPlanDate, sParam) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4509877 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1299 | if (dtStatusValid.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") | FLAG | bDraftCheckFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1a2856c | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1305 | else of (dtStatusValid.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fac4dad9 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1306 | else of (dtStatusValid.Rows[0]["ACTIVE_FLAG"].ToString() == "Y") | FLAG | bDraftCheckFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5d967151 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:1309 |  | RETURN | return bDraftCheckFlag; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.GetUserGroupByDataTable

진입점: this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.GetCellType(e.Row, e.Column).ToString() == "CheckBoxCellType") ▸ if (sValue.Equals("True")) ▸ if (siMain.ActiveSheet.Cells[e.Row, e.Column].Locked == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb0cec57 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1318 | if (dtWoWDataMap.Rows.Count == 0) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-176f5ff1 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1323 |  | DATA_OP | dtResult.Columns.Add | ("USER_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-236a7f2c | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1327 |  | DATA_OP | dRow.Field | ("STEP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-86845302 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1327 |  | DATA_OP | dRow.Field | ("COL_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-48465b16 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1332 | foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6a99833 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1335 |  | DATA_OP | dtResult.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c286db08 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … | FP00590_WoWStatusPopup.cs:1339 |  | RETURN | return sRtnValue; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da09e00 | this.Load | FP00590_WoWStatusPopup.cs:213 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa8d1fc7 | this.Load | FP00590_WoWStatusPopup.cs:219 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fde6295e | this.Load | FP00590_WoWStatusPopup.cs:220 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5e2673a0 | this.Load | FP00590_WoWStatusPopup.cs:225 | try ▸ for (i <= 20) | DATA_OP | ArrBindFieldList.Add | ("CHECK"+String.Format("{0:00}", i)) | 데이터 객체 조작/조회 |  |  |  |
| AC-165f611e | this.Load | FP00590_WoWStatusPopup.cs:236 | try | FLAG | dtWoWHeaderInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_WoWHeaderInfo", _sPla… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0d9656e7 | this.Load | FP00590_WoWStatusPopup.cs:236 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_WoWHeaderInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1c7c1a4 | this.Load | FP00590_WoWStatusPopup.cs:238 | try | FLAG | dtWoWHeaderTitle | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_WoWHeaderTitle", _sPl… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5b7e7ba0 | this.Load | FP00590_WoWStatusPopup.cs:238 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_WoWHeaderTitle", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19168b80 | this.Load | FP00590_WoWStatusPopup.cs:240 | try | FLAG | dtWoWDataMap | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_Map", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-205a01bc | this.Load | FP00590_WoWStatusPopup.cs:240 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_Map", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ec57ea7 | this.Load | FP00590_WoWStatusPopup.cs:243 | try | UI_PROP | lblSysPlanID.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b2a110a7 | this.Load | FP00590_WoWStatusPopup.cs:249 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-cc1d6e35 | this.Load | FP00590_WoWStatusPopup.cs:250 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e28d90a0 | this.Load | FP00590_WoWStatusPopup.cs:251 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7b4aafb3 | this.Load | FP00590_WoWStatusPopup.cs:256 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_WoWStatusPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f135802 | this.Load | FP00590_WoWStatusPopup.cs:322 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b43ba00 | this.Load | FP00590_WoWStatusPopup.cs:323 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_WoWStatusPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f825eee6 | popSql.OnSql | FP00590_WoWStatusPopup.cs:1416 | if (programID == "SELECT_WOW_STATUS") | RETURN | return Find_Data_Sub("SQL", _sPlanGroup, _sPlanDate); |  | 처리 중단/반환 |  |  |  |
| AC-b0760959 | popSql.OnSql | FP00590_WoWStatusPopup.cs:1422 | else of (programID == "SELECT_WOW_STATUS") ▸ if (programID == "UPDATE_RESET_SUBMIT") | RETURN | return Update_Submit_Data("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-91cb883b | popSql.OnSql | FP00590_WoWStatusPopup.cs:1431 | else of (programID == "SELECT_WOW_STATUS") ▸ else of (programID == "UPDATE_RESET_SUBMIT") ▸ if (programID == "UPDATE_STEP_GROUP") | RETURN | return Update_Step_Group(pStepID, pDateSeq, pUserGroup, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-25a5e0af | popSql.OnSql | FP00590_WoWStatusPopup.cs:1434 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.SetCleraVariable

진입점: this.cboSyncPlanID.SelectionChangeCommitted / this.cboDraftPlanID.SelectionChangeCommitted / this.btnReset.Click [try] / this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.GetCellType(e.Row, e.Column).ToString() == "CheckBoxCellType") ▸ if (sValue.Equals("True")) ▸ if (siMain.ActiveSheet.Cells[e.Row, e.Column].Locked == false) ▸ if (MessageBox.Show(sMsg, "Confrim", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (GetCheckActive_Flag(sStepID, sDateSeq, sUserGroup) == true)] / pop…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce342f0e | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1202 |  | FLAG | p_sys_type | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7084a3e2 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1203 |  | FLAG | p_sys_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-74fbd3f7 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1204 |  | FLAG | p_sys_gubun | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3e6bca61 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1205 |  | FLAG | p_user_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7e2bad6d | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1206 |  | FLAG | p_division_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a4dd4582 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1207 |  | FLAG | p_site_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-bda75ed2 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1208 |  | FLAG | p_factory_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2653896a | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1209 |  | FLAG | p_instance_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-83aeb579 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1210 |  | FLAG | p_plan_date | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-850f19a6 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1211 |  | FLAG | p_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-42303ae1 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1212 |  | FLAG | p_step_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-30496fc8 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1213 |  | FLAG | p_date_seq | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-99939302 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1214 |  | FLAG | p_user_group_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f2c52c4a | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1215 |  | FLAG | p_set_step | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-bbb86b19 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1216 |  | FLAG | p_scp_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-097c653b | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1217 |  | FLAG | p_draft_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d6ec8b68 | this.cboSyncPlanID.SelectionChangeCommitted 외 4 | FP00590_WoWStatusPopup.cs:1218 |  | FLAG | p_sync_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP00590_WoWStatusPopup.SetColumMerge

진입점: this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.cboSyncPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.cboDraftPlanID.SelectionChangeCommitted [if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows.Cou…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcf5eb5d | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1239 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sTemp.Equals("MASTER")) | GRID_STYLE | siMain.ActiveSheet.AddSpanCell | (iRow, siMain.GetColumnIndex(DefColumns.CHECK01), 1, iDataFieldCount) | 그리드 표시 설정 |  |  |  |
| AC-f09a7c41 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1241 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sTemp.Equals("MASTER")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CHECK01)].Note | sNote | 그리드 속성/값 설정 |  |  |  |
| AC-a34e866b | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1242 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sTemp.Equals("MASTER")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CHECK01)].NoteStyle | FarPoint.Win.Spread.NoteStyle.PopupNote | 그리드 속성/값 설정 |  |  |  |
| AC-462485fa | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1246 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sTemp.Equals("MASTER")) ▸ if (sValue.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CHECK01)].Value | "True" | 그리드 속성/값 설정 |  |  |  |
| AC-a3a7bde9 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1252 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sTemp.Equals("MASTER")) ▸ else of (sValue.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CHECK01)].Value | "False" | 그리드 속성/값 설정 |  |  |  |
| AC-3ffb9a24 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1263 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (sTemp.Equals("MASTER")) ▸ for (iCol < iSetDataMaxCol) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].Note | sNote | 그리드 속성/값 설정 |  |  |  |
| AC-2655d8af | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1264 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (sTemp.Equals("MASTER")) ▸ for (iCol < iSetDataMaxCol) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].NoteStyle | FarPoint.Win.Spread.NoteStyle.PopupNote | 그리드 속성/값 설정 |  |  |  |
| AC-c9b4f2d7 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1268 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (sTemp.Equals("MASTER")) ▸ for (iCol < iSetDataMaxCol) ▸ if (sValue2.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].Value | "True" | 그리드 속성/값 설정 |  |  |  |
| AC-2ebd6fc5 | this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸… 외 4 | FP00590_WoWStatusPopup.cs:1273 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (sTemp.Equals("MASTER")) ▸ for (iCol < iSetDataMaxCol) ▸ else of (sValue2.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].Value | "False" | 그리드 속성/값 설정 |  |  |  |

## FP00590_WoWStatusPopup.SetControlByCurrStageInfo

진입점: this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5feb3372 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:267 | try | FLAG | dtCurrStageInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_currStageInfo", _sPla… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-9a4a364d | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:267 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_currStageInfo", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79052beb | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:271 | try ▸ if (dtCurrStageInfo.Rows.Count > 0) | FLAG | _sSCPPlanID | dtCurrStageInfo.Rows[0]["SCP_PLAN_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6a7505e | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:272 | try ▸ if (dtCurrStageInfo.Rows.Count > 0) | FLAG | _sSCPPlanTime | dtCurrStageInfo.Rows[0]["SCP_PLAN_TIME"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-20fec332 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:273 | try ▸ if (dtCurrStageInfo.Rows.Count > 0) | FLAG | _sSCPDraftPlanID | dtCurrStageInfo.Rows[0]["DRAFT_PLAN_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ac93d461 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:274 | try ▸ if (dtCurrStageInfo.Rows.Count > 0) | FLAG | _sSCPSyncPlanID | dtCurrStageInfo.Rows[0]["SYNC_PLAN_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cbfb9a6c | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:278 | try | VALUE_SET | txtSCPTargetID.Text | _sPlanID | 컨트롤 값 설정 |  |  |  |
| AC-5ab2ffc1 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:279 | try | VALUE_SET | txtTargetTime.Text | _sSCPPlanTime | 컨트롤 값 설정 |  |  |  |
| AC-969647e0 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:280 | try | VALUE_SET | txtSCPTargetID.Text | _sSCPPlanID | 컨트롤 값 설정 |  |  |  |
| AC-d1cecdb1 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:281 | try | VALUE_SET | cboDraftPlanID.SelectedValue | _sSCPDraftPlanID | 컨트롤 값 설정 |  |  |  |
| AC-efc6a9e7 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:282 | try | VALUE_SET | cboSyncPlanID.SelectedValue | _sSCPSyncPlanID | 컨트롤 값 설정 |  |  |  |
| AC-0e6c07f5 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:288 | try ▸ if (dtCurrStageInfo.Rows.Count > 0) ▸ if (dtCurrStageInfo.Rows[0]["IS_SCP_PLAN_SELECTED"].ToString() == "N") | UI_PROP | txtSCPTargetID.ForeColor | System.Drawing.Color.Blue | 속성 ForeColor 설정 |  |  |  |
| AC-354f2ae9 | this.btnReset.Click [try ▸ if (ds.Tables[0].Rows[0][0].ToStr… 외 1 | FP00590_WoWStatusPopup.cs:294 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00590_WoWStatusPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64bf3d6a | this.Load [try] | FP00590_WoWStatusPopup.cs:343 | if (dtWoWHeaderInfo.Rows.Count > 0 && dtWoWHeaderTitle.Rows.Count > 0) ▸ for (i < iDataCount) | DATA_OP | HeadMergeTitle.Add | (dtWoWHeaderInfo.Rows[i]["PLAN_GROUP_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef714e27 | this.Load [try] | FP00590_WoWStatusPopup.cs:344 | if (dtWoWHeaderInfo.Rows.Count > 0 && dtWoWHeaderTitle.Rows.Count > 0) ▸ for (i < iDataCount) | DATA_OP | HeadMergeListCnt[i] | Int32.Parse(dtWoWHeaderInfo.Rows[i]["CNT"].ToString()) | 행/컬럼 값 대입 |  |  |  |
| AC-5565b7cc | this.Load [try] | FP00590_WoWStatusPopup.cs:345 | if (dtWoWHeaderInfo.Rows.Count > 0 && dtWoWHeaderTitle.Rows.Count > 0) ▸ for (i < iDataCount) | FLAG | iDataFieldCount | iDataFieldCount + HeadMergeListCnt[i] | 화면 필드/플래그 변경 |  |  |  |
| AC-7ce1bbd6 | this.Load [try] | FP00590_WoWStatusPopup.cs:350 | else of (dtWoWHeaderInfo.Rows.Count > 0 && dtWoWHeaderTitle.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a353ef2 | this.Load [try] | FP00590_WoWStatusPopup.cs:354 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56afa491 | this.Load [try] | FP00590_WoWStatusPopup.cs:355 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-755dcb24 | this.Load [try] | FP00590_WoWStatusPopup.cs:360 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a73c2df | this.Load [try] | FP00590_WoWStatusPopup.cs:361 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.InitSheet | (siObj.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-75c56693 | this.Load [try] | FP00590_WoWStatusPopup.cs:364 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_LOCK | siObj.SetLockFlag | (siObj.SheetName, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fe26138 | this.Load [try] | FP00590_WoWStatusPopup.cs:367 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.InitSheet | (siObj.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8f03adf3 | this.Load [try] | FP00590_WoWStatusPopup.cs:368 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_CLEAR | SpreadInfo.ClearDataSource | (siObj.SP) | 그리드 데이터/선택 비움 |  |  |  |
| AC-49cf0bf8 | this.Load [try] | FP00590_WoWStatusPopup.cs:370 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d8233162 | this.Load [try] | FP00590_WoWStatusPopup.cs:373 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Step ID", DefColumns.STEP_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afcc2d05 | this.Load [try] | FP00590_WoWStatusPopup.cs:374 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Step Desc", DefColumns.STEP_DESC, FPMerge.Restricted, 150, true, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28e35db6 | this.Load [try] | FP00590_WoWStatusPopup.cs:375 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Step Seq", DefColumns.STEP_SEQ, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bad90ff7 | this.Load [try] | FP00590_WoWStatusPopup.cs:376 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Role ID", DefColumns.ROLE_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23f7f49e | this.Load [try] | FP00590_WoWStatusPopup.cs:377 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Instance", DefColumns.INSTANCE_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-295d1013 | this.Load [try] | FP00590_WoWStatusPopup.cs:378 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Plan Date", DefColumns.PLAN_DATE, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92681fea | this.Load [try] | FP00590_WoWStatusPopup.cs:379 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("SCP Plan ID", DefColumns.SCP_PLAN_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24fd99e8 | this.Load [try] | FP00590_WoWStatusPopup.cs:380 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Draft Plan ID", DefColumns.DRAFT_PLAN_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b771723d | this.Load [try] | FP00590_WoWStatusPopup.cs:381 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Sync Plan ID", DefColumns.SYNC_PLAN_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abe50890 | this.Load [try] | FP00590_WoWStatusPopup.cs:390 | if (siObj.SheetName == SpdSheet.shtMain) ▸ if (dtWoWHeaderTitle.Rows.Count > 0) ▸ for (i < 30) ▸ if (i < iDataFieldCount + 10) | GRID_INIT | siObj.AddCheckColumn | (dtWoWHeaderTitle.Rows[0][i-10].ToString(), ArrBindFieldList[i-10].ToString(), FPMerge.Res… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a001a7b8 | this.Load [try] | FP00590_WoWStatusPopup.cs:399 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Date Seq", DefColumns.DATE_SEQ, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b8b22ad | this.Load [try] | FP00590_WoWStatusPopup.cs:400 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee827a40 | this.Load [try] | FP00590_WoWStatusPopup.cs:401 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("User ID", DefColumns.USER_ID, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa835de9 | this.Load [try] | FP00590_WoWStatusPopup.cs:402 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Job User Name", DefColumns.JOB_USER_NAME, FPMerge.Restricted, 0, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-494bbdea | this.Load [try] | FP00590_WoWStatusPopup.cs:403 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.AddTextColumn | ("Job Time", DefColumns.JOB_TIME, FPMerge.Restricted, 0, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2884082c | this.Load [try] | FP00590_WoWStatusPopup.cs:406 | if (siObj.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.SYNC_PLAN_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f61411f | this.Load [try] | FP00590_WoWStatusPopup.cs:417 | if (siObj.SheetName == SpdSheet.shtMain) ▸ for (i < HeadMergeListCnt.Length) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iNextIndex, 1, HeadMergeListCnt[i], 20, HeadMergeTitle[i].ToString(), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5112f39d | this.Load [try] | FP00590_WoWStatusPopup.cs:430 | if (siObj.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Columns[i].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9b6f61bc | this.Load [try] | FP00590_WoWStatusPopup.cs:440 | if (siObj.SheetName == SpdSheet.shtMain) ▸ for (i < dtWoWHeaderTitle.Columns.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iNextIndex, 2, 1, 30, dtWoWHeaderTitle.Rows[0][i].ToString(), FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a12b807 | this.Load [try] | FP00590_WoWStatusPopup.cs:445 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.Freeze | (0, this.siMain.GetColumnIndex(DefColumns.STEP_DESC) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00590_WoWStatusPopup.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3165f00 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1119 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) | CALL_EXT | siMain.ActiveSheet.GetCellType | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62fb47aa | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1154 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | MESSAGE | MessageBox.Show | (sMsg, "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-8e75ab9a | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1160 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-3d0d4062 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1161 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Value | "True" | 그리드 속성/값 설정 |  |  |  |
| AC-a7b974d6 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1164 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d608a113 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1169 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Value | "False" | 그리드 속성/값 설정 |  |  |  |
| AC-b81cc265 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1170 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4948e3b8 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1175 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Value | "False" | 그리드 속성/값 설정 |  |  |  |
| AC-8aeb54bd | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1184 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-d1e55646 | this.spdMain.ButtonClicked | FP00590_WoWStatusPopup.cs:1185 | if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Get… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Value | "True" | 그리드 속성/값 설정 |  |  |  |

## FP00590_WoWStatusPopup.Update_Draft_Plan

진입점: this.cboDraftPlanID.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c64a75d | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:694 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e71124 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:695 | try | FLAG | p_sys_flag | "UPDATE_DRAFT_PLAN" | 화면 필드/플래그 변경 |  |  |  |
| AC-31c322b1 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:696 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-94e1e4fc | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:697 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4db0788d | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:698 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-733be757 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:699 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-c5b18a80 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:700 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-13312284 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:701 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-9af2b782 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:702 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-11abf482 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:703 | try | FLAG | p_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-27954e33 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:704 | try | FLAG | p_step_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5cff7e99 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:705 | try | FLAG | p_date_seq | pDateSeq | 화면 필드/플래그 변경 |  |  |  |
| AC-c5f458bc | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:706 | try | FLAG | p_user_group_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-89f2a12a | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:707 | try | FLAG | p_set_step | pSetDraftStep | 화면 필드/플래그 변경 |  |  |  |
| AC-adad0575 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:708 | try | FLAG | p_scp_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8b3561e5 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:709 | try | FLAG | p_draft_plan_id | pDraftPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-6b24b039 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:710 | try | FLAG | p_sync_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-eb9adcf9 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:715 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-9605a09d | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:716 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-55efa66a | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:718 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e504765d | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:719 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e3661733 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:720 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-40bc3e75 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:721 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cbc399fc | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:723 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8a58911e | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:724 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-36fff9c7 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:725 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-90fe004f | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:726 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-c907fe32 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:727 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-f7b59410 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:728 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b593c6f3 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:729 | try | DATA_OP | req.Parameters["p_step_id"] | p_step_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd2434ab | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:730 | try | DATA_OP | req.Parameters["p_date_seq"] | p_date_seq | 행/컬럼 값 대입 |  |  |  |
| AC-63817285 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:731 | try | DATA_OP | req.Parameters["p_user_group_id"] | p_user_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-c0e7ae1c | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:732 | try | DATA_OP | req.Parameters["p_set_step"] | p_set_step | 행/컬럼 값 대입 |  |  |  |
| AC-b8b64674 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:733 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-694fea20 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:734 | try | DATA_OP | req.Parameters["p_draft_plan_id"] | p_draft_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-45c27e4b | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:735 | try | DATA_OP | req.Parameters["p_sync_plan_id"] | p_sync_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c7cda4e | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:737 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-518fe722 | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:738 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-781555de | this.cboDraftPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:744 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.Update_Step_Group

진입점: this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount >= 1 && e.Row >= 0 && e.Column > 0 && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.GetCellType(e.Row, e.Column).ToString() == "CheckBoxCellType") ▸ if (sValue.Equals("True")) ▸ if (siMain.ActiveSheet.Cells[e.Row, e.Column].Locked == false) ▸ if (MessageBox.Show(sMsg, "Confrim", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (GetCheckActive_Flag(sStepID, sDateSeq, sUserGroup) == true)] / popSql.OnSql [else of (programID == "SELECT_WOW_STATUS") ▸ else of (programID == "UPDATE_RESET_SUBMIT") ▸ if (programID == "…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dad7ee4 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:821 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-6d0f589e | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:822 | try | FLAG | p_sys_flag | "UPDATE_STEP_GROUP" | 화면 필드/플래그 변경 |  |  |  |
| AC-bdca2c97 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:823 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fc5364e6 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:824 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-23b2df4f | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:825 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9cff772b | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:826 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-17e156a9 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:827 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2585ff32 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:828 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-7e0954aa | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:829 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-3a02e603 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:830 | try | FLAG | p_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-19ae98d1 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:831 | try | FLAG | p_step_id | pStepID | 화면 필드/플래그 변경 |  |  |  |
| AC-2954153c | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:832 | try | FLAG | p_date_seq | pDateSeq | 화면 필드/플래그 변경 |  |  |  |
| AC-4b3420c1 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:833 | try | FLAG | p_user_group_id | pUserGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-9aab853e | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:834 | try | FLAG | p_set_step | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-13360e8b | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:835 | try | FLAG | p_scp_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-733ac6c1 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:836 | try | FLAG | p_draft_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4d8abde3 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:837 | try | FLAG | p_sync_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-46fc2825 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:842 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-cc3bfc80 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:843 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-882f1627 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:845 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-31c10fd1 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:846 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-772ae489 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:847 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-79b52b3d | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:848 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9864423e | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:850 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8dc61d0 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:851 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4e8987b | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:852 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-58f5f91b | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:853 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-deb6ed24 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:854 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-d1f409d4 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:855 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2558ed3a | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:856 | try | DATA_OP | req.Parameters["p_step_id"] | p_step_id | 행/컬럼 값 대입 |  |  |  |
| AC-96e118a2 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:857 | try | DATA_OP | req.Parameters["p_date_seq"] | p_date_seq | 행/컬럼 값 대입 |  |  |  |
| AC-55a75c66 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:858 | try | DATA_OP | req.Parameters["p_user_group_id"] | p_user_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-88d89457 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:859 | try | DATA_OP | req.Parameters["p_set_step"] | p_set_step | 행/컬럼 값 대입 |  |  |  |
| AC-0670251f | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:860 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0e36bf7 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:861 | try | DATA_OP | req.Parameters["p_draft_plan_id"] | p_draft_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3a264bc | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:862 | try | DATA_OP | req.Parameters["p_sync_plan_id"] | p_sync_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff6644ae | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:864 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-28b3f104 | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:865 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6e5795fd | this.spdMain.ButtonClicked [if (siMain.ActiveSheet.RowCount … 외 1 | FP00590_WoWStatusPopup.cs:871 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.Update_Submit

진입점: this.btnReset.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b9035f0 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:556 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-42a74830 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:558 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-91977a54 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:558 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4abc61b | this.btnReset.Click | FP00590_WoWStatusPopup.cs:560 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-746cfe30 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:567 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9559d539 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:568 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-836b6ef1 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:574 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-38b766cc | this.btnReset.Click | FP00590_WoWStatusPopup.cs:590 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c7eb663 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:603 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6e5e4ff | this.btnReset.Click | FP00590_WoWStatusPopup.cs:606 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-73797f42 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:610 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c04cf2fe | this.btnReset.Click | FP00590_WoWStatusPopup.cs:614 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46ddb9c7 | this.btnReset.Click | FP00590_WoWStatusPopup.cs:618 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00590_WoWStatusPopup.Update_Submit_Data

진입점: this.btnReset.Click [try] / popSql.OnSql [else of (programID == "SELECT_WOW_STATUS") ▸ if (programID == "UPDATE_RESET_SUBMIT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95818d3d | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:631 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-44322f5c | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:632 | try | FLAG | p_sys_flag | "UPDATE_RESET_SUBMIT" | 화면 필드/플래그 변경 |  |  |  |
| AC-409c1ff7 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:633 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b3555c63 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:634 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-e9068873 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:635 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-13ac1370 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:636 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-83785f6a | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:637 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4d0739c6 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:638 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-1faf8327 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:639 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-d32cb54a | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:640 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-d82112ca | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:641 | try | FLAG | p_step_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f4a1b641 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:642 | try | FLAG | p_date_seq | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5948c4c8 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:643 | try | FLAG | p_user_group_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2a2b8486 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:644 | try | FLAG | p_set_step | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e51aeba4 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:645 | try | FLAG | p_scp_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-af3cc577 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:646 | try | FLAG | p_draft_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8b4fc1e5 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:647 | try | FLAG | p_sync_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-20923e37 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:652 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-baf74558 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:653 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4031d4a5 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:655 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f8cd102 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:656 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7ac2a9ef | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:657 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-725502d9 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:658 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-784a7a14 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:660 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-90be85ee | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:661 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-45e633ea | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:662 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-bb2041c5 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:663 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b6e6aae9 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:664 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-36e3ebd3 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:665 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-202c49f3 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:666 | try | DATA_OP | req.Parameters["p_step_id"] | p_step_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2fda6f3 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:667 | try | DATA_OP | req.Parameters["p_date_seq"] | p_date_seq | 행/컬럼 값 대입 |  |  |  |
| AC-de1d47c8 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:668 | try | DATA_OP | req.Parameters["p_user_group_id"] | p_user_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-b5e17147 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:669 | try | DATA_OP | req.Parameters["p_set_step"] | p_set_step | 행/컬럼 값 대입 |  |  |  |
| AC-3ea5882d | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:670 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-79405cb1 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:671 | try | DATA_OP | req.Parameters["p_draft_plan_id"] | p_draft_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ae1e8f3 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:672 | try | DATA_OP | req.Parameters["p_sync_plan_id"] | p_sync_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2416396 | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:674 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b1ad69d | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:675 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d8aceb4c | this.btnReset.Click [try] 외 1 | FP00590_WoWStatusPopup.cs:681 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00590_WoWStatusPopup.Update_Sync_Plan

진입점: this.cboSyncPlanID.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f958142 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:758 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-fb0d5ac6 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:759 | try | FLAG | p_sys_flag | "UPDATE_SYNC_PLAN" | 화면 필드/플래그 변경 |  |  |  |
| AC-f11fd716 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:760 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1e374bff | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:761 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-34c578ed | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:762 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ef81a2e0 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:763 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-a93e6303 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:764 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d560586b | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:765 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-8a3f64dc | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:766 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-4728389a | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:767 | try | FLAG | p_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5e12adba | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:768 | try | FLAG | p_step_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b8139d60 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:769 | try | FLAG | p_date_seq | pDateSeq | 화면 필드/플래그 변경 |  |  |  |
| AC-063c05f8 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:770 | try | FLAG | p_user_group_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0f5e76be | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:771 | try | FLAG | p_set_step | pSetDraftStep | 화면 필드/플래그 변경 |  |  |  |
| AC-7b488936 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:772 | try | FLAG | p_scp_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1e2c25da | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:773 | try | FLAG | p_draft_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ccef9d09 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:774 | try | FLAG | p_sync_plan_id | pSyncPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-34abac2e | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:779 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-fc2c9ec5 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:780 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d09af35d | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:782 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-02de5fc5 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:783 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1b20bf2f | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:784 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a9a83eb2 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:785 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6606c83 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:787 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f5ded18 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:788 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b8a878c | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:789 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-20b37563 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:790 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb441afd | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:791 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-db188125 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:792 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-502eadcc | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:793 | try | DATA_OP | req.Parameters["p_step_id"] | p_step_id | 행/컬럼 값 대입 |  |  |  |
| AC-b621e1a5 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:794 | try | DATA_OP | req.Parameters["p_date_seq"] | p_date_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d2c3ca59 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:795 | try | DATA_OP | req.Parameters["p_user_group_id"] | p_user_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef2406b2 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:796 | try | DATA_OP | req.Parameters["p_set_step"] | p_set_step | 행/컬럼 값 대입 |  |  |  |
| AC-09b2c31f | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:797 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-c97b2761 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:798 | try | DATA_OP | req.Parameters["p_draft_plan_id"] | p_draft_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-36e4d294 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:799 | try | DATA_OP | req.Parameters["p_sync_plan_id"] | p_sync_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e67a0f67 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:801 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ac900f4 | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:802 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-58c1463c | this.cboSyncPlanID.SelectionChangeCommitted | FP00590_WoWStatusPopup.cs:808 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

