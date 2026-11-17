=== FILE: business_analysis.md ===
# SSP0017 업무분석서 — Inventory Raw(Small)

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0017), 1차 분석서(analysis.md · web_components.md · tobe_design.md).
> Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다. 소스에서 주석 처리된 호출 3건(줄 513·531·532)은 현행 기능이 아니므로 이 문서에서 다루지 않습니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0017 / `SSP0017_InventoryRaw` | controls.csv |
| 화면 명칭 | `Inventory Raw(Small)` | props.csv `this.Text` (Designer.cs:589) |
| 도메인 | SSP (`GSCM.SSP.Plan.UIL`) | 파일 구성 |
| 업무 목적 | 조회조건(Plan-date, Division, Plant Site, Inventory Type, Model)으로 재고 Raw 데이터를 조회해 Grid에 표시합니다. SP `SSP0017_GET_INVENTORY_RAW`가 `SSP_ANL_INVENTORY_RAW`를 SELECT합니다. | endpoints.csv |
| 범위 | **조회 전용**입니다. 활성 엔드포인트는 모두 조회(GET / CommonDataList)이고, 저장·삭제 계열 호출은 추출되지 않았습니다. | endpoints.csv |
| 범위 밖 | 주석 처리된 호출 3건(Fact Pack §9) | commented_calls.csv |
| 업무 상세 목적(재고 분석 용도, 사용 부서) | **확인 필요** | Fact Pack에 없음 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` → `InitControls`(:176 `clbDivision.Enabled=false`, :179 `biz:CommonData.CommonDataList` [code=LookupCommon]) → `SetChangedControl`(:365 `biz:CommonData.CommonDataList` [code=PlanDateShip]) | 조회조건 콤보에 공통코드가 채워지고, Division 체크리스트는 비활성 상태가 됩니다. [LookupCommon]이 채우는 컨트롤은 **확인 필요**입니다. | flow.csv, props.csv |
| S2 | Division 선택값이 바뀝니다 | `clbDivision_SelectedIndexChanged` → `SetChangedControl`(:350 `GetCheckedListValue` → :365 `biz:CommonData.CommonDataList` [code=PlanDateShip]) | Plan-date 목록이 다시 조회됩니다(Division 값이 파라미터로 쓰이는지는 **확인 필요**). `clbDivision`이 비활성이므로 이 이벤트가 어떤 경로로 발생하는지도 **확인 필요**입니다. | flow.csv, events.csv |
| S3 | Model 옆 버튼(`btnItemId`)을 누릅니다 | `btnItemId_Click` → :301 `txtItemId.Text = sItemId` | Model 입력란에 값(`sItemId`)이 채워집니다. `sItemId`를 어떻게 얻는지(팝업 여부)는 **확인 필요**입니다. | props.csv |
| S4 | `btnMeasure` 버튼을 누릅니다 | `btnMeasure_Click` (추출된 엔드포인트 없음) | **확인 필요** | events.csv |
| S5 | 조회(Find) 버튼을 누릅니다 | 프레임워크 `FindButton` → `FindData_Main`(:386·387·389·390 `GetCheckedListValue`) → :405 `SSP.SSP0017_GET_INVENTORY_RAW` | Grid 시트 `Inventory Raw(Mobility & IT)`에 결과가 표시되고 컬럼 푸터(합계 행)가 보입니다. | flow.csv, grid_code.csv, props.csv:217 |
| S6 | Grid를 세로로 스크롤합니다 | `SpdMain_TopChange` (추출된 엔드포인트 없음) | **확인 필요** | events.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (this.Load → Form_Load)
     └─ InitControls
          ├─ clbDivision.Enabled = false            (:176)
          ├─ biz:CommonData.CommonDataList [LookupCommon]   (:179)
          └─ SetChangedControl
               └─ biz:CommonData.CommonDataList [PlanDateShip] (:365)
     └─ CreateSpread → AddSheet "Inventory Raw(Mobility & IT)" (:188) → GetSheetInfo(:189) → ChangeSheet(:191)
     └─ InitSpread → InitSheet(:200) → SetSheetHeaderColumn(spdInfo, 1)(:202)  ※ 메타 기반 컬럼 생성
     └─ InitSpreadFooterSum → ColumnFooter.Visible = true (:217)
     └─ InitEvent → 이벤트 배선 (:243~:247)
[2] (선택) Division 변경 → clbDivision_SelectedIndexChanged → SetChangedControl → [PlanDateShip] 재조회
[3] (선택) btnItemId 클릭 → btnItemId_Click → txtItemId.Text = sItemId
[4] (선택) btnMeasure 클릭 → btnMeasure_Click (동작 확인 필요)
[5] 조회 → FindButton → FindData_Main → SSP.SSP0017_GET_INVENTORY_RAW → Grid 표시
[6] (선택) Grid 스크롤 → SpdMain_TopChange (동작 확인 필요)
```

진입점이 연결되지 않은 호출(정적 파서가 호출자를 찾지 못함):
- `GetDivision`(:478) → `SCM.SCM0001_GET_DIVISION`
- `GetDayRange`(:514) → `SCP.SCM0001_GET_SCP_DAY_PERIOD`
- `<field:dtInventoryStatus>`(:49) → `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] (필드 초기화식이므로 클래스 생성 시 실행될 수 있으나 **확인 필요**)

## 4. 업무 규칙

| # | 규칙 | 내용 | 근거 | 확정 여부 |
|---:|---|---|---|---|
| R1 | 필수값 | `Plan-date*` 라벨에 `*`가 있으므로 필수 표시입니다. 미입력 시 검증 메시지 로직은 추출되지 않았습니다. | props.csv:465 | 표시는 확정 / 검증 로직은 **확인 필요** |
| R2 | Division 입력 제한 | `clbDivision.Enabled = false`이므로 사용자가 Division을 직접 바꿀 수 없습니다. | props.csv:176 | 확정 |
| R3 | Division 기본값 | `dtMyDivision` 필드가 `UserInfoContext.Current.NowGroupID`를 읽습니다. 로그인 사용자 그룹 기반으로 Division을 정하는 것으로 보이나 실제 반영 방식은 **확인 필요**입니다. | meta_reads.csv:46 | **확인 필요** |
| R4 | Plan-date 연동 | Plan-date 목록은 `biz:CommonData.CommonDataList` [code=PlanDateShip]로 조회합니다. 화면 진입 시와 Division 변경 시 갱신됩니다. 공통 BIZ `UP_FX_GetCommonDataList`의 해당 코드 분기는 `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V`를 SELECT하고 `STRING_SPLIT`을 참조합니다. | flow.csv, endpoints(DB 보강) | 확정 |
| R5 | 다중 선택 값 전달 | `FindData_Main`에서 `GetCheckedListValue`를 4회(:386·387·389·390) 호출해 체크 리스트의 `CODE` 값을 추출합니다. 어떤 컨트롤 → 어떤 SP 파라미터로 가는지는 **확인 필요**입니다. SP는 `UF_FX_STRING_SPLIT`을 참조하므로 다중 값이 구분자 문자열로 넘어갈 가능성이 있지만, 이 역시 **확인 필요**입니다. | Fact Pack §4-2, endpoints.csv | **확인 필요** |
| R6 | 날짜 변환 | SP `SSP0017_GET_INVENTORY_RAW`는 `FN_CHAR_TO_DATE`를 참조합니다(문자 → 날짜 변환). 어느 파라미터나 컬럼에 적용되는지는 **확인 필요**입니다. | endpoints.csv | **확인 필요** |
| R7 | SP 내부 분기 조건 | SP 본문 분기 조건은 Fact Pack에 없습니다. | — | **확인 필요** |
| R8 | 날짜/버킷 규칙 | `SCM0001_GET_SCP_DAY_PERIOD`는 `SCM_SYS_CALENDAR_M`, `FN_WEEKOFDAY_DATE`, `FN_MULTY_TIME`, `CTE_DATE`를 사용합니다. 다만 이 화면에서는 호출자가 미연결(`GetDayRange`)이라 현행 규칙으로 쓰이는지 **확인 필요**입니다. | flow.csv | **확인 필요** |
| R9 | Grid 컬럼 | `SCM_MST_SHEET_COLUMNS` 메타로 컬럼을 생성합니다(컬럼헤더 1행). 현행 시트 `Inventory Raw(Mobility & IT)`는 메타 31개 중 27개를 표시하고 4개(`LONG_QTY`, `OPERATION_NAME`, `ROUTE_NAME`, `ROUTE_TYPE`)를 숨깁니다. | grid_code.csv:202, grid_effective.csv | 확정 |
| R10 | 합계 행 | 컬럼 푸터를 표시합니다(`ColumnFooter.Visible = true`). 합계 대상 컬럼은 **확인 필요**입니다. | props.csv:217 | 표시는 확정 / 대상은 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

> 이 표의 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 근거 열과 같은 표기를 씁니다.

| # | 엔드포인트 | 호출 메서드(줄) | 진입점 | SP / 처리 | 읽기(SELECT) | 참조 함수 | 쓰기 |
|---:|---|---|---|---|---|---|---|
| D1 | `biz:CommonData.CommonDataList` [code=LookupCommon] | `InitControls`(179) | `Form_Load` | 공통 BIZ → `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | — | 없음 |
| D2 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | `SetChangedControl`(365) | `Form_Load`, `clbDivision_SelectedIndexChanged` | 공통 BIZ → `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V` | `STRING_SPLIT` | 없음 |
| D3 | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] | `<field:dtInventoryStatus>`(49) | 미연결(필드 초기화) | 공통 BIZ → `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER_DETAIL` | — | 없음 |
| D4 | `SSP.SSP0017_GET_INVENTORY_RAW` | `FindData_Main`(405) | `FindButton` | SP `SSP0017_GET_INVENTORY_RAW` | `SSP_ANL_INVENTORY_RAW`, `SCM_MST_ITEM_SN`, `SCM_MST_FACTORY_SN`, `SCM_MST_SLOC`, `SCM_MST_SITE` | `FN_CHAR_TO_DATE`, `UF_FX_STRING_SPLIT` | 없음 |
| D5 | `SCM.SCM0001_GET_DIVISION` | `GetDivision`(478) | 미연결 | SP `SCM0001_GET_DIVISION` | `SCM_MST_DIVISION` | — | 없음 |
| D6 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `GetDayRange`(514) | 미연결 | SP `SCM0001_GET_SCP_DAY_PERIOD` | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `CTE_DATE` | `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE` | 없음 |

- 쓰기(INSERT/UPDATE/DELETE/MERGE) 대상 테이블은 6개 엔드포인트 모두에서 추출되지 않았습니다.
- 엔드포인트별 입력 파라미터 목록과 결과셋 컬럼은 Fact Pack에 없습니다(**확인 필요**).

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Grid 컬럼(Division별) | Division 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 14개 모두 표시 27개(필수+기본 27 / 선택 0)로 같습니다. **Division별 변형은 없습니다.** | grid_effective.csv, Fact Pack §10·§12 |
| 시트 | `Inventory Raw(Mobility & IT)` = META+코드연결(현행) / `Inventory Raw(IT & Mobile)` = 메타 정의만, 코드 미참조(미사용 가능) | grid_effective.csv |
| 코드상 Division 분기 | 분기 조건 판단불가 0건이며, 코드에서 Division 비교 분기는 추출되지 않았습니다. | Fact Pack §12 |
| Division 조회조건 | `clbDivision` 비활성(:176), 기본값 출처는 `NowGroupID`로 보임(**확인 필요**) | props.csv, meta_reads.csv |
| 권한 메타 | `TB_FX_GroupMenuAuth` 14행, `TB_FX_MenuItemInfo` 2행, `TB_FX_ProgramInfo` 2행. 그룹별 C/R/U/D 플래그 값은 **확인 필요**(원문 `dbmeta_dbo_TB_FX_GroupMenuAuth.csv`) | Fact Pack §8 |
| 코드상 권한 분기 | 추출되지 않았습니다. | — |

## 7. 외부 인터페이스

- Fact Pack에서 외부 시스템 인터페이스(I/F) 호출은 추출되지 않았습니다.
- 참고: [code=OWMS_STOCK_STATUS] 공통코드 이름에 `OWMS`가 들어 있고, `SSP_ANL_INVENTORY_RAW`의 적재 원천도 있습니다. 하지만 외부 시스템과 어떤 관계인지(적재 배치 등)는 Fact Pack에 없어 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 사유 |
|---:|---|---|
| 1 | `GetDivision` → `SCM.SCM0001_GET_DIVISION`(SP `SCM0001_GET_DIVISION`) 실사용 여부 | 진입점 미연결 |
| 2 | `GetDayRange` → `SCP.SCM0001_GET_SCP_DAY_PERIOD`(SP `SCM0001_GET_SCP_DAY_PERIOD`) 실사용 여부 | 진입점 미연결 |
| 3 | `dtInventoryStatus` [code=OWMS_STOCK_STATUS]의 사용처 | 바인딩 대상 미추출 |
| 4 | [code=LookupCommon]이 채우는 컨트롤 | 대상 미추출 |
| 5 | `clbPlantSite`, `cboInventoryType` 데이터 출처 | 엔드포인트 미추출 |
| 6 | `FindData_Main`의 `GetCheckedListValue` 4회 ↔ SP `SSP0017_GET_INVENTORY_RAW` 파라미터 매핑 | 파라미터 미추출 |
| 7 | SP `SSP0017_GET_INVENTORY_RAW` 내부 분기·필터 조건과 결과셋 컬럼 | SP 본문 미추출, grid 단계 매칭 시트 없음 |
| 8 | `btnItemId_Click`의 `sItemId` 취득 방식, `btnMeasure_Click`·`SpdMain_TopChange`의 동작 | 엔드포인트 호출 미추출 |
| 9 | `clbDivision.Enabled=false` 상태에서 `clbDivision_SelectedIndexChanged`가 발생하는 경로 | 정적 추출 한계 |
| 10 | `Plan-date*` 미입력 시 검증·메시지 | 검증 로직 미추출 |
| 11 | 푸터 합계 대상 컬럼 | `InitSpreadFooterSum` 세부 미추출 |
| 12 | 그룹별 C/R/U/D 플래그 | 행 수만 있음 |
| 13 | `Inventory Raw(IT & Mobile)` 메타 시트를 폐기할지 여부 | 코드 미참조 |
| 14 | `TB_FX_SearchCondition` 8행(조회조건 저장/복원)의 내용 | 행 수만 있음 |

=== FILE: screen_design.md ===
# SSP0017 화면설계서 — Inventory Raw(Small)

> 근거: AsisFacts Fact Pack(SSP0017) controls.csv · props.csv · events.csv · flow.csv · grid_effective.csv · grid_code.csv.
> Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다. 소스에서 주석 처리된 호출 3건(줄 513·531·532)은 현행 기능이 아니므로 설계 대상에서 제외합니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SSP0017 | Fact Pack |
| 화면 명칭 | `Inventory Raw(Small)` | props.csv `this.Text` (Designer.cs:589) |
| 클래스 | `SSP0017_InventoryRaw` | controls.csv |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 파일 구성 |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 2행, 경로 값 미추출) | Fact Pack §8 |
| 화면 유형 | 조회 전용(조회조건 + 단일 Grid) | endpoints.csv |

## 2. 화면 레이아웃

### 2-1. 분할 구조

- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 없음). 화면은 Dock 배치만으로 구성됩니다.
- controls.csv parent 체인:
  - `this` → `usrConditionPanel1` (Dock Top, 1192×79) → `usrLayoutControl2` (Dock Top, 1192×73) → `cboPlanDate`, `btnMeasure`, `btnItemId`, `clbPlantSite`, `txtItemId`, `cboInventoryType`, `clbDivision`
  - `this` → `panel1` (Dock Fill, 1192×570) → `spdMain` (Dock Fill, 1192×570)
  - parent 없음(레이아웃 아이템·비시각 요소): `usrButton1`, `layoutControlGroup2`, `emptySpaceItem1`, `emptySpaceItem3`, `layoutControlItem7`, `lblItemId`, `layoutControlItem2`, `PlanDate`, `layoutControlItem10`, `lcDivision`, `lblInventoryType`, `imageList1`, `spdMain_Sheet1`
- 상/하 비율(높이 기준, 합계 79 + 570 = 649): 상단 79/649 ≈ **12.2%**, 하단 570/649 ≈ **87.8%**
- 좌/우 분할은 없습니다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────── SSP0017 Inventory Raw(Small) ── 1192 ───────────────────────────────┐
│ [usrConditionPanel1]  Dock=Top  H=79 (≈12.2%)  UsrPanelType=HidePanel(접기 가능)                    │
│ ┌─ [usrLayoutControl2] Dock=Top H=73 / layoutControlGroup2 1192×73 ─────────────────────────────────┐│
│ │ 행A(H=25): [PlanDate: Plan-date* | cboPlanDate](232) [emptySpaceItem1](940)                       ││
│ │ 행B(H=28): [lcDivision: Division | clbDivision](232) [lblInventoryType: Inventory Type |           ││
│ │            cboInventoryType](252) [layoutControlItem7: Plant Site | clbPlantSite](161)            ││
│ │            [lblItemId: Model | txtItemId](154) [layoutControlItem2: btnItemId](43)                ││
│ │            [layoutControlItem10: btnMeasure](43) [emptySpaceItem3](287)                           ││
│ └───────────────────────────────────────────────────────────────────────────────────────────────────┘│
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ [panel1] Dock=Fill H=570 (≈87.8%)                                                                    │
│ ┌─ [spdMain] FpSpread Dock=Fill / [spdMain_Sheet1] ─────────────────────────────────────────────────┐│
│ │  시트: Inventory Raw(Mobility & IT)  (컬럼헤더 1행, 메타 컬럼 27개 표시)                          ││
│ │  ...                                                                                              ││
│ │  [ColumnFooter: 합계 행 Visible=true]                                                             ││
│ └───────────────────────────────────────────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
(배치 위치 미확인: usrButton1 75×23, parent 없음)
```

- 행A/행B 구분은 LayoutControlItem 높이(25 / 28)와 행별 너비 합(각 1172)으로 추정한 것입니다. Location 좌표가 Fact Pack에 없으므로 **행 배치와 아이템 순서는 확인 필요**입니다.

### 2-3. 영역 정의

| 영역 | 구성 | 비고 |
|---|---|---|
| 조회조건 | `usrConditionPanel1` > `usrLayoutControl2` | HidePanel(접기 가능) |
| 버튼 | 프레임워크 조회 버튼(`FindButton`), 조건 영역 내 `btnItemId`·`btnMeasure`, 배치 미확인 `usrButton1` | |
| 그리드 | `panel1` > `spdMain` / `spdMain_Sheet1` | 메타 기반, 푸터 합계 |
| 팝업 | `btnItemId_Click`이 `txtItemId.Text = sItemId`로 값을 넣습니다. 팝업 사용 여부는 **확인 필요**입니다. | props.csv:301 |

## 3. 컨트롤 명세

> 라벨은 props.csv `Text` 원문입니다. 단위테스트 절차 열에서도 같은 컨트롤명을 씁니다.

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 / 초기 상태 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | (Text 없음) | Dock Top, 1192×79, `HidePanel` | — | — | 조회조건 패널(접기 가능) 공용 컴포넌트 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (Designer 기본 Text, 화면 미노출로 보임 — 확인 필요) | Dock Top, 1192×73 | — | — | 조회조건 레이아웃(그리드형 배치) |
| `cboPlanDate` | UsrCombo | `Plan-date*` (PlanDate) | [code=PlanDateShip] 목록. 기본 선택값은 확인 필요 | 필수(`*`) | (값 공급: `Form_Load`·`clbDivision_SelectedIndexChanged` → `SetChangedControl`) | 단일 선택 ComboBox |
| `clbDivision` | UsrCheckedList | `Division` (lcDivision) | `Enabled=false` (:176). 기본값은 `NowGroupID` 기반으로 보임(확인 필요) | 확인 필요 | `clbDivision_SelectedIndexChanged` | 다중 선택 MultiSelect(비활성) |
| `cboInventoryType` | UsrCombo | `Inventory Type` (lblInventoryType) | 데이터 출처 확인 필요([LookupCommon] 후보) | 확인 필요 | — | 단일 선택 ComboBox |
| `clbPlantSite` | UsrCheckedList | `Plant Site` (layoutControlItem7) | 데이터 출처 확인 필요 | 확인 필요 | — | 다중 선택 MultiSelect |
| `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 빈 값(확인 필요). `btnItemId_Click`이 값을 채움 | 확인 필요 | (값 수신: `btnItemId_Click`) | 멀티라인(다건) 입력 공용 컴포넌트 |
| `btnItemId` | UsrButton | (Text 미추출, layoutControlItem2) | 39×24 | — | `btnItemId_Click` | 아이콘 버튼(Model 옆) |
| `btnMeasure` | UsrButton | (Text 미추출, layoutControlItem10) | 39×24 | — | `btnMeasure_Click` | 아이콘 버튼(동작 확인 필요) |
| `usrButton1` | UsrButton | (Text 미추출) | 75×23, parent 없음 | — | 없음 | **확인 필요**(화면 배치 여부 미확인) |
| `spdMain` | FpSpread | — | Dock Fill 1192×570, 시트 `Inventory Raw(Mobility & IT)` | — | `SpdMain_TopChange` | Wijmo FlexGrid(공용 Grid) |
| `spdMain_Sheet1` | SheetView | — | 컬럼헤더 1행, ColumnFooter Visible | — | — | FlexGrid 시트(컬럼 푸터 합계) |
| (화면) `this` | Form | `Inventory Raw(Small)` | — | — | `Form_Load` | 화면 페이지 |
| (프레임워크) FindButton | 공통 조회 버튼 | — | — | — | → `FindData_Main` | 공통 조회 버튼 |

## 4. 그리드 명세

### 4-1. 시트 구성

| 시트 | 연결 규칙 | 메타 컬럼 | 표시 | 숨김 | 근거 |
|---|---|---:|---:|---:|---|
| `Inventory Raw(Mobility & IT)` | META+코드연결 (현행) — `CreateSpread`:188 AddSheet → :191 ChangeSheet → `InitSpread`:200 InitSheet → :202 `SetSheetHeaderColumn(spdInfo, 1)` | 31 | 27 | 4 | grid_code.csv |
| `Inventory Raw(IT & Mobile)` | 메타 정의만, 코드 미참조(미사용 가능, 폐기 후보) | 31 | 27 | 4 | grid_effective.csv |

### 4-2. 컬럼 표 (두 시트 공통 — grid_effective.csv)

- 순서: CSV 정렬 순서(알파벳)입니다. 실제 표시 순서는 **확인 필요**입니다.
- 타입: 메타 `CELL_CONTROL_OBJECT_TYPE_CODE` 값이 Fact Pack에 없어 **확인 필요**입니다.
- 편집 가능 여부: 메타 편집 속성 값이 미추출이고 저장 엔드포인트가 없으므로 **조회 전용으로 보임(확인 필요)**입니다.
- Division별 표시: 14개 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다.

| # | 컬럼 | 헤더(원문) | 타입 | 출처 | `Inventory Raw(Mobility & IT)` | `Inventory Raw(IT & Mobile)` | Division별 표시 | 편집 |
|---:|---|---|---|---|---|---|---|---|
| 1 | AVAILABLE_QTY | Available Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 2 | BUILDING | Building | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 3 | CAPACITY | Capacity | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 4 | CURRENT_OP_START_DATE | Current OP Start Date | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 5 | CUSTOMER | Customer | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 6 | DIVISION_ID | Div | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 7 | EXP_FORMATION_END_DATE | Exp. Formation End Date | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 8 | EXPIRATION_QTY | Expiration Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 9 | HOLD_QTY | Hold Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 10 | HOLD_YN | Hold YN | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 11 | INVENTORY_STATUS | Inventory Status | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 12 | INVENTORY_TYPE | Inventory Type | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 13 | LINE | Line | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 14 | LONG_QTY | Long-Term Qty | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 15 | LOT | Lot | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 16 | LOT_ID | Lot ID | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 17 | MODEL | Model | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 18 | NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 19 | OPERATION | Operation | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 20 | OPERATION_NAME | Operation Name | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 21 | PALLET_ID | Pallet ID | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 22 | PLANT_SITE | Plant Site | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 23 | PRODUCTION_DATE | Production Date | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 24 | REMAIN_LEAD_TIME | Remain Lead Time(Day) | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 25 | ROUTE | Route | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 26 | ROUTE_NAME | Route Name | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 27 | ROUTE_TYPE | Route Type | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 28 | SOC | SOC | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 29 | SPECIAL_YN | Special YN | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 30 | STOCK_QTY | Stock Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 31 | VALTAGE | Valtage | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |

- HARDCODED 컬럼은 없습니다. 코드 변경은 Designer.cs:555~558의 `ColumnHeaderDefaultEnhanced` 스타일 4건(HorizontalAlignment=General, NoteIndicatorColor=Red, Parent, VerticalAlignment=General)뿐이며, 컬럼을 추가하거나 숨기지 않습니다.
- 컬럼 푸터(합계 행): `InitSpreadFooterSum`:217 `ColumnFooter.Visible = true`. 합계 대상 컬럼은 **확인 필요**입니다.
- 헤더 `Valtage`는 메타 원문 철자입니다.

## 5. 액션 명세

> 엔드포인트 이름은 업무분석서 §5 데이터 흐름, 단위테스트 근거 열과 같습니다.

| # | 버튼 / 이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드(`this.Load`, .ctor:122) | `Form_Load` | `InitControls`(:176 `clbDivision.Enabled=false`) → `SetChangedControl` → `CreateSpread` / `InitSpread` / `InitSpreadFooterSum` / `InitEvent` | `biz:CommonData.CommonDataList` [code=LookupCommon] (:179), `biz:CommonData.CommonDataList` [code=PlanDateShip] (:365) | 조회조건 콤보 채움(LookupCommon 대상 컨트롤은 확인 필요), `cboPlanDate` 목록, `spdMain` 시트 `Inventory Raw(Mobility & IT)` 생성 |
| A2 | `clbDivision` SelectedIndexChanged (InitEvent:247) | `clbDivision_SelectedIndexChanged` | `SetChangedControl`(:350 `GetCheckedListValue`) | `biz:CommonData.CommonDataList` [code=PlanDateShip] | `cboPlanDate` 목록 갱신 |
| A3 | `btnItemId` Click (InitEvent:244) | `btnItemId_Click` | :301 `txtItemId.Text = sItemId` | 추출 없음 | `txtItemId` 값 반영 |
| A4 | `btnMeasure` Click (InitEvent:245) | `btnMeasure_Click` | **확인 필요** | 추출 없음 | **확인 필요** |
| A5 | 조회(프레임워크 FindButton) | `FindData_Main` | `GetCheckedListValue`(:386·387·389·390)로 조건 수집 | `SSP.SSP0017_GET_INVENTORY_RAW` (:405) → SP `SSP0017_GET_INVENTORY_RAW` | `spdMain` 결과 바인딩, 푸터 합계 |
| A6 | `spdMain` TopChange (InitEvent:243) | `SpdMain_TopChange` | **확인 필요** | 추출 없음 | **확인 필요** |
| A7 | (진입점 미연결) | `GetDivision`(:478) | 호출자 미발견 | `SCM.SCM0001_GET_DIVISION` → SP `SCM0001_GET_DIVISION` | **확인 필요** (실사용 시 Division 목록 용도로 보임) |
| A8 | (진입점 미연결) | `GetDayRange`(:514) | 호출자 미발견 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` → SP `SCM0001_GET_SCP_DAY_PERIOD` | **확인 필요** |
| A9 | (필드 초기화) | `<field:dtInventoryStatus>`(:49) | 클래스 생성 시 실행 가능(확인 필요) | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] | 바인딩 대상 **확인 필요** |

## 6. 검증·메시지

| # | 항목 | 사실 | 확정 여부 |
|---:|---|---|---|
| V1 | Plan-date 필수 | 라벨 `Plan-date*`의 `*` 표시 | 표시 확정. 미입력 검증 코드와 메시지 문구는 **확인 필요** |
| V2 | Division 수정 불가 | `clbDivision.Enabled=false` | 확정 |
| V3 | 조회 결과 0건 메시지 | 추출되지 않음 | **확인 필요** |
| V4 | 오류 응답 메시지 | 추출되지 않음(프레임워크 공통 처리로 보임) | **확인 필요** |

## 7. 권한(C/R/U/D) 사실

| 항목 | 값 |
|---|---|
| `TB_FX_GroupMenuAuth` 화면 행 수 | 14 |
| `TB_FX_MenuItemInfo` / `TB_FX_ProgramInfo` | 2 / 2 |
| `TB_FX_Favorite` | 9 |
| `TB_FX_SearchCondition` | 8 |
| C/U/D 엔드포인트 | 없음 (R만 존재) |
| 코드상 권한 분기 | 추출되지 않음 |
| 그룹별 C/R/U/D 플래그 값 | **확인 필요** |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| M1 | Grid | FarPoint `spdMain` + `SetSheetHeaderColumn` 메타 | Wijmo FlexGrid 공용 Grid + `SCM_MST_SHEET_COLUMNS` 대응 메타로 컬럼 구성. 시트 `Inventory Raw(Mobility & IT)` 기준 27개 표시·4개 숨김을 유지합니다. |
| M2 | 합계 행 | `ColumnFooter.Visible = true` | FlexGrid 컬럼 푸터(columnFooters) 합계 행. 합계 대상 컬럼은 확인 후 지정합니다. |
| M3 | 다중 선택 조건 | `UsrCheckedList` + `GetCheckedListValue`(CODE) | MultiSelect 계열 공용 컴포넌트. SP가 `UF_FX_STRING_SPLIT`을 참조하므로 Oracle 쪽 문자열 분해 함수 대응을 확인해야 합니다. |
| M4 | 공통코드 | `biz:CommonData.CommonDataList`(`UP_FX_GetCommonDataList`) | 공용 공통코드 조회 API. [PlanDateShip] 분기가 MSSQL `STRING_SPLIT`을 참조하므로 Oracle 변환 시 대체가 필요합니다. |
| M5 | 조회 SP | MSSQL SP `SSP0017_GET_INVENTORY_RAW` | Oracle 19c 패키지/프로시저로 전환. 참조 함수 `FN_CHAR_TO_DATE`, `UF_FX_STRING_SPLIT`의 Oracle 대응이 필요합니다. |
| M6 | 미연결 호출 | `GetDivision`, `GetDayRange`, `dtInventoryStatus` | 실사용 여부를 확인한 뒤 To-Be 반영 여부를 결정합니다. |
| M7 | 조회조건 패널 | `HidePanel` | 접기 가능한 조회조건 패널 공용 컴포넌트 |
| M8 | Grid 스크롤 이벤트 | `SpdMain_TopChange` | 동작을 확인한 뒤 FlexGrid 스크롤 이벤트로 대응할지 판단합니다. |
| M9 | 미사용 시트 | `Inventory Raw(IT & Mobile)` 메타 | 코드 미참조. 이관 여부를 결정해야 합니다. |

## 9. 미확정

1. 메뉴 위치
2. 조회조건 아이템의 실제 행·열 배치(Location 미추출)
3. `usrButton1` 배치 여부와 용도
4. `btnItemId_Click`(`sItemId` 취득 방식), `btnMeasure_Click`, `SpdMain_TopChange`의 동작
5. `cboInventoryType`·`clbPlantSite` 데이터 출처, [LookupCommon] 대상 컨트롤
6. `clbDivision` 기본값과 비활성 상태에서 `clbDivision_SelectedIndexChanged`가 발생하는 경로
7. Grid 컬럼 표시 순서·타입·편집 여부·합계 대상, 숨김 4개 컬럼의 사유
8. SP 결과셋 컬럼과 메타 컬럼의 일치 여부
9. `GetDivision`·`GetDayRange`·`dtInventoryStatus`의 실사용 여부
10. 검증 메시지 문구, 그룹별 권한 플래그

=== FILE: unit_test.md ===
# SSP0017 단위테스트 — Inventory Raw(Small)

> 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5, 화면설계서 §5와 같은 원문입니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 Fact Pack으로 확정할 수 없는 부분은 "(확인 필요)"로 표기했습니다. 주석 처리된 호출은 테스트 대상이 아닙니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0017-001 | 초기화 | 권한 있는 계정으로 로그인 | 메뉴에서 SSP0017 화면을 엽니다 | — | 화면 제목 `Inventory Raw(Small)`이 표시되고, `usrConditionPanel1`·`usrLayoutControl2`·`spdMain`이 렌더링됩니다 | `Form_Load` |
| TC-SSP0017-002 | 초기화 | TC-001 | 화면을 연 직후 공통코드 호출을 확인합니다(네트워크/로그) | code=LookupCommon | 공통코드 조회가 1회 수행되고 조회조건 콤보가 채워집니다(대상 컨트롤은 확인 필요) | `Form_Load` > `InitControls`, `biz:CommonData.CommonDataList` [LookupCommon] |
| TC-SSP0017-003 | 초기화 | TC-001 | 화면을 연 직후 `cboPlanDate` 목록을 펼칩니다 | code=PlanDateShip | Plan-date 목록이 표시됩니다(원천: `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V`) | `Form_Load` > `SetChangedControl`, `biz:CommonData.CommonDataList` [PlanDateShip] |
| TC-SSP0017-004 | 초기화 | TC-001 | `clbDivision`을 클릭해 선택을 바꿔 봅니다 | — | `clbDivision`이 비활성(Enabled=false)이라 선택을 바꿀 수 없습니다 | `Form_Load` > `InitControls`:176 |
| TC-SSP0017-005 | 초기화 | TC-001 | `usrConditionPanel1` 접기/펼치기를 실행합니다 | — | 조회조건 패널이 접히고 펼쳐집니다(HidePanel) | `Form_Load` (props `UsrPanelType=HidePanel`) |
| TC-SSP0017-006 | 이벤트 | TC-001. Division 값이 프로그램적으로 바뀌는 경로 확보(확인 필요) | `clbDivision`의 선택값을 바꿉니다 | Division 다른 값 | `SetChangedControl`이 실행되고 `cboPlanDate` 목록이 다시 조회됩니다 | `clbDivision_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [PlanDateShip] |
| TC-SSP0017-007 | 이벤트 | TC-001 | `btnItemId`를 클릭하고 값을 선택합니다(선택 UI는 확인 필요) | 임의 Model 값(`sItemId`) | `txtItemId`에 선택한 값이 입력됩니다 | `btnItemId_Click` (:301 `txtItemId.Text = sItemId`) |
| TC-SSP0017-008 | 이벤트 | TC-001 | `btnMeasure`를 클릭합니다 | — | 핸들러가 오류 없이 실행됩니다. 구체 결과는 확인 필요입니다 | `btnMeasure_Click` |
| TC-SSP0017-009 | 이벤트 | TC-010으로 다건 조회 완료 | `spdMain`을 세로로 스크롤합니다 | — | 핸들러가 오류 없이 실행되고 Grid 표시가 유지됩니다. 구체 동작은 확인 필요입니다 | `SpdMain_TopChange` |
| TC-SSP0017-010 | 조회 | TC-001 | `cboPlanDate`를 선택하고 `clbPlantSite`·`cboInventoryType`·`txtItemId`를 지정한 뒤 조회(FindButton)를 누릅니다 | 데이터가 있는 Plan-date / Plant Site / Inventory Type / Model | 조회 1회가 수행되고 `spdMain`에 결과 행이 표시됩니다 | `FindData_Main`, `SSP.SSP0017_GET_INVENTORY_RAW`, SP `SSP0017_GET_INVENTORY_RAW` |
| TC-SSP0017-011 | 조회 | TC-001 | `clbPlantSite`에서 여러 항목을 체크한 뒤 조회합니다 | Plant Site 2개 이상 | 선택한 Plant Site 전부가 결과에 반영됩니다(CODE 다중 전달, 파라미터 매핑은 확인 필요) | `FindData_Main` (`GetCheckedListValue`), `SSP.SSP0017_GET_INVENTORY_RAW` |
| TC-SSP0017-012 | 조회 | TC-001 | `txtItemId`에 여러 줄로 Model을 입력하고 조회합니다 | Model 2건 이상(줄바꿈) | 입력한 Model 전부가 결과에 반영됩니다(구분 처리는 확인 필요) | `SSP.SSP0017_GET_INVENTORY_RAW` (REF `UF_FX_STRING_SPLIT`) |
| TC-SSP0017-013 | 조회 | TC-001 | 결과가 없는 조건으로 조회합니다 | 존재하지 않는 Model 값 | `spdMain`이 0행으로 표시되고 오류가 없습니다(안내 메시지는 확인 필요) | `SSP.SSP0017_GET_INVENTORY_RAW` (빈 결과) |
| TC-SSP0017-014 | 조회 | TC-001 | `cboPlanDate`를 비운 채 조회합니다 | Plan-date 미선택 | 필수값 안내가 나오거나 조회가 차단됩니다(메시지 문구는 확인 필요) | `FindData_Main`, `SSP.SSP0017_GET_INVENTORY_RAW` (`Plan-date*` 필수 표시) |
| TC-SSP0017-015 | 조회 | 서버/DB 오류 유발 환경(예: SP 실행 실패) | 조회를 누릅니다 | 정상 조건 | 오류 메시지가 표시되고 화면은 그대로 유지됩니다. 기존 Grid 처리 방식은 확인 필요입니다 | `SSP.SSP0017_GET_INVENTORY_RAW` (오류 응답) |
| TC-SSP0017-016 | 조회 | 공통코드 조회 오류 유발 환경 | 화면을 엽니다 | code=PlanDateShip | 오류 메시지가 표시되고 `cboPlanDate`가 빈 상태가 됩니다. 처리 방식은 확인 필요입니다 | `Form_Load`, `biz:CommonData.CommonDataList` [PlanDateShip] (오류 응답) |
| TC-SSP0017-017 | 그리드 | TC-010 | `spdMain` 시트명과 컬럼 헤더를 확인합니다 | — | 시트 `Inventory Raw(Mobility & IT)`, 컬럼헤더 1행, 표시 컬럼 27개(Available Qty … Valtage) | 시트 `Inventory Raw(Mobility & IT)`, `SetSheetHeaderColumn`(InitSpread:202) |
| TC-SSP0017-018 | 그리드 | TC-010 | 숨김 컬럼이 노출되는지 확인합니다 | — | `LONG_QTY`(Long-Term Qty), `OPERATION_NAME`(Operation Name), `ROUTE_NAME`(Route Name), `ROUTE_TYPE`(Route Type)이 표시되지 않습니다 | 시트 `Inventory Raw(Mobility & IT)` (grid_effective 숨김 4) |
| TC-SSP0017-019 | 그리드 | TC-010 | Grid 하단 푸터를 확인합니다 | — | 컬럼 푸터(합계 행)가 표시됩니다. 합계 대상 컬럼은 확인 필요입니다 | 시트 `Inventory Raw(Mobility & IT)` (`InitSpreadFooterSum`:217) |
| TC-SSP0017-020 | 그리드 | TC-001 | 화면에 생성된 시트 목록을 확인합니다 | — | 시트 `Inventory Raw(IT & Mobile)`은 생성되지 않습니다(메타 정의만 있고 코드에서 참조하지 않음). 메타 31개(표시 27·숨김 4)가 현행 시트와 같은지 DB에서 대조합니다 | 시트 `Inventory Raw(IT & Mobile)` |
| TC-SSP0017-021 | division | Division 40 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=40 | 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (Division 40 = 27/0) |
| TC-SSP0017-022 | division | Division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC) 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=81 계열 | 각 Division 모두 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (81 계열 = 27/0) |
| TC-SSP0017-023 | division | Division 82 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=82 | 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (82 = 27/0) |
| TC-SSP0017-024 | division | Division EE 계열(EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=EE 계열 | 각 Division 모두 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (EE 계열 = 27/0) |
| TC-SSP0017-025 | division | 서로 다른 그룹(NowGroupID) 사용자 2명 | 각각 화면을 열어 `clbDivision`의 기본 선택값을 확인합니다 | 사용자 A / B | 사용자 그룹에 맞는 Division이 기본 선택됩니다(반영 방식은 확인 필요) | `Form_Load` (`dtMyDivision` ← `NowGroupID`) |
| TC-SSP0017-026 | 권한 | 조회 권한만 있는 그룹 사용자 | 화면을 열고 조회합니다 | — | 조회가 가능하고 저장·삭제 기능은 없습니다. 그룹별 C/R/U/D 플래그 값은 확인 필요입니다 | `SSP.SSP0017_GET_INVENTORY_RAW` (`TB_FX_GroupMenuAuth` 14행) |
| TC-SSP0017-027 | 초기화 | 소스 또는 실행 추적 환경 | 화면 진입부터 조회까지 수행하면서 Division 조회 호출이 일어나는지 추적합니다 | — | 진입점 미연결이므로 호출이 없어야 합니다. 호출이 확인되면 실사용으로 분류하고 Division 목록이 `SCM_MST_DIVISION` 기준과 일치하는지 검증합니다 | `GetDivision`, `SCM.SCM0001_GET_DIVISION`, SP `SCM0001_GET_DIVISION` |
| TC-SSP0017-028 | 초기화 | 소스 또는 실행 추적 환경 | 화면 진입부터 조회까지 수행하면서 기간 조회 호출이 일어나는지 추적합니다 | — | 진입점 미연결이므로 호출이 없어야 합니다. 호출이 확인되면 실사용으로 분류하고 `SCM_SYS_CALENDAR_M` 기준 기간이 반환되는지 검증합니다 | `GetDayRange`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0017-029 | 초기화 | 실행 추적 환경 | 화면 클래스 생성 시 재고상태 공통코드 호출이 일어나는지 추적합니다 | code=OWMS_STOCK_STATUS | 호출 여부를 기록합니다. 호출되는 경우 결과가 바인딩되는 대상을 확인합니다(확인 필요) | `<field:dtInventoryStatus>`, `biz:CommonData.CommonDataList` [OWMS_STOCK_STATUS] |

### 근거 커버리지

| 구분 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003, 004, 005, 016, 025 |
| | `SpdMain_TopChange` | 009 |
| | `btnItemId_Click` | 007 |
| | `btnMeasure_Click` | 008 |
| | `clbDivision_SelectedIndexChanged` | 006 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 002, 003, 006, 016, 029 |
| | `SSP.SSP0017_GET_INVENTORY_RAW` | 010~015, 026 |
| | `SCM.SCM0001_GET_DIVISION` | 027 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 028 |
| 시트 | `Inventory Raw(Mobility & IT)` | 017, 018, 019, 021~024 |
| | `Inventory Raw(IT & Mobile)` | 020 |
| division | 40 / 81 계열 / 82 / EE 계열 | 021 / 022 / 023 / 024 |
| 빈 결과·오류 | 빈 결과 013, 필수 미입력 014, 오류 응답 015·016 | |
