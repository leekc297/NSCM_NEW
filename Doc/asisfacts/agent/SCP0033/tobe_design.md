# SCP0033 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨 (AS-IS 원문) | AS-IS 컨트롤 | TO-BE 형태 | 값 소스 |
|---|---|---|---|
| Model | txtItemId (TextBox) | 텍스트 입력 | 자유 입력 |
| Valid | cboValidYN (UsrCombo) | 단일 콤보 | 확인 필요 (biz:CommonData.YesOrNo 후보, 바인딩 미확인) |
| Division | clbDivision (UsrCheckedList) | 다중 선택 | CODE 값 (GetCheckedListValue) |

- 조회조건 메타 TB_FX_SearchCondition은 2행입니다. 컨트롤은 3개라서 개수가 다르며, 원인은 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS | 호출 엔드포인트 | 비고 |
|---|---|---|---|
| 조회 | FindButton → FindData_Main | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | |
| 저장 | SaveButton → SaveData_Main | SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY → 재조회 GET | |
| 행 추가 | InsertButton (204줄) | 서버 호출 없음 | DIVISION_ID 셀을 Combo로 설정, 데이터는 BLUtils.GetDivision(false, "") |
| 편집 | EditButton (219줄) | 서버 호출 없음 (GetSheetInfo만 확인) | 상세 로직 확인 필요 |
| 삭제 | 확인 필요 | 확인 필요 | Fact Pack에 없음 |
| 화면 로드 | Form_Load | 확인 필요 | 본문 미추출 |
| Grid 이벤트 | SpdMain_CellClick / SpdMain_KeyPress / SpdMain_TopChange | 확인 필요 | 본문 미추출 |
| 공통 데이터 | 필드 43·44줄 | CommonData.CommonDataList [LookupCommon], CommonData.YesOrNo | 진입점 미연결 |

## 3. Division별 Grid 변형 요약

- 시트는 `Shipment Semi Dept Day` 1개입니다. 모든 division(40, 81 계열, 82, EE 계열)에서 표시 컬럼이 10개로 같아 변형이 없습니다.
- 숨김 컬럼: `S_VALID_YN`
- 필수 표시 라벨: `Division*`, `Model*`

## 4. 권한 (C/R/U/D) 관련 사실

- TB_FX_GroupMenuAuth 11행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있습니다. 그룹별 C/R/U/D 값은 Fact Pack에 없어 확인 필요입니다.
- InsertButton 처리는 `siMain.IsLock(siMain.SheetName) == false`일 때만 Combo를 설정합니다(시트 잠금 조건).

## 5. 미확정 사항

1. 이벤트 핸들러 4개의 로직
2. Valid 콤보와 Grid의 DEPARTURE_DAY·VALID_YN 셀 타입 및 콤보 소스(LookupCommon 코드값 포함)
3. 삭제 기능 여부
4. Grid 컬럼의 순서·폭·정렬·편집 가능 여부 (SCM_MST_SHEET_COLUMNS 원문)
5. GET/SAVE SP의 파라미터 목록과 저장 키 구성
6. 권한 행의 상세 값
7. usrLayoutControl1(657×184)과 imageList1의 용도
