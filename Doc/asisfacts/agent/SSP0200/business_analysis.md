# SSP0200 Shipment Change Request — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0200)과 1차 분석서(analysis.md, web_components.md, tobe_design.md).
> 현행(current)·공용(shared) 파일만 근거로 썼고, 구버전(legacy) 사본은 쓰지 않았습니다.
> Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다. 주석 처리된 호출 6건은 현행 기능에서 뺐습니다.
> 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트의 근거 열과 똑같이 씁니다.

## 1. 업무 목적·범위

### 1-1. 목적(사실 기반)
이 화면은 출하(Shipment) 확정 건의 변경을 요청하는 화면입니다.
- **변경요청 등록**: 변경요청번호를 채번하고, 확정 데이터를 신규 저장하며, 변경요청(Drafting)을 저장합니다.
- **변경요청 완료**: Request Complete 처리를 하고 메일 발송 체인을 실행합니다.
- **변경요청 취소**: Cancel 처리로 Draft를 삭제합니다.
- **ERP 인터페이스 연계**: SO 건은 ERP 오류 확정, IFSEQ 병합, `XIF_ERP_SHIP_PLAN_CONFIRM_S_SN` 적재를 함께 처리합니다.
- 화면 ID는 SSP0200, 클래스는 `SSP0200_ShipmentChangeRequest`입니다.
- 화면 경로는 `06.UIL\GSCM.SSP.Forms.UIL\Plan\`입니다. 메뉴 위치는 **확인 필요**입니다.

### 1-2. 범위
| 구분 | 내용 |
|---|---|
| 상단 그리드 | `Shipment Change Request` (spdMain). 변경 대상 출하 확정 목록이며 편집 가능합니다. |
| 하단 그리드 | `Change Request` (spdSub). 변경요청 Draft 목록이며 헤더가 2단입니다. |
| 변경요청 정보 | 요청번호, 제목, 요청자, 요청부서, 승인자, 승인부서, 변경사유, 사유상세 (usrLayoutControl3) |
| 부속 팝업 | `SSP0200_ShipmentChangeRequestInsertPopup`. Insert(Multi) 버튼으로 열며, 추가할 행 수를 입력합니다. |
| 엔드포인트 | 20개 (활성 기준) |
| SP | 17개 (FoxQuery 등록 기준). 미등록 2개는 DB 객체(P)로만 존재합니다. |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---:|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load`에서 `InitControls`를 거쳐 다음을 차례로 호출합니다: `SCP.SCM0001_GET_SCP_DAY_PERIOD`(GetDayRange) → `SSP.SSP0200_GET_SHIPMENT_DIVISION`(GetDivision) → `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`(SetChangedControl > GetShipmentPlanPlantSite) | 기간(drpPeriod), Div(clbDivision_ID), From Site(clbFromSite) 목록이 초기화됩니다 |
| S2 | Div를 변경합니다 | `clbDivision_ID_SelectedIndexChanged` > SetChangedControl > `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | From Site 목록을 다시 조회합니다 |
| S3 | Change Type을 변경합니다 | `CboChangeType_SelectedIndexChanged` > GetDayRange > `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간을 다시 계산합니다. 그리드 컬럼 폭과 헤더 변경(InitSpread 분기)과의 연결 시점은 **확인 필요**입니다 |
| S4 | 조회를 실행합니다 (FindButton) | FindData_Main > `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, FindData_Sub_Draft > `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | 상단 `Shipment Change Request`와 하단 `Change Request`에 결과를 표시합니다. 변경요청 정보 영역은 SetChangeRequestInfo로 채웁니다 |
| S5 | 행을 추가합니다 (InsertButton / New) | InsertRow 또는 `BtnNew_Click` > GetPlantSiteByDivisionEEOperation > `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | 신규 행이 추가되고 From Site 셀 콤보 소스가 설정됩니다 |
| S6 | Insert(Multi)를 누르고 수량을 입력합니다 | `btnInsertMultiple_Click`에서 팝업(Form_Load, `btnButtonList_UsrButtonList_Click_Detected`)을 띄운 뒤 InsertRowMultiple로 `SSP.SSP0200_GET_ITEM_FROM_BOD`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`을 호출합니다 | 여러 행이 추가됩니다. 팝업 반환값을 넘기는 방식은 **확인 필요**입니다 |
| S7 | 그리드 셀 값을 변경합니다 | `shtMain_Change`(dsdm.Changed) > GetItemFromBOD > `SSP.SSP0200_GET_ITEM_FROM_BOD` | Item/BOD 관련 값을 보정합니다. 어느 컬럼에 반영하는지는 **확인 필요**입니다 |
| S8 | 셀 콤보를 선택합니다 | `SpdMain_ComboSelChange` > FindData_BOD에서 `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`[TransMode]를 호출합니다. DIVISION_ID 컬럼이면 `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`도 호출합니다 | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL 값을 설정합니다. Division이 바뀌면 END_CUSTOMER와 PROJECT_* 컬럼의 표시가 전환됩니다 |
| S9 | Trans Mode 셀을 클릭합니다 | `SpdMain_CellClick` > `biz:CommonData.CommonDataList`[TransMode] | Trans Mode 콤보 목록이 표시됩니다. 헤더 CheckBox를 클릭하면 전체 선택/해제됩니다(5505~5544) |
| S10 | 저장합니다 (SaveButton) | 다음 순서로 처리합니다. ① `SSP.SSP0200_GET_CHANGE_REQ_NO`(862) ② `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`(1056) ③ GetERPInterface / GetNewERPInterface 분기: `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0200_GET_SHIPMENT_STATUS`, `SSP.SSP0200_GET_ERP_SO_NO_CNT`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`(SoNo / NonSoNo / NewNonSoNo), `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` ④ `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N`(FindData_Main_Nonasync) ⑤ 재조회(FindButton) | 변경요청이 Draft로 저장되고 ERP I/F 테이블에 반영됩니다. 실제 호출 순서와 분기 조건은 **확인 필요**입니다(정적 경로 기준) |
| S11 | Request Complete를 누릅니다 | `BtnChangeRe_Click` > SaveDataDrafting > `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | 변경요청이 완료 처리되고 SP 내부 메일 체인(SCM_SSP_MAIL_SEND → SP_SEND_DBMAIL)이 실행됩니다 |
| S12 | Save Draft를 누릅니다 (btnSave, 기본 Visible=false) | `BtnSave_Click` > SaveDataDrafting > `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | S11과 같은 엔드포인트를 씁니다. S11과 넘기는 파라미터가 어떻게 다른지는 **확인 필요**입니다 |
| S13 | Cancel을 누릅니다 | `BtnCancel_Click` > DeleteDataDrafting > `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`(2620, 그리고 GetErpIFCheck 4928) → 재조회 | Draft가 삭제되거나 상태가 변경됩니다 |
| S14 | 승인자 선택 버튼을 누릅니다 | `BtnApprovalUser_Click` (엔드포인트 미추출) | 승인자(txtApproval)와 승인부서(txtAppDeptName)가 설정되는 것으로 보입니다. **확인 필요** |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입]
  Form_Load
   ├─ GetDayRange ............ SCP.SCM0001_GET_SCP_DAY_PERIOD
   ├─ GetDivision ............ SSP.SSP0200_GET_SHIPMENT_DIVISION
   └─ SetChangedControl
        └─ GetShipmentPlanPlantSite .. SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE
        │
[조건 변경]
  clbDivision_ID_SelectedIndexChanged ─▶ SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE
  CboChangeType_SelectedIndexChanged ─▶ SCP.SCM0001_GET_SCP_DAY_PERIOD
        │
[조회] FindButton
   ├─ FindData_Main ......... SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST  → Shipment Change Request
   └─ FindData_Sub_Draft .... SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING → Change Request
        │
[편집] InsertButton / BtnNew_Click / btnInsertMultiple_Click(팝업)
   ├─ SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION
   └─ SSP.SSP0200_GET_ITEM_FROM_BOD (InsertRowMultiple, shtMain_Change)
   SpdMain_ComboSelChange ─▶ SSP.SSP0026_GET_BOD_ITEM / biz:CommonData.CommonDataList / …EE_OPERATION
   SpdMain_CellClick ─▶ biz:CommonData.CommonDataList [TransMode]
        │
[저장] SaveButton
   1 SSP.SSP0200_GET_CHANGE_REQ_NO
   2 SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW
   3 GetERPInterface / GetNewERPInterface
       ├─ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
       ├─ SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING
       ├─ GetShipmentStatusChk  SSP.SSP0200_GET_SHIPMENT_STATUS
       ├─ GetErpSoNoCnt         SSP.SSP0200_GET_ERP_SO_NO_CNT
       ├─ NewNonSoNo / NonSoNo / SoNo → SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING
       └─ SoNo ─┬─ GetErpIFCheckNew  SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
                └─ GetErpIFSeqMerge  SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE
   4 FindData_Main_Nonasync  SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N
   5 FindButton (재조회)
        │
[완료/취소]
  BtnChangeRe_Click / BtnSave_Click ─▶ SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE → 재조회
  BtnCancel_Click ─▶ SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING (DeleteDataDrafting, GetErpIFCheck) → 재조회
```

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거 |
|---:|---|---|
| R1 | Div가 "40" 또는 "EE"이면 `Shipment Change Request`에서 END_CUSTOMER, ERP_ATTR1, ERP_ATTR2, ERP_ATTR3을 **표시**하고 PROJECT_CODE, PROJECT_NAME을 **숨깁니다**. 그 외 Div는 반대입니다. | grid_code InitSpread:630~648 |
| R2 | 행의 DIVISION_ID 콤보를 바꿀 때도 같은 기준("40"/"EE")으로 END_CUSTOMER와 PROJECT_CODE/NAME 표시를 다시 적용합니다. ERP_ATTR*는 다시 적용하지 않습니다. | SpdMain_ComboSelChange:5668~5679 |
| R3 | Change Type이 "P"이면 `Shipment Change Request`의 ERP_SO_NO, CONFIRM_ID를 Width=0으로 둡니다. 그 외에는 각각 100, 120입니다. | InitSpread:607/608/618/619 |
| R4 | Change Type이 "P"이면 `Change Request`의 ERP_SO_NO를 숨깁니다. 그 외에는 표시합니다. 2단 헤더 Span은 "P"일 때 "Plan"/"Confirm", 그 외에는 "Confirmed"/"Change"입니다. | InitSpread:701/723, web_components §3-2 |
| R5 | `Change Request`의 CHK 컬럼은 CheckBox 셀이며 기본값은 false입니다. REMARKS는 Width=0입니다. | InitSpread:672~674, 696 |
| R6 | SetChangeRequestSOGrid는 spdSub 행을 돌면서, Ship Status가 "R"이 아니고 sSearchType이 "Exist"이면 CHK를 숨깁니다. | SetChangeRequestSOGrid:2275/2294 |
| R7 | 그리드가 잠기지 않았을 때(`siMain.IsLock(SheetName) == false`)만 InsertRow, BtnNew_Click, SpdMain_CellClick 헤더 체크 처리가 동작합니다. | grid_code SpdMain_CellClick:5505~5544, tobe_design §4 |
| R8 | 저장 전 필수값을 검증합니다(SSP_Main_Validation). 일반 건은 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks를 확인하고, SO 건은 INCOTERMS를 뺀 나머지를 확인합니다. 메시지와 조건식은 **확인 필요**입니다. | Fact Pack §4 |
| R9 | ERP I/F Block을 확인합니다(chkERPIFBlockYn: BLOCK_YN, PERIOD). 출처 SP와 판정식은 **확인 필요**입니다. | Fact Pack §4 |
| R10 | 셀 콤보 DIVISION_ID는 MyDivision에서 CODE가 "EE"가 아닌 값만 씁니다. | tobe_design §3 (InsertRow:2765, BtnNew_Click:3381/3422) |
| R11 | 조회조건 From Site 값은 GetCheckedListValue(CODE)로 다건 문자열을 만들어 넘깁니다. | Fact Pack §4-2 (FindData_Main:1466~1473, SaveButton:877) |
| R12 | 기간 초기값은 `SCM0001_GET_SCP_DAY_PERIOD`로 정합니다. 이 SP는 SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE를 참조합니다. 버킷 단위와 기간 길이는 **확인 필요**입니다. InitControls의 dtShipmentInputPeriod(VALUE, Diff_VALUE) 출처도 **확인 필요**입니다. | endpoints.csv |
| R13 | 저장 분기는 SO 유무 등에 따라 SoNo / NonSoNo / NewNonSoNo로 나뉩니다. 세 경로 모두 `SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`을 호출하며, SoNo 경로만 BY_CONFIRM 삭제와 IFSEQ 병합을 추가로 수행합니다. 분기를 정하는 조건식은 **확인 필요**입니다. | flow.csv |
| R14 | 저장, NonSoNo, SoNo 처리에서 결과 ds.Tables[0].Rows[0]의 reason_id, division_id, to_site를 읽습니다. 이 값의 업무 용도는 **확인 필요**입니다. | Fact Pack §4 |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기)

| # | 엔드포인트 | SP | 호출 위치 | 읽기(SELECT) 주요 | 쓰기(INSERT/UPDATE/DELETE/MERGE/EXEC) |
|---:|---|---|---|---|---|
| 1 | `SSP.SSP0200_GET_CHANGE_REQ_NO` | SSP0200_GET_CHANGE_REQ_NO | SaveButton:862 | 내부 미추출(**확인 필요**) | 내부 미추출 |
| 2 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW` | SSP0200_SAVE_SHIPMENT_CONFIRM_NEW | SaveButton:1056 | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_ITEM_SN, SCM_MST_PROJECT, SSP_PLAN_VERSION_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_CUSTOMER, SCM_SYS_CALENDAR_M, DM_PLN_MKT_FCST_CONFIRM, SSP_ANL_SHIP_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT, XIF_ERP_SHIP_DOC_R_SN, DM_PLN_MKT_FCST | INSERT SSP_ANL_SHIP_CONFIRM, INSERT DM_PLN_MKT_FCST_CONFIRM, MERGE DM_PLN_MKT_FCST, INSERT SCM_SYS_LOG_BATCH, EXEC PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SCM_SYS_LOG_BATCH |
| 3 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | FindData_Main:1529 | 동적 SQL(대상 테이블 **확인 필요**), FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 4 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` | SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N | FindData_Main_Nonasync:1650 | 동적 SQL(**확인 필요**), FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 5 | `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | FindData_Sub_Draft:2029 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | INSERT #TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(임시) |
| 6 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE | SaveDataDrafting:2463 | TB_FX_USER, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_RECIPIENT_LIST/MESSAGE/ASSIGN, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_ITEM_SN, SCM_MST_SITE | UPDATE SSP_ANL_SHIP_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SCM_SYS_LOG_BATCH, INSERT SCM_ADM_SMS_MAIL_SEND_LOG, EXEC SCM_SSP_MAIL_SEND, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SP_SEND_DBMAIL |
| 7 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING | DeleteDataDrafting:2620, GetERPInterface:3989, GetErpIFCheck:4928 (3회) | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_ANL_SHIP_CONFIRM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE / SSP_ANL_SHIP_CONFIRM, DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH, EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW, PR_SCP_SYS_LOG_BATCH |
| 8 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD | GetDayRange:3129 | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE | — |
| 9 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | GetERPInterface:3950 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH |
| 10 | `SSP.SSP0200_GET_SHIPMENT_STATUS` | SSP0200_GET_SHIPMENT_STATUS | GetShipmentStatusChk:4096 | SSP_ANL_SHIP_CONFIRM (STRING_SPLIT) | — |
| 11 | `SSP.SSP0200_GET_ERP_SO_NO_CNT` | SSP0200_GET_ERP_SO_NO_CNT | GetErpSoNoCnt:4161 | SSP_ANL_SHIP_CONFIRM (결과 CNT) | — |
| 12 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING | NewNonSoNo:4297, NonSoNo:4491, SoNo:4771 (3회) | SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, DM_PLN_MKT_FCST_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT, XIF_ERP_SHIP_DOC_R_SN, DM_PLN_MKT_FCST | MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE SSP_ANL_SHIP_CONFIRM, INSERT DM_PLN_MKT_FCST_CONFIRM, MERGE/INSERT DM_PLN_MKT_FCST, INSERT SCM_SYS_LOG_BATCH, EXEC PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SCP_SYS_LOG_BATCH |
| 13 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | GetErpIFCheckNew:5009 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / SSP_ANL_SHIP_CONFIRM, DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH |
| 14 | `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` | PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE | GetErpIFSeqMerge:5067 | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN |
| 15 | `biz:CommonData.CommonDataList` [code=TransMode] | (Biz, UP_FX_GetCommonDataList 코드분기) | SpdMain_CellClick:5466, FindData_BOD:6731 (2회) | SCP_MST_BOD_V | — |
| 16 | `SSP.SSP0026_GET_BOD_ITEM` | SSP0026_GET_BOD_ITEM | FindData_BOD:6711 | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM (STRING_SPLIT) | — |
| 17 | `SSP.SSP0200_GET_ITEM_FROM_BOD` | SSP0200_GET_ITEM_FROM_BOD | GetItemFromBOD:6756 | 동적 SQL(**확인 필요**) | — |
| 18 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | SSP0200_GET_SHIPMENT_DIVISION | GetDivision:6781 | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE | — |
| 19 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | (FoxQuery 미등록, DB 객체 P 존재) | GetShipmentPlanPlantSite:6798 | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (STRING_SPLIT) | — |
| 20 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | (FoxQuery 미등록, DB 객체 P 존재) | GetPlantSiteByDivisionEEOperation:6812 | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION | — |

공통: 쓰기 SP 대부분이 `PR_SCM_SYS_LOG_BATCH(_CALL_TRAN)`으로 `SCM_SYS_LOG_BATCH`에 로그를 남깁니다.

## 6. Division·권한별 변형

### 6-1. Division
| 구분 | 40 / EE | 81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC |
|---|---|---|
| `Shipment Change Request` 표시 컬럼 수(grid_effective) | 34 (?4) | 32 (?4) |
| 표시 컬럼 | END_CUSTOMER, ERP_ATTR1(Consignee Name), ERP_ATTR2(Contact Point), ERP_ATTR3(Lot) | PROJECT_CODE(Project Code*), PROJECT_NAME(Project Name) |
| `Change Request` 표시 컬럼 수 | 25 (?5) | 26 (?5) |
| 메타 컬럼 수 | Change Request 26/0, Shipment Change Request 36/0 (모든 division 동일) | 같음 |

- `Change Request`에서 25와 26이 갈리는 원인은 파서가 END_CUSTOMER/PROJECT_* 코드 변경을 이 시트에 귀속시킨 것입니다. 이 귀속은 추정이므로 **확인 필요**입니다.
- 셀 콤보 DIVISION_ID는 "EE"를 제외합니다(R10).

### 6-2. 권한
- Division 목록과 Site 목록 SP 3개(SSP0200_GET_SHIPMENT_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION)는 `TB_FX_USERGROUPAUTHEXTENTION`을 참조합니다. 사용자 그룹(`UserInfoContext.Current["NowGroupID"]`)에 따라 목록이 필터링됩니다.
- NowGroupID를 읽는 위치: SetChangeControl, SetChangedControl, SaveDataDrafting, GetDivision, GetShipmentPlanPlantSite, GetPlantSiteByDivisionEEOperation
- SetChangeControl은 Filter(GROUP_ID, USER_ID)와 GetSSPInnerTable(7회)을 사용합니다. 무엇을 제어하는지는 **확인 필요**입니다.
- 메타 테이블 행 수: TB_FX_GroupMenuAuth 16행, TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행. 버튼별 C/R/U/D 값은 **확인 필요**입니다.
- 그리드 잠금 여부(`siMain.IsLock`)에 따라 편집 기능이 제한됩니다(R7).

## 7. 외부 인터페이스 (사실에 있는 것만)
| 대상 | 방식 | 엔드포인트 |
|---|---|---|
| ERP 출하계획 I/F (`XIF_ERP_SHIP_PLAN_CONFIRM_S_SN`) | INSERT / UPDATE | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` |
| ERP 출하문서 결과 (`XIF_ERP_SHIP_DOC_R_SN`) | SELECT | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| ERP 오류 확정 (`SSP_ANL_SHIP_ERP_ERROR_CONFIRM`) | INSERT | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| 메일 (DB Mail) | EXEC SCM_SSP_MAIL_SEND → SCM_ADM_MAIL_SEND → SP_SEND_DBMAIL, 로그 SCM_ADM_SMS_MAIL_SEND_LOG | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| DM 연계 (DM_PLN_MKT_FCST, DM_PLN_MKT_FCST_CONFIRM) | MERGE / INSERT, EXEC PR_DM_SSP_CONFIRM_SYNC | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |

## 8. 미확정·확인 필요
1. `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`와 `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`은 FoxQuery에 없고 DB 객체(P)만 있습니다. TO-BE 매핑 방식을 정해야 합니다.
2. 동적 SQL SP 3개(SSP0200_GET_SHIPMENT_CHANGE_REQUEST, SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N, SSP0200_GET_ITEM_FROM_BOD)의 조회 대상 테이블과 SSP0200_GET_CHANGE_REQ_NO의 내부 객체를 확인해야 합니다.
3. 저장 분기 조건이 아직 정해지지 않았습니다.
   - SoNo / NonSoNo / NewNonSoNo를 가르는 조건
   - GetERPInterface와 GetNewERPInterface 중 어느 것을 탈지 정하는 조건
   - 실행 순서
4. 데이터 출처가 미추출입니다: chkERPIFBlockYn의 BLOCK_YN·PERIOD, InitControls의 dtShipmentInputPeriod, TO_SITE 콤보 소스(Data_SCP.Common), 그리고 Status·Change Type·Change Reason 콤보 소스
5. BtnSave_Click(Save Draft)과 BtnChangeRe_Click(Request Complete)이 SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE에 넘기는 파라미터 차이를 확인해야 합니다.
6. 검증 메시지 문구와 조건식(SSP_Main_Validation)이 미추출입니다.
7. 상단과 하단 그리드의 연동(마스터-디테일 여부)이 미추출입니다. SpdMain_CursorChanged 내부를 확인해야 합니다.
8. btnDel(Delete)은 배선이 없고 btnAdd·dtDate는 Visible=false입니다. 실제로 쓰이는지 확인해야 합니다.
9. grid_effective 판단불가 140건, 그리고 시트 귀속 추정 건(CHK, END_CUSTOMER/PROJECT_*)이 남아 있습니다.
10. 권한 메타(TB_FX_GroupMenuAuth 16행)의 C/R/U/D 실제 값을 확인해야 합니다.
11. 주석 처리된 호출 6건은 현행 기능에서 뺐습니다(Fact Pack §9).
