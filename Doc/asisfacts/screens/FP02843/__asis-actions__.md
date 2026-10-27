# AS-IS 액션 대조표 — FP02843

> 원천: `Doc/asisfacts/screens/FP02843/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 490행 · 메서드 53 · 종류 DATA_OP 193 · FLAG 43 · CALL_EXT 36 · GRID_SET 35 · RETURN 33 · UI_PROP 31 · GRID_INIT 22 · UI_MISC 17 · GRID_STYLE 13 · POPUP 10 · GRID_LOCK 9 · MESSAGE 8 · COMBO_DATA 8 · THROW 7 · STATE 6 · LIST_REBIND 6 · ENDPOINT 4 · GRID_BIND 3 · STATE_RESET 2 · CALL_BASE 2 · VALUE_SET 1 · EXCEL 1 · ⚠ 의미 확인 필요 38


## FP02843_UI_WH_CAPA..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67559e93 | .ctor | FP02843_UI_WH_CAPA.cs:172 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02843_UI_WH_CAPA.btn_setupinfo_Click

진입점: this.btnSetupColor2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e77e350 | this.btnSetupColor2.Click | FP02843_UI_WH_CAPA.cs:3173 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-60697b84 | this.btnSetupColor2.Click | FP02843_UI_WH_CAPA.cs:3174 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdc387d7 | this.btnSetupColor2.Click | FP02843_UI_WH_CAPA.cs:3180 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e069ac14 | this.btnSetupColor2.Click | FP02843_UI_WH_CAPA.cs:3183 |  | POPUP | new FPC0108_btn_setupinfoPopup | (Filter["INSTANCE_ID"]) | 팝업/폼 생성 |  |  |  |
| AC-f5f7416b | this.btnSetupColor2.Click | FP02843_UI_WH_CAPA.cs:3185 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a8202105 | this.btnSetupColor2.Click | FP02843_UI_WH_CAPA.cs:3186 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02843_UI_WH_CAPA.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d49f17c | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3125 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-777f648a | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3128 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanByModelElectrode, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-d13f0305 | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3129 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4b954972 | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3130 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e9543b5f | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3136 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-78fce0fb | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3136 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanByModelElectrode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7452d34a | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3137 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-6c40e418 | this.btnColumn.Click | FP02843_UI_WH_CAPA.cs:3143 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02843_UI_WH_CAPA.btnMemo_Click

진입점: this.btnMemo2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-380afc61 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3222 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-ebbc6449 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3223 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76233728 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3226 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e5f2c40e | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3228 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-31d34872 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3229 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-79377cb1 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3230 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-15018568 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3231 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-f94a02fd | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3232 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-534593c6 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3232 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-14b65d5c | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3233 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-778df713 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3234 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ca12081 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3235 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-41ea5e2e | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3236 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c317e7eb | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3237 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-df4404ff | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3238 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9735b7ee | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3239 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-27931bf6 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3240 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-45a1c114 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3241 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7a38ba96 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3243 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c13184c9 | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3244 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-9148b7dc | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3245 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-f14d116d | this.btnMemo2.Click | FP02843_UI_WH_CAPA.cs:3246 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02843_UI_WH_CAPA.btnPlanInfo_Click

진입점: this.btnPlanInfo2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a06a8c71 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3196 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-b6b641d0 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3197 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7d877eb | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3203 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7c9d8921 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3206 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-12449a49 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3207 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-55f1cd76 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3207 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dcb41cc7 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3208 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-007a13f9 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3209 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e7795e0f | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3211 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e4a20889 | this.btnPlanInfo2.Click | FP02843_UI_WH_CAPA.cs:3212 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02843_UI_WH_CAPA.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e65b1d7 | this.btnSql.Click | FP02843_UI_WH_CAPA.cs:3258 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-5ad52119 | this.btnSql.Click | FP02843_UI_WH_CAPA.cs:3261 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2df3d1f0 | this.btnSql.Click | FP02843_UI_WH_CAPA.cs:3262 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9355beec | this.btnSql.Click | FP02843_UI_WH_CAPA.cs:3264 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02843_WH_CAPA") | 데이터 객체 조작/조회 |  |  |  |
| AC-813b27fa | this.btnSql.Click | FP02843_UI_WH_CAPA.cs:3267 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02843_UI_WH_CAPA.CheckAndGetMeasure

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5db2110 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2562 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-3168933a | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2562 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-1d0f28e5 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2566 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7bbae15 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2567 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-c9d73341 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2568 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b9f1513 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2569 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-dd513eef | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2570 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-78c85433 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2571 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f08d21df | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2572 |  | DATA_OP | measure.Data.ContainsKey | ("chk_totalBatch") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3aebc9e | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:2573 | if (measure.Data.ContainsKey("chk_totalBatch")) | FLAG | weekTOT_measure | measure.Data["chk_totalBatch"] | 화면 필드/플래그 변경 |  |  |  |

## FP02843_UI_WH_CAPA.CreateFilterDataSet

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a912dd27 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1777 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8c2d1c55 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1789 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-f4cc2d1a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1790 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-82aa1bf7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1807 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-630bf0b5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1812 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cacc458 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1817 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-51d7f890 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1822 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9374067 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1830 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1fa034e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1835 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-01e8feba | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1840 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b9a23f5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1845 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9ac7ba8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1853 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfccc7d7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1858 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d679af80 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1863 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9cd3742 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1868 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f960bcd7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1876 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d303e0e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1881 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-41be50fc | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1886 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-46b329ec | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1891 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1667a168 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1899 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb07e4bc | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1904 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-14653d0b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1909 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-be41f3e5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1914 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1efcfdf0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1922 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-67e04706 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1927 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed643643 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1932 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-819176d5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1937 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef609c01 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1945 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-83574680 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1950 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d832fa5f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1955 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-753ce67b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1960 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f035fc4a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1968 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-123d5b24 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1973 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-61a19503 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1978 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e15d362f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1983 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac0a62eb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1991 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7cb0ed0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1996 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a81a865 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2001 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcbd98f7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2006 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-259ed5aa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2014 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8120c8e7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2019 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a010eeb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2024 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e58c0c54 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2029 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9091b4d5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2039 | if (measure["chk_seq"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_SEQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0053b42e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2045 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-20575108 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2051 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-45516968 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2064 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfd2c2df | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2069 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a319b7a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2074 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66d1bfa0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2079 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ea4577c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2087 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fdd79dc | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2092 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7c28052 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2097 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2666eb6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2102 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-29c8a3ff | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2110 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb563bf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2115 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ee79645 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2120 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-acf1709d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2125 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0441bffe | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2133 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c0a1f6c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2138 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-48805625 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2143 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fdadd36 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2148 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd8302e1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2156 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1edf2e5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2161 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-71434390 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2166 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2561b6cd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2171 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ced8342 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2179 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8f9e12e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2184 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-286c380d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2189 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7884c2f2 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2194 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-00fdf3d7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2203 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9740a6f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2208 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bed696a6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2213 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5decb804 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2218 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-97339c66 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2227 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9b7b95e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2232 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4b0e157 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2237 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fcf4e3d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2242 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c517a434 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2251 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ee77f59 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2256 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c77e4b9a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2261 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6eb5e8c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2266 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b31a627e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2274 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe6696a4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2279 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c20caeaa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2284 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0002f4d9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2289 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-da382fe7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2303 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bc6fab6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2308 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9e8008b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2313 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-35008c79 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2318 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4095623 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2326 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2c111c0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2331 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f557527 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2336 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab8bdea5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2341 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f780aec7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2349 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70e61371 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2354 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-532f3808 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2359 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fe38853 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2364 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac66e16a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2372 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-08ea3cb1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2377 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ccd1ae0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2382 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65758eb0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2387 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-283dea59 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2395 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e2a93aa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2400 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2853c30 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2405 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-87043aaa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2410 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3124b37e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2418 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e27f7fcb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2423 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e89ac8a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2428 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6135d1db | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2433 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6dda4a11 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2441 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af975ac7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2446 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb96bd7e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2451 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb13dbfb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2456 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-53c56555 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2464 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f863c35 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2469 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea871238 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2474 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f23ead67 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2479 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96efe401 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2487 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c54d91e7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2492 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b1071d1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2497 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-966f2c4e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2502 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96067382 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2510 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-39ff29bf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2515 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f643d90a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2520 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac937572 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2525 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d563fbcd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2532 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6d18b81 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2535 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c61f5d1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2539 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd02b55d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2544 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-94d8b080 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2548 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-298322ab | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2548 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-17882a25 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2553 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-62904a40 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2555 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-444a9ce7 | this.Load | FP02843_UI_WH_CAPA.cs:403 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanByModelElectrode, SpdSheet.shtPlanByModelElectrode, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6d80f1f | this.Load | FP02843_UI_WH_CAPA.cs:404 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanByModelElectrode) | 화면 필드/플래그 변경 |  |  |  |
| AC-1700993a | this.Load | FP02843_UI_WH_CAPA.cs:405 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanByModelElectrode) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02843_UI_WH_CAPA.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1e4e5dc | DeleteButton | FP02843_UI_WH_CAPA.cs:892 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c0e3485 | Dispose | FP02843_UI_WH_CAPA.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02843_UI_WH_CAPA.DrawHeader

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59f2e6e7 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1311 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-bf1ddcef | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1315 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-9c5b3912 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1316 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-821cecf7 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1317 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-602d4f81 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1318 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1eafa4a3 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1319 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e9bf9e64 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1323 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-920bae65 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1324 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-57058e8a | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1325 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-3d72c9eb | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1326 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-5585960d | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1336 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(bUse_month, bUse_week, bUse_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f62ca24 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1340 | else of (with_day_part == false) ▸ if (bUse_total) | FLAG | DayColumnCount | += calendar.weeks.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-d8df79ad | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1344 | else of (with_day_part == false) ▸ else of (bUse_total) | FLAG | DayColumnCount | -= calendar.weeks.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-f6b8f4b1 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1347 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b2fee72 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1381 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanByModelElectrode, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-723372e7 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1386 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | DayColumnCount | siMain.SetAmendHeaderColumnWithTotal_FP(calendar, bUse_month, bUse_week, bUse_day, bUse_to… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e5eac37 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1386 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumnWithTotal_FP | (calendar, bUse_month, bUse_week, bUse_day, bUse_total, 2, FPExtensions.DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-17b03b47 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1389 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-426890f0 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1390 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd30b51a | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1391 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-49a81fbe | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1393 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-660982a4 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1395 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-c9e2056b | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1396 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83f80c88 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:1401 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP02843_UI_WH_CAPA.DrawSheet

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c88b98 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1407 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f1da9e77 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1409 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7fac7d5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1414 |  | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcfa19e9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1417 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02843_UI_WH_CAPA.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d44efe3 | ExcelButton | FP02843_UI_WH_CAPA.cs:1241 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02843_UI_WH_CAPA.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP02843_WH_CAPA")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda] / SaveButton [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fab0a71d | popSql.OnSql [if (programID == "PR_UI_FP02843_WH_CAPA")] 외 2 | FP02843_UI_WH_CAPA.cs:1249 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02843_WH_CAPA", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76ce6486 | popSql.OnSql [if (programID == "PR_UI_FP02843_WH_CAPA")] 외 2 | FP02843_UI_WH_CAPA.cs:1251 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-39e5cfc4 | popSql.OnSql [if (programID == "PR_UI_FP02843_WH_CAPA")] 외 2 | FP02843_UI_WH_CAPA.cs:1255 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.FindTotalColorStart

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-579041d7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:1771 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edc987dc | this.Load | FP02843_UI_WH_CAPA.cs:195 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02843_UI_WH_CAPA.GetFilter

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try] / SaveButton [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b3a7e19 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP02843_UI_WH_CAPA.cs:3315 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eb933ae | this.Load [try] | FP02843_UI_WH_CAPA.cs:3340 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c9fc601e | this.Load [try] | FP02843_UI_WH_CAPA.cs:3341 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90c8dad6 | this.Load | FP02843_UI_WH_CAPA.cs:285 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c2848ef4 | this.Load | FP02843_UI_WH_CAPA.cs:290 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fbadb963 | this.Load | FP02843_UI_WH_CAPA.cs:291 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-38e13c20 | this.Load | FP02843_UI_WH_CAPA.cs:294 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e588339 | this.Load | FP02843_UI_WH_CAPA.cs:297 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-261c7ddd | this.Load | FP02843_UI_WH_CAPA.cs:298 | try | DATA_OP | Filter["LOOKUP"] | _lookupType | 행/컬럼 값 대입 |  |  |  |
| AC-89b12aa7 | this.Load | FP02843_UI_WH_CAPA.cs:313 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d0fe7124 | this.Load | FP02843_UI_WH_CAPA.cs:314 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-24daae77 | this.Load | FP02843_UI_WH_CAPA.cs:315 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-76c0a2d2 | this.Load | FP02843_UI_WH_CAPA.cs:320 | try | FLAG | dtAttrType | Data_FP.Common_FP(Data_FP.Type.ATTR_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ATTR_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6f2fd8f6 | this.Load | FP02843_UI_WH_CAPA.cs:320 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ATTR_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ATTR_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-553a1b17 | this.Load | FP02843_UI_WH_CAPA.cs:326 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02843_UI_WH_CAPA.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddca769f | this.Load | FP02843_UI_WH_CAPA.cs:231 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9c36e4fd | this.Load | FP02843_UI_WH_CAPA.cs:232 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-94db1852 | this.Load | FP02843_UI_WH_CAPA.cs:233 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c15695e1 | this.Load | FP02843_UI_WH_CAPA.cs:234 |  | UI_PROP | mcbo_Electrode.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d5ab9037 | this.Load | FP02843_UI_WH_CAPA.cs:236 |  | UI_PROP | mcbo_prod_type.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02843_UI_WH_CAPA.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6109a108 | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:418 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16bb6ffd | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:419 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanByModelElectrode) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c899aaca | this.Load 외 1 | FP02843_UI_WH_CAPA.cs:423 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02843_UI_WH_CAPA.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff23aa50 | InsertButton | FP02843_UI_WH_CAPA.cs:884 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.mcbo_Electrode_changed

진입점: this.Load [try ▸ if (dtLookup != null)] / mcbo_Electrode.SelectedIndexChanged / SaveButton [finally ▸ if (dtLookup != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b28e579 | this.Load [try ▸ if (dtLookup != null)] 외 2 | FP02843_UI_WH_CAPA.cs:3093 | if (mcbo_Electrode.Items.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.mcbo_prod_type_changed

진입점: this.Load [try ▸ if (dtLookup != null)] / mcbo_prod_type.SelectedIndexChanged / SaveButton [finally ▸ if (dtLookup != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26110608 | this.Load [try ▸ if (dtLookup != null)] 외 2 | FP02843_UI_WH_CAPA.cs:3102 | if (mcbo_prod_type.Items.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.RefreshHeadAndBody

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afb1ef81 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1281 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d1a9ea0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1297 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-991ed42e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1302 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02843_UI_WH_CAPA.RefreshHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b54a95b0 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1571 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5aeaf5cc | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1572 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-170f1743 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1573 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-12aa7c53 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1574 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-24a6210b | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1589 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumnWithTotal_FP | (calendar, bUse_month, bUse_week, bUse_day, bUse_total, 2, FPExtensions.DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1f23989 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1592 | if (monthInfo != null) ▸ if (added_columns_count == 0) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col | 그리드 속성/값 설정 |  |  |  |
| AC-a17bff43 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1594 | if (monthInfo != null) ▸ else of (added_columns_count == 0) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-dbcd4a84 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1598 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-16395636 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1603 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63a80fe8 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1604 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-602ee598 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1610 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e31a7525 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1612 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d22f206 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1613 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d8f4447 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1620 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3c610fc8 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1628 | if (monthInfo != null) ▸ for (i < siMain.ActiveSheet.FrozenColumnCount) | GRID_STYLE | siMain.ActiveSheet.SetColumnMerge | (i, FarPoint.Win.Spread.Model.MergePolicy.Always) | 그리드 표시 설정 |  |  |  |
| AC-29f4008b | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1633 | if (monthInfo != null) ▸ for (i < siMain.GetMaxColumnIndex()) | GRID_STYLE | siMain.ActiveSheet.SetColumnMerge | (i, FarPoint.Win.Spread.Model.MergePolicy.None) | 그리드 표시 설정 |  |  |  |
| AC-c6dcd095 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1637 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8943e776 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1638 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ba24b78 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1682 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-340d8620 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1701 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ … | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0db8d19d | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1705 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-be486221 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1707 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab4314f5 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1711 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-826b5bd4 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1727 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) … | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-93b14974 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1742 | if (monthInfo != null) ▸ if (!columnChange) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-fb1e2d24 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:1747 | if (monthInfo != null) ▸ if (!columnChange) | FLAG | columnChange | false | 화면 필드/플래그 변경 |  |  |  |

## FP02843_UI_WH_CAPA.RefreshHeaderOnly

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73161a11 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:441 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-b7b3221f | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:442 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("CATE") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-d1d59d23 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:443 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e52c4292 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:444 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52715171 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:445 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6725cec6 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:452 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-55147dd8 | (진입점 미연결) | FP02843_UI_WH_CAPA.cs:453 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |

## FP02843_UI_WH_CAPA.RefreshSpreadSheet

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10aa8e1a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1265 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-f752ec76 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1265 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-7a8dea1a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1269 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-93f699ec | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1274 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02843_UI_WH_CAPA.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eca76ba9 | popSql.OnSql | FP02843_UI_WH_CAPA.cs:3348 | if (programID == "PR_UI_FP02843_WH_CAPA") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-4ed94571 | popSql.OnSql | FP02843_UI_WH_CAPA.cs:3351 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9182605 | SaveButton | FP02843_UI_WH_CAPA.cs:910 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-89aaefcb | SaveButton | FP02843_UI_WH_CAPA.cs:915 | catch ((Exception)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-89199d49 | SaveButton | FP02843_UI_WH_CAPA.cs:916 | catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce5a0165 | SaveButton | FP02843_UI_WH_CAPA.cs:921 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1c61eaa1 | SaveButton | FP02843_UI_WH_CAPA.cs:925 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.SaveData

진입점: SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64fd1344 | SaveButton [try] | FP02843_UI_WH_CAPA.cs:996 | for (i < total_destination.Count) ▸ if (siMain.ActiveSheet.Cells[cnt, 0].Value != null && siMain.ActiveSheet.Cells[cnt, 0].Value.ToString() … | CALL_EXT | dicTempCapa.TryGetValue | (temp_stock_key, out temp_stock_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d805c26 | SaveButton [try] | FP02843_UI_WH_CAPA.cs:1022 | for (i < total_destination.Count) ▸ if (siMain.ActiveSheet.Cells[cnt, 0].Value != null && siMain.ActiveSheet.Cells[cnt, 0].Value.ToString() … | GRID_SET | dsMain.Tables[0].Rows[j]["WH_TEMP_CAPA"] | past_temp_capa | 그리드 속성/값 설정 |  |  |  |
| AC-8eb19322 | SaveButton [try] | FP02843_UI_WH_CAPA.cs:1092 | for (i < total_destination.Count) ▸ if (siMain.ActiveSheet.Cells[cnt, 0].Value != null && siMain.ActiveSheet.Cells[cnt, 0].Value.ToString() … | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02843_WH_CAPA", FilterBatch, _CurrentUser, "merge_batch_t", "merge_batch_t") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-78d3148a | SaveButton [try] | FP02843_UI_WH_CAPA.cs:1171 | if (siMain.ActiveSheet.Columns[0].DataField.ToUpper() == "ACTION") ▸ if (siMain.ActiveSheet.Columns[0].Visible) ▸ for (i < siMain.ActiveShee… | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02843_WH_CAPA", FilterBatch, _CurrentUser, "merge_batch", "merge_batch") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP02843_UI_WH_CAPA.SetCalenderColor

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0c9660c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1490 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-034dde1b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1494 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-f1ba58aa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1496 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb21a450 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1500 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ca7254aa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1516 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-f85f7951 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1531 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-63ed2f29 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1548 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |

## FP02843_UI_WH_CAPA.SetColumnChangeByMemo

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37dbdef7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2584 |  | FLAG | GnlcellType | new GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d0c102d6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2585 |  | UI_PROP | GnlcellType.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-75cc1680 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2593 | try ▸ if (iColStartIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c3e1c80 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2612 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, froz, k, last_col - 1].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-12bbc7cf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2637 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02843_UI_WH_CAPA.SetColumnsFormat

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-686e9302 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2731 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (om… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7622cc3b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2734 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else o… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6ff51ff | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2757 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71e80e45 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2760 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1302c09 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2785 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1725be6b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2788 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ el… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2a7b280 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2807 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a652a4a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2814 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) ▸ for (i < weekCnt) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e13b7212 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2829 | if (siMain != null) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-0c840311 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2840 | if (siMain != null) ▸ if (iLV1_NAME == -1 \|\| iCATEGORY_NAME == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bd3fcbd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2845 | if (siMain != null) ▸ if (batchIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5c2fc4a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2847 | if (siMain != null) | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0df3cd6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2874 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.GetMaxCo… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-7ed994f9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2875 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.GetMaxCo… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e074b81e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2877 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.GetMaxCo… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-6439332b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2897 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Get… | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-91552db1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2904 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Get… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-6bf84b3f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2905 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Get… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e134fd47 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2907 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Get… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-5069d011 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2936 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name == "Plan(In)") ▸ if (measure_name == "Batch") ▸ for (j < siM… | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f12dec56 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:2937 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name == "Plan(In)") ▸ if (measure_name == "Batch") ▸ for (j < siM… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |

## FP02843_UI_WH_CAPA.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5aeb05d | this.Load | FP02843_UI_WH_CAPA.cs:215 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e728c2c | this.Load | FP02843_UI_WH_CAPA.cs:217 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-186e3736 | this.Load | FP02843_UI_WH_CAPA.cs:218 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-140dbd8e | this.Load | FP02843_UI_WH_CAPA.cs:222 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b4691f48 | this.Load | FP02843_UI_WH_CAPA.cs:223 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP02843_UI_WH_CAPA.SetDirty

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ finally] / SaveButton [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c988452b | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP02843_UI_WH_CAPA.cs:3153 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP02843_UI_WH_CAPA.SetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30909314 | this.Load [try] | FP02843_UI_WH_CAPA.cs:2960 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-9902cf67 | this.Load [try] | FP02843_UI_WH_CAPA.cs:2960 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-899968e4 | this.Load [try] | FP02843_UI_WH_CAPA.cs:2962 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02843_UI_WH_CAPA.SetEditMode

진입점: EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4096e72d | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1203 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ceb5769b | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1204 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8470206e | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1206 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3636e312 | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1207 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ceeb4464 | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1212 | if (spdMain != null) ▸ if (IsEditMode) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByModelElectrode, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1be17e8 | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1216 | if (spdMain != null) | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d3b1514 | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1216 | if (spdMain != null) | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45b0b686 | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1227 | if (spdMain != null) ▸ else of (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible … | GRID_LOCK | siMain.LockColumn | (siMain.ActiveSheet.Columns[i].Index, siMain.ActiveSheet.Columns[i].Index, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-493e0138 | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1234 | if (spdMain != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.SetElectrode

진입점: this.Load [try ▸ if (dtLookup != null)] / SaveButton [finally ▸ if (dtLookup != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1321a3bb | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3036 |  | FLAG | dtElecType | dtLookup.DefaultView.ToTable(true, new string[] { "ELECTRODE_TYPE" }) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4fa9833 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3036 |  | DATA_OP | dtLookup.DefaultView.ToTable | (true, new string[] { "ELECTRODE_TYPE" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fe2aece | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3037 |  | DATA_OP | dtElecType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1209f8b | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3038 |  | GRID_SET | dtElecType.Columns["ELECTRODE_TYPE"].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-a1404506 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3044 | for (i < dtElecType.Rows.Count) ▸ if (dtElecType.Rows[i]["CODE"].ToString() == "C") | GRID_SET | dtElecType.Rows[i]["NAME"] | "Cathod" | 그리드 속성/값 설정 |  |  |  |
| AC-64094b01 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3048 | for (i < dtElecType.Rows.Count) ▸ else of (dtElecType.Rows[i]["CODE"].ToString() == "C") ▸ if (dtElecType.Rows[i]["CODE"].ToString() == "A") | GRID_SET | dtElecType.Rows[i]["NAME"] | "Anode" | 그리드 속성/값 설정 |  |  |  |
| AC-d42e7ec7 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3052 | for (i < dtElecType.Rows.Count) ▸ else of (dtElecType.Rows[i]["CODE"].ToString() == "C") ▸ else of (dtElecType.Rows[i]["CODE"].ToString() ==… | GRID_SET | dtElecType.Rows[i]["NAME"] | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-e4e0db6f | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3056 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, mcbo_Electrode, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02843_UI_WH_CAPA.SetFactory

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ff3df1 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3009 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, _CurrentUser, _sNonAuth, _sSaveAuth , "", n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-6a23dda9 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3009 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, _CurrentUser, _sNonAuth, _sSaveAuth , "", null, Filter["COMP… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-76fed59a | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3012 |  | DATA_OP | dtFactory.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0ea9be54 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3013 |  | STATE_RESET | dtFactory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3379d7d4 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3016 | for (i < _factoryCode.Count()) | DATA_OP | dtFactoryTMP.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1473ca98 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3016 | for (i < _factoryCode.Count()) ▸ lambda | DATA_OP | c["CODE"].ToString().Contains | (_factoryCode[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-465eae17 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3018 | for (i < _factoryCode.Count()) ▸ if (dtFactoryTMP.Select().Where(c => c["CODE"].ToString().Contains(_factoryCode[i])).Count() > 0) | DATA_OP | dtFactoryTMP.Select().Where(c => c["CODE"].ToString().Contains(_factoryCode[i])).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb65e3a | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3018 | for (i < _factoryCode.Count()) ▸ if (dtFactoryTMP.Select().Where(c => c["CODE"].ToString().Contains(_factoryCode[i])).Count() > 0) | DATA_OP | dtFactoryTMP.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6d42995 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3018 | for (i < _factoryCode.Count()) ▸ if (dtFactoryTMP.Select().Where(c => c["CODE"].ToString().Contains(_factoryCode[i])).Count() > 0) ▸ lambda | DATA_OP | c["CODE"].ToString().Contains | (_factoryCode[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b19249ab | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3019 | for (i < _factoryCode.Count()) ▸ if (dtFactoryTMP.Select().Where(c => c["CODE"].ToString().Contains(_factoryCode[i])).Count() > 0) | DATA_OP | dtFactory.Merge | (TmpDT, false, MissingSchemaAction.Ignore) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ef10266 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:3023 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02843_UI_WH_CAPA.SetFilter

진입점: this.Load [try] / mcbo_Electrode.SelectedIndexChanged / mcbo_prod_type.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))] / SaveButton [finally ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4b271c9 | this.Load [try] 외 8 | FP02843_UI_WH_CAPA.cs:3310 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02843_UI_WH_CAPA.SetFilterBatch

진입점: SaveButton [try ▸ for (i < total_destination.Count) ▸ if (siMain.ActiveSheet.Cells[cnt, 0].Value != null && siMain.ActiveSheet.Cells[cnt, 0].Value.ToString() == "M") ▸ if (chg_Tmp)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaa0ce0d | SaveButton [try ▸ for (i < total_destination.Count) ▸ if (si… | FP02843_UI_WH_CAPA.cs:1180 |  | DATA_OP | FilterBatch[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02843_UI_WH_CAPA.SetInitMemo

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be0133d2 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2646 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-886155fb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2647 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b60d5e4e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2648 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-9314163e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2649 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-7796b731 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2660 | try ▸ foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7bceec3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2677 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae8b4758 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2678 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6722e4af | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2679 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5881d75e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2680 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-53e45274 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2681 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d54590b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2682 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-93a6feeb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2683 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57e9aff1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2684 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-969c9e64 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2685 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-11cec688 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2696 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") ▸ if (result.Count() > 0) ▸ forea… | DATA_OP | row[sColName] | result.First()[sChgColName] | 행/컬럼 값 대입 |  |  |  |
| AC-8fb6fc7e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 1 | FP02843_UI_WH_CAPA.cs:2706 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02843_UI_WH_CAPA.SetPlant

진입점: this.Load [try] / cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef63c78e | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:2994 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-11ab011b | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:2994 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fea76e8 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:2997 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02843_UI_WH_CAPA.SetRollType

진입점: this.Load [try ▸ if (dtLookup != null)] / SaveButton [finally ▸ if (dtLookup != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ea8e598 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3062 |  | FLAG | dtRollType | dtLookup.DefaultView.ToTable(true, new string[] { "ROLL_TYPE" }) | 화면 필드/플래그 변경 |  |  |  |
| AC-c66802e5 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3062 |  | DATA_OP | dtLookup.DefaultView.ToTable | (true, new string[] { "ROLL_TYPE" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-b68eaa36 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3063 |  | DATA_OP | dtRollType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-a404959e | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3064 |  | GRID_SET | dtRollType.Columns["ROLL_TYPE"].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-dac3aee5 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3070 | for (i < dtRollType.Rows.Count) ▸ if (dtRollType.Rows[i]["CODE"].ToString() == "J") | GRID_SET | dtRollType.Rows[i]["NAME"] | "Jumbo Roll" | 그리드 속성/값 설정 |  |  |  |
| AC-945d11c3 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3074 | for (i < dtRollType.Rows.Count) ▸ else of (dtRollType.Rows[i]["CODE"].ToString() == "J") ▸ if (dtRollType.Rows[i]["CODE"].ToString() == "P") | GRID_SET | dtRollType.Rows[i]["NAME"] | "Pancake" | 그리드 속성/값 설정 |  |  |  |
| AC-c6bf87f2 | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3078 | for (i < dtRollType.Rows.Count) ▸ else of (dtRollType.Rows[i]["CODE"].ToString() == "J") ▸ else of (dtRollType.Rows[i]["CODE"].ToString() ==… | GRID_SET | dtRollType.Rows[i]["NAME"] | dtRollType.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |
| AC-5b8e459b | this.Load [try ▸ if (dtLookup != null)] 외 1 | FP02843_UI_WH_CAPA.cs:3082 |  | LIST_REBIND | clsCtrl.setListBox | (dtRollType, mcbo_prod_type, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02843_UI_WH_CAPA.SetSecondHost

진입점: this.Load [try] / SaveButton [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de463fe9 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:342 |  | STATE_RESET | dicTempCapa.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2c34ed31 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:343 |  | FLAG | dtLookup | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "WH_LOOK_UP", _lookupType) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0a1567ae | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:343 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "WH_LOOK_UP", _lookupType) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb3bf588 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:348 | if (dtLookup != null) | DATA_OP | dtLookup.DefaultView.ToTable | (true, new string[] { "FACTORY_ID" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-1af97ddd | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:349 | if (dtLookup != null) | FLAG | _factoryCode | tmpFactory.Rows.OfType<DataRow>().Select(k => k[0].ToString()).ToArray() | 화면 필드/플래그 변경 |  |  |  |
| AC-144d725e | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:349 | if (dtLookup != null) | DATA_OP | tmpFactory.Rows.OfType<DataRow>().Select | (k => k[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e2f40ee | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:349 | if (dtLookup != null) | CALL_EXT | tmpFactory.Rows.OfType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca015494 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:360 | if (dtLookup != null) ▸ for (i < dtLookup.Rows.Count) | DATA_OP | dicTempCapa.Add | (tempKey, dtLookup.Rows[i][dtLookup.Columns.Count - 1].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1735d8da | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:369 | else of (dtLookup != null) | STATE | mcbo_prod_type.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c6dd49ab | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:370 | else of (dtLookup != null) | STATE | mcbo_Electrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP02843_UI_WH_CAPA.SetSite

진입점: this.Load [try] / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e13463 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:2980 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-17a97dc9 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:2980 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bae7919a | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:2982 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02843_UI_WH_CAPA.SetSpreadInit

진입점: this.Load [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49460a28 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:431 | if (sheetName.Equals(SpdSheet.shtPlanByModelElectrode)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d29cb80 | this.Load [try] 외 1 | FP02843_UI_WH_CAPA.cs:432 | if (sheetName.Equals(SpdSheet.shtPlanByModelElectrode)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02843_UI_WH_CAPA.SetTotalColor

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5400c617 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… | FP02843_UI_WH_CAPA.cs:1467 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP02843_UI_WH_CAPA.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-808573d1 | this.spdMain.CellDoubleClick | FP02843_UI_WH_CAPA.cs:3281 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-538ec312 | this.spdMain.CellDoubleClick | FP02843_UI_WH_CAPA.cs:3286 | try ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-613b6bd3 | this.spdMain.CellDoubleClick | FP02843_UI_WH_CAPA.cs:3293 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02843_UI_WH_CAPA.SwitchEdit

진입점: EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1b8a7bc | EditButton [if (spdMain != null)] | FP02843_UI_WH_CAPA.cs:1193 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02843_UI_WH_CAPA.UIFindData

진입점: FindButton / SaveButton [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f65c46ae | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:473 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73130f30 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:474 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88879fa0 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:477 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e01836ca | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:486 | try ▸ if (checkCnt > 0) | MESSAGE | MessageBox.Show | ("검색 조건이 맞지 않아서 조회 할 수 없습니다.") | 메시지 표시 |  |  |  |
| AC-aaa3042e | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:487 | try ▸ if (checkCnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-544b70c6 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:490 | try ▸ if (mcbo_prod_type.Enabled == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5282840 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:491 | try ▸ if (mcbo_Electrode.Enabled == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2786f9a6 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:496 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-99c3ea7c | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:510 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-107242b8 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:511 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d549f0a | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:514 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4d731f3a | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:518 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e13c4e4f | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:519 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-49f9edb5 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:529 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-de573f06 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:530 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-972db6a8 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:530 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e992c95 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:538 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) | DATA_OP | dsMain.Tables[0].Columns.Add | ("WH_TEMP_CAPA") | 데이터 객체 조작/조회 |  |  |  |
| AC-03d0c48c | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:546 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) | CALL_EXT | total_destination.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4006822 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:559 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ for (i < dsMain.Tables[0].Rows.Cou… | CALL_EXT | dicTempCapa.TryGetValue | (temp_stock_key, out temp_stock_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-575e8e51 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:561 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ for (i < dsMain.Tables[0].Rows.Cou… | GRID_SET | dsMain.Tables[0].Rows[i][temp_stock_index] | temp_stock_value | 그리드 속성/값 설정 |  |  |  |
| AC-b07170f7 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:576 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ for (i < dsMain.Tables[0].Rows.Cou… | DATA_OP | total_destination.Add | (new Tuple<int, int>(start_index, i - 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7efc615f | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:585 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ for (i < dsMain.Tables[0].Rows.Cou… | DATA_OP | total_destination.Add | (new Tuple<int, int>(start_index, end_index)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0ee780b | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:594 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > … | DATA_OP | dsMain.Tables[0].Columns.Add | ("WH_TOTAL_CAPA") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0ffd529 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:650 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > … | GRID_SET | dsMain.Tables[0].Rows[total_destination[i].Item1][total_stock_index] | trst + d_temp_capa | 그리드 속성/값 설정 |  |  |  |
| AC-eb071334 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:657 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > … | GRID_SET | dsMain.Tables[0].Rows[j][total_stock_index] | trst + d_temp_capa | 그리드 속성/값 설정 |  |  |  |
| AC-abc274ab | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:670 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Cou… | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-71be6565 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:672 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Cou… | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-871ba4a7 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:674 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Cou… | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f61316f2 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:680 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8a5aa71c | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:682 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-5ed8553a | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:695 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fe87ce4 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:700 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0af152d | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:710 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.Cells[i, iroll_type].Value | "Pancake" | 그리드 속성/값 설정 |  |  |  |
| AC-259adfc2 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:714 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.… | GRID_SET | siMain.ActiveSheet.Cells[i, iroll_type].Value | "Jumbo Roll" | 그리드 속성/값 설정 |  |  |  |
| AC-344140f7 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:729 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.Cells[i, ielectrode_type].Value | "Cathod" | 그리드 속성/값 설정 |  |  |  |
| AC-a76a48d3 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:733 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.… | GRID_SET | siMain.ActiveSheet.Cells[i, ielectrode_type].Value | "Anode" | 그리드 속성/값 설정 |  |  |  |
| AC-20f2e339 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:737 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.… | GRID_SET | siMain.ActiveSheet.Cells[i, ielectrode_type].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-69631763 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:741 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | idx_WH_TEMP_CAPA | siMain.ActiveSheet.Columns["WH_TEMP_CAPA"].Index2 | 화면 필드/플래그 변경 |  |  |  |
| AC-ac89361d | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:765 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | CALL_EXT | Parallel.For | (0, dsMain.Tables[0].Rows.Count - 1, (q) => rowsMergeCnt[q] = 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5235b013 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:765 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda | DATA_OP | rowsMergeCnt[q] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-c5e1e339 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:770 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | CALL_EXT | Parallel.For | (0, dsMain.Tables[0].Rows.Count - 1, (q) => rowsMergeCnt[q] = 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a0aa032 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:770 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda | DATA_OP | rowsMergeCnt[q] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-f71366a8 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < dsMain.Tables[0].Rows.Count - 1) ▸ if (siMain.A… | DATA_OP | rowsMergeCnt[i] | rowsMergeCnt[i] + 1 | 행/컬럼 값 대입 |  |  |  |
| AC-4825a0a5 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:786 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (i < dsMain.Tables[0].Rows.Count - 1) ▸ if (siMain.A… | DATA_OP | rowsMergeCnt[i] | rowsMergeCnt[i] + 1 | 행/컬럼 값 대입 |  |  |  |
| AC-3b424285 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:817 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (z < rowsMergeCnt.Length) ▸ if (rowsMergeCnt[z] == 2… | GRID_STYLE | siMain.ActiveSheet.AddSpanCell | (startNum, targetColumn2, cnt, targetColumn2 + 1) | 그리드 표시 설정 |  |  |  |
| AC-66bd04ae | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:818 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (z < rowsMergeCnt.Length) ▸ if (rowsMergeCnt[z] == 2… | GRID_STYLE | siMain.ActiveSheet.AddSpanCell | (startNum, targetColumn, cnt, targetColumn + 1) | 그리드 표시 설정 |  |  |  |
| AC-9a0b3e04 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:822 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (z < rowsMergeCnt.Length) ▸ if (rowsMergeCnt[z] == 2… | GRID_STYLE | siMain.ActiveSheet.AddSpanCell | (startNum, targetColumn2, cnt, 1) | 그리드 표시 설정 |  |  |  |
| AC-f371484f | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:823 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ for (z < rowsMergeCnt.Length) ▸ if (rowsMergeCnt[z] == 2… | GRID_STYLE | siMain.ActiveSheet.AddSpanCell | (startNum, targetColumn, cnt, 1) | 그리드 표시 설정 |  |  |  |
| AC-45c9560c | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:829 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | CALL_EXT | Parallel.For | (0, dsMain.Tables[0].Rows.Count - 1, (q) => rowsMergeCnt[q] = 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bdb75e18 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:829 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda | DATA_OP | rowsMergeCnt[q] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-771556c1 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:835 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81a05300 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:842 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d8e2b10 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:843 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-88d4e7d6 | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:849 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb4023bf | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:856 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ if (siMain.ActiveSheet.Columns[0].DataField.ToUpper() == "ACTI… | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2ce9d0de | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:860 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-80d7443b | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:861 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab9b95ed | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:869 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-bf614b2a | FindButton 외 1 | FP02843_UI_WH_CAPA.cs:873 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

