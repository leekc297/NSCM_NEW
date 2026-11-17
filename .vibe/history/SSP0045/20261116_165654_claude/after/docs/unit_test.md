# SSP0045 Shipment Request — 단위테스트

> 근거 열의 이름은 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름 원문을 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 내부 로직이 추출되지 않은 항목은 기대결과를 "AS-IS 실행 대조(확인 필요)"로 적었습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0045-001 | 초기화 | 화면 권한이 있는 사용자로 로그인 | 화면을 연다 | - | `cboBizType`·`cboDivision` 관련 공통코드 조회가 1회 실행되고 오류가 없다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| TC-SSP0045-002 | 초기화 | 위와 같음 | 화면을 열고 `cboBucketType` 목록을 펼친다 | - | 버킷 코드 목록이 표시되고 DAILY/WEEKLY/MONTHLY 값이 있다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0045-003 | 초기화 | 위와 같음 | 화면을 열고 `drpPeriod`를 클릭·입력해 본다 | - | `drpPeriod`가 비활성(Enabled=false)이라 편집할 수 없다. 기간 값은 SP 결과와 같다(대입 방식 확인 필요) | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0045-004 | 초기화 | 위와 같음 | 화면을 열고 `spdMain` 시트 탭과 헤더를 확인한다 | - | 시트 `Shipment Request` 1개가 생성되고 헤더가 3행이다. 달력 컬럼이 SP 결과 행 수만큼 생성된다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request` |
| TC-SSP0045-005 | 이벤트 | 화면 로드 완료 | `cboDivision`의 값을 다른 Division으로 바꾼다 | Division 변경(예: 40 → 81) | 공통코드가 다시 조회되고 연동 컨트롤 목록이 Division 기준으로 갱신된다(대상 컨트롤 확인 필요) | `CboDivision_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| TC-SSP0045-006 | 이벤트 | 화면 로드 완료 | `cboBizType`의 값을 바꾼다 | Operation Group 변경 | 공통코드가 다시 조회되고 연동 목록이 갱신된다(대상 확인 필요) | `CboBizType_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| TC-SSP0045-007 | 이벤트 | 화면 로드 완료 | `btnItem_Id`를 클릭하고 팝업에서 Model을 선택해 확인한다 | Model 1건 선택 | 선택한 Model 값이 `txtItem_Id`에 들어간다(1198줄) | `BtnItem_Id_Click` |
| TC-SSP0045-008 | 이벤트 | 조회 완료(시트 존재), `chkSum` 해제 | `cboBucketType`을 DAILY로 바꾼다 | DAILY | Tag `D_` 컬럼이 표시되고 `M_` 컬럼은 숨겨진다. `W_` 컬럼 최종 표시는 AS-IS 실행 대조(확인 필요) | `cboBucketType_SelectedIndexChanged`, 시트 `Shipment Request` |
| TC-SSP0045-009 | 이벤트 | 조회 완료, `chkSum` 해제 | `cboBucketType`을 WEEKLY로 바꾼다 | WEEKLY | `D_` 숨김, `W_` 표시, `M_` 숨김 | `cboBucketType_SelectedIndexChanged`, 시트 `Shipment Request` |
| TC-SSP0045-010 | 이벤트 | 조회 완료 | `cboBucketType`을 MONTHLY로 바꾼다 | MONTHLY | `D_`·`W_` 숨김, 그 외 컬럼 표시 | `cboBucketType_SelectedIndexChanged`, 시트 `Shipment Request` |
| TC-SSP0045-011 | 이벤트 | 조회 완료, `cboBucketType` = WEEKLY | `chkSum`을 체크한 뒤 다시 해제한다 | 체크 → 해제 | 체크하면 `M_` 컬럼이 표시되고, 해제하면 숨겨진다 | `chkSum_CheckedChanged`, 시트 `Shipment Request` |
| TC-SSP0045-012 | 이벤트 | 조회 완료, `cboBucketType` = DAILY | `chkSum`을 체크한 뒤 해제한다 | 체크 → 해제 | `M_` 컬럼이 체크 상태를 따라 표시/숨김된다. `W_`는 AS-IS 실행 대조(확인 필요) | `chkSum_CheckedChanged`, 시트 `Shipment Request` |
| TC-SSP0045-013 | 조회 | 데이터가 있는 조건 | `cboBizType`, `cboDivision` 선택 후 `clbFromSite` 체크, `txtItem_Id` 입력, 조회(FindButton) 클릭 | 유효 조건 | 시트를 다시 초기화한 뒤 결과 행이 바인딩된다. 메타 표시 12컬럼과 달력 컬럼에 값이 나온다 | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, SP `SSP0045_GET_SHIPMENT_REQUEST`, `biz:CommonData.CommonDataList` [code=PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request` |
| TC-SSP0045-014 | 조회 | 해당 데이터가 없는 조건 | 존재하지 않는 Model을 `txtItem_Id`에 넣고 조회(FindButton) 클릭 | 없는 Model 값 | 0행이 표시되고 헤더(메타·달력)는 유지되며 오류가 없다. 안내 메시지 여부는 AS-IS 대조(확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, 시트 `Shipment Request` |
| TC-SSP0045-015 | 조회 | SP 오류를 유도할 수 있는 환경(예: DB 객체 권한 제거) | 조회(FindButton) 클릭 | - | 오류 메시지가 표시되고 시트가 깨지지 않는다(메시지 원문 확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, SP `SSP0045_GET_SHIPMENT_REQUEST` |
| TC-SSP0045-016 | 그리드 | 조회 완료 | 시트 `Shipment Request`의 메타 컬럼 표시와 숨김을 확인한다 | - | 표시 12: Division*, FCST Type, From Site*, Incoterms*, Model*, Requestor, L/T(Day), Measure, Nick Name, Project Code, To Site*, Trans Mode*. 숨김 6: BOD_FROM_YYYYMMDD, BOD_ID, BOD_TO_YYYYMMDD, FROZEN_YYYYMMDD, MEASURE, MEASURE_COLOR | 시트 `Shipment Request`, SCM_MST_SHEET_COLUMNS |
| TC-SSP0045-017 | 그리드 | 조회 완료 | 달력 컬럼의 헤더, 색상, 숨김 컬럼을 확인한다 | - | 헤더 0행 대분류, 1행 소분류, 그룹 시작 열에 SUM 헤더. SAT 글자 Blue, SUN 글자 Red. `B_` 포함 컬럼은 숨김(폭 0). 그 외 숫자 컬럼 폭 70 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request` |
| TC-SSP0045-018 | 저장 | 조회 완료, 수정 가능한 행 존재 | 시트 `spdMain`의 수량 셀을 수정하고 저장(SaveButton) 클릭 | 수량 변경 1건 | 저장이 성공하고 자동 재조회 후 변경 값이 반영된다. DM_PLN_SHIPMENT_REQ와 이력 DM_PLN_SHIPMENT_REQ_H에 행이 생성된다(DB 확인) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST`, SP `SSP0045_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0045_GET_SHIPMENT_REQUEST` |
| TC-SSP0045-019 | 저장 | 조회 완료 | 키 컬럼(Division, From Site, Model, Incoterms, Trans Mode, Project Code, FCST Type 등)이 같은 행을 두 개 만든 뒤 저장(SaveButton) | 중복 키 2행 | 저장 전 키 비교 결과가 AS-IS와 같다(판정과 메시지 확인 필요) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (checkValidN0) |
| TC-SSP0045-020 | 저장 | SP 오류를 유도할 수 있는 환경 | 저장(SaveButton) 클릭 | 수정 1건 | 오류 메시지가 표시되고 데이터가 부분 반영되지 않는다(롤백 확인) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST`, SP `SSP0045_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0045-021 | 저장 | 조회 완료, 변경 없음 | 수정 없이 저장(SaveButton) 클릭 | - | 저장 대상 없음 처리가 AS-IS와 같다(메시지 확인 필요) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0045-022 | 그리드 | 조회 완료 | `spdMain`의 셀을 클릭한다 | 임의 셀 | `clbFromSite` 등의 체크 값을 읽어 셀 처리가 이루어진다. 클릭 후에도 콤보 선택 이벤트가 정상 동작한다(해제·재등록). 상세는 AS-IS 대조(확인 필요) | `SpdMain_CellClick` |
| TC-SSP0045-023 | 그리드 | 조회 완료, 콤보 셀 존재 | `spdMain` 콤보 셀에서 값을 선택한다 | 콤보 값 변경 | AS-IS 실행 결과와 같은 연동 동작(확인 필요) | `SpdMain_ComboSelChange` |
| TC-SSP0045-024 | 그리드 | 조회 완료 | `spdMain` 셀을 더블클릭한다 | 임의 셀 | AS-IS 실행 결과와 같은 동작(확인 필요) | `SpdMain_CellDoubleClick` |
| TC-SSP0045-025 | 그리드 | 조회 결과가 화면 높이를 넘는 상태 | `spdMain`을 세로로 스크롤한다 | 스크롤 | AS-IS 실행 결과와 같은 동작(확인 필요) | `SpdMain_TopChange` |
| TC-SSP0045-026 | 그리드 | 조회 완료, 시트 잠금 아님 | 행 추가 후 ITEM_ID(Model*) 셀을 확인한다 | `cboDivision`, `cboBizType` 선택 상태 | ITEM_ID 셀이 Division·Operation Group 조건의 콤보 목록이 된다(진입 버튼과 원천 확인 필요) | 시트 `Shipment Request` (InsertRow/InsertRow2) |
| TC-SSP0045-027 | 권한 | 조회만 허용된 그룹 사용자(권한 값 확인 필요) | 화면을 열고 조회(FindButton)와 저장(SaveButton)을 시도한다 | - | 조회는 되고 저장 버튼 동작은 TB_FX_GroupMenuAuth 권한값과 같다(확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0045-028 | division | Division 40 사용자 | `cboDivision` = 40으로 조회 | Division 40 | 메타 표시 컬럼 12개가 위 TC-016과 같다. 결과 데이터는 AS-IS SP 결과와 일치한다(40 전용 SP 처리 확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, SP `SSP0045_GET_SHIPMENT_REQUEST`, 시트 `Shipment Request` |
| TC-SSP0045-029 | division | Division 81(또는 82·EE 계열) 사용자 | `cboDivision` = 81로 조회 | Division 81 | 메타 표시 컬럼 12개가 Division 40과 같다. 결과 데이터는 AS-IS SP 결과와 일치한다 | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, 시트 `Shipment Request` |

### 커버리지 점검표

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001~004 |
| | `CboDivision_SelectedIndexChanged` | 005 |
| | `CboBizType_SelectedIndexChanged` | 006 |
| | `BtnItem_Id_Click` | 007 |
| | `cboBucketType_SelectedIndexChanged` | 008~010 |
| | `chkSum_CheckedChanged` | 011, 012 |
| | `SpdMain_CellClick` | 022 |
| | `SpdMain_ComboSelChange` | 023 |
| | `SpdMain_CellDoubleClick` | 024 |
| | `SpdMain_TopChange` | 025 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 001, 004, 005, 006, 013 |
| | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 002 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 003 |
| | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 004, 013, 017 |
| | `SSP.SSP0045_GET_SHIPMENT_REQUEST` | 013~015, 018, 027~029 |
| | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` | 018~021, 027 |
| 시트 | `Shipment Request` | 004, 008~013, 016, 017, 026, 028, 029 |
| 빈 결과 / 오류 | 조회 0행 / 조회 오류 / 저장 오류 | 014 / 015 / 020 |
| division | 40 / 81 | 028 / 029 |

> 주석 처리된 호출(화면 834줄)은 현행 기능이 아니므로 테스트 케이스에서 제외했습니다.
