# AS-IS 액션 대조표 — SCP0104

> 원천: `Doc/asisfacts/screens/SCP0104/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1160행 · 메서드 266 · 종류 DATA_OP 333 · CALL_EXT 204 · RETURN 162 · FLAG 137 · LIST_REBIND 76 · UI_PROP 75 · GRID_SET 43 · GRID_INIT 26 · GRID_LOCK 25 · UI_MISC 23 · ENDPOINT 14 · VALUE_SET 8 · VALIDATE 7 · POPUP 6 · MESSAGE 5 · GRID_BIND 4 · COMBO_DATA 4 · STATE_RESET 3 · STATE 3 · THROW 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 205


## SCP0104_CAPA_Line_Assign_Model..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47de75bb | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:453 |  | FLAG | this._def_version | version | 화면 필드/플래그 변경 |  |  |  |
| AC-9b3ea726 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:454 |  | FLAG | this._def_version_seq | version_seq | 화면 필드/플래그 변경 |  |  |  |
| AC-c747500c | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:455 |  | FLAG | this._def_division_type | division_type | 화면 필드/플래그 변경 |  |  |  |
| AC-40145745 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:456 |  | FLAG | this._def_division | division | 화면 필드/플래그 변경 |  |  |  |
| AC-ae8f81d5 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:457 |  | FLAG | this._def_site | site | 화면 필드/플래그 변경 |  |  |  |
| AC-d3dc777d | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:458 |  | FLAG | this._def_plant | plant | 화면 필드/플래그 변경 |  |  |  |
| AC-1b74c6f2 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:459 |  | FLAG | this._def_factory | factory | 화면 필드/플래그 변경 |  |  |  |
| AC-33625e07 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:460 |  | FLAG | this._def_line | line | 화면 필드/플래그 변경 |  |  |  |
| AC-56669f0b | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:461 |  | FLAG | this._def_operation | operation | 화면 필드/플래그 변경 |  |  |  |
| AC-70c8a6d1 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:462 |  | FLAG | this._def_item_id | item_id | 화면 필드/플래그 변경 |  |  |  |
| AC-335301cb | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:463 |  | FLAG | this._def_electrode_type | electrode_type | 화면 필드/플래그 변경 |  |  |  |
| AC-9645ecc1 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:465 |  | FLAG | this.dtDivision | dtDivision.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-790d14d9 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:465 |  | DATA_OP | dtDivision.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b9a9a557 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:466 |  | FLAG | this.dtCapaLineMaster | dtCapaLineMaster.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-2d9fdd46 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:466 |  | DATA_OP | dtCapaLineMaster.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a4f002f4 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:467 |  | FLAG | this.dtSiteAll | dtSiteAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a3ede8c0 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:467 |  | DATA_OP | dtSiteAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e7fb7517 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:468 |  | FLAG | this.dtPlantAll | dtPlantAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f58b6119 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:468 |  | DATA_OP | dtPlantAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f78792b0 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:469 |  | FLAG | this.dtFactoryAll | dtFactoryAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ffa0e45a | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:469 |  | DATA_OP | dtFactoryAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5b0cc334 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:470 |  | FLAG | this.dtLineAll | dtLineAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ebf4064f | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:470 |  | DATA_OP | dtLineAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c4725d0e | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:471 |  | FLAG | this.dtOperationAll | dtOperationAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-68954a65 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:471 |  | DATA_OP | dtOperationAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62db4acd | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:472 |  | FLAG | this.dtElectrodeAll | dtElectrodeAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c497c9c9 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:472 |  | DATA_OP | dtElectrodeAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-65332c2f | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:474 |  | FLAG | this._version | _def_version | 화면 필드/플래그 변경 |  |  |  |
| AC-5391347a | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:475 |  | FLAG | this._version_seq | _def_version_seq | 화면 필드/플래그 변경 |  |  |  |
| AC-a4011d85 | .ctor | SCP0104_CAPA_Line_Assign_Model.cs:476 |  | FLAG | this._division_type | _def_division_type | 화면 필드/플래그 변경 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.AddSelectCheckColumn

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-656e97e5 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:678 |  | GRID_INIT | si.AddCheckColumn | ("V", DefColumns.CHK, FPMerge.None, 25, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-296c5173 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:686 |  | GRID_SET | si.ActiveSheet.ColumnHeader.Cells[0, si.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-b617c9b9 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:687 |  | GRID_SET | si.ActiveSheet.ColumnHeader.Cells[0, si.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-8ab41558 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:688 |  | GRID_SET | si.ActiveSheet.ColumnHeader.Cells[0, si.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90144cd6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1036 |  | GRID_BIND | _si.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4efabfc2 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1042 |  | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b7c94e1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1042 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-244b5afb | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1057 |  | GRID_LOCK | SheetUtils.SetLockAllRows | (_si, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4e0d41f | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1066 | if (colIdxCHK > -1) | GRID_LOCK | _si.LockRange2 | (0, colIdxCHK, _si.GetMaxRowIndex(), colIdxCHK, false, false) | 그리드 편집 잠금 전환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.CancelButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Close:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab99b3f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0104_CAPA_Line_Assign_Model.cs:897 |  | UI_PROP | this.DialogResult | System.Windows.Forms.DialogResult.Cancel | 속성 DialogResult 설정 |  |  |  |
| AC-2936c2f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0104_CAPA_Line_Assign_Model.cs:899 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.ChangeColumnNameToCodeName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acf9adab | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:488 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-7de88a83 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:490 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-564461fe | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:493 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-be230350 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:495 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.CheckNameOnDummyCodeDB

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-294fddac | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:843 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE") ⇒ SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-71e41284 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:845 | try | DATA_OP | request.Parameters["p_code_tp"] | codeType | 행/컬럼 값 대입 |  |  |  |
| AC-aba88be8 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:846 | try | DATA_OP | request.Parameters["p_name"] | name | 행/컬럼 값 대입 |  |  |  |
| AC-9d9aea91 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:847 | try | DATA_OP | request.Parameters["p_program_id"] | "SCP0104" | 행/컬럼 값 대입 |  |  |  |
| AC-80a1bd04 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:848 | try | DATA_OP | request.Parameters["p_sheet_name"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-e523da76 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:849 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-654aa745 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:850 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a46abace | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:852 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f783413 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:872 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fa48095 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:643 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9a7b7abb | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:644 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a485c5a4 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:667 |  | GRID_INIT | this.AddSheet | (spdAssign, SHEETS.SOP_MODEL_ASSEMBLY, SHEETS.SOP_MODEL_ASSEMBLY, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3fb2f60a | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:668 |  | GRID_INIT | this.AddSheet | (spdAssign, SHEETS.SOP_MODEL_ELTR, SHEETS.SOP_MODEL_ELTR, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59c6c848 | Dispose | SCP0104_CAPA_Line_Assign_Model.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.FindButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd119971 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:881 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-db4bd1c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:882 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f38e5dfe | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1109 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GET_CAPA_LINE_ASSIGN_MODEL, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a147a163 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:525 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.GetCurrEditStartColIdx

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-840e628c | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:929 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.GetCurrEditType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0df82bc | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:914 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.GetDataByRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04c813ca | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1270 | try | UI_PROP | res.Division | _si.GetText(row, idxDIVISION_ID) | 속성 Division 설정 |  |  |  |
| AC-d6b99958 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1271 | try | UI_PROP | res.Site | _si.GetText(row, idxSITE_ID) | 속성 Site 설정 |  |  |  |
| AC-f440f5c6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1272 | try | UI_PROP | res.SiteName | _si.GetText(row, idxSITE_NAME) | 속성 SiteName 설정 |  |  |  |
| AC-36ee1623 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1273 | try | UI_PROP | res.Company | _si.GetText(row, idxCOMPANY_ID) | 속성 Company 설정 |  |  |  |
| AC-74c650d3 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1274 | try | UI_PROP | res.CompanyName | _si.GetText(row, idxCOMPANY_NAME) | 속성 CompanyName 설정 |  |  |  |
| AC-1f4ec0f8 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1275 | try | UI_PROP | res.Plant | _si.GetText(row, idxPLANT_ID) | 속성 Plant 설정 |  |  |  |
| AC-0f4c4461 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1276 | try | UI_PROP | res.PlantName | _si.GetText(row, idxPLANT_NAME) | 속성 PlantName 설정 |  |  |  |
| AC-85541553 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1277 | try | UI_PROP | res.Factory | _si.GetText(row, idxFACTORY_ID) | 속성 Factory 설정 |  |  |  |
| AC-37d4641c | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1278 | try | UI_PROP | res.FactoryName | _si.GetText(row, idxFACTORY_NAME) | 속성 FactoryName 설정 |  |  |  |
| AC-ddf51d13 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1279 | try | UI_PROP | res.Line | _si.GetText(row, idxLINE_ID) | 속성 Line 설정 |  |  |  |
| AC-01f891f6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1280 | try | UI_PROP | res.LineName | _si.GetText(row, idxLINE_NAME) | 속성 LineName 설정 |  |  |  |
| AC-2440971c | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1281 | try | UI_PROP | res.Operation | _si.GetText(row, idxOPERATION_ID) | 속성 Operation 설정 |  |  |  |
| AC-66e7c146 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1282 | try | UI_PROP | res.OperationName | _si.GetText(row, idxOPERATION_NAME) | 속성 OperationName 설정 |  |  |  |
| AC-c05ade78 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1283 | try | UI_PROP | res.ElectrodeType | _si.GetText(row, idxELTR_LN_TP_CD) | 속성 ElectrodeType 설정 |  |  |  |
| AC-878903c3 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1289 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce6eafa5 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:182 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ccafa26 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:388 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8b943d3 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:275 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtFactory, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f4981ef | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:282 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a087fc1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:304 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtLine, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-635b9e15 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:311 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5668ea25 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:333 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtOperation, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aa188e1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:340 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5246e1a0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:246 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtPlant, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-118a5b1b | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:253 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.GetSelectedValuesByChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95cb1906 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1354 | try ▸ if (colIdxCHK > -1) ▸ for (r <= _si.GetMaxRowIndex()) ▸ if (_si.GetText(r, colIdxCHK).ToUpper().Equals("TRUE")) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-233dad10 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1361 | try ▸ if (colIdxCHK > -1) | DATA_OP | temp.GroupBy(g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Opera… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae63a015 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1361 | try ▸ if (colIdxCHK > -1) | CALL_EXT | temp.GroupBy | (g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operation, g.Elec… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f128c7af | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1368 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.GetSelectedValuesByRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36f2bfaa | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1312 | try ▸ if (crs.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < satr_row + cr.RowCount) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e9dd112 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1320 | try ▸ else of (crs.LongLength > 0) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-a99ee007 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1325 | try | DATA_OP | temp.GroupBy(g => new {g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operat… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe393764 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1325 | try | CALL_EXT | temp.GroupBy | (g => new {g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operation, g.Elect… | ⚠ 의미 확인 필요 |  |  |  |
| AC-abbfd7f1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1331 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af006d94 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:224 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff55e1f7 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:224 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7e5031e | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:210 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38095861 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:622 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-70717a60 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:625 |  | DATA_OP | ReadOnlySheetList.Add | (SHEETS.SOP_MODEL_ASSEMBLY) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8bc054b | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:628 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-d7ad39ff | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:632 |  | VALUE_SET | cboDivision.SelectedValue | _def_division | 컨트롤 값 설정 |  |  |  |
| AC-0a7ac63a | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:634 |  | VALUE_SET | rgrpDivisionType.SelectedIndex | _division_type | 컨트롤 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceff664f | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:481 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LINE_ASSIGN_MODEL, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.InitSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f58ece8a | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:698 | for (i <= spdAssign.Sheets.Count - 1) | GRID_SET | spdAssign.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-7572d401 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:701 |  | FLAG | _si | GetSheetInfo(spdAssign.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-31163dfb | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:703 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-647f6b18 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:705 |  | GRID_INIT | _si.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-d42ee5e9 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:709 |  | GRID_INIT | _si.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbeb3ad9 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:711 |  | GRID_LOCK | _si.SetLockFlag | (_si.SheetName, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.OkButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78b595f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:890 |  | UI_PROP | this.DialogResult | System.Windows.Forms.DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-cf4ad7b8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:892 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-053b0d8f | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:545 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshElectrodeType

진입점: this.Load / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd492462 | this.Load 외 5 | SCP0104_CAPA_Line_Assign_Model.cs:611 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _division, _operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fea7e5f7 | this.Load 외 5 | SCP0104_CAPA_Line_Assign_Model.cs:613 |  | FLAG | dtElectrode | DBUtils.GetDistinctedCode(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a5d971d | this.Load 외 5 | SCP0104_CAPA_Line_Assign_Model.cs:613 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtElectrodeAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f73e6a5d | this.Load 외 5 | SCP0104_CAPA_Line_Assign_Model.cs:615 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrodeType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshFactory

진입점: this.Load / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92d4c814 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:581 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a89251b | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:583 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9d1166f | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:583 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8c2ce62 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:585 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-47fde5ba | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:585 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-488b09a8 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:586 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshLine

진입점: this.Load / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aaca046 | this.Load 외 3 | SCP0104_CAPA_Line_Assign_Model.cs:592 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f17a061c | this.Load 외 3 | SCP0104_CAPA_Line_Assign_Model.cs:594 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-44fd85e3 | this.Load 외 3 | SCP0104_CAPA_Line_Assign_Model.cs:594 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-544e2b4f | this.Load 외 3 | SCP0104_CAPA_Line_Assign_Model.cs:596 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-f54add3f | this.Load 외 3 | SCP0104_CAPA_Line_Assign_Model.cs:596 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cb85d0e | this.Load 외 3 | SCP0104_CAPA_Line_Assign_Model.cs:597 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshOperation

진입점: this.Load / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6a1cb8b | this.Load 외 4 | SCP0104_CAPA_Line_Assign_Model.cs:602 |  | CALL_EXT | ScpCapaBL.GetFilterOperation | (_division_type, _division, _shop_group, _plant, _factory, _line) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36ab6759 | this.Load 외 4 | SCP0104_CAPA_Line_Assign_Model.cs:604 |  | FLAG | dtOperation | DBUtils.GetDistinctedCode(dtOperationAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-0879fd15 | this.Load 외 4 | SCP0104_CAPA_Line_Assign_Model.cs:604 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtOperationAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-26d8cdcd | this.Load 외 4 | SCP0104_CAPA_Line_Assign_Model.cs:606 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshPlant

진입점: this.Load / this.clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea51e396 | this.Load 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:571 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea75f3c5 | this.Load 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:573 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-35fc221a | this.Load 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:573 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1222d1b | this.Load 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:575 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-22783e75 | this.Load 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:575 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edaaff40 | this.Load 외 1 | SCP0104_CAPA_Line_Assign_Model.cs:576 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshSheetHeader

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-326357c9 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:718 |  | GRID_INIT | _si.SetSheetHeaderColumnSCP | (_si, 1, refreshAllColumn, DefColumns.VALID_YN) | 그리드 재구성/초기화 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.RefreshSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52613edf | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:560 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-875f4f1b | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:563 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4236cb3e | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:563 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3e68eb2 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:565 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-815716c9 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:565 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3037ad9f | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:566 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.rgrpDivisionType_SelectedIndexChanged

진입점: this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cdd1ad8 | this.rgrpDivisionType.SelectedIndexChanged | SCP0104_CAPA_Line_Assign_Model.cs:1134 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5af12a8d | this.rgrpDivisionType.SelectedIndexChanged | SCP0104_CAPA_Line_Assign_Model.cs:1141 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.SetDefConditions

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a01062 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:505 | try | CALL_EXT | clbSite.SetValuesCodeName | (_def_site) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38e0e113 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:506 | try | CALL_EXT | clbPlant.SetValuesCodeName | (_def_plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-add60985 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:507 | try | CALL_EXT | clbFactory.SetValuesCodeName | (_def_factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-090c5e9f | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:508 | try | CALL_EXT | clbLine.SetValuesCodeName | (_def_line) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cc02d32 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:509 | try | CALL_EXT | clbOperation.SetValuesCodeName | (_def_operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-776491e0 | this.Load | SCP0104_CAPA_Line_Assign_Model.cs:512 | try | CALL_EXT | clbElectrodeType.SetValues | (_def_electrode_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.SetLockColumnsAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1ed3de9 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:941 | if (this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57fd7d3e | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:945 |  | UI_MISC | spdAssign.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-02ca20e7 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:974 | try ▸ if (this.IsEditMode) ▸ if (rowCnt > 0) ▸ for (rowIdx <= rowCnt - 1) | GRID_LOCK | _si.LockRange2 | (rowIdx, 0, rowIdx, _fixed_column_idx, isInsertMode) | 그리드 편집 잠금 전환 |  |  |  |
| AC-d48fbb36 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:984 | try ▸ if (this.IsEditMode) ▸ if (rowCnt > 0) ▸ if (laneQtyColIdx != -1) | GRID_LOCK | _si.LockRange2 | (0, laneQtyColIdx, rowCnt - 1, laneQtyColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-48f231f1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:989 | try ▸ if (this.IsEditMode) ▸ if (rowCnt > 0) ▸ if (validYnColIdx != -1) | GRID_LOCK | _si.LockRange2 | (0, validYnColIdx, rowCnt - 1, validYnColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-0cef111f | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:993 | try ▸ if (this.IsEditMode) ▸ if (rowCnt > 0) | GRID_LOCK | _si.LockRange2 | (0, dateStartColIdx, rowCnt - 1, dateEndColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-8d45f7a1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:998 | try ▸ else of (this.IsEditMode) | GRID_LOCK | SheetUtils.SetLockAllRows | (_si, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b141412c | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1005 | finally ▸ if (!this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6a42a65 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1008 | finally | UI_MISC | spdAssign.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.SetQueryInfoGet

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a25a2aeb | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1076 | if (this.QueryDics[DIC_GET_CAPA_LINE_ASSIGN_MODEL].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LINE_ASSIGN_MODEL].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-84522f9e | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1081 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-9df9fa9b | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1082 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-667ac117 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1083 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-3a088cf4 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1084 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0104_GET_CAPA_LINE_ASSIGN_MDL_{0}", _sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-9f21ad2d | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1086 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d889262d | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1087 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff86fb4d | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1088 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4f6a904 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1089 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca9a1b98 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1090 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f062d7ba | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1091 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c45ac29 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1092 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d23a84f0 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1093 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-146164f8 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1095 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4495c19 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1096 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-523fee70 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1097 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f922928 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1098 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "SOP_MODEL_" + this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-988fe567 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1099 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-df52457f | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1100 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-496b7221 | this.Load 외 2 | SCP0104_CAPA_Line_Assign_Model.cs:1102 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LINE_ASSIGN_MODEL] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.SetSelectedColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9980a8bc | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:747 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b32591a | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:752 | if (colIdxCHK == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e29f3253 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:755 | if (col != colIdxCHK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb5ab635 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:761 | if (_si.GetText(row, col).ToUpper().Equals("TRUE")) ▸ for (c <= _si.GetMaxColumnIndex()) | GRID_SET | _si.ActiveSheet.Cells[row, c].BackColor | Color.GreenYellow | 그리드 속성/값 설정 |  |  |  |
| AC-0c444dae | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:768 | else of (_si.GetText(row, col).ToUpper().Equals("TRUE")) ▸ for (c <= _si.GetMaxColumnIndex()) | GRID_SET | _si.ActiveSheet.Cells[row, c].BackColor | System.Drawing.SystemColors.Window | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.SetSheetMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b131d79f | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1016 | if (!this.IsEditMode) | CALL_EXT | _si.ToggleMerge | (spdAssign.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec903f86 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1017 | if (!this.IsEditMode) | GRID_INIT | _si.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.spdAssign_CellClick

진입점: this.spdAssign.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06a8df7f | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign_Model.cs:820 |  | CALL_EXT | SheetUtils.CheckAllRows | (e, _si, DefColumns.CHK) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.spdAssign_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-757775c0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1190 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53323d3f | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:1193 | if (_si.GetMaxRowIndex() <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign_Model.spdAssign_Change

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdee3aa7 | (진입점 미연결) | SCP0104_CAPA_Line_Assign_Model.cs:776 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign._defaultDataModel_Changed

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f53e03a8 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2514 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e3b4751 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2517 | if (e.Column < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbf8bb11 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2559 | if (ds.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a612c105 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2563 | if (e.Type != FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32cf4700 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2583 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.COMPANY_ID, dtCompanySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b53e9c0 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2584 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.COMPANY_NAME, dtCompanySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9dc24b03 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2589 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.PLANT_ID, dtPlantSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5a9ddc4d | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2590 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.PLANT_NAME, dtPlantSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9930edb0 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2596 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.FACTORY_ID, dtFactorySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c01568b2 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2597 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.FACTORY_NAME, dtFactorySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0ff55072 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2605 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.LINE_ID, dtLineSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d0041f30 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2606 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.LINE_NAME, dtLineSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a00affb4 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2611 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.OPERATION_ID, dtOperationSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6dacf246 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2612 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.OPERATION_NAME, dtOperationSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1ed430bb | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2617 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.OPERATION_ID, dtOperationSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4bce69d1 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2618 | try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.OPERATION_NAME, dtOperationSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-689cc2a5 | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2651 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-65ffbe2d | _defaultDataModel.Changed | SCP0104_CAPA_Line_Assign.cs:2657 | finally ▸ if (dt != null) | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.AddNewVersionAssign

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47038c1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:5254 |  | ENDPOINT | this.ExecuteSQL | (_siAssign, DIC_ADD_NEW_CAPA_VERSION, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line_Assign.AfterFindDataAssign

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0c363c6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4499 |  | GRID_BIND | _siAssign.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-83ad8d3c | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4513 |  | FLAG | _tblOriginalAssign | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-54822d4a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4513 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29cd7d01 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4515 |  | GRID_LOCK | _siAssign.LockColumn | (0, _siAssign.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e14b2ed | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4520 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1df16a71 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4524 | if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | DATA_OP | this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN] | false | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.AfterFindDataSOP

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93a47c15 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4536 |  | GRID_BIND | _siSop.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-66277381 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4538 |  | FLAG | _tblOriginalSOP | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1709e28a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4538 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f85eefa | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4540 |  | GRID_LOCK | _siSop.LockColumn | (0, _siSop.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1beb69af | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4545 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3b06de1c | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4549 | if (this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | DATA_OP | this.IsEditModes[DIC_GET_CAPA_LINE_SOP] | false | 행/컬럼 값 대입 |  |  |  |
| AC-e84deb60 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4552 |  | STATE | btnSopNew.Enabled | this.IsEditModes[DIC_GET_CAPA_LINE_SOP] | 컨트롤 상태 Enabled |  |  |  |

## SCP0104_CAPA_Line_Assign.AfterSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce61a2d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4567 |  | CALL_BASE | this._CloseProgress | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a0fa139 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4572 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63fd4a0d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4578 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (isPageSOP) | STATE | btnSopNew.Enabled | this.IsEditModes[DIC_GET_CAPA_LINE_SOP] | 컨트롤 상태 Enabled |  |  |  |
| AC-28e561e0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4592 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0104_CAPA_Line_Assign.AppendNewCode

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else of (colIdxName == colIdx_SITE_NAME) ▸ else of (colIdxName == colIdx_COMPANY_NAME) ▸ else of (colIdxName == colIdx_PLANT_NAME) ▸ else of (colIdxName == colIdx_FACTORY_NAME) ▸ else of (colIdxName == colIdx_LINE_NAME) ▸ else of (colIdxName == colIdx_OPERATION_NAME) ▸ if (colIdxName == colIdx_NICK_NAME)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb981a6f | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3004 |  | DATA_OP | tbl.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bce6bda6 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3010 | foreach (DataColumn c in tbl.Columns) ▸ if (c.ColumnName == codeColumnName) | DATA_OP | r[codeColumnName] | codeValue | 행/컬럼 값 대입 |  |  |  |
| AC-7830597e | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3014 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ if (c.ColumnName == nameColumnName) | DATA_OP | r[nameColumnName] | nameValue | 행/컬럼 값 대입 |  |  |  |
| AC-e449445f | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3022 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ else of (c.ColumnName == nameColumnName) ▸ if (c.ColumnNa… | DATA_OP | r[c.ColumnName] | _curr_assign_company | 행/컬럼 값 대입 |  |  |  |
| AC-566a2ecb | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3026 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ else of (c.ColumnName == nameColumnName) ▸ else of (c.Col… | DATA_OP | r[c.ColumnName] | _curr_assign_division | 행/컬럼 값 대입 |  |  |  |
| AC-750c913d | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3030 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ else of (c.ColumnName == nameColumnName) ▸ else of (c.Col… | DATA_OP | r[c.ColumnName] | _curr_assign_site | 행/컬럼 값 대입 |  |  |  |
| AC-4b43b1ce | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3034 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ else of (c.ColumnName == nameColumnName) ▸ else of (c.Col… | DATA_OP | r[c.ColumnName] | _curr_assign_plant | 행/컬럼 값 대입 |  |  |  |
| AC-2f96bf38 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3038 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ else of (c.ColumnName == nameColumnName) ▸ else of (c.Col… | DATA_OP | r[c.ColumnName] | _curr_assign_factory | 행/컬럼 값 대입 |  |  |  |
| AC-56bf5660 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3042 | foreach (DataColumn c in tbl.Columns) ▸ else of (c.ColumnName == codeColumnName) ▸ else of (c.ColumnName == nameColumnName) ▸ else of (c.Col… | DATA_OP | r[c.ColumnName] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-a272eb94 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3047 |  | DATA_OP | tbl.Rows.Add | (r) | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.AppendNewDummyCode

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else of (colIdxName == colIdx_SITE_NAME) ▸ else of (colIdxName == colIdx_COMPANY_NAME) ▸ else of (colIdxName == colIdx_PLANT_NAME) ▸ else of (colIdxName == colIdx_FACTORY_NAME) ▸ else of (colIdxName == colIdx_LINE_NAME) ▸ else of (colIdxName == colIdx_OPERATION_NAME) ▸ if (colIdxName == colIdx_NICK_NAME)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d72f7621 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3052 |  | DATA_OP | tbl.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fbb3b165 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3054 |  | DATA_OP | r["CODE_TP"] | codeType | 행/컬럼 값 대입 |  |  |  |
| AC-5bed3f2a | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3055 |  | DATA_OP | r["CODE"] | codeValue | 행/컬럼 값 대입 |  |  |  |
| AC-66a37633 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3056 |  | DATA_OP | r["NAME"] | nameValue | 행/컬럼 값 대입 |  |  |  |
| AC-6c380c7e | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3058 |  | DATA_OP | tbl.Rows.Add | (r) | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3da86b0 | this.btnColumn.Click | SCP0104_CAPA_Line_Assign.cs:6098 |  | POPUP | new SCM002_CAPAColumnPopup | ("SCP0104", this._sheet_name, true) | 팝업/폼 생성 |  |  |  |
| AC-8b0c38be | this.btnColumn.Click | SCP0104_CAPA_Line_Assign.cs:6099 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-345e8867 | this.btnColumn.Click | SCP0104_CAPA_Line_Assign.cs:6101 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0104_CAPA_Line_Assign.btnItem_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-654a541d | this.btnItemId.Click | SCP0104_CAPA_Line_Assign.cs:6001 | if (items != "") | VALUE_SET | txtItem.Text | items | 컨트롤 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.btnSopNew_Click

진입점: this.btnSopNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-540fafcf | this.btnSopNew.Click | SCP0104_CAPA_Line_Assign.cs:2226 | if (_siSop == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e65c798a | this.btnSopNew.Click | SCP0104_CAPA_Line_Assign.cs:2229 | if (_siSop.IsLock(_siSop.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7af6235 | this.btnSopNew.Click | SCP0104_CAPA_Line_Assign.cs:2232 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.ChangeColumnNameToCodeName

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b1ce3d | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1378 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-8785ac3c | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1380 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-a25a9608 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1383 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1edd44a | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1385 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.CheckChangedValues

진입점: SaveButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ca2813d | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4272 | else of (si.ActiveSheet.RowCount != tblOriginal.Rows.Count) ▸ for (r <= si.ActiveSheet.RowCount - 1) ▸ for (c <= si.ActiveSheet.ColumnCount … | DATA_OP | tblOriginal.Columns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a12517a | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4285 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.CheckDummyYN

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ if (colIdxName == colIdx_SITE_NAME) ▸ else of (id == "")] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dad2e86e | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3299 |  | GRID_SET | _siAssign.SetText | (rowIdx, dummyColIdx, dummyYN) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.CheckNameOnDummyCodeDB

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else of (colIdxName == colIdx_SITE_NAME) ▸ else of (colIdxName == colIdx_COMPANY_NAME) ▸ else of (colIdxName == colIdx_PLANT_NAME) ▸ else of (colIdxName == colIdx_FACTORY_NAME) ▸ else of (colIdxName == colIdx_LINE_NAME) ▸ else of (colIdxName == colIdx_OPERATION_NAME) ▸ if (colIdxName == colIdx_NICK_NAME)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf0edd14 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2970 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE") ⇒ SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-559df50f | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2972 | try | DATA_OP | request.Parameters["p_code_tp"] | codeType | 행/컬럼 값 대입 |  |  |  |
| AC-1cb96a53 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2973 | try | DATA_OP | request.Parameters["p_name"] | name | 행/컬럼 값 대입 |  |  |  |
| AC-f66060c1 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2974 | try | DATA_OP | request.Parameters["p_program_id"] | "SCP0104" | 행/컬럼 값 대입 |  |  |  |
| AC-4d665d57 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2975 | try | DATA_OP | request.Parameters["p_sheet_name"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-084379c5 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2976 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e43af0b4 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2977 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-751dcfc1 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2979 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3da5424b | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2999 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.CheckValidId

진입점: this.spdAssign.Change [else of ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdx == idxSITE_ID) \|\| (colIdx == idxCOMPANY_ID) \|\| (colIdx == idxPLANT_ID) \|\| (colIdx == idxFACTORY_ID) \|\| (colIdx =…)] / _defaultDataModel.Changed [try ▸ else of ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdx == idxSITE_ID) \|\| (colIdx == idxCOMPANY_ID) \|\| (colIdx == idxPLANT_ID) \|\| (colIdx == idxFACTORY_ID) \|\|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fb8e157 | this.spdAssign.Change [else of ((colIdx == idxSITE_NAME) \|\… 외 2 | SCP0104_CAPA_Line_Assign.cs:3212 | if ((colIdxId == colIdx_SITE_ID) \|\| (colIdxId == colIdx_COMPANY_ID) \|\| (colIdxId == colIdx_PLANT_ID) \|\| (colIdxId == colIdx_…) ▸ if (c… | GRID_SET | _siAssign.SetText | (rowIdx, colNameIdx, name) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.CheckValidName

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-211d4367 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3402 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ if (c… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.SITE_ID, dtSiteSpread, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-aabd4ced | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3406 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ if (c… | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |
| AC-46e5e96f | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3451 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.COMPANY_ID, dtCompanySpreadCode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-34f7f317 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3452 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.COMPANY_NAME, dtCompanySpreadName, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-76876c8c | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3456 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |
| AC-30a80d8d | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3509 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.PLANT_ID, dtPlantSpreadCode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-24f752d0 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3510 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.PLANT_NAME, dtPlantSpreadName, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-d342aa64 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3516 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.PLANT_ID, dtPlantSpreadCode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0586355a | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3517 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.PLANT_NAME, dtPlantSpreadName, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0c0cf16c | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3522 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |
| AC-e4d0c0e9 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3562 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.FACTORY_ID, dtFactorySpreadCode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-aaa989ba | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3563 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.FACTORY_NAME, dtFactorySpreadName, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a7aa2686 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3567 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |
| AC-1f408d10 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3605 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.LINE_ID, dtLineSpreadCode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-142c2d14 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3606 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.LINE_NAME, dtLineSpreadName, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5028455 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3610 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |
| AC-e214a96c | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3650 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.OPERATION_ID, dtOperationSpreadCode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6242e5f7 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3651 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.OPERATION_NAME, dtOperationSpreadName, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-02fbfc23 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3655 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |
| AC-a202676d | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3672 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, dummyYnColIdx, "Y") | 그리드 값 설정 |  |  |  |
| AC-00c04415 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3689 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else … | GRID_SET | _siAssign.SetText | (rowIdx, dummyYnColIdx, "Y") | 그리드 값 설정 |  |  |  |
| AC-043f0cb7 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3697 | if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ if (c… | GRID_SET | _siAssign.SetText | (rowIdx, colIdxId, id) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.ClearRowColumns

진입점: _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxSITE_NAME \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxCOMPANY_NAME \|\| e.Colu…) ▸ if (colIdx == idxSITE_ID \|\| colIdx == idxSITE_NAME)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11405d94 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:3709 | foreach (int colIdx in columnIndexes) | GRID_SET | _siAssign.SetText | (rowIdx, colIdx, String.Empty) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5c6bbe7 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1987 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0fca8204 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1988 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb485bdf | this.Load | SCP0104_CAPA_Line_Assign.cs:2064 |  | GRID_INIT | this.AddSheet | (spdAssign, SHEETS.ASSEMBLY, SHEETS.ASSEMBLY, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a8c1e4ab | this.Load | SCP0104_CAPA_Line_Assign.cs:2065 |  | GRID_INIT | this.AddSheet | (spdAssign, SHEETS.ELTR, SHEETS.ELTR, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f767745a | this.Load | SCP0104_CAPA_Line_Assign.cs:2067 |  | GRID_INIT | this.AddSheet | (spdSOP, SHEETS.SOP_ASSEMBLY, SHEETS.SOP_ASSEMBLY, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-202b1317 | this.Load | SCP0104_CAPA_Line_Assign.cs:2068 |  | GRID_INIT | this.AddSheet | (spdSOP, SHEETS.SOP_ELTR, SHEETS.SOP_ELTR, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0104_CAPA_Line_Assign.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63ef9a55 | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4209 | if (isPageSOP) ▸ if (spdSOP == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-577cc9b2 | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4212 | if (isPageSOP) ▸ if (_siSop.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-504448ab | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4215 | if (isPageSOP) ▸ if (_siSop.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d81701b | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4222 | if (isPageSOP) ▸ if (action == CAppSetting.FlagI) | DATA_OP | _siSop.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb491309 | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4228 | else of (isPageSOP) ▸ if (spdAssign == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a54d96aa | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4231 | else of (isPageSOP) ▸ if (_siAssign.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2329a6d8 | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4234 | else of (isPageSOP) ▸ if (_siAssign.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c672e994 | DeleteButton | SCP0104_CAPA_Line_Assign.cs:4241 | else of (isPageSOP) ▸ if (action == CAppSetting.FlagI) | DATA_OP | _siAssign.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e73638cc | Dispose | SCP0104_CAPA_Line_Assign.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c3aed9bd | Dispose | SCP0104_CAPA_Linen.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line_Assign.Edit_Row_Assign

진입점: this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ else of (selectedItems.Count > 1)] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5623f4c8 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5294 | if (_curr_assign_action == CAppSetting.FlagI) | DATA_OP | dic.Add | (DefColumns.VER_ID, _version) | 데이터 객체 조작/조회 |  |  |  |
| AC-e88c2d58 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5295 | if (_curr_assign_action == CAppSetting.FlagI) | DATA_OP | dic.Add | (DefColumns.VER_SEQ, _version_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-24eac6bd | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5296 | if (_curr_assign_action == CAppSetting.FlagI) | DATA_OP | dic.Add | (DefColumns.DIVISION_ID, _division) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ef6cf6a | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5297 | if (_curr_assign_action == CAppSetting.FlagI) | DATA_OP | dic.Add | (DefColumns.DUMMY_YN, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd219ff5 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5298 | if (_curr_assign_action == CAppSetting.FlagI) | DATA_OP | dic.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-9173bb2b | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5302 | if (_curr_assign_action == CAppSetting.FlagI) ▸ if (_division_type == DivisionType.ELTR) | DATA_OP | dic.Add | (DefColumns.ELTR_LN_TP_CD, "S") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b799304 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5308 | if (_curr_assign_action == CAppSetting.FlagI) ▸ foreach (string dateCol in this._sheetDateColumns) | DATA_OP | dic.Add | (dateCol, "1") | 데이터 객체 조작/조회 |  |  |  |
| AC-23483872 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5318 | if (item != "") ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | DATA_OP | dic.Add | (DefColumns.ITEM_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-de1fecda | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5319 | if (item != "") ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | DATA_OP | dic.Add | (DefColumns.NICK_NAME, item) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9843ea | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5323 | if (item != "") ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | DATA_OP | dic.Add | (DefColumns.ITEM_ID, item) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f16ef4d | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5324 | if (item != "") ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | DATA_OP | dic.Add | (DefColumns.NICK_NAME, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca368760 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5329 |  | GRID_SET | _siAssign.SetValue | (cell, dic) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.Edit_Row_Assign_Line

진입점: this.spdAssign.CellDoubleClick [else of ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ try ▸ if (sels.Count > 0) ▸ foreach (ScpCapaAssignData s in sels) ▸ if (cnt == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9241f436 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5361 |  | DATA_OP | dic.Add | (DefColumns.VER_ID, _version) | 데이터 객체 조작/조회 |  |  |  |
| AC-30a0a39e | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5362 |  | DATA_OP | dic.Add | (DefColumns.VER_SEQ, _version_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-08123fde | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5363 |  | DATA_OP | dic.Add | (DefColumns.DIVISION_ID, s.Division) | 데이터 객체 조작/조회 |  |  |  |
| AC-5292f4b3 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5364 |  | DATA_OP | dic.Add | (DefColumns.SITE_ID, s.Site) | 데이터 객체 조작/조회 |  |  |  |
| AC-c353a62e | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5365 |  | DATA_OP | dic.Add | (DefColumns.SITE_NAME, s.SiteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-5facb1d8 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5366 |  | DATA_OP | dic.Add | (DefColumns.COMPANY_ID, s.Company) | 데이터 객체 조작/조회 |  |  |  |
| AC-082b9c0a | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5367 |  | DATA_OP | dic.Add | (DefColumns.COMPANY_NAME, s.CompanyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8dd16b1 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5368 |  | DATA_OP | dic.Add | (DefColumns.PLANT_ID, s.Plant) | 데이터 객체 조작/조회 |  |  |  |
| AC-610dc39d | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5369 |  | DATA_OP | dic.Add | (DefColumns.PLANT_NAME, s.PlantName) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d3d0c82 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5370 |  | DATA_OP | dic.Add | (DefColumns.FACTORY_ID, s.Factory) | 데이터 객체 조작/조회 |  |  |  |
| AC-e751d140 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5371 |  | DATA_OP | dic.Add | (DefColumns.FACTORY_NAME, s.FactoryName) | 데이터 객체 조작/조회 |  |  |  |
| AC-f032c647 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5372 |  | DATA_OP | dic.Add | (DefColumns.LINE_ID, s.Line) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc77c0e8 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5373 |  | DATA_OP | dic.Add | (DefColumns.LINE_NAME, s.LineName) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd295438 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5374 |  | DATA_OP | dic.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d095fc1 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5379 | foreach (string dateCol in this._sheetDateColumns) | DATA_OP | dic.Add | (dateCol, "1") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a2d9554 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5382 |  | GRID_SET | _siAssign.SetValue | (cell, dic) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.Edit_Row_Sop

진입점: this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapaAssignData s in sels) ▸ if (cnt == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1fc5ae8 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5336 |  | DATA_OP | dic.Add | (DefColumns.VER_ID, _version) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f3e268 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5337 |  | DATA_OP | dic.Add | (DefColumns.VER_SEQ, _version_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-e57c1d8d | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5338 |  | DATA_OP | dic.Add | (DefColumns.DIVISION_ID, s.Division) | 데이터 객체 조작/조회 |  |  |  |
| AC-37cff1c4 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5339 |  | DATA_OP | dic.Add | (DefColumns.SITE_ID, s.Site) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8b9bf9e | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5340 |  | DATA_OP | dic.Add | (DefColumns.SITE_NAME, s.SiteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0347398 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5341 |  | DATA_OP | dic.Add | (DefColumns.COMPANY_ID, s.Company) | 데이터 객체 조작/조회 |  |  |  |
| AC-a02f3177 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5342 |  | DATA_OP | dic.Add | (DefColumns.COMPANY_NAME, s.CompanyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-14911ed4 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5343 |  | DATA_OP | dic.Add | (DefColumns.PLANT_ID, s.Plant) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2f8d755 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5344 |  | DATA_OP | dic.Add | (DefColumns.PLANT_NAME, s.PlantName) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad64e4d5 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5345 |  | DATA_OP | dic.Add | (DefColumns.FACTORY_ID, s.Factory) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd114fda | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5346 |  | DATA_OP | dic.Add | (DefColumns.FACTORY_NAME, s.FactoryName) | 데이터 객체 조작/조회 |  |  |  |
| AC-75bff313 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5347 |  | DATA_OP | dic.Add | (DefColumns.LINE_ID, s.Line) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d9bc411 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5348 |  | DATA_OP | dic.Add | (DefColumns.LINE_NAME, s.LineName) | 데이터 객체 조작/조회 |  |  |  |
| AC-62f921d2 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5349 |  | DATA_OP | dic.Add | (DefColumns.OPERATION_ID, s.Operation) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b7c50c6 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5350 |  | DATA_OP | dic.Add | (DefColumns.OPERATION_NAME, s.OperationName) | 데이터 객체 조작/조회 |  |  |  |
| AC-00d86c2a | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5351 |  | DATA_OP | dic.Add | (DefColumns.ELTR_LN_TP_CD, s.ElectrodeType) | 데이터 객체 조작/조회 |  |  |  |
| AC-d217ae58 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5352 |  | DATA_OP | dic.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-094e4a5e | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5354 |  | GRID_SET | _siSop.SetValue | (cell, dic) | 그리드 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36c86380 | EditButton | SCP0104_CAPA_Line_Assign.cs:4083 | if (isPageSOP) ▸ if (spdSOP == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e878503c | EditButton | SCP0104_CAPA_Line_Assign.cs:4087 | if (isPageSOP) ▸ if (this._currVersionProgressStatus == ProgressStatusType._1ST_CUTOFF \|\| this._currVersionProgressStatus == ProgressStatu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d26b803 | EditButton | SCP0104_CAPA_Line_Assign.cs:4089 | if (isPageSOP) ▸ if (this._currVersionProgressStatus == ProgressStatusType._1ST_CUTOFF \|\| this._currVersionProgressStatus == ProgressStatu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3998401b | EditButton | SCP0104_CAPA_Line_Assign.cs:4093 | if (isPageSOP) | GRID_LOCK | _siSop.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e6d27b20 | EditButton | SCP0104_CAPA_Line_Assign.cs:4095 | if (isPageSOP) | DATA_OP | this.IsEditModes[DIC_GET_CAPA_LINE_SOP] | !_siSop.IsLock(_siSop.SheetName) | 행/컬럼 값 대입 |  |  |  |
| AC-314a7bcf | EditButton | SCP0104_CAPA_Line_Assign.cs:4099 | if (isPageSOP) | STATE | btnSopNew.Enabled | this.IsEditModes[DIC_GET_CAPA_LINE_SOP] | 컨트롤 상태 Enabled |  |  |  |
| AC-a7fa6c60 | EditButton | SCP0104_CAPA_Line_Assign.cs:4104 | else of (isPageSOP) ▸ if (spdAssign == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d358e96 | EditButton | SCP0104_CAPA_Line_Assign.cs:4108 | else of (isPageSOP) ▸ if (this._currVersionProgressStatus == ProgressStatusType._1ST_CUTOFF \|\| this._currVersionProgressStatus == Progress… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b7f6256 | EditButton | SCP0104_CAPA_Line_Assign.cs:4110 | else of (isPageSOP) ▸ if (this._currVersionProgressStatus == ProgressStatusType._1ST_CUTOFF \|\| this._currVersionProgressStatus == Progress… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74710008 | EditButton | SCP0104_CAPA_Line_Assign.cs:4115 | else of (isPageSOP) | GRID_LOCK | _siAssign.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-da860b09 | EditButton | SCP0104_CAPA_Line_Assign.cs:4117 | else of (isPageSOP) | DATA_OP | this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN] | !_siAssign.IsLock(_siAssign.SheetName) | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.ExtractCoodeFromName

진입점: SaveButton [if (isPageSOP) ▸ foreach (DataRow r in tbl.Rows)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc37f8b0 | SaveButton [if (isPageSOP) ▸ foreach (DataRow r in tbl.Rows)… | SCP0104_CAPA_Line_Assign.cs:5247 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c000a6f2 | FindButton | SCP0104_CAPA_Line_Assign.cs:3879 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c9197e5b | FindButton | SCP0104_CAPA_Line_Assign.cs:3880 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.FindDataAssign

진입점: FindButton [else of (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcbac733 | FindButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5267 |  | ENDPOINT | this.ExecuteSQL | (_siAssign, DIC_GET_CAPA_LINE_ASSIGN, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line_Assign.FindDataSOP

진입점: FindButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b55157ac | FindButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5274 |  | ENDPOINT | this.ExecuteSQL | (_siSop, DIC_GET_CAPA_LINE_SOP, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line_Assign.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c8decf7 | this.Load | SCP0104_CAPA_Line_Assign.cs:1517 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAction

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afd0b012 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:869 | try | CALL_EXT | curr_row.Columns | ("Action") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ccbc9ecc | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:875 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignAction

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d69156 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1022 |  | RETURN | return getCurrAction(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d6bdcdf | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1030 |  | RETURN | return getCurrCompany(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1926b8c | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1026 |  | RETURN | return getCurrDivision(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignDummyYn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a55b56b | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1058 |  | RETURN | return getCurrDummyYn(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff289f3b | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1054 |  | RETURN | return getCurrElectrodeType(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fd8fc03 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1042 |  | RETURN | return getCurrFactory(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29602e3a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1046 |  | RETURN | return getCurrLine(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetCurrAssignLines

진입점: this.spdAssign.CellDoubleClick [else of ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ try ▸ if (sels.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e0d3b2f | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:2329 | try ▸ for (r <= _siAssign.GetMaxRowIndex()) | DATA_OP | temp.Add | (s) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0a8b099 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:2332 | try | DATA_OP | temp.GroupBy(g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line }).Selec… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0dff19c5 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:2332 | try | CALL_EXT | temp.GroupBy | (g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c145dc5 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:2338 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9716d57f | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1050 |  | RETURN | return getCurrOperation(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8009de3a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1038 |  | RETURN | return getCurrPlant(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f80c344f | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1034 |  | RETURN | return getCurrSite(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrAssignValidYn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8222a539 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1062 |  | RETURN | return getCurrValidYn(_curr_assign_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8811fc7 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:897 | try | CALL_EXT | curr_row.Columns | (DefColumns.COMPANY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-835dc120 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:903 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad1550c5 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:883 | try | CALL_EXT | curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f54a19e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:889 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrDummyYn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5b0ab8a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:995 | try | CALL_EXT | curr_row.Columns | (DefColumns.DUMMY_YN) | ⚠ 의미 확인 필요 |  |  |  |
| AC-681c2a9e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1001 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetCurrEditStartColIdx

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d5829f6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:3936 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetCurrEditType

진입점: EditButton [else of (isPageSOP) ▸ try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (rowCnt > 0) ▸ for (rowIdx <= rowCnt - 1)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8299e20 | EditButton [else of (isPageSOP) ▸ try ▸ if (this.IsEditModes… 외 1 | SCP0104_CAPA_Line_Assign.cs:3921 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc1ec31d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:981 | try | CALL_EXT | curr_row.Columns | (DefColumns.ELTR_LN_TP_CD) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c40b2f91 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:987 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adeb7b08 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:939 | try | CALL_EXT | curr_row.Columns | (DefColumns.FACTORY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-869a925d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:945 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38f437eb | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:953 | try | CALL_EXT | curr_row.Columns | (DefColumns.LINE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe23aa10 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:959 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91018df0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:967 | try | CALL_EXT | curr_row.Columns | (DefColumns.OPERATION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c21102e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:973 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd00f8b | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:925 | try | CALL_EXT | curr_row.Columns | (DefColumns.PLANT_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a965a2a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:931 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-983fd9c7 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:911 | try | CALL_EXT | curr_row.Columns | (DefColumns.SITE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6d6a494 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:917 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopAction

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d48e3d49 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1067 |  | RETURN | return getCurrAction(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9454b65 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1075 |  | RETURN | return getCurrCompany(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01a5c1bc | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1071 |  | RETURN | return getCurrDivision(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfb2d9a4 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1099 |  | RETURN | return getCurrElectrodeType(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2161572 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1087 |  | RETURN | return getCurrFactory(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3d17f68 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1091 |  | RETURN | return getCurrLine(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetCurrSopLines

진입점: this.btnSopNew.Click [if (sels.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c755667 | this.btnSopNew.Click [if (sels.Count > 0)] 외 1 | SCP0104_CAPA_Line_Assign.cs:2382 | try ▸ for (r <= _siSop.GetMaxRowIndex()) | DATA_OP | temp.Add | (s) | 데이터 객체 조작/조회 |  |  |  |
| AC-5175ffce | this.btnSopNew.Click [if (sels.Count > 0)] 외 1 | SCP0104_CAPA_Line_Assign.cs:2385 | try | DATA_OP | temp.GroupBy(g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Opera… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-819ebec0 | this.btnSopNew.Click [if (sels.Count > 0)] 외 1 | SCP0104_CAPA_Line_Assign.cs:2385 | try | CALL_EXT | temp.GroupBy | (g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operation, g.Elec… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e13bfa63 | this.btnSopNew.Click [if (sels.Count > 0)] 외 1 | SCP0104_CAPA_Line_Assign.cs:2391 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b3af6f5 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1095 |  | RETURN | return getCurrOperation(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae6c569 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1083 |  | RETURN | return getCurrPlant(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetCurrSops

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d28b3cad | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2279 | try ▸ for (r <= _siSop.GetMaxRowIndex()) | DATA_OP | temp.Add | (s) | 데이터 객체 조작/조회 |  |  |  |
| AC-08da54d0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2282 | try | DATA_OP | temp.GroupBy(g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Opera… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dbc9f61 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2282 | try | CALL_EXT | temp.GroupBy | (g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operation, g.Elec… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c543346e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2288 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-881657dc | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1079 |  | RETURN | return getCurrSite(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrSopValidYn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec82a831 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1103 |  | RETURN | return getCurrValidYn(_curr_sop_row); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getCurrValidYn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11d4744d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1009 | try | CALL_EXT | curr_row.Columns | (DefColumns.VALID_YN) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6acf7d22 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1015 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetCurrVersionProgessStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-831a0722 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1574 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE", "VER_SEQ" }, new List<string>() { _division, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-df561b4a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1576 | try | FLAG | dtProgressStatusCurr | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4c8def8 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1576 | try | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7c9b36d5 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1587 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e084292e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:301 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getDivisionType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7773a34d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:277 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetDummyCheckedCode

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [else of (e.Column == _siAssign.GetColumn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b21f95b9 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1747 |  | DATA_OP | code.Contains | ("DMY_") | 데이터 객체 조작/조회 |  |  |  |
| AC-588ebb47 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1747 |  | RETURN | return code.Contains("DMY_") ? "" : code; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e60f251 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:751 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a444a35e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:566 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtFactory, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ccc25d47 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:573 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetIdByName

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ if (colIdxName == colIdx_SITE_NAME)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1174f213 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2943 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "NAME" }, new List<string>() { key }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9390167 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2945 | try | CALL_EXT | DBUtils.GetDistinctedCode | (tblAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc00fe72 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:2956 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetIdColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd865963 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2874 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getIsPageSOP

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed5218dc | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:199 |  | RETURN | return tbcAll.SelectedIndex == 1; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692ac0c4 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:727 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cb94cd5 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:619 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtLine, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90e2baca | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:626 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetNameById

진입점: this.spdAssign.Change [else of ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdx == idxSITE_ID) \|\| (colIdx == idxCOMPANY_ID) \|\| (colIdx == idxPLANT_ID) \|\| (colIdx == idxFACTORY_ID) \|\| (colIdx =…) ▸ if ((colIdxId == colIdx_SITE_ID) \|\| (colIdxId == colIdx_COMPANY_ID) \|\| (colIdxId == colIdx_PLANT_ID) \|\| (colIdxId == colIdx_…) ▸ if (colIdxId == colIdx_SITE_ID)] / _defaultDataModel.Changed [try ▸ else of ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13024865 | this.spdAssign.Change [else of ((colIdx == idxSITE_NAME) \|\… 외 2 | SCP0104_CAPA_Line_Assign.cs:2921 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE" }, new List<string>() { key }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d8b01b6 | this.spdAssign.Change [else of ((colIdx == idxSITE_NAME) \|\… 외 2 | SCP0104_CAPA_Line_Assign.cs:2923 | try | CALL_EXT | DBUtils.GetDistinctedCode | (tblAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-250ab05f | this.spdAssign.Change [else of ((colIdx == idxSITE_NAME) \|\… 외 2 | SCP0104_CAPA_Line_Assign.cs:2934 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetNameColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-764d9d67 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2912 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbbc3987 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:672 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtOperation, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7499459 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:679 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fda6f6fd | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:325 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78486e84 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:775 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-475fdd75 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:597 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03cf58c3 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:650 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a09bbb1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:703 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-befb6404 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:544 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getOriSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbe01ad1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:477 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8174e102 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:513 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtPlant, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c393e3b6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:520 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43519346 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:413 |  | CALL_EXT | ScpCapaBL.GetPlanType | (dtVersionAll, _division, _version, _version_seq) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd7e178d | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:413 |  | RETURN | return ScpCapaBL.GetPlanType(dtVersionAll, _division, _version, _version_seq); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getProgressStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7736b46 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:429 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb028161 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:491 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b1ec3b8 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:491 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75dca4dd | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:453 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.GetSpdTitleAssign

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35ebe1f0 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2094 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_GET_SPREAD_TITLE") ⇒ SCP.SCP0104_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c6aac3e5 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2096 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | this._from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-0d36f769 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2097 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0104" | 행/컬럼 값 대입 |  |  |  |
| AC-739d23de | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2098 |  | DATA_OP | request.Parameters["p_sheet_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e159a1cb | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2100 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ea988c15 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2100 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4cfe0884 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2104 |  | FLAG | this._sheetDateColumns | DBUtils.GetStringColumnValues(dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-b69484cc | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2104 |  | CALL_EXT | DBUtils.GetStringColumnValues | (dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad6a4a25 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2105 |  | FLAG | this._sheetDateColumns | this._sheetDateColumns.Where(w => !w.Contains("ASSIGN_PRIORITY")).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-f310366f | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2105 | lambda | DATA_OP | w.Contains | ("ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-88ad088f | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2109 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | this._sheetNumericColumns | new List<string>() | 화면 필드/플래그 변경 |  |  |  |
| AC-fc2b9703 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2113 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | this._sheetNumericColumns | new List<string>() { DefColumns.LANE_QTY } | 화면 필드/플래그 변경 |  |  |  |

## SCP0104_CAPA_Line_Assign.getValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb497233 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:808 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50a4f2d0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:374 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.getVersionSeq

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50311c28 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:399 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e808bccc | this.Load | SCP0104_CAPA_Line_Assign.cs:1960 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-78d5508b | this.Load | SCP0104_CAPA_Line_Assign.cs:1963 |  | DATA_OP | ReadOnlySheetList.Add | (SHEETS.ASSEMBLY) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ba2f29e | this.Load | SCP0104_CAPA_Line_Assign.cs:1966 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.InitDatasAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-075deee8 | this.Load | SCP0104_CAPA_Line_Assign.cs:1355 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetDummyCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-51bfa79b | this.Load | SCP0104_CAPA_Line_Assign.cs:1355 |  | CALL_EXT | ScpCapaBL.GetDummyCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.InitEditModes

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-685c22a4 | this.Load | SCP0104_CAPA_Line_Assign.cs:1370 |  | DATA_OP | this.IsEditModes.Add | (DIC_GET_CAPA_LINE_ASSIGN, false) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d843461 | this.Load | SCP0104_CAPA_Line_Assign.cs:1371 |  | DATA_OP | this.IsEditModes.Add | (DIC_GET_CAPA_LINE_SOP, false) | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d444b1 | this.Load | SCP0104_CAPA_Line_Assign.cs:1344 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LINE_ASSIGN, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-86679c59 | this.Load | SCP0104_CAPA_Line_Assign.cs:1345 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_LINE_ASSIGN, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c821366d | this.Load | SCP0104_CAPA_Line_Assign.cs:1346 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LINE_SOP, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-081ee290 | this.Load | SCP0104_CAPA_Line_Assign.cs:1347 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_LINE_SOP, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-57a6bb61 | this.Load | SCP0104_CAPA_Line_Assign.cs:1348 |  | DATA_OP | QueryDics.Add | (DIC_ADD_NEW_CAPA_VERSION, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fdeacb4 | this.Load | SCP0104_CAPA_Line_Assign.cs:1350 |  | DATA_OP | QueryDics.Add | (DIC_TEST_IF, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.InitSpreadAssign

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cece8b4 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2119 |  | DATA_OP | this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN] | false | 행/컬럼 값 대입 |  |  |  |
| AC-35892852 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2124 | for (i <= spdAssign.Sheets.Count - 1) | GRID_SET | spdAssign.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-9ee37ff5 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2127 |  | FLAG | _siAssign | GetSheetInfo(spdAssign.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9a81ad3 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2129 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_siAssign) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dcab9cb | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2131 |  | GRID_INIT | _siAssign.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-68bf534e | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2133 |  | GRID_INIT | _siAssign.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.InitSpreadSOP

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd1d40fb | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2139 |  | DATA_OP | this.IsEditModes[DIC_GET_CAPA_LINE_SOP] | false | 행/컬럼 값 대입 |  |  |  |
| AC-74e49def | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2144 | for (i <= spdSOP.Sheets.Count - 1) | GRID_SET | spdSOP.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-1e5d25d6 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2147 |  | FLAG | _siSop | GetSheetInfo(spdSOP.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-55c72c74 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2149 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_siSop) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c186c482 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2151 |  | GRID_INIT | _siSop.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-c04dccd8 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2153 |  | GRID_INIT | _siSop.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.Insert_Row_Assign

진입점: this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems)] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70df367f | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5401 |  | DATA_OP | _siAssign.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e40618ed | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5408 |  | CALL_EXT | _siAssign.SetSelection | (row, col, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9438b4cb | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5421 | if (_division_type == 0) | GRID_LOCK | _siAssign.LockRange | (newCell, _siAssign.GetColumnIndex(DefColumns.NICK_NAME), _siAssign.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0104_CAPA_Line_Assign.Insert_Row_Assign_Line

진입점: this.spdAssign.CellDoubleClick [else of ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ try ▸ if (sels.Count > 0) ▸ foreach (ScpCapaAssignData s in sels) ▸ if (cnt == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ca5fccd | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5440 |  | DATA_OP | _siAssign.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-086f7aad | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5447 |  | CALL_EXT | _siAssign.SetSelection | (row, col, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.Insert_Row_Sop

진입점: this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapaAssignData s in sels) ▸ if (cnt == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a44e40c | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5428 |  | DATA_OP | _siSop.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95771122 | this.btnSopNew.Click [if (sels.Count > 0) ▸ foreach (ScpCapa… 외 1 | SCP0104_CAPA_Line_Assign.cs:5435 |  | CALL_EXT | _siSop.SetSelection | (row, col, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b0c2cf0 | InsertButton | SCP0104_CAPA_Line_Assign.cs:3896 | if (isPageSOP) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af7db495 | InsertButton | SCP0104_CAPA_Line_Assign.cs:3900 | if (spdAssign == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bb4298a | InsertButton | SCP0104_CAPA_Line_Assign.cs:3903 | if (_siAssign.IsLock(_siAssign.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.isDummyCode

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ if (colIdxName == colIdx_SITE_NAME) ▸ else of (id == "")] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b1e84a7 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1743 |  | DATA_OP | code.Contains | ("DMY_") | 데이터 객체 조작/조회 |  |  |  |
| AC-959daa75 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1743 |  | RETURN | return code.Contains("DMY_"); |  | 처리 중단/반환 |  |  |  |
| AC-ebe35b77 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3285 |  | DATA_OP | DBUtils.Filter | (tblDummy, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6e2b4b50 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:3287 |  | RETURN | return tbl.Rows.Count > 0; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.IsNotCheckedSavedData

진입점: SaveButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d42341c8 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4293 | if (fps == null) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-0b0b1a77 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4297 | if (si == null \|\| si.IsLock(si.SheetName) == true) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-cee8eb6d | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4300 | if (si.ActiveSheet.RowCount == 0) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-dbc9f3df | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4303 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (si) | 프레임워크 검증 |  |  |  |
| AC-e5f8abc7 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4304 | if (!DataUtil.checkRequiredOfSpread(si)) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-2b1fa655 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4309 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshAllPre

진입점: this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8451258b | this.rgrpDivisionType.SelectedIndexChanged | SCP0104_CAPA_Line_Assign.cs:1994 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetDummyCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-63603ae0 | this.rgrpDivisionType.SelectedIndexChanged | SCP0104_CAPA_Line_Assign.cs:1994 |  | CALL_EXT | ScpCapaBL.GetDummyCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshCompanyAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12bda19 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1404 |  | FLAG | dtCompanyAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "COMPAN… | 화면 필드/플래그 변경 |  |  |  |
| AC-b9545c15 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1404 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "COMPANY_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fce14d2 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1408 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtCompanyAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshCompanySpread

진입점: this.Load / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellClick [else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ if (e.Column == _siAssign.GetColumnIndex(DefColumns.COMPANY_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.COMPANY_N…)] / _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …) ▸ else of (e.Column == idxSIT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f395319b | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1822 |  | CALL_EXT | ScpCapaBL.GetFilterDummyCompany | (_division, _curr_assign_site) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2abf50e | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1826 |  | FLAG | dtCompanySpread | DBUtils.GetDistinctedCode(dtCompanyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-54f658ca | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1826 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtCompanyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-383d6dad | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1827 |  | FLAG | dtCompanySpread | ScpCapaBL.GetSortedCode(dtCompanySpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8ba3a44 | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1827 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtCompanySpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5631fb7 | this.Load | SCP0104_CAPA_Line_Assign.cs:1534 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummyCompany

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1fe10dd | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1916 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "C" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5bfbf12 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1918 |  | FLAG | dtDummyCompany | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0aa2663 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1918 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummyFactory

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8edea7a | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1930 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "F" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fe6cf7a | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1932 |  | FLAG | dtDummyFactory | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e809cfd8 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1932 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummyItemId

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…) ▸ if ((colIdxName == colIdx_SITE_NAME) \|\| (colIdxName == colIdx_COMPANY_NAME) \|\| (colIdxName == colIdx_PLANT_NAME) \|\| (colIdxN…) ▸ else of (colIdxName == colIdx_SITE_NAME) ▸ else of (colIdxName == colIdx_COMPANY_NAME) ▸ else of (colIdxName == colIdx_PLANT_NAME) ▸ else of (colIdxName == colIdx_FACTORY_NAME) ▸ else of (colIdxName == colIdx_LINE_NAME) ▸ else of (colIdxName == colIdx_OPERATION_NAME) ▸ else of (colIdxName == colIdx_NICK_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12351527 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1951 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "I" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-458ca0e3 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1953 |  | FLAG | dtDummyNickname | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e520c246 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1953 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummyLine

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7b0e126 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1937 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "L" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-742f99ac | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1939 |  | FLAG | dtDummyLine | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-59564760 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1939 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummyNickname

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-620a3c1e | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1944 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "N" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9025067d | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1946 |  | FLAG | dtDummyNickname | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-367b1429 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1946 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummyPlant

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea80953c | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1923 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "P" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec1f38de | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1925 |  | FLAG | dtDummyPlant | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-419f3291 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1925 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshDummySite

진입점: this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / _defaultDataModel.Changed [try ▸ if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)] / spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (colIdx == idxCOMPANY_NAME) \|\| (colIdx == idxPLANT_NAME) \|\| (colIdx == idxFACTORY_NAME) \|\| (…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05061115 | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1909 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "CODE_TP" }, new List<string>() { "S" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e41fd8fc | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1911 |  | FLAG | dtDummySite | DBUtils.GetDistinctedCode(dtDummyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-827f565d | this.spdAssign.Change [if ((colIdx == idxSITE_NAME) \|\| (co… 외 2 | SCP0104_CAPA_Line_Assign.cs:1911 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtDummyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshElectrodeType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a749301 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1722 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _division, _operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09a0cb13 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1724 |  | FLAG | dtElectrode | DBUtils.Filter(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f3f7de1 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1724 |  | DATA_OP | DBUtils.Filter | (dtElectrodeAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e636bb46 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1726 |  | FLAG | dtElectrode | DBUtils.Sort(dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-134d3566 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1726 |  | DATA_OP | DBUtils.Sort | (dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-11bbc3cd | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1728 |  | FLAG | dtElectrode | DBUtils.GetDistinctTable(dtElectrode, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-a51b02aa | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1728 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtElectrode, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1aecf7cd | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1730 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrodeType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshElectrodeTypeAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a93cb9a | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1470 |  | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.OperationElectrodeType, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bf51eb1 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1474 |  | CALL_EXT | ScpCapaBL.GetElectrodeOperationFilter | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0c71753 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1476 |  | FLAG | dtElectrodeAll | DBUtils.Filter(tbl, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3b7cb39 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1476 |  | DATA_OP | DBUtils.Filter | (tbl, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshElectrodeTypeSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID)) ▸ else of (e.Column == _siAssign.GetColumnIndex(DefColumns.PLANT_ID)) ▸ else of (e.Column == _siAssign.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ else of (e.Column == _siAssign.GetColumnIndex(DefColumns.LINE_ID)) ▸ if (e.Column == _siAssign.GetColumnIndex(DefColumns.OPERATION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.N…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00eb4394 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1874 |  | CALL_EXT | ScpCapaBL.GetFilterDummyElectrodeType | (_division_type, _curr_assign_division, _curr_assign_operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b77770c | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1876 |  | FLAG | dtElectrodeSpread | DBUtils.GetDistinctedCode(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-086ad968 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1876 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtElectrodeAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshFactory

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d79fe79 | this.Load 외 6 | SCP0104_CAPA_Line_Assign.cs:1633 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c538fa53 | this.Load 외 6 | SCP0104_CAPA_Line_Assign.cs:1635 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5441dd54 | this.Load 외 6 | SCP0104_CAPA_Line_Assign.cs:1635 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1c4414a | this.Load 외 6 | SCP0104_CAPA_Line_Assign.cs:1637 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-14e0d04b | this.Load 외 6 | SCP0104_CAPA_Line_Assign.cs:1637 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99173c1f | this.Load 외 6 | SCP0104_CAPA_Line_Assign.cs:1638 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshFactoryAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7a2f99e | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1430 |  | FLAG | dtFactoryAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "SHOP_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-3625d55b | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1430 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "SHOP_GROUP_ID", "PLANT_ID", "F… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a82a1671 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1434 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtFactoryAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshFactorySpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [else of (e.Column == _siAssign.GetColumn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0abec32c | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1844 |  | CALL_EXT | ScpCapaBL.GetFilterDummyFactory | (_division_type, _curr_assign_division, _curr_assign_company, _shop_group, GetDummyChecked… | ⚠ 의미 확인 필요 |  |  |  |
| AC-53ce5af7 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1846 |  | FLAG | dtFactorySpread | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4fd76390 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1846 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f8dd7e2 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1847 |  | FLAG | dtFactorySpread | ScpCapaBL.GetSortedCode(dtFactorySpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-186b80ae | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1847 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactorySpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshLine

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b603acb | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1644 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-90aee107 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1646 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-054355c5 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1646 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c75d72a | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1648 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-8636b64a | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1648 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af7af006 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1658 |  | DATA_OP | dtLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8742a2fc | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1659 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a55c6a4 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1660 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ2", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ce4dec8 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1667 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select("CODE LIKE '%" + _rowstr + "%'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01b05921 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1667 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select | ("CODE LIKE '%" + _rowstr + "%'") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e7ac6c2 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1680 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-eaddd212 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1681 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ2"] | "2" | 그리드 속성/값 설정 |  |  |  |
| AC-482822d8 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1685 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-507e5cfc | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1686 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-83202d40 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1692 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5c038f79 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1693 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-cad3792b | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1699 |  | DATA_OP | _dt.Select("", "SEQ1,SEQ2 ASC").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-13ac3531 | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1699 |  | DATA_OP | _dt.Select | ("", "SEQ1,SEQ2 ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a78017f | this.Load 외 7 | SCP0104_CAPA_Line_Assign.cs:1701 |  | LIST_REBIND | clsCtrl.setListBox | (resultDt, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshLineAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8f5e700 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1443 |  | FLAG | dtLineAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "SHOP_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab14da2f | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1443 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "SHOP_GROUP_ID", "PLANT_ID", "F… | ⚠ 의미 확인 필요 |  |  |  |
| AC-243704d4 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1447 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtLineAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshLineSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [else of (e.Column == _siAssign.GetColumn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2614ea85 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1854 |  | CALL_EXT | ScpCapaBL.GetFilterDummyLine | (_division_type, _curr_assign_division, _shop_group, GetDummyCheckedCode(_curr_assign_plan… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5765ba98 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1856 |  | FLAG | dtLineSpread | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-efb078d9 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1856 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-593f86c5 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1857 |  | FLAG | dtLineSpread | ScpCapaBL.GetSortedCode(dtLineSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-2534640a | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1857 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLineSpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshNicknameSpread

진입점: this.Load / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3d1f890 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1881 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID" }, new List<string>() { _curr_assign_division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4629ad9 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1883 |  | DATA_OP | DBUtils.Filter | (dtItemAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-276d3032 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1887 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | dtItemSpread | DBUtils.GetDistinctTable(temp, DefColumns.NICK_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ea50aff | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1887 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | DBUtils.GetDistinctTable | (temp, DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d000f4a | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1891 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | dtItemSpread | DBUtils.GetDistinctTable(temp, DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-747f0af7 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1891 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | DBUtils.GetDistinctTable | (temp, DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshOperation

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de0da1b7 | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:1707 |  | CALL_EXT | ScpCapaBL.GetFilterDummyOperation | (_division_type, _division, _shop_group, "", "", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef1ea281 | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:1710 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ed64ced | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:1710 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dfa96d53 | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:1712 |  | FLAG | dtOperation | DBUtils.Sort(dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-ee0117d4 | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:1712 |  | DATA_OP | DBUtils.Sort | (dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-fe36d3db | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:1715 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshOperationAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57b51028 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1458 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | dtOperationAll | ScpCapaBL.GetFilteredPackCell(Data_SCP.CommonAll(Data_SCP.Type.CapaOperationByLine, false)… | 화면 필드/플래그 변경 |  |  |  |
| AC-23544239 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1458 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | ScpCapaBL.GetFilteredPackCell | (Data_SCP.CommonAll(Data_SCP.Type.CapaOperationByLine, false), _division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aac737f0 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1458 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.CapaOperationByLine, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c65aa013 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1462 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | dtOperationAll | Data_SCP.CommonAll(Data_SCP.Type.CapaOperationByLineEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-82f864d3 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1462 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.CapaOperationByLineEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshOperationSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d6c059b | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1865 |  | CALL_EXT | ScpCapaBL.GetFilterDummyOperation | (_division_type, _curr_assign_division, _shop_group, "", "", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7efe46c | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1867 |  | FLAG | dtOperationSpread | DBUtils.GetDistinctedCode(dtOperationSpreadAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e3056bf | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:1867 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtOperationSpreadAll, filter, false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshPlant

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac4e776b | this.Load 외 5 | SCP0104_CAPA_Line_Assign.cs:1623 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83fc38d4 | this.Load 외 5 | SCP0104_CAPA_Line_Assign.cs:1625 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-87872097 | this.Load 외 5 | SCP0104_CAPA_Line_Assign.cs:1625 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fa235ed | this.Load 외 5 | SCP0104_CAPA_Line_Assign.cs:1627 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a269902 | this.Load 외 5 | SCP0104_CAPA_Line_Assign.cs:1627 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-652af962 | this.Load 외 5 | SCP0104_CAPA_Line_Assign.cs:1628 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshPlantAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20f92f78 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1417 |  | FLAG | dtPlantAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "SHOP_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-4ada8be8 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1417 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "COMPANY_ID", "SHOP_GROUP_ID", "PLANT_ID", "P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-542df9b4 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1421 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtPlantAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshPlantSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [else of (e.Column == _siAssign.GetColumn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67e16c49 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1834 |  | CALL_EXT | ScpCapaBL.GetFilterDummyPlant | (_division_type, _curr_assign_division, _curr_assign_site, _curr_assign_company, _shop_gro… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9d5ad46 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1836 |  | FLAG | dtPlantSpread | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ab39577 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1836 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc8b6c10 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1837 |  | FLAG | dtPlantSpread | ScpCapaBL.GetSortedCode(dtPlantSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-b120d636 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1837 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlantSpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshPlanType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83d38c6c | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1565 |  | VALUE_SET | txtPlanType.Text | _plan_type | 컨트롤 값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshProgressStatus

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-700c2af5 | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1592 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE", "VER_SEQ" }, new List<string>() { _division, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa3fce55 | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1597 |  | FLAG | dtProgressStatus | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4e9d3bc | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1597 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1fa256a0 | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1604 | if (dtProgressStatus.Rows.Count > 0) ▸ if (dtProgressStatus.Rows[0]["PROG_STAT"].ToString().Equals("-")) | GRID_SET | dtProgressStatus.Rows[0]["PROG_STAT"] | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-3b532ce7 | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1605 | if (dtProgressStatus.Rows.Count > 0) ▸ if (dtProgressStatus.Rows[0]["PROG_STAT"].ToString().Equals("-")) | GRID_SET | dtProgressStatus.Rows[0]["PROG_STAT_NAME"] | "Current" | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshSheetHeaderAssign

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-538cd210 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2161 |  | FLAG | _SetSheetHeaderColumnSetInfo | _siAssign.SetSheetHeaderColumnSetInfo(_siAssign, 3, refreshAllColumn, _fixed_column_name) | 화면 필드/플래그 변경 |  |  |  |
| AC-2bb31671 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2161 |  | GRID_INIT | _siAssign.SetSheetHeaderColumnSetInfo | (_siAssign, 3, refreshAllColumn, _fixed_column_name) | 그리드 재구성/초기화 |  |  |  |
| AC-08a1adb1 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2163 |  | GRID_INIT | _siAssign.SetSheetHeaderColumnSCP | (_siAssign, 3, refreshAllColumn, _fixed_column_name) | 그리드 재구성/초기화 |  |  |  |
| AC-76ffdda8 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 6 | SCP0104_CAPA_Line_Assign.cs:2165 |  | CALL_EXT | SheetUtils.RefreshSpreadDateColumn | (_siAssign , dsSpdTitle.Tables[0] // tblTitle , DateColumns.COLUMN_NAME // dataColumnName,… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshSheetHeaderSOP

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae2e509 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:2187 |  | GRID_INIT | _siSop.SetSheetHeaderColumnSCP | (_siSop, 1, refreshAllColumn, DefColumns.VALID_YN) | 그리드 재구성/초기화 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshSite

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9eb4380 | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1612 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ec17815 | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1615 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3eec780a | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1615 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c574f5fc | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1617 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-34d6edc0 | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1617 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8fbd626 | this.Load 외 4 | SCP0104_CAPA_Line_Assign.cs:1618 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshSiteAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca34299a | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1391 |  | FLAG | dtSiteAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-d629eff9 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1391 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-de42d6a5 | this.Load 외 1 | SCP0104_CAPA_Line_Assign.cs:1395 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtSiteAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshSiteSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [if (e.Column == _siAssign.GetColumnIndex…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85e12917 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1811 |  | CALL_EXT | ScpCapaBL.GetFilterDummySite | (_curr_assign_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba2589bb | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1814 |  | FLAG | dtSiteSpread | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-919e3a4a | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1814 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11408e82 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1815 |  | FLAG | dtSiteSpread | ScpCapaBL.GetSortedCode(dtSiteSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-472ae23f | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1815 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSiteSpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshSpreadComboAll

진입점: this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / InsertButton [if (item == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d11d8cd2 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2029 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.SITE_ID, dtSiteSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1759e2f5 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2030 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.SITE_NAME, dtSiteSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f381ede | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2031 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.COMPANY_ID, dtCompanySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-03a9cf4e | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2032 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.COMPANY_NAME, dtCompanySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-866e0576 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2033 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.PLANT_ID, dtPlantSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e75aa0e | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2034 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.PLANT_NAME, dtPlantSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-80de72cf | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2035 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.FACTORY_ID, dtFactorySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-017c4f9e | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2036 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.FACTORY_NAME, dtFactorySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e1e7568 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2037 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.LINE_ID, dtLineSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0a4aedf4 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2038 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.LINE_NAME, dtLineSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-36d64a93 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2039 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.OPERATION_ID, dtOperationSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4753cff3 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2040 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.OPERATION_NAME, dtOperationSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-00c7cd99 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:2041 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, rowIdx, DefColumns.ELTR_LN_TP_CD, dtElectrodeSpread, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshValid

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f64cf82 | this.Load | SCP0104_CAPA_Line_Assign.cs:1737 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshVersion

진입점: this.Load / this.cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cc02d51 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:1544 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID" }, new List<string>() { _division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f85de23d | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:1546 |  | FLAG | dtVersion | DBUtils.GetDistinctedCode(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-13f0ae8c | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:1546 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtVersionAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-855201dc | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:1549 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshVersionAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-719ea90c | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1539 |  | FLAG | dtVersionAll | Data_SCP.CommonAll(Data_SCP.Type.CapaVersion, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-8064e957 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:1539 |  | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.CapaVersion, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0104_CAPA_Line_Assign.RefreshVersionSeq

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f647948a | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1554 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE" }, new List<string>() { _division, _version },… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e9bf53b | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1556 |  | FLAG | dtVersionSeq | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f1d970e | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1556 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0aea3d2b | this.Load 외 3 | SCP0104_CAPA_Line_Assign.cs:1560 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionSeq, cboVersionSeq, false, "VER_SEQ", "VER_SEQ") | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bd1e781 | SaveButton | SCP0104_CAPA_Line_Assign.cs:4326 | if (isExit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d21585e | SaveButton | SCP0104_CAPA_Line_Assign.cs:5486 | if (!isChanged) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a93ab59a | SaveButton | SCP0104_CAPA_Line_Assign.cs:5491 | if (changedCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c07207e3 | SaveButton | SCP0104_CAPA_Line_Assign.cs:5493 | if (changedCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.SaveDataAssign

진입점: SaveButton [else of (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a73c2cfc | SaveButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5455 |  | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { _siAssign, _siAssign } , new List<string>() { DIC_SAVE_CAPA_LINE… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line_Assign.SaveDataSOP

진입점: SaveButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73ae6ef7 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5465 |  | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { _siSop, _siSop } , new List<string>() { DIC_SAVE_CAPA_LINE_SOP, … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line_Assign.SetCodeName

진입점: _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID \|\| e.Column == idxCOMPANY_ID \|\| e.Column == idxPLANT_ID \|\| e.Column == idxFACTORY_ID \|\| e.Column …)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fed1162a | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2691 | if (colName == DefColumns.SITE_ID) ▸ if (!string.IsNullOrEmpty(SITE_ID)) ▸ if (dtSiteSpread != null) | DATA_OP | DBUtils.Filter | (dtSiteSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3bd7e683 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2695 | if (colName == DefColumns.SITE_ID) ▸ if (!string.IsNullOrEmpty(SITE_ID)) ▸ if (dtSiteSpread != null) ▸ if (dtCode.Rows.Count > 0) | DATA_OP | dr[DefColumns.SITE_NAME] | dtCode.Rows[0]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8571f6b7 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2699 | if (colName == DefColumns.SITE_ID) ▸ if (!string.IsNullOrEmpty(SITE_ID)) ▸ if (dtSiteSpread != null) ▸ else of (dtCode.Rows.Count > 0) | DATA_OP | dr[DefColumns.SITE_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-3867f3da | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2717 | else of (colName == DefColumns.SITE_ID) ▸ if (colName == DefColumns.COMPANY_ID) ▸ if (!string.IsNullOrEmpty(COMPANY_ID)) ▸ if (dtCompanySpre… | DATA_OP | DBUtils.Filter | (dtCompanySpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6cabf178 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2721 | else of (colName == DefColumns.SITE_ID) ▸ if (colName == DefColumns.COMPANY_ID) ▸ if (!string.IsNullOrEmpty(COMPANY_ID)) ▸ if (dtCompanySpre… | DATA_OP | dr[DefColumns.COMPANY_NAME] | dtCode.Rows[0]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8df533aa | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2725 | else of (colName == DefColumns.SITE_ID) ▸ if (colName == DefColumns.COMPANY_ID) ▸ if (!string.IsNullOrEmpty(COMPANY_ID)) ▸ if (dtCompanySpre… | DATA_OP | dr[DefColumns.COMPANY_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-95da543a | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2739 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ if (colName == DefColumns.PLANT_ID) ▸ if (!string.IsN… | DATA_OP | DBUtils.Filter | (dtPlantSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7996a31a | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2743 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ if (colName == DefColumns.PLANT_ID) ▸ if (!string.IsN… | DATA_OP | dr[DefColumns.PLANT_NAME] | dtCode.Rows[0]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a98d11ec | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2747 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ if (colName == DefColumns.PLANT_ID) ▸ if (!string.IsN… | DATA_OP | dr[DefColumns.PLANT_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ac6e0742 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2764 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ if (colNam… | DATA_OP | DBUtils.Filter | (dtFactorySpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-22bd8556 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2768 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ if (colNam… | DATA_OP | dr[DefColumns.FACTORY_NAME] | dtCode.Rows[0]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-faa4dc66 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2772 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ if (colNam… | DATA_OP | dr[DefColumns.FACTORY_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-a5173a5e | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2788 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ else of (c… | DATA_OP | DBUtils.Filter | (dtLineSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-22f51827 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2792 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ else of (c… | DATA_OP | dr[DefColumns.LINE_NAME] | dtCode.Rows[0]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5428bf4 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2796 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ else of (c… | DATA_OP | dr[DefColumns.LINE_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-7194b302 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2812 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ else of (c… | DATA_OP | DBUtils.Filter | (dtOperationSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-17cdb4a2 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2816 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ else of (c… | DATA_OP | dr[DefColumns.OPERATION_NAME] | dtCode.Rows[0]["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-299c84a8 | _defaultDataModel.Changed [try ▸ if (e.Column == idxSITE_ID … | SCP0104_CAPA_Line_Assign.cs:2820 | else of (colName == DefColumns.SITE_ID) ▸ else of (colName == DefColumns.COMPANY_ID) ▸ else of (colName == DefColumns.PLANT_ID) ▸ else of (c… | DATA_OP | dr[DefColumns.OPERATION_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetLockColumnsAllAssign

진입점: EditButton [else of (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba250ac9 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:3953 | if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetToggleMerge | (_siAssign, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d55752d | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:3957 |  | UI_MISC | spdAssign.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-803fb964 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:3985 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (rowCnt > 0) ▸ for (rowIdx <= rowCnt - 1) | GRID_LOCK | _siAssign.LockRange2 | (rowIdx, 0, rowIdx, _fixed_column_idx, isInsertMode) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ca6924ec | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:3995 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (rowCnt > 0) ▸ if (laneQtyColIdx != -1) | GRID_LOCK | _siAssign.LockRange2 | (0, laneQtyColIdx, rowCnt - 1, laneQtyColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-1c79f9a8 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4000 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (rowCnt > 0) ▸ if (validYnColIdx != -1) | GRID_LOCK | _siAssign.LockRange2 | (0, validYnColIdx, rowCnt - 1, validYnColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-7948eff1 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4004 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (rowCnt > 0) | GRID_LOCK | _siAssign.LockRange2 | (0, dateStartColIdx, rowCnt - 1, dateEndColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2c9cc5e2 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4009 | try ▸ else of (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | GRID_LOCK | SheetUtils.SetLockAllRows | (_siAssign, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b8a297f2 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4016 | finally ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetToggleMerge | (_siAssign, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0edcee0 | EditButton [else of (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4019 | finally | UI_MISC | spdAssign.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetLockColumnsAllSOP

진입점: EditButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1787690a | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4027 | if (this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | CALL_EXT | SheetUtils.SetToggleMerge | (_siSop, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b2f89e8 | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4031 |  | UI_MISC | spdSOP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3d4ee48e | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4042 | try | GRID_LOCK | SheetUtils.SetLockAllRows | (_siSop, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc435d91 | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4048 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) ▸ if (rowCnt > 0) | GRID_LOCK | _siSop.LockRange2 | (0, _fixed_column_idx, rowCnt - 1, _fixed_column_idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-9d71c544 | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4053 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) ▸ if (rowCnt > 0) ▸ if (validYnColIdx != -1) | GRID_LOCK | _siSop.LockRange2 | (0, validYnColIdx, rowCnt - 1, validYnColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4711d675 | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4057 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) ▸ if (rowCnt > 0) ▸ if (sopDtColIdx != -1) | GRID_LOCK | _siSop.LockRange2 | (0, sopDtColIdx, rowCnt - 1, sopDtColIdx, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-725c7b0d | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4071 | finally ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | CALL_EXT | SheetUtils.SetToggleMerge | (_siSop, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-439486ce | EditButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:4074 | finally | UI_MISC | spdSOP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoAddNewVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2801375 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4600 | if (this.QueryDics[DIC_ADD_NEW_CAPA_VERSION].Count > 0) | CALL_EXT | this.QueryDics[DIC_ADD_NEW_CAPA_VERSION].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7deb6a2 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4605 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-d0eae4c6 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4606 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterAddNewVersion | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-25ee335a | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4607 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-0eab4686 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4608 |  | UI_PROP | qi.QueryId | "SCP.SCP0104_ADD_CAPA_NEW_VERSION" | 속성 QueryId 설정 |  |  |  |
| AC-d3467b47 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4610 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7235cba | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4611 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ce1d9fc | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4612 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "MAIN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-668ce248 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4613 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3464a6f | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4614 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b56cb137 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:4616 |  | DATA_OP | this.QueryDics[DIC_ADD_NEW_CAPA_VERSION] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoGetAssign

진입점: FindButton [else of (isPageSOP)] / SaveButton [else of (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5af91c00 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4625 | if (this.QueryDics[DIC_GET_CAPA_LINE_ASSIGN].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LINE_ASSIGN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f602d73b | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4630 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindDataAssign | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-c0fee9b1 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4631 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataAssign | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-592e90e7 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4632 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-4a9e4e26 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4633 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0104_GET_CAPA_LINE_ASSIGN_{0}", _sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-8d6dd356 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4635 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a68cc1bd | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4636 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab365bf2 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4637 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-279cee4b | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4638 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff17697d | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4639 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9e6de70 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4640 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d07ccae3 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4641 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-73006e80 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4642 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa5aac19 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4643 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d40b7dfe | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4644 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85483412 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4645 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_flag", this._valid)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c13343ab | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4646 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fce9bc15 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4647 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd2e1ee8 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4648 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1902d8a | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4649 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-791379e0 | FindButton [else of (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4651 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LINE_ASSIGN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoGetSOP

진입점: FindButton [if (isPageSOP)] / SaveButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b81c5f13 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4658 | if (this.QueryDics[DIC_GET_CAPA_LINE_SOP].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LINE_SOP].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a119aeb | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4663 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindDataSOP | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-53e44af6 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4664 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataSOP | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-3eec7eaa | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4665 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-73e80842 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4666 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0104_GET_CAPA_LINE_SOP_{0}", _sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-035d629b | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4668 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fd77f3f | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4669 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ba124eb | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4670 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eea8f3a9 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4671 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-59f3f561 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4672 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-441a790d | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4673 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ea6f520 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4674 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6720437c | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4675 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbd1f525 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4676 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c30f70d | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4677 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_flag", this._valid)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d3de8f | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4680 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-62ac7b4e | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4681 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "SOP_" + this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-765aa1c2 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4682 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82133029 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4683 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d024af06 | FindButton [if (isPageSOP)] 외 1 | SCP0104_CAPA_Line_Assign.cs:4685 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LINE_SOP] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoSaveAssignASSEMBLY

진입점: SaveButton [else of (isPageSOP) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-368d13ab | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4944 | if (this.QueryDics[DIC_SAVE_CAPA_LINE_ASSIGN].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_LINE_ASSIGN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e08e46a | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4949 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-6bd5ded6 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4950 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-e58e88d1 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4951 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-d084261b | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4952 |  | UI_PROP | qi.QueryId | "SCP.SCP0104_SAVE_CAPA_LINE_ASSIGN_ASSEMBLY" | 속성 QueryId 설정 |  |  |  |
| AC-8100f64b | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4954 |  | CALL_EXT | SheetUtils.GetChangedData | (_siAssign, _tblOriginalAssign) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fe78b13 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:4998 | foreach (DataRow r in tbl.Rows) ▸ foreach (DataColumn c in tbl.Columns) | DATA_OP | columnName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-620322f2 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5009 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e882fc92 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5010 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e927f2d | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5011 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", "0")) | 데이터 객체 조작/조회 |  |  |  |
| AC-36d52fd1 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5012 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5786d59e | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5013 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_id", COMPANY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc84078d | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5014 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", SITE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c409c660 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5015 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", PLANT_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6a0829e | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5016 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", FACTORY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f41cfc2 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5017 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", LINE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-33c7b897 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5018 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", OPERATION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ab52877 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5019 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", ELTR_LN_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1923b7bc | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5020 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_name", SITE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19cbeba8 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5021 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_name", COMPANY_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d5d96bd | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5022 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_name", PLANT_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a9eb77c | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5023 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_name", FACTORY_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f73a2637 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5024 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_name", LINE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e77d095 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5025 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_yn", VALID_YN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-36524067 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5026 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", ITEM_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef76b17f | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5027 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", NICK_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-567c857f | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5028 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_names", DATE_COLUMN_NAMES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3803c4bd | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5029 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_values", DATE_COLUMN_VALUES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-600aaa53 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5030 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-df1fcc59 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5031 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c0ce7b3 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5032 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad01fb07 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5033 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b6fc336 | SaveButton [else of (isPageSOP) ▸ if (_division_type == Divi… | SCP0104_CAPA_Line_Assign.cs:5036 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_LINE_ASSIGN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoSaveAssignELTR

진입점: SaveButton [else of (isPageSOP) ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f36aed7 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5043 | if (this.QueryDics[DIC_SAVE_CAPA_LINE_ASSIGN].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_LINE_ASSIGN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d060b5b | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5048 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-0785bc84 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5049 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-8403f536 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5050 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-8f2cda29 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5051 |  | UI_PROP | qi.QueryId | "SCP.SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR" | 속성 QueryId 설정 |  |  |  |
| AC-17386db5 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5053 |  | CALL_EXT | SheetUtils.GetChangedData | (_siAssign, _tblOriginalAssign) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cee8a658 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5103 | foreach (DataRow r in tbl.Rows) ▸ foreach (DataColumn c in tbl.Columns) | DATA_OP | columnName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f3063b3 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5114 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-683acd75 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5115 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b250463 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5116 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", "0")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0097a493 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5117 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-92a93009 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5118 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_id", COMPANY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd12171b | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5119 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", SITE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60e80b73 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5120 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", PLANT_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ac2901c | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5121 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", FACTORY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2f8917b | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5122 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", LINE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a889aaa3 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5123 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", OPERATION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8bf9c57 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5124 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", ELTR_LN_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31150ff6 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5125 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_name", SITE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f175aaac | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5126 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_name", COMPANY_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d5c9c15 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5127 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_name", PLANT_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-58f5c385 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5128 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_name", FACTORY_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec250f55 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5129 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_name", LINE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b161ec3f | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5130 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_lane_qty", LANE_QTY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-992c6019 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5131 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_yn", VALID_YN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-491fe2c6 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5132 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", ITEM_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9b066e7 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5133 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", NICK_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff4cf096 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5134 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_names", DATE_COLUMN_NAMES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6b53c89 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5135 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_values", DATE_COLUMN_VALUES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82cbcced | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5136 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a4504d8 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5137 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e49bbff | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5138 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-20630172 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5139 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-05c76278 | SaveButton [else of (isPageSOP) ▸ else of (_division_type ==… | SCP0104_CAPA_Line_Assign.cs:5142 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_LINE_ASSIGN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoSaveSOP

진입점: SaveButton [if (isPageSOP)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26302037 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5149 | if (this.QueryDics[DIC_SAVE_CAPA_LINE_SOP].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_LINE_SOP].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f74dc06 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5154 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-3cc3e0c7 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5155 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-d0f6030f | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5156 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-548527ed | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5157 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0104_SAVE_CAPA_LINE_SOP_{0}", this._sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-d298a5b0 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5159 |  | CALL_EXT | SheetUtils.GetChangedData | (_siSop, _tblOriginalSOP) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d813f98 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5207 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d38eed48 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5208 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2200c55a | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5209 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14946f50 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5210 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_id", COMPANY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf2eedb5 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5211 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", SITE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f98c9015 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5212 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", PLANT_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3710f0c9 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5213 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", FACTORY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-12604fe3 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5214 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", LINE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b460761e | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5215 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", OPERATION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-29889faf | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5216 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", ELTR_LN_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-046de69f | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5217 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_yn", VALID_YN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2f87063 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5218 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sop_dt", SOP_DT)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c70c2f0 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5219 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dc84f92 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5220 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-737a8899 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5221 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7857263d | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5222 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-41d36397 | SaveButton [if (isPageSOP)] | SCP0104_CAPA_Line_Assign.cs:5225 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_LINE_SOP] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetQueryInfoTestIF

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3584b684 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6077 | if (this.QueryDics[DIC_TEST_IF].Count > 0) | CALL_EXT | this.QueryDics[DIC_TEST_IF].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2389906e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6082 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-67da9eca | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6083 |  | UI_PROP | qi.AfterExecuteSQLProc | null | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-eead3160 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6084 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_IF_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-207b9296 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6085 |  | UI_PROP | qi.QueryId | "XIF_DW.DW0105_GET_RESULT" | 속성 QueryId 설정 |  |  |  |
| AC-39e3d7be | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6087 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_id", "1")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e30f1e1 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6089 |  | DATA_OP | this.QueryDics[DIC_TEST_IF] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetSheetMergeAssign

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.TopChange / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f687aa16 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4190 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | _siAssign.ToggleMerge | (spdAssign.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-220bbd57 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4191 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | GRID_INIT | _siAssign.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetSheetMergeSOP

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d352d85 | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:4199 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | CALL_EXT | _siSop.ToggleMerge | (spdSOP.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6b20a0b | this.Load 외 2 | SCP0104_CAPA_Line_Assign.cs:4200 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | GRID_INIT | _siSop.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetSheetNumericColumnFormatASSEMBLY

진입점: EditButton [else of (isPageSOP) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f6b601c | EditButton [else of (isPageSOP) ▸ if (_division_type == Divi… 외 1 | SCP0104_CAPA_Line_Assign.cs:4129 |  | UI_MISC | spdAssign.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-af63df14 | EditButton [else of (isPageSOP) ▸ if (_division_type == Divi… 외 1 | SCP0104_CAPA_Line_Assign.cs:4135 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_siAssign, this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN], _sheetNumericColumns, _fixed_colum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-028b473d | EditButton [else of (isPageSOP) ▸ if (_division_type == Divi… 외 1 | SCP0104_CAPA_Line_Assign.cs:4139 | try ▸ else of (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_siAssign, this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN], _sheetNumericColumns, _fixed_colum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-31759c7d | EditButton [else of (isPageSOP) ▸ if (_division_type == Divi… 외 1 | SCP0104_CAPA_Line_Assign.cs:4146 | finally | UI_MISC | spdAssign.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetSheetNumericColumnFormatELTR

진입점: EditButton [else of (isPageSOP) ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc8f954d | EditButton [else of (isPageSOP) ▸ else of (_division_type ==… 외 1 | SCP0104_CAPA_Line_Assign.cs:4152 |  | UI_MISC | spdAssign.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b292d9fd | EditButton [else of (isPageSOP) ▸ else of (_division_type ==… 외 1 | SCP0104_CAPA_Line_Assign.cs:4158 | try ▸ if (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_siAssign, IsEditModes[DIC_GET_CAPA_LINE_ASSIGN], _sheetNumericColumns, _fixed_column_nam… | ⚠ 의미 확인 필요 |  |  |  |
| AC-539429d5 | EditButton [else of (isPageSOP) ▸ else of (_division_type ==… 외 1 | SCP0104_CAPA_Line_Assign.cs:4162 | try ▸ else of (this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_siAssign, IsEditModes[DIC_GET_CAPA_LINE_ASSIGN], _sheetNumericColumns, _fixed_column_nam… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1b98b0f | EditButton [else of (isPageSOP) ▸ else of (_division_type ==… 외 1 | SCP0104_CAPA_Line_Assign.cs:4170 | finally | UI_MISC | spdAssign.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetSpreadNameToCode

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.spdAssign.ComboSelChange [if (e.Column == _siAssign.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ if (items != "") ▸ if (selectedItems.Count > 0) ▸ if (selectedItems.Count > 1) ▸ foreach (string s in selectedItems) ▸ if (item == "")] / this.spdAssign.CellClick [if (e.Column == _siAssign.GetColumnIndex…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e5eeb4f | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1756 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5fae750 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1767 | foreach (DataRow r in tbl.Rows) ▸ try | DATA_OP | r["NAME"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-e0f20863 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1777 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ffeefa6f | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1778 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b252ab71 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1784 | foreach (DataRow r in tblCode.Rows) ▸ try | DATA_OP | r["NAME"] | r["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e339be81 | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1800 | foreach (DataRow r in tblName.Rows) ▸ try | DATA_OP | r["CODE"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-98b4eb5a | this.Load 외 10 | SCP0104_CAPA_Line_Assign.cs:1801 | foreach (DataRow r in tblName.Rows) ▸ try | DATA_OP | r["NAME"] | newName | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetVisibleElectrodeType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6741720 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:5572 | if (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.CELL) | VALUE_SET | this.lciItem.Text | ScpCapa.ItemNames.NICK_NAME | 컨트롤 값 설정 |  |  |  |
| AC-7cc8fe7c | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:5575 | if (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.CELL) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-97822861 | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:5579 | else of (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.CELL) | VALUE_SET | this.lciItem.Text | ItemNames.MODEL | 컨트롤 값 설정 |  |  |  |
| AC-86a85fdb | this.Load 외 9 | SCP0104_CAPA_Line_Assign.cs:5582 | else of (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.CELL) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetVisibleOperation

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdd65c20 | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:5560 | if (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cde70a61 | this.Load 외 8 | SCP0104_CAPA_Line_Assign.cs:5564 | else of (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0104_CAPA_Line_Assign.SetVisibleSheetColumns

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / EditButton [else of (isPageSOP)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fd929bf | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4373 |  | DATA_OP | _SetSheetHeaderColumnSetInfo.Select | ("ATTRIBUTE3 = 'N'") | 데이터 객체 조작/조회 |  |  |  |
| AC-961cd948 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4373 |  | DATA_OP | _SetSheetHeaderColumnSetInfo.Select("ATTRIBUTE3 = 'N'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e32c495a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4373 |  | DATA_OP | _SetSheetHeaderColumnSetInfo.Select | ("ATTRIBUTE3 = 'N'") | 데이터 객체 조작/조회 |  |  |  |
| AC-05aa2171 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4378 | if (isPageSOP) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, this.IsEditModes[DIC_GET_CAPA_LINE_SOP], new List<string>() { DefColumns.SITE_ID , De… | ⚠ 의미 확인 필요 |  |  |  |
| AC-862008e9 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4404 | else of (isPageSOP) ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN], new List<string>() { DefColumns.SITE_ID ,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-19c1e00d | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4424 | else of (isPageSOP) ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ if (_dt.Rows[i]["COLU… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "DIVISION_ID", 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5bb8b936 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4428 | else of (isPageSOP) ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Rows[i][… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "LINE_NAME", 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8eb01ed | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4433 | else of (isPageSOP) ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Rows[i][… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "PLANT_NAME", 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9197c8c | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4438 | else of (isPageSOP) ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Rows[i][… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "FACTORY_NAME", 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4eae685c | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4443 | else of (isPageSOP) ▸ if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Rows[i][… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "OPERATION_NAME", 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c76d7817 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4450 | else of (isPageSOP) ▸ else of (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN], new List<string>() { DefColumns.SITE_ID ,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-88f6b777 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4468 | else of (isPageSOP) ▸ else of (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ if (_dt.Rows[i][… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "DIVISION_ID", 40, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-175b83fa | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4472 | else of (isPageSOP) ▸ else of (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Row… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "LINE_NAME", 120, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f6efb37 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4477 | else of (isPageSOP) ▸ else of (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Row… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "PLANT_NAME", 140, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe472d1f | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4482 | else of (isPageSOP) ▸ else of (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Row… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "FACTORY_NAME", 120, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb148ac7 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 7 | SCP0104_CAPA_Line_Assign.cs:4487 | else of (isPageSOP) ▸ else of (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) ▸ if (_dt != null) ▸ for (i < _dt.Rows.Count) ▸ else of (_dt.Row… | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (si, "OPERATION_NAME", 120, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line_Assign.ShowItem

진입점: this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…)] / this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9e8d186 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5858 |  | POPUP | new SCM0002_CAPAItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f277ec1e | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5860 |  | CALL_EXT | pop.Init | (true, dtDivision, _division, _shop_group, _item_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d23092d7 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5861 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-16e91bea | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5862 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c471ee28 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5866 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | selectedItems | pop.GetSelectedValues(DefColumns.NICK_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-49c8a5d2 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5866 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValues | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b934dfc | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5868 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09731d5b | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5872 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | selectedItems | pop.GetSelectedValues(DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2987b19 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5872 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValues | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-759cdf34 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5874 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64878780 | this.spdAssign.CellDoubleClick [if ((e.Column == _siAssign.G… 외 1 | SCP0104_CAPA_Line_Assign.cs:5881 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.ShowLine

진입점: this.spdAssign.CellDoubleClick [else of ((e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME)) \|\| (e.Column == _siAssign.GetColumnIndex(DefColumns.ITEM_ID…) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5d61ef1 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5977 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-908957d2 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5979 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4a190a05 | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5982 | if (pop.ShowDialog() == System.Windows.Forms.DialogResult.OK) | CALL_EXT | pop.GetSelectedLinesByChecked | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0899551f | this.spdAssign.CellDoubleClick [else of ((e.Column == _siAss… | SCP0104_CAPA_Line_Assign.cs:5990 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.ShowSopAssignModel

진입점: this.btnSopNew.Click / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98f973a4 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5900 |  | FLAG | this.dtDivision | dtDivision.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-216826b0 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5900 |  | DATA_OP | dtDivision.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0bb9b80 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5901 |  | FLAG | this.dtCapaLineMaster | dtCapaLineMaster.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7e3991b5 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5901 |  | DATA_OP | dtCapaLineMaster.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-795ce503 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5902 |  | FLAG | this.dtSiteAll | dtSiteAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6c7c61ec | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5902 |  | DATA_OP | dtSiteAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-83ad2c3d | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5903 |  | FLAG | this.dtPlantAll | dtPlantAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fdffc0e7 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5903 |  | DATA_OP | dtPlantAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-72266e1b | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5904 |  | FLAG | this.dtFactoryAll | dtFactoryAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d61542c5 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5904 |  | DATA_OP | dtFactoryAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c5ec9ad0 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5905 |  | FLAG | this.dtLineAll | dtLineAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ed896b8 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5905 |  | DATA_OP | dtLineAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25528d86 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5906 |  | FLAG | this.dtOperationAll | dtOperationAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-11484a95 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5906 |  | DATA_OP | dtOperationAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-996ccc14 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5907 |  | FLAG | this.dtElectrodeAll | dtElectrodeAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-8fffc7e4 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5907 |  | DATA_OP | dtElectrodeAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f0ee868 | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5930 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b52a081d | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5932 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fed3417b | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5935 | if (pop.ShowDialog() == System.Windows.Forms.DialogResult.OK) | CALL_EXT | pop.GetSelectedValuesByChecked | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e7c66eb | this.btnSopNew.Click 외 1 | SCP0104_CAPA_Line_Assign.cs:5943 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.spdAssign_CellClick

진입점: this.spdAssign.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b964ae5 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5759 |  | FLAG | this._currAssignRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8ed56e2c | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5760 |  | FLAG | this._currAssignColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-270c7f7d | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5764 | if (_siAssign == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4055577 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5767 | if (_siAssign.IsLock(_siAssign.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-153110e0 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5770 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cac5fd4 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5773 |  | CALL_EXT | _siAssign.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4865c053 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5774 | if (_siAssign.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38030613 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5781 | if (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.SITE_ID, dtSiteSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02eba931 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5782 | if (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.SITE_NAME, dtSiteSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-069fe854 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5788 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ if (e.C… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.COMPANY_ID, dtCompanySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ab335a3b | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5789 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ if (e.C… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.COMPANY_NAME, dtCompanySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c1c858e7 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5805 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.PLANT_ID, dtPlantSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b7ac268 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5806 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.PLANT_NAME, dtPlantSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-08aaccf8 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5812 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.FACTORY_ID, dtFactorySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-17539189 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5813 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.FACTORY_NAME, dtFactorySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-45d1670d | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5819 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.LINE_ID, dtLineSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5f44d35 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5820 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.LINE_NAME, dtLineSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dbba3fb3 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5828 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.OPERATION_ID, dtOperationSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f7433148 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5829 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.OPERATION_NAME, dtOperationSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-26f501c0 | this.spdAssign.CellClick | SCP0104_CAPA_Line_Assign.cs:5835 | else of (e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_ID) \|\| e.Column == _siAssign.GetColumnIndex(DefColumns.SITE_NAME)) ▸ else of… | LIST_REBIND | SheetUtils.SetComboDataRow | (_siAssign, e.Row, DefColumns.ELTR_LN_TP_CD, dtElectrodeSpread, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line_Assign.spdAssign_CellDoubleClick

진입점: this.spdAssign.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98252ac8 | this.spdAssign.CellDoubleClick | SCP0104_CAPA_Line_Assign.cs:5700 | if (_siAssign == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f372c3df | this.spdAssign.CellDoubleClick | SCP0104_CAPA_Line_Assign.cs:5703 | if (_siAssign.IsLock(_siAssign.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ddef221 | this.spdAssign.CellDoubleClick | SCP0104_CAPA_Line_Assign.cs:5706 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec46cf5c | this.spdAssign.CellDoubleClick | SCP0104_CAPA_Line_Assign.cs:5710 | if (_division_type == 0 && (e.Column == _siAssign.GetColumnIndex(DefColumns.NICK_NAME))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.spdAssign_Change

진입점: this.spdAssign.Change / spdAssign.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8102fb6c | this.spdAssign.Change 외 1 | SCP0104_CAPA_Line_Assign.cs:3866 | if (_siAssign == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fa79b0c | this.spdAssign.Change 외 1 | SCP0104_CAPA_Line_Assign.cs:3869 | if (_siAssign.IsLock(_siAssign.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange

진입점: this.spdAssign.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86269b8b | this.spdAssign.ComboSelChange | SCP0104_CAPA_Line_Assign.cs:5644 | if (_siAssign.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efc376c2 | this.spdAssign.ComboSelChange | SCP0104_CAPA_Line_Assign.cs:5647 | if (_siAssign.ActiveRowIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b86415fb | this.spdAssign.ComboSelChange | SCP0104_CAPA_Line_Assign.cs:5650 | if (_curr_assign_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3102836 | this.spdAssign.ComboSelChange | SCP0104_CAPA_Line_Assign.cs:5653 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_ASSIGN]) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.spdSOP_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15a463e0 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:5841 |  | FLAG | this._currSopRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e61566df | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:5842 |  | FLAG | this._currSopColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-b675077f | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:5846 | if (_siSop == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.spdSOP_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94f32fcd | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2490 | if (_siSop == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa8bc142 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2493 | if (_siSop.IsLock(_siSop.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29a76aa8 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2496 | if (!this.IsEditModes[DIC_GET_CAPA_LINE_SOP]) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78cbd021 | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:2499 | if (e.Column == _siSop.GetColumnIndex(DefColumns.SOP_DT)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line_Assign.TestIFAssign

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ee90e8e | (진입점 미연결) | SCP0104_CAPA_Line_Assign.cs:6065 |  | ENDPOINT | this.ExecuteSQL | (_siAssign, DIC_TEST_IF, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf7159e7 | .ctor | SCP0104_CAPA_Line.cs:362 |  | FLAG | this._def_version | _version | 화면 필드/플래그 변경 |  |  |  |
| AC-d90448ce | .ctor | SCP0104_CAPA_Line.cs:363 |  | FLAG | this._def_version_seq | _version_seq | 화면 필드/플래그 변경 |  |  |  |
| AC-cf1c77c4 | .ctor | SCP0104_CAPA_Line.cs:364 |  | FLAG | this._def_division_type | division_type | 화면 필드/플래그 변경 |  |  |  |
| AC-7d196244 | .ctor | SCP0104_CAPA_Line.cs:365 |  | FLAG | this._def_division | division | 화면 필드/플래그 변경 |  |  |  |
| AC-6da9c63e | .ctor | SCP0104_CAPA_Line.cs:366 |  | FLAG | this._def_site | site | 화면 필드/플래그 변경 |  |  |  |
| AC-c6e1bf0f | .ctor | SCP0104_CAPA_Line.cs:367 |  | FLAG | this._def_plant | plant | 화면 필드/플래그 변경 |  |  |  |
| AC-cc0c56af | .ctor | SCP0104_CAPA_Line.cs:368 |  | FLAG | this._def_factory | factory | 화면 필드/플래그 변경 |  |  |  |
| AC-b7ab0b01 | .ctor | SCP0104_CAPA_Line.cs:369 |  | FLAG | this._def_line | line | 화면 필드/플래그 변경 |  |  |  |
| AC-0957c4ed | .ctor | SCP0104_CAPA_Line.cs:371 |  | FLAG | this.dtDivision | dtDivision.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9080ab4c | .ctor | SCP0104_CAPA_Line.cs:371 |  | DATA_OP | dtDivision.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea559043 | .ctor | SCP0104_CAPA_Line.cs:372 |  | FLAG | this.dtCapaLineMaster | dtCapaLineMaster.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-57a1485b | .ctor | SCP0104_CAPA_Line.cs:372 |  | DATA_OP | dtCapaLineMaster.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04cf174a | .ctor | SCP0104_CAPA_Line.cs:373 |  | FLAG | this.dtSiteAll | dtSiteAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1a5492af | .ctor | SCP0104_CAPA_Line.cs:373 |  | DATA_OP | dtSiteAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-338d5bfa | .ctor | SCP0104_CAPA_Line.cs:374 |  | FLAG | this.dtPlantAll | dtPlantAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2f7765a | .ctor | SCP0104_CAPA_Line.cs:374 |  | DATA_OP | dtPlantAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-05156947 | .ctor | SCP0104_CAPA_Line.cs:375 |  | FLAG | this.dtFactoryAll | dtFactoryAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7461d9f | .ctor | SCP0104_CAPA_Line.cs:375 |  | DATA_OP | dtFactoryAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8c6005e9 | .ctor | SCP0104_CAPA_Line.cs:376 |  | FLAG | this.dtLineAll | dtLineAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-eba1cf1b | .ctor | SCP0104_CAPA_Line.cs:376 |  | DATA_OP | dtLineAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line.AddSelectCheckColumn

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5bfd666 | this.Load 외 2 | SCP0104_CAPA_Line.cs:548 |  | GRID_INIT | si.AddCheckColumn | ("V", DefColumns.CHK, FPMerge.None, 25, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6d7d0aa | this.Load 외 2 | SCP0104_CAPA_Line.cs:555 |  | GRID_SET | si.ActiveSheet.ColumnHeader.Cells[0, si.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-b0406cc1 | this.Load 외 2 | SCP0104_CAPA_Line.cs:556 |  | GRID_SET | si.ActiveSheet.ColumnHeader.Cells[0, si.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-b69775e6 | this.Load 외 2 | SCP0104_CAPA_Line.cs:557 |  | GRID_SET | si.ActiveSheet.ColumnHeader.Cells[0, si.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa58abb4 | (진입점 미연결) | SCP0104_CAPA_Line.cs:778 |  | GRID_BIND | _si.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2c86684d | (진입점 미연결) | SCP0104_CAPA_Line.cs:784 |  | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a289c031 | (진입점 미연결) | SCP0104_CAPA_Line.cs:784 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00480d17 | (진입점 미연결) | SCP0104_CAPA_Line.cs:799 |  | GRID_LOCK | SheetUtils.SetLockAllRows | (_si, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f24e02c0 | (진입점 미연결) | SCP0104_CAPA_Line.cs:808 | if (colIdxCHK > -1) | GRID_LOCK | _si.LockRange2 | (0, colIdxCHK, _si.GetMaxRowIndex(), colIdxCHK, false, false) | 그리드 편집 잠금 전환 |  |  |  |

## SCP0104_CAPA_Line.CancelButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Close:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8434b80a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0104_CAPA_Line.cs:719 |  | UI_PROP | this.DialogResult | System.Windows.Forms.DialogResult.Cancel | 속성 DialogResult 설정 |  |  |  |
| AC-9a8f1b10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0104_CAPA_Line.cs:721 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line.ChangeColumnNameToCodeName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c987e5b0 | (진입점 미연결) | SCP0104_CAPA_Line.cs:388 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c816681 | (진입점 미연결) | SCP0104_CAPA_Line.cs:390 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-9bfe8371 | (진입점 미연결) | SCP0104_CAPA_Line.cs:393 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-54594662 | (진입점 미연결) | SCP0104_CAPA_Line.cs:395 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c3dc00a | (진입점 미연결) | SCP0104_CAPA_Line.cs:512 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-26b30955 | (진입점 미연결) | SCP0104_CAPA_Line.cs:513 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8a3e84c | this.Load | SCP0104_CAPA_Line.cs:538 |  | GRID_INIT | this.AddSheet | (spdAssign, SHEETS.LINE, SHEETS.LINE, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0104_CAPA_Line.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b9cdeb9 | Dispose | SCP0104_CAPA_Line.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line.FindButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e191c1f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line.cs:703 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b0e7e31b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line.cs:704 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d849d77d | this.Load 외 2 | SCP0104_CAPA_Line.cs:845 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GET_CAPA_LINE, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0104_CAPA_Line.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-854c9ce6 | this.Load | SCP0104_CAPA_Line.cs:429 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0104_CAPA_Line.GetCurrEditStartColIdx

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f74de9aa | (진입점 미연결) | SCP0104_CAPA_Line.cs:751 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.GetCurrEditType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1788dd1e | (진입점 미연결) | SCP0104_CAPA_Line.cs:736 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.GetDataByRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3665350 | (진입점 미연결) | SCP0104_CAPA_Line.cs:973 | try | UI_PROP | res.Division | _si.GetText(row, idxDIVISION_ID) | 속성 Division 설정 |  |  |  |
| AC-a5a46165 | (진입점 미연결) | SCP0104_CAPA_Line.cs:974 | try | UI_PROP | res.Site | _si.GetText(row, idxSITE_ID) | 속성 Site 설정 |  |  |  |
| AC-6519beb8 | (진입점 미연결) | SCP0104_CAPA_Line.cs:975 | try | UI_PROP | res.SiteName | _si.GetText(row, idxSITE_NAME) | 속성 SiteName 설정 |  |  |  |
| AC-fbede5ac | (진입점 미연결) | SCP0104_CAPA_Line.cs:976 | try | UI_PROP | res.Company | _si.GetText(row, idxCOMPANY_ID) | 속성 Company 설정 |  |  |  |
| AC-0fb6db0d | (진입점 미연결) | SCP0104_CAPA_Line.cs:977 | try | UI_PROP | res.CompanyName | _si.GetText(row, idxCOMPANY_NAME) | 속성 CompanyName 설정 |  |  |  |
| AC-9b7f8bf4 | (진입점 미연결) | SCP0104_CAPA_Line.cs:978 | try | UI_PROP | res.Plant | _si.GetText(row, idxPLANT_ID) | 속성 Plant 설정 |  |  |  |
| AC-3e24378e | (진입점 미연결) | SCP0104_CAPA_Line.cs:979 | try | UI_PROP | res.PlantName | _si.GetText(row, idxPLANT_NAME) | 속성 PlantName 설정 |  |  |  |
| AC-00429e98 | (진입점 미연결) | SCP0104_CAPA_Line.cs:980 | try | UI_PROP | res.Factory | _si.GetText(row, idxFACTORY_ID) | 속성 Factory 설정 |  |  |  |
| AC-386af44d | (진입점 미연결) | SCP0104_CAPA_Line.cs:981 | try | UI_PROP | res.FactoryName | _si.GetText(row, idxFACTORY_NAME) | 속성 FactoryName 설정 |  |  |  |
| AC-d8f22359 | (진입점 미연결) | SCP0104_CAPA_Line.cs:982 | try | UI_PROP | res.Line | _si.GetText(row, idxLINE_ID) | 속성 Line 설정 |  |  |  |
| AC-d151185e | (진입점 미연결) | SCP0104_CAPA_Line.cs:983 | try | UI_PROP | res.LineName | _si.GetText(row, idxLINE_NAME) | 속성 LineName 설정 |  |  |  |
| AC-007fd809 | (진입점 미연결) | SCP0104_CAPA_Line.cs:989 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05285971 | (진입점 미연결) | SCP0104_CAPA_Line.cs:170 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5df6eb06 | (진입점 미연결) | SCP0104_CAPA_Line.cs:263 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtFactory, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c13c95d | (진입점 미연결) | SCP0104_CAPA_Line.cs:270 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dafd513d | (진입점 미연결) | SCP0104_CAPA_Line.cs:292 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtLine, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1c1a020 | (진입점 미연결) | SCP0104_CAPA_Line.cs:299 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82e08740 | (진입점 미연결) | SCP0104_CAPA_Line.cs:234 | try ▸ if (res == "") | CALL_EXT | DBUtils.GetStringColumnValue | (dtPlant, "CODE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4a1caf4 | (진입점 미연결) | SCP0104_CAPA_Line.cs:241 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.GetSelectedItemsByChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c5c3e64 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1054 | try ▸ if (colIdxCHK > -1) ▸ for (r <= _si.GetMaxRowIndex()) ▸ if (_si.GetText(r, colIdxCHK).ToUpper().Equals("TRUE")) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-97b75da7 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1061 | try ▸ if (colIdxCHK > -1) | DATA_OP | temp.GroupBy(g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Opera… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c29d0cc | (진입점 미연결) | SCP0104_CAPA_Line.cs:1061 | try ▸ if (colIdxCHK > -1) | CALL_EXT | temp.GroupBy | (g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operation, g.Elec… | ⚠ 의미 확인 필요 |  |  |  |
| AC-43f31b3e | (진입점 미연결) | SCP0104_CAPA_Line.cs:1068 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.GetSelectedLinesByChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3b53f95 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1091 | try ▸ if (colIdxCHK > -1) ▸ for (r <= _si.GetMaxRowIndex()) ▸ if (_si.GetText(r, colIdxCHK).ToUpper().Equals("TRUE")) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d41f508 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1098 | try ▸ if (colIdxCHK > -1) | DATA_OP | temp.GroupBy(g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line }).Selec… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-31ef0463 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1098 | try ▸ if (colIdxCHK > -1) | CALL_EXT | temp.GroupBy | (g => new { g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a426872 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1105 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.GetSelectedValuesByRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22b4decc | (진입점 미연결) | SCP0104_CAPA_Line.cs:1012 | try ▸ if (crs.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < satr_row + cr.RowCount) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fcdb6ff | (진입점 미연결) | SCP0104_CAPA_Line.cs:1020 | try ▸ else of (crs.LongLength > 0) | DATA_OP | temp.Add | (data) | 데이터 객체 조작/조회 |  |  |  |
| AC-90a9fe07 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1025 | try | DATA_OP | temp.GroupBy(g => new {g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operat… | (s => s.First()) | 데이터 객체 조작/조회 |  |  |  |
| AC-46f7d7fe | (진입점 미연결) | SCP0104_CAPA_Line.cs:1025 | try | CALL_EXT | temp.GroupBy | (g => new {g.Division, g.Site, g.Company, g.Plant, g.Factory, g.Line, g.Operation, g.Elect… | ⚠ 의미 확인 필요 |  |  |  |
| AC-90ae3470 | (진입점 미연결) | SCP0104_CAPA_Line.cs:1031 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f559782d | (진입점 미연결) | SCP0104_CAPA_Line.cs:212 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74d2d6d6 | (진입점 미연결) | SCP0104_CAPA_Line.cs:212 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f601c35 | (진입점 미연결) | SCP0104_CAPA_Line.cs:198 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5247f75e | this.Load | SCP0104_CAPA_Line.cs:496 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-62424459 | this.Load | SCP0104_CAPA_Line.cs:499 |  | DATA_OP | ReadOnlySheetList.Add | (SHEETS.LINE) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eacffbc | this.Load | SCP0104_CAPA_Line.cs:502 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0104_CAPA_Line.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8b952ab | this.Load | SCP0104_CAPA_Line.cs:381 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LINE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0104_CAPA_Line.InitSpread

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82b6f4c9 | this.Load 외 2 | SCP0104_CAPA_Line.cs:566 | for (i <= spdAssign.Sheets.Count - 1) | GRID_SET | spdAssign.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-f60e2375 | this.Load 외 2 | SCP0104_CAPA_Line.cs:569 |  | FLAG | _si | GetSheetInfo(spdAssign.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-e40c9be8 | this.Load 외 2 | SCP0104_CAPA_Line.cs:571 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa823849 | this.Load 외 2 | SCP0104_CAPA_Line.cs:573 |  | GRID_INIT | _si.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-a9d1af82 | this.Load 외 2 | SCP0104_CAPA_Line.cs:577 |  | GRID_INIT | _si.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a446fc44 | this.Load 외 2 | SCP0104_CAPA_Line.cs:579 |  | GRID_LOCK | _si.SetLockFlag | (_si.SheetName, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0104_CAPA_Line.OkButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-724e9ff3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line.cs:712 |  | UI_PROP | this.DialogResult | System.Windows.Forms.DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-83f695e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0104_CAPA_Line.cs:714 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0104_CAPA_Line.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eda66fa | this.Load | SCP0104_CAPA_Line.cs:447 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line.RefreshFactory

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f3b975 | this.Load 외 4 | SCP0104_CAPA_Line.cs:473 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec85fd5b | this.Load 외 4 | SCP0104_CAPA_Line.cs:475 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-411e9129 | this.Load 외 4 | SCP0104_CAPA_Line.cs:475 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a8dbb89 | this.Load 외 4 | SCP0104_CAPA_Line.cs:477 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a77b5e3 | this.Load 외 4 | SCP0104_CAPA_Line.cs:477 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72e54994 | this.Load 외 4 | SCP0104_CAPA_Line.cs:478 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line.RefreshLine

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd786e1 | this.Load 외 5 | SCP0104_CAPA_Line.cs:484 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77bbb83b | this.Load 외 5 | SCP0104_CAPA_Line.cs:486 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4a8d5cf | this.Load 외 5 | SCP0104_CAPA_Line.cs:486 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6d56f40 | this.Load 외 5 | SCP0104_CAPA_Line.cs:488 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-1723e477 | this.Load 외 5 | SCP0104_CAPA_Line.cs:488 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8fc79f3 | this.Load 외 5 | SCP0104_CAPA_Line.cs:489 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line.RefreshPlant

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a506e0d0 | this.Load 외 3 | SCP0104_CAPA_Line.cs:463 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a21ef93 | this.Load 외 3 | SCP0104_CAPA_Line.cs:465 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd32f65b | this.Load 외 3 | SCP0104_CAPA_Line.cs:465 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c79163b | this.Load 외 3 | SCP0104_CAPA_Line.cs:467 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9b658d2 | this.Load 외 3 | SCP0104_CAPA_Line.cs:467 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e26ea6c | this.Load 외 3 | SCP0104_CAPA_Line.cs:468 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line.RefreshSheetHeader

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f890d714 | this.Load 외 2 | SCP0104_CAPA_Line.cs:586 |  | GRID_INIT | _si.SetSheetHeaderColumnSCP | (_si, 1, refreshAllColumn, DefColumns.LINE_NAME) | 그리드 재구성/초기화 |  |  |  |

## SCP0104_CAPA_Line.RefreshSite

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af823125 | this.Load 외 2 | SCP0104_CAPA_Line.cs:452 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef331152 | this.Load 외 2 | SCP0104_CAPA_Line.cs:455 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4994dfd | this.Load 외 2 | SCP0104_CAPA_Line.cs:455 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09aeeb74 | this.Load 외 2 | SCP0104_CAPA_Line.cs:457 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a277331 | this.Load 외 2 | SCP0104_CAPA_Line.cs:457 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-526bce95 | this.Load 외 2 | SCP0104_CAPA_Line.cs:458 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0104_CAPA_Line.SetDefConditions

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb15ba2 | this.Load | SCP0104_CAPA_Line.cs:405 | try | FLAG | _version | _def_version | 화면 필드/플래그 변경 |  |  |  |
| AC-71d5c42a | this.Load | SCP0104_CAPA_Line.cs:406 | try | FLAG | _version_seq | _def_version_seq | 화면 필드/플래그 변경 |  |  |  |
| AC-bd643d3f | this.Load | SCP0104_CAPA_Line.cs:407 | try | FLAG | _division_type | _def_division_type | 화면 필드/플래그 변경 |  |  |  |
| AC-0c64470e | this.Load | SCP0104_CAPA_Line.cs:409 | try | VALUE_SET | cboDivision.SelectedValue | _def_division | 컨트롤 값 설정 |  |  |  |
| AC-90cf7d43 | this.Load | SCP0104_CAPA_Line.cs:411 | try | VALUE_SET | rgrpDivisionType.SelectedIndex | _division_type | 컨트롤 값 설정 |  |  |  |
| AC-32e815f0 | this.Load | SCP0104_CAPA_Line.cs:413 | try | CALL_EXT | clbSite.SetValuesCodeName | (_def_site) | ⚠ 의미 확인 필요 |  |  |  |
| AC-300db624 | this.Load | SCP0104_CAPA_Line.cs:414 | try | CALL_EXT | clbPlant.SetValuesCodeName | (_def_plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d3a8d1e | this.Load | SCP0104_CAPA_Line.cs:415 | try | CALL_EXT | clbFactory.SetValuesCodeName | (_def_factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98442bc0 | this.Load | SCP0104_CAPA_Line.cs:416 | try | CALL_EXT | clbLine.SetValuesCodeName | (_def_line) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line.SetQueryInfoGet

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6b729dd | this.Load 외 2 | SCP0104_CAPA_Line.cs:818 | if (this.QueryDics[DIC_GET_CAPA_LINE].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LINE].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cc4658b | this.Load 외 2 | SCP0104_CAPA_Line.cs:823 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-a08eb1f5 | this.Load 외 2 | SCP0104_CAPA_Line.cs:824 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-979bd600 | this.Load 외 2 | SCP0104_CAPA_Line.cs:825 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-84e7b4e0 | this.Load 외 2 | SCP0104_CAPA_Line.cs:826 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0104_GET_CAPA_LINE_{0}", _division_type_name) | 속성 QueryId 설정 |  |  |  |
| AC-7a0961c9 | this.Load 외 2 | SCP0104_CAPA_Line.cs:828 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de4a7a8a | this.Load 외 2 | SCP0104_CAPA_Line.cs:829 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22a08a39 | this.Load 외 2 | SCP0104_CAPA_Line.cs:830 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-23392a59 | this.Load 외 2 | SCP0104_CAPA_Line.cs:831 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c555ad25 | this.Load 외 2 | SCP0104_CAPA_Line.cs:832 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-63a0dbeb | this.Load 외 2 | SCP0104_CAPA_Line.cs:833 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f5e4cac | this.Load 외 2 | SCP0104_CAPA_Line.cs:834 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-efa11a1d | this.Load 외 2 | SCP0104_CAPA_Line.cs:835 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4505b9fd | this.Load 외 2 | SCP0104_CAPA_Line.cs:836 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-705ab17c | this.Load 외 2 | SCP0104_CAPA_Line.cs:838 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LINE] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0104_CAPA_Line.SetSelectedColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8e4050b | (진입점 미연결) | SCP0104_CAPA_Line.cs:613 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e8c91e5 | (진입점 미연결) | SCP0104_CAPA_Line.cs:618 | if (colIdxCHK == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17ac70cb | (진입점 미연결) | SCP0104_CAPA_Line.cs:621 | if (col != colIdxCHK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f835350e | (진입점 미연결) | SCP0104_CAPA_Line.cs:627 | if (_si.GetText(row, col).ToUpper().Equals("TRUE")) ▸ for (c <= _si.GetMaxColumnIndex()) | GRID_SET | _si.ActiveSheet.Cells[row, c].BackColor | Color.GreenYellow | 그리드 속성/값 설정 |  |  |  |
| AC-d5a56ec0 | (진입점 미연결) | SCP0104_CAPA_Line.cs:634 | else of (_si.GetText(row, col).ToUpper().Equals("TRUE")) ▸ for (c <= _si.GetMaxColumnIndex()) | GRID_SET | _si.ActiveSheet.Cells[row, c].BackColor | System.Drawing.SystemColors.Window | 그리드 속성/값 설정 |  |  |  |

## SCP0104_CAPA_Line.SetSheetMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b1409ed | (진입점 미연결) | SCP0104_CAPA_Line.cs:758 | if (!this.IsEditMode) | CALL_EXT | _si.ToggleMerge | (spdAssign.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df30cdd4 | (진입점 미연결) | SCP0104_CAPA_Line.cs:759 | if (!this.IsEditMode) | GRID_INIT | _si.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0104_CAPA_Line.spdAssign_CellClick

진입점: this.spdAssign.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbcf3182 | this.spdAssign.CellClick | SCP0104_CAPA_Line.cs:685 |  | CALL_EXT | SheetUtils.CheckAllRows | (e, _si, DefColumns.CHK) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0104_CAPA_Line.spdAssign_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ed9403c | (진입점 미연결) | SCP0104_CAPA_Line.cs:898 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea2cd6df | (진입점 미연결) | SCP0104_CAPA_Line.cs:901 | if (_si.GetMaxRowIndex() <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0104_CAPA_Line.spdAssign_Change

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9ecf775 | (진입점 미연결) | SCP0104_CAPA_Line.cs:642 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

