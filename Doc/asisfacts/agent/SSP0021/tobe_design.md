# SSP0021 TO-BE 설계 입력 (사실 기반)

> API 경로·이름은 **후보**다. 확정은 TO-BE 명명 규약을 따른다.

## 1. 조회조건 (컨트롤 기준)

### 1.1 메인 조회 (FindButton → `SSP.SSP0021_GET_SHIPMENT_PLAN`)
| 라벨 | AS-IS 컨트롤 | 필수 표기 | 값 원천 | 연쇄 동작 |
|---|---|---|---|---|
| Division* | clbDivision_ID (UsrCombo) | `*` | `SSP.SSP0021_GET_SHIPMENT_DIVISION` (SetChangedControl 493줄) | clbDivision_ID_SelectedIndexChanged |
| Company* | clbCompany_ID (UsrCombo) | `*` | 확인 필요 (dtMyCompany / dtDiv_Company_ID NAME 사용) | 변경 시 `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`(From Site 목록) 호출, cboPlanDate 이벤트를 해제했다가 재연결, InitSpread 재실행 |
| From Site | clbPlantSite (UsrCheckedList) | — | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | 다중 선택(GetCheckedListValue) |
| Plan-date* | cboPlanDate (UsrCombo) | `*` | 확인 필요 (Plan_Current_Check: CODE·NAME·FROM_DATE·TO_DATE) | 변경 시 FROM_DATE/TO_DATE 반영, 날짜 헤더 재생성(`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) |
| Period* | drpPeriod (UsrDateRangePicker) | `*` | Plan-date의 FROM/TO 반영(5967~5970줄) | **Enabled=false**(표시 전용) |
| Bucket | cboBucketType (UsrCombo) | — | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DAILY/WEEKLY/MONTHLY 열 표시 전환(조회 없음) |
| Sum | chkSum | — | — | 합계 열 표시 전환(조회 없음) |
| Model | txtItemId (UsrMultiLineEditor) + btnItemId | — | 팝업(btnItemId_Click, 대상 확인 필요) | — |
| Show SQL | chkSql | — | — | 용도 확인 필요 |

### 1.2 상세 조회 (spdDetail 상단, btnSearch)
| 라벨 | 컨트롤 | 비고 |
|---|---|---|
| Shipment Date | drpPeriod2 | DrpPeriod2_ValueChanged 연결 |
| Shipment Date | drpPeriod3 | 라벨이 drpPeriod2와 같음. 어느 시트에 적용되는지 확인 필요 |
| Model | txtModel2 + btnItemID2 | |
| (Requestor, 라벨 확인 필요) | txtRequestor + btnRequestor | 요청자 팝업 |
| (라벨 확인 필요) | clbResultType (UsrCheckedList) | |
| (라벨 확인 필요) | txtBoxID (UsrMultiLineEditor) | MES Box ID로 보이나 확인 필요 |

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 호출 순서 (flow.csv) | API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` | SSP0021_GET_SHIPMENT_DIVISION → DM0003_GET_BUCKET_TYPE_CODE → SCP0009_GET_SHEET_CALENDAR_3SPAN | 콤보 초기화 API(Division, Bucket), 캘린더 헤더 API |
| 회사 변경 | `clbCompanyID_SelectedIndexChanged` | SSP0021_GET_SHIPMENT_FROM_SITE → SCP0009 | From Site 콤보 API (FoxQuery 미등록 SP → Mapper 신규 등록) |
| Plan-date 변경 | `cboPlanDate_SelectedIndexChanged` | SCP0009 | 캘린더 헤더 API |
| 조회 | FindButton | SSP0021_GET_SHIPMENT_PLAN → SCP0009 | `GET /ssp0021/shipment-plan` (후보) |
| 메인 더블클릭 | `SpdMain_CellDoubleClick` | 셀 조건에 따라 PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / HOLD_STOCK / MES_STOCK / MES_STOCK_DETAIL | 시트별 상세 조회 API 6종 |
| 상세 Search | `BtnSearch_Click` | PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / SHIPMENT_RESULT / MES_STOCK / MES_STOCK_DETAIL | 위 상세 API 재사용 + Shipment Result API |
| Measure 선택 | `BtnMeasure_Click` | SCP0009 (InitSpread) | 클라이언트 측 열 재구성 + 캘린더 API |
| Bucket/Sum 전환 | `cboBucketType_SelectedIndexChanged`, `chkSum_CheckedChanged` | SetSpreadColumn (API 없음) | FE 열 표시 토글 |
| 편집 진입 | EditButton | SSP0002_GET_USER_INFO_LIST (GetSSPUserCheck) | 사용자 권한 확인 API |
| 저장 | SaveButton | SaveData_Detail: SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM, SSP0021_SAVE_HOLD_STOCK_DATA(⚠ DB 없음), GetERPInterface(SCM_SSP_CHECK_CONFIRM_CHANGETIME, SSP0021_GET_ERP_SO_NO_CNT, SSP0021_GET_SHIPMENT_STATUS, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, NonSoNo/SoNo → SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING, GetErpIFCheckNew → PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH ×2) → 재조회(GET_SHIPMENT_PLAN, PLAN_DETAIL, HOLD_STOCK) | 저장 API(Plan Detail 확정·변경요청), Hold stock 저장 API(원본 SP 확인 후) |
| Simulation | `BtnSimulation_Click` | 엔드포인트 없음 (Simulation 메서드는 DIVISION_ID·FROM_SITE·ITEM_ID·Container_Qty 사용) | FE 계산 여부 확인 필요 |
| 붙여넣기 | `SpdMain_ClipboardPasted`, `SpdDetail_ClipboardPasted` | 엔드포인트 없음 (Detail은 c["CODE"] 매칭) | FE 처리 |
| 기타 Grid 이벤트 | `SpdMain_TopChange`, `SpdDetail_TopChange`, `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_CellClick`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_EditChange`, `SpdMain_Change`, `shtDetail_Change`, `DrpPeriod2_ValueChanged`, `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click` | 엔드포인트 없음 | FE 처리. 각 핸들러의 세부 로직은 원문 확인 필요 |

- 저장 전 검증(Validation_Check): Shipment Qty*, Shipment Date*, Trans Mode*, Building(remarks2), Remarks. SO No가 있는 행과 없는 행을 따로 검증한다(Validationdr / SONoValidationdr).
- ERP I/F 차단 확인: chkERPIFBlockYn이 BLOCK_YN·PERIOD를 읽는다. 데이터 출처는 확인 필요.
- 진입점 미연결(구현 제외 후보, 확인 필요): GetErpIFCheck, NewNonSoNo, GetErpIFCheckNew_.

## 3. Division별 Grid 변형 요약
- 9개 시트 × 14개 division 모두 표시 컬럼 수가 같다(Hold stock 10, Hold stock Detail 10, MES Stock 9, MES Stock Detail 13, oWMS Detail 25, Shipment Plan 8, Shipment Plan Detail 42, Shipment Result 18, Stock Location Detail 20).
- 유일한 division 분기: division **82**일 때 Shipment Result의 `CHILD_QTY` Width=75 (InitSpread 727줄).
- division과 무관한 동적 변형: Shipment Plan 날짜 열(캘린더 SP), Bucket/Sum에 따른 D_/W_/M_ 열 표시.

## 4. 권한(C/R/U/D) 관련 사실
| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0021_GET_SHIPMENT_PLAN`. Division 목록 SP가 TB_FX_USERGROUPAUTHEXTENTION을 참조한다 |
| U/C | EditButton → GetSSPUserCheck → `SSP.SSP0002_GET_USER_INFO_LIST`(TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION). SaveButton → 저장 체인 |
| D | 프레임워크 DeleteButton 진입점은 flow.csv에 없다. 삭제성 SP(SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, DELETE:SSP_ANL_SHIP_CONFIRM 포함)는 저장 체인 안에서 호출된다 |
| 그룹·사용자 | `UserInfoContext.Current.NowGroupID` 사용(InitControls 443, SetChangedControl 497, SetChangeControl 338, clbCompanyID_SelectedIndexChanged 5922). Filter GROUP_ID·USER_ID(338~339줄) |
| 잠금 | SpdDetail_CellClick이 `siDetail.IsLock(SheetName)`으로 편집 가능 여부를 분기한다 |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 14행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행(내용 확인 필요) |

## 5. 미확정 사항
1. `SSP0021_SAVE_HOLD_STOCK_DATA`가 DB에 없다. Hold stock 저장 기능을 유지할지와 원본 SP를 확보해야 한다.
2. `SSP0021_GET_SHIPMENT_FROM_SITE`가 FoxQuery에 미등록이다. 호출 방식과 파라미터를 확인해야 한다.
3. Hold stock / Hold stock Detail 시트를 생성하는 코드 위치와 탭 인덱스(3·4) 처리.
4. 상세 조건 라벨 미확인(txtRequestor, clbResultType, txtBoxID), drpPeriod2와 drpPeriod3의 용도 구분.
5. Company, Plan-date 콤보의 데이터 원천.
6. GetSSPInnerTable 8회 호출의 code 값.
7. Grid 컬럼의 실제 표시 순서(메타 원본).
8. Simulation 기능의 계산 로직과 데이터 출처.
9. chkSql(Show SQL), usrButton1(parent 없음)을 TO-BE에 반영할지.
10. 진입점 미연결 메서드 3개를 제외할지.
11. 주석 처리된 `SSP0046_GET_BUCKET_TYPE_CODE`는 현행 기능이 아니므로 제외(주석 처리됨).
