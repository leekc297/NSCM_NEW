# AS-IS 액션 대조표 — FP01883

> 원천: `Doc/asisfacts/screens/FP01883/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 366행 · 메서드 61 · 종류 RETURN 62 · DATA_OP 59 · FLAG 38 · UI_PROP 33 · MESSAGE 31 · GRID_SET 30 · UI_MISC 23 · GRID_INIT 21 · ENDPOINT 15 · VALUE_SET 12 · POPUP 8 · GRID_LOCK 7 · CALL_EXT 7 · VALUE_CLEAR 6 · GRID_STYLE 6 · GRID_BIND 3 · THROW 3 · VALIDATE 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 7


## FP01883_Instance_Authority_NewFolder..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a55bda7 | .ctor | FP01883_Instance_Authority_NewFolder.cs:64 |  | FLAG | this._ROLE_ID | filterDs["ROLE_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-65d5179a | .ctor | FP01883_Instance_Authority_NewFolder.cs:65 |  | FLAG | this._ROLE_NAME | filterDs["ROLE_NAME"] | 화면 필드/플래그 변경 |  |  |  |
| AC-89be7c77 | .ctor | FP01883_Instance_Authority_NewFolder.cs:66 |  | FLAG | this._USER_ID | filterDs["USER_ID"] | 화면 필드/플래그 변경 |  |  |  |

## FP01883_Instance_Authority_NewFolder.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9da6635f | this.btnClose.Click | FP01883_Instance_Authority_NewFolder.cs:113 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01883_Instance_Authority_NewFolder.btnSql_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cbee766 | (진입점 미연결) | FP01883_Instance_Authority_NewFolder.cs:119 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-343b63a0 | (진입점 미연결) | FP01883_Instance_Authority_NewFolder.cs:120 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c71c1238 | (진입점 미연결) | FP01883_Instance_Authority_NewFolder.cs:123 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01883_Instance_Authority_NewFolder.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69517798 | this.Load | FP01883_Instance_Authority_NewFolder.cs:99 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01883_Instance_Authority_NewFolder.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c992124 | Dispose | FP01883_Instance_Authority_NewFolder.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01883_Instance_Authority_NewFolder.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4386da8b | this.Load | FP01883_Instance_Authority_NewFolder.cs:75 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fc52e3e | this.Load | FP01883_Instance_Authority_NewFolder.cs:77 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01883_Instance_Authority_NewFolder.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d35cbd2 | this.Load | FP01883_Instance_Authority_NewFolder.cs:90 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c86682b | this.Load | FP01883_Instance_Authority_NewFolder.cs:92 |  | VALUE_SET | txt_UpperId.Text | this._ROLE_ID | 컨트롤 값 설정 |  |  |  |
| AC-96484ba5 | this.Load | FP01883_Instance_Authority_NewFolder.cs:93 |  | VALUE_SET | txt_UpperName.Text | this._ROLE_NAME | 컨트롤 값 설정 |  |  |  |

## FP01883_Instance_Authority_NewFolder.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39cd357d | popSql.OnSql | FP01883_Instance_Authority_NewFolder.cs:199 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority_NewFolder.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c553bf2 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:137 | if (string.IsNullOrEmpty(strRoleName)) | MESSAGE | MessageBox.Show | ("권한명칭을 입력하십시요!") | 메시지 표시 |  |  |  |
| AC-f85879c7 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:138 | if (string.IsNullOrEmpty(strRoleName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1372372f | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:142 | if (string.IsNullOrEmpty(strRoleDescr)) | MESSAGE | MessageBox.Show | ("권한설명을 입력하십시요!") | 메시지 표시 |  |  |  |
| AC-e5cf4cb6 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:143 | if (string.IsNullOrEmpty(strRoleDescr)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1e1d203 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:147 |  | UI_PROP | dtsave.TableName | "ds1" | 속성 TableName 설정 |  |  |  |
| AC-1c0affea | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:148 |  | DATA_OP | dtsave.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c47c272f | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:150 |  | DATA_OP | dtsave.Columns.SafeAdd | ("ROLE_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e51ce1d | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:151 |  | DATA_OP | dtsave.Columns.SafeAdd | ("UPPER_ROLE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dfd93c6 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:152 |  | DATA_OP | dtsave.Columns.SafeAdd | ("ROLE_DESCR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-182be03b | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:154 |  | DATA_OP | dtsave.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd1f89d2 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:155 |  | GRID_SET | dtsave.Rows[0]["USER_ID"] | this._USER_ID | 그리드 속성/값 설정 |  |  |  |
| AC-077cf2bc | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:156 |  | GRID_SET | dtsave.Rows[0]["ROLE_NAME"] | strRoleName | 그리드 속성/값 설정 |  |  |  |
| AC-c38fab1c | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:157 |  | GRID_SET | dtsave.Rows[0]["UPPER_ROLE_ID"] | txt_UpperId.Text | 그리드 속성/값 설정 |  |  |  |
| AC-3f64d9fe | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:158 |  | GRID_SET | dtsave.Rows[0]["ROLE_DESCR"] | strRoleDescr | 그리드 속성/값 설정 |  |  |  |
| AC-d12b5177 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:162 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP01883_Instance_Authority", "insert_folder", dtsave, 0, "Admin") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_folder] \| FP\Admin\FP018… | 엔드포인트 호출 |  |  |  |
| AC-9a331b05 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:166 | catch ((Exception ee)) | MESSAGE | MessageBox.Show | (ee.Message) | 메시지 표시 |  |  |  |
| AC-ef33f5b4 | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:167 | catch ((Exception ee)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cb5de2e | this.btnSave.Click | FP01883_Instance_Authority_NewFolder.cs:171 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01883_Instance_Authority.btn_Add_Click

진입점: this.btn_Add.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-588fa855 | this.btn_Add.Click | FP01883_Instance_Authority.cs:495 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.btn_AddDetail_Click

진입점: this.btn_AddDetail.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edcf9a3e | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1429 | if (!isApply) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7caf15c | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1436 | if (treeRow["LVL"].ToString() != "3") | MESSAGE | MessageBox.Show | ("권한 폴더를 선택하셨습니다.\r\n권한을 선택하십시요!.") | 메시지 표시 |  |  |  |
| AC-57174dc4 | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1437 | if (treeRow["LVL"].ToString() != "3") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ae12568 | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1441 |  | DATA_OP | dstmp.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f2c4c630 | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1444 |  | DATA_OP | newRow["ROLE_ID"] | txtAuthority.Text | 행/컬럼 값 대입 |  |  |  |
| AC-f29d7e6b | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1445 |  | DATA_OP | newRow["USE_AT_FLAG"] | "True" | 행/컬럼 값 대입 |  |  |  |
| AC-acf6605c | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1447 |  | DATA_OP | dstmp.Tables[0].Rows.Add | (newRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a6d3690 | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1457 | if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | sitmp.LockRange | (iRow, sitmp.GetColumnIndex(DefColumns.FACTORY_ID), iRow, sitmp.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4436c2eb | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1459 | if (spdMain.ActiveSheetIndex == 0) | GRID_SET | sitmp.ActiveSheet.Cells[iRow, sitmp.GetColumnIndex(DefColumns.FACTORY_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-50725d42 | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1472 | else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | sitmp.LockRange | (iRow, sitmp.GetColumnIndex(DefColumns.USER_NAME_2), iRow, sitmp.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-efcfef26 | this.btn_AddDetail.Click | FP01883_Instance_Authority.cs:1474 | else of (spdMain.ActiveSheetIndex == 0) | GRID_SET | sitmp.ActiveSheet.Cells[iRow, sitmp.GetColumnIndex(DefColumns.USER_NAME_2)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## FP01883_Instance_Authority.btn_AuthFolder_Click

진입점: this.btn_AuthFolder.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a9e4204 | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1394 | if (!isApply) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f5fad30 | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1396 |  | CALL_EXT | utriMain.GetNodeCount | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53f3d24c | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1398 | if (utriMain.GetNodeCount(true) == 0) | MESSAGE | MessageBox.Show | ("조회 후 이용하십시요!") | 메시지 표시 |  |  |  |
| AC-8c5f754d | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1399 | if (utriMain.GetNodeCount(true) == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5443ff33 | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1408 | if (row["LVL"].ToString() != "1") | MESSAGE | MessageBox.Show | ("최상위 권한그룹이 존재하지 않습니다!") | 메시지 표시 |  |  |  |
| AC-ff0b131e | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1409 | if (row["LVL"].ToString() != "1") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9454a245 | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1413 |  | DATA_OP | FilterTmp["ROLE_ID"] | row["ROLE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb806dd0 | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1414 |  | DATA_OP | FilterTmp["ROLE_NAME"] | row["ROLE_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cfb1d27b | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1415 |  | DATA_OP | FilterTmp["USER_ID"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-859f2989 | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1418 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-08233a7d | this.btn_AuthFolder.Click | FP01883_Instance_Authority.cs:1420 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01883_Instance_Authority.btn_Del_Click

진입점: this.btn_Del.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ed62dfb | this.btn_Del.Click | FP01883_Instance_Authority.cs:500 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.btn_DelDetail_Click

진입점: this.btn_DelDetail.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3779255d | this.btn_DelDetail.Click | FP01883_Instance_Authority.cs:1484 | if (!isApply) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-192cf618 | this.btn_DelDetail.Click | FP01883_Instance_Authority.cs:1491 | if (treeRow["LVL"].ToString() != "3") | MESSAGE | MessageBox.Show | ("권한 폴더를 선택하셨습니다.\r\n권한을 선택하십시요!.") | 메시지 표시 |  |  |  |
| AC-ec5cbca1 | this.btn_DelDetail.Click | FP01883_Instance_Authority.cs:1492 | if (treeRow["LVL"].ToString() != "3") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-211fe1d5 | this.btn_DelDetail.Click | FP01883_Instance_Authority.cs:1495 | if (spdMain.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4508f002 | this.btn_DelDetail.Click | FP01883_Instance_Authority.cs:1509 | if (!sitmp.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc32746c | this.btn_DelDetail.Click | FP01883_Instance_Authority.cs:1533 |  | DATA_OP | sitmp.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01883_Instance_Authority.btn_Save_Click

진입점: this.btn_Save.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1789997c | this.btn_Save.Click | FP01883_Instance_Authority.cs:505 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.btn_SaveDetail_Click

진입점: this.btn_SaveDetail.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-750fa1b3 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1538 | if (!isApply) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3df5a93b | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1549 | if (sitmp == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-341934ac | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1551 | if (sitmp.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-688a5daa | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1557 | if (dsTmp.Tables[0].Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc6f25a2 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1568 | if (spdMain.ActiveSheetIndex == 0) ▸ foreach (DataRow dr in dsTmp.Tables[0].Rows) ▸ if (string.IsNullOrEmpty(dr[DefColumns.FACTORY_ID].ToStr… | MESSAGE | MessageBox.Show | ("Please select authority.") | 메시지 표시 |  |  |  |
| AC-bdcf1b6d | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1569 | if (spdMain.ActiveSheetIndex == 0) ▸ foreach (DataRow dr in dsTmp.Tables[0].Rows) ▸ if (string.IsNullOrEmpty(dr[DefColumns.FACTORY_ID].ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86268e2c | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1582 | if (spdMain.ActiveSheetIndex == 0) ▸ if (!isModified) | MESSAGE | MessageBox.Show | ("No modified information.") | 메시지 표시 |  |  |  |
| AC-47d19835 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1583 | if (spdMain.ActiveSheetIndex == 0) ▸ if (!isModified) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08f96028 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1591 | if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac0237bb | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1600 | if (spdMain.ActiveSheetIndex == 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35d30e10 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1613 | else of (spdMain.ActiveSheetIndex == 0) ▸ foreach (DataRow dr in dsTmp.Tables[0].Rows) ▸ if (string.IsNullOrEmpty(dr[DefColumns.USER_ID_2].T… | MESSAGE | MessageBox.Show | ("Please select user.") | 메시지 표시 |  |  |  |
| AC-68b64306 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1614 | else of (spdMain.ActiveSheetIndex == 0) ▸ foreach (DataRow dr in dsTmp.Tables[0].Rows) ▸ if (string.IsNullOrEmpty(dr[DefColumns.USER_ID_2].T… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4abe0c5 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1627 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (!isModified) | MESSAGE | MessageBox.Show | ("No modified information.") | 메시지 표시 |  |  |  |
| AC-6991b693 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1628 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (!isModified) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d594bc2a | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1636 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da4f1840 | this.btn_SaveDetail.Click | FP01883_Instance_Authority.cs:1645 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01883_Instance_Authority.BtnNewModel_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b6b2506 | (진입점 미연결) | FP01883_Instance_Authority.cs:1338 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9ccddce | (진입점 미연결) | FP01883_Instance_Authority.cs:1339 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.ClearSelection

진입점: utriMain.AfterSelect [if (row == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-683dbd33 | utriMain.AfterSelect [if (row == null)] | FP01883_Instance_Authority.cs:395 |  | VALUE_CLEAR | txtAuthority.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-35b00c70 | utriMain.AfterSelect [if (row == null)] | FP01883_Instance_Authority.cs:396 |  | VALUE_CLEAR | txtAuthorityName2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9631356e | utriMain.AfterSelect [if (row == null)] | FP01883_Instance_Authority.cs:397 |  | VALUE_CLEAR | txtAuthDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8f6acab3 | utriMain.AfterSelect [if (row == null)] | FP01883_Instance_Authority.cs:398 |  | VALUE_CLEAR | txtUpperAuth.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-18bfa1bc | utriMain.AfterSelect [if (row == null)] | FP01883_Instance_Authority.cs:399 |  | VALUE_CLEAR | txtInsert.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2cd158c5 | utriMain.AfterSelect [if (row == null)] | FP01883_Instance_Authority.cs:400 |  | VALUE_CLEAR | txtUpdate.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP01883_Instance_Authority.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25776062 | this.Load | FP01883_Instance_Authority.cs:265 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain , SpdSheet.shtMain , iColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c196661 | this.Load | FP01883_Instance_Authority.cs:266 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain2, SpdSheet.shtMain2, iColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4f88f835 | this.Load | FP01883_Instance_Authority.cs:268 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-872c1b67 | this.Load | FP01883_Instance_Authority.cs:269 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain2) | 화면 필드/플래그 변경 |  |  |  |
| AC-785065c0 | this.Load | FP01883_Instance_Authority.cs:271 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f81d369 | this.Load | FP01883_Instance_Authority.cs:274 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13b4fb32 | this.Load | FP01883_Instance_Authority.cs:277 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7591a76 | this.Load | FP01883_Instance_Authority.cs:280 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01883_Instance_Authority.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e7f4f5a | this.Load | FP01883_Instance_Authority.cs:162 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-750d5418 | this.Load | FP01883_Instance_Authority.cs:164 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ecdef4c | this.Load | FP01883_Instance_Authority.cs:165 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-31cf358b | this.Load | FP01883_Instance_Authority.cs:166 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP01883_Instance_Authority.Delete_Data

진입점: this.btn_Del.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dc135ab | this.btn_Del.Click | FP01883_Instance_Authority.cs:831 | try | UI_PROP | dtsave.TableName | "ds1" | 속성 TableName 설정 |  |  |  |
| AC-aa67852d | this.btn_Del.Click | FP01883_Instance_Authority.cs:832 | try | DATA_OP | dtsave.Columns.SafeAdd | ("ROLE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4df21db4 | this.btn_Del.Click | FP01883_Instance_Authority.cs:834 | try | DATA_OP | dtsave.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bb7a6414 | this.btn_Del.Click | FP01883_Instance_Authority.cs:835 | try | GRID_SET | dtsave.Rows[0]["ROLE_ID"] | txtAuthority.Text | 그리드 속성/값 설정 |  |  |  |
| AC-0db07903 | this.btn_Del.Click | FP01883_Instance_Authority.cs:837 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP01883_Instance_Authority", "delete_data", dtsave, 0, "Admin") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_data] \| FP\Admin\FP01883… | 엔드포인트 호출 |  |  |  |
| AC-39ae4182 | this.btn_Del.Click | FP01883_Instance_Authority.cs:839 | try | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-4edb058c | this.btn_Del.Click | FP01883_Instance_Authority.cs:843 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.DeleteData_Main

진입점: this.btn_Del.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f767af9 | this.btn_Del.Click | FP01883_Instance_Authority.cs:775 | if (string.IsNullOrEmpty(txtAuthority.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c25926f | this.btn_Del.Click | FP01883_Instance_Authority.cs:787 | if (row["LVL"].ToString() != "3") | MESSAGE | MessageBox.Show | ("해당 권한은 삭제할 수 없습니다.") | 메시지 표시 |  |  |  |
| AC-805d6548 | this.btn_Del.Click | FP01883_Instance_Authority.cs:788 | if (row["LVL"].ToString() != "3") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67039ab1 | this.btn_Del.Click | FP01883_Instance_Authority.cs:791 |  | MESSAGE | MessageBox.Show | ("해당 권한을 하시면 권한에 적용된 사용자및 메뉴정보도 모두 삭제됩니다!.\r\n삭제하시겠습니까 ?", "Confirm", MessageBoxButtons.Ye… | 메시지 표시 |  |  |  |
| AC-db23537c | this.btn_Del.Click | FP01883_Instance_Authority.cs:793 | if (MessageBox.Show("해당 권한을 하시면 권한에 적용된 사용자및 메뉴정보도 모두 삭제됩니다!.\r\n삭제하시겠습니까 ?", "Confirm", MessageBoxButtons.YesNo) == DialogR…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b91a7609 | this.btn_Del.Click | FP01883_Instance_Authority.cs:796 |  | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4238cde9 | this.btn_Del.Click | FP01883_Instance_Authority.cs:800 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b45715d6 | this.btn_Del.Click | FP01883_Instance_Authority.cs:814 | if (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-3063723c | this.btn_Del.Click | FP01883_Instance_Authority.cs:817 | if (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-131829f0 | this.btn_Del.Click | FP01883_Instance_Authority.cs:821 | else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) | MESSAGE | MessageBox.Show | (sMsg + " Is deleted.! ") | 메시지 표시 |  |  |  |

## FP01883_Instance_Authority.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f808bd7d | Dispose | FP01883_Instance_Authority.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01883_Instance_Authority.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1a2804b | EditButton | FP01883_Instance_Authority.cs:481 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.Find_Detail

진입점: this.Load [try ▸ try ▸ try] / utriMain.AfterSelect [try ▸ try] / this.btn_Save.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try] / this.btn_Del.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try] / this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btn_AuthFolder.Click [if (popItem.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ try] / FindButton [try ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a9f0654 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:572 |  | FLAG | nActIdx | siMain.ActiveSheetIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-b4dd6548 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:574 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dae07960 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:577 |  | UI_PROP | siMain.ActiveSheetIndex | 0 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-e7f5e31e | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:578 |  | CALL_EXT | siMain.SpreadInit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e327dfc | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:585 |  | UI_PROP | siMain.ActiveSheetIndex | 1 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-ed980b33 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:586 |  | CALL_EXT | siMain.SpreadInit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-94a33eeb | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:593 |  | UI_PROP | siMain.ActiveSheetIndex | 0 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-b0ce2aaf | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:595 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01883_Instance_Authority.Find_Detail_Instance

진입점: this.Load [try ▸ try ▸ try] / utriMain.AfterSelect [try ▸ try] / this.btn_Save.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try] / this.btn_Del.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try] / this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btn_AuthFolder.Click [if (popItem.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ try] / FindButton [try ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15a7166c | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:610 | try | DATA_OP | column_params.Add | ("ROLE_ID", sRole) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5268132 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:612 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01883_Instance_Authority", "find_InstanceInfo_admin", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c9ad62f6 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:614 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ece49ab | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:615 | try | GRID_BIND | siMain.Query | (ret.DataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cba0c00b | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:623 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01883_Instance_Authority.Find_Detail_User

진입점: this.Load [try ▸ try ▸ try] / utriMain.AfterSelect [try ▸ try] / this.btn_Save.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try] / this.btn_Del.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try] / this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btn_AuthFolder.Click [if (popItem.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ try] / FindButton [try ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b862636b | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:634 | try | DATA_OP | column_params.Add | ("ROLE_ID", sRole) | 데이터 객체 조작/조회 |  |  |  |
| AC-45fa5c52 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:636 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01883_Instance_Authority", "find_UserList_admin", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] \| FP\ADMI… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b1493a5b | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:638 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-467ac1da | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:639 | try | GRID_BIND | siMain.Query | (ret.DataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-81f15bb6 | this.Load [try ▸ try ▸ try] 외 6 | FP01883_Instance_Authority.cs:647 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01883_Instance_Authority.FindData_Main

진입점: this.Load / this.btn_Save.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null)] / this.btn_Del.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null)] / this.btn_AuthFolder.Click [if (popItem.ShowDialog() == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b88c8cc | this.Load 외 4 | FP01883_Instance_Authority.cs:515 |  | FLAG | isApply | true | 화면 필드/플래그 변경 |  |  |  |
| AC-03305184 | this.Load 외 4 | FP01883_Instance_Authority.cs:520 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-613131be | this.Load 외 4 | FP01883_Instance_Authority.cs:520 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9021e4e5 | this.Load 외 4 | FP01883_Instance_Authority.cs:530 | try | DATA_OP | Filter["USER_ID"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c31e57bb | this.Load 외 4 | FP01883_Instance_Authority.cs:531 | try | DATA_OP | Filter["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f422e9d0 | this.Load 외 4 | FP01883_Instance_Authority.cs:532 | try | DATA_OP | Filter["SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cac75aed | this.Load 외 4 | FP01883_Instance_Authority.cs:533 | try | DATA_OP | Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3afdba9 | this.Load 외 4 | FP01883_Instance_Authority.cs:534 | try | DATA_OP | Filter["PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49146991 | this.Load 외 4 | FP01883_Instance_Authority.cs:535 | try | DATA_OP | Filter["FACTORY_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-621421d9 | this.Load 외 4 | FP01883_Instance_Authority.cs:539 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01883_Instance_Authority", "get_instance_authority", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] \| FP\A… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5455065d | this.Load 외 4 | FP01883_Instance_Authority.cs:540 | try | UI_PROP | utriMain.HideCheckBox | true | 속성 HideCheckBox 설정 |  |  |  |
| AC-30aa32cb | this.Load 외 4 | FP01883_Instance_Authority.cs:541 | try | UI_PROP | utriMain.UIDataName | "ROLE_DESCR" | 속성 UIDataName 설정 |  |  |  |
| AC-ca40a1ce | this.Load 외 4 | FP01883_Instance_Authority.cs:542 | try | UI_PROP | utriMain.UIDataID | "ROLE_ID" | 속성 UIDataID 설정 |  |  |  |
| AC-96347ff5 | this.Load 외 4 | FP01883_Instance_Authority.cs:543 | try | UI_PROP | utriMain.UIDataOrder | "ROLE_DETAIL_ORDER" | 속성 UIDataOrder 설정 |  |  |  |
| AC-2a2e8661 | this.Load 외 4 | FP01883_Instance_Authority.cs:544 | try | UI_PROP | utriMain.UILevel | "LVL" | 속성 UILevel 설정 |  |  |  |
| AC-1c28cbe6 | this.Load 외 4 | FP01883_Instance_Authority.cs:545 | try | UI_PROP | utriMain.UIDataImg | "IMG" | 속성 UIDataImg 설정 |  |  |  |
| AC-1bbfcfb1 | this.Load 외 4 | FP01883_Instance_Authority.cs:546 | try | UI_PROP | utriMain.UIDataParentID | "UPPER_ROLE_ID" | 속성 UIDataParentID 설정 |  |  |  |
| AC-a910b7a3 | this.Load 외 4 | FP01883_Instance_Authority.cs:548 | try | UI_PROP | utriMain.UIDataSource | dtDup | 속성 UIDataSource 설정 |  |  |  |
| AC-8d33d327 | this.Load 외 4 | FP01883_Instance_Authority.cs:556 | try | FLAG | nNewRoleID | -99999 | 화면 필드/플래그 변경 |  |  |  |
| AC-caf7eabc | this.Load 외 4 | FP01883_Instance_Authority.cs:559 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3f092801 | this.Load 외 4 | FP01883_Instance_Authority.cs:560 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53f4a24d | this.Load 외 4 | FP01883_Instance_Authority.cs:564 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ecd064c0 | this.Load 외 4 | FP01883_Instance_Authority.cs:565 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01883_Instance_Authority.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91365286 | this.Load | FP01883_Instance_Authority.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01883_Instance_Authority.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f741ec66 | (진입점 미연결) | FP01883_Instance_Authority.cs:934 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_DAY_RANGE") ⇒ SCP.SCP0049_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-ef38314d | (진입점 미연결) | FP01883_Instance_Authority.cs:935 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-46aa0067 | (진입점 미연결) | FP01883_Instance_Authority.cs:936 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-b8432b3b | (진입점 미연결) | FP01883_Instance_Authority.cs:938 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0781184 | (진입점 미연결) | FP01883_Instance_Authority.cs:938 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.GetUserTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e0b3edb | (진입점 미연결) | FP01883_Instance_Authority.cs:856 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_USER_TITLE") ⇒ SCP.SCP0049_GET_SHEET_USER_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-831ed0bc | (진입점 미연결) | FP01883_Instance_Authority.cs:858 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0049" | 행/컬럼 값 대입 |  |  |  |
| AC-28c5234e | (진입점 미연결) | FP01883_Instance_Authority.cs:859 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-87288979 | (진입점 미연결) | FP01883_Instance_Authority.cs:860 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e488357b | (진입점 미연결) | FP01883_Instance_Authority.cs:862 |  | FLAG | dsUserTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3de75af4 | (진입점 미연결) | FP01883_Instance_Authority.cs:862 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## FP01883_Instance_Authority.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1169bff9 | this.Load | FP01883_Instance_Authority.cs:171 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1dd5f040 | this.Load | FP01883_Instance_Authority.cs:184 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01883_INSTANCE_AUTHORITY", "APPROVE_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2232f590 | this.Load | FP01883_Instance_Authority.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtApproveType, cbApproval, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01883_Instance_Authority.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70741073 | this.Load | FP01883_Instance_Authority.cs:286 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-17fe2afc | this.Load | FP01883_Instance_Authority.cs:288 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2445c4dc | this.Load | FP01883_Instance_Authority.cs:289 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, iColumnHeaderCount) | 그리드 재구성/초기화 |  |  |  |

## FP01883_Instance_Authority.InsertData_Main

진입점: this.btn_Add.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96421689 | this.btn_Add.Click | FP01883_Instance_Authority.cs:732 | if (node == null) | MESSAGE | MessageBox.Show | ("You must select a auth Folder to create authority") | 메시지 표시 |  |  |  |
| AC-51511e38 | this.btn_Add.Click | FP01883_Instance_Authority.cs:733 | if (node == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-680d3338 | this.btn_Add.Click | FP01883_Instance_Authority.cs:738 | if (row == null) | MESSAGE | MessageBox.Show | ("You must select a auth Folder to create authority") | 메시지 표시 |  |  |  |
| AC-08536f7c | this.btn_Add.Click | FP01883_Instance_Authority.cs:739 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20aa86c6 | this.btn_Add.Click | FP01883_Instance_Authority.cs:743 | if (row["LVL"].ToString() != "2") | MESSAGE | MessageBox.Show | ("You must select a auth Folder to create authority") | 메시지 표시 |  |  |  |
| AC-cf7a5995 | this.btn_Add.Click | FP01883_Instance_Authority.cs:744 | if (row["LVL"].ToString() != "2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1327bed7 | this.btn_Add.Click | FP01883_Instance_Authority.cs:751 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | dsMain.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-390dea80 | this.btn_Add.Click | FP01883_Instance_Authority.cs:753 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["ROLE_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-88055de2 | this.btn_Add.Click | FP01883_Instance_Authority.cs:754 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["ROLE_DESCR"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ff711fa0 | this.btn_Add.Click | FP01883_Instance_Authority.cs:755 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["INSERT_DTTM"] | newRow["UPDATE_DTTM"] = DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c3936f71 | this.btn_Add.Click | FP01883_Instance_Authority.cs:755 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["UPDATE_DTTM"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-17df4841 | this.btn_Add.Click | FP01883_Instance_Authority.cs:756 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["INSERT_ID"] | newRow["UPDATE_ID"] = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-62d7b3b4 | this.btn_Add.Click | FP01883_Instance_Authority.cs:756 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["UPDATE_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f776b209 | this.btn_Add.Click | FP01883_Instance_Authority.cs:757 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["ROLE_ID"] | nNewRoleID | 행/컬럼 값 대입 |  |  |  |
| AC-eaf979f3 | this.btn_Add.Click | FP01883_Instance_Authority.cs:758 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["UPPER_ROLE_ID"] | row["ROLE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-02189fe5 | this.btn_Add.Click | FP01883_Instance_Authority.cs:759 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["LVL"] | "3" | 행/컬럼 값 대입 |  |  |  |
| AC-867abf90 | this.btn_Add.Click | FP01883_Instance_Authority.cs:760 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["APPROVAL_EXCEPTION_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-2af51a65 | this.btn_Add.Click | FP01883_Instance_Authority.cs:761 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | newRow["_STATUS"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-218edcb8 | this.btn_Add.Click | FP01883_Instance_Authority.cs:763 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | DATA_OP | node.Nodes.Insert | (0, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddf20123 | this.btn_Add.Click | FP01883_Instance_Authority.cs:764 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | UI_PROP | added.Tag | newRow | 속성 Tag 설정 |  |  |  |
| AC-7caf6335 | this.btn_Add.Click | FP01883_Instance_Authority.cs:765 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | UI_PROP | utriMain.SelectedNode | added | 속성 SelectedNode 설정 |  |  |  |
| AC-57892e9e | this.btn_Add.Click | FP01883_Instance_Authority.cs:769 | if (utriMain.DataSource != null) ▸ if (dsMain != null) | FLAG | nNewRoleID | nNewRoleID++ | 화면 필드 증감 |  |  |  |

## FP01883_Instance_Authority.ReadSelection

진입점: this.Load [try] / utriMain.AfterSelect / this.btn_Save.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try] / this.btn_Del.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try] / this.btn_AuthFolder.Click [if (popItem.ShowDialog() == DialogResult.OK) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7dbcfa7 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:409 | try | VALUE_SET | txtAuthority.Text | row["ROLE_ID"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-4cc38028 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:410 | try | VALUE_SET | txtAuthorityName2.Text | row["ROLE_NAME"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-51a35070 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:411 | try | VALUE_SET | txtAuthDesc.Text | row["ROLE_DESCR"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-317fbebb | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:412 | try | VALUE_SET | txtUpperAuth.Text | row["UPPER_ROLE_NAME"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-00811342 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:413 | try | VALUE_SET | cbApproval.Text | row["APPROVAL_EXCEPTION_FLAG"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-3105f12b | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:414 | try | VALUE_SET | txtInsert.Text | row["INSERT_ID"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-617a2378 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:415 | try | VALUE_SET | txtUpdate.Text | row["UPDATE_ID"].SafeString() | 컨트롤 값 설정 |  |  |  |
| AC-8ca1693d | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:419 | try ▸ try | VALUE_SET | dtInsert.Value | DateTime.ParseExact(row["INSERT_DTTM"].SafeString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-afa339c6 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:423 | try ▸ catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBoxForException | (ee) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ccce999 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:430 | try ▸ try ▸ if (string.IsNullOrEmpty(row["UPDATE_DTTM"].SafeString())) | VALUE_SET | dtUpdate.Value | new DateTime(1900, 01, 01) | 컨트롤 값 설정 |  |  |  |
| AC-ec0e9505 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:434 | try ▸ try ▸ else of (string.IsNullOrEmpty(row["UPDATE_DTTM"].SafeString())) | VALUE_SET | dtUpdate.Value | DateTime.ParseExact(row["UPDATE_DTTM"].SafeString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-ce114943 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:437 | try ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-690838b6 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:441 | try ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-199ec7b9 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:445 | try ▸ catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBoxForException | (ee) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-733ddd14 | this.Load [try] 외 5 | FP01883_Instance_Authority.cs:451 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01883_Instance_Authority.Save_Data

진입점: this.btn_Save.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56d17139 | this.btn_Save.Click | FP01883_Instance_Authority.cs:701 | try | UI_PROP | dtsave.TableName | "ds1" | 속성 TableName 설정 |  |  |  |
| AC-a983d7e2 | this.btn_Save.Click | FP01883_Instance_Authority.cs:702 | try | DATA_OP | dtsave.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f79a5832 | this.btn_Save.Click | FP01883_Instance_Authority.cs:703 | try | DATA_OP | dtsave.Columns.SafeAdd | ("ROLE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95fb3126 | this.btn_Save.Click | FP01883_Instance_Authority.cs:704 | try | DATA_OP | dtsave.Columns.SafeAdd | ("ROLE_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-00ab7d94 | this.btn_Save.Click | FP01883_Instance_Authority.cs:705 | try | DATA_OP | dtsave.Columns.SafeAdd | ("UPPER_ROLE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a5ec81e | this.btn_Save.Click | FP01883_Instance_Authority.cs:706 | try | DATA_OP | dtsave.Columns.SafeAdd | ("ROLE_DESCR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e6df1e4 | this.btn_Save.Click | FP01883_Instance_Authority.cs:707 | try | DATA_OP | dtsave.Columns.SafeAdd | ("APPROVAL_EXCEPTION_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7c6673f | this.btn_Save.Click | FP01883_Instance_Authority.cs:709 | try | DATA_OP | dtsave.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-94e4e8f4 | this.btn_Save.Click | FP01883_Instance_Authority.cs:710 | try | GRID_SET | dtsave.Rows[0]["USER_ID"] | UserInfo.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-421d6a7a | this.btn_Save.Click | FP01883_Instance_Authority.cs:711 | try | GRID_SET | dtsave.Rows[0]["ROLE_ID"] | txtAuthority.Text | 그리드 속성/값 설정 |  |  |  |
| AC-cb4c9735 | this.btn_Save.Click | FP01883_Instance_Authority.cs:712 | try | GRID_SET | dtsave.Rows[0]["ROLE_NAME"] | txtAuthorityName2.Text | 그리드 속성/값 설정 |  |  |  |
| AC-6acae5d8 | this.btn_Save.Click | FP01883_Instance_Authority.cs:713 | try | GRID_SET | dtsave.Rows[0]["UPPER_ROLE_ID"] | row["UPPER_ROLE_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-eee5352b | this.btn_Save.Click | FP01883_Instance_Authority.cs:714 | try | GRID_SET | dtsave.Rows[0]["ROLE_DESCR"] | txtAuthDesc.Text | 그리드 속성/값 설정 |  |  |  |
| AC-57711d54 | this.btn_Save.Click | FP01883_Instance_Authority.cs:715 | try | GRID_SET | dtsave.Rows[0]["APPROVAL_EXCEPTION_FLAG"] | cbApproval.Text | 그리드 속성/값 설정 |  |  |  |
| AC-a94fc0ef | this.btn_Save.Click | FP01883_Instance_Authority.cs:717 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP01883_Instance_Authority", "merge_data", dtsave, 0, "Admin") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Admin\FP01883_… | 엔드포인트 호출 |  |  |  |
| AC-57ca8d0f | this.btn_Save.Click | FP01883_Instance_Authority.cs:719 | try | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-76dcb574 | this.btn_Save.Click | FP01883_Instance_Authority.cs:723 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.Save_Data_Execute

진입점: this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b026bef5 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1658 | try | DATA_OP | dtmain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-93cbc4e5 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1659 | try | CALL_EXT | removed.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08b7103f | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1667 | try ▸ foreach (DataRow row in dtmain.Rows) ▸ if (action == CAppSetting.FlagD) | DATA_OP | removed.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-565bca6f | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1668 | try ▸ foreach (DataRow row in dtmain.Rows) ▸ if (action == CAppSetting.FlagD) | UI_PROP | newrow.ItemArray | row.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-8e710311 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1674 | try | CALL_EXT | dtmain.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8105c886 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1683 | try ▸ if (sType == "INSTANCE") ▸ if (dtmain.Good()) ▸ if (dtmain.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01883_Instance_Authority", "saveAll_InstanceInfo", dtmain, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_InstanceInfo] \| FP\ADMI… | 엔드포인트 호출 |  |  |  |
| AC-732bb373 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1687 | try ▸ if (sType == "INSTANCE") ▸ if (removed.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01883_Instance_Authority", "delete_InstanceInfo", removed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_InstanceInfo] \| FP\ADMIN… | 엔드포인트 호출 |  |  |  |
| AC-bdef7e8d | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1694 | try ▸ else of (sType == "INSTANCE") ▸ if (dtmain.Good()) ▸ if (dtmain.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01883_Instance_Authority", "saveAll_UserInfo", dtmain, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_UserInfo] \| FP\ADMIN\FP… | 엔드포인트 호출 |  |  |  |
| AC-be002a50 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1698 | try ▸ else of (sType == "INSTANCE") ▸ if (removed.Rows.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01883_Instance_Authority", "delete_UserInfo", removed, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_UserInfo] \| FP\ADMIN\FP0… | 엔드포인트 호출 |  |  |  |
| AC-45314eb2 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1706 | try ▸ if (ret2 != null && ret2.DataSet == null) ▸ if (ret2.Rows[0][0].ToString() == "SUCCESS") | DATA_OP | dtrtn.Tables.Add | (ret2) | 데이터 객체 조작/조회 |  |  |  |
| AC-be33965a | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1708 | try ▸ if (ret2 != null && ret2.DataSet == null) ▸ if (ret2.Rows[0][0].ToString() == "SUCCESS") | RETURN | return dtrtn; |  | 처리 중단/반환 |  |  |  |
| AC-3b0bfeff | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1712 | try ▸ if (ret2 != null && ret2.DataSet == null) ▸ else of (ret2.Rows[0][0].ToString() == "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3a57a55c | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1716 | try | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-40a36884 | this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0… | FP01883_Instance_Authority.cs:1720 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.SaveData_Main

진입점: this.btn_Save.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5773d907 | this.btn_Save.Click | FP01883_Instance_Authority.cs:654 | if (string.IsNullOrEmpty(txtAuthority.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf530116 | this.btn_Save.Click | FP01883_Instance_Authority.cs:662 |  | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cdd2c7d5 | this.btn_Save.Click | FP01883_Instance_Authority.cs:666 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ba294034 | this.btn_Save.Click | FP01883_Instance_Authority.cs:680 | if (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f3c4449e | this.btn_Save.Click | FP01883_Instance_Authority.cs:683 | if (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74397ff9 | this.btn_Save.Click | FP01883_Instance_Authority.cs:687 | else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) | MESSAGE | MessageBox.Show | (sMsg + " Is Saved.! ") | 메시지 표시 |  |  |  |

## FP01883_Instance_Authority.Set_RefreshAfterSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c53637f0 | (진입점 미연결) | FP01883_Instance_Authority.cs:980 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-05157d75 | (진입점 미연결) | FP01883_Instance_Authority.cs:985 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |

## FP01883_Instance_Authority.SetEditMode

진입점: this.Load [try ▸ try ▸ try ▸ try] / utriMain.AfterSelect [try ▸ try ▸ try] / this.btn_Save.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try ▸ try] / this.btn_Del.Click [else of (!string.IsNullOrEmpty(sError) \|\| dsRtn == null) ▸ try ▸ try ▸ try ▸ try] / this.btn_SaveDetail.Click [if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btn_AuthFolder.Click [if (popItem.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ try ▸ try] / FindButton [try ▸ try ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82675cc2 | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1742 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd940516 | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1745 | if (spdMain != null) ▸ if (!siTarget.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4366fdbb | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1750 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5489225c | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1762 | if (spdMain != null) ▸ if (isEdit) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ for (i < rowcount) | GRID_SET | siMain.ActiveSheet.Cells[i, reqIdx].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-94234eb5 | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1766 | if (spdMain != null) ▸ if (isEdit) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (10, 10, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f20d7b09 | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1774 | if (spdMain != null) ▸ if (isEdit) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ for (i < rowcount) | GRID_SET | siMain.ActiveSheet.Cells[i, reqIdx].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7fc5e001 | this.Load [try ▸ try ▸ try ▸ try] 외 7 | FP01883_Instance_Authority.cs:1777 | if (spdMain != null) ▸ if (isEdit) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (4, 5, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01883_Instance_Authority.setFlag

진입점: this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸ else of (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USE_AT_FLAG)) ▸ if (action == "")] / this.btn_AddDetail.Click [if (spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56645817 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1814 | switch (Flag) case CAppSetting.FlagI: case CAppSetting.FlagA: | GRID_STYLE | siTmp.SetFGColor | (sRow, 0, eRow, 0, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-a3bc8496 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1815 | switch (Flag) case CAppSetting.FlagI: case CAppSetting.FlagA: | GRID_SET | siTmp.SetText | (sRow, 0, CAppSetting.FlagI) | 그리드 값 설정 |  |  |  |
| AC-7d8bc81c | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1816 | switch (Flag) case CAppSetting.FlagI: case CAppSetting.FlagA: | GRID_STYLE | siTmp.SetBGColor | (sRow, 0, eRow, 0, Color.Blue) | 그리드 표시 설정 |  |  |  |
| AC-bafe6923 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1821 | switch (Flag) case CAppSetting.FlagM: | GRID_STYLE | siTmp.SetFGColor | (sRow, 0, eRow, 0, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-95691337 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1822 | switch (Flag) case CAppSetting.FlagM: | GRID_SET | siTmp.SetText | (sRow, 0, CAppSetting.FlagM) | 그리드 값 설정 |  |  |  |
| AC-70078cc8 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1823 | switch (Flag) case CAppSetting.FlagM: | GRID_STYLE | siTmp.SetBGColor | (sRow, 0, eRow, 0, Color.DarkGray) | 그리드 표시 설정 |  |  |  |
| AC-2e55b35d | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1828 | switch (Flag) case CAppSetting.FlagD: | GRID_STYLE | siTmp.SetFGColor | (sRow, 0, eRow, 0, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-cc92d0d0 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1829 | switch (Flag) case CAppSetting.FlagD: | GRID_SET | siTmp.SetText | (sRow, 0, CAppSetting.FlagD) | 그리드 값 설정 |  |  |  |
| AC-0c3ffc74 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1830 | switch (Flag) case CAppSetting.FlagD: | GRID_STYLE | siTmp.SetBGColor | (sRow, 0, eRow, 0, Color.Red) | 그리드 표시 설정 |  |  |  |
| AC-ddd56574 | this.spdMain.CellClick [if (spdMain.ActiveSheetIndex == 0) ▸… 외 1 | FP01883_Instance_Authority.cs:1835 |  | UI_MISC | siTmp.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01883_Instance_Authority.SetSpreadColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92eb4824 | (진입점 미연결) | FP01883_Instance_Authority.cs:1142 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-95b5e921 | (진입점 미연결) | FP01883_Instance_Authority.cs:1145 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP01883_Instance_Authority.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ede0be9f | (진입점 미연결) | FP01883_Instance_Authority.cs:323 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 2, dsUserTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |

## FP01883_Instance_Authority.shtMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb6b8022 | dsdm.Changed | FP01883_Instance_Authority.cs:1347 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbdf09ec | dsdm.Changed | FP01883_Instance_Authority.cs:1349 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e60f7b5f | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1182 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (!sitmp.ActiveSheet.Columns[CAppSetti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ff9f5c8 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1187 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc19e56d | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1196 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) | POPUP | new FP01883_NewInstancePop | (sFact, sName) | 팝업/폼 생성 |  |  |  |
| AC-8c32e282 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1197 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) | UI_PROP | popInst.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-182826d9 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1198 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) | POPUP | popInst.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a7124b7 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1203 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.INSTANCE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e97944df | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1204 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.COMPANY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2372ee8 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1205 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4649533d | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1206 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-82a8faf2 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1207 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc29c427 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1208 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.FACTORY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee0083d3 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1209 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | DATA_OP | each_row.Field | (DefColumns.PLAN_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-83d36cd3 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1214 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | MESSAGE | MessageBox.Show | ("중복된 데이터가 존재합니다.") | 메시지 표시 |  |  |  |
| AC-43b7674c | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1215 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ed96e0e | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1218 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.INSTANCE_ID] | popInst._InstanceId | 그리드 속성/값 설정 |  |  |  |
| AC-6611cc3d | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1219 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.COMPANY_ID] | popInst._CompanyId | 그리드 속성/값 설정 |  |  |  |
| AC-c950e287 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1220 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.DIVISION_ID] | popInst._DivisionId | 그리드 속성/값 설정 |  |  |  |
| AC-010d677a | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1221 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.SITE_ID] | popInst._SiteId | 그리드 속성/값 설정 |  |  |  |
| AC-f353bcee | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1222 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.PLANT_ID] | popInst._PlantId | 그리드 속성/값 설정 |  |  |  |
| AC-9dd241fa | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1223 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.FACTORY_ID] | popInst._FactoryId | 그리드 속성/값 설정 |  |  |  |
| AC-e6de36e2 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1224 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.FACTORY_NAME] | popInst._FactoryName | 그리드 속성/값 설정 |  |  |  |
| AC-f568566e | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1225 | if (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (popInst.DialogResult == DialogResult… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.PLAN_GROUP_ID] | popInst._PlanGroupId | 그리드 속성/값 설정 |  |  |  |
| AC-bedc9b2a | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1231 | if (spdMain.ActiveSheetIndex == 0) ▸ else of (e.Column == sitmp.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ if (e.Column == sitmp.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98c2b0f3 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1248 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (!sitmp.ActiveSheet.Columns[CAp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-821d7a48 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1253 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdb78092 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1261 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e5dda479 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1263 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) | UI_PROP | popup.Width | 900 | 속성 Width 설정 |  |  |  |
| AC-e6809843 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1264 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-fa67404f | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1265 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-94bd6835 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1267 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-76b5d14b | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1271 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (popup.ShowDialog() == DialogRe… | DATA_OP | each_row.Field | (DefColumns.USER_ID_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-03e3f915 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1276 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (popup.ShowDialog() == DialogRe… | MESSAGE | MessageBox.Show | ("중복된 데이터가 존재합니다.") | 메시지 표시 |  |  |  |
| AC-b2e44d67 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1277 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (popup.ShowDialog() == DialogRe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e58e62ca | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1280 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (popup.ShowDialog() == DialogRe… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.USER_ID_2] | popup.SelectedUserInfoList[0].UserID | 그리드 속성/값 설정 |  |  |  |
| AC-f529a344 | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1281 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (popup.ShowDialog() == DialogRe… | GRID_SET | dsTmp.Tables[0].Rows[iRow][DefColumns.USER_NAME_2] | popup.SelectedUserInfoList[0].UserName | 그리드 속성/값 설정 |  |  |  |
| AC-1fcf7c5d | this.spdMain.CellClick | FP01883_Instance_Authority.cs:1289 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (e.Column == sitmp.GetColumnIndex(DefColumns.USER_NAME_2)) ▸ if (e.Column == sitmp.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01883_Instance_Authority.SwitchEdit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce9224fb | (진입점 미연결) | FP01883_Instance_Authority.cs:1735 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP01883_Instance_Authority.UtriMain_AfterSelect

진입점: utriMain.AfterSelect

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af5eaf74 | utriMain.AfterSelect | FP01883_Instance_Authority.cs:374 | if (selected == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7171e1ca | utriMain.AfterSelect | FP01883_Instance_Authority.cs:375 |  | UI_PROP | selected.BackColor | Color.Blue | 속성 BackColor 설정 |  |  |  |
| AC-ad915606 | utriMain.AfterSelect | FP01883_Instance_Authority.cs:376 |  | UI_PROP | selected.ForeColor | Color.White | 속성 ForeColor 설정 |  |  |  |
| AC-23d2bcac | utriMain.AfterSelect | FP01883_Instance_Authority.cs:379 | if (prev != null) | UI_PROP | prev.BackColor | Color.Transparent | 속성 BackColor 설정 |  |  |  |
| AC-acebda4a | utriMain.AfterSelect | FP01883_Instance_Authority.cs:380 | if (prev != null) | UI_PROP | prev.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-bd95793b | utriMain.AfterSelect | FP01883_Instance_Authority.cs:386 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8103393c | utriMain.AfterSelect | FP01883_Instance_Authority.cs:390 |  | FLAG | prev | selected | 화면 필드/플래그 변경 |  |  |  |

## FP01883_NewInstancePop..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5452b7d9 | .ctor | FP01883_NewInstancePop.cs:149 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ffc5b70c | .ctor | FP01883_NewInstancePop.cs:150 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |

## FP01883_NewInstancePop.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9c000aa | this.btnButtonList.UsrButtonList_Click_Detected | FP01883_NewInstancePop.cs:401 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-55f956c6 | this.btnButtonList.UsrButtonList_Click_Detected | FP01883_NewInstancePop.cs:404 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01883_NewInstancePop.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2312112e | this.Load | FP01883_NewInstancePop.cs:250 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37e9dd84 | this.Load | FP01883_NewInstancePop.cs:251 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ba8ee94 | this.Load | FP01883_NewInstancePop.cs:252 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01883_NewInstancePop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d63e8747 | this.Load | FP01883_NewInstancePop.cs:245 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01883_NewInstancePop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fb890bb | Dispose | FP01883_NewInstancePop.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01883_NewInstancePop.Find_Data_Line

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c648383 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:374 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01883_Instance_Authority", "find_newInstance", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_newInstance] \| FP\Admin\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2d0f5399 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:375 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-c111d285 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:379 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01883_NewInstancePop.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b2bd41a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:326 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f50d87c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:334 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a2840d1d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:336 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-80d03334 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:338 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-230d8ceb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01883_NewInstancePop.cs:362 | catch ((Exception ee)) | MESSAGE | MessageBox.Show | (ee.Message) | 메시지 표시 |  |  |  |

## FP01883_NewInstancePop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29c624c5 | this.Load | FP01883_NewInstancePop.cs:158 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f8d25b6e | this.Load | FP01883_NewInstancePop.cs:160 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01883_NewInstancePop.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a7976ac | this.Load | FP01883_NewInstancePop.cs:262 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2997da0a | this.Load | FP01883_NewInstancePop.cs:263 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01883_NewInstancePop.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52f7ee70 | (진입점 미연결) | FP01883_NewInstancePop.cs:285 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01883_NewInstancePop.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-091ce3cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:444 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19884e17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:445 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab232828 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:446 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0acb20f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:447 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f5d9c3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:448 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b66f3b90 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:449 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1ea6779 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:450 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e0db6fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01883_NewInstancePop.cs:453 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01883_NewInstancePop.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-598ffa0b | this.Load | FP01883_NewInstancePop.cs:269 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-446d4268 | this.Load | FP01883_NewInstancePop.cs:270 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-169926c1 | this.Load | FP01883_NewInstancePop.cs:274 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f8b22485 | this.Load | FP01883_NewInstancePop.cs:276 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SITE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01883_NewInstancePop.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46afd148 | this.spdMain.CellClick | FP01883_NewInstancePop.cs:415 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP01883_NewInstancePop.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddaf59b7 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:420 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8aac4130 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:422 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f43dd642 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:424 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-72b948c5 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:425 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e6364999 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:426 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d3e5ef80 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:427 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-51b4633b | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:428 |  | FLAG | _FactoryId | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a60c494 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:429 |  | FLAG | _FactoryName | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-74597501 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:430 |  | FLAG | _PlanGroupId | this.dtFindData.Rows[e.Row][DefColumns.PLAN_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-12505be7 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:431 |  | FLAG | _InstanceId | this.dtFindData.Rows[e.Row][DefColumns.INSTANCE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2dbdf9b7 | this.spdMain.CellDoubleClick | FP01883_NewInstancePop.cs:434 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

