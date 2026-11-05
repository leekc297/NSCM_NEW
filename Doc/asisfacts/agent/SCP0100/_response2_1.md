=== FILE: business_analysis.md ===
# SCP0100 Global PSI Report — 업무분석서

> 근거: AsisFacts 정적 추출 사실 묶음(Fact Pack)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)만 사용했습니다. 사실 묶음에 없는 내용은 **확인 필요**로 적었습니다.
> 함께 보는 문서: 화면설계서 §5 액션 명세, 단위테스트 근거 열. 세 문서는 엔드포인트 이름을 똑같이 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SCP0100 / `SCP0100_Global_PSI_Report` | 파일 구성 |
| 업무 영역 | SCP Report (`06.UIL\GSCM.SCP.Forms.UIL\Report\`) | 프로젝트 경로 |
| 화면 성격 | Global PSI 리포트. 차트(`chartMain`)와 Spread 그리드 3개(REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL)를 보여 줍니다 | controls.csv, grid_code.csv |
| 업무 목적 | "PSI"의 업무 정의, 리포트가 답하려는 업무 질문 | **확인 필요** (사실 묶음에 업무 설명 없음) |
| 범위: 조회 | 계획일자, 기간, Bucket, Site, Model, Project, Cell Group, Search Level 등으로 조건을 정하고 기간별 수량 컬럼을 보여 줍니다 | 컨트롤·이벤트·grid_code |
| 범위: 저장 | 추출된 저장 계열 엔드포인트 **0건**. 조회 전용인지는 **확인 필요** | endpoints.csv |
| 메인 데이터 조회 | 그리드·차트 본문 데이터를 가져오는 엔드포인트·SP가 **추출되지 않았습니다**. 툴바 조회(Search) 처리 방식은 **확인 필요** | analysis.md §2 경고 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드) | 엔드포인트 | 결과 |
|---:|---|---|---|---|
| S1 | 메뉴에서 화면을 엽니다 | `Form_Load` > InitControls > GetPlanDate | `SCP.SCP0100_GET_PLAN_DATE` | Plan Date 콤보(`cboPlanDate`) 목록을 채웁니다 (콤보 바인딩 방식은 확인 필요) |
| S2 | (화면 열기, 이어서) | `Form_Load` > InitControls > SetCalendar > GetDayRange > GetPlanEndDate | `biz:CommonData.CommonDataList_REPORT` (code=PLAN_END_DATE) | 기간(`dCalendar`) 범위를 정합니다 (종료일 계산식은 확인 필요) |
| S3 | (화면 열기, 이어서) | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 시트 3개를 만들고, 메타 고정 컬럼과 기간 컬럼(3단 헤더)을 생성합니다 |
| S4 | 화면이 표시된 직후 | `SCP0100_Global_PSI_Report_Shown` > InitControlsAfter > RefreshToSite > GetSiteList | `SCP.SCP0100_GET_SITE` | To Site(`clbToSite`) 목록을 채웁니다 |
| S5 | Plan Date를 바꿉니다 | `CboPlanDate_SelectedIndexChanged` > SetCalendar / InitSpread | `biz:CommonData.CommonDataList_REPORT`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 기간 범위와 그리드 기간 헤더를 다시 만듭니다 |
| S6 | 기간을 바꿉니다 | `DCalendar_ValueChanged` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 기간 헤더를 다시 만듭니다 |
| S7 | Search Level 라디오를 바꿉니다 | `rgrpSearchLevel_SelectedIndexChanged` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더를 다시 만듭니다 |
| S8 | Measure 버튼을 누릅니다 | `btnMeasure_Click` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더를 다시 만듭니다 (Measure 선택 팝업이 있는지는 확인 필요) |
| S9 | Column 버튼을 누릅니다 | `BtnColumn_Click` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더를 다시 만듭니다 |
| S10 | Bucket을 바꿉니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn (`if(_SI != null)`) | 없음 | MONTHLY면 `M_` 컬럼만, WEEKLY면 `W_` 컬럼만 표시합니다 |
| S11 | Display를 바꿉니다 | `CboDisplay_SelectedIndexChanged` | 없음 | `splitContainer1.SplitterDistance`를 0 / 750 / 270 중 하나로 바꿉니다 |
| S12 | Model 팝업 버튼을 누릅니다 | `BtnItemId_Click` | 추출 없음 (팝업 API 확인 필요) | `txtItemId.Text = sItemId` |
| S13 | Project 팝업 버튼을 누릅니다 | `BtnProject_Click` | 추출 없음 (팝업 API 확인 필요) | `txtProject.Text = sProjectCode` |
| S14 | Division, Graph, Search Level 콤보, Unit Qty, Plan-type, Cell Qty, A/S를 바꿉니다 | `ClbDivision_SelectedIndexChanged`, `CboGraphType_SelectedIndexChanged`, `CboSearchLevel_SelectedIndexChanged`, `CboUnitQty_SelectedIndexChanged`, `CboPlanType_SelectedIndexChanged`, `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged` | 추출 없음 | 실제 처리는 **확인 필요** |
| S15 | 조회(Search)를 실행합니다 | **확인 필요** (추출 안 됨) | **확인 필요** | 그리드·차트 데이터 표시 (추정, 확인 필요) |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 Load (Form_Load)
    ├─ InitControls
    │   ├─ GetPlanDate ───────────────► SCP.SCP0100_GET_PLAN_DATE        → cboPlanDate
    │   └─ SetCalendar > GetDayRange > GetPlanEndDate
    │                    ─────────────► biz:CommonData.CommonDataList_REPORT (PLAN_END_DATE) → dCalendar
    └─ CreateSpread
        ├─ AddSheet ×3 (SEARCH_LEVEL / REPORT / SEARCH_LEVEL_DETAIL), GetSheetInfo ×3, ChangeSheet ×2
        └─ InitSpread
            ├─ InitSheet(_SI.SheetName)
            ├─ GetSpdTitle ────────────► SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN → dsSpdTitle
            ├─ SetSheetHeaderColumn(_SI, 3)   (메타 고정 컬럼)
            ├─ InitSpreadDateColumn(_SI, _SI.nIdxData) (기간 컬럼 DB 루프)
            └─ SetSpreadColumn               (Bucket별 M_/W_ 표시)
[2] 화면 Shown (SCP0100_Global_PSI_Report_Shown)
    └─ InitControlsAfter > RefreshToSite > GetSiteList ─► SCP.SCP0100_GET_SITE → clbToSite
[3] 조건 변경
    ├─ cboPlanDate 변경 → [기간 재계산(PLAN_END_DATE)] + [InitSpread 재실행]
    ├─ dCalendar / rgrpSearchLevel / btnMeasure / btnColumn → [InitSpread 재실행]
    ├─ cboBucketType → SetSpreadColumn (화면 내부 처리)
    └─ cboDisplay → 차트/그리드 분할 위치 변경 (화면 내부 처리)
[4] 조회 실행 → 메인 데이터 SP (확인 필요) → 그리드/차트 표시
    └─ 시트 표시 전환: VisibleSheet (spdDetail / spdSearchLevel / spdSearchLevelDetail 중 1개)
```

## 4. 업무 규칙 (사실 근거)

### 4-1. SP 분기 조건
- SP 3개(`SCP0100_GET_SHEET_CALENDAR_3SPAN`, `SCP0100_GET_SITE`, `SCP0100_GET_PLAN_DATE`)의 본문, 파라미터, 분기 조건은 사실 묶음에 없습니다 → **확인 필요**.
- 사실 묶음에 있는 것은 참조 객체뿐입니다(§5).
  - `SCP0100_GET_SITE`와 `SCP0100_GET_PLAN_DATE`는 `FN_SPLITSTRING`을 참조합니다. 구분자로 이어 붙인 다중값 파라미터를 받는 것으로 보이지만, 어떤 파라미터인지는 **확인 필요**입니다.
  - 둘 다 `SCP_RPT_GLOBAL_PSI_MD_MM`(월)과 `SCP_RPT_GLOBAL_PSI_MD_WW`(주)를 읽습니다. 월/주 중 어느 쪽을 쓸지 가르는 조건은 **확인 필요**입니다.

### 4-2. 필수값·검증
- 조회 전 필수값 검사와 오류 메시지 호출은 **추출되지 않았습니다** → **확인 필요**.
- 조건 값 수집 (`CString.GetCheckedListValue`, 메타 컬럼 `CODE`):
  - `getPlanStartYYYYMMDD`:215
  - `getFromSite`:306
  - `getToSite`:325
  - `getPlanType`:344
  - `getSearchLevel`:412
  - `getDivision`:466

### 4-3. 날짜·버킷 규칙 (grid_code.csv)

| 규칙 | 조건 | 결과 | 줄 |
|---|---|---|---:|
| B1 Bucket 월 | `_bucket_type.Equals("MONTHLY")` 이고 `ColName.IndexOf("M_") == 0` | 컬럼 표시 | 1103 |
| B2 Bucket 월 외 | MONTHLY 이고 `M_`로 시작하지 않음 | 컬럼 숨김 | 1107 |
| B3 Bucket 주 | `_bucket_type.Equals("WEEKLY")` 이고 `ColName.IndexOf("W_") == 0` | 컬럼 표시 | 1114 |
| B4 Bucket 주 외 | WEEKLY 이고 `W_`로 시작하지 않음 | 컬럼 숨김 | 1118 |
| D1 보조 컬럼 | `sColumnName.IndexOf("B_") > 0` (0번째가 아닌 위치에 `B_` 포함) | Text 컬럼, 폭 0, Visible=false | 755 |
| D2 수량 컬럼 | 그 외 | Num 컬럼, 폭 70, Visible=true | 760 |
| D3 계획 시작월 강조 | `M_`로 시작하고 `_plan_start_yyyymm` 포함 | 글자색 Red | 767 |
| D4 주차 강조 A | `W_`로 시작하고 라벨에 "A" 포함 | 글자색 Blue | 774 |
| D5 주차 강조 B | `W_`로 시작하고 라벨에 "A"는 없고 "B" 포함 | 글자색 Blue | 778 |
| D6 D0·D1 숨김 | `SetVisibleColumnCycle` 루프 (컬럼 D0, D1) | 숨김 | 1290 |
| H1 3단 헤더 | 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, 2행 "Qty" | 기간 헤더 구성 | 787~816 |

- 기간 범위의 종료일은 `GetPlanEndDate`가 `biz:CommonData.CommonDataList_REPORT`(code=PLAN_END_DATE)에서 얻습니다. 계산식은 **확인 필요**입니다.
- `_plan_start_yyyymm`, `_bucket_type` 값의 출처(어느 컨트롤·SP 결과에서 오는지)는 **확인 필요**입니다.
- `SetSpreadColumn` 루프는 `iCol < _SI.ActiveSheet.Columns.Count` 범위를 돕니다. 시작 인덱스는 **확인 필요**입니다. 0부터 돌면 메타 고정 컬럼까지 숨겨질 수 있습니다.

### 4-4. Search Level 표시 규칙 (`SetLayout`, `if(!_is_detail)`)

| `cboSearchLevel.SelectedIndex` | PRODUCT_LEVEL1 | PRODUCT_LEVEL2 | PRODUCT_LEVEL3 | 줄 |
|---|---|---|---|---|
| 1 | 표시 | 표시 | 숨김 | 1498~1500 |
| 2 | 표시 | 숨김 | 숨김 | 1509~1511 |
| 3 | 숨김 | 표시 | 숨김 | 1518~1520 |
| 4 | 표시 | 표시 | 표시 | 1527~1529 |
| case 라벨 미추출 | 숨김 | 숨김 | 숨김 | 1536~1538 (**확인 필요**) |

- `lciSearchLevel.Enabled = !_is_detail` (`EnableSearchLevel`:1874)
- `SetLayout`을 호출하는 지점은 **확인 필요**입니다.

## 5. 데이터 흐름 표

| 엔드포인트 | SP | 호출 진입점 (핸들러) | 읽기 테이블/객체 | 쓰기 | 결과 반영 |
|---|---|---|---|---|---|
| `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | `SCP0100_GET_SHEET_CALENDAR_3SPAN` | `Form_Load`, `CboPlanDate_SelectedIndexChanged`, `DCalendar_ValueChanged`, `rgrpSearchLevel_SelectedIndexChanged`, `btnMeasure_Click`, `BtnColumn_Click` (모두 InitSpread > GetSpdTitle:1326) | `SCM_SYS_CALENDAR_M` | 없음 | `dsSpdTitle` → 기간 컬럼, 3단 헤더 (REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL) |
| `SCP.SCP0100_GET_SITE` | `SCP0100_GET_SITE` | `SCP0100_Global_PSI_Report_Shown` (RefreshToSite > GetSiteList:1342) | `SCP_RPT_GLOBAL_PSI_MD_MM`, `SCP_RPT_GLOBAL_PSI_MD_WW`, 함수 `FN_SPLITSTRING` | 없음 | `clbToSite` 목록 |
| `SCP.SCP0100_GET_PLAN_DATE` | `SCP0100_GET_PLAN_DATE` | `Form_Load` (InitControls > GetPlanDate:1365) | `SCP_PLAN_VERSION_V`, `SCM_SYS_CALENDAR_M`, `SCP_PLN_INTERFACE_YN`, `SCP_RPT_GLOBAL_PSI_MD_MM`, `SCP_RPT_GLOBAL_PSI_MD_WW`, 함수 `FN_CHAR_TO_DATE`, `FN_SPLITSTRING` | 임시 테이블 `#TMP_PLAN` INSERT/SELECT (영구 테이블 쓰기 없음) | `cboPlanDate` 목록 |
| `biz:CommonData.CommonDataList_REPORT` (code=PLAN_END_DATE) | 없음 (via `Data_REPORT.CallBizCommonData`) | `Form_Load`, `CboPlanDate_SelectedIndexChanged` (SetCalendar > GetDayRange > GetPlanEndDate:2035) | **확인 필요** | **확인 필요** | `dCalendar` 기간 범위 |
| (메인 리포트 조회) | **확인 필요** | **확인 필요** | **확인 필요** | **확인 필요** | 그리드, `chartMain` |

- 메타 원천: `SCM_MST_SHEET_COLUMNS`(33행), `SCM_MST_SHEET_MEASURE`(36행, 시트 `Global PSI New`), `SCM_MST_TITLESET_USER`(526행).
- 주석 처리된 호출(commented_calls): 0건.

## 6. Division·권한별 변형

| 구분 | 사실 | 결론 |
|---|---|---|
| Division 메타 | 14개 Division 전부 REPORT 14/0, SEARCH_LEVEL 8/0, SEARCH_LEVEL_DETAIL 8/0, `Global PSI New` 35/0 (40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) | 같음 |
| Division 최종 컬럼 | REPORT 11 (?3), SEARCH_LEVEL 5 (?3), SEARCH_LEVEL_DETAIL 5 (?3), 전 Division 같음 | 같음 |
| Division 코드 분기 | Division 변수를 비교하는 분기는 추출되지 않음 | Division별 변형 **없음** |
| Division 조건 | `clbDivision`(멀티), `getDivision`:466. 값을 SP에 넘기는 방식은 확인 필요 | 조건 값만 사용 |
| 권한 | `TB_FX_GroupMenuAuth` 4행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 2행. C/R/U/D 값 없음 | **확인 필요** |
| 세션 | `BaseForm.OnShown`:522가 `NowGroupID`, `USER_ID`를 소비 | 프레임워크 공통 |

## 7. 외부 인터페이스

- 사실 묶음에 외부 시스템 인터페이스는 없습니다.
- `SCP_PLN_INTERFACE_YN`(`SCP0100_GET_PLAN_DATE`가 SELECT)은 이름에 인터페이스 여부 플래그가 들어 있어 보이지만, 의미는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 이유 |
|---:|---|---|
| 1 | 메인 조회(Search) 엔드포인트·SP, 차트 데이터 원천 | 추출된 엔드포인트 4개는 모두 초기화·헤더·콤보용 |
| 2 | 각 SP의 파라미터, 분기 조건, 월/주 테이블 선택 조건 | SP 본문 없음 |
| 3 | `biz:CommonData.CommonDataList_REPORT`(PLAN_END_DATE)의 원천 테이블과 계산식 | 사실 묶음에 SP·테이블 없음 |
| 4 | 엔드포인트가 추출되지 않은 핸들러의 동작 | `ClbDivision_SelectedIndexChanged`, `CboGraphType_SelectedIndexChanged`, `CboSearchLevel_SelectedIndexChanged`, `CboUnitQty_SelectedIndexChanged`, `CboPlanType_SelectedIndexChanged`, `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged` |
| 5 | `BtnItemId_Click`, `BtnProject_Click` 팝업의 화면·API | 결과 세팅만 추출됨 |
| 6 | 필수값 검증·메시지 | 추출 없음 |
| 7 | `_bucket_type`, `_plan_start_yyyymm`, `_is_detail`이 결정되는 지점 | 추출 없음 |
| 8 | `SetLayout` 마지막 case 라벨과 호출 지점 | 파서가 case 값을 추출하지 못함 |
| 9 | 권한 C/R/U/D 값, `TB_FX_SearchCondition` 23행 내용 | 행 수만 있음 |
| 10 | `SCM_MST_SHEET_MEASURE` `Global PSI New` 35행과 시트·차트의 연결 | 연결 코드 미추출 |

=== FILE: screen_design.md ===
# SCP0100 Global PSI Report — 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_code.csv, grid_effective.csv)과 1차 분석서만 사용했습니다.
> props.csv는 중간이 잘려 있습니다(약 10KB 미수록). 잘린 부분에 있을 값(Orientation, 일부 LayoutItem Text 등)은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0100 |
| 화면 명칭 | Global PSI Report (클래스 `SCP0100_Global_PSI_Report`) |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행 존재, 값 미수록) |
| 화면 유형 | 조회조건 패널 + 차트/그리드 분할 리포트 |
| 저장 기능 | 추출된 저장 엔드포인트 없음 |
| 소스 | `SCP0100_Global_PSI_Report.cs`(2056줄), `.designer.cs`(1682줄) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
SCP0100_Global_PSI_Report (this)
├─ usrConditionPanel1  [UsrConditionPanel | Dock=Top | Size 1784×102 | UsrPanelType=HidePanel]
│   └─ usrLayoutControl2  [UsrLayoutControl | Dock=Fill | Size 1784×102 | Text "usrLayoutControl2"]
│       └─ layoutControlGroup2  [LayoutControlGroup | Size 1784×102]
│           ├─ 조회조건 컨트롤 21개 (parent=usrLayoutControl2): rgrpSearchLevel, chkCellQty, cboPlanDate,
│           │   cboBucketType, dCalendar, cboGraphType, btnItemId, btnMeasure, txtItemId, cboDisplay,
│           │   txtProject, clbFromSite, clbToSite, txtCellGroup, btnProject, cboPlanType, btnColumn,
│           │   cboSearchLevel, chkAS, cboUnitQty, clbDivision
│           ├─ LayoutControlItem 21개 / EmptySpaceItem 9개 (Location 미추출 → 행·열 순서 확인 필요)
│           └─ ※ 높이 단서: Item 높이 27~32, EmptySpaceItem 높이 59 → 2행 배치로 보이지만 확인 필요
├─ splitContainer1  [SplitContainer | parent=this | Dock·Orientation·Size·기본 SplitterDistance = 확인 필요(props 잘림)]
│   ├─ Panel1
│   │   └─ chartMain  [ChartControl]
│   └─ Panel2  (VisibleSheet가 3개 중 1개만 Visible)
│       ├─ spdSearchLevel        [FpSpread] → 시트 SEARCH_LEVEL        (SheetView spdSearchLevel_Sheet)
│       ├─ spdDetail             [FpSpread] → 시트 REPORT              (SheetView spdMain_Sheet로 보이지만 확인 필요)
│       └─ spdSearchLevelDetail  [FpSpread] → 시트 SEARCH_LEVEL_DETAIL (SheetView spdSearchLevelDetail_Sheet)
└─ usrButton1  [UsrButton | parent 없음 | Size 75×23]  ← 화면 배치 위치 확인 필요
```

### 2-2. 분할 비율

| 대상 | 값 | 비율 % | 비고 |
|---|---|---|---|
| usrConditionPanel1 | 높이 102 (Dock=Top) | 전체 폼 높이 미추출 → **확인 필요** | 접기 가능한 HidePanel |
| splitContainer1 기본 | SplitterDistance 확인 필요 | **확인 필요** | Orientation(상/하·좌/우) 미추출 |
| cboDisplay 변경 시 | SplitterDistance 0 / 750 / 270 (1833 / 1841 / 1849줄) | splitContainer1 전체 크기 미추출 → % 산출 불가 | 0 = Panel1(차트) 크기 0 → 그리드만 표시 |

### 2-3. 영역 구분

| 영역 | 구성 |
|---|---|
| 조회조건 | `usrConditionPanel1` > `usrLayoutControl2`: Division, From/To Site, Plan Date, 기간, Bucket, Plan-type, Model, Project, Cell Group, Search Level, Unit Qty, Graph, Display, Cell Qty, A/S |
| 버튼 | 조건 영역 안: `btnItemId`, `btnProject`(팝업), `btnMeasure`, `btnColumn`(헤더 재구성). `usrButton1`(용도 확인 필요). 툴바 조회 버튼은 BaseForm 소관으로 보이지만 확인 필요 |
| 그리드 | `splitContainer1.Panel2`: `spdSearchLevel` / `spdDetail` / `spdSearchLevelDetail` |
| 차트 | `splitContainer1.Panel1`: `chartMain` |
| 팝업 | Model 팝업(`BtnItemId_Click`), Project 팝업(`BtnProject_Click`). 팝업 화면 ID는 확인 필요 |

## 3. 컨트롤 명세

라벨 열은 props.csv의 Text 원문입니다. 연결된 LayoutControlItem의 Text를 쓰고, 해당 행이 잘린 경우 **확인 필요**로 적었습니다.

| 컨트롤명 | 타입 | 라벨 (Text 원문) | 초기값 / 속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - | Dock=Top, 1784×102, HidePanel | - | - | 공용 조회조건 영역 (접기) |
| usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" (컨트롤 Text) | Dock=Fill, 1784×102 | - | - | 조회조건 Grid 레이아웃 |
| clbDivision | UsrCheckedList2 | 확인 필요 | 179×21 | 확인 필요 | `ClbDivision_SelectedIndexChanged` | Wijmo MultiSelect (공용) |
| clbFromSite | UsrCheckedList2 | "From Site" (layoutControlItem1) | 202×21 | 확인 필요 | - | Wijmo MultiSelect |
| clbToSite | UsrCheckedList2 | "To Site" (lblToSite) | 214×21, 목록=`SCP.SCP0100_GET_SITE` | 확인 필요 | - (Shown에서 채움) | Wijmo MultiSelect |
| cboPlanDate | UsrCombo | 확인 필요 (layoutPlanDate Text 잘림) | 144×20, 목록=`SCP.SCP0100_GET_PLAN_DATE` | 확인 필요 | `CboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| dCalendar | UsrDateRangePicker3 | 확인 필요 (layPeriod 추정, Text 잘림) | 230×22, 범위=PLAN_END_DATE | 확인 필요 | `DCalendar_ValueChanged` | 공용 DateRange |
| cboBucketType | UsrCombo | "Bucket" (lblBucket) | 70×20, 값 MONTHLY / WEEKLY | 확인 필요 | `CboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| cboPlanType | UsrCombo | "Plan-type" (PlanType) | 70×20, **LayoutItem Enabled=false** | 확인 필요 | `CboPlanType_SelectedIndexChanged` | Wijmo ComboBox (비활성) |
| cboGraphType | UsrCombo | "Graph" (lblGraphType) | 60×20 | 확인 필요 | `CboGraphType_SelectedIndexChanged` | Wijmo ComboBox |
| cboDisplay | UsrCombo | "Display" (layDisplay) | 60×20 | 확인 필요 | `CboDisplay_SelectedIndexChanged` | Wijmo ComboBox |
| cboSearchLevel | UsrCombo | 확인 필요 (lciSearchLevel 추정) | 120×20, lciSearchLevel.Enabled=`!_is_detail` | 확인 필요 | `CboSearchLevel_SelectedIndexChanged` | Wijmo ComboBox |
| rgrpSearchLevel | RadioGroup | 확인 필요 | 199×25 | 확인 필요 | `rgrpSearchLevel_SelectedIndexChanged` | Radio 그룹 (hook #154 v2 형태) |
| cboUnitQty | UsrCombo | 확인 필요 (layUnit_qty 추정) | 100×20 | 확인 필요 | `CboUnitQty_SelectedIndexChanged` | Wijmo ComboBox |
| txtItemId | UsrTextBox | "Model / Nick Name" (layModel) | 150×25, 팝업 결과 `sItemId` | 확인 필요 | - | Input + 팝업 |
| btnItemId | UsrButton | "layoutControlItem3" (layoutbtnitem Text 원문, 화면 표시 여부 확인 필요) | 39×25 | - | `BtnItemId_Click` | 팝업 호출 버튼 |
| txtProject | UsrTextBox | "Project" (lblCellGroup) | 150×26, 팝업 결과 `sProjectCode` | 확인 필요 | - | Input + 팝업 |
| btnProject | UsrButton | 확인 필요 (layoutControlItem2 Text 미추출) | 39×25 | - | `BtnProject_Click` | 팝업 호출 버튼 |
| txtCellGroup | UsrTextBox | "Cell Group" (lblCellGroup1) | 111×25 | 확인 필요 | - | Input |
| btnMeasure | UsrButton | 확인 필요 (layMeasure 추정) | 30×25 | - | `btnMeasure_Click` | 버튼 → 헤더 재구성 |
| btnColumn | UsrButton | 확인 필요 (layoutBtnColumn 추정) | 30×25 | - | `BtnColumn_Click` | 버튼 → 헤더 재구성 |
| chkCellQty | UsrCheckBox | "Cell Qty" | **Checked=true, Visible=false**, 80×26 | - | `ChkCellQty_CheckedChanged` | CheckBox (숨김) |
| chkAS | UsrCheckBox | "A/S" | **Visible=false**, 80×25 | - | `ChkAS_CheckedChanged` | CheckBox (숨김) |
| usrButton1 | UsrButton | 확인 필요 | 75×23, parent 없음 | - | 없음 | 확인 필요 (미사용 가능성) |
| splitContainer1 | SplitContainer | - | SplitterDistance 런타임 0/750/270 | - | (cboDisplay) | Split 레이아웃 |
| chartMain | ChartControl | - | Panel1 | - | 확인 필요 | Wijmo FlexChart |
| spdSearchLevel | FpSpread | - | Panel2, 시트 SEARCH_LEVEL | - | - | Wijmo FlexGrid |
| spdDetail | FpSpread | - | Panel2, 시트 REPORT | - | - | Wijmo FlexGrid |
| spdSearchLevelDetail | FpSpread | - | Panel2, 시트 SEARCH_LEVEL_DETAIL | - | - | Wijmo FlexGrid |
| spdMain_Sheet | SheetView | - | designer 94줄 | - | - | (FlexGrid 내부) |
| spdSearchLevel_Sheet | SheetView | - | designer 96줄 | - | - | (FlexGrid 내부) |
| spdSearchLevelDetail_Sheet | SheetView | - | designer 98줄 | - | - | (FlexGrid 내부) |

## 4. 그리드 명세

### 4-0. 시트 생성 (CreateSpread)

| Spread | 시트 | AddSheet 인자 | 줄 |
|---|---|---|---:|
| spdSearchLevel | SEARCH_LEVEL | 3, 1, 30 (헤더 3행. 1·30의 의미는 확인 필요) | 684 |
| spdDetail | REPORT | 3, 1, 30 | 685 |
| spdSearchLevelDetail | SEARCH_LEVEL_DETAIL | 3, 1, 30 | 686 |

- 컬럼 타입과 편집 가능 여부: `SetSheetHeaderColumn`이 `CELL_CONTROL_OBJECT_TYPE_CODE`, `DATA_SCALE_NUMBER` 등을 읽습니다. 하지만 값이 사실 묶음에 없어 META 컬럼의 타입·편집 여부는 **확인 필요**입니다. 저장 기능이 추출되지 않아 읽기 전용으로 보이지만, 이것도 확인 필요입니다.
- Division별 표시: 14개 Division 전부 같습니다(§4-4).

### 4-1. REPORT (spdDetail) — 최종 11 (?3)

| 컬럼 | 헤더 | 타입 | 출처 | Division별 표시 | 편집 |
|---|---|---|---|---|---|
| CELL_CF | Cell Qty | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| CELL_GROUP | Cell Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| DIVISION_ID | Div | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| TO_SITE | To Site | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| INCOTERMS | INCOTERMS | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 전 Div 숨김 | - |
| OPERATION_ID | Operation | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| VARIOUS_KEY | Trans Mode or Line or Project | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| PRODUCT_LEVEL1 | Product Level1 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| PRODUCT_LEVEL2 | Product Level2 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| PRODUCT_LEVEL3 | Product Level3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| D0, D1 | (빈값) | - | CODE_ONLY_CHANGE | → 숨김 (SetVisibleColumnCycle) | - |
| 기간 컬럼 (`*B_*`) | SP COLUMN_LABEL_NAME | Text | HARDCODED 루프(DB_DRIVEN) | 숨김, 폭 0 | - |
| 기간 컬럼 (`M_*` / `W_*`) | SP COLUMN_LABEL_NAME + 3단 헤더 | Num | HARDCODED 루프(DB_DRIVEN) | 폭 70. Bucket에 따라 M_ 또는 W_만 표시 | 확인 필요 |

### 4-2. SEARCH_LEVEL (spdSearchLevel) — 최종 5 (?3)

| 컬럼 | 헤더 | 타입 | 출처 | Division별 표시 | 편집 |
|---|---|---|---|---|---|
| CELL_GROUP | Cell Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| DIVISION_ID | Div | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| OPERATION_GROUP | Operation Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 전 Div 숨김 | - |
| PRODUCT_LEVEL1~3 | Product Level1~3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| D0, D1 | (빈값) | - | CODE_ONLY_CHANGE | → 숨김 | - |
| 기간 컬럼 | SP 결과 | Text / Num | HARDCODED 루프(DB_DRIVEN) | REPORT와 같은 규칙 | 확인 필요 |

### 4-3. SEARCH_LEVEL_DETAIL (spdSearchLevelDetail) — 최종 5 (?3)

컬럼 구성과 규칙은 SEARCH_LEVEL과 같습니다.

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| CELL_GROUP / DIVISION_ID / MEASURE_GROUP / MEASURE_NAME / OPERATION_GROUP | Cell Group / Div / Measure Group / Measure Name / Operation Group | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | META + 코드 | 런타임(?) |
| D0, D1 | - | CODE_ONLY_CHANGE | 숨김 |
| 기간 컬럼 | SP 결과 | DB 루프 | REPORT와 같은 규칙 |

### 4-4. 공통 코드 규칙 (세 시트 공통)

- 3단 헤더:
  - 0행: LARGE_CLASS_LABEL_NAME 병합 (높이 20)
  - 1행: SMALL_CLASS_LABEL_NAME 병합
  - 2행: "Qty"
- 글자색:
  - `M_` 컬럼 중 `_plan_start_yyyymm` 포함 = Red
  - `W_` 컬럼 중 라벨에 "A" 또는 "B" 포함 = Blue
- Bucket 표시: MONTHLY → `M_`만 표시, WEEKLY → `W_`만 표시 (SetSpreadColumn)
- PRODUCT_LEVEL 표시 (`!_is_detail`일 때):

  | cboSearchLevel | L1 | L2 | L3 |
  |---|---|---|---|
  | 1 | O | O | X |
  | 2 | O | X | X |
  | 3 | X | O | X |
  | 4 | O | O | O |
  | case 미추출 | X | X | X |

- 시트 전환 (`VisibleSheet`, 1880~1896줄). 분기 조건은 확인 필요입니다.

  | 블록 | spdDetail | spdSearchLevel | spdSearchLevelDetail |
  |---|---|---|---|
  | 1880~1882 | 표시 | 숨김 | 숨김 |
  | 1888~1889 | (변경 없음) | 숨김 | 표시 |
  | 1893~1896 | 숨김 | 표시 | 숨김 |

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | this.Load | `Form_Load` | InitControls > GetPlanDate | `SCP.SCP0100_GET_PLAN_DATE` | cboPlanDate |
| A2 | this.Load | `Form_Load` | InitControls > SetCalendar > GetDayRange > GetPlanEndDate | `biz:CommonData.CommonDataList_REPORT` | dCalendar |
| A3 | this.Load | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 시트 3개, 헤더 |
| A4 | this.Shown | `SCP0100_Global_PSI_Report_Shown` | InitControlsAfter > RefreshToSite > GetSiteList | `SCP.SCP0100_GET_SITE` | clbToSite |
| A5 | clbDivision 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | 추출 없음 | 확인 필요 |
| A6 | cboGraphType 변경 | `CboGraphType_SelectedIndexChanged` | 확인 필요 (차트 유형 관련 추정) | 추출 없음 | chartMain (확인 필요) |
| A7 | cboPlanDate 변경 | `CboPlanDate_SelectedIndexChanged` | SetCalendar > GetDayRange > GetPlanEndDate. 이어서 InitSpread > GetSpdTitle | `biz:CommonData.CommonDataList_REPORT`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | dCalendar, 헤더 |
| A8 | cboBucketType 변경 | `CboBucketType_SelectedIndexChanged` | `if(_SI != null)` SetSpreadColumn | 없음 | M_/W_ 컬럼 표시 |
| A9 | cboDisplay 변경 | `CboDisplay_SelectedIndexChanged` | SplitterDistance = 0 / 750 / 270 | 없음 | 차트/그리드 분할 |
| A10 | cboSearchLevel 변경 | `CboSearchLevel_SelectedIndexChanged` | 확인 필요 (SetLayout 연관 추정) | 추출 없음 | 확인 필요 |
| A11 | cboUnitQty 변경 | `CboUnitQty_SelectedIndexChanged` | 확인 필요 | 추출 없음 | 확인 필요 |
| A12 | rgrpSearchLevel 변경 | `rgrpSearchLevel_SelectedIndexChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A13 | btnItemId 클릭 | `BtnItemId_Click` | 팝업 → `txtItemId.Text = sItemId` (1947) | 추출 없음 | txtItemId |
| A14 | btnMeasure 클릭 | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A15 | btnProject 클릭 | `BtnProject_Click` | 팝업 → `txtProject.Text = sProjectCode` (1981) | 추출 없음 | txtProject |
| A16 | cboPlanType 변경 | `CboPlanType_SelectedIndexChanged` | 확인 필요 (LayoutItem Enabled=false) | 추출 없음 | 확인 필요 |
| A17 | btnColumn 클릭 | `BtnColumn_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A18 | dCalendar 변경 | `DCalendar_ValueChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A19 | chkCellQty 변경 | `ChkCellQty_CheckedChanged` | 확인 필요 (컨트롤 Visible=false) | 추출 없음 | 확인 필요 |
| A20 | chkAS 변경 | `ChkAS_CheckedChanged` | 확인 필요 (컨트롤 Visible=false) | 추출 없음 | 확인 필요 |
| A21 | 조회(Search) | 확인 필요 | 확인 필요 | 확인 필요 | 그리드·chartMain |

## 6. 검증·메시지

- 필수값 검증 코드와 메시지 ID는 추출되지 않았습니다 → **확인 필요**.
- TO-BE에서 메시지를 정할 때는 AS-IS MSG ID를 그대로 쓰지 않고, 문구로 TO-BE ID를 찾아야 합니다. 문구 원문도 확인 필요입니다.
- 조회 결과 0건, SP 오류일 때 화면이 보이는 반응도 확인 필요입니다.

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | 4행. C/R/U/D 값 **확인 필요** |
| TB_FX_MenuItemInfo / TB_FX_ProgramInfo | 각 1행 |
| TB_FX_Favorite | 2행 |
| 세션 | `BaseForm.OnShown`:522가 NowGroupID, USER_ID 소비 |
| 저장·삭제 | 엔드포인트 없음 |

## 8. To-Be 전환 메모

| 영역 | AS-IS | To-Be |
|---|---|---|
| 그리드 | FarPoint Spread 3개 + VisibleSheet 전환 | Wijmo FlexGrid. 1개 그리드에서 시트를 전환할지, 3개를 둘지는 reference 패턴에 맞춰 결정 |
| 3단 헤더 | ColumnHeaderSpan | FlexGrid columnHeaders 행 추가 + allowMerging |
| 기간 컬럼 | `SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과 루프 | 같은 SP(Oracle)의 결과로 동적 컬럼 생성. B_ 숨김, Num 폭 70, Red/Blue 규칙 유지 |
| Bucket 표시 | SetSpreadColumn (M_/W_) | FE에서 컬럼 visible 토글. 메타 고정 컬럼을 숨기지 않도록 시작 인덱스 확인 필요 |
| 차트 | DevExpress ChartControl | Wijmo FlexChart. 데이터 원천 확인 필요 |
| 분할 | SplitContainer, SplitterDistance 0/750/270 | 비율 기반 레이아웃. px → % 환산은 컨테이너 크기를 확인한 뒤 결정 |
| 조회조건 | UsrLayoutControl | SCP 조회조건 기준표(search_cond.csv, CR-071) 우선 대조 |
| Radio | RadioGroup | hook #154 v2 (좌측 라벨 열 + 입력 열) |
| 숨김 컨트롤 | chkCellQty, chkAS (Visible=false), cboPlanType (비활성) | 동작 유지 여부 확인 필요 |
| Oracle | `#TMP_PLAN` 임시 테이블, `FN_SPLITSTRING`, `FN_CHAR_TO_DATE` | GTT 또는 인라인 처리, 멀티선택 split 함수 대체, MSSQL 키워드 제거 |
| 공통 데이터 | `biz:CommonData.CommonDataList_REPORT` (PLAN_END_DATE) | TO-BE 대체 API 확인 필요 |

## 9. 미확정

1. splitContainer1의 Orientation, Dock, Size, 기본 SplitterDistance (props.csv 잘림)
2. LayoutControlItem Location과 Text: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layAS, layCategoryCC, layoutControlItem2·3·4, layoutPlanDate
3. clbDivision, rgrpSearchLevel 라벨
4. usrButton1 용도 (parent 없음)
5. 메인 조회 엔드포인트·SP, 차트 데이터
6. META 컬럼의 타입·편집 여부, SheetView ↔ Spread 대응(spdMain_Sheet)
7. VisibleSheet 분기 조건, SetLayout 마지막 case 라벨과 호출 지점
8. 핸들러 A5·A6·A10·A11·A16·A19·A20의 실제 동작
9. 권한 C/R/U/D 값과 메뉴 위치

=== FILE: unit_test.md ===
# SCP0100 Global PSI Report — 단위테스트

> 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5, 화면설계서 §5와 같은 원문을 씁니다. 절차 열의 컨트롤명은 화면설계서 §3 컨트롤명 그대로입니다.
> 주석 처리된 호출(commented_calls)은 0건이라 대상이 아닙니다. 사실 묶음에서 동작을 확정할 수 없는 기대결과는 "확인 필요"로 적었습니다. AS-IS로 실측한 뒤 확정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0100-001 | 초기화 | 로그인, SCP0100 메뉴 권한 보유 | 화면을 엽니다 | - | `cboPlanDate`에 계획일자 목록이 채워집니다 | `Form_Load` > GetPlanDate, `SCP.SCP0100_GET_PLAN_DATE`, SP `SCP0100_GET_PLAN_DATE` |
| TC-SCP0100-002 | 초기화 | TC-001 | 화면을 연 뒤 `dCalendar` 범위를 확인합니다 | - | `dCalendar`에 PLAN_END_DATE 기준 기간이 설정됩니다 (계산식 확인 필요) | `Form_Load` > SetCalendar > GetDayRange > GetPlanEndDate, `biz:CommonData.CommonDataList_REPORT` |
| TC-SCP0100-003 | 초기화 | TC-001 | 화면을 연 뒤 그리드 헤더를 확인합니다 | - | 시트 3개가 생성되고, 헤더 3행(대분류 / 소분류 / "Qty") 기간 컬럼이 생성됩니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, SP `SCP0100_GET_SHEET_CALENDAR_3SPAN`, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-004 | 초기화 | 화면 표시 완료 | `clbToSite`를 펼칩니다 | - | To Site 목록이 채워집니다 | `SCP0100_Global_PSI_Report_Shown` > RefreshToSite > GetSiteList, `SCP.SCP0100_GET_SITE`, SP `SCP0100_GET_SITE` |
| TC-SCP0100-005 | 초기화 | 화면 열기 | `chkCellQty`, `chkAS`, `cboPlanType` 상태를 확인합니다 | - | `chkCellQty` Checked=true·숨김, `chkAS` 숨김, `cboPlanType`(Plan-type) 비활성 | props.csv designer 248/284/929/1159, `Form_Load` |
| TC-SCP0100-006 | 조회 | 계획 버전 데이터가 없는 환경 | 화면을 엽니다 | - | `cboPlanDate`가 빈 목록입니다. 이후 동작(오류 메시지 여부)은 확인 필요 | `SCP.SCP0100_GET_PLAN_DATE` (빈 결과) |
| TC-SCP0100-007 | 조회 | `SCP_RPT_GLOBAL_PSI_MD_MM` / `_WW`에 대상 데이터 없음 | 화면을 연 뒤 `clbToSite`를 확인합니다 | - | `clbToSite` 빈 목록, 오류 없음 (확인 필요) | `SCP.SCP0100_GET_SITE` (빈 결과), `SCP0100_Global_PSI_Report_Shown` |
| TC-SCP0100-008 | 조회 | 캘린더(`SCM_SYS_CALENDAR_M`)에 기간 데이터 없음 | `dCalendar`를 범위 밖 기간으로 바꿉니다 | 범위 밖 기간 | 기간 컬럼이 생성되지 않고 메타 고정 컬럼만 남습니다 (확인 필요) | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` (빈 결과), `DCalendar_ValueChanged` |
| TC-SCP0100-009 | 조회 | SP 오류를 유도 (권한 회수 등) | 화면을 엽니다 | - | 오류 응답을 처리하고 화면이 비정상 종료되지 않습니다. 메시지 문구는 확인 필요 | `SCP.SCP0100_GET_PLAN_DATE`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` (오류 응답) |
| TC-SCP0100-010 | 조회 | 공통 데이터 PLAN_END_DATE 미등록 | 화면을 엽니다 | - | `dCalendar` 기본 범위 처리 (확인 필요), 오류로 중단되지 않음 | `biz:CommonData.CommonDataList_REPORT` (빈 결과) |
| TC-SCP0100-011 | 이벤트 | 화면 표시 완료 | `clbDivision`에서 체크를 바꿉니다 | Division 1개 해제 | 핸들러가 실행됩니다. 후속 동작(연관 목록 갱신 등)은 확인 필요 | `ClbDivision_SelectedIndexChanged` |
| TC-SCP0100-012 | 이벤트 | 화면 표시 완료 | `cboGraphType` 값을 바꿉니다 | 다른 항목 | 핸들러가 실행됩니다. `chartMain` 반영은 확인 필요 | `CboGraphType_SelectedIndexChanged` |
| TC-SCP0100-013 | 이벤트 | 계획일자 2건 이상 | `cboPlanDate`를 다른 값으로 바꿉니다 | 두 번째 계획일자 | `dCalendar` 범위를 다시 계산하고 그리드 기간 헤더를 다시 만듭니다 | `CboPlanDate_SelectedIndexChanged`, `biz:CommonData.CommonDataList_REPORT`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-014 | 이벤트 | 그리드 생성 완료 | `cboBucketType`을 MONTHLY로 바꿉니다 | MONTHLY | `M_` 컬럼만 표시되고 `W_` 컬럼은 숨겨집니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn(1103/1107), 시트 REPORT |
| TC-SCP0100-015 | 이벤트 | 그리드 생성 완료 | `cboBucketType`을 WEEKLY로 바꿉니다 | WEEKLY | `W_` 컬럼만 표시되고 `M_` 컬럼은 숨겨집니다. 메타 고정 컬럼 유지 여부도 확인합니다 (시작 인덱스 확인 필요) | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn(1114/1118) |
| TC-SCP0100-016 | 이벤트 | 화면 표시 완료 | `cboDisplay`를 각 항목으로 차례로 바꿉니다 | 항목 3개 | `splitContainer1.SplitterDistance`가 0 / 750 / 270으로 바뀝니다. 0이면 `chartMain` 영역이 0이 됩니다 (항목↔값 대응 확인 필요) | `CboDisplay_SelectedIndexChanged` (1833/1841/1849) |
| TC-SCP0100-017 | 이벤트 | 화면 표시 완료 | `cboSearchLevel` 값을 바꿉니다 | Index 1~4 | 핸들러가 실행됩니다. PRODUCT_LEVEL 표시(SetLayout)를 이 핸들러가 호출하는지는 확인 필요 | `CboSearchLevel_SelectedIndexChanged` |
| TC-SCP0100-018 | 이벤트 | 화면 표시 완료 | `cboUnitQty` 값을 바꿉니다 | 다른 단위 | 핸들러가 실행됩니다. 수량 단위 반영은 확인 필요 | `CboUnitQty_SelectedIndexChanged` |
| TC-SCP0100-019 | 이벤트 | 화면 표시 완료 | `rgrpSearchLevel` 선택을 바꿉니다 | 다른 라디오 | 그리드 헤더를 다시 만듭니다 | `rgrpSearchLevel_SelectedIndexChanged`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-020 | 이벤트 | 화면 표시 완료 | `btnItemId`를 클릭하고 팝업에서 Model을 선택합니다 | 임의 Model | `txtItemId`에 선택값(`sItemId`)이 들어갑니다 | `BtnItemId_Click` (1947) |
| TC-SCP0100-021 | 이벤트 | TC-020 | 팝업에서 선택 없이 닫습니다 | 취소 | `txtItemId`가 바뀌지 않습니다 (확인 필요) | `BtnItemId_Click` |
| TC-SCP0100-022 | 이벤트 | 화면 표시 완료 | `btnMeasure`를 클릭합니다 | - | 그리드 헤더를 다시 만듭니다 (Measure 선택 UI는 확인 필요) | `btnMeasure_Click`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-023 | 이벤트 | 화면 표시 완료 | `btnProject`를 클릭하고 팝업에서 Project를 선택합니다 | 임의 Project | `txtProject`에 선택값(`sProjectCode`)이 들어갑니다 | `BtnProject_Click` (1981) |
| TC-SCP0100-024 | 이벤트 | 화면 표시 완료 | `cboPlanType` 조작을 시도합니다 | - | LayoutItem Enabled=false 상태라 사용자가 바꿀 수 없습니다. 코드로 값이 바뀔 때의 핸들러 동작은 확인 필요 | `CboPlanType_SelectedIndexChanged` |
| TC-SCP0100-025 | 이벤트 | 화면 표시 완료 | `btnColumn`을 클릭합니다 | - | 그리드 헤더를 다시 만듭니다 | `BtnColumn_Click`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-026 | 이벤트 | 화면 표시 완료 | `dCalendar` 기간을 바꿉니다 | 시작/종료일 변경 | 바뀐 기간으로 기간 컬럼을 다시 만듭니다 | `DCalendar_ValueChanged`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-027 | 이벤트 | `chkCellQty` 숨김 상태 | 코드·테스트 하네스로 `chkCellQty` 체크를 바꿉니다 | Checked=false | 핸들러가 실행됩니다. 동작은 확인 필요 (사용자 화면에는 노출되지 않음) | `ChkCellQty_CheckedChanged` |
| TC-SCP0100-028 | 이벤트 | `chkAS` 숨김 상태 | 코드·테스트 하네스로 `chkAS` 체크를 바꿉니다 | Checked=true | 핸들러가 실행됩니다. 동작은 확인 필요 | `ChkAS_CheckedChanged` |
| TC-SCP0100-029 | 그리드 | `spdDetail` 표시 상태 | REPORT 시트 컬럼을 확인합니다 | Division 40 | 표시: CELL_CF, CELL_GROUP, DIVISION_ID, FROM_SITE, TO_SITE, INCOTERMS, ITEM_ID, MEASURE_GROUP, MEASURE_NAME, OPERATION_ID, VARIOUS_KEY (11) + PRODUCT_LEVEL1~3 (런타임). 숨김: MEASURE_UI, D0, D1 | 시트 REPORT, `SetSheetHeaderColumn`, grid_effective.csv |
| TC-SCP0100-030 | 그리드 | `spdSearchLevel` 표시 상태 | SEARCH_LEVEL 시트 컬럼을 확인합니다 | Division 40 | 표시: CELL_GROUP, DIVISION_ID, MEASURE_GROUP, MEASURE_NAME, OPERATION_GROUP (5) + PRODUCT_LEVEL1~3. 숨김: MEASURE_UI, D0, D1 | 시트 SEARCH_LEVEL |
| TC-SCP0100-031 | 그리드 | `spdSearchLevelDetail` 표시 상태 | SEARCH_LEVEL_DETAIL 시트 컬럼을 확인합니다 | Division 40 | SEARCH_LEVEL과 같은 5개 + PRODUCT_LEVEL1~3. 숨김: MEASURE_UI, D0, D1 | 시트 SEARCH_LEVEL_DETAIL |
| TC-SCP0100-032 | 그리드 | 기간 컬럼 생성 완료 | 기간 컬럼 속성을 확인합니다 | - | `B_`를 포함(0번째 위치 아님)한 컬럼은 Text·폭 0·숨김, 나머지는 Num·폭 70·표시. 헤더 2행은 "Qty" | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, InitSpreadDateColumn 755/760/787~816, 시트 REPORT |
| TC-SCP0100-033 | 그리드 | MONTHLY / WEEKLY 각각 헤더 생성 | 글자색을 확인합니다 | 계획 시작월 포함 | `M_` + `_plan_start_yyyymm` 포함 컬럼 = Red, `W_` + 라벨 "A" 또는 "B" 포함 컬럼 = Blue | InitSpreadDateColumn 767/774/778, `CboBucketType_SelectedIndexChanged` |
| TC-SCP0100-034 | 그리드 | `_is_detail`=false | `cboSearchLevel` Index를 1, 2, 3, 4로 바꿔 가며 PRODUCT_LEVEL 표시를 확인합니다 | 1 / 2 / 3 / 4 | 1: L1·L2 표시, L3 숨김 / 2: L1만 표시 / 3: L2만 표시 / 4: 모두 표시 | SetLayout 1498~1529, `CboSearchLevel_SelectedIndexChanged`(호출 연결은 확인 필요), 시트 SEARCH_LEVEL |
| TC-SCP0100-035 | 그리드 | `_is_detail`=false | `cboSearchLevel`을 Index 1~4 외의 값으로 둡니다 | 0 등 | PRODUCT_LEVEL1~3 모두 숨김 (case 라벨 확인 필요) | SetLayout 1536~1538 |
| TC-SCP0100-036 | 그리드 | 상세 모드 (`_is_detail`=true) | Search Level 영역과 시트 전환을 확인합니다 | - | `lciSearchLevel` 비활성. VisibleSheet로 `spdDetail` / `spdSearchLevel` / `spdSearchLevelDetail` 중 1개만 표시 (전환 조건은 확인 필요) | EnableSearchLevel 1874, VisibleSheet 1880~1896, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-037 | division | Division 40 사용자 | 화면을 열고 세 시트 컬럼 수를 확인합니다 | Division 40 | REPORT 11(+3), SEARCH_LEVEL 5(+3), SEARCH_LEVEL_DETAIL 5(+3) | grid_effective.csv, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-038 | division | Division 81 사용자 | TC-037과 같은 절차 | Division 81 | TC-037과 같음 (Division별 변형 없음) | grid_effective.csv, `ClbDivision_SelectedIndexChanged` |
| TC-SCP0100-039 | division | Division EE 사용자 | TC-037과 같은 절차 | Division EE | TC-037과 같음 | grid_effective.csv |
| TC-SCP0100-040 | 권한 | `TB_FX_GroupMenuAuth` 4행 기준 그룹 사용자 | 화면을 열고 공통 버튼 노출을 확인합니다 | 권한 그룹별 | 권한 값에 맞게 버튼이 노출됩니다 (C/R/U/D 값 확인 필요) | `SCP0100_Global_PSI_Report_Shown` (BaseForm.OnShown NowGroupID, USER_ID) |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 18 | `Form_Load` | 001~003, 005 |
| | `SCP0100_Global_PSI_Report_Shown` | 004, 007, 040 |
| | `ClbDivision_SelectedIndexChanged` | 011, 038 |
| | `CboGraphType_SelectedIndexChanged` | 012 |
| | `CboPlanDate_SelectedIndexChanged` | 013 |
| | `CboBucketType_SelectedIndexChanged` | 014, 015, 033 |
| | `CboDisplay_SelectedIndexChanged` | 016 |
| | `CboSearchLevel_SelectedIndexChanged` | 017, 034 |
| | `CboUnitQty_SelectedIndexChanged` | 018 |
| | `rgrpSearchLevel_SelectedIndexChanged` | 019 |
| | `BtnItemId_Click` | 020, 021 |
| | `btnMeasure_Click` | 022 |
| | `BtnProject_Click` | 023 |
| | `CboPlanType_SelectedIndexChanged` | 024 |
| | `BtnColumn_Click` | 025 |
| | `DCalendar_ValueChanged` | 008, 026 |
| | `ChkCellQty_CheckedChanged` | 027 |
| | `ChkAS_CheckedChanged` | 028 |
| 엔드포인트 4 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 003, 008, 009, 013, 019, 022, 025, 026, 032 |
| | `SCP.SCP0100_GET_SITE` | 004, 007 |
| | `SCP.SCP0100_GET_PLAN_DATE` | 001, 006, 009 |
| | `biz:CommonData.CommonDataList_REPORT` | 002, 010, 013 |
| 시트 3 | REPORT | 029, 032, 036, 037 |
| | SEARCH_LEVEL | 030, 034, 036, 037 |
| | SEARCH_LEVEL_DETAIL | 031, 036, 037 |
| 빈 결과 / 오류 | | 006, 007, 008, 010 / 009 |
| 미포함 | 메인 조회(Search) | 엔드포인트가 추출되지 않아 TC를 만들지 않았습니다 (확인 필요) |
