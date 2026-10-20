=== FILE: business_analysis.md ===
# SCP0100 Global PSI Report — 업무분석서

> **근거 범위**: AsisFacts 정적 추출 Fact Pack(SCP0100)과 1차 분석서만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 **0건**입니다. 아래 내용은 모두 활성 코드 기준입니다.
> 엔드포인트 이름은 화면설계서 §5와 단위테스트 '근거' 열에서 같은 표기를 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 |
|---|---|
| 화면 ID / 클래스 | SCP0100 / `SCP0100_Global_PSI_Report` |
| 도메인 | SCP. 소스 경로는 `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\` |
| 화면 성격 | 조회(Report) 화면입니다. 구성은 차트(`chartMain`) 1개와 FarPoint Spread 3개(`spdSearchLevel`, `spdDetail`, `spdSearchLevelDetail`)입니다. |
| 사실로 확인된 범위 | ① Plan Date 목록 조회 ② To Site 목록 조회 ③ 기간 헤더(캘린더 3SPAN) 조회와 그리드 동적 컬럼 구성 ④ 계획 종료일(PLAN_END_DATE) 공통 데이터 조회 ⑤ Bucket·Search Level·Display에 따른 화면 표시 전환 |
| 저장·삭제 | 저장·삭제 엔드포인트는 추출되지 않았습니다. 조회 전용으로 보이지만 **확인 필요**입니다. |
| 업무 목적 문장 | "Global PSI(생산·판매·재고) 리포트"라는 명칭 외에 업무 목적을 정의한 사실은 없습니다. **확인 필요** |
| ⚠ 메인 데이터 조회 | 리포트 본문(시트 3개)과 차트 데이터를 채우는 엔드포인트가 **검출되지 않았습니다**. **최우선 확인 필요** |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드 경로) | 엔드포인트 | 결과 |
|---:|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 시트 3개(SEARCH_LEVEL, REPORT, SEARCH_LEVEL_DETAIL)를 만들고 메타 컬럼과 기간 컬럼을 구성합니다 |
| S2 | (화면 열기, 같은 흐름) | `Form_Load` > InitControls > GetPlanDate | `SCP.SCP0100_GET_PLAN_DATE` | cboPlanDate 목록을 채웁니다(바인딩 상세는 확인 필요) |
| S3 | (화면 열기, 같은 흐름) | `Form_Load` > InitControls > SetCalendar > GetDayRange > GetPlanEndDate | `biz:CommonData.CommonDataList_REPORT` [code=Data_REPORT.Type.PLAN_END_DATE] | dCalendar 기간 범위를 설정합니다(정확한 계산식은 확인 필요) |
| S4 | 화면이 표시된 직후 | `SCP0100_Global_PSI_Report_Shown` > InitControlsAfter > RefreshToSite > GetSiteList | `SCP.SCP0100_GET_SITE` | clbToSite 목록을 채웁니다 |
| S5 | Plan Date를 바꿉니다 | `CboPlanDate_SelectedIndexChanged` > InitSpread > GetSpdTitle, 그리고 > SetCalendar > GetDayRange > GetPlanEndDate | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.CommonDataList_REPORT` | 기간 헤더를 다시 만들고 기간 범위를 다시 계산합니다 |
| S6 | 기간(dCalendar)을 바꿉니다 | `DCalendar_ValueChanged` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 기간 헤더를 다시 만듭니다 |
| S7 | Search Level 라디오를 바꿉니다 | `rgrpSearchLevel_SelectedIndexChanged` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더를 다시 만듭니다. 시트 전환과의 관계는 확인 필요 |
| S8 | Measure 버튼을 누릅니다 | `btnMeasure_Click` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더를 다시 만듭니다. 메저 선택 UI는 확인 필요 |
| S9 | Column 버튼을 누릅니다 | `BtnColumn_Click` > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더를 다시 만듭니다. 컬럼 선택 UI는 확인 필요 |
| S10 | Bucket을 바꿉니다 | `CboBucketType_SelectedIndexChanged` > `if(_SI != null)` SetSpreadColumn (:1804) | 없음 | MONTHLY이면 `M_*` 컬럼, WEEKLY이면 `W_*` 컬럼만 보입니다 |
| S11 | Display를 바꿉니다 | `CboDisplay_SelectedIndexChanged` | 없음 | splitContainer1.SplitterDistance가 0(:1833), 750(:1841), 270(:1849) 중 하나로 바뀝니다. 값별 대응은 확인 필요 |
| S12 | Model 팝업 버튼을 누릅니다 | `BtnItemId_Click` | 없음 | `txtItemId.Text = sItemId`(:1947). 호출하는 팝업 화면은 확인 필요 |
| S13 | Project 팝업 버튼을 누릅니다 | `BtnProject_Click` | 없음 | `txtProject.Text = sProjectCode`(:1981). 호출하는 팝업 화면은 확인 필요 |
| S14 | Division / Graph / Search Level 콤보 / Unit Qty / Plan-type / Cell Qty / A/S를 바꿉니다 | `ClbDivision_SelectedIndexChanged`, `CboGraphType_SelectedIndexChanged`, `CboSearchLevel_SelectedIndexChanged`, `CboUnitQty_SelectedIndexChanged`, `CboPlanType_SelectedIndexChanged`, `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged` | 없음 | 내부 동작은 **확인 필요** |
| S15 | 조회(본문·차트 데이터) | 미식별 | 미식별 | **확인 필요** |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 열기 (this.Load → Form_Load)
    ├─ CreateSpread
    │    ├─ AddSheet: spdSearchLevel=SEARCH_LEVEL(:684) / spdDetail=REPORT(:685) / spdSearchLevelDetail=SEARCH_LEVEL_DETAIL(:686)
    │    ├─ GetSheetInfo ×3 (:688~690), ChangeSheet ×2 (:692, :693)
    │    └─ InitSpread
    │         ├─ InitSheet(_SI.SheetName) :702
    │         ├─ GetSpdTitle :703 ──► SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN (:1326)
    │         ├─ SetSheetHeaderColumn(_SI, 3) :705   (SCM_MST_SHEET_COLUMNS 메타, 헤더 3행)
    │         ├─ InitSpreadDateColumn :706           (3SPAN 결과 행을 돌며 기간 컬럼 추가)
    │         └─ SetSpreadColumn :708                (Bucket 기준 M_/W_ 표시 전환)
    └─ InitControls
         ├─ GetPlanDate ──► SCP.SCP0100_GET_PLAN_DATE (:1365)
         └─ SetCalendar > GetDayRange > GetPlanEndDate ──► biz:CommonData.CommonDataList_REPORT (:2035)
[2] 화면 표시 (this.Shown → SCP0100_Global_PSI_Report_Shown)
    └─ InitControlsAfter > RefreshToSite > GetSiteList ──► SCP.SCP0100_GET_SITE (:1342)
[3] 조건 변경
    ├─ cboPlanDate 변경 ──► [InitSpread → 3SPAN] + [SetCalendar → CommonDataList_REPORT]
    ├─ dCalendar / rgrpSearchLevel 변경, btnMeasure / btnColumn 클릭 ──► [InitSpread → 3SPAN]
    ├─ cboBucketType 변경 ──► SetSpreadColumn (API 없음)
    └─ cboDisplay 변경 ──► SplitterDistance 0/750/270 (API 없음)
[4] 조회 실행 ──► 엔드포인트 미식별 (확인 필요)
[5] 결과 표시 ──► VisibleSheet: 시트 3개 중 하나만 Visible (전환 조건은 확인 필요)
```

## 4. 업무 규칙 (사실 근거)

### 4-1. 조회조건 값 수집

| 규칙 | 근거 |
|---|---|
| Plan Start(YYYYMMDD), From Site, To Site, Plan-type, Search Level, Division 값을 `CString.GetCheckedListValue`(메타 컬럼 CODE)로 수집합니다 | getPlanStartYYYYMMDD:215, getFromSite:306, getToSite:325, getPlanType:344, getSearchLevel:412, getDivision:466 |
| 세션의 NowGroupID와 USER_ID를 사용합니다 | BaseForm.OnShown:522 |
| 필수 입력값 | 필수값 검증 코드는 추출되지 않았습니다. **확인 필요** |
| SP 입력 파라미터 | 엔드포인트별 파라미터 목록이 추출되지 않았습니다. **확인 필요** |

### 4-2. 날짜·버킷 규칙

| # | 규칙 | 근거 |
|---:|---|---|
| R1 | 기간 컬럼의 원천은 `SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과 행입니다. 사용하는 열은 COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME입니다 | InitSpreadDateColumn:706, SCM_SYS_CALENDAR_M SELECT |
| R2 | `COLUMN_NAME.IndexOf("B_") > 0`이면 텍스트 컬럼(폭 0, 숨김)으로 만듭니다 | :755 |
| R3 | R2가 아니면 숫자 컬럼(폭 70, 표시)으로 만듭니다 | :760 |
| R4 | `M_`로 시작하고 `_plan_start_yyyymm`을 포함하면 글자색을 빨강으로 합니다 | :767 |
| R5 | `W_`로 시작하고 라벨에 "A" 또는 "B"가 있으면 글자색을 파랑으로 합니다 | :774, :778 |
| R6 | 헤더 병합: 0행은 LARGE_CLASS_LABEL_NAME, 1행은 SMALL_CLASS_LABEL_NAME, 2행 등은 고정 문자열 "Qty"입니다 | :787~816 |
| R7 | Bucket이 "MONTHLY"이면 `M_`로 시작하는 컬럼만 표시하고 나머지는 숨깁니다 | SetSpreadColumn :1103/:1107 |
| R8 | Bucket이 "WEEKLY"이면 `W_`로 시작하는 컬럼만 표시하고 나머지는 숨깁니다 | SetSpreadColumn :1114/:1118 |
| R9 | R7·R8 루프는 `iCol < Columns.Count` 전체를 대상으로 합니다. 시작 인덱스(고정 메타 컬럼도 숨기는지)는 **확인 필요**입니다 | :1103~1118 |
| R10 | D0, D1 컬럼은 숨깁니다 | SetVisibleColumnCycle :1290 |
| R11 | 계획 종료일은 공통 데이터 코드 PLAN_END_DATE로 조회합니다(Biz 경유). 원천 테이블은 **확인 필요** | GetPlanEndDate:2035 |

### 4-3. SP 분기 조건

| SP | 분기 조건 |
|---|---|
| SCP0100_GET_PLAN_DATE | 참조 객체(SCP_PLAN_VERSION_V, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM / _WW, #TMP_PLAN)만 추출되었습니다. 내부 분기(예: MM/WW 선택 조건)는 **확인 필요** |
| SCP0100_GET_SITE | SCP_RPT_GLOBAL_PSI_MD_MM / _WW와 FN_SPLITSTRING 참조만 추출되었습니다. 분기는 **확인 필요** |
| SCP0100_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M 참조만 추출되었습니다. 분기는 **확인 필요** |

### 4-4. 표시 규칙

| # | 규칙 | 근거 |
|---:|---|---|
| R12 | `!_is_detail`일 때 cboSearchLevel.SelectedIndex에 따라 PRODUCT_LEVEL1~3을 표시합니다 → 1: L1·L2 / 2: L1 / 3: L2 / 4: L1·L2·L3 / 나머지 case(라벨 미추출): 모두 숨김 | SetLayout :1498~1538 |
| R13 | `lciSearchLevel.Enabled = !_is_detail` | EnableSearchLevel :1874 |
| R14 | spdSearchLevel, spdDetail, spdSearchLevelDetail 중 하나만 Visible입니다. 전환 조건은 **확인 필요** | VisibleSheet :1880~1896 |
| R15 | Plan-type LayoutItem(`PlanType`)은 Enabled=false입니다 | designer:1159 |
| R16 | chkCellQty(Checked=true)와 chkAS는 Visible=false입니다 | designer:248/284, :929 |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 메서드:줄 | 읽기 | 쓰기 | 함수 참조 | 호출 핸들러 |
|---|---|---|---|---|---|---|
| `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | SCP0100_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle:1326 | SCM_SYS_CALENDAR_M | 없음 | — | Form_Load, CboPlanDate_SelectedIndexChanged, DCalendar_ValueChanged, rgrpSearchLevel_SelectedIndexChanged, BtnColumn_Click, btnMeasure_Click |
| `SCP.SCP0100_GET_SITE` | SCP0100_GET_SITE | GetSiteList:1342 | SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW | 없음 | FN_SPLITSTRING | SCP0100_Global_PSI_Report_Shown |
| `SCP.SCP0100_GET_PLAN_DATE` | SCP0100_GET_PLAN_DATE | GetPlanDate:1365 | SCP_PLAN_VERSION_V, SCM_SYS_CALENDAR_M, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW, #TMP_PLAN | #TMP_PLAN(임시 테이블 INSERT, 영구 테이블 쓰기 없음) | FN_CHAR_TO_DATE, FN_SPLITSTRING | Form_Load |
| `biz:CommonData.CommonDataList_REPORT` [code=Data_REPORT.Type.PLAN_END_DATE] | 미식별(Biz 경유 `Data_REPORT.CallBizCommonData`) | GetPlanEndDate:2035 | **확인 필요** | 없음(추출 기준) | — | Form_Load, CboPlanDate_SelectedIndexChanged |
| (메인 본문·차트 조회) | **미식별** | — | — | — | — | **확인 필요** |

메타 읽기(프레임워크): SCM_MST_SHEET_COLUMNS(SetSheetHeaderColumn)와 SCM_MST_SHEET_MEASURE(`Global PSI New` 35행)입니다.

## 6. division·권한별 변형

| 구분 | 사실 |
|---|---|
| division 메타 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. REPORT 14/0, SEARCH_LEVEL 8/0, SEARCH_LEVEL_DETAIL 8/0, MEASURE `Global PSI New` 35/0 |
| 최종 표시 | REPORT 11 (?3), SEARCH_LEVEL 5 (?3), SEARCH_LEVEL_DETAIL 5 (?3). `?3`은 PRODUCT_LEVEL1~3으로, 실행 시점의 cboSearchLevel 값에 따라 정해집니다 |
| division 코드 분기 | 없습니다. 코드에 division 변수 비교가 추출되지 않았습니다 |
| division 조회조건 | clbDivision(멀티 선택)의 값을 getDivision:466으로 수집합니다. SP 전달 여부는 확인 필요 |
| 권한 | TB_FX_GroupMenuAuth에 4행이 있습니다. 그룹별 C/R/U/D 값은 **확인 필요**(dbmeta CSV) |
| 기타 메타 | TB_FX_MenuItemInfo 1, TB_FX_ProgramInfo 1, TB_FX_Favorite 2, TB_FX_SearchCondition 23, SCM_MST_TITLESET_USER 526 |

## 7. 외부 인터페이스

- 외부 시스템 연계 호출은 Fact Pack에서 추출되지 않았습니다.
- `SCP0100_GET_PLAN_DATE`가 SCP_PLN_INTERFACE_YN 테이블을 읽는다는 사실만 있습니다. 이 테이블의 업무 의미는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 |
|---:|---|
| 1 | 메인 데이터(시트 3개 본문, 차트) 조회 엔드포인트와 SP |
| 2 | `biz:CommonData.CommonDataList_REPORT` PLAN_END_DATE의 원천 테이블과 반환값 형식 |
| 3 | 엔드포인트별 SP 입력 파라미터와 조회조건 매핑 |
| 4 | ClbDivision, CboGraphType, CboSearchLevel, CboUnitQty, CboPlanType, ChkCellQty, ChkAS 핸들러의 내부 동작 |
| 5 | CboDisplay 값과 SplitterDistance 0/750/270의 대응 |
| 6 | `_is_detail` 결정 조건과 VisibleSheet 전환 규칙 |
| 7 | SetSpreadColumn 루프 시작 인덱스 |
| 8 | SetLayout 마지막 case 값 |
| 9 | Model / Project 팝업 화면 ID |
| 10 | 필수값 검증과 메시지 |
| 11 | TB_FX_GroupMenuAuth 그룹별 C/R/U/D 값 |
| 12 | SP 내부 분기(MM/WW 테이블 선택 조건 등) |

=== FILE: screen_design.md ===
# SCP0100 Global PSI Report — 화면설계서

> **근거 범위**: Fact Pack의 controls.csv, props.csv, events.csv, grid_code.csv, grid_effective.csv와 1차 분석서만 사용했습니다.
> props.csv는 뒷부분 약 10KB가 잘렸습니다. 그 범위에 있는 라벨과 SplitContainer 속성은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건입니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0100 |
| 명칭 | Global PSI Report (클래스 `SCP0100_Global_PSI_Report`) |
| 메뉴 위치 | **확인 필요**. TB_FX_MenuItemInfo에 1행이 있으나 값은 dbmeta CSV를 봐야 합니다 |
| 유형 | 조회(Report). 차트 + Spread 3개(한 번에 하나만 표시) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) |
| 컨트롤 수 | 63개(controls.csv) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
this (SCP0100_Global_PSI_Report)
├─[Dock=Top] usrConditionPanel1  (UsrConditionPanel, Size 1784×102, UsrPanelType=HidePanel → 접기 가능)
│   └─[Dock=Fill] usrLayoutControl2  (UsrLayoutControl, Size 1784×102, Text "usrLayoutControl2")
│        └─ layoutControlGroup2 (Size 1784×102) ── 조회조건 컨트롤 22개
│             rgrpSearchLevel, chkCellQty, cboPlanDate, cboBucketType, dCalendar, cboGraphType,
│             btnItemId, btnMeasure, txtItemId, cboDisplay, txtProject, clbFromSite, clbToSite,
│             txtCellGroup, btnProject, cboPlanType, btnColumn, cboSearchLevel, chkAS,
│             cboUnitQty, clbDivision  (+ EmptySpaceItem 9개)
│
└─[나머지 영역] splitContainer1  (SplitContainer, parent=this)
     │   Orientation      : 확인 필요 (props.csv 잘린 범위)
     │   SplitterDistance : 초기값 확인 필요 / 실행 중 0·750·270 (CboDisplay_SelectedIndexChanged)
     │   Size             : 확인 필요
     ├─ Panel1 : chartMain (DevExpress ChartControl)                     ← 차트 영역
     └─ Panel2 : 그리드 3개 겹침 (VisibleSheet로 하나만 Visible)        ← 그리드 영역
          ├─ spdSearchLevel        (시트 SEARCH_LEVEL)
          ├─ spdDetail             (시트 REPORT)
          └─ spdSearchLevelDetail  (시트 SEARCH_LEVEL_DETAIL)

(parent 없음) usrButton1 (UsrButton, Size 75×23) ── 배치 위치·사용 여부 확인 필요
(parent 없음) SheetView 3개: spdMain_Sheet, spdSearchLevel_Sheet, spdSearchLevelDetail_Sheet
```

### 2-2. 비율

| 분할 | 값 | 비율 % |
|---|---|---|
| 조회조건 / 본문 | 조회조건 높이 102px(Dock=Top). 본문은 나머지 | 폼 전체 높이가 없어 **확인 필요** |
| splitContainer1 Panel1 / Panel2 | SplitterDistance 0 / 750 / 270(실행 중) | Orientation·Size가 없어 **확인 필요**. 0이면 Panel1(차트) 폭 또는 높이가 0입니다 |

### 2-3. 텍스트 와이어프레임

```
┌──────────────────────────────────────────── 1784 ────────────────────────────────────────────┐
│ [조회조건 usrConditionPanel1 · 높이 102 · 접기 가능]                                          │
│ Model / Nick Name [txtItemId][btnItemId]  From Site [clbFromSite▼]  To Site [clbToSite▼]       │
│ Cell Group [txtCellGroup]  Project [txtProject][btnProject]  Bucket [cboBucketType▼]           │
│ Plan-type [cboPlanType▼](비활성)  Display [cboDisplay▼]  Graph [cboGraphType▼]                 │
│ (라벨 확인 필요) [cboPlanDate▼] [dCalendar From~To] [btnMeasure] [btnColumn] [cboUnitQty▼]      │
│ (라벨 확인 필요) [cboSearchLevel▼] (rgrpSearchLevel ◯◯) [clbDivision▼]                          │
│ (숨김) chkCellQty "Cell Qty" / chkAS "A/S"                                                      │
│ ※ 행 배치 순서는 LayoutItem Location 미추출로 확인 필요                                        │
├───────────────────────────────────────────────────────────────────────────────────────────────┤
│ splitContainer1 (Orientation 확인 필요)                                                        │
│ ┌ Panel1 ───────────────────────────────┐┌ Panel2 ─────────────────────────────────────────┐  │
│ │ chartMain (차트)                       ││ spdSearchLevel / spdDetail / spdSearchLevelDetail│  │
│ │                                        ││ (한 번에 하나만 Visible)                         │  │
│ └────────────────────────────────────────┘└─────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 2-4. 영역

| 영역 | 구성 |
|---|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl2 아래의 컨트롤 |
| 버튼 | btnItemId, btnProject(팝업), btnMeasure, btnColumn(헤더 재구성). 공통 툴바(조회 등)는 BaseForm 제공으로 보이며 **확인 필요** |
| 그리드 | splitContainer1.Panel2의 spdSearchLevel, spdDetail, spdSearchLevelDetail |
| 차트 | splitContainer1.Panel1의 chartMain |
| 팝업 | BtnItemId_Click(Model), BtnProject_Click(Project). 팝업 화면 ID는 확인 필요 |

## 3. 컨트롤 명세

라벨은 props.csv의 Text 원문입니다. LayoutControlItem의 Text는 연결된 컨트롤의 라벨로 적었습니다. 필수 여부는 검증 코드가 추출되지 않아 모두 **확인 필요**입니다.

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 크기 | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|---|
| 1 | usrButton1 | UsrButton | 없음 | 75×23 | — | — | 없음(parent 없음) | 이관 여부 확인 필요 |
| 2 | usrConditionPanel1 | UsrConditionPanel | — | 1784×102, Dock=Top, HidePanel | — | — | — | 접이식 조회조건 패널 |
| 3 | usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | 1784×102, Dock=Fill | — | — | — | 조회조건 레이아웃(그리드 배치) |
| 4 | txtItemId | UsrTextBox | "Model / Nick Name" (layModel) | 150×25 | 확인 필요 | 확인 필요 | (BtnItemId_Click이 값을 채움) | Input + 검색 버튼 |
| 5 | btnItemId | UsrButton | "layoutControlItem3" (layoutbtnitem, 기본 이름) | 39×25 | — | — | Click → `BtnItemId_Click` | 팝업 버튼 |
| 6 | clbFromSite | UsrCheckedList2 | "From Site" (layoutControlItem1) | 202×21 | 확인 필요 | 확인 필요 | 없음 | Wijmo MultiSelect |
| 7 | clbToSite | UsrCheckedList2 | "To Site" (lblToSite) | 214×21 | `SCP.SCP0100_GET_SITE` 목록 | 확인 필요 | 없음 | Wijmo MultiSelect |
| 8 | txtCellGroup | UsrTextBox | "Cell Group" (lblCellGroup1) | 111×25 | 확인 필요 | 확인 필요 | 없음 | Input |
| 9 | txtProject | UsrTextBox | "Project" (lblCellGroup) | 150×26 | 확인 필요 | 확인 필요 | (BtnProject_Click이 값을 채움) | Input + 검색 버튼 |
| 10 | btnProject | UsrButton | layoutControlItem2 Text는 props.csv 표시 범위에 없음(확인 필요) | 39×25 | — | — | Click → `BtnProject_Click` | 팝업 버튼 |
| 11 | cboBucketType | UsrCombo | "Bucket" (lblBucket) | 70×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboBucketType_SelectedIndexChanged` | Wijmo ComboBox (MONTHLY/WEEKLY) |
| 12 | cboPlanType | UsrCombo | "Plan-type" (PlanType, Enabled=false) | 70×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboPlanType_SelectedIndexChanged` | Wijmo ComboBox(비활성) |
| 13 | cboDisplay | UsrCombo | "Display" (layDisplay) | 60×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboDisplay_SelectedIndexChanged` | Wijmo ComboBox |
| 14 | cboGraphType | UsrCombo | "Graph" (lblGraphType) | 60×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboGraphType_SelectedIndexChanged` | Wijmo ComboBox |
| 15 | cboPlanDate | UsrCombo | 확인 필요(props.csv 잘림) | 144×20 | `SCP.SCP0100_GET_PLAN_DATE` 목록 | 확인 필요 | SelectedIndexChanged → `CboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| 16 | dCalendar | UsrDateRangePicker3 | 확인 필요(props.csv 잘림) | 230×22 | `biz:CommonData.CommonDataList_REPORT`(PLAN_END_DATE) 기반 | 확인 필요 | ValueChanged → `DCalendar_ValueChanged` | 기간(From~To) InputDate 쌍 |
| 17 | btnMeasure | UsrButton | 확인 필요(props.csv 잘림) | 30×25 | — | — | Click → `btnMeasure_Click` | 메저 선택 버튼 |
| 18 | btnColumn | UsrButton | 확인 필요(props.csv 잘림) | 30×25 | — | — | Click → `BtnColumn_Click` | 컬럼 선택 버튼 |
| 19 | cboUnitQty | UsrCombo | 확인 필요(props.csv 잘림) | 100×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboUnitQty_SelectedIndexChanged` | Wijmo ComboBox |
| 20 | cboSearchLevel | UsrCombo | 확인 필요(props.csv 잘림). LayoutItem lciSearchLevel.Enabled = !_is_detail | 120×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboSearchLevel_SelectedIndexChanged` | Wijmo ComboBox |
| 21 | rgrpSearchLevel | RadioGroup | 확인 필요 | 199×25 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `rgrpSearchLevel_SelectedIndexChanged` | Radio 그룹 |
| 22 | clbDivision | UsrCheckedList2 | 확인 필요(props.csv 잘림) | 179×21 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | Wijmo MultiSelect |
| 23 | chkCellQty | UsrCheckBox | "Cell Qty" | 80×26 | Checked=true, **Visible=false** | — | CheckedChanged → `ChkCellQty_CheckedChanged` | CheckBox(숨김). 이관 여부 확인 필요 |
| 24 | chkAS | UsrCheckBox | "A/S" | 80×25 | **Visible=false** | — | CheckedChanged → `ChkAS_CheckedChanged` | CheckBox(숨김). 이관 여부 확인 필요 |
| 25 | splitContainer1 | SplitContainer | — | 확인 필요 | SplitterDistance 확인 필요 | — | (CboDisplay가 변경) | Splitter 레이아웃 |
| 26 | chartMain | ChartControl | — | 확인 필요 | — | — | (CboGraphType 연동은 확인 필요) | Wijmo FlexChart |
| 27 | spdSearchLevel | FpSpread | — | — | 시트 SEARCH_LEVEL | — | — | Wijmo FlexGrid |
| 28 | spdDetail | FpSpread | — | — | 시트 REPORT | — | — | Wijmo FlexGrid |
| 29 | spdSearchLevelDetail | FpSpread | — | — | 시트 SEARCH_LEVEL_DETAIL | — | — | Wijmo FlexGrid |
| 30 | spdMain_Sheet | SheetView | — | — | 어느 Spread에 속하는지 확인 필요(이름상 spdMain) | — | — | (FlexGrid 내부, 별도 컴포넌트 없음) |
| 31 | spdSearchLevel_Sheet | SheetView | — | — | 확인 필요 | — | — | (FlexGrid 내부) |
| 32 | spdSearchLevelDetail_Sheet | SheetView | — | — | 확인 필요 | — | — | (FlexGrid 내부) |

## 4. 그리드 명세

공통 사항
- 헤더는 3행입니다(`SetSheetHeaderColumn(_SI, 3)`).
- AddSheet 인자는 `3 ¦ 1 ¦ 30`입니다(의미는 확인 필요).
- 메타 고정 컬럼 뒤에 `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과로 기간 컬럼을 붙입니다.
- 편집 가능 여부: 조회 화면이고 저장 엔드포인트가 없습니다. 메타 CELL_CONTROL_OBJECT_TYPE_CODE 값은 Fact Pack에 없어 **확인 필요**입니다.
- 메타 컬럼의 데이터 타입은 메타 행 값이 없어 **확인 필요**입니다.
- 메타 순서(SORT_ORDER_NO)도 **확인 필요**입니다.

### 4-1. 시트 `REPORT` (spdDetail, AddSheet:685, META+코드연결)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 동일) | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 기본 표시 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 표시 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 기본 표시 | 확인 필요 |
| TO_SITE | To Site | 확인 필요 | META | 기본 표시 | 확인 필요 |
| INCOTERMS | INCOTERMS | 확인 필요 | META | 기본 표시 | 확인 필요 |
| OPERATION_ID | Operation | 확인 필요 | META | 기본 표시 | 확인 필요 |
| VARIOUS_KEY | Trans Mode or Line or Project | 확인 필요 | META | 기본 표시 | 확인 필요 |
| CELL_GROUP | Cell Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| CELL_CF | Cell Qty | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 숨김 | 확인 필요 |
| PRODUCT_LEVEL1 | Product Level1 | 확인 필요 | META + 코드(SetLayout) | 기본 → cboSearchLevel에 따라 동적(?) | 확인 필요 |
| PRODUCT_LEVEL2 | Product Level2 | 확인 필요 | META + 코드(SetLayout) | 기본 → 동적(?) | 확인 필요 |
| PRODUCT_LEVEL3 | Product Level3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 동적(?) | 확인 필요 |
| D0, D1 | (공란) | — | CODE_ONLY_CHANGE | 숨김(SetVisibleColumnCycle:1290) | — |
| 기간 컬럼(M_*, W_*, *B_*) | LARGE / SMALL / "Qty" 3행 | B_ 포함: Text, 그 외: Num | HARDCODED 로직 + DB루프(3SPAN) | §4-4 규칙 | 확인 필요 |

메타 14/0이고 최종 표시는 **11 (?3)** 입니다.

### 4-2. 시트 `SEARCH_LEVEL` (spdSearchLevel, AddSheet:684, META+코드연결)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 동일) | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 기본 표시 | 확인 필요 |
| OPERATION_GROUP | Operation Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| CELL_GROUP | Cell Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 숨김 | 확인 필요 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 동적(?) | 확인 필요 |
| D0, D1 | (공란) | — | CODE_ONLY_CHANGE | 숨김 | — |
| 기간 컬럼 | 3행 헤더 | Text / Num | DB루프(3SPAN) | §4-4 | 확인 필요 |

메타 8/0이고 최종 표시는 **5 (?3)** 입니다.

### 4-3. 시트 `SEARCH_LEVEL_DETAIL` (spdSearchLevelDetail, AddSheet:686, META+코드연결)

컬럼 구성은 SEARCH_LEVEL과 같습니다: DIVISION_ID(Div), OPERATION_GROUP(Operation Group), CELL_GROUP(Cell Group), MEASURE_GROUP(Measure Group), MEASURE_NAME(Measure Name), MEASURE_UI(Measure, 숨김), PRODUCT_LEVEL1~3(동적), D0/D1(숨김), 기간 컬럼. 출처도 같습니다(META / CODE_ONLY_CHANGE / DB루프). 메타 8/0이고 최종 표시는 **5 (?3)** 입니다.

### 4-4. 기간 컬럼 규칙 (3개 시트 공통, InitSpreadDateColumn)

| 규칙 | 내용 | 줄 |
|---|---|---|
| 원천 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과 행 | 706 |
| `IndexOf("B_") > 0` | AddTextColumn, 폭 0, Visible=false | 755 |
| 그 외 | AddNumColumn, 폭 70, Visible=true | 760 |
| 글자색 빨강 | `M_`로 시작하고 `_plan_start_yyyymm` 포함 | 767 |
| 글자색 파랑 | `W_`로 시작하고 라벨에 "A" 포함 / "B" 포함 | 774 / 778 |
| 헤더 0행 | LARGE_CLASS_LABEL_NAME 병합 | 787, 815 |
| 헤더 1행 | SMALL_CLASS_LABEL_NAME 병합(또는 "Qty" 2행 병합) | 788, 793, 802, 813, 816 |
| 헤더 2행 | "Qty" | 794, 803, 814 |
| Bucket | MONTHLY: `M_`만 표시 / WEEKLY: `W_`만 표시 | SetSpreadColumn 1103~1118 |

### 4-5. PRODUCT_LEVEL 표시 (SetLayout, `!_is_detail`일 때)

| cboSearchLevel.SelectedIndex | L1 | L2 | L3 |
|---|---|---|---|
| 1 | 표시 | 표시 | 숨김 |
| 2 | 표시 | 숨김 | 숨김 |
| 3 | 숨김 | 표시 | 숨김 |
| 4 | 표시 | 표시 | 표시 |
| (case 라벨 미추출) | 숨김 | 숨김 | 숨김 |

### 4-6. 메저

SCM_MST_SHEET_MEASURE `Global PSI New`에 35행이 있습니다(division 공통). 메저별 내역은 **확인 필요**입니다.

## 5. 액션 명세

| # | 트리거(컨트롤.이벤트) | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | this.Load | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 시트 3개 생성, 메타 + 기간 컬럼 구성 |
| A2 | this.Load | `Form_Load` | InitControls > GetPlanDate | `SCP.SCP0100_GET_PLAN_DATE` | cboPlanDate 목록 |
| A3 | this.Load | `Form_Load` | InitControls > SetCalendar > GetDayRange > GetPlanEndDate | `biz:CommonData.CommonDataList_REPORT` [PLAN_END_DATE] | dCalendar 범위 |
| A4 | this.Shown | `SCP0100_Global_PSI_Report_Shown` | InitControlsAfter > RefreshToSite > GetSiteList | `SCP.SCP0100_GET_SITE` | clbToSite 목록 |
| A5 | cboPlanDate.SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitSpread > GetSpdTitle / SetCalendar > GetDayRange > GetPlanEndDate | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.CommonDataList_REPORT` | 헤더 재구성, dCalendar 재설정 |
| A6 | dCalendar.ValueChanged | `DCalendar_ValueChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| A7 | rgrpSearchLevel.SelectedIndexChanged | `rgrpSearchLevel_SelectedIndexChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성(시트 전환 관계는 확인 필요) |
| A8 | btnMeasure.Click | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| A9 | btnColumn.Click | `BtnColumn_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| A10 | cboBucketType.SelectedIndexChanged | `CboBucketType_SelectedIndexChanged` | `if(_SI != null)` SetSpreadColumn(:1804) | 없음 | M_ / W_ 컬럼 표시 전환 |
| A11 | cboDisplay.SelectedIndexChanged | `CboDisplay_SelectedIndexChanged` | splitContainer1.SplitterDistance = 0 / 750 / 270 | 없음 | 차트·그리드 분할 변경 |
| A12 | cboSearchLevel.SelectedIndexChanged | `CboSearchLevel_SelectedIndexChanged` | 확인 필요(SetLayout 연동 여부 미추출) | 없음 | 확인 필요 |
| A13 | clbDivision.SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요 |
| A14 | cboGraphType.SelectedIndexChanged | `CboGraphType_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요(차트 연동 추정, 미확인) |
| A15 | cboUnitQty.SelectedIndexChanged | `CboUnitQty_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요 |
| A16 | cboPlanType.SelectedIndexChanged | `CboPlanType_SelectedIndexChanged` | 확인 필요(LayoutItem 비활성) | 없음 | 확인 필요 |
| A17 | btnItemId.Click | `BtnItemId_Click` | 팝업(확인 필요) → `txtItemId.Text = sItemId`(:1947) | 없음 | txtItemId 값 |
| A18 | btnProject.Click | `BtnProject_Click` | 팝업(확인 필요) → `txtProject.Text = sProjectCode`(:1981) | 없음 | txtProject 값 |
| A19 | chkCellQty.CheckedChanged | `ChkCellQty_CheckedChanged` | 확인 필요(컨트롤 숨김) | 없음 | 확인 필요 |
| A20 | chkAS.CheckedChanged | `ChkAS_CheckedChanged` | 확인 필요(컨트롤 숨김) | 없음 | 확인 필요 |
| A21 | 조회(BaseForm 툴바 추정) | 미식별 | 미식별 | **미식별** | 시트 3개 본문, 차트 — **확인 필요** |

## 6. 검증·메시지

- 입력 검증 코드와 메시지 코드는 Fact Pack에서 추출되지 않았습니다. **확인 필요**
- 코드상 조건으로 확인된 것은 다음뿐입니다.
  - `CboBucketType_SelectedIndexChanged`의 `_SI != null` 가드
  - `lciSearchLevel.Enabled = !_is_detail`

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SCP0100 행 4건이 있습니다. C/R/U/D 값은 **확인 필요** |
| 세션 | BaseForm.OnShown:522가 NowGroupID와 USER_ID를 사용합니다 |
| 저장·삭제 | 엔드포인트가 없습니다. R 전용으로 보이며 확인 필요 |
| 조회조건 저장 | TB_FX_SearchCondition 23행, SCM_MST_TITLESET_USER 526행 |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 항목 | AS-IS | To-Be 관점 |
|---|---|---|
| 그리드 | FarPoint Spread 3개 겹침 + VisibleSheet | FlexGrid. 시트별 3개 또는 단일 그리드 전환 중 선택은 설계 결정이 필요합니다(`_is_detail` 조건 확인 후) |
| 3행 헤더 | ColumnHeaderSpan | FlexGrid `columnHeaders` 3행 + allowMerging. LARGE / SMALL / "Qty" 병합 |
| 동적 기간 컬럼 | 3SPAN 결과 DB 루프 | API 결과로 컬럼 정의를 생성합니다. `B_` 숨김 텍스트, 숫자 폭 70, 글자색 규칙(빨강/파랑)은 셀 서식 처리 |
| Bucket 전환 | SetSpreadColumn | 재조회 없이 FE에서 M_ / W_ 컬럼 visible만 전환(AS-IS도 API 없음) |
| 차트 | DevExpress ChartControl | FlexChart. 시리즈 구성은 확인 필요 |
| 분할 | SplitContainer 0/750/270 | Splitter 컴포넌트. 비율 기준 환산은 Orientation·Size 확인 후 |
| 멀티 선택 | UsrCheckedList2(GetCheckedListValue CODE) | MultiSelect. 선택 CODE를 구분자 문자열로 전달하는지는 SP 파라미터 확인 후(SP가 FN_SPLITSTRING 사용) |
| SP: #TMP_PLAN | MSSQL 임시 테이블 | Oracle GTT 또는 WITH절로 전환 |
| SP: FN_SPLITSTRING, FN_CHAR_TO_DATE | MSSQL 함수 | Oracle 동등 함수 존재 여부 확인 |
| Biz 경유 PLAN_END_DATE | Data_REPORT.CallBizCommonData | To-Be 공통 데이터 API 매핑이 필요하며 원천은 확인 필요 |
| 숨김 컨트롤 | chkCellQty, chkAS(Visible=false), usrButton1(parent 없음) | 이관 여부 결정 필요 |
| Division | 코드·메타 분기 없음 | division별 컬럼 분기가 필요 없습니다(추출 기준) |

## 9. 미확정

1. 메인 조회 엔드포인트와 SP, 차트 데이터 원천
2. splitContainer1의 Orientation, 초기 SplitterDistance, Size(props.csv 잘림)
3. 라벨 미확인 LayoutItem: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layoutControlItem2/3/4, layAS, layCategoryCC, layoutPlanDate
4. 조회조건 컨트롤의 배치 순서와 행(Location 미추출)
5. 핸들러 내부 동작: ClbDivision, CboGraphType, CboSearchLevel, CboUnitQty, CboPlanType, ChkCellQty, ChkAS
6. CboDisplay 값과 0/750/270의 대응
7. `_is_detail` 조건과 VisibleSheet 규칙
8. SheetView 3개와 Spread의 소속 관계(spdMain_Sheet 명칭)
9. 메타 컬럼 타입·편집·순서
10. Model / Project 팝업 화면 ID
11. 권한 C/R/U/D 값

=== FILE: unit_test.md ===
# SCP0100 Global PSI Report — 단위테스트

> 근거 열에는 엔드포인트, SP, 핸들러, 시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출(commented_calls)은 0건이므로 테스트 대상이 없습니다.
> Fact Pack에서 동작을 확인할 수 없는 항목은 기대결과에 **확인 필요**로 적었습니다. 실행 전에 기대값을 확정해야 합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0100-001 | 초기화 | 로그인(세션 NowGroupID, USER_ID 있음) | SCP0100 화면을 엽니다 | — | 시트 SEARCH_LEVEL / REPORT / SEARCH_LEVEL_DETAIL이 생성되고, 메타 컬럼과 기간 컬럼이 3행 헤더로 구성됩니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` / SP SCP0100_GET_SHEET_CALENDAR_3SPAN |
| TC-SCP0100-002 | 초기화 | 위와 같음 | 화면을 연 뒤 cboPlanDate 목록을 확인합니다 | — | SP 결과 행이 cboPlanDate 항목으로 채워집니다(표시 형식은 확인 필요) | `Form_Load` > InitControls > GetPlanDate → `SCP.SCP0100_GET_PLAN_DATE` / SP SCP0100_GET_PLAN_DATE |
| TC-SCP0100-003 | 초기화 | 위와 같음 | 화면을 연 뒤 dCalendar 기간을 확인합니다 | — | PLAN_END_DATE 공통 데이터로 기간 범위가 설정됩니다(계산식은 확인 필요) | `Form_Load` > SetCalendar > GetDayRange > GetPlanEndDate → `biz:CommonData.CommonDataList_REPORT` |
| TC-SCP0100-004 | 초기화 | 화면 Load 완료 | 화면이 표시된 직후 clbToSite 목록을 확인합니다 | — | SP 결과가 clbToSite 항목으로 채워집니다 | `SCP0100_Global_PSI_Report_Shown` > InitControlsAfter > RefreshToSite > GetSiteList → `SCP.SCP0100_GET_SITE` / SP SCP0100_GET_SITE |
| TC-SCP0100-005 | 초기화 | 화면 Load 완료 | chkCellQty, chkAS, cboPlanType 상태를 확인합니다 | — | chkCellQty: Checked=true, Visible=false / chkAS: Visible=false / cboPlanType의 LayoutItem(PlanType): Enabled=false | designer:248/284/929/1159, `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged`, `CboPlanType_SelectedIndexChanged` |
| TC-SCP0100-006 | 이벤트 | cboPlanDate 항목 2개 이상 | cboPlanDate에서 다른 항목을 고릅니다 | 다른 Plan Date | 기간 헤더가 다시 구성되고, dCalendar 범위가 다시 계산됩니다 | `CboPlanDate_SelectedIndexChanged` → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.CommonDataList_REPORT` |
| TC-SCP0100-007 | 이벤트 | 화면 초기화 완료 | dCalendar의 From/To를 바꿉니다 | 기간 변경 | 기간 헤더가 다시 구성되고, 기간 컬럼 수가 새 기간에 맞게 바뀝니다 | `DCalendar_ValueChanged` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-008 | 이벤트 | 화면 초기화 완료 | rgrpSearchLevel 선택을 바꿉니다 | 다른 라디오 항목 | 헤더가 다시 구성됩니다. 시트 전환 여부는 확인 필요 | `rgrpSearchLevel_SelectedIndexChanged` → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-009 | 이벤트 | 화면 초기화 완료 | btnMeasure를 누릅니다 | — | 헤더가 다시 구성됩니다(메저 선택 UI는 확인 필요) | `btnMeasure_Click` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-010 | 이벤트 | 화면 초기화 완료 | btnColumn을 누릅니다 | — | 헤더가 다시 구성됩니다(컬럼 선택 UI는 확인 필요) | `BtnColumn_Click` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-011 | 이벤트 | 시트 생성 완료(_SI 있음) | cboBucketType을 MONTHLY로 바꿉니다 | MONTHLY | `M_`로 시작하는 컬럼만 보이고 나머지는 숨겨집니다. API 호출은 없습니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn :1103/:1107 |
| TC-SCP0100-012 | 이벤트 | 시트 생성 완료(_SI 있음) | cboBucketType을 WEEKLY로 바꿉니다 | WEEKLY | `W_`로 시작하는 컬럼만 보이고 나머지는 숨겨집니다. API 호출은 없습니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn :1114/:1118 |
| TC-SCP0100-013 | 이벤트 | 시트 미생성(_SI == null) | 시트 생성 전에 cboBucketType 변경 이벤트가 발생하는 경우 | 임의 | SetSpreadColumn이 호출되지 않고 예외도 없습니다 | `CboBucketType_SelectedIndexChanged` `if(_SI != null)` :1804 |
| TC-SCP0100-014 | 이벤트 | 화면 초기화 완료 | cboDisplay 항목을 차례로 고릅니다 | 콤보 각 항목 | splitContainer1.SplitterDistance가 0, 750, 270 중 하나로 바뀝니다. 값별 대응은 확인 필요. 0일 때 Panel1(chartMain)이 접힙니다 | `CboDisplay_SelectedIndexChanged` :1833/:1841/:1849 |
| TC-SCP0100-015 | 이벤트 | 화면 초기화 완료 | cboSearchLevel 항목을 바꿉니다 | 각 항목 | 예외 없이 처리됩니다. 세부 동작(SetLayout 호출 여부)은 확인 필요 | `CboSearchLevel_SelectedIndexChanged` |
| TC-SCP0100-016 | 이벤트 | 화면 초기화 완료 | clbDivision 체크를 바꿉니다 | division 선택/해제 | 예외 없이 처리됩니다. 세부 동작은 확인 필요. 선택값은 getDivision(CODE)으로 수집됩니다 | `ClbDivision_SelectedIndexChanged`, getDivision:466 |
| TC-SCP0100-017 | 이벤트 | 화면 초기화 완료 | cboGraphType 항목을 바꿉니다 | 각 항목 | 예외 없이 처리됩니다. chartMain 반영 여부는 확인 필요 | `CboGraphType_SelectedIndexChanged` |
| TC-SCP0100-018 | 이벤트 | 화면 초기화 완료 | cboUnitQty 항목을 바꿉니다 | 각 항목 | 예외 없이 처리됩니다. 세부 동작은 확인 필요 | `CboUnitQty_SelectedIndexChanged` |
| TC-SCP0100-019 | 이벤트 | PlanType LayoutItem Enabled=false | cboPlanType 변경 이벤트를 발생시킵니다(코드/테스트 하네스로) | 각 항목 | 예외 없이 처리됩니다. 세부 동작은 확인 필요. 화면에서 사용자가 직접 바꿀 수 없음을 확인합니다 | `CboPlanType_SelectedIndexChanged`, designer:1159 |
| TC-SCP0100-020 | 이벤트 | 화면 초기화 완료 | btnItemId를 누르고 팝업에서 Model을 고릅니다 | Model 1건 | txtItemId에 선택한 값(sItemId)이 들어갑니다. 팝업 화면 ID는 확인 필요 | `BtnItemId_Click` :1947 |
| TC-SCP0100-021 | 이벤트 | 화면 초기화 완료 | btnProject를 누르고 팝업에서 Project를 고릅니다 | Project 1건 | txtProject에 선택한 값(sProjectCode)이 들어갑니다. 팝업 화면 ID는 확인 필요 | `BtnProject_Click` :1981 |
| TC-SCP0100-022 | 이벤트 | chkCellQty Visible=false | chkCellQty 체크 변경 이벤트를 발생시킵니다(하네스) | true→false | 예외 없이 처리됩니다. 세부 동작은 확인 필요 | `ChkCellQty_CheckedChanged` |
| TC-SCP0100-023 | 이벤트 | chkAS Visible=false | chkAS 체크 변경 이벤트를 발생시킵니다(하네스) | false→true | 예외 없이 처리됩니다. 세부 동작은 확인 필요 | `ChkAS_CheckedChanged` |
| TC-SCP0100-024 | 그리드 | spdDetail 표시 상태 | 시트 REPORT의 컬럼을 확인합니다 | — | 표시: Div, Model, From Site, To Site, INCOTERMS, Operation, Trans Mode or Line or Project, Cell Group, Cell Qty, Measure Group, Measure Name(11개) + PRODUCT_LEVEL1~3(동적) / 숨김: MEASURE_UI, D0, D1 | 시트 REPORT, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, grid_effective |
| TC-SCP0100-025 | 그리드 | spdSearchLevel 표시 상태 | 시트 SEARCH_LEVEL의 컬럼을 확인합니다 | — | 표시: Div, Operation Group, Cell Group, Measure Group, Measure Name(5개) + PRODUCT_LEVEL1~3(동적) / 숨김: MEASURE_UI, D0, D1 | 시트 SEARCH_LEVEL, grid_effective |
| TC-SCP0100-026 | 그리드 | spdSearchLevelDetail 표시 상태 | 시트 SEARCH_LEVEL_DETAIL의 컬럼을 확인합니다 | — | SEARCH_LEVEL과 같은 구성(5개 + PRODUCT_LEVEL1~3 동적), MEASURE_UI/D0/D1 숨김 | 시트 SEARCH_LEVEL_DETAIL, grid_effective |
| TC-SCP0100-027 | 그리드 | 3SPAN 결과에 `B_`가 위치 1 이후에 들어간 COLUMN_NAME 있음 | 기간 컬럼 속성을 확인합니다 | — | 해당 컬럼은 Text 컬럼, 폭 0, 숨김입니다. 그 외 컬럼은 Num 컬럼, 폭 70, 표시입니다 | InitSpreadDateColumn :755/:760, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-028 | 그리드 | `_plan_start_yyyymm`을 포함한 `M_` 컬럼 있음 | 글자색을 확인합니다 | — | 빨강입니다 | InitSpreadDateColumn :767 |
| TC-SCP0100-029 | 그리드 | `W_` 컬럼의 라벨에 "A" 또는 "B" 포함 | 글자색을 확인합니다 | — | 파랑입니다 | InitSpreadDateColumn :774/:778 |
| TC-SCP0100-030 | 그리드 | 헤더 구성 완료 | 기간 컬럼 헤더를 확인합니다 | — | 0행: LARGE_CLASS_LABEL_NAME 병합 / 1행: SMALL_CLASS_LABEL_NAME 병합 / 2행: "Qty" | InitSpreadDateColumn :787~816, SetSheetHeaderColumn(_SI, 3) |
| TC-SCP0100-031 | 그리드 | `!_is_detail` | cboSearchLevel.SelectedIndex를 1, 2, 3, 4로 바꾼 뒤 SetLayout 결과를 확인합니다 | 1 / 2 / 3 / 4 | 1: L1·L2 표시 / 2: L1만 / 3: L2만 / 4: L1·L2·L3. SetLayout 실행 트리거는 확인 필요 | SetLayout :1498~1529, `CboSearchLevel_SelectedIndexChanged` |
| TC-SCP0100-032 | 그리드 | `!_is_detail` | case 라벨이 미추출인 분기로 진입시킵니다 | 1~4 외 값(확인 필요) | PRODUCT_LEVEL1~3 모두 숨김 | SetLayout :1536~1538 |
| TC-SCP0100-033 | 그리드 | 화면 초기화 완료 | spdSearchLevel, spdDetail, spdSearchLevelDetail의 Visible을 확인합니다 | — | 항상 하나만 Visible입니다. lciSearchLevel.Enabled = !_is_detail입니다. 전환 조건은 확인 필요 | VisibleSheet :1880~1896, EnableSearchLevel :1874, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-034 | division | division별 사용자 준비(40, 81, 82, EE 계열 등 14개) | division별로 로그인 또는 clbDivision을 선택한 뒤 각 시트 컬럼 수를 비교합니다 | 14개 division | 모든 division에서 REPORT 11 (?3), SEARCH_LEVEL 5 (?3), SEARCH_LEVEL_DETAIL 5 (?3)로 같습니다 | grid_effective, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL, `ClbDivision_SelectedIndexChanged` |
| TC-SCP0100-035 | 권한 | TB_FX_GroupMenuAuth 4개 그룹 사용자 | 그룹별로 화면에 진입합니다 | 그룹별 계정 | 그룹별 C/R/U/D 값에 맞는 화면 접근과 버튼 활성이 적용됩니다. 값은 확인 필요 | TB_FX_GroupMenuAuth, BaseForm.OnShown:522, `Form_Load` |
| TC-SCP0100-036 | 조회 | 3SPAN SP 결과 0행인 조건 | 화면을 열거나 dCalendar를 바꿉니다 | 데이터 없는 기간 | 기간 컬럼이 추가되지 않습니다. ColumnHeaderSpan이 `dsSpdTitle.Tables[0].Rows[0][2]`를 참조하므로 0행일 때 예외가 날 수 있습니다 → 실제 동작은 확인 필요 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, InitSpreadDateColumn :787~816, `DCalendar_ValueChanged` |
| TC-SCP0100-037 | 조회 | PLAN_DATE SP 결과 0행인 조건 | 화면을 엽니다 | — | cboPlanDate가 비어 있습니다. 이후 동작(예외·메시지)은 확인 필요 | `SCP.SCP0100_GET_PLAN_DATE`, `Form_Load` |
| TC-SCP0100-038 | 조회 | SITE SP 결과 0행인 조건 | 화면을 엽니다 | — | clbToSite가 비어 있습니다. 예외는 없어야 합니다(확인 필요) | `SCP.SCP0100_GET_SITE`, `SCP0100_Global_PSI_Report_Shown` |
| TC-SCP0100-039 | 조회 | PLAN_END_DATE 공통 데이터가 없거나 Biz 호출이 실패하는 조건 | 화면을 열거나 cboPlanDate를 바꿉니다 | — | 오류 처리(메시지·기본 기간)는 확인 필요 | `biz:CommonData.CommonDataList_REPORT`, `CboPlanDate_SelectedIndexChanged` |
| TC-SCP0100-040 | 조회 | 3SPAN SP가 오류를 응답하는 조건(권한 누락 등) | btnColumn을 누릅니다 | — | 오류 메시지 표시 방식은 확인 필요. 기존 그리드 상태가 유지되는지 확인합니다 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `BtnColumn_Click` |
| TC-SCP0100-041 | 조회 | 조회조건 입력 완료 | 조회를 실행합니다 | 기본 조건 | 시트·차트 본문 데이터 표시 — **엔드포인트 미식별. 확인 후 TC 확정** | 메인 조회 엔드포인트 미식별(Fact Pack 미검출) |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 엔드포인트 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 001, 006~010, 024, 027, 036, 040 |
| | `SCP.SCP0100_GET_SITE` | 004, 038 |
| | `SCP.SCP0100_GET_PLAN_DATE` | 002, 037 |
| | `biz:CommonData.CommonDataList_REPORT` | 003, 006, 039 |
| 핸들러(18) | `Form_Load` 001~003, 035 / `SCP0100_Global_PSI_Report_Shown` 004, 038 / `ClbDivision_SelectedIndexChanged` 016, 034 / `CboGraphType_SelectedIndexChanged` 017 / `CboPlanDate_SelectedIndexChanged` 006, 039 / `CboBucketType_SelectedIndexChanged` 011~013 / `CboDisplay_SelectedIndexChanged` 014 / `CboSearchLevel_SelectedIndexChanged` 015, 031 / `CboUnitQty_SelectedIndexChanged` 018 / `rgrpSearchLevel_SelectedIndexChanged` 008 / `BtnItemId_Click` 020 / `btnMeasure_Click` 009 / `BtnProject_Click` 021 / `CboPlanType_SelectedIndexChanged` 005, 019 / `BtnColumn_Click` 010, 040 / `DCalendar_ValueChanged` 007, 036 / `ChkCellQty_CheckedChanged` 005, 022 / `ChkAS_CheckedChanged` 005, 023 | — |
| 시트 | REPORT 024 / SEARCH_LEVEL 025 / SEARCH_LEVEL_DETAIL 026 (공통 033, 034) | — |
| division | 14개 division 동일 → 034 | — |
| 빈 결과 / 오류 | 036~040 | — |
