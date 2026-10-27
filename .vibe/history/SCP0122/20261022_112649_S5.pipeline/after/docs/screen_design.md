# SCP0122 Plan Activity Mgmt — 화면설계서

> 근거는 AsisFacts Fact Pack(SCP0122)의 props.csv / controls.csv / events.csv / grid_effective.csv / grid_code.csv와 1차 분석서입니다. 사실이 없는 항목은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0122 |
| 화면 명칭(Form Text 원문) | `SCP0122_PlanActivityMgmt` (Designer.cs:293) |
| 클래스 | `SCP0122_PlanActivityMgmt` |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행 존재, 내용 미확인) |
| 소스 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\` (sln 미등록) |
| 시트 | `Plan Activity Mgmt` (1개) |

## 2. 화면 레이아웃

### 2-1. 분할 구조 (props.csv + controls.csv parent 체인)

- props.csv에 **SplitContainer가 없습니다**. Orientation·SplitterDistance 사실이 없으므로 분할은 **Dock**만으로 구성됩니다.
- parent 체인:
  - `this`(Form) → `usrConditionPanel1` (Dock **Top**, 1561×98, UsrPanelType=HidePanel)
    - → `usrLayoutControl2` (Dock **Fill**, 1561×98, Text `"usrLayoutControl2"`)
      - → `cboPlanGroup` (285×26), `cboProcess` (332×26), `cboDivision` (311×26)
  - `this`(Form) → `spdMain` (Dock **Fill**, 1561×766) — 시트 `spdMain_Sheet1` / 코드 생성 시트 `Plan Activity Mgmt`
  - `usrLayoutControl1` (Dock Fill, 657×184) — **parent 미기재**. 화면에서 실제로 쓰이는지 **확인 필요**
  - LayoutControlItem: `Division`(383×68, Control=cboDivision), `layoutControlItem9`(383×68, Control=cboPlanGroup), `layoutControlItem2`(382×68, Control=cboProcess), `emptySpaceItem1`(383×68). 이들의 parent(layoutControlGroup1/2)는 controls.csv에 미기재입니다. layoutControlGroup2 크기(1561×98)가 usrLayoutControl2와 같아 그 루트 그룹으로 추정되지만 **확인 필요**
- 상/하 비율: 98 : 766 → **상 11.3% : 하 88.7%**
- 좌/우 분할: **없음**

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────── SCP0122_PlanActivityMgmt (1561 폭) ────────────────────────────┐
│ [조회조건] usrConditionPanel1 (Dock Top, 98px ≈ 11%, HidePanel=접기 가능)                  │
│ ┌─ usrLayoutControl2 (Dock Fill) ───────────────────────────────────────────────────────┐ │
│ │ [Division(Text 확인 필요)] cboDivision │ [Plan Group] cboPlanGroup │ [Process] cboProcess │ (emptySpaceItem1) │ │
│ │   item 383×68                         │  item 383×68             │  item 382×68         │  383×68           │ │
│ └───────────────────────────────────────────────────────────────────────────────────────┘ │
│   ※ 항목 좌우 순서: Location 사실 없음 → 확인 필요                                         │
├───────────────────────────────────────────────────────────────────────────────────────────┤
│ [버튼] 공통 툴바: FindButton(조회) / SaveButton(저장) / EditButton / 행추가(Insert_Row 진입 확인 필요) │
│   ※ 버튼은 폼 컨트롤이 아니라 프레임워크 툴바로 보임 — 노출 여부 확인 필요                  │
├───────────────────────────────────────────────────────────────────────────────────────────┤
│ [그리드] spdMain / spdMain_Sheet1 (Dock Fill, 766px ≈ 89%)                                 │
│   시트 탭: Plan Activity Mgmt (단일)                                                       │
│   컬럼 15개 (META, §4)                                                                     │
└───────────────────────────────────────────────────────────────────────────────────────────┘
[팝업] Fact Pack에 사실 없음
```

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | GSCM.Windows.Forms.Controls.UsrConditionPanel | (Text 없음) | HidePanel, Dock Top | — | — | 접이식 조회조건 패널 |
| usrLayoutControl2 | GSCM.Windows.Forms.Controls.UsrLayoutControl | `usrLayoutControl2` | Dock Fill | — | — | 조회조건 Form 레이아웃 |
| usrLayoutControl1 | GSCM.Windows.Forms.Controls.UsrLayoutControl | (Text 없음) | Dock Fill, 657×184 | — | — | 사용 여부 **확인 필요** (미사용이면 전환 제외) |
| cboDivision | GSCM.Windows.Forms.Controls.UsrCombo | (LayoutControlItem `Division`의 Text 속성 없음 — **확인 필요**) | **확인 필요** | **확인 필요** | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | Division 콤보 (멀티선택 여부 **확인 필요** — GetCheckedListValue 사용) |
| cboPlanGroup | GSCM.Windows.Forms.Controls.UsrComboBox | `Plan Group` (layoutControlItem9) | **확인 필요** (`SCP.SCP0121_GET_SEARCH_INFO` 결과로 추정) | **확인 필요** | SelectedIndexChanged → `CboPlanGroup_SelectedIndexChanged` | Plan Group 콤보 |
| cboProcess | GSCM.Windows.Forms.Controls.UsrComboBox | `Process` (layoutControlItem2) | **확인 필요** (`biz:CommonData.CommonDataList` LookupCommon 추정) | **확인 필요** | — | Process 콤보 |
| emptySpaceItem1 | DevExpress.XtraLayout.EmptySpaceItem | — | 383×68 | — | — | 여백 |
| spdMain | FarPoint.Win.Spread.FpSpread | — | Dock Fill, 1561×766 | — | ComboSelChange → `SpdMain_ComboSelChange` / CellClick → `spdMain_CellClick` | Wijmo FlexGrid |
| spdMain_Sheet1 | FarPoint.Win.Spread.SheetView | — | 코드에서 `Plan Activity Mgmt` 시트 생성(AddSheet 인자 1 ¦ 1 ¦ 30 — 의미 **확인 필요**) | — | — | FlexGrid 시트(단일) |
| imageList1 | System.Windows.Forms.ImageList | — | — | — | — | 대응 필요 여부 **확인 필요** |

## 4. 그리드 명세 — 시트 `Plan Activity Mgmt`

- 생성: CreateSpread:185 `AddSheet` → 메타 빌드 SetSpreadInit:212 `SetSheetHeaderColumnSCP(siObj, 1, false, "")` → 활성화 InitSpread:198 `ChangeActiveSheet`, 조회 시 FindData_Main:306 `ChangeSheet`
- 연결 규칙: `META+코드연결`
- 코드 변경: 컬럼 헤더 스타일만 있습니다(Designer.cs:252~255 — HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General). 하드코딩 컬럼 추가·숨김은 없습니다.
- 컬럼 순서는 grid_effective.csv 기재 순서입니다. 실제 표시 순서·폭·셀 유형·편집 여부는 SCM_MST_SHEET_COLUMNS 원문 **확인 필요**

| # | 컬럼 | 헤더(COLUMN_LABEL) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | AUTO_YN | Auto Flag | 확인 필요 | META | 14개 division 전부 기본 | 확인 필요 |
| 2 | CONFIRM_YN | Confirm Flag | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 3 | DIVISION_ID | Div. | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 4 | LINK_UI_TYPE | Link UI Type | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 5 | OPMZ_ACTV_CD | Activity Code | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 6 | OPMZ_ACTV_NAME | Activity Name | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 7 | OPMZ_ACTV_SEQ | Act. Seq | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 8 | OPMZ_PLAN_GR_ID | Plan Group ID | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 9 | OPMZ_PLAN_GR_NAME | Plan Group | 확인 필요 (ClipboardPasted의 NAME→CODE 변환으로 보아 콤보 추정) | META | 전부 기본 | 확인 필요 |
| 10 | OPMZ_PRS_CD | Process CD | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 11 | OPMZ_PRS_NAME | Process | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 12 | OPTION_YN | Option Flag | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 13 | PRE_OPMZ_ACTV_CD | PRE_OPMZ_ACTV_CD | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 14 | PRE_OPMZ_ACTV_SEQ | PRE_OPMZ_ACTV_SEQ | 확인 필요 | META | 전부 기본 | 확인 필요 |
| 15 | PROGRAM_NAME | Program Name | 확인 필요 | META | 전부 기본 | 확인 필요 |

> division 목록: 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — 모두 15/0(기본 15, 선택 0)이며 **차이 없음**.
> 메타가 결정하는 속성: COLUMN_WIDTH, VISIBLE_FLAG, VALID_YN, FIXED_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, HORIZONTAL_ALIGN_CODE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG, ATTRIBUTE1~5.

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A01 | 화면 로드 | `Form_Load` (.ctor:98) / 필드 `dtProcessCdAll`:47 | 시트 생성·활성화, 공통코드 LookupCommon 적재 | `biz:CommonData.CommonDataList` [code=LookupCommon] | dtProcessCdAll (cboProcess 바인딩 **확인 필요**) |
| A02 | (시점 확인 필요) Plan Group 적재 | `GetPlanGroupByUserID`:155 | NowGroupID 기준 조회 | `SCP.SCP0121_GET_SEARCH_INFO` | cboPlanGroup 목록 (추정) |
| A03 | cboDivision 변경 | `ClbDivision_SelectedIndexChanged` (InitEvent:217) | **확인 필요** (RefreshPlanGroupByDivision:171 연관 추정) | 확인 필요 | 확인 필요 |
| A04 | cboPlanGroup 변경 | `CboPlanGroup_SelectedIndexChanged` (InitEvent:218) | **확인 필요** | 확인 필요 | 확인 필요 |
| A05 | 조회(FindButton) | `FindData_Main` | ChangeSheet:306 → GetCheckedListValue ×3:308~310 → 호출:321 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | spdMain `Plan Activity Mgmt` 바인딩 |
| A06 | 행 추가 | `Insert_Row`:367 | GetCheckedListValue(CODE) 사용, 진입 버튼 **확인 필요** | 없음 | 신규 행 |
| A07 | 그리드 콤보 선택 | `SpdMain_ComboSelChange` (InitEvent:220) | **확인 필요** | 확인 필요 | 확인 필요 |
| A08 | 그리드 셀 클릭 | `spdMain_CellClick` (InitEvent:221) | **확인 필요** | 확인 필요 | 확인 필요 |
| A09 | 저장(SaveButton) | `Save_Data`:480 → `FindData_Main`:321 | 저장 후 재조회 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` → `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | SCP_OPMZ_PLAN_GR_ACTV_M 반영, 이력·로그 적재, 그리드 재조회 |
| A10 | 편집(EditButton) | `EditButton`:275 | GetSheetInfo(spdMain.Name, ActiveSheetIndex), `if(spdMain != null)` | 없음 | **확인 필요** |

> `SpdMain_ClipboardPasted`(574)는 events.csv에 배선 기록이 없어 액션에서 제외하고 §9에 적었습니다.

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| 조회조건 필수 검증 | Fact Pack에 없음 — **확인 필요** |
| 저장 전 검증(필수·중복) | Fact Pack에 없음 — **확인 필요** |
| 메시지 코드/문구 | Fact Pack에 없음 — **확인 필요** |
| 그리드 시각 표시 | 컬럼 헤더 NoteIndicatorColor = Red (Designer.cs:253) |

## 7. 권한 (C/R/U/D)

| 구분 | 사실 |
|---|---|
| C | `Insert_Row`:367 존재, 저장 SP INSERT SCP_OPMZ_PLAN_GR_ACTV_M |
| R | FindButton → `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` |
| U | SaveButton, `EditButton`:275, 저장 SP UPDATE SCP_OPMZ_PLAN_GR_ACTV_M |
| D | 저장 SP DELETE SCP_OPMZ_PLAN_GR_ACTV_M. 삭제 버튼 진입점 **확인 필요** |
| 권한 메타 | TB_FX_GroupMenuAuth 3행 / TB_FX_MenuItemInfo 1행 / TB_FX_ProgramInfo 1행 / TB_FX_SearchCondition 3행 — 내용 **확인 필요** |
| 사용자 컨텍스트 | `FoxUserInfoContext.Current.NowGroupID` (GetPlanGroupByUserID:143) |

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| As-is | To-Be 전환 시 바뀌는 점 |
|---|---|
| FarPoint FpSpread `spdMain` + `SetSheetHeaderColumnSCP` 메타 빌드 | Wijmo FlexGrid. 컬럼은 SCM_MST_SHEET_COLUMNS 메타(SHEET_NAME=`Plan Activity Mgmt`) 기반으로 동적 생성. 하드코딩 컬럼 정의 금지 |
| ColumnHeader 스타일(General 정렬, NoteIndicatorColor Red) | FlexGrid 헤더 공통 스타일로 대체. inline style 금지 |
| UsrConditionPanel HidePanel | 접이식 조회조건 영역 |
| `GetCheckedListValue`(CODE) 다중 선택값 | 멀티선택 콤보의 CODE 목록 전달 형식(구분자 문자열 등)을 SP 파라미터 계약에 맞춰야 함 — **확인 필요** |
| `SpdMain_ClipboardPasted` NAME→CODE 변환 | 배선이 확인되면 FlexGrid 붙여넣기 시 콤보 NAME→CODE 변환을 구현 |
| MSSQL 임시테이블(#DIVISION_INFO, #LINE_MASTER, #OSP_PLANT_INFO) in `SCP0121_GET_SEARCH_INFO` | Oracle 19c GTT 또는 WITH 절로 변환 |
| `EXEC PR_SCM_SYS_LOG_BATCH`, `EXEC SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` | Oracle 프로시저 호출로 변환. 하위 SP도 함께 이관 대상 |
| `SCM_ARR_SPL_CNT` / `SCM_ARR_SPL_VAL` 문자열 분해 | Oracle 대응 함수(또는 JSON/CLOB 페이로드) 존재 여부 **확인 필요** |
| 결과셋 반환 | Oracle REF CURSOR 반환 형식, 저장 결과 코드 반환 방식 **확인 필요** |

## 9. 미확정

1. `Division` LayoutControlItem의 Text 원문
2. 조회조건 항목의 좌우 순서(Location 없음)와 layoutControlGroup1/2·LayoutControlItem의 parent
3. `usrLayoutControl1`, `imageList1` 사용 여부
4. 5개 이벤트 핸들러의 본문 동작
5. `SpdMain_ClipboardPasted` 배선 여부
6. `Insert_Row`·삭제·EditButton의 버튼 노출과 권한값
7. 그리드 컬럼별 셀 유형·편집 가능 여부·표시 순서·폭
8. 조회조건 초기값·필수 여부, 검증 메시지
9. 메뉴 위치
