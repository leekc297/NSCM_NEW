# SSP0012 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순서(Designer 선언) | 라벨 (원문) | AS-IS 컨트롤 | TO-BE 형태 | 필수 | 기본값 / 연동 |
|---:|---|---|---|---|---|
| 1 | From Site | clbPlantSite (UsrCheckedList) | 다중 선택 콤보 | 표시 없음 | 항목 출처 **확인 필요** |
| 2 | Period* | drpPeriod (UsrDateRangePicker) | 날짜 범위(From~To) | `*` 표시 | `SCM0001_GET_SCP_DAY_PERIOD` 결과(Form_Load, Division 변경 시) |
| 3 | Model | txtItemId (UsrMultiLineEditor) + btnItemId | 여러 줄 입력 + 검색 버튼 | 표시 없음 | 버튼 결과를 `txtItemId.Text` 에 넣음 |
| 4 | Division | clbDivision (UsrCheckedList) | 다중 선택 콤보 | 표시 없음 | 변경 시 Period 재계산. 기본값 = 사용자 `NowGroupID`(dtMyDivision, 48행) 관련 여부 **확인 필요** |
| 5 | Sold To Party | txtSoldToParty (TextBox) | 텍스트 | 표시 없음 | - |
| 6 | Ship To Party | txtShipToParty (TextBox) | 텍스트 | 표시 없음 | - |
| - | (텍스트 없음) | btnColumn (UsrButton) | 버튼 | - | `BtnColumn_Click` 동작 **확인 필요** |

- 순서는 Designer 선언/라벨 줄 순서입니다. 화면상 배치 순서는 **확인 필요**입니다.
- 조회조건 영역은 `HidePanel`(접기 가능)입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load > InitControls > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 공용 기간 조회 API (SCM0001) |
| Division 변경 | clbDivision_SelectedIndexChanged > SetChangedControl > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 공용 기간 조회 API 재호출 |
| 조회 (FindButton) | FindButton > FindData_Main | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | SSP0012 조회 API |
| Model 검색 버튼 | btnItemId_Click | 추출된 엔드포인트 없음 | 팝업 여부 **확인 필요** |
| 컬럼 버튼 | BtnColumn_Click | 추출된 엔드포인트 없음 | **확인 필요** |
| Grid 셀 클릭 | SpdMain_CellClick | 추출된 엔드포인트 없음 | **확인 필요** (이미지 셀 INCOTERMS / CHANGE_REQ_NO 연계 여부) |
| Grid 스크롤 | SpdMain_TopChange | 추출된 엔드포인트 없음 | **확인 필요** |
| 공통코드 | dtFcstType / dtBaseDay (필드) | `biz:CommonData.CommonDataList` [LookupCommon] | 공통코드 API. 사용처 **확인 필요** |
| 기간 기본값(미연결) | SetChangedPeriod | `biz:CommonData.CommonDataList` [PERIOD_*] | 사용 여부 **확인 필요** |

- 저장·삭제·Excel 업로드 엔드포인트는 추출되지 않았습니다. 주석 처리됨 `SCP.GET_DATE_RANGE_1MONTH` 은 대상이 아닙니다.

## 3. Division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 (전 division 공통) | 숨김 | 코드 변경 |
|---|---:|---|---|
| Shipment Plan Confirm Detail | 44 | BOD_ID, ORIGIN_FROM_DIVISION_ID, PLAN_QTY | INCOTERMS, CHANGE_REQ_NO → 이미지 셀 |

- 40 / 81(_HD/_HG/_HM/_ST/_UC) / 82 / EE(_HD/_HG/_HM/_ST/_UC) 모두 같습니다. Division에 따른 변형은 **없습니다**.
- 헤더는 2행입니다(`SetSheetHeaderColumn(spdInfo, 2)`).

## 4. 권한 (C/R/U/D) 관련 사실

| 사실 | 내용 |
|---|---|
| 메뉴 권한 메타 | `TB_FX_GroupMenuAuth` 16행. 그룹별 C/R/U/D 값은 미추출이므로 **확인 필요** |
| 기능 | 조회(R) 엔드포인트만 추출됨. C/U/D 엔드포인트는 없음 |
| 사용자 정보 | `UserInfoContext.Current.NowGroupID` 를 읽음(48행) |

## 5. 미확정 사항

1. 핸들러 4종(`SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click`, `btnItemId_Click`)의 상세 동작
2. `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 의 입력 파라미터와 결과 컬럼(동적 피벗)
3. Grid 컬럼 순서·폭·고정, 2행 헤더 상단 그룹 텍스트
4. `SetChangedPeriod` / `dtFcstType` / `dtBaseDay` 가 실제로 쓰이는지
5. `PERIOD_*` 공통코드의 분기 테이블
6. `usrButton1`(parent 없음)이 화면에 배치되는지
7. From Site / Division 콤보 항목의 데이터 출처, Division 기본 선택값
8. 권한 메타 16행의 내용
