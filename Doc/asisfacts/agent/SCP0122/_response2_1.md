=== FILE: business_analysis.md ===
# SCP0122 Plan Activity Mgmt — 업무분석서

> 근거는 AsisFacts 정적 추출 Fact Pack(SCP0122)과 1차 분석서(analysis.md / web_components.md / tobe_design.md)뿐입니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 **0건**입니다. 아래 내용은 모두 활성 호출 기준입니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SCP0122 | Fact Pack §1 |
| 화면명(Form Text) | `SCP0122_PlanActivityMgmt` | props.csv Designer.cs:293 |
| 그리드 시트명 | `Plan Activity Mgmt` | grid_code.csv CreateSpread:185 |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) | Fact Pack §1 |
| 업무 목적 | Plan Group별 Activity(`SCP_OPMZ_PLAN_GR_ACTV_M`)를 조회하고 저장(신규·수정·삭제)하는 마스터 관리 화면입니다. 저장 SP가 이 테이블에 INSERT/UPDATE/DELETE 하므로 이렇게 판단했습니다. 업무상 정의(Activity의 의미, 계획 수립에서의 용도)는 **확인 필요** | endpoints.csv |
| 범위 | 조회조건(Division / Plan Group / Process), 메인 그리드 1시트 조회·저장, 저장 이력·로그 적재 | Fact Pack §2·§3 |
| 범위 밖 / 미확정 | 엑셀 업·다운로드, 팝업, 외부 I/F는 Fact Pack에 사실이 없습니다 | — |
| 배포 상태 | 파일 5개 모두 **sln 미등록**이라 운영 빌드에 포함되는지 **확인 필요** | Fact Pack §1 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면 열기 | `Form_Load`가 실행됩니다(.ctor:98 배선). 필드 초기화식 `dtProcessCdAll`(47행)이 `biz:CommonData.CommonDataList` [code=LookupCommon]을 호출합니다. 그리드 시트 `Plan Activity Mgmt`를 생성(CreateSpread:185 AddSheet)·활성화(InitSpread:198 ChangeActiveSheet)합니다 | 조회조건과 빈 그리드가 표시됩니다. Form_Load 본문 순서는 **확인 필요** | events.csv, endpoints.csv, grid_code.csv |
| S2 | (화면 열기 또는 Division 변경 시점 — **확인 필요**) Plan Group 목록 적재 | `GetPlanGroupByUserID`(155)가 `FoxUserInfoContext.Current.NowGroupID`(143)를 사용해 `SCP.SCP0121_GET_SEARCH_INFO` → SP `SCP0121_GET_SEARCH_INFO`를 호출합니다 | Plan Group 콤보 목록. 정적 파서상 진입점 미연결(unreached) | flow.csv, meta_reads.csv |
| S3 | Division 변경 | `ClbDivision_SelectedIndexChanged`(InitEvent:217)가 실행됩니다. `RefreshPlanGroupByDivision`(171)이 `GetCheckedListValue`(CODE)를 호출한다는 사실은 있지만, 이 핸들러가 그 메서드를 부르는지는 **확인 필요** | Plan Group 목록 갱신으로 추정(**확인 필요**) | events.csv, Fact Pack §4-2 |
| S4 | Plan Group 변경 | `CboPlanGroup_SelectedIndexChanged`(InitEvent:218)가 실행됩니다 | 처리 내용 **확인 필요** | events.csv |
| S5 | 조회 버튼 | FindButton → `FindData_Main`. 시트 전환(306 ChangeSheet `Plan Activity Mgmt`) 후 `GetCheckedListValue`(CODE) 3회(308·309·310)로 조건값을 만들고, 321행에서 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` → SP `SCP0122_GET_PLAN_ACTIVITY_MGMT`를 호출합니다 | 그리드에 Activity 목록이 표시됩니다 | flow.csv, grid_code.csv, Fact Pack §4-2 |
| S6 | 행 추가 | `Insert_Row`(367)가 `GetCheckedListValue`(CODE)를 호출합니다. 어느 버튼에서 진입하는지는 **확인 필요** | 신규 행 추가. 조건값을 기본값으로 채우는지 **확인 필요** | Fact Pack §4-2 |
| S7 | 그리드 셀 콤보 선택 / 셀 클릭 | `SpdMain_ComboSelChange`(InitEvent:220), `spdMain_CellClick`(InitEvent:221) | 처리 내용 **확인 필요** | events.csv |
| S8 | 저장 버튼 | SaveButton → `Save_Data`(480)가 `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` → SP `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`를 호출합니다. 이어서 `FindData_Main`(321)이 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`로 재조회합니다 | 변경분이 `SCP_OPMZ_PLAN_GR_ACTV_M`에 반영되고, 이력(`SCP_OPMZ_PLAN_GR_ACTV_H`)과 로그(`SCM_SYS_LOG_BATCH`)가 적재된 뒤 그리드가 재조회됩니다 | flow.csv, endpoints.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  ├─ (필드 초기화) dtProcessCdAll ── biz:CommonData.CommonDataList [LookupCommon]
  ├─ Form_Load ── 그리드 시트 'Plan Activity Mgmt' 생성/활성화 (CreateSpread:185 / InitSpread:198)
  └─ (시점 확인 필요) GetPlanGroupByUserID ── SCP.SCP0121_GET_SEARCH_INFO (NowGroupID)
        │
[조회조건 설정]
  ├─ cboDivision 변경 ── ClbDivision_SelectedIndexChanged (→ RefreshPlanGroupByDivision:171 연관 확인 필요)
  ├─ cboPlanGroup 변경 ── CboPlanGroup_SelectedIndexChanged
  └─ cboProcess 선택
        │
[조회] FindButton → FindData_Main
  ├─ ChangeSheet('Plan Activity Mgmt') :306
  ├─ GetCheckedListValue(CODE) ×3 :308~310
  └─ SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT :321 → 그리드 바인딩
        │
[그리드 편집]
  ├─ Insert_Row :367 (진입 버튼 확인 필요)
  ├─ SpdMain_ComboSelChange / spdMain_CellClick
        │
[저장] SaveButton → Save_Data
  ├─ SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT :480
  │     ├─ INSERT/UPDATE/DELETE SCP_OPMZ_PLAN_GR_ACTV_M
  │     ├─ EXEC SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST → INSERT SCP_OPMZ_PLAN_GR_ACTV_H
  │     └─ EXEC PR_SCM_SYS_LOG_BATCH → INSERT SCM_SYS_LOG_BATCH
  └─ FindData_Main → SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT :321 (재조회)
```

## 4. 업무 규칙 (사실 근거만)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 조회 시 조건 3개를 `GetCheckedListValue`(CODE)로 만들어 전달합니다 | FindData_Main:308·309·310 | 대상 컨트롤(Division/Plan Group/Process 추정)과 SP 파라미터명은 **확인 필요** |
| R2 | Plan Group 목록은 로그인 사용자의 `NowGroupID`를 기준으로 조회합니다 | GetPlanGroupByUserID:143 → `SCP0121_GET_SEARCH_INFO` | SP 안의 분기 조건은 **확인 필요** |
| R3 | Process 원천은 공통코드 LookupCommon입니다 (UP_FX_GetCommonDataList: `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL`) | endpoints.csv `<field:dtProcessCdAll>`:47 | LOOKUP 코드값과 cboProcess 바인딩 여부는 **확인 필요** |
| R4 | 그리드 컬럼은 메타(`SCM_MST_SHEET_COLUMNS`)로 생성하며, `sheetName.Equals("Plan Activity Mgmt")`일 때만 메타 빌드를 실행합니다 | SetSpreadInit:205·206·212 | `SetSheetHeaderColumnSCP(siObj, 1, false, "")` — 헤더 1행, chkAll=false |
| R5 | 메타 표시 규칙: VISIBLE_FLAG·VALID_YN='Y', USER_SELECTABLE_FLAG='N'=필수, DEFAULT_FLAG='Y'=기본 | Fact Pack §10 | 15컬럼 모두 '기본'(필수 0) |
| R6 | 저장 후에는 반드시 재조회합니다 | flow.csv SaveButton > Save_Data > FindData_Main | 저장 실패 시에도 재조회하는지는 **확인 필요** |
| R7 | 저장은 한 SP 안에서 INSERT/UPDATE/DELETE를 함께 처리합니다. 행 상태(신규/수정/삭제) 구분 방식은 **확인 필요** | endpoints.csv SAVE objects | 페이로드는 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`(문자열 분해 함수) 참조로 보아 구분자 문자열 가능성이 있음 — **확인 필요** |
| R8 | 저장 시 이력(`SCP_OPMZ_PLAN_GR_ACTV_H`, `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` 경유)과 실행 로그(`SCM_SYS_LOG_BATCH`, `PR_SCM_SYS_LOG_BATCH` 경유)를 남깁니다 | endpoints.csv | 이력 적재 조건은 **확인 필요** |
| R9 | 필수값 검증 | — | Fact Pack에 사실 없음. **확인 필요** |
| R10 | 날짜·버킷 규칙 | — | Fact Pack에 날짜/버킷 관련 사실 없음. **해당 사실 없음** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 위치 | 읽기 | 쓰기 | 화면설계서 §5 대응 액션 |
|---|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | (Biz 공통 UP_FX_GetCommonDataList) | `<field:dtProcessCdAll>`:47 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — | A01 화면 초기화(필드 초기화) |
| `SCP.SCP0121_GET_SEARCH_INFO` | `SCP0121_GET_SEARCH_INFO` | GetPlanGroupByUserID:155 | SCM_MST_DIVISION, SCM_MST_LINE_SN, SCM_MST_FACTORY_SN, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_OSP, SCM_MST_SITE, SCM_MST_VENDOR, SCP_MST_CAPA_LINE, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER, SCM_OPERATION_M_SN | 임시: #DIVISION_INFO, #LINE_MASTER, #OSP_PLANT_INFO (INSERT 후 SELECT) | A02 Plan Group 목록 적재 |
| `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | `SCP0122_GET_PLAN_ACTIVITY_MGMT` | FindData_Main:321 | SCP_OPMZ_PLAN_GR_ACTV_M, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER_DETAIL | — | A05 조회 / A09 저장 후 재조회 |
| `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | Save_Data:480 | (REF) SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | SCP_OPMZ_PLAN_GR_ACTV_M (INSERT/UPDATE/DELETE), SCP_OPMZ_PLAN_GR_ACTV_H (INSERT), SCM_SYS_LOG_BATCH (INSERT) / EXEC PR_SCM_SYS_LOG_BATCH, SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST | A09 저장 |

> SP 3개(`SCP0121_GET_SEARCH_INFO`, `SCP0122_GET_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`)의 입력 파라미터 목록과 결과 컬럼은 Fact Pack에 없어 **확인 필요**입니다. Fact Pack §10에는 SP 실행 결과와 매칭되는 시트가 없다고 기재되어 있습니다.

## 6. division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Grid division 차이 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 `Plan Activity Mgmt` 15컬럼 '기본'. **차이 없음** | Fact Pack §10·§12, grid_effective.csv |
| 코드 division 분기 | 코드 안의 division 변수 비교 분기 0건(판단불가 0건) | Fact Pack §12 |
| SP 안의 division 분기 | Fact Pack에 사실 없음. **확인 필요** | — |
| 사용자 그룹 | Plan Group 목록이 `NowGroupID`에 따라 달라질 수 있음 | meta_reads.csv:143 |
| 권한 메타 | TB_FX_GroupMenuAuth 3행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_SearchCondition 3행이 존재합니다. 행 내용(그룹·버튼 권한값)은 **확인 필요** | Fact Pack §8 |
| C/R/U/D | R: FindButton / C: Insert_Row + SAVE INSERT / U: SaveButton + SAVE UPDATE, EditButton(275) 메서드 존재 / D: SAVE DELETE — 삭제 버튼 진입점 **확인 필요** | flow.csv, endpoints.csv, grid_code.csv |

## 7. 외부 인터페이스

Fact Pack에 외부 시스템 I/F 사실은 없습니다. `SCM_SYS_LOG_BATCH`는 내부 실행 로그 적재로 보이며, 외부 연계인지는 **확인 필요**입니다.

## 8. 미확정·확인 필요

1. `GetPlanGroupByUserID`(`SCP.SCP0121_GET_SEARCH_INFO`)를 실제로 부르는 시점(Form_Load / Division 변경)
2. `dtProcessCdAll`(`biz:CommonData.CommonDataList` LookupCommon)의 LOOKUP 코드값과 cboProcess 바인딩 여부
3. 5개 이벤트 핸들러(`Form_Load`, `ClbDivision_SelectedIndexChanged`, `CboPlanGroup_SelectedIndexChanged`, `SpdMain_ComboSelChange`, `spdMain_CellClick`)의 본문 동작
4. `SpdMain_ClipboardPasted`(574, dtPlanGroup NAME→CODE 변환)의 이벤트 배선 여부 — events.csv에 배선 기록 없음
5. `Insert_Row`(367)와 삭제 기능의 버튼 진입점
6. FindData_Main 308~310 `GetCheckedListValue` 3회의 대상 컨트롤과 SP 파라미터 매핑
7. SP 3종의 파라미터와 결과 컬럼, 결과 컬럼과 메타 15컬럼의 일치 여부
8. 저장 페이로드 형식(SCM_ARR_SPL_CNT/VAL)과 행 상태 구분 방식
9. 필수값·중복 검증과 메시지 코드
10. 권한 메타 4종의 행 내용
11. sln 미등록 프로젝트가 운영 배포 대상인지

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# SCP0122 Plan Activity Mgmt — 단위테스트

> 근거 열은 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름 원문을 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출(commented_calls)은 0건이라 제외 대상이 없습니다. 핸들러 본문이 확인되지 않은 항목은 기대결과에 **확인 필요**를 적었으니, 원문을 확인한 뒤 기대값을 확정해야 합니다.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0122-001 | 초기화 | SCP0122 메뉴 권한이 있는 사용자로 로그인 | 1) SCP0122 화면을 연다 2) usrConditionPanel1, spdMain을 확인한다 | 없음 | `Form_Load`가 실행됩니다. usrConditionPanel1(상단, 접기 가능) 안에 cboDivision / cboPlanGroup / cboProcess가 보이고, spdMain에 시트 `Plan Activity Mgmt`가 활성 상태로 표시됩니다. 조회 전 그리드는 빈 상태(**확인 필요**) | `Form_Load`, `Plan Activity Mgmt` (CreateSpread:185, InitSpread:198) |
| TC-SCP0122-002 | 초기화 | SCM_ADM_LOOKUP_MASTER / _DETAIL에 LookupCommon 대상 코드 존재(코드값 **확인 필요**) | 1) 화면을 연다 2) 공통코드 호출 여부를 확인한다 3) cboProcess 목록을 확인한다 | LookupCommon | 클래스 생성 시 `biz:CommonData.CommonDataList` [code=LookupCommon]이 1회 호출되어 dtProcessCdAll에 적재됩니다. cboProcess에 바인딩되는지는 **확인 필요** | `biz:CommonData.CommonDataList` (`<field:dtProcessCdAll>`:47, UP_FX_GetCommonDataList) |
| TC-SCP0122-003 | 초기화 | 로그인 사용자 NowGroupID에 해당하는 SCP_OPMZ_PLAN_GR_M 데이터 존재 | 1) 화면을 연다(또는 cboDivision을 변경한다 — 호출 시점 **확인 필요**) 2) cboPlanGroup 목록을 확인한다 | NowGroupID = 로그인 사용자 그룹 | `SCP.SCP0121_GET_SEARCH_INFO` → SP `SCP0121_GET_SEARCH_INFO`가 호출되고 cboPlanGroup에 Plan Group 목록이 채워집니다 | `SCP.SCP0121_GET_SEARCH_INFO`, `SCP0121_GET_SEARCH_INFO` (GetPlanGroupByUserID:155·143) |
| TC-SCP0122-004 | 초기화 | 사용자 그룹에 해당하는 Plan Group 데이터 없음 | 1) 화면을 연다 2) cboPlanGroup을 펼친다 | NowGroupID = 데이터 없는 그룹 | 빈 결과에서도 오류 없이 cboPlanGroup이 비어 있습니다(빈 목록 처리 방식 **확인 필요**) | `SCP.SCP0121_GET_SEARCH_INFO` (빈 결과) |
| TC-SCP0122-005 | 이벤트 | TC-001 완료 | 1) cboDivision 선택값을 바꾼다 | Division 값 1개 이상 | `ClbDivision_SelectedIndexChanged`가 실행됩니다. cboPlanGroup이 선택 Division 기준으로 갱신되는지(RefreshPlanGroupByDivision:171) **확인 필요** | `ClbDivision_SelectedIndexChanged` (InitEvent:217) |
| TC-SCP0122-006 | 이벤트 | cboPlanGroup 목록 적재됨 | 1) cboPlanGroup 선택값을 바꾼다 | Plan Group 1건 | `CboPlanGroup_SelectedIndexChanged`가 실행됩니다. 연동 처리(cboProcess 갱신 등)는 **확인 필요** | `CboPlanGroup_SelectedIndexChanged` (InitEvent:218) |
| TC-SCP0122-007 | 조회 | SCP_OPMZ_PLAN_GR_ACTV_M에 조건에 맞는 데이터 존재 | 1) cboDivision, cboPlanGroup, cboProcess를 선택한다 2) 조회(FindButton)를 누른다 | Division / Plan Group / Process 각 CODE | 시트가 `Plan Activity Mgmt`로 전환(306)되고, 조건 3개가 GetCheckedListValue(CODE)로 전달(308~310)된 뒤 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`가 호출(321)되어 spdMain에 결과가 표시됩니다 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`, `SCP0122_GET_PLAN_ACTIVITY_MGMT`, `Plan Activity Mgmt` |
| TC-SCP0122-008 | 조회 | 조건에 맞는 데이터 없음 | 1) 데이터가 없는 조합을 선택한다 2) 조회(FindButton)를 누른다 | 데이터 없는 Plan Group/Process | 오류 없이 spdMain이 0행이고 헤더 15컬럼은 유지됩니다(조회 결과 없음 메시지 여부 **확인 필요**) | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (빈 결과) |
| TC-SCP0122-009 | 조회 | SP 오류 유발 환경(예: SP 권한 회수·DB 연결 차단) | 1) 조회(FindButton)를 누른다 | 정상 조건 | 오류 응답 시 오류 메시지가 표시되고 기존 그리드가 깨지지 않습니다(메시지 문구 **확인 필요**) | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (오류 응답) |
| TC-SCP0122-010 | 그리드 | SCM_MST_SHEET_COLUMNS SCP0122 15행 존재 | 1) 화면을 연다 2) spdMain 헤더를 확인한다 | 없음 | 시트 `Plan Activity Mgmt`에 15컬럼 헤더 Auto Flag, Confirm Flag, Div., Link UI Type, Activity Code, Activity Name, Act. Seq, Plan Group ID, Plan Group, Process CD, Process, Option Flag, PRE_OPMZ_ACTV_CD, PRE_OPMZ_ACTV_SEQ, Program Name이 표시됩니다(표시 순서는 메타 원문 **확인 필요**) | `Plan Activity Mgmt` (SetSheetHeaderColumnSCP@SetSpreadInit:212, grid_effective.csv) |
| TC-SCP0122-011 | 그리드 | TC-010 완료 | 1) 각 컬럼의 폭·정렬·고정·최대길이·대문자 적용을 메타 값과 비교한다 | SCM_MST_SHEET_COLUMNS 원문 | COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE가 메타대로 적용됩니다 | `Plan Activity Mgmt` (SetSheetHeaderColumnSCP) |
| TC-SCP0122-012 | 그리드 | TC-001 완료 | 1) 컬럼 헤더 스타일을 확인한다 | 없음 | 헤더 정렬은 General, NoteIndicatorColor는 Red(Designer.cs:252~255)입니다 | `Plan Activity Mgmt` (InitializeComponent:252~255) |
| TC-SCP0122-013 | 이벤트 | TC-007 조회 완료, 콤보 셀 존재(셀 유형 메타 **확인 필요**) | 1) spdMain의 콤보 셀에서 값을 선택한다 | 콤보 항목 1건 | `SpdMain_ComboSelChange`가 실행됩니다. 연동 셀 갱신 등 처리 내용은 **확인 필요** | `SpdMain_ComboSelChange` (InitEvent:220), `Plan Activity Mgmt` |
| TC-SCP0122-014 | 이벤트 | TC-007 조회 완료 | 1) spdMain 임의 셀을 클릭한다 | 셀 위치(행/열) | `spdMain_CellClick`이 실행됩니다. 처리 내용은 **확인 필요** | `spdMain_CellClick` (InitEvent:221), `Plan Activity Mgmt` |
| TC-SCP0122-015 | 저장 | 조회조건 선택됨, 원장에 없는 Activity 키 준비 | 1) 행 추가(Insert_Row — 진입 버튼 **확인 필요**) 2) 필수 셀을 입력한다 3) 저장(SaveButton)을 누른다 | 신규 OPMZ_ACTV_CD 등 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`로 SCP_OPMZ_PLAN_GR_ACTV_M에 INSERT된 뒤 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`로 재조회되어 신규 행이 표시됩니다 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-016 | 저장 | TC-007 조회 완료 | 1) 기존 행의 편집 가능 셀을 수정한다 2) 저장(SaveButton)을 누른다 | 예: Activity Name 변경 | SCP_OPMZ_PLAN_GR_ACTV_M에 UPDATE되고 재조회 결과에 변경값이 반영됩니다 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-017 | 저장 | TC-007 조회 완료, 삭제 진입점 확인됨(**확인 필요**) | 1) 행 삭제 표시를 한다 2) 저장(SaveButton)을 누른다 | 삭제 대상 1행 | SCP_OPMZ_PLAN_GR_ACTV_M에서 DELETE되고 재조회 결과에서 사라집니다 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-018 | 저장 | TC-015~017 중 1건 수행 | 1) 저장 후 이력·로그 테이블을 조회한다 | 저장한 키 | SCP_OPMZ_PLAN_GR_ACTV_H(SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST 경유)와 SCM_SYS_LOG_BATCH(PR_SCM_SYS_LOG_BATCH 경유)에 행이 적재됩니다(적재 조건 **확인 필요**) | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-019 | 저장 | SP 오류 유발 데이터(예: 중복 키 — 원장 실존 키) 준비 | 1) 오류를 유발하는 행으로 저장(SaveButton)을 누른다 | 오류 유발 값 | 오류 응답 시 메시지가 표시되고 원장이 변경되지 않습니다. 재조회 수행 여부는 **확인 필요** | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` (오류 응답) |
| TC-SCP0122-020 | 저장 | TC-007 조회 완료, 변경 없음 | 1) 아무것도 수정하지 않고 저장(SaveButton)을 누른다 | 없음 | 변경 없음 처리(메시지 또는 무동작)는 **확인 필요**. 원장 변경 0건 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` (빈 페이로드) |
| TC-SCP0122-021 | division | Division 40 사용자/조건 | 1) cboDivision = 40으로 조회(FindButton)한다 | Division 40 | `Plan Activity Mgmt` 15컬럼 전부 표시(기본 15/선택 0) | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 40) |
| TC-SCP0122-022 | division | Division 81 계열 사용자/조건 | 1) cboDivision = 81(및 81_HD/81_HG/81_HM/81_ST/81_UC)로 조회(FindButton)한다 | 81 계열 | 15컬럼 전부 표시, 40과 동일 | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 81 계열) |
| TC-SCP0122-023 | division | Division 82 사용자/조건 | 1) cboDivision = 82로 조회(FindButton)한다 | Division 82 | 15컬럼 전부 표시, 40과 동일 | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 82) |
| TC-SCP0122-024 | division | Division EE 계열 사용자/조건 | 1) cboDivision = EE(및 EE_HD/EE_HG/EE_HM/EE_ST/EE_UC)로 조회(FindButton)한다 | EE 계열 | 15컬럼 전부 표시, 40과 동일 | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv EE 계열) |
| TC-SCP0122-025 | 권한 | 조회 권한만 있는 그룹(TB_FX_GroupMenuAuth 값 **확인 필요**) | 1) 화면을 연다 2) 조회·저장 버튼 노출을 확인한다 | 권한 그룹 A | 조회(FindButton)는 가능하고, 저장(SaveButton)·행추가의 노출·비활성 여부는 권한 메타에 따릅니다(**확인 필요**) | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`, `Form_Load` (TB_FX_GroupMenuAuth 3행) |
| TC-SCP0122-026 | 권한 | 저장 권한 그룹 / 권한 없는 그룹 각 1계정 | 1) 각 계정으로 행 추가·수정 후 저장(SaveButton)을 시도한다 | 권한 그룹 B / 권한 없음 | 저장 권한 그룹은 `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` 호출에 성공합니다. 권한이 없으면 저장이 차단됩니다(차단 방식 **확인 필요**) | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-027 | 권한 | 서로 다른 NowGroupID 사용자 2명 | 1) 각 계정으로 화면을 열어 cboPlanGroup 목록을 비교한다 | 그룹 X / 그룹 Y | `SCP.SCP0121_GET_SEARCH_INFO` 결과가 그룹별로 다를 수 있습니다(차이 규칙은 SP 원문 **확인 필요**) | `SCP.SCP0121_GET_SEARCH_INFO`, `SCP0121_GET_SEARCH_INFO` (NowGroupID:143) |

## 2. 커버리지 대조

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 025 |
| | `ClbDivision_SelectedIndexChanged` | 005 |
| | `CboPlanGroup_SelectedIndexChanged` | 006 |
| | `SpdMain_ComboSelChange` | 013 |
| | `spdMain_CellClick` | 014 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 002 |
| | `SCP.SCP0121_GET_SEARCH_INFO` | 003, 004(빈 결과), 027 |
| | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | 007, 008(빈 결과), 009(오류), 021~025 |
| | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | 015~018, 019(오류), 020(빈 페이로드), 026 |
| 시트 | `Plan Activity Mgmt` | 001, 007, 010~014, 021~024 |
| division | 40 / 81 계열 / 82 / EE 계열 | 021 / 022 / 023 / 024 (차이 없음 확인) |

## 3. 보류 (사실 미확정으로 TC 미작성)

- `SpdMain_ClipboardPasted`(574, dtPlanGroup NAME→CODE 변환): events.csv에 배선이 없습니다. 배선이 확인되면 붙여넣기 TC를 추가합니다.
- 조회조건 필수값 검증, 저장 필수·중복 검증 메시지: Fact Pack에 사실이 없어 원문을 확인한 뒤 TC를 추가합니다.
