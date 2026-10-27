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
