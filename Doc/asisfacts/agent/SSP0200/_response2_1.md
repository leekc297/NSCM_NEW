=== FILE: business_analysis.md ===
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

=== FILE: screen_design.md ===
# SSP0200 Shipment Change Request — 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_code, grid_effective)과 1차 분석서.
> props.csv 일부(LayoutControlItem Text 등)는 잘려서 추출되지 않았습니다. 해당 라벨은 **미추출(확인 필요)**로 적었습니다.
> 엔드포인트 이름은 업무분석서 §5와 같습니다. 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요
| 항목 | 값 |
|---|---|
| 화면 ID | SSP0200 |
| 화면명 | Shipment Change Request (`SSP0200_ShipmentChangeRequest`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 4행, 내용 미추출) |
| 도메인 | SSP / Plan |
| 그리드 구성 | META(프레임워크) + 코드 표시/라벨 변경. 메타는 SCM_MST_SHEET_COLUMNS 124행입니다 |
| 시트 | `Shipment Change Request` (spdMain), `Change Request` (spdSub) |
| 팝업 | SSP0200_ShipmentChangeRequestInsertPopup (shared). 다건 행 추가 수량을 입력합니다 |

## 2. 화면 레이아웃 (분할 트리 와이어프레임)

근거는 다음 props.csv 값입니다.
- splitContainer1: Dock=Fill, Orientation=Horizontal, Size=1192×649, SplitterDistance=253
- usrConditionPanel1: Dock=Top, 1192×73, HidePanel
- usrLayoutControl1: Fill, 1192×73
- spdMain: Fill, 1192×180
- panel3: Dock=Top, 1192×179
- usrLayoutControl2: Fill, 432×179
- spdSub: Fill, 1192×213
- controls.csv parent 체인

```
SSP0200 (Form)
└─ splitContainer1  [Dock=Fill · Orientation=Horizontal → 상/하 분할 · 1192×649 · SplitterDistance=253]
   ├─ Panel1 (상단) 253px / 649px = 39.0%
   │  ├─ usrConditionPanel1 [Dock=Top · 1192×73 · HidePanel(접이식)]       ── 조회조건 영역 (73/253 = 28.9%)
   │  │  └─ usrLayoutControl1 [Dock=Fill · 1192×73]
   │  │     ├ clbDivision_ID(Div) · clbFromSite(From Site) · clbToSite(To Site) · cboStatus(Status)
   │  │     ├ drpPeriod(Shipment Date) · cboChangeType(Change Type) · txtSoNo(SO No) · txtConfirmId(Confirm Id)
   │  │     ├ txtRequest + btnItemId (LayoutItem "Model", Text 미추출) · chkSingleProcess (Text 미추출)
   │  │     └ btnNew("New") · btnInsertMultiple("Insert(Multi)")                ── 행 추가 버튼
   │  └─ spdMain [Dock=Fill · 1192×180] (180/253 = 71.1%)                     ── 그리드: Shipment Change Request
   │     └─ spdMain_Sheet1
   └─ Panel2 (하단) 나머지 = 649 − 253 = 396px (61.0%; 스플리터 폭 미추출이라 정확값은 확인 필요)
      ├─ panel3 [Dock=Top · 1192×179]                                        ── 액션 + 변경요청 정보
      │  ├─ usrLayoutControl2 [Dock=Fill · 432×179]                            ── 버튼 영역
      │  │  ├ btnChangeRe2("Request Complete") · btnSave("Save Draft", Visible=false)
      │  │  ├ btnCancel("Cancel") · btnDel("Delete")
      │  │  └ btnAdd("Add Date", Visible=false) · dtDate(Visible=false)
      │  └─ panel1 [Dock·위치 미추출 — 확인 필요]
      │     └─ usrLayoutControl3                                               ── 변경요청 정보 영역
      │        ├ txtRequestNo · txtTitle · txtRequestor · txtRequestDeptName
      │        ├ txtApproval + btnApprovalUser · txtAppDeptName
      │        └ cboChangeReason · txtReasonDetail · usrLabel2
      └─ spdSub [Dock=Fill · 1192×213]                                        ── 그리드: Change Request (2단 헤더)
         └─ spdSub_Sheet1

※ panel3(179) + spdSub(213) = 392px. Panel2 396px와 4px 차이가 나는데, 원인은 미확인입니다.
※ usrLayoutControl2는 Dock=Fill인데 Size가 432×179로 기록돼 있습니다. panel1과 좌우로 나뉘는지는 확인 필요합니다.
※ txtItemId: controls.csv의 parent가 없어 배치 위치를 확인해야 합니다.

[팝업] SSP0200_ShipmentChangeRequestInsertPopup
└─ usrConditionPanel1 (parent=this)
   └─ usrLayoutControl2
      ├ usrLabel1 (Text 미추출)
      ├ txtCurrentInsert_Qty (추가 행 수)
      └ btnButtonList (UsrButtonList_Click_Detected)
```

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | spdMain | FarPoint FpSpread | — | — | — | SpdMain_TopChange, SpdMain_CellClick, SpdMain_CellDoubleClick, SpdMain_EditChange, SpdMain_ClipboardPasted, SpdMain_ComboSelChange, SpdMain_CursorChanged | Wijmo FlexGrid (편집) |
| 2 | spdMain_Sheet1 | SheetView | 시트 `Shipment Change Request` | 메타 36/0 | — | (dsdm.Changed → shtMain_Change) | FlexGrid columns |
| 3 | usrConditionPanel1 | UsrConditionPanel | — | HidePanel | — | — | 조회조건 접이식 패널 |
| 4 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" | — | — | — | 조회조건 레이아웃 |
| 5 | btnInsertMultiple | UsrButton | "Insert(Multi)" | — | — | btnInsertMultiple_Click | Button + 수량 팝업 |
| 6 | txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 7 | clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | SSP0200_GET_SHIPMENT_DIVISION 결과 | 확인 필요 | clbDivision_ID_SelectedIndexChanged | Wijmo ComboBox |
| 8 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE 결과 | 확인 필요 | — | Wijmo MultiSelect |
| 9 | txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 10 | drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | SCM0001_GET_SCP_DAY_PERIOD | 확인 필요 | — | DateRange (InputDate×2) |
| 11 | cboStatus | UsrCombo | "Status" (PlanType) | 소스 확인 필요 | 확인 필요 | — | Wijmo ComboBox |
| 12 | txtRequest | UsrMultiLineEditor | 미추출 (LayoutItem "Model") | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 13 | btnItemId | UsrButton | 미추출 (layoutControlItem2) | — | — | btnItemId_Click | 팝업 호출 버튼 |
| 14 | cboChangeType | UsrCombo | "Change Type" (PlanType1) | 소스 확인 필요 ("P" 값 존재) | 확인 필요 | CboChangeType_SelectedIndexChanged | Wijmo ComboBox |
| 15 | clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | 소스 확인 필요 | 확인 필요 | — | Wijmo MultiSelect |
| 16 | btnNew | UsrButton | "New" | — | — | BtnNew_Click | Button |
| 17 | chkSingleProcess | CheckEdit | 미추출 (CheckSingleProcess) | 확인 필요 | — | — | CheckBox |
| 18 | spdSub | FarPoint FpSpread | — | — | — | 배선 없음 | Wijmo FlexGrid (2단 헤더) |
| 19 | spdSub_Sheet1 | SheetView | 시트 `Change Request` | 메타 26/0 | — | — | FlexGrid columns |
| 20 | usrLayoutControl2 | UsrLayoutControl | 미추출 | — | — | — | 버튼 영역 레이아웃 |
| 21 | dtDate | UsrDatePicker | 미추출 (lcDate) | Visible=false | — | — | InputDate (숨김) |
| 22 | btnDel | SimpleButton | "Delete" | — | — | **배선 없음(확인 필요)** | Button |
| 23 | btnCancel | SimpleButton | "Cancel" | — | — | BtnCancel_Click | Button |
| 24 | btnSave | SimpleButton | "Save Draft" | Visible=false | — | BtnSave_Click | Button (숨김) |
| 25 | btnAdd | SimpleButton | "Add Date" | Visible=false | — | 배선 없음 | Button (숨김) |
| 26 | btnChangeRe2 | SimpleButton | "Request Complete" | — | — | BtnChangeRe_Click | Button |
| 27 | usrLayoutControl3 | UsrLayoutControl | 미추출 | — | — | — | 변경요청 정보 폼 |
| 28 | txtRequestNo | TextBox | 미추출 | CHANGE_REQ_NO (SetChangeRequestInfo) | 확인 필요 | — | Input (읽기 전용 여부 확인 필요) |
| 29 | txtTitle | TextBox | 미추출 (lcTitle) | REQUEST_TITLE | 확인 필요 | — | Input |
| 30 | txtRequestor | TextBox | 미추출 | REQUEST_USER(_NAME) | 확인 필요 | — | Input |
| 31 | txtRequestDeptName | TextBox | 미추출 | REQUEST_DEPT(_NAME) | 확인 필요 | — | Input |
| 32 | txtAppDeptName | TextBox | 미추출 (lcAppDept) | APPROVAL_DEPT(_NAME) | 확인 필요 | — | Input |
| 33 | cboChangeReason | UsrComboBox | 미추출 (lcChangeReason) | CHANGE_REASON_CODE, 소스 확인 필요 | 확인 필요 | — | Wijmo ComboBox |
| 34 | txtReasonDetail | TextBox | 미추출 (lcReasonDetail) | CHANGE_REASON_DETAIL | 확인 필요 | — | Input / TextArea |
| 35 | btnApprovalUser | UsrButton | 미추출 | — | — | BtnApprovalUser_Click | 승인자 선택 팝업 버튼 |
| 36 | usrLabel2 | UsrLabel | 미추출 | — | — | — | Label |
| 37 | txtApproval | TextBox | 미추출 (lcApproval) | APPROVAL_USER(_NAME) | 확인 필요 | — | Input |
| 38 | txtItemId | UsrMultiLineEditor | 미추출 (parent 없음) | 확인 필요 | — | — | 확인 필요 |
| 39 | usrLabel1 | UsrLabel (팝업) | 미추출 | — | — | — | Label |
| 40 | txtCurrentInsert_Qty | UsrTextBox (팝업) | — | 확인 필요 | 확인 필요 | — | InputNumber |
| 41 | btnButtonList | UsrButtonList (팝업) | — | — | — | btnButtonList_UsrButtonList_Click_Detected | 확인/취소 버튼 그룹 |

> 필수 여부는 Fact Pack에 컨트롤 단위 근거가 없어 모두 **확인 필요**로 두었습니다. 그리드 셀 필수 여부는 §4와 §6을 봅니다.

## 4. 그리드 명세

### 4-1. 시트 `Shipment Change Request` (spdMain, 헤더 1행, 메타 36/0 → 최종 40/EE 34열, 그 외 32열, 판단불가 ?4)

| 컬럼 | 헤더(메타) | 타입 | 출처 | 40 / EE | 그 외 | 편집 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | Combo (MyDivision, EE 제외) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 (IsLock 기준) |
| CONFIRM_ID | Confirm/Plan ID | Text | META + 코드 Width | 표시 (ChangeType "P" → Width 0, 그 외 120) | 같음 | 확인 필요 |
| ERP_SO_NO | SO No | Text | META + 코드 Width | "P" → Width 0, 그 외 100 | 같음 | 확인 필요 |
| SHIPMENT_STATUS | Status | Text | META | 표시 | 표시 | 확인 필요 |
| ITEM_ID | Model* | Text | META | 표시 | 표시 | 확인 필요 |
| NICK_NAME | Nick Name | Text | META | 표시 | 표시 | 확인 필요 |
| FCST_TYPE | FCST Type* | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| FROM_SITE | From Site ID | Text | META | 표시 | 표시 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site* | Combo (SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 |
| TO_SITE | To Site ID | Text | META | 표시 | 표시 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site* | Combo (Data_SCP.Common, 확인 필요) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 |
| TO_SITE_SHIPTO_CODE | Ship to | Text | META | 표시 | 표시 | 확인 필요 |
| TO_SITE_SOLDTO_CODE | Sold to | Text | META | 표시 | 표시 | 확인 필요 |
| END_CUSTOMER | End Customer* | 확인 필요 | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| ERP_ATTR1 | Consignee Name | Text | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| ERP_ATTR2 | Contact Point | Text | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| ERP_ATTR3 | Lot | Text | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| PROJECT_CODE | Project Code* | 확인 필요 | META + 코드 Visible | **숨김** | **표시** | 확인 필요 |
| PROJECT_NAME | Project Name | Text | META + 코드 Visible | **숨김** | **표시** | 확인 필요 |
| INCOTERMS | Incoterms* | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | Combo (biz:CommonData.CommonDataList TransMode) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 |
| LT_DAY | L/T(Day) | Number | META | 표시 | 표시 | 확인 필요 |
| ETD | ETD | Date | META | 표시 | 표시 | 확인 필요 |
| ETA | ETA | Date | META | 표시 | 표시 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date* | Date | META | 표시 | 표시 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | Number | META | 표시 | 표시 | 확인 필요 |
| REQUEST_DATE | Request Date | Date | META | 표시 | 표시 | 확인 필요 |
| REQUESTOR | Shipment Requestor | Text | META | 표시 | 표시 | 확인 필요 |
| MTK_OWNER | MKT Owner | Text | META | 표시 | 표시 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS | Remarks | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS2 | Building | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS3 | Customer Requirement | Text | META | 표시 | 표시 | 확인 필요 |
| ATTRIBUTE10 | ATTRIBUTE10 | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| EDIT_MAIN | EDIT_MAIN | 확인 필요 | META | 표시 | 표시 | 확인 필요 |

- 메타 숨김 컬럼(정의만 있음): BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_* 계열 15개, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE
- 헤더의 '*'는 메타 라벨 원문입니다. 이것이 저장 필수와 같은 뜻인지는 SSP_Main_Validation 조건식으로 확인해야 합니다.

### 4-2. 시트 `Change Request` (spdSub, 헤더 2행, 메타 26/0 → 최종 40/EE 25열, 그 외 26열, 판단불가 ?5)

| 컬럼 | 헤더(메타) | 상위 헤더 Span | 타입 | 출처 | 40 / EE | 그 외 | 편집 |
|---|---|---|---|---|---|---|---|
| CHK | ALL | — | CheckBox (기본 false) | META + 코드 CellType | 표시 (Ship Status가 "R"이 아니고 sSearchType이 "Exist"이면 숨김) | 같음 | 체크 가능 |
| CHANGE_REQ_NO | Change Req.No | — | Text | META | 표시 | 표시 | 확인 필요 |
| CONFIRM_ID | Confirm id | — | Text | META | 표시 | 표시 | 확인 필요 |
| ERP_SO_NO | SO No | — | Text | META + 코드 Visible | "P"이면 숨김, 그 외 표시 | 같음 | 확인 필요 |
| ITEM_ID | Model | — | Text | META | 표시 | 표시 | 확인 필요 |
| NICK_NAME | Nick Name | — | Text | META | 표시 | 표시 | 확인 필요 |
| FCST_TYPE | FCST Type | — | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | — | Text | META | 표시 | 표시 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | — | Text | META | 표시 | 표시 | 확인 필요 |
| INCOTERMS | Incoterms | — | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| PROJECT_NAME / PROJECT_CODE / END_CUSTOMER | Project Name / Project Code / — | — | 확인 필요 | 코드 변경 귀속 추정 | 확인 필요 | 확인 필요 | 확인 필요 |
| LT_DAY, ETD, ETA, TRANSPORT_MODE, SHIPMENT_DATE, SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty | "Plan"("P") / "Confirmed"(그 외) | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| NEW_LT_DAY, NEW_ETD, NEW_ETA, NEW_TRANSPORT_MODE, NEW_SHIPMENT_DATE, NEW_SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date*, Qty* | "Confirm"("P") / "Change"(그 외) | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| REMARKS | Remarks | — | Text | META + 코드 Width=0 | 사실상 숨김 | 같음 | — |
| REMARKS2 | Building | — | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS3 | Customer requirement | — | Text | META | 표시 | 표시 | 확인 필요 |

- 메타 숨김 컬럼: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

## 5. 액션 명세

| # | 트리거(컨트롤/이벤트) | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls > GetDayRange / GetDivision > SetChangedControl > GetShipmentPlanPlantSite | `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | drpPeriod, clbDivision_ID, clbFromSite |
| A2 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | SetChangedControl > GetShipmentPlanPlantSite | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | clbFromSite |
| A3 | cboChangeType 변경 | `CboChangeType_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod. "P" 분기 컬럼 폭과 헤더(§4) |
| A4 | 조회 (프레임워크 FindButton) | FindButton (오버라이드) | FindData_Main / FindData_Sub_Draft | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | spdMain(`Shipment Change Request`), spdSub(`Change Request`), usrLayoutControl3 정보 |
| A5 | 행추가 (프레임워크 InsertButton) | InsertButton > InsertRow | 신규 행 추가, From Site 콤보 소스 설정 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 신규 행 |
| A6 | btnNew 클릭 | `BtnNew_Click` | 신규 행 추가, DIVISION_ID 콤보(EE 제외) | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 신규 행 |
| A7 | btnInsertMultiple 클릭 | `btnInsertMultiple_Click` | 팝업(`Form_Load`, `btnButtonList_UsrButtonList_Click_Detected`) → InsertRowMultiple | `SSP.SSP0200_GET_ITEM_FROM_BOD`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 다건 행 |
| A8 | dsdm 데이터 변경 | `shtMain_Change` | GetItemFromBOD (row operation_group) | `SSP.SSP0200_GET_ITEM_FROM_BOD` | spdMain 행 값(**확인 필요**) |
| A9 | spdMain 셀 클릭 | `SpdMain_CellClick` | TRANSPORT_MODE 콤보 소스 로드, 헤더 CheckBox 전체 토글 | `biz:CommonData.CommonDataList` [TransMode] | 셀 콤보, 체크 값 |
| A10 | spdMain 콤보 선택 | `SpdMain_ComboSelChange` | FindData_BOD (ROUTE·BOD·INCOTERMS·국가·포트·LT 설정). DIVISION_ID 컬럼이면 Site 재조회 + END_CUSTOMER/PROJECT_* 표시 전환 | `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 행 값, 컬럼 표시 |
| A11 | 저장 (프레임워크 SaveButton) | SaveButton (오버라이드) | SSP_Main_Validation, chkERPIFBlockYn → 채번 → Confirm 저장 → ERP I/F 분기 → 재조회 | `SSP.SSP0200_GET_CHANGE_REQ_NO`, `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0200_GET_SHIPMENT_STATUS`, `SSP.SSP0200_GET_ERP_SO_NO_CNT`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE`, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` (+ A4 재조회) | spdMain, spdSub 재조회 |
| A12 | btnChangeRe2 "Request Complete" | `BtnChangeRe_Click` | SaveDataDrafting → 재조회 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` (+ A4) | spdMain, spdSub. 메일 발송(SP 내부) |
| A13 | btnSave "Save Draft" (Visible=false) | `BtnSave_Click` | SaveDataDrafting → 재조회 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` (+ A4) | spdMain, spdSub |
| A14 | btnCancel "Cancel" | `BtnCancel_Click` | DeleteDataDrafting (+ GetErpIFCheck) → 재조회 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` (+ A4) | spdMain, spdSub |
| A15 | btnApprovalUser 클릭 | `BtnApprovalUser_Click` | 승인자 선택 (엔드포인트 미추출) | — | txtApproval, txtAppDeptName (**확인 필요**) |
| A16 | btnItemId 클릭 | `btnItemId_Click` | Item 선택 팝업 추정 (내부 미추출) | — | txtRequest (**확인 필요**) |
| A17 | spdMain 상단 행 변경 | `SpdMain_TopChange` | 내부 미추출 | — | **확인 필요** |
| A18 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | 내부 미추출 | — | **확인 필요** |
| A19 | spdMain 편집 변경 | `SpdMain_EditChange` | 내부 미추출 | — | **확인 필요** |
| A20 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | 내부 미추출 | — | **확인 필요** |
| A21 | spdMain 커서 변경 | `SpdMain_CursorChanged` | 내부 미추출 (상·하단 연동 여부 확인 필요) | — | **확인 필요** |
| A22 | 팝업 Load | `Form_Load` (InsertPopup) | 팝업 초기화 | — | txtCurrentInsert_Qty |
| A23 | 팝업 버튼 | `btnButtonList_UsrButtonList_Click_Detected` | 확인/취소 처리 (내부 미추출) | — | 팝업 닫힘, 수량 반환(**확인 필요**) |
| A24 | btnDel "Delete" | 배선 없음 | — | — | **확인 필요** |

## 6. 검증·메시지
| # | 시점 | 검증 내용 | 메시지 |
|---:|---|---|---|
| V1 | SaveButton (SSP_Main_Validation), 일반 건 | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks | 확인 필요 |
| V2 | SaveButton (SSP_Main_Validation), SO 건 | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks | 확인 필요 |
| V3 | SaveButton (chkERPIFBlockYn) | BLOCK_YN, PERIOD | 확인 필요 |
| V4 | GetShipmentStatusChk | `SSP.SSP0200_GET_SHIPMENT_STATUS` 결과 Tables[0~2]의 CONFIRM_ID | 확인 필요 |
| V5 | GetErpSoNoCnt | `SSP.SSP0200_GET_ERP_SO_NO_CNT` 결과 CNT | 확인 필요 |
| V6 | 편집 계열 | `siMain.IsLock(SheetName)`이 true이면 행 추가와 헤더 체크를 막습니다 | 확인 필요 |

## 7. 권한 (C/R/U/D) 사실
- TB_FX_GroupMenuAuth 16행, TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행이 있습니다. 버튼별 C/R/U/D 값은 **확인 필요**입니다.
- 프레임워크 버튼 Find, Insert, Save가 오버라이드로 쓰입니다(R/C/U). EditButton도 오버라이드 대상으로 언급되지만 엔드포인트는 없습니다.
- Div 목록과 Site 목록은 사용자 그룹(NowGroupID)과 TB_FX_USERGROUPAUTHEXTENTION으로 필터링됩니다.
- 그리드 잠금(IsLock)에 따라 편집이 제한됩니다.

## 8. To-Be 전환 메모 (Wijmo·Oracle)
1. **레이아웃**: splitContainer1 상/하 분할(39.0% : 61.0%)을 Split 레이아웃으로 옮깁니다. usrConditionPanel1(HidePanel)은 접이식 조회조건으로 만듭니다. 하단 panel3은 버튼 영역과 변경요청 정보 폼을 함께 둡니다.
2. **그리드**:
   - spdMain은 FlexGrid로 만들고, 메타(SCM_MST_SHEET_COLUMNS) 기반 컬럼에 division/ChangeType 분기 표시(R1~R4)를 코드로 적용합니다.
   - spdSub는 FlexGrid 2단 헤더(columnGroups)로 만들고, Span 문구를 ChangeType에 따라 동적으로 바꿉니다("Plan"/"Confirm" ↔ "Confirmed"/"Change").
   - CHK 헤더 전체 선택은 FlexGrid 헤더 체크박스로 구현합니다.
   - 행 단위 DIVISION_ID 변경 시 컬럼 표시를 전환하는 동작(시트 전체 컬럼에 적용)은 AS-IS와 같게 유지해야 합니다.
3. **셀 콤보**: TRANSPORT_MODE(CommonDataList TransMode), FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, DIVISION_ID(EE 제외)는 DataMap으로 만듭니다.
4. **Oracle 변환**:
   - MSSQL 전용 요소를 Oracle 등가로 바꿔야 합니다: STRING_SPLIT 사용 SP(SSP0200_GET_SHIPMENT_STATUS, SSP0026_GET_BOD_ITEM, SSP0200_SAVE_SHIPMENT_CONFIRM_NEW, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE), #임시테이블(#T_SSP, #TMP_* 등), 동적 SQL(DYNAMIC@)
   - 메일 발송 체인 SP_SEND_DBMAIL의 대체 방식을 정해야 합니다.
5. **FoxQuery 미등록 SP 2개**(SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION): BE 매핑을 새로 정의해야 합니다.
6. **저장 트랜잭션**: AS-IS는 클라이언트가 여러 SP를 차례로 호출합니다(채번 → Confirm → ERP I/F 분기). TO-BE에서 BE 서비스 한 트랜잭션으로 묶을지는 **확인 필요**입니다(분기 조건 미추출).

## 9. 미확정
1. 미추출 라벨: Model(txtRequest), CheckSingleProcess, layoutControlItem2/13, lcAdd~lcSave, usrLayoutControl3 항목 전부, usrLabel1, usrLabel2
2. panel1의 Dock과 좌우 배치, usrLayoutControl2 폭 432의 의미, txtItemId 배치
3. 콤보 소스: cboStatus, cboChangeType, clbToSite, cboChangeReason, TO_SITE_DESCRIPTION
4. 내부 미추출 핸들러: SpdMain_TopChange, BtnApprovalUser_Click, SpdMain_CellDoubleClick, SpdMain_EditChange, SpdMain_ClipboardPasted, btnItemId_Click, SpdMain_CursorChanged, btnButtonList_UsrButtonList_Click_Detected
5. btnDel 배선 없음, btnAdd·dtDate Visible=false
6. grid_effective 판단불가 140건, Change Request 귀속 추정 컬럼
7. 컨트롤과 그리드 셀의 필수 여부, 편집 가능 여부

=== FILE: unit_test.md ===
# SSP0200 Shipment Change Request — 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 씁니다.
> 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> Fact Pack에 기대값 근거가 없는 항목은 기대결과에 **확인 필요**를 함께 적었습니다.
> 주석 처리된 호출은 테스트 대상에서 뺐습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0200-001 | 초기화 | SSP0200 권한이 있는 사용자 | 화면을 엽니다 | — | drpPeriod에 기간 초기값이 설정됩니다(기간 길이 확인 필요) | `Form_Load` > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SCM0001_GET_SCP_DAY_PERIOD |
| TC-SSP0200-002 | 초기화 | 같음 | 화면을 열고 clbDivision_ID 목록을 확인합니다 | — | 사용자 그룹 권한(TB_FX_USERGROUPAUTHEXTENTION) 범위의 Div 목록이 표시됩니다 | `Form_Load` > GetDivision, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, SSP0200_GET_SHIPMENT_DIVISION |
| TC-SSP0200-003 | 초기화 | 같음 | 화면을 열고 clbFromSite 목록을 확인합니다 | — | 선택된 Div의 From Site 목록이 표시됩니다 | `Form_Load` > SetChangedControl > GetShipmentPlanPlantSite, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0200-004 | 이벤트 | 화면이 열려 있음 | clbDivision_ID 값을 다른 Div로 바꿉니다 | Div=40 → 81 | clbFromSite 목록이 다시 조회됩니다 | `clbDivision_ID_SelectedIndexChanged`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0200-005 | 이벤트 | 화면이 열려 있음 | cboChangeType 값을 바꿉니다 | ChangeType="P" | drpPeriod 기간이 다시 계산됩니다(값 확인 필요) | `CboChangeType_SelectedIndexChanged` > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0200-006 | 그리드 | cboChangeType="P" | 조회 버튼을 누르고 spdMain 컬럼을 확인합니다 | ChangeType="P" | 시트 `Shipment Change Request`의 ERP_SO_NO, CONFIRM_ID가 Width=0입니다. 시트 `Change Request`의 ERP_SO_NO가 숨겨지고 2단 헤더가 "Plan"/"Confirm"입니다 | InitSpread:607/608/701, `Shipment Change Request`, `Change Request` |
| TC-SSP0200-007 | 그리드 | cboChangeType이 "P"가 아님 | 조회 후 컬럼을 확인합니다 | ChangeType≠"P" | `Shipment Change Request`의 ERP_SO_NO Width=100, CONFIRM_ID Width=120입니다. `Change Request`의 ERP_SO_NO가 표시되고 헤더가 "Confirmed"/"Change"입니다 | InitSpread:618/619/723, `Shipment Change Request`, `Change Request` |
| TC-SSP0200-008 | 조회 | 조회 대상 데이터가 있음 | 조건(clbDivision_ID, clbFromSite, drpPeriod, cboChangeType)을 입력하고 조회합니다 | Div=40, 기간=초기값 | 상단 spdMain에 결과가 표시됩니다 | FindButton > FindData_Main, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, SSP0200_GET_SHIPMENT_CHANGE_REQUEST, `Shipment Change Request` |
| TC-SSP0200-009 | 조회 | 같음 | 같은 조회에서 하단을 확인합니다 | 같음 | 하단 spdSub에 Draft가 표시됩니다. txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, cboChangeReason, txtReasonDetail 값이 채워집니다(SetChangeRequestInfo) | FindButton > FindData_Sub_Draft, `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING`, SSP0200_GET_SHIPMENT_REQUEST_DRAFTING, `Change Request` |
| TC-SSP0200-010 | 조회 | 조건에 맞는 데이터가 없음 | 존재하지 않는 txtSoNo로 조회합니다 | SO No=존재하지 않는 값 | spdMain, spdSub가 0행이고 오류가 없습니다. 메시지 문구는 확인 필요 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-011 | 조회 | 다건 조건 | txtSoNo와 txtConfirmId에 여러 줄을 붙여넣고 clbFromSite를 여러 개 선택한 뒤 조회합니다 | SO 2건, Site 2개 | 입력한 값 전부에 해당하는 결과가 나옵니다(GetCheckedListValue 다건 전달) | FindData_Main:1466~1473, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` |
| TC-SSP0200-012 | 그리드 | 조회 결과가 있음 | spdMain 컬럼 헤더를 확인합니다 | Div=81 | `Shipment Change Request`에 메타 헤더(Div, Confirm/Plan ID, SO No, Status, Model*, … Trans Mode*)가 표시되고 표시 컬럼은 32개입니다(판단불가 ?4 별도 확인) | SetSheetHeaderColumn@InitSpread:598, `Shipment Change Request` |
| TC-SSP0200-013 | 그리드 | 조회 결과가 있음 | spdSub 헤더를 확인합니다 | Div=81 | `Change Request`가 2단 헤더(기존 6열/변경 6열 Span)로 표시되고, CHK가 CheckBox(기본 false), REMARKS가 Width=0입니다. 표시 컬럼은 26개입니다(?5) | SetSheetHeaderColumn@InitSpread:659, InitSpread:672~696, `Change Request` |
| TC-SSP0200-014 | division | Div=40 선택 | 조회 후 spdMain을 확인합니다 | Div=40 | END_CUSTOMER, ERP_ATTR1(Consignee Name), ERP_ATTR2(Contact Point), ERP_ATTR3(Lot)이 표시되고 PROJECT_CODE, PROJECT_NAME이 숨겨집니다. 34열입니다 | InitSpread:630~637, `Shipment Change Request` |
| TC-SSP0200-015 | division | Div=EE 선택 | 조회 후 spdMain을 확인합니다 | Div=EE | TC-014와 같습니다(34열) | InitSpread:630~637, `Shipment Change Request` |
| TC-SSP0200-016 | division | Div=81 계열/82/EE_* 선택 | 조회 후 spdMain을 확인합니다 | Div=82 | END_CUSTOMER, ERP_ATTR1~3이 숨겨지고 PROJECT_CODE, PROJECT_NAME이 표시됩니다. 32열입니다 | InitSpread:641~648, `Shipment Change Request` |
| TC-SSP0200-017 | division | Div=40 / 그 외 | 조회 후 spdSub 표시 컬럼 수를 비교합니다 | Div=40, 81 | 40은 25열, 81은 26열입니다. 귀속 추정 컬럼은 확인 필요 | grid_effective, `Change Request` |
| TC-SSP0200-018 | 이벤트 | 그리드가 잠기지 않음 | 프레임워크 행추가(InsertButton)를 누릅니다 | — | spdMain에 신규 행이 추가되고 FROM_SITE_DESCRIPTION 콤보 목록이 설정됩니다 | InsertButton > InsertRow, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` |
| TC-SSP0200-019 | 이벤트 | 그리드가 잠기지 않음 | btnNew를 클릭합니다 | — | 신규 행이 추가됩니다. DIVISION_ID 콤보에 "EE"가 없습니다 | `BtnNew_Click`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` |
| TC-SSP0200-020 | 이벤트 | 그리드가 잠기지 않음 | btnInsertMultiple을 클릭하고 팝업의 txtCurrentInsert_Qty에 3을 입력한 뒤 btnButtonList 확인을 누릅니다 | 수량=3 | spdMain에 3행이 추가되고 Item/From Site가 설정됩니다(값 확인 필요) | `btnInsertMultiple_Click` > InsertRowMultiple, `SSP.SSP0200_GET_ITEM_FROM_BOD`, SSP0200_GET_ITEM_FROM_BOD, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` |
| TC-SSP0200-021 | 이벤트 | btnInsertMultiple 클릭 | 팝업이 열릴 때 초기 상태를 확인합니다 | — | usrLabel1, txtCurrentInsert_Qty, btnButtonList가 표시됩니다. 초기값은 확인 필요 | `Form_Load` (InsertPopup .ctor:49) |
| TC-SSP0200-022 | 이벤트 | 팝업이 열려 있음 | btnButtonList 취소 버튼을 누릅니다 | — | 팝업이 닫히고 행이 추가되지 않습니다(동작 확인 필요) | `btnButtonList_UsrButtonList_Click_Detected` |
| TC-SSP0200-023 | 이벤트 | spdMain에 행이 있음 | 행의 Item 관련 셀을 바꿉니다 | ITEM_ID 변경 | Item/BOD 기반 값이 보정됩니다(대상 컬럼 확인 필요) | `shtMain_Change`(dsdm.Changed) > GetItemFromBOD, `SSP.SSP0200_GET_ITEM_FROM_BOD` |
| TC-SSP0200-024 | 이벤트 | spdMain에 행이 있음 | TRANSPORT_MODE 셀을 클릭합니다 | — | Trans Mode 콤보 목록이 표시됩니다 | `SpdMain_CellClick`, `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0200-025 | 그리드 | 잠기지 않았고 1행 이상 있음 | 체크박스 컬럼 헤더를 클릭합니다(2회) | — | 1회 클릭에 전체 체크, 2회 클릭에 전체 해제됩니다 | `SpdMain_CellClick`:5505~5544 |
| TC-SSP0200-026 | 이벤트 | spdMain에 행이 있음 | 콤보 셀(BOD/Route 관련)을 선택합니다 | 콤보 값 선택 | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL이 설정됩니다 | `SpdMain_ComboSelChange` > FindData_BOD, `SSP.SSP0026_GET_BOD_ITEM`, SSP0026_GET_BOD_ITEM, `biz:CommonData.CommonDataList` |
| TC-SSP0200-027 | division | spdMain에 행이 있음 | 행의 DIVISION_ID 콤보를 40으로 바꿉니다 | DIVISION_ID=40 | END_CUSTOMER가 표시되고 PROJECT_CODE, PROJECT_NAME이 숨겨집니다. From Site 콤보가 다시 조회됩니다 | `SpdMain_ComboSelChange`:5668~5670, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`, `Shipment Change Request` |
| TC-SSP0200-028 | division | 같음 | 행의 DIVISION_ID 콤보를 81로 바꿉니다 | DIVISION_ID=81 | END_CUSTOMER가 숨겨지고 PROJECT_CODE, PROJECT_NAME이 표시됩니다 | `SpdMain_ComboSelChange`:5677~5679, `Shipment Change Request` |
| TC-SSP0200-029 | 저장 | 편집한 행이 있음 | 프레임워크 저장을 누릅니다 | 정상 값 | 변경요청번호가 채번됩니다 | SaveButton:862, `SSP.SSP0200_GET_CHANGE_REQ_NO`, SSP0200_GET_CHANGE_REQ_NO |
| TC-SSP0200-030 | 저장 | 같음 | 저장 후 DB를 확인합니다 | 정상 값 | SSP_ANL_SHIP_CONFIRM에 신규 행이 생기고 DM_PLN_MKT_FCST가 MERGE됩니다 | SaveButton:1056, `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, SSP0200_SAVE_SHIPMENT_CONFIRM_NEW |
| TC-SSP0200-031 | 저장 | 같음 | 저장 직후 상단 갱신을 확인합니다 | — | 상단이 다시 조회됩니다 | SaveButton > FindData_Main_Nonasync, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N`, SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N |
| TC-SSP0200-032 | 저장 | ERP I/F 대상 건 | 저장 후 오류 확정 테이블을 확인합니다 | ERP 오류 건 | SSP_ANL_SHIP_ERP_ERROR_CONFIRM에 INSERT되고 _CHG_REQ, _CHG_REQ_DE가 UPDATE됩니다(진입 조건 확인 필요) | GetERPInterface:3950, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0200-033 | 저장 | ERP I/F 대상 건 | 저장 중 Draft 삭제 경로를 확인합니다 | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE와 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT가 일어납니다(조건 확인 필요) | GetERPInterface:3989, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0200-034 | 저장 | ERP I/F 대상 건 | 저장 시 출하 상태 확인을 봅니다 | CONFIRM_ID 다건 | 결과 Tables[0~2]의 CONFIRM_ID로 상태를 판정합니다(메시지 확인 필요) | GetShipmentStatusChk:4096, `SSP.SSP0200_GET_SHIPMENT_STATUS`, SSP0200_GET_SHIPMENT_STATUS |
| TC-SSP0200-035 | 저장 | ERP I/F 대상 건 | 저장 시 SO 건수 확인을 봅니다 | — | CNT 결과에 따라 분기합니다(조건 확인 필요) | GetErpSoNoCnt:4161, `SSP.SSP0200_GET_ERP_SO_NO_CNT`, SSP0200_GET_ERP_SO_NO_CNT |
| TC-SSP0200-036 | 저장 | SO가 있는 건 | 저장합니다 | ERP_SO_NO 있음 | SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE와 _CHG_REQ_DE INSERT가 일어납니다 | SoNo:4771, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`, SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0200-037 | 저장 | SO가 없는 건 | 저장합니다 | ERP_SO_NO 없음 | TC-036과 같은 테이블에 반영됩니다(NonSoNo 경로) | NonSoNo:4491, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-038 | 저장 | 신규 경로 건 | 저장합니다 | 신규 행 | GetNewERPInterface > NewNonSoNo 경로로 저장됩니다(진입 조건 확인 필요) | NewNonSoNo:4297, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-039 | 저장 | SO가 있는 건 | 저장 후 I/F 테이블을 확인합니다 | ERP_SO_NO 있음 | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN에 INSERT되고 SSP_ANL_SHIP_CONFIRM이 갱신됩니다 | GetErpIFCheckNew:5009, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0200-040 | 저장 | SO가 있는 건 | 저장 후 IFSEQ를 확인합니다 | — | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN이 UPDATE됩니다(IFSEQ 병합) | GetErpIFSeqMerge:5067, `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE`, PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE |
| TC-SSP0200-041 | 저장 | 편집한 행이 있음 | Shipment Qty를 비운 채 저장합니다 | SHIPMENT_CONFIRM_QTY=빈값 | 검증 메시지가 나오고 저장이 중단됩니다(문구 확인 필요) | SaveButton > SSP_Main_Validation (shipment_confirm_qty) |
| TC-SSP0200-042 | 저장 | SO가 없는 일반 건 | INCOTERMS를 비운 채 저장합니다 | INCOTERMS=빈값 | 일반 건이면 검증에 걸립니다. SO 건이면 INCOTERMS를 검증하지 않습니다(확인 필요) | SSP_Main_Validation (Validationdr / SONoValidationdr) |
| TC-SSP0200-043 | 저장 | ERP Block 상태(BLOCK_YN) | 저장합니다 | BLOCK_YN=Y(가정 데이터) | 저장이 차단되거나 안내 메시지가 나옵니다(판정식 확인 필요) | SaveButton > chkERPIFBlockYn |
| TC-SSP0200-044 | 저장 | 저장 중 SP 오류 | DB 오류를 유도한 뒤 저장합니다 | 무효 CONFIRM_ID | 오류 메시지가 나오고 재조회되지 않습니다. 롤백 범위는 확인 필요 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-045 | 저장 | 하단 Draft가 있음 | spdSub CHK를 선택하고 btnChangeRe2를 클릭합니다 | CHK=true 1건 | 완료 처리(SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE)와 메일 발송 체인이 실행되고 재조회됩니다 | `BtnChangeRe_Click` > SaveDataDrafting, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE`, SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE, `Change Request` |
| TC-SSP0200-046 | 저장 | btnSave가 표시된 상태(기본 Visible=false) | btnSave를 클릭합니다 | CHK=true 1건 | SaveDataDrafting이 실행되고 재조회됩니다. Request Complete와의 차이는 확인 필요 | `BtnSave_Click`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0200-047 | 저장 | 하단 Draft가 있음 | spdSub CHK를 선택하고 btnCancel을 클릭합니다 | CHK=true 1건 | Draft가 삭제되거나 상태가 바뀌고, ERP I/F 체크(GetErpIFCheck) 후 재조회됩니다 | `BtnCancel_Click` > DeleteDataDrafting / GetErpIFCheck, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, `Change Request` |
| TC-SSP0200-048 | 저장 | 하단에 선택된 행이 없음 | btnCancel을 클릭합니다 | CHK 없음 | 처리되지 않거나 안내 메시지가 나옵니다(확인 필요) | `BtnCancel_Click`, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0200-049 | 이벤트 | 변경요청 정보 영역 | btnApprovalUser를 클릭합니다 | — | 승인자 선택 동작이 실행되고 txtApproval, txtAppDeptName에 반영됩니다(확인 필요) | `BtnApprovalUser_Click` |
| TC-SSP0200-050 | 이벤트 | 조회조건 영역 | btnItemId를 클릭합니다 | — | Item 선택 동작이 실행되고 txtRequest에 반영됩니다(확인 필요) | `btnItemId_Click` |
| TC-SSP0200-051 | 이벤트 | spdMain에 여러 행이 있음 | spdMain을 세로로 스크롤합니다 | — | TopChange 처리가 실행됩니다(내부 동작 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0200-052 | 이벤트 | spdMain에 행이 있음 | 셀을 더블클릭합니다 | — | 내부 동작 확인 필요 | `SpdMain_CellDoubleClick` |
| TC-SSP0200-053 | 이벤트 | spdMain에 행이 있음 | 편집 셀에 값을 입력합니다 | 임의 값 | EditChange 처리가 실행됩니다(확인 필요) | `SpdMain_EditChange` |
| TC-SSP0200-054 | 이벤트 | spdMain에 행이 있음 | 여러 셀을 Ctrl+V로 붙여넣습니다 | 2행×2열 | 붙여넣기 후처리가 실행됩니다(확인 필요) | `SpdMain_ClipboardPasted` |
| TC-SSP0200-055 | 이벤트 | spdMain에 2행 이상 있음 | 다른 행으로 커서를 옮깁니다 | — | CursorChanged 처리가 실행됩니다. 하단 연동 여부는 확인 필요 | `SpdMain_CursorChanged` |
| TC-SSP0200-056 | 권한 | 그리드가 잠긴 상태(IsLock=true) | btnNew 클릭, 헤더 체크 클릭 | — | 행이 추가되지 않고 헤더 전체 체크가 동작하지 않습니다 | `BtnNew_Click`, `SpdMain_CellClick`(IsLock 조건) |
| TC-SSP0200-057 | 권한 | 사용자 그룹이 다른 계정 2개 | 각 계정으로 화면을 열고 clbDivision_ID, clbFromSite를 비교합니다 | 그룹 A / B | 그룹 권한(TB_FX_USERGROUPAUTHEXTENTION)에 따라 목록이 다릅니다 | `SSP.SSP0200_GET_SHIPMENT_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0200-058 | 권한 | 권한 메타 | 메뉴 권한별로 조회·저장 버튼 활성을 확인합니다 | C/R/U/D 조합 | TB_FX_GroupMenuAuth 값대로 동작합니다(값 확인 필요) | FindButton, SaveButton, TB_FX_GroupMenuAuth |
| TC-SSP0200-059 | 초기화 | FoxQuery 미등록 SP | 화면을 열 때 Site 조회 오류가 나는지 확인합니다 | — | 오류 없이 목록이 로드됩니다. 오류가 나면 직접 호출 경로를 확인합니다 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` (NOT_IN_FOXQUERY) |
| TC-SSP0200-060 | 그리드 | 조회 후 SetChangeRequestSOGrid | sSearchType="Exist"이고 Ship Status가 "R"이 아닌 데이터로 조회합니다 | — | 시트 `Change Request`의 CHK가 숨겨집니다 | SetChangeRequestSOGrid:2294, `Change Request` |

### 커버리지 점검
- **이벤트 핸들러 19개**: btnInsertMultiple_Click(020), Form_Load(001·021), clbDivision_ID_SelectedIndexChanged(004), SpdMain_TopChange(051), BtnApprovalUser_Click(049), shtMain_Change(023), BtnSave_Click(046), BtnChangeRe_Click(045), BtnCancel_Click(047), BtnNew_Click(019), SpdMain_CellClick(024), SpdMain_CellDoubleClick(052), SpdMain_EditChange(053), SpdMain_ClipboardPasted(054), SpdMain_ComboSelChange(026), btnItemId_Click(050), CboChangeType_SelectedIndexChanged(005), SpdMain_CursorChanged(055), btnButtonList_UsrButtonList_Click_Detected(022)
- **엔드포인트 20개**: 001~003, 008~009, 018, 020, 024, 026, 029~040, 045, 047 등. 위 근거 열에 모두 원문으로 나옵니다.
- **시트 2개**: `Shipment Change Request`(006·012·014~016), `Change Request`(006·013·017·060)
- **division**: 40(014), EE(015), 그 외(016), 행 단위(027·028)
- **빈 결과·오류**: 010, 044, 048, 059
