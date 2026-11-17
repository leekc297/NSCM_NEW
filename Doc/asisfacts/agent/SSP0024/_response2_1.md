=== FILE: business_analysis.md ===
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

=== FILE: screen_design.md ===
# SSP0024 화면설계서 — Shipment Master Electrode

> 근거: AsisFacts Fact Pack(SSP0024)입니다. 라벨은 props.csv `Text` 원문을 그대로 옮겼습니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같습니다. §3 컨트롤명은 단위테스트 절차 열에서도 같은 이름을 씁니다.

## 1. 화면 개요
| 항목 | 내용 |
|---|---|
| 화면 ID | SSP0024 |
| 화면 명칭 | Shipment Master Electrode (메인 폼 Text `"SSP0024_ShipmentMasterElectrode"`) |
| 팝업 | `SSP0024_ItembyDivisionPopup` (Text `"Item by DivisionPopup"`) |
| 도메인/프로젝트 | SSP / `GSCM.SSP.Plan.UIL` |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, 내용 미제공) |
| Grid 구성 | HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) |
| 시트 | `Ship Master Elec`(메인, META+코드연결), `Project`(팝업, 코드 하드코딩 전용) |

## 2. 화면 레이아웃

### 2-1. 분할 구조 근거
- props.csv에 **SplitContainer(Orientation·SplitterDistance)는 0건**입니다. 분할은 Dock 구성(`Dock=Top` 조건 패널 + `Dock=Fill` 그리드)으로만 이루어지며, 두 화면 모두 **상/하 2단**입니다.
- controls.csv parent 체인:
  - `this` → `usrConditionPanel1`(Dock=Top, UsrPanelType=HidePanel) → `usrLayoutControl2`(Dock=Fill) → 조회조건 컨트롤
  - `this` → `spdMain`(Dock=Fill) → `spdMain_Sheet1`
  - `usrLayoutControl1`(Dock=Fill, 657×184): parent가 비어 있습니다. 화면에서 맡는 역할은 **확인 필요**입니다.
- 비율은 Size 높이로 계산했습니다. 메인은 41 : 533(합 574), 팝업은 50 : 524(합 574)입니다.

### 2-2. 메인 `SSP0024_ShipmentMasterElectrode` 와이어프레임
```
this (Form)                                                        [폭 1093]
├─ usrConditionPanel1  Dock=Top  1093×41  HidePanel        ── 상단 7.1% (41/574)
│   └─ usrLayoutControl2  Dock=Fill  1093×41
│       └─ layoutControlGroup2 1093×49 (한 줄, 아이템 높이 29)
│          ┌──────────────┬──────────┬───────────────┬────┬──────────────┬──────────────┬───┬────────┐
│          │Plant Site    │Div       │Material       │[🔍]│Nick Name     │Model         │[🔍]│(empty) │
│          │cboPlantSite  │cboDivision│txtMaterialId │btnM│txtNickName   │txtModelId    │btnM│emptySp │
│          │PlanSite 199  │Division135│MaterialID 185 │ 43 │NickName 198  │ModelId 179   │ 32 │ 102    │
│          └──────────────┴──────────┴───────────────┴────┴──────────────┴──────────────┴───┴────────┘
│          ※ 아이템 좌표가 없어 가로 순서는 확인 필요(위 순서는 LayoutItem 선언 순서)
├─ [공통 툴바] FindButton / SaveButton / EditButton (프레임워크 버튼, 위치 확인 필요)
└─ spdMain  Dock=Fill  1093×533                            ── 하단 92.9% (533/574)
    └─ spdMain_Sheet1 → 시트 "Ship Master Elec" (25컬럼, 메타)
(usrLayoutControl1 657×184 Dock=Fill — parent 없음, 역할 확인 필요)
```

### 2-3. 팝업 `SSP0024_ItembyDivisionPopup` 와이어프레임
```
this (Form "Item by DivisionPopup")                                [폭 985]
├─ usrConditionPanel1  Dock=Top  985×50  HidePanel         ── 상단 8.7% (50/574)
│   └─ usrLayoutControl2  Dock=Fill  985×50
│       └─ layoutControlGroup2 985×50
│          ┌────────────────┬────────────────┬──────────────┬────────────────┬──────────┐
│          │Division        │Plant Site      │Material      │btnButtonList   │(empty)   │
│          │clbDivisionId   │clbPlantSiteId  │txtMaterialId │layoutCtrlItem1 │emptySp   │
│          │lblDivision 189 │lblPlantSite 216│lbMaterialID208│ 179            │ 173      │
│          │(Enabled=false) │(Enabled=false) │(=sMaterial)  │                │          │
│          └────────────────┴────────────────┴──────────────┴────────────────┴──────────┘
│          ※ 가로 순서 확인 필요
└─ spdMain  Dock=Fill  985×524                             ── 하단 91.3% (524/574)
    └─ spdMain_Sheet1 → 시트 "Project" (11컬럼 하드코딩, CellDoubleClick)
(usrLayoutControl1 657×184 Dock=Fill — parent 없음, 역할 확인 필요)
```

## 3. 컨트롤 명세
| # | 화면 | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|---|
| C1 | 메인 | `usrLayoutControl1` | UsrLayoutControl | - | Dock=Fill, 657×184 | - | - | 역할 확인 필요(불필요 시 제외 검토) |
| C2 | 메인 | `usrConditionPanel1` | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널(접기 가능) |
| C3 | 메인 | `usrLayoutControl2` | UsrLayoutControl | `"usrLayoutControl2"`(컨트롤 Text) | Dock=Fill | - | - | 조회조건 레이아웃 |
| C4 | 메인 | `cboPlantSite` | UsrCheckedList | `"Plant Site"` (PlanSite) | PlantSiteByFactoryEEOperation 목록 | 확인 필요 | (데이터) SetChangedControl | Wijmo MultiSelect |
| C5 | 메인 | `cboDivision` | UsrCombo | `"Div"` (Division) | 원천 데이터 확인 필요 | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | Wijmo ComboBox |
| C6 | 메인 | `txtMaterialId` | UsrMultiLineEditor | `"Material"` (MaterialID) | Div 변경 시 `""` | 확인 필요 | (값 설정) `BtnMaterialId_Click` | 멀티라인 입력 |
| C7 | 메인 | `btnMaterialId` | UsrButton | `"layoutControlItem4"` (layoutControlItem5 Text, 표시 여부 확인 필요) | - | - | Click → `BtnMaterialId_Click` | 돋보기 버튼 |
| C8 | 메인 | `txtNickName` | TextEdit | `"Nick Name"` (NickName) | - | 확인 필요 | - | 텍스트 입력 |
| C9 | 메인 | `txtModelId` | UsrMultiLineEditor | `"Model"` (ModelId) | Div 변경 시 `""` | 확인 필요 | (값 설정) `BtnModelId_Click` | 멀티라인 입력 |
| C10 | 메인 | `btnModelId` | UsrButton | (layoutControlItem4, Text 없음) | - | - | Click → `BtnModelId_Click` | 돋보기 버튼 |
| C11 | 메인 | `spdMain` | FpSpread | - | Dock=Fill | - | CellClick → `SpdMain_CellClick`, ComboSelChange → `SpdMain_ComboSelChange`, ClipboardPasted → `SpdMain_ClipboardPasted`, KeyPress → `SpdMain_KeyPress` | Wijmo FlexGrid |
| C12 | 메인 | `spdMain_Sheet1` | SheetView | 시트 `Ship Master Elec` | - | - | - | FlexGrid 컬럼 정의(메타) |
| C13 | 팝업 | `usrLayoutControl1` | UsrLayoutControl | - | Dock=Fill, 657×184 | - | - | 역할 확인 필요 |
| C14 | 팝업 | `usrConditionPanel1` | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널 |
| C15 | 팝업 | `usrLayoutControl2` | UsrLayoutControl | `"usrLayoutControl2"` | Dock=Fill | - | - | 조회조건 레이아웃 |
| C16 | 팝업 | `clbDivisionId` | UsrCheckedList | `"Division"` (lblDivision) | Enabled=false, `SCM.SCM0001_GET_DIVISION` 목록 | 확인 필요 | SelectedIndexChanged → `clbDivision_SelectedIndexChanged` | MultiSelect(비활성) |
| C17 | 팝업 | `clbPlantSiteId` | UsrCheckedList | `"Plant Site"` (lblPlantSite) | Enabled=false, PlantSiteByDivision 목록 | 확인 필요 | - | MultiSelect(비활성) |
| C18 | 팝업 | `txtMaterialId` | UsrMultiLineEditor | `"Material"` (lbMaterialID) | `sMaterial`(호출 측 전달값) | 확인 필요 | - | 멀티라인 입력 |
| C19 | 팝업 | `btnButtonList` | UsrButtonList | (layoutControlItem1, Text 없음) | - | - | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼 그룹(조회) |
| C20 | 팝업 | `spdMain` | FpSpread | - | Dock=Fill | - | CellDoubleClick → `spdMain_CellDoubleClick` | Wijmo FlexGrid |
| C21 | 팝업 | `spdMain_Sheet1` | SheetView | 시트 `Project` | - | - | - | FlexGrid 컬럼 정의(하드코딩) |
| C22 | 메인·팝업 | 폼(this) | Form | 메인 `"SSP0024_ShipmentMasterElectrode"` / 팝업 `"Item by DivisionPopup"` | - | - | Load → `Form_Load` | 페이지 / 모달 |

## 4. 그리드 명세

### 4-1. 시트 `Ship Master Elec` (메인 · META+코드연결)
- 생성 순서: CreateSpread:206 AddSheet(`Ship Master Elec`, 1, 1, 30) → GetSheetInfo:207 → ChangeSheet:208 → InitSpread:221 `SetSheetHeaderColumn(siMain, 1)`. 메타는 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0024) 25행입니다.
- 폭·정렬·셀 타입·고정·대문자·최대길이는 메타 값이 Fact Pack에 없어 **확인 필요**입니다. 아래 표는 grid_effective.csv 순서(알파벳순)이며, 실제 표시 순서도 **확인 필요**입니다.
- 편집 가능 여부: 메타 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE) 값이 미제공이어서 **확인 필요**입니다. 콤보 컬럼 4개는 코드 사실이 있습니다.

| # | 컬럼 | 헤더(메타 원문) | 타입 | 출처 | division별 표시(14개) | 편집 |
|---:|---|---|---|---|---|---|
| 1 | BOX_PER_CUT | `Box/Cut*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 2 | BUILDING | `Building*` | 콤보(InsertRow:377 `dtBuilding`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 3 | BUILDING_DESC | `Building Desc.` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 4 | CELL_TYPE | `Cell Type` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 5 | CREATED_BY | `Created By` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 6 | CREATION_DATE | `Creation Date` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 7 | DIVISION_ID | `Div*` | 콤보(InsertRow:374 `dtMyDivisionIns`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 8 | DOM_EXP_TYPE_CODE | `DOM/EXP.*` | 확인 필요(dtDomExpTypeCode 연결 여부) | META | 전 division 기본 | 확인 필요 |
| 9 | ELECTRODE_TYPE | `Electrode Type` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 10 | ITEM_UOM | `UOM` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 11 | LAST_UPDATE_DATE | `Last Update Date` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 12 | LAST_UPDATED_BY | `Last Updated By` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 13 | MATERIAL_ID | `Material*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 14 | MODEL_ID | `Model` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 15 | NICK_NAME | `Nick Name` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 16 | PACKAGE_TYPE_CODE | `Package Type*` | 확인 필요(dtElectrodePackageType 연결 여부) | META | 전 division 기본 | 확인 필요 |
| 17 | PC_ROLL_LENGTH | `Pancake Roll Length` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 18 | PLANT_SITE_CODE | `Plant Site Code` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 19 | PLANT_SITE_ID | `Plant Site*` | 콤보(InsertRow:375 `dtPlantSiteByFactoryForSpread` "40,81,82,81_UC" / Paste:700 `dtEmpty`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 20 | POST_OPER | `Post Oper.*` | 콤보(InsertRow:376 `dtElectrodePostOperCode`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 21 | POST_OPER_LT | `Post Oper.LT(Day)` | 확인 필요(ComboSelChange:621에서 POST_OPER_LT 참조) | META | 전 division 기본 | 확인 필요 |
| 22 | REMARKS | `Remarks` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 23 | STEELCRATE_PER_CUT | `Steelcrate/Cut*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 24 | STEELRACK_PER_CUT | `Steelrack/Cut*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 25 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | 확인 필요 | META | 전 division 기본 | 확인 필요 |

헤더 스타일(OVERRIDE, 메인 Designer 469~472): HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`"ColumnHeaderDefaultEnhanced"`, VerticalAlignment=General.

### 4-2. 시트 `Project` (팝업 · 코드 하드코딩 전용)
생성 순서: CreateSpread:202 AddSheet(`Project`, 1, 1, 30) → GetSheetInfo:203 → ChangeSheet:204 → InitSpread:214~224 AddTextColumn 11개. 병합은 모두 None입니다.

| # | 컬럼 | 헤더 원문 | 타입 | 출처 | 폭 | 표시 | 정렬 | division별 표시 | 편집 |
|---:|---|---|---|---|---:|---|---|---|---|
| 1 | DIVISION_ID | `division` | Text | HARDCODED | 60 | true | Center/Center | 14개 동일 | 확인 필요 |
| 2 | DIVISION_NAME | `division` | Text | HARDCODED | 80 | **false** | - | 14개 동일(숨김) | - |
| 3 | PLANT_SITE_CODE | `Plant Site Code` | Text | HARDCODED | 80 | true | 지정 없음 | 14개 동일 | 확인 필요 |
| 4 | PLANT_SITE_ID | `Plant Site` | Text | HARDCODED | 80 | true | Center/Center | 14개 동일 | 확인 필요 |
| 5 | MATERIAL_ID | `Material` | Text | HARDCODED | 100 | true | Center/Center | 14개 동일 | 확인 필요 |
| 6 | MODEL_ID | `Model` | Text | HARDCODED | 150 | true | Center/Center | 14개 동일 | 확인 필요 |
| 7 | CELL_TYPE | `Cell Type` | Text | HARDCODED | 80 | true | Center/Center | 14개 동일 | 확인 필요 |
| 8 | NICK_NAME | `Nick Name` | Text | HARDCODED | 150 | true | Center/Center | 14개 동일 | 확인 필요 |
| 9 | ELECTRODE_TYPE | `Electrode Type` | Text | HARDCODED | 80 | true | Center/Center | 14개 동일 | 확인 필요 |
| 10 | ITEM_UOM | `UOM` | Text | HARDCODED | 60 | true | Center/Center | 14개 동일 | 확인 필요 |
| 11 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | Text | HARDCODED | 120 | true | 지정 없음 | 14개 동일 | 확인 필요 |

헤더 스타일(OVERRIDE, 팝업 Designer 373~376): 메인과 같습니다.
> grid_effective는 `Project`를 11컬럼으로 집계하지만, DIVISION_NAME이 `bVisible=false`이므로 실제로 보이는 컬럼은 10개로 보입니다(**확인 필요**).

## 5. 액션 명세
| # | 화면 | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|---|
| A1 | 메인 | this.Load | `Form_Load` | InitControls > SetChangedControl | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | `cboPlantSite` 목록 |
| A2 | 메인 | cboDivision.SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | SetChangedControl: Plant Site 재조회, `txtMaterialId`·`txtModelId` = "" | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | `cboPlantSite` 재구성, 입력값 초기화 |
| A3 | 메인 | FindButton | (FindButton) | FindData | `SSP.SSP0024_GET_SHIP_MASTER` | `spdMain` 시트 `Ship Master Elec` |
| A4 | 메인 | SaveButton | (SaveButton) | SaveData → FindData | `SSP.SSP0024_SAVE_SHIP_MASTER` → `SSP.SSP0024_GET_SHIP_MASTER` | 저장 후 재조회 |
| A5 | 메인 | EditButton | (EditButton) | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가부(판정 확인 필요) |
| A6 | 메인 | 행 추가(버튼 확인 필요) | (InsertRow) | IsLock==false && 시트 `Ship Master Elec` → 셀 콤보 4종 설정 | (필드 데이터) `biz:CommonData.CommonDataList` [PlantSiteByFactoryEEOperation / ElectrodePostOperCode / BuildingForShipMasterElec], dtMyDivisionIns(출처 확인 필요) | DIVISION_ID·PLANT_SITE_ID·POST_OPER·BUILDING 콤보 |
| A7 | 메인 | spdMain.ComboSelChange | `SpdMain_ComboSelChange` | DIVISION_ID·CODE 기준 행에서 POST_OPER_LT를 읽음 | (호출 없음) | 반영 셀 확인 필요 |
| A8 | 메인 | spdMain.ClipboardPasted | `SpdMain_ClipboardPasted` | DIVISION_ID 열 값이 빈값이면 PLANT_SITE_ID 콤보 = dtEmpty | (호출 없음) | PLANT_SITE_ID 콤보 비움 |
| A9 | 메인 | spdMain.CellClick | `SpdMain_CellClick` | 확인 필요 | 확인 필요 | 확인 필요 |
| A10 | 메인 | spdMain.KeyPress | `SpdMain_KeyPress` | 확인 필요 | 확인 필요 | 확인 필요 |
| A11 | 메인 | btnMaterialId.Click | `BtnMaterialId_Click` | `txtMaterialId.Text = sMaterialId` | (직접 호출 없음, 팝업 연계 확인 필요) | `txtMaterialId` |
| A12 | 메인 | btnModelId.Click | `BtnModelId_Click` | `txtModelId.Text = sModelId` | (직접 호출 없음, 팝업 연계 확인 필요) | `txtModelId` |
| A13 | 팝업 | this.Load | `Form_Load` | InitControls(GetDivision, GetDivisionbyPlantSiteCode, txtMaterialId=sMaterial, clbDivisionId/clbPlantSiteId Enabled=false) → FindData | `SCM.SCM0001_GET_DIVISION`, `biz:CommonData.CommonDataList` [code=PlantSiteByDivision], `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | `clbDivisionId`, `clbPlantSiteId`, 시트 `Project` |
| A14 | 팝업 | clbDivisionId.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | GetDivisionbyPlantSiteCode | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | `clbPlantSiteId` |
| A15 | 팝업 | btnButtonList.UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | FindData | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` |
| A16 | 팝업 | FindButton | (FindButton) | FindData | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` |
| A17 | 팝업 | spdMain.CellDoubleClick | `spdMain_CellDoubleClick` | 확인 필요(선택값 반환 추정은 하지 않음) | 확인 필요 | 확인 필요 |

## 6. 검증·메시지
| # | 사실 | 근거 |
|---:|---|---|
| V1 | 셀 콤보 설정 전제: `siMain != null && siMain.IsLock(siMain.SheetName) == false`, `siMain.SheetName == "Ship Master Elec"` | grid_code.csv:374~377 |
| V2 | SetCellCombo 전제: `"" != pdivision` | grid_code.csv:852 |
| V3 | 붙여넣은 DIVISION_ID가 빈값이면 PLANT_SITE_ID 콤보를 비움 | grid_code.csv:700 |
| V4 | 그리드 라벨 `*` 표기 10개 컬럼(§4-1). 필수값 검증 로직과 메시지 문구는 **확인 필요** | grid_effective.csv |
| V5 | 조회 0건·SP 오류 시 메시지는 Fact Pack에 없음 → **확인 필요** | - |

## 7. 권한 (C/R/U/D) 사실
| 구분 | 사실 |
|---|---|
| R(조회) | FindButton → `SSP.SSP0024_GET_SHIP_MASTER` |
| C/U(생성·수정) | SaveButton → `SSP.SSP0024_SAVE_SHIP_MASTER`(MERGE SSP_MST_SHIP_MASTER_EE) |
| D(삭제) | Fact Pack에 사실 없음(**확인 필요**) |
| 편집 진입 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST`(TB_FX_USER·TB_FX_USERGROUPINFO·TB_FX_GROUPINFO·TB_FX_USERGROUPAUTHEXTENTION·SCM_MST_SSO_DEPT_INFO) — 판정 조건은 **확인 필요** |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 12행(값 미제공) |
| 시트 잠금 | IsLock==true이면 행 추가 시 콤보를 설정하지 않음 |

## 8. To-Be 전환 메모 (Wijmo · Oracle)
| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| M1 | 그리드 | FarPoint FpSpread + SetSheetHeaderColumn(메타) | Wijmo FlexGrid. 컬럼은 SCM_MST_SHEET_COLUMNS 메타(`Ship Master Elec` 25행)로 구성. `Project`는 하드코딩 11컬럼을 FE 컬럼 정의로 옮기거나 메타화 여부 결정 필요 |
| M2 | 셀 콤보 | 행 추가·붙여넣기 시 행 단위 SetCellTypeCombo | FlexGrid DataMap(행별 DataMap은 PLANT_SITE_ID가 DIVISION_ID에 따라 바뀌므로 행 단위 필터 필요 — 동작 확인 후 결정) |
| M3 | 조회조건 | UsrCheckedList / UsrCombo / UsrMultiLineEditor | MultiSelect / ComboBox / 멀티라인 입력 |
| M4 | 공통코드 | biz CommonData(UP_FX_GetCommonDataList 코드분기) | 공통코드 조회 API(Oracle 이관 대상 SP·패키지 이름은 **확인 필요**) |
| M5 | SP 이관 | MSSQL SP가 `STRING_SPLIT` 참조 | Oracle 19c에 `STRING_SPLIT`이 없으므로 대체 구현 필요(MSSQL 키워드 잔존 금지) |
| M6 | 저장 | MERGE + 이력 + 로그(PR_SCM_SYS_LOG_BATCH) | Oracle MERGE로 이관하고, 이력·로그 INSERT를 누락 없이 유지 |
| M7 | 레이아웃 | Dock Top/Fill(SplitContainer 없음) | 조회조건 영역 + 그리드 상/하 2단 |
| M8 | 팝업 | 별도 Form, Division/Plant Site 비활성 | 모달 팝업. 호출 측이 넘기는 값(sMaterial, division)은 **확인 필요** |

## 9. 미확정
| # | 항목 |
|---:|---|
| Q1 | 메뉴 위치, 공통 버튼(Find/Save/Edit/행 추가)의 노출 메타(TB_FX_GroupMenuAuth 12행) |
| Q2 | 조회조건 가로 배치 순서(LayoutItem 좌표 없음), btnMaterialId 라벨 `"layoutControlItem4"`의 표시 여부 |
| Q3 | `usrLayoutControl1`(parent 없음)의 역할 |
| Q4 | `Ship Master Elec` 컬럼 표시 순서·폭·정렬·셀 타입·편집 여부, DOM_EXP_TYPE_CODE / PACKAGE_TYPE_CODE 콤보 |
| Q5 | `SpdMain_CellClick`, `SpdMain_KeyPress`, `spdMain_CellDoubleClick` 동작, `SpdMain_ComboSelChange`의 POST_OPER_LT 반영 셀 |
| Q6 | `BtnMaterialId_Click` / `BtnModelId_Click`이 여는 팝업과 반환값, 팝업 호출 위치 |
| Q7 | `cboDivision`의 원천 데이터(MyDivision 여부), dtMyDivisionIns 출처 |
| Q8 | 필수값 검증·메시지 문구 |

=== FILE: unit_test.md ===
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
