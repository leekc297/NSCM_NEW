=== FILE: business_analysis.md ===
# SSP0012 업무분석서 — Shipment Plan Confirm Detail

> **작성 근거**: AsisFacts 정적 추출 Fact Pack(SSP0012)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)
> **작성 원칙**: Fact Pack에 있는 사실만 썼습니다. 추출되지 않은 내용은 **확인 필요**로 표기했습니다.
> **관련 문서**: 화면설계서 `screen_design.md` §5 액션 명세, 단위테스트 `unit_test.md` 근거 열. 세 문서의 엔드포인트 이름은 같습니다.

---

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SSP0012 | Fact Pack §1 |
| 클래스 | `SSP0012_ShipmentPlanConfirmDetail` | controls.csv |
| 폼 Text | `Shipment Plan Confirm` | props.csv Designer.cs:545 |
| 도메인 / 프로젝트 | SSP / `GSCM.SSP.Plan.UIL` | Fact Pack §1 |
| 업무 목적 | 선적계획 확정(Shipment Plan Confirm) 상세 데이터를 조건별로 조회합니다. | 엔드포인트명 `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, 시트명 `Shipment Plan Confirm Detail` |
| 업무 범위 | **조회 전용**입니다. 저장·삭제·업로드 엔드포인트는 추출되지 않았습니다. | Fact Pack §3 (활성 엔드포인트 3종이 모두 조회/코드 조회) |
| 업무 목적의 상세 정의 | 확정 데이터의 생성 주체, 확정 시점, 후속 업무 연계는 **확인 필요**입니다. | Fact Pack에 없음 |

**현행 엔드포인트 3종**

| # | 엔드포인트 | 구분 | SP |
|---:|---|---|---|
| 1 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | 메인 조회 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| 2 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값 조회 | `SCM0001_GET_SCP_DAY_PERIOD` |
| 3 | `biz:CommonData.CommonDataList` | 공통코드 조회. 코드는 `LookupCommon`, `PERIOD_{p:value} \|\| PERIOD_DEFAULT` | (프레임워크 BIZ. 코드 분기는 `UP_FX_GetCommonDataList`) |

- 주석 처리된 호출 1건(595행)이 있습니다. 현행 기능이 아니므로 이 문서의 업무 범위·흐름·규칙에서 모두 뺐습니다.

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 메뉴에서 화면을 엽니다. | `Form_Load` > `InitControls` > `GetDayRange` 순으로 `SCP.SCM0001_GET_SCP_DAY_PERIOD`(SP `SCM0001_GET_SCP_DAY_PERIOD`)를 호출합니다. 그리드는 `CreateSpread`/`InitSpread` 에서 시트 `Shipment Plan Confirm Detail` 로 만들어집니다. | 기간(drpPeriod) 기본값이 들어갑니다(반영 방식은 **확인 필요**). 그리드 헤더는 2행이고 표시 컬럼은 44개입니다. | flow.csv, events.csv(.ctor:186), grid_code.csv |
| S2 | Division(clbDivision) 선택을 바꿉니다. | `clbDivision_SelectedIndexChanged` > `SetChangedControl` > `GetDayRange` 순으로 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 를 다시 호출합니다. `SetChangedControl:366` 에서 `GetCheckedListValue`(CODE)를 읽습니다. | 기간이 다시 계산됩니다(반영 값은 **확인 필요**). | flow.csv, events.csv(InitEvent:282), Fact Pack §4-2 |
| S3 | Model 검색 버튼(btnItemId)을 누릅니다. | `btnItemId_Click` 이 실행되고 341행에서 `txtItemId.Text = sItemId` 를 대입합니다. | Model 입력란에 값이 채워집니다. `sItemId` 를 얻는 방식(팝업 여부)은 **확인 필요**입니다. | events.csv(InitEvent:278), props.csv(:341) |
| S4 | 조회 조건을 넣고 조회(FindButton)를 누릅니다. | `FindButton` > `FindData_Main` 순으로 `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`(SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`)를 호출합니다(418행). 398·399행에서 `GetCheckedListValue`(CODE)를 읽습니다. | 시트 `Shipment Plan Confirm Detail` 에 결과가 표시됩니다(바인딩 방식은 **확인 필요**). | flow.csv, endpoints.csv |
| S5 | 컬럼 버튼(btnColumn)을 누릅니다. | `BtnColumn_Click` 이 실행됩니다. | **확인 필요** (핸들러 본문 미추출) | events.csv(InitEvent:284) |
| S6 | 그리드 셀을 클릭합니다. | `SpdMain_CellClick` 이 실행됩니다. | **확인 필요**. 이미지 셀 `INCOTERMS`/`CHANGE_REQ_NO` 와의 관계도 **확인 필요**입니다. | events.csv(InitEvent:280), grid_code.csv(270·271) |
| S7 | 그리드를 스크롤합니다(상단 행이 바뀜). | `SpdMain_TopChange` 가 실행됩니다. | **확인 필요** | events.csv(InitEvent:277) |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  └─(1) Form_Load
        └─ InitControls ──(InitControls:237 c["CODE"] 사용)
              └─ GetDayRange ──▶ SCP.SCM0001_GET_SCP_DAY_PERIOD
                                   └─ SP SCM0001_GET_SCP_DAY_PERIOD
                                        (SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL 조회)
        └─ CreateSpread → AddSheet("Shipment Plan Confirm Detail") → GetSheetInfo → ChangeSheet
        └─ InitSpread → InitSheet → SetSheetHeaderColumn(spdInfo, 2)  ※ 메타 SCM_MST_SHEET_COLUMNS
                      → INCOTERMS / CHANGE_REQ_NO CellType = cellTypeImage
        ※ CreateSpread/InitSpread 가 Form_Load 경로 안에서 호출되는지는 확인 필요

[조회조건 입력]
  ├─(2) Division 변경 → clbDivision_SelectedIndexChanged → SetChangedControl
  │        └─ GetCheckedListValue(CODE) → GetDayRange ──▶ SCP.SCM0001_GET_SCP_DAY_PERIOD
  └─(3) Model 버튼 → btnItemId_Click → txtItemId.Text = sItemId

[조회]
  └─(4) FindButton → FindData_Main
        └─ GetCheckedListValue(CODE) ×2 (398, 399행)
        └─ ──▶ SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
                 └─ SP SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
                      (#TBLDYNAMICPIVOT_SSP0012 생성·조회, 동적 SQL, FN_GET_IN_STR, FN_SCM_SPLIT)
        └─ 시트 "Shipment Plan Confirm Detail" 표시

[그리드 조작]
  ├─(5) SpdMain_CellClick   — 동작 확인 필요
  ├─(6) SpdMain_TopChange   — 동작 확인 필요
  └─(7) BtnColumn_Click     — 동작 확인 필요

[진입점 미연결 (정적 분석상 호출자 없음)]
  ├─ <field:dtFcstType> (56행) ──▶ biz:CommonData.CommonDataList [code=LookupCommon]
  ├─ <field:dtBaseDay>  (57행) ──▶ biz:CommonData.CommonDataList [code=LookupCommon]
  └─ SetChangedPeriod  (542행) ──▶ biz:CommonData.CommonDataList [code=PERIOD_{p:value} || PERIOD_DEFAULT]
                                    → dt.Rows[0]["FROM_VALUE"], ["TO_VALUE"] (549·550행)
```

---

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 내용 | 근거 | 상태 |
|---:|---|---|---|---|
| R1 | 기간 기본값 | 화면을 열 때 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과로 기간을 정합니다. | flow.csv(Form_Load > InitControls > GetDayRange, 596행) | 사실 |
| R2 | Division 연동 기간 재계산 | Division 선택이 바뀌면 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 를 다시 호출합니다. 이때 CheckedList 선택값(CODE)을 읽습니다(366행). | flow.csv, Fact Pack §4-2 | 사실. 파라미터로 넘기는 값은 **확인 필요** |
| R3 | 기간 계산 기준 | SP `SCM0001_GET_SCP_DAY_PERIOD` 는 `SCM_SYS_CALENDAR_M`(달력), `SCM_ADM_LOOKUP_MASTER_DETAIL`(Lookup), `FN_WEEKOFDAY_DATE`, `FN_MULTY_TIME`, CTE `CTE_DATE` 를 참조합니다. | endpoints.csv objects | 참조 사실만 있음. 계산식(주차·버킷 규칙)은 **확인 필요** |
| R4 | 기간 필수 표시 | 기간 라벨이 `Period*` 입니다. 라벨에 `*` 필수 표시가 있습니다. | props.csv:453 | 표시 사실. 조회 전 필수값 검증 로직·메시지는 **확인 필요** |
| R5 | 다중 선택 조건 | 조회할 때 CheckedList 선택값(CODE)을 2곳(398·399행)에서 읽습니다. 대상 컨트롤(clbPlantSite / clbDivision 대응)은 **확인 필요**입니다. | Fact Pack §4-2 | 사실 + 확인 필요 |
| R6 | 다중값 분해 | 메인 SP가 `FN_GET_IN_STR`, `FN_SCM_SPLIT` 을 참조합니다. | endpoints.csv | 참조 사실. 어느 파라미터를 분해하는지는 **확인 필요** |
| R7 | 결과 동적 피벗 | 메인 SP가 `#TBLDYNAMICPIVOT_SSP0012` 를 만들고 조회하며 동적 SQL(`DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`)을 씁니다. | endpoints.csv | 사실. 피벗 축과 결과 컬럼은 **확인 필요** |
| R8 | 요일 버킷 컬럼 | 그리드 메타에 요일 컬럼 `DAYS_MON`~`DAYS_SUN`(7개)이 있습니다. | grid_effective.csv | 사실. 요일별 값의 의미(수량/여부)는 **확인 필요** |
| R9 | 기간 공통코드 분기 | `SetChangedPeriod` 는 `PERIOD_{값}` 코드를 쓰고, 없으면 `PERIOD_DEFAULT` 를 써서 `FROM_VALUE`/`TO_VALUE` 를 읽습니다. | endpoints.csv(542), meta_reads.csv(549·550) | 정적 분석상 호출자가 없습니다. 현행 동작인지 **확인 필요** |
| R10 | 그리드 표시 컬럼 | 메타 47개 중 44개를 표시합니다. 숨김 3개는 `BOD_ID`, `ORIGIN_FROM_DIVISION_ID`, `PLAN_QTY` 입니다. | grid_effective.csv | 사실 |
| R11 | 이미지 셀 | `INCOTERMS`, `CHANGE_REQ_NO` 의 CellType 은 `cellTypeImage` 입니다. | grid_code.csv(270·271) | 사실. 이미지 의미는 **확인 필요** |
| R12 | Model 입력 | Model 버튼 결과를 `txtItemId.Text` 에 넣습니다. | props.csv(:341) | 사실 |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 위치 | SP | 읽기 (SELECT/REF) | 쓰기 | 비고 |
|---|---|---|---|---|---|
| `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | FindData_Main:418 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | `#TBLDYNAMICPIVOT_SSP0012`(임시), FN `FN_GET_IN_STR`, FN `FN_SCM_SPLIT`, 동적 SQL | 영구 테이블 쓰기 없음. 임시 테이블 `#TBLDYNAMICPIVOT_SSP0012` 만 CREATE | 동적 SQL 안의 원천 테이블은 **확인 필요** |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange:596 (Form_Load, clbDivision_SelectedIndexChanged 두 경로) | `SCM0001_GET_SCP_DAY_PERIOD` | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, CTE `CTE_DATE`, FN `FN_MULTY_TIME`, FN `FN_WEEKOFDAY_DATE` | 없음 | 공용 SP(SCP 영역) |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | `<field:dtFcstType>`:56, `<field:dtBaseDay>`:57 | (BIZ) 코드 분기 `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | 없음 | 진입점 미연결. 사용처 **확인 필요** |
| `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | SetChangedPeriod:542 | (BIZ) | 분기 테이블 **확인 필요** | 없음 | 진입점 미연결. 결과 컬럼 `FROM_VALUE`, `TO_VALUE` |

**메타 테이블(화면 ID가 값으로 들어 있는 행)**

| 메타 테이블 | 행 수 | 용도 |
|---|---:|---|
| `dbo.SCM_MST_SHEET_COLUMNS` | 47 | 그리드 컬럼 정의(`SetSheetHeaderColumn`) |
| `dbo.TB_FX_SearchCondition` | 46 | 조회조건 저장으로 보이나 내용은 **확인 필요** |
| `dbo.SCM_MST_TITLESET_USER` | 90 | **확인 필요** |
| `dbo.TB_FX_GroupMenuAuth` | 16 | 메뉴 권한 |
| `dbo.TB_FX_Favorite` | 12 | 즐겨찾기 |
| `dbo.TB_FX_MenuItemInfo` | 4 | 메뉴 정보 |
| `dbo.TB_FX_ProgramInfo` | 4 | 프로그램 정보 |
| `dbo.SCM_ADM_DB_SCRIPT_BACKUP` | 7 | DB 스크립트 백업 이력 |

---

## 6. Division·권한별 변형

| 항목 | 사실 | 근거 |
|---|---|---|
| 그리드 표시 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 **44개로 같습니다**. 필수+기본/선택 = 44/0 입니다. | Fact Pack §10·§12 |
| 코드 분기 | 코드 분기는 시트명 비교(`spdInfo.SheetName == "Shipment Plan Confirm Detail"`) 하나뿐입니다. division 변수를 비교하는 분기는 없습니다(판단불가 0건). | grid_code.csv |
| 사용자 division | `<field:dtMyDivision>`(48행)에서 `UserInfoContext.Current.NowGroupID` 를 읽습니다. | meta_reads.csv |
| Division 조건 | clbDivision 을 바꾸면 기간을 다시 계산합니다(R2). 기본 선택값이 사용자 division 인지는 **확인 필요**입니다. | flow.csv |
| 권한 C/R/U/D | `TB_FX_GroupMenuAuth` 에 16행이 있습니다. 그룹별 값은 미추출이므로 **확인 필요**입니다. 기능상 조회(R) 엔드포인트만 있습니다. | Fact Pack §8 |

---

## 7. 외부 인터페이스

- Fact Pack에서 외부 시스템(ERP·I/F 테이블·파일 연계) 호출은 추출되지 않았습니다.
- 그리드 컬럼 `ERP_SO_NO`(라벨 `SO No`)가 있습니다. 다만 ERP 연계 방식은 화면 기능 범위 밖이며 **확인 필요**입니다.

---

## 8. 미확정·확인 필요

| # | 항목 | 이유 |
|---:|---|---|
| 1 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 의 입력 파라미터, 동적 SQL 원천 테이블, 피벗 결과 컬럼이 메타 47컬럼과 맞는지 | SP 본문·파라미터 미추출 |
| 2 | `SCM0001_GET_SCP_DAY_PERIOD` 입력 파라미터(Division 등)와 반환 기간 규칙 | SP 본문 미추출 |
| 3 | `SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click` 동작 | 핸들러 본문 미추출 |
| 4 | `btnItemId_Click` 의 `sItemId` 출처(팝업 여부와 팝업 ID) | 341행 대입만 추출 |
| 5 | `dtFcstType`·`dtBaseDay`(LookupCommon) 코드값과 사용처 | 진입점 미연결 |
| 6 | `SetChangedPeriod` 의 현행 호출 여부와 `PERIOD_*` 분기 테이블 | 진입점 미연결, DB 보강 없음 |
| 7 | `GetCheckedListValue` 3곳(366/398/399)의 대상 컨트롤 | 줄 번호만 추출 |
| 8 | Period 필수 검증 메시지, 조회 0건 메시지 | 검증·메시지 코드 미추출 |
| 9 | 권한 메타 16행 내용 | 행 수만 추출 |
| 10 | 폼 Text `Shipment Plan Confirm` 과 클래스·시트명 `…Detail` 이 다른 데 따른 메뉴 표시명 | 메뉴 메타(`TB_FX_MenuItemInfo`) 내용 미추출 |

=== FILE: screen_design.md ===
# SSP0012 화면설계서 — Shipment Plan Confirm Detail

> **작성 근거**: AsisFacts Fact Pack(SSP0012). controls.csv, props.csv, events.csv, grid_*.csv 를 사용했습니다.
> **표기**: 사실이 없으면 **확인 필요**로 적었습니다.
> **관련 문서**: 업무분석서 §5와 엔드포인트 이름이 같고, 단위테스트 절차 열에서 §3의 컨트롤명을 그대로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0012 |
| 화면명(폼 Text) | `Shipment Plan Confirm` (Designer.cs:545) |
| 클래스 | `SSP0012_ShipmentPlanConfirmDetail` |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 4행의 내용 미추출) |
| 화면 유형 | 조회 전용(조회조건 + 단일 그리드) |
| 그리드 시트 | `Shipment Plan Confirm Detail` (1개) |
| 소스 | `SSP0012_ShipmentPlanConfirmDetail.cs`(619줄), `SSP0012_ShipmentPlanConfirmDetail.Designer.cs`(598줄) |

---

## 2. 화면 레이아웃

### 2-1. 분할 구조

- props.csv 에 **SplitContainer(Orientation·SplitterDistance)가 없습니다**. 그래서 분할 트리는 Dock 속성과 controls.csv 의 parent 체인으로 그렸습니다.

**parent 체인 (controls.csv)**

```
this (Form, Text="Shipment Plan Confirm")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192×73, UsrPanelType=HidePanel]
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Top, 1192×73, Text="usrLayoutControl2"]
│       ├─ clbPlantSite   (layoutControlItem7 "From Site", 161×29)
│       ├─ txtItemId      (lblItemId "Model", 313×29)
│       ├─ btnItemId      (layoutControlItem2, Text 없음, 43×29)
│       ├─ drpPeriod      (layoutControlItem6 "Period*", 309×29)
│       ├─ clbDivision    (lcDivision "Division", 148×29)
│       ├─ txtSoldToParty (layoutControlItem1 "Sold To Party", 356×29)
│       ├─ txtShipToParty (layoutControlItem3 "Ship To Party", 351×29)
│       └─ btnColumn      (layoutControlItem5, Text 없음, 43×29)
│       (layoutControlGroup2 1192×78 · emptySpaceItem3 464×29 · emptySpaceItem1 156×29)
├─ spdMain              [FpSpread, Dock=Fill, 1192×576]
│   └─ spdMain_Sheet1   [SheetView] → 시트 "Shipment Plan Confirm Detail"
└─ (parent 없음) usrButton1 [UsrButton, 75×23] — 배치 여부 확인 필요
   (parent 없음) imageList1 [ImageList]
```

### 2-2. 텍스트 와이어프레임 (상/하 2단, 높이 비율 = 73 : 576)

```
┌──────────────────────────────────────────────────────────────────────────────┐ ─┐
│ usrConditionPanel1 (HidePanel · 접기 가능)                  높이 73 ≈ 11.2%    │  │
│  From Site[clbPlantSite▼]  Model[txtItemId      ][btnItemId]                 │  │상
│  Period*[drpPeriod  ~  ]   Division[clbDivision▼]                            │  │
│  Sold To Party[txtSoldToParty      ]  Ship To Party[txtShipToParty     ][btnColumn] │
│  ※ 항목 높이는 모두 29. 행·열 Location 은 미추출이므로 실제 행 배치는 확인 필요         │  │
├──────────────────────────────────────────────────────────────────────────────┤ ─┤
│ spdMain (Dock Fill)                                         높이 576 ≈ 88.8%   │  │
│ ┌──────────────────────────────────────────────────────────────────────────┐ │  │하
│ │ 시트: Shipment Plan Confirm Detail  (헤더 2행, 표시 컬럼 44)                   │ │  │
│ │ ...                                                                      │ │  │
│ └──────────────────────────────────────────────────────────────────────────┘ │  │
└──────────────────────────────────────────────────────────────────────────────┘ ─┘
 폭: 상·하 모두 1192 (100%). 좌/우 분할 없음.
 버튼 영역: 표준 툴바 FindButton(조회)은 프레임워크 버튼이며 Designer 컨트롤 목록에는 없음.
 팝업 영역: btnItemId 의 팝업 여부 확인 필요.
```

- 비율 계산: 73 / (73 + 576) = 11.2%, 576 / 649 = 88.8% (props.csv Size 기준).
- `layoutControlGroup2` 높이는 78입니다. 패널 높이 73보다 큽니다. 실제 렌더링 높이는 **확인 필요**입니다.

---

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | (Text 없음) | HidePanel(펼침/접힘 초기 상태는 **확인 필요**) | - | - | 조회조건 영역(접기 가능 패널) |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (디자이너 기본 Text) | - | - | - | 조회조건 레이아웃 그리드 |
| `clbPlantSite` | UsrCheckedList | `From Site` (layoutControlItem7) | **확인 필요** (항목 출처 미추출) | `*` 없음 | - | 다중 선택 콤보(MultiSelect) |
| `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 빈값(**확인 필요**) | `*` 없음 | btnItemId_Click 결과 대입(341행) | 여러 줄 입력 |
| `btnItemId` | UsrButton | (Text 없음, layoutControlItem2) | - | - | `btnItemId_Click` | 검색 아이콘 버튼(팝업 여부 **확인 필요**) |
| `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과(Form_Load) | **필수 표시 `*`** (검증 로직 **확인 필요**) | Division 변경 시 재설정 | 날짜 범위(From~To) |
| `clbDivision` | UsrCheckedList | `Division` (lcDivision) | **확인 필요** (`NowGroupID` 관련 여부) | `*` 없음 | `clbDivision_SelectedIndexChanged` | 다중 선택 콤보 |
| `txtSoldToParty` | TextBox | `Sold To Party` (layoutControlItem1) | 빈값(**확인 필요**) | `*` 없음 | - | 텍스트 입력 |
| `txtShipToParty` | TextBox | `Ship To Party` (layoutControlItem3) | 빈값(**확인 필요**) | `*` 없음 | - | 텍스트 입력 |
| `btnColumn` | UsrButton | (Text 없음, layoutControlItem5) | - | - | `BtnColumn_Click` | 아이콘 버튼(기능 **확인 필요**) |
| `usrButton1` | UsrButton | (Text 없음) | - | - | 배선 없음 | **확인 필요** (parent 없음. 배치되지 않은 컨트롤일 수 있음) |
| `spdMain` | FpSpread | - | 시트 `Shipment Plan Confirm Detail` | - | `SpdMain_TopChange`, `SpdMain_CellClick` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | - | 런타임에 `AddSheet`/`ChangeSheet` 로 구성 | - | - | FlexGrid 시트(단일) |

- 보조 항목: `imageList1`(ImageList, 이미지 셀 관련 여부 **확인 필요**), `emptySpaceItem3`/`emptySpaceItem1`(여백).

---

## 4. 그리드 명세 — 시트 `Shipment Plan Confirm Detail`

- 생성: `CreateSpread:253` `AddSheet(spdMain, "Shipment Plan Confirm Detail", "Shipment Plan Confirm Detail", 2, 1, 30)`. 인자 2/1/30 의 의미는 **확인 필요**입니다.
- 컬럼: `InitSpread:266` `SetSheetHeaderColumn(spdInfo, 2)` 로 메타 `SCM_MST_SHEET_COLUMNS` 47행에서 만듭니다. 헤더는 **2행**이고, 상단 그룹 텍스트는 **확인 필요**입니다.
- 순서: 아래 표는 컬럼명 순입니다. 실제 메타 정렬 순서·폭·정렬·고정은 **확인 필요**입니다.
- 편집 가능 여부: 저장 엔드포인트가 없으므로 조회 전용입니다. 컬럼별 Lock 메타는 미추출이므로 각 행을 "조회 전용(확인 필요)"으로 표기했습니다.
- division별 표시: 14개 division 모두 같습니다(아래 "division" 열에 공통으로 표기).

| # | 컬럼 | 헤더(라벨) | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | A_COUNTRY | Country* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 2 | A_PORT_CODE | Port Code* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 3 | A_PORT_NAME | Port* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 4 | BIZ_TYPE_NAME | Biz Name | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 5 | BOD_ID | bod_id | 확인 필요 | META | 전 division **숨김** | - |
| 6 | CHANGE_REQ_NO | Change Request No | **Image** (`cellTypeImage`, InitSpread:271) | META(+코드 변경) | 전 division 기본 | 조회 전용(확인 필요) |
| 7 | CONFIRM_ID | Confirm ID | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 8 | CONFIRM_QTY | Confirmed Qty | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 9 | D_COUNTRY | Country* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 10 | D_PORT_CODE | Port Code* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 11 | D_PORT_NAME | Port* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 12 | DAYS_FRI | Fri | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 13 | DAYS_MON | Mon | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 14 | DAYS_SAT | Sat | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 15 | DAYS_SUN | Sun | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 16 | DAYS_THU | Thu | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 17 | DAYS_TUE | Tue | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 18 | DAYS_WED | Wed | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 19 | DIVISION_ID | Division | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 20 | ERP_SO_NO | SO No | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 21 | ETA | ETA | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 22 | ETD | ETD | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 23 | Expected_Shipping_Date | Expected Shipping Date | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 24 | FCST_TYPE | FCST Type | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 25 | FROM_SITE_DESCRIPTION | From Site | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 26 | INCOTERMS | Incoterms | **Image** (`cellTypeImage`, InitSpread:270) | META(+코드 변경) | 전 division 기본 | 조회 전용(확인 필요) |
| 27 | ITEM_ID | Model | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 28 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 29 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 30 | LT_ARRIVAL_INLAND | Arrival Inland | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 31 | LT_DAY | L/T(Day) | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 32 | LT_DEPARTURE_INLAND | Departure Inland | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 33 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 34 | LT_SUM | Total L/T | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 35 | LT_TYPE | L/T Type | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 36 | LT_VOYAGE | Voyage | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 37 | LT_WAIT_SHIPPING | Waiting For Shipping | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 38 | MTK_OWNER | MKT Owner | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 39 | NICK_NAME | Nick Name | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 40 | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | 확인 필요 | META | 전 division **숨김** | - |
| 41 | PLAN_DATE | Shipment Date(GI) | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 42 | PLAN_QTY | Planned Qty | 확인 필요 | META | 전 division **숨김** | - |
| 43 | PROJECT_NAME | Project Name | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 44 | SHIPTO_DESCRIPTION | Ship To Party | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 45 | SOLDTO_DESCRIPTION | Sold To Party | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 46 | TO_SITE_DESCRIPTION | To Site | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 47 | TRANSPORT_MODE | Trans Mode | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |

- 집계: 메타 47개 / 표시 44개 / 숨김 3개 / HARDCODED 컬럼 0개 / 코드 변경 2개(CellType)
- division: 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 모두 44/0입니다.
- `A_*` 와 `D_*` 의 라벨이 같습니다(`Country*`, `Port Code*`, `Port*`). 2행 헤더의 상단 그룹으로 두 묶음을 구분하는 것으로 보이나, 상단 그룹 텍스트는 **확인 필요**입니다.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 폼 로드 (`this.Load`, .ctor:186) | `Form_Load` | InitControls > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `drpPeriod` 기간 설정(**확인 필요**) |
| A2 | Division 변경 (`clbDivision.SelectedIndexChanged`, InitEvent:282) | `clbDivision_SelectedIndexChanged` | SetChangedControl(GetCheckedListValue CODE, 366행) > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `drpPeriod` 재설정(**확인 필요**) |
| A3 | 조회 (툴바 `FindButton`) | `FindData_Main` (프레임워크 버튼 진입) | GetCheckedListValue CODE(398·399행) 후 SP 호출(418행) | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | `spdMain` 시트 `Shipment Plan Confirm Detail` 바인딩 |
| A4 | Model 버튼 (`btnItemId.Click`, InitEvent:278) | `btnItemId_Click` | `txtItemId.Text = sItemId` (341행) | 추출된 엔드포인트 없음 | `txtItemId` 값 설정 |
| A5 | 컬럼 버튼 (`btnColumn.Click`, InitEvent:284) | `BtnColumn_Click` | **확인 필요** | 추출된 엔드포인트 없음 | **확인 필요** |
| A6 | 셀 클릭 (`spdMain.CellClick`, InitEvent:280) | `SpdMain_CellClick` | **확인 필요** | 추출된 엔드포인트 없음 | **확인 필요** |
| A7 | 스크롤 (`spdMain.TopChange`, InitEvent:277) | `SpdMain_TopChange` | **확인 필요** | 추출된 엔드포인트 없음 | **확인 필요** |
| A8 | (진입점 미연결) 필드 초기화 `dtFcstType`/`dtBaseDay` | - | 공통코드 LookupCommon 조회 | `biz:CommonData.CommonDataList` | 사용처 **확인 필요** |
| A9 | (진입점 미연결) `SetChangedPeriod` | - | PERIOD_{값} \|\| PERIOD_DEFAULT 조회 → FROM_VALUE/TO_VALUE | `biz:CommonData.CommonDataList` | 호출 여부 **확인 필요** |

- 주석 처리된 호출(595행) 1건은 현행 액션이 아니므로 위 표에서 뺐습니다.

---

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| Period 필수 | 라벨 `Period*` 에 필수 표시가 있습니다. | 검증 코드와 메시지 원문은 **확인 필요** |
| 조회 0건 메시지 | 미추출 | **확인 필요** |
| 오류 메시지 | 미추출 | **확인 필요** |
| Fact Pack §7 확인 필요 항목 | 0건 | - |

---

## 7. 권한 (C/R/U/D)

| 구분 | 사실 |
|---|---|
| C (생성) | 엔드포인트 없음 |
| R (조회) | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `biz:CommonData.CommonDataList` |
| U (수정) | 엔드포인트 없음 |
| D (삭제) | 엔드포인트 없음 |
| 권한 메타 | `TB_FX_GroupMenuAuth` 16행. 그룹별 값은 **확인 필요** |
| 사용자 정보 | `UserInfoContext.Current.NowGroupID` (48행) |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| 1 | 그리드 | FarPoint `spdMain` + `SetSheetHeaderColumn(spdInfo, 2)` | Wijmo FlexGrid + 메타 기반 컬럼 생성. 2행 헤더는 ColumnGroup 으로 구성하고, 상단 그룹 텍스트를 확인한 뒤 정합니다. |
| 2 | 이미지 셀 | `INCOTERMS`, `CHANGE_REQ_NO` = `cellTypeImage` | FlexGrid cellTemplate(아이콘) 후보. 클릭 동작은 `SpdMain_CellClick` 확인 후 정합니다. |
| 3 | 조회조건 패널 | `usrConditionPanel1` HidePanel | 접기 가능한 조회조건 영역 |
| 4 | 다중 선택 | `clbPlantSite`, `clbDivision` (UsrCheckedList, CODE) | 다중 선택 콤보. 선택 CODE 를 구분자 문자열로 전달할지 여부는 SP 파라미터 확인 후 정합니다. |
| 5 | 동적 피벗 SP | MSSQL `#TBLDYNAMICPIVOT_SSP0012` + 동적 SQL | Oracle 19c 에서는 `#` 임시 테이블이 없습니다. GTT 또는 PIVOT/동적 SQL(REF CURSOR)로 바꿔야 합니다. |
| 6 | 분해 함수 | `FN_SCM_SPLIT`, `FN_GET_IN_STR` | Oracle 대응 함수가 있는지 확인해야 합니다. MSSQL 키워드는 남기지 않습니다. |
| 7 | 기간 SP | `SCM0001_GET_SCP_DAY_PERIOD` (CTE `CTE_DATE`, 달력) | 공용 기간 조회 API로 재사용합니다. |
| 8 | 미배치 컨트롤 | `usrButton1` (parent 없음) | 배치 여부를 확인한 뒤 To-Be 포함 여부를 정합니다. |

---

## 9. 미확정

1. `SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click` 동작, `btnItemId_Click` 의 팝업 여부
2. 조회조건 실제 행·열 배치(Location 미추출), `usrConditionPanel1` 초기 펼침 상태
3. 그리드 컬럼 실제 순서·폭·정렬·고정·타입, 2행 헤더 상단 그룹 텍스트
4. `AddSheet` 인자 2/1/30 의 의미
5. `clbPlantSite`·`clbDivision` 항목 출처와 기본 선택값
6. Period 필수 검증 메시지, 조회 0건 메시지
7. `usrButton1` 배치 여부, `imageList1` 용도
8. 메뉴 위치, 권한 16행 내용

=== FILE: unit_test.md ===
# SSP0012 단위테스트 — Shipment Plan Confirm Detail

> **작성 근거**: Fact Pack(SSP0012), 업무분석서 §5, 화면설계서 §3·§5
> **기대결과 표기**: Fact Pack에 동작이 없는 경우 기대결과에 **확인 필요**를 적었습니다. AS-IS 실행 결과를 확인한 뒤 확정합니다.
> **범위**: 주석 처리된 호출은 테스트 대상이 아닙니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0012-001 | 초기화 | SSP0012 메뉴 권한이 있는 사용자로 로그인 | 1) 화면을 엽니다. 2) `drpPeriod` 값을 확인합니다. | 없음 | `Form_Load` > InitControls > GetDayRange 가 실행되고 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 가 1회 호출됩니다. `drpPeriod` 에 SP 결과 기간이 들어갑니다(값 매핑은 **확인 필요**). | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-002 | 초기화 | TC-001 수행 | 1) 화면을 엽니다. 2) `usrConditionPanel1`, `usrLayoutControl2` 안의 조회조건 라벨을 확인합니다. | 없음 | 라벨이 `From Site`, `Model`, `Period*`, `Division`, `Sold To Party`, `Ship To Party` 로 표시됩니다. `btnItemId`, `btnColumn` 버튼이 보입니다. `usrButton1` 의 표시 여부는 **확인 필요**입니다. | `Form_Load`, props.csv Text |
| TC-SSP0012-003 | 그리드 | 화면 열림 | 1) `spdMain` 의 시트 이름을 확인합니다. 2) `spdMain_Sheet1` 헤더 행 수를 확인합니다. | 없음 | 시트 `Shipment Plan Confirm Detail` 이 1개 있고 헤더는 2행입니다. | 시트 `Shipment Plan Confirm Detail`, `SetSheetHeaderColumn`(InitSpread:266) |
| TC-SSP0012-004 | 그리드 | 화면 열림 | 1) `spdMain` 의 표시 컬럼 수와 라벨을 메타와 대조합니다. | 없음 | 표시 컬럼 44개, 라벨은 화면설계서 §4와 같습니다. `BOD_ID`, `ORIGIN_FROM_DIVISION_ID`, `PLAN_QTY` 는 숨김입니다. | 시트 `Shipment Plan Confirm Detail`, `SCM_MST_SHEET_COLUMNS` 47행 |
| TC-SSP0012-005 | 그리드 | 조회 결과 1건 이상 | 1) `spdMain` 의 `INCOTERMS`, `CHANGE_REQ_NO` 셀을 확인합니다. | 조회 결과 데이터 | 두 컬럼이 이미지 셀(`cellTypeImage`)로 표시됩니다. 이미지 종류는 **확인 필요**입니다. | 시트 `Shipment Plan Confirm Detail`, InitSpread:270·271 |
| TC-SSP0012-006 | 조회 | 화면 열림. 기간 기본값이 들어 있음 | 1) `clbPlantSite`, `clbDivision` 에서 값을 선택합니다. 2) `drpPeriod` 를 확인합니다. 3) 툴바 조회(FindButton)를 누릅니다. | From Site·Division 각 1개 이상, Period 기본값 | `FindData_Main` 이 실행되고 `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 이 호출됩니다. 결과가 `spdMain` 시트 `Shipment Plan Confirm Detail` 에 표시됩니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-007 | 조회 | 화면 열림 | 1) `clbPlantSite`, `clbDivision` 에서 각각 여러 개를 선택합니다. 2) 조회(FindButton)를 누릅니다. 3) 전송 파라미터를 확인합니다. | 다중 선택 CODE | CheckedList 선택값(CODE)이 SP 파라미터로 전달됩니다(398·399행). 구분자 형식은 **확인 필요**입니다. 결과는 선택한 값으로 필터됩니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, `GetCheckedListValue` |
| TC-SSP0012-008 | 조회 | 화면 열림 | 1) `txtItemId`, `txtSoldToParty`, `txtShipToParty` 에 값을 넣습니다. 2) 조회(FindButton)를 누릅니다. | Model / Sold To Party / Ship To Party 텍스트 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 이 호출됩니다. 각 조건이 결과 필터에 반영되는지는 **확인 필요**입니다(SP 파라미터 미추출). | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| TC-SSP0012-009 | 조회 (빈 결과) | 화면 열림 | 1) 데이터가 없는 조건(예: 없는 Model)을 넣습니다. 2) 조회(FindButton)를 누릅니다. | `txtItemId` = 존재하지 않는 값 | `spdMain` 시트 `Shipment Plan Confirm Detail` 이 0행이고, 헤더 2행과 44컬럼은 유지됩니다. 안내 메시지는 **확인 필요**입니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-010 | 조회 (오류 응답) | 메인 SP가 오류를 반환하도록 환경 구성(예: SP 권한 회수, 테스트 DB) | 1) 조회(FindButton)를 누릅니다. | 정상 조건 | 오류 메시지가 표시되고 그리드에 이전 데이터나 일부 데이터가 잘못 남지 않습니다. 메시지 원문은 **확인 필요**입니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| TC-SSP0012-011 | 조회 (필수값) | 화면 열림 | 1) `drpPeriod` 값을 비웁니다. 2) 조회(FindButton)를 누릅니다. | Period 빈값 | 라벨 `Period*` 가 필수 표시입니다. 차단 여부와 메시지는 **확인 필요**입니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, props.csv:453 |
| TC-SSP0012-012 | 조회 (큰 결과) | 기간을 넓게 설정 | 1) `drpPeriod` 를 최대 범위로 설정합니다. 2) 조회를 누릅니다. | 넓은 기간 | 동적 피벗 결과가 메타 컬럼과 맞게 표시되고 요일 컬럼 `DAYS_MON`~`DAYS_SUN` 에 값이 들어갑니다(값 의미는 **확인 필요**). | SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`(#TBLDYNAMICPIVOT_SSP0012), 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-013 | 이벤트 | 화면 열림 | 1) `clbDivision` 선택을 바꿉니다. 2) `drpPeriod` 값을 확인합니다. | Division 값 변경 | `clbDivision_SelectedIndexChanged` > SetChangedControl > GetDayRange 가 실행되고 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 가 다시 호출됩니다. `drpPeriod` 가 다시 설정됩니다(값은 **확인 필요**). | `clbDivision_SelectedIndexChanged`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-014 | 이벤트 (오류 응답) | 기간 SP가 오류를 반환하도록 환경 구성 | 1) 화면을 엽니다. 2) `clbDivision` 선택을 바꿉니다. | Division 값 변경 | 오류 메시지가 표시되고 화면이 멈추지 않습니다. `drpPeriod` 처리 결과는 **확인 필요**입니다. | `Form_Load`, `clbDivision_SelectedIndexChanged`, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-015 | 이벤트 (빈 결과) | 달력 `SCM_SYS_CALENDAR_M` 에 해당 기간 데이터가 없는 테스트 환경 | 1) 화면을 엽니다. | 없음 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 가 0행을 반환할 때 `drpPeriod` 처리 결과는 **확인 필요**입니다(빈값 또는 오류 메시지). | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-016 | 이벤트 | 화면 열림 | 1) `btnItemId` 를 누릅니다. 2) 값을 고르거나 받습니다. 3) `txtItemId` 를 확인합니다. | Model 1건 이상 | `btnItemId_Click` 이 실행되고 `txtItemId.Text` 에 `sItemId` 가 들어갑니다(341행). 팝업 여부는 **확인 필요**입니다. | `btnItemId_Click` |
| TC-SSP0012-017 | 이벤트 | 화면 열림 | 1) `btnColumn` 을 누릅니다. | 없음 | `BtnColumn_Click` 이 실행됩니다. 동작(컬럼 설정 등)은 **확인 필요**입니다. | `BtnColumn_Click`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-018 | 이벤트 | 조회 결과 1건 이상 | 1) `spdMain` 의 `INCOTERMS` 셀을 클릭합니다. 2) `CHANGE_REQ_NO` 셀을 클릭합니다. 3) 일반 셀을 클릭합니다. | 조회 결과 | `SpdMain_CellClick` 이 실행됩니다. 셀별 동작은 **확인 필요**입니다. | `SpdMain_CellClick`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-019 | 이벤트 | 조회 결과가 한 화면을 넘음 | 1) `spdMain` 을 세로로 스크롤합니다. | 조회 결과 다건 | `SpdMain_TopChange` 가 실행됩니다. 동작(추가 로딩·동기화 등)은 **확인 필요**입니다. | `SpdMain_TopChange`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-020 | 초기화 (공통코드) | 화면 인스턴스 생성 | 1) 화면을 엽니다. 2) 공통코드 호출 로그를 확인합니다. | 없음 | 필드 초기화 `dtFcstType`·`dtBaseDay` 에서 `biz:CommonData.CommonDataList`(LookupCommon)를 호출하는지 확인합니다. 정적 분석상 진입점이 없으므로 실제 호출 여부와 사용처는 **확인 필요**입니다. | `biz:CommonData.CommonDataList` [LookupCommon], `UP_FX_GetCommonDataList` |
| TC-SSP0012-021 | 초기화 (공통코드) | `SetChangedPeriod` 의 호출 경로를 확인한 뒤 수행(정적 분석상 진입점 없음) | 1) `SetChangedPeriod` 가 호출되는 조작을 합니다(**확인 필요**). 2) 기간 값을 확인합니다. | PERIOD_{값}, 없으면 PERIOD_DEFAULT | `biz:CommonData.CommonDataList` 결과의 `FROM_VALUE`/`TO_VALUE` 로 기간이 정해집니다. 호출되지 않으면 이 TC는 "미사용 코드 확인"으로 종료합니다. | `biz:CommonData.CommonDataList` [PERIOD_*], `SetChangedPeriod` |
| TC-SSP0012-022 | division | division 40 사용자 | 1) 화면을 엽니다. 2) 조회합니다. 3) `spdMain` 컬럼을 확인합니다. | Division 40 | 표시 컬럼 44개(TC-004와 같음) | 시트 `Shipment Plan Confirm Detail`, grid_effective(40) |
| TC-SSP0012-023 | division | division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC) 사용자 | TC-022와 같음 | Division 81 계열 | 각각 표시 컬럼 44개이고 division 40과 같습니다. | 시트 `Shipment Plan Confirm Detail`, grid_effective(81*) |
| TC-SSP0012-024 | division | division 82 사용자 | TC-022와 같음 | Division 82 | 표시 컬럼 44개이고 division 40과 같습니다. | 시트 `Shipment Plan Confirm Detail`, grid_effective(82) |
| TC-SSP0012-025 | division | division EE 계열(EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 사용자 | TC-022와 같음 | Division EE 계열 | 각각 표시 컬럼 44개이고 division 40과 같습니다. | 시트 `Shipment Plan Confirm Detail`, grid_effective(EE*) |
| TC-SSP0012-026 | division | 로그인 사용자 `NowGroupID` 확인 | 1) 화면을 엽니다. 2) `clbDivision` 기본 선택을 확인합니다. | 사용자 division | 기본 선택이 사용자 `NowGroupID` 와 관련되는지 **확인 필요**입니다(48행 `dtMyDivision`). | `Form_Load`, `clbDivision_SelectedIndexChanged` |
| TC-SSP0012-027 | 권한 | `TB_FX_GroupMenuAuth` 에 조회 권한만 있는 그룹 사용자 | 1) 화면을 엽니다. 2) 조회합니다. 3) 툴바 버튼 상태를 확인합니다. | 권한 그룹 | 조회가 됩니다. 저장·삭제 기능이 없으므로 해당 툴바 버튼의 비활성/미표시 여부를 확인합니다(그룹별 값은 **확인 필요**). | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, `TB_FX_GroupMenuAuth` 16행 |
| TC-SSP0012-028 | 권한 | 메뉴 권한이 없는 그룹 사용자 | 1) 메뉴 목록에서 SSP0012를 찾습니다. | 권한 없음 | 메뉴가 보이지 않거나 열리지 않습니다(**확인 필요**). | `TB_FX_GroupMenuAuth`, `Form_Load` |

**커버리지 점검**

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 014, 015, 026 |
| | `SpdMain_TopChange` | 019 |
| | `btnItemId_Click` | 016 |
| | `SpdMain_CellClick` | 018 |
| | `clbDivision_SelectedIndexChanged` | 013, 014 |
| | `BtnColumn_Click` | 017 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 020, 021 |
| | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | 006~012, 027 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 001, 013, 014, 015 |
| 시트 | `Shipment Plan Confirm Detail` | 003, 004, 005, 009, 022~025 |
| 빈 결과 | | 009, 015 |
| 오류 응답 | | 010, 014 |
| division | 40 / 81 계열 / 82 / EE 계열 | 022~025 |
