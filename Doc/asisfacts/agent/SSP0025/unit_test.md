# SSP0025 단위테스트 — Shipment Requestor PIC

> 근거: Fact Pack(SSP0025). 절차의 컨트롤명은 화면설계서 §3, 근거의 엔드포인트명은 업무분석서 §5 / 화면설계서 §5와 같습니다.
> 주석 처리된 호출은 0건이라 제외 대상이 없습니다. Fact Pack에서 동작이 확인되지 않은 항목은 기대결과에 **확인 필요**로 적었습니다. As-Is 원문으로 기대값을 확정한 뒤 실행합니다.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0025-001 | 초기화 | 로그인(SSP 권한 사용자) | 메뉴에서 SSP0025 화면을 연다 | - | `Form_Load` 실행. clbFromSite에 PlantCell 공통코드 목록이 채워진다. usrConditionPanel1(상단)과 spdMain(하단)이 표시된다 | `Form_Load`(.ctor:102) > InitControls > SetChangedControl:140, `biz:CommonData.CommonDataList` [code=PlantCell] |
| TC-SSP0025-002 | 초기화 | TC-001 | 화면 열림 시 필드 초기화 호출을 로그/트레이스로 확인한다 | - | `biz:CommonData.CommonDataList` [code=MyDivision], `biz:CommonData.YesOrNo`가 각 1회 호출된다. `dtYesOrNo` 사용처는 **확인 필요** | `<field:dtMyDivision>`:45, `<field:dtYesOrNo>`:47, `biz:CommonData.YesOrNo` |
| TC-SSP0025-003 | 그리드 | TC-001 | spdMain / spdMain_Sheet1의 컬럼 헤더를 확인한다 | - | 시트 `Shipment Requestor PIC`에 메타 19컬럼(Cell Type, Created By, Creation Date, Division, Electrode Type, Material*, Last Update Date, Last Updated By, Model, Nick Name, Part Leader, Part Leader Name, Plant Site*, Team Leader, Team Leader Name, Plant Site Code, User ID*, User Name, Valid*)이 표시된다. 순서·폭은 SCM_MST_SHEET_COLUMNS 값과 일치 | 시트 `Shipment Requestor PIC`, InitSpread:159 SetSheetHeaderColumn, grid_effective.csv |
| TC-SSP0025-004 | 그리드 | TC-003 | 이미지 셀 유형이 적용된 컬럼을 확인한다 | - | 3개 컬럼에 `cellTypeImage` 적용. 대상 컬럼은 **확인 필요** | 시트 `Shipment Requestor PIC`, InitSpread:162~164 |
| TC-SSP0025-005 | 이벤트 | TC-001 | cboDivision에서 다른 Division을 고른다 | Division 값 A → B | `CboDivision_SelectedIndexChanged` 실행. clbFromSite 목록이 Division B 기준 PlantCell 목록으로 바뀐다 | `CboDivision_SelectedIndexChanged`(InitEvent:175) > SetChangedControl:140, `biz:CommonData.CommonDataList` [code=PlantCell] |
| TC-SSP0025-006 | 조회 | 해당 조건 데이터가 SSP_MST_MODEL_USER_EE에 있음 | cboDivision, clbFromSite 선택, txtItemId·txtModelId·txtNickName 입력 후 조회(FindButton) | Division, Plant Site(복수), Material, Model, Nick Name | 시트 `Shipment Requestor PIC`에 조건에 맞는 행이 표시된다 | FindButton > FindData_Main:274, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, SP `SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-007 | 조회 | TC-001 | clbFromSite에서 Plant Site를 2개 이상 체크하고 조회한다 | Plant Site 2개 이상 | 체크한 CODE 값이 모두 조건으로 넘어가고 해당 Site 행만 조회된다(GetCheckedListValue CODE) | FindData_Main:258·259, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-008 | 조회(빈 결과) | 조건에 맞는 데이터 없음 | 존재하지 않는 Material을 txtItemId에 넣고 조회한다 | 미존재 Material | 그리드 0행. 안내 메시지 표시 여부는 **확인 필요** | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-009 | 조회(검증) | TC-001 | cboDivision을 비우고 조회한다(가능한 경우) | Division 빈값 | `Div*` 필수 표시 항목. 차단 여부·메시지는 **확인 필요** | props.csv:392 `Div*`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-010 | 권한 | 조회 완료 | 편집(EditButton)을 누른다 | - | 사용자 정보·권한 조회가 수행되고 결과에 따라 편집 가능 여부가 정해진다. 허용 조건은 **확인 필요** | EditButton > GetSSPUserCheck:511, `SSP.SSP0002_GET_USER_INFO_LIST`, SP `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0025-011 | 그리드 | 편집 가능 상태(시트 잠금 해제) | 행을 추가한다(InsertRow, 진입 버튼 **확인 필요**) | - | 신규 행 DIVISION_ID 셀이 MyDivision 콤보로, SITE_DESCRIPTION 셀이 PlantCell 콤보로 바뀐다 | InsertRow:318·320, 시트 `Shipment Requestor PIC`, `biz:CommonData.CommonDataList` [code=MyDivision]/[code=PlantCell] |
| TC-SSP0025-012 | 권한 | 시트 잠금 상태(`IsLock`=true) | 행 추가를 시도한다 | - | DIVISION_ID / SITE_DESCRIPTION 콤보가 설정되지 않는다 | InsertRow:318·320 조건 `siMain.IsLock(siMain.SheetName) == false` |
| TC-SSP0025-013 | 이벤트 | TC-011로 신규 행 생성 | 신규 행의 SITE_DESCRIPTION 셀을 클릭한다 | - | `SpdMain_CellClick` 실행. PlantCell 콤보가 다시 설정된다 | `SpdMain_CellClick`(InitEvent:172) :639·640, `biz:CommonData.CommonDataList` [code=PlantCell] |
| TC-SSP0025-014 | 이벤트 | 조회된 기존 행(Action≠"I") | 기존 행의 SITE_DESCRIPTION 셀을 클릭한다 | - | 콤보 재설정이 일어나지 않는다 | `SpdMain_CellClick`:640 조건 Action=`"I"` |
| TC-SSP0025-015 | 이벤트 | 조회 결과가 여러 화면 분량 | spdMain을 세로 스크롤한다 | - | `SpdMain_TopChange` 실행. 동작은 **확인 필요** | `SpdMain_TopChange`(InitEvent:170) |
| TC-SSP0025-016 | 이벤트 | 조회 완료 | spdMain 셀을 더블클릭한다 | - | `SpdMain_CellDoubleClick` 실행. 동작은 **확인 필요** | `SpdMain_CellDoubleClick`(InitEvent:171) |
| TC-SSP0025-017 | 이벤트 | TC-011 신규 행 | 콤보 셀(DIVISION_ID 또는 SITE_DESCRIPTION)에서 값을 고른다 | 콤보 값 | `SpdMain_ComboSelChange` 실행. 연쇄 동작은 **확인 필요** | `SpdMain_ComboSelChange`(InitEvent:173) |
| TC-SSP0025-018 | 저장 | TC-011 신규 행 입력 완료(USER_ID는 TB_FX_USER에 있는 ID) | 저장(SaveButton)을 누른다 | Division, Plant Site, Material, User ID, Valid | 사용자 ID 확인 → SSP_MST_MODEL_USER_EE MERGE → SCM_SYS_LOG_BATCH 로그 → 재조회로 그리드에 저장 행이 표시된다(호출 순서는 원문으로 확정) | SaveButton > SaveData:410, GetUserIDChk:458, FindData_Main:274, `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-019 | 저장 | 조회된 기존 행 | 기존 행의 값을 수정하고 저장한다 | 수정값 | 같은 키 행이 MERGE로 갱신되고 재조회 결과에 반영된다 | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, SP `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`(MERGE SSP_MST_MODEL_USER_EE) |
| TC-SSP0025-020 | 저장(오류) | 신규 행 | TB_FX_USER에 없는 USER_ID로 저장한다 | 미존재 User ID | 사용자 ID 확인 SP가 호출된다. 저장 중단 여부와 메시지는 **확인 필요** | GetUserIDChk:458, `SSP.SSP0025_GET_USER_ID_CHECK`, SP `SSP0025_GET_USER_ID_CHECK` |
| TC-SSP0025-021 | 저장(오류) | 신규 행 | `*` 라벨 컬럼(Material*, Plant Site*, User ID*, Valid*) 중 하나를 비우고 저장한다 | 필수 표시 컬럼 빈값 | 필수 검증 수행 여부·메시지는 **확인 필요**. SP 오류 응답 시 표시 방식도 원문으로 확정 | 시트 `Shipment Requestor PIC` 메타 라벨, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` |
| TC-SSP0025-022 | 저장 | TC-018 완료 | DB에서 로그 테이블을 조회한다 | - | SCM_SYS_LOG_BATCH에 저장 건 로그가 남아 있다 | SP `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` (EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH) |
| TC-SSP0025-023 | 이벤트 | TC-001 | txtItemId에 값을 넣고 btnItemId를 누른 뒤 팝업에서 행을 골라 닫는다 | Material 일부 값 | `btnItemId_Click` 실행. 팝업이 열리고 선택 결과가 `txtItemId.Text = popItem.ItemId`로 반영된다 | `btnItemId_Click`(InitEvent:177) :718 |
| TC-SSP0025-024 | 이벤트 | TC-001 | txtModelId에 값을 넣고 btnModelId를 누른 뒤 팝업에서 행을 골라 닫는다 | Model 일부 값 | `btnModelId_Click` 실행. 선택 결과가 `txtModelId.Text = popItem.ModelId`로 반영된다 | `btnModelId_Click`(InitEvent:178) :736 |
| TC-SSP0025-025 | 초기화(팝업) | TC-023에서 팝업 열림 | 팝업의 초기 상태를 확인한다 | 메인 txtItemId/txtModelId 값 | 팝업 `Form_Load` 실행. 팝업 txtItemId=sItemId, txtModelId=sModelId, clbDivisionId 비활성, clbFromSiteId 활성. clbFromSiteId에 FromSiteByAssembly 목록. 시트 `Project` 자동 조회 | 팝업 `Form_Load`(.ctor:172) > InitControls:201~206 > FindData:296, `biz:CommonData.CommonDataList` [code=FromSiteByAssembly], `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-026 | 그리드(팝업) | TC-025 | 팝업 spdMain / spdMain_Sheet1의 컬럼을 확인한다 | - | 시트 `Project` 표시 컬럼 10개(division, From Site Code, From Site, Material, Model, Cell Type, Nick Name, Electrode Type, UOM, Pancake (m/cell)). DIVISION_NAME은 숨김. Pancake (m/cell)은 소수 5자리 | 시트 `Project`, InitSpread:243~253 |
| TC-SSP0025-027 | 이벤트(팝업) | TC-025 | clbDivisionId 선택 변경을 일으킨다(초기 설정 포함, 사용자 조작은 Enabled=false라 불가) | DIVISION_ID | `clbDivision_SelectedIndexChanged` 실행. `c["DIVISION_ID"]` 기준으로 clbFromSiteId 목록을 다시 채운다 | `clbDivision_SelectedIndexChanged`(InitializeComponent:188) :357·358, `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] |
| TC-SSP0025-028 | 조회(팝업) | TC-025 | clbFromSiteId, txtItemId, txtModelId를 바꾸고 btnButtonList를 누른다 | From Site, Material, Model | `btnButtonList_UsrButtonList_Click_Detected` 실행. 시트 `Project`를 다시 조회한다 | `btnButtonList_UsrButtonList_Click_Detected`(InitializeComponent:281) > FindData:296, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`, SP `SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-029 | 조회(팝업) | TC-025 | 팝업 조회(FindButton)를 실행한다 | - | 시트 `Project`를 다시 조회한다 | 팝업 FindButton > FindData:296, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-030 | 조회(팝업 빈 결과) | TC-025 | 존재하지 않는 Material로 btnButtonList 조회 | 미존재 Material | 시트 `Project` 0행. 메시지 여부는 **확인 필요** | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0025-031 | 이벤트(팝업) | TC-028 결과 있음 | 팝업 spdMain 행을 더블클릭한다 | - | `spdMain_CellDoubleClick` 실행. 선택값 반환·팝업 닫힘 여부는 **확인 필요** | `spdMain_CellDoubleClick`(InitializeComponent:362), 시트 `Project` |
| TC-SSP0025-032 | division | 사용자 권한 Division이 40, 81, 82, EE인 계정(각각) | Division별로 화면을 열어 조회한다 | Division 40 / 81 / 82 / EE | 모든 Division에서 시트 `Shipment Requestor PIC` 19컬럼, 팝업 시트 `Project` 11컬럼(표시 10)이 같게 나온다(division별 변형 없음, 14개 division 동일) | Fact Pack §10·§12, 시트 `Shipment Requestor PIC`, 시트 `Project` |
| TC-SSP0025-033 | division/권한 | 권한 Division이 다른 두 계정 | 각 계정으로 행 추가 후 DIVISION_ID 콤보 목록을 비교한다 | NowGroupID 서로 다름 | 각 계정의 권한(TB_FX_USERGROUPAUTHEXTENTION) Division만 콤보에 나온다 | InsertRow:318, `biz:CommonData.CommonDataList` [code=MyDivision] |
| TC-SSP0025-034 | 권한 | TB_FX_GroupMenuAuth 12건 중 서로 다른 그룹 계정 | 그룹별로 조회·편집·저장 버튼의 사용 가능 여부를 확인한다 | 그룹별 계정 | 그룹별 C/R/U/D 값과 일치. 기대값(12행 내용)은 **확인 필요** | Fact Pack §8 TB_FX_GroupMenuAuth, `SSP.SSP0002_GET_USER_INFO_LIST` |

## 2. 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load`(메인/팝업) | 001, 025 |
| | `CboDivision_SelectedIndexChanged` | 005 |
| | `SpdMain_CellClick` | 013, 014 |
| | `SpdMain_TopChange` | 015 |
| | `SpdMain_CellDoubleClick` | 016 |
| | `SpdMain_ComboSelChange` | 017 |
| | `btnItemId_Click` | 023 |
| | `btnModelId_Click` | 024 |
| | `clbDivision_SelectedIndexChanged` | 027 |
| | `btnButtonList_UsrButtonList_Click_Detected` | 028 |
| | `spdMain_CellDoubleClick` | 031 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 001, 002, 005, 011, 013, 025, 027, 033 |
| | `biz:CommonData.YesOrNo` | 002 |
| | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | 006, 007, 008, 009, 018 |
| | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | 018, 019, 021, 022 |
| | `SSP.SSP0025_GET_USER_ID_CHECK` | 018, 020 |
| | `SSP.SSP0002_GET_USER_INFO_LIST` | 010, 034 |
| | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 025, 028, 029, 030 |
| 시트 | `Shipment Requestor PIC` | 003, 004, 011, 021, 032 |
| | `Project` | 026, 031, 032 |
| 빈 결과 / 오류 | - | 008, 009, 020, 021, 030 |
| division | 변형 없음 확인 + 권한 Division | 032, 033 |
| 주석 처리 호출 | 0건(테스트 제외 대상 없음) | - |
