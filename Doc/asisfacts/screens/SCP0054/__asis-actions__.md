# AS-IS 액션 대조표 — SCP0054

> 원천: `Doc/asisfacts/screens/SCP0054/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 458행 · 메서드 32 · 종류 DATA_OP 92 · FLAG 58 · COMBO_DATA 42 · LIST_REBIND 42 · GRID_SET 40 · CALL_EXT 30 · GRID_INIT 28 · UI_PROP 26 · GRID_STYLE 22 · ENDPOINT 14 · GRID_LOCK 12 · UI_MISC 10 · RETURN 10 · POPUP 8 · VALUE_SET 6 · GRID_CLEAR 6 · VALIDATE 4 · MESSAGE 4 · GRID_BIND 2 · STATE_RESET 2 · ⚠ 의미 확인 필요 30


## SCP0054_CAPA_SIMULATION.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c226225 | this.btnColumn.Click | SCP0054_CAPA_SIMULATION.cs:1254 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0054", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-3a2ad317 | this.btnColumn.Click | SCP0054_CAPA_SIMULATION.cs:1255 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-54d7c553 | this.btnColumn.Click | SCP0054_CAPA_SIMULATION.cs:1256 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3d8a0217 | this.btnColumn.Click | SCP0054_CAPA_SIMULATION.cs:1255 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0054", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-a9f44cfa | this.btnColumn.Click | SCP0054_CAPA_SIMULATION.cs:1256 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3acc63bc | this.btnColumn.Click | SCP0054_CAPA_SIMULATION.cs:1257 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0054_CAPA_SIMULATION.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b1dabc4 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1311 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-cff44111 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1311 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b120dce5 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1312 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8f21e4d1 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1313 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-dd221260 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1315 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-a456057e | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1312 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-82c12a57 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1312 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa778e98 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1313 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f868c6fa | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1314 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-50979130 | cboPlanDate.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1316 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0054_CAPA_SIMULATION.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63eca55b | cboPlanSeq.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1331 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-4d3d5875 | cboPlanSeq.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1332 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0054_CAPA_SIMULATION.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcb9ff0d | cboPlanType.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1324 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f663ced | cboPlanType.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1324 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-601dc3b3 | cboPlanType.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1325 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fb63a51b | cboPlanType.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1325 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-947769f4 | cboPlanType.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1325 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe3e7566 | cboPlanType.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1326 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.CboVersionId_Click

진입점: cboVersionId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62ed2348 | cboVersionId.Click | SCP0054_CAPA_SIMULATION.cs:1241 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, pDivisionId, pGroupId, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-1eb444ae | cboVersionId.Click | SCP0054_CAPA_SIMULATION.cs:1241 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, pDivisionId, pGroupId, "Y") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e279314e | cboVersionId.Click | SCP0054_CAPA_SIMULATION.cs:1242 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6be707b2 | cboVersionId.Click | SCP0054_CAPA_SIMULATION.cs:1242 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, division, pGroupId, "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-b7da9995 | cboVersionId.Click | SCP0054_CAPA_SIMULATION.cs:1242 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, division, pGroupId, "Y") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-738f2e2b | cboVersionId.Click | SCP0054_CAPA_SIMULATION.cs:1243 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.CboVersionId_SelectedIndexChanged

진입점: cboVersionId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ec2674d | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1214 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-88842301 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1221 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, pDivisionId, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e61a4e5 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1221 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, pDivisionId, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0abd8e8a | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1222 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7a5cc4de | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1225 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, pDivisionId, pPlanDate, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-dfe6ec02 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1225 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, pDivisionId, pPlanDate, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea6b7b21 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1226 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-46afe574 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1229 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-aa58f205 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1232 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, pDivisionId, pPlanDate, pPlanType, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-b44ea604 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1232 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, pDivisionId, pPlanDate, pPlanType, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f19295d | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1233 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-237d9600 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1215 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-7cb1afd5 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1222 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-4ba1be8d | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1222 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e342bce | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1223 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0a226e29 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1226 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-43963b82 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1226 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8a5aae6 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1227 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f2bbb5eb | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1230 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-eb90cd5c | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1233 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-65c849ab | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1233 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0d7fef34 | cboVersionId.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1234 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53738300 | clbBuilding.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1208 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-a1b2b594 | clbBuilding.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1208 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bac1f88c | clbBuilding.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1209 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0121c44a | clbBuilding.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1209 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-b474be1a | clbBuilding.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1209 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e30bd636 | clbBuilding.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1210 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.ClbGroup_SelectedIndexChanged

진입점: clbGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14e89c0a | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1175 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-73a4031b | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1175 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79fb06b3 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1176 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0cb90013 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1179 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-69855fcf | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1179 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05b05f66 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1180 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55e69539 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1183 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-7f8c8bbc | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1183 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID,pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a09f972f | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1184 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ecf994c2 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1176 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-eca92e34 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1176 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cdb54b41 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1177 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d93d5587 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1180 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-c197f706 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1180 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28fff4f7 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1181 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6c843655 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1184 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-2b9250fd | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1184 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID,pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1bb29a49 | clbGroup.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1185 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6de328e2 | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1193 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b3b0251 | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1193 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-315697e1 | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1194 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e019023 | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1197 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e8fa9ea | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1197 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f13be87 | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1198 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e945afc5 | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1194 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b8a1cfd | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1194 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd19ac0e | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1195 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-218400bb | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1198 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-5bcd0a5a | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1198 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cc4ce23a | clbPlant.SelectedIndexChanged | SCP0054_CAPA_SIMULATION.cs:1199 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaf9d862 | this.Load | SCP0054_CAPA_SIMULATION.cs:319 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d273a83c | this.Load | SCP0054_CAPA_SIMULATION.cs:321 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8083dba | this.Load | SCP0054_CAPA_SIMULATION.cs:322 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8543b96c | this.Load | SCP0054_CAPA_SIMULATION.cs:326 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df9b56f0 | this.Load | SCP0054_CAPA_SIMULATION.cs:320 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6d12814 | this.Load | SCP0054_CAPA_SIMULATION.cs:322 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-343d7559 | this.Load | SCP0054_CAPA_SIMULATION.cs:323 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f440bb29 | this.Load | SCP0054_CAPA_SIMULATION.cs:327 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b0d78af | this.Load | SCP0054_CAPA_SIMULATION.cs:217 |  | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f30ac4b | this.Load | SCP0054_CAPA_SIMULATION.cs:217 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-647db1dd | this.Load | SCP0054_CAPA_SIMULATION.cs:218 |  | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ece5829 | this.Load | SCP0054_CAPA_SIMULATION.cs:218 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0054_CAPA_SIMULATION.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84bea87c | Dispose | SCP0054_CAPA_SIMULATION.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-d0359ea5 | Dispose | SCP0054_CAPA_SIMULATION.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0054_CAPA_SIMULATION.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0791da1b | EditButton | SCP0054_CAPA_SIMULATION.cs:423 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3751f9f0 | EditButton | SCP0054_CAPA_SIMULATION.cs:424 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d00082a9 | EditButton | SCP0054_CAPA_SIMULATION.cs:435 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-20010ce0 | EditButton | SCP0054_CAPA_SIMULATION.cs:460 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, 0, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dec5ebed | EditButton | SCP0054_CAPA_SIMULATION.cs:467 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-45aa5b3a | EditButton | SCP0054_CAPA_SIMULATION.cs:473 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, 4, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a73b88c | EditButton | SCP0054_CAPA_SIMULATION.cs:476 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-337fa3d4 | EditButton | SCP0054_CAPA_SIMULATION.cs:485 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7c9c6009 | EditButton | SCP0054_CAPA_SIMULATION.cs:486 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.Sheet(0).Rows.Count-1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ffb49a05 | EditButton | SCP0054_CAPA_SIMULATION.cs:496 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.Sh… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50b43962 | EditButton | SCP0054_CAPA_SIMULATION.cs:424 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48635d09 | EditButton | SCP0054_CAPA_SIMULATION.cs:425 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-47fd337c | EditButton | SCP0054_CAPA_SIMULATION.cs:436 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1dd98365 | EditButton | SCP0054_CAPA_SIMULATION.cs:461 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, 0, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-744899ac | EditButton | SCP0054_CAPA_SIMULATION.cs:468 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-594cfb56 | EditButton | SCP0054_CAPA_SIMULATION.cs:474 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, 4, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e081ceee | EditButton | SCP0054_CAPA_SIMULATION.cs:477 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8b8440c | EditButton | SCP0054_CAPA_SIMULATION.cs:486 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5a542c20 | EditButton | SCP0054_CAPA_SIMULATION.cs:487 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.Sheet(0).Rows.Count-1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-19401255 | EditButton | SCP0054_CAPA_SIMULATION.cs:497 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.Sh… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, 2, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0054_CAPA_SIMULATION.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9f8b9e9 | FindButton | SCP0054_CAPA_SIMULATION.cs:563 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-af4a746e | FindButton | SCP0054_CAPA_SIMULATION.cs:566 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bdcd16c0 | FindButton | SCP0054_CAPA_SIMULATION.cs:566 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66154e02 | FindButton | SCP0054_CAPA_SIMULATION.cs:577 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326" , new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39435370 | FindButton | SCP0054_CAPA_SIMULATION.cs:578 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-9bfe935a | FindButton | SCP0054_CAPA_SIMULATION.cs:579 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed89b007 | FindButton | SCP0054_CAPA_SIMULATION.cs:584 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0e48070c | FindButton | SCP0054_CAPA_SIMULATION.cs:587 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2961f9da | FindButton | SCP0054_CAPA_SIMULATION.cs:602 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-36435c2b | FindButton | SCP0054_CAPA_SIMULATION.cs:603 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d311f266 | FindButton | SCP0054_CAPA_SIMULATION.cs:607 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0054_GET_CAPA_SIMULATION") ⇒ SCP.SCP0054_GET_CAPA_SIMULATION | 엔드포인트 요청 생성 |  |  |  |
| AC-d7543ddb | FindButton | SCP0054_CAPA_SIMULATION.cs:608 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dbbcead5 | FindButton | SCP0054_CAPA_SIMULATION.cs:609 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-bcf21f09 | FindButton | SCP0054_CAPA_SIMULATION.cs:610 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-736aa478 | FindButton | SCP0054_CAPA_SIMULATION.cs:611 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-b15bb075 | FindButton | SCP0054_CAPA_SIMULATION.cs:612 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-fe1e3768 | FindButton | SCP0054_CAPA_SIMULATION.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-46f3ec49 | FindButton | SCP0054_CAPA_SIMULATION.cs:614 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-441f882f | FindButton | SCP0054_CAPA_SIMULATION.cs:615 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-0483f834 | FindButton | SCP0054_CAPA_SIMULATION.cs:616 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-6ee4cc1c | FindButton | SCP0054_CAPA_SIMULATION.cs:617 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a575d4ad | FindButton | SCP0054_CAPA_SIMULATION.cs:618 | try ▸ lambda | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e16acc13 | FindButton | SCP0054_CAPA_SIMULATION.cs:619 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | pPlanStartYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7e52541d | FindButton | SCP0054_CAPA_SIMULATION.cs:620 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | pPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-96020f52 | FindButton | SCP0054_CAPA_SIMULATION.cs:621 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_seq"] | pPlanSeq | 행/컬럼 값 대입 |  |  |  |
| AC-187cd52f | FindButton | SCP0054_CAPA_SIMULATION.cs:622 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9a1ee688 | FindButton | SCP0054_CAPA_SIMULATION.cs:624 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-18432aea | FindButton | SCP0054_CAPA_SIMULATION.cs:626 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ed72f4fb | FindButton | SCP0054_CAPA_SIMULATION.cs:640 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-499e35fc | FindButton | SCP0054_CAPA_SIMULATION.cs:642 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7f585d9 | FindButton | SCP0054_CAPA_SIMULATION.cs:642 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-27f2bc80 | FindButton | SCP0054_CAPA_SIMULATION.cs:644 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8577fb7f | FindButton | SCP0054_CAPA_SIMULATION.cs:646 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c78c142 | FindButton | SCP0054_CAPA_SIMULATION.cs:649 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a2d40023 | FindButton | SCP0054_CAPA_SIMULATION.cs:651 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97c9591f | FindButton | SCP0054_CAPA_SIMULATION.cs:664 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e4b993bc | FindButton | SCP0054_CAPA_SIMULATION.cs:665 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-980de502 | FindButton | SCP0054_CAPA_SIMULATION.cs:669 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b8782f38 | FindButton | SCP0054_CAPA_SIMULATION.cs:673 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ec9eed66 | FindButton | SCP0054_CAPA_SIMULATION.cs:564 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9811cc04 | FindButton | SCP0054_CAPA_SIMULATION.cs:567 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-67df234d | FindButton | SCP0054_CAPA_SIMULATION.cs:567 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-785dbc6c | FindButton | SCP0054_CAPA_SIMULATION.cs:578 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326" , new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9d0c61b | FindButton | SCP0054_CAPA_SIMULATION.cs:579 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-e225dcc5 | FindButton | SCP0054_CAPA_SIMULATION.cs:580 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9432f286 | FindButton | SCP0054_CAPA_SIMULATION.cs:585 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-da68d19d | FindButton | SCP0054_CAPA_SIMULATION.cs:588 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b261cb4 | FindButton | SCP0054_CAPA_SIMULATION.cs:603 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ad7d0265 | FindButton | SCP0054_CAPA_SIMULATION.cs:604 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fbdc6cc1 | FindButton | SCP0054_CAPA_SIMULATION.cs:608 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0054_GET_CAPA_SIMULATION") ⇒ SCP.SCP0054_GET_CAPA_SIMULATION | 엔드포인트 요청 생성 |  |  |  |
| AC-a5ec1063 | FindButton | SCP0054_CAPA_SIMULATION.cs:609 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c39d2493 | FindButton | SCP0054_CAPA_SIMULATION.cs:610 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-56f41f30 | FindButton | SCP0054_CAPA_SIMULATION.cs:611 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-c5df1a0f | FindButton | SCP0054_CAPA_SIMULATION.cs:612 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-cb08d7f8 | FindButton | SCP0054_CAPA_SIMULATION.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-39332bc7 | FindButton | SCP0054_CAPA_SIMULATION.cs:614 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-a5e05ed2 | FindButton | SCP0054_CAPA_SIMULATION.cs:615 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-f2413190 | FindButton | SCP0054_CAPA_SIMULATION.cs:616 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-ee09435d | FindButton | SCP0054_CAPA_SIMULATION.cs:617 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-99f51381 | FindButton | SCP0054_CAPA_SIMULATION.cs:618 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b0a29017 | FindButton | SCP0054_CAPA_SIMULATION.cs:619 | try ▸ lambda | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-41479839 | FindButton | SCP0054_CAPA_SIMULATION.cs:620 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | pPlanStartYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ab8137e6 | FindButton | SCP0054_CAPA_SIMULATION.cs:621 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | pPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-b86bbe55 | FindButton | SCP0054_CAPA_SIMULATION.cs:622 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_seq"] | pPlanSeq | 행/컬럼 값 대입 |  |  |  |
| AC-fb758b75 | FindButton | SCP0054_CAPA_SIMULATION.cs:623 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ff3c3daa | FindButton | SCP0054_CAPA_SIMULATION.cs:625 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25b13b12 | FindButton | SCP0054_CAPA_SIMULATION.cs:627 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4295f6bd | FindButton | SCP0054_CAPA_SIMULATION.cs:641 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-a7179c04 | FindButton | SCP0054_CAPA_SIMULATION.cs:643 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f867be8 | FindButton | SCP0054_CAPA_SIMULATION.cs:643 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b7e41056 | FindButton | SCP0054_CAPA_SIMULATION.cs:645 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8c162591 | FindButton | SCP0054_CAPA_SIMULATION.cs:647 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-71ef9d43 | FindButton | SCP0054_CAPA_SIMULATION.cs:650 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-938961b8 | FindButton | SCP0054_CAPA_SIMULATION.cs:652 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63d5ad23 | FindButton | SCP0054_CAPA_SIMULATION.cs:665 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0373283c | FindButton | SCP0054_CAPA_SIMULATION.cs:666 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04a4ba32 | FindButton | SCP0054_CAPA_SIMULATION.cs:670 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0f8eac30 | FindButton | SCP0054_CAPA_SIMULATION.cs:674 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0054_CAPA_SIMULATION.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8df78c56 | this.Load | SCP0054_CAPA_SIMULATION.cs:204 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-154a540d | this.Load | SCP0054_CAPA_SIMULATION.cs:205 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0054_CAPA_SIMULATION.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd5567b8 | this.Load | SCP0054_CAPA_SIMULATION.cs:715 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0054_GET_DAY_RANGE") ⇒ SCP.SCP0054_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-f9f144a6 | this.Load | SCP0054_CAPA_SIMULATION.cs:716 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-09972a4e | this.Load | SCP0054_CAPA_SIMULATION.cs:717 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-0e925abd | this.Load | SCP0054_CAPA_SIMULATION.cs:719 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90ab3e91 | this.Load | SCP0054_CAPA_SIMULATION.cs:719 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-fd302b9d | this.Load | SCP0054_CAPA_SIMULATION.cs:716 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0054_GET_DAY_RANGE") ⇒ SCP.SCP0054_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-b83862e6 | this.Load | SCP0054_CAPA_SIMULATION.cs:717 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2cb82a28 | this.Load | SCP0054_CAPA_SIMULATION.cs:718 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-148b1f9d | this.Load | SCP0054_CAPA_SIMULATION.cs:720 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ef00077 | this.Load | SCP0054_CAPA_SIMULATION.cs:720 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0054_CAPA_SIMULATION.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ea10ba8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:681 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0054_GET_SHEET_CALENDAR") ⇒ SCP.SCP0054_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-2cb6e5c0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:685 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-cfbcfecd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:686 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-cda44110 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:687 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-d2d8b92c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:689 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4ec19025 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:689 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2ec50f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:682 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0054_GET_SHEET_CALENDAR") ⇒ SCP.SCP0054_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-07cd6fa4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:686 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-cc86105d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:687 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ab06d601 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:688 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-bf151d1d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:690 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8eca7790 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:690 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0054_CAPA_SIMULATION.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc28326d | this.Load | SCP0054_CAPA_SIMULATION.cs:222 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c867f25c | this.Load | SCP0054_CAPA_SIMULATION.cs:225 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-966b7374 | this.Load | SCP0054_CAPA_SIMULATION.cs:228 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7834ac8 | this.Load | SCP0054_CAPA_SIMULATION.cs:229 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f3fd9e8 | this.Load | SCP0054_CAPA_SIMULATION.cs:230 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a936de61 | this.Load | SCP0054_CAPA_SIMULATION.cs:234 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-85dd1cdc | this.Load | SCP0054_CAPA_SIMULATION.cs:235 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-74e2e704 | this.Load | SCP0054_CAPA_SIMULATION.cs:236 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-ae900a97 | this.Load | SCP0054_CAPA_SIMULATION.cs:238 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | HardCodeService.MatchCodeFp("SCP0049_CAPA", "DIVORDER1", dr["CODE"]) ? 1 : HardCodeService… | 행/컬럼 값 대입 |  |  |  |
| AC-0a5cf326 | this.Load | SCP0054_CAPA_SIMULATION.cs:238 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER1", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-feacb7bf | this.Load | SCP0054_CAPA_SIMULATION.cs:238 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER2", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d234a5f8 | this.Load | SCP0054_CAPA_SIMULATION.cs:239 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99bed0c7 | this.Load | SCP0054_CAPA_SIMULATION.cs:242 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-cca79285 | this.Load | SCP0054_CAPA_SIMULATION.cs:243 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9344b524 | this.Load | SCP0054_CAPA_SIMULATION.cs:245 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8d7fd75 | this.Load | SCP0054_CAPA_SIMULATION.cs:247 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e257e0bb | this.Load | SCP0054_CAPA_SIMULATION.cs:248 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4460f757 | this.Load | SCP0054_CAPA_SIMULATION.cs:248 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1160d5ec | this.Load | SCP0054_CAPA_SIMULATION.cs:251 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-54e115b8 | this.Load | SCP0054_CAPA_SIMULATION.cs:257 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-f65cf2a0 | this.Load | SCP0054_CAPA_SIMULATION.cs:258 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-caa1ea9c | this.Load | SCP0054_CAPA_SIMULATION.cs:260 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-2be65ac7 | this.Load | SCP0054_CAPA_SIMULATION.cs:261 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-933180f1 | this.Load | SCP0054_CAPA_SIMULATION.cs:263 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-0e3a17d9 | this.Load | SCP0054_CAPA_SIMULATION.cs:270 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-fcbe0f2a | this.Load | SCP0054_CAPA_SIMULATION.cs:223 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-30fa687a | this.Load | SCP0054_CAPA_SIMULATION.cs:226 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-9690e6e3 | this.Load | SCP0054_CAPA_SIMULATION.cs:229 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bb234ab5 | this.Load | SCP0054_CAPA_SIMULATION.cs:230 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-b378d13b | this.Load | SCP0054_CAPA_SIMULATION.cs:231 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-97cc1636 | this.Load | SCP0054_CAPA_SIMULATION.cs:235 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1edf9c31 | this.Load | SCP0054_CAPA_SIMULATION.cs:236 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-83da4088 | this.Load | SCP0054_CAPA_SIMULATION.cs:237 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-f961ef2c | this.Load | SCP0054_CAPA_SIMULATION.cs:238 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-ea73d84d | this.Load | SCP0054_CAPA_SIMULATION.cs:240 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-799deef5 | this.Load | SCP0054_CAPA_SIMULATION.cs:243 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-3d2e146c | this.Load | SCP0054_CAPA_SIMULATION.cs:244 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-462b1b36 | this.Load | SCP0054_CAPA_SIMULATION.cs:246 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2970db0 | this.Load | SCP0054_CAPA_SIMULATION.cs:248 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-463c13eb | this.Load | SCP0054_CAPA_SIMULATION.cs:249 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-56ecd60b | this.Load | SCP0054_CAPA_SIMULATION.cs:249 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b83c0c0 | this.Load | SCP0054_CAPA_SIMULATION.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c8ec4872 | this.Load | SCP0054_CAPA_SIMULATION.cs:258 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-072b5889 | this.Load | SCP0054_CAPA_SIMULATION.cs:259 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-0cfe349a | this.Load | SCP0054_CAPA_SIMULATION.cs:261 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-768f3f39 | this.Load | SCP0054_CAPA_SIMULATION.cs:262 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-735689e0 | this.Load | SCP0054_CAPA_SIMULATION.cs:264 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-5c0d000d | this.Load | SCP0054_CAPA_SIMULATION.cs:271 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f422aed4 | this.Load 외 2 | SCP0054_CAPA_SIMULATION.cs:334 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f18f6753 | this.Load 외 2 | SCP0054_CAPA_SIMULATION.cs:338 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9bfd25c3 | this.Load 외 2 | SCP0054_CAPA_SIMULATION.cs:339 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-09e7628d | this.Load 외 2 | SCP0054_CAPA_SIMULATION.cs:335 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3b59629e | this.Load 외 2 | SCP0054_CAPA_SIMULATION.cs:339 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0833c298 | this.Load 외 2 | SCP0054_CAPA_SIMULATION.cs:340 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0054_CAPA_SIMULATION.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006f4264 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:706 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 90, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffecb84c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:707 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 90, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0054_CAPA_SIMULATION.Re_Design

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fc8f0df | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:741 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount) ▸ if (DefColumnsLossCode.XP001 == sLossCode \|\| DefColumnsLo… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, lastIdx, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4910771 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:742 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount) ▸ if (DefColumnsLossCode.XP001 == sLossCode \|\| DefColumnsLo… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, lastIdx, 0, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0054_CAPA_SIMULATION.Set_Calculator

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sAction == CAppSetting.StringM && e.Column > 0)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5f3787b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:815 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d99691e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:815 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-59cfb8fd | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:862 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-c72a3f5b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:866 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-c62a455f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:870 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-626dc3eb | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:890 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | DATA_OP | htXP001.Add | (sItemId, dXP001Temp) | 데이터 객체 조작/조회 |  |  |  |
| AC-53e2f04f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:913 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | htXP003.GetEnumerator | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca6d4de0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:917 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | myEnumerator.MoveNext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-15c924b5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:928 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | htXP001.GetEnumerator | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f367522 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:929 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | eHXP001.MoveNext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f05d362 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:948 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ if (DefColumnsLossCode.XB020 == sLossCode) | GRID_SET | siMain.SetValue | (row, col, dXB020) | 그리드 값 설정 |  |  |  |
| AC-68bb5f83 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:955 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-febecff5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:960 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dLoadTime) | 그리드 값 설정 |  |  |  |
| AC-d8bf413a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:968 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-eeca3e4a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:973 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE500) | 그리드 값 설정 |  |  |  |
| AC-1ea7ed22 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:980 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE501) | 그리드 값 설정 |  |  |  |
| AC-16c9280d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:988 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dM08) | 그리드 값 설정 |  |  |  |
| AC-aeb5205f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:994 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-19eac35b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:998 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXP002) | 그리드 값 설정 |  |  |  |
| AC-d653bb6d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1010 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | DATA_OP | htXP003.Add | (sItemId, xx) | 데이터 객체 조작/조회 |  |  |  |
| AC-c358f57e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1012 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-e9c4ff0e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1017 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | DATA_OP | htXP003.Add | (sItemId, xx) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d769b56 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1022 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXP004) | 그리드 값 설정 |  |  |  |
| AC-5b9cadb8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1025 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | CALL_EXT | htXP003.GetEnumerator | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8763a28 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1028 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | CALL_EXT | myEnumerator.MoveNext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-317c7a41 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1044 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP008, col, dMaxResult) | 그리드 값 설정 |  |  |  |
| AC-063b0869 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1045 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP009, col, dMinResult) | 그리드 값 설정 |  |  |  |
| AC-99d15def | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1049 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXP005) | 그리드 값 설정 |  |  |  |
| AC-a404944e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1055 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP006, col, dResult1) | 그리드 값 설정 |  |  |  |
| AC-68f6c79b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1059 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP007, col, dResult2) | 그리드 값 설정 |  |  |  |
| AC-af76bd0a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:816 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-e160b3a6 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:816 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4ffbc42 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:863 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c13e2a1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:867 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd790e16 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:871 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b540ee8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:891 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | DATA_OP | htXP001.Add | (sItemId, dXP001Temp) | 데이터 객체 조작/조회 |  |  |  |
| AC-150d4280 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:914 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | htXP003.GetEnumerator | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f43f74de | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:918 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | myEnumerator.MoveNext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-23e27bf2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:929 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | htXP001.GetEnumerator | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6de4652 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:930 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | CALL_EXT | eHXP001.MoveNext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0476cfd3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:949 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ if (DefColumnsLossCode.XB020 == sLossCode) | GRID_SET | siMain.SetValue | (row, col, dXB020) | 그리드 값 설정 |  |  |  |
| AC-eac8c2d2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:956 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-204a935d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:961 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dLoadTime) | 그리드 값 설정 |  |  |  |
| AC-d682d6f4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:969 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-00e55df2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:974 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE500) | 그리드 값 설정 |  |  |  |
| AC-5ef9ed0e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:981 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE501) | 그리드 값 설정 |  |  |  |
| AC-1258137d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:989 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dM08) | 그리드 값 설정 |  |  |  |
| AC-8470dbb3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:995 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-cca201f3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:999 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXP002) | 그리드 값 설정 |  |  |  |
| AC-4ef18fe1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1011 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | DATA_OP | htXP003.Add | (sItemId, xx) | 데이터 객체 조작/조회 |  |  |  |
| AC-85ea592e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1013 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-64a69454 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1018 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | DATA_OP | htXP003.Add | (sItemId, xx) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e729a1d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1023 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXP004) | 그리드 값 설정 |  |  |  |
| AC-088fb89c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1026 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | CALL_EXT | htXP003.GetEnumerator | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a319736b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1029 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | CALL_EXT | myEnumerator.MoveNext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb0c7a62 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1045 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP008, col, dMaxResult) | 그리드 값 설정 |  |  |  |
| AC-99fb549f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1046 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP009, col, dMinResult) | 그리드 값 설정 |  |  |  |
| AC-6d94ab8a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1050 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXP005) | 그리드 값 설정 |  |  |  |
| AC-36ef2844 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1056 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP006, col, dResult1) | 그리드 값 설정 |  |  |  |
| AC-38b9610f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | SCP0054_CAPA_SIMULATION.cs:1060 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (iColXP007, col, dResult2) | 그리드 값 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.Set_CalculatorBestWorst

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34beed38 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1074 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a7b09ff | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1078 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f248e2c3 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1080 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8201dbd0 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1097 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-88c569fe | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1097 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-13d97a0b | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1102 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7202dab2 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1102 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-a712ecc2 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1105 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | GRID_SET | siMain.SetValue | (row, col, value) | 그리드 값 설정 |  |  |  |
| AC-4f11ef4f | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1109 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST_RESULT… | CALL_EXT | siMain.GetColumnText | (0, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2a9f723 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1116 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST_RESULT… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-46e641fb | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1075 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-d73f1583 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1079 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8593cad | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1081 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f784ca89 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1098 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f0a354a | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1098 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8698302 | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1103 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe62c30f | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1103 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-402f672d | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1106 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST_RESULT \|\|… | GRID_SET | siMain.SetValue | (row, col, value) | 그리드 값 설정 |  |  |  |
| AC-184c769e | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1110 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST_RESULT… | CALL_EXT | siMain.GetColumnText | (0, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3067f23e | FindButton [try] | SCP0054_CAPA_SIMULATION.cs:1117 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST_RESULT… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |

## SCP0054_CAPA_SIMULATION.Set_ChangeValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82cef5ff | (진입점 미연결) | SCP0054_CAPA_SIMULATION.cs:1301 | if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable && sColName.StartsWith("D_")) | GRID_SET | siMain.SetValue | (row, newColIdx, oldValue) | 그리드 값 설정 |  |  |  |
| AC-c577886d | (진입점 미연결) | SCP0054_CAPA_SIMULATION.cs:1302 | if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable && sColName.StartsWith("D_")) | GRID_SET | siMain.SetValue | (row, newColIdx, oldValue) | 그리드 값 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.Set_RefreshAfterSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea93e3aa | (진입점 미연결) | SCP0054_CAPA_SIMULATION.cs:752 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-05bf9d48 | (진입점 미연결) | SCP0054_CAPA_SIMULATION.cs:757 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-6f109c1e | (진입점 미연결) | SCP0054_CAPA_SIMULATION.cs:753 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-31048e56 | (진입점 미연결) | SCP0054_CAPA_SIMULATION.cs:758 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.SetBackColor

진입점: FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / EditButton [if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6ae56cb | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:519 | if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-f1d259a6 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:520 | if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-ba0985e5 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:525 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XP001 == sLossCode) | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-92666ea5 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:526 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XP001 == sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(216, 228, 1… | 그리드 표시 설정 |  |  |  |
| AC-63b9b0aa | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:530 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-69507049 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:531 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(196, 189, 1… | 그리드 표시 설정 |  |  |  |
| AC-1386c2b4 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:535 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-c936367b | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:538 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(252, 213, 1… | 그리드 표시 설정 |  |  |  |
| AC-72bdca05 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:544 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-f8660e30 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:545 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(196, 189, 1… | 그리드 표시 설정 |  |  |  |
| AC-f3c4c9d3 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:520 | if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-61462044 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:521 | if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-e53d8647 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:526 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XP001 == sLossCode) | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-9bf10fbb | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:527 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XP001 == sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(216, 228, 1… | 그리드 표시 설정 |  |  |  |
| AC-9ca96512 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:531 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-e146c602 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:532 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(196, 189, 1… | 그리드 표시 설정 |  |  |  |
| AC-2b62eb5e | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:536 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-671e33b8 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:539 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(252, 213, 1… | 그리드 표시 설정 |  |  |  |
| AC-53d5b738 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:545 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-d6d5ac1b | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for… 외 1 | SCP0054_CAPA_SIMULATION.cs:546 | else of (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ else of (DefColumnsLossCode.XP001 == sLossCode) ▸… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.FromArgb(196, 189, 1… | 그리드 표시 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.SetBackColorBef

진입점: FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0)] / EditButton [if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80e040c1 | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0)] 외 1 | SCP0054_CAPA_SIMULATION.cs:507 |  | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.UOM)+1, siMain.Sheet(0).Rows.Count - 1, siMain.GetCol… | 그리드 표시 설정 |  |  |  |
| AC-e6b7ed7a | FindButton [try ▸ if (siMain.ActiveSheet.RowCount > 0)] 외 1 | SCP0054_CAPA_SIMULATION.cs:508 |  | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.UOM)+1, siMain.Sheet(0).Rows.Count - 1, siMain.GetCol… | 그리드 표시 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-205fa851 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:279 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd47dc5e | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:279 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d2b8280 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:280 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-499a71b8 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:283 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID , pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ff69d9e | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:283 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID , pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41966449 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:284 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-15e8d8dc | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:288 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId,pGroupId… | 화면 필드/플래그 변경 |  |  |  |
| AC-e87aaf04 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:288 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c0b2bcc | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:289 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4077aee6 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:293 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-5b756031 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:293 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c86a3095 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:294 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4f00ef75 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:297 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, pDivisionID, pGroupId , "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-30fe58df | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:297 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, pDivisionID, pGroupId , "Y") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bd7c6f3 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:298 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9c17b312 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:302 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, pDivisionID, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-847d491a | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:302 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, pDivisionID, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35c87e06 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:303 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b0fe81fa | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:306 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-6f9bf6f1 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:306 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4a37aa7 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:307 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a9a5f098 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:310 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-5d864664 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:313 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-0300ce81 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:313 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2749897e | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:314 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2d6329ef | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:280 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ae7ca18 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:280 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc11a954 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:281 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-b684d430 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:284 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division , pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4e8a2c6 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:284 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division , pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9047766b | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:285 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cd567288 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:289 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId,pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c67d3ab | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:289 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5cc7d34f | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-644f32f2 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:294 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding… | 화면 필드/플래그 변경 |  |  |  |
| AC-c0df2827 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:294 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fec3eeaa | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f351cf94 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:298 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, division, pGroupId , "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-a4e05bde | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:298 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, division, pGroupId , "Y") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96e2451f | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:299 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-17d5259d | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:303 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-d303235a | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:303 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division, pVersionId) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e1d55bb | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:304 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f7bfac51 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:307 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-ae931a20 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:307 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-303b9b59 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:308 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-da178c64 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:311 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-148fd757 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:314 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-19092440 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:314 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-12310297 | this.Load 외 1 | SCP0054_CAPA_SIMULATION.cs:315 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0054_CAPA_SIMULATION.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f93d920 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1153 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-67db40b8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1154 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.SetSpreadColumnRESULT

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6be7e2dc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:377 | for (i <= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6ResultCol - i].Visible | bVisibleResult | 그리드 속성/값 설정 |  |  |  |
| AC-12b84e47 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:378 | for (i <= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6ResultCol - i].Visible | bVisibleResult | 그리드 속성/값 설정 |  |  |  |

## SCP0054_CAPA_SIMULATION.SetSpreadColumnTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b0c1495 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1134 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M6_RESULT), bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-d24e3a52 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1135 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M5_RESULT), bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-ae321cd8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1136 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M4_RESULT), bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-91919caf | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1137 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M3_RESULT), bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-e155781c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1138 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M2_RESULT), bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-18bcd097 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1139 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M1_RESULT), bef1Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-4f858381 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1135 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M6_RESULT), bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-e8d83579 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1136 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M5_RESULT), bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-ed7de237 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1137 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M4_RESULT), bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-891a4112 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1138 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M3_RESULT), bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-23306edf | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1139 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M2_RESULT), bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-15ce4115 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0054_CAPA_SIMULATION.cs:1140 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M1_RESULT), bef1Mon) | 그리드 재구성/초기화 |  |  |  |

## SCP0054_CAPA_SIMULATION.shtMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1919626a | dsdm.Changed | SCP0054_CAPA_SIMULATION.cs:1266 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f99b773f | dsdm.Changed | SCP0054_CAPA_SIMULATION.cs:1267 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

