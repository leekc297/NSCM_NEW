# AS-IS 액션 대조표 — SCP0124

> 원천: `Doc/asisfacts/screens/SCP0124/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 68행 · 메서드 13 · 종류 DATA_OP 12 · UI_PROP 9 · GRID_INIT 8 · FLAG 8 · RETURN 5 · ENDPOINT 5 · UI_MISC 4 · LIST_REBIND 4 · VALIDATE 3 · CALL_EXT 3 · GRID_CLEAR 2 · POPUP 2 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 3


## SCP0124_PlanGroupDashboard.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dda2a36 | cboPlanGroup.SelectedIndexChanged | SCP0124_PlanGroupDashboard.cs:375 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0124_PlanGroupDashboard.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45552f2b | cboDivision.SelectedIndexChanged | SCP0124_PlanGroupDashboard.cs:370 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0124_PlanGroupDashboard.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd8807f1 | this.Load | SCP0124_PlanGroupDashboard.cs:240 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0da18ff6 | this.Load | SCP0124_PlanGroupDashboard.cs:241 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-712a5173 | this.Load | SCP0124_PlanGroupDashboard.cs:243 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0124_PlanGroupDashboard.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1b59cd3 | Dispose | SCP0124_PlanGroupDashboard.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0124_PlanGroupDashboard.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba53344a | FindButton | SCP0124_PlanGroupDashboard.cs:288 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a1d7eeee | FindButton | SCP0124_PlanGroupDashboard.cs:291 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e358a35a | FindButton | SCP0124_PlanGroupDashboard.cs:291 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8d288df | FindButton | SCP0124_PlanGroupDashboard.cs:292 | try | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-eb954cdc | FindButton | SCP0124_PlanGroupDashboard.cs:292 | try ▸ if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-055a1747 | FindButton | SCP0124_PlanGroupDashboard.cs:296 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-011f638d | FindButton | SCP0124_PlanGroupDashboard.cs:299 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bede2f9 | FindButton | SCP0124_PlanGroupDashboard.cs:316 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1716cbbb | FindButton | SCP0124_PlanGroupDashboard.cs:317 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a92c2f84 | FindButton | SCP0124_PlanGroupDashboard.cs:321 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0124_GET_PLAN_GROUP_DASHBOARD") ⇒ SCP.SCP0124_GET_PLAN_GROUP_DASHBOARD | 엔드포인트 요청 생성 |  |  |  |
| AC-d7ed7349 | FindButton | SCP0124_PlanGroupDashboard.cs:322 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-35f20c93 | FindButton | SCP0124_PlanGroupDashboard.cs:323 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-ebc952ee | FindButton | SCP0124_PlanGroupDashboard.cs:324 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-da1ae229 | FindButton | SCP0124_PlanGroupDashboard.cs:325 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-02f3ce27 | FindButton | SCP0124_PlanGroupDashboard.cs:326 | try ▸ lambda | DATA_OP | request.Parameters["p_completed_yn"] | p_completed_yn | 행/컬럼 값 대입 |  |  |  |
| AC-9167f494 | FindButton | SCP0124_PlanGroupDashboard.cs:327 | try ▸ lambda | DATA_OP | request.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-213b5fb4 | FindButton | SCP0124_PlanGroupDashboard.cs:328 | try ▸ lambda | DATA_OP | request.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-9297fd2a | FindButton | SCP0124_PlanGroupDashboard.cs:330 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1defcf3 | FindButton | SCP0124_PlanGroupDashboard.cs:332 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-aac4469c | FindButton | SCP0124_PlanGroupDashboard.cs:341 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPlanActivityAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-542811c8 | FindButton | SCP0124_PlanGroupDashboard.cs:341 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8417b4ce | FindButton | SCP0124_PlanGroupDashboard.cs:344 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-70e5a472 | FindButton | SCP0124_PlanGroupDashboard.cs:345 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6024bb19 | FindButton | SCP0124_PlanGroupDashboard.cs:348 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-66d659e0 | FindButton | SCP0124_PlanGroupDashboard.cs:358 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0124_PlanGroupDashboard.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd13c27 | this.Load | SCP0124_PlanGroupDashboard.cs:111 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0124_PlanGroupDashboard.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fde10688 | this.Load | SCP0124_PlanGroupDashboard.cs:204 |  | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b66dc92a | this.Load | SCP0124_PlanGroupDashboard.cs:206 |  | CALL_EXT | DateUtil.GetStringToDate | (strToday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed2b986a | this.Load | SCP0124_PlanGroupDashboard.cs:211 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0124_PlanGroupDashboard.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-909fa488 | (진입점 미연결) | SCP0124_PlanGroupDashboard.cs:187 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-1846b38a | (진입점 미연결) | SCP0124_PlanGroupDashboard.cs:189 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4b8c1f1a | (진입점 미연결) | SCP0124_PlanGroupDashboard.cs:190 |  | DATA_OP | request.Parameters["p_user_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1060f674 | (진입점 미연결) | SCP0124_PlanGroupDashboard.cs:193 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd145e78 | (진입점 미연결) | SCP0124_PlanGroupDashboard.cs:197 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0124_PlanGroupDashboard.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4d5f1a9 | this.Load | SCP0124_PlanGroupDashboard.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-672970ad | this.Load | SCP0124_PlanGroupDashboard.cs:132 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-308e5d6f | this.Load | SCP0124_PlanGroupDashboard.cs:134 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0a727eeb | this.Load | SCP0124_PlanGroupDashboard.cs:135 |  | LIST_REBIND | cboCompleted.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-976f7d87 | this.Load | SCP0124_PlanGroupDashboard.cs:137 |  | FLAG | dtPlantIdAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-d04e781b | this.Load | SCP0124_PlanGroupDashboard.cs:138 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-0b415291 | this.Load | SCP0124_PlanGroupDashboard.cs:140 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-b45bb9e3 | this.Load | SCP0124_PlanGroupDashboard.cs:143 |  | DATA_OP | dCalendar.Controls.Find | ("txtStart", true) | 데이터 객체 조작/조회 |  |  |  |
| AC-774033a5 | this.Load | SCP0124_PlanGroupDashboard.cs:150 | foreach (Control x in ctl) ▸ if (x is MaskedTextBox) | UI_PROP | minSize.Width | 80 | 속성 Width 설정 |  |  |  |
| AC-cb4f5455 | this.Load | SCP0124_PlanGroupDashboard.cs:152 | foreach (Control x in ctl) ▸ if (x is MaskedTextBox) | UI_PROP | x.MinimumSize | minSize | 속성 MinimumSize 설정 |  |  |  |
| AC-0134ea0b | this.Load | SCP0124_PlanGroupDashboard.cs:153 | foreach (Control x in ctl) ▸ if (x is MaskedTextBox) | UI_PROP | x.Width | 80 | 속성 Width 설정 |  |  |  |
| AC-024b1717 | this.Load | SCP0124_PlanGroupDashboard.cs:157 |  | DATA_OP | dCalendar.Controls.Find | ("txtEnd", true) | 데이터 객체 조작/조회 |  |  |  |
| AC-3364d570 | this.Load | SCP0124_PlanGroupDashboard.cs:164 | foreach (Control x in ctl) ▸ if (x is MaskedTextBox) | UI_PROP | minSize.Width | 80 | 속성 Width 설정 |  |  |  |
| AC-a7fd8972 | this.Load | SCP0124_PlanGroupDashboard.cs:165 | foreach (Control x in ctl) ▸ if (x is MaskedTextBox) | UI_PROP | x.MinimumSize | minSize | 속성 MinimumSize 설정 |  |  |  |
| AC-5c65d616 | this.Load | SCP0124_PlanGroupDashboard.cs:166 | foreach (Control x in ctl) ▸ if (x is MaskedTextBox) | UI_PROP | x.Width | 80 | 속성 Width 설정 |  |  |  |

## SCP0124_PlanGroupDashboard.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58a8e875 | this.Load | SCP0124_PlanGroupDashboard.cs:252 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd9948cf | this.Load | SCP0124_PlanGroupDashboard.cs:253 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0124_PlanGroupDashboard.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df23ca08 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:226 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-291efc34 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:226 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-20b76469 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, cboPlanGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0124_PlanGroupDashboard.RefreshPlantIdByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f0d3ce7 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:217 |  | FLAG | dtPlantId | DBUtils.Filter(dtPlantIdAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-59e143d9 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:217 |  | DATA_OP | DBUtils.Filter | (dtPlantIdAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-caac1695 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:218 |  | FLAG | dtPlantId | DBUtils.GetDistinctTable(dtPlantId, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-2eec186d | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:218 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtPlantId, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0510c60 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantId, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0124_PlanGroupDashboard.SetSpreadInit

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-740c3908 | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:260 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1e8ee1d | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:261 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-76e909fe | this.Load 외 1 | SCP0124_PlanGroupDashboard.cs:264 |  | GRID_INIT | siObj.SetSheetHeaderColumnSCP | (siObj, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

