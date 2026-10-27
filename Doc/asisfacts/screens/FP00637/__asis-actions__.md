# AS-IS 액션 대조표 — FP00637

> 원천: `Doc/asisfacts/screens/FP00637/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 493행 · 메서드 87 · 종류 DATA_OP 95 · FLAG 85 · CALL_EXT 42 · VALUE_SET 41 · UI_PROP 39 · RETURN 31 · UI_MISC 23 · MESSAGE 22 · ENDPOINT 20 · GRID_INIT 17 · LIST_REBIND 15 · COMBO_DATA 10 · GRID_LOCK 10 · VALUE_CLEAR 10 · POPUP 8 · GRID_STYLE 6 · THROW 5 · GRID_SET 5 · FOCUS 3 · CALL_BASE 3 · STATE 1 · EXCEL 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 45


## FP00637_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dbaa28c | .ctor | FP00637_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-763be7dc | .ctor | FP00637_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-60f61b7f | .ctor | FP00637_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b5698ddf | .ctor | FP00637_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00637_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bc119ac | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:189 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-ae46484f | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:189 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-f50fd2f6 | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:191 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-b657afd3 | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:195 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-7976f17b | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:196 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-2efaa450 | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:197 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-cf5180d4 | this.btnOK.Click | FP00637_BucketSetForm_Popup.cs:198 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00637_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65e8ac13 | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:204 |  | VALUE_SET | chk_day.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-5309e3de | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:212 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-cfd81549 | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:212 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-2871eefc | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:214 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-438bdd2c | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:218 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-2495a48e | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:219 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-770a0a57 | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:221 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0c36a06 | this.btbSet.Click | FP00637_BucketSetForm_Popup.cs:223 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00637_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95da605d | Dispose | FP00637_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00637_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4d595bf | this.Load | FP00637_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00637_BucketSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a7ad974 | this.Load | FP00637_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_plan_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-51b93c20 | this.Load | FP00637_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_mat_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-277e3b70 | this.Load | FP00637_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_cell_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5811616 | this.Load | FP00637_BucketSetForm_Popup.cs:150 |  | DATA_OP | ctrls.Add | (chk_avail_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbecf52e | this.Load | FP00637_BucketSetForm_Popup.cs:151 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ca1215d | this.Load | FP00637_BucketSetForm_Popup.cs:153 |  | VALUE_SET | chk_day.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8ef4dd99 | this.Load | FP00637_BucketSetForm_Popup.cs:155 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-3850a57f | this.Load | FP00637_BucketSetForm_Popup.cs:155 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-b59544e0 | this.Load | FP00637_BucketSetForm_Popup.cs:163 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-adf79829 | this.Load | FP00637_BucketSetForm_Popup.cs:167 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-d3d02c90 | this.Load | FP00637_BucketSetForm_Popup.cs:171 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00637_BucketSetForm_Popup.InitNames

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6821b99f | this.Load | FP00637_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_plan_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2c2eac47 | this.Load | FP00637_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_mat_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7b3440ff | this.Load | FP00637_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_cell_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6d1c142b | this.Load | FP00637_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_avail_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-faebc009 | this.Load | FP00637_BucketSetForm_Popup.cs:120 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00637_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aeeb986a | this.Load | FP00637_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a0fffed | this.Load | FP00637_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb059c25 | .ctor | FP00637_Material_Cell_Simulation_Pack.cs:128 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK") ▸ try] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70f09894 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1913 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-049c323a | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1914 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-142211a9 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1915 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-afbde67e | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1916 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-57f9d1fa | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1917 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b668aa61 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1919 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00637_Material_Cell_Simulation_Pack", "find_WeekCnt", Filte… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-dae57279 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1919 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00637_Material_Cell_Simulation_Pack", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5600c75f | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1920 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00637_Material_Cell_Simulation_Pack", "find_DateMap", Filte… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-64b530ca | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1920 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00637_Material_Cell_Simulation_Pack", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-eccca4e7 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1921 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00637_Material_Cell_Simulation_Pack", "find_MonthCnt", Filt… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-504edc82 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1921 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00637_Material_Cell_Simulation_Pack", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f08b5c9e | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1922 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00637_Material_Cell_Simulation_Pack", "find_BukInfo", Filte… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-126ab752 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1922 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00637_Material_Cell_Simulation_Pack", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4325a34e | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1935 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-172a09a0 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1936 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-221cd8f7 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1937 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-ebe17ddc | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1938 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK") ▸ try] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2f71a43 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1949 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b879d74b | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1950 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-70a92d0d | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1953 |  | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-abf3d367 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1957 | if (Filter["RELEASE_FLAG"] == "Y" \|\| Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-59aa8a93 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1961 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb3fc6e9 | this.btn_bucket.Click | FP00637_Material_Cell_Simulation_Pack.cs:2602 |  | POPUP | new FP00637_BucketSetForm_Popup | ("FP00637", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-25451147 | this.btn_bucket.Click | FP00637_Material_Cell_Simulation_Pack.cs:2603 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-caf5fc36 | this.btn_bucket.Click | FP00637_Material_Cell_Simulation_Pack.cs:2604 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8866da98 | this.btn_bucket.Click | FP00637_Material_Cell_Simulation_Pack.cs:2605 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bfff77b9 | this.btn_bucket.Click | FP00637_Material_Cell_Simulation_Pack.cs:2609 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e597c91 | this.btn_column.Click | FP00637_Material_Cell_Simulation_Pack.cs:2564 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00637", SpdSheet.shtPlanAmendMA, true, cboPlanId.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-e2bae539 | this.btn_column.Click | FP00637_Material_Cell_Simulation_Pack.cs:2565 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-81ccb3b4 | this.btn_column.Click | FP00637_Material_Cell_Simulation_Pack.cs:2566 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnCratePlan_Click

진입점: this.btnCreatePlanxx.Click / this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ce42ee4 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2752 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-edf77f8b | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2753 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-5ef24259 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2761 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2635fd55 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2762 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e280fd64 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2768 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-d76bb984 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2769 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23a27248 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2774 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdc8be34 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2775 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c5b08f4 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2778 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6c635551 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2783 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a397ccc | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2790 | try ▸ try | MESSAGE | MessageBox.Show | ("Do you want to Create Plan", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-5a18a5cb | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2793 | try ▸ try ▸ if (MessageBox.Show("Do you want to Create Plan", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0b3f3270 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2797 | try ▸ try ▸ if (MessageBox.Show("Do you want to Create Plan", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_PLAN").ToUpper(), Filter, CurrentUser, "SELECT", "CREATE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0520b7bb | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2801 | try ▸ try ▸ if (MessageBox.Show("Do you want to Create Plan", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try | DATA_OP | Filter["PLAN_ID"] | dtNewPlan.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bcbde72e | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2803 | try ▸ try ▸ if (MessageBox.Show("Do you want to Create Plan", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00637_Material_Cell_Simulation_Pack", "execute_calculation", Filter.Dictionary, null, … ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_calculation] \| FP\Pl… | 엔드포인트 호출 |  |  |  |
| AC-da62298f | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2816 | try ▸ catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-7b475a8a | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2821 | try ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f5f8f024 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2828 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7cd8e2dc | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2829 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-6bc208ed | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2833 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c4c3c6c4 | this.btnCreatePlanxx.Click 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:2837 | finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnData_Click

진입점: this.btnData.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e42ef5b | this.btnData.Click | FP00637_Material_Cell_Simulation_Pack.cs:2745 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c17f986 | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2719 | if (flo == null) | FLAG | flo | new MenuFloater() | 화면 필드/플래그 변경 |  |  |  |
| AC-f35e942c | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2720 | if (flo == null) | POPUP | flo.Show | () | 팝업/폼 열기 |  |  |  |
| AC-43c774ad | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2722 | if (flo == null) ▸ if (mainForm != null) | CALL_EXT | flo.SetMainForm | (mainForm) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9d2aedf | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2723 | if (flo == null) | CALL_EXT | flo.SetMyPanel | (btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f32b6b1 | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2731 | else of (flo == null) ▸ if (flo.Visible == false) | POPUP | flo.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5d801dda | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2732 | else of (flo == null) ▸ if (flo.Visible == false) | CALL_EXT | flo.SetMyPanel | (btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-810bf782 | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2736 | else of (flo == null) ▸ else of (flo.Visible == false) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-c5aed3d4 | this.btnMenu.Click | FP00637_Material_Cell_Simulation_Pack.cs:2737 | else of (flo == null) ▸ else of (flo.Visible == false) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c88c3840 | this.btnSql.Click | FP00637_Material_Cell_Simulation_Pack.cs:1292 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fde273a6 | this.btnSql.Click | FP00637_Material_Cell_Simulation_Pack.cs:1293 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-83190e65 | this.btnSql.Click | FP00637_Material_Cell_Simulation_Pack.cs:1295 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5138272 | this.btnSql.Click | FP00637_Material_Cell_Simulation_Pack.cs:1296 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.btnToggleSave_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb8e214c | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:2634 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb4c8b1 | this.button1.Click | FP00637_Material_Cell_Simulation_Pack.cs:2862 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.cboInstance_changed

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb6542cf | cboInstance.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:467 |  | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.cboPlanId_changed

진입점: cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94cb8954 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:509 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3b74b534 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:511 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-05b80586 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:512 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7da5cc43 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:513 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ce4a45b7 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:514 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtUpdater.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5cb1b76d | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:515 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtUpdation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c1e6f049 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:518 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d3d82c2 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:534 |  | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-edda29f3 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:535 |  | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-d5f7e415 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:536 |  | VALUE_SET | txtUpdater.Text | sUpdateId | 컨트롤 값 설정 |  |  |  |
| AC-f325e8f0 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:537 |  | VALUE_SET | txtUpdation.Text | sUpdateTime | 컨트롤 값 설정 |  |  |  |
| AC-351f49c6 | cboPlanId.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:538 |  | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a08fb4f3 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:781 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-2164e011 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:781 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-826671c2 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:784 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-514f1158 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:785 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-88707b66 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:786 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba98456f | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:787 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-583f2fff | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:788 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-b44e52c1 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:789 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5854521e | this.chk_Info.CheckedChanged | FP00637_Material_Cell_Simulation_Pack.cs:2848 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-c69e0b57 | this.chk_Info.CheckedChanged | FP00637_Material_Cell_Simulation_Pack.cs:2848 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59cb057a | this.chk_Info.CheckedChanged | FP00637_Material_Cell_Simulation_Pack.cs:2854 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4532e0c1 | this.chk_Info.CheckedChanged | FP00637_Material_Cell_Simulation_Pack.cs:2855 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beafb043 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1980 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-59c224ee | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1983 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-33018a7b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1984 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-04efe128 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1985 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a202280 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1986 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4de89563 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1987 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-65780935 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1988 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-33e02486 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1989 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-72d88449 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1990 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-38637e44 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1991 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e0a5314 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1992 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0712b9f6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1993 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0abe06d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1994 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-43bf9ed7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1996 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cfb7e0c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1997 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6fb6edd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1998 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SIM_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9284430 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:2003 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_SIM_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-da07cd22 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:2010 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-04afd809 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:2016 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-4888bb10 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:2019 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.CreateFilterDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33c2ce9 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1312 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f6660840 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1323 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-53d37c0a | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1324 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6c1c0281 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1331 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e88f0e7 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1335 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-6eb5f4ed | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1339 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2639b8b6 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1342 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-a19916e9 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1344 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd5575f9 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:738 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9980eace | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:739 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e5fe48c | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:740 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f893df4 | DeleteButton | FP00637_Material_Cell_Simulation_Pack.cs:1210 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-794d64d8 | Dispose | FP00637_Material_Cell_Simulation_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab7bb1fc | drpPeriod.ValueChanged | FP00637_Material_Cell_Simulation_Pack.cs:652 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-35f69a20 | drpPeriod.ValueChanged | FP00637_Material_Cell_Simulation_Pack.cs:659 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-75601422 | drpPeriod.ValueChanged | FP00637_Material_Cell_Simulation_Pack.cs:660 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-3120d305 | drpPeriod.ValueChanged | FP00637_Material_Cell_Simulation_Pack.cs:666 | if (int.Parse(sStartDate) > int.Parse(arrRetStart)) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(Filter["PLAN_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.drpPlanDate_changed

진입점: drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d1b6d4b | drpPlanDate.DateTimeChanged | FP00637_Material_Cell_Simulation_Pack.cs:629 |  | FLAG | dtPlanDate | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-e169aa21 | drpPlanDate.DateTimeChanged | FP00637_Material_Cell_Simulation_Pack.cs:629 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "DATE_TEMP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8709604d | drpPlanDate.DateTimeChanged | FP00637_Material_Cell_Simulation_Pack.cs:634 |  | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-17684349 | drpPlanDate.DateTimeChanged | FP00637_Material_Cell_Simulation_Pack.cs:637 |  | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(7) | 속성 Value2 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28b9308b | EditButton | FP00637_Material_Cell_Simulation_Pack.cs:1218 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02a36ec8 | ExcelButton | FP00637_Material_Cell_Simulation_Pack.cs:1058 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK")] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aa3ff91 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1895 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-c32773d9 | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1900 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-058e089e | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1902 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-db22b96d | popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1906 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == Spd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19f3c7f9 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1019 |  | FLAG | tmp | siMain.GetColumnIndex("FACTORY_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-3f98983a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1020 |  | FLAG | tmp | siMain.GetColumnIndex("LOCATION") | 화면 필드/플래그 변경 |  |  |  |
| AC-2b2eda6a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1021 |  | FLAG | tmp | siMain.GetColumnIndex("BOH_QTY") | 화면 필드/플래그 변경 |  |  |  |
| AC-471f9bcd | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1022 |  | FLAG | tmp | siMain.GetColumnIndex("BOH_CELL_QTY") | 화면 필드/플래그 변경 |  |  |  |
| AC-e9aa6ff1 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1023 |  | FLAG | tmp | siMain.GetColumnIndex("PRODUCTION_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-fd6de0e6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1024 |  | FLAG | tmp | siMain.GetColumnIndex("PSI") | 화면 필드/플래그 변경 |  |  |  |
| AC-66a038c0 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1025 |  | FLAG | tmp | siMain.GetColumnIndex("LINE_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-f27f0907 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1026 |  | FLAG | tmp | siMain.GetColumnIndex("LINE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-7ef40041 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1027 |  | FLAG | tmp | siMain.GetColumnIndex("ELECTRODE_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-9c3f4452 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1028 |  | FLAG | tmp | siMain.GetColumnIndex("PLAN_DATE") | 화면 필드/플래그 변경 |  |  |  |
| AC-12f0e74d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1029 |  | FLAG | tmp | siMain.GetColumnIndex("CATE") | 화면 필드/플래그 변경 |  |  |  |
| AC-3c14631a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1030 |  | FLAG | tmp | siMain.GetColumnIndex("CATEGORY_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-001133dc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1031 |  | FLAG | tmp | siMain.GetColumnIndex("CATEGORY_ORDER") | 화면 필드/플래그 변경 |  |  |  |
| AC-8be4ed14 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1032 |  | FLAG | tmp | siMain.GetColumnIndex("MEASURE_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-27185adb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1033 |  | FLAG | tmp | siMain.GetColumnIndex("MEASURE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-67d26825 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1034 |  | FLAG | tmp | siMain.GetColumnIndex("DATA_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-7a14a8f9 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1035 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.fn_columnChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2913f3b2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2032 | if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | EditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-48d00ecd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2033 | if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-256e218a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2042 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1d422a5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2047 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-c3eb3bd6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2053 | if (EditingCol != cCol) | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-b4b0ae16 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2104 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-164d1f64 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:163 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetDivision

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca044acf | cboInstance.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:675 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c91dc8d | cboInstance.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:675 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4204c75f | cboInstance.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:677 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetFactory

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f9e6c4d | clbPlant.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:698 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e149125 | clbPlant.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:698 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe68a217 | clbPlant.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:703 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetFilter

진입점: drpPlanDate.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK") ▸ try] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAme…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56d04a83 | drpPlanDate.DateTimeChanged 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1826 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetIsPast

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-384519d9 | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:396 |  | FLAG | dtIsPast | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-6177de53 | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:396 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "ISPAST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetLine

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ffff6ca | clbOperation.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:721 |  | DATA_OP | Filter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-2f35239e | clbOperation.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:723 |  | FLAG | dtLine | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b1edf52 | clbOperation.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:723 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "LINE_CODE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-85b06bbc | clbOperation.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:724 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetOperation

진입점: clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6bcbd83 | clbFactory.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:708 |  | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-d6984e83 | clbFactory.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:708 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OPERATION_CODE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e07d3295 | clbFactory.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:715 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetPlanGroup

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a956b647 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:390 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-728546af | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:390 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a428f593 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:391 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetPlanId

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / this.btnCreatePlanxx.Click [finally] / this.btnCreatePlan.Click [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2702c287 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:337 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-695d2765 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:337 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2f8988cf | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:338 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-28267137 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:341 | if (cboPlanId.Items.Count > 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b60249f2 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:355 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-94bd2e0d | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:356 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-2a78b339 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:357 | if (dtPlanId.Good()) | VALUE_SET | txtUpdater.Text | sUpdateId | 컨트롤 값 설정 |  |  |  |
| AC-966abaf9 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:358 | if (dtPlanId.Good()) | VALUE_SET | txtUpdation.Text | sUpdateTime | 컨트롤 값 설정 |  |  |  |
| AC-1e48e238 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:359 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-f8785ed7 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:371 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d533b306 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:372 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7e9090ba | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:373 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtUpdater.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-16990f2a | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:374 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtUpdation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-434bcb48 | this.Load 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:375 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetPlanPeriod

진입점: this.Load / cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82d73a02 | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:407 | if (!dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-d735c2e9 | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:408 | if (!dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(7) | 속성 Value2 설정 |  |  |  |
| AC-78f140b9 | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:426 | else of (!dtPlanId.Good()) | UI_PROP | drpPeriod.Text1 | sStart | 속성 Text1 설정 |  |  |  |
| AC-579b86ec | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:428 | else of (!dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(7) | 속성 Value2 설정 |  |  |  |
| AC-ac4f190f | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:432 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2c633d2c | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:433 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetPlant

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73197d59 | cboSite.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:689 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-ea29c1c8 | cboSite.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:689 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0cac7dd7 | cboSite.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:691 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GetSite

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66e305ca | clbDivision.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:682 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-099efc50 | clbDivision.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:682 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d9b257a | clbDivision.SelectedIndexChanged | FP00637_Material_Cell_Simulation_Pack.cs:684 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e5111e5 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1842 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GoDrawCellColor

진입점: this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.Acti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9542be3e | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1225 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5717738 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1227 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9dda0850 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1269 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On && calendar.Days != null) ▸ foreach (var day_item i… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61c34bce | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1270 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On && calendar.Days != null) ▸ foreach (var day_item i… | GRID_STYLE | siMain.SetBGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-1fb7eee3 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1282 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.GoEditMode

진입점: this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.Acti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7c4e3d2 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1689 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fc0cd57f | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1718 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_LOCK | siMain.LockRange2 | (rowindex, colindex, rowindex, colindex, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-9767f7b2 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1732 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d91aba6 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1733 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4148c71a | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1744 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d43ac80 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1748 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange2 | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3958d9d9 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1765 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, color242_255_237) | 그리드 표시 설정 |  |  |  |
| AC-9abc2f64 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1782 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, colorLightPink) | 그리드 표시 설정 |  |  |  |
| AC-d27de756 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1788 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-13556fb6 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1789 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75a2774a | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:178 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-87ff6b3f | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:182 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c186f78d | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:183 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cf6c1c4a | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:187 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-60f83945 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:191 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-79c34397 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:196 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5a49e460 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:198 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0aba4a12 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:198 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-01a87f69 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:200 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-72f8a86e | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:202 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16015d18 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:205 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-2785c58f | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:207 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cf853cd3 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:207 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.InitEditingBuf

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6b2c667 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1971 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e4832a8e | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1972 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-59a57a02 | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1973 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-5c605a7d | (진입점 미연결) | FP00637_Material_Cell_Simulation_Pack.cs:1974 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5bcb096 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:301 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ac608714 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:302 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9ac7c757 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:303 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-891c40c0 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:304 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-951e1ebc | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:305 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.InitSpread

진입점: this.Load / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11db8bda | this.Load 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:752 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a659fc8 | this.Load 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:753 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5ed19bb4 | this.Load 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:755 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-8a2da6e5 | this.Load 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:759 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-656eda9d | InsertButton | FP00637_Material_Cell_Simulation_Pack.cs:1194 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFilte…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c347883 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:796 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-fcde4a55 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:797 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-5caa78bf | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:798 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-506064e9 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:799 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9df7c209 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:816 | if (monthInfo != null) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-08be1135 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:822 | if (monthInfo != null) | CALL_EXT | MeasureService.CreateDateBucket | (measure, _sMeasureName, // chk_qty _sDateColumnTitleName, // "Plan(In)" _sDateColumnPrefi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd2f79ec | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:828 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumnEx_FP | (calendar, 3, use_month, use_week, use_day, DateColumnType.DDAY, DateColumnType.DDAY, Date… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4951f715 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:840 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-08927ce1 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:841 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c7f757e | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:845 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f5cc3fb | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:846 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-465e1f2b | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:849 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 14) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79e2e40a | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:850 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 14) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b24bba0a | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:851 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 28) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5d14825 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:853 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-ff2b85e4 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:864 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ae55718 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:866 | if (monthInfo != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-29a27b08 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:882 | if (monthInfo != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ for (i < _sFormatColumn.… | CALL_EXT | siMain.SetFormat | ("#,##0.0", colindex, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5bb5a44 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:891 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be37b324 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:892 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7088a78f | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:915 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToSt… | FLAG | tmp | total_color | 화면 필드/플래그 변경 |  |  |  |
| AC-e5f8910f | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:920 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToSt… | FLAG | tmp | sub_total_color | 화면 필드/플래그 변경 |  |  |  |
| AC-aac5c51e | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:927 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-642b3faa | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:949 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-da43dd44 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:953 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | colorBlue | 그리드 속성/값 설정 |  |  |  |
| AC-963f7b41 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:955 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-149a9379 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:959 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | colorRed | 그리드 속성/값 설정 |  |  |  |
| AC-47024a1a | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:974 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, color242_255_237) | 그리드 표시 설정 |  |  |  |
| AC-5c1c225e | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:989 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, colorLightPink) | 그리드 표시 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / SaveButton [if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6b4974d | this.Load [try] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1002 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-b290d0f6 | this.Load [try] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1003 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-3c622a23 | this.Load [try] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1004 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93e21cc2 | this.Load [try] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1005 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99bf0382 | this.Load [try] 외 6 | FP00637_Material_Cell_Simulation_Pack.cs:1006 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.RefreshSpreadSheet

진입점: this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.Acti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2adec219 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1657 |  | FLAG | dsMainFiltered | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a952f346 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1657 |  | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1096ca89 | this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.Activ… 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:1663 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9758385a | popSql.OnSql | FP00637_Material_Cell_Simulation_Pack.cs:1872 | if (programID == "PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-93507beb | popSql.OnSql | FP00637_Material_Cell_Simulation_Pack.cs:1874 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d600226d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1388 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8810cfa8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1398 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5384d47 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1399 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-01db3fe5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1405 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f60d57a1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1409 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-92590447 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1414 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-9cc6d2f3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1415 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-746dc4b2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1416 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-deea402b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1436 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ba77f3e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1444 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c620059 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1445 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b364d9fb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1446 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba7e3349 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1447 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22a494ed | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1448 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05f88aa5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1449 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1162b3ed | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1450 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f3819fa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1451 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d1e2b97 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1452 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7519ad5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1453 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f0a2542 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1454 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee8d7210 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1455 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee1d0093 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1456 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1c34f0f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1457 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-167d0af6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1442 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("COMPANY_ID") == enum_row_from_Saving["COMPANY_ID"].ToS… |  | 처리 중단/반환 |  |  |  |
| AC-29bded95 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1482 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-1303f7ea | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1487 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["SIM_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-7bb1ae3c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1488 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-f85d75ef | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1496 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f6bd3c2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1498 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ca8cbc4f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1499 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a901649 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1500 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c91ecded | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1501 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad150768 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1502 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-253b8131 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1503 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7fe6d0cf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1504 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5dee2531 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1505 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0eba7485 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1506 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MODEL_ID"] | enum_row_from_Saving["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94ed67b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1507 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1609d88b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1508 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0c6bb91b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1509 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-7a147736 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1510 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd023b65 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1511 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa6e31ea | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1513 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SIM_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-d823acbd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1514 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORG_SIM_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-e101172d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1515 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-290fcb8c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1517 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-50ca3c9f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1535 | try | DATA_OP | objDs.Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6885cd40 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1537 | try ▸ if (!objDs.Columns.Contains("USER_ID")) | DATA_OP | objDs.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3debd6d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1540 | try ▸ if (!objDs.Columns.Contains("USER_ID")) ▸ foreach (DataRow dr in objDs.Rows) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0ecc68fe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1544 | try | DATA_OP | Filter["SIM_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3cd72c30 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1546 | try | DATA_OP | objDs.Columns.Contains | ("SIM_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c82ff895 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1548 | try ▸ if (!objDs.Columns.Contains("SIM_PLAN_ID")) | DATA_OP | objDs.Columns.Add | (new DataColumn("SIM_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-86727c14 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1551 | try ▸ if (!objDs.Columns.Contains("SIM_PLAN_ID")) ▸ foreach (DataRow dr in objDs.Rows) | DATA_OP | dr["SIM_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6f8206c8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1616 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP00637_Material_Cell_Simulation_Pack", "merge_data", objDs.DataSet, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] \| FP\Planning\FP006… | 엔드포인트 호출 |  |  |  |
| AC-698640d2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1622 | try ▸ if (save_result) | ENDPOINT | DataService.FP_RunProcedure | ("FP00637_Material_Cell_Simulation_Pack", "execute_calculation", Filter.Dictionary, null, … ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_calculation] \| FP\Pl… | 엔드포인트 호출 |  |  |  |
| AC-ee02389b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1624 | try ▸ if (save_result) | RETURN | return save_result = true; |  | 처리 중단/반환 |  |  |  |
| AC-1ce9c9ca | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1628 | try ▸ else of (save_result) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-87202bd0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1636 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a795af58 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1637 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6bb0f907 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1641 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-17815a17 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00637_Material_Cell_Simulation_Pack.cs:1643 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85b623bd | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1201 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a59a215 | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1203 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14e65009 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:244 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-bec09553 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:244 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a980b575 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-45f6b0a2 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:250 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1cee555c | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:250 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56e02b58 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-261ac56e | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:257 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-6c7c25f1 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:257 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ceed2f3 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:259 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-993670c4 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:263 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-26fe82dd | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:263 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71c068d2 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:268 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-eb919fc8 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:272 |  | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-c0101c44 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:272 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OPERATION_CODE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-416cb7f2 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-da5de0c6 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:284 |  | FLAG | dtLine | Data_FP.CallGeneralProcedure2(("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b63c59b0 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:284 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "LINE_CODE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4d30b714 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:285 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SetCurrentDate

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c3b7b6 | this.Load 외 1 | FP00637_Material_Cell_Simulation_Pack.cs:447 |  | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8c0d003 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:138 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5f60aa6 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:140 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8a252de0 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:144 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-08fcb905 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:146 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-12a6157f | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:147 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7e9de99 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:149 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-50cee763 | this.Load | FP00637_Material_Cell_Simulation_Pack.cs:153 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SetDirty

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-345331fa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00637_Material_Cell_Simulation_Pack.cs:2450 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SetFilter

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged / cboInstance.SelectedIndexChanged [if (dtInstance.Good())] / cboPlanId.SelectedIndexChanged / edtPjtGroupName.TextChanged / edtModelName.TextChanged / edtModel.TextChanged / edtNickName.TextChanged / edtItem.TextChanged / drpPlanDate.DateTimeChanged / drpPeriod.ValueChanged / popSql.OnSql [if (programID == "PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK") ▸ try ▸ if (GetFilter("INSTANCE_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2cd285c | this.Load 외 22 | FP00637_Material_Cell_Simulation_Pack.cs:1821 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.SetSpreadInit

진입점: this.Load [try] / this.btnCreatePlanxx.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCreatePlan.Click [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.Act…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61da259a | this.Load [try] 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:767 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06248af4 | this.Load [try] 외 5 | FP00637_Material_Cell_Simulation_Pack.cs:768 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-009c56a7 | this.spdMain.ButtonClicked | FP00637_Material_Cell_Simulation_Pack.cs:2702 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af6f2cb1 | this.spdMain.CellClick | FP00637_Material_Cell_Simulation_Pack.cs:2545 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-764dbd5b | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2491 | if (day != null) | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8fbbba6 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2501 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00637_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CELL_CODE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8f3f8171 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2503 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cboInstance", CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00a82214 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2504 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "drpPlanDate", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f7b65bd | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2505 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cboPlanId", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8296fc9 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2506 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "drpPeriod", Filter["BUCKET_FROM"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81835096 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2507 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "edtItem", dtCellCode.Rows[0]["CELL_CODE"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-157f2c18 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2508 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "SIM_PLAN_ID", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50bd79c8 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2509 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "HISTORY_YN", Filter["HISTORY_YN"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ae7fb26 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2514 | if (day != null) ▸ if (colname.IndexOf("CELL") > -1) | CALL_BASE | openSubMenu | ("FP00627", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b2c21e9 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2518 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_plan_group", CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues)… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ba72dc0 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2519 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dtpPlanDate", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-752291e2 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2520 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_planid", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-542db0a2 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2521 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_division", dsMainFiltered.Tables[0].Rows[e.Row]["DIVISION_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ed56227 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2522 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_site", dsMainFiltered.Tables[0].Rows[e.Row]["SITE_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-141eb11e | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2523 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_plant", dsMainFiltered.Tables[0].Rows[e.Row]["PLANT_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7da3a7d | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2525 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "txtModel", dsMainFiltered.Tables[0].Rows[e.Row]["MODEL_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f13dfb4d | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2526 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dCalendar_planrange", Filter["BUCKET_FROM"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f538596 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2529 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "SIM_PLAN_ID", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3ef3f6d | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2530 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "HISTORY_YN", Filter["HISTORY_YN"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-573f7b20 | this.spdMain.CellDoubleClick | FP00637_Material_Cell_Simulation_Pack.cs:2531 | if (day != null) ▸ else of (colname.IndexOf("CELL") > -1) | CALL_BASE | openSubMenu | ("FP00629", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12d4ec8b | this.spdMain.Change | FP00637_Material_Cell_Simulation_Pack.cs:2467 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da127ee2 | this.spdMain.ChildControlDeactivated | FP00637_Material_Cell_Simulation_Pack.cs:2659 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f785b393 | this.spdMain.DragFillBlockCompleted | FP00637_Material_Cell_Simulation_Pack.cs:2669 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e18050e | this.spdMain.EditChange | FP00637_Material_Cell_Simulation_Pack.cs:2444 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8600fcc5 | this.spdMain.EditModeOff | FP00637_Material_Cell_Simulation_Pack.cs:2687 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34033a65 | this.spdMain.EditModeOn | FP00637_Material_Cell_Simulation_Pack.cs:2693 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-46cc1620 | this.spdMain.EditModeOn | FP00637_Material_Cell_Simulation_Pack.cs:2694 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90383d49 | this.spdMain.EditorFocused | FP00637_Material_Cell_Simulation_Pack.cs:2681 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b29e38e | this.spdMain.Enter | FP00637_Material_Cell_Simulation_Pack.cs:2644 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5319e6b0 | this.spdMain.Leave | FP00637_Material_Cell_Simulation_Pack.cs:2639 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc029911 | this.spdMain.SubEditorClosed | FP00637_Material_Cell_Simulation_Pack.cs:2675 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0388a92d | this.spdMain.SubEditorOpening | FP00637_Material_Cell_Simulation_Pack.cs:2664 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52b76861 | this.spdMain.TableChanged | FP00637_Material_Cell_Simulation_Pack.cs:2432 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3d64ebb | this.spdMain.TableChanged | FP00637_Material_Cell_Simulation_Pack.cs:2434 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9e62b71 | this.spdMain.TextChanged | FP00637_Material_Cell_Simulation_Pack.cs:2415 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef11c029 | this.spdMain.TextChanged | FP00637_Material_Cell_Simulation_Pack.cs:2417 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a376af0 | this.spdMain.Validated | FP00637_Material_Cell_Simulation_Pack.cs:2649 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78f2b3eb | this.spdMain.Validating | FP00637_Material_Cell_Simulation_Pack.cs:2654 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.UIFindData

진입점: this.btnCreatePlanxx.Click [finally] / this.btnCreatePlan.Click [finally] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton / SaveButton [if (save_success == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e05776cc | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1071 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67c23cbc | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1072 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91ecf2d6 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1075 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-92de9a1d | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1078 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-f156b1c9 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1082 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]) && !Filter["RELEASE_FLAG"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-d33e21fb | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1084 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]) && !Filter["RELEASE_FLAG"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1a40f92 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1088 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-624878ca | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1102 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrWhiteSpace(sInstance)) | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d3d5ba5 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1112 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sInstance == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-729682d6 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1113 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sInstance == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-885351c2 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1117 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2f3b9330 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1120 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-321f855c | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1121 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-79588a58 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1124 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c33ca6b3 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1134 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f9b42dae | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1136 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-36197047 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1136 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a2656a3 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1142 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e750440d | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1146 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8092f0d5 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1160 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a37013c | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1166 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-750efcf6 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1169 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa6ee772 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1175 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f3403ec | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1181 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-65decfa3 | this.btnCreatePlanxx.Click [finally] 외 4 | FP00637_Material_Cell_Simulation_Pack.cs:1185 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00637_Material_Cell_Simulation_Pack.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60e09584 | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1359 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-28c431fe | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1362 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7c6bd6cc | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1364 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff997244 | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1371 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-62ebaac7 | SaveButton | FP00637_Material_Cell_Simulation_Pack.cs:1376 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

