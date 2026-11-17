# SSP0025 TO-BE 설계 입력 (As-is 사실 기반)

## 1. 조회조건 (메인)

| 순서 | As-is 컨트롤 | 라벨 | 유형 | 필수 표시 | 데이터 원천 | 연동 |
|---:|---|---|---|---|---|---|
| 1 | cboDivision | Div* | 단일 콤보 | `*` 있음 | 원천 **확인 필요** (MyDivision 사용 여부 미추출) | 변경 시 CboDivision_SelectedIndexChanged → SetChangedControl → Plant Site 재조회 |
| 2 | clbFromSite | Plant Site | 체크리스트(다중) | 없음 | CommonDataList[PlantCell] | Division에 종속 |
| 3 | txtItemId (+btnItemId) | Material | 멀티라인 + 팝업 버튼 | 없음 | 직접 입력 / 팝업 결과 popItem.ItemId | - |
| 4 | txtModelId (+btnModelId) | Model | 멀티라인 + 팝업 버튼 | 없음 | 직접 입력 / 팝업 결과 popItem.ModelId | - |
| 5 | txtNickName | Nick Name | 텍스트 | 없음 | 직접 입력 | - |

FindData_Main:258·259에서 `GetCheckedListValue`를 호출해 체크리스트 값(CODE)을 조회 파라미터로 넘깁니다. 정확한 SP 파라미터 목록은 **확인 필요**입니다.

### 1-1. 팝업 조회조건 (`Item by DivisionPopup`)

| 컨트롤 | 라벨 | 상태 | 원천 |
|---|---|---|---|
| clbDivisionId | Division | 비활성(Enabled=false) | 메인에서 넘긴 값으로 보이나 전달 방식은 **확인 필요** |
| clbFromSiteId | From Site | 활성 | CommonDataList[FromSiteByAssembly] |
| txtItemId | Material | 초기값 sItemId | 메인 입력값 |
| txtModelId | Model | 초기값 sModelId | 메인 입력값 |

## 2. 액션별 호출 API 후보

| 액션 | As-is 진입점 | As-is 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load > InitControls > SetChangedControl | CommonDataList[PlantCell] | 공통코드 API (PlantCell) |
| Division 변경 | CboDivision_SelectedIndexChanged | CommonDataList[PlantCell] | 공통코드 API (PlantCell, division 파라미터) |
| 조회 | FindButton > FindData_Main | SSP0025_GET_SHIPMENT_REQUESTOR_PIC | `GET/POST …/ssp0025/search` → SP 조회 |
| 편집 진입 | EditButton > GetSSPUserCheck | SSP0002_GET_USER_INFO_LIST | 사용자 권한 확인 API (SSP0002와 공용) |
| 행 추가 | InsertRow (진입 버튼 **확인 필요**) | CommonDataList[MyDivision], [PlantCell] | 신규 행 콤보: Division / Plant Site 공통코드 |
| 그리드 셀 클릭(신규 행 Plant Site) | SpdMain_CellClick | CommonDataList[PlantCell] | 공통코드 API (PlantCell) |
| 저장 | SaveButton > SaveData (> GetUserIDChk, > FindData_Main) | SSP0025_GET_USER_ID_CHECK, SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC, SSP0025_GET_SHIPMENT_REQUESTOR_PIC | 사용자 ID 검증 + 저장 API + 재조회 (순서 **확인 필요**) |
| Material 팝업 | btnItemId_Click | (팝업 내부) SSP0025_GET_ITEM_BY_DIVISION_POPUP | 팝업 조회 API |
| Model 팝업 | btnModelId_Click | (팝업 내부) SSP0025_GET_ITEM_BY_DIVISION_POPUP | 팝업 조회 API (같은 SP) |
| 팝업 로드/조회 | Form_Load, btnButtonList_UsrButtonList_Click_Detected, FindButton | CommonDataList[FromSiteByAssembly], SSP0025_GET_ITEM_BY_DIVISION_POPUP | 공통코드 API + 팝업 조회 API |
| 팝업 Division 변경 | clbDivision_SelectedIndexChanged | CommonDataList[FromSiteByAssembly] | 공통코드 API (컨트롤이 비활성이라 사용자가 직접 바꾸는 경우는 없음) |
| 팝업 행 더블클릭 | spdMain_CellDoubleClick | 없음 | 선택값 반환 (동작 **확인 필요**) |
| 그리드 TopChange / CellDoubleClick / ComboSelChange (메인) | SpdMain_TopChange 등 | 없음 | 동작 **확인 필요** |

## 3. Division별 Grid 변형 요약

| 시트 | 구성 | division별 차이 |
|---|---|---|
| Shipment Requestor PIC | 메타 19컬럼(모두 기본) + 코드 셀 유형 변경(이미지 3, 콤보 2) | 없음 (14개 division 모두 19) |
| Project (팝업) | 하드코딩 11컬럼(DIVISION_NAME 숨김 → 표시 10) | 없음 |

메타 기반 그리드이므로 TO-BE에서는 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0025, SHEET_NAME=`Shipment Requestor PIC`) 19행을 컬럼 메타 원천으로 씁니다. 팝업 `Project` 시트는 메타가 없어 TO-BE에서 메타를 새로 등록할지, 코드로 정의할지 결정해야 합니다(미확정).

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| TB_FX_GroupMenuAuth에 SSP0025 행 12건 | DB 메타 §8 |
| TB_FX_MenuItemInfo 1건, TB_FX_ProgramInfo 1건 | DB 메타 §8 |
| TB_FX_SearchCondition 4건(저장된 조회조건) | DB 메타 §8 |
| TB_FX_Favorite 5건 | DB 메타 §8 |
| EditButton에서 SSP0002_GET_USER_INFO_LIST로 사용자 정보·권한(TB_FX_USERGROUPAUTHEXTENTION 등) 조회 | flow.csv |
| 신규 행 Division 콤보 = MyDivision(사용자 그룹 권한 TB_FX_USERGROUPAUTHEXTENTION 기준) | grid_code InsertRow:318 |
| 그리드 잠금 여부 `siMain.IsLock(SheetName)`가 행 추가·셀 콤보 설정 조건 | grid_code InsertRow / SpdMain_CellClick |

그룹별 C/R/U/D 플래그 값(12행의 내용)은 Fact Pack에 없어 **확인 필요**입니다.

## 5. 미확정 사항

1. 메인 Form Text `"SSP0014_ShipmentModelPIC"`와 화면명 `Shipment Requestor PIC`가 다릅니다. TO-BE 화면 제목 기준이 미확정입니다.
2. 저장 절차(USER_ID 검증 → MERGE → 재조회)의 정확한 순서와 오류 처리는 원문 확인이 필요합니다.
3. EditButton 권한 확인 결과로 편집을 허용하는 조건은 원문 확인이 필요합니다.
4. 이미지 셀(cellTypeImage) 3컬럼의 대상과 TO-BE 표현 방식(아이콘 셀) 미확정.
5. VALID_YN 콤보 원천(`biz:CommonData.YesOrNo` 여부) 미확정.
6. cboDivision(Div*) 콤보 데이터 원천 미확정.
7. 팝업과 메인 사이 값 전달(sItemId/sModelId 입력, popItem.ItemId/ModelId 반환, Division 전달) 인터페이스 확정 필요.
8. 팝업 `Project` 시트의 TO-BE 컬럼 정의 방식(메타 등록 / 코드) 미확정.
9. STRING_SPLIT, SCM_ARR_SPL_CNT/VAL, PR_SCM_SYS_LOG_BATCH의 Oracle 대응 객체 존재 여부 미확인.
10. usrButton1, imageList1, usrLayoutControl1(팝업)의 사용 여부 미확인.
