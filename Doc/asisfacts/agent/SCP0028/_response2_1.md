=== FILE: business_analysis.md ===
# SCP0028 Shipment Lot Size — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0028)과 1차 분석서(analysis.md, web_components.md, tobe_design.md). Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls.csv)은 0건입니다. 이 문서의 기능은 모두 활성 호출만 근거로 합니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SCP0028 / `SCP0028_Shipment_Lot_Size` | Designer.cs:724 `this.Text` |
| 소속 | SCP 도메인, `Master` 폴더에 있는 화면 | 프로젝트 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\…` |
| 관리 대상 | 출하 Lot Size 마스터 `SCP_MST_SHIPMENT_LOT_SIZE`. 저장 SP가 이 테이블을 MERGE하고 DELETE함 | endpoints.csv 511·659 objects |
| 관리 항목(그리드 메타 라벨) | Division, Operation Group, From Site, To Site, Trans Mode, Model, Nick Name, Lot Size*, Increment*, Container Split*, Valid*, Created By, Creation Date, Last Updated By, Last Update Date | grid_effective.csv |
| 업무 범위 | ① 조회 ② Input(입력 대상 후보 조회) ③ 저장 ④ 삭제 ⑤ Division에 따른 Site 목록 재구성 ⑥ Model 지정 | flow.csv |
| 업무 목적 서술 | Fact Pack에는 업무 목적 문장이 없습니다. "출하 Lot Size 기준정보 관리"는 테이블과 컬럼 이름에서 읽은 범위입니다. 실제 업무 정의는 **확인 필요**입니다 | – |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` > `InitControls`가 `biz:CommonData.YesOrNo`(135)와 `biz:CommonData.CommonDataList` [code=LookupCommon](137)를 호출합니다. 이어서 `SetChangedControl`이 `biz:CommonData.CommonDataList` [code=FromSiteByDivision](166)와 [code=ToSiteByDivision](169)를 호출합니다 | Valid 콤보는 YesOrNo 목록으로 채워집니다(DataBind 135). LookupCommon, FromSite, ToSite 결과가 바인딩되는 컨트롤은 **확인 필요**입니다 |
| S2 | Division 변경 | `ClbDivision_SelectedIndexChanged` > `SetChangedControl`이 FromSiteByDivision(166)과 ToSiteByDivision(169)를 다시 호출합니다. 이때 `UserInfoContext.Current.NowGroupID`를 읽습니다 | Division과 사용자 그룹 기준으로 Site 목록이 다시 구성됩니다(바인딩 대상은 **확인 필요**) |
| S3 | Model 버튼 클릭 | `btnItemId_Click` 실행 | `txtItemId.Text = sItemId`가 설정됩니다(256). 팝업 호출 여부는 **확인 필요**입니다 |
| S4 | 조회(프레임워크 FindButton) | `FindButton` > `FindData`(349)가 `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE`를 호출합니다. 조회조건은 `GetCheckedListValue`를 5회 호출해 구성합니다(332~336) | 시트 `Shipment Lot Size`에 결과가 표시됩니다 |
| S5 | Input 버튼 클릭 | `btnInput_Click`(`GetCheckedListValue` 265) > `FindInput`(417)이 `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT`을 호출합니다 | 입력 후보 데이터가 조회됩니다. 그리드에 반영하는 방식(행 추가 또는 대체)은 **확인 필요**입니다 |
| S6 | 저장(프레임워크 SaveButton) | `SaveButton` > `SaveData`(659)가 `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE`를 호출한 뒤 `FindData`(349)로 다시 조회합니다 | `SCP_MST_SHIPMENT_LOT_SIZE`가 MERGE되고 이력과 로그가 기록됩니다. 화면은 다시 조회됩니다 |
| S7 | Delete 버튼 클릭 | `btnDelete_Click`(`GetCheckedListValue` 293) > `FindDelete`(511)가 `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE`를 호출한 뒤 `FindData`(349)로 다시 조회합니다 | 저장 SP가 DELETE 경로로 처리되는 것으로 보입니다. 넘기는 삭제 구분값은 **확인 필요**입니다 |
| S8 | 그리드 셀 편집 | `dsdm.Changed` → `spdMain_Change` | 본문 동작은 **확인 필요**입니다. 엔드포인트 호출은 없습니다 |
| S9 | 그리드 스크롤 | `spdMain.TopChange` → `SpdMain_TopChange` | 본문 동작은 **확인 필요**입니다. 엔드포인트 호출은 없습니다 |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (Form_Load)
     ├─ InitControls:135  biz:CommonData.YesOrNo                      → cboValid DataBind
     ├─ InitControls:137  biz:CommonData.CommonDataList [LookupCommon] → 바인딩 대상 확인 필요
     └─ InitControls > SetChangedControl
           ├─ :166 biz:CommonData.CommonDataList [FromSiteByDivision] (NowGroupID)
           └─ :169 biz:CommonData.CommonDataList [ToSiteByDivision]   (NowGroupID)
[2] 조회조건 설정
     ├─ Division 변경 → ClbDivision_SelectedIndexChanged → SetChangedControl(:166, :169) 재호출
     └─ Model 버튼   → btnItemId_Click → txtItemId.Text 설정(:256)
[3] 조회   FindButton > FindData:349 → SCP.SCP0028_GET_SHIPMENT_LOT_SIZE → 시트 "Shipment Lot Size"
[4] 입력   btnInput_Click > FindInput:417 → SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT → 그리드 반영(방식 확인 필요)
[5] 편집   그리드 편집 (spdMain_Change — 본문 확인 필요)
[6] 저장   SaveButton > SaveData:659 → SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE → FindData:349 재조회
[7] 삭제   btnDelete_Click > FindDelete:511 → SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE → FindData:349 재조회
```

## 4. 업무 규칙

### 4-1. SP 처리 규칙 (참조 객체로 확인되는 사실)

| SP | 확인된 처리 | 분기 조건 |
|---|---|---|
| `SCP0028_GET_SHIPMENT_LOT_SIZE` | `SCP_MST_SHIPMENT_LOT_SIZE`, `SCM_MST_FINAL_ITEM_V`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SCM_MST_SITE`를 SELECT합니다. `FN_GET_SCM_SITE_DESCRIPTION`과 `STRING_SPLIT`을 참조합니다 | Fact Pack에 SP 본문 분기가 없어 **확인 필요**입니다 |
| `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | 임시테이블 `#TBLDYNAMIC_SCP0028IN_DIV`, `_OPER`, `_FROM`, `_TO`, `_ITEM`, `_INPUT`에 INSERT하고 SELECT합니다. `UF_FX_STRING_SPLIT`, `FN_GET_LOOKUP_CODE_DESC`, `FN_GET_SCM_SITE_DESCRIPTION`을 참조합니다. `SCM_MST_FINAL_ITEM_V`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SCP_MST_BOD`, `SCM_MST_SITE`를 SELECT합니다. `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 실행하고 `SCM_SYS_LOG_BATCH`에 INSERT합니다 | 임시테이블 이름(DIV, OPER, FROM, TO, ITEM)으로 보아 조건 5종을 분해하는 것으로 보입니다. 정확한 조건과 `SCP_MST_BOD` 결합 규칙은 **확인 필요**입니다 |
| `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `SCM_ARR_SPL_CNT`와 `SCM_ARR_SPL_VAL`을 참조합니다(배열 분해). `SCP_MST_SHIPMENT_LOT_SIZE`를 MERGE하고 DELETE합니다. `PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST`를 실행하고 `SCP_MST_SHIPMENT_LOT_SIZE_H`에 INSERT합니다. `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 실행하고 `SCM_SYS_LOG_BATCH`에 INSERT합니다 | MERGE와 DELETE가 갈리는 조건, 그리고 `FindDelete`(511)와 `SaveData`(659)가 넘기는 구분값은 **확인 필요**입니다 |

### 4-2. 필수값·검증

| 대상 | 사실 | 판단 |
|---|---|---|
| 조회조건 Division | LayoutControlItem `Division`.Text = `Division*` (Designer:472) | 화면에 필수 표시(`*`)가 있습니다. 검증 코드가 실제로 있는지는 **확인 필요**입니다 |
| 그리드 `Lot Size*`, `Increment*`, `Container Split*`, `Valid*` | 메타 COLUMN_LABEL_NAME 원문에 `*`가 있습니다 | 필수 입력을 검증하는 로직은 Fact Pack에 없어 **확인 필요**입니다 |
| 저장 전 검증 / 메시지 | Fact Pack에 없음 | **확인 필요** |

### 4-3. 날짜·버킷 규칙
- Fact Pack에 날짜나 버킷 관련 조건, 파라미터, 함수가 없습니다. 이 화면에 적용되는 날짜·버킷 규칙은 **없음(사실 미발견)**입니다.
- 그리드의 `Creation Date`와 `Last Update Date`는 감사 컬럼 라벨입니다.

### 4-4. 조회조건 구성 규칙
- `FindData`는 332, 333, 334, 335, 336줄에서 `CString.GetCheckedListValue`(CODE)를 5회 호출합니다. 각 호출이 어느 컨트롤의 값을 꺼내는지는 **확인 필요**입니다.
- `btnInput_Click`(265), `btnDelete_Click`(293), `SetChangedControl`(160)도 `GetCheckedListValue`를 호출합니다.

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 위치 | SP | 읽기 | 쓰기 |
|---|---|---|---|---|
| `biz:CommonData.YesOrNo` | InitControls:135 (`<field:dtYesOrNo>`:46 미연결) | – (DB 보강 없음) | – | – |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | InitControls:137 (`<field:dtTransMode>`:44 미연결) | 코드분기 UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | – |
| `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | SetChangedControl:166 | 코드분기 UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (REF STRING_SPLIT) | – |
| `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | SetChangedControl:169 | 코드분기 UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (REF STRING_SPLIT) | – |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | FindData:349 | `SCP0028_GET_SHIPMENT_LOT_SIZE` | SCP_MST_SHIPMENT_LOT_SIZE, SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE (REF FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT) | – |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | FindInput:417 | `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD, SCM_MST_SITE, #TBLDYNAMIC_SCP0028IN_* (REF UF_FX_STRING_SPLIT, FN_GET_LOOKUP_CODE_DESC, FN_GET_SCM_SITE_DESCRIPTION) | #TBLDYNAMIC_SCP0028IN_DIV/OPER/FROM/TO/ITEM/INPUT, SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN) |
| `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | SaveData:659, FindDelete:511 | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | (REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL) | MERGE·DELETE SCP_MST_SHIPMENT_LOT_SIZE, INSERT SCP_MST_SHIPMENT_LOT_SIZE_H (EXEC PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST), INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN) |

- `UP_FX_GetCommonDataList`와 `UP_FX_GetCommonDataList_SCP` 중 어느 분기가 실행되는지는 **확인 필요**입니다.

## 6. Division·권한별 변형

| 구분 | 사실 |
|---|---|
| 그리드 Division 변형 | 시트 `Shipment Lot Size`는 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 표시 15개(15/0)로 같습니다. 코드의 division 분기는 0건입니다 |
| 조회조건 Division 변형 | Division을 바꾸면 FromSiteByDivision과 ToSiteByDivision이 다시 호출되어 Site 목록이 Division에 종속됩니다 |
| 사용자 그룹 제한 | Site 목록은 `UserInfoContext.Current.NowGroupID`(meta_reads 166/169)와 `TB_FX_USERGROUPAUTHEXTENTION`(코드분기 SP SELECT)으로 제한됩니다 |
| 메뉴 권한 | `TB_FX_GroupMenuAuth` 13행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행이 있습니다. 그룹별 C/R/U/D 플래그 값은 **확인 필요**입니다 |

## 7. 외부 인터페이스
- Fact Pack에 외부 시스템(I/F) 호출 사실이 없습니다.
- 내부 로그로 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`에서 `SCM_SYS_LOG_BATCH`에 기록합니다(Input SP, 저장 SP). 이는 외부 인터페이스가 아닌 내부 실행 로그입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---|---|---|
| 1 | `FindDelete`(511)가 `SCP0028_SAVE_SHIPMENT_LOT_SIZE`에 넘기는 삭제 구분값과, SP 안의 MERGE/DELETE 분기 조건 | endpoints.csv 511 |
| 2 | Input 결과를 그리드에 반영하는 방식 | flow.csv 417 |
| 3 | `FindData` 332~336의 `GetCheckedListValue` 5회가 각각 꺼내는 컨트롤 | Fact Pack §4-2 |
| 4 | LookupCommon(137), FromSite(166), ToSite(169) 결과의 바인딩 대상 컨트롤, 그리고 `cboDivision`과 `cboOperationGroup`의 데이터 소스 | endpoints.csv |
| 5 | `<field:dtTransMode>`(44)와 `<field:dtYesOrNo>`(46)가 진입점 미연결로 분류된 이유 | flow.csv unreached |
| 6 | `SaveButton:207`을 `PersonalSettingPopup.SaveData`로 해석한 정적 분석이 화면 `SaveData`(659)와 섞였을 가능성 | Fact Pack §4-2 |
| 7 | 필수(`*`) 검증 로직, 저장 전 검증, 메시지 문구 | 사실 없음 |
| 8 | `spdMain_Change`, `SpdMain_TopChange`, `EditButton`(231)의 동작 | events.csv, grid_code.csv |
| 9 | 업무 목적 정의, 메뉴 위치 | 사실 없음 |
| 10 | `UP_FX_GetCommonDataList`와 `_SCP` 중 실행되는 분기 | Fact Pack §3 DB 보강 |

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# SCP0028 Shipment Lot Size — 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 메시지 문구와 SP 분기 조건은 Fact Pack에 없으므로, 해당 기대결과는 "AS-IS 실행 결과와 대조"로 적었습니다(**확인 필요**).
> 주석 처리된 호출은 0건이며 테스트 대상에 넣지 않았습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0028-001 | 초기화 | 로그인 상태, 화면 권한 있음 | 메뉴에서 SCP0028 열기 | – | `Form_Load` 실행. `cboValid`에 YesOrNo 목록 바인딩 | `Form_Load` · `biz:CommonData.YesOrNo` (InitControls:135) |
| TC-SCP0028-002 | 초기화 | TC-001과 같음 | 화면 열린 직후 LookupCommon 목록 확인 | – | LookupCommon 목록이 조회됨(바인딩 컨트롤 **확인 필요**, `clbTransMode` 후보) | `Form_Load` · `biz:CommonData.CommonDataList` [code=LookupCommon] (InitControls:137) |
| TC-SCP0028-003 | 초기화 | TC-001과 같음 | 화면 열린 직후 `clbFromSite`, `clbToSite` 목록 확인 | 기본 Division | FromSite와 ToSite 목록이 사용자 그룹(NowGroupID) 기준으로 조회됨 | `Form_Load` · `biz:CommonData.CommonDataList` [code=FromSiteByDivision]·[code=ToSiteByDivision] (SetChangedControl:166/169) |
| TC-SCP0028-004 | 초기화 | TC-001과 같음 | 레이아웃 확인: `usrConditionPanel1` 상단, `usrLayoutControl2` 안의 조회조건, `spdMain` 하단 | – | 상단 조회조건(72)과 하단 그리드(502)가 12.5%:87.5%로 배치됨. 라벨은 `Division*`, `Operation Group`, `From Site`, `Trans Mode`, `To Site`, `Model`, `Valid`. 버튼은 `Input`, `Delete` | `Form_Load` · 시트 `Shipment Lot Size` |
| TC-SCP0028-005 | division | 화면 열림 | `cboDivision`을 다른 Division으로 변경 | Division A → B | `ClbDivision_SelectedIndexChanged` 실행. FromSite와 ToSite 목록이 Division B 기준으로 다시 구성됨 | `ClbDivision_SelectedIndexChanged` · `biz:CommonData.CommonDataList` [code=FromSiteByDivision]·[code=ToSiteByDivision] |
| TC-SCP0028-006 | 권한 | 사용자 그룹이 다른 계정 2개 | 각 계정으로 같은 Division을 선택하고 `clbFromSite`, `clbToSite` 목록 비교 | 그룹 G1, G2 | 목록이 `TB_FX_USERGROUPAUTHEXTENTION`과 NowGroupID 기준으로 그룹별 제한됨 (AS-IS 결과와 대조) | `ClbDivision_SelectedIndexChanged` · `biz:CommonData.CommonDataList` [code=FromSiteByDivision]·[code=ToSiteByDivision] |
| TC-SCP0028-007 | 이벤트 | 화면 열림 | `btnItemId` 클릭 후 Model 선택 | Model 값 | `btnItemId_Click` 실행. `txtItemId.Text`에 선택값(sItemId) 설정 | `btnItemId_Click` (:256) |
| TC-SCP0028-008 | 조회 | 데이터가 있는 조건 | `cboDivision`, `cboOperationGroup`, `clbFromSite`, `clbTransMode`, `clbToSite`, `txtItemId`, `cboValid` 설정 후 툴바 조회 | 유효 조건 | 시트 `Shipment Lot Size`에 결과 행이 표시됨. 행 값이 AS-IS와 일치 | FindButton > FindData · `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` · `SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-009 | 조회 | 데이터가 없는 조건 | 결과가 없는 조건으로 툴바 조회 | 존재하지 않는 Model | 시트 `Shipment Lot Size`가 0행. 오류 없음(빈 결과 안내 문구는 **확인 필요**) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` · `SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-010 | 조회 | – | 필수 표시가 있는 `cboDivision`을 비우고 조회 | Division 미선택 | AS-IS 동작(검증 메시지 또는 조회)과 같음 (검증 로직 **확인 필요**) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-011 | 그리드 | TC-008 조회 완료 | 시트 컬럼 헤더 확인 | – | 표시 15개: Created By, Creation Date, Division, From Site, Increment*, Model, Last Update Date, Last Updated By, Lot Size*, Nick Name, Operation Group, Container Split*, To Site, Trans Mode, Valid*. 숨김 3개: FROM_SITE, TO_SITE, TRANS_MODE_CODE | 시트 `Shipment Lot Size` · SetSheetHeaderColumn (InitSpread:186) |
| TC-SCP0028-012 | division | 14개 division 시험 계정 | 각 division으로 조회한 뒤 표시 컬럼 수 확인 | 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | 모든 division에서 표시 15개, 숨김 3개로 같음 | 시트 `Shipment Lot Size` · grid_effective.csv |
| TC-SCP0028-013 | 이벤트 | 조회 결과 행이 화면보다 많음 | `spdMain` 세로 스크롤 | – | `SpdMain_TopChange` 실행. 동작 결과가 AS-IS와 같음 (본문 **확인 필요**) | `SpdMain_TopChange` · 시트 `Shipment Lot Size` |
| TC-SCP0028-014 | 이벤트 | 조회 완료 | 그리드에서 `Lot Size*` 셀 값 변경 | Lot Size 변경값 | `spdMain_Change`(dsdm.Changed) 실행. 행 상태와 표시가 AS-IS와 같음 (본문 **확인 필요**) | `spdMain_Change` · 시트 `Shipment Lot Size` |
| TC-SCP0028-015 | 조회 | 입력 후보가 있는 조건 | 조회조건 설정 후 `btnInput` 클릭 | 유효 조건 | `btnInput_Click` 실행. 입력 후보 데이터가 조회되어 그리드에 반영됨(반영 방식은 AS-IS와 대조) | `btnInput_Click` · `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` · `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| TC-SCP0028-016 | 조회 | 입력 후보가 없는 조건 | `btnInput` 클릭 | 결과 없는 조건 | 0건 처리. 오류 없음 (안내 문구 **확인 필요**) | `btnInput_Click` · `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| TC-SCP0028-017 | 저장 | TC-014에서 셀 편집 | 툴바 저장 | 변경 행 1건 | `SCP_MST_SHIPMENT_LOT_SIZE` MERGE 반영. `SCP_MST_SHIPMENT_LOT_SIZE_H` 이력과 `SCM_SYS_LOG_BATCH` 로그 INSERT. 이후 재조회 결과에 변경값 표시 | SaveButton > SaveData · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-018 | 저장 | TC-015 Input 결과 반영 | 신규 행의 `Lot Size*`, `Increment*`, `Container Split*`, `Valid*` 입력 후 저장 | 신규 행 | 신규 행이 MERGE로 등록되고 재조회 시 표시됨 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` · 시트 `Shipment Lot Size` |
| TC-SCP0028-019 | 저장 | 조회 완료 | 필수 표시 컬럼(`Lot Size*`)을 비우고 저장 | 빈값 | AS-IS 동작(검증 메시지 또는 SP 오류 응답)과 같음. 오류이면 데이터가 변경되지 않음 (검증·메시지 **확인 필요**) | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-020 | 저장 | 변경 행 없음 | 툴바 저장 | – | AS-IS 동작과 같음 (메시지 **확인 필요**) | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-021 | 저장 | 조회 완료 | 행을 선택하고 `btnDelete` 클릭 | 대상 행 1건 | `btnDelete_Click` 실행. `SCP_MST_SHIPMENT_LOT_SIZE`에서 DELETE되고 이력·로그 기록. 재조회 결과에서 해당 행이 없음 (삭제 구분값 **확인 필요**) | `btnDelete_Click` · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-022 | 저장 | 조회 결과 0행 또는 선택 없음 | `btnDelete` 클릭 | – | AS-IS 동작과 같음. 데이터 변경 없음 (메시지 **확인 필요**) | `btnDelete_Click` · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-023 | 저장 | DB 오류를 유발하는 조건(예: SP 실행 실패) | 툴바 저장 | 오류 유발 데이터 | 오류 응답이 표시되고 `SCP_MST_SHIPMENT_LOT_SIZE` 변경 없음 (오류 문구 **확인 필요**) | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-024 | 권한 | 그룹별 `TB_FX_GroupMenuAuth` 권한이 다른 계정 | 조회, 저장, `btnInput`, `btnDelete` 사용 가능 여부 확인 | 권한 계정별 | AS-IS 권한 플래그와 같음 (C/R/U/D 값 **확인 필요**) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `btnInput_Click` · `btnDelete_Click` |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001~004 |
| | `btnInput_Click` | 015, 016 |
| | `btnDelete_Click` | 021, 022 |
| | `SpdMain_TopChange` | 013 |
| | `spdMain_Change` | 014 |
| | `ClbDivision_SelectedIndexChanged` | 005, 006 |
| | `btnItemId_Click` | 007 |
| 엔드포인트 | `biz:CommonData.YesOrNo` | 001 |
| | `biz:CommonData.CommonDataList` | 002, 003, 005, 006 |
| | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | 008~010, 017, 021 |
| | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | 015, 016 |
| | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | 017~023 |
| 시트 | `Shipment Lot Size` | 004, 011~014, 018 |
| 빈 결과 / 오류 | – | 009, 016, 019, 020, 022, 023 |
