# AS-IS 액션 대조표 — SCP0055

> 원천: `Doc/asisfacts/screens/SCP0055/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 235행 · 메서드 34 · 종류 GRID_INIT 45 · DATA_OP 44 · GRID_SET 26 · CALL_EXT 18 · FLAG 14 · RETURN 12 · MESSAGE 10 · ENDPOINT 10 · UI_PROP 9 · LIST_REBIND 9 · POPUP 8 · VALUE_SET 8 · UI_MISC 6 · COMBO_DATA 5 · STATE 4 · GRID_LOCK 3 · EXCEL 2 · VALIDATE 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 18


## SCP0055_Shipment_Allo_Report.btnModel_ID_Click

진입점: this.btnModel_ID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cec6a85 | this.btnModel_ID.Click | SCP0055_Shipment_Allo_Report.cs:1378 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7cbe7b27 | this.btnModel_ID.Click | SCP0055_Shipment_Allo_Report.cs:1380 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-00a8a5a5 | this.btnModel_ID.Click | SCP0055_Shipment_Allo_Report.cs:1382 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ab59e850 | this.btnModel_ID.Click | SCP0055_Shipment_Allo_Report.cs:1383 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-753c0714 | this.btnModel_ID.Click | SCP0055_Shipment_Allo_Report.cs:1384 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c97b82d0 | this.btnModel_ID.Click | SCP0055_Shipment_Allo_Report.cs:1389 | if (popItem.ItemID != "") | VALUE_SET | txtModel_ID.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.btnNickName_Click

진입점: this.btnNickName.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed7d270e | this.btnNickName.Click | SCP0055_Shipment_Allo_Report.cs:1401 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-265a8d9f | this.btnNickName.Click | SCP0055_Shipment_Allo_Report.cs:1403 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-31ebc5d8 | this.btnNickName.Click | SCP0055_Shipment_Allo_Report.cs:1405 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-db1af21f | this.btnNickName.Click | SCP0055_Shipment_Allo_Report.cs:1406 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6a9799d5 | this.btnNickName.Click | SCP0055_Shipment_Allo_Report.cs:1407 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b88f79c4 | this.btnNickName.Click | SCP0055_Shipment_Allo_Report.cs:1414 | if (popItem.NickName != "") | VALUE_SET | txtNickName.Text | sNickName | 컨트롤 값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.cboPlanDate_SelectedIndexChanged

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.cboPlanDate.SelectedIndexChanged / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74e2e6f0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:1361 | if (cboGapDate.Items.Count > cboPlanDate.SelectedIndex + 1) | VALUE_SET | cboGapDate.SelectedIndex | cboPlanDate.SelectedIndex + 1 | 컨트롤 값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3815c77 | this.Load | SCP0055_Shipment_Allo_Report.cs:374 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-94e2ab2a | this.Load | SCP0055_Shipment_Allo_Report.cs:375 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-928e1fbb | this.Load | SCP0055_Shipment_Allo_Report.cs:376 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aadd0075 | this.Load | SCP0055_Shipment_Allo_Report.cs:378 |  | GRID_INIT | this.AddSheet | (spdGap, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-758324ee | this.Load | SCP0055_Shipment_Allo_Report.cs:379 |  | FLAG | siGap | GetSheetInfo(spdGap.Name, spdGap.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1e768ae | this.Load | SCP0055_Shipment_Allo_Report.cs:380 |  | GRID_INIT | siGap.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0055_Shipment_Allo_Report.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ececd937 | this.Load | SCP0055_Shipment_Allo_Report.cs:137 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-eded50ac | this.Load | SCP0055_Shipment_Allo_Report.cs:138 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-e1912354 | this.Load | SCP0055_Shipment_Allo_Report.cs:140 |  | VALUE_SET | cboCellTypeGr.SelectedValue | CellTypeGroupType.Cyl | 컨트롤 값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-769ee081 | Dispose | SCP0055_Shipment_Allo_Report.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0055_Shipment_Allo_Report.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb59241f | EditButton | SCP0055_Shipment_Allo_Report.cs:499 | if (fps != null) | UI_PROP | rtb.Multiline | true | 속성 Multiline 설정 |  |  |  |
| AC-5421ba36 | EditButton | SCP0055_Shipment_Allo_Report.cs:500 | if (fps != null) | UI_PROP | rtb.WordWrap | true | 속성 WordWrap 설정 |  |  |  |
| AC-29e1c2aa | EditButton | SCP0055_Shipment_Allo_Report.cs:502 | if (fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8eb384d9 | EditButton | SCP0055_Shipment_Allo_Report.cs:503 | if (fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f242f125 | EditButton | SCP0055_Shipment_Allo_Report.cs:505 | if (fps != null) | GRID_LOCK | siMain.LockColumn | (iColIdx_FROM_SITE, iColIdx_GAP, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a1caa5b | EditButton | SCP0055_Shipment_Allo_Report.cs:515 | if (fps != null) ▸ for (i < svMain.RowCount) ▸ if (string.IsNullOrEmpty(svMain.Cells[i, iColIdx_DEPT_NAME].Text)) | GRID_SET | svMain.Cells[i, iColIdx_NOTE].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.ElectrodeDashReplace

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae5839be | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1338 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f5acc10 | ExcelButton | SCP0055_Shipment_Allo_Report.cs:1506 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c46b3e90 | ExcelButton | SCP0055_Shipment_Allo_Report.cs:1509 | if (result == DialogResult.Yes) | EXCEL | ExportExcel | (true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-28ee7ad5 | ExcelButton | SCP0055_Shipment_Allo_Report.cs:1511 | else of (result == DialogResult.Yes) ▸ if (result == DialogResult.No) | EXCEL | ExportExcel | (false) | 엑셀 내보내기/올리기 |  |  |  |
| AC-d8ab4623 | ExcelButton | SCP0055_Shipment_Allo_Report.cs:1513 | else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == spdMain.Name)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d417a323 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:546 | if (DateTime.Compare(dtFrom, dtTo) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00344") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eac565a4 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:547 | if (DateTime.Compare(dtFrom, dtTo) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dab2e76b | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:553 | if (DateTime.Compare(dtMain, dtGap) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00345") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7e32952 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:554 | if (DateTime.Compare(dtMain, dtGap) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e608c75 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:574 | if (DateTime.Compare(dtMain, dtGap) == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00348") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-581d0295 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:575 | if (DateTime.Compare(dtMain, dtGap) == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de56d3d5 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:579 |  | FLAG | giColIdx_Total | InitSpreadDateColumn(siMain, siMain.nIdxData, cboPlanDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-171c522c | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:589 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1621fa55 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:593 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-718d596a | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:595 | try | VALUE_SET | ulPlanType_Seq1.Text | RefreshGrid(spdMain.ActiveSheet, cboPlanDate) | 컨트롤 값 설정 |  |  |  |
| AC-4db757c5 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:597 | try | VALUE_SET | ulPlanType_Seq2.Text | RefreshGrid(spdGap.ActiveSheet, cboGapDate) | 컨트롤 값 설정 |  |  |  |
| AC-8317233b | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:608 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed2ee65d | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:610 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e591450 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:612 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-37404149 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:617 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a13e6278 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:619 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ad08034 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:623 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7eadfa38 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:624 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0055_Shipment_Allo_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5efa320a | this.Load | SCP0055_Shipment_Allo_Report.cs:127 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0055_Shipment_Allo_Report.Get_IsSaveYn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb563ffb | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1316 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c60ea30 | this.Load | SCP0055_Shipment_Allo_Report.cs:271 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-2d93f278 | this.Load | SCP0055_Shipment_Allo_Report.cs:272 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03a68bee | this.Load | SCP0055_Shipment_Allo_Report.cs:274 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffe606b2 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1348 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dfb88e2 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1350 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.GetIsEditable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75553f03 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1309 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bd7b947 | this.Load | SCP0055_Shipment_Allo_Report.cs:145 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7874dd32 | this.Load | SCP0055_Shipment_Allo_Report.cs:147 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-74a37297 | this.Load | SCP0055_Shipment_Allo_Report.cs:150 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-09e5c43d | this.Load | SCP0055_Shipment_Allo_Report.cs:152 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c7cde4c5 | this.Load | SCP0055_Shipment_Allo_Report.cs:154 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-b0177382 | this.Load | SCP0055_Shipment_Allo_Report.cs:154 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f089ca9c | this.Load | SCP0055_Shipment_Allo_Report.cs:155 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-35f919ca | this.Load | SCP0055_Shipment_Allo_Report.cs:157 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d4cbcde5 | this.Load | SCP0055_Shipment_Allo_Report.cs:158 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16ef34f0 | this.Load | SCP0055_Shipment_Allo_Report.cs:170 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2ebcc0b6 | this.Load | SCP0055_Shipment_Allo_Report.cs:172 |  | UI_PROP | umpMonthFrom.MonthText | DateTime.Now.AddMonths(-3).ToString("yyyyMM") | 속성 MonthText 설정 |  |  |  |
| AC-dffaeefa | this.Load | SCP0055_Shipment_Allo_Report.cs:173 |  | UI_PROP | umpMonthTo.MonthText | DateTime.Now.AddMonths(3).ToString("yyyyMM") | 속성 MonthText 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.InitSpread

진입점: this.Load / FindButton / SaveButton [if (fps.Name == spdMain.Name)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf81bd48 | this.Load 외 2 | SCP0055_Shipment_Allo_Report.cs:389 |  | GRID_INIT | spreadInfo.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f60e6b98 | this.Load 외 2 | SCP0055_Shipment_Allo_Report.cs:390 |  | GRID_INIT | spreadInfo.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0055_Shipment_Allo_Report.InitSpreadDateColumn

진입점: FindButton / SaveButton [if (fps.Name == spdMain.Name)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13068558 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:188 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-6ccd0198 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:200 | while (dtCurrent <= dtTo) ▸ if ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) | GRID_INIT | spdInfo.AddNumColumn | (sCurLabel, sCurColName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4f68533 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:201 | while (dtCurrent <= dtTo) ▸ if ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sCurColName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-90c19aaf | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:203 | while (dtCurrent <= dtTo) ▸ if ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-66d6fdd2 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:204 | while (dtCurrent <= dtTo) ▸ if ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month))) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, "Result") | 그리드 재구성/초기화 |  |  |  |
| AC-e245f05b | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:209 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.AddNumColumn | (sCurLabel, sCurColName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e376cf6c | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:210 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sCurColName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8d6ac31c | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:212 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-1295f673 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:213 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, "Plan") | 그리드 재구성/초기화 |  |  |  |
| AC-ddda3fc9 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:218 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.AddNumColumn | (sCurLabel, sCurColName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4775717 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:219 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sCurColName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-92daff6e | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:221 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-3c68310e | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:222 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, "Result") | 그리드 재구성/초기화 |  |  |  |
| AC-93655da8 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:225 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.AddNumColumn | (sCurLabel, sCurColName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cc6e42c | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:226 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sCurColName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-097b6af5 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:228 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-a613406e | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:229 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, "Plan") | 그리드 재구성/초기화 |  |  |  |
| AC-ead004ce | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:232 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.AddNumColumn | (sCurLabel, sCurColName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ada93676 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:233 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sCurColName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ad8f57b4 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:235 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, sCurLabel) | 그리드 재구성/초기화 |  |  |  |
| AC-08424d83 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:236 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurIdx, "Total") | 그리드 재구성/초기화 |  |  |  |
| AC-e2ac20b1 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:239 | while (dtCurrent <= dtTo) ▸ else of ((dtCurrent.Year < dtBase.Year) \|\| ((dtCurrent.Year == dtBase.Year) && (dtCurrent.Month < dtBase.Month… | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurIdx-2, 1, 3, 20, sCurLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68587210 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:247 |  | GRID_INIT | spdInfo.AddNumColumn | ("SUBTOTAL", "SUBTOTAL", FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f081b2f9 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:248 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex("SUBTOTAL"), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-22613b1c | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:249 |  | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, "소계") | 그리드 재구성/초기화 |  |  |  |
| AC-b505ed6c | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:250 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurIdx, 2, 1, 20, "소계", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d2cd621 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:254 |  | GRID_INIT | spdInfo.AddNumColumn | ("GAP", "GAP", FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb737691 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:255 |  | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex("GAP"), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-49e56ffe | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:256 |  | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, "GAP") | 그리드 재구성/초기화 |  |  |  |
| AC-641051e8 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:257 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurIdx, 2, 1, 20, "GAP", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60a8f80d | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:261 |  | GRID_INIT | spdInfo.AddTextColumn | ("비고", "비고", FPMerge.None, 200, true, FPHAlign.Left, FPVAlign.Center, false, false, 500) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-622359d8 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:262 |  | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurIdx, "비고") | 그리드 재구성/초기화 |  |  |  |
| AC-e2d7611d | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:263 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurIdx, 2, 1, 20, "비고", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f5fda94 | FindButton 외 1 | SCP0055_Shipment_Allo_Report.cs:265 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.MergeGrid

진입점: FindButton [try] / SaveButton [if (fps.Name == spdMain.Name) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2d0f9f3 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:703 | try ▸ for (i < svGap.RowCount) | CALL_EXT | svMain.AddRows | (iRowIdx_Main+1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-436245d9 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:706 | try ▸ for (i < svGap.RowCount) ▸ for (j <= iColIdx_DEPT_NAME) | GRID_SET | svMain.Cells[iRowIdx_Main + 1, j].Value | svGap.Cells[i, j].Value | 그리드 속성/값 설정 |  |  |  |
| AC-3468291a | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:717 | try | CALL_EXT | svMain.SortRows | (0, svMain.RowCount, si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88b70562 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:718 | try | CALL_EXT | svGap.SortRows | (0, svGap.RowCount, si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba8bf341 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:726 | try ▸ for (i <= iColIdx_DEPT_NAME) | GRID_SET | svMain.Columns[i].Width | svMain.Columns[i].GetPreferredWidth() + 10 | 그리드 속성/값 설정 |  |  |  |
| AC-95964126 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:726 | try ▸ for (i <= iColIdx_DEPT_NAME) | CALL_EXT | svMain.Columns[i].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3caaf9dc | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:727 | try ▸ for (i <= iColIdx_DEPT_NAME) | GRID_SET | svGap.Columns[i].Width | svGap.Columns[i].GetPreferredWidth() + 10 | 그리드 속성/값 설정 |  |  |  |
| AC-27d5eaa4 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:727 | try ▸ for (i <= iColIdx_DEPT_NAME) | CALL_EXT | svGap.Columns[i].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-732668c0 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:732 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0055_Shipment_Allo_Report.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92c77b1a | OnShown | SCP0055_Shipment_Allo_Report.cs:1461 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cdcd4770 | OnShown | SCP0055_Shipment_Allo_Report.cs:1464 |  | STATE | cboOperationGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0177706b | OnShown | SCP0055_Shipment_Allo_Report.cs:1467 |  | STATE | cboBucketType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9c92d968 | OnShown | SCP0055_Shipment_Allo_Report.cs:1470 |  | STATE | cboCellTypeGr.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc55257f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:304 | try ▸ if (!division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "OPERATION_GROUP" }, new List<string>() { division, o… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d842a725 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:308 | try ▸ else of (!division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "OPERATION_GROUP" }, new List<string>() { operationGroup }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-52a4b26d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:311 | try | FLAG | dtFromSiteCpy | DBUtils.Filter(dtFromSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff299fed | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:311 | try | DATA_OP | DBUtils.Filter | (dtFromSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1672ebcb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:313 | try | LIST_REBIND | clsCtrl.setListBox | (dtFromSiteCpy, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7fb74163 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0055_Shipment_Allo_Report.cs:318 | catch ((Exception ex)) | LIST_CLEAR | clbFromSite.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshGapDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4bd2616 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:339 |  | FLAG | dtGapDate | DBUtils.Filter(dtGapDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a1be97c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:339 |  | DATA_OP | DBUtils.Filter | (dtGapDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6dc6e42c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:341 |  | LIST_REBIND | clsCtrl.setListBox | (dtGapDate, cboGapDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshGrid

진입점: FindButton [try] / SaveButton [if (fps.Name == spdMain.Name) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b2adca5 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:776 | try | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f88b9bf4 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:779 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0055_GET_SHIPMENT_ALLO_PLAN") ⇒ SCP.SCP0055_GET_SHIPMENT_ALLO_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-3ba10a3e | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:781 | try | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4d66dd93 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:783 | try | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | dtFrom.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-982134f5 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:784 | try | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | dtTo.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0223bb0e | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:785 | try | DATA_OP | req.Parameters["P_DIVISION_ID"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-4eb6bd08 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:786 | try | DATA_OP | req.Parameters["P_BIZ_TYPE"] | p_OperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-8b41e7a2 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:787 | try | DATA_OP | req.Parameters["P_ITEM_ID"] | p_Model_ID | 행/컬럼 값 대입 |  |  |  |
| AC-dbca72a4 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:788 | try | DATA_OP | req.Parameters["P_CELL_TYPE_GR"] | p_cell_type_group | 행/컬럼 값 대입 |  |  |  |
| AC-079b23bb | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:789 | try | DATA_OP | req.Parameters["P_PLAN_START_YYYYMMDD"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d4d05335 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:790 | try | DATA_OP | req.Parameters["P_FROMSITE"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-f29ce8de | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:791 | try | DATA_OP | req.Parameters["P_TEAM_ID"] | p_team_id | 행/컬럼 값 대입 |  |  |  |
| AC-b569a287 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:792 | try | DATA_OP | req.Parameters["P_NICKNAME"] | p_NickName | 행/컬럼 값 대입 |  |  |  |
| AC-683337bb | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:793 | try | DATA_OP | req.Parameters["P_PROGRAM_ID"] | "SCP0055" | 행/컬럼 값 대입 |  |  |  |
| AC-7ad21ce8 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:794 | try | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-76f87c01 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:795 | try | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fbcf942a | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:796 | try | DATA_OP | req.Parameters["P_FCST_YN"] | p_fcst_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b6d8313e | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:797 | try | DATA_OP | req.Parameters["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-de436162 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:799 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a08e65f | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:830 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | CALL_EXT | svView.AddRows | (svView.RowCount, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce159c86 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:832 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | GRID_SET | svView.Cells[iCurRow, iColIdx_FROM_SITE].Text | sSITE_NAME | 그리드 속성/값 설정 |  |  |  |
| AC-7ffd9e49 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:833 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | GRID_SET | svView.Cells[iCurRow, iColIdx_SITE_ID].Text | sSITE_ID | 그리드 속성/값 설정 |  |  |  |
| AC-b2b1df08 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:835 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | GRID_SET | svView.Cells[iCurRow, iColIdx_EXTRA_SPEC].Text | sEXTRA_SPEC | 그리드 속성/값 설정 |  |  |  |
| AC-4c3aecbc | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:836 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | GRID_SET | svView.Cells[iCurRow, iColIdx_NICK_NAME].Text | sNICK_NAME | 그리드 속성/값 설정 |  |  |  |
| AC-c75c5e22 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:837 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | GRID_SET | svView.Cells[iCurRow, iColIdx_DEPT_ID].Text | sDEPT_ID | 그리드 속성/값 설정 |  |  |  |
| AC-b5086204 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:838 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[1].Rows) | GRID_SET | svView.Cells[iCurRow, iColIdx_DEPT_NAME].Text | sDEPT_NAME | 그리드 속성/값 설정 |  |  |  |
| AC-6eefc040 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:881 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ for (i < svView.ColumnCount) | CALL_EXT | svView.GetColumnLabel | (0, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-828777ce | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:882 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ for (i < svView.ColumnCount) | DATA_OP | colValue.Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-6daf07b4 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:883 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ for (i < svView.ColumnCount) | DATA_OP | colValue.Contains | ("/") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ef08862 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:904 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if ((iRowIdx >= 0) && (iColIdx >= 0)) | GRID_SET | svView.Cells[iRowIdx, iColIdx].Text | dTemp.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-71a75e97 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:945 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[2].Rows) ▸ for (i < svView.ColumnCount) | CALL_EXT | svView.GetColumnLabel | (0, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c54f14b | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:946 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[2].Rows) ▸ for (i < svView.ColumnCount) | DATA_OP | colValue.Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-76c7a6fd | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:947 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[2].Rows) ▸ for (i < svView.ColumnCount) | DATA_OP | colValue.Contains | ("/") | 데이터 객체 조작/조회 |  |  |  |
| AC-9183846d | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:965 | try ▸ if (dsResult.Tables.Count >= 4) ▸ foreach (DataRow row in dsResult.Tables[2].Rows) ▸ if ((iRowIdx >= 0) && (iColIdx >= 0)) | GRID_SET | svView.Cells[iRowIdx, iColIdx].Text | dTemp.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5810c26d | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:981 | try ▸ if (dsResult.Tables.Count >= 4) ▸ for (i < svView.RowCount) | GRID_SET | svView.Cells[i, iColIdx_SUB_TOTAL].Text | dTemp.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-e9172978 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:983 | try ▸ if (dsResult.Tables.Count >= 4) | GRID_SET | svView.Columns[iColIdx_SUB_TOTAL].Width | svView.Columns[iColIdx_SUB_TOTAL].GetPreferredWidth() + 10 | 그리드 속성/값 설정 |  |  |  |
| AC-2f2c89c0 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:983 | try ▸ if (dsResult.Tables.Count >= 4) | CALL_EXT | svView.Columns[iColIdx_SUB_TOTAL].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-416a53d5 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:994 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64097918 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1000 |  | RETURN | return sResult; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshGridGAP

진입점: FindButton [try] / SaveButton [if (fps.Name == spdMain.Name) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6addf64 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1134 | try ▸ for (i < svMain.RowCount) | GRID_SET | svMain.Cells[i, iColIdx_GAP].Text | (dTemp - dTemp2).ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-e3ec0335 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1136 | try | GRID_SET | svMain.Columns[iColIdx_GAP].Width | svMain.Columns[iColIdx_GAP].GetPreferredWidth() + 10 | 그리드 속성/값 설정 |  |  |  |
| AC-58a87631 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1136 | try | CALL_EXT | svMain.Columns[iColIdx_GAP].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-35c2adf2 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1147 | try ▸ if (giColIdx_Total > 0) ▸ for (i >= 0) | GRID_SET | svMain.Cells[i, giColIdx_Total].Text | dTemp.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-aeb1a962 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1185 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | CALL_EXT | svMain.AddRows | (i + 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93729927 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1186 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Rows[i + 1].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-3cb3f5aa | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1187 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, iColIdx_FROM_SITE].Text | sFromStie | 그리드 속성/값 설정 |  |  |  |
| AC-b0963f05 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1188 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, iColIdx_SITE_ID].Text | sStieID | 그리드 속성/값 설정 |  |  |  |
| AC-a19b4afd | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1190 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, iColIdx_EXTRA_SPEC].Text | sExtraSpec | 그리드 속성/값 설정 |  |  |  |
| AC-975d27b7 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1191 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, iColIdx_NICK_NAME].Text | sNickName | 그리드 속성/값 설정 |  |  |  |
| AC-90ed8620 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1192 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, iColIdx_DEPT_ID].Text | sDept_ID | 그리드 속성/값 설정 |  |  |  |
| AC-406e69b9 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1193 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, iColIdx_DEPT_NAME].Text | sNickName + " 요약" | 그리드 속성/값 설정 |  |  |  |
| AC-04d0570a | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1202 | try ▸ for (i >= 0) ▸ if ((svMain.Cells[i, iColIdx_FROM_SITE].Text != sFromStie) \|\| (svMain.Cells[i, iColIdx_EXTRA_SPEC].Text != sExtraSpec… | GRID_SET | svMain.Cells[i + 1, j].Text | dTemp.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-e1284c84 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1209 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshNote

진입점: FindButton [try] / SaveButton [if (fps.Name == spdMain.Name) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7bcc8a9 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1046 | for (i < svMain.RowCount) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(UserInfoContext.Current.UserId)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-787b7491 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1049 | for (i < svMain.RowCount) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0055_GET_SHIPMENT_ALLO_NOTE") ⇒ SCP.SCP0055_GET_SHIPMENT_ALLO_NOTE | 엔드포인트 요청 생성 |  |  |  |
| AC-53a91e46 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1051 | for (i < svMain.RowCount) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b3d36aa8 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1053 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["P_SITE_ID"] | sSITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-5f0f40ca | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1054 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["P_DEPT_ID"] | (sTEAM_NAME.IndexOf("요약") >= 0) ? sTEAM_NAME : sDEPT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-5c202c51 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1055 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["P_NICK_NAME"] | sNICK_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-6b6acbc3 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1056 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["P_PLAN_DATE"] | sPLAN_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-4e030e9e | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1057 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["P_GAP_DATE"] | sGAP_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-93f96db9 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1058 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1a559aa2 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1059 | for (i < svMain.RowCount) | DATA_OP | req.Parameters["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ba5cafc7 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1061 | for (i < svMain.RowCount) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bbb08539 | FindButton [try] 외 1 | SCP0055_Shipment_Allo_Report.cs:1064 | for (i < svMain.RowCount) ▸ if (dsResult.Tables[0].Rows.Count > 0) | GRID_SET | svMain.Cells[i, iColIdx_NOTE].Text | dsResult.Tables[0].Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshOperationGroup

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b4b2a7c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:283 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae8b5d44 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:283 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04dd6705 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:287 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-9024df03 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:287 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d1e1f441 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8deb87f0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:348 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-25f13776 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:348 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e0873ae5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0055_Shipment_Allo_Report.cs:350 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0055_Shipment_Allo_Report.RefreshTeam

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa80f90 | this.Load 외 1 | SCP0055_Shipment_Allo_Report.cs:328 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-f227daa8 | this.Load 외 1 | SCP0055_Shipment_Allo_Report.cs:328 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9ea52862 | this.Load 외 1 | SCP0055_Shipment_Allo_Report.cs:330 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-37c06113 | this.Load 외 1 | SCP0055_Shipment_Allo_Report.cs:330 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "40,81,82") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb71d2aa | this.Load 외 1 | SCP0055_Shipment_Allo_Report.cs:332 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0055_Shipment_Allo_Report.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-285154fb | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:639 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0055_Shipment_Allo_Report.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62df6f36 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1274 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0055_SAVE_SHIPMENT_ALLO_PLAN") ⇒ SCP.SCP0055_SAVE_SHIPMENT_ALLO_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-383f5582 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1276 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_SITE_ID"] | sSITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1cc64526 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1277 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_NICK_NAME"] | sNICK_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-c05b4fd8 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1278 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_DEPT_ID"] | (sTEAM_NAME.IndexOf("요약") >= 0) ? sTEAM_NAME : sDEPT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-9c83206f | SaveButton | SCP0055_Shipment_Allo_Report.cs:1279 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PLAN_DATE"] | sPLAN_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-0e892142 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1280 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_GAP_DATE"] | sGAP_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-475c6c6e | SaveButton | SCP0055_Shipment_Allo_Report.cs:1281 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_NOTE"] | sNOTE | 행/컬럼 값 대입 |  |  |  |
| AC-c84b4e46 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1282 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PROGRAM_ID"] | "SCP0055" | 행/컬럼 값 대입 |  |  |  |
| AC-f3d2d908 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1283 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_USER_ID"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-52ff3503 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1285 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb13c8b0 | SaveButton | SCP0055_Shipment_Allo_Report.cs:1292 | if (fps.Name == spdMain.Name) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c42e2afb | SaveButton | SCP0055_Shipment_Allo_Report.cs:1300 | if (fps.Name == spdMain.Name) ▸ if (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0055_Shipment_Allo_Report.SCM_SYS_LOG_BATCH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a4a6f0b | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1431 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-3a335f40 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1432 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-6c487fe5 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1433 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-824b4215 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1434 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-199db6c9 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1435 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-f6e729c4 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1436 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-357bdec4 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1437 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-dd81732c | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:1439 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0055_Shipment_Allo_Report.SelectCombo

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77ddd123 | OnShown | SCP0055_Shipment_Allo_Report.cs:1491 | try ▸ if (iIdx >= 0) | VALUE_SET | cCombo.SelectedIndex | iIdx | 컨트롤 값 설정 |  |  |  |

## SCP0055_Shipment_Allo_Report.SetSpreadInit

진입점: this.Load / FindButton / SaveButton [if (fps.Name == spdMain.Name)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d460b21 | this.Load 외 2 | SCP0055_Shipment_Allo_Report.cs:399 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-391ad705 | this.Load 외 2 | SCP0055_Shipment_Allo_Report.cs:400 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-f0ab7f44 | this.Load 외 2 | SCP0055_Shipment_Allo_Report.cs:401 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-47d7c812 | this.Load 외 2 | SCP0055_Shipment_Allo_Report.cs:403 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0055_Shipment_Allo_Report.SpdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5f6b1a1 | (진입점 미연결) | SCP0055_Shipment_Allo_Report.cs:453 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

