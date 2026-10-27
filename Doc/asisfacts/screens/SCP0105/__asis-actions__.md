# AS-IS 액션 대조표 — SCP0105

> 원천: `Doc/asisfacts/screens/SCP0105/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 410행 · 메서드 95 · 종류 DATA_OP 95 · CALL_EXT 89 · RETURN 68 · FLAG 45 · UI_PROP 17 · POPUP 16 · GRID_SET 16 · UI_MISC 13 · LIST_REBIND 12 · GRID_LOCK 10 · GRID_INIT 6 · MESSAGE 5 · VALUE_SET 5 · ENDPOINT 4 · VALIDATE 3 · GRID_STYLE 2 · GRID_BIND 1 · CALL_BASE 1 · STATE_RESET 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 90


## SCP0105_CAPA_Speed_Plan._defaultDataModel_Changed

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87093963 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3088 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc1e758c | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3091 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8ac1141 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3094 | if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfa5f92f | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3097 | if (_si.IsLock(_si.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90a4f639 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3101 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8be09e7 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3104 |  | CALL_EXT | _si.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aeb987f | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3105 | if (_si.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e90888aa | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2059 |  | GRID_BIND | _si.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-14c91d7e | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2075 |  | FLAG | _tblBeforeChanged | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ad53da49 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2075 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75dae4c9 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2076 |  | FLAG | _tblAfterChanged | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-253fdeb1 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2076 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ef59aa1 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2080 | if (_progress_status == ProgressStatusType._CURRENT) | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9318e1f5 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2080 | if (_progress_status == ProgressStatusType._CURRENT) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6a932136 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2084 | else of (_progress_status == ProgressStatusType._CURRENT) | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-34425fb6 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2084 | else of (_progress_status == ProgressStatusType._CURRENT) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b7e1da4 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2088 | if (_tblAfterChanged.Rows.Count > 0) | CALL_EXT | _tblAfterChanged.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-65b86a42 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2090 |  | GRID_LOCK | _si.LockColumn | (0, _si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3bf7ce02 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2095 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a4038355 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2099 | if (this.IsEditMode) | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.AfterSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d5a6bb8 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2160 |  | CALL_BASE | this._CloseProgress | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-02e9579b | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2165 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38fcac70 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2169 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (this.IsEditMode) | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-969caba5 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2212 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (dbErrNo == "50426") | MESSAGE | MessageHelper.GMessageBox | ("MSG00426", new object[] { string.Format("\n\r\n\r{0}", msg) }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7574a649 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2221 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (dbErrNo == "50426") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0105_CAPA_Speed_Plan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e05723b4 | this.btnColumn.Click | SCP0105_CAPA_Speed_Plan.cs:3168 |  | POPUP | new SCM002_CAPAColumnPopup | ("SCP0105", this._division_type_name, true) | 팝업/폼 생성 |  |  |  |
| AC-fdb4263a | this.btnColumn.Click | SCP0105_CAPA_Speed_Plan.cs:3169 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-09455fc5 | this.btnColumn.Click | SCP0105_CAPA_Speed_Plan.cs:3171 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0105_CAPA_Speed_Plan.btnItem_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fc315a0 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3162 | if (nicknames != "") | VALUE_SET | txtItem.Text | nicknames | 컨트롤 값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.ChangeColumnNameToCodeName

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff342dc9 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:894 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfbabc31 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:896 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-53033a06 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:899 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-c52cca72 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:901 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.CheckChangedValues

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-150f1ed2 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:1867 | else of (_si.ActiveSheet.RowCount != _tblBeforeChanged.Rows.Count) ▸ for (r <= _si.ActiveSheet.RowCount - 1) ▸ for (c <= _si.ActiveSheet.Col… | DATA_OP | _tblBeforeChanged.Columns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-f82cde13 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:1880 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.CheckEltrEquipmentType

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d09f9c76 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:2949 | if (_division_type != DivisionType.ELTR) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-497ebbe7 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:2955 | if (colName != DefColumns.ELTR_LN_TP_CD) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2be5f49e | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3014 | if ((DIVISION_ID == "") \|\| (COMPANY_ID == "") \|\| (SITE_ID == "") \|\| (PLANT_ID == "") \|\| (FACTORY_ID == "") \|\| (LINE_ID == ""…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22319240 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3075 | for (r <= _si.GetMaxRowIndex()) ▸ if ((currDIVISION_ID == DIVISION_ID) && (currCOMPANY_ID == COMPANY_ID) && (currSITE_ID == SITE_ID) && (cur… | GRID_SET | _si.SetText | (r, colIdx, ELTR_LN_TP_CD) | 그리드 값 설정 |  |  |  |
| AC-8f65d4c8 | _defaultDataModel.Changed | SCP0105_CAPA_Speed_Plan.cs:3079 | for (r <= _si.GetMaxRowIndex()) ▸ if ((currDIVISION_ID == DIVISION_ID) && (currCOMPANY_ID == COMPANY_ID) && (currSITE_ID == SITE_ID) && (cur… | GRID_SET | _si.SetValue | (r, 0, "M") | 그리드 값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0600ca09 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1256 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5883cae1 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1257 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a140fd8 | this.Load | SCP0105_CAPA_Speed_Plan.cs:1302 |  | GRID_INIT | this.AddSheet | (spdMain, SHEETS.ASSEMBLY, SHEETS.ASSEMBLY, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-afecb946 | this.Load | SCP0105_CAPA_Speed_Plan.cs:1303 |  | GRID_INIT | this.AddSheet | (spdMain, SHEETS.ELTR, SHEETS.ELTR, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0105_CAPA_Speed_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2b309f1 | DeleteButton | SCP0105_CAPA_Speed_Plan.cs:1824 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d47bc059 | DeleteButton | SCP0105_CAPA_Speed_Plan.cs:1827 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03e6de71 | DeleteButton | SCP0105_CAPA_Speed_Plan.cs:1830 | if (_si.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab9850c9 | DeleteButton | SCP0105_CAPA_Speed_Plan.cs:1837 | if (action == CAppSetting.FlagI) | DATA_OP | _si.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0105_CAPA_Speed_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecbc026a | Dispose | SCP0105_CAPA_Speed_Plan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0105_CAPA_Speed_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4959335 | EditButton | SCP0105_CAPA_Speed_Plan.cs:1781 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da70bdf7 | EditButton | SCP0105_CAPA_Speed_Plan.cs:1784 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2df8bedf | EditButton | SCP0105_CAPA_Speed_Plan.cs:1787 | if (_si.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca7ab3d2 | EditButton | SCP0105_CAPA_Speed_Plan.cs:1791 | if (this._currVersionProgressStatus == ProgressStatusType._PRE \|\| this._currVersionProgressStatus == ProgressStatusType._1ST…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2706fb94 | EditButton | SCP0105_CAPA_Speed_Plan.cs:1793 | if (this._currVersionProgressStatus == ProgressStatusType._PRE \|\| this._currVersionProgressStatus == ProgressStatusType._1ST…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-622e2c85 | EditButton | SCP0105_CAPA_Speed_Plan.cs:1807 |  | GRID_LOCK | _si.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75664d2f | FindButton | SCP0105_CAPA_Speed_Plan.cs:1457 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8cf41398 | FindButton | SCP0105_CAPA_Speed_Plan.cs:1458 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22b913a3 | FindButton | SCP0105_CAPA_Speed_Plan.cs:2359 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GET_CAPA_SPEED_PLAN, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0105_CAPA_Speed_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d8a78db | this.Load | SCP0105_CAPA_Speed_Plan.cs:1002 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddd5f122 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:602 | try | CALL_EXT | _curr_row.Columns | (DefColumns.COMPANY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c02c8a58 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:608 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e574c71e | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:626 | try | CALL_EXT | _curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27493f65 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:632 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2c27e75 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:770 | try | CALL_EXT | _curr_row.Columns | (DefColumns.ELTR_LN_TP_CD) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34504b2b | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:776 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32ebd764 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:698 | try | CALL_EXT | _curr_row.Columns | (DefColumns.FACTORY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-341c5b88 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:704 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f81d34df | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:794 | try | CALL_EXT | _curr_row.Columns | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a8ca976 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:800 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c2c28df | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:722 | try | CALL_EXT | _curr_row.Columns | (DefColumns.LINE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-294157dc | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:728 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb2ce439 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:842 | try | CALL_EXT | _curr_row.Columns | (DefColumns.MSR_TP_CD) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79589015 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:848 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb5a5720 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:818 | try | CALL_EXT | _curr_row.Columns | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17a90524 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:824 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e6746b2 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:746 | try | CALL_EXT | _curr_row.Columns | (DefColumns.OPERATION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-314e24b8 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:752 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f125ad2 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:650 | try | CALL_EXT | _curr_row.Columns | (DefColumns.PLANT_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-902398f1 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:656 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getCurrSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-622ecba7 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:674 | try | CALL_EXT | _curr_row.Columns | (DefColumns.SITE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b13b483e | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:680 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.GetCurrVersionProgessStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7309b179 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1055 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE", "VER_SEQ" }, new List<string>() { _division, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-5aecf71b | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1057 | try | FLAG | dtProgressStatusCurr | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-13286100 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1057 | try | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ccdb5029 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1068 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a79f07e | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:225 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtDivision, cboDivision.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-538249c4 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:231 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getDivisionType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74f33e9c | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:206 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae5d6ca | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:519 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtElectrode, clbElectrodeType.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a46190c6 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:525 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.GetExistsDifferentEquipmentType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1523a364 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1930 | try | CALL_EXT | DBUtils.GetDistinctTable | (_tblBeforeChanged, DefColumns.DIVISION_ID, DefColumns.SITE_ID, DefColumns.COMPANY_ID, Def… | ⚠ 의미 확인 필요 |  |  |  |
| AC-54ecaabe | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1952 | try | CALL_EXT | DBUtils.GetDistinctTable | (tblRawTemp, DefColumns.DIVISION_ID , DefColumns.SITE_ID , DefColumns.COMPANY_ID , DefColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-29f366c2 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1961 | try | CALL_EXT | DBUtils.GetDistinctTable | (tblRaw, DefColumns.DIVISION_ID , DefColumns.SITE_ID , DefColumns.COMPANY_ID , DefColumns.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-91dc2c0b | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1976 | try ▸ if (tblLine.Rows.Count < tblRaw.Rows.Count) ▸ foreach (DataRow row in tblLine.Rows) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefColumns.DIVISION_ID, DefColumns.SITE_ID , DefColumns.COMPANY_ID ,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-89c75c7b | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1989 | try ▸ if (tblLine.Rows.Count < tblRaw.Rows.Count) ▸ foreach (DataRow row in tblLine.Rows) | DATA_OP | DBUtils.Filter | (tblRaw, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-93e5a0bc | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1995 | try ▸ if (tblLine.Rows.Count < tblRaw.Rows.Count) ▸ foreach (DataRow row in tblLine.Rows) ▸ if (tbl.Rows.Count >= 2) | DATA_OP | res.Add | (tbl.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-945f5189 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2004 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb49bb70 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:423 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtFactory, clbFactory.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbac2195 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:429 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f90af7cf | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:501 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5c5b426 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:447 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtLine, clbLine.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5acd71c | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:453 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa3710e | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:471 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtOperation, clbOperation.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6331ec0a | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:477 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-379836ac | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:399 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtPlant, clbPlant.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f858bf1 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:405 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d147c0e | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:319 |  | CALL_EXT | ScpCapaBL.GetPlanType | (dtVersionAll, _division, _version, _version_seq) | ⚠ 의미 확인 필요 |  |  |  |
| AC-917f1b50 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:319 |  | RETURN | return ScpCapaBL.GetPlanType(dtVersionAll, _division, _version, _version_seq); |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.GetPPMRowIndex

진입점: _defaultDataModel.Changed / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94f0a02e | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2627 |  | RETURN | return GetQtyRowIndex(currRowIdx, qtyColIdx, currMeasure) + 2; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getProgressStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31cfacf4 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:343 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.GetQtyRowIndex

진입점: _defaultDataModel.Changed / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adebf4be | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2617 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45a38410 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:381 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b544b0d | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:381 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41fafed4 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:361 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtSite, clbSite.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3dee4ab | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:367 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1ea4bbf | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1316 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_GET_SPREAD_TITLE") ⇒ SCP.SCP0104_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-35f0821f | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1318 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | this._from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-fce98cbb | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1319 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0105" | 행/컬럼 값 대입 |  |  |  |
| AC-e35a0fb3 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1320 |  | DATA_OP | request.Parameters["p_sheet_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-842dbcdc | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1322 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-fbd8eda9 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1322 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-540d071a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1326 |  | FLAG | this._sheetDateColumns | DBUtils.GetStringColumnValues(dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1f9aada | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1326 |  | CALL_EXT | DBUtils.GetStringColumnValues | (dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c647178 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1327 |  | FLAG | this._sheetDateColumns | this._sheetDateColumns.Where(w => !w.Contains("_ASSIGN_PRIORITY")).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-baf42670 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1327 | lambda | DATA_OP | w.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-7adde30a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1329 |  | FLAG | this._sheetNumericColumns | new List<string>() { DefColumns.PFRSLT_QTY, DefColumns.BASE_QTY } | 화면 필드/플래그 변경 |  |  |  |
| AC-cfdc381b | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1333 | foreach (string dateCol in _sheetDateColumns) | DATA_OP | this._sheetNumericColumns.Add | (dateCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex

진입점: _defaultDataModel.Changed / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93cdb509 | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2622 |  | RETURN | return GetQtyRowIndex(currRowIdx, qtyColIdx, currMeasure) + 1; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc9276be | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:280 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.getVersionSeq

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6989cb5c | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:305 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce88ca80 | this.Load | SCP0105_CAPA_Speed_Plan.cs:1236 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a558c4b | this.Load | SCP0105_CAPA_Speed_Plan.cs:1239 |  | DATA_OP | ReadOnlySheetList.Add | (SHEETS.ASSEMBLY) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4f874e5 | this.Load | SCP0105_CAPA_Speed_Plan.cs:1242 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.InitDatasAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49c9186a | this.Load | SCP0105_CAPA_Speed_Plan.cs:881 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b795b4b | this.Load | SCP0105_CAPA_Speed_Plan.cs:881 |  | CALL_EXT | ScpCapaBL.GetCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-786bcef7 | this.Load | SCP0105_CAPA_Speed_Plan.cs:875 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_SPEED_PLAN, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5adf3cd | this.Load | SCP0105_CAPA_Speed_Plan.cs:876 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_SPEED_PLAN, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0105_CAPA_Speed_Plan.InitSpread

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae4c03ce | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1339 |  | UI_PROP | spdMain.TabStripPolicy | TabStripPolicy.Never | 속성 TabStripPolicy 설정 |  |  |  |
| AC-afca9e62 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1343 | for (i <= spdMain.Sheets.Count - 1) | GRID_SET | spdMain.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-b8cfbc4a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1346 |  | FLAG | _si | GetSheetInfo(spdMain.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-3bf0c22b | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1348 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3413005a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1350 |  | GRID_INIT | _si.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-0ea686a3 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1352 |  | GRID_INIT | _si.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.Insert_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec4928c8 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2369 |  | DATA_OP | _si.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d17ea472 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2374 |  | DATA_OP | dic.Add | (DefColumns.DIVISION_ID, _division) | 데이터 객체 조작/조회 |  |  |  |
| AC-4474cf4d | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2380 | if (item != "") ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | DATA_OP | dic.Add | (DefColumns.NICK_NAME, item) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff8f8825 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2384 | if (item != "") ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | DATA_OP | dic.Add | (DefColumns.ITEM_ID, item) | 데이터 객체 조작/조회 |  |  |  |
| AC-36e6b88f | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2388 |  | GRID_SET | _si.SetValue | (newCell, dic) | 그리드 값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.IsDummy

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e289587 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2650 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.IsExistsDifferentEquipmentType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08c07fda | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:1917 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.IsModelDummy

진입점: _defaultDataModel.Changed [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25422c47 | _defaultDataModel.Changed [try] 외 1 | SCP0105_CAPA_Speed_Plan.cs:2673 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RecalcSheet

진입점: _defaultDataModel.Changed / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff3baf30 | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2679 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad9dddc1 | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2690 | if (speedRowIdx > _si.GetMaxRowIndex()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c05c2a64 | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2693 | if (ppmRowIdx > _si.GetMaxRowIndex()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-debbddce | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2871 | try ▸ else of (IsModelDummy(qtyRowIdx) && ((speedMeasure == "MMS") \|\| (speedMeasure == "CPM"))) | GRID_SET | _si.SetValue | (ppmRowIdx, qtyColIdx, ppm) | 그리드 값 설정 |  |  |  |
| AC-66236502 | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2873 | try ▸ else of (IsModelDummy(qtyRowIdx) && ((speedMeasure == "MMS") \|\| (speedMeasure == "CPM"))) | GRID_SET | _si.SetValue | (ppmRowIdx, 0, "M") | 그리드 값 설정 |  |  |  |
| AC-9df7ca2b | _defaultDataModel.Changed 외 1 | SCP0105_CAPA_Speed_Plan.cs:2914 | if (columnName == DefColumns.BASE_QTY \|\| columnName.Substring(0, 2) == "M_" \|\| columnName.Substring(0, 2) == "Y_") ▸ if (_division_type … | CALL_EXT | _si.IsLockCell | (ppmRowIdx, colIdx) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshAllPre

진입점: this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aaede3b | this.rgrpDivisionType.SelectedIndexChanged | SCP0105_CAPA_Speed_Plan.cs:1263 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb2cbe9c | this.rgrpDivisionType.SelectedIndexChanged | SCP0105_CAPA_Speed_Plan.cs:1263 |  | CALL_EXT | ScpCapaBL.GetCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshColumnsVisible

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-544d26c4 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1388 | for (c <= _si.GetMaxColumnIndex()) | DATA_OP | colName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1f17fe0 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1390 | for (c <= _si.GetMaxColumnIndex()) ▸ if (colName.Contains("_ASSIGN_PRIORITY")) | GRID_STYLE | _si.setColumnWidth | (c, 0) | 그리드 표시 설정 |  |  |  |
| AC-c3e01719 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1392 | for (c <= _si.GetMaxColumnIndex()) ▸ if (colName.Contains("_ASSIGN_PRIORITY")) | GRID_SET | _si.ActiveSheet.Columns[c].Resizable | false | 그리드 속성/값 설정 |  |  |  |
| AC-0d0cd49a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1396 |  | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, this.IsEditMode, null) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd654735 | this.Load | SCP0105_CAPA_Speed_Plan.cs:1020 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshElectrodeAssemblyAll

진입점: this.Load [if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / this.rgrpDivisionType.SelectedIndexChanged [if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6f39c47 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0105_CAPA_Speed_Plan.cs:978 |  | FLAG | dtElectrodeAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD",… | 화면 필드/플래그 변경 |  |  |  |
| AC-cd3d4332 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0105_CAPA_Speed_Plan.cs:978 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD", "ELTR_LN_TP_NM", "DISPL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e3626d4 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0105_CAPA_Speed_Plan.cs:982 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtElectrodeAll, "CODE", "NAME", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2518b848 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0105_CAPA_Speed_Plan.cs:984 |  | FLAG | dtElectrodeAll | DBUtils.Sort(dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-170e8260 | this.Load [if (_division_type == DivisionType.CELL \|\| _div… 외 1 | SCP0105_CAPA_Speed_Plan.cs:984 |  | DATA_OP | DBUtils.Sort | (dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshElectrodeeEltrAll

진입점: this.Load [else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / this.rgrpDivisionType.SelectedIndexChanged [else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff219284 | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0105_CAPA_Speed_Plan.cs:989 |  | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.OperationElectrodeType, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-652a906b | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0105_CAPA_Speed_Plan.cs:993 |  | CALL_EXT | ScpCapaBL.GetElectrodeOperationFilter | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5e31ceb | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0105_CAPA_Speed_Plan.cs:995 |  | FLAG | dtElectrodeAll | DBUtils.Filter(tbl, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-50201ad5 | this.Load [else of (_division_type == DivisionType.CELL \|\|… 외 1 | SCP0105_CAPA_Speed_Plan.cs:995 |  | DATA_OP | DBUtils.Filter | (tbl, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshElectrodeType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e4705fc | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1218 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _division, _operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ff71098 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1220 |  | FLAG | dtElectrode | DBUtils.Filter(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd3cadc6 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1220 |  | DATA_OP | DBUtils.Filter | (dtElectrodeAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d9652480 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1222 |  | FLAG | dtElectrode | DBUtils.Sort(dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-e728f3ea | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1222 |  | DATA_OP | DBUtils.Sort | (dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-066efdb0 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1224 |  | FLAG | dtElectrode | DBUtils.GetDistinctTable(dtElectrode, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-7f99661e | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1224 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtElectrode, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-08338632 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1226 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrodeType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshElectrodeTypeSpread

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2da1f945 | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1446 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _curr_division, _curr_operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c79a906 | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1448 |  | FLAG | dtElectrodeSpread | DBUtils.GetDistinctedCode(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6e87e4f | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1448 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtElectrodeAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshFactory

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fba11c41 | this.Load 외 7 | SCP0105_CAPA_Speed_Plan.cs:1131 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17a041ed | this.Load 외 7 | SCP0105_CAPA_Speed_Plan.cs:1133 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6b913cb | this.Load 외 7 | SCP0105_CAPA_Speed_Plan.cs:1133 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f0a969d | this.Load 외 7 | SCP0105_CAPA_Speed_Plan.cs:1135 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-71cc4622 | this.Load 외 7 | SCP0105_CAPA_Speed_Plan.cs:1135 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a80a47bc | this.Load 외 7 | SCP0105_CAPA_Speed_Plan.cs:1136 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshFactoryAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8be67993 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:929 |  | FLAG | dtFactoryAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-5e982b56 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:929 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "F… | ⚠ 의미 확인 필요 |  |  |  |
| AC-852dbdfb | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:933 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtFactoryAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshLine

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68aeee18 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1141 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3517dc40 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1143 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-004b138d | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1143 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca151ef5 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1145 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-08f9778e | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1145 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2139c3c9 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1155 |  | DATA_OP | dtLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0954ddf4 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1156 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6a830f0 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1157 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ2", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d905a5e | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1164 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select("CODE LIKE '%" + _rowstr + "%'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7b1fa5a7 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1164 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select | ("CODE LIKE '%" + _rowstr + "%'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf3edcd0 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1177 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-9b104fc6 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1178 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ2"] | "2" | 그리드 속성/값 설정 |  |  |  |
| AC-e39b5910 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1182 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-3302cdff | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1183 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-89815295 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1189 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-dc99f71c | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1190 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-6580e02e | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1196 |  | DATA_OP | _dt.Select("", "SEQ1,SEQ2 ASC").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e6275c4 | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1196 |  | DATA_OP | _dt.Select | ("", "SEQ1,SEQ2 ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b1ddc8c | this.Load 외 8 | SCP0105_CAPA_Speed_Plan.cs:1198 |  | LIST_REBIND | clsCtrl.setListBox | (resultDt, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshLineAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4c3a088 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:940 |  | FLAG | dtLineAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-a5add5cf | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:940 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "L… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ba6861f | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:944 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtLineAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshOperation

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f503d9d | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1203 |  | CALL_EXT | ScpCapaBL.GetFilterOperation | (_division_type, _division, _shop_group, _plant, _factory, _line) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e269f677 | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1205 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-b20973ab | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1205 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-91619721 | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1207 |  | FLAG | dtOperation | DBUtils.Sort(dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-1e1429e5 | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1207 |  | DATA_OP | DBUtils.Sort | (dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-75c7e5a5 | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1209 |  | FLAG | dtOperation | DBUtils.GetDistinctTable(dtOperation, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-bb6211da | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1209 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtOperation, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b528a34d | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:1211 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshOperationAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81718be0 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:951 |  | FLAG | dtOperationAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FA… | 화면 필드/플래그 변경 |  |  |  |
| AC-020aa874 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:951 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "O… | ⚠ 의미 확인 필요 |  |  |  |
| AC-24e5f838 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:955 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtOperationAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f86d810 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:957 |  | CALL_EXT | ScpCapaBL.GetCodeFilterExceptFormation | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-533d835f | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:959 |  | FLAG | dtOperationAll | DBUtils.Filter(dtOperationAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-47262a09 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:959 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-60c8deb8 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:961 |  | FLAG | dtOperationAll | DBUtils.Sort(dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-966d3a09 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:961 |  | DATA_OP | DBUtils.Sort | (dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshPlant

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-968861d3 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1121 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8d1cb30 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1123 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f43df36b | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1123 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31d3f106 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1125 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1d7e98c | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1125 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6404b394 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:1126 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshPlantAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-211d2c2c | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:918 |  | FLAG | dtPlantAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-76a3258a | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:918 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "PLANT_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fdb0924 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:922 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtPlantAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshPlanType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23e291df | this.Load 외 3 | SCP0105_CAPA_Speed_Plan.cs:1046 |  | VALUE_SET | txtPlanType.Text | _plan_type | 컨트롤 값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshProgressStatus

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a308f86a | this.Load 외 3 | SCP0105_CAPA_Speed_Plan.cs:1086 |  | FLAG | dtProgressStatus | DBUtils.GetDistinctedCode(dtProgressStatusAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8daf79c4 | this.Load 외 3 | SCP0105_CAPA_Speed_Plan.cs:1086 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtProgressStatusAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d3a7e89 | this.Load 외 3 | SCP0105_CAPA_Speed_Plan.cs:1088 |  | LIST_REBIND | clsCtrl.setListBox | (dtProgressStatus, cboProgressStatus, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1bb48704 | this.Load 외 3 | SCP0105_CAPA_Speed_Plan.cs:1099 |  | CALL_EXT | UIUtils.GetIndexByCode | (cboProgressStatus, _currVersionProgressStatus) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb3840c0 | this.Load 외 3 | SCP0105_CAPA_Speed_Plan.cs:1105 | if (cboProgressStatus.Items.Count > 0) | VALUE_SET | cboProgressStatus.SelectedIndex | statusIdx | 컨트롤 값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshSheetHeader

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cd1ef56 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1359 |  | GRID_INIT | _si.SetSheetHeaderColumnSCP | (_si, 3, refreshAllColumn, _fixed_column_name) | 그리드 재구성/초기화 |  |  |  |
| AC-ac87d543 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:1361 |  | CALL_EXT | SheetUtils.RefreshSpreadDateColumn | (_si , dsSpdTitle.Tables[0] // tblTitle , DateColumns.COLUMN_NAME // dataColumnName, 월 , D… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshSite

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29ecc45f | this.Load 외 5 | SCP0105_CAPA_Speed_Plan.cs:1111 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9327e08f | this.Load 외 5 | SCP0105_CAPA_Speed_Plan.cs:1113 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-275e003b | this.Load 외 5 | SCP0105_CAPA_Speed_Plan.cs:1113 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93742582 | this.Load 외 5 | SCP0105_CAPA_Speed_Plan.cs:1115 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3651997 | this.Load 외 5 | SCP0105_CAPA_Speed_Plan.cs:1115 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-045535db | this.Load 외 5 | SCP0105_CAPA_Speed_Plan.cs:1116 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshSiteAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc583726 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:907 |  | FLAG | dtSiteAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-2396b812 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:907 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-27c8687a | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:911 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtSiteAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshVersion

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-016f477a | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:1025 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID" }, new List<string>() { _division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea00f694 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:1027 |  | FLAG | dtVersion | DBUtils.GetDistinctedCode(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3e2ac763 | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:1027 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtVersionAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ccebd8d | this.Load 외 1 | SCP0105_CAPA_Speed_Plan.cs:1030 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.RefreshVersionSeq

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3a2d37a | this.Load 외 2 | SCP0105_CAPA_Speed_Plan.cs:1035 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE" }, new List<string>() { _division, _version },… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f56721da | this.Load 외 2 | SCP0105_CAPA_Speed_Plan.cs:1037 |  | FLAG | dtVersionSeq | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0836db04 | this.Load 외 2 | SCP0105_CAPA_Speed_Plan.cs:1037 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ad57080a | this.Load 외 2 | SCP0105_CAPA_Speed_Plan.cs:1041 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionSeq, cboVersionSeq, false, "VER_SEQ", "VER_SEQ") | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dbb0422 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2010 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-572719e4 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2014 | if (_si == null \|\| _si.IsLock(_si.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0e2684c | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2017 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69cd3f2e | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2020 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (_si) | 프레임워크 검증 |  |  |  |
| AC-c3c2d02c | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2021 | if (!DataUtil.checkRequiredOfSpread(_si)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b68fe8e | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2407 | if (!CheckChangedValues(ref changedCnt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4eb7d97 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2411 | if (changedCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ca8b4bb | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2413 | if (changedCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SaveDataMain

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57d4f58b | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2397 |  | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { _si, _si } , new List<string>() { DIC_SAVE_CAPA_SPEED_PLAN, DIC_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0105_CAPA_Speed_Plan.Set_MeasureColor

진입점: EditButton [if (!this.IsEditMode)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cee8858 | EditButton [if (!this.IsEditMode)] 외 1 | SCP0105_CAPA_Speed_Plan.cs:2117 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a776875e | EditButton [if (!this.IsEditMode)] 외 1 | SCP0105_CAPA_Speed_Plan.cs:2120 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-034fea82 | EditButton [if (!this.IsEditMode)] 외 1 | SCP0105_CAPA_Speed_Plan.cs:2133 | try ▸ for (rowIdx <= rowCnt-1) | DATA_OP | (new List<string>() { "MMS", "PPM_AVG", "TTT", "CPM"}).Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a875dd6 | EditButton [if (!this.IsEditMode)] 외 1 | SCP0105_CAPA_Speed_Plan.cs:2138 | try ▸ for (rowIdx <= rowCnt-1) | GRID_STYLE | _si.SetBGColor | (rowIdx, measureNameColIdx, rowIdx, colCnt - 1, color) | 그리드 표시 설정 |  |  |  |
| AC-13f16c3c | EditButton [if (!this.IsEditMode)] 외 1 | SCP0105_CAPA_Speed_Plan.cs:2143 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetBaseToDateColumns

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bbf1677 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2558 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e51bd88b | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2590 | for (i <= dateEndColIdx) | GRID_SET | _si.SetValue | (qtyRowIdx, i, base_qty) | 그리드 값 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetLockColumnsASSEMBLY

진입점: EditButton [if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b14f96d | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1483 | if (this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b443a5dc | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1487 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-afbdec83 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1509 | try ▸ if (this.IsEditMode) | GRID_LOCK | _si.LockRange2 | (0, 0, rowCnt - 1, _fixed_column_idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-a2853c7d | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1543 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | DATA_OP | colName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-4965632b | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1547 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | CALL_EXT | SheetUtils.IsCurrPriorityNone | (_si, rowIdx, colIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93965020 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1551 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIdx, colIdx, isCellLocked) | 그리드 편집 잠금/해제 |  |  |  |
| AC-44511d47 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1560 | try ▸ else of (this.IsEditMode) | GRID_LOCK | SheetUtils.SetLockAllRows | (_si, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c1c8cea | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1567 | finally ▸ if (!this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89068d66 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… | SCP0105_CAPA_Speed_Plan.cs:1570 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetLockColumnsELTR

진입점: EditButton [else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fbf1632 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1578 | if (this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0abef72d | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1582 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-43bc0fc4 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1605 | try ▸ if (this.IsEditMode) | GRID_LOCK | _si.LockRange2 | (0, 0, rowCnt - 1, _fixed_column_idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-699664a9 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1633 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (isEquipmentTypeEmpty \|\| isEquipmentIdEmpty \|\| isUiUpdYn) | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIdx, electrodeTypeColIdx, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d3c4d19 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1637 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ else of (isEquipmentTypeEmpty \|\| isEquipmentIdEmpty \|\| isUiUpdYn) | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIdx, electrodeTypeColIdx, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-18c23547 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1663 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | DATA_OP | colName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-19527622 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1667 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | CALL_EXT | SheetUtils.IsCurrPriorityNone | (_si, rowIdx, colIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f3e0ebb | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1672 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIdx, colIdx, isCellLocked) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb21460f | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1681 | try ▸ else of (this.IsEditMode) | GRID_LOCK | SheetUtils.SetLockAllRows | (_si, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a2b1002 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1683 | try ▸ else of (this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd5e3e78 | EditButton [else of (_division_type == DivisionType.CELL \|\… | SCP0105_CAPA_Speed_Plan.cs:1690 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetQueryInfoGet

진입점: FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f7e2987 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2230 | if (this.QueryDics[DIC_GET_CAPA_SPEED_PLAN].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_SPEED_PLAN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dad29ee8 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2235 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-d82ae157 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2236 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-8b6f32d0 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2237 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-b4333374 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2238 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0105_GET_CAPA_SPEED_PLAN_{0}", _sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-4b88f361 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2240 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75a94c65 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2241 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8951e753 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2242 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", this._progress_status)) | 데이터 객체 조작/조회 |  |  |  |
| AC-80776025 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2243 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6787bdc | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2244 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8640f945 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2245 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd6339dd | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2246 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd71af84 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2247 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-71de516b | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2248 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c80ca6c | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2249 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-995ed313 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2250 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a46ab67 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2251 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0105")) | 데이터 객체 조작/조회 |  |  |  |
| AC-56ecbd09 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2252 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._division_type_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9befef1 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2253 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a15eafc8 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2254 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-525cd043 | FindButton 외 1 | SCP0105_CAPA_Speed_Plan.cs:2257 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_SPEED_PLAN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetQueryInfoSave

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a304c8 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2265 | if (this.QueryDics[DIC_SAVE_CAPA_SPEED_PLAN].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_SPEED_PLAN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa07dbea | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2270 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-58f405a6 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2271 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-380572fe | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2272 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-15fee6ce | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2273 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0105_SAVE_CAPA_SPEED_PLAN_{0}", _division_type_name) | 속성 QueryId 설정 |  |  |  |
| AC-dbcfa6ac | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2276 |  | CALL_EXT | SheetUtils.GetChangedData | (_si, _tblOriginal) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ec90976 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2316 | foreach (DataRow r in tbl.Rows) ▸ foreach (DataColumn c in tbl.Columns) | DATA_OP | columnName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-32d1e915 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2327 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f1634a | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2328 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bb96716 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2329 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", this._progress_status)) | 데이터 객체 조작/조회 |  |  |  |
| AC-366984f7 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2330 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c4d2f47 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2331 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_id", COMPANY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-04c6bff6 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2332 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", SITE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a649feac | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2333 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", PLANT_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88528423 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2334 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", FACTORY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c339492 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2335 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", LINE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08dca807 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2336 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", OPERATION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a82f882 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2337 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", ELTR_LN_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6faacabf | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2338 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", ITEM_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f1c781e | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2339 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", NICK_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a89d0fd | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2340 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_capa_speed_measure", MSR_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f84eba5 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2341 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_base_qty", BASE_QTY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6be54a8d | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2342 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_ui_upd_yn", UI_UPD_YN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37d44f6d | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2343 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_names", DATE_COLUMN_NAMES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-304c6af1 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2344 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_values", DATE_COLUMN_VALUES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a25c1cf | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2345 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0105")) | 데이터 객체 조작/조회 |  |  |  |
| AC-89750a83 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2346 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._division_type_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a1b6282 | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2347 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8a3f50f | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2348 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc0e027f | SaveButton | SCP0105_CAPA_Speed_Plan.cs:2351 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_SPEED_PLAN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetSheetMerge

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0814821a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:2151 | if (!this.IsEditMode) | CALL_EXT | _si.ToggleMerge | (spdMain.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe6de6f8 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0105_CAPA_Speed_Plan.cs:2152 | if (!this.IsEditMode) | GRID_INIT | _si.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnFormatASSEMBLY

진입점: EditButton [if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ee6c44 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1709 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0d0b10c6 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1717 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("EQP_NBU", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-21d6ccee | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1717 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-b060be87 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1718 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("MMS", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-532ebc2b | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1718 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-9881f77d | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1719 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("TTT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37a13ebb | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1719 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-295d0502 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1720 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("CPM", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-902eb530 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1720 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-f324799c | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1721 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PPM", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f39ac65 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1721 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-2dac8c56 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1727 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("EQP_NBU", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-892828b3 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1727 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-aa179144 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1728 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("MMS", new CellFormatConditionType(0, 0)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37a8818a | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1728 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (0, 0) | 팝업/폼 생성 |  |  |  |
| AC-4d2779fd | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1729 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("TTT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ef3ac2c | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1729 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-d23b25b6 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1730 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("CPM", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-42345126 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1730 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-a19ace91 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1731 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PPM", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fed0547e | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1731 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-f6134521 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1735 | try | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_si, _sheetNumericColumns, DefColumns.MSR_TP_CD, dic, this.IsEditMode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-040ac917 | EditButton [if (_division_type == DivisionType.CELL \|\| _di… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1740 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnFormatELTR

진입점: EditButton [else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56c1abc7 | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1746 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2ff12454 | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1756 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("EQP_QTY", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a4521d9 | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1756 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-d2218117 | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1764 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("EQP_QTY", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdb69280 | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1764 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-6be6bfaf | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1770 | try | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_si, _sheetNumericColumns, DefColumns.MSR_TP_CD, dic, this.IsEditMode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65d57275 | EditButton [else of (_division_type == DivisionType.CELL \|\… 외 1 | SCP0105_CAPA_Speed_Plan.cs:1774 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetVisibleElectrodeType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddb8064b | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:2478 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | VALUE_SET | this.lciItem.Text | ItemNames.NICK_NAME | 컨트롤 값 설정 |  |  |  |
| AC-c89e4d01 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:2481 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6367189c | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:2485 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | VALUE_SET | this.lciItem.Text | ItemNames.MODEL | 컨트롤 값 설정 |  |  |  |
| AC-3bfe9ed9 | this.Load 외 6 | SCP0105_CAPA_Speed_Plan.cs:2488 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SetVisibleOperation

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba2a1267 | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:2466 | if (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1d3b6350 | this.Load 외 9 | SCP0105_CAPA_Speed_Plan.cs:2470 | else of (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0105_CAPA_Speed_Plan.ShowItem

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2036219 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3128 |  | POPUP | new SCM0002_CAPAItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0643d32b | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3130 |  | CALL_EXT | pop.Init | (true, dtDivision, _division, _shop_group, _item_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32842ac5 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3131 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5d0e6d62 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3132 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2e2224c6 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3140 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | selectedItems | pop.GetSelectedValues(DefColumns.NICK_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-77176c58 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3140 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValues | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-248797df | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3142 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a7283ad | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3146 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | selectedItems | pop.GetSelectedValues(DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d1502a5 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3146 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValues | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8397ea5 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3148 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db072701 | this.btnItemId.Click | SCP0105_CAPA_Speed_Plan.cs:3152 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0105_CAPA_Speed_Plan.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e356b68 | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1425 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e2b4c38e | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1426 |  | FLAG | this._currColIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-5b15805e | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1430 | if (this._division_type != DivisionType.ELTR) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18149aff | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1433 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ef5dc28 | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1435 |  | CALL_EXT | _si.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29d23797 | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1436 | if (_si.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-effde1f1 | this.spdMain.CellClick | SCP0105_CAPA_Speed_Plan.cs:1441 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_si, e.Row, DefColumns.ELTR_LN_TP_CD, dtElectrodeSpread, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0105_CAPA_Speed_Plan.spdMain_Change

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5bde2c4 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2936 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ac4a665 | (진입점 미연결) | SCP0105_CAPA_Speed_Plan.cs:2939 | if (_si.IsLock(_si.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

