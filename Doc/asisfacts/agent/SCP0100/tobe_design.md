# SCP0100 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순서 | 조건 | As-is 컨트롤 | 라벨(원문) | 값 원천 | 비고 |
|---:|---|---|---|---|---|
| 1 | Division | clbDivision (멀티) | 확인 필요 | 확인 필요 | `getDivision`(466) GetCheckedListValue |
| 2 | Plan Date | cboPlanDate | 확인 필요 | SCP0100_GET_PLAN_DATE | 변경 시 기간과 헤더를 다시 만듦 |
| 3 | 기간 | dCalendar (DateRange) | 확인 필요 | GetPlanEndDate(CommonDataList_REPORT, PLAN_END_DATE) | 변경 시 헤더 재구성 |
| 4 | Bucket | cboBucketType | Bucket | 확인 필요 | MONTHLY / WEEKLY 컬럼 표시 전환 |
| 5 | Plan-type | cboPlanType | Plan-type | 확인 필요 | LayoutItem Enabled=false. `getPlanType`(344) |
| 6 | From Site | clbFromSite (멀티) | From Site | 확인 필요 | `getFromSite`(306) |
| 7 | To Site | clbToSite (멀티) | To Site | SCP0100_GET_SITE | `getToSite`(325) |
| 8 | Model | txtItemId + btnItemId | Model / Nick Name | 팝업 | |
| 9 | Project | txtProject + btnProject | Project | 팝업 | |
| 10 | Cell Group | txtCellGroup | Cell Group | 직접 입력 | |
| 11 | Search Level | cboSearchLevel / rgrpSearchLevel | 확인 필요 | 확인 필요 | `getSearchLevel`(412). PRODUCT_LEVEL 표시 제어 |
| 12 | Unit Qty | cboUnitQty | 확인 필요 | 확인 필요 | |
| 13 | Graph | cboGraphType | Graph | 확인 필요 | 차트 유형 |
| 14 | Display | cboDisplay | Display | 확인 필요 | 차트/그리드 분할 0 / 750 / 270 |
| 15 | Measure / Column | btnMeasure / btnColumn | 확인 필요 | - | 헤더 재구성 |
| - | Cell Qty | chkCellQty | Cell Qty | - | Visible=false, Checked=true |
| - | A/S | chkAS | A/S | - | Visible=false |

> 조회조건 순서와 라벨은 SCP 기준표(search_cond.csv, CR-071)를 우선해야 합니다. 사실 묶음에는 기준표가 없어 **확인 필요**입니다. TB_FX_SearchCondition 23행도 내용 확인이 필요합니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러 | 호출 API 후보 | 동작 |
|---|---|---|---|
| 화면 로드 | `Form_Load` | `SCP0100_GET_PLAN_DATE`, `SCP0100_GET_SHEET_CALENDAR_3SPAN`, 공통 PLAN_END_DATE | 콤보·기간 초기화, 그리드 헤더 생성 |
| 화면 표시 후 | `SCP0100_Global_PSI_Report_Shown` | `SCP0100_GET_SITE` | To Site 목록 |
| Plan Date 변경 | `CboPlanDate_SelectedIndexChanged` | `SCP0100_GET_SHEET_CALENDAR_3SPAN`, PLAN_END_DATE | 기간·헤더 재구성 |
| 기간 변경 | `DCalendar_ValueChanged` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Search Level 라디오 변경 | `rgrpSearchLevel_SelectedIndexChanged` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Measure 버튼 | `btnMeasure_Click` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Column 버튼 | `BtnColumn_Click` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| Bucket 변경 | `CboBucketType_SelectedIndexChanged` | 없음(FE) | M_ / W_ 컬럼 표시 전환 |
| Display 변경 | `CboDisplay_SelectedIndexChanged` | 없음(FE) | 분할 비율 변경 |
| Model 팝업 | `BtnItemId_Click` | 팝업 API 확인 필요 | txtItemId 세팅 |
| Project 팝업 | `BtnProject_Click` | 팝업 API 확인 필요 | txtProject 세팅 |
| Division 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | |
| Graph 변경 | `CboGraphType_SelectedIndexChanged` | 확인 필요 | |
| Search Level 콤보 | `CboSearchLevel_SelectedIndexChanged` | 확인 필요 | PRODUCT_LEVEL 표시(SetLayout) 관련 추정 |
| Unit Qty | `CboUnitQty_SelectedIndexChanged` | 확인 필요 | |
| Plan-type | `CboPlanType_SelectedIndexChanged` | 확인 필요 | |
| Cell Qty 체크 | `ChkCellQty_CheckedChanged` | 확인 필요 | 컨트롤 Visible=false |
| A/S 체크 | `ChkAS_CheckedChanged` | 확인 필요 | 컨트롤 Visible=false |
| 조회(Search) | 미추출 | **확인 필요** (메인 리포트 SP) | 그리드·차트 데이터 |

## 3. Division별 Grid 변형 요약

- 변형 **없음**: 전 Division 14종의 메타·최종 컬럼 수가 같고, 코드에 Division 비교 분기도 없습니다.
- 최종 표시 컬럼 수: REPORT 11 (+런타임 PRODUCT_LEVEL 3), SEARCH_LEVEL 5 (+3), SEARCH_LEVEL_DETAIL 5 (+3)
- 동적 요소(전 Division 공통):
  - 기간 컬럼 DB 루프(SCP0100_GET_SHEET_CALENDAR_3SPAN)
  - Bucket별 M_ / W_ 표시
  - D0·D1 숨김
  - 계획 시작월 Red, W_ 라벨 A·B Blue
  - 3단 헤더

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴·프로그램 등록 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 |
| 그룹 메뉴 권한 | TB_FX_GroupMenuAuth 4행 — C/R/U/D 값은 사실 묶음에 없음, **확인 필요** |
| 즐겨찾기 | TB_FX_Favorite 2행 |
| 세션 정보 | `BaseForm.OnShown`(522)에서 NowGroupID, USER_ID 소비 |
| 저장 / 삭제 | 추출된 저장 계열 엔드포인트 없음 |

## 5. 미확정 사항

1. 메인 조회 SP와 차트 데이터 SP
2. CommonDataList_REPORT(PLAN_END_DATE)의 원천과 TO-BE 대체 API
3. 엔드포인트가 추출되지 않은 핸들러 11종의 실제 로직
4. `SetSpreadColumn` 루프 시작 인덱스(고정 컬럼까지 숨기는지 여부)
5. `SetLayout` 마지막 case 라벨과 적용 대상 시트
6. `VisibleSheet` 전환 조건(`_is_detail` 결정 지점)
7. splitContainer1 Orientation, 그리고 cboDisplay 항목과 SplitterDistance(0 / 750 / 270)의 대응
8. 라벨을 찾지 못한 LayoutControlItem의 Text: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layAS, layCategoryCC, layoutControlItem3·4, layoutPlanDate
9. SCM_MST_SHEET_MEASURE `Global PSI New` 35행과 시트·차트 사이의 연결 방식
10. TB_FX_SearchCondition 23행 내용과 SCP 조회조건 기준표 대조
