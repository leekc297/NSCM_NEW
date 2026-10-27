# AS-IS 액션 대조표 — SCP0012

> 원천: `Doc/asisfacts/screens/SCP0012/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 322행 · 메서드 37 · 종류 DATA_OP 65 · GRID_INIT 59 · GRID_SET 36 · UI_PROP 24 · FLAG 19 · ENDPOINT 17 · UI_MISC 16 · RETURN 15 · VALUE_SET 12 · LIST_REBIND 12 · COMBO_DATA 9 · POPUP 7 · CALL_EXT 6 · MESSAGE 5 · VALIDATE 5 · STATE 4 · GRID_CLEAR 3 · THROW 3 · GRID_BIND 2 · GRID_LOCK 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 6


## SCP0012_PSI.AddSubSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d000c83e | (진입점 미연결) | SCP0012_PSI.cs:1201 | for (iRow < dt.Rows.Count) ▸ if (psi_type.Equals("I")) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dbc2031d | (진입점 미연결) | SCP0012_PSI.cs:1205 | for (iRow < dt.Rows.Count) ▸ if (psi_type.Equals("I")) ▸ for (iCol < dt.Rows[iRow].ItemArray.Length) | DATA_OP | newDr[iCol] | dt.Rows[iRow].ItemArray[iCol] | 행/컬럼 값 대입 |  |  |  |
| AC-0bb3749d | (진입점 미연결) | SCP0012_PSI.cs:1207 | for (iRow < dt.Rows.Count) ▸ if (psi_type.Equals("I")) | DATA_OP | dt.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-193dbc2a | (진입점 미연결) | SCP0012_PSI.cs:1221 | for (iRow < dt.Rows.Count) ▸ else of (psi_type.Equals("I")) ▸ else of (!befPSI.Equals(psi_type)) | DATA_OP | list.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9b3b57e | (진입점 미연결) | SCP0012_PSI.cs:1233 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c79be83f | (진입점 미연결) | SCP0012_PSI.cs:1236 |  | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b796cdc | (진입점 미연결) | SCP0012_PSI.cs:1237 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0012_PSI.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716d96c5 | this.btnItemId.Click | SCP0012_PSI.cs:545 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ce3343dd | this.btnItemId.Click | SCP0012_PSI.cs:547 |  | POPUP | pop.Form_Load | (true, division, pOperationGroup, sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c3f7c548 | this.btnItemId.Click | SCP0012_PSI.cs:548 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-353f75dc | this.btnItemId.Click | SCP0012_PSI.cs:549 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a0a2b0d9 | this.btnItemId.Click | SCP0012_PSI.cs:555 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0012_PSI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d59eaa52 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1675 | if (dtPlanTypeAll == null) | FLAG | dtPlanTypeAll | Data_SCP.CommonAll(Data_SCP.Type.PlanType1, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-db2b9bf5 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1675 | if (dtPlanTypeAll == null) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlanType1, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1ab42e0 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1677 |  | FLAG | dtPlanType | dtPlanTypeAll.Select("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'"… | 화면 필드/플래그 변경 |  |  |  |
| AC-19190432 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1677 |  | DATA_OP | dtPlanTypeAll.Select("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'"… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b8b1457 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1677 |  | DATA_OP | dtPlanTypeAll.Select | ("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-124fb0e4 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1680 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0146279d | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1682 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-367cf9d8 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1684 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-994b4173 | cboPlanDate.SelectedIndexChanged | SCP0012_PSI.cs:1685 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0012_PSI.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dacd381c | cboPlanSeq.SelectedIndexChanged | SCP0012_PSI.cs:1711 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0012_PSI.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d92d277 | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1696 | if (dtPlanSeqAll == null) | FLAG | dtPlanSeqAll | Data_SCP.CommonAll(Data_SCP.Type.PlanSeq1, false, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-8c6a3a11 | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1696 | if (dtPlanSeqAll == null) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlanSeq1, false, "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f74f519c | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1698 |  | FLAG | dtPlanSeq | dtPlanSeqAll.Select("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "' A… | 화면 필드/플래그 변경 |  |  |  |
| AC-1e4e2e5a | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1698 |  | DATA_OP | dtPlanSeqAll.Select("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "' A… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26d0c024 | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1698 |  | DATA_OP | dtPlanSeqAll.Select | ("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "' AND PLANTYPE = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-0667bd38 | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1700 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false , "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f9f6427e | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1702 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b586cdc3 | cboPlanType.SelectedIndexChanged | SCP0012_PSI.cs:1705 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0012_PSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c3e4968 | this.Load | SCP0012_PSI.cs:244 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7152ca7b | this.Load | SCP0012_PSI.cs:245 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4135388 | this.Load | SCP0012_PSI.cs:247 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0012_PSI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-076d9497 | this.Load | SCP0012_PSI.cs:179 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-4750b43b | this.Load | SCP0012_PSI.cs:180 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0012_PSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cca9938e | Dispose | SCP0012_PSI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0012_PSI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84999978 | EditButton | SCP0012_PSI.cs:580 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4ef9caa | EditButton | SCP0012_PSI.cs:581 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0012_PSI.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23ad3bff | ExcelButton | SCP0012_PSI.cs:594 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-ef964966 | ExcelButton | SCP0012_PSI.cs:595 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-cad2c980 | ExcelButton | SCP0012_PSI.cs:596 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-9a11dfa7 | ExcelButton | SCP0012_PSI.cs:597 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-ecd53676 | ExcelButton | SCP0012_PSI.cs:598 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-049d548a | ExcelButton | SCP0012_PSI.cs:600 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-46e74c30 | ExcelButton | SCP0012_PSI.cs:601 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-e476873d | ExcelButton | SCP0012_PSI.cs:603 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-43b4fe93 | ExcelButton | SCP0012_PSI.cs:608 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee18dde1 | ExcelButton | SCP0012_PSI.cs:613 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-98e73284 | ExcelButton | SCP0012_PSI.cs:617 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0012_PSI.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14019f4f | FindButton | SCP0012_PSI.cs:1036 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ad27a13f | FindButton | SCP0012_PSI.cs:1036 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24dacf70 | FindButton | SCP0012_PSI.cs:1038 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-12a9dab4 | FindButton | SCP0012_PSI.cs:1038 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1506e930 | FindButton | SCP0012_PSI.cs:1065 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d7a04c27 | FindButton | SCP0012_PSI.cs:1067 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28c68b98 | FindButton | SCP0012_PSI.cs:1070 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-02ab2e13 | FindButton | SCP0012_PSI.cs:1072 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3884295 | FindButton | SCP0012_PSI.cs:1075 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0012_GET_PSI") ⇒ SCP.SCP0012_GET_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-04248a35 | FindButton | SCP0012_PSI.cs:1076 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bcbca205 | FindButton | SCP0012_PSI.cs:1077 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d46e4356 | FindButton | SCP0012_PSI.cs:1078 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-12deaa66 | FindButton | SCP0012_PSI.cs:1079 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c559fc6 | FindButton | SCP0012_PSI.cs:1080 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-ddeff1c1 | FindButton | SCP0012_PSI.cs:1081 | try ▸ lambda | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-c57dfc53 | FindButton | SCP0012_PSI.cs:1082 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3ec184b | FindButton | SCP0012_PSI.cs:1083 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-01386684 | FindButton | SCP0012_PSI.cs:1084 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-deeb69c4 | FindButton | SCP0012_PSI.cs:1085 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-51337a79 | FindButton | SCP0012_PSI.cs:1086 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a6d41361 | FindButton | SCP0012_PSI.cs:1087 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-f4e8f5c3 | FindButton | SCP0012_PSI.cs:1088 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e7a047dc | FindButton | SCP0012_PSI.cs:1089 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-66ec1324 | FindButton | SCP0012_PSI.cs:1090 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-63d646d7 | FindButton | SCP0012_PSI.cs:1091 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d95be14a | FindButton | SCP0012_PSI.cs:1098 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-61d73e6c | FindButton | SCP0012_PSI.cs:1099 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e5a1927a | FindButton | SCP0012_PSI.cs:1119 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8828015f | FindButton | SCP0012_PSI.cs:1133 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | VALUE_SET | cells.Text | "Sum" | 컨트롤 값 설정 |  |  |  |
| AC-f65c2b90 | FindButton | SCP0012_PSI.cs:1134 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ColumnSpan | 2 | 속성 ColumnSpan 설정 |  |  |  |
| AC-50e5e592 | FindButton | SCP0012_PSI.cs:1135 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-a1db9131 | FindButton | SCP0012_PSI.cs:1136 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-1c9e41d4 | FindButton | SCP0012_PSI.cs:1137 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-1144de6b | FindButton | SCP0012_PSI.cs:1148 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | GRID_SET | siMain.SetValue | (iRow, boh_idx, nSumInventory) | 그리드 값 설정 |  |  |  |
| AC-82cfe5a8 | FindButton | SCP0012_PSI.cs:1158 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7a40b8e8 | FindButton | SCP0012_PSI.cs:1160 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d42b494 | FindButton | SCP0012_PSI.cs:1166 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80d91090 | FindButton | SCP0012_PSI.cs:1171 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-22e1ebd9 | FindButton | SCP0012_PSI.cs:1173 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0a7bb06 | FindButton | SCP0012_PSI.cs:1177 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ba5c7cf | FindButton | SCP0012_PSI.cs:1178 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0012_PSI.FindData_Main_Parallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9532b0a2 | (진입점 미연결) | SCP0012_PSI.cs:786 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-dae9bc09 | (진입점 미연결) | SCP0012_PSI.cs:787 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9e4395d | (진입점 미연결) | SCP0012_PSI.cs:789 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-96c32897 | (진입점 미연결) | SCP0012_PSI.cs:789 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efc34f90 | (진입점 미연결) | SCP0012_PSI.cs:815 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-65c75ae1 | (진입점 미연결) | SCP0012_PSI.cs:817 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cd8b5677 | (진입점 미연결) | SCP0012_PSI.cs:820 | try | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcbffd63 | (진입점 미연결) | SCP0012_PSI.cs:833 | try | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { if (i != nCnt - 1) { string strStartDate = DateUtil.GetDateAdd(p_from… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a4c70e9 | (진입점 미연결) | SCP0012_PSI.cs:855 | try ▸ lambda ▸ if (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0012_GET_PSI_QTY") ⇒ SCP.SCP0012_GET_PSI_QTY | 엔드포인트 요청 생성 |  |  |  |
| AC-e2aab561 | (진입점 미연결) | SCP0012_PSI.cs:856 | try ▸ lambda ▸ if (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-58089c07 | (진입점 미연결) | SCP0012_PSI.cs:857 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-ddb70209 | (진입점 미연결) | SCP0012_PSI.cs:858 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-7fa3b0c1 | (진입점 미연결) | SCP0012_PSI.cs:859 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b38995bf | (진입점 미연결) | SCP0012_PSI.cs:860 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-a7401a12 | (진입점 미연결) | SCP0012_PSI.cs:861 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-4bb2d8d3 | (진입점 미연결) | SCP0012_PSI.cs:862 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e56fa24c | (진입점 미연결) | SCP0012_PSI.cs:863 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-927d7ad0 | (진입점 미연결) | SCP0012_PSI.cs:864 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8955881b | (진입점 미연결) | SCP0012_PSI.cs:865 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-2a2e144d | (진입점 미연결) | SCP0012_PSI.cs:866 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-48a46ee1 | (진입점 미연결) | SCP0012_PSI.cs:868 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dd5ae1a0 | (진입점 미연결) | SCP0012_PSI.cs:869 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5c96c106 | (진입점 미연결) | SCP0012_PSI.cs:874 | try ▸ lambda ▸ if (i != nCnt - 1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fccf7bb3 | (진입점 미연결) | SCP0012_PSI.cs:878 | try ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a3b7d44 | (진입점 미연결) | SCP0012_PSI.cs:882 | try ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ else of (i == 1) ▸ if (i == 2) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4a2873f4 | (진입점 미연결) | SCP0012_PSI.cs:891 | try ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0012_GET_PSI_PARAL") ⇒ SCP.SCP0012_GET_PSI_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-5540f19a | (진입점 미연결) | SCP0012_PSI.cs:892 | try ▸ lambda ▸ else of (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e12cfc9e | (진입점 미연결) | SCP0012_PSI.cs:893 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2ec3fd44 | (진입점 미연결) | SCP0012_PSI.cs:894 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9921ec20 | (진입점 미연결) | SCP0012_PSI.cs:895 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-140e8d6b | (진입점 미연결) | SCP0012_PSI.cs:896 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-45946ab0 | (진입점 미연결) | SCP0012_PSI.cs:897 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-30dd2eb5 | (진입점 미연결) | SCP0012_PSI.cs:898 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3e1d7f1 | (진입점 미연결) | SCP0012_PSI.cs:899 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-f15f504f | (진입점 미연결) | SCP0012_PSI.cs:900 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-504a26cb | (진입점 미연결) | SCP0012_PSI.cs:901 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-98a7eb38 | (진입점 미연결) | SCP0012_PSI.cs:902 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4b0c04e0 | (진입점 미연결) | SCP0012_PSI.cs:903 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2629db2b | (진입점 미연결) | SCP0012_PSI.cs:904 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-930280b5 | (진입점 미연결) | SCP0012_PSI.cs:907 | try ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc2db343 | (진입점 미연결) | SCP0012_PSI.cs:912 | try | FLAG | dsBinding | dsTitle.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-334c90a0 | (진입점 미연결) | SCP0012_PSI.cs:912 | try | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-248d69c8 | (진입점 미연결) | SCP0012_PSI.cs:913 | try | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-60baedfe | (진입점 미연결) | SCP0012_PSI.cs:947 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f959cd0f | (진입점 미연결) | SCP0012_PSI.cs:948 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-055ba6a6 | (진입점 미연결) | SCP0012_PSI.cs:968 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2fa5ea5a | (진입점 미연결) | SCP0012_PSI.cs:982 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | VALUE_SET | cells.Text | "Sum" | 컨트롤 값 설정 |  |  |  |
| AC-54655bba | (진입점 미연결) | SCP0012_PSI.cs:983 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ColumnSpan | 2 | 속성 ColumnSpan 설정 |  |  |  |
| AC-da398f2c | (진입점 미연결) | SCP0012_PSI.cs:984 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-e7a98d2c | (진입점 미연결) | SCP0012_PSI.cs:985 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-28ba7d33 | (진입점 미연결) | SCP0012_PSI.cs:986 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-0d08710e | (진입점 미연결) | SCP0012_PSI.cs:997 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | GRID_SET | siMain.SetValue | (iRow, boh_idx, nSumInventory) | 그리드 값 설정 |  |  |  |
| AC-59371835 | (진입점 미연결) | SCP0012_PSI.cs:1005 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3bf3da07 | (진입점 미연결) | SCP0012_PSI.cs:1007 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6497944b | (진입점 미연결) | SCP0012_PSI.cs:1011 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-802c340f | (진입점 미연결) | SCP0012_PSI.cs:1018 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-785f8727 | (진입점 미연결) | SCP0012_PSI.cs:1020 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a38b9e8a | (진입점 미연결) | SCP0012_PSI.cs:1024 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0699ee7a | (진입점 미연결) | SCP0012_PSI.cs:1025 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0012_PSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8296754 | this.Load | SCP0012_PSI.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0012_PSI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a6cb38c | this.Load | SCP0012_PSI.cs:221 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-0ad9098a | this.Load | SCP0012_PSI.cs:222 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d420d496 | this.Load | SCP0012_PSI.cs:225 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0012_PSI.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fb27db8 | this.Load 외 1 | SCP0012_PSI.cs:1771 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4458872 | this.Load 외 1 | SCP0012_PSI.cs:1773 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0012_PSI.GetFromSiteByDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-552ba191 | (진입점 미연결) | SCP0012_PSI.cs:234 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_FROM_SITE") ⇒ SCM.SCM0001_GET_FROM_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-f69a0ee8 | (진입점 미연결) | SCP0012_PSI.cs:236 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f700b2de | (진입점 미연결) | SCP0012_PSI.cs:239 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0012_PSI.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e27b46b | (진입점 미연결) | SCP0012_PSI.cs:724 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-9c86b463 | (진입점 미연결) | SCP0012_PSI.cs:726 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-122c3cd1 | (진입점 미연결) | SCP0012_PSI.cs:727 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cdad89bb | (진입점 미연결) | SCP0012_PSI.cs:728 | try | FLAG | dsBinding | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c6498458 | (진입점 미연결) | SCP0012_PSI.cs:739 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-6cc11ddc | (진입점 미연결) | SCP0012_PSI.cs:740 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-e9a5ff5e | (진입점 미연결) | SCP0012_PSI.cs:741 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0012_PSI.GetSpdTitle

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5611c4a2 | this.Load 외 2 | SCP0012_PSI.cs:300 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SCP0012", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e867fa4 | this.Load 외 2 | SCP0012_PSI.cs:302 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-2d116fd3 | this.Load 외 2 | SCP0012_PSI.cs:1743 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6aae97b0 | this.Load 외 2 | SCP0012_PSI.cs:1744 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-1e440d7a | this.Load 외 2 | SCP0012_PSI.cs:1745 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-78f2775e | this.Load 외 2 | SCP0012_PSI.cs:1747 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9a87a0a8 | this.Load 외 2 | SCP0012_PSI.cs:1747 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0012_PSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5221e7f2 | this.Load | SCP0012_PSI.cs:186 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-4ccadb2b | this.Load | SCP0012_PSI.cs:189 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-caf7bc55 | this.Load | SCP0012_PSI.cs:190 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-7767af13 | this.Load | SCP0012_PSI.cs:191 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-266e21ae | this.Load | SCP0012_PSI.cs:194 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-49e196c6 | this.Load | SCP0012_PSI.cs:196 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-190339e4 | this.Load | SCP0012_PSI.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-74457a2f | this.Load | SCP0012_PSI.cs:200 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-82b24bf5 | this.Load | SCP0012_PSI.cs:200 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52fbf76c | this.Load | SCP0012_PSI.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9ae44684 | this.Load | SCP0012_PSI.cs:203 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-d1c33044 | this.Load | SCP0012_PSI.cs:203 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f7b5d1cf | this.Load | SCP0012_PSI.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5d09f02 | this.Load | SCP0012_PSI.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-d09230d9 | this.Load | SCP0012_PSI.cs:209 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-257c20e2 | this.Load | SCP0012_PSI.cs:210 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7caafc78 | this.Load | SCP0012_PSI.cs:212 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0012_PSI.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76103676 | (진입점 미연결) | SCP0012_PSI.cs:318 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-30af3c13 | (진입점 미연결) | SCP0012_PSI.cs:319 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-510f5f7e | (진입점 미연결) | SCP0012_PSI.cs:320 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP_DESC, DefMain.OPERATION_GROUP_DESC, FPMerge.Restricted, 65 ,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1c2fa3b | (진입점 미연결) | SCP0012_PSI.cs:321 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SITE_DESCRIPTION, DefMain.SITE_DESCRIPTION, FPMerge.Restricted, 65, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07772e7e | (진입점 미연결) | SCP0012_PSI.cs:322 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 115 , true , FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3714d214 | (진입점 미연결) | SCP0012_PSI.cs:323 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 80, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e252fe5 | (진입점 미연결) | SCP0012_PSI.cs:325 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ELECTRODE_TYPE, DefMain.ELECTRODE_TYPE, FPMerge.Restricted, elec_size, true … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28217b4c | (진입점 미연결) | SCP0012_PSI.cs:326 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainLabel.BOH, DefMain.BOH, FPMerge.Restricted , 75, true, FPHAlign.Right , FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0a94287 | (진입점 미연결) | SCP0012_PSI.cs:327 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_NAME, DefMain.PSI_NAME, FPMerge.Restricted, 75, true, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e77213fd | (진입점 미연결) | SCP0012_PSI.cs:328 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_VALUE, DefMain.PSI_VALUE, FPMerge.Restricted, 120, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f28ef901 | (진입점 미연결) | SCP0012_PSI.cs:329 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_TYPE, DefMain.PSI_TYPE, FPMerge.Restricted, 65, false, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbc9a95c | (진입점 미연결) | SCP0012_PSI.cs:331 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f1a2d33 | (진입점 미연결) | SCP0012_PSI.cs:332 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 130, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbea9b25 | (진입점 미연결) | SCP0012_PSI.cs:333 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP, DefMain.OPERATION_GROUP, FPMerge.Restricted, 60, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5af11bbf | (진입점 미연결) | SCP0012_PSI.cs:334 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_START_YYYYMMDD, DefMain.PLAN_START_YYYYMMDD, FPMerge.Restricted, 60, fa… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-150bfc3f | (진입점 미연결) | SCP0012_PSI.cs:335 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_TYPE, DefMain.PLAN_TYPE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dff9788c | (진입점 미연결) | SCP0012_PSI.cs:337 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SEQ, DefMain.SEQ, FPMerge.Restricted, 60, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12bb7dcb | (진입점 미연결) | SCP0012_PSI.cs:340 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-995e5610 | (진입점 미연결) | SCP0012_PSI.cs:341 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95d4a980 | (진입점 미연결) | SCP0012_PSI.cs:342 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_START_YYYYMMDD), 3, 1, 20, "PLAN_START_YYYYMMDD", … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-248c7c92 | (진입점 미연결) | SCP0012_PSI.cs:343 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_TYPE), 3, 1, 20, "PLAN_TYPE", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ded2e239 | (진입점 미연결) | SCP0012_PSI.cs:344 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SEQ), 3, 1, 20, "SEQ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0edd6948 | (진입점 미연결) | SCP0012_PSI.cs:345 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.OPERATION_GROUP), 3, 1, 20, "Operation Group", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca5e69fe | (진입점 미연결) | SCP0012_PSI.cs:346 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.OPERATION_GROUP_DESC), 3, 1, 20, "Operation Group", FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36a3762d | (진입점 미연결) | SCP0012_PSI.cs:347 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, "From Site", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c15c0da9 | (진입점 미연결) | SCP0012_PSI.cs:348 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SITE_DESCRIPTION), 3, 1, 20, "From Site", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ad1e5e4 | (진입점 미연결) | SCP0012_PSI.cs:349 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, "Model", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-493ae0aa | (진입점 미연결) | SCP0012_PSI.cs:350 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, "Nick Name", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-258386ad | (진입점 미연결) | SCP0012_PSI.cs:351 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ELECTRODE_TYPE), 3, 1, 20, "Electrode Type", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71127f21 | (진입점 미연결) | SCP0012_PSI.cs:352 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.BOH), 3, 1, 20, "BOH (From Site)" , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82086342 | (진입점 미연결) | SCP0012_PSI.cs:353 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_TYPE), 3, 1, 20, "PSI_Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25753d30 | (진입점 미연결) | SCP0012_PSI.cs:354 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_NAME), 3, 1, 20, "PSI Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c85da7dc | (진입점 미연결) | SCP0012_PSI.cs:355 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_VALUE), 3, 1, 20, "PSI Value", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-360e6b37 | (진입점 미연결) | SCP0012_PSI.cs:365 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee4b0221 | (진입점 미연결) | SCP0012_PSI.cs:366 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.PSI_VALUE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f084b37 | (진입점 미연결) | SCP0012_PSI.cs:367 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0012_PSI.InitSpread_2

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87186818 | this.Load 외 2 | SCP0012_PSI.cs:256 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d9743efe | this.Load 외 2 | SCP0012_PSI.cs:261 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-eeb378c1 | this.Load 외 2 | SCP0012_PSI.cs:268 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a08eb2c5 | this.Load 외 2 | SCP0012_PSI.cs:270 |  | GRID_INIT | siMain.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-08ae8d28 | this.Load 외 2 | SCP0012_PSI.cs:274 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8940b8d2 | this.Load 외 2 | SCP0012_PSI.cs:275 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4014cdbf | this.Load 외 2 | SCP0012_PSI.cs:276 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8627caa7 | this.Load 외 2 | SCP0012_PSI.cs:279 | if (!division.Substring(0, 2).Equals("EE")) ▸ if (division == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9e9cf92d | this.Load 외 2 | SCP0012_PSI.cs:281 | if (!division.Substring(0, 2).Equals("EE")) ▸ else of (division == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-eb3962f7 | this.Load 외 2 | SCP0012_PSI.cs:286 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-22017ab7 | this.Load 외 2 | SCP0012_PSI.cs:287 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-28f47cc2 | this.Load 외 2 | SCP0012_PSI.cs:288 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ef0c7812 | this.Load 외 2 | SCP0012_PSI.cs:289 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0012_PSI.InitSpreadDateColumn

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a77e828 | this.Load 외 2 | SCP0012_PSI.cs:403 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50ebdeeb | this.Load 외 2 | SCP0012_PSI.cs:404 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ca231af | this.Load 외 2 | SCP0012_PSI.cs:408 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7812e45 | this.Load 외 2 | SCP0012_PSI.cs:409 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a92e507a | this.Load 외 2 | SCP0012_PSI.cs:413 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-c0f51890 | this.Load 외 2 | SCP0012_PSI.cs:420 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1b314cc | this.Load 외 2 | SCP0012_PSI.cs:421 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-757315b1 | this.Load 외 2 | SCP0012_PSI.cs:426 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd9ad8ac | this.Load 외 2 | SCP0012_PSI.cs:427 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a929dd2 | this.Load 외 2 | SCP0012_PSI.cs:435 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fe873e8 | this.Load 외 2 | SCP0012_PSI.cs:436 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cffa586e | this.Load 외 2 | SCP0012_PSI.cs:446 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-595b1fbc | this.Load 외 2 | SCP0012_PSI.cs:447 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d42f715 | this.Load 외 2 | SCP0012_PSI.cs:448 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd03d790 | this.Load 외 2 | SCP0012_PSI.cs:449 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0012_PSI.RefreshFromSite

진입점: this.Load / cboDivision.SelectedIndexChanged / cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9fea735 | this.Load 외 2 | SCP0012_PSI.cs:634 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteEEAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e417547 | this.Load 외 2 | SCP0012_PSI.cs:634 | if (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtFromSiteEEAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a2942f5 | this.Load 외 2 | SCP0012_PSI.cs:639 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0cbd6d0 | this.Load 외 2 | SCP0012_PSI.cs:639 | else of (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtFromSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fccc06ed | this.Load 외 2 | SCP0012_PSI.cs:642 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0012_PSI.RefreshOperationGroup

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa1393f6 | cboDivision.SelectedIndexChanged | SCP0012_PSI.cs:475 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c8cb172 | cboDivision.SelectedIndexChanged | SCP0012_PSI.cs:475 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33e0dc24 | cboDivision.SelectedIndexChanged | SCP0012_PSI.cs:479 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-619bac6d | cboDivision.SelectedIndexChanged | SCP0012_PSI.cs:479 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a3bd7cd3 | cboDivision.SelectedIndexChanged | SCP0012_PSI.cs:482 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0012_PSI.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b8527c8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:649 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-000fc5c0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:649 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ce20e0d8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:650 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0012_PSI.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8be4f6cd | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:666 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-64c76b03 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:666 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "' AND PL… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-474bcd12 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:667 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0012_PSI.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c76fc8e0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:657 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanD… | 화면 필드/플래그 변경 |  |  |  |
| AC-614efb5e | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:657 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'", tru… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cef14084 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0012_PSI.cs:658 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0012_PSI.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1aad8763 | (진입점 미연결) | SCP0012_PSI.cs:1558 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0012_PSI.Set_Inventories

진입점: FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43267c95 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1252 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca86a58c | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1256 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8c2ed6 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1328 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total Load… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxWeek] | weekSum / nCntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-0256fd9e | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1340 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total Load… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxMonth] | monthSum / nCntDayOfMonth | 그리드 속성/값 설정 |  |  |  |
| AC-60ee1261 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1362 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-e091df0a | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1371 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-3f8b4559 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1379 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-9de9a634 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1380 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-dc747fd0 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1389 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-f270aade | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0012_PSI.cs:1393 | finally | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0012_PSI.Set_PSI_Measure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b9f8f97 | (진입점 미연결) | SCP0012_PSI.cs:1446 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-842b0ead | (진입점 미연결) | SCP0012_PSI.cs:1455 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-c27bb977 | (진입점 미연결) | SCP0012_PSI.cs:1463 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-8a42333f | (진입점 미연결) | SCP0012_PSI.cs:1464 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-45917707 | (진입점 미연결) | SCP0012_PSI.cs:1484 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-4e799d1d | (진입점 미연결) | SCP0012_PSI.cs:1485 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-c971d75a | (진입점 미연결) | SCP0012_PSI.cs:1492 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-87b074de | (진입점 미연결) | SCP0012_PSI.cs:1501 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-30b803b2 | (진입점 미연결) | SCP0012_PSI.cs:1510 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-21981a8b | (진입점 미연결) | SCP0012_PSI.cs:1511 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-26b649b3 | (진입점 미연결) | SCP0012_PSI.cs:1520 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-227a416d | (진입점 미연결) | SCP0012_PSI.cs:1524 | finally | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0012_PSI.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7fa93f8 | this.Load 외 1 | SCP0012_PSI.cs:678 | if (division == "40") | STATE | this.lcCellTypeGr.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e7b333a7 | this.Load 외 1 | SCP0012_PSI.cs:682 | else of (division == "40") | STATE | this.lcCellTypeGr.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fb4af86b | this.Load 외 1 | SCP0012_PSI.cs:684 | else of (division == "40") | CALL_EXT | cboCellTypeGr.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a91ab5f5 | this.Load 외 1 | SCP0012_PSI.cs:693 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-4b765b8a | this.Load 외 1 | SCP0012_PSI.cs:700 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-a1a54fe7 | this.Load 외 1 | SCP0012_PSI.cs:701 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b85c6af5 | this.Load 외 1 | SCP0012_PSI.cs:705 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0012_PSI.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdb4a4e6 | (진입점 미연결) | SCP0012_PSI.cs:1721 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e2d9e2f | (진입점 미연결) | SCP0012_PSI.cs:1725 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c454fcdf | (진입점 미연결) | SCP0012_PSI.cs:1728 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-514bf21b | (진입점 미연결) | SCP0012_PSI.cs:1732 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-d1c1c5d7 | (진입점 미연결) | SCP0012_PSI.cs:1733 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0012_PSI.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a28805 | (진입점 미연결) | SCP0012_PSI.cs:1541 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-51fecfab | (진입점 미연결) | SCP0012_PSI.cs:1547 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0012_PSI.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05cf986f | this.Load 외 4 | SCP0012_PSI.cs:1571 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cefac815 | this.Load 외 4 | SCP0012_PSI.cs:1576 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f4daea6e | this.Load 외 4 | SCP0012_PSI.cs:1583 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-628f3fa1 | this.Load 외 4 | SCP0012_PSI.cs:1587 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-af061fa6 | this.Load 외 4 | SCP0012_PSI.cs:1592 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ca427b36 | this.Load 외 4 | SCP0012_PSI.cs:1599 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4d1b7e2e | this.Load 외 4 | SCP0012_PSI.cs:1603 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0012_PSI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14778c04 | this.spdMain.CellDoubleClick | SCP0012_PSI.cs:534 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0012_PSI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-730c7c7a | this.spdMain.TopChange | SCP0012_PSI.cs:493 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0012_PSI.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7166c69d | (진입점 미연결) | SCP0012_PSI.cs:1623 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88a9e007 | (진입점 미연결) | SCP0012_PSI.cs:1625 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-e6c8d14a | (진입점 미연결) | SCP0012_PSI.cs:1631 | if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days > 364) | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53964712 | (진입점 미연결) | SCP0012_PSI.cs:1637 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

