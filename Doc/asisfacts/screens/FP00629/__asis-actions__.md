# AS-IS 액션 대조표 — FP00629

> 원천: `Doc/asisfacts/screens/FP00629/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 703행 · 메서드 69 · 종류 FLAG 109 · DATA_OP 105 · UI_PROP 73 · RETURN 56 · VALUE_SET 55 · GRID_INIT 40 · STATE 37 · COMBO_DATA 34 · MESSAGE 33 · GRID_SET 31 · CALL_EXT 24 · UI_MISC 22 · POPUP 18 · LIST_REBIND 13 · VALUE_CLEAR 12 · GRID_STYLE 10 · ENDPOINT 9 · THROW 8 · GRID_BIND 6 · GRID_LOCK 4 · CALL_BASE 2 · EXCEL 2 · ⚠ 의미 확인 필요 26


## FP00629_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8971dfb | .ctor | FP00629_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-21f85797 | .ctor | FP00629_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-e4b23efd | .ctor | FP00629_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b74e71cd | .ctor | FP00629_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00629_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf622f47 | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:196 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-755f2e5a | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:196 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-97288b53 | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:198 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-3ddc5cad | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:202 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-19cdeaa2 | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:203 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-30b4ae05 | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:204 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8af23043 | this.btnOK.Click | FP00629_BucketSetForm_Popup.cs:205 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00629_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cf86cc7 | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:213 |  | VALUE_SET | chk_day.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-9963d8f2 | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:221 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-128c6c6a | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:221 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-379d2ef1 | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:223 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-5d6f2a46 | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:227 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-0ead4698 | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:228 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-42574cb8 | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:230 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1abaab9f | this.btbSet.Click | FP00629_BucketSetForm_Popup.cs:232 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00629_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f2c55f9 | Dispose | FP00629_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00629_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-262d3121 | this.Load | FP00629_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00629_BucketSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43bf1b87 | this.Load | FP00629_BucketSetForm_Popup.cs:143 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-6220e97c | this.Load | FP00629_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-21d17691 | this.Load | FP00629_BucketSetForm_Popup.cs:150 |  | DATA_OP | ctrls.Add | (chk_mat_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5883fe8 | this.Load | FP00629_BucketSetForm_Popup.cs:151 |  | DATA_OP | ctrls.Add | (chk_matin_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a70f06e7 | this.Load | FP00629_BucketSetForm_Popup.cs:153 |  | DATA_OP | ctrls.Add | (chk_eoh_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b9a2507 | this.Load | FP00629_BucketSetForm_Popup.cs:154 |  | DATA_OP | ctrls.Add | (chk_eoh2_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-39bf7510 | this.Load | FP00629_BucketSetForm_Popup.cs:155 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-d92e8212 | this.Load | FP00629_BucketSetForm_Popup.cs:157 |  | DATA_OP | ctrls.Add | (chk_comeoh_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-50691fee | this.Load | FP00629_BucketSetForm_Popup.cs:158 |  | DATA_OP | ctrls.Add | (chk_comeoh2_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd51d1d8 | this.Load | FP00629_BucketSetForm_Popup.cs:160 |  | VALUE_SET | chk_day.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-e28e1f67 | this.Load | FP00629_BucketSetForm_Popup.cs:162 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-49e25eea | this.Load | FP00629_BucketSetForm_Popup.cs:162 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-4f67e121 | this.Load | FP00629_BucketSetForm_Popup.cs:170 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-8c9df8b9 | this.Load | FP00629_BucketSetForm_Popup.cs:174 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-228cead5 | this.Load | FP00629_BucketSetForm_Popup.cs:178 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00629_BucketSetForm_Popup.InitNames

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4263d55a | this.Load | FP00629_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8769c683 | this.Load | FP00629_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_mat_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b0b4e9cc | this.Load | FP00629_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_matin_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b3c3a30f | this.Load | FP00629_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_eoh_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f0c81495 | this.Load | FP00629_BucketSetForm_Popup.cs:120 |  | VALUE_SET | chk_eoh2_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-39473735 | this.Load | FP00629_BucketSetForm_Popup.cs:121 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4414dac4 | this.Load | FP00629_BucketSetForm_Popup.cs:122 |  | VALUE_SET | chk_comeoh_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3e626359 | this.Load | FP00629_BucketSetForm_Popup.cs:123 |  | VALUE_SET | chk_comeoh2_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00629_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e4c3662 | this.Load | FP00629_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-da188bdc | this.Load | FP00629_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026c68c5 | .ctor | FP00629_MaterialDemandSupplySimul.cs:188 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d913af | .ctor | FP00629_MaterialDemandSupplySimul.cs:196 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-3d2d091f | .ctor | FP00629_MaterialDemandSupplySimul.cs:197 |  | FLAG | _refreshSync | pPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-8fdf9ab8 | .ctor | FP00629_MaterialDemandSupplySimul_Ref.cs:181 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-c0c900bb | .ctor | FP00629_MaterialDemandSupplySimul_Ref.cs:189 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-24e1729e | .ctor | FP00629_MaterialDemandSupplySimul_Ref.cs:190 |  | FLAG | _refreshSync | pPlanID | 화면 필드/플래그 변경 |  |  |  |

## FP00629_MaterialDemandSupplySimul.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == _FormSearchProcedure + "_SELECT") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e0a11fe | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:696 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bea943d3 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:697 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0698951b | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:698 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-169e44f6 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:699 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-59dbd62c | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:700 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-305bb388 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:701 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-91239cae | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:703 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4461e9d | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:704 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f6749036 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:706 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8f756bc | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:707 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-720c4c0e | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:709 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0958b57f | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:710 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a061e642 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:712 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c944263c | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:713 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-65abe085 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:715 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00629_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2513a374 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:716 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3b88c380 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:724 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-3f4ff1b2 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:725 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-12111f56 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:726 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-e709d854 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:727 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-ee3e9fb9 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:728 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-582c98f8 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:766 |  | DATA_OP | Filter["RESULT_VAL"] | sIsResult | 행/컬럼 값 대입 |  |  |  |
| AC-57409af7 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:767 |  | DATA_OP | Filter["RESULT_VAL2"] | sIsResult2 | 행/컬럼 값 대입 |  |  |  |
| AC-b68f70bc | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:595 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e81f15e0 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:596 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cce9c63b | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:597 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5eb1ff16 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:598 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9e1c9ed3 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:599 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3f106254 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:600 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a8554ed8 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:602 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FR… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c58d861b | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:603 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-bf5219b2 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:605 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-192de46c | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:606 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1ed282aa | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:608 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bf3f03f2 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:609 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1b552100 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:611 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b64c5180 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:612 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0b37799e | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:614 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00629_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cefa6681 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:615 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1b30f676 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:623 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-4bcff1eb | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:624 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-e35afebb | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:625 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-f15fdb85 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:626 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-fee26094 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:627 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-1231879c | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:665 |  | DATA_OP | Filter["RESULT_VAL"] | sIsResult | 행/컬럼 값 대입 |  |  |  |
| AC-54622959 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:666 |  | DATA_OP | Filter["RESULT_VAL2"] | sIsResult2 | 행/컬럼 값 대입 |  |  |  |

## FP00629_MaterialDemandSupplySimul.ApplySearchCondition

진입점: popSql.OnSql [if (programID == _FormSearchProcedure + "_SELECT") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2424168 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:772 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (GetFilter("INSTANCE_ID") == "") { SetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-df723411 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:782 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e2682936 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:783 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-879deef8 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:791 | lambda ▸ if (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-64600258 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:793 | lambda ▸ else of (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e86623a0 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:817 | lambda ▸ if (sInst.IndexOf("CELL") != -1) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-97f03f94 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:821 | lambda ▸ if (sInst.IndexOf("CELL") != -1) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-d5e54721 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:826 | lambda ▸ else of (sInst.IndexOf("CELL") != -1) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b92a8940 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:830 | lambda ▸ else of (sInst.IndexOf("CELL") != -1) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-bd181fbc | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:836 | lambda ▸ if (Filter["RELEASE_FLAG"].ToString() == "Y") | DATA_OP | Filter["AMEND_TABLE"] | "FP_DAILY_PRODUCTIOIN_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-8e35fa6c | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:671 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (GetFilter("INSTANCE_ID") == "") { SetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f65dca0 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:681 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b106cf30 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:682 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e267d8ea | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:690 | lambda ▸ if (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-cba6fb47 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:692 | lambda ▸ else of (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d50faf40 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:697 | lambda ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["IS_RESULT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3ba491d7 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:701 | lambda ▸ else of (rdoGroup1.SelectedIndex == 0) ▸ if (rdoGroup1.SelectedIndex == 1) | DATA_OP | Filter["IS_RESULT"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-03e4576e | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:705 | lambda ▸ else of (rdoGroup1.SelectedIndex == 0) ▸ else of (rdoGroup1.SelectedIndex == 1) ▸ if (rdoGroup1.SelectedIndex == 2) | DATA_OP | Filter["IS_RESULT"] | "2" | 행/컬럼 값 대입 |  |  |  |
| AC-108137b4 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:709 | lambda ▸ else of (rdoGroup1.SelectedIndex == 0) ▸ else of (rdoGroup1.SelectedIndex == 1) ▸ else of (rdoGroup1.SelectedIndex == 2) ▸ if (rdoG… | DATA_OP | Filter["IS_RESULT"] | "3" | 행/컬럼 값 대입 |  |  |  |
| AC-ce60ce45 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:716 | lambda ▸ if (sInst.IndexOf("CELL") != -1) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-3bd58b67 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:720 | lambda ▸ if (sInst.IndexOf("CELL") != -1) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-cbc224b2 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:725 | lambda ▸ else of (sInst.IndexOf("CELL") != -1) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-28ed4304 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:729 | lambda ▸ else of (sInst.IndexOf("CELL") != -1) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-54b362f9 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:735 | lambda ▸ if (Filter["RELEASE_FLAG"].ToString() == "Y") | DATA_OP | Filter["AMEND_TABLE"] | "FP_DAILY_PRODUCTIOIN_PLAN_H" | 행/컬럼 값 대입 |  |  |  |

## FP00629_MaterialDemandSupplySimul.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10f68d73 | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul.cs:1738 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d410659e | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul.cs:1741 |  | POPUP | new FP00629_BucketSetForm_Popup | ("FP00629", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-3ef0c5da | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul.cs:1742 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f58738f | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul.cs:1743 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b6451d9d | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul.cs:1749 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-ea97e924 | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1407 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1560b304 | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1410 |  | POPUP | new FP00629_BucketSetForm_Popup | ("FP00629", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-82e40b7f | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1411 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-d111f181 | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1412 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-43f6ec2a | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1413 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fd89906f | this.btnBucket.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1419 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00629_MaterialDemandSupplySimul.btnClose1_Click

진입점: this.btnClose1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0af2e0ab | this.btnClose1.Click | FP00629_MaterialDemandSupplySimul.cs:1827 |  | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-31b25127 | this.btnClose1.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1496 |  | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00629_MaterialDemandSupplySimul.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-affb4083 | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul.cs:1713 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-98b78fe5 | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul.cs:1716 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00629", SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-ca29d5d8 | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul.cs:1717 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cee0b91d | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul.cs:1718 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5bbfbfcd | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1382 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3326d5c9 | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1385 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00629", SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-99d11588 | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1386 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f5581ce | this.btnColumn.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1387 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00629_MaterialDemandSupplySimul.btnMrpReceive_Click

진입점: this.btnMrpReceive.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-571bd1b8 | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul.cs:1760 |  | MESSAGE | MessageBox.Show | ("Would you like to receive MRP material demand information?", "Confrim", MessageBoxButton… | 메시지 표시 |  |  |  |
| AC-8138478b | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul.cs:1762 | if (MessageBox.Show("Would you like to receive MRP material demand information?", "Confrim", MessageBoxButtons.YesNo) == Dia…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ffe9746 | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul.cs:1766 |  | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL", Filter, _CurrentUser, "SELECT", "EXECUTE_MRP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-45d23a45 | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul.cs:1770 | if (dsResult.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageBox.Show | ("Excution Done!") | 메시지 표시 |  |  |  |
| AC-73d2390a | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1430 |  | MESSAGE | MessageBox.Show | ("Would you like to receive MRP material demand information?", "Confrim", MessageBoxButton… | 메시지 표시 |  |  |  |
| AC-33ac81a2 | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1432 | if (MessageBox.Show("Would you like to receive MRP material demand information?", "Confrim", MessageBoxButtons.YesNo) == Dia…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be7d3d71 | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1436 |  | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL", Filter, _CurrentUser, "SELECT", "EXECUTE_MRP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ddcb094b | this.btnMrpReceive.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1440 | if (dsResult.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageBox.Show | ("Excution Done!") | 메시지 표시 |  |  |  |

## FP00629_MaterialDemandSupplySimul.btnMrpTransit_Click

진입점: this.btnMrpTransit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7510fee2 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1776 | if (siMain.GetMaxRowIndex() == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85618f6b | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1781 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-385ee5ea | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1782 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bf71a54 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1788 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Release plan can not proceed." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69e260c0 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1789 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fadbcce | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1793 |  | MESSAGE | MessageBox.Show | ("Will you proceed with MRP transmission? - " + Filter["PLAN_ID"], "Confrim", MessageBoxBu… | 메시지 표시 |  |  |  |
| AC-963202bc | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1795 | if (MessageBox.Show("Will you proceed with MRP transmission? - " + Filter["PLAN_ID"], "Confrim", MessageBoxButtons.YesNo) ==…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5cd0c79 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1801 |  | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL", Filter, _CurrentUser, "SELECT", "EXECUTE_MRP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e59c8e24 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul.cs:1803 |  | MESSAGE | MessageBox.Show | ("Saved!") | 메시지 표시 |  |  |  |
| AC-6e71486c | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1446 | if (siMain.GetMaxRowIndex() == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0535415 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1451 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-552893ee | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1452 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc5a7335 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1458 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Release plan can not proceed." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83c9f6e1 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1459 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73daeab2 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1463 |  | MESSAGE | MessageBox.Show | ("Will you proceed with MRP transmission? - " + Filter["PLAN_ID"], "Confrim", MessageBoxBu… | 메시지 표시 |  |  |  |
| AC-5696e999 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1465 | if (MessageBox.Show("Will you proceed with MRP transmission? - " + Filter["PLAN_ID"], "Confrim", MessageBoxButtons.YesNo) ==…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8e3dd82 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1471 |  | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL", Filter, _CurrentUser, "SELECT", "EXECUTE_MRP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b2861144 | this.btnMrpTransit.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1473 |  | MESSAGE | MessageBox.Show | ("Saved!") | 메시지 표시 |  |  |  |

## FP00629_MaterialDemandSupplySimul.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-524df1a5 | this.btnSql.Click | FP00629_MaterialDemandSupplySimul.cs:1814 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-345de8ff | this.btnSql.Click | FP00629_MaterialDemandSupplySimul.cs:1817 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-496ab21e | this.btnSql.Click | FP00629_MaterialDemandSupplySimul.cs:1818 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2eab516b | this.btnSql.Click | FP00629_MaterialDemandSupplySimul.cs:1820 |  | DATA_OP | popSql.Services.Add | (_FormSearchProcedure + "_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bb73a69 | this.btnSql.Click | FP00629_MaterialDemandSupplySimul.cs:1822 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-561ae2c8 | this.btnSql.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1483 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c5de0649 | this.btnSql.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1486 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9a7904e3 | this.btnSql.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1487 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3ae902aa | this.btnSql.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1489 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-734eec14 | this.btnSql.Click | FP00629_MaterialDemandSupplySimul_Ref.cs:1491 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00629_MaterialDemandSupplySimul.cbo_plan_group_changed

진입점: cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0121d9b | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1403 |  | FLAG | dtCurrDate | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_find_currdate", sInstance_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b5eb4567 | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1403 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_find_currdate", sInstance_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-481e5d28 | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1419 | if (dtCurrDate != null) | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-6c336ab8 | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1425 | else of (dtCurrDate != null) | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-1c6d8b56 | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1092 |  | FLAG | dtCurrDate | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_find_currdate", sInstance_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-2d89a069 | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1092 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_find_currdate", sInstance_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4945a41a | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1108 | if (dtCurrDate != null) | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-fe37d8d6 | cbo_plan_group.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1114 | else of (dtCurrDate != null) | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.cbo_planid_changed

진입점: cbo_planid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3380235 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1503 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[idx]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e972b79c | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1504 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["DESCRIPTION"] | dtPlanId.Rows[idx]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-284a2d1b | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1505 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["READ_ONLY"] | dtPlanId.Rows[idx]["READ_ONLY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef5dada5 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1506 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["PLAN_NAME"] | dtPlanId.Rows[idx]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6d62ecd | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1510 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (sReadOnly == "Y") | STATE | btnMrpReceive.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-14df8f4d | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1511 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (sReadOnly == "Y") | STATE | btnMrpTransit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b230a000 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1515 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ else of (sReadOnly == "Y") | STATE | btnMrpReceive.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8d979ef2 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul.cs:1516 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ else of (sReadOnly == "Y") | STATE | btnMrpTransit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a25532de | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1189 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[idx]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8a86a46b | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1190 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["DESCRIPTION"] | dtPlanId.Rows[idx]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d46c028 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1191 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["READ_ONLY"] | dtPlanId.Rows[idx]["READ_ONLY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d5ed13d | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1192 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["PLAN_NAME"] | dtPlanId.Rows[idx]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-77f059c8 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1196 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (sReadOnly == "Y") | STATE | btnMrpReceive.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-08a6e994 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1197 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (sReadOnly == "Y") | STATE | btnMrpTransit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c1ab1513 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1201 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ else of (sReadOnly == "Y") | STATE | btnMrpReceive.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-42dbc350 | cbo_planid.SelectedIndexChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1202 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtPlanId.Rows.Count > 0) ▸ else of (sReadOnly == "Y") | STATE | btnMrpTransit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00629_MaterialDemandSupplySimul.CheckAndGetMeasure

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e784bdc4 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1184 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-46bed988 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1184 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-4943e11e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1186 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88ae28b5 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1186 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-290f8903 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1190 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-75a8f9f6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1191 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-a7e706ab | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1192 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-50ae910f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1193 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-4b8361d0 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1194 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a7033db | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1195 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-eb556748 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:989 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-759b9085 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:989 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-c1ea7962 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:993 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-18fa4aad | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:994 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-d5acd3b0 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:995 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca069dfb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:996 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-dd98098a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:997 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-843141ec | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:998 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00629_MaterialDemandSupplySimul.chk_release_CheckedChanged

진입점: this.chk_release.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb9d6077 | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1580 | if (chk_release.Checked == true) | STATE | cbo_planid.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9e0b8b1b | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1581 | if (chk_release.Checked == true) | VALUE_CLEAR | cbo_planid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-ac5b0ea8 | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1585 | else of (chk_release.Checked == true) | STATE | cbo_planid.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-43944bdd | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1589 | else of (chk_release.Checked == true) ▸ if (cbo_planid.Items.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-31484bc0 | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1254 | if (chk_release.Checked == true) | STATE | cbo_planid.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-25a779eb | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1255 | if (chk_release.Checked == true) | VALUE_CLEAR | cbo_planid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-39c3e6d5 | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1259 | else of (chk_release.Checked == true) | STATE | cbo_planid.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aa5784cc | this.chk_release.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1263 | else of (chk_release.Checked == true) ▸ if (cbo_planid.Items.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.chkInfo_CheckedChanged

진입점: this.chkInfo.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-973809be | this.chkInfo.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1598 | if (chkInfo.Checked == true) | STATE | infoPanel.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0a102adc | this.chkInfo.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1599 | if (chkInfo.Checked == true) | UI_PROP | infoPanel.Location | new Point((this.ClientSize.Width / 2 - infoPanel.Size.Width / 2) + 50, btnMrpReceive.Locat… | 속성 Location 설정 |  |  |  |
| AC-b30da718 | this.chkInfo.CheckedChanged | FP00629_MaterialDemandSupplySimul.cs:1604 | else of (chkInfo.Checked == true) | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-89dbc2c5 | this.chkInfo.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1272 | if (chkInfo.Checked == true) | STATE | infoPanel.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-25ac637b | this.chkInfo.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1273 | if (chkInfo.Checked == true) | UI_PROP | infoPanel.Location | new Point((this.ClientSize.Width / 2 - infoPanel.Size.Width / 2) + 50, btnMrpReceive.Locat… | 속성 Location 설정 |  |  |  |
| AC-a29c7028 | this.chkInfo.CheckedChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1278 | else of (chkInfo.Checked == true) | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00629_MaterialDemandSupplySimul.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c584efe | this.Load | FP00629_MaterialDemandSupplySimul.cs:400 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8be3fd65 | this.Load | FP00629_MaterialDemandSupplySimul.cs:401 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-867e3a95 | this.Load | FP00629_MaterialDemandSupplySimul.cs:402 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-544dc553 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:345 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d0e0853 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:346 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-c15ce217 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:347 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00629_MaterialDemandSupplySimul.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged / this.dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddb9f8e5 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul.cs:1642 | if (Convert.ToDecimal(arrRetStart) != Convert.ToDecimal(sPlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b416152 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul.cs:1649 | if (Convert.ToDecimal(arrRetStart) != Convert.ToDecimal(sPlanDate)) | UI_PROP | dCalendar_planrange.Value1 | dPlanDate | 속성 Value1 설정 |  |  |  |
| AC-4f71e7a4 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul.cs:1651 | if (Convert.ToDecimal(arrRetStart) != Convert.ToDecimal(sPlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f89409bf | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul.cs:1654 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88dbde4c | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul.cs:1660 | if (Convert.ToDecimal(arrRetEnd) > 20000101) ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date.") | 메시지 표시 |  |  |  |
| AC-5917bca6 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul.cs:1661 | if (Convert.ToDecimal(arrRetEnd) > 20000101) ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-897a7382 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1316 | if (Convert.ToDecimal(arrRetStart) != Convert.ToDecimal(sPlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81a58cfe | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1323 | if (Convert.ToDecimal(arrRetStart) != Convert.ToDecimal(sPlanDate)) | UI_PROP | dCalendar_planrange.Value1 | dPlanDate | 속성 Value1 설정 |  |  |  |
| AC-28dabcad | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1325 | if (Convert.ToDecimal(arrRetStart) != Convert.ToDecimal(sPlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6503fcfa | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1328 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b862dc57 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1334 | if (Convert.ToDecimal(arrRetEnd) > 20000101) ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date.") | 메시지 표시 |  |  |  |
| AC-c8a505c0 | dCalendar_planrange.ValueChanged 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1335 | if (Convert.ToDecimal(arrRetEnd) > 20000101) ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf399cbf | DeleteButton | FP00629_MaterialDemandSupplySimul.cs:638 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a38e732 | DeleteButton | FP00629_MaterialDemandSupplySimul.cs:639 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b20ff24c | DeleteButton | FP00629_MaterialDemandSupplySimul_Ref.cs:446 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee13d5a3 | DeleteButton | FP00629_MaterialDemandSupplySimul_Ref.cs:447 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5cbbb0e | Dispose | FP00629_MaterialDemandSupplySimul.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00629_MaterialDemandSupplySimul.dtpPlanDate_ValueChanged

진입점: dtpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e978a6be | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul.cs:1443 |  | FLAG | dtCurrDate | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_find_currdate", sInstance_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-29f1ef67 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul.cs:1443 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_find_currdate", sInstance_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-994d2cf2 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul.cs:1454 | if (dtCurrDate != null) ▸ if (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f5f4570 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul.cs:1461 | if (dtCurrDate != null) ▸ if (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-f234a0f6 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul.cs:1468 | if (dtCurrDate != null) ▸ else of (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | UI_PROP | dCalendar_planrange.Value1 | dPlanDate | 속성 Value1 설정 |  |  |  |
| AC-4bbb3897 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul.cs:1469 | if (dtCurrDate != null) ▸ else of (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-b2d9938f | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1129 |  | FLAG | dtCurrDate | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_find_currdate", sInstance_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6506b4eb | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1129 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_find_currdate", sInstance_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20350f55 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1140 | if (dtCurrDate != null) ▸ if (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95cce865 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1147 | if (dtCurrDate != null) ▸ if (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-01759f7d | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1154 | if (dtCurrDate != null) ▸ else of (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | UI_PROP | dCalendar_planrange.Value1 | dPlanDate | 속성 Value1 설정 |  |  |  |
| AC-51eb4485 | dtpPlanDate.ValueChanged | FP00629_MaterialDemandSupplySimul_Ref.cs:1155 | if (dtCurrDate != null) ▸ else of (Convert.ToDecimal(sPlanDate) > Convert.ToDecimal(sCurrDate)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5d36b13 | EditButton | FP00629_MaterialDemandSupplySimul.cs:645 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc7b8818 | EditButton | FP00629_MaterialDemandSupplySimul.cs:646 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5995314 | EditButton | FP00629_MaterialDemandSupplySimul_Ref.cs:453 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1fde5582 | EditButton | FP00629_MaterialDemandSupplySimul_Ref.cs:454 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74b4fbe3 | ExcelButton | FP00629_MaterialDemandSupplySimul.cs:667 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |
| AC-a7b86555 | ExcelButton | FP00629_MaterialDemandSupplySimul_Ref.cs:475 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00629_MaterialDemandSupplySimul.Find_Data

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a67c5365 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:482 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0d959528 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:489 | try ▸ if (string.IsNullOrEmpty(sInstance)) | MESSAGE | MessageBox.Show | ("Insert FP Plan ID!.") | 메시지 표시 |  |  |  |
| AC-781d83fe | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:490 | try ▸ if (string.IsNullOrEmpty(sInstance)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-650f226b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:494 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-364c3263 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:495 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b581980a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:498 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b46c7ab1 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:503 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41947f25 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:510 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8ec5e31 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:510 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc012f6d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:530 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8c914a9d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:534 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f0866920 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:536 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-537d269e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:538 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c26e31f2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:546 | try ▸ if (chk_release.Checked == true) | VALUE_SET | lblPlanID.Text | "Plan ID:" | 컨트롤 값 설정 |  |  |  |
| AC-f101993c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:550 | try ▸ else of (chk_release.Checked == true) | VALUE_SET | lblPlanID.Text | "Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-52c20d19 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:557 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d1d90aa | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:563 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b4b5b73b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00629_MaterialDemandSupplySimul_Ref.cs:565 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00629_MaterialDemandSupplySimul.Find_Data_Amend

진입점: popSql.OnSql [if (programID == _FormSearchProcedure + "_SELECT")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44a06cc6 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:682 | try | FLAG | dtComBoh | Data_FP.CallGeneralProcedure2(("PR_UI_FP00629_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-7daeec55 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:682 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00629_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "COM_BOH") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4409d999 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:684 | try | ENDPOINT | Data_FP.CallGeneralProcedure | (_FormSearchProcedure, Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-42ca9fe2 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:686 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-2af203f0 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:690 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d1ded6b8 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:583 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL", Filter, _CurrentUser, pSysType, "SELECT_MAIN… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4fd03286 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:585 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a2a95185 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:589 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31695f46 | FindButton | FP00629_MaterialDemandSupplySimul_Ref.cs:427 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00629_MaterialDemandSupplySimul.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c534a07 | this.Load | FP00629_MaterialDemandSupplySimul.cs:209 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a8c3bca8 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:202 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00629_MaterialDemandSupplySimul.FpPlanFilterInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3ebfc2c | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2103 | if (!string.IsNullOrEmpty(_refreshSync)) ▸ if (cbo_planid.Items.Count > 0) | VALUE_SET | cbo_planid.SelectedValue | _refreshSync | 컨트롤 값 설정 |  |  |  |
| AC-cb4467c6 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2104 | if (!string.IsNullOrEmpty(_refreshSync)) ▸ if (cbo_planid.Items.Count > 0) | FLAG | _refreshSync | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-87d59224 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2110 | else of (!string.IsNullOrEmpty(_refreshSync)) ▸ if (cbo_planid.Items.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-bbbb057b | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1851 | if (!string.IsNullOrEmpty(_refreshSync)) ▸ if (cbo_planid.Items.Count > 0) | VALUE_SET | cbo_planid.SelectedValue | _refreshSync | 컨트롤 값 설정 |  |  |  |
| AC-9de9f717 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1852 | if (!string.IsNullOrEmpty(_refreshSync)) ▸ if (cbo_planid.Items.Count > 0) | FLAG | _refreshSync | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-db2ced38 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1858 | else of (!string.IsNullOrEmpty(_refreshSync)) ▸ if (cbo_planid.Items.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.GetDayColNameOfType_Local

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null && dayOn == true) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null && dayOn == true) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Length) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7ee3a26 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1178 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |
| AC-68cec1a2 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:982 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.GetFilter

진입점: popSql.OnSql [if (programID == _FormSearchProcedure + "_SELECT") ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49705ee0 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul.cs:1935 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |
| AC-f20afdf2 | popSql.OnSql [if (programID == _FormSearchProcedure + "_SELE… 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1683 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.GetFpPlanInfo

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dtpPlanDate.ValueChanged [if (dtCurrDate != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccaade41 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2128 | if (Filter["POPUP_OPEN"].ToString().Equals("Y")) | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_SIM_Plan_Info", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-35b1b596 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2128 | if (Filter["POPUP_OPEN"].ToString().Equals("Y")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_SIM_Plan_Info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e0715a2 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2132 | else of (Filter["POPUP_OPEN"].ToString().Equals("Y")) | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f97eb59f | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2132 | else of (Filter["POPUP_OPEN"].ToString().Equals("Y")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-979666c4 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2135 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_planid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5e256bbd | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2150 | if (dtPlanId != null) ▸ if (!string.IsNullOrEmpty(_sCurrPlanId)) ▸ if (dtPlanId.Rows.Count > 0) ▸ for (i < dtPlanId.Rows.Count) ▸ if (_sCurr… | VALUE_SET | cbo_planid.SelectedValue | dtPlanId.Rows[i]["PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b015a19e | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2160 | if (dtPlanId != null) ▸ else of (!string.IsNullOrEmpty(_sCurrPlanId)) ▸ if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-028154b3 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2182 | if (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpReceive.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3d267549 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2183 | if (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpTransit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-20f7bf5a | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2187 | else of (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpReceive.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83ccd640 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2188 | else of (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpTransit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-832d8920 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1873 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-69a3d056 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1873 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-728b6c15 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1874 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_planid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-08e10a58 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1889 | if (dtPlanId != null) ▸ if (!string.IsNullOrEmpty(_sCurrPlanId)) ▸ if (dtPlanId.Rows.Count > 0) ▸ for (i < dtPlanId.Rows.Count) ▸ if (_sCurr… | VALUE_SET | cbo_planid.SelectedValue | dtPlanId.Rows[i]["PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b5b8af63 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1899 | if (dtPlanId != null) ▸ else of (!string.IsNullOrEmpty(_sCurrPlanId)) ▸ if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-03d714c2 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1921 | if (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpReceive.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9afa4367 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1922 | if (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpTransit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ff3188cc | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1926 | else of (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpReceive.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-927b7587 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1927 | else of (Filter["READ_ONLY"].ToString() == "Y") | STATE | btnMrpTransit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00629_MaterialDemandSupplySimul.GetToDay

진입점: this.Load [try ▸ try] / cbo_plan_group.SelectedIndexChanged [else of (dtCurrDate != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3052933d | this.Load [try ▸ try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2308 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-334c82dd | this.Load [try ▸ try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2309 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |
| AC-051e55e7 | this.Load [try ▸ try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:2047 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f93a9d74 | this.Load [try ▸ try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:2048 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab5bac01 | this.Load | FP00629_MaterialDemandSupplySimul.cs:271 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f4b2f03 | this.Load | FP00629_MaterialDemandSupplySimul.cs:274 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9a23705 | this.Load | FP00629_MaterialDemandSupplySimul.cs:276 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d72151bb | this.Load | FP00629_MaterialDemandSupplySimul.cs:277 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-17ce735d | this.Load | FP00629_MaterialDemandSupplySimul.cs:287 | try ▸ if (IgnoreSearchCondition == true) | DATA_OP | ManualSearchCondition.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c6a0575 | this.Load | FP00629_MaterialDemandSupplySimul.cs:290 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | CALL_EXT | ManualSearchCondition.Tables[0].AsEnumerable().Where(a => a.Field<string>("ControlName").E… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c015195 | this.Load | FP00629_MaterialDemandSupplySimul.cs:290 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | DATA_OP | ManualSearchCondition.Tables[0].AsEnumerable().Where(a => a.Field<string>("ControlName").E… | (a => a.Field<string>("ControlValue")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af37ff52 | this.Load | FP00629_MaterialDemandSupplySimul.cs:290 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | DATA_OP | a.Field | ("ControlName") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e9f3b15 | this.Load | FP00629_MaterialDemandSupplySimul.cs:290 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | DATA_OP | a.Field | ("ControlValue") | 데이터 객체 조작/조회 |  |  |  |
| AC-6551f43e | this.Load | FP00629_MaterialDemandSupplySimul.cs:294 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | FLAG | _FormSearchProcedure | "PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL_SIMPOPUP" | 화면 필드/플래그 변경 |  |  |  |
| AC-e94d6c50 | this.Load | FP00629_MaterialDemandSupplySimul.cs:296 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | VALUE_SET | lblFpPlanId.Text | "Simulation ID" | 컨트롤 값 설정 |  |  |  |
| AC-0f4dd828 | this.Load | FP00629_MaterialDemandSupplySimul.cs:297 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | STATE | chk_release.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e64bf15a | this.Load | FP00629_MaterialDemandSupplySimul.cs:298 | try ▸ if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_… | UI_PROP | lblRelease.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9803e98f | this.Load | FP00629_MaterialDemandSupplySimul.cs:304 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1db1c54 | this.Load | FP00629_MaterialDemandSupplySimul.cs:310 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6d6a64ea | this.Load | FP00629_MaterialDemandSupplySimul.cs:322 | try | FLAG | dtSimulResult | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00629_MATERIALDEMANDSUPPLYSIMNUL"… | 화면 필드/플래그 변경 |  |  |  |
| AC-ddfd1ee9 | this.Load | FP00629_MaterialDemandSupplySimul.cs:322 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00629_MATERIALDEMANDSUPPLYSIMNUL", "SIMUL_RESULT_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d9110c4 | this.Load | FP00629_MaterialDemandSupplySimul.cs:331 | try | LIST_REBIND | clsCtrl.setListBox | (dtSimulResult, cboResult, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f761f0cc | this.Load | FP00629_MaterialDemandSupplySimul.cs:338 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-eda08e2a | this.Load | FP00629_MaterialDemandSupplySimul.cs:350 | try | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-01fa91f9 | this.Load | FP00629_MaterialDemandSupplySimul.cs:354 | try ▸ if (!Filter["POPUP_OPEN"].ToString().Equals("Y")) | VALUE_SET | chk_release.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-0388cb3c | this.Load | FP00629_MaterialDemandSupplySimul.cs:361 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f766ff84 | this.Load | FP00629_MaterialDemandSupplySimul.cs:362 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c7342fce | this.Load | FP00629_MaterialDemandSupplySimul.cs:363 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a77460e8 | this.Load | FP00629_MaterialDemandSupplySimul.cs:371 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-99372841 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:260 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-68672f01 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:263 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2781ee8 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:265 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7f050ab4 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:266 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-56e07f60 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:269 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cdb0eee | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:273 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-74a321e3 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:280 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-a359b60b | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:283 | try | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-49f939ce | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:289 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-05542578 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:301 | try | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c3e03e4e | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:303 | try | VALUE_SET | chk_release.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-421c1b12 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:308 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-bc48aec9 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:309 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ee927a53 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:310 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d9f48b3d | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:316 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00629_MaterialDemandSupplySimul.InitEditingBuf

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56796e50 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… | FP00629_MaterialDemandSupplySimul.cs:2314 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1697f7f5 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… | FP00629_MaterialDemandSupplySimul.cs:2315 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-f87a2cdd | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… | FP00629_MaterialDemandSupplySimul_Ref.cs:2053 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a9467097 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… | FP00629_MaterialDemandSupplySimul_Ref.cs:2054 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |

## FP00629_MaterialDemandSupplySimul.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7602095a | this.Load | FP00629_MaterialDemandSupplySimul.cs:242 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-055f31d3 | this.Load | FP00629_MaterialDemandSupplySimul.cs:243 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1a019dfa | this.Load | FP00629_MaterialDemandSupplySimul.cs:244 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4182af7c | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:235 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-be91d873 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:236 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1c9d5619 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:237 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa7eb2a7 | this.Load | FP00629_MaterialDemandSupplySimul.cs:414 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16594e63 | this.Load | FP00629_MaterialDemandSupplySimul.cs:415 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-13d1d074 | this.Load | FP00629_MaterialDemandSupplySimul.cs:422 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-c8bad4e9 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:359 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4973baaf | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:360 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-63b144ad | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:367 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00629_MaterialDemandSupplySimul.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c276eb | InsertButton | FP00629_MaterialDemandSupplySimul.cs:630 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6994f0af | InsertButton | FP00629_MaterialDemandSupplySimul.cs:631 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebfff3cd | InsertButton | FP00629_MaterialDemandSupplySimul_Ref.cs:438 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c6771b2 | InsertButton | FP00629_MaterialDemandSupplySimul_Ref.cs:439 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.onMemoMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a34d40c0 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1594 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56ae51f8 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1597 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21f5d12f | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1615 | if (day != null) | POPUP | new FPC0096_MemoEditPopup | (row, day, arg.Row, arg.Column) | 팝업/폼 생성 |  |  |  |
| AC-f2e10b9b | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1616 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-35fd830d | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1617 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00629_MaterialDemandSupplySimul.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeaee08c | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1630 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1e5365f | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1633 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be3be422 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1651 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5958dfdc | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1652 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | frm.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2867b13a | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1652 | if (day != null) | DATA_OP | frm.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-897351f2 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1653 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] = Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e35c9bcc | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1653 | if (day != null) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aa0e933f | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1654 | if (day != null) | DATA_OP | frm.Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee5e1919 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1654 | if (day != null) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-391451f7 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1655 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f0ee1c05 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1656 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c45cabd2 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1657 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-e243fbfe | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1658 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-84b1b5a6 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1659 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ccbfd92 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1660 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1db637cb | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1661 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00629_MaterialDemandSupplySimul.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99b6c69e | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:1843 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-336960cf | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:1846 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08bfb047 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:1870 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-03dd8f2a | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1512 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbaa1b2a | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1515 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56f4899b | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1539 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1ea16f3 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:1884 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b48d212 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:1887 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-366af8f4 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:1911 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-65bfbaaf | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1553 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-500eb370 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1556 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d355de31 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1580 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efba8f5e | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1009 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d57076d7 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1010 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-d9b3c20f | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1011 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-775596d6 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1012 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-2118f269 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1024 | if (monthInfo != null) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-bd7a04fa | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1029 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-57426bb2 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1033 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-811d3417 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1038 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bec07eba | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1040 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ddede931 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1045 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-480c754c | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1046 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-394ba0d5 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1048 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb8b7063 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1049 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e5e6ee1 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1050 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b6971fd | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1055 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8029280 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1057 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f7164bd5 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1062 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6530451b | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1080 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b336bc20 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1082 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | color_Blue | 그리드 속성/값 설정 |  |  |  |
| AC-b9583e7f | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1084 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1eb2ff26 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul.cs:1086 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | color_Red | 그리드 속성/값 설정 |  |  |  |
| AC-c3cabc69 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:807 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-254cf05d | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:808 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-3ded6175 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:809 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-1e8f6b15 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:810 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-f5dec129 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:823 | if (monthInfo != null) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-834cb289 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:824 | if (monthInfo != null) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-51dd97f5 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:832 | if (monthInfo != null) | CALL_EXT | MeasureService.CreateDateBucket | (measure, _sMeasureName, // chk_qty _sDateColumnTitleName, // "Plan(In)" _sDateColumnPrefi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-44c95c35 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:838 | if (monthInfo != null) | FLAG | added_columns_count | siMain.SetAmendHeaderColumnEx_FP(calendar, 3, bUse_month, bUse_week, bUse_day, DateColumnT… | 화면 필드/플래그 변경 |  |  |  |
| AC-cd450bad | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:838 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumnEx_FP | (calendar, 3, bUse_month, bUse_week, bUse_day, DateColumnType.DDAY, DateColumnType.DDAY, D… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8e2d3f0 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:849 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-519ee221 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:853 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-deeba1ea | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:858 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00089d02 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:860 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ad7b7fa7 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:865 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31311685 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:866 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e147a9d6 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:868 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 14) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f917945e | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:869 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 14) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83558976 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:870 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 28) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54e75aa0 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:875 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca24caf1 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:877 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-af601eeb | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:882 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12d7a120 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:898 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-981d2ad3 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:902 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-35950683 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:904 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a5b6558 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:908 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.RefreshHeaderOnly

진입점: this.Load [try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c8d621f | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:441 | if (monthInfo == null) | GRID_INIT | siMain.InitSheet | (SpdSheet.shtPlanAmendMA) | 그리드 재구성/초기화 |  |  |  |
| AC-8022d6e2 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:443 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-bf4468dc | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:444 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("SHORTAGE_DATE") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-78fdfc03 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:445 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23c9ea21 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:446 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eada1911 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:447 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc51cd18 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:448 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4185da59 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:455 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-6122b942 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:456 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |
| AC-16430c0c | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:386 | if (monthInfo == null) | GRID_INIT | siMain.InitSheet | (SpdSheet.shtPlanAmendMA) | 그리드 재구성/초기화 |  |  |  |
| AC-5c1104fd | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:388 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-55293fad | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:389 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("SHORTAGE_DATE") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-7abb4f65 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:390 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e436055f | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:391 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fe4fabc | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:392 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05dfcf40 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:393 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3b887cd | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:400 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-f281965a | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:401 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.RefreshSpreadSheet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8021e6a8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:946 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-c20be3a2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:946 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-319c86c4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:958 | try | FLAG | dsMainFiltered | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4ee8b17a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:958 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d08339dd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:967 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c033fc89 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:989 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-24f4e0b3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:747 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-7baa91a2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:747 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-98442c39 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:759 | try | FLAG | dsMainFiltered | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-691dcd24 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:759 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-571efaf7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:766 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00629_MaterialDemandSupplySimul.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40dd5c85 | popSql.OnSql | FP00629_MaterialDemandSupplySimul.cs:2323 | if (programID == _FormSearchProcedure + "_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-ff5b4770 | popSql.OnSql | FP00629_MaterialDemandSupplySimul.cs:2326 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4d8a7bde | popSql.OnSql | FP00629_MaterialDemandSupplySimul_Ref.cs:2062 | if (programID == "PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-0bd9a8b1 | popSql.OnSql | FP00629_MaterialDemandSupplySimul_Ref.cs:2065 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9bf06b1 | SaveButton | FP00629_MaterialDemandSupplySimul.cs:652 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-900ede78 | SaveButton | FP00629_MaterialDemandSupplySimul.cs:653 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33bad1cb | SaveButton | FP00629_MaterialDemandSupplySimul_Ref.cs:460 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c882263 | SaveButton | FP00629_MaterialDemandSupplySimul_Ref.cs:461 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetAmendHeaderColumn_FP_Local

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97cc7318 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1097 |  | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-203b6ee6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1103 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62dd20b1 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1106 | if (!dtSheetColumnConfig.Good()) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-65265bfc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1107 | if (!dtSheetColumnConfig.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b84c432b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1124 | foreach (var week_item in calendar.Weeks) ▸ if (week != null && dayOn == true) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateCol… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c67f0a7c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1125 | foreach (var week_item in calendar.Weeks) ▸ if (week != null && dayOn == true) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateCol… | CALL_EXT | MenuService.SetMenuColumn | (dateRow, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _sDat… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4eccb7cf | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1135 | foreach (var week_item in calendar.Weeks) ▸ if (week != null && dayOn == true) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateCol… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ca2e720 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1136 | foreach (var week_item in calendar.Weeks) ▸ if (week != null && dayOn == true) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateCol… | FLAG | added_columns_count | added_columns_count++ | 화면 필드 증감 |  |  |  |
| AC-96a5324f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1166 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-65e283e5 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1167 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5f85709 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1170 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-d338ff00 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul.cs:1171 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-839a6ae8 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:921 |  | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-7a2b7e2f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:927 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f67c2317 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:930 | if (!dtSheetColumnConfig.Good()) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e64cc6a2 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:931 | if (!dtSheetColumnConfig.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06e913a5 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:947 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25074fd6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:949 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | CALL_EXT | MenuService.SetMenuColumn | (dateRow, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _sDat… | ⚠ 의미 확인 필요 |  |  |  |
| AC-529a50b7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:959 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e35f21fa | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:960 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | FLAG | added_columns_count | added_columns_count++ | 화면 필드 증감 |  |  |  |
| AC-08cba06c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:970 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e32906ca | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:971 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7a49bad | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:974 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-b331769a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:975 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetBohQty

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feb48d3c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:850 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-a897a6bb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:851 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-df3f9076 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:852 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a49b980b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:853 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-643efb68 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:867 | foreach (DataRow row in dtComBoh.Rows) ▸ lambda | DATA_OP | rowx.Field | ("MATERIAL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e62e8c5c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:883 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a99a06c9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:884 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f17a103 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:885 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ lambda | DATA_OP | each_row.Field | ("MATERIAL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-823dbfc6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:895 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ foreach (Da… | DATA_OP | result[colname] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e1385f51 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:900 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ foreach (Da… | DATA_OP | result[colname] | (Math.Abs(iComEoh) - LWH_BOH) * -1 | 행/컬럼 값 대입 |  |  |  |
| AC-91d69eba | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:912 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ foreach (Da… | DATA_OP | result[colname2] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-3d9effdf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:917 | foreach (DataRow row in dtComBoh.Rows) ▸ foreach (DataRow dr in list_Material) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ foreach (Da… | DATA_OP | result[colname2] | (Math.Abs(iComEoh2) - M_BOH) * -1 | 행/컬럼 값 대입 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetColumnHidden

진입점: this.Load [try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8b6b904 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:465 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CLASS_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a6e2c5d8 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:466 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IS_RESULT)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cd45eef1 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:468 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IS_RESULT_COLOR)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-acc34730 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:469 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SORT_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5fa787a2 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:470 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MATERIAL_RANK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3555cd9e | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:407 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f69d7d63 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:408 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5dbea44e | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:409 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-faa60135 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:410 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CLASS_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a4f3a67 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:411 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IS_RESULT)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7b64fd23 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:413 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IS_RESULT_COLOR)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-81c40f09 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:414 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SORT_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c28603a2 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:415 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MATERIAL_RANK)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetCurrPlanDate_Default

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1887eeb | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:2007 | try | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-d69fa2b3 | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:2010 | try | UI_PROP | dCalendar_planrange.Value1 | dPlanDate | 속성 Value1 설정 |  |  |  |
| AC-1fce99f2 | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:2011 | try | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-89183494 | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:2016 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-bfa72cf2 | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1755 | try | VALUE_SET | dtpPlanDate.Value | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-d30f596b | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1758 | try | UI_PROP | dCalendar_planrange.Value1 | dPlanDate | 속성 Value1 설정 |  |  |  |
| AC-3eac3e55 | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1759 | try | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-1f008a35 | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1764 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2339bef2 | this.Load | FP00629_MaterialDemandSupplySimul.cs:229 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-147871ba | this.Load | FP00629_MaterialDemandSupplySimul.cs:231 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4126dda5 | this.Load | FP00629_MaterialDemandSupplySimul.cs:235 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4bbadf41 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:222 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaad377d | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:224 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-833ada43 | this.Load | FP00629_MaterialDemandSupplySimul_Ref.cs:228 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-240b4d0a | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:1954 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-cc08c89e | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:1954 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd30f8df | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul.cs:1955 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bc98cc4d | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1702 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-c10d6801 | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1702 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bf8004dd | this.Load [try] 외 1 | FP00629_MaterialDemandSupplySimul_Ref.cs:1703 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dtpPlanDate.ValueChanged [if (dtCurrDate != null)] / cbo_planid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / cboResult.SelectedIndexChanged [try] / txtPjtGroupName.TextChanged / txtModel.TextChanged / txtItem.TextChanged / txtNickName.TextChanged / dCalendar_planrange.ValueChanged / chk_alt.CheckedChanged / popSql.OnSql [if (programID == _FormSearchProcedure + "_SELECT") ▸ try ▸ lambda ▸ if (GetFilter("INSTANCE_ID")…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dd9c2b9 | this.Load [try] 외 20 | FP00629_MaterialDemandSupplySimul.cs:1930 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-5ad9abf7 | this.Load [try] 외 20 | FP00629_MaterialDemandSupplySimul_Ref.cs:1678 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetFpPlanFilterInit

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dtpPlanDate.ValueChanged [if (dtCurrDate != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e9536ec | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2277 |  | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-08f978c7 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2284 | if (string.IsNullOrEmpty(sEnd)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-72053dfd | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:2292 | else of (string.IsNullOrEmpty(sEnd)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-2f561e22 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:2016 |  | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-1692c5b1 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:2023 | if (string.IsNullOrEmpty(sEnd)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-90bdff4d | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:2031 | else of (string.IsNullOrEmpty(sEnd)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetOperation

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aa513e0 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1984 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4bbf964a | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1984 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0d4741cc | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1986 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d9e74738 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1732 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findOperationCode_common",… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6a252ff2 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1732 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVIS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b0e8e64 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1734 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b95212a | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:1940 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_findInstanceList_common", … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-82488bed | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:1940 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_findInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-59116da1 | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:1941 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-925bad0a | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1688 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00629_findInstanceList_common", … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3acaa25e | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1688 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00629_findInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-db5f82a6 | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:1689 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetPlanInfo

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dtpPlanDate.ValueChanged [if (dtCurrDate != null)] / cbo_planid.SelectedIndexChanged [if (!string.IsNullOrEmpty(sPlanID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8dd1e22 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2206 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-204544cd | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2207 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-8994d34d | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2208 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-7ba1d936 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2209 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-70136e4a | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2210 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-fd6da6f8 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2214 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4574b653 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2215 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-40c9c72f | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2216 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4306c556 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2217 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3d6090cc | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul.cs:2218 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-bb96c0f8 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1945 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-c8cc2cfc | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1946 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-4337b567 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1947 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-a6346ccb | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1948 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-53ed30b7 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1949 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-858003bc | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1953 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ea54cda6 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1954 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3aee9866 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1955 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-14c3be42 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1956 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-fb5cc2f3 | this.Load [try] 외 3 | FP00629_MaterialDemandSupplySimul_Ref.cs:1957 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetPlanPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-444a247e | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2029 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bb04b92 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2044 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-1f7e638c | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2045 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-3481235b | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2049 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-ff73da96 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2050 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-3f49dbaf | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2056 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-b57ebc18 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul.cs:2057 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-3025c011 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1777 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-933de923 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1792 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-0c96c60c | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1793 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-e353ac35 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1797 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-654894a8 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1798 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-02fb1929 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1804 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-d8ad6e40 | (진입점 미연결) | FP00629_MaterialDemandSupplySimul_Ref.cs:1805 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetPlant

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5f15b5d | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1974 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-015c53fc | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1974 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e84792aa | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1976 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-31e70bb3 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1722 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-85b6dacf | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1722 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2304a57b | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1724 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetShortageDate

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30cbfe04 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1205 | lambda | DATA_OP | each_row.Field | ("_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d57cc7e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1238 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sKeyYN.Equals("Y")) | GRID_STYLE | siMain.SetFontBold | (nRow, siMain.GetColumnIndex(DefColumns.MATERIAL_ID), nRow, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-7a98d4e4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1246 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate) && (siMain.GetColumnIndex(… | DATA_OP | each_row.Field | ("_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-08deb4a1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1282 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate) && (siMain.GetColumnIndex(… | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-52d41d9b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1290 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate) && (siMain.GetColumnIndex(… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.SHORTAGE_DATE), sInputDate) | 그리드 값 설정 |  |  |  |
| AC-25411978 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1297 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate) && (siMain.GetColumnIndex(… | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-08b77e07 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1305 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate) && (siMain.GetColumnIndex(… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.PROD_SHORTAGE_DATE), sInputDate) | 그리드 값 설정 |  |  |  |
| AC-efb3fdec | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1310 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate) && (siMain.GetColumnIndex(… | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-e24609e6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1328 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("2") && string.IsNullOrEmpty(sProdShortageDate) && siMain.GetColumnInd… | DATA_OP | each_row.Field | ("_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-106234b9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1350 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("2") && string.IsNullOrEmpty(sProdShortageDate) && siMain.GetColumnInd… | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6cd9f59 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1358 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("2") && string.IsNullOrEmpty(sProdShortageDate) && siMain.GetColumnInd… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.PROD_SHORTAGE_DATE), sInputDate) | 그리드 값 설정 |  |  |  |
| AC-6af7cc47 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1359 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("2") && string.IsNullOrEmpty(sProdShortageDate) && siMain.GetColumnInd… | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-3b9deb35 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1379 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sResultColor.Equals("red")) | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-0f43a4a5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1382 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sResultColor.Equals("green")) | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-57cca10c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul.cs:1385 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sResultColor.Equals("orange")) | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-aba9fc44 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1008 | lambda | DATA_OP | each_row.Field | ("_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a094d46c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1035 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) ▸ lambda | DATA_OP | each_row.Field | ("_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb71335a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1056 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-24ce2920 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1064 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.SHORTAGE_DATE), sInputDate) | 그리드 값 설정 |  |  |  |
| AC-81a00215 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1065 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |
| AC-4c820e63 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1069 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) ▸ if (sResultColor.Equals… | GRID_STYLE | siMain.SetForeColor | (nRow, siMain.GetColumnIndex(sPlanDateCol2_tmp)-1, nRow, siMain.GetColumnIndex(sPlanDateCo… | 그리드 표시 설정 |  |  |  |
| AC-cd299571 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1070 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ if (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) ▸ if (sResultColor.Equals… | GRID_STYLE | siMain.SetForeColor | (nRow, siMain.GetColumnIndex(sPlanDateCol2_tmp), nRow, siMain.GetColumnIndex(sPlanDateCol2… | 그리드 표시 설정 |  |  |  |
| AC-840c515f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1076 | foreach (DataRow row in dsMain.Tables[0].Rows) ▸ else of (sIsResult.Equals("1") && string.IsNullOrEmpty(sShortageDate)) ▸ if (sResultColor.E… | GRID_STYLE | siMain.SetBGColor | (nRow, siMain.GetColumnIndex(DefColumns.IS_RESULT_NAME), nRow, siMain.GetColumnIndex(DefCo… | 그리드 표시 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetSite

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63cf3269 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1963 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-deb67e5c | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1963 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2da65e8 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul.cs:1964 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7af99715 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1711 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a80c0baf | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1711 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f27639b | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1712 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-12adb834 | this.Load [try] 외 2 | FP00629_MaterialDemandSupplySimul_Ref.cs:1715 | if (dtSite.Rows.Count == 1) | VALUE_SET | cbo_site.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00629_MaterialDemandSupplySimul.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7d4745a | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:430 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebae4268 | this.Load [try] | FP00629_MaterialDemandSupplySimul.cs:431 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-d431bf26 | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:375 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dceecabb | this.Load [try] | FP00629_MaterialDemandSupplySimul_Ref.cs:376 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00629_MaterialDemandSupplySimul.UIFindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f214b89 | FindButton | FP00629_MaterialDemandSupplySimul.cs:487 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a10d1788 | FindButton | FP00629_MaterialDemandSupplySimul.cs:488 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05fdeedb | FindButton | FP00629_MaterialDemandSupplySimul.cs:491 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c6f2bdb5 | FindButton | FP00629_MaterialDemandSupplySimul.cs:494 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-da586706 | FindButton | FP00629_MaterialDemandSupplySimul.cs:508 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrEmpty(sInstance)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b00f2168 | FindButton | FP00629_MaterialDemandSupplySimul.cs:509 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrEmpty(sInstance)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48521da6 | FindButton | FP00629_MaterialDemandSupplySimul.cs:519 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrWhiteSpace(sPlanId)) ▸ if (!Filter["POPUP_OPEN… | VALUE_SET | chk_release.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8ad15852 | FindButton | FP00629_MaterialDemandSupplySimul.cs:526 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrWhiteSpace(sPlanId) && !Filter["RELEASE_FLAG"]… | MESSAGE | MessageBox.Show | ("You need to select one Plan to proceed") | 메시지 표시 |  |  |  |
| AC-d0b51a01 | FindButton | FP00629_MaterialDemandSupplySimul.cs:528 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrWhiteSpace(sPlanId) && !Filter["RELEASE_FLAG"]… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50fbba53 | FindButton | FP00629_MaterialDemandSupplySimul.cs:534 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8d6c1e90 | FindButton | FP00629_MaterialDemandSupplySimul.cs:535 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2a872ca2 | FindButton | FP00629_MaterialDemandSupplySimul.cs:538 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-34cef390 | FindButton | FP00629_MaterialDemandSupplySimul.cs:543 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00c8d4e9 | FindButton | FP00629_MaterialDemandSupplySimul.cs:550 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-a435c3e2 | FindButton | FP00629_MaterialDemandSupplySimul.cs:550 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c8b620fa | FindButton | FP00629_MaterialDemandSupplySimul.cs:570 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-10aacdee | FindButton | FP00629_MaterialDemandSupplySimul.cs:574 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-df3cef68 | FindButton | FP00629_MaterialDemandSupplySimul.cs:576 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa844084 | FindButton | FP00629_MaterialDemandSupplySimul.cs:578 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-04138a98 | FindButton | FP00629_MaterialDemandSupplySimul.cs:586 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (chk_release.Checked == true) | VALUE_SET | lblPlanID.Text | "Plan ID:" | 컨트롤 값 설정 |  |  |  |
| AC-45bd1a51 | FindButton | FP00629_MaterialDemandSupplySimul.cs:590 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (chk_release.Checked == true) | VALUE_SET | lblPlanID.Text | "Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-eab3b958 | FindButton | FP00629_MaterialDemandSupplySimul.cs:597 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53ac5219 | FindButton | FP00629_MaterialDemandSupplySimul.cs:603 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c6063565 | FindButton | FP00629_MaterialDemandSupplySimul.cs:617 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-c539bfbe | FindButton | FP00629_MaterialDemandSupplySimul.cs:621 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

