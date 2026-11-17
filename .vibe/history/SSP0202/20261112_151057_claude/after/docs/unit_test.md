# SSP0202 Shipment Change Request Confirm — 단위테스트

> 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5의 원문 그대로입니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 Fact Pack으로 값을 확정할 수 없는 부분은 **확인 필요**로 두었습니다. 원문을 확인한 뒤 기대값을 확정해야 합니다.
> 주석 처리된 호출은 테스트 대상에서 뺐습니다. 일반 저장 SP는 875줄의 활성 호출을 근거로 합니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0202-001 | 초기화 | 로그인, SSP0202 메뉴 권한 보유 | 화면을 엽니다 | 없음 | `drpPeriod`에 `SCM0001_GET_SCP_DAY_PERIOD` 결과 기간이 설정됩니다(기간 값 규칙 확인 필요). 오류가 없습니다. | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0202-002 | 초기화 | 기간 SP가 빈 결과 또는 오류를 반환하는 상태 | 화면을 엽니다 | 없음 | 화면이 중단되지 않습니다. `drpPeriod` 처리(빈 값/기본값)는 확인 필요 | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0202-003 | 초기화 | 화면 진입 | `clbDivision`, `clbFromSite`, `cboStatus`, `cboChangeType` 목록을 펼칩니다 | 없음 | 각 목록에 항목이 채워집니다(GetSSPInnerTable 216~246 바인딩 대응 확인 필요) | `Form_Load`, SetChangeControl / GetSSPInnerTable |
| TC-SSP0202-004 | 그리드 | 화면 진입 | `spdMain` 헤더를 확인합니다 | 없음 | 표시 컬럼 19개(Division, Request No, Title, Change Type, Status, From Site, To Site, Model, Nick Name, Change Reason, Reject Reason, Requestor, Requestor Dept Name, Request Date, Approval, Approval Dept Name, Approval Date, Delegatee, Delegatee Dept Name). REQUEST_USER, APPROVAL_USER, DELEGATEE_USER는 숨김. 헤더 1행 | `Shipment Change Request Confirm`, SetSheetHeaderColumn@InitSpread:368 |
| TC-SSP0202-005 | 그리드 | 화면 진입 | `txtApprovalDeptName` 헤더를 확인합니다 | 없음 | 표시 컬럼 25개(Confirm ID, SO No, FCST Type, Project Name, Model, From Site, To Site, ShipTo Code, Incoterms, L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty, NEW_ 6종, ShipTo Code, Remarks, Building, Customer requirement). 숨김 25개는 표시되지 않습니다. | `Shipment Change Request Confirm Detail`, SetSheetHeaderColumn@InitSpread:399 |
| TC-SSP0202-006 | 그리드 | CHANGE_TYPE이 "P"인 요청 존재(`_sChangeType` 출처 확인 필요) | `spdMain`에서 해당 행을 더블클릭합니다 | Change Type = P 행 | `txtApprovalDeptName`의 ERP_SO_NO가 숨김이 됩니다. 상단 헤더는 LT_DAY부터 6칸 "Plan", NEW_LT_DAY부터 7칸 "Confirm" | `Shipment Change Request Confirm Detail`, `SpdMain_CellDoubleClick`, InitSpread 405~422 |
| TC-SSP0202-007 | 그리드 | CHANGE_TYPE이 "P"가 아닌 요청 존재 | `spdMain`에서 해당 행을 더블클릭합니다 | Change Type ≠ P 행 | ERP_SO_NO가 표시됩니다. 상단 헤더는 LT_DAY부터 7칸 "Confirmed", NEW_LT_DAY부터 7칸 "Change" | `Shipment Change Request Confirm Detail`, `SpdMain_CellDoubleClick`, InitSpread 427~444 |
| TC-SSP0202-008 | 조회 | 처리 대상 요청 데이터 존재 | 조회조건을 입력하고 조회 버튼(FindButton)을 누릅니다 | `clbDivision`=보유 division, `drpPeriod`=기본 기간 | `spdMain`에 결과 행이 표시됩니다. 컬럼 값이 SP 결과 컬럼과 일치합니다. | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `Shipment Change Request Confirm` |
| TC-SSP0202-009 | 조회 | 조건에 맞는 데이터 없음 | 조회 버튼을 누릅니다 | `drpPeriod`=데이터 없는 기간 | `spdMain`이 0행입니다. 오류가 없습니다(안내 메시지 여부 확인 필요). | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-010 | 조회 | 다중 선택 가능 | `clbDivision`, `clbFromSite`에서 여러 값을 선택한 뒤 조회합니다 | 2개 이상 선택 | 선택한 값(CODE)이 모두 조건에 반영된 결과가 나옵니다(GetCheckedListValue 593/594/598/600) | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-011 | 조회 | 조회 조건 입력 | `cboStatus`, `cboChangeType`, `txtRequest`, `txtItemID`를 각각 지정해 조회합니다 | 상태·변경유형·요청자·모델 값 | 조건별로 필터링된 결과가 나옵니다(파라미터 대응 확인 필요) | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-012 | 조회 | 조회 SP 오류 응답 상태 | 조회 버튼을 누릅니다 | — | 오류 메시지가 표시되고 `spdMain`의 기존 데이터 처리 방식은 확인 필요. 화면이 중단되지 않습니다. | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-013 | 이벤트 | `spdMain`에 조회 결과 있음 | `spdMain` 행을 더블클릭합니다 | 임의 요청 행 | `txtApprovalDeptName`에 상세 행이 표시됩니다 | `SpdMain_CellDoubleClick`, `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-014 | 이벤트 | TC-013과 같음 | 더블클릭한 뒤 상세 폼을 확인합니다 | 임의 요청 행 | `txtRequestNo`, `txtTitle`, `txtRequestor`, `txtRequestDeptName`, `txtApproval`, `txtAppDeptName`, `txtChangeReason`, `txtReasonDetail`에 CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, APPROVAL_DEPT_NAME, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL 값이 표시됩니다(대응 관계 확인 필요). 8개 모두 읽기 전용입니다. | `SpdMain_CellDoubleClick`, SetChangeRequestInfo 723~730 |
| TC-SSP0202-015 | 이벤트 | 위임자가 등록된 요청 | `spdMain` 행을 더블클릭합니다 | 위임 대상 요청 행 | 위임자 정보가 로드됩니다(표시 위치 확인 필요) | `SpdMain_CellDoubleClick`, `SSP.SSP0202_GET_DELEGATEE_LOAD`, `SSP0202_GET_DELEGATEE_LOAD` |
| TC-SSP0202-016 | 이벤트 | 위임자가 없는 요청 | `spdMain` 행을 더블클릭합니다 | 위임자 없는 요청 행 | 빈 결과여도 오류가 없습니다 | `SSP.SSP0202_GET_DELEGATEE_LOAD` |
| TC-SSP0202-017 | 이벤트 | 상세 데이터가 없는 요청(빈 결과) | `spdMain` 행을 더블클릭합니다 | 상세 없는 요청 | `txtApprovalDeptName` 0행, 오류 없음 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-018 | 이벤트 | 화면 진입 | `clbDivision` 선택을 바꿉니다 | division 변경 | 연쇄 동작(예: `clbFromSite` 갱신 여부)은 원문 확인 후 확정. 최소 기준: 오류 없음 | `ClbDivision_SelectedIndexChanged` |
| TC-SSP0202-019 | 이벤트 | `spdMain`에 스크롤이 생길 만큼 행 존재 | `spdMain`을 세로로 스크롤합니다 | — | 동작은 원문 확인 후 확정. 최소 기준: 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0202-020 | 이벤트 | 화면 진입 | `btnRequestUser`를 누릅니다 | — | 검색 동작(팝업 여부)은 확인 필요. 선택 결과가 `txtRequest`에 반영되는지 확인 | `BtnRequestUser_Click` |
| TC-SSP0202-021 | 이벤트 | 화면 진입 | `btnItemId`를 누릅니다 | — | 검색 동작(팝업 여부)은 확인 필요. 선택 결과가 `txtItemID`에 반영되는지 확인 | `btnItemId_Click` |
| TC-SSP0202-022 | 저장 | 승인 대기 요청 상세 조회 완료, 계획 처리 중 아님, ERP I/F 정상 | `btnApproval`을 누릅니다 | 선택 요청 | 검사 3종을 통과하면 저장되고 `spdMain`이 재조회됩니다. 해당 요청 상태가 바뀝니다(상태 값 확인 필요). | `BtnApproval_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-023 | 저장 | 해당 division 계획이 처리 중인 상태 | `btnApproval`을 누릅니다 | 선택 요청 | 계획 처리 중 검사로 저장이 중단되는지 확인합니다(판정 값과 메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` |
| TC-SSP0202-024 | 저장 | SCS Confirm ID 검사에서 CNT가 걸리는 데이터 | `btnApproval`을 누릅니다 | 선택 요청 | Tables[0]/[1]의 CNT 판정에 따라 저장이 중단되거나 확인 절차가 나오는지 확인합니다(임계값·메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP0202_GET_SCS_CONFIRM_ID_CHECK` |
| TC-SSP0202-025 | 저장 | ERP I/F 검사에서 result_code가 오류인 데이터 | `btnApproval`을 누릅니다 | 선택 요청 | result_code 판정으로 저장이 중단되는지 확인합니다(값·메시지 확인 필요). SSP_ANL_SHIP_CONFIRM 변경 없음 | `BtnApproval_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| TC-SSP0202-026 | 저장 | `_40` SP 분기 조건을 만족하는 요청(조건 확인 필요) | `btnApproval`을 누릅니다 | 선택 요청 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`이 호출됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ 갱신, SSP_ANL_SHIP_CONFIRM_H 이력 INSERT, 메일 로그(SCM_ADM_SMS_MAIL_SEND_LOG) 생성 여부를 DB에서 확인 | `SaveData`(875), `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0202-027 | 저장 | `_40` 분기 조건을 만족하지 않는 요청 | `btnApproval`을 누릅니다 | 선택 요청 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`이 호출됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ 갱신, SSP_ANL_SHIP_CONFIRM_H 이력, XIF_SCS_PACK_SHIP_PLAN_S_SN·DM_PLN_MKT_FCST_CONFIRM 반영 여부를 DB에서 확인 | `SaveData`(875), `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0202-028 | 저장 | 반려 대상 요청 상세 조회 완료 | `txtRejectReason`에 사유를 입력하고 `btnReject`를 누릅니다 | 반려 사유 텍스트 | ERP I/F 검사 후 저장되고 재조회됩니다. 계획 처리·SCS 검사는 호출되지 않습니다. 반려 사유 저장 여부(REJECT_REASON 컬럼)는 확인 필요 | `BtnReject_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-029 | 저장 | 반려 대상 요청, `txtRejectReason` 빈 값 | `btnReject`를 누릅니다 | 반려 사유 없음 | 필수 검증 여부는 확인 필요(차단 또는 저장) | `BtnReject_Click` |
| TC-SSP0202-030 | 저장 | 본인 요청 상세 조회 완료 | `btnSelfReject`를 누릅니다 | 선택 요청 | ERP I/F 검사 후 저장되고 재조회됩니다. 계획 처리·SCS 검사는 호출되지 않습니다. 처리 구분 값은 확인 필요 | `BtnSelfReject_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-031 | 저장 | 저장 SP가 오류를 반환하는 상태 | `btnApproval` / `btnReject` / `btnSelfReject` 중 하나를 누릅니다 | 선택 요청 | 오류 메시지가 표시되고 SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ에 부분 반영이 없는지 확인합니다(롤백 방식 확인 필요) | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0202-032 | 저장 | 처리 대상 행을 선택하지 않음(상세 미조회) | `btnApproval`을 누릅니다 | 없음 | 차단 여부와 메시지는 확인 필요 | `BtnApproval_Click` |
| TC-SSP0202-033 | 저장 | ERP Block 대상 데이터(BLOCK_YN, PERIOD) | 처리 버튼을 누릅니다 | 선택 요청 | chkERPIFBlockYn 판정에 따라 차단되는지 확인(호출 경로·데이터 출처 확인 필요) | chkERPIFBlockYn(1064, 1073) |
| TC-SSP0202-034 | 조회 | SetChangedPeriod 호출 경로 확인 완료(현재 진입점 미연결) | 경로가 확인되면 해당 동작을 수행합니다 | PERIOD_{값} 코드 / PERIOD_DEFAULT | FROM_VALUE, TO_VALUE가 기간에 반영됩니다. 호출되지 않는 코드로 확인되면 이 TC는 NA | `biz:CommonData.CommonDataList`, SetChangedPeriod(1044) |
| TC-SSP0202-035 | division | Division 40 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=40 | `Shipment Change Request Confirm` 19컬럼, `Shipment Change Request Confirm Detail` 25컬럼(ERP_SO_NO는 `_sChangeType`에 따름) | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-036 | division | Division 40 요청 | `btnApproval`을 누릅니다 | `clbDivision`=40 요청 | 호출되는 저장 SP가 `_40`인지 일반인지 기록합니다(분기 조건 확인 근거 수집) | `BtnApproval_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0202-037 | division | Division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC) 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=81 계열 | 두 시트 컬럼 수가 19 / 25로 같습니다 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-038 | division | Division 82 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=82 | 두 시트 컬럼 수가 19 / 25로 같습니다 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-039 | division | Division EE 계열(EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=EE 계열 | 두 시트 컬럼 수가 19 / 25로 같습니다 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-040 | 권한 | 서로 다른 그룹(NowGroupID) 사용자 2명 | 각 사용자로 화면을 엽니다 | 그룹 A / 그룹 B | 조회조건 목록 등 SetChangeControl 결과가 GROUP_ID, USER_ID 기준으로 달라지는지 확인(차이 내용 확인 필요) | `Form_Load`, SetChangeControl(209~210), SetChangedControl(327) |
| TC-SSP0202-041 | 권한 | TB_FX_GroupMenuAuth 권한이 다른 그룹 | 화면을 열고 `btnApproval`, `btnReject`, `btnSelfReject` 상태를 확인합니다 | 그룹별 | 메뉴 권한에 따른 버튼 표시/활성 여부(메타 8행 내용 확인 필요) | `BtnApproval_Click`, `BtnReject_Click`, `BtnSelfReject_Click` |
| TC-SSP0202-042 | 권한 | 승인자 또는 위임자가 아닌 사용자 | `btnApproval`을 누릅니다 | 타인 승인 대상 요청 | 처리 제한 여부 확인(SSP_MST_DELEGATE 참조, 판정 위치 확인 필요) | `BtnApproval_Click`, `SSP.SSP0202_GET_DELEGATEE_LOAD` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001, 002, 003, 040 |
| 핸들러 | `SpdMain_CellDoubleClick` | 006, 007, 013~017 |
| 핸들러 | `ClbDivision_SelectedIndexChanged` | 018 |
| 핸들러 | `SpdMain_TopChange` | 019 |
| 핸들러 | `BtnApproval_Click` | 022~027, 032, 036, 041, 042 |
| 핸들러 | `BtnReject_Click` | 028, 029, 041 |
| 핸들러 | `BtnSelfReject_Click` | 030, 041 |
| 핸들러 | `BtnRequestUser_Click` | 020 |
| 핸들러 | `btnItemId_Click` | 021 |
| 엔드포인트 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 008~012, 022, 028, 030, 035 |
| 엔드포인트 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 013, 017 |
| 엔드포인트 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | 022, 026, 028, 030, 031, 036 |
| 엔드포인트 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | 022, 027, 028, 030, 031, 036 |
| 엔드포인트 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 025, 028, 030 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 034 |
| 엔드포인트 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | 023 |
| 엔드포인트 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | 024 |
| 엔드포인트 | `SSP.SSP0202_GET_DELEGATEE_LOAD` | 015, 016, 042 |
| 엔드포인트 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 001, 002 |
| 시트 | `Shipment Change Request Confirm` | 004, 008, 035, 037~039 |
| 시트 | `Shipment Change Request Confirm Detail` | 005~007, 013, 017, 035, 037~039 |
| 빈 결과 | — | 002, 009, 016, 017 |
| 오류 응답 | — | 002, 012, 025, 031 |
