# SSP0005 — TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | 컨트롤 | 데이터 원천 | 비고 |
|---|---|---|---|
| Company | cboCompany | `biz:CommonData.CommonDataList` [code=Company] (필드 dtCompany:46) | 바인딩 지점은 unreached 판정이므로 확인 필요 |
| Division | clbDivision | `biz:CommonData.CommonDataList` [code=MyDivision] (dtMyDivision:45, NowGroupID 기준) | 다중 선택. FindData_Main:387·388 `GetCheckedListValue` |
| Period* | drpPeriod | `SCP.SCM0001_GET_SCP_PERIOD` (GetDayRange:941) 초기값 | 필수 표시 `*` |
| Day of the week | cboDayWeek | `biz:CommonData.CommonDataList` [code=LookupCommon] (dtDayWeek:47) | 변경 시 cboInputValue Enabled 제어 |
| Input Value | cboInputValue | `biz:CommonData.YesOrNo` (InitControls:168) | 일괄 입력용 값 |

조회 파라미터 구성(FindData_Main 387·388의 값 매핑)은 확인 필요입니다. `TB_FX_SearchCondition` 메타에 19행이 존재합니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 진입점 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load | biz:CommonData.YesOrNo, SCP.SCM0001_GET_SCP_PERIOD, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 공통코드 API + 기간 조회 API + 달력 헤더 조회 API |
| 조회 | FindButton → FindData_Main | SSP.SSP0005_GET_SHIPMENT_WORKING_DAY, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 헤더(달력) 조회 → 데이터 조회 |
| 저장 | SaveButton → SaveData_Main | SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW (변경분 GetChanges) → 재조회 | 변경 행 저장 API → 재조회 |
| 일괄 입력 | BtnInput_Click | 서버 호출 추출 없음 | 클라이언트 처리. Changed 이벤트 억제 후 일괄 반영 |
| 요일 변경 | CboDayWeek_SelectedIndexChanged | 서버 호출 추출 없음 | Input Value 활성/비활성 처리 |
| 헤더 더블클릭 | SpdMain_CellDoubleClick | 없음 | 월(M_)·주(W_)·일(D_) 컬럼 접기/펼치기 |
| 셀 변경 | SpdMain_Changed | 없음 | 변경 처리(내용 확인 필요) |
| 스크롤 | SpdMain_TopChange | 없음 | 확인 필요 |

## 3. Division별 Grid 변형 요약

- 시트 `Shipment Working Day`의 메타 컬럼은 COMPANY_ID, DIVISION_ID 2개입니다. 14개 division 모두 같습니다(기본 2).
- 날짜 컬럼은 SCP0009 결과로 동적 생성됩니다(Combo YesOrNo, 폭 70, SAT 파랑/SUN 빨강, 3단 헤더). division 분기는 없습니다.

## 4. 권한(C/R/U/D) 관련 사실

| 메타 테이블 | 행 수 |
|---|---:|
| TB_FX_GroupMenuAuth | 13 |
| TB_FX_MenuItemInfo | 1 |
| TB_FX_ProgramInfo | 1 |
| TB_FX_Favorite | 5 |

- 그룹별 C/R/U/D 플래그 값은 Fact Pack에 없어 확인 필요입니다(`dbmeta_dbo_TB_FX_GroupMenuAuth.csv` 참조).
- 화면 코드에서 확인된 기능은 조회(FindButton)와 저장(SaveButton)입니다. 신규/삭제 진입점은 추출되지 않았습니다. `EditButton`(352)은 `GetSheetInfo`만 추출되었습니다.

## 5. 미확정 사항

1. `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` 3회 참조(535~537)의 구분과 저장 파라미터
2. `SaveData_Main`의 컬럼 `A`(502·527) 의미
3. `BtnInput_Click`의 일괄 입력 대상(요일·기간·Division 조합)과 반영 방식
4. `CboDayWeek_SelectedIndexChanged`의 Enabled 분기 조건
5. `SpdMain_TopChange`, `SpdMain_Changed` 내부 처리
6. `SetChangedPeriod`(PERIOD_ 코드)와 필드 초기화(45~48)의 실제 호출 경로
7. `B_` 컬럼 처리 분기와 AddSheet 인자(3, 1, 35)의 의미
8. `usrButton1`의 용도
9. 메타 라벨 `Divison` 철자의 TO-BE 처리 여부
10. 주석 처리된 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`, `SCP.GET_DATE_RANGE_1MONTH`는 현행 기능이 아니므로 설계에서 제외합니다
