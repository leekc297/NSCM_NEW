# SSP0019 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)
| 순 | 라벨(원문) | As-is 컨트롤 | 유형 | 초기값 / 비고 |
|---:|---|---|---|---|
| 1 | Division | clbDivision | 다중 체크 목록 | SelectedIndexChanged 이벤트 있음(동작 확인 필요) |
| 2 | From Site | clbFromSite | 다중 체크 목록 | 데이터 원천 확인 필요(GetSSPInnerTable 후보) |
| 3 | To Site | clbToSite | 다중 체크 목록 | 데이터 원천 확인 필요 |
| 4 | 확인 필요(TransportMode) | clbTransportMode | 다중 체크 목록 | 라벨 Text 미추출 |
| 5 | Incoterms | clbIncomterms | 다중 체크 목록 | |
| 6 | Shipment Date | drpPeriod | 기간 | Form_Load 시 `SCP.GET_DATE_RANGE_1MONTH` 로 초기화 |
| 7 | SO No | txtSoNo | 다건 텍스트 | |
| 8 | Model | txtItemId + btnItemId | 다건 텍스트 + 찾기 버튼 | 버튼 클릭 시 txtItemId 설정 |
| 9 | Confirm ID | txtConfirmId | 다건 텍스트 | |
| 10 | Current | chkCurrent | 체크박스 | CheckedChanged 이벤트 있음(동작 확인 필요) |

- 순서는 정리용이며 실제 배치 순서는 Layout 좌표로 **확인 필요**합니다.
- 저장된 조회조건(TB_FX_SearchCondition 96행)이 있으므로 조회조건 저장·복원 기능이 대상입니다.

## 2. 액션별 호출 API 후보
| 액션 | As-is 경로 | 호출 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load > InitControls > GetDayRange | SCP.GET_DATE_RANGE_1MONTH | 기간 기본값 조회 API (공통) |
| 화면 로드(콤보) | SetChangeControl > GetSSPInnerTable ×3 | 프레임워크 | SSP 공통 콤보 API (대상 컨트롤 확인 필요) |
| 조회(FindButton) | FindData_Main | SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY | `SSP0019` 조회 API → SP SSP0019_GET_SHIPMENT_CHANGE_HISTORY |
| 기간 변경(진입점 미확정) | SetChangedPeriod | biz:CommonData.CommonDataList (PERIOD_*) | 공통코드 API (진입점 확인 필요) |
| Model 찾기 | btnItemId_Click | 확인 필요 | Model 선택 팝업 |
| 그리드 클릭 | SpdMain_CellClick | 확인 필요 | 확인 필요 |
| 그리드 스크롤 | SpdMain_TopChange | 확인 필요 | 확인 필요 |

- 저장/삭제 엔드포인트는 추출되지 않았습니다. 조회 전용 화면입니다.

## 3. Division별 Grid 변형 요약
- 시트 `Shipment Change History` 1개. 메타 기반(SetSheetHeaderColumn)으로 구성합니다.
- 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 46컬럼 표시로 **변형 없음**.
- LAST_SEQ 는 숨김 컬럼으로 유지합니다.
- REQUEST_NO 는 이미지 셀 타입(코드 하드코딩)이므로 TO-BE 에서 셀 템플릿(이미지/아이콘)이 필요합니다.

## 4. 권한(C/R/U/D) 관련 사실
- TB_FX_GroupMenuAuth 에 SSP0019 관련 16행이 있습니다. 행별 C/R/U/D 값은 Fact Pack 에 없어 **확인 필요**.
- 코드에서 사용자/그룹 정보를 사용합니다: SetChangeControl:163~164 (Filter GROUP_ID·USER_ID, NowGroupID), SetChangedControl:298·303 (NowGroupID). 그룹별 조건 컨트롤 분기로 보이나 구체 동작은 **확인 필요**.
- InitControls:258·262 에서 FP_Log2 로 사용 로그(LOGTYPE, NOTE, USER_ID)를 남깁니다.

## 5. 미확정 사항
1. SP 파라미터 목록과 각 조회조건의 대응(GetCheckedListValue 5건: FindData_Main 387~390, 396).
2. SP 결과 컬럼과 메타 46컬럼의 일치 여부(grid 단계 미실행).
3. SetChangedPeriod / CommonData PERIOD_* 의 진입점과 코드값.
4. btnItemId_Click 팝업의 종류와 반환값(sItemId) 출처.
5. Current 체크, Division 변경, CellClick, TopChange 핸들러의 동작.
6. TransportMode 라벨 원문.
7. 조회조건 레이아웃 좌표와 splitter1(Dock=Bottom) 의 실제 역할.
8. GroupMenuAuth 16행의 권한 값.
