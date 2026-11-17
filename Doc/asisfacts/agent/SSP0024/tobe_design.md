# SSP0024 TO-BE 설계 입력 (Shipment Master Electrode)

> Fact Pack 기반 TO-BE 설계 후보입니다. 확정 사항이 아닌 것은 '미확정'에 모았습니다.

## 1. 조회조건 (컨트롤 기준)

### 1-1. 메인
| 라벨(원문) | AS-IS 컨트롤 | 유형 | 데이터 / 연동 | TO-BE 후보 |
|---|---|---|---|---|
| `Plant Site` | cboPlantSite | UsrCheckedList(다중) | PlantSiteByFactoryEEOperation (Div 변경 시 재조회) | 다중선택 콤보 |
| `Div` | cboDivision | UsrCombo(단일) | 변경 시 → Plant Site 재조회, Material·Model 비움(SetChangedControl:191·194·195). 콤보 원천 데이터 = 확인 필요 | 단일 콤보 |
| `Material` | txtMaterialId + btnMaterialId | UsrMultiLineEditor + 버튼 | 버튼 클릭 → `txtMaterialId.Text = sMaterialId` | 멀티 입력 + 팝업 버튼 |
| `Nick Name` | txtNickName | TextEdit | - | 텍스트 입력 |
| `Model` | txtModelId + btnModelId | UsrMultiLineEditor + 버튼 | 버튼 클릭 → `txtModelId.Text = sModelId` | 멀티 입력 + 팝업 버튼 |

FindData:301~302에서 GetCheckedListValue를 2회 호출합니다. SSP0024_GET_SHIP_MASTER에 넘기는 파라미터 목록은 **미확정**입니다.

### 1-2. 팝업 (Item by DivisionPopup)
| 라벨(원문) | AS-IS 컨트롤 | 상태 | 데이터 |
|---|---|---|---|
| `Division` | clbDivisionId | Enabled=false | SCM.SCM0001_GET_DIVISION |
| `Plant Site` | clbPlantSiteId | Enabled=false | CommonData PlantSiteByDivision |
| `Material` | txtMaterialId | 초기값 sMaterial | - |

## 2. 액션별 호출 API 후보
| 화면 | 액션(버튼/이벤트) | AS-IS 경로 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|---|
| 메인 | 화면 로드 | Form_Load > InitControls > SetChangedControl | CommonData PlantSiteByFactoryEEOperation | 공통코드 조회 API |
| 메인 | Div 변경 | ClbDivision_SelectedIndexChanged > SetChangedControl | CommonData PlantSiteByFactoryEEOperation | 공통코드 조회 API(division 파라미터) |
| 메인 | 조회 | FindButton > FindData | SSP.SSP0024_GET_SHIP_MASTER | 조회 API → SSP0024_GET_SHIP_MASTER |
| 메인 | 저장 | SaveButton > SaveData → FindData | SSP.SSP0024_SAVE_SHIP_MASTER → SSP.SSP0024_GET_SHIP_MASTER | 저장 API → SSP0024_SAVE_SHIP_MASTER, 성공 후 재조회 |
| 메인 | 편집 | EditButton > GetSSPUserCheck | SSP.SSP0002_GET_USER_INFO_LIST | 사용자 권한 확인 API |
| 메인 | 행 추가 | InsertRow (진입 버튼 = 확인 필요) | (셀 콤보 데이터: MyDivision(Ins), PlantSiteByFactoryEEOperation "40,81,82,81_UC", ElectrodePostOperCode, BuildingForShipMasterElec) | 공통코드 조회 API ×4 (화면 로드 때 미리 받아두는 방식 검토) |
| 메인 | 셀 콤보 변경 | SpdMain_ComboSelChange | (API 호출 없음, POST_OPER_LT 등 로컬 데이터 참조) | FE 처리 |
| 메인 | 붙여넣기 | SpdMain_ClipboardPasted | (API 호출 없음) DIVISION_ID 빈값이면 PLANT_SITE_ID 콤보를 비움 | FE 처리 |
| 메인 | 셀 클릭 / 키 입력 | SpdMain_CellClick / SpdMain_KeyPress | 동작 확인 필요 | 미확정 |
| 메인 | Material/Model 버튼 | BtnMaterialId_Click / BtnModelId_Click | 직접 호출 엔드포인트 없음. 팝업 연계 여부 확인 필요 | 팝업 컴포넌트 |
| 팝업 | 로드 | Form_Load > InitControls / FindData | SCM.SCM0001_GET_DIVISION, CommonData PlantSiteByDivision, SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | division 조회 + 공통코드 + 팝업 조회 API |
| 팝업 | Division 변경 | clbDivision_SelectedIndexChanged | CommonData PlantSiteByDivision | 공통코드 조회 API |
| 팝업 | 조회(버튼) | FindButton / btnButtonList_UsrButtonList_Click_Detected > FindData | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | 팝업 조회 API |
| 팝업 | 행 더블클릭 | spdMain_CellDoubleClick | (동작 확인 필요) | 선택값 반환 |

## 3. Division별 Grid 변형 요약
| 시트 | 구성 | Division별 컬럼 수 | 변형 |
|---|---|---|---|
| `Ship Master Elec` | 메타 25컬럼(전부 기본) + 코드 셀 콤보 | 14개 division 모두 25 | 컬럼 표시 변형 없음. 셀 콤보 데이터만 division 영향(PLANT_SITE_ID: `"40,81,82,81_UC"` 인자, SetCellCombo `pdivision` 조건) |
| `Project`(팝업) | 하드코딩 11컬럼 | 14개 division 모두 11 | 변형 없음. DIVISION_NAME은 bVisible=false |

## 4. 권한(C/R/U/D) 관련 사실
| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth에 SSP0024 행 12건이 있음(값 내용은 미제공) | Fact Pack 8장 |
| TB_FX_MenuItemInfo 1건, TB_FX_ProgramInfo 1건, TB_FX_SearchCondition 6건, TB_FX_Favorite 3건 | Fact Pack 8장 |
| EditButton → GetSSPUserCheck → SSP0002_GET_USER_INFO_LIST(TB_FX_USER, TB_FX_USERGROUPINFO, TB_FX_GROUPINFO, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SSO_DEPT_INFO 참조) — 편집 진입 시 사용자 정보 확인 | flow.csv |
| MyDivision 공통코드가 `UserInfoContext.Current["NowGroupID"]`와 TB_FX_USERGROUPAUTHEXTENTION을 참조 — 사용자 그룹 기준 division 목록 | meta_reads.csv, 엔드포인트 표 |
| InsertRow의 셀 콤보 설정 조건 `siMain.IsLock(siMain.SheetName) == false` — 시트 잠금 상태면 행 추가 시 콤보를 설정하지 않음 | grid_code.csv 374~377 |
| 저장은 MERGE(C/U)와 이력 INSERT. 삭제(D) 처리 여부는 Fact Pack에 없음 | 엔드포인트 표 |

## 5. 미확정 사항
| # | 항목 | 필요한 확인 |
|---:|---|---|
| 1 | TB_FX_GroupMenuAuth 12행의 버튼별 권한 값 | 메타 CSV(dbmeta_dbo_TB_FX_GroupMenuAuth.csv) 확인 |
| 2 | TB_FX_SearchCondition 6행(조회조건 저장 항목) | dbmeta_dbo_TB_FX_SearchCondition.csv 확인 |
| 3 | GetSSPUserCheck 결과로 편집 가부를 판정하는 조건 | MAIN:883 주변 소스 |
| 4 | 행 추가 버튼과 InsertRow의 연결, 삭제 기능 유무 | 메인 소스 |
| 5 | DOM_EXP_TYPE_CODE / PACKAGE_TYPE_CODE 셀 콤보 설정 위치 | 메인 소스(dtDomExpTypeCode, dtElectrodePackageType 사용처) |
| 6 | SpdMain_ComboSelChange에서 POST_OPER_LT를 반영하는 대상 셀 | MAIN:612~621 |
| 7 | Material/Model 버튼이 여는 팝업(SSP0024_ItembyDivisionPopup 여부)과 넘기는 값 | MAIN:746, 767 |
| 8 | 팝업 CellDoubleClick 반환 컬럼 | POP.D:357 핸들러 |
| 9 | 메인 cboDivision 콤보 원천 데이터(MyDivision 여부) | 메인 InitControls |
| 10 | 조회·저장 SP 파라미터 정의 | SP 원문 |
| 11 | Ship Master Elec 메타 25행의 폭·정렬·셀 타입·고정·대문자 속성 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| 12 | 4-2절 SaveButton:282 → PersonalSettingPopup.SaveData 매핑의 진위 | 파서 결과 재검토 |
