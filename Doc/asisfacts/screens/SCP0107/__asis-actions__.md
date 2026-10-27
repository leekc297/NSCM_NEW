# AS-IS 액션 대조표 — SCP0107

> 원천: `Doc/asisfacts/screens/SCP0107/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 337행 · 메서드 79 · 종류 DATA_OP 84 · CALL_EXT 65 · FLAG 40 · RETURN 36 · GRID_INIT 23 · GRID_SET 22 · UI_PROP 21 · LIST_REBIND 10 · UI_MISC 8 · ENDPOINT 8 · POPUP 7 · GRID_BIND 4 · VALIDATE 2 · GRID_STYLE 2 · GRID_LOCK 1 · STATE_RESET 1 · MESSAGE 1 · COMBO_DATA 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 65


## SCP0107_CAPA_TEEP_Report.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb688656 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1506 |  | GRID_BIND | _si.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-831979f6 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1508 |  | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a8f0328 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1508 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd471768 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1510 |  | GRID_LOCK | _si.LockColumn | (0, _si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b8078dc | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1515 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0107_CAPA_TEEP_Report.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-987ea267 | this.btnColumn.Click | SCP0107_CAPA_TEEP_Report.cs:1767 |  | POPUP | new SCM002_CAPAColumnPopup | ("SCP0107", this._division_type_name, true) | 팝업/폼 생성 |  |  |  |
| AC-796a78cc | this.btnColumn.Click | SCP0107_CAPA_TEEP_Report.cs:1768 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d7d5c138 | this.btnColumn.Click | SCP0107_CAPA_TEEP_Report.cs:1770 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0107_CAPA_TEEP_Report.ChangeColumnNameToCodeName

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dce3963 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:812 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-04ec2037 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:814 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-c62b6f50 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:817 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-39953be3 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:819 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0107_CAPA_TEEP_Report.CheckChangedValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ad0ac76 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1403 | else of (base._si.ActiveSheet.RowCount != _tblOriginal.Rows.Count) ▸ for (r <= base._si.ActiveSheet.RowCount - 1) ▸ for (c <= base._si.Activ… | DATA_OP | _tblOriginal.Columns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a5addb9 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1416 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17021453 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1145 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f6e0881c | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1146 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c0d91fd | this.Load | SCP0107_CAPA_TEEP_Report.cs:1190 | foreach (KeyValuePair<string, int> kvp in this._SHEETS) | GRID_INIT | this.AddSheet | (spdMain, kvp.Key, kvp.Key, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0107_CAPA_TEEP_Report.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-396dd2b8 | DeleteButton | SCP0107_CAPA_TEEP_Report.cs:1360 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9959ade1 | DeleteButton | SCP0107_CAPA_TEEP_Report.cs:1363 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a06c6c7 | DeleteButton | SCP0107_CAPA_TEEP_Report.cs:1366 | if (_si.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adb15d70 | DeleteButton | SCP0107_CAPA_TEEP_Report.cs:1373 | if (action == CAppSetting.FlagI) | DATA_OP | _si.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0107_CAPA_TEEP_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26e0ac20 | Dispose | SCP0107_CAPA_TEEP_Report.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0107_CAPA_TEEP_Report.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35ad48f4 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1342 | if (this._currVersionProgressStatus != ProgressStatusType._2ND_CUTOFF) | MESSAGE | MessageHelper.GMessageBox | ("MSG00423", new object[] { "'2`nd Cut-off'" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c5e48b76 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1344 | if (this._currVersionProgressStatus != ProgressStatusType._2ND_CUTOFF) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0357929 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1347 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2e37e7f0 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1348 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00b33e45 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1622 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GET_CAPA_LOSS_PLAN, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0107_CAPA_TEEP_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-918a2f97 | this.Load | SCP0107_CAPA_TEEP_Report.cs:917 |  | DATA_OP | this._SHEETS.Add | (SHEETS.ASSEMBLY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-3669846c | this.Load | SCP0107_CAPA_TEEP_Report.cs:918 |  | DATA_OP | this._SHEETS.Add | (SHEETS.ELTR, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cfea029 | this.Load | SCP0107_CAPA_TEEP_Report.cs:921 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4fab778 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:543 | try | CALL_EXT | _curr_row.Columns | (DefColumns.COMPANY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edd545e0 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:549 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6dc5133 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:567 | try | CALL_EXT | _curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-35e88fdd | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:573 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c50e6f20 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:711 | try | CALL_EXT | _curr_row.Columns | (DefColumns.ELTR_LN_TP_CD) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d037035 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:717 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad6a7010 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:639 | try | CALL_EXT | _curr_row.Columns | (DefColumns.FACTORY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e90c6d14 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:645 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fd8f187 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:663 | try | CALL_EXT | _curr_row.Columns | (DefColumns.LINE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e95805b | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:669 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a466cd74 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:759 | try | CALL_EXT | _curr_row.Columns | (DefColumns.MEASURE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e012e73 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:765 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8721707 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:735 | try | CALL_EXT | _curr_row.Columns | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-acc671ad | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:741 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52996eb5 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:687 | try | CALL_EXT | _curr_row.Columns | (DefColumns.OPERATION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b2283ce | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:693 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bef114a2 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:591 | try | CALL_EXT | _curr_row.Columns | (DefColumns.PLANT_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-274f26a8 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:597 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getCurrSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23b3e81a | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:615 | try | CALL_EXT | _curr_row.Columns | (DefColumns.SITE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2db268fc | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:621 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.GetCurrVersionProgessStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce1503ba | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:973 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE", "VER_SEQ" }, new List<string>() { _division, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-a012d16f | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:975 | try | FLAG | dtProgressStatusCurr | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-689ad9f3 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:975 | try | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-11d912e3 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:986 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceab0dd6 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:209 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getDivisionType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb78e16 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:184 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86b052b6 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:497 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtElectrode, clbElectrodeType.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1196dac7 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:503 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0173a23b | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:425 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtFactory, clbFactory.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0da40f22 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:431 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3a2416e | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:449 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtLine, clbLine.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30f2b9b6 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:455 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45d1126a | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:473 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtOperation, clbOperation.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-73cccf02 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:479 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a71d60e9 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:401 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtPlant, clbPlant.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d664d0d | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:407 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ce0cf5 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:297 |  | CALL_EXT | ScpCapaBL.GetPlanType | (dtVersionAll, _division, _version, _version_seq) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2464f4b3 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:297 |  | RETURN | return ScpCapaBL.GetPlanType(dtVersionAll, _division, _version, _version_seq); |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b07aef86 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:383 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67d545e5 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:383 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2d1750d | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:363 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtSite, clbSite.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8889abe | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:369 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.GetSpdTitle

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a23f66e8 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1204 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_GET_SPREAD_TITLE") ⇒ SCP.SCP0104_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b0bfa24d | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1206 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | this._from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-efd010d7 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1207 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0107" | 행/컬럼 값 대입 |  |  |  |
| AC-c92e986f | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1208 |  | DATA_OP | request.Parameters["p_sheet_name"] | rgrpDivisionType.SelectedIndex == 0 ? SHEETS.ELTR : SHEETS.ASSEMBLY | 행/컬럼 값 대입 |  |  |  |
| AC-411a83b0 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1210 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-30547ae0 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1210 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6ff2315 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1214 |  | FLAG | this._sheetDateColumns | DBUtils.GetStringColumnValues(dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f0f0794 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1214 |  | CALL_EXT | DBUtils.GetStringColumnValues | (dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-23e008e2 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1215 |  | FLAG | this._sheetDateColumns | this._sheetDateColumns.Where(w => !w.Contains("ASSIGN_PRIORITY")).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-205d2baa | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1215 | lambda | DATA_OP | w.Contains | ("ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-1bae9891 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1217 |  | FLAG | this._sheetNumericColumns | new List<string>() { DefColumns.BIZ_QTY, DefColumns.PRE_QTY, DefColumns.PFRSLT_QTY, DefCol… | 화면 필드/플래그 변경 |  |  |  |
| AC-ee03a424 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1221 | foreach (string dateCol in _sheetDateColumns) | DATA_OP | this._sheetNumericColumns.Add | (dateCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46f451e1 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:258 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.getVersionSeq

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db9958d4 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:283 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPA_TEEP_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68bb0986 | this.Load | SCP0107_CAPA_TEEP_Report.cs:1126 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-420e5a13 | this.Load | SCP0107_CAPA_TEEP_Report.cs:1129 |  | DATA_OP | ReadOnlySheetList.Add | (SHEETS.ASSEMBLY) | 데이터 객체 조작/조회 |  |  |  |
| AC-5958348c | this.Load | SCP0107_CAPA_TEEP_Report.cs:1132 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0107_CAPA_TEEP_Report.InitDatasAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb44d1b6 | this.Load | SCP0107_CAPA_TEEP_Report.cs:799 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1b1335c | this.Load | SCP0107_CAPA_TEEP_Report.cs:799 |  | CALL_EXT | ScpCapaBL.GetCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cae0f8b7 | this.Load | SCP0107_CAPA_TEEP_Report.cs:792 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LOSS_PLAN, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f509254 | this.Load | SCP0107_CAPA_TEEP_Report.cs:793 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_LOSS_PLAN_MODEL, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c15bd98b | this.Load | SCP0107_CAPA_TEEP_Report.cs:794 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_LOSS_PLAN_LINE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0107_CAPA_TEEP_Report.InitSpread

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e722efd | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1227 |  | UI_PROP | spdMain.TabStripPolicy | TabStripPolicy.Never | 속성 TabStripPolicy 설정 |  |  |  |
| AC-dbbb862b | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1231 | for (i <= spdMain.Sheets.Count - 1) | GRID_SET | spdMain.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-0145b9f1 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1234 |  | FLAG | _si | GetSheetInfo(spdMain.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e50aaa4 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1236 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a09e9c6a | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1238 |  | GRID_INIT | _si.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-9d965b2a | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1240 |  | GRID_INIT | _si.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.MergeKeyColumns

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2115b0e | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1256 | for (c <= toIdx) ▸ if (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (headers.Cou… | DATA_OP | headers.Add | (c - 1, _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a4953ac | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1259 | for (c <= toIdx) ▸ if (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) | DATA_OP | headers.Add | (c, _si.ActiveSheet.ColumnHeader.Columns[c].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-72f47672 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1265 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | GRID_INIT | _si.ColumnHeaderSpan | (0, headers.First().Key, 1, headers.Count, 20, headers.First().Value, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77c8657d | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1266 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | GRID_INIT | _si.ColumnHeaderSpan | (1, headers.First().Key, 1, headers.Count, 20, headers.First().Value, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f799fb3 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1267 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | GRID_INIT | _si.ColumnHeaderSpan | (2, headers.First().Key, 1, headers.Count, 20, headers.First().Value, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78d09d0f | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1269 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | CALL_EXT | headers.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshAllPre

진입점: this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b122114 | this.rgrpDivisionType.SelectedIndexChanged | SCP0107_CAPA_TEEP_Report.cs:1152 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-e14b8b47 | this.rgrpDivisionType.SelectedIndexChanged | SCP0107_CAPA_TEEP_Report.cs:1152 |  | CALL_EXT | ScpCapaBL.GetCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95200b98 | this.Load | SCP0107_CAPA_TEEP_Report.cs:936 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshElectrodeAssemblyAll

진입점: this.Load [if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / this.rgrpDivisionType.SelectedIndexChanged [if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe4443fa | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0107_CAPA_TEEP_Report.cs:892 |  | FLAG | dtElectrodeAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD",… | 화면 필드/플래그 변경 |  |  |  |
| AC-48973c6e | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0107_CAPA_TEEP_Report.cs:892 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD", "ELTR_LN_TP_NM", "DISPL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-260b1923 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0107_CAPA_TEEP_Report.cs:896 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtElectrodeAll, "CODE", "NAME", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae29b84a | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0107_CAPA_TEEP_Report.cs:898 |  | FLAG | dtElectrodeAll | DBUtils.Sort(dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-aab0d125 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0107_CAPA_TEEP_Report.cs:898 |  | DATA_OP | DBUtils.Sort | (dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshElectrodeeEltrAll

진입점: this.Load [else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / this.rgrpDivisionType.SelectedIndexChanged [else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbef1a02 | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0107_CAPA_TEEP_Report.cs:903 |  | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.OperationElectrodeType, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2faaa3a | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0107_CAPA_TEEP_Report.cs:907 |  | CALL_EXT | ScpCapaBL.GetElectrodeOperationFilter | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c8a1c8e | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0107_CAPA_TEEP_Report.cs:909 |  | FLAG | dtElectrodeAll | DBUtils.Filter(tbl, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-033b833a | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0107_CAPA_TEEP_Report.cs:909 |  | DATA_OP | DBUtils.Filter | (tbl, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshElectrodeType

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-912c4bb3 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1109 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _division, _operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7de68f7 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1111 |  | FLAG | dtElectrode | DBUtils.Filter(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-c42a5ba4 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1111 |  | DATA_OP | DBUtils.Filter | (dtElectrodeAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a3ea3000 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1113 |  | FLAG | dtElectrode | DBUtils.Sort(dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-c46a2473 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1113 |  | DATA_OP | DBUtils.Sort | (dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-edfce156 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1115 |  | FLAG | dtElectrode | DBUtils.GetDistinctTable(dtElectrode, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-a2bde2c2 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1115 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtElectrode, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-605b6202 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1117 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrodeType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshFactory

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-111c6934 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1011 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b73a4fe | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1013 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b18888e5 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1013 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47874e5c | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1015 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f6ae087 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1015 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85f5836c | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1016 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshFactoryAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6edb310d | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:847 |  | FLAG | dtFactoryAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-ea93a5d5 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:847 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "F… | ⚠ 의미 확인 필요 |  |  |  |
| AC-af956ac5 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:851 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtFactoryAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshLine

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-593cd40f | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1021 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ccef7923 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1023 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf92f7ac | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1023 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60916c64 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1025 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-474b2a4e | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1025 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2b535f7 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1035 |  | DATA_OP | dtLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c7b712b | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1036 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c87b54a | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1037 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ2", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0653c725 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1044 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select("CODE LIKE '%" + _rowstr + "%'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2754d862 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1044 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select | ("CODE LIKE '%" + _rowstr + "%'") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbe94470 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1057 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-3d2cc22a | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1058 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ2"] | "2" | 그리드 속성/값 설정 |  |  |  |
| AC-7dc8965d | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1062 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-9757b287 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1063 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-7a028565 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1069 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-549a3c08 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1070 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-3e9cdd59 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1076 |  | DATA_OP | _dt.Select("","SEQ1,SEQ2 ASC").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9bc65303 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1076 |  | DATA_OP | _dt.Select | ("","SEQ1,SEQ2 ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-55923308 | this.Load 외 7 | SCP0107_CAPA_TEEP_Report.cs:1078 |  | LIST_REBIND | clsCtrl.setListBox | (resultDt, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshLineAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57bf9248 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:858 |  | FLAG | dtLineAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-85a05b7c | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:858 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "L… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4149193c | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:862 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtLineAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshOperation

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-658187c6 | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1083 |  | CALL_EXT | ScpCapaBL.GetFilterOperation | (_division_type, _division, _shop_group, _plant, _factory, _line) | ⚠ 의미 확인 필요 |  |  |  |
| AC-542e4343 | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1096 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-4cc42aa1 | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1096 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9349a74f | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1098 |  | FLAG | dtOperation | DBUtils.Sort(dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-40b3de43 | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1098 |  | DATA_OP | DBUtils.Sort | (dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-ff6df244 | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1100 |  | FLAG | dtOperation | DBUtils.GetDistinctTable(dtOperation, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-d34f0bb7 | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1100 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtOperation, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-de9b566d | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1102 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshOperationAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c5ead2 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:869 |  | FLAG | dtOperationAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FA… | 화면 필드/플래그 변경 |  |  |  |
| AC-857669ad | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:869 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "O… | ⚠ 의미 확인 필요 |  |  |  |
| AC-82ba0deb | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:873 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtOperationAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbaf023c | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:875 |  | FLAG | dtOperationAll | DBUtils.Sort(dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-337ff804 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:875 |  | DATA_OP | DBUtils.Sort | (dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshPlant

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cb2ea25 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1001 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ccb2c4e | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1003 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1092cfb | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1003 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd62e911 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1005 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-0632acee | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1005 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-750d68f7 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1006 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshPlantAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9c0d91 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:836 |  | FLAG | dtPlantAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-50785a02 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:836 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "PLANT_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b665ef56 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:840 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtPlantAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshPlanType

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae399ff | this.Load 외 3 | SCP0107_CAPA_TEEP_Report.cs:964 |  | VALUE_SET | txtPlanType.Text | _plan_type | 컨트롤 값 설정 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshSheetHeader

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-577054b1 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1279 |  | GRID_INIT | _si.SetSheetHeaderColumnSCP | (_si, 3, refreshAllColumn, _fixed_column_name) | 그리드 재구성/초기화 |  |  |  |
| AC-27ce460e | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1288 |  | CALL_EXT | SheetUtils.RefreshSpreadDateColumn | (_si , dsSpdTitle.Tables[0] // tblTitle , DateColumns.COLUMN_NAME // dataColumnName, 월 , D… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshSite

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc44b23a | this.Load 외 4 | SCP0107_CAPA_TEEP_Report.cs:991 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21537261 | this.Load 외 4 | SCP0107_CAPA_TEEP_Report.cs:993 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a48476a | this.Load 외 4 | SCP0107_CAPA_TEEP_Report.cs:993 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80835360 | this.Load 외 4 | SCP0107_CAPA_TEEP_Report.cs:995 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-73cfdd31 | this.Load 외 4 | SCP0107_CAPA_TEEP_Report.cs:995 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-096a5b84 | this.Load 외 4 | SCP0107_CAPA_TEEP_Report.cs:996 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshSiteAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f74c4ec0 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:825 |  | FLAG | dtSiteAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-14317a8a | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:825 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-53082cb1 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:829 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtSiteAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshVersion

진입점: this.Load / this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86bd00a7 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:941 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "PROG_STAT" }, new List<string>() { _division, "2" },… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b35ae18d | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:943 |  | FLAG | dtVersion | DBUtils.GetDistinctedCode(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d26b8473 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:943 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtVersionAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ac7b705 | this.Load 외 1 | SCP0107_CAPA_TEEP_Report.cs:946 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.RefreshVersionSeq

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d324d63 | this.Load 외 2 | SCP0107_CAPA_TEEP_Report.cs:951 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE" }, new List<string>() { _division, _version },… | ⚠ 의미 확인 필요 |  |  |  |
| AC-483b1a71 | this.Load 외 2 | SCP0107_CAPA_TEEP_Report.cs:953 |  | FLAG | dtVersionSeq | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-90ce6655 | this.Load 외 2 | SCP0107_CAPA_TEEP_Report.cs:953 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-70052861 | this.Load 외 2 | SCP0107_CAPA_TEEP_Report.cs:955 |  | FLAG | dtVersionSeq | DBUtils.GetDistinctTable(dtVersionSeq, "VER_SEQ") | 화면 필드/플래그 변경 |  |  |  |
| AC-9f353f94 | this.Load 외 2 | SCP0107_CAPA_TEEP_Report.cs:955 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtVersionSeq, "VER_SEQ") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0d004d7 | this.Load 외 2 | SCP0107_CAPA_TEEP_Report.cs:959 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionSeq, cboVersionSeq, false, "VER_SEQ", "VER_SEQ") | 목록 컨트롤 재구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-229ff154 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1525 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06973182 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1570 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureVal != "") | GRID_STYLE | _si.SetBGColor | (i, _si.GetColumnIndex(DefColumns.MEASURE_NAME), i, spdMain.ActiveSheet.ColumnCount - 1, m… | 그리드 표시 설정 |  |  |  |
| AC-73271d63 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1574 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetBaseToDateColumns

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5513756a | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1728 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8ac6bc9 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1760 | for (i <= _dateEndColIdx) | GRID_SET | _si.SetValue | (qtyRowIdx, i, base_qty) | 그리드 값 설정 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetQueryInfoGet

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35caae2a | FindButton | SCP0107_CAPA_TEEP_Report.cs:1590 | if (this.QueryDics[DIC_GET_CAPA_LOSS_PLAN].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LOSS_PLAN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-50084aa5 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1595 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-adb983b1 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1596 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-fc62340c | FindButton | SCP0107_CAPA_TEEP_Report.cs:1597 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-781768c7 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1598 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0107_GET_CAPA_TEEP_{0}", _sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-bf671030 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1600 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ced66bad | FindButton | SCP0107_CAPA_TEEP_Report.cs:1601 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4c0f090 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1602 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fe22df0 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1603 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d40c6e1 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1604 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c880d99 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1605 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46e0e316 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1606 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3a141d9 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1607 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-058a2e64 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1608 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dae7ba58 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1609 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0107")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b81ad2e | FindButton | SCP0107_CAPA_TEEP_Report.cs:1610 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", _sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e45093e | FindButton | SCP0107_CAPA_TEEP_Report.cs:1611 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d34d020 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1612 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b6f0d47 | FindButton | SCP0107_CAPA_TEEP_Report.cs:1615 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LOSS_PLAN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetSheetMerge

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a6575ec | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1581 | if (!this.IsEditMode) | CALL_EXT | _si.ToggleMerge | (spdMain.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6ea8db8 | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1582 | if (!this.IsEditMode) | GRID_INIT | _si.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetSheetNumericColumnFormat

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e65aec82 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1480 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-610f1abf | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1486 | try | DATA_OP | dic.Add | ("SCP_PROD_PLAN", new CellFormatConditionType(0, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cec89ade | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1486 | try | POPUP | new CellFormatConditionType | (0, 1) | 팝업/폼 생성 |  |  |  |
| AC-b733194f | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1487 | try | DATA_OP | dic.Add | ("PROD_CAPA_M", new CellFormatConditionType(0, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6704f95 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1487 | try | POPUP | new CellFormatConditionType | (0, 1) | 팝업/폼 생성 |  |  |  |
| AC-5d0e6112 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1488 | try | DATA_OP | dic.Add | ("PROD_CAPA_D", new CellFormatConditionType(0, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0257cf30 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1488 | try | POPUP | new CellFormatConditionType | (0, 1) | 팝업/폼 생성 |  |  |  |
| AC-88208ba3 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1489 | try | DATA_OP | dic.Add | ("SCP_PROD_PLAN_DDN", new CellFormatConditionType(0, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e24b57c0 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1489 | try | POPUP | new CellFormatConditionType | (0, 1) | 팝업/폼 생성 |  |  |  |
| AC-33287e61 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1490 | try | DATA_OP | dic.Add | ("THRY_CAPA_D", new CellFormatConditionType(0, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-811a58f7 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1490 | try | POPUP | new CellFormatConditionType | (0, 1) | 팝업/폼 생성 |  |  |  |
| AC-59a7faf0 | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1492 | try | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_si, this._sheetNumericColumns, DefColumns.MEASURE, dic) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7e5152f | (진입점 미연결) | SCP0107_CAPA_TEEP_Report.cs:1498 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetVisibleElectrodeType

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfc874a7 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1447 | if (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.ELTR) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-92767417 | this.Load 외 5 | SCP0107_CAPA_TEEP_Report.cs:1451 | else of (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.ELTR) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetVisibleOperation

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b96cc28a | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1435 | if (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b821d26b | this.Load 외 8 | SCP0107_CAPA_TEEP_Report.cs:1439 | else of (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0107_CAPA_TEEP_Report.SetVisibleSheetColumns

진입점: this.Load / this.clbDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-507d2ddf | this.Load 외 6 | SCP0107_CAPA_TEEP_Report.cs:1459 |  | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, this.IsEditMode, new List<string>() { DefColumns.VER_ID , DefColumns.VER_SEQ , DefCo… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0107_CAPAReportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-368daf27 | this.Load | SCP0107_CAPAReportPopup.cs:133 |  | GRID_INIT | this.AddSheet | (spdBase, SpdSheet.shtSpdBase, SpdSheet.shtSpdBase, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af332879 | this.Load | SCP0107_CAPAReportPopup.cs:134 |  | FLAG | siSpdBase | GetSheetInfo(spdBase.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-8fc4569d | this.Load | SCP0107_CAPAReportPopup.cs:135 |  | GRID_INIT | clsCtrl.InitSheet | (siSpdBase, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-bbc26e46 | this.Load | SCP0107_CAPAReportPopup.cs:137 |  | GRID_INIT | this.AddSheet | (spdUser, SpdSheet.shtSpdUser, SpdSheet.shtSpdUser, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df5531e9 | this.Load | SCP0107_CAPAReportPopup.cs:138 |  | FLAG | siSpdUser | GetSheetInfo(spdUser.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-72b78d5b | this.Load | SCP0107_CAPAReportPopup.cs:139 |  | GRID_INIT | clsCtrl.InitSheet | (siSpdUser, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-040d55e0 | this.Load | SCP0107_CAPAReportPopup.cs:141 |  | GRID_INIT | siSpdBase.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a23e96a0 | this.Load | SCP0107_CAPAReportPopup.cs:142 |  | GRID_INIT | siSpdUser.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0107_CAPAReportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0e2e547 | this.Load | SCP0107_CAPAReportPopup.cs:108 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-c3328158 | this.Load | SCP0107_CAPAReportPopup.cs:110 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0107_CAPAReportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b890ae6f | Dispose | SCP0107_CAPAReportPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0107_CAPAReportPopup.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-023c5915 | FindButton | SCP0107_CAPAReportPopup.cs:437 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.SEL_COLUMN), SEL_COLUMN_TEXT) | 그리드 재구성/초기화 |  |  |  |
| AC-2559b60d | FindButton | SCP0107_CAPAReportPopup.cs:441 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdb05d51 | FindButton | SCP0107_CAPAReportPopup.cs:445 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_DIO_REPORT_H") ⇒ SCP.SCP0083_GET_DIO_REPORT_H | 엔드포인트 요청 생성 |  |  |  |
| AC-a2a50f90 | FindButton | SCP0107_CAPAReportPopup.cs:446 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-300bf231 | FindButton | SCP0107_CAPAReportPopup.cs:447 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | PLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-da6778fe | FindButton | SCP0107_CAPAReportPopup.cs:448 | lambda | DATA_OP | request.Parameters["p_plan_type"] | PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-6049c947 | FindButton | SCP0107_CAPAReportPopup.cs:449 | lambda | DATA_OP | request.Parameters["p_seq"] | SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-ab0bced8 | FindButton | SCP0107_CAPAReportPopup.cs:450 | lambda | DATA_OP | request.Parameters["p_item_id"] | ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-76ecdf55 | FindButton | SCP0107_CAPAReportPopup.cs:451 | lambda | DATA_OP | request.Parameters["p_nick_name"] | NICK_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-cbe0a2a8 | FindButton | SCP0107_CAPAReportPopup.cs:452 | lambda | DATA_OP | request.Parameters["p_plant_id"] | PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-990773a6 | FindButton | SCP0107_CAPAReportPopup.cs:453 | lambda | DATA_OP | request.Parameters["p_sel_column"] | SEL_COLUMN | 행/컬럼 값 대입 |  |  |  |
| AC-f2eba381 | FindButton | SCP0107_CAPAReportPopup.cs:454 | lambda | DATA_OP | request.Parameters["p_ver"] | VERSION | 행/컬럼 값 대입 |  |  |  |
| AC-44301383 | FindButton | SCP0107_CAPAReportPopup.cs:455 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-217239b7 | FindButton | SCP0107_CAPAReportPopup.cs:456 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69217fe0 | FindButton | SCP0107_CAPAReportPopup.cs:458 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bb0dc403 | FindButton | SCP0107_CAPAReportPopup.cs:462 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCP0107_CAPAReportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb4387ca | this.Load | SCP0107_CAPAReportPopup.cs:87 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0107_CAPAReportPopup.GetTitleSet

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3579bc71 | .ctor | SCP0107_CAPAReportPopup.cs:410 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0002_GET_TITLESET_POPUP") ⇒ SCM.SCM0002_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-733eac4f | .ctor | SCP0107_CAPAReportPopup.cs:411 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0107" | 행/컬럼 값 대입 |  |  |  |
| AC-4ab315b3 | .ctor | SCP0107_CAPAReportPopup.cs:412 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ASSEMBLY" | 행/컬럼 값 대입 |  |  |  |
| AC-bda08a30 | .ctor | SCP0107_CAPAReportPopup.cs:413 |  | DATA_OP | request.Parameters["p_column_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-d2b7fce5 | .ctor | SCP0107_CAPAReportPopup.cs:414 |  | DATA_OP | request.Parameters["p_user_id"] | "jahn1502" | 행/컬럼 값 대입 |  |  |  |
| AC-a36798f1 | .ctor | SCP0107_CAPAReportPopup.cs:415 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa0a1b80 | .ctor | SCP0107_CAPAReportPopup.cs:416 |  | FLAG | _dtTitleSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0107_CAPAReportPopup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-954c6968 | this.Load | SCP0107_CAPAReportPopup.cs:116 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-28e957ea | this.Load | SCP0107_CAPAReportPopup.cs:118 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-4d7bf4b4 | this.Load | SCP0107_CAPAReportPopup.cs:120 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-c9000182 | this.Load | SCP0107_CAPAReportPopup.cs:121 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-73682bdf | this.Load | SCP0107_CAPAReportPopup.cs:122 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-0ac2c8ff | this.Load | SCP0107_CAPAReportPopup.cs:124 |  | UI_PROP | this.Size | new Size(600, 400) | 속성 Size 설정 |  |  |  |
| AC-202f1f8e | this.Load | SCP0107_CAPAReportPopup.cs:127 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-73544b40 | this.Load | SCP0107_CAPAReportPopup.cs:128 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## SCP0107_CAPAReportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f784457 | this.Load | SCP0107_CAPAReportPopup.cs:149 |  | GRID_INIT | siSpdBase.InitSheet | (siSpdBase.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-844d9dea | this.Load | SCP0107_CAPAReportPopup.cs:150 |  | GRID_INIT | siSpdBase.SetSheetHeaderColumn | (siSpdBase, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1522a077 | this.Load | SCP0107_CAPAReportPopup.cs:151 |  | GRID_INIT | siSpdBase.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16365de7 | this.Load | SCP0107_CAPAReportPopup.cs:152 |  | GRID_INIT | siSpdBase.AddTextColumn | ("COLUMN_LABEL_NAME", "COLUMN_LABEL_NAME", FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2a8222b | this.Load | SCP0107_CAPAReportPopup.cs:156 |  | GRID_INIT | siSpdUser.InitSheet | (siSpdUser.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-908735ac | this.Load | SCP0107_CAPAReportPopup.cs:157 |  | GRID_INIT | siSpdUser.SetSheetHeaderColumn | (siSpdUser, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-51ae10b6 | this.Load | SCP0107_CAPAReportPopup.cs:158 |  | GRID_INIT | siSpdBase.AddTextColumn | ("COLUMN_NAME", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c78cfb67 | this.Load | SCP0107_CAPAReportPopup.cs:159 |  | GRID_INIT | siSpdUser.AddTextColumn | ("COLUMN_LABEL_NAME", "COLUMN_LABEL_NAME", FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0107_CAPAReportPopup.IsFixedColumn

진입점: this.Load [if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67a98704 | this.Load [if (svSource == spdUser.Sheets[0]) ▸ foreach (Far… 외 1 | SCP0107_CAPAReportPopup.cs:384 | if (_fixColumns == null) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-204ea153 | this.Load [if (svSource == spdUser.Sheets[0]) ▸ foreach (Far… 외 1 | SCP0107_CAPAReportPopup.cs:387 | if (_fixColumns.Length == 0) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-7fee0b98 | this.Load [if (svSource == spdUser.Sheets[0]) ▸ foreach (Far… 외 1 | SCP0107_CAPAReportPopup.cs:390 | if (colName.Trim().Length == 0) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-0bffca31 | this.Load [if (svSource == spdUser.Sheets[0]) ▸ foreach (Far… 외 1 | SCP0107_CAPAReportPopup.cs:394 | try | DATA_OP | _fixColumns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2c204b3 | this.Load [if (svSource == spdUser.Sheets[0]) ▸ foreach (Far… 외 1 | SCP0107_CAPAReportPopup.cs:400 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0107_CAPAReportPopup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b25a0b9 | this.Load | SCP0107_CAPAReportPopup.cs:376 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-b37fe2c2 | this.Load | SCP0107_CAPAReportPopup.cs:377 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## SCP0107_CAPAReportPopup.SetFixColumnStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a32a585 | (진입점 미연결) | SCP0107_CAPAReportPopup.cs:359 | for (r <= svSource.Rows.Count - 1) ▸ for (c <= svSource.Columns.Count - 1) | GRID_SET | svSource.Cells[r, c].BackColor | Color.WhiteSmoke | 그리드 속성/값 설정 |  |  |  |

## SCP0107_CAPAReportPopup.SetTitleSet

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-762e1354 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:172 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-12c19527 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:172 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'N'", "SORT_ORDER_NO").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4adfd1b4 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:172 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-271618b2 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:173 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ba9a7d3 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:173 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'Y'", sSortColumn).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-755723d7 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:173 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-464abdb5 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:177 | if (dtBase == null) | GRID_SET | spdBase.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8ecf832a | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:179 | else of (dtBase == null) | GRID_BIND | si.Query | (dtBase) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-533e1aa2 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:183 | if (dtUser == null) | GRID_SET | spdUser.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-25458801 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:185 | else of (dtUser == null) | GRID_BIND | si.Query | (dtUser) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e669417b | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:195 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |
| AC-c8b844c6 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:203 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1634953 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:204 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8cdc39a | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:234 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-76c4260a | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:240 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-a596139c | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:244 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a5d79ff | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:246 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-503cd622 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:260 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3df208d | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:262 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-a325a4cd | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:266 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b089601 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:268 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-cafd83cf | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:301 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c73d098 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:304 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_NAME"].Index].Text | sColumnName | 그리드 속성/값 설정 |  |  |  |
| AC-aab26890 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:305 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_LABEL_NAME"].Index].Text | sLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-a9214530 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:306 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SMALL_CLASS_LABEL_NAME"].Index].Text | sSLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-73138a95 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:307 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["LARGE_CLASS_LABEL_NAME"].Index].Text | sLLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-fa3c689b | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:308 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_METHOD_CODE"].Index].Text | sSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-a4ed6f05 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:309 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_ORDER_NO"].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-61c7b654 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:310 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SORT_METHOD_CODE"].Index].Text | sUSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-36ffb2a3 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:311 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SELECTABLE_FLAG"].Index].Text | sUserSelectedFlag | 그리드 속성/값 설정 |  |  |  |
| AC-1cb1675e | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:317 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-2d4a312d | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:322 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-af26b541 | this.Load 외 1 | SCP0107_CAPAReportPopup.cs:324 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |

