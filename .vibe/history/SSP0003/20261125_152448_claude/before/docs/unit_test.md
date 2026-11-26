# SSP0003 Shipment Change Request Confirm — 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 Fact Pack에서 확정되지 않은 부분은 '확인 필요'로 표시했습니다. 테스트 실행 전에 AS-IS 원문 동작으로 확정해야 합니다.
> 주석 처리된 호출은 테스트 대상에서 제외했습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0003-001 | 초기화 | 권한이 있는 사용자로 로그인. NowGroupID에 Division 권한(TB_FX_USERGROUPAUTHEXTENTION)이 있음 | 화면을 엽니다 | — | clbDivision에 사용자 그룹 권한 범위의 Division 목록이 표시됩니다 | `Form_Load`, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, SP `SSP0200_GET_SHIPMENT_DIVISION` |
| TC-SSP0003-002 | 초기화 | TC-001과 같음 | 화면을 연 뒤 clbFromSite 목록을 확인합니다 | — | clbFromSite가 Site 목록으로 채워집니다. 두 SP 중 어느 것이 실행되는지는 조건 확인 필요 | `Form_Load`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, SP `SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-003 | 초기화 | TC-001과 같음. 위 SP가 선택되지 않는 조건(확인 필요) | 화면을 연 뒤 clbFromSite 목록을 확인합니다 | — | clbFromSite가 Shipment Plan Plant Site 목록으로 채워집니다 | `Form_Load`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`, SP `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0003-004 | 초기화 | SCM_SYS_CALENDAR_M에 당일 데이터가 있음 | 화면을 열고 drpPeriod 값을 확인합니다 | — | GetDayRange 결과로 기간 기본값이 설정됩니다(drpPeriod 바인딩과 값의 규칙은 확인 필요). 오류가 없어야 합니다 | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0003-005 | 초기화 | — | 화면을 열고 spdMain, txtApprovalDeptName의 헤더를 확인합니다 | — | spdMain은 시트 `Shipment Change Request Confirm`, 헤더 1행입니다. txtApprovalDeptName은 시트 `Shipment Change Request Confirm Detail`, 헤더 2행입니다. 두 그리드 모두 데이터 0행입니다 | `Form_Load` (InitSpread:431, 439), `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-006 | 이벤트 | 화면 로드 완료 | clbDivision에서 Division 하나를 체크합니다 | Division 1건 | clbFromSite가 선택한 Division 기준 Site 목록으로 다시 구성됩니다 | `ClbDivision_SelectedIndexChanged`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-007 | 이벤트 | 화면 로드 완료. Shipment Plan Site 분기 조건 충족(확인 필요) | clbDivision에서 선택을 바꿉니다 | Division 변경 | clbFromSite가 다시 구성됩니다 | `ClbDivision_SelectedIndexChanged`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0003-008 | 이벤트(빈 결과) | 선택한 Division에 해당 사용자 권한 Site가 없음 | clbDivision에서 해당 Division만 체크합니다 | Site 없는 Division | 오류 없이 clbFromSite가 빈 목록이 됩니다 | `ClbDivision_SelectedIndexChanged`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-009 | 조회 | 변경 요청 데이터(SSP_ANL_SHIP_CONFIRM_CHG_REQ)가 있음 | clbDivision, clbFromSite, drpPeriod, cboStatus, cboChangeType을 지정하고 조회(FindButton)를 누릅니다 | 데이터가 있는 조건 | spdMain에 결과 행이 표시됩니다. 표시 컬럼은 19개입니다 | FindButton > FindData_Main, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, SP `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `Shipment Change Request Confirm` |
| TC-SSP0003-010 | 조회(빈 결과) | 조건에 맞는 데이터가 없음 | drpPeriod를 데이터가 없는 기간으로 지정하고 조회합니다 | 데이터 없는 기간 | 오류 없이 spdMain이 0행이 됩니다. 안내 메시지 여부는 확인 필요 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-011 | 조회(오류) | SP 실행 오류가 발생하도록 환경을 구성(예: 권한 제거) | 조회합니다 | — | 오류 메시지가 표시되고 spdMain 기존 데이터의 처리는 확인 필요. 화면이 비정상 종료되지 않아야 합니다 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-012 | 조회 | 조회조건 txtRequest, txtItemID에 값 입력 | txtRequest에 요청자, txtItemID에 모델을 입력하고 조회합니다 | 요청자·모델 값 | 입력값이 조회 파라미터로 반영되어 결과가 필터됩니다(파라미터 매핑 확인 필요) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-013 | 그리드 | TC-009 결과 있음 | spdMain 컬럼을 확인합니다 | — | 표시 19개: Request No, Title, Change Type, Status, Division, From Site, To Site, Model, Nick Name, Change Reason, Reject Reason, Requestor, Requestor Dept Name, Request Date, Approval, Approval Dept Name, Approval Date, Delegatee, Delegatee Dept Name. 숨김: REQUEST_USER, APPROVAL_USER, DELEGATEE_USER | `Shipment Change Request Confirm` (SCM_MST_SHEET_COLUMNS) |
| TC-SSP0003-014 | 그리드 | 상세 조회 완료 | txtApprovalDeptName 컬럼을 확인합니다 | — | 표시 29개(CHK~REJECT_REASON), 숨김 25개(A_COUNTRY 등)가 화면설계서 §4-2와 같습니다 | `Shipment Change Request Confirm Detail` (SCM_MST_SHEET_COLUMNS) |
| TC-SSP0003-015 | 그리드 | 상세 조회 완료 | txtApprovalDeptName의 CHK 컬럼을 확인합니다 | — | CHK는 체크박스이고 헤더는 "ALL"입니다. 기본값은 true(체크)입니다 | `Shipment Change Request Confirm Detail` (InitSpread:447~449) |
| TC-SSP0003-016 | 그리드 | `_sChangeType == "P"`인 요청 | spdMain에서 해당 요청 행을 더블클릭합니다 | Change Type P 요청 | ERP_SO_NO가 숨겨집니다. 0행 그룹 헤더는 LT_DAY부터 6열이 "Plan", NEW_LT_DAY부터 6열이 "Confirm"입니다 | `Shipment Change Request Confirm Detail` (InitSpread:475), `SpdMain_CellDoubleClick` |
| TC-SSP0003-017 | 그리드 | `_sChangeType != "P"`인 요청 | spdMain에서 해당 요청 행을 더블클릭합니다 | Change Type P 외 요청 | ERP_SO_NO가 표시됩니다. 0행 그룹 헤더는 "Confirmed"와 "Change"입니다 | `Shipment Change Request Confirm Detail` (InitSpread:503), `SpdMain_CellDoubleClick` |
| TC-SSP0003-018 | 이벤트 | TC-009 결과 있음 | spdMain 행을 더블클릭합니다 | 요청 1건 | txtApprovalDeptName에 상세 행이 표시됩니다. txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtChangeReason, txtReasonDetail에 요청 정보가 채워집니다(컬럼↔TextBox 대응 확인 필요) | `SpdMain_CellDoubleClick`, `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, SP `SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| TC-SSP0003-019 | 이벤트 | 위임자(SSP_MST_DELEGATE)가 등록된 승인자의 요청 | spdMain 행을 더블클릭합니다 | 위임 등록 요청 | 위임자 정보를 조회합니다. 화면 반영 위치는 확인 필요 | `SpdMain_CellDoubleClick`, `SSP.SSP0003_GET_DELEGATEE_LOAD`, SP `SSP0003_GET_DELEGATEE_LOAD` |
| TC-SSP0003-020 | 이벤트(빈 결과) | 상세(SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE)가 없는 요청 | spdMain 행을 더블클릭합니다 | 상세 없는 요청 | 오류 없이 txtApprovalDeptName이 0행이 됩니다. 패널 처리는 확인 필요 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| TC-SSP0003-021 | 그리드 | `p_status`가 E·O·R·S·D·A·P 어느 것도 아닌 요청 | spdMain 행을 더블클릭합니다 | 해당 상태 요청 | txtApprovalDeptName의 0번 컬럼이 숨겨집니다. 다른 상태의 처리는 확인 필요 | `SpdMain_CellDoubleClick` (FindData_Sub:827), `Shipment Change Request Confirm Detail` |
| TC-SSP0003-022 | 이벤트 | spdMain에 화면 높이를 넘는 행이 있음 | spdMain을 세로로 스크롤합니다 | — | 오류 없이 스크롤됩니다. 추가 동작은 AS-IS 원문 확인 후 확정 | `SpdMain_TopChange` |
| TC-SSP0003-023 | 저장 | 상세 조회 완료. 선적 상태 검사 대상 CONFIRM_ID가 있음 | txtApprovalDeptName에서 CHK를 체크하고 btnApproval을 누릅니다 | 승인 대상 행 | 선적 상태 검사를 실행합니다. 결과 Tables[2] CONFIRM_ID에 따라 진행하거나 중단합니다(판정 기준·메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0200_GET_SHIPMENT_STATUS`, SP `SSP0200_GET_SHIPMENT_STATUS` |
| TC-SSP0003-024 | 저장 | 해당 Division 계획이 처리 중(SCM_MST_PLAN·SCM_MST_PLAN_DETAIL) | btnApproval을 누릅니다 | 계획 처리 중 상태 | 계획 처리 검사 결과에 따라 승인이 진행되거나 중단됩니다(메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, SP `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| TC-SSP0003-025 | 저장 | 검사 통과 조건 | btnApproval을 누릅니다 | 승인 대상 행 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE가 UPDATE되고 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN과 SCM_SYS_LOG_BATCH에 INSERT됩니다 | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` |
| TC-SSP0003-026 | 저장 / division | Division 40 요청(분기 조건 확인 필요) | btnApproval을 누릅니다 | Division 40 | `_40` SP가 실행됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ UPDATE, SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, SSP_ANL_SHIP_PLAN_40 DELETE/INSERT, DM_PLN_MKT_FCST_CONFIRM INSERT, SSP_ANL_SHIP_CONFIRM_H INSERT가 일어납니다 | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0003-027 | 저장 / division | Division 40 외 요청(예: 81, 82, EE) | btnApproval을 누릅니다 | Division 81 | 일반 SP가 실행됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ UPDATE, SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, XIF_SCS_PACK_SHIP_PLAN_S_SN·XIF_FP_SSP_SALES_EXFACTORY_S_SN·SSP_ANL_SHIP_CONFIRM_H INSERT가 일어납니다 | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0003-028 | 저장 | 승인 저장 완료 | btnApproval 처리 후 ERP IF 검사 결과를 확인합니다 | — | `result_code`를 반환받아 분기합니다(값별 동작 확인 필요). XIF_ERP_SHIP_PLAN_CONFIRM_S_SN이 INSERT/UPDATE됩니다 | `BtnApproval_Click` > GetErpIFCheck, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| TC-SSP0003-029 | 저장 | 신규 ERP IF 경로 조건(확인 필요) | btnApproval을 누릅니다 | — | GetErpIFCheckNew에서 IF 검사를 실행합니다(줄 1409, 1492). `result_code`로 분기합니다(줄 1426) | `BtnApproval_Click` > GetErpIFCheckNew, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| TC-SSP0003-030 | 저장 | 신규 ERP IF 경로에서 Drafting 삭제 조건(확인 필요) | btnApproval을 누릅니다 | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE UPDATE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT가 일어납니다 | `BtnApproval_Click`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SP `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0003-031 | 저장(오류 응답) | ERP IF 검사가 오류 `result_code`를 반환하는 조건(확인 필요) | btnApproval을 누릅니다 | — | ERP 오류 확정이 실행됩니다. SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, SSP_ANL_SHIP_CONFIRM_CHG_REQ·SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE UPDATE가 일어납니다. 사용자 메시지는 확인 필요 | `BtnApproval_Click`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, SP `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| TC-SSP0003-032 | 저장 | 승인 성공 | btnApproval 처리 완료 후 spdMain을 확인합니다 | — | 목록이 다시 조회되어 처리한 요청의 Status, Approval, Approval Date가 갱신되어 보입니다 | `BtnApproval_Click` > SaveData > FindData_Main, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-033 | 저장(오류 응답) | 저장 SP에서 DB 오류가 발생하는 조건 | btnApproval을 누릅니다 | — | 오류 메시지가 표시되고 데이터 롤백 여부가 확인됩니다(트랜잭션 범위 확인 필요) | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0003-034 | 저장 | 상세 조회 완료 | txtRejectReason에 사유를 입력하고(편집 가능 여부 확인 필요) btnReject를 누릅니다 | 반려 사유 | 상세 확정 저장, 요청 저장, ERP IF 검사, 재조회를 거쳐 spdMain에 반려 상태가 반영됩니다 | `BtnReject_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-035 | 저장 / division | Division 40 요청 | btnReject를 누릅니다 | Division 40 | `_40` 저장 SP가 실행됩니다(분기 조건 확인 필요) | `BtnReject_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0003-036 | 저장 | 상세 조회 완료. 요청자 본인 요청(확인 필요) | btnSelfReject를 누릅니다 | — | 상세 확정 저장, 요청 저장, ERP IF 검사, 재조회를 거쳐 spdMain에 자가 반려 결과가 반영됩니다 | `BtnSelfReject_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-037 | 이벤트 | 화면 로드 완료 | btnRequestUser를 누릅니다 | — | 요청자 선택 동작이 실행되어 txtRequest에 반영됩니다(팝업 여부와 반영 방식 확인 필요). 오류가 없어야 합니다 | `BtnRequestUser_Click` |
| TC-SSP0003-038 | 이벤트 | 화면 로드 완료 | btnItemId를 누릅니다 | — | 모델 선택 동작이 실행되어 txtItemID에 반영됩니다(팝업 여부와 반영 방식 확인 필요). 오류가 없어야 합니다 | `btnItemId_Click` |
| TC-SSP0003-039 | 초기화 | SetChangedPeriod 호출 경로 확인(진입점 미연결) | AS-IS를 실행하며 CommonDataList 호출을 추적합니다 | PERIOD_{값} 또는 PERIOD_DEFAULT | 호출되면 FROM_VALUE, TO_VALUE로 기간을 설정합니다. 호출되지 않으면 To-Be 대상에서 제외 판정합니다 | SetChangedPeriod, `biz:CommonData.CommonDataList` |
| TC-SSP0003-040 | 권한 | 사용자 A 그룹은 Division 일부만 권한이 있음(TB_FX_USERGROUPAUTHEXTENTION) | 사용자 A로 화면을 엽니다 | — | clbDivision과 clbFromSite에 권한 범위의 항목만 표시됩니다 | `Form_Load`, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-041 | 권한 | TB_FX_GroupMenuAuth에서 U 권한이 없는 그룹(플래그 확인 필요) | 해당 그룹 사용자로 화면을 열고 btnApproval, btnReject, btnSelfReject 상태를 확인합니다 | — | 권한에 따라 버튼이 비활성화되거나 처리가 차단됩니다(구체 동작 확인 필요) | `BtnApproval_Click`, `BtnReject_Click`, `BtnSelfReject_Click` |
| TC-SSP0003-042 | division | Division 40 사용자 | 조회 후 spdMain과 txtApprovalDeptName의 표시 컬럼 수를 확인합니다 | Division 40 | 상단 19개, 상세 29개(ERP_SO_NO는 `_sChangeType`에 따름) | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-043 | division | Division 81 계열(81, 81_HD/HG/HM/ST/UC) 사용자 | TC-042와 같습니다 | Division 81 | 상단 19개, 상세 29개 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-044 | division | Division 82 사용자 | TC-042와 같습니다 | Division 82 | 상단 19개, 상세 29개 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-045 | division | Division EE 계열(EE, EE_HD/HG/HM/ST/UC) 사용자 | TC-042와 같습니다 | Division EE | 상단 19개, 상세 29개 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |

### 커버리지 대조

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 9 | `Form_Load` | 001~005 |
| | `SpdMain_CellDoubleClick` | 016~021 |
| | `ClbDivision_SelectedIndexChanged` | 006~008 |
| | `SpdMain_TopChange` | 022 |
| | `BtnApproval_Click` | 023~033 |
| | `BtnReject_Click` | 034, 035 |
| | `BtnSelfReject_Click` | 036 |
| | `BtnRequestUser_Click` | 037 |
| | `btnItemId_Click` | 038 |
| 엔드포인트 16 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | 001, 040 |
| | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | 002, 006, 008 |
| | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | 003, 007 |
| | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 009~012, 032 |
| | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 018, 020 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | 025, 034 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | 026, 035 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 027, 033 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 028, 029 |
| | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 030 |
| | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 031 |
| | `biz:CommonData.CommonDataList` | 039 |
| | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 024 |
| | `SSP.SSP0200_GET_SHIPMENT_STATUS` | 023 |
| | `SSP.SSP0003_GET_DELEGATEE_LOAD` | 019 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 004 |
| 시트 2 | `Shipment Change Request Confirm` | 005, 009, 013, 042~045 |
| | `Shipment Change Request Confirm Detail` | 005, 014~017, 021, 042~045 |
| 빈 결과 | | 008, 010, 020 |
| 오류 응답 | | 011, 031, 033 |
