# AS-IS 액션 대조표 — FP88888

> 원천: `Doc/asisfacts/screens/FP88888/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 351행 · 메서드 25 · 종류 DATA_OP 188 · VALUE_SET 39 · FLAG 25 · CALL_EXT 23 · UI_PROP 17 · RETURN 13 · ENDPOINT 12 · VALUE_CLEAR 10 · POPUP 7 · THROW 5 · UI_MISC 3 · MESSAGE 3 · LIST_BIND 3 · LIST_REBIND 2 · COMBO_DATA 1 · ⚠ 의미 확인 필요 23


## FP88888_FP_Log_Vue..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e8c5f24 | .ctor | FP88888_FP_Log_Vue.cs:110 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP88888_FP_Log_Vue.ApplyAmendCalendarCondition

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edb0797c | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2440 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-57a2e271 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2441 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9019ff73 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2442 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-71a74cc0 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2443 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-08102f2e | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2444 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ebf83bf4 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2447 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-a32b41b0 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2447 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e5484344 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2448 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-35f5a982 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2448 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-58ad3688 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2449 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 화면 필드/플래그 변경 |  |  |  |
| AC-15e8a6d1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2449 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-112e2307 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2450 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-7f9f346c | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2450 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ceb2e147 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2451 |  | FLAG | day2_week_month | Data_FP.CallGeneralProcedure2(("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-8029fe90 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2451 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "DAY2_WEEK_MONTH") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a5d99b2e | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2460 |  | CALL_EXT | DataService.ToLoopParam2 | ("", day2_week_month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08d8b7c7 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2465 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-8f79a87c | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2466 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-771b615f | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2467 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-e6e94769 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2468 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-9152aa30 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2469 |  | DATA_OP | Filter["DAY2_WEEK_MONTH"] | sDay2_week_month | 행/컬럼 값 대입 |  |  |  |
| AC-3b90edaf | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2470 |  | DATA_OP | Filter["CURR_DATE_COL"] | DataService.ToLoopParam2("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00611_ETC").ToUpper()… | 행/컬럼 값 대입 |  |  |  |
| AC-ccfa2855 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2470 |  | CALL_EXT | DataService.ToLoopParam2 | ("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a70baad | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2470 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CURR_DATE_COL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP88888_FP_Log_Vue.btnSql_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2309720b | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1481 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9c812d64 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1482 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-563e46f4 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1484 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00611_PLAN_BY_LINE_ASSY") | 데이터 객체 조작/조회 |  |  |  |
| AC-98438f52 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1485 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP88888_FP_Log_Vue.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7c07dfe | this.Load | FP88888_FP_Log_Vue.cs:970 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7c670f3 | this.Load | FP88888_FP_Log_Vue.cs:970 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-14a55864 | this.Load | FP88888_FP_Log_Vue.cs:973 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab653655 | this.Load | FP88888_FP_Log_Vue.cs:974 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-81896414 | this.Load | FP88888_FP_Log_Vue.cs:975 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6f57c3e | this.Load | FP88888_FP_Log_Vue.cs:976 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-9a370348 | this.Load | FP88888_FP_Log_Vue.cs:977 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d4a0ad9 | this.Load | FP88888_FP_Log_Vue.cs:978 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP88888_FP_Log_Vue.CreateFilterDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc2df48f | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1601 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-90d9877a | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1612 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-c131b080 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1613 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-21a951ce | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1648 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad1a4a40 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1652 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8623d5eb | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1656 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6449544 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1660 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5f1c4dc | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1664 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e67bbd6 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1668 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d53655ab | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1672 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1bc77df | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1676 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gap"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a1e02fc | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1680 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_cut"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42c12998 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1690 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d8babef | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1694 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-01f0240a | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1698 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c64addf | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1702 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-21ad0457 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1706 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7812e4e5 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1710 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc345acf | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1714 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43bfba99 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1718 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gap"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f1dc965 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1722 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_cut"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6d9fc2d | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1729 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c51ebc | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1734 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd133c15 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1745 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-806c13c8 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1747 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9369b28 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1749 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa0b28d1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1751 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d51f7bb | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1753 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a96a463 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1755 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c79025f8 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1757 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6da056a1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1759 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee218e94 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1761 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e615310 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1767 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd24ff82 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1769 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b859aba | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1771 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b27915b1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1773 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-407f48c9 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1775 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e821eb80 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1777 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fd36310 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1779 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ff28058 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1781 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-09b317de | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1783 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfb119fc | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1793 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7864cff1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1795 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a96819f9 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1797 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96678c01 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1799 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe6bda90 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1801 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-289f59ff | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1803 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca65fe35 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1805 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-368cbbdf | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1807 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c015e5b3 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1809 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7de04396 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1815 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae2bca37 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1817 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b32184c | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1819 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc374c24 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1821 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e2f108f | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1823 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af3ac92c | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1825 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4ddee33 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1827 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f7a3e8f | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1829 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2233e307 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1831 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-054e8402 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1835 |  | CALL_EXT | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | (MainGo, chks_measure_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da8fbc8f | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1836 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1f9ce8e | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1840 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-d16ac06d | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1844 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9584caef | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1847 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb42507d | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1849 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP88888_FP_Log_Vue.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69addcf3 | Dispose | FP88888_FP_Log_Vue.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP88888_FP_Log_Vue.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47a34849 | ExcelButton | FP88888_FP_Log_Vue.cs:1249 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bc857d20 | ExcelButton | FP88888_FP_Log_Vue.cs:1259 | try | CALL_EXT | rgFpLog.Save | (sFileName, unvell.ReoGrid.IO.FileFormat.Excel2007) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6761aa7 | ExcelButton | FP88888_FP_Log_Vue.cs:1260 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-966758ef | ExcelButton | FP88888_FP_Log_Vue.cs:1266 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38a2d59c | ExcelButton | FP88888_FP_Log_Vue.cs:1270 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP88888_FP_Log_Vue.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY")] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12772ac | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2069 | if (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["FROM_DATE"] | drpPeriod.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b195fce2 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2070 | if (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["TO_DATE"] | drpPeriod.ValueEnd.AddDays(1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-244bbb1c | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2072 | if (tabSpread.SelectedTab == pageMenu) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("LogVue", "list_menu_log", param.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_menu_log] \| FP\Common\Log… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ea45c74f | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2093 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) | LIST_BIND | sheet.DataSource | ds | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-daa6c515 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2111 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FPDateT… | CALL_EXT | sheet.SetRangeDataFormat | (range, unvell.ReoGrid.DataFormat.CellDataFormatFlag.DateTime, new unvell.ReoGrid.DataForm… | ⚠ 의미 확인 필요 |  |  |  |
| AC-50bf675d | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2112 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FPDateT… | POPUP | new unvell.ReoGrid.DataFormat.DateTimeDataFormatter.DateTimeFormatArgs |  | 팝업/폼 생성 |  |  |  |
| AC-4417c697 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2126 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FPDateT… | CALL_EXT | sheet.SetRangeDataFormat | (range, unvell.ReoGrid.DataFormat.CellDataFormatFlag.DateTime, new unvell.ReoGrid.DataForm… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b174532 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2127 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FPDateT… | POPUP | new unvell.ReoGrid.DataFormat.DateTimeDataFormatter.DateTimeFormatArgs |  | 팝업/폼 생성 |  |  |  |
| AC-107267bd | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2157 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | ENDPOINT | new FoxDataRequest | ("MenuContainer.UP_FX_GetMenuExecutionLog") ⇒ MenuContainer.UP_FX_GetMenuExecutionLog | 엔드포인트 요청 생성 |  |  |  |
| AC-91f4daad | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2158 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_program_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cad7e8f6 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2159 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_log_type"] | "FIND" | 행/컬럼 값 대입 |  |  |  |
| AC-21e89429 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2160 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_log_message"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-652ce651 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2161 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-471dd5ab | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2162 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_created_by"] | param["INSERT_USER"] | 행/컬럼 값 대입 |  |  |  |
| AC-725a4f8b | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2163 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_last_updated_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55badf5d | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2164 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_CREATION_FROM"] | drpPeriod.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-53b187f3 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2165 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | DATA_OP | request.Parameters["p_CREATION_TO"] | drpPeriod.ValueEnd.AddDays(1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0eb7121a | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2167 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a96faa80 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2171 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ try | LIST_BIND | sheet.DataSource | dsCnt | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ab92357b | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2176 | if (tabSpread.SelectedTab == pageMenu) ▸ try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.ToString()) | 메시지 표시 |  |  |  |
| AC-78c7e113 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2187 | if (tabSpread.SelectedTab == pageMenu) ▸ try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-5cf09e2e | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2191 | if (tabSpread.SelectedTab == pageMenu) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-45da6156 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2203 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (string.IsNullOrWhiteSpace(edt_user_name.Text)) | VALUE_SET | edt_user_name.Text | CurrentUser | 컨트롤 값 설정 |  |  |  |
| AC-58e33851 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2210 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["INSERT_USER"] | edt_user_name.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c4fb6f9f | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2211 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["INSERT_FROM"] | drpPeriod.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-eeded20c | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2212 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["INSERT_TO"] | drpPeriod.ValueEnd.AddDays(1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a32a1574 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2213 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["PROG_ID"] | txtProgID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-cc47a211 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2214 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["JOB_TYPE"] | job_type.SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-5c39f0e3 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2215 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | DATA_OP | param["LOG_TYPE"] | log_type.SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-753802ba | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2217 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("LogVue", "list_log", param.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_log] \| FP\Common\LogVue#l… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76c8c07f | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2252 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) | LIST_BIND | sheet.DataSource | ds | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-75b5f7ed | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2253 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) | CALL_EXT | sheet.ShowRows | (0, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63f2faec | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2271 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FP… | CALL_EXT | sheet.SetRangeDataFormat | (range, unvell.ReoGrid.DataFormat.CellDataFormatFlag.DateTime, new unvell.ReoGrid.DataForm… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8b3d050 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2272 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FP… | POPUP | new unvell.ReoGrid.DataFormat.DateTimeDataFormatter.DateTimeFormatArgs |  | 팝업/폼 생성 |  |  |  |
| AC-5b53099c | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2286 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FP… | CALL_EXT | sheet.SetRangeDataFormat | (range, unvell.ReoGrid.DataFormat.CellDataFormatFlag.DateTime, new unvell.ReoGrid.DataForm… | ⚠ 의미 확인 필요 |  |  |  |
| AC-76a2d615 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2287 | else of (tabSpread.SelectedTab == pageMenu) ▸ try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ for (j < col_count) ▸ switch (type) case FPDataType.FP… | POPUP | new unvell.ReoGrid.DataFormat.DateTimeDataFormatter.DateTimeFormatArgs |  | 팝업/폼 생성 |  |  |  |
| AC-dfdb0315 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2400 | else of (tabSpread.SelectedTab == pageMenu) ▸ try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-af6ed8f7 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 1 | FP88888_FP_Log_Vue.cs:2404 | else of (tabSpread.SelectedTab == pageMenu) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP88888_FP_Log_Vue.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a563c8c5 | this.Load | FP88888_FP_Log_Vue.cs:149 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP88888_FP_Log_Vue.GetBasisTime

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc21a5ea | (진입점 미연결) | FP88888_FP_Log_Vue.cs:859 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e756fc2 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:859 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP88888_FP_Log_Vue.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88b2f5b8 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1990 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP88888_FP_Log_Vue.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09250cdb | (진입점 미연결) | FP88888_FP_Log_Vue.cs:2003 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP88888_FP_Log_Vue.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27d7bc9d | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1329 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-683af9d1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1394 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | ClassExtensionForFp.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |

## FP88888_FP_Log_Vue.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-322fdb0c | this.Load | FP88888_FP_Log_Vue.cs:164 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9d636a5 | this.Load | FP88888_FP_Log_Vue.cs:169 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-23018c85 | this.Load | FP88888_FP_Log_Vue.cs:170 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9085a1e7 | this.Load | FP88888_FP_Log_Vue.cs:174 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-8efc7f42 | this.Load | FP88888_FP_Log_Vue.cs:177 |  | FLAG | dtJobType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-91eb2cc0 | this.Load | FP88888_FP_Log_Vue.cs:178 |  | DATA_OP | dtJobType.Columns.Add | (new DataColumn(CDefineColumn.Code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a89b607b | this.Load | FP88888_FP_Log_Vue.cs:179 |  | DATA_OP | dtJobType.Columns.Add | (new DataColumn(CDefineColumn.Name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-abf8f06b | this.Load | FP88888_FP_Log_Vue.cs:181 |  | DATA_OP | dtJobType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-be1da783 | this.Load | FP88888_FP_Log_Vue.cs:182 |  | DATA_OP | dr["CODE"] | "batch" | 행/컬럼 값 대입 |  |  |  |
| AC-1b84c18c | this.Load | FP88888_FP_Log_Vue.cs:183 |  | DATA_OP | dr["NAME"] | "batch" | 행/컬럼 값 대입 |  |  |  |
| AC-dc665abb | this.Load | FP88888_FP_Log_Vue.cs:184 |  | DATA_OP | dtJobType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-228a4f8d | this.Load | FP88888_FP_Log_Vue.cs:187 |  | DATA_OP | dtJobType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-23b4d2b2 | this.Load | FP88888_FP_Log_Vue.cs:188 |  | DATA_OP | dr["CODE"] | "execute" | 행/컬럼 값 대입 |  |  |  |
| AC-dd6c1cf4 | this.Load | FP88888_FP_Log_Vue.cs:189 |  | DATA_OP | dr["NAME"] | "execute" | 행/컬럼 값 대입 |  |  |  |
| AC-cd4c78dd | this.Load | FP88888_FP_Log_Vue.cs:190 |  | DATA_OP | dtJobType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7fe12f1 | this.Load | FP88888_FP_Log_Vue.cs:193 |  | DATA_OP | dtJobType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5a36417 | this.Load | FP88888_FP_Log_Vue.cs:194 |  | DATA_OP | dr["CODE"] | "procedure" | 행/컬럼 값 대입 |  |  |  |
| AC-75c42ecd | this.Load | FP88888_FP_Log_Vue.cs:195 |  | DATA_OP | dr["NAME"] | "procedure" | 행/컬럼 값 대입 |  |  |  |
| AC-afed05ef | this.Load | FP88888_FP_Log_Vue.cs:196 |  | DATA_OP | dtJobType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-07f5a3bb | this.Load | FP88888_FP_Log_Vue.cs:199 |  | DATA_OP | dtJobType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3fe3c9c4 | this.Load | FP88888_FP_Log_Vue.cs:200 |  | DATA_OP | dr["CODE"] | "read" | 행/컬럼 값 대입 |  |  |  |
| AC-44eb6e25 | this.Load | FP88888_FP_Log_Vue.cs:201 |  | DATA_OP | dr["NAME"] | "read" | 행/컬럼 값 대입 |  |  |  |
| AC-720df511 | this.Load | FP88888_FP_Log_Vue.cs:202 |  | DATA_OP | dtJobType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1156b668 | this.Load | FP88888_FP_Log_Vue.cs:205 |  | DATA_OP | dtJobType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-54b87a01 | this.Load | FP88888_FP_Log_Vue.cs:206 |  | DATA_OP | dr["CODE"] | "run" | 행/컬럼 값 대입 |  |  |  |
| AC-34e97281 | this.Load | FP88888_FP_Log_Vue.cs:207 |  | DATA_OP | dr["NAME"] | "run" | 행/컬럼 값 대입 |  |  |  |
| AC-73be0c3e | this.Load | FP88888_FP_Log_Vue.cs:208 |  | DATA_OP | dtJobType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f749c46 | this.Load | FP88888_FP_Log_Vue.cs:211 |  | DATA_OP | dtJobType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4736e1b2 | this.Load | FP88888_FP_Log_Vue.cs:212 |  | DATA_OP | dr["CODE"] | "select" | 행/컬럼 값 대입 |  |  |  |
| AC-35a9b92a | this.Load | FP88888_FP_Log_Vue.cs:213 |  | DATA_OP | dr["NAME"] | "select" | 행/컬럼 값 대입 |  |  |  |
| AC-01d21c52 | this.Load | FP88888_FP_Log_Vue.cs:214 |  | DATA_OP | dtJobType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb94823c | this.Load | FP88888_FP_Log_Vue.cs:216 |  | LIST_REBIND | clsCtrl.setListBox | (dtJobType, cmbJob, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b5558063 | this.Load | FP88888_FP_Log_Vue.cs:219 |  | FLAG | dtLogType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-02a1ef90 | this.Load | FP88888_FP_Log_Vue.cs:220 |  | DATA_OP | dtLogType.Columns.Add | (new DataColumn(CDefineColumn.Code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f18edc8 | this.Load | FP88888_FP_Log_Vue.cs:221 |  | DATA_OP | dtLogType.Columns.Add | (new DataColumn(CDefineColumn.Name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ec38239 | this.Load | FP88888_FP_Log_Vue.cs:223 |  | DATA_OP | dtLogType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-70b29817 | this.Load | FP88888_FP_Log_Vue.cs:224 |  | DATA_OP | dr["CODE"] | "PARAM" | 행/컬럼 값 대입 |  |  |  |
| AC-819e4caa | this.Load | FP88888_FP_Log_Vue.cs:225 |  | DATA_OP | dr["NAME"] | "PARAM" | 행/컬럼 값 대입 |  |  |  |
| AC-e049f39f | this.Load | FP88888_FP_Log_Vue.cs:226 |  | DATA_OP | dtLogType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c71438c | this.Load | FP88888_FP_Log_Vue.cs:229 |  | DATA_OP | dtLogType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b39145f9 | this.Load | FP88888_FP_Log_Vue.cs:230 |  | DATA_OP | dr["CODE"] | "SQL" | 행/컬럼 값 대입 |  |  |  |
| AC-a2107d7c | this.Load | FP88888_FP_Log_Vue.cs:231 |  | DATA_OP | dr["NAME"] | "SQL" | 행/컬럼 값 대입 |  |  |  |
| AC-28b25ff8 | this.Load | FP88888_FP_Log_Vue.cs:232 |  | DATA_OP | dtLogType.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5259e80f | this.Load | FP88888_FP_Log_Vue.cs:235 |  | LIST_REBIND | clsCtrl.setListBox | (dtLogType, cmbLog, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7236661b | this.Load | FP88888_FP_Log_Vue.cs:238 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now.AddDays(-1) | 속성 Value1 설정 |  |  |  |
| AC-611e58c2 | this.Load | FP88888_FP_Log_Vue.cs:239 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |

## FP88888_FP_Log_Vue.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8394620 | this.Load | FP88888_FP_Log_Vue.cs:896 |  | CALL_EXT | FPExtensions.GetSpdTitleEx | ("FP88888", CurrentUser, SpdSheet.shtMainLog) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d71de9f | this.Load | FP88888_FP_Log_Vue.cs:904 | if (dtColumns.Good()) | CALL_EXT | sheet.SetCols | (colen) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c724a8c | this.Load | FP88888_FP_Log_Vue.cs:905 | if (dtColumns.Good()) | CALL_EXT | sheet.SetRows | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2358b6a9 | this.Load | FP88888_FP_Log_Vue.cs:906 | if (dtColumns.Good()) | CALL_EXT | sheet.HideRows | (0, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13ad106c | this.Load | FP88888_FP_Log_Vue.cs:912 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) | UI_PROP | sheet.ColumnHeaders[index].DataColumn | row["COLUMN_NAME"].SafeString() | 속성 DataColumn 설정 |  |  |  |
| AC-7c95f5c7 | this.Load | FP88888_FP_Log_Vue.cs:913 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) | VALUE_SET | sheet.ColumnHeaders[index].Text | row["COLUMN_LABEL_NAME"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-96984596 | this.Load | FP88888_FP_Log_Vue.cs:914 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) | UI_PROP | sheet.ColumnHeaders[index].Width | (ushort)row["COLUMN_WIDTH"].SafeZeroInt() | 속성 Width 설정 |  |  |  |
| AC-bf56e5f5 | this.Load | FP88888_FP_Log_Vue.cs:915 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) | UI_PROP | sheet.ColumnHeaders[index].IsAutoWidth | false | 속성 IsAutoWidth 설정 |  |  |  |
| AC-8b29cee1 | this.Load | FP88888_FP_Log_Vue.cs:920 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) ▸ switch (type_string.ToUpper()) case "FPDATE": | UI_PROP | sheet.ColumnHeaders[index].DataType | FPDataType.FPDate | 속성 DataType 설정 |  |  |  |
| AC-cc163d15 | this.Load | FP88888_FP_Log_Vue.cs:923 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) ▸ switch (type_string.ToUpper()) case "FPDATETIME": | UI_PROP | sheet.ColumnHeaders[index].DataType | FPDataType.FPDateTime | 속성 DataType 설정 |  |  |  |
| AC-f39f2c2a | this.Load | FP88888_FP_Log_Vue.cs:927 | if (dtColumns.Good()) ▸ foreach (DataRow row in dtColumns.Rows) ▸ switch (type_string.ToUpper()) default: case "FPTEXTBOX": | UI_PROP | sheet.ColumnHeaders[index].DataType | FPDataType.FPText | 속성 DataType 설정 |  |  |  |
| AC-b236a6d2 | this.Load | FP88888_FP_Log_Vue.cs:933 | if (dtColumns.Good()) | UI_PROP | sheet.ColumnHeaders.IsDataSourceColumn | true | 속성 IsDataSourceColumn 설정 |  |  |  |
| AC-9e9e1919 | this.Load | FP88888_FP_Log_Vue.cs:949 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP88888_FP_Log_Vue.ParseParamValueType1

진입점: sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) case "READ": ▸ switch (ATTR1.ToUpper()) case "GENERALEXECUTEQUERY":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20cc7f25 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:803 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) | DATA_OP | param_subs[i] | param_subs[i].Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-8f2f2096 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:808 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) ▸ if (ee > 1) | DATA_OP | param_keys.Add | (each_subs[ee - 1]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebfda8e6 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:814 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) ▸ if (ee > 1) | DATA_OP | param_values.Add | (m_param_value) | 데이터 객체 조작/조회 |  |  |  |
| AC-e92d8b9e | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:819 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) ▸ else of (ee > 1) ▸ if (ee == 1) ▸ if (i == 0) | DATA_OP | param_keys.Add | (each_subs[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-90a7e8c3 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:822 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) ▸ else of (ee > 1) ▸ if (ee == 1) ▸ else of (i == 0) ▸ if (i =… | DATA_OP | param_values.Add | (each_subs[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-36907f9a | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:826 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) ▸ else of (ee > 1) ▸ if (ee == 1) ▸ else of (i == 0) ▸ else of… | DATA_OP | param_values.Add | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-478106e3 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:827 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (i < cnt) ▸ else of (ee > 1) ▸ if (ee == 1) ▸ else of (i == 0) ▸ else of… | DATA_OP | param_keys.Add | (each_subs[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ea2fab5 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:841 | if (param_value.StartsWith("{") && param_value.EndsWith("}")) ▸ for (k < param_keys.Count) ▸ if (k < param_values.Count) | DATA_OP | rDict[param_keys[k]] | param_values[k] | 행/컬럼 값 대입 |  |  |  |
| AC-702e01ac | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:847 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP88888_FP_Log_Vue.ParseParamValueType2

진입점: sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) case "READ": ▸ switch (ATTR1.ToUpper()) case "PSEUDODATACLIENT": ▸ if (!string.IsNullOrWhiteSpace(QUERY_ID)) ▸ if (string.IsNullOrWhiteSpace(PARAM_VALUE)) ▸ if (param_set.Length > 0) ▸ if (true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fdebef8 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:683 |  | DATA_OP | p_keys.Add | ("p_sys_type : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-9595305b | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:684 |  | DATA_OP | p_keys.Add | ("p_sys_flag : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbac4f99 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:685 |  | DATA_OP | p_keys.Add | ("p_sys_gubun : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1e72d14 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:686 |  | DATA_OP | p_keys.Add | ("p_user_id : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2bb3246 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:687 |  | DATA_OP | p_keys.Add | ("p_proc_name : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f3092b4 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:688 |  | DATA_OP | p_keys.Add | ("opt_none : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9181477 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:689 |  | DATA_OP | p_keys.Add | ("TimeOut : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b0b4926 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:690 |  | DATA_OP | p_keys.Add | ("in_columns : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-6fd5b50e | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:691 |  | DATA_OP | p_keys.Add | ("in_row : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-63e372cb | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:692 |  | DATA_OP | p_keys.Add | ("in_row1 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab80b2cf | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:693 |  | DATA_OP | p_keys.Add | ("in_row2 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-33f49f4b | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:694 |  | DATA_OP | p_keys.Add | ("in_row3 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-915eaad0 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:695 |  | DATA_OP | p_keys.Add | ("in_row4 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-54767a93 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:696 |  | DATA_OP | p_keys.Add | ("in_row5 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-65bd4ef6 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:697 |  | DATA_OP | p_keys.Add | ("in_row6 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e8ca44e | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:698 |  | DATA_OP | p_keys.Add | ("in_row7 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-145dc18c | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:699 |  | DATA_OP | p_keys.Add | ("in_row8 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3be73ba | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:700 |  | DATA_OP | p_keys.Add | ("in_row9 : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-c080be98 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:701 |  | DATA_OP | p_keys.Add | ("USER_ID : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e446359 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:716 | for (j< p_keys.Count) ▸ if (pos_end >=0 && pos_start >=0 && pos_end > pos_start) | DATA_OP | rDict[from] | found_param | 행/컬럼 값 대입 |  |  |  |
| AC-2d610f78 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:720 | for (j< p_keys.Count) ▸ else of (pos_end >=0 && pos_start >=0 && pos_end > pos_start) | THROW | throw new Exception("abnormal format"); |  | 예외 발생 |  |  |  |
| AC-6e54ffb9 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:724 | for (j< p_keys.Count) ▸ if (j== p_keys.Count-1) | DATA_OP | rDict[to] | buf | 행/컬럼 값 대입 |  |  |  |
| AC-e4302972 | sheet.SelectionRangeChanged [if (cell_ref is DataRow && cell… | FP88888_FP_Log_Vue.cs:784 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP88888_FP_Log_Vue.RefreshHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68926e24 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:990 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-55ea4720 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:991 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-8942e7fd | (진입점 미연결) | FP88888_FP_Log_Vue.cs:992 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ff9b95d6 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:993 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-5d671152 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1016 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5b745840 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1017 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30f89408 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1035 | if (monthInfo != null) | UI_PROP | mct.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-4a200e6a | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1138 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b73a909d | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1144 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c0b30d1 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1186 |  | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |

## FP88888_FP_Log_Vue.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43c676d7 | popSql.OnSql | FP88888_FP_Log_Vue.cs:2037 | if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-6a0d7586 | popSql.OnSql | FP88888_FP_Log_Vue.cs:2039 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP88888_FP_Log_Vue.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-336e7c9c | this.Load | FP88888_FP_Log_Vue.cs:120 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |

## FP88888_FP_Log_Vue.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-427154e4 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1985 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP88888_FP_Log_Vue.SetInitMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c25d2f0 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1500 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-58082b2f | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1501 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-382528fc | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1502 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-55bfdc5c | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1503 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-1444a357 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1509 | foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c5fac2b | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1528 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7aeb93b2 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1534 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edba1406 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1538 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | String.Format("{0}", m) | 행/컬럼 값 대입 |  |  |  |
| AC-fb1932ff | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1545 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c78909a6 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1569 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c43b0688 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1570 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a03f74b | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1571 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cca396a0 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1572 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ae9313a | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1573 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b08eb1bc | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1574 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c2dea76 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1575 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be9d99f4 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1576 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-21332d09 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1577 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f5c9e14 | (진입점 미연결) | FP88888_FP_Log_Vue.cs:1587 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "MEMO") ▸ if (result.Count() > 0) ▸ foreach (Amen… | DATA_OP | row[sColName] | result.First()[sChgColName] | 행/컬럼 값 대입 |  |  |  |

## FP88888_FP_Log_Vue.Sheet_CellMouseDown

진입점: sheet.CellMouseDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-790daf18 | sheet.CellMouseDown | FP88888_FP_Log_Vue.cs:2415 | if (cell ==null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP88888_FP_Log_Vue.Sheet_SelectionRangeChanging

진입점: sheet.SelectionRangeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a668c18f | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:264 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) | CALL_EXT | selected["QUERY_SEQ"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fdf4edfa | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:266 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) | VALUE_CLEAR | txtInfoA.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2044570e | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:267 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) | VALUE_CLEAR | txtInfoB.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3f1f449d | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:268 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) | VALUE_CLEAR | txtInfoC.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9be40567 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:269 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) | VALUE_CLEAR | txtSqlLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e929c025 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:270 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) | VALUE_CLEAR | txtParamLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-41db4d9a | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:274 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ if (mm != null) | VALUE_SET | txtInfoC.Text | mm.Value.ToLongDateString() + " " + mm.Value.ToLongTimeString() | 컨트롤 값 설정 |  |  |  |
| AC-ef0762fa | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:274 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ if (mm != null) | CALL_EXT | mm.Value.ToLongDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a09a985 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:274 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ if (mm != null) | CALL_EXT | mm.Value.ToLongTimeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-82984181 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:292 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | VALUE_SET | txtInfoA.Text | filename | 컨트롤 값 설정 |  |  |  |
| AC-d5a22f44 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:293 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | VALUE_SET | txtInfoB.Text | path | 컨트롤 값 설정 |  |  |  |
| AC-014f4a8b | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:296 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | DATA_OP | selected.Table.Select | ("LOG_TYPE='" + "SQL" + "' AND SESSION_ID='" + SESSION + "'", "INST_SEQ ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-21b42f67 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:304 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | VALUE_SET | txtSqlLog.Text | query_str | 컨트롤 값 설정 |  |  |  |
| AC-4ebadcdc | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:323 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | VALUE_SET | txtSqlLog.Text | selected["QUERY_VALUE"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-cedce6ad | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:325 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | VALUE_CLEAR | txtParamLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-40e389eb | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:328 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "PARAM": ▸ switch (JOB_TYPE.ToUpper()) … | VALUE_SET | txtParamLog.Text | param_log_txt | 컨트롤 값 설정 |  |  |  |
| AC-6a24b6ee | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:347 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | DATA_OP | selected.Table.Select | ("INST_SEQ='" + INST_SEQ + "'", "QUERY_SEQ ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-5232dafc | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:355 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtSqlLog.Text | query_str | 컨트롤 값 설정 |  |  |  |
| AC-61d5a873 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:356 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtInfoA.Text | PROG_ID | 컨트롤 값 설정 |  |  |  |
| AC-69da7d44 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:357 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtInfoB.Text | QUERY_ID | 컨트롤 값 설정 |  |  |  |
| AC-247935dd | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:358 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtParamLog.Text | PARAM_VALUE | 컨트롤 값 설정 |  |  |  |
| AC-4366550c | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:363 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtInfoA.Text | selected["PROG_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-04cdef4d | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:364 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtSqlLog.Text | selected["QUERY_VALUE"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-88ab3262 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:365 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "": ▸ switch (JOB_TYPE.ToUpper()) case … | VALUE_SET | txtParamLog.Text | selected["PARAM_VALUE"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-02911d10 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:385 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtInfoA.Text | PROG_ID | 컨트롤 값 설정 |  |  |  |
| AC-f7748e60 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:386 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtInfoB.Text | QUERY_ID | 컨트롤 값 설정 |  |  |  |
| AC-eccda0a6 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:389 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | selected.Table.Select | ("LOG_TYPE='" + "SQL" + "' AND SESSION_ID='" + SESSION + "'", "INST_SEQ ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8219241 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:397 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | query_str | 컨트롤 값 설정 |  |  |  |
| AC-83b6b3cd | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:400 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | selected.Table.Select | ("LOG_TYPE='" + "PARAM" + "' AND SESSION_ID='" + SESSION + "'", "INST_SEQ ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-548218c7 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:422 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | ParamValue2.Keys.Contains | ("in_columns : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-57867e69 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:426 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | ParamValue2.Keys.Contains | ("in_row : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-129f0a45 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:432 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | ParamValue2.Keys.Contains | ("in_row" + m+" : ") | 데이터 객체 조작/조회 |  |  |  |
| AC-a15ddde4 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:447 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | deep_param_log + "\r\n----------\r\n" + param_log_txt | 컨트롤 값 설정 |  |  |  |
| AC-0e46054d | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:452 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | rT2.Item1 | 컨트롤 값 설정 |  |  |  |
| AC-72cfd367 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:457 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_CLEAR | txtParamLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b3d5c577 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:460 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | += eKv.Key + ":" + eKv.Value + "\r\n" | 컨트롤 값 설정 |  |  |  |
| AC-a564f645 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:519 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | QUERY_VALUE | 컨트롤 값 설정 |  |  |  |
| AC-df23f2a6 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:526 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | ParamValue.Keys.Contains | ("in_columns") | 데이터 객체 조작/조회 |  |  |  |
| AC-d24f7fe2 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:530 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | ParamValue.Keys.Contains | ("in_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-87b35f91 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:536 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | ParamValue.Keys.Contains | ("in_row" + m) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b14231c | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:551 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | deep_param_log + "\r\n----------\r\n" + param_log_txt | 컨트롤 값 설정 |  |  |  |
| AC-204a9b50 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:556 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | rT.Item1 | 컨트롤 값 설정 |  |  |  |
| AC-0a24af14 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:561 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_CLEAR | txtParamLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c0fc6aa9 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:564 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | += eKv.Key + ":" + eKv.Value + "\r\n" | 컨트롤 값 설정 |  |  |  |
| AC-a612cbe1 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:575 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | selected["QUERY_VALUE"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-2dcfc611 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:576 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_CLEAR | txtParamLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-19e37538 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:581 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | param_log_txt | 컨트롤 값 설정 |  |  |  |
| AC-d0f4f94b | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:592 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtInfoA.Text | filename | 컨트롤 값 설정 |  |  |  |
| AC-e5f1789f | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:593 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtInfoB.Text | path | 컨트롤 값 설정 |  |  |  |
| AC-5692945a | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:599 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | selected.Table.Select | ("QUERY_SEQ='" + QUERY_SEQ + "' AND SESSION_ID='" + SESSION + "'", "INST_SEQ ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-322b592e | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:607 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | query_str | 컨트롤 값 설정 |  |  |  |
| AC-481685c6 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:610 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | DATA_OP | selected.Table.Select | ("LOG_TYPE='" + "PARAM" + "' AND SESSION_ID='" + SESSION + "'", "INST_SEQ ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-bad9da13 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:618 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | ParseParamValueType1(param_str).Item1 | 컨트롤 값 설정 |  |  |  |
| AC-8e367a1c | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:623 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | QUERY_VALUE | 컨트롤 값 설정 |  |  |  |
| AC-48ad583d | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:624 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | ParseParamValueType1(PARAM_VALUE).Item1 | 컨트롤 값 설정 |  |  |  |
| AC-8fec71fd | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:629 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | selected["QUERY_VALUE"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-0be51918 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:630 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | ParseParamValueType1(PARAM_VALUE).Item1 | 컨트롤 값 설정 |  |  |  |
| AC-466516de | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:650 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtInfoA.Text | QUERY_ID | 컨트롤 값 설정 |  |  |  |
| AC-6f3f1074 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:651 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtInfoB.Text | ATTR1 | 컨트롤 값 설정 |  |  |  |
| AC-9dc236f3 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:654 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtSqlLog.Text | selected["QUERY_VALUE"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-5fa860c2 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:655 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_CLEAR | txtParamLog.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e6666284 | sheet.SelectionRangeChanged | FP88888_FP_Log_Vue.cs:659 | if (cell_ref is DataRow && cell_ref !=null) ▸ if (selected!=null) ▸ switch (LOG_TYPE.ToUpper()) case "SQL": ▸ switch (JOB_TYPE.ToUpper()) ca… | VALUE_SET | txtParamLog.Text | param_log_txt | 컨트롤 값 설정 |  |  |  |

## FP88888_FP_Log_Vue.UIFindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31e7469f | FindButton | FP88888_FP_Log_Vue.cs:1859 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_division_id", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-898ce035 | FindButton | FP88888_FP_Log_Vue.cs:1860 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_company_id", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c75f6649 | FindButton | FP88888_FP_Log_Vue.cs:1861 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_site_id", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0055c9f1 | FindButton | FP88888_FP_Log_Vue.cs:1862 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_plant_id", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46850d43 | FindButton | FP88888_FP_Log_Vue.cs:1863 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_factory_id", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b46dbf8c | FindButton | FP88888_FP_Log_Vue.cs:1864 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_qtyh", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ebb1a88 | FindButton | FP88888_FP_Log_Vue.cs:1865 |  | DATA_OP | dtInput.Columns.SafeAdd | ("p_update_id", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-db9ad8f7 | FindButton | FP88888_FP_Log_Vue.cs:1869 | while (x > 0) | DATA_OP | dtInput.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-23657b8d | FindButton | FP88888_FP_Log_Vue.cs:1870 | while (x > 0) | DATA_OP | row["p_division_id"] | "00" | 행/컬럼 값 대입 |  |  |  |
| AC-189aec11 | FindButton | FP88888_FP_Log_Vue.cs:1873 | while (x > 0) | DATA_OP | dtInput.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-6337df0e | FindButton | FP88888_FP_Log_Vue.cs:1876 |  | ENDPOINT | DataService.FP_RunProcedureCustomTable | ("LogVue", "test_of_custom_table", "@FP00TEST", dtInput) ⇒ biz:FPCommonDataBLL.RunProcedureCustomTable [procedure=test_of_custom_table] \| … | 엔드포인트 호출 |  |  |  |

