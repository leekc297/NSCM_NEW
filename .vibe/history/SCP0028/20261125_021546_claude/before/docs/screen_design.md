# SCP0028 Shipment Lot Size — 화면설계서

> 근거: Fact Pack(SCP0028)의 controls.csv, props.csv, events.csv, flow.csv, grid_effective.csv, grid_code.csv. 엔드포인트와 핸들러 이름은 업무분석서 §5 및 단위테스트 근거 열과 같은 이름을 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0028 |
| 화면 명칭 | `SCP0028_Shipment_Lot_Size` (Designer.cs:724 `this.Text` 원문) |
| 클래스 | `SCP0028_Shipment_Lot_Size` |
| 도메인 / 폴더 | SCP / `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0028_Shipment_Lot_Size` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행이 있으나 내용은 Fact Pack에 없음) |
| 시트 | `Shipment Lot Size` (1개) |
| 그리드 구성 방식 | META(프레임워크) (+코드 표시/라벨 변경) |

## 2. 화면 레이아웃

### 2-1. 분할 근거
- **props.csv에 SplitContainer 행이 0건**이라 Orientation과 SplitterDistance 값이 없습니다. 영역은 `Dock` 속성으로 나뉩니다.
- parent 체인(controls.csv):
  - `this` → `usrConditionPanel1` (Dock=Top, 1093×72, UsrPanelType=HidePanel) → `usrLayoutControl2` (Dock=Fill, 1093×72) → 조회조건 컨트롤 10개(cboValid, cboDivision, btnItemId, txtItemId, cboOperationGroup, clbFromSite, clbTransMode, btnInput, btnDelete, clbToSite)
  - `this` → `spdMain` (Dock=Fill, 1093×502)
  - parent 미기재: `usrLayoutControl1` (Dock=Fill, 657×184), `layoutControlGroup1` (657×184), `layoutControlGroup2` (1093×78), `spdMain_Sheet1`, LayoutControlItem 10개, EmptySpaceItem 4개, `imageList1`
- 상/하 비율(디자인 Size 기준): 상단 72 : 하단 502, 합계 574 기준 **12.5% : 87.5%**. 좌/우 분할은 없습니다.

### 2-2. 텍스트 와이어프레임

```
SCP0028_Shipment_Lot_Size (this)   ※ SplitContainer 없음 → Dock 분할
┌────────────────────────────── 폭 1093 ──────────────────────────────┐
│ [상 12.5%] usrConditionPanel1  Dock=Top 1093×72  HidePanel(접이식)     │
│   └ usrLayoutControl2  Dock=Fill 1093×72                              │
│       (layoutControlGroup2 1093×78 · 항목 높이 29)                     │
│       Division*        [cboDivision        ]  (항목 217)               │
│       Operation Group  [cboOperationGroup  ]  (항목 228)               │
│       From Site        [clbFromSite  ☑▼    ]  (항목 241)               │
│       Trans Mode       [clbTransMode ☑▼    ]  (항목 241)               │
│       To Site          [clbToSite    ☑▼    ]  (항목 214)               │
│       Model            [txtItemId          ]  (항목 174) [btnItemId](43)│
│       Valid            [cboValid           ]  (항목 228)               │
│       [btnInput: Input](75)  [btnDelete: Delete](75)                  │
│       빈 공간 emptySpaceItem1/2/3/4 = 10/145/242/13                   │
├───────────────────────────────────────────────────────────────────────┤
│ [하 87.5%] spdMain  Dock=Fill 1093×502                                │
│   └ spdMain_Sheet1  →  시트 "Shipment Lot Size" (메타 15컬럼 표시)       │
└───────────────────────────────────────────────────────────────────────┘
(배치 미확인) usrLayoutControl1 Dock=Fill 657×184 / layoutControlGroup1 657×184
```

- 조회조건 항목의 폭 합계는 2,146(빈 공간 포함)으로 그룹 폭 1,093보다 큽니다. 따라서 한 줄에 모두 들어가지 않습니다. 실제 행·열 배치(Location)는 Fact Pack에 없으므로, 위 나열 순서는 배치 순서가 아니며 **확인 필요**입니다.
- 팝업 영역: Fact Pack에 팝업 폼 사실이 없습니다. `btnItemId_Click`이 팝업을 여는지는 **확인 필요**입니다.
- 버튼 영역: 화면 버튼 `btnInput`과 `btnDelete`는 조회조건 패널 안에 있습니다. 조회와 저장은 프레임워크 툴바의 FindButton과 SaveButton입니다.

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrLayoutControl1` | UsrLayoutControl | 없음 | – | – | – | 미사용 후보 (배치 **확인 필요**) |
| `usrConditionPanel1` | UsrConditionPanel | 없음 (UsrPanelType=HidePanel, :117) | – | – | – | 접이식 조회조건 패널 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (:138) | – | – | – | 조회조건 레이아웃 |
| `cboDivision` | UsrCombo | `Division*` (LayoutControlItem `Division`, :472) | **확인 필요** | 표시상 필수(`*`) | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | ComboBox (단일·다중 여부 **확인 필요**) |
| `cboOperationGroup` | UsrCombo | `Operation Group` (layoutControlItem1, :492) | **확인 필요** | – | – | ComboBox |
| `clbFromSite` | UsrCheckedList | `From Site` (layoutControlItem7, :504) | **확인 필요** | – | – (FromSiteByDivision 재조회 대상으로 보임, **확인 필요**) | MultiSelect ComboBox |
| `clbTransMode` | UsrCheckedList | `Trans Mode` (layoutControlItem6, :516) | **확인 필요** | – | – | MultiSelect ComboBox |
| `clbToSite` | UsrCheckedList | `To Site` (layoutControlItem4, :711) | **확인 필요** | – | – (ToSiteByDivision 재조회 대상으로 보임, **확인 필요**) | MultiSelect ComboBox |
| `txtItemId` | UsrMultiLineEditor | `Model` (layoutControlItem3, :528) | 빈값 (**확인 필요**) | – | `btnItemId_Click`이 Text 설정(:256) | 멀티라인 입력 |
| `btnItemId` | UsrButton | Text 없음 (layoutControlItem11에 Text 미설정) | – | – | Click → `btnItemId_Click` | 검색 아이콘 버튼 |
| `cboValid` | UsrComboBox | `Valid` (layoutControlItem9, :560) | **확인 필요** | – | – (DataBind `biz:CommonData.YesOrNo`, :135) | ComboBox |
| `btnInput` | UsrButton | `Input` (:401) | – | – | Click → `btnInput_Click` | Button |
| `btnDelete` | UsrButton | `Delete` (:437). 감싸는 layoutControlItem2.Text는 `layoutControlItem5`(:604) | – | – | Click → `btnDelete_Click` | Button |
| `spdMain` | FpSpread | 없음 | – | – | TopChange → `SpdMain_TopChange` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | 없음 (시트명 `Shipment Lot Size`는 AddSheet:176) | – | – | (dsdm.Changed → `spdMain_Change`, dsdm 정체는 **확인 필요**) | FlexGrid 시트 |

## 4. 그리드 명세 — 시트 `Shipment Lot Size`

- 생성: `CreateSpread:176` `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)` → `:177` `GetSheetInfo` → `:178` `ChangeSheet`.
- 컬럼 생성: `InitSpread:185` `InitSheet` → `:186` `SetSheetHeaderColumn(siMain, 1)` (메타, 헤더 1행).
- 코드 override(Designer 633~636): 컬럼헤더 스타일만 바꿉니다. `HorizontalAlignment=General`, `NoteIndicatorColor=Red`, `Parent=ColumnHeaderDefaultEnhanced`, `VerticalAlignment=General`. 하드코딩 컬럼은 0개입니다.

| # | 컬럼 | 헤더 (COLUMN_LABEL_NAME) | 타입 | 출처 | Division별 표시 (14개 전부) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | CREATED_BY | Created By | **확인 필요** | META | 기본 | **확인 필요** |
| 2 | CREATION_DATE | Creation Date | **확인 필요** | META | 기본 | **확인 필요** |
| 3 | DIVISION_ID | Division | **확인 필요** | META | 기본 | **확인 필요** |
| 4 | FROM_SITE | From Site | **확인 필요** | META | 숨김 | – |
| 5 | FROM_SITE_DESCRIPTION | From Site | **확인 필요** | META | 기본 | **확인 필요** |
| 6 | INCREMENT | Increment* | **확인 필요** | META | 기본 | **확인 필요** |
| 7 | ITEM_ID | Model | **확인 필요** | META | 기본 | **확인 필요** |
| 8 | LAST_UPDATE_DATE | Last Update Date | **확인 필요** | META | 기본 | **확인 필요** |
| 9 | LAST_UPDATED_BY | Last Updated By | **확인 필요** | META | 기본 | **확인 필요** |
| 10 | LOT_SIZE | Lot Size* | **확인 필요** | META | 기본 | **확인 필요** |
| 11 | NICK_NAME | Nick Name | **확인 필요** | META | 기본 | **확인 필요** |
| 12 | OPERATION_GROUP_ID | Operation Group | **확인 필요** | META | 기본 | **확인 필요** |
| 13 | SPLIT_YN | Container Split* | **확인 필요** | META | 기본 | **확인 필요** |
| 14 | TO_SITE | To Site | **확인 필요** | META | 숨김 | – |
| 15 | TO_SITE_DESCRIPTION | To Site | **확인 필요** | META | 기본 | **확인 필요** |
| 16 | TRANS_MODE_CODE | Trans Mode | **확인 필요** | META | 숨김 | – |
| 17 | TRANS_MODE_NAME | Trans Mode | **확인 필요** | META | 기본 | **확인 필요** |
| 18 | VALID_YN | Valid* | **확인 필요** | META | 기본 | **확인 필요** |

- 표시 15개, 숨김 3개입니다(FROM_SITE, TO_SITE, TRANS_MODE_CODE). 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다.
- `#`는 grid_effective.csv의 행 순서이며 표시 순서가 아닙니다. 표시 순서, 타입(CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE), 폭, 정렬, 고정, 대문자 적용은 `SetSheetHeaderColumn`이 메타에서 읽지만 컬럼별 값이 Fact Pack에 없습니다(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv **확인 필요**).

## 5. 액션 명세

| 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| 화면 Load | `Form_Load` | InitControls → SetChangedControl | `biz:CommonData.YesOrNo`(135), `biz:CommonData.CommonDataList` [LookupCommon](137), [FromSiteByDivision](166), [ToSiteByDivision](169) | cboValid DataBind. 나머지 바인딩 대상은 **확인 필요** |
| cboDivision 변경 | `ClbDivision_SelectedIndexChanged` | SetChangedControl (NowGroupID 사용) | `biz:CommonData.CommonDataList` [FromSiteByDivision](166), [ToSiteByDivision](169) | Site 목록 재구성 (대상 **확인 필요**) |
| btnItemId 클릭 | `btnItemId_Click` | sItemId 획득 | 없음 | `txtItemId.Text = sItemId` (:256) |
| 조회(툴바 FindButton) | FindButton (프레임워크) | FindData, GetCheckedListValue ×5 (332~336) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` (349) | 시트 `Shipment Lot Size` 바인딩 |
| btnInput 클릭 | `btnInput_Click` | GetCheckedListValue(265) → FindInput | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` (417) | 그리드 반영 방식 **확인 필요** |
| 저장(툴바 SaveButton) | SaveButton (프레임워크) | SaveData → FindData | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` (659) → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` (349) | 저장 후 재조회 |
| btnDelete 클릭 | `btnDelete_Click` | GetCheckedListValue(293) → FindDelete → FindData | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` (511) → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` (349) | 삭제 후 재조회 (구분값 **확인 필요**) |
| spdMain 스크롤 | `SpdMain_TopChange` | **확인 필요** | 없음 | **확인 필요** |
| 그리드 데이터 변경 (dsdm.Changed) | `spdMain_Change` | **확인 필요** | 없음 | **확인 필요** |

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| Division 필수 표시 | 라벨 `Division*`. 검증 코드는 **확인 필요** |
| 그리드 필수 표시 | `Increment*`, `Lot Size*`, `Container Split*`, `Valid*` (메타 라벨 원문). 검증 로직은 **확인 필요** |
| 저장·삭제 확인 메시지, 오류 메시지 문구 | Fact Pack에 없음 → **확인 필요** |

## 7. 권한 (C/R/U/D) 사실

| 사실 | 출처 |
|---|---|
| `TB_FX_GroupMenuAuth` 13행 | DB 메타 §8 (플래그 값 **확인 필요**) |
| `TB_FX_MenuItemInfo` 1행 · `TB_FX_ProgramInfo` 1행 · `TB_FX_Favorite` 10행 · `TB_FX_SearchCondition` 54행 | DB 메타 §8 |
| Site 목록을 `TB_FX_USERGROUPAUTHEXTENTION`과 `NowGroupID`로 그룹별 제한 | Fact Pack §3, meta_reads.csv |
| 프레임워크 FindButton(R), SaveButton(C/U) 사용. `EditButton` 메서드 있음(231) | flow.csv, grid_code.csv |
| btnInput과 btnDelete(D)가 권한과 연동되는지 | **확인 필요** |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 항목 | AS-IS | To-Be 고려 |
|---|---|---|
| 그리드 | FarPoint FpSpread, 메타 `SetSheetHeaderColumn` | Wijmo FlexGrid와 메타 컬럼 정의(SCM_MST_SHEET_COLUMNS 18행) 연계. 숨김 3컬럼 유지 |
| 헤더 스타일 override | Designer 633~636 | 공통 그리드 기본 스타일로 대체할지 **확인 필요** |
| 조회조건 패널 | UsrConditionPanel HidePanel | 접이식 조회조건 영역 |
| 체크 리스트 | UsrCheckedList 3개, GetCheckedListValue(CODE) | 멀티 선택 콤보. 전송 형식(구분자 문자열 등)은 **확인 필요** |
| SP 문자열 분해 | `STRING_SPLIT`, `UF_FX_STRING_SPLIT`, `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL` | Oracle 19c에는 STRING_SPLIT이 없으므로 대체 분해 로직이 필요합니다 |
| 임시테이블 | `#TBLDYNAMIC_SCP0028IN_*` 6종 | Oracle에서는 GTT 등으로 전환하고, 세션 간 잔존 데이터 처리가 필요합니다 |
| MERGE/DELETE | `SCP_MST_SHIPMENT_LOT_SIZE` | Oracle MERGE로 전환. 삭제 구분값을 어떻게 받을지 **확인 필요** |
| 라벨 | `Valid`, `*` 표기 | (프로젝트 TO-BE 룰, Fact Pack 외) SCP 라벨 Valid→Active 일괄(CR-092), 필수 `*` 생략 허용(CR-077) |

## 9. 미확정

1. 조회조건 항목의 행·열 배치(Location), `usrLayoutControl1`과 `layoutControlGroup1`의 용도
2. 컨트롤 초기값과 cboDivision, cboOperationGroup의 데이터 소스
3. LookupCommon, FromSite, ToSite 결과의 바인딩 대상
4. 그리드 컬럼의 표시 순서, 셀 타입, 편집 가능 여부
5. `SpdMain_TopChange`, `spdMain_Change`(dsdm), `EditButton`의 동작
6. Input 결과 반영 방식과 Delete 구분값
7. 검증 로직과 메시지 문구, C/R/U/D 플래그
8. 메뉴 위치
