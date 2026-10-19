# 룰 보완 후보 — 2026-10-19 (gap 122화면, 3화면 이상 반복만)

아래는 GAP 에서 MISSING/UNMAPPED 로 반복되는 As-is 요소다. 각 행은 "표준 매핑을 정하면 map_* 에, 의도된 차이면 allowed_gaps 에" 한 줄로 끝난다. 결정 후 `_candidates.csv` 의 해당 행을 대상 CSV 로 옮기면 생성기·검사기가 함께 바뀐다.

## 1. 컨트롤 타입 (map_control.csv 보강 또는 allowed_gaps control_type)

| As-is 타입 | 화면 수 | 건수 | 예 |
|---|---:|---:|---|

## 2. 컨트롤 이름 패턴 (map_field.csv 카탈로그 배정 또는 map_button.csv)

| 이름(숫자 제거) | 타입 | 화면 수 | 예 |
|---|---|---:|---|
| usrButton | UsrButton | 28 | DMF0020 DMF0022 SCP0009 SCP0010 SCP0011 |
| txtRequestor | TextBox/UsrTextBox/UsrMultiLineEditor | 7 | SSP0003 SSP0015 SSP0022 SSP0026 SSP0200 |
| clbLine | UsrCheckedList/UsrCheckedList2 | 6 | SCP0002 SCP0020 SCP0024 SCP0049 SCP0108 |
| cboCellQty | UsrCheckBox | 5 | DMF0003 DMF0021 DMF0022 DMF0035 DMF0048 |
| clbOperation | UsrCheckedList/UsrCheckedList2 | 5 | SCP0002 SCP0049 SCP0080 SCP0108 SCP0121 |
| btnW | UsrButton | 5 | SCP0009 SCP0010 SCP0013 SCP0024 SCP0025 |
| btnItem_Id | UsrButton | 5 | SCP0009 SCP0010 SCP0018 SCP0025 SSP0045 |
| txtItem_Id | UsrMultiLineEditor | 5 | SCP0009 SCP0025 SCP0085 SCP0101 SSP0045 |
| cboPlanType | UsrCombo | 5 | SCP0009 SCP0011 SCP0013 SCP0095 SCP0111 |
| txtSearch | UsrTextBox | 5 | SYS0003 SYS0007 SYS0014 SYS0015 SYS0016 |
| txtVersion | UsrMultiLineEditor | 4 | DMF0022 DMF0035 DMF0053 DMF0068 |
| cboQTY | UsrCombo | 4 | DMF0022 DMF0035 DMF0040 DMF0053 |
| btnButtonList | UsrButtonList | 4 | SCM0002 SCP0104 SYS0013 SYS0017 |
| cboStatus | UsrComboBox/UsrCombo | 4 | SCP0006 SSP0200 SSP0201 SSP0202 |
| clbElecType | UsrCheckedList | 4 | SCP0009 SCP0010 SCP0018 SCP0025 |
| btnWLast | UsrButton | 4 | SCP0010 SCP0013 SCP0024 SCP0025 |
| cboStage | UsrComboBox | 4 | SCP0127 SCP0128 SCP0129 SCP0133 |
| cboChangeType | UsrCombo | 4 | SSP0003 SSP0200 SSP0201 SSP0202 |
| txtTitle | TextBox | 4 | SSP0003 SSP0200 SSP0201 SSP0202 |
| txtRequestDeptName | TextBox | 4 | SSP0003 SSP0200 SSP0201 SSP0202 |
| txtApproval | TextBox | 4 | SSP0003 SSP0200 SSP0201 SSP0202 |
| txtReasonDetail | TextBox | 4 | SSP0003 SSP0200 SSP0201 SSP0202 |
| btnRequestor | UsrButton | 4 | SSP0015 SSP0022 SSP0026 SSP0060 |
| clbDivision_ID | UsrCombo | 4 | SSP0022 SSP0060 SSP0200 SSP0201 |
| cboQty | UsrCheckBox | 3 | DMF0003 DMF0042 DMF0082 |
| chkDetail | UsrCheckBox | 3 | DMF0004 DMF0005 SCP0101 |
| clbDivisions | UsrCombo | 3 | DMF0006 DMF0007 DMF0020 |
| clbScmSite | UsrCheckedList | 3 | DMF0013 DMF0014 DMF0074 |
| btmItem | UsrButton | 3 | DMF0013 DMF0014 DMF0074 |
| InternalYN | UsrCheckBox | 3 | DMF0021 DMF0022 DMF0048 |
| btnVersion | UsrButton | 3 | DMF0022 DMF0035 DMF0053 |
| btnSPVer | UsrButton | 3 | DMF0044 DMF0049 DMF0068 |
| clbBuilding | UsrCheckedList/UsrCheckedList2 | 3 | SCP0002 SCP0049 SCP0121 |
| clbTransMode | UsrCheckedList | 3 | SCP0005 SCP0028 SCP0030 |
| btnUnfix | UsrButton | 3 | SCP0009 SCP0010 SCP0013 |
| btnFix | UsrButton | 3 | SCP0009 SCP0010 SCP0013 |
| cboPlanSeq | UsrCombo | 3 | SCP0009 SCP0011 SCP0013 |
| cboElectrode | UsrCheckedList | 3 | SCP0011 SCP0013 SCP0024 |
| formDown | UsrButton | 3 | SCP0049 SSP0022 SSP0026 |
| btnReject | SimpleButton | 3 | SSP0003 SSP0202 SYS0012 |
| btnApproval | SimpleButton | 3 | SSP0003 SSP0202 SYS0012 |
| txtRequest | UsrMultiLineEditor | 3 | SSP0003 SSP0200 SSP0201 |
| txtRequestNo | TextBox | 3 | SSP0003 SSP0200 SSP0201 |
| txtAppDeptName | TextBox | 3 | SSP0003 SSP0200 SSP0202 |
| txtLotID | UsrMultiLineEditor | 3 | SSP0015 SSP0022 SSP0026 |

## 3. 이벤트 (map_event.csv 또는 allowed_gaps event)

| 타깃.이벤트 | 화면 수 | 예 |
|---|---:|---|
| layoutControlItem.Click | 3 | DMF0021 DMF0042 DMF0048 |

## 4. SP 계열 (allowed_gaps endpoint — 공통 SP 는 콤보/메타/권한으로 대체되는 것이 보통)

| SP 패턴 | 화면 수 | 예 SP |
|---|---:|---|
| [statement] | 6 | [statement] |
| SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 6 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| *_GET_SHEET_CALENDAR_3SPAN | 5 | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 5 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| PR_GET_DAY_RANGE | 4 | PR_GET_DAY_RANGE |
| *_GET_QTY_TYPE_CODE | 4 | DMF0003_GET_QTY_TYPE_CODE |
| *_GET_SCP_DAILY_PLAN_PERIOD | 4 | SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 4 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| *_GET_SALES_SITE_CUSTOMER_DATA | 3 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| *_GET_LAST_PLAN_VERSION | 3 | SCP0011_GET_LAST_PLAN_VERSION |
| *_GET_SHEET_CALENDAR_3SPAN_ISO | 3 | SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| *_GET_LOOKUP_MASTER_DETAIL | 3 | SCM0003_GET_LOOKUP_MASTER_DETAIL SCP0120_GET_LOOKUP_MASTER_DETAIL |
| *_GET_SSP_PLAN_PROCESSING_CHECK | 3 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| *_GET_ERP_SO_NO_CNT | 3 | SSP0021_GET_ERP_SO_NO_CNT SSP0060_GET_ERP_SO_NO_CNT SSP0201_GET_ERP_SO_NO_CNT |
| *_GET_SHIPMENT_STATUS | 3 | SSP0021_GET_SHIPMENT_STATUS SSP0060_GET_SHIPMENT_STATUS SSP0201_GET_SHIPMENT_STATUS |
| UP_FX_GetGroupInfoList | 3 | UP_FX_GetGroupInfoList |

## 5. 공통 SP 단건 (여러 화면이 같은 SP 를 호출 — 공통 콤보/권한 후보)

| SP | 화면 수 |
|---|---:|
| [statement] | 6 |
| SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 6 |
| SCP0009_GET_SHEET_CALENDAR_3SPAN | 5 |
| SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 5 |
| PR_GET_DAY_RANGE | 4 |
| DMF0003_GET_QTY_TYPE_CODE | 4 |
| SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 4 |
| PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 4 |
| SCP0011_GET_LAST_PLAN_VERSION | 3 |
| SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | 3 |
| SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 3 |
| UP_FX_GetGroupInfoList | 3 |
