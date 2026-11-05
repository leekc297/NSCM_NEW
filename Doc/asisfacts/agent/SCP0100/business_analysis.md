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
