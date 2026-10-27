# SCP0122 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순번 | As-is 컨트롤 | 라벨(원문) | 데이터 원천 | 연동 |
|---:|---|---|---|---|
| 1 | cboDivision (UsrCombo) | (Division — Text 원문 **확인 필요**) | 확인 필요 (SCP0121_GET_SEARCH_INFO가 SCM_MST_DIVISION을 참조하므로 후보) | 변경 시 `ClbDivision_SelectedIndexChanged` → `RefreshPlanGroupByDivision`(171)으로 Plan Group 갱신 추정 (**확인 필요**) |
| 2 | cboPlanGroup (UsrComboBox) | Plan Group | `GetPlanGroupByUserID` → `SCP.SCP0121_GET_SEARCH_INFO` (NowGroupID 사용) | 변경 시 `CboPlanGroup_SelectedIndexChanged` (동작 **확인 필요**) |
| 3 | cboProcess (UsrComboBox) | Process | `dtProcessCdAll` → `biz:CommonData.CommonDataList` [LookupCommon] 추정 (**확인 필요**) | — |

- 조회 시 `FindData_Main` 308~310행에서 `GetCheckedListValue`(CODE)를 3번 호출합니다. 조건 3개를 CODE 목록으로 전달하는 것으로 추정되지만 **확인 필요**입니다.
- 조회조건 패널: HidePanel 유형 (접기 가능)

## 2. 액션별 호출 API 후보

| 액션 | As-is | 호출 SP | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | `Form_Load` | 확인 필요 (GetPlanGroupByUserID 호출 여부) | 조회조건 콤보 API (SCP0121_GET_SEARCH_INFO) |
| Division 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | Plan Group 콤보 재조회 |
| Plan Group 변경 | `CboPlanGroup_SelectedIndexChanged` | 확인 필요 | 확인 필요 |
| 조회 | FindButton → FindData_Main:321 | SCP0122_GET_PLAN_ACTIVITY_MGMT | call-proc 조회 |
| 저장 | SaveButton → Save_Data:480 → FindData_Main:321 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT → 재조회 SCP0122_GET_PLAN_ACTIVITY_MGMT | call-proc 저장 + 성공 시 재조회 |
| 행 추가 | Insert_Row:367 (진입 버튼 **확인 필요**) | 없음 (조건 콤보 CODE를 읽음) | FE 행 추가. 조건값을 기본값으로 채우는지 **확인 필요** |
| 편집 | EditButton:275 (GetSheetInfo) | 없음 | 확인 필요 |
| 그리드 콤보 변경 | `SpdMain_ComboSelChange` | 확인 필요 | 확인 필요 |
| 그리드 셀 클릭 | `spdMain_CellClick` | 확인 필요 | 확인 필요 |
| 붙여넣기 | `SpdMain_ClipboardPasted`:574 (배선 **확인 필요**) | 없음 | Plan Group NAME → CODE 변환 (dtPlanGroup 기준) |

## 3. Division별 Grid 변형 요약

| 시트 | 구성 | Division 차이 |
|---|---|---|
| Plan Activity Mgmt | META 15컬럼 (SCM_MST_SHEET_COLUMNS) + 헤더 스타일 코드 | **없음** — 14개 division 모두 15컬럼 '기본' 표시 |

## 4. 권한(C/R/U/D) 관련 사실

| 구분 | 사실 |
|---|---|
| R | FindButton → SCP0122_GET_PLAN_ACTIVITY_MGMT |
| C | Insert_Row 메서드 있음. 저장 SP가 SCP_OPMZ_PLAN_GR_ACTV_M에 INSERT |
| U | SaveButton. 저장 SP가 SCP_OPMZ_PLAN_GR_ACTV_M에 UPDATE. EditButton 있음 |
| D | 저장 SP가 SCP_OPMZ_PLAN_GR_ACTV_M에 DELETE. 삭제 버튼 진입점은 Fact Pack에 없음 (**확인 필요**) |
| 메타 | TB_FX_GroupMenuAuth 3행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_SearchCondition 3행 존재. 행 내용(그룹·버튼 권한값)은 **확인 필요** |
| 사용자 컨텍스트 | GetPlanGroupByUserID에서 `FoxUserInfoContext.Current.NowGroupID` 사용 → Plan Group 목록이 사용자 그룹에 따라 달라질 가능성 |

## 5. 미확정 사항

1. 진입점 미연결 2건(SCP0121_GET_SEARCH_INFO, CommonDataList LookupCommon)의 실제 호출 시점
2. 5개 이벤트 핸들러의 본문 동작
3. Insert/Delete/Edit 버튼의 실제 노출 여부와 권한 메타값 (TB_FX_GroupMenuAuth 3행)
4. TB_FX_SearchCondition 3행이 조회조건 3개와 1:1로 대응하는지
5. 메인 조회 SP 결과 컬럼과 메타 15컬럼의 일치 여부 (SP 실행 결과 매칭 시트 없음)
6. 메타 컬럼별 편집 가능 여부·셀 유형·표시 순서 (SCM_MST_SHEET_COLUMNS 원문 확인 필요)
7. 저장 페이로드 형식 (SCM_ARR_SPL_CNT/VAL로 보아 구분자 문자열 가능성)
8. sln 미등록 프로젝트가 운영 대상인지
