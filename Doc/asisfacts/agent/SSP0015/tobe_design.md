# SSP0015 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단 조회조건

| 순서(Designer) | 컨트롤 | 라벨 | 필수 | 데이터 원천 | 연동 이벤트 |
|---|---|---|---|---|---|
| 1 | clbDivision | Division* | Y (`*`) | GetSSPInnerTable 계열 (SetChangeControl:456~491, 확인 필요) | clbDivision_SelectedIndexChanged → PlanDateShip 공통코드 재조회, GetDayRange |
| 2 | cboPlanDate | Plan-date* | Y | `biz:CommonData.CommonDataList` code=PlanDateShip | CboPlanDate_SelectedIndexChanged → `SCM0001_GET_SCP_DAY_PERIOD` |
| 3 | drpPeriod | Period* | Y | `SCM0001_GET_SCP_DAY_PERIOD`(GetDayRange) | – |
| 4 | cboBucketType | Bucket | – | `DM0003_GET_BUCKET_TYPE_CODE` (값 DAILY/WEEKLY/MONTHLY는 코드 비교식에서 확인) | cboBucketType_SelectedIndexChanged → 컬럼 표시 (SetSpreadColumn 추정, 확인 필요) |
| 5 | chkSum | Sum | – | – | chkSum_CheckedChanged → M_ 또는 W_ 합계 컬럼 표시 |
| 6 | btnMeasure | (Text 확인 필요) | – | – | btnMeasure_Click → InitSpread 재생성 (SCP0009_GET_SHEET_CALENDAR_3SPAN) |
| 7 | clbPlantSite | From Site | – | 확인 필요 | – |
| 8 | txtItemId + btnItemId | Model | – | btnItemId_Click (팝업, 내용 확인 필요) | – |
| – | chkMyModel / chkPartLeader / chkTeamLeader / chkDelegateeModel | My Model / Part Leader / Team Leader / Delegatee Model | – | Visible=false (chkMyModel Checked=true) | 숨김. 조회 파라미터로 쓰이는지 확인 필요 |

- 조회조건 순서는 위 표의 Designer 선언 순서가 아니라 LayoutControl 배치 좌표로 정해진다. 좌표가 추출되지 않아 실제 순서는 **확인 필요**하다.

### 1-2. 하단 상세 조회조건

| 컨트롤 | 라벨 | 비고 |
|---|---|---|
| clbResultType | 확인 필요 | Shipment Result 시트용으로 추정 (확인 필요) |
| txtRequestor + btnRequestor | Requestor (항목명) | BtnRequestor_Click |
| txtModel2 + btnItemID2 | 확인 필요 | BtnItemID2_Click |
| drpPeriod2 | Shipment Date | – |
| drpPeriod3 | 확인 필요 | – |
| txtLotID | 확인 필요 | – |
| btnSearch | Search | BtnSearch_Click → 활성 Detail 시트별 조회 |

## 2. 액션별 호출 API 후보

API 경로는 정하지 않았다. SP 단위의 후보만 적었다.

| 액션 | AS-IS 진입점 | 호출 SP (순서는 경로 기준) |
|---|---|---|
| 화면 진입 | Form_Load | CommonDataList(PlanDateShip) → `DM0003_GET_BUCKET_TYPE_CODE` → `SCM0001_GET_SCP_DAY_PERIOD` → `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| Division 변경 | clbDivision_SelectedIndexChanged | CommonDataList(PlanDateShip) → `SCM0001_GET_SCP_DAY_PERIOD` |
| Plan-date 변경 | CboPlanDate_SelectedIndexChanged | `SCM0001_GET_SCP_DAY_PERIOD` |
| Main 시트 전환 | SpdMain_ActiveSheetChanged | CommonDataList(LookupCommon, PlanDateShip) → `SCM0001_GET_SCP_DAY_PERIOD` → `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| 조회 (Mobility & IT) | FindButton > FindData_Main | `SSP0015_GET_SHIPMENT_PSI` (+ Re_Design > `SSP0002_GET_NERP_CODE`) |
| 조회 (Packer) | FindButton > FindData_Main_Packer / _Past | `SSP0015_GET_SHIPMENT_PSI_PACKER` / `SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` (분기 조건 확인 필요) |
| Measure 변경 | btnMeasure_Click | `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| Main 더블클릭 | SpdMain_CellDoubleClick | 활성 Detail 시트에 따라 `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / `SSP0015_GET_WH_STOCK` / `SSP0015_GET_MES_STOCK` / `SSP0015_GET_BLOCK_STOCK` / `SSP0015_GET_STOCK_LOCATION_DETAIL` / `SSP0015_GET_SCS_STOCK` / `SSP0015_GET_SHIPMENT_PSI` |
| Detail Search | BtnSearch_Click | `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL(_PACKER)`, `SSP0015_GET_WH_STOCK`, `SSP0015_GET_BLOCK_STOCK`, `SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP0015_GET_SCS_STOCK`, `SSP0015_GET_MES_STOCK`, `SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP0015_GET_SHIPMENT_PSI_COMMENTS`, `SSP0015_GET_SHIPMENT_RESULT(_PACKER)` |
| 편집 모드 | EditButton | CommonDataList(PlanDateShip) → `SSP0002_GET_USER_INFO_LIST` |
| 저장 (Main) | SaveButton > SaveData_Main | `SSP0015_SAVE_SHIPMENT_PSI` |
| 저장 (Detail 40 계열) | SaveButton > SaveData_Detail | `SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP0015_SAVE_BLOCK_STOCK_DATA`, `SSP0015_SAVE_MES_STOCK` → 재조회 |
| 저장 (Detail Packer) | SaveButton > SaveData_Detail_Packer | `SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` → `SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` → GetERPInterface (아래 행) → `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` 재조회 |
| ERP I/F (Packer 저장 하위) | GetERPInterface | 사전 점검: `SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP0015_GET_ERP_SO_NO_CNT`, `SSP0015_GET_SHIPMENT_STATUS`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`<br>SoNo / NonSoNo: `SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING(_PACKER)`<br>GetErpIFCheckNew: `SCM_SSP_DELETE_..._BY_CONFIRM`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| 코멘트 저장 (팝업) | btnButtonList_UsrButtonList_Click_Detected > SaveData | `SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` |
| Detail 콤보 | SpdDetail_CellClick / SpdDetail_ClipboardPasted | CommonDataList(TransMode, ShipToCodeByDivision) |
| (미연결) | GetErpIFCheck, GetErpIFCheckNew_, NewNonSoNo, GetDivision, SCM_SYS_LOG_BATCH, SetChangedPeriod | `SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SCM0001_GET_DIVISION`, `PR_SCM_SYS_LOG_BATCH`, PERIOD 공통코드. 이관 여부는 확인 필요 |

- Packer 저장 하위 단계의 실행 순서와 분기 조건(SoNo와 NonSoNo 중 무엇을 타는지)은 Fact Pack에 없어 **확인 필요**하다.
- Validation_Check는 저장 전에 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE를 읽는다(6318~6472줄). 검증 규칙의 상세는 **확인 필요**하다.
- chkERPIFBlockYn은 BLOCK_YN과 PERIOD를 읽는다(7449/7458줄). 이 데이터의 원천 엔드포인트는 추출되지 않아 **확인 필요**하다.

## 3. division별 Grid 변형 요약

- 14개 division 전부 시트별 표시 컬럼 수가 같다. **division별 변형은 없다.**
- 변형은 division이 아니라 다음 조건에서 생긴다.
  - Bucket(DAILY/WEEKLY/MONTHLY)과 Sum 체크: D_/W_/M_ 날짜 컬럼 표시
  - Main 시트 종류(Mobility & IT / Packer): MergePolicy, SO No 컬럼 Width(SetSoNoColumnVisible)
  - 권한 행(drPgmAuthId)이 있을 때만 WH In Plan Detail 시트 생성
  - Shipment Result 조회 시 SHIP_TO와 SHIPTO_DESCRIPTION 숨김

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 근거 |
|---|---|
| 메뉴 권한 메타 14행 | dbo.TB_FX_GroupMenuAuth (dbmeta, 14행) |
| WH In Plan Detail 시트는 권한 행이 있을 때만 생성 | CreateSpread:680/731/732, InitSpread:965/967 `if(drPgmAuthId != null)` |
| 편집 진입 시 사용자 정보 확인 | EditButton > GetSSPUserCheck:9901 → `SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 등) |
| 그룹 기반 필터 | SetChangeControl:449/450 (Filter GROUP_ID, USER_ID / NowGroupID), InitControls:584, SpdMain_ActiveSheetChanged:1459, SetChangedControl:2209 |
| 시트 잠금 시 헤더 체크박스 동작이 다름 | SpdDetail_CellClick: `siDetail.IsLock(siDetail.SheetName)` 분기 (8618/8653/8657줄) |
| 모델 담당 범위 체크박스(My Model 등)는 숨김 | Designer Visible=false. 권한 범위로 쓰이는지 확인 필요 |
| 저장 전 계획 진행 여부 확인 | EngProcessingChk → `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| C/R/U/D 버튼별 권한 매핑 | TB_FX_GroupMenuAuth 행 내용이 Fact Pack에 없어 **확인 필요** |

## 5. 미확정 사항

1. FindButton의 Main 조회 분기 조건. FindData_Main, _Packer, _Packer_Past 중 무엇을 부르는지 정하는 조건이다.
2. GetERPInterface 하위 단계의 순서와 분기, 오류 처리.
3. unreached 메서드 6개를 이관할지 여부.
4. 메타에만 있는 시트를 넣을지: Shipment PSI(IT & Mobile), MES Stock Detail, SSP0015_TEMP2.
5. 컬럼 상세가 잘린 시트 4개: W/H stock, W/H stock Detail, Stock Location Detail, WH In Plan Detail.
6. W/H stock Detail 시트의 조회 엔드포인트.
7. 라벨을 못 찾은 컨트롤: clbResultType, txtModel2, drpPeriod3, txtLotID, btnMeasure, btnItemId, 팝업 텍스트박스들.
8. 동적 SQL SP 8개가 실제로 참조하는 테이블과, 그 안의 MSSQL 문법.
9. SaveButton과 팝업 SaveData의 연결이 맞는지. 4-2장에서 `PersonalSettingPopup.SaveData`로 해석된 점과 충돌한다.
10. SP 실행 결과 컬럼과 메타 컬럼이 맞는지. grid 단계가 실행되지 않았다.
11. 주석 처리된 호출 4건(3573, 9288, 9308, 9309줄)은 TO-BE 기능에 넣지 않는다. 주석 처리됨.
