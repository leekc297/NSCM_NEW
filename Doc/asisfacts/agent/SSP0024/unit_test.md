# SSP0024 단위테스트 — Shipment Master Electrode

> 근거: AsisFacts Fact Pack(SSP0024)입니다. 절차 열의 컨트롤명은 화면설계서 §3과 같고, 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5를 원문 그대로 따릅니다.
> 주석 처리된 호출(commented_calls)은 0건이어서 이를 대상으로 한 테스트 케이스는 없습니다.
> 기대결과 중 Fact Pack에 동작이 없는 항목은 "AS-IS와 같은 결과(**확인 필요**)"로 적었습니다. AS-IS 실행 결과를 대조해 확정해야 합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0024-001 | 초기화 | 로그인 사용자, SSP0024 메뉴 권한 있음 | 1) 메인 화면을 연다 2) `cboPlantSite` 목록을 확인한다 | - | `Form_Load`에서 `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation]이 호출되고 `cboPlantSite`에 목록이 채워진다. `usrConditionPanel1`(Top)과 `spdMain`(Fill)이 상/하로 배치된다 | `Form_Load`, `biz:CommonData.CommonDataList` [PlantSiteByFactoryEEOperation], SetChangedControl:191 |
| TC-SSP0024-002 | 초기화 | 메인 화면 열림 | 조회조건 라벨을 확인한다 | - | 라벨이 `Plant Site`(cboPlantSite), `Div`(cboDivision), `Material`(txtMaterialId), `Nick Name`(txtNickName), `Model`(txtModelId)로 표시되고, `btnMaterialId`·`btnModelId` 버튼이 있다 | props.csv 367·379·391·414·433, `usrLayoutControl2` |
| TC-SSP0024-003 | division | 메인 화면 열림, `txtMaterialId`·`txtModelId`에 값 입력 | `cboDivision`에서 다른 Div를 선택한다 | Div 값 변경(예: 40 → 81) | `ClbDivision_SelectedIndexChanged`에서 `biz:CommonData.CommonDataList` [PlantSiteByFactoryEEOperation]이 다시 호출되어 `cboPlantSite`가 갱신되고, `txtMaterialId`·`txtModelId`가 빈 문자열이 된다 | `ClbDivision_SelectedIndexChanged`, `biz:CommonData.CommonDataList`, props.csv 194·195 |
| TC-SSP0024-004 | 조회 | 조회 대상 데이터 존재 | 1) `cboDivision`·`cboPlantSite`를 선택한다 2) FindButton을 누른다 | Div, Plant Site, Material, Nick Name, Model | `SSP.SSP0024_GET_SHIP_MASTER`(SP `SSP0024_GET_SHIP_MASTER`)가 호출되고 `spdMain` 시트 `Ship Master Elec`에 결과가 표시된다 | `SSP.SSP0024_GET_SHIP_MASTER`, `SSP0024_GET_SHIP_MASTER`, `Ship Master Elec`, FindData:316 |
| TC-SSP0024-005 | 조회 | 조건에 맞는 데이터 없음 | FindButton을 누른다 | 존재하지 않는 Material 값 | `SSP.SSP0024_GET_SHIP_MASTER`가 0행을 돌려주고 `Ship Master Elec` 시트가 빈 상태로 표시된다(메시지는 **확인 필요**) | `SSP.SSP0024_GET_SHIP_MASTER`, `Ship Master Elec` |
| TC-SSP0024-006 | 조회 | SP 오류 유도(예: DB 연결 불가) | FindButton을 누른다 | - | 오류 응답을 처리하고 화면이 비정상 종료되지 않는다(메시지는 **확인 필요**) | `SSP.SSP0024_GET_SHIP_MASTER` |
| TC-SSP0024-007 | 그리드 | 조회 완료 | `spdMain`의 `Ship Master Elec` 컬럼 헤더를 확인한다 | - | 메타 25컬럼(`Div*`, `Plant Site*`, `Plant Site Code`, `Material*`, `Model`, `Nick Name`, `Cell Type`, `Electrode Type`, `UOM`, `Pancake (m/cell)`, `Pancake Roll Length`, `DOM/EXP.*`, `Package Type*`, `Post Oper.*`, `Post Oper.LT(Day)`, `Building*`, `Building Desc.`, `Box/Cut*`, `Steelcrate/Cut*`, `Steelrack/Cut*`, `Remarks`, `Created By`, `Creation Date`, `Last Updated By`, `Last Update Date`)이 표시된다. 순서·폭은 메타를 따른다(**확인 필요**) | `Ship Master Elec`, SetSheetHeaderColumn@InitSpread:221, SCM_MST_SHEET_COLUMNS 25행 |
| TC-SSP0024-008 | 그리드 | 시트 잠금 아님(IsLock == false) | 행 추가(InsertRow, 진입 버튼 **확인 필요**)를 실행하고 새 행의 콤보를 연다 | - | DIVISION_ID(dtMyDivisionIns), PLANT_SITE_ID(PlantSiteByFactoryEEOperation "40,81,82,81_UC"), POST_OPER(ElectrodePostOperCode), BUILDING(BuildingForShipMasterElec)이 콤보로 설정된다 | `Ship Master Elec`, `biz:CommonData.CommonDataList` [PlantSiteByFactoryEEOperation/ElectrodePostOperCode/BuildingForShipMasterElec], InsertRow:374~377 |
| TC-SSP0024-009 | 그리드 | 시트 잠금 상태(IsLock == true) | 행 추가를 실행한다 | - | 셀 콤보 4종이 설정되지 않는다 | `Ship Master Elec`, InsertRow:374 조건 |
| TC-SSP0024-010 | 이벤트 | 조회 완료, POST_OPER 콤보가 있는 행 | `spdMain`에서 POST_OPER 콤보 값을 바꾼다 | 다른 Post Oper 코드 | `SpdMain_ComboSelChange`가 DIVISION_ID·CODE 기준으로 POST_OPER_LT를 읽는다. 반영 대상 셀은 AS-IS와 같다(**확인 필요**) | `SpdMain_ComboSelChange`, meta_reads.csv 612~621 |
| TC-SSP0024-011 | 이벤트 | 조회 완료 | DIVISION_ID 열에 빈값을 포함한 범위를 `spdMain`에 붙여넣는다 | DIVISION_ID = "" | `SpdMain_ClipboardPasted`가 해당 행의 PLANT_SITE_ID 셀 콤보를 빈 목록(dtEmpty)으로 설정한다 | `SpdMain_ClipboardPasted`, grid_code.csv:700 |
| TC-SSP0024-012 | 이벤트 | 조회 완료 | DIVISION_ID 열에 값이 있는 범위를 `spdMain`에 붙여넣는다 | DIVISION_ID = 유효값 | PLANT_SITE_ID 콤보를 비우지 않는다. 설정 동작은 AS-IS와 같다(SetCellCombo `"" != pdivision`, **확인 필요**) | `SpdMain_ClipboardPasted`, SetCellCombo:852 |
| TC-SSP0024-013 | 이벤트 | 조회 완료 | `spdMain` 셀을 클릭한다 | 임의 셀 | `SpdMain_CellClick`이 실행되고 AS-IS와 같은 결과가 나온다(**확인 필요**) | `SpdMain_CellClick` |
| TC-SSP0024-014 | 이벤트 | 조회 완료 | `spdMain` 셀에서 키를 입력한다 | 영문/숫자 키 | `SpdMain_KeyPress`가 실행되고 AS-IS와 같은 결과가 나온다(**확인 필요**) | `SpdMain_KeyPress` |
| TC-SSP0024-015 | 이벤트 | 메인 화면 열림 | `btnMaterialId`를 누른다 | - | `BtnMaterialId_Click`이 `txtMaterialId.Text = sMaterialId`를 실행한다(sMaterialId 출처·팝업 연계는 **확인 필요**) | `BtnMaterialId_Click`, props.csv:746 |
| TC-SSP0024-016 | 이벤트 | 메인 화면 열림 | `btnModelId`를 누른다 | - | `BtnModelId_Click`이 `txtModelId.Text = sModelId`를 실행한다(sModelId 출처는 **확인 필요**) | `BtnModelId_Click`, props.csv:767 |
| TC-SSP0024-017 | 저장 | 조회 완료, 행을 수정 또는 추가 | SaveButton을 누른다 | 수정 행 1건 + 신규 행 1건 | `SSP.SSP0024_SAVE_SHIP_MASTER`(SP `SSP0024_SAVE_SHIP_MASTER`)가 호출되어 SSP_MST_SHIP_MASTER_EE에 MERGE되고, SSP_MST_SHIP_MASTER_EE_H 이력과 SCM_SYS_LOG_BATCH 로그가 INSERT된 뒤 `SSP.SSP0024_GET_SHIP_MASTER`로 다시 조회된다 | `SSP.SSP0024_SAVE_SHIP_MASTER`, `SSP0024_SAVE_SHIP_MASTER`, `SSP.SSP0024_GET_SHIP_MASTER`, SaveData:467 |
| TC-SSP0024-018 | 저장 | `*` 컬럼(예: `Material*`)을 비운 신규 행 | SaveButton을 누른다 | MATERIAL_ID = "" | 필수값 검증 결과가 AS-IS와 같다(검증 위치·메시지는 **확인 필요**) | `SSP.SSP0024_SAVE_SHIP_MASTER`, `Ship Master Elec` 라벨 `*` |
| TC-SSP0024-019 | 저장 | SP 오류 유도 | SaveButton을 누른다 | - | 오류 응답을 처리하고 재조회하지 않거나 AS-IS와 같은 동작을 한다(**확인 필요**). 데이터는 부분 반영되지 않아야 한다 | `SSP.SSP0024_SAVE_SHIP_MASTER` |
| TC-SSP0024-020 | 권한 | 편집 권한 사용자 | EditButton을 누른다 | 로그인 사용자 ID | `SSP.SSP0002_GET_USER_INFO_LIST`(SP `SSP0002_GET_USER_INFO_LIST`)가 호출되고 편집이 허용된다(판정 조건은 **확인 필요**) | `SSP.SSP0002_GET_USER_INFO_LIST`, `SSP0002_GET_USER_INFO_LIST`, GetSSPUserCheck:883 |
| TC-SSP0024-021 | 권한 | 사용자 정보 조회 결과 0건인 사용자 | EditButton을 누른다 | 미등록 사용자 | `SSP.SSP0002_GET_USER_INFO_LIST`가 빈 결과를 돌려주고 AS-IS와 같은 처리를 한다(편집 불가 여부는 **확인 필요**) | `SSP.SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0024-022 | 권한 | TB_FX_GroupMenuAuth에서 버튼 권한이 제한된 그룹 | 메인 화면을 열고 버튼 노출을 확인한다 | - | 메타 12행 기준으로 버튼이 노출되거나 숨겨진다(값은 **확인 필요**) | TB_FX_GroupMenuAuth 12행, `Ship Master Elec` |
| TC-SSP0024-023 | 초기화 | 팝업 호출 측이 sMaterial을 넘김(호출 위치 **확인 필요**) | 팝업 `SSP0024_ItembyDivisionPopup`를 연다 | sMaterial = 임의 Material | `Form_Load`에서 `SCM.SCM0001_GET_DIVISION`(SP `SCM0001_GET_DIVISION`) → `clbDivisionId`, `biz:CommonData.CommonDataList` [PlantSiteByDivision] → `clbPlantSiteId`가 채워지고, 두 컨트롤은 Enabled=false다. `txtMaterialId` = sMaterial이며 `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`으로 자동 조회된다 | `Form_Load`(팝업), `SCM.SCM0001_GET_DIVISION`, `SCM0001_GET_DIVISION`, `biz:CommonData.CommonDataList` [PlantSiteByDivision], `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0024-024 | 조회 | 팝업 열림 | `btnButtonList` 조회를 누른다 | `txtMaterialId` 값 | `btnButtonList_UsrButtonList_Click_Detected` → FindData에서 `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`(SP `SSP0024_GET_ITEM_BY_DIVISION_POPUP`)이 호출되고 시트 `Project`가 갱신된다 | `btnButtonList_UsrButtonList_Click_Detected`, `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`, `SSP0024_GET_ITEM_BY_DIVISION_POPUP`, `Project` |
| TC-SSP0024-025 | 조회 | 팝업 열림 | 팝업 FindButton을 누른다 | - | FindData에서 `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`이 호출된다 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`, FindData:267 |
| TC-SSP0024-026 | 조회 | 팝업 열림, 조건에 맞는 품목 없음 | 조회한다 | 존재하지 않는 Material | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`이 0행을 돌려주고 `Project` 시트가 빈 상태다(메시지는 **확인 필요**) | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`, `Project` |
| TC-SSP0024-027 | 조회 | 팝업 열림, SCM0001 오류 유도 | 팝업을 연다 | - | `SCM.SCM0001_GET_DIVISION` 오류 응답 시 `clbDivisionId`가 비고 화면이 비정상 종료되지 않는다(**확인 필요**) | `SCM.SCM0001_GET_DIVISION` |
| TC-SSP0024-028 | 이벤트 | 팝업 열림 | `clbDivisionId` 선택값이 바뀌게 한다(Enabled=false이므로 코드 경로로 변경) | division 변경 | `clbDivision_SelectedIndexChanged` → GetDivisionbyPlantSiteCode에서 `biz:CommonData.CommonDataList` [PlantSiteByDivision]이 호출되고 `clbPlantSiteId`가 갱신된다 | `clbDivision_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [PlantSiteByDivision] |
| TC-SSP0024-029 | 그리드 | 팝업 조회 완료 | `spdMain` 시트 `Project`의 헤더를 확인한다 | - | `division`(DIVISION_ID, 60), `Plant Site Code`(80), `Plant Site`(80), `Material`(100), `Model`(150), `Cell Type`(80), `Nick Name`(150), `Electrode Type`(80), `UOM`(60), `Pancake (m/cell)`(120)이 표시되고 DIVISION_NAME은 숨김(bVisible=false)이다 | `Project`, InitSpread:214~224 |
| TC-SSP0024-030 | 이벤트 | 팝업 조회 완료 | `spdMain` 행을 더블클릭한다 | 임의 행 | `spdMain_CellDoubleClick`이 실행되고 AS-IS와 같은 결과(선택값 반환 등, **확인 필요**)가 나온다 | `spdMain_CellDoubleClick` |
| TC-SSP0024-031 | division | division 40·81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC 사용자 각각 | 각 division으로 조회한다 | 14개 division | `Ship Master Elec` 표시 컬럼이 모든 division에서 25개로 같다 | `Ship Master Elec`, Fact Pack 10·12장, `SSP.SSP0024_GET_SHIP_MASTER` |
| TC-SSP0024-032 | division | 위 14개 division 각각 | 팝업 조회 | 14개 division | `Project` 컬럼이 모든 division에서 같다(11 정의, DIVISION_NAME 숨김) | `Project`, `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0024-033 | division | 시트 잠금 아님 | 행 추가 후 PLANT_SITE_ID 콤보 목록을 확인한다 | - | 콤보 목록이 division 인자 `"40,81,82,81_UC"`의 PlantSiteByFactoryEEOperation 결과와 같다 | `biz:CommonData.CommonDataList` [PlantSiteByFactoryEEOperation], InsertRow:375, `Ship Master Elec` |
| TC-SSP0024-034 | division | 사용자 그룹(NowGroupID)이 서로 다른 두 사용자 | 행 추가 후 DIVISION_ID 콤보를 확인한다 | - | MyDivision 기준 사용자 그룹별 division 목록이 나온다(dtMyDivisionIns와 MyDivision의 관계는 **확인 필요**) | `biz:CommonData.CommonDataList` [MyDivision], InsertRow:374 |

## 커버리지 점검
| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러(11) | `clbDivision_SelectedIndexChanged` | 028 |
| | `btnButtonList_UsrButtonList_Click_Detected` | 024 |
| | `spdMain_CellDoubleClick` | 030 |
| | `Form_Load` | 001, 023 |
| | `ClbDivision_SelectedIndexChanged` | 003 |
| | `SpdMain_CellClick` | 013 |
| | `SpdMain_ComboSelChange` | 010 |
| | `SpdMain_ClipboardPasted` | 011, 012 |
| | `SpdMain_KeyPress` | 014 |
| | `BtnMaterialId_Click` | 015 |
| | `BtnModelId_Click` | 016 |
| 엔드포인트(6) | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | 023~026, 032 |
| | `SCM.SCM0001_GET_DIVISION` | 023, 027 |
| | `biz:CommonData.CommonDataList` | 001, 003, 008, 023, 028, 033, 034 |
| | `SSP.SSP0024_GET_SHIP_MASTER` | 004~006, 017, 031 |
| | `SSP.SSP0024_SAVE_SHIP_MASTER` | 017~019 |
| | `SSP.SSP0002_GET_USER_INFO_LIST` | 020, 021 |
| 시트(2) | `Ship Master Elec` | 007~009, 031, 033 |
| | `Project` | 024, 026, 029, 032 |
| 빈 결과 / 오류 | - | 005, 006, 019, 021, 026, 027 |
