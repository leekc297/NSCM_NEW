# AS-IS 액션 대조표 — SCP0113

> 원천: `Doc/asisfacts/screens/SCP0113/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1755행 · 메서드 126 · 종류 DATA_OP 749 · FLAG 276 · RETURN 203 · ENDPOINT 99 · UI_PROP 72 · GRID_INIT 62 · MESSAGE 50 · GRID_SET 47 · CALL_EXT 46 · UI_MISC 42 · POPUP 30 · COMBO_DATA 19 · GRID_LOCK 16 · STATE 13 · LIST_REBIND 13 · GRID_BIND 7 · VALUE_SET 4 · THROW 2 · VALIDATE 2 · CALL_BASE 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 48


## SCP0113_LongTermProcessPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe762e96 | .ctor | SCP0113_LongTermProcessPopup.cs:158 |  | FLAG | _sSite | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3194d571 | .ctor | SCP0113_LongTermProcessPopup.cs:159 |  | FLAG | _sPlanGroup | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0af3bc4a | .ctor | SCP0113_LongTermProcessPopup.cs:160 |  | FLAG | _sPlanDate | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-46ef660a | .ctor | SCP0113_LongTermProcessPopup.cs:161 |  | FLAG | _sPlanID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8d7c98b6 | .ctor | SCP0113_LongTermProcessPopup.cs:162 |  | FLAG | _sIsSamePlanID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fc565dd1 | .ctor | SCP0113_LongTermProcessPopup.cs:163 |  | FLAG | _sDescription | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermProcessPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b857d1a | this.btnClose.Click | SCP0113_LongTermProcessPopup.cs:3176 | if (blnReleaseRun == true) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-4cfa93c8 | this.btnClose.Click | SCP0113_LongTermProcessPopup.cs:3178 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermProcessPopup.btnCreatePlan_ClickAsync

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ae78f0d | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3226 | if (usrRadio3.Checked) | MESSAGE | MessageBox.Show | (message, "Process Data", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-2b0623f7 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3229 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-73302a23 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3230 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e23f07d | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3234 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_LGTM_MRP_P_RESULT") ⇒ SCP.PR_SCM_LGTM_MRP_P_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-e72aedb8 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3235 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3930e095 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3236 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_base_yyyymm"] | p_base_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-543f45be | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3237 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_mrp_version_id"] | p_mrp_version_id | 행/컬럼 값 대입 |  |  |  |
| AC-744e52f1 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3239 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | CALL_EXT | timer.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e51e4b77 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3240 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c8acc90 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3241 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | CALL_EXT | timer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d488ad71 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3243 | if (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-11a7efd6 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3270 | else of (usrRadio3.Checked) | MESSAGE | MessageBox.Show | (message, "Process Data", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-3d1fd59f | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3277 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-76d90488 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3278 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0fd7dd81 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3282 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_LGTM_INV_ALLOCATION_START") ⇒ SCP.PR_SCM_LGTM_INV_ALLOCATION_START | 엔드포인트 요청 생성 |  |  |  |
| AC-ef7c5445 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3283 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | UI_PROP | request.CommandTimeout | 60 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7c1c3b67 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3284 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_plan_tp_cd"] | arr[i] | 행/컬럼 값 대입 |  |  |  |
| AC-4cbab202 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3285 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef679eb2 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3286 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b5f2c7ca | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3287 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_base_yyyymm"] | p_base_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-d154bab0 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3288 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea45463b | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3289 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_chg_plan_start_yyyymmdd"] | p_chg_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-296b9bfa | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3290 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_mrp_version_id"] | p_mrp_version_id | 행/컬럼 값 대입 |  |  |  |
| AC-a30ebea4 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3291 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-693a2f10 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3293 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | CALL_EXT | timer.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fefa6f2c | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3294 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8df7bbdc | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3295 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | CALL_EXT | timer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2478753 | this.btnCreatePlan.Click | SCP0113_LongTermProcessPopup.cs:3297 | else of (usrRadio3.Checked) ▸ if (MessageBox.Show(message, "Process Data", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ for (i < arr.Leng… | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Check_CapaValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b57014f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3670 | if (dtInstance.Rows[0]["CAPA_VALIDATION"].ToString() != "Y") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5ed804b3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3690 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-615a2017 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3695 | if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-04c0c399 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3700 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CapaValidation", _sPlanGroup, _sPlanID, _sPlanDate, _sPlanE… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5290e89b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3732 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Check_ConfirmValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa910dc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3635 | if (dsValid_1 != null) ▸ if (dsValid_1.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cfca480a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3657 | if (dsValid_2 != null) ▸ if (dsValid_2.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-67a2a0b4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3661 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Check_Exec_IsRunningEngine

진입점: this.btnSearch.Click / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4be8e93b | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3450 | switch (sType) case "SELECT_INIT": | FLAG | p_division_id | CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d8bf7d0 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3454 | switch (sType) case "SELECT_INIT": | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA") ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-1a86acc2 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3455 | switch (sType) case "SELECT_INIT": | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-08e3ca31 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3456 | switch (sType) case "SELECT_INIT": | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bfed1f5c | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3460 | switch (sType) case "SELECT_INIT": | GRID_BIND | siMain.Query | (client.ExecuteDataSet(request).DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f13d7ed1 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3460 | switch (sType) case "SELECT_INIT": | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29823706 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3461 | switch (sType) case "SELECT_INIT": | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-37a2a433 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3464 | switch (sType) case "SELECT_INIT": | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-01357e39 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3467 | switch (sType) case "SELECT_INIT": | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34f47d10 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3475 | switch (sType) case "SELECT_INIT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47404b2b | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3476 | switch (sType) case "SELECT_INIT": ▸ if (dtIsRunRelease != null) ▸ if (dtIsRunRelease.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-661b963f | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3502 | switch (sType) case "CREATE": ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-dd66988f | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3507 | switch (sType) case "CREATE": | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0766cbf5 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3528 | switch (sType) case "DELETE": ▸ if (ds1 != null) ▸ else of (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-55e9d9e1 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3534 | switch (sType) case "DELETE": | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-09cb0510 | this.btnSearch.Click 외 1 | SCP0113_LongTermProcessPopup.cs:3537 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Check_isConfirmed

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad656986 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3572 | if (iCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isConfirmed", p_sql) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20c3a95f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3593 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ if (dtConfirm.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2854ae7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3594 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ if (dtConfirm.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-64508f6d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3598 | if (iCount > 0) ▸ if (dtConfirm != null) ▸ else of (dtConfirm.Rows.Count > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-20695497 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3603 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Check_IsPastDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cad78268 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3740 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isPast", _sSite, _sPlanGroup, _sPlanDate) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38b9599d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3747 | if (dtPastdate != null) ▸ if (dtPastdate.Rows.Count > 0) ▸ if (dtPastdate.Rows[0]["DATE_VALID"].ToString() == "Y") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-91f52fc2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3753 | if (dtPastdate != null) ▸ if (dtPastdate.Rows.Count > 0) ▸ else of (dtPastdate.Rows[0]["DATE_VALID"].ToString() == "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-74df6fab | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3759 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.chkStatus_CheckedChanged

진입점: this.chkStatus.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47d3483d | this.chkStatus.CheckedChanged | SCP0113_LongTermProcessPopup.cs:3329 | if (chkStatus.Checked == false) | STATE | cboPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-601785e3 | this.chkStatus.CheckedChanged | SCP0113_LongTermProcessPopup.cs:3333 | else of (chkStatus.Checked == false) | STATE | cboPlanDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0113_LongTermProcessPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baa6c89e | this.Load | SCP0113_LongTermProcessPopup.cs:318 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e6a1495 | this.Load | SCP0113_LongTermProcessPopup.cs:319 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d8e79c7 | this.Load | SCP0113_LongTermProcessPopup.cs:324 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1551bd02 | this.Load | SCP0113_LongTermProcessPopup.cs:325 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0113_LongTermProcessPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74a89cb5 | this.Load | SCP0113_LongTermProcessPopup.cs:312 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0113_LongTermProcessPopup.Delete_Is_Running_Release

진입점: this.btnSearch.Click [switch (sType) case "DELETE":] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f362617 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2249 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-16ea6c11 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2250 | try | FLAG | p_sys_flag | "DELETE_RUNNING_RELEASE" | 화면 필드/플래그 변경 |  |  |  |
| AC-0ab98a8a | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2251 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2def44b5 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2252 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-68d67954 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2253 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-cd575492 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2255 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0277d329 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2259 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-65dbd912 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2260 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f5050cc4 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2262 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-05cd89ac | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2263 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6a952a33 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2264 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-49ff4700 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2265 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2cce01b4 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2267 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6953940 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2268 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1aed8e26 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2269 | try | DATA_OP | req.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-5d9da158 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2270 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc77c8dd | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2271 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1337eec | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2272 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-30a78c6e | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2273 | try | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f256751d | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2274 | try | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c522fc25 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2275 | try | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc396cf1 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2276 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-739ead68 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2277 | try | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dde4539c | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2278 | try | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9718e93c | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2279 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eadc5950 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2280 | try | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a0c53d2d | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2281 | try | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5254373 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2282 | try | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4157e3d | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2283 | try | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-794fdaae | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2284 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-271c0711 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2285 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-971bc4b6 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2287 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b801af80 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2288 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b640da24 | this.btnSearch.Click [switch (sType) case "DELETE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2294 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0137bca | Dispose | SCP0113_LongTermProcessPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_MES_ERP_WO_MASTER

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b081ee54 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2634 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-60573a6e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2641 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-160bdd77 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2641 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bcb61250 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2643 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-1b13c786 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2644 | try | FLAG | p_sys_flag | "EXECUTE_MES_ERP_WO_MASTER" | 화면 필드/플래그 변경 |  |  |  |
| AC-1d873c1e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2645 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8d969119 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2646 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-c5021bb0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2659 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-e81e0db7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2660 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-16914519 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2662 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-bfe44569 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2663 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1f175c3c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2664 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-970e1c02 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2665 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c525f2f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2667 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed1eb78b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2668 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c0c83df | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2669 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-144fd786 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2670 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-266d49dc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2671 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-71036d00 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2672 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-159f7611 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2673 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9dd8d24 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2674 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d23b0f0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2675 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e46fd07 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2676 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9aa54ac | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2677 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e523949 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2678 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2efe320a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2679 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85808766 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2680 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3de11ae6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2681 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c0b64576 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2682 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-957cd70a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2683 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9cdd474f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2684 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-103bac48 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2685 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-497f9081 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2687 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02e0bd97 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2693 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c199c89f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2698 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_PR_SCM_OF_ASSY_ELEC_REPORT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce8c74fb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2806 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-e33998d6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2807 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-af4da193 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2808 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-1b012c4b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2809 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ac3116ab | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2810 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c315a3d8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2812 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89c992b9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2813 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f8af96b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2814 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6cab8340 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2815 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-5108c796 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2816 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3fffc233 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2817 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4b6b1c27 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2818 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e0633a14 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2819 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-80903470 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2820 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf380e17 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2821 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-71ab852a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2822 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-27c30588 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2823 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-09691383 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2824 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-783848cd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2825 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c24af1f1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2826 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-39449c70 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2827 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-921f4f0a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2828 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f5afd40 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2829 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec256361 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2830 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-8434c56b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2832 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-123e0f5d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2834 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-32e8ac1f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2839 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_PR_SCM_OF_CELL_DELIVERY_PLAN

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c26d97c4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3020 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-151c6f4d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3024 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-6cae2661 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3025 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-011eb6a2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3026 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN" | 행/컬럼 값 대입 |  |  |  |
| AC-2bc98ceb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3027 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-488dcc78 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3028 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7c356dbb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3030 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e37fb92c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3031 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-14ad2273 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3032 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6477fcda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3033 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-d5299dc6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3034 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b1a8ec3f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3035 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7b2c4d70 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3036 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c9cf578b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3037 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-20b7b50e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3038 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95a22455 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3039 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99c41dd9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3040 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5a006d1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3041 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b1379d25 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3042 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-61e93ca0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3043 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1696a310 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3044 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf0e592e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3045 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eddca6a8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3046 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3569d053 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3047 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74d5638a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3048 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1adb9752 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3050 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2175d20e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3052 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-70d0f1cb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3057 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_PR_SCM_OF_PACK_REQUIRE_CEL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb3a1da3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2864 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1f92c2fa | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2868 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-7bb3569b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2869 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-06b44e2c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2870 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL" | 행/컬럼 값 대입 |  |  |  |
| AC-c14f874d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2871 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6756a93d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2872 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-94667a28 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2874 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e6cfbc69 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2875 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-932d066a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2876 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1937160 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2877 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-10dc4eca | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2878 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-980df78e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2879 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-283c5206 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2880 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84c9e821 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2881 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfb98a99 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2882 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-675e1781 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2883 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d4d6222 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2884 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de5154af | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2885 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-371a8cef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2886 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d52be40 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2887 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea60b6c3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2888 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a139cb5d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2889 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbe429ff | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2890 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-77721103 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2891 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2ba8cf24 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2892 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-db696c1c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2894 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0050bd0a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2896 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6cd06a4c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2901 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_PR_SCM_OF_PACK_TO_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ae1d162 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2930 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5f6820f3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2937 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-5381dad8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2937 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92ff5887 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2939 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-caf003fe | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2940 | try | FLAG | p_sys_flag | "EXECUTE_PR_SCM_OF_PACK_TO_CELL" | 화면 필드/플래그 변경 |  |  |  |
| AC-bf5e9577 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2941 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6917210a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2942 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-5fe4a77b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2957 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-c480acef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2958 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dc4aef00 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2960 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-723c1b81 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2961 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-03f407a6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2962 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f6ff2402 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2963 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-152eda1d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2965 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ecf1d42f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2966 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a68beab4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2967 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8e42869 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2968 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-42e43776 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2969 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bca6b9e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2970 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-0fc64676 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2971 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-155603fc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2972 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3405a5c9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2973 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef54e479 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2974 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e0967a39 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2975 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-db340e72 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2976 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7fb75cd5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2977 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50bb614f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2978 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-939077e8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2979 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6984c4a3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2980 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-02bf37ef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2981 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c7bc2f9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2982 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e4b2bb99 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2983 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-7b6a5d22 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2985 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c7c61e3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2991 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e583462a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2996 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_PR_SCM_PIC_ALARM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e4fb387 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3093 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "INSTANCE_OPTION", _sSite, _sPlanGroup, _sPlanDate, _sPlanID, sFactory_LT… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6646e9dd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3095 | try ▸ if (dtTmp.Rows[0]["PIC_ALARM"].ToString() != "Y") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b7bcf9a7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3097 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-16cb51ef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3098 | try | FLAG | p_sys_flag | "PR_SCM_PIC_ALARM" | 화면 필드/플래그 변경 |  |  |  |
| AC-ea646c9c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3099 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2e4c6e6d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3100 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-5e583e6b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3113 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-6d4ce442 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3114 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-031007bc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3116 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ae1ccb1b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3117 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b5abc260 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3118 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-16cc2db1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3119 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-802806bf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3121 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7315f1d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3122 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3c6c1e69 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3123 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d94b7e57 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3124 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-5b01d4b2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3125 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e020d903 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3126 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-b7ff76cc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3127 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-13feeba1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3128 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de7c0670 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3129 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad07370a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3130 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8bdeeaa3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3131 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-31ed6437 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3132 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a26a7a27 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3133 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5613eda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3134 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-72904397 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3135 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e01c681 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3136 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-185bb309 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3137 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d66d679 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3138 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2f021de | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3139 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ebc93520 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3141 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94635c84 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3147 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6a272573 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3152 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_Release_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34893f6a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1223 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ if (dsResult.Tables[idx].Rows.Count > 0) ▸ else of … | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-c32202d9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1225 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ if (dsResult.Tables[idx].Rows.Count > 0) ▸ else of … | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-9bf47026 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1233 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ else of (dsResult.Tables[idx].Rows.Count > 0) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-23c8dff4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1235 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ if (dsResult != null) ▸ else of (dsResult.Tables[idx].Rows.Count > 0) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-da117098 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1245 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ else of (dsResult != null) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-9b70d856 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1247 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (bFirst == true) ▸ else of (dsResult != null) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-ab0348c0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1265 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsAll != null) ▸ if (dsAll.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-143532d0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1268 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ if (dsAll != null) ▸ if (dsAll.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-6d5bf1eb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1302 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (Find_Duplicate_Check(sInstance, sFactory) == false) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-b4e9cdf3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1320 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (dsRelease != null) ▸ if (dsRelease.Tables[0].Rows[0][0].ToString() != "0") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-ad134ec5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1322 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (dsRelease != null) ▸ if (dsRelease.Tables[0].Rows[0][0].ToString() != "0") | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-1dd0428f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1329 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ else of (dsRelease != null) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-89376f3d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1330 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ else of (dsRelease != null) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-c2b77324 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1346 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ try ▸ if (dsSendMail != null) ▸ if (dsSendMail.Tables[0].Rows[0][0].ToString() != "1") | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-2f2c67af | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1356 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ catch ((Exception ex2)) | MESSAGE | MessageBox.Show | (ex2.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-7b27f48e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1357 | try ▸ for (k <= siMain.GetMaxRowIndex()) ▸ catch ((Exception ex2)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-00110eec | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1363 | try ▸ if (iCount == 0) | MESSAGE | MessageBox.Show | ("Please, check row!. Check Row Count is Zero!", "Warning", MessageBoxButtons.OK, MessageB… | 메시지 표시 |  |  |  |
| AC-f3633fb9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1364 | try ▸ if (iCount == 0) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |
| AC-3784f5f9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1377 | try ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() == "F") | RETURN | return "PROCEED"; |  | 처리 중단/반환 |  |  |  |
| AC-ce859512 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1381 | try | RETURN | return "PROCEED"; |  | 처리 중단/반환 |  |  |  |
| AC-3c4455ed | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1386 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-244f6eb9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1387 | catch ((Exception ex)) | RETURN | return "STOP"; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_Release_Plan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ee72077 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1574 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-bfa9ac09 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1575 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-5d68116d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1576 | try | FLAG | p_sys_flag | "EXECUTE_RELEASE" | 화면 필드/플래그 변경 |  |  |  |
| AC-d24c80f0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1577 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-84d2abf2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1578 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-5d40d694 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1579 | try | FLAG | p_division_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a30a38 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1580 | try | FLAG | p_site_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-24f43c28 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1581 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5662144d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1582 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e051fe9f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1583 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e21b907 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1584 | try | FLAG | p_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f509ad8c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1585 | try | FLAG | p_flag | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FLAG)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-28da2db0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1586 | try | FLAG | p_insert_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSERT_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-571093b2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1587 | try | FLAG | p_release_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.RELEASE_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e6c0f6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1588 | try | FLAG | p_is_enable_rel | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0690467d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1589 | try | FLAG | p_confirm_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-324d4192 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1590 | try | FLAG | p_confirm_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-44fd91d9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1591 | try | FLAG | p_description | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-94c87d08 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1592 | try | FLAG | p_isenable | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISENABLE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-03d8756c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1593 | try | FLAG | p_ischk | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISCHK)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a1e1c8c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1594 | try | FLAG | p_next_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-2af0b5c5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1595 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-25cb3f2f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1599 | try | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-147ae505 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1599 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f2780e9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1606 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5221b38 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1609 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-02749801 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1609 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5d3cec9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1613 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-470be3c9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1616 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ if (dtResult.Rows.Count > 0) | FLAG | p_plan_type | dtResult.Rows[0]["PLAN_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-58b58158 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1618 | try ▸ if (dtPlanID != null) ▸ if (dtPlanID.Rows.Count > 0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9c0a655f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1622 | try ▸ if (dtPlanID != null) ▸ else of (dtPlanID.Rows.Count > 0) | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3011b393 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1628 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-a1593eff | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1629 | try | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ffc8bc72 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1631 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a50f00a8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1632 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-db618bfd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1633 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-2f626ce2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1634 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-11b6659b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1636 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ba26b29b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1637 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7355bc0e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1638 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-544a02db | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1639 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-89b5a0ae | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1640 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-6a18f897 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1641 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2491e734 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1642 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-90113cf3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1643 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-6ecd54da | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1644 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-0d0488e9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1645 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-3bdcc085 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1646 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c068d8b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1647 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-abd1d710 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1648 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-da0a6eb7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1649 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-0ac99722 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1650 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-4c04ceb3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1651 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a4c00b3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1652 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-382d2783 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1653 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-1332bcc7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1654 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-85d9b7a6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1656 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e88f534 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1657 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bb605c49 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1664 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-a5d05788 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1665 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_Release_Queue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4912c694 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1113 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-877f8d9b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1114 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-21d5344c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1116 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-40605a24 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1117 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ebf81a0d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1118 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9a84b441 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1119 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-980edcb2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1121 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-84955b40 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1122 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b54fba8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1123 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0d7f5cb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1124 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-faebe029 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1125 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b5f70946 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1126 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d177a392 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1127 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ae3e3477 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1128 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-f53be824 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1129 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-dd41cff2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1130 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-33827cde | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1131 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-96b6b0fc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1132 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-899b36cf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1133 | try | DATA_OP | req.Parameters["p_description"] | p_description.Replace("'", "''") | 행/컬럼 값 대입 |  |  |  |
| AC-589cc307 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1134 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-4d7ac8bd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1135 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-11137488 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1136 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-3d2e01a8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1137 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f6e23e04 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1138 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ed3a9fb5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1139 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b1488f69 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1141 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32a94701 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1142 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-401000cf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1150 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_RollBack_Release

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80520109 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1841 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-9fc4d2e1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1842 | try | FLAG | p_sys_flag | pSysFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-82ee7055 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1843 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2c6845af | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1844 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-f518eb54 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1845 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d43abcde | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1846 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-1e92208f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1847 | try | FLAG | p_factory_id | sFactory_LT | 화면 필드/플래그 변경 |  |  |  |
| AC-3b5f815d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1848 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-2c10b67b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1849 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-61a56766 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1850 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-7898cf10 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1851 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-97421861 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1852 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-13a32cdd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1853 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f9c92624 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1854 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8b8d12c9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1855 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-120cddbd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1856 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9641cc66 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1857 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-82e9022e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1858 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-395f0b2b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1859 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-37aae1c3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1860 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e0b89091 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1861 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c7874486 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1862 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6ad64dc4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1866 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-c7a91197 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1867 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1f18f75c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1869 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f7514822 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1870 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-51bbd351 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1871 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f865331f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1872 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2df701a0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1874 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-64b544b1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1875 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-de163a73 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1876 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-203c060f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1877 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d12bc97 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1878 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-8383761a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1879 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c5eec0e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1880 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2dcb3eae | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1881 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-0905b42d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1882 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-b43723ee | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1883 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-9715fa31 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1884 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee3619d9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1885 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-c82f6e6d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1886 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-07f3624c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1887 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-87d2d6d9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1888 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-9a9211f2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1889 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-19af1303 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1890 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-396737dc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1891 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-40a3457b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1892 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-f1bb2816 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1894 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eab1b4b8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1895 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-408612e8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1902 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_Send_Mail_Quantity_Check

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c375a25 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1680 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-3f22d15f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1681 | try | FLAG | p_sys_flag | "EXECUTE_SENDMAIL_QUANTITY_CHECK" | 화면 필드/플래그 변경 |  |  |  |
| AC-0ff24c02 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1682 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-106373e6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1683 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4515cc6e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1684 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec1049bc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1685 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7178b1f4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1686 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-32dabbb8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1691 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-28aba0a0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1692 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fd6608ea | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1694 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3b25d5c0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1695 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4f732c34 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1696 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-8f4cffb7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1697 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3facc9ac | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1699 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c534ace8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1700 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-86a0cad4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1701 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-5894e4fc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1702 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-597527c4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1703 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-399a6367 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1704 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-417c8712 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1705 | try | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5130a1be | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1706 | try | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f0b3d51c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1707 | try | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57d5dfbf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1708 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f6477143 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1709 | try | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a08265ed | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1710 | try | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-021eb08c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1711 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1cbe0a89 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1712 | try | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c1690f4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1713 | try | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bbcab476 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1714 | try | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be694613 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1715 | try | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4198cb97 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1716 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-252f1f70 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1717 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-0f36a3c8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1719 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-817eebf2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1720 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1196935b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1727 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-8467ab33 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1728 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_Send_SMS

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1431d975 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2540 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7e0bc9ac | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2547 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-924cb3c0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2547 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-291da5b2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2549 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-b83225f3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2550 | try | FLAG | p_sys_flag | "EXECUTE_SMS" | 화면 필드/플래그 변경 |  |  |  |
| AC-9d988623 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2551 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6c998967 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2552 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-2b38613f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2568 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-57820cf1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2569 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3c23b8b0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2571 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d44312b7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2572 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2d555f5f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2573 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e16f08fb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2574 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5fdf142 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2576 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f72ef74a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2577 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e728638b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2578 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | sFacoty | 행/컬럼 값 대입 |  |  |  |
| AC-4286a3a5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2579 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-3f3c18ac | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2580 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-08aa3105 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2581 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-6ba45c73 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2582 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f476d22 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2583 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a3de5c4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2584 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-face7b15 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2585 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c82cd0fe | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2586 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-131fb03b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2587 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4593ad4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2588 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9632b750 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2589 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2952f8c4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2590 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d241612 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2591 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c70664a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2592 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad1e2cad | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2593 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e1661aa | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2594 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-5a673075 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2596 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad8b77cc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2602 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-bb55cd8c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2607 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Exec_SendMail_FinalTotal

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a1fcd2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2389 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-ddce8a6a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2390 | try | FLAG | p_sys_flag | "EXECUTE_RELEASE_PLAN_SEND" | 화면 필드/플래그 변경 |  |  |  |
| AC-0da2bd82 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2391 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1f08e9a4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2392 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-13254fb6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2411 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-13c3fa2a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2412 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-91cfdb47 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2414 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3e3bfd03 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2415 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-84f1e80d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2416 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-b68b8016 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2417 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-65f1c219 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2419 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d9ace3e5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2420 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1e54cf30 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2421 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_factory_id"] | sFacoty | 행/컬럼 값 대입 |  |  |  |
| AC-eea948ac | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2422 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-a8b408f8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2423 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-3086d7fe | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2424 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-393c990b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2425 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-700497c6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2426 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d34bc232 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2427 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8896d93e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2428 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9aa637f7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2429 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe21dc8e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2430 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3e8313d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2431 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_description"] | sDescription | 행/컬럼 값 대입 |  |  |  |
| AC-5b39d833 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2432 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65ba8c0b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2433 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8c36a69 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2434 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c570f81 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2435 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51f88604 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2436 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf8d6df3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2437 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-9852a70e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2439 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b7d2e90 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2445 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-35c75829 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2450 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Execute_Calcuration

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a7034c4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1422 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-f38e326f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1423 | try | FLAG | p_sys_flag | "EXECUTE_CALCURATION" | 화면 필드/플래그 변경 |  |  |  |
| AC-5f99f2f3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1424 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1237a15c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1425 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-df009340 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1426 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0a53033f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1427 | try | FLAG | p_site_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f74993e8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1428 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-49d06a86 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1429 | try | FLAG | p_instance_id | pPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-00085fc9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1430 | try | FLAG | p_plan_date | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-55e024db | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1431 | try | FLAG | p_plan_id | pPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-5d19ae45 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1432 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e29939b0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1433 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-90017b19 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1434 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ae987c57 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1435 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e405f39c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1436 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a16225d7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1437 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c7591890 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1438 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4b868145 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1439 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-88a6a4d6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1440 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-366949b1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1441 | try | FLAG | p_next_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-104ffc92 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1442 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-05d9a9a4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1443 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4de000db | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1448 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-2ba50eca | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1449 | try | UI_PROP | req.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8a307803 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1451 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b1ac7ef7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1452 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f26d6c59 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1453 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-49cac5b0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1454 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-03bdb8b6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1456 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b08c5075 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1457 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-de17635c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1458 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b6a0ae1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1459 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-17b98daa | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1460 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-78a7c26d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1461 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-69d7c7fc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1462 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-55a7795a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1463 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-1f481add | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1464 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-61409345 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1465 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-d7c45ad4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1466 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-5dee05e9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1467 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-53979c28 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1468 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-d0c32406 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1469 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-66d14840 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1470 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-643b2372 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1471 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-c575c880 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1472 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e5b464c6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1473 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-847d48a5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1474 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e6a1458f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1476 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51c4a92b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1477 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-16311d7d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1483 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-4302ab64 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1484 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Find_Confirm_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-978942b9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2306 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7eef59ee | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2311 | try ▸ if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a63a49c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2324 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToString(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK))) == "True" && !str… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-70c26ea8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2336 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-038ea18e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2340 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-fea0db1a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2341 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-8b87022c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2342 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-3ee86a31 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2343 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-429156f0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2344 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fbbd3494 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2346 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-17be03a3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2347 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-90b5fdd6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2348 | try | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-b7d51772 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2349 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-21a16456 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2350 | try | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-770a0e14 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2351 | try | DATA_OP | request.Parameters["p_plan_id"] | _sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-5a83e7ee | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2352 | try | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d626523 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2353 | try | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2b4019a0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2354 | try | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2ff7ac0d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2355 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6994403e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2356 | try | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-81ee1b8e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2357 | try | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e9dadfc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2358 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-871b9d59 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2359 | try | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-64941423 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2360 | try | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d203635b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2361 | try | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-383ef5f2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2362 | try | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3405da83 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2363 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c4904ac1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2364 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-4eebb6e5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2366 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bbe27ed | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2368 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-46d9d8ba | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2373 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Find_Data_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd58f8dc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:514 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-4ccca02e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:515 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-de8c840a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:516 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_RELEASE_TOTAL" | 행/컬럼 값 대입 |  |  |  |
| AC-e2887e41 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:517 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-83ca0638 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:518 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dcfdc10c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:520 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0c1f42e6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:521 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-773741e2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:522 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31a18042 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:523 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-15fc42c6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:524 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-75c52ad4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:525 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-6b68e353 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:526 | try | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b2a10e5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:527 | try | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7771aa43 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:528 | try | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5041e27f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:529 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-774a68aa | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:530 | try | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f5810e1d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:531 | try | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4a00a1da | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:532 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6a61a059 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:533 | try | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-eaa048eb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:534 | try | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a07e4c68 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:535 | try | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-63bbe043 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:536 | try | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1dd27f47 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:537 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31d84266 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:538 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ce1e3b95 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:540 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b8b2c62 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:542 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-07b00e2c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:547 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Find_Duplicate_Check

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2015d5cc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1396 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_dupReleaseCheck", pInstanceId, pFactoryId) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93a50649 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1403 | if (dtDuplication.Rows.Count > 0) | MESSAGE | MessageBox.Show | (sMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-dd3680d2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1409 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Find_Release_Plan_List_2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-257889b7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2117 | try ▸ if (iCount > 0) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList2", _sSite, _sPlanGroup, _sPlanDate, _sPlanI… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7f35548 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2124 | try ▸ if (iCount > 0) | RETURN | return dtReleasePlanList2; |  | 처리 중단/반환 |  |  |  |
| AC-1bd29078 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2128 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8bc0c431 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2133 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Find_Release_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc94e207 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1741 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_PLANWEEK_DATE", _sPlanGroup, _sPlanDate) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a83ecbda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1746 | try ▸ if (dtEndDate != null) ▸ if (dtEndDate.Rows.Count > 0) | FLAG | _sPlanEndDate | dtEndDate.Rows[0]["END_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea11cd31 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1777 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-7c2b79f8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1778 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-81f78df0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1779 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-fc29b3fe | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1780 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-81ce3faf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1781 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-10e7950c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1783 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3746a496 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1784 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0ca3ed2e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1785 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-51a38f4d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1786 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-0a31b84e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1787 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-c8127a59 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1788 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_id"] | sPlanID_LT | 행/컬럼 값 대입 |  |  |  |
| AC-69a7bea5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1789 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-26461582 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1790 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_insert_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f76b4a96 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1791 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_release_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-474da012 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1792 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_is_enable_rel"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d729fcb9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1793 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a710d2a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1794 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_time"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-325730d4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1795 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-20af8471 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1796 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_isenable"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-914e7cbb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1797 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_ischk"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3979258a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1798 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_next_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4cd85a41 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1799 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_release_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ac26501b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1800 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ea5533cb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1801 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e8e34e92 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1803 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-15ae6548 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1805 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4c26785b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1810 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-09a53790 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1815 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.FindData_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a36fd7d2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:431 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2b1a76bc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:437 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1b7828e2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:437 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97224656 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:442 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8c5f8161 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:445 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a220830f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:451 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7a4bfd39 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:453 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Sub("SELECT", pSite, pPlanGroup, pPlanDate, pPlanID) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70d670e3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:461 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-be3545b1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:466 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8e5d55f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:475 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-03e85f88 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:478 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c81053c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:485 | try ▸ if (ds != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a1f446b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:489 | try ▸ if (ds != null) ▸ for (i < row_count) | GRID_SET | siMain.ActiveSheet.Rows[i].Height | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-1a726037 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:498 | catch () | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a37baaab | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:502 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermProcessPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b6680bc | this.Load | SCP0113_LongTermProcessPopup.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd941d23 | this.Load | SCP0113_LongTermProcessPopup.cs:176 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0113_LongTermProcessPopup.Get_FactoryDescription

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9073ab98 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3776 |  | RETURN | return sRtnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.GetMrpVersionComboBox

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1141310f | this.Load [try] | SCP0113_LongTermProcessPopup.cs:303 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-4950e8fb | this.Load [try] | SCP0113_LongTermProcessPopup.cs:305 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2c745f7 | this.Load [try] | SCP0113_LongTermProcessPopup.cs:305 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.GetPlanDateComboBox

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-343b7172 | this.Load [try] | SCP0113_LongTermProcessPopup.cs:293 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-2db438d4 | this.Load [try] | SCP0113_LongTermProcessPopup.cs:295 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d51fef9c | this.Load [try] | SCP0113_LongTermProcessPopup.cs:295 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ead5753e | this.Load | SCP0113_LongTermProcessPopup.cs:229 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a8f4113 | this.Load | SCP0113_LongTermProcessPopup.cs:231 | try | VALUE_SET | drpPlanDate.InitValue | DateTime.Today.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-889072a6 | this.Load | SCP0113_LongTermProcessPopup.cs:235 | try | FLAG | dtMyDivision | BLUtils.GetDivisionWithoutEE(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-041fb8a5 | this.Load | SCP0113_LongTermProcessPopup.cs:235 | try | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f34c9747 | this.Load | SCP0113_LongTermProcessPopup.cs:236 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2721651d | this.Load | SCP0113_LongTermProcessPopup.cs:238 | try | FLAG | dtPlantByGroupAll | Data_SCP.CommonAll(Data_SCP.Type.PlantByGroup1, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-babe39dd | this.Load | SCP0113_LongTermProcessPopup.cs:238 | try | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlantByGroup1, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf0c9b04 | this.Load | SCP0113_LongTermProcessPopup.cs:239 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroupAll, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-32afdd53 | this.Load | SCP0113_LongTermProcessPopup.cs:242 | try | VALUE_SET | monthPicker.InitValue | initValue | 컨트롤 값 설정 |  |  |  |
| AC-09f9e68d | this.Load | SCP0113_LongTermProcessPopup.cs:245 | try | FLAG | dtItemType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-cd702850 | this.Load | SCP0113_LongTermProcessPopup.cs:246 | try | DATA_OP | dtItemType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf7caddb | this.Load | SCP0113_LongTermProcessPopup.cs:247 | try | DATA_OP | dtItemType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba935d32 | this.Load | SCP0113_LongTermProcessPopup.cs:248 | try | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0a57df79 | this.Load | SCP0113_LongTermProcessPopup.cs:249 | try | DATA_OP | dataRow["CODE"] | DefItemType.CODE_1_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-6f07c5c1 | this.Load | SCP0113_LongTermProcessPopup.cs:250 | try | DATA_OP | dataRow["NAME"] | DefItemTypeName.CODE_1_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-7822a01c | this.Load | SCP0113_LongTermProcessPopup.cs:251 | try | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-24f6b8fe | this.Load | SCP0113_LongTermProcessPopup.cs:252 | try | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eed65685 | this.Load | SCP0113_LongTermProcessPopup.cs:253 | try | DATA_OP | dataRow["CODE"] | DefItemType.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-0f918e25 | this.Load | SCP0113_LongTermProcessPopup.cs:254 | try | DATA_OP | dataRow["NAME"] | DefItemTypeName.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-36c832ba | this.Load | SCP0113_LongTermProcessPopup.cs:255 | try | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a9d4bb8 | this.Load | SCP0113_LongTermProcessPopup.cs:256 | try | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e10346cf | this.Load | SCP0113_LongTermProcessPopup.cs:257 | try | DATA_OP | dataRow["CODE"] | DefItemType.CODE_3_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-ca947879 | this.Load | SCP0113_LongTermProcessPopup.cs:258 | try | DATA_OP | dataRow["NAME"] | DefItemTypeName.CODE_3_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-9a467de5 | this.Load | SCP0113_LongTermProcessPopup.cs:259 | try | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8d1dda0 | this.Load | SCP0113_LongTermProcessPopup.cs:260 | try | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd7e3af | this.Load | SCP0113_LongTermProcessPopup.cs:261 | try | DATA_OP | dataRow["CODE"] | DefItemType.CODE_4_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-317a2f12 | this.Load | SCP0113_LongTermProcessPopup.cs:262 | try | DATA_OP | dataRow["NAME"] | DefItemTypeName.CODE_4_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-b66006c1 | this.Load | SCP0113_LongTermProcessPopup.cs:263 | try | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0227436 | this.Load | SCP0113_LongTermProcessPopup.cs:265 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-df0d580e | this.Load | SCP0113_LongTermProcessPopup.cs:268 | try | FLAG | dtPlanDate | GetPlanDateComboBox() | 화면 필드/플래그 변경 |  |  |  |
| AC-6f2201f9 | this.Load | SCP0113_LongTermProcessPopup.cs:269 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-76d01aed | this.Load | SCP0113_LongTermProcessPopup.cs:273 | try ▸ if (chkStatus.Checked == false) | STATE | cboPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-55eacf60 | this.Load | SCP0113_LongTermProcessPopup.cs:277 | try | FLAG | dtMrpVersion | GetMrpVersionComboBox() | 화면 필드/플래그 변경 |  |  |  |
| AC-a48381cb | this.Load | SCP0113_LongTermProcessPopup.cs:278 | try | LIST_REBIND | clsCtrl.setListBox | (dtMrpVersion, cboMrpVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-48cc7c7c | this.Load | SCP0113_LongTermProcessPopup.cs:280 | try | FLAG | timer | new System.Timers.Timer() | 화면 필드/플래그 변경 |  |  |  |
| AC-f9737242 | this.Load | SCP0113_LongTermProcessPopup.cs:281 | try | UI_PROP | timer.Interval | 15 * 1000 | 속성 Interval 설정 |  |  |  |
| AC-2bd437ca | this.Load | SCP0113_LongTermProcessPopup.cs:285 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## SCP0113_LongTermProcessPopup.Insert_Hist_Detail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36052c78 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2475 | try ▸ if (bCheck == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a521edc2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2479 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-4d88d13a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2480 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-f1036b9b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2481 | try | DATA_OP | request.Parameters["p_sys_flag"] | "INSERT_HIST_DETAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-43597c49 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2482 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d67ff162 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2483 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-177d2465 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2485 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8c06047 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2486 | try | DATA_OP | request.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-b50aea74 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2487 | try | DATA_OP | request.Parameters["p_factory_id"] | sFactory_LT | 행/컬럼 값 대입 |  |  |  |
| AC-ed6e891e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2488 | try | DATA_OP | request.Parameters["p_instance_id"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-bb25528d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2489 | try | DATA_OP | request.Parameters["p_plan_date"] | _sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-ea940ad8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2490 | try | DATA_OP | request.Parameters["p_plan_id"] | _sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-fd6cf6e5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2491 | try | DATA_OP | request.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f3421db8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2492 | try | DATA_OP | request.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e4f9a3a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2493 | try | DATA_OP | request.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-26a8ad22 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2494 | try | DATA_OP | request.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a478dd75 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2495 | try | DATA_OP | request.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5eacfcc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2496 | try | DATA_OP | request.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03c567e3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2497 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7ece0651 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2498 | try | DATA_OP | request.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45c8b6f0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2499 | try | DATA_OP | request.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f636922 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2500 | try | DATA_OP | request.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8ddf06b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2501 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b80677b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2502 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99fee211 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2503 | try | DATA_OP | request.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-8c347c15 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2505 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4cdeab63 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2507 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-efb6b969 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2512 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Insert_Is_Running_Release

진입점: this.btnSearch.Click [switch (sType) case "CREATE":] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-270baa4c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2188 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-2dbcfd2d | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2189 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-23263c3c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2191 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9957d532 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2192 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2c493949 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2193 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5a445936 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2194 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-813d6673 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2196 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd263af0 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2197 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-52a195ce | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2198 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f6a1aee | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2199 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-43921b3c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2200 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-4e3d76ad | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2201 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f574e21 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2202 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cb7665ff | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2203 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-416c252c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2204 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-5103bec1 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2205 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-3b633499 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2206 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a41af66 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2207 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-6c453a74 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2208 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-2069fe08 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2209 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-f1d76896 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2210 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-a602cc1c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2211 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ddc7d96 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2212 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0d3489df | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2213 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-96bed164 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2214 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-2a82c433 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2216 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8e826205 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2217 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8c0941ff | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:2223 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Insert_OT_NET_JOB

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fc85a7d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2720 | try | FLAG | dtReleasePlanList | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_ReleasePlanList", _sS… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-3c85eed0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2720 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_ReleasePlanList", _sSite, _sPlanGroup, _sPlanDate, _sPlanID… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-523bceb1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2722 | try | FLAG | p_sys_type | "SELECT" | 화면 필드/플래그 변경 |  |  |  |
| AC-49feb19d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2723 | try | FLAG | p_sys_flag | "INSERT_OT_NET_JOB" | 화면 필드/플래그 변경 |  |  |  |
| AC-03a6b4e5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2724 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ab1f2fc8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2725 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-ccaa4db7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2741 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-2fe69ae5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2742 | try ▸ for (i < dtReleasePlanList.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3619e509 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2744 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b1bd99da | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2745 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3ef766c2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2746 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-49196ba0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2747 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d34bc14f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2749 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5909590 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2750 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93d9ad6d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2751 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e6ef00ca | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2752 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | sInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-0a848a6c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2753 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-9e4a3aef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2754 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_id"] | sReleasePlanID | 행/컬럼 값 대입 |  |  |  |
| AC-e72bf283 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2755 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-08ca5ef1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2756 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_insert_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1cb49855 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2757 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c2af24cf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2758 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_is_enable_rel"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3d4131e7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2759 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec1dcae2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2760 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_confirm_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f3644e3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2761 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa94062e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2762 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_isenable"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f9bb2ef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2763 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_ischk"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5862bad0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2764 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_next_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2f1d3a0e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2765 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d0cce65 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2766 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-faad8da5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2767 | try ▸ for (i < dtReleasePlanList.Rows.Count) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-9a9506f1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2769 | try ▸ for (i < dtReleasePlanList.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-79d6d64f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2775 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-13b8df8e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2780 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.RunSqlSource

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-826abe41 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3799 | if (programID == "SELECT_RELEASE_TOTAL") | RETURN | return Find_Data_Sub("SQL", pSiteID, pPlanGroup, pPlanDate, pPlanID); |  | 처리 중단/반환 |  |  |  |
| AC-5db686c0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3804 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ if (programID == "CONFIRM_VALIDATION_1") | RETURN | return Find_Confirm_Valid("SQL", "CONFIRM_VALIDATION_1"); |  | 처리 중단/반환 |  |  |  |
| AC-d8844e37 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3809 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ if (programID == "CONFIRM_VALIDATION_2") | RETURN | return Find_Confirm_Valid("SQL", "CONFIRM_VALIDATION_2"); |  | 처리 중단/반환 |  |  |  |
| AC-286b14d6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3815 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | FLAG | dtPlanID | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findRevision", _sPlanGroup… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-6333e91d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3815 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findRevision", _sPlanGroup, _sPlanDate) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c080f1b2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3827 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Exec_Release_Plan(i, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-95aebfe9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3837 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Update_DivisionList(i, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-0d5a5834 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3853 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Insert_Is_Running_Release("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-3f0e9691 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3868 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Delete_Is_Running_Release("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7397e681 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3872 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Find_Release_Valid("SQL", "RELEASE_VALIDATION_1"); |  | 처리 중단/반환 |  |  |  |
| AC-03e4ea3c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3876 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Find_Release_Valid("SQL", "RELEASE_VALIDATION_2"); |  | 처리 중단/반환 |  |  |  |
| AC-5100ee99 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3880 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Update_Release_Flag("UPDATE_RELEASE_FLAG", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-64516b41 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3884 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Update_Release_PlanList_2("UPDATE_RELEASE_PLANLIST_2", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9b6d5159 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3888 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Insert_Hist_Detail("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-ded991f1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3902 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return Insert_OT_NET_JOB("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-561306eb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3925 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9505bf3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3926 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_PLAN_RESULT_SEND " + "'" + pPlanGroup + "', " + "'" + pPlanDate + "', " + "'… | 데이터 객체 조작/조회 |  |  |  |
| AC-25c0ca9f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3927 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-97d9f374 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3929 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4346f0d1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3953 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc37653 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3954 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_CONFIRM_SMS_SEND " + "'" + pPlanGroup + "', " + "'" + pPlanID + "', " + "'" … | 데이터 객체 조작/조회 |  |  |  |
| AC-19d0eda0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3955 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ae8052c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3957 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-5d3f7c1c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3967 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a47802d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3968 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_XIF_MES_ERP_WO_MASTER " + "'" + pPlanID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-acfd11f4 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3969 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a06a6996 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3971 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-9dec2b42 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3980 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-18ded15d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3981 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_ASSY_ELEC_REPORT " + "'" + pPlanGroup + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0858724 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3982 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9563fea3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3984 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f99e51d7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3993 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2314b759 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3994 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_PACK_REQUIRE_CEL " + "'" + pPlanGroup + "', " + "'', " + "'Y', " + "'', '… | 데이터 객체 조작/조회 |  |  |  |
| AC-b6a8083e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3995 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dfd4a9f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3997 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e65f6a8d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:4006 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-be6e306c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:4007 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_OF_CELL_DELIVERY_PLAN " + "'" + pPlanGroup + "', " + "'', " + "'Y', " + "'',… | 데이터 객체 조작/조회 |  |  |  |
| AC-41c2e594 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:4008 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-252cfca7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:4010 | else of (programID == "SELECT_RELEASE_TOTAL") ▸ else of (programID == "CONFIRM_VALIDATION_1") ▸ else of (programID == "CONFIRM_VALIDATION_2"… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d05f2491 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:4012 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Save_Release

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d095107 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:560 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c4f52e59 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:564 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-440b76bf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:568 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", _sPlanGroup) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e14c12de | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:577 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_RELEASE_LIMIT_YN == "Y") | MESSAGE | MessageHelper.GMessageBox | ("Unable to release. Contact GSCM.FP PI representative for details.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a77a1b3e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:578 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_RELEASE_LIMIT_YN == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-331e2758 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:586 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3a98b80 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:587 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f484e0d5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:611 | try ▸ if (iChkCount == 0) | MESSAGE | MessageBox.Show | ("Please select check plan group or factory before proceed") | 메시지 표시 |  |  |  |
| AC-fb064c16 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:612 | try ▸ if (iChkCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dbf0f99 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:618 | try ▸ if (bExistComplete == false) | MESSAGE | MessageBox.Show | ("Already exisit Confirm Plan ID. Will you proceed?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-01cb6420 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:620 | try ▸ if (bExistComplete == false) ▸ if (MessageBox.Show("Already exisit Confirm Plan ID. Will you proceed?", "Confrim", MessageBoxButtons.Y… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c833b04 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:629 | try ▸ else of (bExistComplete == false) | MESSAGE | MessageBox.Show | ("Will you Confirm proceed?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-d8b27fa7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:631 | try ▸ else of (bExistComplete == false) ▸ if (MessageBox.Show("Will you Confirm proceed?", "Confrim", MessageBoxButtons.YesNo) == DialogResu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14f1fed5 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:639 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") | FLAG | dtIsRunReleaseBySite | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_is_running_release_by… ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 화면 필드/플래그 변경 |  |  |  |
| AC-ebeb9b88 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:639 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_is_running_release_bySite", _sPlanGroup) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9741111 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:648 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") ▸ if (dtIsRunReleaseBySite != null) ▸ if (dtIsRunReleaseBySite.Rows.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5edb2554 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:649 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() != "Y") ▸ if (dtIsRunReleaseBySite != null) ▸ if (dtIsRunReleaseBySite.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ca5251f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:654 | try ▸ if (Check_Exec_IsRunningEngine("SELECT_INIT") == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-197090bc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:660 | try ▸ if (Check_isConfirmed() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-100862ef | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:666 | try ▸ if (Check_ConfirmValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6898484c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:669 | try ▸ if (Check_CapaValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f03a67fc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:677 | try ▸ if (Check_IsPastDate() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-818139fc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:678 | try ▸ if (Check_IsPastDate() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28d8938a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:683 | try ▸ if (Check_Exec_IsRunningEngine("SELECT") == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-deec8cda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:687 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7edca41f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:705 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | ENDPOINT | proxyPivot.ExecuteAsync | (() => Exec_Release_Queue("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5150a33a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:725 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_watingTime", _sPlanGroup, _sSite, sFactory_LT) ⇒ SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe0b7045 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:743 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnReleaseRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-66f05125 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:745 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | MESSAGE | MessageBox.Show | (sMsg, "Excute", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-50e7f084 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:749 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (MessageBox.Show(sMsg, "Excute", MessageBoxButtons.OK) == DialogR… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-69ab5d1d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:750 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (MessageBox.Show(sMsg, "Excute", MessageBoxButtons.OK) == DialogR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d09ae72 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:752 | try ▸ if (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d7448ed8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:786 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9ab67429 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:787 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-38fe3260 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:788 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (sResults.Equals("STOP")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-931a9970 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:817 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-56c4225f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:828 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0fc1074 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:835 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2e82cd7f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:836 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f00b5968 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:837 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7de9a63 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:861 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-dd0701a0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:872 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | CALL_EXT | Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-648c75c6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:879 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d68c2fb1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:880 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dtInstance.Rows[0]["INSTANCE_TYPE"].ToString() != "F") ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b4d5ac1 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:944 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") ▸ if (dsSendTotal == null \|\| dsSendTotal.Tables[0].Rows[0][0].T… | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) | 메시지 표시 |  |  |  |
| AC-5dd53b47 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1032 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e6cc8e00 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1034 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | FLAG | blnReleaseRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8960801d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1037 | try ▸ else of (dtInstance.Rows[0]["RELEASE_QUEUE_FLAG"].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { _sPlanID }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93ed0fc8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1043 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c88180dd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1044 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-975d9161 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1048 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f6b7913b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1049 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4788b4d8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1053 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d468c7dc | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1057 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dd21c3cb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1058 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-faee4d1b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1060 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermProcessPopup.SCP0113_LongTermProcessPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fc6cf54 | this.FormClosing | SCP0113_LongTermProcessPopup.cs:3385 | if (blnReleaseRun == true) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## SCP0113_LongTermProcessPopup.SetCboDivisionChangedControl

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ab59563 | cboDivision.SelectedIndexChanged | SCP0113_LongTermProcessPopup.cs:3318 |  | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-27dc2f01 | cboDivision.SelectedIndexChanged | SCP0113_LongTermProcessPopup.cs:3318 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fa32561e | cboDivision.SelectedIndexChanged | SCP0113_LongTermProcessPopup.cs:3320 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0113_LongTermProcessPopup.SetCheckRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0342208 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:4026 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sCheckYn != "Y") | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |

## SCP0113_LongTermProcessPopup.SetCleraVariable

진입점: this.btnSearch.Click [switch (sType) case "CREATE":] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ada2244 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3407 |  | FLAG | p_sys_type | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8c556168 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3408 |  | FLAG | p_sys_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fdcaf552 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3409 |  | FLAG | p_sys_gubun | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fb494aca | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3410 |  | FLAG | p_user_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9ef58821 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3411 |  | FLAG | p_division_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d136ca0c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3412 |  | FLAG | p_site_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c8eb86f4 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3413 |  | FLAG | p_factory_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7c0fc253 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3414 |  | FLAG | p_instance_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3d36ef44 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3415 |  | FLAG | p_plan_date | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-93def0f2 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3416 |  | FLAG | p_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-79f87853 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3417 |  | FLAG | p_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8c8c0365 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3418 |  | FLAG | p_insert_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-64dfca21 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3419 |  | FLAG | p_release_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1e6e5e4c | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3420 |  | FLAG | p_is_enable_rel | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c3cd54fd | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3421 |  | FLAG | p_confirm_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2e632aa0 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3422 |  | FLAG | p_confirm_time | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0c4dc0a6 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3423 |  | FLAG | p_description | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b6e1e198 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3424 |  | FLAG | p_isenable | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4f536a75 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3425 |  | FLAG | p_ischk | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-72e93ff8 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3426 |  | FLAG | p_next_plan_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ca977087 | this.btnSearch.Click [switch (sType) case "CREATE":] 외 1 | SCP0113_LongTermProcessPopup.cs:3427 |  | FLAG | p_release_flag | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermProcessPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bc448f2 | this.Load | SCP0113_LongTermProcessPopup.cs:333 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-557706de | this.Load | SCP0113_LongTermProcessPopup.cs:334 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-8867e5e4 | this.Load | SCP0113_LongTermProcessPopup.cs:337 |  | CALL_EXT | siObj.GetSpdTitle | ("SCP0113", UserInfoContext.Current.UserId, siObj.SheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f023352 | this.Load | SCP0113_LongTermProcessPopup.cs:338 |  | GRID_INIT | siObj.CreateSheetHeaderColumn | (siObj, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## SCP0113_LongTermProcessPopup.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-914ba6e2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3349 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-ebd02926 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3354 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-306ca103 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3361 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ColumnHeader.Ce… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, bChk) | 그리드 값 설정 |  |  |  |
| AC-0b2fb52f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:3374 |  | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermProcessPopup.Update_DivisionList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d770a9ca | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1499 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-1fc67d80 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1500 | try | FLAG | p_sys_flag | "UPDATE_DIVISIONLIST" | 화면 필드/플래그 변경 |  |  |  |
| AC-59506f9c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1501 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4fad2426 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1502 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-6d36eabf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1503 | try | FLAG | p_division_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7f2a6fda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1504 | try | FLAG | p_site_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cc02f37b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1505 | try | FLAG | p_factory_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9a7819a2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1506 | try | FLAG | p_instance_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec6b2dda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1507 | try | FLAG | p_plan_date | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9883e73e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1508 | try | FLAG | p_plan_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLAN_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-18e6b68f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1509 | try | FLAG | p_flag | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FLAG)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a183849e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1510 | try | FLAG | p_insert_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INSERT_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-301f7657 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1511 | try | FLAG | p_release_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.RELEASE_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb36a54d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1512 | try | FLAG | p_is_enable_rel | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.IS_ENABLE_REL)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff0c41ad | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1513 | try | FLAG | p_confirm_id | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e8b4ecb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1514 | try | FLAG | p_confirm_time | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CONFIRM_TIME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-82756029 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1515 | try | FLAG | p_description | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f7428d2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1516 | try | FLAG | p_isenable | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISENABLE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7483e3f3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1517 | try | FLAG | p_ischk | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ISCHK)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-532ece1e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1518 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1444545f | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1519 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf3a6a3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1520 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cb4e804e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1524 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-4710b8eb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1525 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-38daab84 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1527 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-79cc7260 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1528 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bd580b75 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1529 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-6e59f24d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1530 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-68f2506d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1532 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-198d897c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1533 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-febb5180 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1534 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-46c63f89 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1535 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9ee8658a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1536 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-4ccb4a41 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1537 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-109c3847 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1538 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c7b96ac8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1539 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-eb5e3c15 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1540 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-53481cfd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1541 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-c2fd7cdd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1542 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-e14f0a31 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1543 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-ca7c5a7d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1544 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-736ecd21 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1545 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-9fcb5f60 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1546 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-a2af102a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1547 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d5fb3ba3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1548 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-21f4fa4b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1549 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cd587e14 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1550 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-80b8bc6c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1552 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7206f58 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1553 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d48e16c2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1559 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Update_Release_Flag

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de4509d0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1927 | try | FLAG | p_sys_type | pSysType | 화면 필드/플래그 변경 |  |  |  |
| AC-db67d2a3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1928 | try | FLAG | p_sys_flag | pSysFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-7fd8424d | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1929 | try | FLAG | p_sys_gubun | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-687ecb57 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1930 | try | FLAG | p_user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-318e2cda | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1931 | try | FLAG | p_division_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ffdac5f0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1932 | try | FLAG | p_site_id | _sSite | 화면 필드/플래그 변경 |  |  |  |
| AC-1f2c5b22 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1933 | try | FLAG | p_factory_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-93c45cbf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1934 | try | FLAG | p_instance_id | _sPlanGroup | 화면 필드/플래그 변경 |  |  |  |
| AC-aecdc308 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1935 | try | FLAG | p_plan_date | _sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-0731640e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1936 | try | FLAG | p_plan_id | _sPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa2dea3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1937 | try | FLAG | p_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-48977cd0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1938 | try | FLAG | p_insert_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8b071ab9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1939 | try | FLAG | p_release_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-81e532e2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1940 | try | FLAG | p_is_enable_rel | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-88027f4b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1941 | try | FLAG | p_confirm_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4be02628 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1942 | try | FLAG | p_confirm_time | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6f2edefb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1943 | try | FLAG | p_description | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e76dfec3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1944 | try | FLAG | p_isenable | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-31be6722 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1945 | try | FLAG | p_ischk | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1ea9d826 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1946 | try | FLAG | p_next_plan_id | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c196e3e9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1947 | try | FLAG | p_release_flag | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7f43ea47 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1948 | try | FLAG | p_plan_type | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-205bba03 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1952 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-9f0f44de | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1953 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1501b469 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1955 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-fd766672 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1956 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b41ec34a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1957 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-99d37da2 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1958 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4284d9bf | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1960 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1dd7d179 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1961 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-41414612 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1962 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8e5a639 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1963 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-25711832 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1964 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-347ba1e0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1965 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ef2a302 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1966 | try | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b9b8ea38 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1967 | try | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-dac644ed | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1968 | try | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-80fbbbca | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1969 | try | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-21e1d9e8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1970 | try | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-83824c94 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1971 | try | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-87e55997 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1972 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-838e81d0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1973 | try | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-7f17bea8 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1974 | try | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-d1eed372 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1975 | try | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-0e9d3777 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1976 | try | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-48f26c54 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1977 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7895e1d9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1978 | try | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1584a074 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1980 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11241343 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1981 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4c301f5c | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:1988 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.Update_Release_PlanList_2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdf0c569 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2047 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-29c0aa08 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2048 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-94dc1f01 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2050 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f3af80d0 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2051 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d2559011 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2052 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-2efff91e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2053 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4161bac | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2055 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-28943118 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2056 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-966be477 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2057 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-9417c6c9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2058 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-0bcd000b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2059 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-88bc99a9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2060 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8ed17d9 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2061 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_flag"] | p_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ccee7ab6 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2062 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_insert_time"] | p_insert_time | 행/컬럼 값 대입 |  |  |  |
| AC-37502a2e | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2063 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_time"] | p_release_time | 행/컬럼 값 대입 |  |  |  |
| AC-987be483 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2064 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_enable_rel"] | p_is_enable_rel | 행/컬럼 값 대입 |  |  |  |
| AC-fc46254a | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2065 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a5070cb | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2066 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_confirm_time"] | p_confirm_time | 행/컬럼 값 대입 |  |  |  |
| AC-35f03644 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2067 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-cefd05ea | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2068 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_isenable"] | p_isenable | 행/컬럼 값 대입 |  |  |  |
| AC-787bf900 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2069 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ischk"] | p_ischk | 행/컬럼 값 대입 |  |  |  |
| AC-f427eecd | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2070 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_next_plan_id"] | p_next_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-41a28d48 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2071 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e8ff8d8b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2072 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-58d07f8b | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2073 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_end_date"] | _sPlanEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-089ea4f7 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2075 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4297ce28 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2076 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ab5bd4b3 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2081 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ac72ad95 | (진입점 미연결) | SCP0113_LongTermProcessPopup.cs:2086 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermProcessPopup.usrRadio_CheckedChanged

진입점: this.usrRadio3.CheckedChanged / this.usrRadio2.CheckedChanged / this.usrRadio1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d562603 | this.usrRadio3.CheckedChanged 외 2 | SCP0113_LongTermProcessPopup.cs:4040 | if (usrRadio3.Checked) | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-90fe6e1f | this.usrRadio3.CheckedChanged 외 2 | SCP0113_LongTermProcessPopup.cs:4041 | if (usrRadio3.Checked) | STATE | clbItemType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-04e9a5c3 | this.usrRadio3.CheckedChanged 외 2 | SCP0113_LongTermProcessPopup.cs:4042 | if (usrRadio3.Checked) | STATE | clbPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-632be1d9 | this.usrRadio3.CheckedChanged 외 2 | SCP0113_LongTermProcessPopup.cs:4046 | else of (usrRadio3.Checked) | STATE | cboDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f7c65916 | this.usrRadio3.CheckedChanged 외 2 | SCP0113_LongTermProcessPopup.cs:4047 | else of (usrRadio3.Checked) | STATE | clbItemType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3ef5c6f6 | this.usrRadio3.CheckedChanged 외 2 | SCP0113_LongTermProcessPopup.cs:4048 | else of (usrRadio3.Checked) | STATE | clbPlant.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0113_LongTermStockMgmt.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fad1d51d | this.btnColumn.Click | SCP0113_LongTermStockMgmt.cs:2586 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0113", SpdSheet.shtMain, true, fixedColumns) | 팝업/폼 생성 |  |  |  |
| AC-c0c6930c | this.btnColumn.Click | SCP0113_LongTermStockMgmt.cs:2587 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-406ecc93 | this.btnColumn.Click | SCP0113_LongTermStockMgmt.cs:2588 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0113_LongTermStockMgmt.btnDownloadExcel_Click

진입점: this.btnDownloadExcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee6677e1 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3136 |  | DATA_OP | Filter["p_plan_date"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-8d758c5d | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3137 |  | DATA_OP | Filter["p_division_id"] | CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a0748a9f | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3138 |  | DATA_OP | Filter["p_group_code"] | txtGroupCode.Text | 행/컬럼 값 대입 |  |  |  |
| AC-db9099e9 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3139 |  | DATA_OP | Filter["p_item_type"] | CString.GetCheckedListValue(dtItemType, clbItemType.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-767bee71 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3140 |  | DATA_OP | Filter["p_plant_id"] | CString.GetCheckedListValue(dtPlantByGroupAll, clbPlant.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-1ea030d4 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3141 |  | DATA_OP | Filter["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c2347096 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3143 |  | POPUP | new SCP0113_LongTermStockMgmtViewPopup | () | 팝업/폼 생성 |  |  |  |
| AC-61f9f0f4 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3144 |  | UI_PROP | popup.p_creation_type | CString.GetComboBoxValue(cboCreationType.SelectedItem) | 속성 p_creation_type 설정 |  |  |  |
| AC-f3647f29 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3144 |  | CALL_EXT | CString.GetComboBoxValue | (cboCreationType.SelectedItem) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53011861 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3145 |  | UI_PROP | popup.p_end_month | monthPicker.ControlValues | 속성 p_end_month 설정 |  |  |  |
| AC-f8381f1f | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3146 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ee64e4db | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3146 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b39a742f | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3147 |  | UI_PROP | popup.Width | 830 | 속성 Width 설정 |  |  |  |
| AC-bcd43e26 | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3148 |  | UI_PROP | popup.Height | 530 | 속성 Height 설정 |  |  |  |
| AC-ac0aff1c | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3149 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6cd9dfbc | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3151 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-b1b540bf | this.btnDownloadExcel.Click | SCP0113_LongTermStockMgmt.cs:3153 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0113_LongTermStockMgmt.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f72f97e | this.btnImport.Click | SCP0113_LongTermStockMgmt.cs:2613 |  | POPUP | new ExcelUploadForm | ("SCP0113", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-e0d0d175 | this.btnImport.Click | SCP0113_LongTermStockMgmt.cs:2614 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-c7daddec | this.btnImport.Click | SCP0113_LongTermStockMgmt.cs:2615 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f9314b4e | this.btnImport.Click | SCP0113_LongTermStockMgmt.cs:2616 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0113_LongTermStockMgmt.btnProcessLongTerm_Click

진입점: this.btnProcessLongTerm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-122b5470 | this.btnProcessLongTerm.Click | SCP0113_LongTermStockMgmt.cs:3204 |  | POPUP | new SCP0113_LongTermProcessPopup | () | 팝업/폼 생성 |  |  |  |
| AC-65b47d3c | this.btnProcessLongTerm.Click | SCP0113_LongTermStockMgmt.cs:3205 |  | UI_PROP | popWowStatus.p_end_month | monthPicker.ControlValues | 속성 p_end_month 설정 |  |  |  |
| AC-cead8bc9 | this.btnProcessLongTerm.Click | SCP0113_LongTermStockMgmt.cs:3206 |  | UI_PROP | popWowStatus.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ea390379 | this.btnProcessLongTerm.Click | SCP0113_LongTermStockMgmt.cs:3208 |  | UI_PROP | popWowStatus.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-0cef98ca | this.btnProcessLongTerm.Click | SCP0113_LongTermStockMgmt.cs:3209 |  | UI_PROP | popWowStatus.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eb85df1a | this.btnProcessLongTerm.Click | SCP0113_LongTermStockMgmt.cs:3210 |  | POPUP | popWowStatus.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0113_LongTermStockMgmt.ChangeEditCell

진입점: this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(DefColumns.EXHT_TP_CD))] / this.spdMain.LeaveCell [if (cellCol == siMain.GetColumnIndex(DefColumns.EXHT_TP_CD))] / EditButton [for (row < siMain.ActiveSheet.RowCount)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f96d165 | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2452 | if (!siMain.IsLock()) ▸ if (!string.IsNullOrEmpty(exhtValue)) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue.Trim()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9463e8d | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2452 | if (!siMain.IsLock()) ▸ if (!string.IsNullOrEmpty(exhtValue)) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue.Trim()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c960ddb | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2457 | if (!siMain.IsLock()) ▸ if (dtQtyInputException == null) | FLAG | dtQtyInputException | GetItemTypeQTYInputException() | 화면 필드/플래그 변경 |  |  |  |
| AC-f66defbb | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2464 | if (!siMain.IsLock()) ▸ if (check) | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex("QTY_1"), rowIndex, siMain.GetColumnIndex("QTY_1") + qtyC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7def1037 | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2468 | if (!siMain.IsLock()) ▸ if (check) ▸ for (i < qtyColCount) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, siMain.GetColumnIndex("QTY_" + qtyNum.ToString()), null) | 그리드 값 설정 |  |  |  |
| AC-c15e49fe | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2473 | if (!siMain.IsLock()) ▸ else of (check) | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex("QTY_1"), rowIndex, siMain.GetColumnIndex("QTY_1") + qtyC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db83d648 | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 2 | SCP0113_LongTermStockMgmt.cs:2480 | if (!siMain.IsLock()) ▸ if (edittype == "1") | GRID_LOCK | siMain.LockRange | (rowIndex, 0, rowIndex, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0113_LongTermStockMgmt.CheckEditPeriod

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f05cfd0 | EditButton | SCP0113_LongTermStockMgmt.cs:2573 | if (lastEditableDate > curDate) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b12fbe71 | EditButton | SCP0113_LongTermStockMgmt.cs:2576 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.CheckNullExcelValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd193049 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1851 | try | FLAG | dtQtyInputException | GetItemTypeQTYInputException() | 화면 필드/플래그 변경 |  |  |  |
| AC-4fc0b205 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1885 | try ▸ for (i < dtData.Rows.Count) ▸ if (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ if (dtData.Columns.Count - qty… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2565107e | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1894 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ if ((string.IsNullOrEmpty… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-efc6c48a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1901 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-506490df | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1906 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f6dd8450 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1937 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue.Trim()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bbc39b7 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1937 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue.Trim()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5d118bf | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1944 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ab9774e6 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1950 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fe0abd2a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1961 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a12a57b1 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1978 | try ▸ for (i < dtData.Rows.Count) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOr… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d92629a8 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1990 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-24703b64 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1993 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.CheckNullSpreadValidation

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be7b1624 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1293 | try | FLAG | dtQtyInputException | GetItemTypeQTYInputException() | 화면 필드/플래그 변경 |  |  |  |
| AC-5aee353c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1353 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((strin… | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue.Trim()) | 데이터 객체 조작/조회 |  |  |  |
| AC-16308732 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1353 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((strin… | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue.Trim()) | 데이터 객체 조작/조회 |  |  |  |
| AC-000fcda6 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1360 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((strin… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e09c2301 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1409 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-909ab414 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1411 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e55a6cb3 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:353 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d835a2b1 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:354 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0113_LongTermStockMgmt.convertMasterDataToList

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ebe0c4f | this.Load | SCP0113_LongTermStockMgmt.cs:1028 | if (masterData.Rows.Count > 0) ▸ foreach (DataRow row in masterData.Rows) | DATA_OP | result.Add | (pair) | 데이터 객체 조작/조회 |  |  |  |
| AC-56560f66 | this.Load | SCP0113_LongTermStockMgmt.cs:1032 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.CreateComboboxCellType

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ for (iSheetIndex < spSpread.Sheets.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b672636 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmt.cs:1722 | for (i <= listData.Rows.Count - 1) | DATA_OP | list.Add | (listData.Rows[i][1].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-48349c6d | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmt.cs:1724 |  | UI_PROP | comboBoxCellType.Items | list.ToArray() | 속성 Items 설정 |  |  |  |
| AC-614e4c2e | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmt.cs:1725 |  | STATE | comboBoxCellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-53359898 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmt.cs:1726 |  | RETURN | return comboBoxCellType; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de20a1c8 | this.Load | SCP0113_LongTermStockMgmt.cs:363 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ba63e51a | this.Load | SCP0113_LongTermStockMgmt.cs:364 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fb9fc60 | this.Load | SCP0113_LongTermStockMgmt.cs:368 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtDetail1, SpdSheet.shtDetail1, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c8e60d5 | this.Load | SCP0113_LongTermStockMgmt.cs:369 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtDetail2, SpdSheet.shtDetail2, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-51de0873 | this.Load | SCP0113_LongTermStockMgmt.cs:370 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtDetail3, SpdSheet.shtDetail3, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c5210679 | this.Load | SCP0113_LongTermStockMgmt.cs:372 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtDetail1) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0a8bb63 | this.Load | SCP0113_LongTermStockMgmt.cs:373 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtDetail2) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd25a984 | this.Load | SCP0113_LongTermStockMgmt.cs:374 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtDetail3) | 화면 필드/플래그 변경 |  |  |  |
| AC-08527108 | this.Load | SCP0113_LongTermStockMgmt.cs:377 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35b1e755 | this.Load | SCP0113_LongTermStockMgmt.cs:380 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eae3feef | this.Load | SCP0113_LongTermStockMgmt.cs:383 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail3) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5464166f | this.Load | SCP0113_LongTermStockMgmt.cs:388 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1a264a5 | this.Load | SCP0113_LongTermStockMgmt.cs:389 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0113_LongTermStockMgmt.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34379532 | this.Load | SCP0113_LongTermStockMgmt.cs:277 |  | DATA_OP | group_id.Contains | ("ADMIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a71da06 | this.Load | SCP0113_LongTermStockMgmt.cs:279 | if (group_id.Contains("ADMIN")) | STATE | btnProcessLongTerm.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-554c588f | this.Load | SCP0113_LongTermStockMgmt.cs:283 | else of (group_id.Contains("ADMIN")) | STATE | btnProcessLongTerm.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0113_LongTermStockMgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87984b69 | Dispose | SCP0113_LongTermStockMgmt.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmt.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c140a994 | EditButton | SCP0113_LongTermStockMgmt.cs:595 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-680a18b8 | EditButton | SCP0113_LongTermStockMgmt.cs:602 | if (!CheckEditPeriod(planDate)) | MESSAGE | MessageHelper.GMessageBox | ("입력 기간이 경과하였습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-32a7fa41 | EditButton | SCP0113_LongTermStockMgmt.cs:603 | if (!CheckEditPeriod(planDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-178b6220 | EditButton | SCP0113_LongTermStockMgmt.cs:606 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1eb4db04 | EditButton | SCP0113_LongTermStockMgmt.cs:607 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-08e2859e | EditButton | SCP0113_LongTermStockMgmt.cs:608 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b5aeaeed | EditButton | SCP0113_LongTermStockMgmt.cs:611 |  | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f545c920 | EditButton | SCP0113_LongTermStockMgmt.cs:612 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6330e80 | EditButton | SCP0113_LongTermStockMgmt.cs:614 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-df2c7b64 | EditButton | SCP0113_LongTermStockMgmt.cs:617 |  | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ce52d90 | EditButton | SCP0113_LongTermStockMgmt.cs:619 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cba1aafe | EditButton | SCP0113_LongTermStockMgmt.cs:621 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-517be36c | EditButton | SCP0113_LongTermStockMgmt.cs:624 |  | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.IMPU_DEPT_NM), spdMain.ActiveSheet.RowCount - 1, siMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1333f834 | EditButton | SCP0113_LongTermStockMgmt.cs:625 |  | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.OCCR_RSN_CD), spdMain.ActiveSheet.RowCount - 1, siMai… | 그리드 편집 잠금/해제 |  |  |  |
| AC-509be80b | EditButton | SCP0113_LongTermStockMgmt.cs:627 |  | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex("QTY_1"), spdMain.ActiveSheet.RowCount - 1, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db5f10a0 | EditButton | SCP0113_LongTermStockMgmt.cs:628 |  | FLAG | qtyColIndexList | new List<int>() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9839115 | EditButton | SCP0113_LongTermStockMgmt.cs:632 | for (i <= qtyColCount) | DATA_OP | qtyColIndexList.Add | (siMain.GetColumnIndex("QTY_" + i.ToString())) | 데이터 객체 조작/조회 |  |  |  |

## SCP0113_LongTermStockMgmt.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48ac0e38 | ExcelButton | SCP0113_LongTermStockMgmt.cs:648 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72e89964 | ExcelButton | SCP0113_LongTermStockMgmt.cs:655 | try ▸ else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.ExportExcelData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12171296 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1418 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7820ce5 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1422 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-17d0d205 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1433 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb2c37a0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1440 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c87a5af | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1442 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58450767 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1445 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-48dce3de | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1481 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-789021b2 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1486 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-3126d15f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1492 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (newSheet, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80dd6c6d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1502 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "ACTION": | DATA_OP | newSheet.Columns[i].Remove | () | 데이터 객체 조작/조회 |  |  |  |
| AC-abc1a102 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1512 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-061700e8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1514 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-73bef2b4 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1523 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b47290de | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1535 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-26a8e068 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1536 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-a0bed2f6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1545 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-3418ae93 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1546 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-34886376 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1552 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f0fd7bf6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1565 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-cc2236c4 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1574 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-b30c2f66 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1594 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, occrColPosition].CellType | comboBoxCellType_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-1bc92559 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1597 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_OCCR)) | GRID_SET | newSheet.Cells[i, occrColPosition].Value | value_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-cc0f3178 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1601 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, exthColPosition].CellType | comboBoxCellType_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-fab4b6b0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1604 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_EXHT)) | GRID_SET | newSheet.Cells[i, exthColPosition].Value | value_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-b78fa298 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1610 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-554db394 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1615 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-9b215f59 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1617 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-9e9dff8c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1621 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-84ffbc3c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1623 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-6d6bafa2 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1631 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-82905579 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1633 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-0682a724 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1638 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a8ce5eb | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1652 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a25bff1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1654 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83ba3013 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1658 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-108b5862 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1659 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-348f3955 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1660 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-a0a81117 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1661 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-391aa81d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1662 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9c4a3d9f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1669 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-77177f34 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1671 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-353c840d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1674 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd4a29ee | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1678 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07b2cb37 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1684 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0eb73c35 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1685 | catch ((Exception e)) | CALL_BASE | SCM_SYS_LOG_BATCH | ("ExcelDownload", "ERROR", 0, "########## UI ExcelDownload Error (" + tmpSheetName + ") ##… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5a7e764 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1689 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c1bc832e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmt.cs:1692 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0113_LongTermStockMgmt.Find_Data

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa5e185f | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:668 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4125345a | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:671 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-839769c4 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:671 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98b0d0c1 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:675 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9e4ea048 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:678 | try | FLAG | mPlanDate | String.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8af2bd66 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:679 | try | FLAG | mPlanDate2 | String.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-97b6ba9c | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:680 | try | FLAG | mEndMonth | String.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8707793f | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:681 | try | FLAG | mDivisionId | String.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-95160486 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:682 | try | FLAG | mPlanType | String.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-47f3e255 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:683 | try | FLAG | mItemId | String.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e3781d4b | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:688 | try | CALL_EXT | CString.GetComboBoxValue | (cboCreationType.SelectedItem) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9436144f | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:696 | try | FLAG | baseMonth | GetBaseMonth(p_plan_date) | 화면 필드/플래그 변경 |  |  |  |
| AC-e93aa642 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:697 | try | FLAG | dtQtyInputException | GetItemTypeQTYInputException() | 화면 필드/플래그 변경 |  |  |  |
| AC-c10309e0 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:704 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-943670b9 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:705 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-443841b8 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:709 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-46588f98 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:710 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9690a242 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-694834a1 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-08621361 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_creation_type"] | p_creation_type | 행/컬럼 값 대입 |  |  |  |
| AC-7a2f2435 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:714 | try ▸ lambda | DATA_OP | request.Parameters["p_group_code"] | p_group_code | 행/컬럼 값 대입 |  |  |  |
| AC-48bf1a03 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-7348ec66 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-49e02804 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_end_month"] | p_end_month | 행/컬럼 값 대입 |  |  |  |
| AC-c23c8d40 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:718 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ffca3709 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:719 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-da756573 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:721 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c653a08 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:723 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5eb4d1d9 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:727 | try | VALUE_SET | lblBaseMonth.Text | "This is the expected long-term ending stock for " + baseMonth | 컨트롤 값 설정 |  |  |  |
| AC-ee06d7f5 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:732 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-39e29b9e | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:734 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-315061cd | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:736 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3831093c | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:741 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5c44d94f | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:748 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-06e0a0e6 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:749 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72b0ada5 | FindButton 외 1 | SCP0113_LongTermStockMgmt.cs:753 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmt.FindData_Detail1

진입점: this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1)] / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0")] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1) ▸ if (siSub.IsLock(siSub.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59a41069 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:761 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-70911ced | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:762 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d035a479 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:766 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bda38515 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:770 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3a7a278 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:776 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9f272a14 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:777 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c8f466f9 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:781 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-5c745c30 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:783 | lambda | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-9341050e | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:784 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-187c0146 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:785 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e92002a2 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:786 | lambda | DATA_OP | request.Parameters["p_company_id"] | sCompany_id | 행/컬럼 값 대입 |  |  |  |
| AC-7fb24460 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:787 | lambda | DATA_OP | request.Parameters["p_plant_id"] | sPlant_id | 행/컬럼 값 대입 |  |  |  |
| AC-55775506 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:789 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3651413 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:791 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0c1ef536 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:798 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-18044949 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:799 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e5a498b | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:806 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dd699b57 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:807 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmt.FindData_Detail2

진입점: this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2)] / this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString() == "0") ▸ if (e.SheetTabIndex.ToString() == "1")] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2) ▸ if (siSub.IsLock(siSub.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0f7a52b | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:812 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-be6dc6f9 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:813 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7e4ba950 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:817 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f088757f | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:821 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0be585c3 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:827 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9d8c0b09 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:828 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20601058 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:832 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-7796b6cf | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:834 | lambda | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-f00e97c2 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:835 | lambda | DATA_OP | request.Parameters["p_plan_type"] | sPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-9c6065f9 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:836 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-68892162 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:837 | lambda | DATA_OP | request.Parameters["p_end_month"] | sEndMonth | 행/컬럼 값 대입 |  |  |  |
| AC-779d5976 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:838 | lambda | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-7a991b7f | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:839 | lambda | DATA_OP | request.Parameters["p_company_id"] | sCompany_id | 행/컬럼 값 대입 |  |  |  |
| AC-7202b85f | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:840 | lambda | DATA_OP | request.Parameters["p_plant_id"] | sPlant_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4964727 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:842 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88fe9428 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:844 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6e0acac5 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:851 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f9a43b95 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:852 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-413f0c25 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:859 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-aac684df | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:860 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmt.FindData_Detail3

진입점: this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail3)] / this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString() == "0") ▸ else of (e.SheetTabIndex.ToString() == "1") ▸ if (e.SheetTabIndex.ToString() == "2")] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07bf1e4a | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:865 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4048147a | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:866 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-516b8259 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:870 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-41d4963e | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:874 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail3) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad7d8807 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:880 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-91a74a2e | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:881 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65843fe9 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:885 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-1c9c7876 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:887 | lambda | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-24da910d | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:888 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e35eb4d0 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:889 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-eeec0a07 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:890 | lambda | DATA_OP | request.Parameters["p_company_id"] | sCompany_id | 행/컬럼 값 대입 |  |  |  |
| AC-2714288f | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:891 | lambda | DATA_OP | request.Parameters["p_plant_id"] | sPlant_id | 행/컬럼 값 대입 |  |  |  |
| AC-1db2a22b | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:893 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3660164e | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:895 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e9fa61d3 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:904 | if (ds != null) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7c399b25 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:905 | if (ds != null) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aae2def1 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:914 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-08b9f0f6 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:915 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c190a05f | this.Load | SCP0113_LongTermStockMgmt.cs:260 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0113_LongTermStockMgmt.GetBaseMonth

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate)) ▸ if (string.IsNullOrEmpty(baseMonth) \|\| string.IsNullOrWhiteSpace(baseMonth))] / this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate)) ▸ if (string.IsNullOrEmpty(baseMonth) \|\| string.IsNullOrWhiteSpace(baseMonth))] / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0") …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0282d30b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 7 | SCP0113_LongTermStockMgmt.cs:2334 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_BASE_MONTH") ⇒ SCP.SCP0113_GET_BASE_MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-3ba703fc | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 7 | SCP0113_LongTermStockMgmt.cs:2335 |  | DATA_OP | request.Parameters["p_plan_date"] | planDate | 행/컬럼 값 대입 |  |  |  |
| AC-633d7c05 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 7 | SCP0113_LongTermStockMgmt.cs:2337 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c8fe68d7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 7 | SCP0113_LongTermStockMgmt.cs:2346 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetColumnIndexByHeaderName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90e44644 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2175 | for (i < dataTable.Columns.Count) ▸ if (dataTable.Columns[i].ColumnName.Equals(headerName, StringComparison.OrdinalIgnoreCase)) | RETURN | return i; |  | 처리 중단/반환 |  |  |  |
| AC-1b5ece33 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2178 |  | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetComboBoxMasterData

진입점: this.Load / ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ for (iSheetIndex < spSpread.Sheets.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e65654e0 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:999 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-f4ffc15d | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1000 |  | DATA_OP | request.Parameters["p_lookup_type"] | "SCM_LGTM_CODE_NAME_FOR_REPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-7b88d62f | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1001 |  | DATA_OP | request.Parameters["p_segment1"] | "SRCE_TP_CD" | 행/컬럼 값 대입 |  |  |  |
| AC-d164bbd2 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1002 |  | DATA_OP | request.Parameters["p_segment2"] | "EOH" | 행/컬럼 값 대입 |  |  |  |
| AC-ada54a12 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1004 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9de23ef9 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1004 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-5fccb101 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1012 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_COMBOBOX_DATA") ⇒ SCP.SCP0084_GET_COMBOBOX_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4762ab1c | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1013 |  | DATA_OP | request.Parameters["p_lookup_type"] | lookup_type | 행/컬럼 값 대입 |  |  |  |
| AC-22ec8104 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1014 |  | DATA_OP | request.Parameters["p_valid_yn"] | valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b0d38706 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1016 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-13db04e4 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1016 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetEditPeriod

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b5608c7 | EditButton | SCP0113_LongTermStockMgmt.cs:2521 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LGTM_PLAN_EDIT_PERIOD") ⇒ SCP.SCP0113_GET_LGTM_PLAN_EDIT_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-9c25684e | EditButton | SCP0113_LongTermStockMgmt.cs:2522 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-acf932e2 | EditButton | SCP0113_LongTermStockMgmt.cs:2531 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetItemTypeQTYInputException

진입점: this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(DefColumns.EXHT_TP_CD)) ▸ if (!siMain.IsLock()) ▸ if (dtQtyInputException == null)] / this.spdMain.LeaveCell [if (cellCol == siMain.GetColumnIndex(DefColumns.EXHT_TP_CD)) ▸ if (!siMain.IsLock()) ▸ if (dtQtyInputException == null)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResult)) ▸ try] / EditButton [for (row < siMain.ActiveSheet.RowCount) ▸ if (!siMain.IsLock()) ▸ if (dtQtyInputException == null)] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7139f0d | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 6 | SCP0113_LongTermStockMgmt.cs:2558 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION") ⇒ SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | 엔드포인트 요청 생성 |  |  |  |
| AC-fb1c4392 | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 6 | SCP0113_LongTermStockMgmt.cs:2559 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b96f803a | this.spdMain.Change [if (cellCol == siMain.GetColumnIndex(De… 외 6 | SCP0113_LongTermStockMgmt.cs:2562 |  | RETURN | return dtResult; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetLabelNameByName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebcc580e | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2161 |  | DATA_OP | dataTable.Select | ($"COLUMN_NAME = '{name}'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5224d767 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2164 | if (foundRows.Length > 0) | RETURN | return foundRows[0]["COLUMN_LABEL_NAME"].ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-8921afec | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2166 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetMonthRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46fe82cf | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1038 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_MONTH_RANGE") ⇒ SCP.SCP0084_GET_MONTH_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-6dd6138a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1039 |  | DATA_OP | request.Parameters["p_month"] | 12 | 행/컬럼 값 대입 |  |  |  |
| AC-1415a5f3 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1041 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39bef20e | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1041 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetPlanDateComboBox

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c001e72d | this.Load | SCP0113_LongTermStockMgmt.cs:2313 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE") ⇒ SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-b1de8845 | this.Load | SCP0113_LongTermStockMgmt.cs:2315 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1511b15c | this.Load | SCP0113_LongTermStockMgmt.cs:2315 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.GetQtyInputPeriod

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45b01a64 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:2539 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD") ⇒ SCP.SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-305f7744 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:2540 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-818cd9e1 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:2549 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-118014f4 | this.Load | SCP0113_LongTermStockMgmt.cs:290 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-900b4f1c | this.Load | SCP0113_LongTermStockMgmt.cs:292 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e0044984 | this.Load | SCP0113_LongTermStockMgmt.cs:297 |  | FLAG | dtItemType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-d5e33150 | this.Load | SCP0113_LongTermStockMgmt.cs:298 |  | DATA_OP | dtItemType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c53d2ea | this.Load | SCP0113_LongTermStockMgmt.cs:299 |  | DATA_OP | dtItemType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-18339d69 | this.Load | SCP0113_LongTermStockMgmt.cs:300 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e597fece | this.Load | SCP0113_LongTermStockMgmt.cs:301 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_1_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-a41eab0e | this.Load | SCP0113_LongTermStockMgmt.cs:302 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_1_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-588865eb | this.Load | SCP0113_LongTermStockMgmt.cs:303 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c633907 | this.Load | SCP0113_LongTermStockMgmt.cs:304 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-27e6097a | this.Load | SCP0113_LongTermStockMgmt.cs:305 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-7642794e | this.Load | SCP0113_LongTermStockMgmt.cs:306 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-3f8cd3c3 | this.Load | SCP0113_LongTermStockMgmt.cs:307 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d1f20ac | this.Load | SCP0113_LongTermStockMgmt.cs:308 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2fd687e2 | this.Load | SCP0113_LongTermStockMgmt.cs:309 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_3_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-cab6e19a | this.Load | SCP0113_LongTermStockMgmt.cs:310 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_3_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-5c0ef554 | this.Load | SCP0113_LongTermStockMgmt.cs:311 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-8693ba60 | this.Load | SCP0113_LongTermStockMgmt.cs:312 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6b07846a | this.Load | SCP0113_LongTermStockMgmt.cs:313 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_4_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-ccec632f | this.Load | SCP0113_LongTermStockMgmt.cs:314 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_4_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-5f0cd8b5 | this.Load | SCP0113_LongTermStockMgmt.cs:315 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f6947ad | this.Load | SCP0113_LongTermStockMgmt.cs:318 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f8557ce0 | this.Load | SCP0113_LongTermStockMgmt.cs:320 |  | FLAG | dtCreationType | GetComboBoxMasterData() | 화면 필드/플래그 변경 |  |  |  |
| AC-680fc7e4 | this.Load | SCP0113_LongTermStockMgmt.cs:322 |  | LIST_REBIND | clsCtrl.setListBox | (dtCreationType, cboCreationType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3ced049 | this.Load | SCP0113_LongTermStockMgmt.cs:323 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroupAll, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-28374063 | this.Load | SCP0113_LongTermStockMgmt.cs:325 |  | FLAG | dtPlanDate | GetPlanDateComboBox() | 화면 필드/플래그 변경 |  |  |  |
| AC-81658333 | this.Load | SCP0113_LongTermStockMgmt.cs:326 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0113_LongTermStockMgmt.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1)] / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0")] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2) ▸ if (siSub.IsLock(siSub.SheetName))] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7ed5e46 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:399 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtDetail2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bdc3b47f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:402 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32ffdc18 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:403 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b58464f3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:421 | if (spdInfo.SheetName == SpdSheet.shtMain) | FLAG | dtTitle | spdInfo.GetSpdTitle("SCP0113", UserInfoContext.Current.UserId, spdInfo.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ec86ee4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:421 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.GetSpdTitle | ("SCP0113", UserInfoContext.Current.UserId, spdInfo.SheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7154a7ca | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:422 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.CreateSheetHeaderColumn | (spdInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-dbc4b9f1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:425 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.Sheet().ColumnHeader.RowCount | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-92939360 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:438 | else of (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6251e99c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:455 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0113_LongTermStockMgmt.InitSpreadDateColumn

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate))] / this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate))] / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0") ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate))] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6686fb3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:499 | if (string.IsNullOrEmpty(baseMonth) \|\| string.IsNullOrWhiteSpace(baseMonth)) | FLAG | baseMonth | GetBaseMonth(planDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-6146ca25 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:515 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d6d38b5f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:519 | else of (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-084c5f59 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:529 | while (dtFrom <= dtTo) | GRID_INIT | spdInfo.AddNumColumn | (sCurLabel, sCurColName, FPMerge.None, 70, true, FPHAlign.Right, FPVAlign.General, 2, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f6faed6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:534 | while (dtFrom <= dtTo) ▸ if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(sCurColName), 1, qtyColIndex, 20, largeLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d358538 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:536 | while (dtFrom <= dtTo) ▸ if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-f5e1b537 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:540 | while (dtFrom <= dtTo) ▸ else of (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-5a073a58 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:550 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex("QTY_1"), 1, qtyColIndex - 1, 20, largeLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fa909b7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:551 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | qtyColCount | qtyColIndex - 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-df652fb9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:553 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | ("Entered by", DefColumns.USER_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Gene… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f22f990 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:555 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.USER_ID), 2, 1, 20, "Entered by", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eee7de2a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:556 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetColumnHeader | (0, spdInfo.GetColumnIndex(DefColumns.USER_ID), "Entered by") | 그리드 재구성/초기화 |  |  |  |
| AC-4687bce9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:558 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddDateTimeColumn | ("Date entered", DefColumns.UPDATE_DATE, FPMerge.None, 130, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72023f4c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:560 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.UPDATE_DATE), 2, 1, 20, "Date entered", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-661d60db | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:561 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetColumnHeader | (0, spdInfo.GetColumnIndex(DefColumns.UPDATE_DATE), "Date entered") | 그리드 재구성/초기화 |  |  |  |
| AC-37ed618f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:569 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtDetail2) | GRID_INIT | spdInfo.AddNumColumn | ("Total", "TOTAL", FPMerge.None, 70, true, FPHAlign.Right, FPVAlign.General, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f5541c5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:571 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtDetail2) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, "Total") | 그리드 재구성/초기화 |  |  |  |

## SCP0113_LongTermStockMgmt.LoadExcelToDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59fe61eb | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1768 | try ▸ if (bFile == false) | MESSAGE | MessageBox.Show | ("Check Excel File Name", "File Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-66753cc5 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1769 | try ▸ if (bFile == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-70ed638b | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1772 | try | CALL_EXT | FarExcel.OpenExcel | (filePath, FarPoint.Excel.ExcelOpenFlags.ColumnHeaders) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f66cf854 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1799 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (k < iColCount) | DATA_OP | dt.Columns.Add | (FarExcel.ActiveSheet.ColumnHeader.Cells[iRowStart, k].Text.ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0594a0f9 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1804 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) | CALL_EXT | FarExcel.ActiveSheet.GetLastNonEmptyRow | (FarPoint.Win.Spread.NonEmptyItemFlag.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e1c9156 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1807 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8adc68e3 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1814 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-11ca8565 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1816 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k] | FarExcel.ActiveSheet.Cells[i, k].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa5cad57 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1821 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k - 1] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-04f9beec | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1823 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) ▸ for… | DATA_OP | dr[k - 1] | FarExcel.ActiveSheet.Cells[i, k].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b80596a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1826 | try ▸ if (FarExcel.ActiveSheet.RowCount > 0) ▸ for (i <= FarExcel.ActiveSheet.GetLastNonEmptyRow(FarPoint.Win.Spread.NonEmptyItemFla…) | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f89de70 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1830 | try | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5983f700 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1832 | try | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-ad6d6ae9 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1836 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("Please Check Excel Form", "File Error", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-32ada076 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1838 | catch ((Exception ex)) | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.LoadMasterData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a578382 | this.Load | SCP0113_LongTermStockMgmt.cs:487 |  | FLAG | this.dtOccr_rsn_cd | GetComboBoxMasterData(OccrType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-5c0985c4 | this.Load | SCP0113_LongTermStockMgmt.cs:488 |  | FLAG | this.dtExht_tp_cd | GetComboBoxMasterData(ExhtType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-17d3d428 | this.Load | SCP0113_LongTermStockMgmt.cs:489 |  | FLAG | this.occrList | convertMasterDataToList(this.dtOccr_rsn_cd) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e45a493 | this.Load | SCP0113_LongTermStockMgmt.cs:490 |  | FLAG | this.exhtList | convertMasterDataToList(this.dtExht_tp_cd) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa72a814 | this.Load | SCP0113_LongTermStockMgmt.cs:491 |  | FLAG | this.dtQtyInputException | GetItemTypeQTYInputException() | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermStockMgmt.ReCalculateValue

진입점: this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] / this.spdMain.LeaveCell [if (qtyColIndexList.Contains(cellCol))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22612c1b | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] 외 1 | SCP0113_LongTermStockMgmt.cs:2369 | if (remainCol != -1) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, remainCol, totalValue - monthlyQtySum) | 그리드 값 설정 |  |  |  |
| AC-3543de17 | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] 외 1 | SCP0113_LongTermStockMgmt.cs:2380 | if (remainCol != -1) ▸ if (priceCol != -1 && remainAMTCol != -1) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, remainAMTCol, (totalValue - monthlyQtySum) * priceValue) | 그리드 값 설정 |  |  |  |
| AC-78c452e5 | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] 외 1 | SCP0113_LongTermStockMgmt.cs:2398 | if (remainCol != -1) ▸ if (priceCol != -1 && remainAMTUSDCol != -1 && exToBamtCol != -1) ▸ if (!string.IsNullOrEmpty(ex_to_bamt)) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, remainAMTUSDCol, (totalValue - monthlyQtySum) * priceValue / exToBamtValue) | 그리드 값 설정 |  |  |  |
| AC-e2a31b20 | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] 외 1 | SCP0113_LongTermStockMgmt.cs:2402 | if (remainCol != -1) ▸ if (priceCol != -1 && remainAMTUSDCol != -1 && exToBamtCol != -1) ▸ else of (!string.IsNullOrEmpty(ex_to_bamt)) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, remainAMTUSDCol, 0) | 그리드 값 설정 |  |  |  |
| AC-14aaa738 | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] 외 1 | SCP0113_LongTermStockMgmt.cs:2413 | if (remainLongTermCol != -1 && longTermQtyCol != -1) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, remainLongTermCol, longTermQtyValue - monthlyQtySum > 0 ? longTermQtyValue - mo… | 그리드 값 설정 |  |  |  |
| AC-f78c5197 | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol))] 외 1 | SCP0113_LongTermStockMgmt.cs:2418 | if (remainLongTermCol != -1 && longTermQtyCol != -1) ▸ if (remainLongTermExpectCol != -1 && longTermExpectQtyCol != -1) | GRID_SET | siMain.ActiveSheet.SetValue | (rowIndex, remainLongTermExpectCol, longTermQtyValue - monthlyQtySum > 0 ? longTermExpectV… | 그리드 값 설정 |  |  |  |

## SCP0113_LongTermStockMgmt.RenameColumnHearder

진입점: this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail3)] / this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString() == "0") ▸ else of (e.SheetTabIndex.ToString() == "1") ▸ if (e.SheetTabIndex.ToString() == "2") ▸ if (!string.IsNullOrEmpty(mPlanDate2))] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d407c081 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:952 | for (i <= 12) ▸ if (inputMonth <= 12) ▸ if (spdInfo.GetColumnIndex("QTY_" + i.ToString())> 0) | GRID_INIT | spdInfo.SetColumnHeader | (0, spdInfo.GetColumnIndex("QTY_" + i.ToString()), columnNewLable) | 그리드 재구성/초기화 |  |  |  |
| AC-f556f017 | this.spdMain.CellDoubleClick [if (selectedCellColnIndex == m… 외 2 | SCP0113_LongTermStockMgmt.cs:958 | for (i <= 12) ▸ else of (inputMonth <= 12) | MESSAGE | MessageHelper.GMessageBox | ("Invalid Month Value!") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0113_LongTermStockMgmt.Save_Data_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-063f5912 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:1999 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e9cc6f38 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2002 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-82881add | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2043 | try ▸ for (i < dtData.Rows.Count) ▸ if (!string.IsNullOrEmpty(occrValue)) | DATA_OP | this.occrList.Find | (x => x.Value.Trim() == occrValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-b629bd09 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2043 | try ▸ for (i < dtData.Rows.Count) ▸ if (!string.IsNullOrEmpty(occrValue)) | DATA_OP | this.occrList.Find | (x => x.Value.Trim() == occrValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d7657a7 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2050 | try ▸ for (i < dtData.Rows.Count) ▸ if (!string.IsNullOrEmpty(exhtValue)) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-734a4093 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2050 | try ▸ for (i < dtData.Rows.Count) ▸ if (!string.IsNullOrEmpty(exhtValue)) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-82a0ae4a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2114 | try ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e5f8a94b | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2115 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN") ⇒ SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-dde2edb0 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2119 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b686f434 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2121 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a4a8bc60 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2122 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5602fc33 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2123 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_tp_cd"] | p_plan_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-62c7bc6d | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2124 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_data_tp_cd"] | p_data_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-43fa6f4a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2125 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_srce_tp_cd"] | p_srce_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-fa3b4cd3 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2126 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9effca65 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2127 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c06c66b0 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2128 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed2a6205 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2129 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_impu_dept_nm"] | p_impu_dept_nm | 행/컬럼 값 대입 |  |  |  |
| AC-c833ffa2 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2130 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_cd"] | p_occr_rsn_cd | 행/컬럼 값 대입 |  |  |  |
| AC-d33d8b62 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2131 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_ctn"] | p_occr_rsn_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-08402a9c | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2132 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_exht_tp_cd"] | p_exht_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-f2e3b9b4 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2133 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_exht_tp_ctn"] | p_exht_tp_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-88c3a382 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2134 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_yyyymm"] | p_plan_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-01bcd070 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2135 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9ed05d0a | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2136 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-edc9f9c1 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2138 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c058fc7 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2140 | try ▸ if (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-50019a2c | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2141 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b5230a85 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2146 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c55b32d6 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2147 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-355a4558 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2148 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4db3e08d | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2153 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4e30faf | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2154 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8af6bedb | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2155 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31ebeb0e | SaveButton | SCP0113_LongTermStockMgmt.cs:1078 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1f195ecf | SaveButton | SCP0113_LongTermStockMgmt.cs:1090 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (string.IsNullOrEmpty(saveReasonResu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f185499 | SaveButton | SCP0113_LongTermStockMgmt.cs:1094 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (string.IsNullOrEmpty(saveReaso… | MESSAGE | MessageHelper.GMessageBox | (saveReasonResult) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4a563c0 | SaveButton | SCP0113_LongTermStockMgmt.cs:1101 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dddcdbb8 | SaveButton | SCP0113_LongTermStockMgmt.cs:1102 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f379637 | SaveButton | SCP0113_LongTermStockMgmt.cs:1106 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-749f5e91 | SaveButton | SCP0113_LongTermStockMgmt.cs:1107 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0113_LongTermStockMgmt.SaveDataReason

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfa87808 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1144 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (message != "") | RETURN | return message + "\n" + detailMessage; |  | 처리 중단/반환 |  |  |  |
| AC-0050052e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(baseMonth) \… | FLAG | baseMonth | GetBaseMonth(siMain.GetColumnIndex(DefColumns.PLAN_DATE).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3f0b731 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(occrValue)) | DATA_OP | this.occrList.Find | (x => x.Value.Trim() == occrValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-e008c51a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1169 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(occrValue)) | DATA_OP | this.occrList.Find | (x => x.Value.Trim() == occrValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-1808a296 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(exhtValue)) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b0ad0c7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(exhtValue)) | DATA_OP | this.exhtList.Find | (x => x.Value.Trim() == exhtValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-989bb5c2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN") ⇒ SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-614e74c8 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2c0a7130 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-899c593c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1244 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2eda460b | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_tp_cd"] | p_plan_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-1e3a5936 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_data_tp_cd"] | p_data_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-6ea4cec5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_srce_tp_cd"] | p_srce_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-692ad03f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ecf770f9 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-b950f38d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-32be42d7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9afff4ea | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_impu_dept_nm"] | p_impu_dept_nm | 행/컬럼 값 대입 |  |  |  |
| AC-11503f9a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1253 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_cd"] | p_occr_rsn_cd | 행/컬럼 값 대입 |  |  |  |
| AC-1f6d1c99 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_occr_rsn_ctn"] | p_occr_rsn_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-709c673e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_exht_tp_cd"] | p_exht_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-bde12681 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1256 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_exht_tp_ctn"] | p_exht_tp_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-0bb65f1f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1257 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_yyyymm"] | p_plan_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-f899bae6 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-20fe3ad2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-63d69a17 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1261 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1bc4013f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (dst.Tables[dst.Tables.Count - 1].Rows[0][0].ToString… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-a81a3008 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1275 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ else of (dst.Tables[dst.Tables.Count - 1].Rows[0][0].ToS… | RETURN | return errorMsg; |  | 처리 중단/반환 |  |  |  |
| AC-cd36712e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0113_LongTermStockMgmt.cs:1283 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.SetCboDivisionChangedControl

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48799247 | cboDivision.SelectedIndexChanged | SCP0113_LongTermStockMgmt.cs:472 |  | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-40e498d4 | cboDivision.SelectedIndexChanged | SCP0113_LongTermStockMgmt.cs:472 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e359023a | cboDivision.SelectedIndexChanged | SCP0113_LongTermStockMgmt.cs:474 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0113_LongTermStockMgmt.SetColumnFooterData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ if (this.DisplayFooter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24361268 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmt.cs:1702 |  | DATA_OP | sv.Rows.Add | (newIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9eedb14 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmt.cs:1706 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Border | columnHeaerStyle.Border | 그리드 속성/값 설정 |  |  |  |
| AC-4322cd49 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmt.cs:1707 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].BackColor | columnHeaerStyle.BackColor | 그리드 속성/값 설정 |  |  |  |
| AC-373f5dd9 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmt.cs:1708 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].HorizontalAlignment | columnHeaerStyle.HorizontalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-553f0bf4 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmt.cs:1709 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].VerticalAlignment | columnHeaerStyle.VerticalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-87516a22 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmt.cs:1711 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Text | sv.ColumnFooter.Cells[0, col].Text | 그리드 속성/값 설정 |  |  |  |

## SCP0113_LongTermStockMgmt.SetComboBox

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [if (selectedCellColnIndex == materialColIndex) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail1)] / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0")] / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtDetail2) ▸ if (siSub.IsLock(siSub.SheetName))] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee35024e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:481 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.OCCR_RSN_CD), dtOccr_rsn_cd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a427fb3d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | SCP0113_LongTermStockMgmt.cs:482 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.EXHT_TP_CD), dtExht_tp_cd) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0113_LongTermStockMgmt.SetMonthRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c51555e | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1057 |  | FLAG | baseMonth | GetBaseMonth(planDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-2529c11a | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1066 |  | FLAG | addMonth | GetQtyInputPeriod() | 화면 필드/플래그 변경 |  |  |  |
| AC-938643f0 | this.Load 외 1 | SCP0113_LongTermStockMgmt.cs:1072 |  | VALUE_SET | monthPicker.InitValue | initValue | 컨트롤 값 설정 |  |  |  |

## SCP0113_LongTermStockMgmt.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c3271c0 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2880 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b786fee4 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2884 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4cd2896 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2885 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-def7e6db | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2888 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d89e2353 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2946 | if (selectedCellColnIndex == materialColIndex) | FLAG | mPlanDate | planDate | 화면 필드/플래그 변경 |  |  |  |
| AC-d2b67600 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2947 | if (selectedCellColnIndex == materialColIndex) | FLAG | mPlanDate2 | planDate2 | 화면 필드/플래그 변경 |  |  |  |
| AC-54d035e3 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2948 | if (selectedCellColnIndex == materialColIndex) | FLAG | mEndMonth | endMonth | 화면 필드/플래그 변경 |  |  |  |
| AC-b99ceb15 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2949 | if (selectedCellColnIndex == materialColIndex) | FLAG | mDivisionId | divisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-344f460b | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2950 | if (selectedCellColnIndex == materialColIndex) | FLAG | mPlanType | planType | 화면 필드/플래그 변경 |  |  |  |
| AC-bb1622a2 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2951 | if (selectedCellColnIndex == materialColIndex) | FLAG | mItemId | itemId | 화면 필드/플래그 변경 |  |  |  |
| AC-f785036a | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2952 | if (selectedCellColnIndex == materialColIndex) | FLAG | mCompanyID | company_id | 화면 필드/플래그 변경 |  |  |  |
| AC-968792bc | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2953 | if (selectedCellColnIndex == materialColIndex) | FLAG | mPlantID | plant_id | 화면 필드/플래그 변경 |  |  |  |
| AC-61b6ac57 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2956 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91dd0346 | this.spdMain.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:2957 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0113_LongTermStockMgmt.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a392a57 | this.spdMain.Change | SCP0113_LongTermStockMgmt.cs:2974 |  | DATA_OP | qtyColIndexList.Contains | (cellCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0113_LongTermStockMgmt.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5b53d11 | this.spdMain.LeaveCell | SCP0113_LongTermStockMgmt.cs:2992 |  | DATA_OP | qtyColIndexList.Contains | (cellCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0113_LongTermStockMgmt.SpdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a0cbf1c | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:345 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0113_LongTermStockMgmt.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-790fa78c | this.spdSub.ActiveSheetChanging | SCP0113_LongTermStockMgmt.cs:3163 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-e6d47e6a | this.spdSub.ActiveSheetChanging | SCP0113_LongTermStockMgmt.cs:3165 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9728366d | this.spdSub.ActiveSheetChanging | SCP0113_LongTermStockMgmt.cs:3166 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe3a421a | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3015 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21e91601 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3017 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c14cafd1 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3025 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83f334cc | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3031 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdShee… | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f70d8685 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3032 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76a71bc7 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3036 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siSub.ActiveSheet.SheetName == SpdShee… | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc9ad16d | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3062 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ebba44d | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3068 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e44055c | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3069 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eedda242 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3072 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cd9e668 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3092 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32bf8356 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3098 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3eae877d | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3099 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2105407 | this.spdSub.CellDoubleClick | SCP0113_LongTermStockMgmt.cs:3102 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siSub.ActiveSheet.SheetName == Sp… | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0113_LongTermStockMgmt.SumMonthlyQty

진입점: this.spdMain.Change [if (qtyColIndexList.Contains(cellCol)) ▸ if (remainCol != -1)] / this.spdMain.LeaveCell [if (qtyColIndexList.Contains(cellCol)) ▸ if (remainCol != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c3b175 | this.spdMain.Change [if (qtyColIndexList.Contains(cellCol)) … 외 1 | SCP0113_LongTermStockMgmt.cs:2437 |  | RETURN | return monthlyQtySum; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmt.UpdateColumnIndexForUploadFunction

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-403e919e | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2188 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | planDateIndex | GetColumnIndexByHeaderName(dtExcel, planDateLabel) | 화면 필드/플래그 변경 |  |  |  |
| AC-6567eb96 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2195 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | planTPCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-01fed734 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2202 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | dataTPCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-08e053ac | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2209 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | srceTPCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-acafee75 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2216 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | divIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d247846 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2223 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | planIdIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-c76a3f0b | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2230 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | itemIdIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-573dd0dd | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2237 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | totalIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-30b26ff6 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2244 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | occrCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-b472f57e | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2251 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | occrCTNIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-77a73709 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2258 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | exhtCDIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d7410e6 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2265 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | exhtCTNIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-19dad47c | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2272 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | impuDeptNmIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-91e625bc | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2279 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | itemTypeIndex | GetColumnIndexByHeaderName(dtExcel, columnLableName) | 화면 필드/플래그 변경 |  |  |  |
| AC-34959ec6 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2286 | if (!string.IsNullOrEmpty(columnLableName)) | FLAG | baseMonthIndex | GetColumnIndexByHeaderName(dtExcel, baseMonthLabel) | 화면 필드/플래그 변경 |  |  |  |
| AC-c54aa364 | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2302 |  | FLAG | qtyExcelColCount | ((endMonthValue.Year - baseMonthValue.Year) * 12) + endMonthValue.Month - baseMonthValue.M… | 화면 필드/플래그 변경 |  |  |  |
| AC-04f5b84d | (진입점 미연결) | SCP0113_LongTermStockMgmt.cs:2303 |  | FLAG | qty1Index | GetColumnIndexByHeaderName(dtExcel, baseMonthValue.ToString("yy.MM")) | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermStockMgmt.ValidateComboBox

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrEmpty(occrValue) && string.IsNullOrEmpty(exhtValue)) ▸ else of ((string.IsNullOrEmpty(occrValue) && !string.IsNullOrEmpty(exhtValue)) \|\| (!string.IsNullOrEmpty(occrValue) && string.IsN…)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16967ac3 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0113_LongTermStockMgmt.cs:2323 |  | CALL_EXT | comboData.Exists | (x => x.Value.Trim() == value.Trim()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d42e7dcb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0113_LongTermStockMgmt.cs:2323 |  | RETURN | return comboData.Exists(x => x.Value.Trim() == value.Trim()); |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.convertMasterDataToList

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-811d243e | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:722 | if (masterData.Rows.Count > 0) ▸ foreach (DataRow row in masterData.Rows) | DATA_OP | result.Add | (pair) | 데이터 객체 조작/조회 |  |  |  |
| AC-e934e25a | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:726 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.CreateComboboxCellType

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ for (iSheetIndex < spSpread.Sheets.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8978aa9 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmtViewPopup.cs:758 | for (i <= listData.Rows.Count - 1) | DATA_OP | list.Add | (listData.Rows[i][1].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-accb470e | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmtViewPopup.cs:760 |  | UI_PROP | comboBoxCellType.Items | list.ToArray() | 속성 Items 설정 |  |  |  |
| AC-d1c9d23f | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmtViewPopup.cs:761 |  | STATE | comboBoxCellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-099c3f6e | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ f… | SCP0113_LongTermStockMgmtViewPopup.cs:762 |  | RETURN | return comboBoxCellType; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fccb3a20 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:234 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b84d8c8b | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:235 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-512f29c2 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:240 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-818a1033 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:241 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ef9f083 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:182 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-6f0c3194 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:187 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef640d1e | Dispose | SCP0113_LongTermStockMgmtViewPopup.Designer.cs:20 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e3a9721 | ExcelButton | SCP0113_LongTermStockMgmtViewPopup.cs:371 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2924a037 | ExcelButton | SCP0113_LongTermStockMgmtViewPopup.cs:378 | try ▸ else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.ExportExcelData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3da4af12 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:387 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-254f57f3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:391 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cd299712 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:402 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f93051e1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:409 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3547f811 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:411 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61f3664c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:414 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8eec0159 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:449 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7238f5cc | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:454 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-beb4620f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:460 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (newSheet, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61ed09cb | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:470 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "ACTION": | DATA_OP | newSheet.Columns[i].Remove | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e011129 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:480 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ecf3ed0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:482 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a08d7648 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:491 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-85e427c3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:503 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-9984b8b1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:504 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-d1728625 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:513 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-6b0624b1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:514 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-a5ad47de | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:520 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-a31948ed | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:533 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-d7af9c05 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:542 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-af01d123 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:562 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, occrColPosition].CellType | comboBoxCellType_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-4779539e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:565 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_OCCR)) | GRID_SET | newSheet.Cells[i, occrColPosition].Value | value_OCCR | 그리드 속성/값 설정 |  |  |  |
| AC-53162c8a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:569 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) | GRID_SET | newSheet.Cells[i, exthColPosition].CellType | comboBoxCellType_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-4411ef55 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:572 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i < newSheet.RowCount) ▸ if (!string.IsNullOrEmpty(value_EXHT)) | GRID_SET | newSheet.Cells[i, exthColPosition].Value | value_EXHT | 그리드 속성/값 설정 |  |  |  |
| AC-33ba740b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:576 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-deec2d80 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:581 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-18028c04 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:583 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-f6cb19a1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:587 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-041c9044 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:589 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-dfb57373 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:597 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-09ea7d09 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:599 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-dda89b3b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:603 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-f6abcbe0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:614 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49540da0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:616 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-837f43a1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:620 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-3dc338ff | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:621 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-cf571d9e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:622 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-e86c92c1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:623 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-997244d0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:624 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0c79019a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:631 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0e03eed | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:632 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d78a1c0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:634 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b498686 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:638 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd427e70 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:643 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38677acc | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:644 | catch ((Exception e)) | CALL_BASE | SCM_SYS_LOG_BATCH | ("ExcelDownload", "ERROR", 0, "########## UI ExcelDownload Error (" + tmpSheetName + ") ##… | ⚠ 의미 확인 필요 |  |  |  |
| AC-94ade82d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:648 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b32e300d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0113_LongTermStockMgmtViewPopup.cs:651 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03624a74 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:669 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8544d95e | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:673 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_LGTM_DETAIL_FOR_EXPORT") ⇒ SCP.SCP0113_GET_LGTM_DETAIL_FOR_EXPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-feca0e13 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:674 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6eacf420 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:675 | lambda | DATA_OP | request.Parameters["p_plan_date"] | Filter["p_plan_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-bde160a5 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:676 | lambda | DATA_OP | request.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-676c6d0a | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:677 | lambda | DATA_OP | request.Parameters["p_creation_type"] | p_creation_type | 행/컬럼 값 대입 |  |  |  |
| AC-8853aa18 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:678 | lambda | DATA_OP | request.Parameters["p_group_code"] | Filter["p_group_code"] | 행/컬럼 값 대입 |  |  |  |
| AC-b2e86de2 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:679 | lambda | DATA_OP | request.Parameters["p_item_type"] | Filter["p_item_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-f73fbe5f | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:680 | lambda | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-41f0eb07 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:681 | lambda | DATA_OP | request.Parameters["p_end_month"] | p_end_month | 행/컬럼 값 대입 |  |  |  |
| AC-a881f2e6 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:682 | lambda | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-1195ee71 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:683 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-02b90277 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:685 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d17becd | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:687 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-486a7ced | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:691 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-24c9df8e | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:692 |  | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-55a14cb9 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:695 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-77f5b781 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:698 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd172629 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2f01b091 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:171 |  | GRID_SET | spdMain.ActiveSheet.RowHeader.Columns[0].Width | 56 | 그리드 속성/값 설정 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.GetBaseMonth

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate)) ▸ if (string.IsNullOrEmpty(baseMonth) \|\| string.IsNullOrWhiteSpace(baseMonth))] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate)) ▸ if (string.IsNullOrEmpty(baseMonth) \|\| string.IsNullOrWhiteSpace(baseMonth))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-737f9f70 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:844 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0113_GET_BASE_MONTH") ⇒ SCP.SCP0113_GET_BASE_MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-3c53d3df | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:845 |  | DATA_OP | request.Parameters["p_plan_date"] | planDate | 행/컬럼 값 대입 |  |  |  |
| AC-4d59a8d6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:847 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b3df065 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:856 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.GetComboBoxMasterData

진입점: this.Load / ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ for (iSheetIndex < spSpread.Sheets.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f746125 | this.Load 외 1 | SCP0113_LongTermStockMgmtViewPopup.cs:705 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_COMBOBOX_DATA") ⇒ SCP.SCP0084_GET_COMBOBOX_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a5487116 | this.Load 외 1 | SCP0113_LongTermStockMgmtViewPopup.cs:706 |  | DATA_OP | request.Parameters["p_lookup_type"] | lookup_type | 행/컬럼 값 대입 |  |  |  |
| AC-cde6db91 | this.Load 외 1 | SCP0113_LongTermStockMgmtViewPopup.cs:707 |  | DATA_OP | request.Parameters["p_valid_yn"] | valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d988a1ae | this.Load 외 1 | SCP0113_LongTermStockMgmtViewPopup.cs:709 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b0be66a | this.Load 외 1 | SCP0113_LongTermStockMgmtViewPopup.cs:709 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.InitControls

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a2a23fb | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:192 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1be6cecc | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:196 |  | FLAG | dtItemType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2349bda | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:197 |  | DATA_OP | dtItemType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-53394c38 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:198 |  | DATA_OP | dtItemType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-564b8a67 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:199 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d378ca9a | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:200 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_1_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-f202bc68 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:201 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_1_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-34222c55 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:202 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-96c0c484 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:203 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c7a1bc2 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:204 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-9c0c0159 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:205 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-740ee1ea | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:206 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2810b971 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:207 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5bf8bf7f | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:208 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_3_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-b7db7d79 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:209 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_3_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-a62f2fee | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:210 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-263ffb4a | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:211 |  | DATA_OP | dtItemType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2abcd756 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:212 |  | DATA_OP | dataRow["CODE"] | DefItemType.CODE_4_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-1824cb5b | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:213 |  | DATA_OP | dataRow["NAME"] | DefItemType.CODE_4_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-328532ba | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:214 |  | DATA_OP | dtItemType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.InitSpread

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e5df899 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:249 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8253053c | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:250 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c563a0a | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:258 | if (spdInfo.SheetName == SpdSheet.shtMain) | FLAG | dtTitle | spdInfo.GetSpdTitle("SCP0113", UserInfoContext.Current.UserId, spdInfo.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e32ce4f4 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:258 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.GetSpdTitle | ("SCP0113", UserInfoContext.Current.UserId, spdInfo.SheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e3e64a4 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:259 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.CreateSheetHeaderColumn | (spdInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-d3fa65cc | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:261 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.Sheet().ColumnHeader.RowCount | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-307eb6b6 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:272 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate))] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrEmpty(planDate))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-234af319 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:279 | if (string.IsNullOrEmpty(baseMonth) \|\| string.IsNullOrWhiteSpace(baseMonth)) | FLAG | baseMonth | GetBaseMonth(planDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d34f65d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:295 | if (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-cdb81efd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (… 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:299 | else of (spdInfo.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.LoadMasterData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f8e14ee | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:352 |  | FLAG | this.dtOccr_rsn_cd | GetComboBoxMasterData(OccrType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-80e44721 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:353 |  | FLAG | this.dtExht_tp_cd | GetComboBoxMasterData(ExhtType, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-82d522c1 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:354 |  | FLAG | this.occrList | convertMasterDataToList(this.dtOccr_rsn_cd) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5000615 | this.Load | SCP0113_LongTermStockMgmtViewPopup.cs:355 |  | FLAG | this.exhtList | convertMasterDataToList(this.dtExht_tp_cd) | 화면 필드/플래그 변경 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.OkButtonClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6585d087 | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:809 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.SetColumnFooterData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ if (this.DisplayFooter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa5d8569 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmtViewPopup.cs:738 |  | DATA_OP | sv.Rows.Add | (newIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a821563c | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmtViewPopup.cs:742 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Border | columnHeaerStyle.Border | 그리드 속성/값 설정 |  |  |  |
| AC-1cfe3454 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmtViewPopup.cs:743 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].BackColor | columnHeaerStyle.BackColor | 그리드 속성/값 설정 |  |  |  |
| AC-51e0e803 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmtViewPopup.cs:744 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].HorizontalAlignment | columnHeaerStyle.HorizontalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-fd156cd4 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmtViewPopup.cs:745 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].VerticalAlignment | columnHeaerStyle.VerticalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-edce1191 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0113_LongTermStockMgmtViewPopup.cs:747 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Text | sv.ColumnFooter.Cells[0, col].Text | 그리드 속성/값 설정 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.SetComboBox

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04fa00c1 | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:346 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.OCCR_RSN_CD), dtOccr_rsn_cd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22429b7f | this.Load 외 2 | SCP0113_LongTermStockMgmtViewPopup.cs:347 |  | CALL_EXT | spdInfo.SetColumnCombo | (siMain.GetColumnIndex(DefColumns.EXHT_TP_CD), dtExht_tp_cd) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0113_LongTermStockMgmtViewPopup.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ea894e | (진입점 미연결) | SCP0113_LongTermStockMgmtViewPopup.cs:833 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

