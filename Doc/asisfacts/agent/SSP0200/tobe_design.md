# SSP0200 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)
| 순서 | 라벨(원문) | AS-IS 컨트롤 | 유형 | 비고 |
|---:|---|---|---|---|
| 1 | Div | clbDivision_ID | 단일 콤보 | 소스 `SSP0200_GET_SHIPMENT_DIVISION`. 변경 시 From Site 재조회(`SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`) |
| 2 | From Site | clbFromSite | 체크리스트(다중) | GetCheckedListValue 사용 |
| 3 | To Site | clbToSite | 체크리스트(다중) | 소스 확인 필요 |
| 4 | Status | cboStatus | 콤보 | 소스 확인 필요 |
| 5 | Shipment Date | drpPeriod | 기간 | 초기값 = `SCM0001_GET_SCP_DAY_PERIOD` |
| 6 | Change Type | cboChangeType | 콤보 | 값 "P" 분기 존재. 변경 시 기간 재계산 + Grid 컬럼 변경 |
| 7 | SO No | txtSoNo | 멀티라인 | |
| 8 | Confirm Id | txtConfirmId | 멀티라인 | |
| 9 | (Model — Text 미추출) | txtRequest + btnItemId | 멀티라인 + 팝업 | btnItemId_Click 내부 확인 필요 |
| 10 | (Text 미추출) | chkSingleProcess | 체크박스 | 용도 확인 필요 |

- 위 순서는 Designer 선언 순서가 아니라 정리용입니다. 실제 배치 순서는 LayoutControl 위치값으로 확인해야 합니다.
- usrConditionPanel1은 `HidePanel` 타입(접이식)입니다.

## 2. 액션별 호출 API 후보
| 액션 | 트리거 | 호출 SP (순서는 정적 경로 기준) |
|---|---|---|
| 화면 초기화 | Form_Load | SCM0001_GET_SCP_DAY_PERIOD → SSP0200_GET_SHIPMENT_DIVISION → SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| Division 변경 | clbDivision_ID_SelectedIndexChanged | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| Change Type 변경 | CboChangeType_SelectedIndexChanged | SCM0001_GET_SCP_DAY_PERIOD |
| 조회 | FindButton | SSP0200_GET_SHIPMENT_CHANGE_REQUEST (상단) + SSP0200_GET_SHIPMENT_REQUEST_DRAFTING (하단) |
| 행 추가 | InsertButton / BtnNew_Click ("New") | SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION (From Site 콤보) |
| 다건 행 추가 | btnInsertMultiple_Click ("Insert(Multi)", 수량 팝업) | SSP0200_GET_ITEM_FROM_BOD, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION |
| 셀 값 변경 | shtMain_Change | SSP0200_GET_ITEM_FROM_BOD |
| 셀 콤보 선택 | SpdMain_ComboSelChange | SSP0026_GET_BOD_ITEM, CommonDataList[TransMode], SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION |
| Trans Mode 셀 클릭 | SpdMain_CellClick | CommonDataList[TransMode] |
| 저장 | SaveButton | SSP0200_GET_CHANGE_REQ_NO → SSP0200_SAVE_SHIPMENT_CONFIRM_NEW → (ERP I/F 분기) SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM / SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING / SSP0200_GET_SHIPMENT_STATUS / SSP0200_GET_ERP_SO_NO_CNT / SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING (SoNo·NonSoNo·NewNonSoNo) / SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM / PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE → SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N + 재조회 |
| Request Complete | BtnChangeRe_Click | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE (메일 발송 체인 포함) → 재조회 |
| Save Draft (기본 숨김) | BtnSave_Click | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE → 재조회 |
| Cancel | BtnCancel_Click | SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING (DeleteDataDrafting, GetErpIFCheck) → 재조회 |
| 승인자 선택 | BtnApprovalUser_Click | 엔드포인트 미추출 — 확인 필요 |
| Delete | btnDel | 이벤트 배선 없음 — 확인 필요 |

**저장 전 클라이언트 검증 근거**
- `SSP_Main_Validation`이 다음 값을 확인합니다.
  - 일반: shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks
  - SO 건: INCOTERMS를 제외한 같은 항목
- `chkERPIFBlockYn`이 BLOCK_YN과 PERIOD를 확인합니다.
- 메시지 문구와 조건식은 Fact Pack에 없습니다. **확인 필요**

## 3. division별 Grid 변형 요약
| 시트 | 40 / EE | 그 외 (81 계열, 82, EE_*) |
|---|---|---|
| Shipment Change Request | END_CUSTOMER, ERP_ATTR1(Consignee Name), ERP_ATTR2(Contact Point), ERP_ATTR3(Lot) 표시 / PROJECT_CODE, PROJECT_NAME 숨김 → 34열 | 반대 → 32열 |
| Change Request | 25열(?5) | 26열(?5) |

- 판정 기준은 조회조건 Div 값(InitSpread)과 행별 DIVISION_ID 콤보 값(SpdMain_ComboSelChange) 두 가지입니다.
- Change Type "P"이면 ERP_SO_NO와 CONFIRM_ID를 숨기거나 폭을 0으로 하고, Change Request 2단 헤더를 "Plan/Confirm"으로 둡니다. 그 외에는 "Confirmed/Change"입니다.
- DIVISION_ID 셀 콤보는 MyDivision에서 `CODE != "EE"`인 값만 씁니다(InsertRow:2765, BtnNew_Click:3381/3422).

## 4. 권한(C/R/U/D) 관련 사실
- 메타 테이블에 `TB_FX_GroupMenuAuth` 16행, `TB_FX_MenuItemInfo` 4행, `TB_FX_ProgramInfo` 4행이 있습니다. 행 내용(버튼별 C/R/U/D 값)은 Fact Pack 본문에 없습니다. **확인 필요**
- Division과 Site 목록 SP 3개(SSP0200_GET_SHIPMENT_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION)가 `TB_FX_USERGROUPAUTHEXTENTION`을 참조합니다. 즉 사용자 그룹 권한에 따라 목록이 필터링됩니다.
- `UserInfoContext.Current["NowGroupID"]`를 읽는 위치: SetChangeControl:334, SetChangedControl:562, SaveDataDrafting:2521, GetDivision, GetShipmentPlanPlantSite, GetPlantSiteByDivisionEEOperation
- 편집 가능 여부는 `siMain.IsLock(SheetName)`으로 판정합니다(InsertRow, BtnNew_Click, SpdMain_CellClick 조건).
- 승인 흐름 관련 컬럼: APPROVAL_USER, APPROVAL_DEPT. 승인자 선택 버튼은 btnApprovalUser입니다.

## 5. 미확정 사항
1. FoxQuery 미등록 SP 2개를 TO-BE에서 어떻게 호출할지(MyBatis 직접 매핑 여부)
2. TO_SITE 콤보 소스(`Data_SCP.Common`)와 Status·Change Type·Change Reason 콤보 소스 SP
3. 상단↔하단 그리드 연동 방식(SpdMain_CursorChanged 내부 미추출)
4. ERP I/F 분기 조건 3종(SoNo / NonSoNo / NewNonSoNo)을 결정하는 조건식
5. `SP_SEND_DBMAIL` 메일 발송의 TO-BE 대체 방식
6. 동적 SQL 3개 SP의 실제 조회 대상 테이블
7. LayoutControlItem Text 중 미추출 라벨(Model, Single Process, 변경요청 정보 영역 전부)
8. grid_effective 판단불가(?) 140건, 시트 귀속 추정 건(CHK, END_CUSTOMER/PROJECT_* on Change Request)
9. btnDel·btnAdd·dtDate의 실사용 여부(btnAdd·dtDate는 Visible=false, btnDel은 배선 없음)
