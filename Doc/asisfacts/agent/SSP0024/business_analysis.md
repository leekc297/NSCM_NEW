# SSP0024 업무분석서 — Shipment Master Electrode

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0024)과 1차 분석서(analysis.md·web_components.md·tobe_design.md)입니다.
> Fact Pack에 없는 내용은 **확인 필요**로 적었습니다. 주석 처리된 호출(commented_calls)은 0건이므로 이 문서에 넣은 기능은 모두 현행(variant `only`) 코드에 있는 것입니다.
> 화면설계서 §5 액션 명세와 단위테스트 '근거' 열은 이 문서 §5에 적은 엔드포인트 이름을 그대로 씁니다.

## 1. 업무 목적·범위

### 1-1. 목적(사실 기반)
- 전극(Electrode)의 출하 마스터(Ship Master)를 조회·저장하는 화면입니다. 화면 클래스는 `SSP0024_ShipmentMasterElectrode`, 시트는 `Ship Master Elec`입니다.
- 저장 대상 테이블은 `SSP_MST_SHIP_MASTER_EE`(MERGE)입니다. 저장할 때 이력 테이블 `SSP_MST_SHIP_MASTER_EE_H`(INSERT)와 로그 테이블 `SCM_SYS_LOG_BATCH`(INSERT)에도 기록합니다. 근거는 `SSP.SSP0024_SAVE_SHIP_MASTER`의 참조 객체입니다.
- 관리 항목은 메타 `SCM_MST_SHEET_COLUMNS` 25행입니다. Division·Plant Site·Material·Model·Nick Name·Cell Type·Electrode Type·UOM·Pancake 환산·Pancake Roll Length·DOM/EXP·Package Type·Post Oper·Post Oper LT·Building·Box/Steelcrate/Steelrack per Cut·Remarks·생성·수정 정보가 여기에 포함됩니다.
- 이 업무의 정식 정의(업무 목적 문구)는 Fact Pack에 없어 **확인 필요**입니다.

### 1-2. 범위
| 구분 | 대상 | 근거 |
|---|---|---|
| 메인 화면 | `SSP0024_ShipmentMasterElectrode`(조회·저장·편집 권한 확인·행 추가 셀 콤보) | flow.csv |
| 팝업 | `SSP0024_ItembyDivisionPopup`(Text `"Item by DivisionPopup"`): division별 품목 조회 | flow.csv, props.csv:407 |
| 제외 | 주석 처리된 호출 0건, legacy 사본 없음 | commented_calls.csv, 파일 구성 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)
| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 메인 화면을 엽니다 | `Form_Load` > InitControls > SetChangedControl에서 `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation]을 호출합니다 | `cboPlantSite`(Plant Site) 목록이 채워집니다 | flow.csv:191 |
| S2 | 조회조건 `Div`(cboDivision)를 바꿉니다 | `ClbDivision_SelectedIndexChanged` > SetChangedControl에서 `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation]을 다시 호출하고, `txtMaterialId.Text=""`, `txtModelId.Text=""`로 비웁니다 | Plant Site 목록이 다시 채워지고 Material·Model 입력값이 지워집니다 | flow.csv:191, props.csv:194·195 |
| S3 | Material/Model 버튼을 누릅니다 | `BtnMaterialId_Click`은 `txtMaterialId.Text = sMaterialId`, `BtnModelId_Click`은 `txtModelId.Text = sModelId`를 실행합니다 | 입력란에 값이 들어갑니다(값을 어디서 받아오는지는 **확인 필요**) | props.csv:746·767 |
| S4 | 조회(FindButton)를 누릅니다 | FindData에서 `SSP.SSP0024_GET_SHIP_MASTER`(SP `SSP0024_GET_SHIP_MASTER`)를 호출합니다 | `Ship Master Elec` 시트에 결과가 표시됩니다 | flow.csv:316 |
| S5 | 편집(EditButton)을 누릅니다 | GetSSPUserCheck에서 `SSP.SSP0002_GET_USER_INFO_LIST`(SP `SSP0002_GET_USER_INFO_LIST`)를 호출합니다 | 사용자 정보를 확인합니다(편집 가부를 어떻게 판정하는지는 **확인 필요**) | flow.csv:883 |
| S6 | 행을 추가합니다(InsertRow, 진입 버튼은 **확인 필요**) | 시트가 잠겨 있지 않고 시트명이 `"Ship Master Elec"`이면 DIVISION_ID·PLANT_SITE_ID·POST_OPER·BUILDING 셀 콤보를 설정합니다 | 새 행에서 콤보로 값을 고를 수 있습니다 | grid_code.csv:374~377 |
| S7 | 그리드 콤보 값을 바꿉니다 | `SpdMain_ComboSelChange`가 DIVISION_ID·CODE 기준 행에서 `POST_OPER_LT`를 읽습니다 | 값을 어느 셀에 반영하는지는 **확인 필요** | meta_reads.csv:612~621 |
| S8 | 그리드에 붙여넣습니다 | `SpdMain_ClipboardPasted`: 붙여넣은 열이 DIVISION_ID이고 그 값이 빈값이면 PLANT_SITE_ID 셀 콤보를 빈 DataTable(`dtEmpty`)로 설정합니다 | 해당 행의 Plant Site 콤보가 비워집니다 | grid_code.csv:700 |
| S9 | 저장(SaveButton)을 누릅니다 | SaveData에서 `SSP.SSP0024_SAVE_SHIP_MASTER`(SP `SSP0024_SAVE_SHIP_MASTER`)를 호출하고, 이어서 FindData에서 `SSP.SSP0024_GET_SHIP_MASTER`로 다시 조회합니다 | MERGE로 반영되고 이력·로그가 쌓인 뒤 화면이 다시 조회됩니다 | flow.csv:467·316 |
| S10 | 팝업을 엽니다(어디서 여는지는 **확인 필요**) | 팝업 `Form_Load` > InitControls에서 `SCM.SCM0001_GET_DIVISION`과 `biz:CommonData.CommonDataList` [code=PlantSiteByDivision]을 호출하고, 이어서 FindData에서 `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`을 호출합니다 | Division·Plant Site 목록이 채워지고(두 컨트롤 모두 비활성) `Project` 시트가 자동 조회됩니다 | flow.csv:405·415·267, props.csv:188~191 |
| S11 | 팝업에서 조회 버튼(btnButtonList 또는 FindButton)을 누릅니다 | `btnButtonList_UsrButtonList_Click_Detected` 또는 FindButton > FindData에서 `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP`을 호출합니다 | `Project` 시트가 갱신됩니다 | flow.csv:267 |
| S12 | 팝업 행을 더블클릭합니다 | `spdMain_CellDoubleClick` | 동작은 **확인 필요**(선택값 반환 여부) | events.csv:357 |

## 3. 업무 흐름도 (텍스트 단계)
```
[메인 SSP0024_ShipmentMasterElectrode]
 1. 화면 열기 ─ Form_Load ─▶ InitControls ─▶ SetChangedControl
                 └─▶ biz:CommonData.CommonDataList [PlantSiteByFactoryEEOperation] ─▶ cboPlantSite
 2. Div 변경 ─ ClbDivision_SelectedIndexChanged ─▶ SetChangedControl
                 ├─▶ biz:CommonData.CommonDataList [PlantSiteByFactoryEEOperation] ─▶ cboPlantSite
                 └─▶ txtMaterialId = "", txtModelId = ""
 3. (선택) BtnMaterialId_Click / BtnModelId_Click ─▶ txtMaterialId / txtModelId 값 설정
 4. 조회 ─ FindButton ─▶ FindData ─▶ SSP.SSP0024_GET_SHIP_MASTER ─▶ [Ship Master Elec] 표시
 5. 편집 ─ EditButton ─▶ GetSSPUserCheck ─▶ SSP.SSP0002_GET_USER_INFO_LIST ─▶ (판정 로직 확인 필요)
 6. 행 추가 ─ InsertRow ─▶ (IsLock == false && SheetName == "Ship Master Elec")
                 └─▶ 셀 콤보: DIVISION_ID / PLANT_SITE_ID / POST_OPER / BUILDING
 7. 셀 편집 ─ SpdMain_ComboSelChange(POST_OPER_LT 참조) / SpdMain_ClipboardPasted(PLANT_SITE_ID 콤보 비움)
            / SpdMain_CellClick / SpdMain_KeyPress(동작 확인 필요)
 8. 저장 ─ SaveButton ─▶ SaveData ─▶ SSP.SSP0024_SAVE_SHIP_MASTER
                 └─▶ FindData ─▶ SSP.SSP0024_GET_SHIP_MASTER (재조회)

[팝업 SSP0024_ItembyDivisionPopup]
 P1. 열기 ─ Form_Load ─▶ InitControls
                 ├─▶ GetDivision ─▶ SCM.SCM0001_GET_DIVISION ─▶ clbDivisionId (Enabled=false)
                 ├─▶ GetDivisionbyPlantSiteCode ─▶ biz:CommonData.CommonDataList [PlantSiteByDivision] ─▶ clbPlantSiteId (Enabled=false)
                 └─▶ txtMaterialId = sMaterial
             └─▶ FindData ─▶ SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP ─▶ [Project] 표시
 P2. Division 변경 ─ clbDivision_SelectedIndexChanged ─▶ biz:CommonData.CommonDataList [PlantSiteByDivision]
 P3. 조회 ─ btnButtonList_UsrButtonList_Click_Detected / FindButton ─▶ FindData ─▶ SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP
 P4. 더블클릭 ─ spdMain_CellDoubleClick ─▶ (확인 필요)
```

## 4. 업무 규칙
| # | 규칙 | 구분 | 근거 |
|---:|---|---|---|
| R1 | Div(cboDivision)를 바꾸면 Plant Site 목록을 다시 조회하고, Material(txtMaterialId)·Model(txtModelId) 입력값을 빈 문자열로 초기화합니다 | 연동 | SetChangedControl:191·194·195 |
| R2 | 메인 Plant Site 목록은 공통코드 `PlantSiteByFactoryEEOperation`으로 조회합니다(SetChangedControl:189에서 GetCheckedListValue 사용) | 데이터 원천 | flow.csv:191, Fact Pack 4-2 |
| R3 | 저장이 끝나면 같은 조건으로 다시 조회합니다(SaveData > FindData) | 처리 순서 | flow.csv:316 |
| R4 | 저장은 `SSP_MST_SHIP_MASTER_EE`에 **MERGE**합니다(신규·수정을 한 SP에서 처리). 이력은 `SSP_MST_SHIP_MASTER_EE_H`에 INSERT하고, `PR_SCM_SYS_LOG_BATCH`를 거쳐 `SCM_SYS_LOG_BATCH`에 INSERT합니다. 참조 `SCM_ARR_SPL_CNT`·`SCM_ARR_SPL_VAL`의 용도는 **확인 필요**입니다 | 저장 | endpoints.csv:467 |
| R5 | 삭제(D) 처리는 Fact Pack에 없습니다(**확인 필요**) | 저장 | endpoints.csv |
| R6 | 행을 추가할 때 셀 콤보는 `siMain != null && siMain.IsLock(siMain.SheetName) == false`이고 `siMain.SheetName == "Ship Master Elec"`일 때만 설정합니다 | 그리드 | grid_code.csv:374~377 |
| R7 | 행 추가 시 PLANT_SITE_ID 콤보 데이터는 `Data.Common(Data.Type.PlantSiteByFactoryEEOperation, false, "40,81,82,81_UC")` 식으로 나온 `dtPlantSiteByFactoryForSpread`입니다 | division | grid_code.csv:375 |
| R8 | 붙여넣은 셀이 DIVISION_ID 열이고 그 값(`rDivisionID`)이 빈값이면 PLANT_SITE_ID 셀 콤보를 빈 DataTable로 설정합니다 | 그리드 | grid_code.csv:700 |
| R9 | SetCellCombo는 `"" != pdivision`일 때만 `dtRstDataTable`을 셀 콤보로 설정합니다 | 그리드/division | grid_code.csv:852 |
| R10 | `SpdMain_ComboSelChange`는 행의 DIVISION_ID·CODE 기준으로 `POST_OPER_LT`를 읽습니다. 값을 반영하는 대상 셀은 **확인 필요**입니다 | 연동 | meta_reads.csv:612~621 |
| R11 | 팝업의 Division(clbDivisionId)·Plant Site(clbPlantSiteId)는 `Enabled=false`입니다. Material은 호출 측이 넘긴 `sMaterial`로 초기화합니다 | 팝업 | props.csv:188~191 |
| R12 | 팝업은 열리자마자 자동 조회합니다(Form_Load > FindData) | 팝업 | flow.csv:267 |
| R13 | 그리드 라벨에 `*`가 붙은 컬럼은 `Div*`, `Plant Site*`, `Material*`, `DOM/EXP.*`, `Package Type*`, `Post Oper.*`, `Building*`, `Box/Cut*`, `Steelcrate/Cut*`, `Steelrack/Cut*`입니다. 이 컬럼들의 필수값 검증 로직(위치·메시지)은 Fact Pack에 없어 **확인 필요**입니다 | 필수값 | grid_effective.csv |
| R14 | SP 내부 분기 조건과 파라미터(`SSP0024_GET_SHIP_MASTER`, `SSP0024_SAVE_SHIP_MASTER`, `SSP0024_GET_ITEM_BY_DIVISION_POPUP`)는 SP 원문이 Fact Pack에 없어 **확인 필요**입니다. 참조 객체 `STRING_SPLIT`이 있으므로 구분자로 이어 붙인 다중값 파라미터를 받는 것으로 보이지만, 구체적인 형식은 **확인 필요**입니다 | SP 분기 | endpoints.csv |
| R15 | 날짜·버킷 규칙: Fact Pack에 해당 사실이 없습니다. 그리드에 CREATION_DATE·LAST_UPDATE_DATE 컬럼만 있습니다 | 날짜 | grid_effective.csv |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)
| # | 엔드포인트 | SP | 호출 위치 | 읽기 | 쓰기 |
|---:|---|---|---|---|---|
| D1 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | `SSP0024_GET_ITEM_BY_DIVISION_POPUP` | ItembyDivisionPopup.FindData:267 | SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE (REF STRING_SPLIT) | - |
| D2 | `SCM.SCM0001_GET_DIVISION` | `SCM0001_GET_DIVISION` | ItembyDivisionPopup.GetDivision:405 | SCM_MST_DIVISION | - |
| D3 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | (UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP 코드분기) | ItembyDivisionPopup.GetDivisionbyPlantSiteCode:415 | SCM_MST_SITE (REF STRING_SPLIT) | - |
| D4 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | (UP_FX_GetCommonDataList 코드분기) | ShipmentMasterElectrode.SetChangedControl:191, `<field:dtPlantSiteByFactoryForSpread>`:41 | SCM_MST_SITE, SCM_MST_FACTORY_SN (REF STRING_SPLIT) | - |
| D5 | `biz:CommonData.CommonDataList` [code=MyDivision] | (UP_FX_GetCommonDataList 코드분기) | `<field:dtMyDivision>`:37 (진입점 미연결) | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION (UserInfoContext NowGroupID) | - |
| D6 | `biz:CommonData.CommonDataList` [code=ElectrodePostOperCode] | (UP_FX_GetCommonDataList 코드분기) | `<field:dtElectrodePostOperCode>`:49 (진입점 미연결) | SCM_ADM_LOOKUP_MASTER_DETAIL (REF STRING_SPLIT) | - |
| D7 | `biz:CommonData.CommonDataList` [code=DomExpTypeCode] | (UP_FX_GetCommonDataList 코드분기) | `<field:dtDomExpTypeCode>`:51 (진입점 미연결) | SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| D8 | `biz:CommonData.CommonDataList` [code=BuildingForShipMasterElec] | (UP_FX_GetCommonDataList 코드분기) | `<field:dtBuilding>`:52 (진입점 미연결) | SCM_MST_FACTORY_SN, SCM_MST_SITE (REF STRING_SPLIT) | - |
| D9 | `biz:CommonData.CommonDataList` [code=ElectrodePackageType] | (UP_FX_GetCommonDataList 코드분기) | `<field:dtElectrodePackageType>`:55 (진입점 미연결) | SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| D10 | `SSP.SSP0024_GET_SHIP_MASTER` | `SSP0024_GET_SHIP_MASTER` | ShipmentMasterElectrode.FindData:316 | SSP_MST_SHIP_MASTER_EE, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE (REF STRING_SPLIT) | - |
| D11 | `SSP.SSP0024_SAVE_SHIP_MASTER` | `SSP0024_SAVE_SHIP_MASTER` | ShipmentMasterElectrode.SaveData:467 | (REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL) | MERGE SSP_MST_SHIP_MASTER_EE, INSERT SSP_MST_SHIP_MASTER_EE_H, INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH) |
| D12 | `SSP.SSP0002_GET_USER_INFO_LIST` | `SSP0002_GET_USER_INFO_LIST` | ShipmentMasterElectrode.GetSSPUserCheck:883 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | - |

> D5~D9는 필드 초기화식(`<field:...>`)에서 호출되며, 정적 파서가 이벤트 진입점에 연결하지 못한(unreached) 건입니다. 실행 시점(폼 인스턴스를 만들 때인지)은 **확인 필요**입니다. D4·D6·D8의 결과는 InsertRow:375~377에서 셀 콤보 데이터로 쓰입니다. D7·D9를 어디에 쓰는지는 **확인 필요**입니다.

## 6. Division·권한별 변형
| 구분 | 사실 | 근거 |
|---|---|---|
| 그리드 컬럼 | `Ship Master Elec`는 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 25컬럼(필수+기본 25 / 선택 0)이고 차이가 없습니다 | Fact Pack 10·12장 |
| 그리드 컬럼 | `Project`(팝업)는 14개 division 모두 11컬럼(하드코딩)입니다. DIVISION_NAME은 division과 관계없이 `bVisible=false`입니다 | grid_code.csv:215 |
| 셀 콤보 | PLANT_SITE_ID 콤보는 division 인자 `"40,81,82,81_UC"`로 조회합니다 | grid_code.csv:375 |
| 셀 콤보 | SetCellCombo는 `pdivision`이 빈값이 아닐 때만 설정합니다 | grid_code.csv:852 |
| 셀 콤보 | 붙여넣은 DIVISION_ID가 빈값이면 PLANT_SITE_ID 콤보를 비웁니다 | grid_code.csv:700 |
| 사용자 그룹 | MyDivision 공통코드는 `UserInfoContext.Current["NowGroupID"]`와 TB_FX_USERGROUPAUTHEXTENTION을 참조합니다(사용자 그룹 기준 division 목록). 메인 cboDivision이 이 데이터를 쓰는지는 **확인 필요**입니다 | meta_reads.csv:37 |
| 권한 | EditButton을 누르면 `SSP.SSP0002_GET_USER_INFO_LIST`로 사용자 정보를 확인합니다. 편집 가부 판정 조건은 **확인 필요**입니다 | flow.csv:883 |
| 권한 | 메뉴 권한 메타 TB_FX_GroupMenuAuth에 SSP0024 행이 12건 있습니다(값 미제공, **확인 필요**) | Fact Pack 8장 |
| 권한 | 시트 잠금(`IsLock == true`)이면 행 추가 시 콤보를 설정하지 않습니다 | grid_code.csv:374 |

## 7. 외부 인터페이스
- Fact Pack에 외부 시스템 인터페이스(I/F) 사실은 없습니다. 이 화면이 호출하는 대상은 내부 SP와 공통코드(biz)뿐입니다.

## 8. 미확정·확인 필요
| # | 항목 | 확인 방법 |
|---:|---|---|
| U1 | `<field:...>` 6건(D5~D9, D4의 필드분)의 실행 시점과 DomExpTypeCode·ElectrodePackageType 사용처 | 메인 .cs 37~55행, DOM_EXP_TYPE_CODE·PACKAGE_TYPE_CODE 셀 콤보 설정 위치 |
| U2 | InsertRow:374 `dtMyDivisionIns`의 출처 | 메인 .cs |
| U3 | InsertRow를 부르는 버튼(행 추가) | 메인 .cs / TB_FX_GroupMenuAuth |
| U4 | GetSSPUserCheck 결과로 편집 가부를 판정하는 조건 | 메인 .cs:883 주변 |
| U5 | SpdMain_ComboSelChange에서 POST_OPER_LT를 반영하는 셀 | 메인 .cs:612~621 |
| U6 | BtnMaterialId_Click / BtnModelId_Click이 여는 팝업과 반환값(sMaterialId·sModelId) | 메인 .cs:746·767 |
| U7 | 팝업을 어디서 여는지, spdMain_CellDoubleClick의 반환 동작 | 팝업 .cs |
| U8 | SpdMain_CellClick / SpdMain_KeyPress 동작 | 메인 .cs |
| U9 | 조회·저장 SP 파라미터와 내부 분기, 삭제 처리 유무 | SP 원문 |
| U10 | 필수값(`*`) 검증 로직과 메시지 | 메인 .cs SaveData |
| U11 | Fact Pack 4-2 `SaveButton:282 → PersonalSettingPopup.SaveData` 매핑(파서 오매핑 가능성) | 파서 결과 재검토 |
| U12 | 메타 TB_FX_SearchCondition 6행, TB_FX_Favorite 3행, TB_FX_MenuItemInfo 1행, SCM_ADM_DB_SCRIPT_BACKUP 7행 내용 | dbmeta CSV |
