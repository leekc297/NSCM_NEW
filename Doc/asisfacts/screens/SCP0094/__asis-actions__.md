# AS-IS 액션 대조표 — SCP0094

> 원천: `Doc/asisfacts/screens/SCP0094/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 167행 · 메서드 56 · 종류 DATA_OP 36 · GRID_INIT 21 · RETURN 19 · UI_PROP 16 · FLAG 10 · GRID_SET 10 · CALL_EXT 8 · LIST_REBIND 8 · VALUE_SET 7 · POPUP 5 · GRID_CLEAR 5 · ENDPOINT 5 · COMBO_DATA 5 · UI_MISC 4 · VALIDATE 3 · GRID_BIND 1 · GRID_LOCK 1 · CALL_BASE 1 · MESSAGE 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 9


## SCP0094_GlobalPSI_Auto.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d547aa2b | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:776 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-30605b9f | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:778 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-33871afd | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:780 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d57f84b3 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:785 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0de2c722 | this.btnItem_Id.Click | SCP0094_GlobalPSI_Auto.cs:1160 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d51ab898 | this.btnItem_Id.Click | SCP0094_GlobalPSI_Auto.cs:1162 |  | POPUP | popItem.Form_Load | (true, _division, sScmSite, sProject, this._item_id) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3e7b42d7 | this.btnItem_Id.Click | SCP0094_GlobalPSI_Auto.cs:1164 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d45c2c98 | this.btnItem_Id.Click | SCP0094_GlobalPSI_Auto.cs:1166 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f25053fd | this.btnItem_Id.Click | SCP0094_GlobalPSI_Auto.cs:1172 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | item_Id | 컨트롤 값 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eab77a44 | this.btnMeasure.Click | SCP0094_GlobalPSI_Auto.cs:1086 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0094", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-b10ae03b | this.btnMeasure.Click | SCP0094_GlobalPSI_Auto.cs:1088 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-910f5086 | this.btnMeasure.Click | SCP0094_GlobalPSI_Auto.cs:1090 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-52853417 | this.btnMeasure.Click | SCP0094_GlobalPSI_Auto.cs:1094 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-28cd4c12 | this.btnMeasure.Click | SCP0094_GlobalPSI_Auto.cs:1098 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.CboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eeafad6 | this.cboBucketType.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:1114 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0094_GlobalPSI_Auto.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e768c8a0 | cboPlanDate.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:1143 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-3d374104 | cboPlanDate.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:1145 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-73152f72 | cboPlanDate.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:1147 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0094_GlobalPSI_Auto.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5331c960 | cboPlanSeq.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:658 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0094_GlobalPSI_Auto.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6542f2d8 | cboPlanType.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:1133 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-13091eea | cboPlanType.SelectedIndexChanged | SCP0094_GlobalPSI_Auto.cs:1136 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0094_GlobalPSI_Auto.ChkAll_CheckedChanged

진입점: this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-457fd907 | this.chkAll.CheckedChanged | SCP0094_GlobalPSI_Auto.cs:1127 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0094_GlobalPSI_Auto.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba928d94 | this.Load | SCP0094_GlobalPSI_Auto.cs:533 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5cb599b4 | this.Load | SCP0094_GlobalPSI_Auto.cs:535 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7768ed56 | this.Load | SCP0094_GlobalPSI_Auto.cs:537 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3050db45 | this.Load | SCP0094_GlobalPSI_Auto.cs:361 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-fdc9e16b | this.Load | SCP0094_GlobalPSI_Auto.cs:362 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aedf478 | Dispose | SCP0094_GlobalPSI_Auto.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0094_GlobalPSI_Auto.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-487ded01 | ExcelButton | SCP0094_GlobalPSI_Auto.cs:756 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0094_GlobalPSI_Auto.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52d72ffc | FindButton | SCP0094_GlobalPSI_Auto.cs:828 |  | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-c89959ff | FindButton | SCP0094_GlobalPSI_Auto.cs:829 | if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5158d566 | FindButton | SCP0094_GlobalPSI_Auto.cs:831 |  | VALIDATE | SCPPlan.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-050c59c1 | FindButton | SCP0094_GlobalPSI_Auto.cs:832 | if (!SCPPlan.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70393219 | FindButton | SCP0094_GlobalPSI_Auto.cs:834 |  | UI_PROP | SCPPlan.p_div | this._division | 속성 p_div 설정 |  |  |  |
| AC-ef3999d9 | FindButton | SCP0094_GlobalPSI_Auto.cs:835 |  | UI_PROP | SCPPlan.p_bucket | this._bucket | 속성 p_bucket 설정 |  |  |  |
| AC-411d443f | FindButton | SCP0094_GlobalPSI_Auto.cs:836 |  | UI_PROP | SCPPlan.p_plan_date | this._plan_start_yyyymmdd | 속성 p_plan_date 설정 |  |  |  |
| AC-c8dfb948 | FindButton | SCP0094_GlobalPSI_Auto.cs:837 |  | UI_PROP | SCPPlan.p_to_yyyymmdd | this._to_yyyymmdd | 속성 p_to_yyyymmdd 설정 |  |  |  |
| AC-d85c0b00 | FindButton | SCP0094_GlobalPSI_Auto.cs:839 |  | CALL_EXT | SCPPlan.CheckPlanPeriodRange | (ref returnMessage, ref plan_end_date) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d288eabf | FindButton | SCP0094_GlobalPSI_Auto.cs:841 | if (!SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date)) | MESSAGE | MessageHelper.GMessageBox | (returnMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a219bc4e | FindButton | SCP0094_GlobalPSI_Auto.cs:843 | if (!SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date)) | UI_PROP | dCalendar.Text2 | plan_end_date | 속성 Text2 설정 |  |  |  |
| AC-f2c5e273 | FindButton | SCP0094_GlobalPSI_Auto.cs:845 | if (!SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84a3f475 | FindButton | SCP0094_GlobalPSI_Auto.cs:792 | if (this.QueryDics[DIC_GLOBAL_PSI_AUTO].Count > 0) | CALL_EXT | this.QueryDics[DIC_GLOBAL_PSI_AUTO].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e5a3a28 | FindButton | SCP0094_GlobalPSI_Auto.cs:797 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpread | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-20585e32 | FindButton | SCP0094_GlobalPSI_Auto.cs:798 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-07b0e763 | FindButton | SCP0094_GlobalPSI_Auto.cs:799 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-f5ef2889 | FindButton | SCP0094_GlobalPSI_Auto.cs:800 |  | UI_PROP | qi.QueryId | "SCP.SCP0094_GET_GLOBAL_PSI_AUTO" | 속성 QueryId 설정 |  |  |  |
| AC-756ff50c | FindButton | SCP0094_GlobalPSI_Auto.cs:802 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a83810c | FindButton | SCP0094_GlobalPSI_Auto.cs:803 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-baad5cdc | FindButton | SCP0094_GlobalPSI_Auto.cs:804 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", this._nick_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a577b25 | FindButton | SCP0094_GlobalPSI_Auto.cs:805 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_cell_group", this._cell_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c471aed | FindButton | SCP0094_GlobalPSI_Auto.cs:806 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_site", this._from_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-63deb9cf | FindButton | SCP0094_GlobalPSI_Auto.cs:807 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_site", this._to_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-790d9a90 | FindButton | SCP0094_GlobalPSI_Auto.cs:808 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_start_yyyymmdd", this._plan_start_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d9d5ba0 | FindButton | SCP0094_GlobalPSI_Auto.cs:809 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_type", this._plan_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c80034d | FindButton | SCP0094_GlobalPSI_Auto.cs:810 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_seq", this._seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f741b84 | FindButton | SCP0094_GlobalPSI_Auto.cs:811 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_bucket", this._bucket)) | 데이터 객체 조작/조회 |  |  |  |
| AC-892a8980 | FindButton | SCP0094_GlobalPSI_Auto.cs:812 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_chk_all", this._chk_all)) | 데이터 객체 조작/조회 |  |  |  |
| AC-711981b8 | FindButton | SCP0094_GlobalPSI_Auto.cs:813 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c83e2b9 | FindButton | SCP0094_GlobalPSI_Auto.cs:814 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49774f5c | FindButton | SCP0094_GlobalPSI_Auto.cs:815 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0094")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f340fb06 | FindButton | SCP0094_GlobalPSI_Auto.cs:816 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", SpdSheet.shtMain)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a64bd833 | FindButton | SCP0094_GlobalPSI_Auto.cs:817 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a115fea3 | FindButton | SCP0094_GlobalPSI_Auto.cs:818 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaf5bb5a | FindButton | SCP0094_GlobalPSI_Auto.cs:820 |  | DATA_OP | this.QueryDics[DIC_GLOBAL_PSI_AUTO] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-c3f50000 | FindButton | SCP0094_GlobalPSI_Auto.cs:823 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_GLOBAL_PSI_AUTO, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0094_GlobalPSI_Auto.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cf8dc5b | this.Load | SCP0094_GlobalPSI_Auto.cs:349 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0094_GlobalPSI_Auto.getBucket

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cdf3d4e | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:278 |  | RETURN | return cboBucketType.ControlValues; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23e1342a | this.Load | SCP0094_GlobalPSI_Auto.cs:1034 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-6de303c9 | this.Load | SCP0094_GlobalPSI_Auto.cs:1035 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a62ad52c | this.Load | SCP0094_GlobalPSI_Auto.cs:1038 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getCellGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52f7a620 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:180 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getChkAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53b6d34e | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:292 |  | RETURN | return chkAll.Checked == true ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f298d59 | this.Load 외 1 | SCP0094_GlobalPSI_Auto.cs:1068 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-333666a6 | this.Load 외 1 | SCP0094_GlobalPSI_Auto.cs:1070 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5318c2d | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:131 |  | RETURN | return cboDivision.ControlValues; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getFromSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c27effa3 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:201 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47592474 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:306 |  | RETURN | return dCalendar.Text1.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ad456ea | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:145 |  | RETURN | return txtItemId.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getNickName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7790470 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:159 |  | RETURN | return txtNickName.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getPlantDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-792cfbf2 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:236 |  | RETURN | return CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getPlantType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cf258b2 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:250 |  | RETURN | return CString.GetCheckedListValue(dtPlanType, cboPlanType.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getSeq

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65efd3f9 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:264 |  | RETURN | return CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f350bbee | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:1056 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-ed6adf69 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:1058 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | this._from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c0f4d145 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:1059 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | this._to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3086bde1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:1061 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-e829f05a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:1061 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0094_GlobalPSI_Auto.getToSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0b81be9 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:222 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf2093ec | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:320 |  | RETURN | return dCalendar.Text2.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitBucket

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc4d7c2 | this.Load | SCP0094_GlobalPSI_Auto.cs:506 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitCellGroup

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3d98532 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:427 |  | FLAG | dtCellGroup | Data_SCP.Common(Data_SCP.Type.CellGroup, false, this._division, this._item_id, this._nick_… | 화면 필드/플래그 변경 |  |  |  |
| AC-d83a22c7 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:427 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.CellGroup, false, this._division, this._item_id, this._nick_name) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0094_GlobalPSI_Auto.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b4478aa | this.Load | SCP0094_GlobalPSI_Auto.cs:515 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d717f5f | this.Load | SCP0094_GlobalPSI_Auto.cs:518 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4a6d0e2 | this.Load | SCP0094_GlobalPSI_Auto.cs:519 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-8003718d | this.Load | SCP0094_GlobalPSI_Auto.cs:520 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f830cb0 | this.Load | SCP0094_GlobalPSI_Auto.cs:526 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a2cac8c | this.Load | SCP0094_GlobalPSI_Auto.cs:376 |  | FLAG | dtDivision | BLUtils.GetDivisionWithoutEE(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-a0b1c0c3 | this.Load | SCP0094_GlobalPSI_Auto.cs:376 |  | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a037241 | this.Load | SCP0094_GlobalPSI_Auto.cs:381 | if (dtDivision.Rows.Count > 0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-be1ab2bc | this.Load | SCP0094_GlobalPSI_Auto.cs:383 | if (dtDivision.Rows.Count > 0) | CALL_EXT | tbl.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b236fa7 | this.Load | SCP0094_GlobalPSI_Auto.cs:393 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | tbl.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb55d042 | this.Load | SCP0094_GlobalPSI_Auto.cs:394 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f3c69e0b | this.Load | SCP0094_GlobalPSI_Auto.cs:395 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-057843e8 | this.Load | SCP0094_GlobalPSI_Auto.cs:397 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | CALL_EXT | tbl.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-170361c0 | this.Load | SCP0094_GlobalPSI_Auto.cs:401 | if (dtDivision.Rows.Count > 0) | UI_PROP | tbl.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-eb364b34 | this.Load | SCP0094_GlobalPSI_Auto.cs:402 | if (dtDivision.Rows.Count > 0) | DATA_OP | tbl.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0664be77 | this.Load | SCP0094_GlobalPSI_Auto.cs:404 | if (dtDivision.Rows.Count > 0) | DATA_OP | tbl.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b581ff6c | this.Load | SCP0094_GlobalPSI_Auto.cs:406 | if (dtDivision.Rows.Count > 0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-960464bc | this.Load | SCP0094_GlobalPSI_Auto.cs:407 | if (dtDivision.Rows.Count > 0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-33b20609 | this.Load | SCP0094_GlobalPSI_Auto.cs:407 | if (dtDivision.Rows.Count > 0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d5ab068f | this.Load | SCP0094_GlobalPSI_Auto.cs:414 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b992036 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:481 |  | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, _division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-764375d5 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:481 |  | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, _division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0094_GlobalPSI_Auto.InitPlanType

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79202df2 | this.Load [if (cboDivision.ControlValues != null)] 외 2 | SCP0094_GlobalPSI_Auto.cs:490 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, _division, _plan_start_yyyymmdd) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-79872ca5 | this.Load [if (cboDivision.ControlValues != null)] 외 2 | SCP0094_GlobalPSI_Auto.cs:490 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, _division, _plan_start_yyyymmdd) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0094_GlobalPSI_Auto.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18c7a1fb | this.Load | SCP0094_GlobalPSI_Auto.cs:344 |  | DATA_OP | QueryDics.Add | (DIC_GLOBAL_PSI_AUTO, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitSeq

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012b98a1 | this.Load [if (cboDivision.ControlValues != null)] 외 2 | SCP0094_GlobalPSI_Auto.cs:471 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, _division, _plan_start_yyyymmdd, _plan_type) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-2abbed07 | this.Load [if (cboDivision.ControlValues != null)] 외 2 | SCP0094_GlobalPSI_Auto.cs:471 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, _division, _plan_start_yyyymmdd, _plan_type) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0094_GlobalPSI_Auto.InitSite

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f3d2060 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:439 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-429b7659 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:441 |  | DATA_OP | tbl.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-794d3913 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:443 |  | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-1ec57294 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:444 |  | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f08cc9c0 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:446 |  | CALL_EXT | tbl.Rows.InsertAt | (dr1, 0) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be218012 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:544 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-96194dae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:548 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-e43232fe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:552 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14de6ada | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:588 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (columnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (columnLabelname, columnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ae890c8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:589 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (columnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(columnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f7381aed | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:593 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (columnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (columnLabelname, columnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a11a6cbf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:594 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (columnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(columnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1a159724 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:598 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (columnName.IndexOf("B_") > 0) ▸ if (dayCode == DefMainLabel.Saturday \|\| dayCo… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | dayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-a720d084 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:605 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != largeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, largeStartCol, 1, largeSpanCnt, 20, largeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c67d7b51 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:606 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != largeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, largeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b78d00f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:612 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != largeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1a5a3cc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:613 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != largeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4e9f67a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:622 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (largeSpanName != largeLabelName) ▸ if (smallSpanName != smallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76a7c97d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:623 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (largeSpanName != largeLabelName) ▸ if (smallSpanName != smallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43ea0aec | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:634 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, smallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-050db1c6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:635 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, smallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-474477e6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:636 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, largeStartCol, 1, largeSpanCnt, 20, largeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-327dafdf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SCP0094_GlobalPSI_Auto.cs:637 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, largeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshBucket

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e431812e | this.Load | SCP0094_GlobalPSI_Auto.cs:498 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshCellGroup

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0575394d | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:422 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellGroup, clbCellGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4afcfcd3 | this.Load | SCP0094_GlobalPSI_Auto.cs:368 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c771c2ae | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:434 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-503d134b | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:477 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21c5675b | this.Load [if (cboDivision.ControlValues != null)] 외 2 | SCP0094_GlobalPSI_Auto.cs:486 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshSeq

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-923910e3 | this.Load [if (cboDivision.ControlValues != null)] 외 2 | SCP0094_GlobalPSI_Auto.cs:467 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.RefreshToSite

진입점: this.Load [if (cboDivision.ControlValues != null)] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72657866 | this.Load [if (cboDivision.ControlValues != null)] 외 1 | SCP0094_GlobalPSI_Auto.cs:456 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0094_GlobalPSI_Auto.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10559245 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:1010 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9c5fd8a | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:1022 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-ec2589eb | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:1026 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0094_GlobalPSI_Auto.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8365222d | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:866 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-38c74099 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:871 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-eba416e4 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:946 | for (row < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals(… | GRID_SET | dsBinding.Tables[0].Rows[row][nIdxWeek] | weekSum / cntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-605f2383 | (진입점 미연결) | SCP0094_GlobalPSI_Auto.cs:961 | for (row < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals(… | GRID_SET | dsBinding.Tables[0].Rows[row][nIdxMonth] | monthSum / cntDayOfMonth | 그리드 속성/값 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6778ce62 | this.Load 외 1 | SCP0094_GlobalPSI_Auto.cs:725 | if (cboDivision.ControlValues != null) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (chkAll.Checked) ▸ if (siMain != null)] / this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5271f8df | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:672 | for (col <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(col).IndexOf("D_") ==… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3e92dd2c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:677 | for (col <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(col).IndexOf("M_") ==… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2d892f1a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:684 | for (col <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buck… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-08c1ca7c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:688 | for (col <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buck… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-956dee30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:693 | for (col <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buck… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b8a0888d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:700 | for (col <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues ==… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-77f2ac21 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0094_GlobalPSI_Auto.cs:704 | for (col <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues ==… | GRID_SET | siObj.ActiveSheet.Columns[col].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0094_GlobalPSI_Auto.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a62cabcf | this.spdMain.CellDoubleClick | SCP0094_GlobalPSI_Auto.cs:1048 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0094_GlobalPSI_Auto.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff175fb9 | this.spdMain.TopChange | SCP0094_GlobalPSI_Auto.cs:1078 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

