# SCP0122 Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel (Dock Top, HidePanel) | — | 1561×98 | 조회조건 패널 (접기 가능) |
| usrLayoutControl2 | UsrLayoutControl (Dock Fill, 조건패널 내부) | — | 1561×98 | 조회조건 Form 레이아웃 |
| cboDivision | UsrCombo | (LayoutControlItem `Division`, Text 원문 미기재 — **확인 필요**) | 311×26 | Division 콤보 (멀티선택 여부는 GetCheckedListValue 사용으로 추정, **확인 필요**) |
| cboPlanGroup | UsrComboBox | `Plan Group` | 285×26 | Plan Group 콤보 |
| cboProcess | UsrComboBox | `Process` | 332×26 | Process 콤보 |
| emptySpaceItem1 | EmptySpaceItem | — | 383×68 | 여백 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView (Dock Fill) | — | 1561×766 | Wijmo FlexGrid |
| usrLayoutControl1 | UsrLayoutControl (Dock Fill, parent 미기재) | — | 657×184 | 사용 여부 **확인 필요** |
| imageList1 | ImageList | — | — | 대응 불필요 여부 **확인 필요** |

## 2. 화면 배치

- props.csv에 **SplitContainer가 없습니다**. Dock으로만 배치합니다.
- 상/하 분할: 조회조건 `usrConditionPanel1` (Dock Top, 높이 98) / 그리드 `spdMain` (Dock Fill, 높이 766)
  - 비율 ≈ **상 11% : 하 89%** (98 : 766)
- 좌/우 분할: 없음
- 조회조건 행 (LayoutControlItem 폭 383/383/382, 높이 68): Division, Plan Group, Process, emptySpaceItem1. 항목 간 정확한 좌우 순서는 Location 값이 없어 **확인 필요**입니다.

## 3. 시트별 Grid 컬럼 — `Plan Activity Mgmt`

- 연결 규칙: `META+코드연결` (AddSheet → SetSheetHeaderColumnSCP)
- 코드 하드코딩 컬럼: 없음 (코드 변경은 ColumnHeader 스타일 4건뿐)
- Division별 표시: 14개 division 모두 15컬럼이 '기본'으로 표시되어 차이가 없습니다.

| # | COLUMN_NAME | 라벨 | 출처 | 40 | 81 계열 | 82 | EE 계열 |
|---:|---|---|---|---|---|---|---|
| 1 | AUTO_YN | Auto Flag | META | 기본 | 기본 | 기본 | 기본 |
| 2 | CONFIRM_YN | Confirm Flag | META | 기본 | 기본 | 기본 | 기본 |
| 3 | DIVISION_ID | Div. | META | 기본 | 기본 | 기본 | 기본 |
| 4 | LINK_UI_TYPE | Link UI Type | META | 기본 | 기본 | 기본 | 기본 |
| 5 | OPMZ_ACTV_CD | Activity Code | META | 기본 | 기본 | 기본 | 기본 |
| 6 | OPMZ_ACTV_NAME | Activity Name | META | 기본 | 기본 | 기본 | 기본 |
| 7 | OPMZ_ACTV_SEQ | Act. Seq | META | 기본 | 기본 | 기본 | 기본 |
| 8 | OPMZ_PLAN_GR_ID | Plan Group ID | META | 기본 | 기본 | 기본 | 기본 |
| 9 | OPMZ_PLAN_GR_NAME | Plan Group | META | 기본 | 기본 | 기본 | 기본 |
| 10 | OPMZ_PRS_CD | Process CD | META | 기본 | 기본 | 기본 | 기본 |
| 11 | OPMZ_PRS_NAME | Process | META | 기본 | 기본 | 기본 | 기본 |
| 12 | OPTION_YN | Option Flag | META | 기본 | 기본 | 기본 | 기본 |
| 13 | PRE_OPMZ_ACTV_CD | PRE_OPMZ_ACTV_CD | META | 기본 | 기본 | 기본 | 기본 |
| 14 | PRE_OPMZ_ACTV_SEQ | PRE_OPMZ_ACTV_SEQ | META | 기본 | 기본 | 기본 | 기본 |
| 15 | PROGRAM_NAME | Program Name | META | 기본 | 기본 | 기본 | 기본 |

> 81 계열 = 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC / EE 계열 = EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — 모두 동일합니다.
> 컬럼 순서는 grid_effective.csv 기재 순서(알파벳)를 따랐습니다. 실제 표시 순서(SORT 메타)·폭·셀 유형(콤보 등)은 SCM_MST_SHEET_COLUMNS 원문을 봐야 하므로 **확인 필요**입니다.
> 셀 콤보: `SpdMain_ComboSelChange` 배선과 ClipboardPasted의 Plan Group NAME→CODE 변환으로 보아 Plan Group 셀은 콤보로 추정됩니다. 확정하려면 메타 CELL_CONTROL_OBJECT_TYPE_CODE를 **확인**해야 합니다.

## 4. 시트 연결 규칙

| 시트 | 규칙 | 생성 | 메타 빌드 | 활성화 |
|---|---|---|---|---|
| Plan Activity Mgmt | META+코드연결 | CreateSpread:185 AddSheet | SetSpreadInit:212 SetSheetHeaderColumnSCP | InitSpread:198 ChangeActiveSheet, FindData_Main:306 ChangeSheet |

- 단일 시트이므로 시트 간 마스터-디테일 연결은 없습니다.
