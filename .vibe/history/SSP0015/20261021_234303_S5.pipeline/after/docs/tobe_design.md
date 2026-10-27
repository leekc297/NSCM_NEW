# SSP0015 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단(메인) 조회조건
| 순서 | 라벨(원문) | As-is 컨트롤 | 필수 | 데이터/기본값 원천 | 연동 |
|---:|---|---|:---:|---|---|
| 1 | Division* | clbDivision (UsrCombo) | Y | 원천 확인 필요 (GetDivision / SCM0001_GET_DIVISION은 진입점 미연결) | 변경 → SetChangedControl → PlanDateShip 재조회 + GetDayRange |
| 2 | Plan-date* | cboPlanDate (UsrCombo) | Y | `biz:CommonData.CommonDataList [code=PlanDateShip]` | 변경 → GetDayRange(SCM0001_GET_SCP_DAY_PERIOD) |
| 3 | Period* | drpPeriod | Y | SCM0001_GET_SCP_DAY_PERIOD. InitControls의 dtShipmentInputPeriod(VALUE / Diff_VALUE) 사용 | — |
| 4 | From Site | clbPlantSite (CheckedList) | N | 확인 필요 (GetSSPInnerTable: PLANT_ID / SCM_SITE_ID 컬럼 가능성) | — |
| 5 | Bucket | cboBucketType | N | DM0003_GET_BUCKET_TYPE_CODE | DAILY / WEEKLY / MONTHLY → D_/W_/M_ 컬럼 표시 |
| 6 | Sum | chkSum | N | — | Sum 계열 컬럼 표시 |
| 7 | (Measure 버튼) | btnMeasure | — | — | 클릭 → InitSpread 재구성 |
| 8 | Model | txtItemId + btnItemId | N | 선택 팝업 내용 확인 필요 | — |
| — | My Model / Part Leader / Team Leader / Delegatee Model | chk* 4종 | — | **Visible=false** (My Model은 Checked=true) | 화면에 표시하지 않음. 값은 SP 파라미터로 쓰일 수 있음(확인 필요) |

### 1-2. 하단(Detail) 조회 바
| 라벨(원문) | 컨트롤 | 비고 |
|---|---|---|
| Shipment Date | drpPeriod2 | |
| Requestor | txtRequestor + btnRequestor | 사용자 선택 팝업(확인 필요) |
| 확인 필요 | clbResultType, txtModel2 + btnItemID2, drpPeriod3, txtLotID | 라벨 원문 미확보 |
| Search | btnSearch | 활성 Detail 시트별 조회 |

## 2. 액션별 호출 API 후보

| 액션 | As-is 진입 | 호출 API 후보 (순서는 확인 필요) |
|---|---|---|
| 화면 진입 | Form_Load | CommonData PlanDateShip → DM0003_GET_BUCKET_TYPE_CODE → SCM0001_GET_SCP_DAY_PERIOD → SCP0009_GET_SHEET_CALENDAR_3SPAN(헤더) |
| Division 변경 | clbDivision_SelectedIndexChanged | CommonData PlanDateShip, SCM0001_GET_SCP_DAY_PERIOD |
| Plan-date 변경 | CboPlanDate_SelectedIndexChanged | SCM0001_GET_SCP_DAY_PERIOD |
| 상단 시트 전환 | SpdMain_ActiveSheetChanged | CommonData LookupCommon, PlanDateShip, SCM0001_GET_SCP_DAY_PERIOD, SCP0009_GET_SHEET_CALENDAR_3SPAN |
| Measure | btnMeasure_Click | SCP0009_GET_SHEET_CALENDAR_3SPAN (Grid 재구성) |
| 조회 | FindButton | 시트/조건에 따라 SSP0015_GET_SHIPMENT_PSI \| SSP0015_GET_SHIPMENT_PSI_PACKER \| SSP0015_GET_SHIPMENT_PSI_PACKER_PAST (+ SSP0002_GET_NERP_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN) |
| 상단 셀 더블클릭 | SpdMain_CellDoubleClick | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, SSP0015_GET_WH_STOCK, SSP0015_GET_MES_STOCK, SSP0015_GET_BLOCK_STOCK, SSP0015_GET_STOCK_LOCATION_DETAIL(+NERP), SSP0015_GET_SCS_STOCK, SSP0015_GET_SHIPMENT_PSI. Comments 팝업 데이터(GAP / BEFORE_QTY / USER_ADD_QTY) 전달 |
| Detail Search | BtnSearch_Click | 시트별: Confirm Detail → SSP0015_GET_SHIPMENT_CONFIRM_DETAIL(_PACKER) / Request Detail → SSP0026_GET_REQUEST_DETAIL_PACK / W/H stock → SSP0015_GET_WH_STOCK / Hold stock Detail → SSP0015_GET_BLOCK_STOCK / Stock Detail → SSP0015_GET_MES_STOCK / SCS Stock Detail → SSP0015_GET_SCS_STOCK / Stock Location Detail → SSP0015_GET_STOCK_LOCATION_DETAIL / WH In Plan Detail → SSP0015_GET_SHIPMENT_PSI_COMMENTS / Shipment Result → SSP0015_GET_SHIPMENT_RESULT 또는 _PACKER |
| Detail 셀 클릭 | SpdDetail_CellClick | CommonData TransMode, ShipToCodeByDivision (셀 콤보). 헤더 CheckBox 전체 토글 |
| Detail 붙여넣기 | SpdDetail_ClipboardPasted | CommonData TransMode (CODE 검증) |
| 편집 | EditButton | CommonData PlanDateShip, SSP0002_GET_USER_INFO_LIST(사용자 권한 확인) |
| 저장 — 메인 | SaveButton > SaveData_Main | SSP0015_SAVE_SHIPMENT_PSI |
| 저장 — Detail(40) | SaveButton > SaveData_Detail | Validation_Check → SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 / SSP0015_SAVE_BLOCK_STOCK_DATA / SSP0015_SAVE_MES_STOCK → 재조회(GET_SHIPMENT_PSI, GET_SHIPMENT_CONFIRM_DETAIL, GET_MES_STOCK) |
| 저장 — Detail(Packer) | SaveButton > SaveData_Detail_Packer | SSP0202_GET_SCS_CONFIRM_ID_CHECK, SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, GetERPInterface{SCM_SSP_CHECK_CONFIRM_CHANGETIME, SSP0015_GET_ERP_SO_NO_CNT, SSP0015_GET_SHIPMENT_STATUS, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SoNo/NonSoNo → SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING(_PACKER), GetErpIFCheckNew → PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH} → SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER 재조회 |
| Comments 저장 | 팝업 btnButtonList | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

> 검증 순서와 메시지는 Fact Pack에 없습니다. TO-BE 구현 전에 As-is 원문과 SP 내부 검증을 먼저 대조해야 합니다(확인 필요). Validation_Check 검증 대상 필드: shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE (confirm_id 기준).

## 3. division별 Grid 변형 요약
- 메타(SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE)와 최종 Grid 모두 **14개 division에서 차이가 없습니다.**
- 변형 요인은 division이 아니라 다음과 같습니다.
  1. 상단 시트: `Shipment PSI(Mobility & IT)`(10컬럼, Measure 12/1) vs `Shipment PSI(Packer)`(8컬럼, Measure 6/0)
  2. Bucket Type(DAILY / WEEKLY / MONTHLY)과 Sum 체크에 따른 일자 컬럼 표시
  3. `ichkbtn` 상태에 따른 SetSoNoColumnVisible 폭 전환
  4. Packer / 40 저장 SP 분기(division 연관성 확인 필요)
- TO-BE에서는 메타 + 동적 일자 컬럼(SCP0009_GET_SHEET_CALENDAR_3SPAN, 3단 헤더 + SUM)을 결합하고, 토요일 파랑 / 일요일 빨강 헤더 색상을 재현해야 합니다.

## 4. 권한(C/R/U/D) 관련 사실
| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 14행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행 |
| R (조회) | FindButton, btnSearch, 더블클릭 조회 |
| U/C (저장) | SaveButton(SaveData_Main / _Detail / _Detail_Packer), 팝업 저장. DML 대상은 oracle_migration.md §1 |
| D (삭제성) | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(DELETE SSP_ANL_SHIP_CONFIRM), SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING(진입점 미연결). 별도 Delete 버튼 진입점은 Fact Pack에 없음 |
| 편집 진입 | EditButton > GetSSPUserCheck → SSP0002_GET_USER_INFO_LIST (TB_FX_USERGROUPINFO, TB_FX_USERGROUPAUTHEXTENTION 참조) |
| 시트 권한 | `WH In Plan Detail` 시트는 `drPgmAuthId != null`일 때만 생성 |
| 그룹/사용자 필터 | SetChangeControl이 GROUP_ID / USER_ID / UserInfoContext.Current.NowGroupID 사용. GetSSPInnerTable(DEPT_ID, COMPANY_ID, PLANT_ID 등) |
| 잠금 | SpdDetail_CellClick에서 `siDetail.IsLock(SheetName)==false`일 때만 헤더 체크 토글 |
| 담당 모델 필터 | 조회 SP 다수가 SSP_MST_MODEL_USER / SSP_MST_DELEGATE 참조. 숨김 체크박스(My Model 등)와 연관된 것으로 보이나 확인 필요 |
| 버튼 권한 메타(MNU / BTN) | Fact Pack에 없음 → 확인 필요 |

## 5. 미확정 사항
1. FindButton / SaveButton 내부 분기 조건과 호출 순서
2. Detail 조회 바 6개 컨트롤 라벨 원문, 팝업 컨트롤 라벨 원문(props.csv 잘림)
3. W/H stock, W/H stock Detail, Stock Location Detail, WH In Plan Detail 시트 컬럼 전체 목록(grid_effective.csv 잘림)
4. W/H stock Detail 시트의 조회 SP
5. Shipment Confirm Detail 표시 40 vs 메타 39의 차이
6. 메타 전용 시트(`Shipment PSI(IT & Mobile)`, `MES Stock Detail`)와 `SSP0015_TEMP2` 메타의 이관 여부
7. 진입점 미연결 메서드 6종의 실제 사용 여부
8. SaveButton > SaveData 귀속(팝업 SaveData vs PersonalSettingPopup.SaveData)
9. chkERPIFBlockYn(BLOCK_YN / PERIOD) 데이터 원천과 저장 차단 로직
10. 숨김 체크박스 4종의 SP 파라미터 반영 여부
11. Packer / 40 분기와 division의 관계
12. 동적 SQL SP 4종(GET_SHIPMENT_CONFIRM_DETAIL(_PACKER), GET_SHIPMENT_PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK)의 실제 참조 테이블
