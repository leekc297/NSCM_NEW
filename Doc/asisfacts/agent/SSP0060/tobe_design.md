# SSP0060 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 메인 조회 (FindButton → `SSP0060_GET_SHIPMENT_PLAN`)
| 컨트롤 | 타입 | 데이터 소스 | 비고 |
|---|---|---|---|
| clbCompany_ID | 단일 콤보 | GetSSPInnerTable (InitControls) | 변경 시 InitSpread와 GetSpdTitle 재구성, cboPlanDate 이벤트 일시 해제 |
| clbDivision_ID | 단일 콤보 | `SSP0060_GET_SHIPMENT_DIVISION` (SetChangedControl) | 변경 시 `SSP0002_GET_NERP_CODE`(SEGMENT2) |
| clbPlantSite | 다중 선택 | GetSSPInnerTable 계열 (확인 필요) | GetCheckedListValue(CODE) |
| cboPlanDate | 단일 콤보 | 확인 필요 (CODE, FROM_DATE, TO_DATE1 사용) | 변경 시 GetSpdTitle과 InitSpreadDateColumn |
| cboBucketType | 단일 콤보 | `DM0003_GET_BUCKET_TYPE_CODE` | cboBucketType_SelectedIndexChanged |
| drpPeriod | 기간 | dtShipmentInputPeriod VALUE/Diff_VALUE 기반 기본값 (확인 필요) | |
| txtItemId (+btnItemId) | 다건 텍스트 + 품목 팝업 | – | |
| clbProductLevel11 | 다중 선택 | 확인 필요 | |
| chkTotPSI | 체크박스 | – | 변경 시 즉시 FindData_Main 재조회 |
| chkSum | 체크박스 | – | 합계 표시(클라이언트 Set_SumValues/CalculateSum, 확인 필요) |
| btnMeasure | 버튼 | SCM_MST_SHEET_MEASURE | Measure 선택 후 InitSpread |

### 1-2. Detail 조회 (btnSearch / spdMain 더블클릭)
txtRequestor(+btnRequestor), txtModel2(+btnItemID2), drpPeriod2(ValueChanged 처리), drpPeriod3, clbResultType, txtBoxID, clbProductLevel12. 컨트롤과 SP 파라미터의 대응 관계는 Fact Pack에 없습니다. **확인 필요**

라벨 원문은 메인 화면 props.csv가 잘려 **확인 필요**입니다. TO-BE에서는 `ui-category-setup-column-meta` 기준으로 라벨을 확정해야 합니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 SP(순서) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load > InitControls | SSP0060_GET_SHIPMENT_DIVISION, DM0003_GET_BUCKET_TYPE_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN | 초기 콤보 API(division, bucketType), 캘린더 헤더 API |
| 메인 조회 | FindButton / chkTotPSI | SSP0060_GET_SHIPMENT_PLAN (+ SCP0009 헤더) | 메인 PSI 조회 |
| Detail 조회 7종 | btnSearch / SpdMain_CellDoubleClick | SSP0060_GET_SHIPMENT_PLAN_DETAIL, SSP0060_GET_STOCK_LOCATION_DETAIL, SSP0060_GET_OWMS_DETAIL, SSP0060_GET_SHIPMENT_RESULT, SSP0060_GET_HOLD_STOCK(더블클릭만), SSP0060_GET_MES_STOCK, SSP0060_GET_MES_STOCK_DETAIL | 시트별 조회 API 7개 |
| 메인 저장 | SaveButton > SaveData_Main | SSP0060_SAVE_SHIPMENT_PLAN | 계획 저장 |
| Detail 저장 | SaveButton > SaveData_Detail | Validation_Check, chkERPIFBlockYn → SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM → GetERPInterface: SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP0060_GET_ERP_SO_NO_CNT, SSP0060_GET_SHIPMENT_STATUS, SCM_SSP_CHECK_CONFIRM_CHANGETIME, SoNo/NonSoNo 분기 SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING, GetErpIFCheckNew 분기 PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH → 재조회 | 확정 저장. 하나의 트랜잭션으로 묶을지, 단계별 커밋을 유지할지 결정 필요 |
| Hold stock 저장 | SaveData_Detail:3460 | `SSP0060_SAVE_HOLD_STOCK_DATA` (없음) | **미확정** |
| 변경요청 팝업 조회 | RequestPopup Form_Load / Find | SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 변경요청 조회 |
| 변경요청 팝업 저장 | RequestPopup SaveButton / usrButtonList1 | ChkEngProcessing: SSP0003_GET_SSP_PLAN_PROCESSING_CHECK → SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM → GetERPInterface: ERROR_CONFIRM, DELETE_…_BY_CONFIRM, SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE, GET_ERP_SO_NO_CNT, GET_SHIPMENT_STATUS, SoNo: SAVE_…_DRAFTING_MAIN + PR_…_CHG_BATCH / NonSoNo: SAVE_…_DRAFTING_MAIN + PR_…_CHG_BATCH_NEW_C, GetErpIFCheckNew 분기 | 변경요청 저장 |
| 팝업 Auto Set | btnAutoSet_Click | 엔드포인트 없음 (클라이언트 로직) | FE 로직 |
| 확정 상세 팝업 | ConfirmDetailPopup Form_Load / Find | SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 조회 전용 팝업 |
| 수정 버튼 | EditButton > GetSSPUserCheck | SSP0002_GET_USER_INFO_LIST | 사용자 권한 체크 |
| Detail 셀 편집 | SpdDetail_EditChange / CellClick | CommonData [TransMode] | Trans Mode 콤보 API |
| Simulation / New / Requestor | BtnSimulation_Click / BtnNew_Click / BtnRequestor_Click | 엔드포인트 없음 (Simulation은 Container_Qty 기반 클라이언트 계산) | FE 로직과 공용 팝업 |

## 3. Division별 Grid 변형 요약
- 메타 기준으로 14개 Division 모두 컬럼 구성이 같습니다. Division 변형 없이 단일 컬럼 정의로 구현합니다.
- 다만 코드의 Division 분기(NERP 코드, 사이트 필터)는 조회 파라미터에 반영해야 합니다.
- 날짜 컬럼과 EDIT_YN_* 컬럼은 Plan Date와 Bucket에 따라 동적으로 만들어지므로 FE 동적 컬럼 생성이 필요합니다.

## 4. 권한(C/R/U/D) 관련 사실
| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 (값 미포함) | DB 메타 §8 |
| 프레임워크 버튼 FindButton(R), SaveButton(C/U), EditButton 사용 | flow.csv |
| EditButton에서 `SSP0002_GET_USER_INFO_LIST`로 사용자, 그룹, 권한 확장(TB_FX_USERGROUPAUTHEXTENTION)을 확인 | endpoints.csv |
| Division과 Site 콤보를 TB_FX_USERGROUPAUTHEXTENTION 기준으로 필터 (`SSP0060_GET_SHIPMENT_DIVISION`) | endpoints.csv |
| UserInfoContext.Current.NowGroupID 사용 (InitControls, SetChangedControl, SetChangeControl, InitSpread) | meta_reads.csv |
| 삭제(D) 전용 버튼과 엔드포인트는 진입점에 연결되어 있지 않음 (`SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`은 unreached) | flow.csv |

## 5. 미확정 사항
1. `SSP0060_SAVE_HOLD_STOCK_DATA`가 없는 상태에서 Hold stock 저장 기능을 유지할지, 대체할지
2. unreached 호출 4건(SSP0202_…_IF_CHECK, DELETE_…_DRAFTING ×2, NewNonSoNo)을 이관 대상에 포함할지
3. 메인 화면 조회조건 라벨, splitContainer1 분할 방향과 비율
4. 시트와 Spread(spdMain/spdDetail) 귀속, 더블클릭 셀 위치별 Detail 조회 분기 조건
5. Request Info의 ELECTRODE_YN과 NEW_TO_CITY 헤더/필드 교차를 TO-BE에서 그대로 둘지 (원문 결함 가능)
6. RequestPopup과 ConfirmDetailPopup을 메인에서 여는 조건과 전달 파라미터
7. 저장 체인(확정, ERP 인터페이스, 메일)의 트랜잭션 경계
8. TB_FX_GroupMenuAuth 그룹별 C/R/U/D 값
9. SCM_MST_SHEET_MEASURE의 Shipment Plan Measure 20행 상세(필수+기본 14 / 선택 6)
