# SSP0014 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순 | 라벨(원문) | As-is 컨트롤 | 필수 | 값 원천 | 비고 |
|---:|---|---|---|---|---|
| 1 | Division* | cboDivision (UsrCombo) | 필수(`*` 표기) | GetSSPInnerTable 추정 → 확인 필요 | 변경 시 CboDivision_SelectedIndexChanged |
| 2 | Operation Group | cboOperationGroup (UsrCombo) | 확인 필요 | 확인 필요 | – |
| 3 | From Site | clbFromSite (UsrCheckedList) | 확인 필요 | 확인 필요 | 다중 선택, GetCheckedListValue(CODE) |
| 4 | Valid | cboValidYN (UsrCombo) | 확인 필요 | YesOrNo 연결 여부 확인 필요 | – |
| 5 | User ID(Name) | txtUser (TextBox) | 확인 필요 | 직접 입력 | – |
| 6 | Model | txtItemId (UsrMultiLineEditor) + btnItemId | 확인 필요 | 직접 입력 / btnItemId_Click | 다중행 |

- 표의 순서는 Designer 선언 순서입니다. 실제 화면 배치 순서는 확인 필요입니다.
- TB_FX_SearchCondition 에 SSP0014 행이 112개 있습니다(저장된 조회조건). 컬럼 구성은 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 경로 | 호출 API(As-is 키) | TO-BE API 후보 |
|---|---|---|---|
| 조회 | FindButton > FindData_Main | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | 조회 API (SP SSP0014_GET_SHIPMENT_MODEL_PIC) |
| 저장 | SaveButton > SaveData > GetUserIDChk | `SSP.SSP0014_GET_USER_ID_CHECK` | 사용자 ID 검사 (저장 서비스 안 또는 별도 API, 확인 필요) |
| 저장 | SaveButton > SaveData | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | 저장 API (SP SSP0014_SAVE_SHIPMENT_MODEL_PIC) |
| 저장 후 | SaveData > FindData_Main | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | 재조회 |
| Model 버튼 | btnItemId_Click | 없음(Fact Pack 기준) | txtItemId 값 설정. 팝업 여부 확인 필요 |
| Division 변경 | CboDivision_SelectedIndexChanged | 확인 필요 | 종속 조회조건 갱신 여부 확인 필요 |
| 셀 더블클릭 | SpdMain_CellDoubleClick | 확인 필요 | 확인 필요 |
| 스크롤 | SpdMain_TopChange | 확인 필요 | 확인 필요 |
| 편집 | EditButton | GetSheetInfo(spdMain, ActiveSheetIndex) | 그리드 편집 모드 처리 |
| 화면 로드 | Form_Load | 확인 필요 (InitControls 의 FP_Log2 로그, SetChangeControl 의 GetSSPInnerTable) | 초기 콤보 로드 |

## 3. Division별 Grid 변형 요약

- 시트 `Shipment Model PIC` 1개, 21컬럼.
- 모든 division(40, 81 계열, 82, EE 계열)에서 21컬럼 모두 기본 표시 → **division별 변형 없음**.
- 코드 변경: 이미지 CellType 8건(InitSpread 225~233, 대상 컬럼 확인 필요). 라벨 변경·숨김 없음.
- 필수 표시 라벨: `User ID*`, `Valid*`.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 | DB 메타 |
| SetChangeControl:137~138 에서 Filter GROUP_ID / USER_ID 와 `UserInfoContext.Current.NowGroupID` 사용 | meta_reads |
| 저장 전 `SSP0014_GET_USER_ID_CHECK` 가 TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION 조회 | endpoints |
| 버튼 진입점: FindButton(R), SaveButton(C/U), EditButton | flow / grid_code |

- Delete 기능(D), 행 추가 버튼은 Fact Pack에서 확인되지 않습니다. SAVE SP 는 MERGE 만 참조합니다 → 삭제 지원 여부 **확인 필요**.
- 그룹별 C/R/U/D 플래그 값은 Fact Pack에 없습니다 → **확인 필요**.

## 5. 미확정 사항

1. SaveData 안의 실행 순서(사용자 검사 → 저장 → 재조회)와 실패 시 처리
2. SaveButton:285 호출 해석(PersonalSettingPopup.SaveData)이 맞는지
3. `biz:CommonData.YesOrNo` 를 쓰는 컨트롤(진입점 미연결)
4. 각 조회조건의 값 원천과 필수 여부(Division 외)
5. 이미지 CellType 8건의 대상 컬럼과 동작(CellDoubleClick 과의 관련 여부)
6. SpdMain_TopChange / SpdMain_CellDoubleClick / CboDivision_SelectedIndexChanged 본문
7. btnItemId_Click 의 sItemId 원천
8. usrButton1, imageList1 사용 여부
9. STRING_SPLIT, SCM_ARR_SPL_CNT/VAL, FN_GET_ITEM_NICKNAME, PR_SCM_SYS_LOG_BATCH 의 Oracle 대응 객체
10. 메타 컬럼 순서·폭·정렬·편집 여부(SCM_MST_SHEET_COLUMNS 원문 대조)
