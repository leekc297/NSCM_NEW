# AS-IS 액션 대조표 — SCP0063

> 원천: `Doc/asisfacts/screens/SCP0063/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 343행 · 메서드 36 · 종류 DATA_OP 61 · GRID_INIT 59 · GRID_SET 35 · FLAG 23 · UI_PROP 21 · COMBO_DATA 20 · ENDPOINT 20 · RETURN 19 · VALUE_SET 13 · LIST_REBIND 13 · UI_MISC 11 · CALL_EXT 10 · POPUP 10 · MESSAGE 7 · STATE 6 · VALIDATE 5 · GRID_CLEAR 3 · GRID_BIND 2 · GRID_LOCK 2 · THROW 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 10


## SCP0063_PSI_JV.AddSubSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f08628c6 | (진입점 미연결) | SCP0063_PSI_JV.cs:1218 | for (iRow < dt.Rows.Count) ▸ if (psi_type.Equals("I")) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e40dc30 | (진입점 미연결) | SCP0063_PSI_JV.cs:1222 | for (iRow < dt.Rows.Count) ▸ if (psi_type.Equals("I")) ▸ for (iCol < dt.Rows[iRow].ItemArray.Length) | DATA_OP | newDr[iCol] | dt.Rows[iRow].ItemArray[iCol] | 행/컬럼 값 대입 |  |  |  |
| AC-46c49ffd | (진입점 미연결) | SCP0063_PSI_JV.cs:1224 | for (iRow < dt.Rows.Count) ▸ if (psi_type.Equals("I")) | DATA_OP | dt.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-11452478 | (진입점 미연결) | SCP0063_PSI_JV.cs:1238 | for (iRow < dt.Rows.Count) ▸ else of (psi_type.Equals("I")) ▸ else of (!befPSI.Equals(psi_type)) | DATA_OP | list.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-651b8e12 | (진입점 미연결) | SCP0063_PSI_JV.cs:1250 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1563e98 | (진입점 미연결) | SCP0063_PSI_JV.cs:1253 |  | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b882a190 | (진입점 미연결) | SCP0063_PSI_JV.cs:1254 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abb4cde7 | this.btnItemId.Click | SCP0063_PSI_JV.cs:634 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57c4a2e9 | this.btnItemId.Click | SCP0063_PSI_JV.cs:636 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c1af6946 | this.btnItemId.Click | SCP0063_PSI_JV.cs:637 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-392d2cf4 | this.btnItemId.Click | SCP0063_PSI_JV.cs:638 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-58ec865f | this.btnItemId.Click | SCP0063_PSI_JV.cs:639 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-be1a8eff | this.btnItemId.Click | SCP0063_PSI_JV.cs:644 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0063_PSI_JV.BtnNickName_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-234d8cbd | (진입점 미연결) | SCP0063_PSI_JV.cs:570 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-622a9ef8 | (진입점 미연결) | SCP0063_PSI_JV.cs:571 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b8055927 | (진입점 미연결) | SCP0063_PSI_JV.cs:572 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6ee58459 | (진입점 미연결) | SCP0063_PSI_JV.cs:573 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-025f3bf5 | (진입점 미연결) | SCP0063_PSI_JV.cs:578 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0063_PSI_JV.CboOperGroup_SelectedIndexChanged

진입점: cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-818c41e6 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:470 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fa5f349 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:484 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner"… | 화면 필드/플래그 변경 |  |  |  |
| AC-90b942ef | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:484 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner", get_JV_Value) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c199bfbc | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:489 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner"… | 화면 필드/플래그 변경 |  |  |  |
| AC-77fc54a2 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:489 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner", "9999!!!!") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11862faa | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:497 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1bea8f17 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:502 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-ad3c3ff0 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:502 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3fa78270 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:506 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-4eec7d62 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:506 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a4b31c6 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:510 | if (dtFromSite.Rows.Count < 1) | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-d981f981 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:511 | else of (dtFromSite.Rows.Count < 1) | UI_PROP | clbFromSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-74716728 | cboOperGroup.SelectedIndexChanged | SCP0063_PSI_JV.cs:513 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0063_PSI_JV.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2185d7f8 | cboPlanDate.SelectedIndexChanged | SCP0063_PSI_JV.cs:1705 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-60608bbd | cboPlanDate.SelectedIndexChanged | SCP0063_PSI_JV.cs:1705 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bab00bd7 | cboPlanDate.SelectedIndexChanged | SCP0063_PSI_JV.cs:1706 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a2c3aad0 | cboPlanDate.SelectedIndexChanged | SCP0063_PSI_JV.cs:1708 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-51c9214b | cboPlanDate.SelectedIndexChanged | SCP0063_PSI_JV.cs:1710 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-85aab8ec | cboPlanDate.SelectedIndexChanged | SCP0063_PSI_JV.cs:1711 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0063_PSI_JV.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6002579 | cboPlanSeq.SelectedIndexChanged | SCP0063_PSI_JV.cs:1731 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0063_PSI_JV.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb1e02e2 | cboPlanType.SelectedIndexChanged | SCP0063_PSI_JV.cs:1719 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-87c5ba20 | cboPlanType.SelectedIndexChanged | SCP0063_PSI_JV.cs:1719 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae305086 | cboPlanType.SelectedIndexChanged | SCP0063_PSI_JV.cs:1720 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d7b1359 | cboPlanType.SelectedIndexChanged | SCP0063_PSI_JV.cs:1722 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d774b3cc | cboPlanType.SelectedIndexChanged | SCP0063_PSI_JV.cs:1725 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0063_PSI_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed7e5508 | this.Load | SCP0063_PSI_JV.cs:237 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-61b75da2 | this.Load | SCP0063_PSI_JV.cs:238 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-2105e099 | this.Load | SCP0063_PSI_JV.cs:240 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0063_PSI_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fab070b | this.Load | SCP0063_PSI_JV.cs:172 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-135018d9 | this.Load | SCP0063_PSI_JV.cs:173 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0063_PSI_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a70b2085 | Dispose | SCP0063_PSI_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0063_PSI_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ce9aca9 | EditButton | SCP0063_PSI_JV.cs:623 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b67b7ffa | EditButton | SCP0063_PSI_JV.cs:624 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e62b890c | FindButton | SCP0063_PSI_JV.cs:591 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33e16bab | FindButton | SCP0063_PSI_JV.cs:592 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85616116 | FindButton | SCP0063_PSI_JV.cs:604 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24d866a1 | FindButton | SCP0063_PSI_JV.cs:605 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afc7dc8b | this.Load | SCP0063_PSI_JV.cs:1782 |  | STATE | clbFromSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3f86605e | this.Load | SCP0063_PSI_JV.cs:1785 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bdaddc0 | this.Load | SCP0063_PSI_JV.cs:1789 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-2f4959ac | this.Load | SCP0063_PSI_JV.cs:1791 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-e4e69b67 | this.Load | SCP0063_PSI_JV.cs:1792 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8aa5c293 | this.Load | SCP0063_PSI_JV.cs:1793 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-d9c381b6 | this.Load | SCP0063_PSI_JV.cs:1794 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-3741db7d | this.Load | SCP0063_PSI_JV.cs:1795 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e826076b | this.Load | SCP0063_PSI_JV.cs:1797 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0cdf642e | this.Load | SCP0063_PSI_JV.cs:1806 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c14dcc9d | this.Load | SCP0063_PSI_JV.cs:1808 |  | STATE | clbFromSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0063_PSI_JV.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a08ddfdf | FindButton | SCP0063_PSI_JV.cs:1050 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b34cc83e | FindButton | SCP0063_PSI_JV.cs:1050 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40f9ceed | FindButton | SCP0063_PSI_JV.cs:1051 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-b9c527ba | FindButton | SCP0063_PSI_JV.cs:1051 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-246c78bd | FindButton | SCP0063_PSI_JV.cs:1077 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bb778bad | FindButton | SCP0063_PSI_JV.cs:1080 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-99e028bc | FindButton | SCP0063_PSI_JV.cs:1083 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d46b656c | FindButton | SCP0063_PSI_JV.cs:1085 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05411fa1 | FindButton | SCP0063_PSI_JV.cs:1088 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0012_GET_PSI") ⇒ SCP.SCP0012_GET_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-6ab96c5b | FindButton | SCP0063_PSI_JV.cs:1089 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-15d4e216 | FindButton | SCP0063_PSI_JV.cs:1090 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bf94d33a | FindButton | SCP0063_PSI_JV.cs:1091 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2ed50c6f | FindButton | SCP0063_PSI_JV.cs:1092 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c4f4cfa | FindButton | SCP0063_PSI_JV.cs:1093 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-52be0796 | FindButton | SCP0063_PSI_JV.cs:1094 | try ▸ lambda | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-8f618c4f | FindButton | SCP0063_PSI_JV.cs:1095 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2b99c65 | FindButton | SCP0063_PSI_JV.cs:1096 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-bd3dd9ec | FindButton | SCP0063_PSI_JV.cs:1097 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d8d7eb54 | FindButton | SCP0063_PSI_JV.cs:1098 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4f387968 | FindButton | SCP0063_PSI_JV.cs:1099 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-47c18bb3 | FindButton | SCP0063_PSI_JV.cs:1100 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-db1eb1cc | FindButton | SCP0063_PSI_JV.cs:1101 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0a09a4f4 | FindButton | SCP0063_PSI_JV.cs:1102 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d18925f8 | FindButton | SCP0063_PSI_JV.cs:1103 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b1153dc | FindButton | SCP0063_PSI_JV.cs:1104 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3d9764b4 | FindButton | SCP0063_PSI_JV.cs:1111 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1b22b50c | FindButton | SCP0063_PSI_JV.cs:1112 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d632a71f | FindButton | SCP0063_PSI_JV.cs:1137 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | VALUE_SET | cells.Text | "Sum" | 컨트롤 값 설정 |  |  |  |
| AC-115a57a9 | FindButton | SCP0063_PSI_JV.cs:1138 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ColumnSpan | 2 | 속성 ColumnSpan 설정 |  |  |  |
| AC-205230c5 | FindButton | SCP0063_PSI_JV.cs:1139 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-a6c8184e | FindButton | SCP0063_PSI_JV.cs:1140 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-bf064a6a | FindButton | SCP0063_PSI_JV.cs:1141 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-58aec6af | FindButton | SCP0063_PSI_JV.cs:1152 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefMain.BOH), nSumInventory) | 그리드 값 설정 |  |  |  |
| AC-f214ac93 | FindButton | SCP0063_PSI_JV.cs:1177 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-600e19b8 | FindButton | SCP0063_PSI_JV.cs:1183 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ae512b9 | FindButton | SCP0063_PSI_JV.cs:1188 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8bae93e2 | FindButton | SCP0063_PSI_JV.cs:1190 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2c72025 | FindButton | SCP0063_PSI_JV.cs:1194 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-278b1d1e | FindButton | SCP0063_PSI_JV.cs:1195 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0063_PSI_JV.FindData_Main_Parallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f031760 | (진입점 미연결) | SCP0063_PSI_JV.cs:827 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-67bfea7d | (진입점 미연결) | SCP0063_PSI_JV.cs:827 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bc81dfe | (진입점 미연결) | SCP0063_PSI_JV.cs:828 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-ba5051b6 | (진입점 미연결) | SCP0063_PSI_JV.cs:828 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea222ae9 | (진입점 미연결) | SCP0063_PSI_JV.cs:854 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fa4d3e98 | (진입점 미연결) | SCP0063_PSI_JV.cs:857 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28d9b56e | (진입점 미연결) | SCP0063_PSI_JV.cs:860 | try | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3186cdca | (진입점 미연결) | SCP0063_PSI_JV.cs:873 | try | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { if (i != nCnt - 1) { string strStartDate = DateUtil.GetDateAdd(p_from… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a1a993f | (진입점 미연결) | SCP0063_PSI_JV.cs:894 | try ▸ lambda ▸ if (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0012_GET_PSI_QTY") ⇒ SCP.SCP0012_GET_PSI_QTY | 엔드포인트 요청 생성 |  |  |  |
| AC-a248c7da | (진입점 미연결) | SCP0063_PSI_JV.cs:895 | try ▸ lambda ▸ if (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e47f2532 | (진입점 미연결) | SCP0063_PSI_JV.cs:896 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d8351455 | (진입점 미연결) | SCP0063_PSI_JV.cs:897 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-0f0e4078 | (진입점 미연결) | SCP0063_PSI_JV.cs:898 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9847a4a | (진입점 미연결) | SCP0063_PSI_JV.cs:899 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-dcd62f95 | (진입점 미연결) | SCP0063_PSI_JV.cs:900 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-d003ce78 | (진입점 미연결) | SCP0063_PSI_JV.cs:901 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-762b52cf | (진입점 미연결) | SCP0063_PSI_JV.cs:902 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-4e88990e | (진입점 미연결) | SCP0063_PSI_JV.cs:903 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ec4d3de3 | (진입점 미연결) | SCP0063_PSI_JV.cs:904 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-29d2fef2 | (진입점 미연결) | SCP0063_PSI_JV.cs:905 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f5de96f9 | (진입점 미연결) | SCP0063_PSI_JV.cs:907 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-41544448 | (진입점 미연결) | SCP0063_PSI_JV.cs:908 | try ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2bf56ede | (진입점 미연결) | SCP0063_PSI_JV.cs:913 | try ▸ lambda ▸ if (i != nCnt - 1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9bed6869 | (진입점 미연결) | SCP0063_PSI_JV.cs:917 | try ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-85f4447e | (진입점 미연결) | SCP0063_PSI_JV.cs:921 | try ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ else of (i == 1) ▸ if (i == 2) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3317a39 | (진입점 미연결) | SCP0063_PSI_JV.cs:930 | try ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0012_GET_PSI_PARAL") ⇒ SCP.SCP0012_GET_PSI_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-da0428ac | (진입점 미연결) | SCP0063_PSI_JV.cs:931 | try ▸ lambda ▸ else of (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-580098ba | (진입점 미연결) | SCP0063_PSI_JV.cs:932 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2131153a | (진입점 미연결) | SCP0063_PSI_JV.cs:933 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-03369c0f | (진입점 미연결) | SCP0063_PSI_JV.cs:934 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a911f72 | (진입점 미연결) | SCP0063_PSI_JV.cs:935 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-455b19e0 | (진입점 미연결) | SCP0063_PSI_JV.cs:936 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-f41b20f5 | (진입점 미연결) | SCP0063_PSI_JV.cs:937 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-da5c77f0 | (진입점 미연결) | SCP0063_PSI_JV.cs:938 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-50aed882 | (진입점 미연결) | SCP0063_PSI_JV.cs:939 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fb173098 | (진입점 미연결) | SCP0063_PSI_JV.cs:940 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-24a73bab | (진입점 미연결) | SCP0063_PSI_JV.cs:941 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d864b95c | (진입점 미연결) | SCP0063_PSI_JV.cs:942 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-66165b81 | (진입점 미연결) | SCP0063_PSI_JV.cs:943 | try ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6c0cf774 | (진입점 미연결) | SCP0063_PSI_JV.cs:946 | try ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3793ac3 | (진입점 미연결) | SCP0063_PSI_JV.cs:951 | try | FLAG | dsBinding | dsTitle.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-caa41b47 | (진입점 미연결) | SCP0063_PSI_JV.cs:951 | try | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dc442525 | (진입점 미연결) | SCP0063_PSI_JV.cs:952 | try | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-89393d54 | (진입점 미연결) | SCP0063_PSI_JV.cs:986 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7821850e | (진입점 미연결) | SCP0063_PSI_JV.cs:987 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-836e226f | (진입점 미연결) | SCP0063_PSI_JV.cs:1011 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | VALUE_SET | cells.Text | "Sum" | 컨트롤 값 설정 |  |  |  |
| AC-4deb4599 | (진입점 미연결) | SCP0063_PSI_JV.cs:1012 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ColumnSpan | 3 | 속성 ColumnSpan 설정 |  |  |  |
| AC-b021550a | (진입점 미연결) | SCP0063_PSI_JV.cs:1013 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-8a7585c1 | (진입점 미연결) | SCP0063_PSI_JV.cs:1014 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-42c96f59 | (진입점 미연결) | SCP0063_PSI_JV.cs:1015 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-144cbc78 | (진입점 미연결) | SCP0063_PSI_JV.cs:1021 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8768dd0f | (진입점 미연결) | SCP0063_PSI_JV.cs:1025 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c49d04ff | (진입점 미연결) | SCP0063_PSI_JV.cs:1032 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7bcc979c | (진입점 미연결) | SCP0063_PSI_JV.cs:1034 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d45bb507 | (진입점 미연결) | SCP0063_PSI_JV.cs:1038 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a8b20438 | (진입점 미연결) | SCP0063_PSI_JV.cs:1039 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0063_PSI_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f10153b | this.Load | SCP0063_PSI_JV.cs:157 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0063_PSI_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc80abfc | this.Load | SCP0063_PSI_JV.cs:214 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b4a0a619 | this.Load | SCP0063_PSI_JV.cs:215 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f062f1c | this.Load | SCP0063_PSI_JV.cs:218 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c53de65 | this.Load 외 1 | SCP0063_PSI_JV.cs:1775 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ad489b2 | this.Load 외 1 | SCP0063_PSI_JV.cs:1777 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.GetFromSiteByDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5701087d | (진입점 미연결) | SCP0063_PSI_JV.cs:227 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_FROM_SITE") ⇒ SCM.SCM0001_GET_FROM_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-e6da9169 | (진입점 미연결) | SCP0063_PSI_JV.cs:229 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ca5dbcb5 | (진입점 미연결) | SCP0063_PSI_JV.cs:232 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8292304b | (진입점 미연결) | SCP0063_PSI_JV.cs:765 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-9d941131 | (진입점 미연결) | SCP0063_PSI_JV.cs:767 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b659e9b0 | (진입점 미연결) | SCP0063_PSI_JV.cs:768 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2abebd92 | (진입점 미연결) | SCP0063_PSI_JV.cs:769 | try | FLAG | dsBinding | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-92b08f9a | (진입점 미연결) | SCP0063_PSI_JV.cs:780 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-eb1bddf4 | (진입점 미연결) | SCP0063_PSI_JV.cs:781 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-3177ee6d | (진입점 미연결) | SCP0063_PSI_JV.cs:782 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0063_PSI_JV.GetSpdTitle

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14595043 | this.Load 외 2 | SCP0063_PSI_JV.cs:292 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SCP0012", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c8ef6ba | this.Load 외 2 | SCP0063_PSI_JV.cs:294 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-3d617a13 | this.Load 외 2 | SCP0063_PSI_JV.cs:1763 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-47b1c7bb | this.Load 외 2 | SCP0063_PSI_JV.cs:1764 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-7d1235f0 | this.Load 외 2 | SCP0063_PSI_JV.cs:1765 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-c4384594 | this.Load 외 2 | SCP0063_PSI_JV.cs:1767 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f405857b | this.Load 외 2 | SCP0063_PSI_JV.cs:1767 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0063_PSI_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c257edc | this.Load | SCP0063_PSI_JV.cs:179 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-795109f6 | this.Load | SCP0063_PSI_JV.cs:182 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-3324b8e5 | this.Load | SCP0063_PSI_JV.cs:183 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-94b5cdd6 | this.Load | SCP0063_PSI_JV.cs:184 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-70833df6 | this.Load | SCP0063_PSI_JV.cs:187 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-d88df376 | this.Load | SCP0063_PSI_JV.cs:189 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-710b710b | this.Load | SCP0063_PSI_JV.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-637ace53 | this.Load | SCP0063_PSI_JV.cs:193 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-81b9d2ab | this.Load | SCP0063_PSI_JV.cs:193 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5eaca42a | this.Load | SCP0063_PSI_JV.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f5311e17 | this.Load | SCP0063_PSI_JV.cs:196 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-7060c722 | this.Load | SCP0063_PSI_JV.cs:196 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bddb50a7 | this.Load | SCP0063_PSI_JV.cs:197 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2a59b0f8 | this.Load | SCP0063_PSI_JV.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-422125d5 | this.Load | SCP0063_PSI_JV.cs:202 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f9bd68d | this.Load | SCP0063_PSI_JV.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9c897383 | this.Load | SCP0063_PSI_JV.cs:205 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0063_PSI_JV.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb2189b | (진입점 미연결) | SCP0063_PSI_JV.cs:310 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-967f3398 | (진입점 미연결) | SCP0063_PSI_JV.cs:311 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c1c6e3f | (진입점 미연결) | SCP0063_PSI_JV.cs:312 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP_DESC, DefMain.OPERATION_GROUP_DESC, FPMerge.Restricted, 65, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bfe55d0 | (진입점 미연결) | SCP0063_PSI_JV.cs:313 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SITE_DESCRIPTION, DefMain.SITE_DESCRIPTION, FPMerge.Restricted, 65, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5760d557 | (진입점 미연결) | SCP0063_PSI_JV.cs:314 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 115, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-854054c6 | (진입점 미연결) | SCP0063_PSI_JV.cs:315 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 80, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ad1a924 | (진입점 미연결) | SCP0063_PSI_JV.cs:317 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ELECTRODE_TYPE, DefMain.ELECTRODE_TYPE, FPMerge.Restricted, elec_size, true,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-382d15e0 | (진입점 미연결) | SCP0063_PSI_JV.cs:318 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainLabel.BOH, DefMain.BOH, FPMerge.Restricted, 75, true, FPHAlign.Right, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbc4e6f5 | (진입점 미연결) | SCP0063_PSI_JV.cs:319 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_NAME, DefMain.PSI_NAME, FPMerge.Restricted, 75, true, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bfc12899 | (진입점 미연결) | SCP0063_PSI_JV.cs:320 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_VALUE, DefMain.PSI_VALUE, FPMerge.Restricted, 120, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed1b6644 | (진입점 미연결) | SCP0063_PSI_JV.cs:321 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_TYPE, DefMain.PSI_TYPE, FPMerge.Restricted, 65, false, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39bf191c | (진입점 미연결) | SCP0063_PSI_JV.cs:323 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6d5ce6e | (진입점 미연결) | SCP0063_PSI_JV.cs:324 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 130, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb4b579a | (진입점 미연결) | SCP0063_PSI_JV.cs:325 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP, DefMain.OPERATION_GROUP, FPMerge.Restricted, 60, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9baa16b | (진입점 미연결) | SCP0063_PSI_JV.cs:326 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_START_YYYYMMDD, DefMain.PLAN_START_YYYYMMDD, FPMerge.Restricted, 60, fa… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4ebc3df | (진입점 미연결) | SCP0063_PSI_JV.cs:327 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_TYPE, DefMain.PLAN_TYPE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2d6b5ca | (진입점 미연결) | SCP0063_PSI_JV.cs:329 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SEQ, DefMain.SEQ, FPMerge.Restricted, 60, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cc904d2 | (진입점 미연결) | SCP0063_PSI_JV.cs:332 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56fd5a6d | (진입점 미연결) | SCP0063_PSI_JV.cs:333 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5547aaf | (진입점 미연결) | SCP0063_PSI_JV.cs:334 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_START_YYYYMMDD), 3, 1, 20, "PLAN_START_YYYYMMDD", … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf99857a | (진입점 미연결) | SCP0063_PSI_JV.cs:335 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_TYPE), 3, 1, 20, "PLAN_TYPE", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e8395c7 | (진입점 미연결) | SCP0063_PSI_JV.cs:336 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SEQ), 3, 1, 20, "SEQ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf10096a | (진입점 미연결) | SCP0063_PSI_JV.cs:337 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.OPERATION_GROUP), 3, 1, 20, "Operation Group", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-605583ad | (진입점 미연결) | SCP0063_PSI_JV.cs:338 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.OPERATION_GROUP_DESC), 3, 1, 20, "Operation Group", FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ab7e7f9 | (진입점 미연결) | SCP0063_PSI_JV.cs:339 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, "From Site", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7d62407 | (진입점 미연결) | SCP0063_PSI_JV.cs:340 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SITE_DESCRIPTION), 3, 1, 20, "From Site", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7356ffd1 | (진입점 미연결) | SCP0063_PSI_JV.cs:341 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, "Model", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8198316e | (진입점 미연결) | SCP0063_PSI_JV.cs:342 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, "Nick Name", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be28a470 | (진입점 미연결) | SCP0063_PSI_JV.cs:343 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ELECTRODE_TYPE), 3, 1, 20, "Electrode Type", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-998bf58d | (진입점 미연결) | SCP0063_PSI_JV.cs:344 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.BOH), 3, 1, 20, "BOH (From Site)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9aa82ea | (진입점 미연결) | SCP0063_PSI_JV.cs:345 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_TYPE), 3, 1, 20, "PSI_Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b0abef0 | (진입점 미연결) | SCP0063_PSI_JV.cs:346 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_NAME), 3, 1, 20, "PSI Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d4d54fc | (진입점 미연결) | SCP0063_PSI_JV.cs:347 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_VALUE), 3, 1, 20, "PSI Value", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bea27ddc | (진입점 미연결) | SCP0063_PSI_JV.cs:355 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbb41ac2 | (진입점 미연결) | SCP0063_PSI_JV.cs:356 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.PSI_VALUE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e221dfc6 | (진입점 미연결) | SCP0063_PSI_JV.cs:357 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0063_PSI_JV.InitSpread_2

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f968f88 | this.Load 외 2 | SCP0063_PSI_JV.cs:249 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-dd129726 | this.Load 외 2 | SCP0063_PSI_JV.cs:254 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-56958ef7 | this.Load 외 2 | SCP0063_PSI_JV.cs:260 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00d9f92b | this.Load 외 2 | SCP0063_PSI_JV.cs:262 |  | GRID_INIT | siMain.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6e0f3bb | this.Load 외 2 | SCP0063_PSI_JV.cs:266 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1d569a8c | this.Load 외 2 | SCP0063_PSI_JV.cs:267 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-336d1902 | this.Load 외 2 | SCP0063_PSI_JV.cs:268 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-21257ab9 | this.Load 외 2 | SCP0063_PSI_JV.cs:271 | if (!division.Substring(0, 2).Equals("EE")) ▸ if (division == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-67c4b4d3 | this.Load 외 2 | SCP0063_PSI_JV.cs:273 | if (!division.Substring(0, 2).Equals("EE")) ▸ else of (division == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f16f053 | this.Load 외 2 | SCP0063_PSI_JV.cs:278 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-097a5b1f | this.Load 외 2 | SCP0063_PSI_JV.cs:279 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-89309f06 | this.Load 외 2 | SCP0063_PSI_JV.cs:280 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-13f7b382 | this.Load 외 2 | SCP0063_PSI_JV.cs:281 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0063_PSI_JV.InitSpreadDateColumn

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76bad073 | this.Load 외 2 | SCP0063_PSI_JV.cs:393 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8129f88d | this.Load 외 2 | SCP0063_PSI_JV.cs:394 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4aa85765 | this.Load 외 2 | SCP0063_PSI_JV.cs:398 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71f6e356 | this.Load 외 2 | SCP0063_PSI_JV.cs:399 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa9dc013 | this.Load 외 2 | SCP0063_PSI_JV.cs:403 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-2f96064e | this.Load 외 2 | SCP0063_PSI_JV.cs:410 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3812f5ca | this.Load 외 2 | SCP0063_PSI_JV.cs:411 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb3c77cd | this.Load 외 2 | SCP0063_PSI_JV.cs:416 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e22192ce | this.Load 외 2 | SCP0063_PSI_JV.cs:417 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-971693cc | this.Load 외 2 | SCP0063_PSI_JV.cs:425 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9563b19 | this.Load 외 2 | SCP0063_PSI_JV.cs:426 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b66756f6 | this.Load 외 2 | SCP0063_PSI_JV.cs:436 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7323bac4 | this.Load 외 2 | SCP0063_PSI_JV.cs:437 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de1ee943 | this.Load 외 2 | SCP0063_PSI_JV.cs:438 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f36f667e | this.Load 외 2 | SCP0063_PSI_JV.cs:439 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0063_PSI_JV.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-919f0f32 | (진입점 미연결) | SCP0063_PSI_JV.cs:1577 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0063_PSI_JV.Set_Inventories

진입점: FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f408b40 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1269 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-a880d288 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1273 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-04a6bdfb | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1346 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total Load… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxWeek] | weekSum / nCntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-fc8c99cd | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1358 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total Load… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxMonth] | monthSum / nCntDayOfMonth | 그리드 속성/값 설정 |  |  |  |
| AC-4fd7369e | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1380 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-aa7bf7a5 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1389 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-e22a361b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1397 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-c9b75f8b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1398 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of ((PSI_Type.Equals("P") \|\| PSI_Type.Equals("PA")) && measure.Equals("Line Total… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-35c85940 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1407 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-04b64dee | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0063_PSI_JV.cs:1411 | finally | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0063_PSI_JV.Set_PSI_Measure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24932655 | (진입점 미연결) | SCP0063_PSI_JV.cs:1465 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-67e34293 | (진입점 미연결) | SCP0063_PSI_JV.cs:1474 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-ac0aeb4c | (진입점 미연결) | SCP0063_PSI_JV.cs:1482 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-50926bfa | (진입점 미연결) | SCP0063_PSI_JV.cs:1483 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-531d0c67 | (진입점 미연결) | SCP0063_PSI_JV.cs:1503 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-650ecbc3 | (진입점 미연결) | SCP0063_PSI_JV.cs:1504 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-17f033fc | (진입점 미연결) | SCP0063_PSI_JV.cs:1511 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-2a615283 | (진입점 미연결) | SCP0063_PSI_JV.cs:1520 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-bcba6143 | (진입점 미연결) | SCP0063_PSI_JV.cs:1529 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-457418b4 | (진입점 미연결) | SCP0063_PSI_JV.cs:1530 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ if (!PSI_Type.Equ… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-67164a64 | (진입점 미연결) | SCP0063_PSI_JV.cs:1539 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-ffd4b204 | (진입점 미연결) | SCP0063_PSI_JV.cs:1543 | finally | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0063_PSI_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df7facb7 | this.Load 외 1 | SCP0063_PSI_JV.cs:657 | if (dic_JV_Plant.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-112d9567 | this.Load 외 1 | SCP0063_PSI_JV.cs:666 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f14ed516 | this.Load 외 1 | SCP0063_PSI_JV.cs:680 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner"… | 화면 필드/플래그 변경 |  |  |  |
| AC-5e72b8f8 | this.Load 외 1 | SCP0063_PSI_JV.cs:680 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner", get_JV_Value) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00328c1f | this.Load 외 1 | SCP0063_PSI_JV.cs:684 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner"… | 화면 필드/플래그 변경 |  |  |  |
| AC-9704939f | this.Load 외 1 | SCP0063_PSI_JV.cs:684 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.FromSite_PSI, false, division, pOperationGroup, "JV Planner", "9999!!!!") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf21743d | this.Load 외 1 | SCP0063_PSI_JV.cs:691 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c58ea41 | this.Load 외 1 | SCP0063_PSI_JV.cs:696 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-200f7df0 | this.Load 외 1 | SCP0063_PSI_JV.cs:696 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff97cbce | this.Load 외 1 | SCP0063_PSI_JV.cs:700 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-f9ebfced | this.Load 외 1 | SCP0063_PSI_JV.cs:700 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b7faf17e | this.Load 외 1 | SCP0063_PSI_JV.cs:704 | if (dtFromSite.Rows.Count < 1) | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-f7d2254b | this.Load 외 1 | SCP0063_PSI_JV.cs:705 | else of (dtFromSite.Rows.Count < 1) | UI_PROP | clbFromSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-6532b6ef | this.Load 외 1 | SCP0063_PSI_JV.cs:707 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2c93b9d0 | this.Load 외 1 | SCP0063_PSI_JV.cs:711 | if (division == "40") | STATE | this.lcCellTypeGr.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4d246212 | this.Load 외 1 | SCP0063_PSI_JV.cs:715 | else of (division == "40") | STATE | this.lcCellTypeGr.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ccf87d64 | this.Load 외 1 | SCP0063_PSI_JV.cs:716 | else of (division == "40") | CALL_EXT | cboCellTypeGr.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04627d53 | this.Load 외 1 | SCP0063_PSI_JV.cs:722 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-a82b2a0e | this.Load 외 1 | SCP0063_PSI_JV.cs:722 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ceb42478 | this.Load 외 1 | SCP0063_PSI_JV.cs:723 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-76a8f1f4 | this.Load 외 1 | SCP0063_PSI_JV.cs:726 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-63a0754e | this.Load 외 1 | SCP0063_PSI_JV.cs:726 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3afd6734 | this.Load 외 1 | SCP0063_PSI_JV.cs:727 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d8b9f8ed | this.Load 외 1 | SCP0063_PSI_JV.cs:730 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-f28518f2 | this.Load 외 1 | SCP0063_PSI_JV.cs:733 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-89ee6cad | this.Load 외 1 | SCP0063_PSI_JV.cs:733 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40ec3118 | this.Load 외 1 | SCP0063_PSI_JV.cs:734 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6a7848c1 | this.Load 외 1 | SCP0063_PSI_JV.cs:739 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-ed4017dd | this.Load 외 1 | SCP0063_PSI_JV.cs:740 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e07034c6 | this.Load 외 1 | SCP0063_PSI_JV.cs:744 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0063_PSI_JV.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8736c489 | (진입점 미연결) | SCP0063_PSI_JV.cs:1741 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed45539b | (진입점 미연결) | SCP0063_PSI_JV.cs:1745 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80cc3a84 | (진입점 미연결) | SCP0063_PSI_JV.cs:1748 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d8fe93a | (진입점 미연결) | SCP0063_PSI_JV.cs:1752 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-be1218a7 | (진입점 미연결) | SCP0063_PSI_JV.cs:1753 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0063_PSI_JV.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c891be21 | (진입점 미연결) | SCP0063_PSI_JV.cs:1560 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-11eccda7 | (진입점 미연결) | SCP0063_PSI_JV.cs:1566 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0063_PSI_JV.SetOperationGroupByDivision

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b15e267c | cboDivision.SelectedIndexChanged | SCP0063_PSI_JV.cs:1586 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-9623c9fd | cboDivision.SelectedIndexChanged | SCP0063_PSI_JV.cs:1586 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2328820d | cboDivision.SelectedIndexChanged | SCP0063_PSI_JV.cs:1590 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8ed39a2 | cboDivision.SelectedIndexChanged | SCP0063_PSI_JV.cs:1590 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a6625f61 | cboDivision.SelectedIndexChanged | SCP0063_PSI_JV.cs:1593 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0063_PSI_JV.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dc32c0e | this.Load 외 4 | SCP0063_PSI_JV.cs:1606 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d997f9b3 | this.Load 외 4 | SCP0063_PSI_JV.cs:1611 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a19e6512 | this.Load 외 4 | SCP0063_PSI_JV.cs:1618 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3d2a6805 | this.Load 외 4 | SCP0063_PSI_JV.cs:1622 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4917085c | this.Load 외 4 | SCP0063_PSI_JV.cs:1627 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-4bde9ec1 | this.Load 외 4 | SCP0063_PSI_JV.cs:1634 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ff864ab5 | this.Load 외 4 | SCP0063_PSI_JV.cs:1638 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0063_PSI_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb919bac | this.spdMain.CellDoubleClick | SCP0063_PSI_JV.cs:560 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0063_PSI_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa56984c | this.spdMain.TopChange | SCP0063_PSI_JV.cs:519 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0063_PSI_JV.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21289e33 | (진입점 미연결) | SCP0063_PSI_JV.cs:1658 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5488d2bf | (진입점 미연결) | SCP0063_PSI_JV.cs:1660 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-bf2f6f71 | (진입점 미연결) | SCP0063_PSI_JV.cs:1666 | if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days > 364) | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30683c0e | (진입점 미연결) | SCP0063_PSI_JV.cs:1672 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

