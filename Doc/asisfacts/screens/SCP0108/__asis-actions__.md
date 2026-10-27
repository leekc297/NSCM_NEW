# AS-IS 액션 대조표 — SCP0108

> 원천: `Doc/asisfacts/screens/SCP0108/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 216행 · 메서드 66 · 종류 CALL_EXT 63 · FLAG 34 · DATA_OP 34 · RETURN 31 · UI_PROP 13 · LIST_REBIND 12 · UI_MISC 5 · GRID_INIT 5 · POPUP 4 · VALUE_SET 4 · ENDPOINT 3 · GRID_SET 2 · VALIDATE 2 · GRID_BIND 1 · GRID_LOCK 1 · STATE_RESET 1 · MESSAGE 1 · ⚠ 의미 확인 필요 63


## SCP0108_CAPA_LOB_Report.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-770dd0d9 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1402 |  | GRID_BIND | _si.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4b14f30e | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1404 |  | FLAG | _tblBottleneckFlag | ds.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6400d05c | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1404 |  | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f7cb45f | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1406 |  | GRID_LOCK | _si.LockColumn | (0, _si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-71ed5cfc | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1411 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-10ef2af9 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1418 | if (this.IsEditMode) | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5e65124 | this.btnColumn.Click | SCP0108_CAPA_LOB_Report.cs:1616 |  | POPUP | new SCM002_CAPAColumnPopup | ("SCP0108", this._sheet_name, true) | 팝업/폼 생성 |  |  |  |
| AC-838d6873 | this.btnColumn.Click | SCP0108_CAPA_LOB_Report.cs:1617 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bf691c66 | this.btnColumn.Click | SCP0108_CAPA_LOB_Report.cs:1619 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0108_CAPA_LOB_Report.btnItem_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a8a13af | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1610 | if (nicknames != "") | VALUE_SET | txtItem.Text | nicknames | 컨트롤 값 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.ChangeColumnNameToCodeName

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da2bc289 | this.Load | SCP0108_CAPA_LOB_Report.cs:888 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-a70d307f | this.Load | SCP0108_CAPA_LOB_Report.cs:890 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-0c7a1bb6 | this.Load | SCP0108_CAPA_LOB_Report.cs:893 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-077f5a3d | this.Load | SCP0108_CAPA_LOB_Report.cs:895 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28ff851c | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1148 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5a795e65 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1149 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceff05cf | this.Load | SCP0108_CAPA_LOB_Report.cs:1167 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.CURRENT, SpdSheet.CURRENT, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3ff4f857 | this.Load | SCP0108_CAPA_LOB_Report.cs:1168 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.CUTOFF, SpdSheet.CUTOFF, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0108_CAPA_LOB_Report.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-615bfedd | DeleteButton | SCP0108_CAPA_LOB_Report.cs:1291 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1faba77 | DeleteButton | SCP0108_CAPA_LOB_Report.cs:1294 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-333210be | DeleteButton | SCP0108_CAPA_LOB_Report.cs:1297 | if (_si.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c72c688 | DeleteButton | SCP0108_CAPA_LOB_Report.cs:1304 | if (action == CAppSetting.FlagI) | DATA_OP | _si.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0108_CAPA_LOB_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86b88d16 | Dispose | SCP0108_CAPA_LOB_Report.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0108_CAPA_LOB_Report.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8f2aa46 | FindButton | SCP0108_CAPA_LOB_Report.cs:1273 | if (this._currVersionProgressStatus == ProgressStatusType._PRE) | MESSAGE | MessageHelper.GMessageBox | ("MSG00423", new object[] { "'Current" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3c246a8 | FindButton | SCP0108_CAPA_LOB_Report.cs:1275 | if (this._currVersionProgressStatus == ProgressStatusType._PRE) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a167805 | FindButton | SCP0108_CAPA_LOB_Report.cs:1278 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4f0cfde5 | FindButton | SCP0108_CAPA_LOB_Report.cs:1279 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddd6f1a2 | FindButton | SCP0108_CAPA_LOB_Report.cs:1479 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GET_CAPA_LOB, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0108_CAPA_LOB_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e5bcf8f | this.Load | SCP0108_CAPA_LOB_Report.cs:969 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-170ff550 | this.Load | SCP0108_CAPA_LOB_Report.cs:975 |  | VALUE_SET | rgrpDivisionType.SelectedIndex | DivisionType.CELL | 컨트롤 값 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.getBottleneck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d38c3a81 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:600 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c946a33 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:640 | try | CALL_EXT | _curr_row.Columns | (DefColumns.COMPANY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e583e99 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:646 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e6f6c57 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:664 | try | CALL_EXT | _curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d5d0f30 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:670 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e163ef28 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:808 | try | CALL_EXT | _curr_row.Columns | (DefColumns.ELTR_LN_TP_CD) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a61b704 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:814 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7908624e | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:736 | try | CALL_EXT | _curr_row.Columns | (DefColumns.FACTORY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41dacc4f | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:742 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d4cc699 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:760 | try | CALL_EXT | _curr_row.Columns | (DefColumns.LINE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ad33f22 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:766 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a2fff1d | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:832 | try | CALL_EXT | _curr_row.Columns | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58e0d213 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:838 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf7b17d8 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:784 | try | CALL_EXT | _curr_row.Columns | (DefColumns.OPERATION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cc18231 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:790 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-833504d0 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:688 | try | CALL_EXT | _curr_row.Columns | (DefColumns.PLANT_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b8fa676 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:694 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getCurrSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ac327c0 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:712 | try | CALL_EXT | _curr_row.Columns | (DefColumns.SITE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0919a2d | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:718 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.GetCurrVersionProgessStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b670043 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:142 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE", "VER_SEQ" }, new List<string>() { _division, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-9461736a | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:144 | try | FLAG | dtProgressStatusCurr | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6fa682f | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:144 | try | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1a19d6f6 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:155 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7093807 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:198 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtDivision, cboDivision.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3102b80f | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:204 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getDivisionType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4b3f473 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:171 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a2ad596 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:568 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtElectrode, clbElectrodeType.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b97ad92c | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:574 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41c1d314 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:472 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtFactory, clbFactory.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f9682a0 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:478 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0a75c6d | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:550 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c58caa44 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:496 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtLine, clbLine.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28318fe6 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:502 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa207434 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:520 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtOperation, clbOperation.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bfa0cf8 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:526 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64f3d05d | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:448 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtPlant, clbPlant.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8338cf2 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:454 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-946ced7e | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:255 |  | CALL_EXT | ScpCapaBL.GetPlanType | (dtVersionAll, _division, _version, _version_seq) | ⚠ 의미 확인 필요 |  |  |  |
| AC-406a9fe3 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:255 |  | RETURN | return ScpCapaBL.GetPlanType(dtVersionAll, _division, _version, _version_seq); |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getProgressStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d647ab | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:279 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cde4f04b | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:430 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-87ccaed1 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:430 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c29eca3 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:410 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtSite, clbSite.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b70dc52d | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:416 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7167b4d4 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1179 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_GET_SPREAD_TITLE") ⇒ SCP.SCP0104_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-e4e813d5 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1181 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | this._from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-a36f1dbe | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1182 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0108" | 행/컬럼 값 대입 |  |  |  |
| AC-95c83462 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1183 |  | DATA_OP | request.Parameters["p_sheet_name"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-b732571e | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1185 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8d389257 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1185 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1cd087c0 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1189 |  | FLAG | this._sheetDateColumns | DBUtils.GetStringColumnValues(dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c9a12a9 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1189 |  | CALL_EXT | DBUtils.GetStringColumnValues | (dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32664ba0 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1190 |  | FLAG | this._sheetDateColumns | this._sheetDateColumns.Where(w => !w.Contains("ASSIGN_PRIORITY")).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-708c5b8f | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1190 | lambda | DATA_OP | w.Contains | ("ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-e54b4a7c | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1192 |  | FLAG | this._sheetNumericColumns | _sheetDateColumns | 화면 필드/플래그 변경 |  |  |  |

## SCP0108_CAPA_LOB_Report.getVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-040acffb | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:231 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.getVersionSeq

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd3c1953 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:326 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0108_CAPA_LOB_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2a94e0c | this.Load | SCP0108_CAPA_LOB_Report.cs:1128 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd36fadc | this.Load | SCP0108_CAPA_LOB_Report.cs:1131 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.CURRENT) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb39c73f | this.Load | SCP0108_CAPA_LOB_Report.cs:1134 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39a1a1d7 | this.Load | SCP0108_CAPA_LOB_Report.cs:865 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LOB, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0108_CAPA_LOB_Report.InitSpread

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f0737f5 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1197 |  | UI_PROP | spdMain.TabStripPolicy | TabStripPolicy.Never | 속성 TabStripPolicy 설정 |  |  |  |
| AC-8a8e5faf | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1199 |  | FLAG | _si | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-b39edbb4 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1201 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01f8508c | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1203 |  | GRID_INIT | _si.InitSheet | (_sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-c5a46d44 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1205 |  | GRID_INIT | _si.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshBottleneck

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84ce630e | this.Load | SCP0108_CAPA_LOB_Report.cs:882 |  | LIST_REBIND | cboBottleneck.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshDateColumnStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-763aa27c | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1353 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f2e2e984 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1363 | try ▸ for (r <= rowCnt-1) | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_si, dateColumnStartIdx, "###,##0.0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7cefd03 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1386 | try ▸ for (r <= rowCnt-1) ▸ for (c <= colCnt-1) | CALL_EXT | _si.SetRowFormat | (r, c, 1, "###,##0.0", "", false, columnColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-090f47d9 | (진입점 미연결) | SCP0108_CAPA_LOB_Report.cs:1394 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c27c465f | this.Load | SCP0108_CAPA_LOB_Report.cs:986 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshElectrodeType

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a92c3ee | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1111 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _division, _operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3636395 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1113 |  | FLAG | dtElectrode | DBUtils.Filter(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-268592b1 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1113 |  | DATA_OP | DBUtils.Filter | (dtElectrodeAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e38fb433 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1115 |  | FLAG | dtElectrode | DBUtils.Sort(dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-d4fd0e50 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1115 |  | DATA_OP | DBUtils.Sort | (dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-b5ed96b8 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1117 |  | FLAG | dtElectrode | DBUtils.GetDistinctTable(dtElectrode, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-6cbee0ca | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1117 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtElectrode, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-09f6e649 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1119 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrodeType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshElectrodeTypeAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e741b02c | this.Load | SCP0108_CAPA_LOB_Report.cs:956 |  | FLAG | dtElectrodeAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD",… | 화면 필드/플래그 변경 |  |  |  |
| AC-a1c784ff | this.Load | SCP0108_CAPA_LOB_Report.cs:956 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD", "ELTR_LN_TP_NM", "DISPL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f63710a | this.Load | SCP0108_CAPA_LOB_Report.cs:960 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtElectrodeAll, "CODE", "NAME", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94ceeb18 | this.Load | SCP0108_CAPA_LOB_Report.cs:962 |  | FLAG | dtElectrodeAll | DBUtils.Sort(dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-e2f802f2 | this.Load | SCP0108_CAPA_LOB_Report.cs:962 |  | DATA_OP | DBUtils.Sort | (dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshFactory

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc299706 | this.cboDivision.SelectedIndexChanged 외 5 | SCP0108_CAPA_LOB_Report.cs:1076 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-822415d1 | this.cboDivision.SelectedIndexChanged 외 5 | SCP0108_CAPA_LOB_Report.cs:1078 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1cae648 | this.cboDivision.SelectedIndexChanged 외 5 | SCP0108_CAPA_LOB_Report.cs:1078 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-73540766 | this.cboDivision.SelectedIndexChanged 외 5 | SCP0108_CAPA_LOB_Report.cs:1080 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-0283f8e0 | this.cboDivision.SelectedIndexChanged 외 5 | SCP0108_CAPA_LOB_Report.cs:1080 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47384aab | this.cboDivision.SelectedIndexChanged 외 5 | SCP0108_CAPA_LOB_Report.cs:1081 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshFactoryAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-596ea49f | this.Load | SCP0108_CAPA_LOB_Report.cs:923 |  | FLAG | dtFactoryAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-d29452eb | this.Load | SCP0108_CAPA_LOB_Report.cs:923 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "F… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fb7b096 | this.Load | SCP0108_CAPA_LOB_Report.cs:927 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtFactoryAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshLine

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6d7cc27 | this.cboDivision.SelectedIndexChanged 외 6 | SCP0108_CAPA_LOB_Report.cs:1086 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83c49aec | this.cboDivision.SelectedIndexChanged 외 6 | SCP0108_CAPA_LOB_Report.cs:1088 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-598bd8b3 | this.cboDivision.SelectedIndexChanged 외 6 | SCP0108_CAPA_LOB_Report.cs:1088 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0074d520 | this.cboDivision.SelectedIndexChanged 외 6 | SCP0108_CAPA_LOB_Report.cs:1090 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-152c511e | this.cboDivision.SelectedIndexChanged 외 6 | SCP0108_CAPA_LOB_Report.cs:1090 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a9a8254 | this.cboDivision.SelectedIndexChanged 외 6 | SCP0108_CAPA_LOB_Report.cs:1091 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshLineAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c13eb4b | this.Load | SCP0108_CAPA_LOB_Report.cs:934 |  | FLAG | dtLineAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-3594fdaf | this.Load | SCP0108_CAPA_LOB_Report.cs:934 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "L… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f364edb6 | this.Load | SCP0108_CAPA_LOB_Report.cs:938 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtLineAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshOperation

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a18b35b | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1096 |  | CALL_EXT | ScpCapaBL.GetFilterOperation | (_division_type, _division, _shop_group, _plant, _factory, _line) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d99b233b | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1098 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-e86bfd28 | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1098 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fc1a0acc | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1100 |  | FLAG | dtOperation | DBUtils.Sort(dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-d7817656 | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1100 |  | DATA_OP | DBUtils.Sort | (dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-8c27b18f | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1102 |  | FLAG | dtOperation | DBUtils.GetDistinctTable(dtOperation, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-a094cc4d | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1102 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtOperation, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfefb93f | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1104 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshOperationAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-862ad204 | this.Load | SCP0108_CAPA_LOB_Report.cs:945 |  | FLAG | dtOperationAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FA… | 화면 필드/플래그 변경 |  |  |  |
| AC-e3759d5e | this.Load | SCP0108_CAPA_LOB_Report.cs:945 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "O… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c08328b | this.Load | SCP0108_CAPA_LOB_Report.cs:949 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtOperationAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a08f5e9 | this.Load | SCP0108_CAPA_LOB_Report.cs:951 |  | FLAG | dtOperationAll | DBUtils.Sort(dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-3d101e0d | this.Load | SCP0108_CAPA_LOB_Report.cs:951 |  | DATA_OP | DBUtils.Sort | (dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshPlant

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61d339cc | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1066 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53ba1e03 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1068 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5bc6b507 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1068 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8221efd | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1070 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-498df416 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1070 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbe769df | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1071 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshPlantAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c772c825 | this.Load | SCP0108_CAPA_LOB_Report.cs:912 |  | FLAG | dtPlantAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-17d401bb | this.Load | SCP0108_CAPA_LOB_Report.cs:912 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "PLANT_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-acdf5fa2 | this.Load | SCP0108_CAPA_LOB_Report.cs:916 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtPlantAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshPlanType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eebc98a6 | this.Load 외 3 | SCP0108_CAPA_LOB_Report.cs:1015 |  | VALUE_SET | txtPlanType.Text | _plan_type | 컨트롤 값 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshProgressStatus

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a19a6f3f | this.Load 외 3 | SCP0108_CAPA_LOB_Report.cs:1031 |  | FLAG | dtProgressStatus | DBUtils.GetDistinctedCode(dtProgressStatusAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b50f95d | this.Load 외 3 | SCP0108_CAPA_LOB_Report.cs:1031 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtProgressStatusAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd9890d2 | this.Load 외 3 | SCP0108_CAPA_LOB_Report.cs:1033 |  | LIST_REBIND | clsCtrl.setListBox | (dtProgressStatus, cboProgressStatus, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0271f0ab | this.Load 외 3 | SCP0108_CAPA_LOB_Report.cs:1044 |  | CALL_EXT | UIUtils.GetIndexByCode | (cboProgressStatus, _currVersionProgressStatus) | ⚠ 의미 확인 필요 |  |  |  |
| AC-460eb52e | this.Load 외 3 | SCP0108_CAPA_LOB_Report.cs:1050 | if (cboProgressStatus.Items.Count > 0) | VALUE_SET | cboProgressStatus.SelectedIndex | cboProgressStatus.Items.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshSheetHeader

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-841233b0 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1213 |  | GRID_INIT | _si.SetSheetHeaderColumnSCP | (_si, 3, refreshAllColumn, _fixed_column_name) | 그리드 재구성/초기화 |  |  |  |
| AC-86608520 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0108_CAPA_LOB_Report.cs:1215 |  | CALL_EXT | SheetUtils.RefreshSpreadDateColumn | (_si , dsSpdTitle.Tables[0] // tblTitle , DateColumns.COLUMN_NAME // dataColumnName, 월 , D… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshSite

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54785ec9 | this.cboDivision.SelectedIndexChanged 외 3 | SCP0108_CAPA_LOB_Report.cs:1056 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-326cc86a | this.cboDivision.SelectedIndexChanged 외 3 | SCP0108_CAPA_LOB_Report.cs:1058 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7872ba4d | this.cboDivision.SelectedIndexChanged 외 3 | SCP0108_CAPA_LOB_Report.cs:1058 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2d4856c | this.cboDivision.SelectedIndexChanged 외 3 | SCP0108_CAPA_LOB_Report.cs:1060 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-d80c74f4 | this.cboDivision.SelectedIndexChanged 외 3 | SCP0108_CAPA_LOB_Report.cs:1060 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc59cc82 | this.cboDivision.SelectedIndexChanged 외 3 | SCP0108_CAPA_LOB_Report.cs:1061 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshSiteAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2e1d086 | this.Load | SCP0108_CAPA_LOB_Report.cs:901 |  | FLAG | dtSiteAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-d8930da2 | this.Load | SCP0108_CAPA_LOB_Report.cs:901 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4780c082 | this.Load | SCP0108_CAPA_LOB_Report.cs:905 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtSiteAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshVersion

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cd3e315 | this.Load 외 1 | SCP0108_CAPA_LOB_Report.cs:991 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID" }, new List<string>() { _division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d622cb2 | this.Load 외 1 | SCP0108_CAPA_LOB_Report.cs:996 |  | FLAG | dtVersion | DBUtils.GetDistinctedCode(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d27f567d | this.Load 외 1 | SCP0108_CAPA_LOB_Report.cs:996 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtVersionAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e6681d6 | this.Load 외 1 | SCP0108_CAPA_LOB_Report.cs:999 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.RefreshVersionSeq

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff2fb210 | this.Load 외 2 | SCP0108_CAPA_LOB_Report.cs:1004 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE" }, new List<string>() { _division, _version },… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d62b1be8 | this.Load 외 2 | SCP0108_CAPA_LOB_Report.cs:1006 |  | FLAG | dtVersionSeq | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b668109 | this.Load 외 2 | SCP0108_CAPA_LOB_Report.cs:1006 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8e189a65 | this.Load 외 2 | SCP0108_CAPA_LOB_Report.cs:1010 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionSeq, cboVersionSeq, false, "VER_SEQ", "VER_SEQ") | 목록 컨트롤 재구성 |  |  |  |

## SCP0108_CAPA_LOB_Report.SetQueryInfoGet

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd939a0c | FindButton | SCP0108_CAPA_LOB_Report.cs:1437 | if (this.QueryDics[DIC_GET_CAPA_LOB].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LOB].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-23e7b0f8 | FindButton | SCP0108_CAPA_LOB_Report.cs:1442 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-8039e001 | FindButton | SCP0108_CAPA_LOB_Report.cs:1443 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-4233cc03 | FindButton | SCP0108_CAPA_LOB_Report.cs:1444 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-96046eaa | FindButton | SCP0108_CAPA_LOB_Report.cs:1448 | if (_progress_status == ProgressStatusType._CURRENT) | UI_PROP | qi.QueryId | "SCP.SCP0108_GET_CAPA_LOB_CURRENT" | 속성 QueryId 설정 |  |  |  |
| AC-74b59e61 | FindButton | SCP0108_CAPA_LOB_Report.cs:1452 | else of (_progress_status == ProgressStatusType._CURRENT) | UI_PROP | qi.QueryId | "SCP.SCP0108_GET_CAPA_LOB" | 속성 QueryId 설정 |  |  |  |
| AC-b78cebde | FindButton | SCP0108_CAPA_LOB_Report.cs:1456 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2e08c9a | FindButton | SCP0108_CAPA_LOB_Report.cs:1457 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2be16342 | FindButton | SCP0108_CAPA_LOB_Report.cs:1458 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a93615d | FindButton | SCP0108_CAPA_LOB_Report.cs:1459 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a87cc1a | FindButton | SCP0108_CAPA_LOB_Report.cs:1460 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-864f51fc | FindButton | SCP0108_CAPA_LOB_Report.cs:1461 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0deb6a80 | FindButton | SCP0108_CAPA_LOB_Report.cs:1462 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d63d5be | FindButton | SCP0108_CAPA_LOB_Report.cs:1463 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46840c51 | FindButton | SCP0108_CAPA_LOB_Report.cs:1464 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4639990d | FindButton | SCP0108_CAPA_LOB_Report.cs:1465 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d82241c | FindButton | SCP0108_CAPA_LOB_Report.cs:1466 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_bottleneck_flag", this._bottleneck)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ae0d42b | FindButton | SCP0108_CAPA_LOB_Report.cs:1467 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0108")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d486e9a0 | FindButton | SCP0108_CAPA_LOB_Report.cs:1468 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-424d91e6 | FindButton | SCP0108_CAPA_LOB_Report.cs:1469 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d0f29cc | FindButton | SCP0108_CAPA_LOB_Report.cs:1470 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd400414 | FindButton | SCP0108_CAPA_LOB_Report.cs:1472 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LOB] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0108_CAPA_LOB_Report.SetSheetMerge

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / this.spdMain.TopChange / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5af5cc45 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0108_CAPA_LOB_Report.cs:1429 | if (!this.IsEditMode) | CALL_EXT | _si.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.SetVisibleElectrodeType

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-346e9b4a | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1337 | if (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.ELTR) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-07facc50 | this.cboDivision.SelectedIndexChanged 외 4 | SCP0108_CAPA_LOB_Report.cs:1341 | else of (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.ELTR) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.SetVisibleOperation

진입점: this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-348ae07c | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1325 | if (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c134133f | this.cboDivision.SelectedIndexChanged 외 7 | SCP0108_CAPA_LOB_Report.cs:1329 | else of (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0108_CAPA_LOB_Report.SetVisibleSheetColumns

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812bca30 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 5 | SCP0108_CAPA_LOB_Report.cs:1347 |  | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, this.IsEditMode, null) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0108_CAPA_LOB_Report.ShowItem

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3ecc61d | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1586 |  | POPUP | new SCM0002_CAPAItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-73ed1246 | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1588 |  | CALL_EXT | pop.Init | (true, dtDivision, _division, _shop_group, _item_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e97f23d3 | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1589 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-24f07eb4 | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1590 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-75e4e14f | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1592 |  | FLAG | selectedNicknames | pop.GetSelectedValues(DefColumns.NICK_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0c9e121 | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1592 |  | CALL_EXT | pop.GetSelectedValues | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de3deacc | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1594 |  | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-43e631ac | this.btnItemId.Click | SCP0108_CAPA_LOB_Report.cs:1600 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

