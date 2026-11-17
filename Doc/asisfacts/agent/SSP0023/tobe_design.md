# SSP0023 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 메인 조회조건 (상단 패널)

| 순서 | 라벨 원문 | AS-IS 컨트롤 | 유형 | 필수 | 비고 |
|---:|---|---|---|---|---|
| 1 | Company* | clbCompany_ID | 콤보 | Y | 변경 시 InitSpread와 Plan-date 재구성 |
| 2 | Division* | clbDivision_ID | 콤보 | Y | `clbDivision_ID_SelectedIndexChanged`. DIVISION_ID로 하위 필터 |
| 3 | Plan-date* | cboPlanDate | 콤보 | Y | CODE, FROM_DATE, TO_DATE 사용. 변경 시 달력 헤더 재조회 |
| 4 | Period* | drpPeriod | 기간 | Y | 초기 `Enabled=false` (Plan-date에서 파생되는 것으로 보이며 확인 필요) |
| 5 | Bucket | cboBucketType | 콤보 | — | DAILY / WEEKLY / MONTHLY. `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| 6 | From Site | clbFromSite | 다중선택 | — | |
| 7 | Material | txtItemId (+btnItemId) | 멀티라인 + 팝업 | — | |
| 8 | (확인 필요) | txtModelId | 멀티라인 | — | |
| 9 | (확인 필요) | textNickName | 멀티라인 | — | |
| 10 | UOM Type | rdButton1 `UOM`(기본) / rdButton2 `Cell` / rdButton3 `Pancake m` | 라디오 | — | 표시 단위 전환 (재조회 없이 컬럼 Visible만 변경) |
| 11 | Sum | chkSum | 체크 | — | 합계 컬럼 표시 |
| 12 | (확인 필요) | btnMeasure | 버튼 | — | Measure 선택 후 InitSpread 재호출 |
| 13 | My Model / Delegatee Model / Team Leader / Part Leader | chkMyModel / chkDelegateeModel / chkTeamLeader / chkPartLeader | 체크 | — | SSP_MST_MODEL_USER, SSP_MST_DELEGATE 참조 SP와 연관된 것으로 보이며 확인 필요 |
| 14 | Including Past Period | chkPastPeriod | 체크 | — | 과거 날짜 컬럼 표시 (SetSpreadColumn:4642) |

- FindData_Main은 GetCheckedListValue를 4회 호출합니다(4683–4686). 어떤 컨트롤 4개인지는 확인 필요입니다.

### 1-2. 상세 조회조건 (하단 패널, btnSearch)

txtNickName2, txtModel2, txtItemId2(+btnItemId2), txtLotID, clbResultType, drpPeriod2, drpPeriod3, txtRequestor(+btnRequestor). 라벨 원문은 props.csv가 잘려 **확인 필요**입니다. 각 조건이 Detail, Stock, Result 중 어느 조회에 쓰이는지도 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 호출 엔드포인트(순서) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` | `DM.DM0003_GET_BUCKET_TYPE_CODE` → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | GET bucket-types, GET sheet-calendar |
| 조회 | FindButton | `SSP.SSP0023_GET_SHIPMENT_PLAN` (+ CALENDAR_3SPAN) | GET shipment-plan |
| Plan-date / Company 변경 | `cboPlanDate_SelectedIndexChanged`, `clbCompanyID_SelectedIndexChanged` | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | GET sheet-calendar |
| Measure 변경 | `BtnMeasure_Click` | CALENDAR_3SPAN | GET sheet-calendar |
| 메인 더블클릭 | `SpdMain_CellDoubleClick` | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | GET shipment-plan/detail |
| 상세 조회 | `BtnSearch_Click` | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` | GET detail / stock-detail / shipment-result |
| 시뮬레이션 | `BtnSimulation_Click` | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` → GET_SHIPMENT_PLAN → GET_SHIPMENT_PLAN_DETAIL | POST shipment-plan/simulation |
| 엑셀 양식 | `btnExcelFormDownload_Click` | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | GET shipment-plan/excel-form |
| 엑셀 업로드 | `btnExcelUpload_Click` | 업로드 처리 엔드포인트는 Fact Pack에 없음(확인 필요) → GET_SHIPMENT_PLAN, GET_SHIPMENT_PLAN_DETAIL 재조회 | POST upload (확인 필요) |
| 편집 진입 | EditButton | `SSP.SSP0002_GET_USER_INFO_LIST` | GET user-auth |
| 저장 | SaveButton | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`(×2) → GetERPInterface: `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0023_GET_SHIPMENT_STATUS`, `SSP.SSP0023_GET_ERP_SO_NO_CNT`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SoNo/NonSoNo: `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`, GetErpIFCheckNew: `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` → 재조회 | POST shipment-confirm (단일 트랜잭션으로 묶을지 결정 필요) |

- 저장 전 화면 검증(Validation_Check, ChangeData_Check, ChangeNotSendERP_Check)이 보는 컬럼: confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type, dom_exp. 오류 메시지와 조건 원문은 확인 필요입니다.
- `chkERPIFBlockYn`이 BLOCK_YN과 PERIOD로 ERP I/F 차단 여부를 확인합니다. 데이터 출처는 확인 필요입니다.

## 3. Division별 Grid 변형 요약

- 5개 시트 모두 division 14종에서 컬럼 구성이 **같습니다.** Division별 변형은 없습니다.
- 변형은 화면 컨트롤 값으로만 생깁니다.
  - UOM Type 라디오: BOH 3세트(기본 / _CELL / _PCM)와 날짜 컬럼 접두어 X_ / Y_ / Z_
  - Bucket: 날짜 컬럼 _D_ / _W_ / _M_
  - Sum: 주·월 합계 컬럼
  - Including Past Period: 과거 날짜 컬럼

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행 (내용 확인 필요) |
| 편집 권한 확인 | EditButton → `GetSSPUserCheck` → `SSP.SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 참조) |
| 그룹·사용자 필터 | SetChangeControl:341–342에서 Filter GROUP_ID / USER_ID와 `UserInfoContext.Current.NowGroupID` 사용. InitControls:462에서도 NowGroupID 사용 |
| 잠금 | SpdDetail_CellClick에서 `siDetail.IsLock(SheetName)`으로 편집 가능 여부 분기 |
| C/R/U/D 버튼 | FindButton(R), SaveButton(C/U), EditButton 사용. Delete 버튼 override는 Fact Pack에 없음 |

## 5. 미확정 사항

1. splitContainer1의 분할 방향과 비율(props.csv 잘림).
2. 하단 상세 패널 및 일부 상단 컨트롤의 라벨 원문.
3. Excel Upload의 서버 처리 엔드포인트.
4. 저장 체인의 분기 조건(SoNo / NonSoNo, CONFIRM 2회 호출, CHG_BATCH 2회 호출)과 트랜잭션 경계.
5. unreached 메서드 3개(`NewNonSoNo`, `GetErpIFCheckNew_`, `GetErpIFCheck`)와 `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`을 이전 대상에서 제외할지.
6. SCM_MST_SHEET_MEASURE 11행의 Measure 정의와 `P_SHIP_CONFIRM_ETD` 외 더블클릭 대상.
7. BOH 컬럼 표시 제어가 Shipment Plan(Electrode) 외 시트에도 적용되는지.
8. rdButton3에 CheckedChanged가 배선되지 않은 상태에서의 실제 동작.
9. `usrButton1`(부모 없음)과 `dsdm` 객체의 정체.
10. legacy 사본(GSCM.SSP.Plan.UIL)과 current 사본의 차이 반영 여부.
